## Design: IPv4 Quality Enhancement Strategy

### Current State Analysis

**IPv4 Channel Status (Dec 14, 2025)**
- Total IPv4 channels: 479
- CCTV channels in IPv4: 11 unique (CCTV-1, 2, 4, 6, 9, 10, 11, 13, 14, 15, 17)
- Missing CCTV: CCTV-3, 5, 5+, 7, 8, 12, 16 (7 channels)
- Quality issue: Most CCTV channels have only 1 IPv4 option with speed <0.5 MB/s
- Best performers:
  - CCTV-13: 3 IPv4 options, max speed 8.29 M/s
  - CCTV-1: 2 IPv4 options, max speed 2.03 M/s

**Regional Coverage**
- Hong Kong: Limited TVB/regional channels
- Macau: Minimal coverage
- Taiwan: Insufficient availability

### Architecture Strategy

**Principle: Configuration-Driven Quality Improvement**
- No Python code changes required
- Leverage existing filtering and aggregation logic
- Stack high-quality IPv4 sources to increase channel options

**Quality Control Mechanism**
```
Source Aggregation → IP Protocol Filter → Resolution Filter → Speed Filter → Result
     (subscribe.txt)    (ipv_type)      (≥1920x1080)       (≥0.5 MB/s)   (m3u)
```

### Source Categorization Strategy

**Tier 1: CCTV-Specialized Sources** (highest priority)
- Focus: CCTV-1 through CCTV-17, CGTN
- Format: M3U/TXT with IPv4 emphasis
- Expected channels: 15-18 unique CCTV channels
- Examples: YJIT/IPTV.m3u, malimali/iptv, YueChan/Live

**Tier 2: Domestic Aggregators** (regional satellites & variety)
- Focus: Complete regional Chinese channels
- Format: M3U/TXT, mixed IPv4/IPv6
- Expected channels: CCTV + 30-50 regional satellites
- Examples: hailin0/PaoCaiTV, Ftindy/IPTV-M3U

**Tier 3: Regional Specialty Sources** (Hong Kong, Macau, Taiwan)
- Focus: TVB, AATV, Macau channels, Taiwan channels
- Format: M3U/TXT region-specific
- Expected channels: 20-30 per region
- Examples: Ftindy/IPTV-M3U HK/TW, iptv-org/iptv mo.m3u

**Tier 4: Existing Global Sources** (supplementary)
- Keep existing international sources
- Provide IPv6 fallback
- Maintain international channel discovery

### Configuration Changes Details

**config/subscribe.txt**
```
[Existing sources - keep as-is]
...

[Tier 1: CCTV-Specialized - NEW]
https://raw.githubusercontent.com/YJIT/IPTV.m3u/main/CCTV.m3u
[Additional 3-5 CCTV-focused sources]

[Tier 2: Domestic Aggregators - NEW]
https://raw.githubusercontent.com/malimali/iptv/main/iptv.m3u
https://raw.githubusercontent.com/YueChan/Live/main/IPTV.m3u
https://raw.githubusercontent.com/hailin0/PaoCaiTV/main/直播.txt
[More domestic sources]

[Tier 3: Regional - NEW/Enhanced]
https://raw.githubusercontent.com/iptv-org/iptv/master/streams/mo.m3u
https://raw.githubusercontent.com/Ftindy/IPTV-M3U/main/HK.m3u
https://raw.githubusercontent.com/Ftindy/IPTV-M3U/main/TW.m3u
```

**config/config.ini**
```
[Quality Thresholds]
min_resolution = 1920x1080           # No fallback (strict)
min_speed = 0.5                      # 0.5 MB/s minimum
open_filter_resolution = True        # Enable resolution filtering
open_filter_speed = True             # Enable speed filtering

[IPv4 Preference]
ipv4_num = 25                        # Increased from 15
ipv_type_prefer = ipv4,ipv6          # IPv4 first
ipv_type = 全部                      # Include both

[Aggregation]
open_supply = False                  # Strict quality (no compensation)
```

**config/demo.txt**
- Ensure all 17 CCTV channels are listed separately
- Include CCTV specialty channels
- Add distinct Hong Kong category
- Add distinct Macau category
- Add distinct Taiwan category

### Quality Filtering Workflow

1. **Source Collection**: subscribe.txt provides 50+ source URLs
2. **Parsing**: Extract M3U entries with metadata
3. **IP Filtering**: Select only IPv4 streams (ipv_type_prefer = ipv4)
4. **Resolution Check**: Remove streams <1920x1080 (FFmpeg probe required)
5. **Speed Test**: Remove streams <0.5 MB/s
6. **Deduplication**: Merge identical URLs across sources
7. **Ranking**: Sort by speed (descending) within channel
8. **Limiting**: Take top 25 IPv4 per channel (ipv4_num = 25)
9. **Output**: Generate result.m3u and ipv4-specific variants

### Success Criteria

| Metric | Target | Method |
|--------|--------|--------|
| CCTV unique channels | ≥15 | Count unique tvg-name values starting with "CCTV-" in result.m3u |
| CCTV IPv4 options | ≥2 avg | Check ipv4_num in statistic.log |
| CCTV max speed | ≥0.5 M/s | Verify max speed in statistic.log |
| CCTV resolution | 1920x1080 | Verify resolution metadata in output |
| HK channels | ≥10 | Count TVB/AATV/Now TV entries |
| MO channels | ≥5 | Count Macau-specific channels |
| TW channels | ≥7 | Count Taiwan-specific channels |

### Risk Mitigation

**Risk**: Source URLs become outdated
- **Mitigation**: Monitor GitHub repositories; quarterly review; maintain backup sources

**Risk**: Resolution detection fails without FFmpeg
- **Mitigation**: Ensure FFmpeg is installed in Docker; make optional with sensible defaults

**Risk**: Speed test timeout too strict
- **Mitigation**: Adjust min_speed from 0.5 to 0.2-0.3 MB/s if needed; document trade-off

**Risk**: Hong Kong/Macau sources lack IPv4
- **Mitigation**: Accept IPv6 for HK/MO as fallback; adjust ipv4_num if insufficient options

### Implementation Notes

- **No breaking changes**: Existing users' configurations unaffected unless they explicitly adopt new settings
- **Backward compatibility**: Old subscribe.txt entries continue to work
- **Performance impact**: Speed testing adds ~2-5 minutes to update cycle (manageable)
- **Caching**: Reuse cached test results from previous runs (open_use_cache = True)
