From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 1/2] dm-kcopyd: introduce per-module throttle
 structure
Date: Thu, 2 Jun 2011 15:16:32 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1106021514260.25649@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1105311802330.9322@hs20-bc2-1.build.redhat.com>
	<4DE5D9C6.1050504@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4DE5D9C6.1050504@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ankit Jain <jankit@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids



On Wed, 1 Jun 2011, Ankit Jain wrote:

> Just some comments, inline -
> 
> On 06/01/2011 03:33 AM, Mikulas Patocka wrote:
> > Hi
> > 
> > Here I'm sending new kcopyd throttling patches that allow the throttle to 
> > be set per module (i.e. one throttle for mirror and the other for 
> > snapshots).
> > 
> > Mikulas
> > 
> > ---
> > 
> > dm-kcopyd: introduce per-module throttle structure
> > 
> > The structure contains the throttle parameter (it could be set in
> > /sys/module/*/parameters and auxulary variables for activity counting.
> > 
> > The throttle does nothing, it will be activated in the next patch.
> > 
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > 
> > ---
> >  drivers/md/dm-kcopyd.c    |    2 +-
> >  drivers/md/dm-raid1.c     |    5 ++++-
> >  drivers/md/dm-snap.c      |    5 ++++-
> >  include/linux/dm-kcopyd.h |   15 ++++++++++++++-
> >  4 files changed, 23 insertions(+), 4 deletions(-)
> > 
> > Index: linux-2.6.39-fast/drivers/md/dm-kcopyd.c
> > ===================================================================
> > --- linux-2.6.39-fast.orig/drivers/md/dm-kcopyd.c	2011-05-31 23:46:18.000000000 +0200
> > +++ linux-2.6.39-fast/drivers/md/dm-kcopyd.c	2011-05-31 23:49:47.000000000 +0200
> > @@ -617,7 +617,7 @@ int kcopyd_cancel(struct kcopyd_job *job
> >  /*-----------------------------------------------------------------
> >   * Client setup
> >   *---------------------------------------------------------------*/
> > -struct dm_kcopyd_client *dm_kcopyd_client_create(void)
> > +struct dm_kcopyd_client *dm_kcopyd_client_create(struct dm_kcopyd_throttle *throttle)
> 
> IMHO, the other patch should be the first one, and this change should be
> part of it. Basically, the first patch should add throttle support and
> the related infrastructure for using it, and the second one can add
> *usage/declaration* of those throttles in raid1/snapshot etc.
> 
> [...]
> >  {
> >  	int r = -ENOMEM;
> >  	struct dm_kcopyd_client *kc;
> > Index: linux-2.6.39-fast/drivers/md/dm-raid1.c
> > ===================================================================
> > --- linux-2.6.39-fast.orig/drivers/md/dm-raid1.c	2011-05-31 23:46:18.000000000 +0200
> > +++ linux-2.6.39-fast/drivers/md/dm-raid1.c	2011-05-31 23:46:22.000000000 +0200
> > @@ -83,6 +83,9 @@ struct mirror_set {
> >  	struct mirror mirror[0];
> >  };
> >  
> > +dm_kcopyd_throttle_declare(raid1_resync_throttle,
> > +		"A percentage of time allocated for raid resynchronization");
> > +
> >  static void wakeup_mirrord(void *context)
> >  {
> >  	struct mirror_set *ms = context;
> > @@ -1115,7 +1118,7 @@ static int mirror_ctr(struct dm_target *
> >  		goto err_destroy_wq;
> >  	}
> >  
> > -	ms->kcopyd_client = dm_kcopyd_client_create();
> > +	ms->kcopyd_client = dm_kcopyd_client_create(&dm_kcopyd_throttle);
> 
> IMHO, its not very clear where the dm_kcopyd_throttle variable here,
> comes from, until you find the definition for dm_kcopyd_throttle_declare.
> 
> >  	if (IS_ERR(ms->kcopyd_client)) {
> >  		r = PTR_ERR(ms->kcopyd_client);
> >  		goto err_destroy_wq;
> > Index: linux-2.6.39-fast/drivers/md/dm-snap.c
> > ===================================================================
> > --- linux-2.6.39-fast.orig/drivers/md/dm-snap.c	2011-05-31 23:46:18.000000000 +0200
> > +++ linux-2.6.39-fast/drivers/md/dm-snap.c	2011-05-31 23:46:22.000000000 +0200
> > @@ -135,6 +135,9 @@ struct dm_snapshot {
> >  #define RUNNING_MERGE          0
> >  #define SHUTDOWN_MERGE         1
> >  
> > +dm_kcopyd_throttle_declare(snapshot_copy_throttle,
> > +		"A percentage of time allocated for copy on write");
> > +
> >  struct dm_dev *dm_snap_origin(struct dm_snapshot *s)
> >  {
> >  	return s->origin;
> > @@ -1111,7 +1114,7 @@ static int snapshot_ctr(struct dm_target
> >  		goto bad_hash_tables;
> >  	}
> >  
> > -	s->kcopyd_client = dm_kcopyd_client_create();
> > +	s->kcopyd_client = dm_kcopyd_client_create(&dm_kcopyd_throttle);
> >  	if (IS_ERR(s->kcopyd_client)) {
> >  		r = PTR_ERR(s->kcopyd_client);
> >  		ti->error = "Could not create kcopyd client";
> > Index: linux-2.6.39-fast/include/linux/dm-kcopyd.h
> > ===================================================================
> > --- linux-2.6.39-fast.orig/include/linux/dm-kcopyd.h	2011-05-31 23:46:18.000000000 +0200
> > +++ linux-2.6.39-fast/include/linux/dm-kcopyd.h	2011-05-31 23:46:22.000000000 +0200
> > @@ -21,11 +21,24 @@
> >  
> >  #define DM_KCOPYD_IGNORE_ERROR 1
> >  
> > +struct dm_kcopyd_throttle {
> > +	unsigned throttle;
> > +	unsigned long num_io_jobs;
> > +	unsigned io_period;
> > +	unsigned total_period;
> > +	unsigned last_jiffies;
> > +};
> > +
> > +#define dm_kcopyd_throttle_declare(name, description)	\
> > +static struct dm_kcopyd_throttle dm_kcopyd_throttle = { 100, 0, 0, 0, 0 }; \
> > +module_param_named(name, dm_kcopyd_throttle.throttle, uint, 0644); \
> > +MODULE_PARM_DESC(name, description)
> > +
> 
> I'm just trying to understand, how is it determined, when to use macros
> with UPPER_CASE_LETTERS and when otherwise. To me, UPPER_CASE_LETTERS
> makes it very clear that I'm using a macro, and since this seems to be
> doing declaration etc also, that would seem helpful. But I don't know
> the general style or reasoning followed in the kernel, hence the question.
> 
> >  /*
> >   * To use kcopyd you must first create a dm_kcopyd_client object.
> >   */
> >  struct dm_kcopyd_client;
> > -struct dm_kcopyd_client *dm_kcopyd_client_create(void);
> > +struct dm_kcopyd_client *dm_kcopyd_client_create(struct dm_kcopyd_throttle *throttle);
> >  void dm_kcopyd_client_destroy(struct dm_kcopyd_client *kc);
> >  
> >  /*
> > 
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> > 
> 
> Thanks,
> -- 
> Ankit Jain
> SUSE Labs

Hi

This is the updated patch with macro name in capital letters.

I think the order of patches doesn't matter much, the result will be the 
same anyway.

Mikulas

---

dm-kcopyd: introduce per-module throttle structure

The structure contains the throttle parameter (it could be set in
/sys/module/*/parameters and auxulary variables for activity counting.

The throttle does nothing, it will be activated in the next patch.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-kcopyd.c    |    2 +-
 drivers/md/dm-raid1.c     |    5 ++++-
 drivers/md/dm-snap.c      |    5 ++++-
 include/linux/dm-kcopyd.h |   15 ++++++++++++++-
 4 files changed, 23 insertions(+), 4 deletions(-)

Index: linux-2.6.39-fast/drivers/md/dm-kcopyd.c
===================================================================
--- linux-2.6.39-fast.orig/drivers/md/dm-kcopyd.c	2011-05-31 23:46:18.000000000 +0200
+++ linux-2.6.39-fast/drivers/md/dm-kcopyd.c	2011-05-31 23:49:47.000000000 +0200
@@ -617,7 +617,7 @@ int kcopyd_cancel(struct kcopyd_job *job
 /*-----------------------------------------------------------------
  * Client setup
  *---------------------------------------------------------------*/
-struct dm_kcopyd_client *dm_kcopyd_client_create(void)
+struct dm_kcopyd_client *dm_kcopyd_client_create(struct dm_kcopyd_throttle *throttle)
 {
 	int r = -ENOMEM;
 	struct dm_kcopyd_client *kc;
Index: linux-2.6.39-fast/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.39-fast.orig/drivers/md/dm-raid1.c	2011-05-31 23:46:18.000000000 +0200
+++ linux-2.6.39-fast/drivers/md/dm-raid1.c	2011-05-31 23:46:22.000000000 +0200
@@ -83,6 +83,9 @@ struct mirror_set {
 	struct mirror mirror[0];
 };
 
+DECLARE_DM_KCOPYD_THROTTLE(raid1_resync_throttle,
+		"A percentage of time allocated for raid resynchronization");
+
 static void wakeup_mirrord(void *context)
 {
 	struct mirror_set *ms = context;
@@ -1115,7 +1118,7 @@ static int mirror_ctr(struct dm_target *
 		goto err_destroy_wq;
 	}
 
-	ms->kcopyd_client = dm_kcopyd_client_create();
+	ms->kcopyd_client = dm_kcopyd_client_create(&dm_kcopyd_throttle);
 	if (IS_ERR(ms->kcopyd_client)) {
 		r = PTR_ERR(ms->kcopyd_client);
 		goto err_destroy_wq;
Index: linux-2.6.39-fast/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.39-fast.orig/drivers/md/dm-snap.c	2011-05-31 23:46:18.000000000 +0200
+++ linux-2.6.39-fast/drivers/md/dm-snap.c	2011-05-31 23:46:22.000000000 +0200
@@ -135,6 +135,9 @@ struct dm_snapshot {
 #define RUNNING_MERGE          0
 #define SHUTDOWN_MERGE         1
 
+DECLARE_DM_KCOPYD_THROTTLE(snapshot_copy_throttle,
+		"A percentage of time allocated for copy on write");
+
 struct dm_dev *dm_snap_origin(struct dm_snapshot *s)
 {
 	return s->origin;
@@ -1111,7 +1114,7 @@ static int snapshot_ctr(struct dm_target
 		goto bad_hash_tables;
 	}
 
-	s->kcopyd_client = dm_kcopyd_client_create();
+	s->kcopyd_client = dm_kcopyd_client_create(&dm_kcopyd_throttle);
 	if (IS_ERR(s->kcopyd_client)) {
 		r = PTR_ERR(s->kcopyd_client);
 		ti->error = "Could not create kcopyd client";
Index: linux-2.6.39-fast/include/linux/dm-kcopyd.h
===================================================================
--- linux-2.6.39-fast.orig/include/linux/dm-kcopyd.h	2011-05-31 23:46:18.000000000 +0200
+++ linux-2.6.39-fast/include/linux/dm-kcopyd.h	2011-05-31 23:46:22.000000000 +0200
@@ -21,11 +21,24 @@
 
 #define DM_KCOPYD_IGNORE_ERROR 1
 
+struct dm_kcopyd_throttle {
+	unsigned throttle;
+	unsigned long num_io_jobs;
+	unsigned io_period;
+	unsigned total_period;
+	unsigned last_jiffies;
+};
+
+#define DECLARE_DM_KCOPYD_THROTTLE(name, description)	\
+static struct dm_kcopyd_throttle dm_kcopyd_throttle = { 100, 0, 0, 0, 0 }; \
+module_param_named(name, dm_kcopyd_throttle.throttle, uint, 0644); \
+MODULE_PARM_DESC(name, description)
+
 /*
  * To use kcopyd you must first create a dm_kcopyd_client object.
  */
 struct dm_kcopyd_client;
-struct dm_kcopyd_client *dm_kcopyd_client_create(void);
+struct dm_kcopyd_client *dm_kcopyd_client_create(struct dm_kcopyd_throttle *throttle);
 void dm_kcopyd_client_destroy(struct dm_kcopyd_client *kc);
 
 /*
