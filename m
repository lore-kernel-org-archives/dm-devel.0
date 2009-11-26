From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 8/7] Hold all write bios in nosync region
Date: Thu, 26 Nov 2009 12:54:33 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0911261252260.28831@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0911180703410.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180709570.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180710370.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180711140.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180711510.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180712340.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180713150.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180718540.21358@hs20-bc2-1.build.redhat.com>
	<20091123055835.GA28981@us.ibm.com>
	<Pine.LNX.4.64.0911240638250.27545@hs20-bc2-1.build.redhat.com>
	<20091124191704.GB7971@us.ibm.com>
	<Pine.LNX.4.64.0911250807500.14481@hs20-bc2-1.build.redhat.com>
	<4B0D509E.9090001@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4B0D509E.9090001@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Takahiro Yasui <tyasui@redhat.com>
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids



On Wed, 25 Nov 2009, Takahiro Yasui wrote:

> On 11/25/09 08:19, Mikulas Patocka wrote:
> > 
> > 
> > On Tue, 24 Nov 2009, malahal@us.ibm.com wrote:
> > 
> >> I need to look at the code again, but I thought any new writes to a
> >> failed region go to a surviving leg. In that case, we end up returning
> >> I/O's to the application after writing to a single leg.
> > 
> > Writes always go to all the legs, see do_write(). Anyway, dmeventd removes 
> > the failed leg soon.
> 
> Is it correct? When the region is in the state of out of sync (NOSYNC), 
> I/Os are not processed by do_write() but generic_make_request() in the
> do_writes().

This is good point. Here I'm sending patch 8 (to be applied on the top of 
the rest of patches) that fixes it.

Mikulas

---

Hold all write bios when leg fails and errors are handled

When using dmeventd to handle errors, we must be held until dmeventd does
its job. This patch prevents the following race:
* primary leg fails
* write "1" fail, the write is held, secondary leg is set default
* write "2" goes straight to the secondary leg
*** crash *** (before dmeventd does its job)
* after a reboot, primary leg goes back online, it is resynchronized to
  the secondary leg, write "2" is reverted although it already completed

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-raid1.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

Index: linux-2.6.32-rc8-devel/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.32-rc8-devel.orig/drivers/md/dm-raid1.c	2009-11-26 17:26:26.000000000 +0100
+++ linux-2.6.32-rc8-devel/drivers/md/dm-raid1.c	2009-11-26 18:30:48.000000000 +0100
@@ -68,6 +68,7 @@ struct mirror_set {
 	region_t nr_regions;
 	int in_sync;
 	int log_failure;
+	int leg_failure;
 	atomic_t suspend;
 
 	atomic_t default_mirror;	/* Default mirror */
@@ -210,6 +211,8 @@ static void fail_mirror(struct mirror *m
 	struct mirror_set *ms = m->ms;
 	struct mirror *new;
 
+	ms->leg_failure = 1;
+
 	/*
 	 * error_count is used for nothing more than a
 	 * simple way to tell if a device has encountered
@@ -694,8 +697,12 @@ static void do_writes(struct mirror_set 
 		dm_rh_delay(ms->rh, bio);
 
 	while ((bio = bio_list_pop(&nosync))) {
-		map_bio(get_default_mirror(ms), bio);
-		generic_make_request(bio);
+		if (unlikely(ms->leg_failure) && errors_handled(ms))
+			hold_bio(ms, bio);
+		else {
+			map_bio(get_default_mirror(ms), bio);
+			generic_make_request(bio);
+		}
 	}
 }
 
@@ -816,6 +823,7 @@ static struct mirror_set *alloc_context(
 	ms->nr_regions = dm_sector_div_up(ti->len, region_size);
 	ms->in_sync = 0;
 	ms->log_failure = 0;
+	ms->leg_failure = 0;
 	atomic_set(&ms->suspend, 0);
 	atomic_set(&ms->default_mirror, DEFAULT_MIRROR);
 
