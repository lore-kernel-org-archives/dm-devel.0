From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 1/3] dm: prevent access to md being deleted
Date: Tue, 08 Jun 2010 19:25:49 +0900
Message-ID: <4C0E1AAD.1050108@ct.jp.nec.com>
References: <4C0E19A0.1040804@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4C0E19A0.1040804@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This patch prevents access to mapped_device which is being deleted.

Currently, even after a mapped_device has been removed from the hash,
it could be accessed through idr_find() using minor number.
That could cause a race and NULL pointer reference below:
  CPU0                          CPU1
  ------------------------------------------------------------------
  dev_remove(param)
    down_write(_hash_lock)
    dm_lock_for_deletion(md)
      spin_lock(_minor_lock)
      set_bit(DMF_DELETING)
      spin_unlock(_minor_lock)
    __hash_remove(hc)
    up_write(_hash_lock)
                                dev_status(param)
                                  md = find_device(param)
                                         down_read(_hash_lock)
                                         __find_device_hash_cell(param)
                                           dm_get_md(param->dev)
                                             md = dm_find_md(dev)
                                                    spin_lock(_minor_lock)
                                                    md = idr_find(MINOR(dev))
                                                    spin_unlock(_minor_lock)
    dm_put(md)
      free_dev(md)
                                             dm_get(md)
                                         up_read(_hash_lock)
                                  __dev_status(md, param)
                                  dm_put(md)

This patch fixes such problems.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm.c |    1 +
 1 file changed, 1 insertion(+)

Index: 2.6.35-rc1/drivers/md/dm.c
===================================================================
--- 2.6.35-rc1.orig/drivers/md/dm.c
+++ 2.6.35-rc1/drivers/md/dm.c
@@ -2141,6 +2141,7 @@ static struct mapped_device *dm_find_md(
 	md = idr_find(&_minor_idr, minor);
 	if (md && (md == MINOR_ALLOCED ||
 		   (MINOR(disk_devt(dm_disk(md))) != minor) ||
+		   dm_deleting_md(md) ||
 		   test_bit(DMF_FREEING, &md->flags))) {
 		md = NULL;
 		goto out;
