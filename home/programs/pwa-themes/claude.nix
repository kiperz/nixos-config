# Claude.ai theme — Stylix-aware base16 color interpolation
# Overrides Claude's Tailwind utility classes with base16 palette
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
#
# mozDocument: set to a domain string (e.g. "claude.ai") to wrap in
#   @-moz-document for Firefox userContent.css; omit for Electron/bare CSS
{ c
, alpha ? { subtle = "0A"; light = "1A"; medium = "40"; strong = "80"; heavy = "CC"; }
, mozDocument ? null
}:
let
  css = ''
    /* ── Scrollbars ── */
    html, div, aside, nav, main, section {
      scrollbar-width: thin;
      scrollbar-color: ${c.base04}${alpha.medium} ${c.base00};
    }

    /* ── Text selection ── */
    ::selection { background-color: ${c.base02} !important; }

    /* ── Global base ── */
    html, body {
      background-color: ${c.base00} !important;
      color: ${c.base05} !important;
    }

    /* ── Background layers ── */
    .bg-bg-000, div[class*="bg-bg-000"] { background-color: ${c.base00} !important; }
    .bg-bg-100, div[class*="bg-bg-100"] { background-color: ${c.base00} !important; }
    .bg-bg-200, div[class*="bg-bg-200"] { background-color: ${c.base01} !important; }
    .bg-bg-300, div[class*="bg-bg-300"] { background-color: ${c.base01} !important; }
    .bg-bg-400, div[class*="bg-bg-400"] { background-color: color-mix(in sRGB, ${c.base00}, black 20%) !important; }
    .bg-bg-500 { background-color: color-mix(in sRGB, ${c.base00}, black 40%) !important; }

    /* Gradients */
    .from-bg-000 { --tw-gradient-from: ${c.base00} !important; }
    .from-bg-100 { --tw-gradient-from: ${c.base00} !important; }
    .from-bg-200 { --tw-gradient-from: ${c.base01} !important; }
    .from-bg-300 { --tw-gradient-from: ${c.base01} !important; }
    .to-bg-000 { --tw-gradient-to: ${c.base00} !important; }
    .to-bg-100 { --tw-gradient-to: ${c.base00} !important; }
    .to-bg-300 { --tw-gradient-to: ${c.base01} !important; }

    .bg-gradient-to-b, .bg-gradient-to-t, .bg-gradient-to-r, .bg-gradient-to-l {
      --tw-gradient-from: ${c.base00} !important;
      --tw-gradient-to: ${c.base00}00 !important;
    }

    /* Layout containers */
    .min-h-screen, .h-screen {
      background-color: ${c.base00} !important;
    }

    /* ── Sidebar ── */
    nav, aside, .z-sidebar, div[class*="z-sidebar"] {
      background-color: ${c.base01} !important;
      border-right-color: ${c.base04}${alpha.medium} !important;
    }

    /* Sidebar items */
    ul.flex.flex-col.gap-px li a { color: ${c.base04} !important; }
    ul.flex.flex-col.gap-px li a:hover {
      background-color: ${c.base00}${alpha.light} !important;
      color: ${c.base05} !important;
    }

    /* ── Header ── */
    header, [class*="header"] {
      background-color: ${c.base00} !important;
      border-bottom-color: ${c.base04}${alpha.medium} !important;
    }

    /* ── Text colors ── */
    .text-text-000 { color: ${c.base06} !important; }
    .text-text-100 { color: ${c.base06} !important; }
    .text-text-200 { color: ${c.base05} !important; }
    .text-text-300 { color: ${c.base04} !important; }
    .text-text-400 { color: ${c.base03} !important; }
    .text-text-500 { color: ${c.base03} !important; }

    /* ── Border colors ── */
    .border-border-100 { border-color: ${c.base04}${alpha.light} !important; }
    .border-border-200 { border-color: ${c.base04}${alpha.light} !important; }
    .border-border-300 { border-color: ${c.base04}${alpha.medium} !important; }
    .border-border-400 { border-color: ${c.base04}${alpha.medium} !important; }
    .border-0\.5 { border-color: ${c.base04}${alpha.light} !important; }

    /* ── Accent colors (brand → base0D blue) ── */
    .bg-accent-main-000 { background-color: ${c.base0D}${alpha.light} !important; }
    .bg-accent-main-100 { background-color: ${c.base0D} !important; }
    .bg-accent-main-200 { background-color: ${c.base0D} !important; }
    .bg-accent-main-900 { background-color: ${c.base0D}${alpha.light} !important; }
    .text-accent-main-000, .text-accent-main-100, .text-accent-main-200 { color: ${c.base0D} !important; }
    .border-accent-main-000 { border-color: ${c.base0D}${alpha.medium} !important; }
    .border-accent-main-100 { border-color: ${c.base0D} !important; }
    .bg-accent-brand { background-color: ${c.base0D} !important; }

    /* Pro accent → violet */
    .bg-accent-pro-000 { background-color: ${c.base0E}${alpha.light} !important; }
    .bg-accent-pro-100 { background-color: ${c.base0E} !important; }
    .bg-accent-pro-200 { background-color: ${c.base0E} !important; }
    .bg-accent-pro-900 { background-color: ${c.base0E}${alpha.light} !important; }
    .text-accent-pro-000, .text-accent-pro-100 { color: ${c.base0E} !important; }

    /* Secondary accent → cyan */
    .bg-accent-secondary-000 { background-color: ${c.base0C}${alpha.light} !important; }
    .bg-accent-secondary-100 { background-color: ${c.base0C} !important; }
    .bg-accent-secondary-200 { background-color: ${c.base0C} !important; }
    .bg-accent-secondary-900 { background-color: ${c.base0C}${alpha.light} !important; }
    .text-accent-secondary-000, .text-accent-secondary-100 { color: ${c.base0C} !important; }

    /* ── Semantic colors ── */
    .text-danger-000, .text-danger-100 { color: ${c.base08} !important; }
    .bg-danger-000 { background-color: ${c.base08}${alpha.light} !important; }
    .bg-danger-100 { background-color: ${c.base08} !important; }
    .bg-danger-900 { background-color: ${c.base08}${alpha.light} !important; }
    .border-danger-100 { border-color: ${c.base08} !important; }

    .text-success-000, .text-success-100 { color: ${c.base0B} !important; }
    .bg-success-000 { background-color: ${c.base0B}${alpha.light} !important; }
    .bg-success-100 { background-color: ${c.base0B} !important; }
    .bg-success-900 { background-color: ${c.base0B}${alpha.light} !important; }

    /* On-color text */
    .text-oncolor-100 { color: ${c.base07} !important; }
    .text-oncolor-200 { color: ${c.base06} !important; }
    .text-oncolor-300 { color: ${c.base05} !important; }

    /* ── Chat messages ── */
    .font-user-message { color: ${c.base06} !important; }
    .font-claude-message, .font-copernicus { color: ${c.base05} !important; }

    [data-testid="chat-message-text"], .standard-markdown { color: ${c.base05} !important; }

    .standard-markdown h1, .standard-markdown h2,
    .standard-markdown h3, .standard-markdown h4 { color: ${c.base06} !important; }
    .standard-markdown strong, .standard-markdown b { color: ${c.base06} !important; }
    .standard-markdown a { color: ${c.base0D} !important; }
    .standard-markdown a:hover { color: ${c.base0C} !important; }

    .standard-markdown blockquote {
      border-left: 3px solid ${c.base0D}${alpha.strong} !important;
      color: ${c.base04} !important;
      background-color: ${c.base01}${alpha.strong} !important;
      padding-left: 12px !important;
    }

    .standard-markdown hr { border-color: ${c.base01} !important; }
    .standard-markdown ul li::marker, .standard-markdown ol li::marker { color: ${c.base0D} !important; }

    .standard-markdown table th {
      background-color: ${c.base01} !important;
      color: ${c.base06} !important;
      border-color: ${c.base01} !important;
    }
    .standard-markdown table td {
      border-color: ${c.base01} !important;
      color: ${c.base05} !important;
    }
    .standard-markdown table tr:nth-child(even) { background-color: ${c.base01}${alpha.medium} !important; }

    /* ── Code blocks ── */
    .code-block__code, pre[class*="language-"], div[class*="code-block"] {
      background-color: ${c.base01} !important;
      color: ${c.base05} !important;
      border: 1px solid ${c.base01} !important;
      border-radius: 6px !important;
    }

    /* Inline code */
    .standard-markdown code:not(pre code), code:not(pre code) {
      background-color: ${c.base01} !important;
      color: ${c.base0C} !important;
      border: 1px solid ${c.base01} !important;
      border-radius: 4px !important;
      padding: 1px 5px !important;
    }

    /* Syntax highlighting (PrismJS — standard base16 mapping) */
    .token.comment, .token.prolog, .token.doctype, .token.cdata { color: ${c.base03} !important; }
    .token.punctuation { color: ${c.base05} !important; }
    .token.property, .token.tag, .token.boolean, .token.number, .token.constant, .token.symbol, .token.deleted { color: ${c.base09} !important; }
    .token.selector, .token.attr-name, .token.string, .token.char, .token.builtin, .token.inserted { color: ${c.base0B} !important; }
    .token.operator, .token.entity, .token.url { color: ${c.base0A} !important; }
    .token.atrule, .token.attr-value, .token.keyword { color: ${c.base0E} !important; }
    .token.function, .token.class-name { color: ${c.base0D} !important; }
    .token.regex, .token.important, .token.variable { color: ${c.base0C} !important; }

    /* ── Input area ── */
    fieldset, [data-testid="chat-input-grid-area"] {
      background-color: ${c.base01} !important;
      border-color: ${c.base01} !important;
    }

    .ProseMirror {
      background-color: transparent !important;
      color: ${c.base05} !important;
      caret-color: ${c.base0D} !important;
    }
    .ProseMirror p.is-editor-empty:first-child::before { color: ${c.base03} !important; }

    fieldset:focus-within {
      border-color: ${c.base0D}${alpha.strong} !important;
      box-shadow: 0 0 0 1px ${c.base0D}${alpha.medium} !important;
    }

    /* ── Buttons ── */
    button[class*="bg-accent-main"], button.bg-accent-main-100 {
      background-color: ${c.base0D} !important;
      color: ${c.base07} !important;
    }
    button[class*="bg-accent-main"]:hover { background-color: color-mix(in sRGB, ${c.base0D}, white 15%) !important; }

    /* ── Dropdowns & Popovers ── */
    [data-radix-popper-content-wrapper] > div, [role="menu"], [role="dialog"] {
      background-color: ${c.base01} !important;
      border-color: ${c.base01} !important;
      box-shadow: 0 4px 16px ${c.base00}${alpha.strong} !important;
    }
    [role="menuitem"], [role="option"] { color: ${c.base05} !important; }
    [role="menuitem"]:hover, [role="option"]:hover,
    [role="menuitem"][data-highlighted], [role="option"][data-highlighted] {
      background-color: ${c.base00} !important;
      color: ${c.base06} !important;
    }

    /* ── Modals ── */
    [role="alertdialog"], [role="dialog"][class*="bg-bg"] {
      background-color: ${c.base01} !important;
      border: 1px solid ${c.base01} !important;
    }

    /* ── Tooltips ── */
    [role="tooltip"] {
      background-color: ${c.base01} !important;
      color: ${c.base05} !important;
      border: 1px solid ${c.base01} !important;
    }

    /* ── Form inputs (settings pages) ── */
    input[type="text"], input[type="email"], input[type="password"], textarea {
      background-color: ${c.base01} !important;
      color: ${c.base05} !important;
      border-color: ${c.base01} !important;
      caret-color: ${c.base0D} !important;
    }
    input[type="text"]:focus, input[type="email"]:focus, textarea:focus {
      border-color: ${c.base0D}${alpha.strong} !important;
      box-shadow: 0 0 0 1px ${c.base0D}${alpha.medium} !important;
    }

    /* Toggle switches */
    [role="switch"][data-state="checked"] { background-color: ${c.base0D} !important; }
    [role="switch"][data-state="unchecked"] { background-color: ${c.base01} !important; }

    /* ── Shadows ── */
    .shadow-lg, .shadow-md, .shadow-sm { box-shadow: 0 1px 3px ${c.base00}${alpha.medium} !important; }

    /* ── Focus rings ── */
    *:focus-visible { outline-color: ${c.base0D}${alpha.strong} !important; }

    /* ── SVG icons ── */
    svg { color: inherit !important; }
    svg path[fill="#D97757"] { fill: ${c.base09} !important; }

    /* ── Loading indicators ── */
    .anthropic-animated-logo svg path { fill: ${c.base0D} !important; }

    /* ── Plan badges ── */
    [class*="bg-accent-pro"] {
      background-color: ${c.base0E}${alpha.light} !important;
      color: ${c.base0E} !important;
    }

    /* ── Links ── */
    a { color: ${c.base0D} !important; }
    a:hover { color: ${c.base0C} !important; }
  '';
in
  if mozDocument != null
  then ''@-moz-document domain("${mozDocument}") {${css}}''
  else css
