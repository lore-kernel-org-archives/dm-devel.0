From: Nikanth Karthikesan <knikanth@suse.de>
Subject: [PATCH] Just inform and dont warn when DM_DEV_REMOVE is
	tried on a open device
Date: Tue, 20 Apr 2010 12:46:58 +0530
Message-ID: <201004201246.58828.knikanth@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>, device-mapper development <dm-devel@redhat.com>, Stefan Assmann <s.assmann@gmx.de>
List-Id: dm-devel.ids

Dont warn when DM_DEV_REMOVE ioctl is tried on a open device.

On openSUSE when cryptsetup and udev interact, cryptsetup sometimes tries to
remove a dm device currently opened by blkid, which is not a serious issue to
print a kernel warning. The application should retry if -EBUSY is returned. So
let us make it an informational message instead.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index d7500e1..dcfa48a 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -729,7 +729,7 @@ static int dev_remove(struct dm_ioctl *param, size_t param_size)
 	 */
 	r = dm_lock_for_deletion(md);
 	if (r) {
-		DMWARN("unable to remove open device %s", hc->name);
+		DMINFO("unable to remove open device %s", hc->name);
 		up_write(&_hash_lock);
 		dm_put(md);
 		return r;
