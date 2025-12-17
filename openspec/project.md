# Project Context

## Purpose
IPTV-API is an automated IPTV live stream source management platform. The system automatically collects, filters, tests, and generates IPTV channel lists (M3U/TXT formats) from multiple sources. The platform provides flexible configuration options for customizing channel templates, filtering preferences, speed testing, and content delivery. It supports various deployment modes: command-line, GUI application, Docker containers, and GitHub Actions workflows.

Core functionality:
- Automatic discovery and aggregation of IPTV streams from multiple sources
- Channel quality assurance through speed testing and resolution filtering
- Flexible result generation with customizable templates and formats
- Scheduled updates with configurable intervals and preferred times
- EPG (Electronic Program Guide) integration for channel descriptions
- Multi-protocol support (IPv4/IPv6, RTMP streaming, HLS)
- Extensive configuration system for regional preferences, ISP filtering, blacklist/whitelist management

## Tech Stack
- **Language**: Python 3.13 (async-first architecture)
- **Web Framework**: Flask 3.1.0 (REST API and service interface)
- **Async**: aiohttp 3.11.13, asyncio (concurrent stream fetching and testing)
- **Web Scraping**: BeautifulSoup 4, Selenium 4.29.0 (browser automation for dynamic content)
- **Configuration**: configparser (INI-based configuration)
- **Data Processing**: requests 2.32.3, m3u8 6.0.0, Pillow 11.1.0
- **Utilities**: tqdm (progress bars), pytz (timezone handling), ipip-ipdb (IP geolocation)
- **Localization**: opencc-python-reimplemented (simplified/traditional Chinese conversion)
- **Deployment**: Docker (multi-platform: amd64, arm64, armv7), Gunicorn 23.0.0
- **Package Management**: Pipenv (lock-based dependency management)
- **UI**: tkinter (GUI desktop application), pystray (system tray integration)
- **Build**: PyInstaller 6.12.0 (executable packaging)

## Project Conventions

### Code Style
- **Language**: Python 3.13+ with type hints using TypedDict, Literal, Union, NotRequired
- **Imports**: Organize as stdlib → third-party → local modules
- **Type Annotations**: Required for function parameters and return types; use TypedDict for structured data
- **Docstrings**: Include brief descriptions for functions and classes; explain parameters for complex logic
- **Naming**:
  - snake_case for functions and variables
  - PascalCase for classes and TypedDicts
  - UPPER_SNAKE_CASE for constants
  - Private functions: prefix with underscore (e.g., `_helper_func`)
- **Error Handling**: Log exceptions with context; avoid silent failures
- **Resource Paths**: Use `config.resource_path()` for file paths (supports both development and PyInstaller bundles)
- **Configuration Access**: Use centralized `config` instance from `utils.config`; avoid hardcoded values

### Architecture Patterns
- **Modular Structure**: Separate concerns into dedicated modules
  - `utils/` - Common utilities (config, type definitions, tools)
  - `updates/` - Source-specific update modules (hotel, multicast, subscribe, online_search, EPG)
  - `service/` - Flask web service and API endpoints
  - `tkinter_ui/` - Desktop GUI application
- **Data Flow**: UpdateSource class orchestrates fetching → filtering → testing → writing
- **Configuration Management**: ConfigManager provides centralized configuration with environment variable overrides
- **Async Patterns**: Use asyncio for I/O-bound operations (HTTP requests, file operations); concurrent speed testing via semaphores
- **Caching**: Cache test results and EPG data to reduce API calls
- **Channel Data Model**: ChannelData TypedDict standardizes channel representation across all sources
  - Fields: id, url, host, date, resolution, origin, ipv_type, location, isp, headers, catchup, extra_info
  - Origin types: live, hls, local, whitelist, subscribe, hotel, multicast, online_search
  - Support for metadata (resolution, ISP, geolocation, request headers)

### Testing Strategy
- **Current State**: Project has no formal unit tests (no test framework detected)
- **Manual Testing**: GUI app and Docker containers provide integration testing opportunities
- **Speed Testing**: Built-in speed test mechanism validates stream quality (latency, bandwidth, resolution)
- **Validation**: Results logged in `output/log/result.log` for verification
- **Recommended Approach**: Consider pytest for future test coverage on utils and core channel processing logic

### Git Workflow
- **Branch Strategy**: Direct commits to main branch (typical for active solo projects)
- **Commit Conventions**: Follow conventional commits with scope and message in English or Chinese
  - `feat:` - New feature
  - `feat(scope):` - Feature affecting specific area (e.g., `feat(config)`)
  - `fix:` - Bug fix
  - `refactor:` - Code refactoring without behavior change
  - `chore:` - Maintenance (dependencies, badges, CI configuration)
  - `docs:` - Documentation updates
  - `update:` - Content updates (not code functionality)
  - Examples: `feat: 更新IPTV频道列表`, `refactor: request handling and improve error reporting`
- **Merge Strategy**: Linear history preferred; use fast-forward when possible
- **Tags**: Version tags for releases (e.g., v1.0.0)

## Domain Context

### IPTV Streaming Concepts
- **M3U Format**: Playlist format listing streams with metadata (title, group, logo, duration)
- **Stream Origins**: Multiple sources provide redundancy
  - Hotel networks (Foodie, FOFA/ZoomEye APIs)
  - Multicast (regional ISP broadcasts)
  - Subscription lists (community-maintained lists)
  - Online search (keyword-based discovery)
  - Local templates (user-defined channels)
- **Stream Protocols**:
  - HTTP/HTTPS (standard streaming)
  - RTMP (Real Time Messaging Protocol for low-latency live streaming)
  - HLS (HTTP Live Streaming, preferred for reliability)
  - Multicast (direct network broadcast via specific IP ranges)
- **Quality Metrics**:
  - Resolution: Detection via FFmpeg probe (e.g., 1920x1080, 1280x720)
  - Latency: Response time for stream initialization (milliseconds)
  - Bandwidth: Data transmission rate (MB/s), minimum 0.5 MB/s default
  - Host health: Track successful playback instances
- **Channel Metadata**:
  - Aliases: Multiple names for same channel (regex-supported for fuzzy matching)
  - Geolocation: ISP and country attribution for regional filtering
  - EPG: Electronic Program Guide with daily schedules and descriptions
  - Logo/Logos: Channel branding (PNG/SVG)
  - Catchup: Replay/archive capability (some players support format-specific replay)
- **Update Scheduling**: Cron-like scheduling with Asia/Shanghai timezone default (configurable)

### Regional & Network Considerations
- IPv4 vs IPv6: Dual-stack support with per-protocol result generation
- ISP Filtering: Filter results by specific carriers (e.g., China Telecom, China Mobile)
- Geolocation Filtering: Match streams to user region (e.g., mainland China, Hong Kong, international)
- Network Types: Support for both public internet and private hotel/multicast networks
- Timezone Handling: Default Asia/Shanghai; configurable for international deployments

## Important Constraints

- **Resource Constraints**: Speed testing is computationally expensive; configurable concurrency limits (default 10) balance speed vs accuracy
- **Network Dependency**: Heavily relies on third-party stream sources; no guaranteed stability
- **Latency Trade-offs**: Lower speed test timeouts increase result quality but reduce discovery rate
- **IP Blocking Risk**: Hotel/multicast scanning may trigger firewall restrictions
- **Browser Automation**: Selenium-based hotel discovery requires system display (headless mode configurable)
- **Data Freshness**: Most streams are ephemeral; results may be outdated within hours/days
- **Encoding**: Chinese language support in channel names; traditional/simplified conversion available
- **FFmpeg Dependency**: Resolution detection requires FFmpeg installation (optional; falls back to defaults)
- **Python 3.13 Requirement**: Specific Python version pinned for compatibility
- **Large File Handling**: M3U files can be 1MB+ with thousands of channels

## External Dependencies

### Data Sources

**Primary Stream Sources:**
- **GitHub Repositories** (CCTV, regional satellites, general IPTV):
  - Guovin/iptv-database (primary curated source)
  - iptv-org/iptv (international + regional: cn.m3u, hk.m3u, mo.m3u, tc.m3u, tw.m3u)
  - suxuang/myIPTV (IPv4-focused IPTV lists)
  - kimwang1978/collect-tv-txt (aggregated streams)
  - vbskycn/iptv (domestic IPTV)

**Enhanced Chinese Domestic Sources** (Added for quality improvement):
- **High-Quality Domestic Aggregators**:
  - malimali/iptv (comprehensive domestic channels)
  - YueChan/Live (curated IPTV selections)
  - hailin0/PaoCaiTV (regional broadcast focus)
  - YJIT/IPTV.m3u (CCTV-dedicated source)
  - Ftindy/IPTV-M3U (region-specific: Domestic, HK, TW)
- **Regional Specialty Sources**:
  - iptv-org/iptv mo.m3u (Macau channels)
  - iptv-org/iptv tc.m3u (Traditional Chinese)
  - Ftindy/IPTV-M3U HK/TW (Hong Kong/Taiwan dedicated)

- **Channel Logos**: fanmingming/live (GitHub repository)
- **IP Geolocation**: IPIP IP database (ipip-ipdb package)

### API Services
- **FOFA/ZoomEye**: Shodan-like APIs for hotel network discovery (optional; requires API key)
- **Foodie API**: Provides hotel/network resource enumeration
- **Multicast Network**: Regional ISP multicast broadcasts (192.168.x.x, 224.0.0.0/4 ranges)

### System Dependencies
- **FFmpeg**: Optional; required for resolution detection and RTMP streaming
- **Docker**: For containerized deployments (amd64/arm64/armv7)
- **Browser**: Selenium requires Chrome/Firefox for hotel source discovery
- **Networking**: IPv6 detection requires network interface access

### Configuration Files
- `config/config.ini` - Master configuration (50+ settings)
- `config/demo.txt` - Channel template file
- `config/alias.txt` - Channel name aliases with regex
- `config/blacklist.txt` - URLs/hosts to exclude
- `config/whitelist.txt` - URLs/hosts to prioritize
- `config/subscribe.txt` - Third-party subscription source URLs
- `config/local.txt` - User-defined local channels
- `config/epg.txt` - EPG source URLs
- `config/rtp/` - Regional multicast IP mappings (per ISP)

### Result Outputs
- **Files**: result.m3u, result.txt (default format), plus IPv4/IPv6/RTMP variants
- **Logs**: result.log (valid channels), speed_test.log (test metrics), statistic.log (summary), nomatch.log (unmatched channels)
- **Cache**: data/ directory (pickled test results for reuse)
