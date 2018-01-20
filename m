From: Wuchongyun <wu.chongyun@h3c.com>
Subject: [PATCH] multipathd: update path's udev in uev_update_path
Date: Sat, 20 Jan 2018 02:30:40 +0000
Message-ID: <CEB9978CF3252343BE3C67AC9F0086A3429585CA@H3CMLB14-EX.srv.huawei-3com.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: zh-CN
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
Cc: Guozhonghua <guozhonghua@h3c.com>, Changwei Ge <ge.changwei@h3c.com>, Changlimin <changlimin@h3c.com>
List-Id: dm-devel.ids

Hi Martin and Ben,
Could you help to review this patch, thanks.

When receiving a change uevent and calling uev_update_path, current code
not update the path's udev, if use pp->udev to query the udev database
info will get the old data. So it should update the path's udev with the
new udev from the new uevent in uev_update_path also.

Signed-off-by: Chongyun Wu <wu.chongyun@h3c.com>
---
 multipathd/main.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/multipathd/main.c b/multipathd/main.c
index 27cf234..e7a4f4b 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -937,6 +937,9 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 	if (pp) {
 		struct multipath *mpp = pp->mpp;
 
+		udev_device_unref(pp->udev);
+		pp->udev = udev_device_ref(uev->udev);
+
 		if (disable_changed_wwids &&
 		    (strlen(pp->wwid) || pp->wwid_changed)) {
 			char wwid[WWID_SIZE];
-- 
1.7.9.5

Regards
Chongyun
