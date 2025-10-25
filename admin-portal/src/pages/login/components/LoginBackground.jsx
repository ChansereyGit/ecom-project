import React from 'react';
import Image from '../../../components/AppImage';

const LoginBackground = () => {
  return (
    <div className="hidden lg:flex lg:w-1/2 relative overflow-hidden">
      {/* Background Image */}
      <div className="absolute inset-0">
        <Image
          src="https://images.unsplash.com/photo-1722277956458-09dc65a5445c"
          alt="Luxury hotel lobby with modern furniture, marble floors, and elegant lighting fixtures"
          className="w-full h-full object-cover" />

        <div className="absolute inset-0 bg-gradient-to-br from-primary/90 to-primary/70" />
      </div>

      {/* Content Overlay */}
      <div className="relative z-10 flex flex-col justify-center px-12 text-white">
        <div className="max-w-md">
          <h2 className="text-4xl font-bold mb-6">
            Manage Your Hotel with Confidence
          </h2>
          <p className="text-xl text-white/90 mb-8 leading-relaxed">
            Streamline operations, boost revenue, and deliver exceptional guest experiences with our comprehensive hotel management platform.
          </p>
          
          {/* Feature Highlights */}
          <div className="space-y-4">
            <div className="flex items-center space-x-3">
              <div className="w-8 h-8 bg-white/20 rounded-full flex items-center justify-center">
                <span className="text-sm font-semibold">✓</span>
              </div>
              <span className="text-white/90">Real-time booking management</span>
            </div>
            <div className="flex items-center space-x-3">
              <div className="w-8 h-8 bg-white/20 rounded-full flex items-center justify-center">
                <span className="text-sm font-semibold">✓</span>
              </div>
              <span className="text-white/90">Revenue analytics & reporting</span>
            </div>
            <div className="flex items-center space-x-3">
              <div className="w-8 h-8 bg-white/20 rounded-full flex items-center justify-center">
                <span className="text-sm font-semibold">✓</span>
              </div>
              <span className="text-white/90">Multi-property support</span>
            </div>
          </div>
        </div>

        {/* Trust Indicators */}
        <div className="absolute bottom-12 left-12 right-12">
          <div className="flex items-center justify-between text-white/70 text-sm">
            <div className="flex items-center space-x-2">
              <div className="w-4 h-4 bg-success rounded-full" />
              <span>Trusted by 500+ hotels</span>
            </div>
            <div className="flex items-center space-x-2">
              <div className="w-4 h-4 bg-success rounded-full" />
              <span>99.9% uptime guarantee</span>
            </div>
          </div>
        </div>
      </div>
    </div>);

};

export default LoginBackground;