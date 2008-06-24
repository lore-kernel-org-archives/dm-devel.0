From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] dm-mpath: propage path errors up through the
	multipath ctr function
Date: Tue, 24 Jun 2008 14:51:35 -0500
Message-ID: <20080624195135.GB9546@ether.msp.redhat.com>
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
To: dm-devel@redhat.com
Cc: agk@redhat.com
List-Id: dm-devel.ids

This patch allows path errors from the multipath ctr function to
propagate up to userspace as errno values from the ioctl() call.

This is in response to
https://www.redhat.com/archives/dm-devel/2008-May/msg00000.html
and
https://bugzilla.redhat.com/show_bug.cgi?id=444421

The patch only lets through the errors that it needs to, in order to
get the path errors from parse_path().  It's possible that there are
other errors worth progatating that this leaves out.

The patch was built against the  2.6.26-rc3 kernel.

-Ben

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 dm-mpath.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

Index: linux-2.6.25.i686/drivers/md/dm-mpath.c
===================================================================
--- linux-2.6.25.i686.orig/drivers/md/dm-mpath.c
+++ linux-2.6.25.i686/drivers/md/dm-mpath.c
@@ -555,12 +555,12 @@ static struct pgpath *parse_path(struct 
 	/* we need at least a path arg */
 	if (as->argc < 1) {
 		ti->error = "no device given";
-		return NULL;
+		return ERR_PTR(-EINVAL);
 	}
 
 	p = alloc_pgpath();
 	if (!p)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	r = dm_get_device(ti, shift(as), ti->begin, ti->len,
 			  dm_table_get_mode(ti->table), &p->path.dev);
@@ -579,7 +579,7 @@ static struct pgpath *parse_path(struct 
 
  bad:
 	free_pgpath(p);
-	return NULL;
+	return ERR_PTR(r);
 }
 
 static struct priority_group *parse_priority_group(struct arg_set *as,
@@ -598,13 +598,13 @@ static struct priority_group *parse_prio
 	if (as->argc < 2) {
 		as->argc = 0;
 		ti->error = "not enough priority group aruments";
-		return NULL;
+		return ERR_PTR(-EINVAL);
 	}
 
 	pg = alloc_priority_group();
 	if (!pg) {
 		ti->error = "couldn't allocate priority group";
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	}
 	pg->m = m;
 
@@ -635,8 +635,10 @@ static struct priority_group *parse_prio
 		path_args.argv = as->argv;
 
 		pgpath = parse_path(&path_args, &pg->ps, ti);
-		if (!pgpath)
+		if (IS_ERR(pgpath)){
+			r = PTR_ERR(pgpath);
 			goto bad;
+		}
 
 		pgpath->pg = pg;
 		list_add_tail(&pgpath->list, &pg->pgpaths);
@@ -647,7 +649,7 @@ static struct priority_group *parse_prio
 
  bad:
 	free_priority_group(pg, ti);
-	return NULL;
+	return ERR_PTR(r);
 }
 
 static int parse_hw_handler(struct arg_set *as, struct multipath *m)
@@ -778,8 +780,8 @@ static int multipath_ctr(struct dm_targe
 		struct priority_group *pg;
 
 		pg = parse_priority_group(&as, m);
-		if (!pg) {
-			r = -EINVAL;
+		if (IS_ERR(pg)) {
+			r = PTR_ERR(pg);
 			goto bad;
 		}
 
