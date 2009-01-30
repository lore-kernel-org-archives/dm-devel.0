From: "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>
Subject: RE: [RFC PATCH 1/2] dm-mpath: interface change for
	preparation
Date: Fri, 30 Jan 2009 10:12:07 +0530
Message-ID: <0D1E8821739E724A86F4D16902CE275C13FF9B0272@inbmail01.lsi.com>
References: <49815665.1040701@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49815665.1040701@ct.jp.nec.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Alasdair G Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Kiyoshi/Alasdair,

Just a thought. As we are changing __choose_pgpath parameters in this pat=
ch, will it be good to use BIO rather than nr_bytes as parameter? Availab=
ility of BIO in loadbalancing interface can provide more flexibility for =
coming up with new load balancing in future.


Thanks,
Vijay

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] On=
 Behalf Of Kiyoshi Ueda
Sent: Thursday, January 29, 2009 12:40 PM
To: device-mapper development
Subject: [dm-devel] [RFC PATCH 1/2] dm-mpath: interface change for prepar=
ation

This patch changes path selector interfaces for service-time oriented dyn=
amic load balancer.

To calculate the service time for an incoming I/O correctly, the load bal=
ancer needs the size of the incoming I/O when selecting the next path.


Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/md/dm-mpath.c         |   27 ++++++++++++++++-----------
 drivers/md/dm-path-selector.h |    9 ++++++---
 drivers/md/dm-queue-length.c  |    8 +++++---
 drivers/md/dm-round-robin.c   |    2 +-
 4 files changed, 28 insertions(+), 18 deletions(-)

Index: 2.6.29-rc2/drivers/md/dm-mpath.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- 2.6.29-rc2.orig/drivers/md/dm-mpath.c
+++ 2.6.29-rc2/drivers/md/dm-mpath.c
@@ -103,6 +103,7 @@ struct multipath {
 struct dm_mpath_io {
        struct pgpath *pgpath;
        struct dm_bio_details details;
+       size_t nr_bytes;
 };

 typedef int (*action_fn) (struct pgpath *pgpath); @@ -251,11 +252,12 @@ =
static void __switch_pg(struct multipath
        m->pg_init_count =3D 0;
 }

-static int __choose_path_in_pg(struct multipath *m, struct priority_grou=
p *pg)
+static int __choose_path_in_pg(struct multipath *m, struct priority_grou=
p *pg,
+                              size_t nr_bytes)
 {
        struct dm_path *path;

-       path =3D pg->ps.type->select_path(&pg->ps, &m->repeat_count);
+       path =3D pg->ps.type->select_path(&pg->ps, &m->repeat_count,
+ nr_bytes);
        if (!path)
                return -ENXIO;

@@ -267,7 +269,7 @@ static int __choose_path_in_pg(struct mu
        return 0;
 }

-static void __choose_pgpath(struct multipath *m)
+static void __choose_pgpath(struct multipath *m, size_t nr_bytes)
 {
        struct priority_group *pg;
        unsigned bypassed =3D 1;
@@ -279,12 +281,12 @@ static void __choose_pgpath(struct multi
        if (m->next_pg) {
                pg =3D m->next_pg;
                m->next_pg =3D NULL;
-               if (!__choose_path_in_pg(m, pg))
+               if (!__choose_path_in_pg(m, pg, nr_bytes))
                        return;
        }

        /* Don't change PG until it has no remaining paths */
-       if (m->current_pg && !__choose_path_in_pg(m, m->current_pg))
+       if (m->current_pg && !__choose_path_in_pg(m, m->current_pg,
+ nr_bytes))
                return;

        /*
@@ -296,7 +298,7 @@ static void __choose_pgpath(struct multi
                list_for_each_entry(pg, &m->priority_groups, list) {
                        if (pg->bypassed =3D=3D bypassed)
                                continue;
-                       if (!__choose_path_in_pg(m, pg))
+                       if (!__choose_path_in_pg(m, pg, nr_bytes))
                                return;
                }
        } while (bypassed--);
@@ -327,6 +329,7 @@ static int map_io(struct multipath *m, s
                  struct dm_mpath_io *mpio, unsigned was_queued)  {
        int r =3D DM_MAPIO_REMAPPED;
+       size_t nr_bytes =3D bio->bi_size;
        unsigned long flags;
        struct pgpath *pgpath;

@@ -335,7 +338,7 @@ static int map_io(struct multipath *m, s
        /* Do we need to select a new pgpath? */
        if (!m->current_pgpath ||
            (!m->queue_io && (m->repeat_count && --m->repeat_count =3D=3D=
 0)))
-               __choose_pgpath(m);
+               __choose_pgpath(m, nr_bytes);

        pgpath =3D m->current_pgpath;

@@ -360,9 +363,11 @@ static int map_io(struct multipath *m, s
                r =3D -EIO;       /* Failed */

        mpio->pgpath =3D pgpath;
+       mpio->nr_bytes =3D nr_bytes;

        if (r =3D=3D DM_MAPIO_REMAPPED && pgpath->pg->ps.type->start_io)
-               pgpath->pg->ps.type->start_io(&pgpath->pg->ps, &pgpath->p=
ath);
+               pgpath->pg->ps.type->start_io(&pgpath->pg->ps, &pgpath->p=
ath,
+                                             nr_bytes);

        spin_unlock_irqrestore(&m->lock, flags);

@@ -441,7 +446,7 @@ static void process_queued_ios(struct wo
                goto out;

        if (!m->current_pgpath)
-               __choose_pgpath(m);
+               __choose_pgpath(m, 1 << 19); /* Assume 512 KB */

        pgpath =3D m->current_pgpath;

@@ -1199,7 +1204,7 @@ static int multipath_end_io(struct dm_ta
        if (pgpath) {
                ps =3D &pgpath->pg->ps;
                if (ps->type->end_io)
-                       ps->type->end_io(ps, &pgpath->path);
+                       ps->type->end_io(ps, &pgpath->path,
+ mpio->nr_bytes);
        }
        if (r !=3D DM_ENDIO_INCOMPLETE)
                mempool_free(mpio, m->mpio_pool); @@ -1415,7 +1420,7 @@ s=
tatic int multipath_ioctl(struct dm_tar
        spin_lock_irqsave(&m->lock, flags);

        if (!m->current_pgpath)
-               __choose_pgpath(m);
+               __choose_pgpath(m, 1 << 19); /* Assume 512KB */

        if (m->current_pgpath) {
                bdev =3D m->current_pgpath->path.dev->bdev;
Index: 2.6.29-rc2/drivers/md/dm-path-selector.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- 2.6.29-rc2.orig/drivers/md/dm-path-selector.h
+++ 2.6.29-rc2/drivers/md/dm-path-selector.h
@@ -56,7 +56,8 @@ struct path_selector_type {
         * the path fails.
         */
        struct dm_path *(*select_path) (struct path_selector *ps,
-                                    unsigned *repeat_count);
+                                       unsigned *repeat_count,
+                                       size_t nr_bytes);

        /*
         * Notify the selector that a path has failed.
@@ -75,8 +76,10 @@ struct path_selector_type {
        int (*status) (struct path_selector *ps, struct dm_path *path,
                       status_type_t type, char *result, unsigned int max=
len);

-       int (*start_io) (struct path_selector *ps, struct dm_path *path);
-       int (*end_io) (struct path_selector *ps, struct dm_path *path);
+       int (*start_io) (struct path_selector *ps, struct dm_path *path,
+                        size_t nr_bytes);
+       int (*end_io) (struct path_selector *ps, struct dm_path *path,
+                      size_t nr_bytes);
 };

 /* Register a path selector */
Index: 2.6.29-rc2/drivers/md/dm-round-robin.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- 2.6.29-rc2.orig/drivers/md/dm-round-robin.c
+++ 2.6.29-rc2/drivers/md/dm-round-robin.c
@@ -161,7 +161,7 @@ static int rr_reinstate_path(struct path  }

 static struct dm_path *rr_select_path(struct path_selector *ps,
-                                  unsigned *repeat_count)
+                                     unsigned *repeat_count, size_t
+ nr_bytes)
 {
        struct selector *s =3D (struct selector *) ps->context;
        struct path_info *pi =3D NULL;
Index: 2.6.29-rc2/drivers/md/dm-queue-length.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- 2.6.29-rc2.orig/drivers/md/dm-queue-length.c
+++ 2.6.29-rc2/drivers/md/dm-queue-length.c
@@ -138,7 +138,7 @@ static int ql_reinstate_path(struct path  }

 static struct dm_path *ql_select_path(struct path_selector *ps,
-                                     unsigned *repeat_count)
+                                     unsigned *repeat_count, size_t
+ nr_bytes)
 {
        struct selector *s =3D (struct selector *) ps->context;
        struct path_info *pi =3D NULL, *best =3D NULL; @@ -166,7 +166,8 @=
@ static struct dm_path *ql_select_path(st
        return best->path;
 }

-static int ql_start_io(struct path_selector *ps, struct dm_path *path)
+static int ql_start_io(struct path_selector *ps, struct dm_path *path,
+                      size_t nr_bytes)
 {
        struct path_info *pi =3D path->pscontext;

@@ -175,7 +176,8 @@ static int ql_start_io(struct path_selec
        return 0;
 }

-static int ql_end_io(struct path_selector *ps, struct dm_path *path)
+static int ql_end_io(struct path_selector *ps, struct dm_path *path,
+                    size_t nr_bytes)
 {
        struct path_info *pi =3D path->pscontext;


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
