From: Jan Blunck <jblunck@suse.de>
Subject: [PATCH] Fix reference counting in
	__find_device_hash_cell()
Date: Thu, 26 Oct 2006 19:47:39 +0200
Message-ID: <20061026174739.GA4744@hasse.suse.de>
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
To: agk@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

When the device is created but it hasn't yet been inserted into the hash list
a concurrent call to __find_device_hash_cell() was failing to release the
reference to the mapped device.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 drivers/md/dm-ioctl.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.18/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.18.orig/drivers/md/dm-ioctl.c
+++ linux-2.6.18/drivers/md/dm-ioctl.c
@@ -608,6 +608,8 @@ static struct hash_cell *__find_device_h
 	md = dm_get_md(huge_decode_dev(param->dev));
 	if (md)
 		mdptr = dm_get_mdptr(md);
+	if (md && !mdptr)
+		dm_put(md);
 
 	return mdptr;
 }
