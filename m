From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH v2 1/1] block: fix blk_queue_split() resource
 exhaustion
Date: Fri, 6 Jan 2017 11:50:45 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1701061139160.13944@file01.intranet.prod.int.rdu2.redhat.com>
References: <1467990243-3531-1-git-send-email-lars.ellenberg@linbit.com> <1467990243-3531-2-git-send-email-lars.ellenberg@linbit.com> <20160711141042.GY13335@soda.linbit> <76d9bf14-d848-4405-8358-3771c0a93d39@profitbricks.com> <20161223114553.GP4138@soda.linbit>
 <CA+res+SjL6FrYWMroB-xjBO5gyz9pca6FQCy-arr7+4RQHeJGw@mail.gmail.com> <878tqrmmqx.fsf@notabene.neil.brown.name> <20170104185046.GA982@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170104185046.GA982@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: NeilBrown <neilb@suse.com>, Jack Wang <jack.wang.usish@gmail.com>, Lars Ellenberg <lars.ellenberg@linbit.com>, Jens Axboe <axboe@kernel.dk>, linux-raid <linux-raid@vger.kernel.org>, Michael Wang <yun.wang@profitbricks.com>, Peter Zijlstra <peterz@infradead.org>, Jiri Kosina <jkosina@suse.cz>, Ming Lei <ming.lei@canonical.com>, linux-kernel@vger.kernel.org, Zheng Liu <gnehzuil.liu@gmail.com>, linux-block@vger.kernel.org, Takashi Iwai <tiwai@suse.de>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Alasdair Kergon <agk@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Keith Busch <keith.busch@intel.com>, device-mapper development <dm-devel@redhat.com>, Shaohua Li <shli@kernel.org>, Kent
List-Id: dm-devel.ids



On Wed, 4 Jan 2017, Mike Snitzer wrote:

> On Wed, Jan 04 2017 at 12:12am -0500,
> NeilBrown <neilb@suse.com> wrote:
> 
> > On Tue, Jan 03 2017, Jack Wang wrote:
> > 
> > > 2016-12-23 12:45 GMT+01:00 Lars Ellenberg <lars.ellenberg@linbit.com>:
> > >> On Fri, Dec 23, 2016 at 09:49:53AM +0100, Michael Wang wrote:
> > >>> Dear Maintainers
> > >>>
> > >>> I'd like to ask for the status of this patch since we hit the
> > >>> issue too during our testing on md raid1.
> > >>>
> > >>> Split remainder bio_A was queued ahead, following by bio_B for
> > >>> lower device, at this moment raid start freezing, the loop take
> > >>> out bio_A firstly and deliver it, which will hung since raid is
> > >>> freezing, while the freezing never end since it waiting for
> > >>> bio_B to finish, and bio_B is still on the queue, waiting for
> > >>> bio_A to finish...
> > >>>
> > >>> We're looking for a good solution and we found this patch
> > >>> already progressed a lot, but we can't find it on linux-next,
> > >>> so we'd like to ask are we still planning to have this fix
> > >>> in upstream?
> > >>
> > >> I don't see why not, I'd even like to have it in older kernels,
> > >> but did not have the time and energy to push it.
> > >>
> > >> Thanks for the bump.
> > >>
> > >>         Lars
> > >>
> > > Hi folks,
> > >
> > > As Michael mentioned, we hit a bug this patch is trying to fix.
> > > Neil suggested another way to fix it.  I attached below.
> > > I personal prefer Neil's version as it's less code change, and straight forward.
> > >
> > > Could you share your comments, we can get one fix into mainline.
> > >
> > > Thanks,
> > > Jinpu
> > > From 69a4829a55503e496ce9c730d2c8e3dd8a08874a Mon Sep 17 00:00:00 2001
> > > From: NeilBrown <neilb@suse.com>
> > > Date: Wed, 14 Dec 2016 16:55:52 +0100
> > > Subject: [PATCH] block: fix deadlock between freeze_array() and wait_barrier()
> > >
> > > When we call wait_barrier, we might have some bios waiting
> > > in current->bio_list, which prevents the array_freeze call to
> > > complete. Those can only be internal READs, which have already
> > > passed the wait_barrier call (thus incrementing nr_pending), but
> > > still were not submitted to the lower level, due to generic_make_request
> > > logic to avoid recursive calls. In such case, we have a deadlock:
> > > - array_frozen is already set to 1, so wait_barrier unconditionally waits, so
> > > - internal READ bios will not be submitted, thus freeze_array will
> > > never completes.
> > >
> > > To fix this, modify generic_make_request to always sort bio_list_on_stack
> > > first with lowest level, then higher, until same level.
> > >
> > > Sent to linux-raid mail list:
> > > https://marc.info/?l=linux-raid&m=148232453107685&w=2
> > >
> > 
> > This should probably also have
> > 
> >   Inspired-by: Lars Ellenberg <lars.ellenberg@linbit.com>
> > 
> > or something that, as I was building on Lars' ideas when I wrote this.
> > 
> > It would also be worth noting in the description that this addresses
> > issues with dm and drbd as well as md.
> 
> I never saw this patch but certainly like the relative simplicity of the
> solution when compared with other approaches taken, e.g. (5 topmost
> commits on this branch):
> http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/log/?h=wip
> 
> > In fact, I think that with this patch in place, much of the need for the
> > rescue_workqueue won't exist any more.  I cannot promise it can be
> > removed completely, but it should be to hard to make it optional and
> > only enabled for those few block devices that will still need it.
> > The rescuer should only be needed for a bioset which can be allocated
> > From twice in the one call the ->make_request_fn.  This would include
> > raid0 for example, though raid0_make_reqest could be re-written to not
> > use a loop and to just call generic_make_request(bio) if bio != split.
> 
> > > Suggested-by: NeilBrown <neilb@suse.com>
> > > Signed-off-by: Jack Wang <jinpu.wang@profitbricks.com>
> > > ---
> > >  block/blk-core.c | 20 ++++++++++++++++++++
> > >  1 file changed, 20 insertions(+)
> > >
> > > diff --git a/block/blk-core.c b/block/blk-core.c
> > > index 9e3ac56..47ef373 100644
> > > --- a/block/blk-core.c
> > > +++ b/block/blk-core.c
> > > @@ -2138,10 +2138,30 @@ blk_qc_t generic_make_request(struct bio *bio)
> > >  		struct request_queue *q = bdev_get_queue(bio->bi_bdev);
> > >  
> > >  		if (likely(blk_queue_enter(q, __GFP_DIRECT_RECLAIM) == 0)) {
> > > +			struct bio_list lower, same, hold;
> > > +
> > > +			/* Create a fresh bio_list for all subordinate requests */
> > > +			bio_list_init(&hold);
> > > +			bio_list_merge(&hold, &bio_list_on_stack);
> > > +			bio_list_init(&bio_list_on_stack);
> > >  
> > >  			ret = q->make_request_fn(q, bio);
> > >  
> > >  			blk_queue_exit(q);
> > > +			/* sort new bios into those for a lower level
> > > +			 * and those for the same level
> > > +			 */
> > > +			bio_list_init(&lower);
> > > +			bio_list_init(&same);
> > > +			while ((bio = bio_list_pop(&bio_list_on_stack)) != NULL)
> > > +				if (q == bdev_get_queue(bio->bi_bdev))
> > > +					bio_list_add(&same, bio);
> > > +				else
> > > +					bio_list_add(&lower, bio);
> > > +			/* now assemble so we handle the lowest level first */
> > > +			bio_list_merge(&bio_list_on_stack, &lower);
> > > +			bio_list_merge(&bio_list_on_stack, &same);
> > > +			bio_list_merge(&bio_list_on_stack, &hold);
> > >  
> > >  			bio = bio_list_pop(current->bio_list);
> > >  		} else {
> > > -- 
> > > 2.7.4
> 
> Mikulas, would you be willing to try the below patch with the
> dm-snapshot deadlock scenario and report back on whether it fixes that?
> 
> Patch below looks to be the same as here:
> https://marc.info/?l=linux-raid&m=148232453107685&q=p3
> 
> Neil and/or others if that isn't the patch that should be tested please
> provide a pointer to the latest.
> 
> Thanks,
> Mike

The bad news is that this doesn't fix the snapshot deadlock.

I created a test program for the snapshot deadlock bug (it was originally 
created years ago to test for a different bug, so it contains some cruft). 
You also need to insert "if (ci->sector_count) msleep(100);" to the end of 
__split_and_process_non_flush to make the kernel sleep when splitting the 
bio.

And with the above above patch, the snapshot deadlock bug still happens.

Mikulas


#define _XOPEN_SOURCE 500
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>
#include <errno.h>
#include <malloc.h>
#include <pthread.h>
#include <asm/unistd.h>

/*
 * Change "VG" symbol to a volume group name that you are using.
 *
 * You must apply this patch to the kernel to trigger the bug:
 * Index: linux-4.10-rc2/drivers/md/dm.c
 * ===================================================================
 * --- linux-4.10-rc2.orig/drivers/md/dm.c
 * +++ linux-4.10-rc2/drivers/md/dm.c
 * @@ -1223,6 +1223,9 @@ static int __split_and_process_non_flush
 *         ci->sector += len;
 *         ci->sector_count -= len;
 * 
 * +       if (ci->sector_count)
 * +               msleep(100);
 * +
 *         return 0;
 *  }
 * 
 */

#define VG		"vg1"
#define LV		"test_lv"
#define LV_SNAP		"test_snap"
#define MEGABYTES	"12"
#define SNAP_MEGABYTES	"16"
#define THREADS		1
#define BS		4096
#define SKEW		512
#define ORIG_PATTERN	'p'
#define NEW_PATTERN	'n'

enum {
	IOPRIO_CLASS_NONE,
	IOPRIO_CLASS_RT,
	IOPRIO_CLASS_BE,
	IOPRIO_CLASS_IDLE,
};

enum {
	IOPRIO_WHO_PROCESS = 1,
	IOPRIO_WHO_PGRP,
	IOPRIO_WHO_USER,
};

#define IOPRIO_CLASS_SHIFT	13

static inline int ioprio_set(int which, int who, int ioprio)
{
	return syscall(__NR_ioprio_set, which, who, ioprio);
}

static inline int ioprio_get(int which, int who)
{
	return syscall(__NR_ioprio_get, which, who);
}

#define PRIO_READER	((IOPRIO_CLASS_IDLE << IOPRIO_CLASS_SHIFT) | 0xff)
#define PRIO_WRITER	(IOPRIO_CLASS_RT << IOPRIO_CLASS_SHIFT)

static void do_cmd(char *cmd, int ign_err)
{
	int r;
	fprintf(stderr, "* %s\n", cmd);
	r = system(cmd);
	if (r) {
		if (r == -1) {
			perror("system");
		} else {
			if (ign_err) return;
			fprintf(stderr, "return code %x\n", r);
		}
		exit(1);
	}
}

static char pattern[BS];

static int h_orig, h_snap;
static int n;
static long long test_of;
static pthread_rwlock_t rw_lock_1;
static pthread_rwlock_t rw_lock_2;
static pthread_rwlock_t rw_lock_3;
static volatile int started = 0;

static void pthread_error(int r)
{
	fprintf(stderr, "pthread_error: %s\n", strerror(r));
	exit(1);
}

static void *test_read(long long of)
{
	int r;
	char *t = memalign(BS, BS);
	if (!t) perror("memalign"), exit(1);
	if ((r = pread(h_snap, t, BS, of)) != BS) {
		fprintf(stderr, "can't read (%d): %s\n", r, strerror(errno));
		exit(1);
	}
	if (memcmp(pattern, t, BS)) {
		int i;
		for (i = 0; i < BS; i++) if (t[i] != pattern[i]) break;
		fprintf(stderr, "!!!! SNAPSHOT VOLUME DAMAGE AT BLOCK OFFSET %llX, BYTE OFFSET %X: %02x != %02x\n", of, i, (unsigned char)t[i], (unsigned char)pattern[i]);
		exit(2);
	}
	free(t);
	return NULL;
}

static void *test_thread(void *_)
{
	int r;
	_ = _;
	//fprintf(stderr, "start\n");
	if ((r = ioprio_set(IOPRIO_WHO_PROCESS, 0, PRIO_READER))) perror("ioprio_set"), exit(1);
	if ((r = pthread_rwlock_rdlock(&rw_lock_2))) pthread_error(r);
	started = 1;
	if ((r = ioprio_get(IOPRIO_WHO_PROCESS, 0)) != PRIO_READER) {
		if (r == -1) perror("ioprio_get");
		else fprintf(stderr, "reader priority not set: %x\n", r);
		exit(1);
	}
	again:
	if ((r = pthread_rwlock_rdlock(&rw_lock_1))) pthread_error(r);
	if ((r = pthread_rwlock_unlock(&rw_lock_2))) pthread_error(r);
	if (test_of == -1) {
		if ((r = pthread_rwlock_unlock(&rw_lock_1))) pthread_error(r);
		//fprintf(stderr, "return\n");
		return NULL;
	}
	//fprintf(stderr, "test(%lld)\n", test_of);
	test_read(test_of);
	if ((r = pthread_rwlock_rdlock(&rw_lock_3))) pthread_error(r);
	if ((r = pthread_rwlock_unlock(&rw_lock_1))) pthread_error(r);
	if ((r = pthread_rwlock_rdlock(&rw_lock_2))) pthread_error(r);
	if ((r = pthread_rwlock_unlock(&rw_lock_3))) pthread_error(r);
	goto again;
}

int main(void)
{
	int i, j, r;
	char *np;
	pthread_t thr[THREADS];

	memset(pattern, ORIG_PATTERN, sizeof pattern);

	do_cmd("lvremove -f "VG"/"LV_SNAP"", 1);
	do_cmd("lvremove -f "VG"/"LV"", 1);
	do_cmd("lvcreate -L "MEGABYTES" -n "LV" "VG"", 0);

	h_orig = open("/dev/mapper/"VG"-"LV"", O_RDWR);
	if (h_orig < 0) perror("open orig"), exit(1);
	if (lseek(h_orig, SKEW, SEEK_SET) == -1) perror("lseek"), exit(1);
	n = 0;
	while (write(h_orig, pattern, BS) == BS) {
		n++;
		fprintf(stderr, "creating %llx...\r", (long long)n * BS + SKEW);
	}
	if (fsync(h_orig)) perror("fsync"), exit(1);
	fprintf(stderr,"\n");
	lseek(h_orig, 0, SEEK_SET);
	close(h_orig);

	do_cmd("lvcreate -L "SNAP_MEGABYTES" -n "LV_SNAP" -s "VG"/"LV"", 0);

	h_orig = open("/dev/mapper/"VG"-"LV"", O_RDWR | O_DIRECT);
	if (h_orig < 0) perror("open orig"), exit(1);

	h_snap = open("/dev/mapper/"VG"-"LV_SNAP"", O_RDONLY | O_DIRECT);
	if (h_snap < 0) perror("open snap"), exit(1);

	if ((r = pthread_rwlock_init(&rw_lock_1, NULL))) pthread_error(r);
	if ((r = pthread_rwlock_init(&rw_lock_2, NULL))) pthread_error(r);
	if ((r = pthread_rwlock_init(&rw_lock_3, NULL))) pthread_error(r);
	if ((r = pthread_rwlock_wrlock(&rw_lock_1))) pthread_error(r);
	if ((r = pthread_rwlock_wrlock(&rw_lock_3))) pthread_error(r);

	if ((r = ioprio_set(IOPRIO_WHO_PROCESS, 0, PRIO_WRITER))) perror("ioprio_set"), exit(1);

	for (j = 0; j < THREADS; j++) {
		if ((r = pthread_create(&thr[j], NULL, test_thread, NULL))) pthread_error(r);
	}
	while (!started) usleep(1000);

	if ((r = ioprio_get(IOPRIO_WHO_PROCESS, 0)) != PRIO_WRITER) {
		if (r == -1) perror("ioprio_get");
		else fprintf(stderr, "writer priority not set: %x\n", r);
		exit(1);
	}

	np = memalign(BS, BS);
	if (!np) perror("memalign"), exit(1);
	memset(np, NEW_PATTERN, BS);
	for (i = 0; i < n; i++) {
		test_of = (off_t)i * BS + SKEW;
		fprintf(stderr, "testing %llx...\r", test_of);
		if ((r = pthread_rwlock_unlock(&rw_lock_1))) pthread_error(r);
		sched_yield();
		if (pwrite(h_orig, np, BS, test_of) != BS) {
			fprintf(stderr, "can't write (%d): %s\n", r, strerror(errno));
			exit(1);
		}
		if ((r = pthread_rwlock_wrlock(&rw_lock_2))) pthread_error(r);
		if ((r = pthread_rwlock_unlock(&rw_lock_3))) pthread_error(r);
		if ((r = pthread_rwlock_wrlock(&rw_lock_1))) pthread_error(r);
		if ((r = pthread_rwlock_unlock(&rw_lock_2))) pthread_error(r);
		if ((r = pthread_rwlock_wrlock(&rw_lock_3))) pthread_error(r);
	}
	fprintf(stderr,"\n");

	test_of = -1;
	if ((r = pthread_rwlock_unlock(&rw_lock_1))) pthread_error(r);

	for (j = 0; j < THREADS; j++) {
		if ((r = pthread_join(thr[j], NULL))) pthread_error(r);
	}

	fprintf(stderr, "TEST PASSED OK.\n");

	return 0;
}

