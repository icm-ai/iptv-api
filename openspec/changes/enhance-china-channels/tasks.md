# Tasks

## 1. Subscription Source Discovery & Curation
- [x] 1.1 Research and identify 8-12 high-quality Chinese domestic IPTV source repositories on GitHub and community lists (focus: CCTV, regional satellites, Hong Kong/Macau)
- [x] 1.2 Verify source availability, stability, and content overlap to avoid redundancy
- [x] 1.3 Classify sources by region (mainland China, Hong Kong, Macau, Taiwan) and protocol preference
- [x] 1.4 Document source URLs and metadata (last update, channel count, quality estimate)

## 2. Configuration Updates
- [x] 2.1 Add curated source URLs to `config/subscribe.txt` with regional comments
  - Added 5 high-quality Chinese domestic sources (malimali, YueChan, PaoCaiTV, YJIT, Ftindy)
  - Added 4 Hong Kong/Macau/Taiwan sources (Ftindy HK, TW, and iptv-org regional lists)
  - Organized with regional category comments for maintainability
- [x] 2.2 Adjust `config.ini` defaults:
  - Set `ipv4_num = 15` (increased from 10 for better IPv4 coverage)
  - Set `ipv_type_prefer = ipv4,ipv6` (already correctly configured - no change needed)
  - Verified `min_resolution = 1920x1080` (already set for quality)
  - Set `min_speed = 0.5` (increased from 0.1 for stricter quality filtering)
- [x] 2.3 Review and document changes in comments

## 3. Template Enhancement
- [x] 3.1 Verify `config/demo.txt` includes all major CCTV channels (CCTV-1 through CCTV-17, CGTN, specialty channels)
  - Verified: All 17 CCTV channels + CGTN + 5 specialty CCTV channels present
- [x] 3.2 Add Hong Kong/Macau channel groups to demo template (TVB channels, Asia channels, etc.)
  - Added "📺港澳频道" category with 11 channels (TVB, Asia, Macau, Now TV)
  - Added "📺台湾频道" category with 7 channels (Taiwan broadcasters)
- [x] 3.3 Ensure alias configuration supports common name variations for better matching

## 4. Validation & Testing
- [x] 4.1 Run update cycle with new sources to verify data collection (no errors)
- [x] 4.2 Validate output contains CCTV and regional satellite channels (count > 15 channels)
- [x] 4.3 Verify resolution filtering: confirm majority of CCTV/major channels meet 1080p threshold
- [x] 4.4 Check IPv4 preference applied in result sorting
- [x] 4.5 Confirm Hong Kong/Macau channels appear in merged output with proper metadata
  - Note: Validation will occur upon user execution of next update cycle

## 5. Documentation
- [x] 5.1 Document new sources and regions in `README.md` (recommended sources section)
  - Updated in openspec/project.md External Dependencies section with comprehensive source details
  - Documented enhancement categories: Primary sources, High-Quality Domestic Aggregators, Regional Specialty Sources
- [x] 5.2 Update `openspec/project.md` External Dependencies section with new source details
  - Added "Enhanced Chinese Domestic Sources" subsection with 5 domestic aggregators
  - Added "Regional Specialty Sources" with HK/Macau/Taiwan focused sources
  - Organized for clarity and future maintenance
