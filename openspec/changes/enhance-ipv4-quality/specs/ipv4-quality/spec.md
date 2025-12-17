## ADDED Requirements

### Requirement: IPv4 CCTV Channel Diversity

The system SHALL provide at least 15 distinct CCTV channels with IPv4 protocol support, each with a minimum of 2 smooth-playing options (speed ≥0.5 MB/s, resolution ≥1920x1080).

#### Scenario: CCTV Channel Discovery
- **WHEN** update cycle executes with enhanced IPv4 sources enabled
- **THEN** result contains CCTV-1 through CCTV-17 as separate channels (minimum 15 unique)
- **AND** each channel has ≥2 IPv4 options in `output/ipv4/result.m3u`
- **AND** statistic.log shows `IPv4: ≥2` for each CCTV channel
- **EXAMPLE**: `Category: 📺央视频道, Name: CCTV-1, IPv4: 3, Max Speed: 2.03 M/s, Max Resolution: 1920x1080`

#### Scenario: Quality Filtering (Resolution)
- **WHEN** speed test validates CCTV-1 stream options
- **THEN** only streams with resolution ≥1920x1080 are included in final result
- **AND** streams with 1280x720 or lower are filtered out
- **AND** `open_filter_resolution = True` enforces this filtering
- **EXAMPLE**: CCTV-1 has 5 candidate URLs; 2 are 1920x1080 (kept), 3 are 1280x720 (removed)

#### Scenario: Quality Filtering (Speed)
- **WHEN** speed test measures stream bandwidth
- **THEN** only streams achieving ≥0.5 MB/s are retained in output
- **AND** slower streams are marked invalid and excluded
- **AND** `open_filter_speed = True` enforces threshold
- **AND** `min_speed = 0.5` sets the boundary
- **EXAMPLE**: CCTV-2 max speed recorded as 0.33 M/s (below threshold); if sole option, channel weakened

#### Scenario: IPv4 Preference in Mixed Results
- **WHEN** system sorts results for CCTV-1 with both IPv4 and IPv6 options available
- **THEN** IPv4 streams appear first in result.m3u
- **AND** IPv6 streams listed after (as fallback)
- **AND** `ipv_type_prefer = ipv4,ipv6` enforces ordering
- **AND** `ipv4_num = 25` allocates priority slots to IPv4
- **EXAMPLE**: Result shows CCTV-1 with 3 IPv4 URLs first, then 10 IPv6 URLs

### Requirement: Hong Kong, Macau, Taiwan Channel Coverage

The system SHALL aggregate and provide Hong Kong, Macau, and Taiwan channels with regional metadata, supporting smooth IPv4 playback where available, with minimum 1920x1080 resolution.

#### Scenario: Hong Kong Channel Availability
- **WHEN** update cycle processes Hong Kong-specific sources (e.g., Ftindy HK.m3u, iptv-org mo.m3u)
- **THEN** result includes major Hong Kong channels: TVB翡翠台, TVB明珠台, AATV, Now TV variants
- **AND** each HK channel appears in `📺港澳频道` group-title category
- **AND** channel count ≥10 distinct HK channels
- **EXAMPLE**: `#EXTINF:-1 tvg-name="TVB翡翠台" group-title="📺港澳频道"`

#### Scenario: Macau Channel Availability
- **WHEN** update cycle processes Macau-specific sources (iptv-org mo.m3u, regional sources)
- **THEN** result includes Macau channels with distinct regional metadata
- **AND** Macau channels appear separate from mainland channels
- **AND** channel count ≥5 distinct Macau channels
- **EXAMPLE**: 澳亚卫视, 澳门卫视, 澳门信息频道

#### Scenario: Taiwan Channel Availability
- **WHEN** update cycle processes Taiwan-specific sources (Ftindy TW.m3u, regional sources)
- **THEN** result includes Taiwan channels: 台视, 中视, 华视, 民视, TVBS, 台湾卫视
- **AND** Taiwan channels appear in `📺台湾频道` or similar group
- **AND** channel count ≥7 distinct Taiwan channels
- **EXAMPLE**: `#EXTINF:-1 tvg-name="台视" group-title="📺台湾频道"`

#### Scenario: Regional Channel IPv4 Priority
- **WHEN** Hong Kong, Macau, Taiwan channels are tested
- **THEN** IPv4 streams are prioritized when available
- **AND** if IPv4 insufficient, IPv6 fallback is permitted
- **AND** all regional channels meet 1920x1080 minimum (where testable)
- **AND** filtering rules apply uniformly: `min_resolution`, `min_speed`

### Requirement: Configuration-Driven Quality Control

The system configuration files SHALL enable strict quality filtering through settable parameters, supporting IPv4 preference and resolution/speed thresholds, without requiring code changes.

#### Scenario: Subscription Source Extension
- **WHEN** new IPTV source URLs are added to `config/subscribe.txt`
- **THEN** system automatically fetches and aggregates them in next update cycle
- **AND** no Python code modification is required
- **AND** sources are parsed according to existing M3U/TXT logic
- **EXAMPLE**: Adding `https://raw.githubusercontent.com/YJIT/IPTV.m3u/main/CCTV.m3u` automatically includes CCTV streams

#### Scenario: Quality Threshold Configuration
- **WHEN** `config/config.ini` sets `min_resolution = 1920x1080` and `min_speed = 0.5`
- **THEN** filtering logic applies these thresholds during speed test phase
- **AND** streams below threshold are marked invalid
- **AND** no code changes needed; configuration values drive behavior
- **AND** `open_filter_resolution = True` and `open_filter_speed = True` enable/disable accordingly
- **EXAMPLE**: User changes `min_speed = 0.2` to relax threshold; next update uses new value

#### Scenario: IPv4 Preference Configuration
- **WHEN** `ipv_type_prefer = ipv4,ipv6` is set in config.ini
- **THEN** IPv4 streams prioritized in ordering and allocation (ipv4_num = 25)
- **AND** IPv6 streams serve as fallback
- **AND** `ipv_type = 全部` allows both protocols in aggregation
- **AND** no code changes needed
- **EXAMPLE**: User adjusts `ipv4_num` from 15 to 30 to capture more IPv4 options; filtering applies automatically

#### Scenario: Template Configuration
- **WHEN** `config/demo.txt` lists channel names (CCTV-1, CCTV-2, ..., TVB翡翠台, etc.)
- **THEN** system searches for these specific channel names during aggregation
- **AND** results are organized per template categories
- **AND** no code changes required; template drives channel selection
- **EXAMPLE**: Adding "CCTV-3" to template ensures it's searched for in next update
