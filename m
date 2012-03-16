From: Joe Thornber <ejt@redhat.com>
Subject: [PATCH 02/14] dm-thin: remove some documentation for the
	unimplemented 'trim' target message
Date: Fri, 16 Mar 2012 15:22:25 +0000
Message-ID: <1331911358-8848-2-git-send-email-ejt@redhat.com>
References: <20120316152156.GA8836@ubuntu>
	<1331911358-8848-1-git-send-email-ejt@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1331911358-8848-1-git-send-email-ejt@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

I'd planned a 'trim' target message for shrinking thin devices, but
this is better handled via the discard ioctl.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 Documentation/device-mapper/thin-provisioning.txt |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/Documentation/device-mapper/thin-provisioning.txt b/Documentation/device-mapper/thin-provisioning.txt
index 801d9d1..981aebb 100644
--- a/Documentation/device-mapper/thin-provisioning.txt
+++ b/Documentation/device-mapper/thin-provisioning.txt
@@ -237,16 +237,6 @@ iii) Messages
 
 	Deletes a thin device.  Irreversible.
 
-    trim <dev id> <new size in sectors>
-
-	Delete mappings from the end of a thin device.  Irreversible.
-	You might want to use this if you're reducing the size of
-	your thinly-provisioned device.  In many cases, due to the
-	sharing of blocks between devices, it is not possible to
-	determine in advance how much space 'trim' will release.  (In
-	future a userspace tool might be able to perform this
-	calculation.)
-
     set_transaction_id <current id> <new id>
 
 	Userland volume managers, such as LVM, need a way to
-- 
1.7.9.1
