From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH RESEND 4/4] libmultipath: uev_update_path: update
	path properties
Date: Thu,  8 Mar 2018 00:21:52 +0100
Message-ID: <20180307232152.15538-5-mwilck@suse.com>
References: <20180307232152.15538-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180307232152.15538-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Chongyun Wu <wu.chongyun@h3c.com>
Cc: Martin Wilck <mwilck@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Update pp->udev and those path attributes that can be cheaply
updated from sysfs, i.e. without IO to the disk.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/multipathd/main.c b/multipathd/main.c
index e9668205ce92..6e6c52a52783 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -964,6 +964,14 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 				strcpy(pp->wwid, wwid);
 			else
 				pp->wwid_changed = 0;
+		} else {
+			udev_device_unref(pp->udev);
+			pp->udev = udev_device_ref(uev->udev);
+			conf = get_multipath_config();
+			if (pathinfo(pp, conf, DI_SYSFS|DI_NOIO) != PATHINFO_OK)
+				condlog(1, "%s: pathinfo failed after change uevent",
+					uev->kernel);
+			put_multipath_config(conf);
 		}
 
 		if (pp->initialized == INIT_REQUESTED_UDEV)
-- 
2.16.1
