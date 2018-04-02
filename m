From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 17/20] multipath -u: test if path is busy
Date: Mon,  2 Apr 2018 21:50:48 +0200
Message-ID: <20180402195051.26854-18-mwilck@suse.com>
References: <20180402195051.26854-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180402195051.26854-1-mwilck@suse.com>
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
Cc: Julian Andres Klode <julian.klode@canonical.com>, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

For "find_multipaths smart", check if a path is already in use
before setting DM_MULTIPATH_DEVICE_PATH to 1 or 2 (and thus,
SYSTEMD_READY=0). If we don't do this, a device which has already been
mounted (e.g. during initrd processing) may be unmounted by systemd, causing
havoc to the boot process.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/main.c | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/multipath/main.c b/multipath/main.c
index d09f117..392d5f0 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -629,16 +629,45 @@ configure (struct config *conf, enum mpath_cmds cmd,
 
 
 	if (cmd == CMD_VALID_PATH) {
+		struct path *pp;
+		int fd;
+
 		/* This only happens if find_multipaths and
 		 * ignore_wwids is set.
 		 * If there is currently a multipath device matching
 		 * the refwwid, or there is more than one path matching
 		 * the refwwid, then the path is valid */
-		if (VECTOR_SIZE(curmp) != 0 || VECTOR_SIZE(pathvec) > 1)
+		if (VECTOR_SIZE(curmp) != 0) {
+			r = 0;
+			goto print_valid;
+		} else if (VECTOR_SIZE(pathvec) > 1)
 			r = 0;
 		else
 			/* Use r=2 as an indication for "maybe" */
 			r = 2;
+
+		/*
+		 * If opening the path with O_EXCL fails, the path
+		 * is in use (e.g. mounted during initramfs processing).
+		 * We know that it's not used by dm-multipath.
+		 * We may not set SYSTEMD_READY=0 on such devices, it
+		 * might cause systemd to umount the device.
+		 * Use O_RDONLY, because udevd would trigger another
+		 * uevent for close-after-write.
+		 *
+		 * get_refwwid() above stores the path we examine in slot 0.
+		 */
+		pp = VECTOR_SLOT(pathvec, 0);
+		fd = open(udev_device_get_devnode(pp->udev),
+			  O_RDONLY|O_EXCL);
+		if (fd >= 0)
+			close(fd);
+		else {
+			condlog(3, "%s: path %s is in use: %s",
+				__func__, pp->dev,
+				strerror(errno));
+			r = 1;
+		}
 		goto print_valid;
 	}
 
-- 
2.16.1
