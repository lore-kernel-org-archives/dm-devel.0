From: Alasdair G Kergon <agk@redhat.com>
Subject: [PATCH 2.6.19 1/5] dm: fix find_device race
Date: Tue, 7 Nov 2006 18:29:40 +0000
Message-ID: <20061107182940.GC6993@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrew Morton <akpm@osdl.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

There is a race between dev_create() and find_device().

If the mdptr has not yet been stored against a device,
find_device() needs to behave as though no device was
found.  It already returns NULL, but there is a dm_put()
missing: it must drop the reference dm_get_md() took.

The bug was introduced by dm-fix-mapped-device-ref-counting.patch.
 
It manifests itself if another dm ioctl attempts to reference a
newly-created device while the device creation ioctl is still running.
The consequence is that the device cannot be removed until the machine
is rebooted.  Certain udev configurations can lead to this happening.

Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com

Index: linux-2.6.19-rc4/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.19-rc4.orig/drivers/md/dm-ioctl.c	2006-11-07 17:06:30.000000000 +0000
+++ linux-2.6.19-rc4/drivers/md/dm-ioctl.c	2006-11-07 17:07:53.000000000 +0000
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
 
