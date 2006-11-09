From: akpm@osdl.org
Subject: - dm-fix-find_device-race.patch removed from -mm tree
Date: Thu, 09 Nov 2006 00:44:48 -0800
Message-ID: <200611090844.kA98imN8010572@shell0.pdx.osdl.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com, dm-devel@redhat.com, mm-commits@vger.kernel.org
List-Id: dm-devel.ids


The patch titled
     dm: fix find_device race
has been removed from the -mm tree.  Its filename was
     dm-fix-find_device-race.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: dm: fix find_device race
From: Alasdair G Kergon <agk@redhat.com>

There is a race between dev_create() and find_device().

If the mdptr has not yet been stored against a device, find_device() needs to
behave as though no device was found.  It already returns NULL, but there is a
dm_put() missing: it must drop the reference dm_get_md() took.

The bug was introduced by dm-fix-mapped-device-ref-counting.patch.

It manifests itself if another dm ioctl attempts to reference a newly-created
device while the device creation ioctl is still running.  The consequence is
that the device cannot be removed until the machine is rebooted.  Certain udev
configurations can lead to this happening.

Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Cc: <dm-devel@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/md/dm-ioctl.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN drivers/md/dm-ioctl.c~dm-fix-find_device-race drivers/md/dm-ioctl.c
--- a/drivers/md/dm-ioctl.c~dm-fix-find_device-race
+++ a/drivers/md/dm-ioctl.c
@@ -606,9 +606,14 @@ static struct hash_cell *__find_device_h
 		return __get_name_cell(param->name);
 
 	md = dm_get_md(huge_decode_dev(param->dev));
-	if (md)
-		mdptr = dm_get_mdptr(md);
+	if (!md)
+		goto out;
 
+	mdptr = dm_get_mdptr(md);
+	if (!mdptr)
+		dm_put(md);
+
+out:
 	return mdptr;
 }
 
_

Patches currently in -mm which might be from agk@redhat.com are

origin.patch
struct-path-rename-dms-struct-path.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
