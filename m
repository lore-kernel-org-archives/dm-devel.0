From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/2] lib/lcm.c: lcm(n,0)=lcm(0,n) is 0, not n
Date: Sat, 28 Mar 2015 22:44:28 -0400
Message-ID: <CAMM=eLdw+7zfoufBEBSKhVR5d=g-a-GdzTA4WBgXUcMx=Av91A@mail.gmail.com>
References: <1418158984-25546-1-git-send-email-linux@rasmusvillemoes.dk> <1418158984-25546-2-git-send-email-linux@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1418158984-25546-2-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, device-mapper development <dm-devel@redhat.com>, Jens Axboe <axboe@kernel.dk>
List-Id: dm-devel.ids

On Tue, Dec 9, 2014 at 4:03 PM, Rasmus Villemoes
<linux@rasmusvillemoes.dk> wrote:
> Return the mathematically correct answer when an argument is 0.
>
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
>  lib/lcm.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/lib/lcm.c b/lib/lcm.c
> index 01b3aa922dda..51cc6b13cd52 100644
> --- a/lib/lcm.c
> +++ b/lib/lcm.c
> @@ -8,9 +8,7 @@ unsigned long lcm(unsigned long a, unsigned long b)
>  {
>         if (a && b)
>                 return (a / gcd(a, b)) * b;
> -       else if (b)
> -               return b;
> -
> -       return a;
> +       else
> +               return 0;
>  }
>  EXPORT_SYMBOL_GPL(lcm);

This change is the source of 3.19 regression for stacking device
limits, via commit 69c953c ("lib/lcm.c: lcm(n,0)=lcm(0,n) is 0, not
n").

Test:
# modprobe scsi_debug dev_size_mb=10 num_tgts=1 opt_blks=1536
# cat /sys/block/sde/queue/optimal_io_size
786432
# dmsetup create node --table "0 100 linear /dev/sde 0"

Before commit 69c953c:
# cat /sys/block/dm-5/queue/optimal_io_size
786432

After commit 69c953c:
# cat /sys/block/dm-5/queue/optimal_io_size
0

Rasmus, mathematical purity of lcm() aside, it'd have been nice if you
looked at the lcm() callers to determine whether you'd be breaking
them.

It looks like we need a new lcm_not_zero() and blk_stack_limits()
should be changed to use it, and the patch needs to cc stable.  Martin
and/or Jens, what do you think?

Mike
