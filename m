From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH] dm mpath: move the dereference below the NULL test
Date: Fri, 7 Sep 2012 15:03:38 +0800
Message-ID: <CAPgLHd8Udm3DO9E3_kT3G-CpAyjmvsrWkGPoBuWEz=wW3uNfqA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: agk@redhat.com, neilb@suse.de
Cc: yongjun_wei@trendmicro.com.cn, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The dereference should be moved below the NULL test.

spatch with a semantic match is used to found this.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/md/dm-mpath.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index d8abb90..7b494e6 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1309,13 +1309,14 @@ static int multipath_end_io(struct dm_target *ti, struct request *clone,
 {
 	struct multipath *m = ti->private;
 	struct dm_mpath_io *mpio = map_context->ptr;
-	struct pgpath *pgpath = mpio->pgpath;
+	struct pgpath *pgpath;
 	struct path_selector *ps;
 	int r;
 
 	BUG_ON(!mpio);
 
 	r  = do_end_io(m, clone, error, mpio);
+	pgpath = mpio->pgpath;
 	if (pgpath) {
 		ps = &pgpath->pg->ps;
 		if (ps->type->end_io)

