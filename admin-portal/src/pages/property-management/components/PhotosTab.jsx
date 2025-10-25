import React, { useState } from 'react';
import Icon from '../../../components/AppIcon';
import Button from '../../../components/ui/Button';
import Image from '../../../components/AppImage';

const PhotosTab = ({ property, onUpdate, isEditing }) => {
  const [dragOver, setDragOver] = useState(false);
  const [selectedPhoto, setSelectedPhoto] = useState(null);

  const mockPhotos = [
  {
    id: 1,
    url: "https://images.unsplash.com/photo-1722277956458-09dc65a5445c",
    alt: 'Modern hotel lobby with marble floors, elegant seating area, and crystal chandelier',
    category: 'lobby',
    title: 'Main Lobby',
    isPrimary: true
  },
  {
    id: 2,
    url: "https://images.unsplash.com/photo-1614340508729-777dbef96d8b",
    alt: 'Luxury hotel room with king bed, modern furniture, and city view through large windows',
    category: 'room',
    title: 'Deluxe King Room',
    isPrimary: false
  },
  {
    id: 3,
    url: "https://images.unsplash.com/photo-1662472460736-e26f7a49e90a",
    alt: 'Hotel restaurant with elegant dining tables, warm lighting, and contemporary decor',
    category: 'dining',
    title: 'Main Restaurant',
    isPrimary: false
  },
  {
    id: 4,
    url: "https://images.unsplash.com/photo-1675771922250-6b1ab4fb9786",
    alt: 'Outdoor swimming pool with lounge chairs, palm trees, and blue water',
    category: 'amenities',
    title: 'Swimming Pool',
    isPrimary: false
  },
  {
    id: 5,
    url: "https://images.unsplash.com/photo-1543502999-b65be91f22ea",
    alt: 'Modern hotel bathroom with marble countertops, rainfall shower, and luxury amenities',
    category: 'room',
    title: 'Premium Bathroom',
    isPrimary: false
  },
  {
    id: 6,
    url: "https://images.unsplash.com/photo-1670004810567-f4328dcc983e",
    alt: 'Hotel fitness center with modern equipment, mirrors, and natural lighting',
    category: 'amenities',
    title: 'Fitness Center',
    isPrimary: false
  }];


  const categories = [
  { id: 'all', label: 'All Photos', icon: 'Image' },
  { id: 'lobby', label: 'Lobby & Common Areas', icon: 'Building' },
  { id: 'room', label: 'Rooms & Suites', icon: 'Bed' },
  { id: 'dining', label: 'Dining', icon: 'UtensilsCrossed' },
  { id: 'amenities', label: 'Amenities', icon: 'Dumbbell' },
  { id: 'exterior', label: 'Exterior', icon: 'Home' }];


  const [activeCategory, setActiveCategory] = useState('all');

  const filteredPhotos = activeCategory === 'all' ?
  mockPhotos :
  mockPhotos?.filter((photo) => photo?.category === activeCategory);

  const handleDragOver = (e) => {
    e?.preventDefault();
    setDragOver(true);
  };

  const handleDragLeave = (e) => {
    e?.preventDefault();
    setDragOver(false);
  };

  const handleDrop = (e) => {
    e?.preventDefault();
    setDragOver(false);
    // Handle file drop logic here
    console.log('Files dropped:', e?.dataTransfer?.files);
  };

  const PhotoCard = ({ photo }) =>
  <div className="group relative bg-card border border-border rounded-lg overflow-hidden hover:shadow-elevation-2 transition-all duration-200">
      <div className="aspect-video relative overflow-hidden">
        <Image
        src={photo?.url}
        alt={photo?.alt}
        className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-200" />

        
        {/* Primary Badge */}
        {photo?.isPrimary &&
      <div className="absolute top-2 left-2 bg-primary text-primary-foreground px-2 py-1 rounded-full text-xs font-medium flex items-center">
            <Icon name="Star" size={12} className="mr-1" />
            Primary
          </div>
      }

        {/* Actions Overlay */}
        {isEditing &&
      <div className="absolute inset-0 bg-black/50 opacity-0 group-hover:opacity-100 transition-opacity duration-200 flex items-center justify-center space-x-2">
            <Button
          variant="secondary"
          size="sm"
          iconName="Eye"
          onClick={() => setSelectedPhoto(photo)}>

              View
            </Button>
            <Button
          variant="secondary"
          size="sm"
          iconName="Edit">

              Edit
            </Button>
            <Button
          variant="destructive"
          size="sm"
          iconName="Trash2">

              Delete
            </Button>
          </div>
      }
      </div>

      <div className="p-3">
        <h4 className="font-medium text-foreground text-sm mb-1">{photo?.title}</h4>
        <div className="flex items-center justify-between">
          <span className="text-xs text-muted-foreground capitalize">
            {photo?.category}
          </span>
          {isEditing && !photo?.isPrimary &&
        <Button
          variant="ghost"
          size="xs"
          iconName="Star"
          className="text-muted-foreground hover:text-warning">

              Set Primary
            </Button>
        }
        </div>
      </div>
    </div>;


  const UploadArea = () =>
  <div
    className={`
        border-2 border-dashed rounded-lg p-8 text-center transition-colors
        ${dragOver ?
    'border-primary bg-primary/5' : 'border-border hover:border-primary/50'}
        ${
    !isEditing ? 'opacity-50 cursor-not-allowed' : 'cursor-pointer'}
      `}
    onDragOver={handleDragOver}
    onDragLeave={handleDragLeave}
    onDrop={handleDrop}
    onClick={() => isEditing && document.getElementById('photo-upload')?.click()}>

      <Icon
      name="Upload"
      size={32}
      className={`mx-auto mb-4 ${dragOver ? 'text-primary' : 'text-muted-foreground'}`} />

      <h4 className="font-medium text-foreground mb-2">
        {dragOver ? 'Drop photos here' : 'Upload Property Photos'}
      </h4>
      <p className="text-sm text-muted-foreground mb-4">
        Drag and drop photos here, or click to browse
      </p>
      <p className="text-xs text-muted-foreground">
        Supports: JPG, PNG, WebP • Max size: 10MB each
      </p>
      
      <input
      id="photo-upload"
      type="file"
      multiple
      accept="image/*"
      className="hidden"
      disabled={!isEditing} />

    </div>;


  return (
    <div className="p-6">
      <div className="max-w-6xl mx-auto">
        <div className="flex items-center justify-between mb-6">
          <div>
            <h3 className="text-lg font-medium text-foreground flex items-center">
              <Icon name="Camera" size={20} className="mr-2" />
              Photo Gallery
            </h3>
            <p className="text-sm text-muted-foreground mt-1">
              Manage photos for {property?.name} • {mockPhotos?.length} photos
            </p>
          </div>
        </div>

        {/* Category Filter */}
        <div className="flex flex-wrap gap-2 mb-6 p-1 bg-muted rounded-lg">
          {categories?.map((category) =>
          <button
            key={category?.id}
            onClick={() => setActiveCategory(category?.id)}
            className={`
                flex items-center space-x-2 px-3 py-2 rounded-md text-sm font-medium transition-colors
                ${activeCategory === category?.id ?
            'bg-background text-foreground shadow-sm' :
            'text-muted-foreground hover:text-foreground hover:bg-background/50'}
              `
            }>

              <Icon name={category?.icon} size={16} />
              <span>{category?.label}</span>
              <span className="text-xs bg-muted-foreground/20 px-1.5 py-0.5 rounded-full">
                {category?.id === 'all' ?
              mockPhotos?.length :
              mockPhotos?.filter((p) => p?.category === category?.id)?.length
              }
              </span>
            </button>
          )}
        </div>

        {/* Upload Area */}
        {isEditing && <UploadArea />}

        {/* Photos Grid */}
        <div className="mt-6">
          {filteredPhotos?.length === 0 ?
          <div className="text-center py-12">
              <Icon name="Image" size={48} className="mx-auto text-muted-foreground mb-4" />
              <h4 className="text-lg font-medium text-foreground mb-2">
                No Photos in {categories?.find((c) => c?.id === activeCategory)?.label}
              </h4>
              <p className="text-muted-foreground mb-4">
                {activeCategory === 'all' ? 'Upload your first property photo to get started' : 'No photos in this category yet'
              }
              </p>
            </div> :

          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
              {filteredPhotos?.map((photo) =>
            <PhotoCard key={photo?.id} photo={photo} />
            )}
            </div>
          }
        </div>

        {!isEditing && mockPhotos?.length > 0 &&
        <div className="mt-6 p-4 bg-muted/50 rounded-lg border border-border">
            <div className="flex items-center text-sm text-muted-foreground">
              <Icon name="Info" size={16} className="mr-2" />
              Enable edit mode to upload, edit, or delete photos
            </div>
          </div>
        }
      </div>
      {/* Photo Modal */}
      {selectedPhoto &&
      <div className="fixed inset-0 bg-black/80 z-300 flex items-center justify-center p-4">
          <div className="bg-card rounded-lg max-w-4xl max-h-[90vh] overflow-hidden">
            <div className="flex items-center justify-between p-4 border-b border-border">
              <h3 className="font-medium text-foreground">{selectedPhoto?.title}</h3>
              <Button
              variant="ghost"
              size="sm"
              iconName="X"
              onClick={() => setSelectedPhoto(null)} />

            </div>
            <div className="p-4">
              <Image
              src={selectedPhoto?.url}
              alt={selectedPhoto?.alt}
              className="w-full h-auto max-h-[70vh] object-contain" />

            </div>
          </div>
        </div>
      }
    </div>);

};

export default PhotosTab;