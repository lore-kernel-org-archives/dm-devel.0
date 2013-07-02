From: Yann Droneaud <ydroneaud@opteya.com>
Subject: [PATCH] MAINTAINERS: dm-devel@redhat.com is a list
Date: Tue,  2 Jul 2013 17:01:47 +0200
Message-ID: <1372777307-4259-1-git-send-email-ydroneaud@opteya.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com
Cc: Yann Droneaud <ydroneaud@opteya.com>
List-Id: dm-devel.ids

This patch changes type of dm-devel@redhat.com

The output of ./scripts/get_maintainer.pl is
modified to report dm-devel@redhat.com as a list:

 Alasdair Kergon <agk@redhat.com> (maintainer:DEVICE-MAPPER  (LVM))
-dm-devel@redhat.com (maintainer:DEVICE-MAPPER  (LVM))
 Neil Brown <neilb@suse.de> (supporter:SOFTWARE RAID (Mu...)
+dm-devel@redhat.com (open list:DEVICE-MAPPER  (LVM))
 linux-raid@vger.kernel.org (open list:SOFTWARE RAID (Mu...)
 linux-kernel@vger.kernel.org (open list)

Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7b6ab51..fefd17f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2527,7 +2527,6 @@ S:	Maintained
 
 DEVICE-MAPPER  (LVM)
 M:	Alasdair Kergon <agk@redhat.com>
-M:	dm-devel@redhat.com
 L:	dm-devel@redhat.com
 W:	http://sources.redhat.com/dm
 Q:	http://patchwork.kernel.org/project/dm-devel/list/
-- 
1.8.3.1
