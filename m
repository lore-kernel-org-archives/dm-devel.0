From: Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 1/1] dm raid: fix compat_features validation
Date: Tue, 11 Oct 2016 15:28:35 +0100
Message-ID: <20161011142835.11620-1-apw@canonical.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, Heinz Mauelshagen <heinzm@redhat.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
List-Id: dm-devel.ids

In commit ecbfb9f118bce4 ("dm raid: add raid level takeover support") a new
compatible feature flag was added.  Validation for these compat_features
was added but this only passes for new raid mappings with this feature
flag.  This causes previously created raid mappings to be failed at import.

Check compat_features for any valid combinations.

Fixes: ecbfb9f118bce4 ("dm raid: add raid level takeover support")
BugLink: http://bugs.launchpad.net/bugs/1631298
Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 drivers/md/dm-raid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

It very much looks like these are intended to be optional extended feature
flags.  That we should be accepting any valid flag and rejecting any bit
not in that set.  We should however not be ensuring that specific bits
are actually set.  Certainly as things stand raid sets built on previous
kernel versions cannot be assembled.

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 8abde6b..6ddea60 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -2258,7 +2258,7 @@ static int super_validate(struct raid_set *rs, struct md_rdev *rdev)
 	if (!mddev->events && super_init_validation(rs, rdev))
 		return -EINVAL;
 
-	if (le32_to_cpu(sb->compat_features) != FEATURE_FLAG_SUPPORTS_V190) {
+	if (le32_to_cpu(sb->compat_features) & ~(FEATURE_FLAG_SUPPORTS_V190)) {
 		rs->ti->error = "Unable to assemble array: Unknown flag(s) in compatible feature flags";
 		return -EINVAL;
 	}
-- 
2.9.3

