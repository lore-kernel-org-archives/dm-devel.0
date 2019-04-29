From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH] dm mpath: parse_path: always free
	attached_handler_name
Date: Mon, 29 Apr 2019 11:48:15 +0200
Message-ID: <20190429094815.29827-1-mwilck@suse.com>
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
To: Yufen Yu <yuyufen@huawei.com>, Mike Snitzer <snitzer@redhat.com>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Commit b592211c33f7 "dm mpath: fix attached_handler_name leak and
dangling hw_handler_name pointer" fixed a memory leak for the
case where setup_scsi_dh() returns failure. But setup_scsi_dh
may return success and not "use" attached_handler_name if the
retain_attached_hwhandler flag is not set on the map. As
setup_scsi_sh properly "steals" the pointer by nullifying it,
freeing it unconditionally in parse_path() is safe.

Fixes: b592211c33f7 "dm mpath: fix attached_handler_name leak and
dangling hw_handler_name pointer"
Reported-by: Yufen Yu <yuyufen@huawei.com>

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 drivers/md/dm-mpath.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 2ee5e35..cc5173d 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -882,6 +882,7 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
 	if (attached_handler_name || m->hw_handler_name) {
 		INIT_DELAYED_WORK(&p->activate_path, activate_path_work);
 		r = setup_scsi_dh(p->path.dev->bdev, m, &attached_handler_name, &ti->error);
+		kfree(attached_handler_name);
 		if (r) {
 			dm_put_device(ti, p->path.dev);
 			goto bad;
@@ -896,7 +897,6 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
 
 	return p;
  bad:
-	kfree(attached_handler_name);
 	free_pgpath(p);
 	return ERR_PTR(r);
 }
-- 
2.21.0
