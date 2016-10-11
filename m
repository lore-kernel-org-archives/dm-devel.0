From: Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 1/1 V2] dm raid: fix compat_features validation
Date: Tue, 11 Oct 2016 17:21:48 +0100
Message-ID: <20161011162148.hz2ncmbvtmtmzjkz@brain>
References: <20161011142835.11620-1-apw@canonical.com>
 <1c517f14-1234-7844-fc6a-cd1b9698fb8b@redhat.com>
 <20161011153808.nmyf6hafjaadcemw@brain>
 <591b9d8d-2036-2d0f-14f2-af176b5beaea@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <591b9d8d-2036-2d0f-14f2-af176b5beaea@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Heinz Mauelshagen <heinzm@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

From a30fba068e41214cb0ffcb14e68722482765e0c9 Mon Sep 17 00:00:00 2001
From: Andy Whitcroft <apw@canonical.com>
Date: Tue, 11 Oct 2016 15:16:57 +0100

In ecbfb9f118bce4 ("dm raid: add raid level takeover support") a new
compatible feature flag was added.  Validation for these compat_features
was added but this only passes for new raid mappings with this feature
flag.  This causes previously created raid mappings to be failed at
import.

Check compat_features for the only valid combination.

Fixes: ecbfb9f118bce4 ("dm raid: add raid level takeover support")
Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 drivers/md/dm-raid.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

V2: simplify checks as per maintainer.

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 8abde6b..2a39700 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -2258,7 +2258,8 @@ static int super_validate(struct raid_set *rs, struct md_rdev *rdev)
 	if (!mddev->events && super_init_validation(rs, rdev))
 		return -EINVAL;
 
-	if (le32_to_cpu(sb->compat_features) != FEATURE_FLAG_SUPPORTS_V190) {
+	if (le32_to_cpu(sb->compat_features) &&
+	    le32_to_cpu(sb->compat_features) != FEATURE_FLAG_SUPPORTS_V190) {
 		rs->ti->error = "Unable to assemble array: Unknown flag(s) in compatible feature flags";
 		return -EINVAL;
 	}
-- 
2.9.3
