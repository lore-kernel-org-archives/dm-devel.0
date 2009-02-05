From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [PATCH] dm-path-selector: fix refcount corruption
Date: Thu, 05 Feb 2009 21:51:01 +0900
Message-ID: <498AE0B5.5050709@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
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
To: device-mapper development <dm-devel@redhat.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
List-Id: dm-devel.ids

Hi,

Refcounting of path-selector module is not safe in SMP environment.
The counter may corrupt and trigger BUG() like this:
  kernel BUG at linux-2.6.29-rc3/drivers/md/dm-path-selector.c:90!
though it's rare under normal usage.

The bug is here:
  void dm_put_path_selector(struct path_selector_type *pst)
  {
  ...
        down_read(&_ps_lock);
        psi = __find_path_selector_type(pst->name);
        if (!psi)
                goto out;

        if (--psi->use == 0)
                module_put(psi->pst.module);

        BUG_ON(psi->use < 0);

The code manipulates the counter without exclusive lock or atomic ops.
So if 2 processors come in, the counter may corrupt.

While it could be fixed using atomic ops for the counter manipulation,
we can just drop the 'use' counter like Cheng Renquan did for dm-target:
https://www.redhat.com/archives/dm-devel/2008-December/msg00075.html

(Actually, without his patch, dm-target.c hits the same problem.)

This is a simple reproducer. Change "dev" for your environment.
(In my experiment, it used to take hours to reproduce the problem.)
-------------------------------------------------------------------
#!/bin/sh

dev=/dev/sda11
tab1="0 100 multipath 0 0 1 1 round-robin 0 1 1 $dev 10"
tab2="0 100 multipath 0 0 1 1 round-robin 0 1 1 $dev 20"

function runtest() {
  local map=$1

  echo $tab1 | dmsetup create $map
  while true; do
    echo $tab2 | dmsetup load $map
    dmsetup resume $map
    echo $tab1 | dmsetup load $map
    dmsetup resume $map
  done
}

runtest m1 &
runtest m1 &
-------------------------------------------------------------------

-- 
Jun'ichi Nomura, NEC Corporation


Fix refcount corruption in dm-path-selector

Refcounting with non-atomic ops under shared lock will corrupt the counter
in multi-processor system and may trigger BUG_ON().
Use module refcount.
# same approach as dm-target-use-module-refcount-directly.patch here
# https://www.redhat.com/archives/dm-devel/2008-December/msg00075.html

Typical oops:
  kernel BUG at linux-2.6.29-rc3/drivers/md/dm-path-selector.c:90!
  Pid: 11148, comm: dmsetup Not tainted 2.6.29-rc3-nm #1
  dm_put_path_selector+0x4d/0x61 [dm_multipath]
  Call Trace:
   [<ffffffffa031d3f9>] free_priority_group+0x33/0xb3 [dm_multipath]
   [<ffffffffa031d4aa>] free_multipath+0x31/0x67 [dm_multipath]
   [<ffffffffa031d50d>] multipath_dtr+0x2d/0x32 [dm_multipath]
   [<ffffffffa015d6c2>] dm_table_destroy+0x64/0xd8 [dm_mod]
   [<ffffffffa015b73a>] __unbind+0x46/0x4b [dm_mod]
   [<ffffffffa015b79f>] dm_swap_table+0x60/0x14d [dm_mod]
   [<ffffffffa015f963>] dev_suspend+0xfd/0x177 [dm_mod]
   [<ffffffffa0160250>] dm_ctl_ioctl+0x24c/0x29c [dm_mod]
   [<ffffffff80288cd3>] ? get_page_from_freelist+0x49c/0x61d
   [<ffffffffa015f866>] ? dev_suspend+0x0/0x177 [dm_mod]
   [<ffffffff802bf05c>] vfs_ioctl+0x2a/0x77
   [<ffffffff802bf4f1>] do_vfs_ioctl+0x448/0x4a0
   [<ffffffff802bf5a0>] sys_ioctl+0x57/0x7a
   [<ffffffff8020c05b>] system_call_fastpath+0x16/0x1b

Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 dm-path-selector.c |   21 +++------------------
 1 file changed, 3 insertions(+), 18 deletions(-)

Index: linux-2.6.29-rc2/drivers/md/dm-path-selector.c
===================================================================
--- linux-2.6.29-rc2.orig/drivers/md/dm-path-selector.c
+++ linux-2.6.29-rc2/drivers/md/dm-path-selector.c
@@ -17,9 +17,7 @@
 
 struct ps_internal {
 	struct path_selector_type pst;
-
 	struct list_head list;
-	long use;
 };
 
 #define pst_to_psi(__pst) container_of((__pst), struct ps_internal, pst)
@@ -45,12 +43,8 @@ static struct ps_internal *get_path_sele
 
 	down_read(&_ps_lock);
 	psi = __find_path_selector_type(name);
-	if (psi) {
-		if ((psi->use == 0) && !try_module_get(psi->pst.module))
-			psi = NULL;
-		else
-			psi->use++;
-	}
+	if (psi && !try_module_get(psi->pst.module))
+		psi = NULL;
 	up_read(&_ps_lock);
 
 	return psi;
@@ -84,11 +78,7 @@ void dm_put_path_selector(struct path_se
 	if (!psi)
 		goto out;
 
-	if (--psi->use == 0)
-		module_put(psi->pst.module);
-
-	BUG_ON(psi->use < 0);
-
+	module_put(psi->pst.module);
 out:
 	up_read(&_ps_lock);
 }
@@ -136,11 +126,6 @@ int dm_unregister_path_selector(struct p
 		return -EINVAL;
 	}
 
-	if (psi->use) {
-		up_write(&_ps_lock);
-		return -ETXTBSY;
-	}
-
 	list_del(&psi->list);
 
 	up_write(&_ps_lock);
