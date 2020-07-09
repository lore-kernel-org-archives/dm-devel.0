From: mwilck@suse.com
Subject: [PATCH 47/54] libmultipath: get_refwwid(): use
	find_path_by_devt()
Date: Thu,  9 Jul 2020 12:36:16 +0200
Message-ID: <20200709103623.8302-6-mwilck@suse.com>
References: <20200709103623.8302-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709103623.8302-1-mwilck@suse.com>
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

If get_refwwid is called with a dev_t argument, there's no point in converting
it into a devname first. If the device doesn't exist, get_udev_device() will fail.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 75e11fd..e8d6db8 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -1414,17 +1414,15 @@ int get_refwwid(enum mpath_cmds cmd, char *dev, enum devtypes dev_type,
 
 	if (dev_type == DEV_DEVT) {
 		strchop(dev);
-		if (devt2devname(buff, FILE_NAME_SIZE, dev)) {
-			condlog(0, "%s: cannot find block device\n", dev);
-			return 1;
-		}
-		pp = find_path_by_dev(pathvec, buff);
+		pp = find_path_by_devt(pathvec, dev);
 		if (!pp) {
 			struct udev_device *udevice =
 				get_udev_device(dev, dev_type);
 
-			if (!udevice)
+			if (!udevice) {
+				condlog(0, "%s: cannot find block device", dev);
 				return 1;
+			}
 
 			conf = get_multipath_config();
 			pthread_cleanup_push(put_multipath_config, conf);
-- 
2.26.2
