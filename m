From: Martin Schwenke <martin@meltin.net>
Subject: [PATCH] multipathd: Don't mark a virtio_blk path offline
 if it has no sysfs "state" attribute
Date: Thu, 5 May 2011 16:32:25 +1000
Message-ID: <20110505163225.0a8a5257@martins.ozlabs.org>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

multipathd currently marks paths as down if they don't have a sysfs
"state" attribute.

Unfortunately, this makes multipathd unusable with Linux virtio_blk
devices, since they don't have this attribute.  I need to use multipath
with virtio for consistency with a real configuration when testing a
clustered NAS system - yeah, I'm that guy again...  :-)

One way of working around this might be to have path_offline() return
PATH_UP for all devices that don't have a sysfs "state" attribute,
instead of PATH_WILD.  However, I'm guessing the current behaviour might
exist for a reason.

The following patch makes path_offline() always return PATH_UP instead
of PATH_WILD for virtio_blk devices.  I've implemented the nested if
statements as below to change the code flow as little as possible
when sysfs_get_state() actually succeeds, which I assume is usually the
case.   If nobody is feeling paranoid then the check for virtio_blk
could obviously be done before the call to sysfs_get_state().

If people think this patch is too specific then at least it can be
used to start a discussion...  ;-)


commit fc2eb79ba3bca70702568cce73be9daffaf3f149
Author: Martin Schwenke <martin@meltin.net>
Date:   Thu May 5 14:39:29 2011 +1000

    Don't mark a virtio_blk path offline if it has no sysfs "state" attribute.
    
    Signed-off-by: Martin Schwenke <martin@meltin.net>

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index aa25cc4..1155f68 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -722,8 +722,15 @@ path_offline (struct path * pp)
 		return PATH_WILD;
 	}
 
-	if (sysfs_get_state(parent, buff, SCSI_STATE_SIZE))
-		return PATH_WILD;
+	if (sysfs_get_state(parent, buff, SCSI_STATE_SIZE)) {
+		if (!strncmp(parent->driver, "virtio_blk", 10)) {
+			condlog(3, "%s: virtio_blk is always up", pp->dev);
+			return PATH_UP;
+		} else {
+			condlog(3, "%s: failed to get \"state\"", pp->dev);
+			return PATH_WILD;
+		}
+	}
 
 	condlog(3, "%s: state = %s", pp->dev, buff);
 

peace & happiness,
martin
