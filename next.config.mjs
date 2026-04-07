/** @type {import('next').NextConfig} */
const nextConfig = {
  eslint: {
    // Warnings don't block deploy
    ignoreDuringBuilds: true,
  },
};

export default nextConfig;
