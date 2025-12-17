# Change: Enhance Chinese Domestic and Hong Kong/Macau Channel Quality and Availability

## Why

Current subscription sources lack specialized coverage for Chinese domestic channels (CCTV series) and Hong Kong/Macau regional channels. While general sources exist, they often mix low-quality and regional-specific streams without optimization. Users require dedicated, high-quality IPv4 sources focused on Mainland China, with merged results for Hong Kong/Macau channels that maintain regional distinction through metadata.

## What Changes

- **Extend subscription source list**: Add 8-12 curated GitHub repositories and CDN sources specializing in Chinese domestic IPTV streams (CCTV, regional satellites, Hong Kong/Macau channels)
- **Prioritize IPv4 discovery**: Configure result generation to favor IPv4 sources for Chinese domestic use
- **Optimize resolution filtering**: Ensure CCTV and major channels meet minimum 1920x1080 threshold
- **Merge regional results**: Combined output with region metadata (mainland, Hong Kong, Macau, Taiwan) for user-side filtering

## Impact

- **Affected specs**: `channel-sourcing` (new)
- **Affected code**:
  - `config/subscribe.txt` - Add new subscription source URLs
  - `config/config.ini` - Adjust `ipv4_num`, `ipv_type_prefer`, `min_resolution` defaults
  - `utils/config.py` - No changes (existing configuration system sufficient)
- **Deployment**: No code changes required; configuration-driven solution
- **User impact**: Better channel discovery and quality for Chinese domestic viewing; Hong Kong/Macau channels available in unified result with region tagging
