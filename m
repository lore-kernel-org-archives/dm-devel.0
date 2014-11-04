From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH] dm-thin: Change couple of DMWARN() to pr_debug()
Date: Tue, 4 Nov 2014 12:54:37 -0500
Message-ID: <20141104175437.GA14026@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Right now we use DMWARN to output a message on console if thin/snap device
creation fails. It has two problems.

- First of all this is not a warning and an error. In case of error, just
  returning code to user space should be good enough. If we need some debug
  info out, then a better choice will be pr_debug() which can be enabled
  when the need be.

- dm-thin expects users to keep track of already used device id. If an
  application tries to reuse the id, then -EEXIST is returned but this
  message is also displayed on console.

[17991.140135] device-mapper: thin: Creation of new snapshot 33 of device 3 failed

Docker does not keep track of already used device ids. Instead it starts from
0 and keeps on incrementing this id and retrying till it succeeds. And that
leads to flooding console with above messages.

I think it is better to just return error code to user space and not give
any warning. Instead convert this into pr_debug() so that if need be one
can enable it dynamically using debugfs and get some debug data out on a
running system.

One can enable all pr_debug() in dm-thin.c file using following.

echo 'file dm-thin.c +p' > /sys/kernel/debug/dynamic_debug/control 

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 drivers/md/dm-thin.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/md/dm-thin.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-thin.c	2014-11-04 10:05:43.504600136 -0500
+++ linux-2.6/drivers/md/dm-thin.c	2014-11-04 10:15:48.984908908 -0500
@@ -4,6 +4,8 @@
  * This file is released under the GPL.
  */
 
+#define pr_fmt(fmt)     "device-mapper: thin: " fmt
+
 #include "dm-thin-metadata.h"
 #include "dm-bio-prison.h"
 #include "dm.h"
@@ -2819,7 +2821,7 @@ static int process_create_thin_mesg(unsi
 
 	r = dm_pool_create_thin(pool->pmd, dev_id);
 	if (r) {
-		DMWARN("Creation of new thinly-provisioned device with id %s failed.",
+		pr_debug("Creation of new thinly-provisioned device with id %s failed.",
 		       argv[1]);
 		return r;
 	}
@@ -2847,7 +2849,7 @@ static int process_create_snap_mesg(unsi
 
 	r = dm_pool_create_snap(pool->pmd, dev_id, origin_dev_id);
 	if (r) {
-		DMWARN("Creation of new snapshot %s of device %s failed.",
+		pr_debug("Creation of new snapshot %s of device %s failed.",
 		       argv[1], argv[2]);
 		return r;
 	}
