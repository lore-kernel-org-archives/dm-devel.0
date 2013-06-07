From: Jonathan McDowell <noodles@earth.li>
Subject: [PATCH] Pass request position info to dm-mpath plugins
 (was: updated dm-switch)
Date: Fri, 7 Jun 2013 14:51:37 -0700
Message-ID: <20130607215137.GG23899@earth.li>
References: <Pine.LNX.4.64.1305221709160.22686@file.rdu.redhat.com>
	<20130606224518.GU19749@earth.li>
	<Pine.LNX.4.64.1306071214001.22600@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1306071214001.22600@file.rdu.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Jun 07, 2013 at 12:16:19PM -0400, Mikulas Patocka wrote:
> On Thu, 6 Jun 2013, Jonathan McDowell wrote:
> > On Wed, May 22, 2013 at 05:14:18PM -0400, Mikulas Patocka wrote:
> > 
> > > This is updated dm-switch. It has better documentation and better error
> > > reporting in message function.
> > ...
> > > ---
> > > 
> > > From: Jim Ramsay <jim_ramsay@dell.com>
> > > 
> > > dm-switch is a new target that maps IO to underlying block devices
> > > efficiently when there are a large number of fixed-sized address regions
> > > but there is no simple pattern to allow for a compact mapping
> > > representation such as dm-stripe.
> > 
> > Interesting. I have been working on something similar recently, for not
> > dissimilar reasons. However the approach I had been taking was to extend
> > __choose_pgpath to take a pos parameter indicating the block being
> > requested, and then add a new dm-pref-hint multipath driver, which
> > effectively does a round-robin but prefers any path that has the "pref"
> > bit. Currently the dm-pref-hint driver is extremely hacky and reaches
> > down into the scsi_device to do an appropriate CDB along each path to
> > get the pref-map, or I'd post it for comments.
> > 
> > I'm interested in why the decision was made to have dm-switch as a separate
> > device-mapper layer? Are there a corresponding set of patches to
> > multipath-tools which know how to do the setup of each individual path?
> > 
> 
> It is a separate target because it was originally developed as such by
> Dell.
> 
> It could be possible to turn it into a plugin to dm-mpath but that would
> require changes in the userspace code that is driving it.

Based on my own experience I would venture that the reason it was
developed as such is that currently there's no way to ship a dm-mpath
plugin that can achieve this, because the plugin interface doesn't have
the appropriate information (the request offset) to make the decision.
So if you want to ship something that'll work with whatever enterprise
kernel the server is running you have to layer on top.

I present the patch below as potential solution. It adds a pos parameter
providing this information, and is against 3.10-rc4.

I think this allows a cleaner solution. multipath-tools can continue to
manage the paths (including things like dealing ALUA infomation), and
then the underlying dm-mpath plugin gets to worry about which of the
deemed available paths is the best one to use for that particular
offset.

As a separate part, is there a way to feed information into a dm-mpath
plugin, after its up and running? I'd like to take my pref-hints driver
and make it suitable for submission too, but first I need a cleaner way
of getting it the information it needs than it reaching into the SCSI
layer.

Signed-Off-By: Jonathan McDowell <noodles@earth.li>

-----
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index bdf26f5..3cbf9d5 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -292,11 +292,11 @@ static void __switch_pg(struct multipath *m, struct pgpath *pgpath)
 }
 
 static int __choose_path_in_pg(struct multipath *m, struct priority_group *pg,
-			       size_t nr_bytes)
+			       size_t pos, size_t nr_bytes)
 {
 	struct dm_path *path;
 
-	path = pg->ps.type->select_path(&pg->ps, &m->repeat_count, nr_bytes);
+	path = pg->ps.type->select_path(&pg->ps, &m->repeat_count, pos, nr_bytes);
 	if (!path)
 		return -ENXIO;
 
@@ -308,7 +308,7 @@ static int __choose_path_in_pg(struct multipath *m, struct priority_group *pg,
 	return 0;
 }
 
-static void __choose_pgpath(struct multipath *m, size_t nr_bytes)
+static void __choose_pgpath(struct multipath *m, size_t pos, size_t nr_bytes)
 {
 	struct priority_group *pg;
 	unsigned bypassed = 1;
@@ -320,12 +320,12 @@ static void __choose_pgpath(struct multipath *m, size_t nr_bytes)
 	if (m->next_pg) {
 		pg = m->next_pg;
 		m->next_pg = NULL;
-		if (!__choose_path_in_pg(m, pg, nr_bytes))
+		if (!__choose_path_in_pg(m, pg, pos, nr_bytes))
 			return;
 	}
 
 	/* Don't change PG until it has no remaining paths */
-	if (m->current_pg && !__choose_path_in_pg(m, m->current_pg, nr_bytes))
+	if (m->current_pg && !__choose_path_in_pg(m, m->current_pg, pos, nr_bytes))
 		return;
 
 	/*
@@ -338,7 +338,7 @@ static void __choose_pgpath(struct multipath *m, size_t nr_bytes)
 		list_for_each_entry(pg, &m->priority_groups, list) {
 			if (pg->bypassed == bypassed)
 				continue;
-			if (!__choose_path_in_pg(m, pg, nr_bytes)) {
+			if (!__choose_path_in_pg(m, pg, pos, nr_bytes)) {
 				if (!bypassed)
 					m->pg_init_delay_retry = 1;
 				return;
@@ -373,6 +373,7 @@ static int map_io(struct multipath *m, struct request *clone,
 {
 	int r = DM_MAPIO_REMAPPED;
 	size_t nr_bytes = blk_rq_bytes(clone);
+	size_t pos = blk_rq_pos(clone);
 	unsigned long flags;
 	struct pgpath *pgpath;
 	struct block_device *bdev;
@@ -383,7 +384,7 @@ static int map_io(struct multipath *m, struct request *clone,
 	/* Do we need to select a new pgpath? */
 	if (!m->current_pgpath ||
 	    (!m->queue_io && (m->repeat_count && --m->repeat_count == 0)))
-		__choose_pgpath(m, nr_bytes);
+		__choose_pgpath(m, pos, nr_bytes);
 
 	pgpath = m->current_pgpath;
 
@@ -489,7 +490,7 @@ static void process_queued_ios(struct work_struct *work)
 	spin_lock_irqsave(&m->lock, flags);
 
 	if (!m->current_pgpath)
-		__choose_pgpath(m, 0);
+		__choose_pgpath(m, 0, 0);
 
 	pgpath = m->current_pgpath;
 
@@ -1569,7 +1570,7 @@ again:
 	spin_lock_irqsave(&m->lock, flags);
 
 	if (!m->current_pgpath)
-		__choose_pgpath(m, 0);
+		__choose_pgpath(m, 0, 0);
 
 	pgpath = m->current_pgpath;
 
diff --git a/drivers/md/dm-path-selector.h b/drivers/md/dm-path-selector.h
index e7d1fa8..e06839a 100644
--- a/drivers/md/dm-path-selector.h
+++ b/drivers/md/dm-path-selector.h
@@ -57,6 +57,7 @@ struct path_selector_type {
 	 */
 	struct dm_path *(*select_path) (struct path_selector *ps,
 					unsigned *repeat_count,
+					size_t pos,
 					size_t nr_bytes);
 
 	/*
diff --git a/drivers/md/dm-queue-length.c b/drivers/md/dm-queue-length.c
index 3941fae..b574fea1 100644
--- a/drivers/md/dm-queue-length.c
+++ b/drivers/md/dm-queue-length.c
@@ -169,7 +169,7 @@ static int ql_reinstate_path(struct path_selector *ps, struct dm_path *path)
  * Select a path having the minimum number of in-flight I/Os
  */
 static struct dm_path *ql_select_path(struct path_selector *ps,
-				      unsigned *repeat_count, size_t nr_bytes)
+				      unsigned *repeat_count, size_t pos, size_t nr_bytes)
 {
 	struct selector *s = ps->context;
 	struct path_info *pi = NULL, *best = NULL;
diff --git a/drivers/md/dm-round-robin.c b/drivers/md/dm-round-robin.c
index 6ab1192..5b57e07 100644
--- a/drivers/md/dm-round-robin.c
+++ b/drivers/md/dm-round-robin.c
@@ -163,7 +163,7 @@ static int rr_reinstate_path(struct path_selector *ps, struct dm_path *p)
 }
 
 static struct dm_path *rr_select_path(struct path_selector *ps,
-				      unsigned *repeat_count, size_t nr_bytes)
+				      unsigned *repeat_count, size_t pos, size_t nr_bytes)
 {
 	struct selector *s = (struct selector *) ps->context;
 	struct path_info *pi = NULL;
diff --git a/drivers/md/dm-service-time.c b/drivers/md/dm-service-time.c
index 9df8f6b..5ccf2d1 100644
--- a/drivers/md/dm-service-time.c
+++ b/drivers/md/dm-service-time.c
@@ -256,7 +256,7 @@ static int st_compare_load(struct path_info *pi1, struct path_info *pi2,
 }
 
 static struct dm_path *st_select_path(struct path_selector *ps,
-				      unsigned *repeat_count, size_t nr_bytes)
+				      unsigned *repeat_count, size_t pos, size_t nr_bytes)
 {
 	struct selector *s = ps->context;
 	struct path_info *pi = NULL, *best = NULL;
-----

J.

-- 
] http://www.earth.li/~noodles/ []   Mistakes aren't always regrets.   [
]  PGP/GPG Key @ the.earth.li   []                                     [
] via keyserver, web or email.  []                                     [
] RSA: 4096/2DA8B985            []                                     [
