From: neilb@suse.de
Subject: [dmraid 2/4] Avoid fd leak in remove_device_partitions.
Date: Thu, 17 Dec 2009 16:44:12 +1100
Message-ID: <20091217054520.996066834@suse.de>
References: <20091217054410.410634166@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dmraid-fdleak.patch
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

As this removes partitions for a list of devices, it could leak
a large number of file descriptors.

Reported-by:  David Binderman <dcb314@hotmail.com>
From: crrodriguez@opensuse.org
Signed-off-by: NeilBrown <neilb@suse.de>

---
 lib/device/partition.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- dmraid-16.orig/lib/device/partition.c
+++ dmraid-16/lib/device/partition.c
@@ -30,12 +30,15 @@ _remove_subset_partitions(struct lib_con
 		/* There is no way to enumerate partitions */
 		for (part.pno = 1; part.pno <= 256; part.pno++) {
 			if (ioctl(fd, BLKPG, &io) < 0 && errno != ENXIO &&
-					(part.pno < 16 || errno != EINVAL))
+					(part.pno < 16 || errno != EINVAL)) {
+			       close(fd);
 				LOG_ERR(lc, 0,
 					"removing part %d from %s: %s\n",
 					part.pno, rd->di->path,
 					strerror(errno));
+			}
 		}
+		close(fd);
 	}
 	return 1;
 }
