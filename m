From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [PATCH 1/6] dm raid45 target: export region hash
	functions and add a needed one
Date: Thu, 02 Jul 2009 14:52:10 +0200
Message-ID: <1246539130.20207.12.camel@o>
References: <4a368301.KBrCZcokAm87BF/S%heinzm@redhat.com>
	<20090616140914.GA3348@infradead.org> <1245163906.28257.113.camel@o>
	<e9c3a7c20906161055g6434ffd8uc7fc1ca53950556@mail.gmail.com>
	<1245179467.4278.11.camel@o> <19000.8388.899607.749942@notabene.brown>
	<19002.60755.876186.489524@notabene.brown>
	<1245407630.12264.66.camel@o>
	<19006.8756.925105.737041@notabene.brown> <1245697837.7390.456.camel@o>
Reply-To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-vpZ8J/V6fafon2bxUcAd"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1245697837.7390.456.camel@o>
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
Cc: Christoph Hellwig <hch@infradead.org>, Dan Williams <dan.j.williams@intel.com>, Ed Ciechanowski <ed.ciechanowski@intel.com>
List-Id: dm-devel.ids


--=-vpZ8J/V6fafon2bxUcAd
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Mon, 2009-06-22 at 21:10 +0200, Heinz Mauelshagen wrote:
> On Sun, 2009-06-21 at 22:06 +1000, Neil Brown wrote:
> > On Friday June 19, heinzm@redhat.com wrote:
> > > On Fri, 2009-06-19 at 11:43 +1000, Neil Brown wrote:
> > > > On Wednesday June 17, neilb@suse.de wrote:
> > > > > 
> > > > > I will try to find time to review your dm-raid5 code with a view to
> > > > > understanding how it plugs in to dm, and then how the md/raid5 engine
> > > > > can be used by dm-raid5.
> > > 
> > > Hi Neil.
> > > 
> > > > 
> > > > I've had a bit of a look through the dm-raid5 patches.
> > > 
> > > Thanks.
> > > 
> > > > 
> > > > Some observations:
> > > > 
> > > > - You have your own 'xor' code against which you do a run-time test of
> > > >   the 'xor_block' code which md/raid5 uses - then choose the fasted.
> > > >   This really should not be necessary.  If you have xor code that runs
> > > >   faster than anything in xor_block, it really would be best to submit
> > > >   it for inclusion in the common xor code base.
> > > 
> > > This is in because it actually shows better performance regularly by
> > > utilizing cache lines etc. more efficiently (tested on Intel, AMD and
> > > Sparc).
> > > 
> > > If xor_block would always have been performed best, I'd dropped that
> > > optimization already.
<SNIP>

Dan, Neil,

like mentioned before I left to LinuxTag last week, here comes an initial
take on dm-raid45 warm/cold CPU cache xor speed optimization metrics.

This shall give us the base to decide to keep or drop the dm-raid45
internal xor optimization magic or move (part of) it into the crypto
subsystem.

Heinz


Howto:
------
I added a loop to walk the list of recovery stripes to dm-raid45.c
in xor_optimize() to allow for over committing the cache and some variables
to be able to display absolute minimum and maximum xor runs performed plus
the number of xor runs achieved per cycle for xor_blocks() and for the dm-raid45
build in xor optimization.

In order to make results more deterministic, I run xor_speed() for <= 5 ticks.

See diff vs. dm-devel dm-raid45 patch (submitted Jun 15th) attached.

Tests being performed on the following 2 systems:

   hostname: a4
   2.6.31-rc1@250HZ timer frequency
   Core i7 920@3.4GHz, 8 MB 3rd Level Cache
   6GB RAM

   hostname: t4
   2.6.31-rc1@250HZ timer frequency
   2 CPU Opeteron 280@2.4GHz, 2*1 MB 2nd Level Cache
   2GB RAM

with the xor optimization being the only load on the systems.


I've performed test runs on each of those with the following mapping tables
and 128 iterations for each of them, which represents a small array case
with 3 drives per set, running the xor optimization on a single core:

Intel:
0 58720256 raid45 core 2 8192 nosync  raid5_la 7 -1 -1 -1 512 10 nosync 1  3 -1 /dev/mapper/error1 0 /dev/mapper/error2 0 /dev/mapper/error3 0
...
0 58720256 raid45 core 2 8192 nosync  raid5_la 7 -1 -1 -1 512 10 nosync 13  3 -1 /dev/mapper/error1 0 /dev/mapper/error2 0 /dev/mapper/error3 0

Opteron:
0 58720256 raid45 core 2 8192 nosync  raid5_la 7 -1 -1 -1 256 10 nosync 1  3 -1 /dev/mapper/error1 0 /dev/mapper/error2 0 /dev/mapper/error3 0
...
0 58720256 raid45 core 2 8192 nosync  raid5_la 7 -1 -1 -1 256 10 nosync 13  3 -1 /dev/mapper/error1 0 /dev/mapper/error2 0 /dev/mapper/error3 0


Because no actual IO is being performed, I just mapped to error targets
(table used: "0 2199023255552 error"; I know it's large but it ain't matter).

The number following the 2nd nosync parameter is the amount of recovery
stripes with io size of 512 sectors = 256 kilobytes per chunk or
256 sectors = 128 kilobytes per chunk respectively.
I.e. a work set of 768/384 kilobytes per recovery stripe.
These values shall make sure, that results differ in the per mille range
(i.e. more than 100 cycles per test run) where appropriate.


Systems are running out of cache at
~ >= 8 stripes on the Intel (8192 - 2048 code / (512 / 2) / 3)
and
~ >= 0 stripes on the Opteron system (1024 - 768 code) / (256 / 2) / 3).
assuming some cache utilization for code and other data.

See raw kernel log extracts being created by these test runs attached
in a tarball and the script to extract the metrics as well.


Intel results with 128 iterations each:
---------------------------------------

1 stripe  : NB:10 111/80 HM:118 111/82
2 stripes : NB:25 113/87 HM:103 112/91
3 stripes : NB:24 115/93 HM:104 114/93
4 stripes : NB:48 114/93 HM:80 114/93
5 stripes : NB:38 113/94 HM:90 114/94
6 stripes : NB:25 116/94 HM:103 114/94
7 stripes : NB:25 115/95 HM:103 115/95
8 stripes : NB:62 117/96 HM:66 116/95 <<<--- cold cache starts here
9 stripes : NB:66 117/96 HM:62 116/95
10 stripes: NB:73 117/96 HM:55 114/95
11 stripes: NB:63 114/96 HM:65 112/95
12 stripes: NB:51 111/96 HM:77 110/95
13 stripes: NB:65 109/96 HM:63 112/95

NB: number of xor_blocks() parity calculations winning per 128 iterations
HM: number of dm-raid45 xor() parity calculations equal to/winning
    xor_blocks per 128 iterations
NN/MM: count of maximm/minimum calculations achived per iteration in <= 5 ticks.

Opteron results with 128 iterations each:
-----------------------------------------
1 stripe  : NB:0 30/20 HM:128 64/53
2 stripes : NB:0 31/21 HM:128 68/55
3 stripes : NB:0 31/22 HM:128 68/57
4 stripes : NB:0 32/22 HM:128 70/61
5 stripes : NB:0 32/22 HM:128 70/63
6 stripes : NB:0 35/22 HM:128 70/64
7 stripes : NB:0 32/23 HM:128 69/63
8 stripes : NB:0 44/23 HM:128 76/65
9 stripes : NB:0 43/23 HM:128 73/65
10 stripes: NB:0 35/23 HM:128 72/64
11 stripes: NB:0 35/24 HM:128 72/64
12 stripes: NB:0 33/24 HM:128 72/65
13 stripes: NB:0 33/23 HM:128 71/64


Test analysis:
--------------
I must have done something wrong ;-)

On the Opteron, dm-raid45 xor() outperforms xor_blocks() by far.
No warm cache significance visible.

On the Intel, dm-raid45 xor() performs slightly better on warm cache
vs. xor_blocks() performing slightly better on cold cache, which may be
the result of the lag of prefetching in dm-raid45 xor().
xor_blocks() achieves a slightly better maximum in 8 / 13 runs vs.
xor() in 2 test runs. in 3 runs they achieve the same maximum.

This is not deterministic:
min/max varying by up to > 200% on the Opteron
and up to 46% on the Intel.


Questions/Recommendations:
--------------------------
Review the code changes and the data analysis please.

Review the test cases and argue if those are valid
or recommend different ones please.

Can we get this more deterministic (e.g. use prefetching for dm-raid45 xor()) ?

Regards,
Heinz


--=-vpZ8J/V6fafon2bxUcAd
Content-Disposition: attachment; filename="xor_performance_metrics"
Content-Type: application/x-shellscript; name="xor_performance_metrics"
Content-Transfer-Encoding: 7bit

#!/bin/sh
#
# Extract dm-raid45 xor performamce metrics from saved kernel log.
#

trap "rm NB_$$.tmp HM_$$.tmp NB_$$.tmp1 HM_$$.tmp1" 1 2 3 15
cmd=$(basename $0)
log_file=$1
if [ -z "$log_file" ]
then
	echo "$cmd log_file"
	exit 1
fi

iter=$(wc -l $log_file)

grep NB $log_file > NB_$$.tmp
grep HM $log_file > HM_$$.tmp
nb=$(wc -l NB_$$.tmp | cut -d ' ' -f 1)
hm=$(wc -l HM_$$.tmp | cut -d ' ' -f 1)

# Extract xor_block() metrics and get max/min
sed 's/.*blocks=//;s/ hm=.*//' NB_$$.tmp | sort -n > NB_$$.tmp1
nb_max=$(tail -1 NB_$$.tmp1)
nb_min=$(head -1 NB_$$.tmp1)

# Extract dm-raid45 xor() metrics and get max/min
sed 's/.*hm=//;s/ max=.*//' HM_$$.tmp | sort -n > HM_$$.tmp1
hm_max=$(tail -1 HM_$$.tmp1)
hm_min=$(head -1 HM_$$.tmp1)

echo "$iter: NB:$nb $nb_max/$nb_min HM:$hm $hm_max/$hm_min"
kill $$

--=-vpZ8J/V6fafon2bxUcAd
Content-Disposition: attachment; filename="dm-raid45-2.6.31-rc1.patch"
Content-Type: text/x-patch; name="dm-raid45-2.6.31-rc1.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

 {drivers => /usr/src/linux/drivers}/md/dm-raid45.c |  139 ++++++++++++++------
 1 files changed, 98 insertions(+), 41 deletions(-)

diff --git a/drivers/md/dm-raid45.c b/drivers/md/dm-raid45.c
index 0c33fea..6ace975 100644
--- a/drivers/md/dm-raid45.c
+++ b/linux/drivers/md/dm-raid45.c
@@ -8,7 +8,28 @@
  *
  * Linux 2.6 Device Mapper RAID4 and RAID5 target.
  *
- * Supports:
+ * Tested-by: Intel; Marcin.Labun@intel.com, krzysztof.wojcik@intel.com
+ *
+ *
+ * Supports the following ATARAID vendor solutions (and SNIA DDF):
+ *
+ * 	Adaptec HostRAID ASR
+ * 	SNIA DDF1
+ * 	Hiphpoint 37x
+ * 	Hiphpoint 45x
+ *	Intel IMSM
+ *	Jmicron ATARAID
+ *	LSI Logic MegaRAID
+ *	NVidia RAID
+ *	Promise FastTrack
+ *	Silicon Image Medley
+ *	VIA Software RAID
+ *
+ * via the dmraid application.
+ *
+ *
+ * Features:
+ *
  *	o RAID4 with dedicated and selectable parity device
  *	o RAID5 with rotating parity (left+right, symmetric+asymmetric)
  *	o recovery of out of sync device for initial
@@ -37,7 +58,7 @@
  * ANALYZEME: recovery bandwidth
  */ 
 
-static const char *version = "v0.2594p";
+static const char *version = "v0.2596l";
 
 #include "dm.h"
 #include "dm-memcache.h"
@@ -101,9 +122,6 @@ static const char *version = "v0.2594p";
 /* Check value in range. */
 #define	range_ok(i, min, max)	(i >= min && i <= max)
 
-/* Check argument is power of 2. */
-#define POWER_OF_2(a) (!(a & (a - 1)))
-
 /* Structure access macros. */
 /* Derive raid_set from stripe_cache pointer. */
 #define	RS(x)	container_of(x, struct raid_set, sc)
@@ -1848,10 +1866,10 @@ struct xor_func {
 	xor_function_t f;
 	const char *name;
 } static xor_funcs[] = {
-	{ xor_8,   "xor_8"  },
-	{ xor_16,  "xor_16" },
-	{ xor_32,  "xor_32" },
 	{ xor_64,  "xor_64" },
+	{ xor_32,  "xor_32" },
+	{ xor_16,  "xor_16" },
+	{ xor_8,   "xor_8"  },
 	{ xor_blocks_wrapper, "xor_blocks" },
 };
 
@@ -3114,10 +3132,10 @@ static void _do_endios(struct raid_set *rs, struct stripe *stripe,
 		SetStripeReconstructed(stripe);
 
 		/* FIXME: reschedule to be written in case of read. */
-		// if (!RSDead && RSDegraded(rs) !StripeRBW(stripe)) {
-		// 	chunk_set(CHUNK(stripe, stripe->idx.recover), DIRTY);
-		// 	stripe_chunks_rw(stripe);
-		// }
+		/* if (!RSDead && RSDegraded(rs) !StripeRBW(stripe)) {
+			chunk_set(CHUNK(stripe, stripe->idx.recover), DIRTY);
+			stripe_chunks_rw(stripe);
+		} */
 
 		stripe->idx.recover = -1;
 	}
@@ -3257,7 +3275,7 @@ static void do_ios(struct raid_set *rs, struct bio_list *ios)
 		/* Check for recovering regions. */
 		sector = _sector(rs, bio);
 		r = region_state(rs, sector, DM_RH_RECOVERING);
-		if (unlikely(r && bio_data_dir(bio) == WRITE)) {
+		if (unlikely(r)) {
 			delay++;
 			/* Wait writing to recovering regions. */
 			dm_rh_delay_by_region(rh, bio,
@@ -3409,64 +3427,104 @@ static unsigned mbpers(struct raid_set *rs, unsigned speed)
 /*
  * Discover fastest xor algorithm and # of chunks combination.
  */
-/* Calculate speed for algorithm and # of chunks. */
+/* Calculate speed of particular algorithm and # of chunks. */
 static unsigned xor_speed(struct stripe *stripe)
 {
+	int ticks = 5;
 	unsigned r = 0;
-	unsigned long j;
 
-	/* Wait for next tick. */
-	for (j = jiffies; j == jiffies; )
-		;
+	/* Do xors for a few ticks. */
+	while (ticks--) {
+		unsigned xors = 0;
+		unsigned long j = jiffies;
+
+		while (j == jiffies) {
+			mb();
+			common_xor(stripe, stripe->io.size, 0, 0);
+			mb();
+			xors++;
+			mb();
+		}
 
-	/* Do xors for a full tick. */
-	for (j = jiffies; j == jiffies; ) {
-		mb();
-		common_xor(stripe, stripe->io.size, 0, 0);
-		mb();
-		r++;
+		if (xors > r)
+			r = xors;
 	}
 
 	return r;
 }
 
+/* Define for xor multi recovery stripe optimization runs. */
+#define DMRAID45_XOR_TEST
+
 /* Optimize xor algorithm for this RAID set. */
 static unsigned xor_optimize(struct raid_set *rs)
 {
-	unsigned chunks_max = 2, p = rs->set.raid_devs, speed_max = 0;
+	unsigned chunks_max = 2, p, speed_max = 0;
 	struct xor_func *f = ARRAY_END(xor_funcs), *f_max = NULL;
 	struct stripe *stripe;
+unsigned speed_hm = 0, speed_min = ~0, speed_xor_blocks = 0;
 
 	BUG_ON(list_empty(&rs->recover.stripes));
+#ifndef DMRAID45_XOR_TEST
 	stripe = list_first_entry(&rs->recover.stripes, struct stripe,
 				  lists[LIST_RECOVER]);
 
 	/* Must set uptodate so that xor() will belabour chunks. */
-	while (p--)
+	for (p = rs->set.raid_devs; p-- ;)
 		SetChunkUptodate(CHUNK(stripe, p));
+#endif
 
 	/* Try all xor functions. */
 	while (f-- > xor_funcs) {
 		unsigned speed;
 
-		/* Set actual xor function for common_xor(). */
-		rs->xor.f = f;
-		rs->xor.chunks = (f->f == xor_blocks_wrapper ?
-				  (MAX_XOR_BLOCKS + 1) : XOR_CHUNKS_MAX) + 1;
-
-		while (rs->xor.chunks-- > 2) {
-			speed = xor_speed(stripe);
-			if (speed > speed_max) {
-				speed_max = speed;
-				chunks_max = rs->xor.chunks;
-				f_max = f;
+#ifdef DMRAID45_XOR_TEST
+		list_for_each_entry(stripe, &rs->recover.stripes,
+				    lists[LIST_RECOVER]) {
+				for (p = rs->set.raid_devs; p-- ;)
+					SetChunkUptodate(CHUNK(stripe, p));
+#endif
+	
+			/* Set actual xor function for common_xor(). */
+			rs->xor.f = f;
+			rs->xor.chunks = (f->f == xor_blocks_wrapper ?
+					  (MAX_XOR_BLOCKS + 1) :
+					  XOR_CHUNKS_MAX) + 1;
+	
+			while (rs->xor.chunks-- > 2) {
+				speed = xor_speed(stripe);
+
+#ifdef DMRAID45_XOR_TEST
+				if (f->f == xor_blocks_wrapper) {
+					if (speed > speed_xor_blocks)
+						speed_xor_blocks = speed;
+				} else if (speed > speed_hm)
+					speed_hm = speed;
+	
+				if (speed < speed_min)
+					speed_min = speed;
+#endif
+
+				if (speed > speed_max) {
+					speed_max = speed;
+					chunks_max = rs->xor.chunks;
+					f_max = f;
+				}
 			}
+#ifdef DMRAID45_XOR_TEST
 		}
+#endif
 	}
 
-	/* Memorize optimum parameters. */
+	/* Memorize optimal parameters. */
 	rs->xor.f = f_max;
 	rs->xor.chunks = chunks_max;
+#ifdef DMRAID45_XOR_TEST
+	DMINFO("%s stripes=%u min=%u xor_blocks=%u hm=%u max=%u",
+	       speed_max == speed_hm ? "HM" : "NB",
+	       rs->recover.recovery_stripes, speed_min,
+	       speed_xor_blocks, speed_hm, speed_max);
+#endif
 	return speed_max;
 }
 
@@ -3786,7 +3844,7 @@ static int get_raid_variable_parms(struct dm_target *ti, char **argv,
 		  "Invalid recovery switch; must be \"sync\" or \"nosync\"" },
 		{ 0,
 		  "Invalid number of recovery stripes;"
-		  "must be -1, > 0 and <= 16384",
+		  "must be -1, > 0 and <= 64",
 		  RECOVERY_STRIPES_MIN, RECOVERY_STRIPES_MAX,
 		  &vp->recovery_stripes_parm, &vp->recovery_stripes, NULL },
 	}, *varp;
@@ -3831,7 +3889,7 @@ static int get_raid_variable_parms(struct dm_target *ti, char **argv,
 
 		if (sscanf(*(argv++), "%d", &value) != 1 ||
 		    (value != -1 &&
-		     ((varp->action && !POWER_OF_2(value)) ||
+		     ((varp->action && !is_power_of_2(value)) ||
 		      !range_ok(value, varp->min, varp->max))))
 			TI_ERR(varp->errmsg);
 

--=-vpZ8J/V6fafon2bxUcAd
Content-Disposition: attachment; filename="xor_optomize_test_data.tar.bz2"
Content-Type: application/x-bzip-compressed-tar;
	name="xor_optomize_test_data.tar.bz2"
Content-Transfer-Encoding: base64

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
FCQkgyrSwC==


--=-vpZ8J/V6fafon2bxUcAd
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--=-vpZ8J/V6fafon2bxUcAd--
