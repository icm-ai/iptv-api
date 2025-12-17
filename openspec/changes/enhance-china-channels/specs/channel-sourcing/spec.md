# Spec Delta: Channel Sourcing Enhancement

## ADDED Requirements

### Requirement: Curated Chinese Domestic Source List
The system SHALL aggregate IPTV streams from specialized Chinese domestic sources covering CCTV national channels, regional satellite broadcasts, and Hong Kong/Macau regional channels through extended subscription source configuration.

#### Scenario: CCTV channel discovery
- **WHEN** update cycle executes with new Chinese domestic sources enabled
- **THEN** result includes CCTV-1 through CCTV-17, CGTN, and specialty channels (风云足球, 风云音乐, etc.)
- **AND** primary sources are IPv4-based streams from reliable repositories

#### Scenario: Regional channel availability
- **WHEN** subscription sources include Hong Kong (HK) and Macau (MO) region data
- **THEN** output contains TVB channels (TVB翡翠台, TVB明珠台, etc.) and Macau regional channels
- **AND** channels appear with region metadata for user filtering

#### Scenario: Quality threshold enforcement
- **WHEN** CCTV and major satellite channels are tested
- **THEN** at least 80% of channels meet minimum 1920x1080 resolution requirement
- **AND** channels below minimum speed threshold (0.5 MB/s) are filtered

### Requirement: IPv4-Optimized Result Generation
The system SHALL prefer IPv4 sources in result generation to support Chinese domestic network infrastructure and user expectations.

#### Scenario: IPv4 preference in output
- **WHEN** results are sorted for same channel with both IPv4 and IPv6 options
- **THEN** IPv4 sources appear first in the result list
- **AND** configuration `ipv_type_prefer = ipv4,ipv6` enforces this ordering

#### Scenario: Result composition
- **WHEN** `ipv4_num = 15` is configured
- **THEN** result prioritizes up to 15 IPv4 interfaces per channel (where available)
- **AND** IPv6 interfaces supplement when IPv4 sources insufficient

## MODIFIED Requirements

### Requirement: Subscription Source Configuration
The system SHALL fetch IPTV stream data from subscription source URLs specified in configuration file.

**Previous behavior**: Supported generic international and selective Chinese sources (iptv-org/iptv country-specific lists).

**Updated behavior**: Extends to include specialized Chinese domestic repositories (multiple CCTV-focused, regional broadcast aggregators) prioritizing IPv4 availability and region attribution for mainland, Hong Kong, Macau, and Taiwan channels.

#### Scenario: Source loading with regional curation
- **WHEN** system initializes subscription source fetching from updated `config/subscribe.txt`
- **THEN** Chinese domestic sources (CCTV aggregators, regional lists) are processed alongside existing general sources
- **AND** Hong Kong/Macau region sources are included in same aggregation (merged output)
- **AND** all source URL formats (M3U, TXT) are parsed correctly

#### Scenario: Configuration precedence
- **WHEN** configuration updates IPv4 count and resolution filters
- **THEN** quality filtering respects `min_resolution = 1920x1080` for CCTV/major channels
- **AND** speed filtering applies `min_speed = 0.5` MB/s consistently
- **AND** IPv4 preference applies `ipv_type_prefer = ipv4,ipv6`

### Requirement: Channel Template Management
The system SHALL support customizable channel templates defining which channels to discover and include in results.

**Previous behavior**: Template supports CCTV 1-17, regional satellites, and basic local channels.

**Updated behavior**: Extends template to explicitly list Hong Kong/Macau channels (TVB, Asia, etc.) with improved regex-based alias matching for regional name variations.

#### Scenario: Template expansion for HK/Macau
- **WHEN** `config/demo.txt` includes Hong Kong/Macau channel group
- **THEN** channels like TVB翡翠台, 亚视, 澳亚卫视 are discoverable and included in results
- **AND** channel alias matching (regex) correctly maps variations (例: "TVB翡翠" → "TVB翡翠台")

#### Scenario: Mixed-region result output
- **WHEN** both mainland and HK/Macau channels are in template
- **THEN** result output preserves both categories in same M3U/TXT file
- **AND** channel metadata includes region information for filtering capability
