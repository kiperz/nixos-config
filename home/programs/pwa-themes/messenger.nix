# Messenger Dark theme — adapted from userstyles.world/style/1325 (CC-BY-SA-4.0)
# Takes Stylix color palette (config.lib.stylix.colors.withHashtag) as argument
#
# base16 roles:
#   base00/01 = backgrounds (dark → lighter)
#   base02    = selection highlight ONLY
#   base03    = comments/muted text
#   base04    = dark foreground (secondary text)
#   base05    = default foreground
#   base06    = light foreground (icons, emphasis)
#   base07    = lightest (button text on accent)
#   base08-0F = accent colors
#
# Alpha levels (configurable via `alpha` attr):
#   subtle  = "0A" (~4%)  — barely visible tints
#   light   = "1A" (~10%) — hover overlays, dividers
#   medium  = "40" (~25%) — scrollbar thumbs, borders
#   strong  = "80" (~50%) — blockquote bgs, inset shadows
#   heavy   = "CC" (~80%) — modal backdrops
{ c, alpha ? { subtle = "0A"; light = "1A"; medium = "40"; strong = "80"; heavy = "CC"; } }: ''
  @-moz-document domain("messenger.com") {
    /* Scrollbars */
    html, div {
      scrollbar-width: thin;
      scrollbar-color: ${c.base04}${alpha.medium} ${c.base00};
    }

    /* Root CSS Variables Override */
    :root, .__fb-light-mode, .__fb-dark-mode {
      /* Backgrounds */
      --messenger-card-background: ${c.base00} !important;
      --surface-background: ${c.base00} !important;
      --card-background: ${c.base00} !important;
      --card-background-flat: ${c.base01} !important;
      --popover-background: ${c.base01} !important;
      --chat-incoming-message-bubble-background-color: ${c.base01} !important;
      --mwp-message-row-background: ${c.base00} !important;
      --messenger-reply-background: ${c.base01} !important;
      --secondary-button-background: ${c.base01} !important;
      --secondary-button-background-floating: ${c.base01} !important;
      --disabled-button-background: ${c.base01} !important;
      --input-background: ${c.base00} !important;
      --wash: ${c.base01} !important;
      --web-wash: ${c.base01} !important;
      --comment-footer-background: ${c.base01} !important;
      --background-deemphasized: ${c.base01} !important;

      /* Accent */
      --primary-button-background: ${c.base0D} !important;
      --primary-deemphasized-button-text: ${c.base0D} !important;
      --accent: ${c.base0D} !important;
      --blue-link: ${c.base0D} !important;
      --base-blue: ${c.base0D} !important;
      --base-lemon: ${c.base0A} !important;
      --switch-active: ${c.base0D} !important;
      --toggle-active-background: ${c.base0D} !important;

      /* Text */
      --primary-text: ${c.base05} !important;
      --secondary-text: ${c.base04} !important;
      --placeholder-text: ${c.base03} !important;
      --primary-button-text: ${c.base07} !important;
      --secondary-button-text: ${c.base05} !important;
      --disabled-text: ${c.base03} !important;
      --disabled-button-text: ${c.base03} !important;
      --primary-text-on-media: ${c.base05} !important;
      --input-label-color-highlighted: ${c.base0D} !important;

      /* Overlays & Borders */
      --always-dark-overlay: ${c.base00}${alpha.subtle} !important;
      --hosted-view-selected-state: ${c.base02}${alpha.medium} !important;
      --pressable-background-color-selected: ${c.base0D}${alpha.light} !important;
      --circle-button-normal-background-color: ${c.base01} !important;
      --primary-deemphasized-button-background: ${c.base0D}${alpha.light} !important;
      --primary-deemphasized-button-pressed-overlay: ${c.base01}${alpha.strong} !important;
      --secondary-button-background-on-dark: ${c.base01} !important;
      --pressable-background-color-hover: ${c.base01}${alpha.strong} !important;
      --chat-replied-message-background-color: ${c.base01}${alpha.strong} !important;
      --chat-text-blockquote-color-background-line: ${c.base01} !important;
      --comment-background: ${c.base01} !important;
      --hover-overlay: ${c.base05}${alpha.light} !important;
      --press-overlay: ${c.base05}${alpha.light} !important;
      --overlay-alpha-80: ${c.base00}${alpha.heavy} !important;
      --media-inner-border: ${c.base05}${alpha.light} !important;
      --shadow-inset: ${c.base00}${alpha.strong} !important;
      --progress-ring-neutral-foreground: ${c.base04}${alpha.medium} !important;
      --scroll-thumb: ${c.base04}${alpha.medium} !important;
      --radio-border-color: ${c.base04} !important;
      --divider: ${c.base05}${alpha.light} !important;
      --input-border-color: ${c.base01} !important;
      --input-border-color-hover: ${c.base04}${alpha.medium} !important;
      --focus-ring-blue: ${c.base0D} !important;
      --placeholder-text-on-media: ${c.base03} !important;
      --always-black: ${c.base00} !important;
      --always-white: ${c.base05} !important;

      /* Icons */
      --primary-icon: ${c.base06} !important;
      --secondary-icon: ${c.base04}${alpha.medium} !important;
      --icon-primary-color: ${c.base06} !important;
      --icon-secondary-color: ${c.base04} !important;
      --icon-tertiary-color: ${c.base03} !important;
      --placeholder-icon: ${c.base04} !important;
      --disabled-icon: ${c.base03} !important;
      --filter-primary-icon: invert(100%) sepia(0%) saturate(4807%) hue-rotate(84deg) brightness(110%) contrast(110%) !important;
      --filter-secondary-icon: invert(100%) sepia(0%) saturate(4807%) hue-rotate(84deg) brightness(110%) contrast(110%) !important;
      --filter-disabled-icon: invert(100%) sepia(0%) saturate(4807%) hue-rotate(84deg) brightness(110%) contrast(110%) !important;
      --filter-placeholder-icon: invert(100%) sepia(0%) saturate(4807%) hue-rotate(84deg) brightness(110%) contrast(110%) !important;
      --filter-accent: invert(50%) sepia(94%) saturate(3979%) hue-rotate(183deg) brightness(104%) contrast(103%) !important;

      /* Gray scale (derived from base00) */
      --fds-gray-00: ${c.base00} !important;
      --fds-gray-05: color-mix(in sRGB, ${c.base00}, white 5%) !important;
      --fds-gray-10: color-mix(in sRGB, ${c.base00}, white 10%) !important;
      --fds-gray-20: color-mix(in sRGB, ${c.base00}, white 20%) !important;
      --fds-gray-25: color-mix(in sRGB, ${c.base00}, white 25%) !important;
      --fds-gray-30: color-mix(in sRGB, ${c.base00}, white 30%) !important;
      --fds-gray-45: color-mix(in sRGB, ${c.base00}, white 45%) !important;
      --fds-gray-70: color-mix(in sRGB, ${c.base00}, white 70%) !important;
      --fds-gray-80: color-mix(in sRGB, ${c.base00}, white 80%) !important;
      --fds-gray-90: color-mix(in sRGB, ${c.base00}, white 90%) !important;
      --fds-gray-100: color-mix(in sRGB, ${c.base00}, white 100%) !important;

      color-scheme: dark;
    }

    /* Icon overrides */
    svg[style="--color: var(--always-black);"] {
      --color: ${c.base06} !important;
    }

    /* Hidden images / file attachments */
    .x11dxs5c, .x1ybostu {
      background-color: ${c.base01};
    }

    /* Focus rings */
    .x51xajf::before { border-color: ${c.base00}; }
    .x7kqs8i::after { border-color: ${c.base04}; }

    /* Document preview */
    .x1yi8jrw { background-color: ${c.base00}; }

    /* Video progress bar */
    .x1evw4sf { background-color: ${c.base0D}; }

    /* Loading spinner */
    path[style*="stroke: rgb(24"] { stroke: ${c.base0D} !important; fill: none !important; }
    rect[style*="stroke: rgb(204"] { stroke: ${c.base01} !important; }

    /* Conversation loading bar */
    .x1xzmf5g { background-color: ${c.base01}; }
    .x4o00kh { background-color: ${c.base0D}; }

    /* Text selection */
    ::selection { background-color: ${c.base02} !important; }
  }
''
