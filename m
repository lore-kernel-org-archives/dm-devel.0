From: mwilck@suse.com
Subject: [PATCH 31/35] libmultipath: alloc_path_with_pathinfo():
	treat devname overflow as error
Date: Thu,  9 Jul 2020 12:16:16 +0200
Message-ID: <20200709101620.6786-32-mwilck@suse.com>
References: <20200709101620.6786-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709101620.6786-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

This is to be consistent with store_path_with_pathinfo(). It's not strictly
necessary; we _could_ proceed in both functions even in the unlikely case
that the device name overflows, because we use pp->dev mainly for log
messages. However, a device node name that causes an overflow for
FILE_NAME_SIZE = 256 should be considered pathologic anyway.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 10b5a28..81a3fad 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -64,6 +64,7 @@ alloc_path_with_pathinfo (struct config *conf, struct udev_device *udevice,
 
 	if (safe_sprintf(pp->dev, "%s", devname)) {
 		condlog(0, "pp->dev too small");
+		err = 1;
 	} else {
 		pp->udev = udev_device_ref(udevice);
 		err = pathinfo(pp, conf, flag | DI_BLACKLIST);
-- 
2.26.2
