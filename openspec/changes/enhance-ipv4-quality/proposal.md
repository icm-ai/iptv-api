# Change: Enhance IPv4 Channel Quality with Strict Resolution Requirements

## Why

Current IPv4 channel availability is limited (479 total channels), with only 11 different CCTV channels and insufficient high-quality sources. Users require:
- **CCTV**: At least 15 different channels (currently only 11 unique channels in IPv4)
- **Hong Kong/Macau channels**: Complete coverage with smooth playback
- **Quality guarantee**: All channels must meet strict 1920x1080 resolution standard
- **Speed consistency**: IPv4 streams must deliver smooth playback (≥0.5 MB/s)

Current data shows only 2-3 CCTV channels have satisfactory IPv4 options with adequate speed. This proposal adds specialized IPv4 sources focusing on high-quality, smooth Chinese domestic and Hong Kong/Macau channels.

## What Changes

### Configuration Updates
1. **Enhanced subscription sources**: Add 10+ curated IPv4-focused IPTV repositories emphasizing Chinese domestic and regional channels
2. **Quality filtering strictness**:
   - Enforce minimum resolution: 1920x1080 (no fallback to 1280x720)
   - Maintain speed threshold: ≥0.5 MB/s
3. **IPv4 preference optimization**:
   - Increase `ipv4_num` from 15 to 25 (more IPv4 options per channel)
   - Enforce `ipv_type_prefer = ipv4,ipv6` ordering
4. **Regional coverage**:
   - Maintain domestic CCTV/satellite sources
   - Ensure Hong Kong/Macau/Taiwan channel inclusion
   - Preserve region metadata for user filtering

### No Code Changes
- Existing configuration system handles all requirements
- No Python code modifications needed
- Solution is purely configuration-driven

## Impact

- **Affected specs**: `channel-sourcing`, `ipv4-quality` (new)
- **Affected files**:
  - `config/subscribe.txt` - Add specialized IPv4 sources (10-15 new entries)
  - `config/config.ini` - Update quality thresholds and IPv4 preferences
  - `config/demo.txt` - Ensure Hong Kong/Macau channels are defined
- **Testing**: Speed test results should show ≥15 unique CCTV channels with IPv4 options
- **User impact**: Better IPv4 discovery, guaranteed smooth playback for CCTV and regional channels
