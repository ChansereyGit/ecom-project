import React, { useState } from 'react';
import Icon from '../../../components/AppIcon';
import Button from '../../../components/ui/Button';
import Input from '../../../components/ui/Input';

const ImageUrlInput = ({ images = [], onChange, label = "Images" }) => {
  const [newImageUrl, setNewImageUrl] = useState('');
  const [previewError, setPreviewError] = useState({});

  const handleAddImage = () => {
    if (!newImageUrl.trim()) return;
    
    // Basic URL validation
    try {
      new URL(newImageUrl);
      onChange([...images, newImageUrl.trim()]);
      setNewImageUrl('');
    } catch (error) {
      alert('Please enter a valid URL');
    }
  };

  const handleRemoveImage = (index) => {
    const newImages = images.filter((_, i) => i !== index);
    onChange(newImages);
  };

  const handleImageError = (index) => {
    setPreviewError(prev => ({ ...prev, [index]: true }));
  };

  const handleImageLoad = (index) => {
    setPreviewError(prev => ({ ...prev, [index]: false }));
  };

  return (
    <div className="space-y-4">
      <label className="block text-sm font-medium text-foreground">{label}</label>
      
      {/* Add Image URL */}
      <div className="flex gap-2">
        <Input
          type="url"
          value={newImageUrl}
          onChange={(e) => setNewImageUrl(e.target.value)}
          placeholder="https://images.unsplash.com/photo-..."
          onKeyPress={(e) => e.key === 'Enter' && (e.preventDefault(), handleAddImage())}
        />
        <Button
          type="button"
          variant="outline"
          onClick={handleAddImage}
          iconName="Plus"
        >
          Add
        </Button>
      </div>

      {/* Image Previews */}
      {images.length > 0 && (
        <div className="grid grid-cols-2 md:grid-cols-3 gap-4">
          {images.map((url, index) => (
            <div key={index} className="relative group">
              <div className="aspect-video bg-muted rounded-lg overflow-hidden border border-border">
                {previewError[index] ? (
                  <div className="w-full h-full flex items-center justify-center">
                    <div className="text-center p-4">
                      <Icon name="ImageOff" size={32} className="text-muted-foreground mx-auto mb-2" />
                      <p className="text-xs text-muted-foreground">Failed to load</p>
                    </div>
                  </div>
                ) : (
                  <img
                    src={url}
                    alt={`Preview ${index + 1}`}
                    className="w-full h-full object-cover"
                    onError={() => handleImageError(index)}
                    onLoad={() => handleImageLoad(index)}
                  />
                )}
              </div>
              
              {/* Remove Button */}
              <button
                type="button"
                onClick={() => handleRemoveImage(index)}
                className="absolute top-2 right-2 bg-error text-white rounded-full p-1.5 opacity-0 group-hover:opacity-100 transition-opacity"
                title="Remove image"
              >
                <Icon name="X" size={14} />
              </button>

              {/* Image Number */}
              <div className="absolute bottom-2 left-2 bg-black/50 text-white text-xs px-2 py-1 rounded">
                {index + 1}
              </div>
            </div>
          ))}
        </div>
      )}

      {/* Helper Text */}
      <p className="text-xs text-muted-foreground">
        <Icon name="Info" size={12} className="inline mr-1" />
        Enter image URLs from Unsplash, your CDN, or any public image source. First image will be the main photo.
      </p>

      {/* Sample URLs */}
      {images.length === 0 && (
        <div className="p-3 bg-muted/50 border border-border rounded-md">
          <p className="text-xs font-medium text-foreground mb-2">Sample image URLs for testing:</p>
          <div className="space-y-1">
            <button
              type="button"
              onClick={() => setNewImageUrl('https://images.unsplash.com/photo-1611892440504-42a792e24d32')}
              className="block text-xs text-primary hover:underline"
            >
              Hotel Room 1
            </button>
            <button
              type="button"
              onClick={() => setNewImageUrl('https://images.unsplash.com/photo-1590490360182-c33d57733427')}
              className="block text-xs text-primary hover:underline"
            >
              Hotel Room 2
            </button>
            <button
              type="button"
              onClick={() => setNewImageUrl('https://images.unsplash.com/photo-1582719478250-c89cae4dc85b')}
              className="block text-xs text-primary hover:underline"
            >
              Luxury Suite
            </button>
          </div>
        </div>
      )}
    </div>
  );
};

export default ImageUrlInput;
