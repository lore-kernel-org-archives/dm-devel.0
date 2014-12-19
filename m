From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v3 0/8] dm: add request-based blk-mq support
Date: Fri, 19 Dec 2014 15:32:52 +0100
Message-ID: <54943714.2040704@acm.org>
References: <1418788804-1982-1-git-send-email-snitzer@redhat.com>	<alpine.LNX.2.00.1412172133240.4026@localhost.lm.intel.com>	<5491F906.1090004@kernel.dk>
	<20141217230622.GC15390@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20141217230622.GC15390@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc: hch@infradead.org, Keith Busch <keith.busch@intel.com>, j-nomura@ce.jp.nec.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 12/18/14 00:06, Mike Snitzer wrote:
> So if you know someone with relevant blk-mq hardware who might benefit
> from blk-mq multipathing please point them at this code and have them
> report back!

Hello Mike,

Great to see that you are working on blk-mq multipathing. Unfortunately
a test with the SRP initiator and your dm-for-3.20-blk-mq tree merged
with Linus' latest tree was not successful. This is what was reported
when I tried to start multipathd (without call trace, followed by a
hard lockup):

=========================================================
[ INFO: possible irq lock inversion dependency detected ]
3.18.0-debug+ #1 Tainted: G        W     
---------------------------------------------------------
kdmwork-253:0/5347 just changed the state of lock:
 (&(&m->lock)->rlock){+.....}, at: [<ffffffffa080eb80>] __multipath_map.isra.15+0x40/0x1f0 [dm_multipath]
but this lock was taken by another, HARDIRQ-safe lock in the past:
 (&(&q->__queue_lock)->rlock){-.-...}
 
and interrupts could create inverse lock ordering between them.
 
other info that might help us debug this:
 Possible interrupt unsafe locking scenario:

This is how objdump translates the assembler code of the above kernel address (0x1b80 below):

static int __multipath_map(struct dm_target *ti, struct request *clone,
    1b62:       48 89 55 c8             mov    %rdx,-0x38(%rbp)
    1b66:       4c 89 45 c0             mov    %r8,-0x40(%rbp)
                           union map_info *map_context,
                           struct request *rq, struct request **__clone)
{
        struct multipath *m = (struct multipath *) ti->private;
        int r = DM_MAPIO_REQUEUE;
        size_t nr_bytes = clone ? blk_rq_bytes(clone) : blk_rq_bytes(rq);
    1b6a:       0f 84 50 01 00 00       je     1cc0 <__multipath_map.isra.15+0x180>
    1b70:       44 8b 66 5c             mov    0x5c(%rsi),%r12d
        raw_spin_lock_init(&(_lock)->rlock);            \
} while (0)

static inline void spin_lock(spinlock_t *lock)
{
        raw_spin_lock(&lock->rlock);
    1b74:       49 8d 5e 28             lea    0x28(%r14),%rbx
    1b78:       48 89 df                mov    %rbx,%rdi
    1b7b:       e8 00 00 00 00          callq  1b80 <__multipath_map.isra.15+0x40>
        struct dm_mpath_io *mpio;

        spin_lock(&m->lock);

        /* Do we need to select a new pgpath? */
        if (!m->current_pgpath ||
    1b80:       49 8b 8e d0 00 00 00    mov    0xd0(%r14),%rcx
    1b87:       48 85 c9                test   %rcx,%rcx
    1b8a:       74 55                   je     1be1 <__multipath_map.isra.15+0xa1>
            (!m->queue_io && (m->repeat_count && --m->repeat_count == 0)))
    1b8c:       41 0f b6 96 ec 00 00    movzbl 0xec(%r14),%edx

Bart.
