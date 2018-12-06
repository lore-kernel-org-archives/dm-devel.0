From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v4 0/7] per-cpu in_flight counters for
	bio-based drivers
Date: Thu, 6 Dec 2018 14:04:45 -0500
Message-ID: <20181206190444.GA15753@redhat.com>
References: <20181206164122.2166-1-snitzer@redhat.com>
	<20181206180025.GA15514@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20181206180025.GA15514@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>, Omar Sandoval <osandov@fb.com>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Thu, Dec 06 2018 at  1:00pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Thu, Dec 06 2018 at 11:41am -0500,
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
> > Hey,
> > 
> > This v4 addresses the compile issues on various archs when CONFIG_SMP
> > isn't set (by introducing appropriate wrappers in genhd.h)
> > 
> > Testing with this v4 I was unable to reproduce the issue you reported
> > where iostat always reports 0 for avgqu-sz -- but please let me know
> > if you still see problems like that.
> 
> I ran blktests and both block/017 and block/018 fail due to this
> patchset's changes, I'm still trying to grok what the test result is
> _saying_ but I'll hopefully get there soon:
> 
> block/017 (do I/O and check the inflight counter)            [failed]
>     runtime    ...  77.675s
>     --- tests/block/017.out     2018-12-06 12:31:21.457936217 -0500
>     +++ /home/git/blktests/results/nodev/block/017.out.bad      2018-12-06 12:36:15.735053586 -0500
>     @@ -1,14 +1,14 @@
>      Running block/017
>     -sysfs inflight reads 1
>     +sysfs inflight reads 2
>      sysfs inflight writes 0
>     -sysfs stat 1
>     -diskstats 1
>     -sysfs inflight reads 1
>     ...
>     (Run 'diff -u tests/block/017.out /home/git/blktests/results/nodev/block/017.out.bad' to see the entire diff)
> 
> # diff -u tests/block/017.out /home/git/blktests/results/nodev/block/017.out.bad
> --- tests/block/017.out 2018-12-06 12:31:21.457936217 -0500
> +++ /home/git/blktests/results/nodev/block/017.out.bad  2018-12-06 12:51:36.695542332 -0500
> @@ -1,14 +1,14 @@
>  Running block/017
> -sysfs inflight reads 1
> +sysfs inflight reads 2
>  sysfs inflight writes 0
> -sysfs stat 1
> -diskstats 1
> -sysfs inflight reads 1
> -sysfs inflight writes 1
>  sysfs stat 2
>  diskstats 2
> -sysfs inflight reads 0
> +sysfs inflight reads 2
> +sysfs inflight writes 1
> +sysfs stat 3
> +diskstats 3
> +sysfs inflight reads 1
>  sysfs inflight writes 0
> -sysfs stat 0
> -diskstats 0
> +sysfs stat 1
> +diskstats 1
>  Test complete
> 

Interestingly the 017 test is only testing blk-mq (using null_blk's
queue_mode=2).  This patchset's changes are specific to bio-based.

If I revert this patchset I still get the failures.

So it would seem something regressed in latest block for-next (I've been
testing up through linux-block commit c754a9bf7ee8 ("blk-mq: remove
QUEUE_FLAG_POLL from default MQ flags").

> block/018 (do I/O and check iostats times)                   [failed]
>     runtime    ...  156.073s
>     --- tests/block/018.out     2018-12-06 12:31:21.458936217 -0500
>     +++ /home/git/blktests/results/nodev/block/018.out.bad      2018-12-06 12:38:51.831116369 -0500
>     @@ -1,10 +1,10 @@
>      Running block/018
>      read 0 s
>      write 0 s
>     -read 1 s
>     +read 2 s
>      write 0 s
>     -read 1 s
>     ...
>     (Run 'diff -u tests/block/018.out /home/git/blktests/results/nodev/block/018.out.bad' to see the entire diff)
> 
> # diff -u tests/block/018.out /home/git/blktests/results/nodev/block/018.out.bad
> --- tests/block/018.out 2018-12-06 12:31:21.458936217 -0500
> +++ /home/git/blktests/results/nodev/block/018.out.bad  2018-12-06 12:38:51.831116369 -0500
> @@ -1,10 +1,10 @@
>  Running block/018
>  read 0 s
>  write 0 s
> -read 1 s
> +read 2 s
>  write 0 s
> -read 1 s
> -write 1 s
>  read 2 s
> +write 1 s
> +read 6 s
>  write 3 s
>  Test complete

Same goes for this block/018 test.

Mike
