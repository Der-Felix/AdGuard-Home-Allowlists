#!/bin/bash
# Regenerates all-combined.txt and category combos
set -e
cd "$(dirname "$0")"

# Individual combined
{
echo "# ============================================================="
echo "# AdGuard Home – ALL Services Combined"
echo "# Auto-generated on $(date -u '+%Y-%m-%d')"
echo "# ============================================================="
echo ""
for f in lists/*.txt; do
  [ "$(basename "$f")" = "all-combined.txt" ] && continue
  cat "$f"
  echo ""
done
} > lists/all-combined.txt

RULES=$(grep -c '@@||' lists/all-combined.txt)
echo "✅ lists/all-combined.txt regenerated ($RULES rules)"

# Category combos
combine() {
  local name="$1"; shift
  {
    echo "# ============================================================="
    echo "# AdGuard Home – Combined: $name"
    echo "# Auto-generated on $(date -u '+%Y-%m-%d')"
    echo "# ============================================================="
    echo ""
    for f in "$@"; do
      [ -f "lists/$f" ] && { cat "lists/$f"; echo ""; }
    done
  } > "combined/$name.txt"
  echo "  ↳ combined/$name.txt ($(grep -c '@@||' "combined/$name.txt") rules)"
}

mkdir -p combined
combine "ai-services" chatgpt.txt claude-ai.txt gemini.txt midjourney.txt perplexity.txt deepl.txt copilot.txt huggingface.txt
combine "social-media" instagram.txt facebook.txt tiktok.txt twitter.txt reddit.txt pinterest.txt linkedin.txt snapchat.txt mastodon.txt threads.txt bluesky.txt
combine "streaming" netflix.txt disneyplus.txt primevideo.txt appletv.txt crunchyroll.txt paramountplus.txt dazn.txt plex.txt joyn.txt rtlplus.txt ard-zdf.txt
combine "gaming" steam.txt epicgames.txt playstation.txt nintendo.txt riotgames.txt xbox.txt twitch.txt discord.txt
combine "messaging" whatsapp.txt signal.txt telegram.txt slack.txt zoom.txt
combine "apple" icloud.txt icloud-privaterelay.txt appletv.txt
combine "google-full" google.txt youtube.txt gemini.txt googlehome.txt
combine "meta-full" facebook.txt instagram.txt whatsapp.txt threads.txt
combine "microsoft-full" microsoft.txt xbox.txt copilot.txt
combine "vpn-security" nordvpn.txt mullvad.txt expressvpn.txt cloudflare.txt bitwarden.txt tailscale.txt wireguard.txt proton.txt
combine "smart-home" alexa.txt googlehome.txt homeassistant.txt sonos.txt
combine "german-services" gmx.txt ard-zdf.txt joyn.txt rtlplus.txt dhl.txt banking-de.txt ebay.txt klarna.txt

echo "✅ All category combos regenerated"
