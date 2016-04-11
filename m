From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH] MAINTAINERS: correct entry for LVM
Date: Mon, 11 Apr 2016 20:50:39 +0530
Message-ID: <1460388039-20282-1-git-send-email-sudipm.mukherjee@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>, dm-devel@redhat.com, linux-raid@vger.kernel.org, Sudip Mukherjee <sudipm.mukherjee@gmail.com>
List-Id: dm-devel.ids

The entry of dm-devel@redhat.com was duplicated and the duplicate entry
was marked as a Maintainer but it appears from the email address that it
is a List. So remove the entry of M and only keep the L entry.

Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 51891b2..1c32e82 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3557,7 +3557,6 @@ S:	Maintained
 DEVICE-MAPPER  (LVM)
 M:	Alasdair Kergon <agk@redhat.com>
 M:	Mike Snitzer <snitzer@redhat.com>
-M:	dm-devel@redhat.com
 L:	dm-devel@redhat.com
 W:	http://sources.redhat.com/dm
 Q:	http://patchwork.kernel.org/project/dm-devel/list/
-- 
1.9.1

