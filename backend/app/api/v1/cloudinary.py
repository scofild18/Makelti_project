from fastapi import APIRouter, Depends, HTTPException, UploadFile, File
from sqlalchemy.orm import Session
import cloudinary
import cloudinary.uploader
from app.database import get_db
from app.utils.verify_supabase_jwt import get_token_payload
from app.config import settings

router = APIRouter()

# Configure Cloudinary
cloudinary.config(
    cloud_name=settings.CLOUDINARY_CLOUD_NAME,
    api_key=settings.CLOUDINARY_API_KEY,
    api_secret=settings.CLOUDINARY_API_SECRET,
    secure=True
)

@router.post("/upload/profile-picture")
async def upload_profile_picture(
    file: UploadFile = File(...),
    db: Session = Depends(get_db),
    token_payload: dict = Depends(get_token_payload)
):
    """
    Upload profile picture to Cloudinary using signed upload
    """
    user_id = token_payload["sub"]
    
    print(f"\n🔐 ========== SIGNED UPLOAD REQUEST ==========")
    print(f"👤 User ID: {user_id}")
    print(f"📁 File: {file.filename}")
    print(f"📦 Content Type: {file.content_type}")
    
    # Validate file type
    if not file.content_type or not file.content_type.startswith("image/"):
        print(f"❌ Invalid file type: {file.content_type}")
        raise HTTPException(status_code=400, detail="File must be an image")
    
    # Read file contents
    contents = await file.read()
    file_size = len(contents)
    print(f"📏 File size: {file_size} bytes ({file_size / 1024 / 1024:.2f} MB)")
    
    # Validate file size (max 10MB)
    max_size = 10 * 1024 * 1024
    if file_size > max_size:
        print(f"❌ File too large: {file_size} bytes")
        raise HTTPException(
            status_code=400, 
            detail=f"File too large (max {max_size / 1024 / 1024}MB)"
        )
    
    try:
        print("☁️ Uploading to Cloudinary...")
        
        # ✅ FIXED: Use eager transformation instead of transformation parameter
        result = cloudinary.uploader.upload(
            contents,
            folder="makelti/profiles",
            public_id=f"profile_{user_id}",
            overwrite=True,
            invalidate=True,
            # ✅ Use eager transformation - generates optimized version on upload
            eager=[
                {
                    "width": 400,
                    "height": 400,
                    "crop": "fill",
                    "gravity": "face",
                    "quality": "auto",
                    "fetch_format": "auto"
                }
            ],
            eager_async=False,  # Wait for transformation to complete
        )
        
        print("✅ Cloudinary upload successful!")
        print(f"   🆔 Public ID: {result['public_id']}")
        print(f"   🔗 Secure URL: {result['secure_url']}")
        print(f"   📐 Dimensions: {result['width']}x{result['height']}")
        print(f"   📦 Format: {result['format']}")
        print(f"   🔢 Version: {result['version']}")
        
        # Check if eager transformation was generated
        if 'eager' in result and len(result['eager']) > 0:
            print(f"   ✨ Optimized URL: {result['eager'][0]['secure_url']}")
        
        print(f"🔐 ========== SIGNED UPLOAD SUCCESS ==========\n")
        
        return {
            "public_id": result["public_id"],
            "version": result["version"],
            "secure_url": result["secure_url"],
            "width": result["width"],
            "height": result["height"],
            "format": result["format"],
        }
        
    except Exception as e:
        print(f"❌ Cloudinary upload failed: {str(e)}")
        print(f"🔐 ========== SIGNED UPLOAD FAILED ==========\n")
        raise HTTPException(status_code=500, detail=f"Upload failed: {str(e)}")


@router.post("/upload/meal-image")
async def upload_meal_image(
    file: UploadFile = File(...),
    db: Session = Depends(get_db),
    token_payload: dict = Depends(get_token_payload)
):
    """
    Upload meal image to Cloudinary
    """
    user_id = token_payload["sub"]
    
    # Validate file type
    if not file.content_type or not file.content_type.startswith("image/"):
        raise HTTPException(status_code=400, detail="File must be an image")
    
    # Read file contents
    contents = await file.read()
    file_size = len(contents)
    
    # Validate file size (max 10MB)
    if file_size > 10 * 1024 * 1024:
        raise HTTPException(status_code=400, detail="File too large (max 10MB)")
    
    try:
        # Upload to Cloudinary
        result = cloudinary.uploader.upload(
            contents,
            folder="makelti/meals",
            overwrite=False,
            eager=[
                {
                    "width": 800,
                    "height": 800,
                    "crop": "fill",
                    "quality": "auto",
                    "fetch_format": "auto"
                }
            ],
            eager_async=False,
        )
        
        return {
            "public_id": result["public_id"],
            "version": result["version"],
            "secure_url": result["secure_url"],
            "width": result["width"],
            "height": result["height"],
            "format": result["format"],
        }
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Upload failed: {str(e)}")