From: Takahiro Yasui <tyasui@redhat.com>
Subject: [RFC][PATCH 3/4] dm-crypt: update resume method for
 interruption of presuspend
Date: Tue, 23 Feb 2010 13:45:11 -0500
Message-ID: <4B842237.7020202@redhat.com>
Reply-To: LVM2 development <lvm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <lvm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/lvm-devel>,
	<mailto:lvm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/lvm-devel>
List-Post: <mailto:lvm-devel@redhat.com>
List-Help: <mailto:lvm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/lvm-devel>,
	<mailto:lvm-devel-request@redhat.com?subject=subscribe>
Sender: lvm-devel-bounces@redhat.com
Errors-To: lvm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: k-ueda@ct.jp.nec.com, LVM2 development <lvm-devel@redhat.com>
List-Id: dm-devel.ids

When suspend is interrupted after presuspend procedure, each
target needs to cancel all state changes done by its presuspend
procedure. As for the crypt target, there is nothing to be
canceled because the crypt target doesn't have a presuspend method.

The crypt target should skip crypt_preresume/crypt_resume method
when the target isn't suspended.


Signed-off-by: Takahiro Yasui <tyasui@redhat.com>
---
 drivers/md/dm-crypt.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux-2.6.33-rc1-dm/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.33-rc1-dm.orig/drivers/md/dm-crypt.c
+++ linux-2.6.33-rc1-dm/drivers/md/dm-crypt.c
@@ -1314,6 +1314,10 @@ static int crypt_preresume(struct dm_tar
 {
 	struct crypt_config *cc = ti->private;
 
+	/* Just returns if the state is not "suspended". */
+	if (!dm_suspended(ti))
+		return 0;
+
 	if (!test_bit(DM_CRYPT_KEY_VALID, &cc->flags)) {
 		DMERR("aborting resume - crypt key is not set.");
 		return -EAGAIN;
@@ -1326,6 +1330,10 @@ static void crypt_resume(struct dm_targe
 {
 	struct crypt_config *cc = ti->private;
 
+	/* Just returns if the state is not "suspended". */
+	if (!dm_suspended(ti))
+		return;
+
 	clear_bit(DM_CRYPT_SUSPENDED, &cc->flags);
 }
 

--
lvm-devel mailing list
lvm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/lvm-devel
