From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: mempool.c: Replace io_schedule_timeout with
	io_schedule
Date: Thu, 18 Dec 2014 10:37:09 -0500
Message-ID: <20141218153709.GC2293@redhat.com>
References: <1418863222-25096-1-git-send-email-nefelim4ag@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1418863222-25096-1-git-send-email-nefelim4ag@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Dec 17 2014 at  7:40pm -0500,
Timofey Titovets <nefelim4ag@gmail.com> wrote:

> io_schedule_timeout(5*HZ);
> Introduced for avoidance dm bug:
> http://linux.derkeiler.com/Mailing-Lists/Kernel/2006-08/msg04869.html
> According to description must be replaced with io_schedule()
> 
> Can you test it and answer: it produce any regression?
> 
> I replace it and recompile kernel, tested it by following script:
> ---
> dev=""
> block_dev=zram #loop
> if [ "$block_dev" == "loop" ]; then
>         f1=$RANDOM
>         f2=${f1}_2
>         truncate -s 256G ./$f1
>         truncate -s 256G ./$f2
>         dev="$(losetup -f --show ./$f1) $(losetup -f --show ./$f2)"
>         rm ./$f1 ./$f2
> else
>         modprobe zram num_devices=8
>         # needed ~1g free ram for test
>         echo 128G > /sys/block/zram7/disksize
>         echo 128G > /sys/block/zram6/disksize
>         dev="/dev/zram7 /dev/zram6"
> fi
> 
> md=/dev/md$[$RANDOM%8]
> echo "y\n" | mdadm --create $md --chunk=4 --level=1 --raid-devices=2 $(echo $dev)

You didn't test using DM, you used MD.

And in the context of 2.6.18 the old dm-raid1 target was all DM had
(whereas now we also have a DM wrapper around MD raid with the dm-raid
module).  Should we just kill dm-raid1 now that we have dm-raid?  But
that is tangential to the question being posed here.

So I'll have to read the thread you linked to to understand if DM raid1
(or DM core) still suffers from the problem that this hack papered over.

Mike


> [ "$block_dev" == "loop" ] && losetup -d $(echo $dev) &
> 
> mkfs.xfs -f $md
> mount $md /mnt
> 
> cat /dev/zero > /mnt/$RANDOM &
> cat /dev/zero > /mnt/$RANDOM &
> wait
> umount -l /mnt
> mdadm --stop $md
> 
> if [ "$block_dev" == "zram" ]; then
>         echo 1 > /sys/block/zram7/reset
>         echo 1 > /sys/block/zram6/reset
> fi
> ---
> 
> i.e. i can't get this error for fast test with zram and slow test with loop devices
> 
> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
> ---
>  mm/mempool.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/mm/mempool.c b/mm/mempool.c
> index e209c98..ae230c9 100644
> --- a/mm/mempool.c
> +++ b/mm/mempool.c
> @@ -253,11 +253,7 @@ repeat_alloc:
>  
>  	spin_unlock_irqrestore(&pool->lock, flags);
>  
> -	/*
> -	 * FIXME: this should be io_schedule().  The timeout is there as a
> -	 * workaround for some DM problems in 2.6.18.
> -	 */
> -	io_schedule_timeout(5*HZ);
> +	io_schedule();
>  
>  	finish_wait(&pool->wait, &wait);
>  	goto repeat_alloc;
> -- 
> 2.1.3
