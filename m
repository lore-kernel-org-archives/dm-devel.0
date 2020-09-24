From: John Dorminy <jdorminy@redhat.com>
Subject: Re: [PATCH] dm-raid: stack limits instead of overwriting
	them.
Date: Thu, 24 Sep 2020 12:45:43 -0400
Message-ID: <CAMeeMh87GLea=7_4qGuPhMj0WKnB-596HzkKQDafLirHiBpSzQ@mail.gmail.com>
References: <alpine.LRH.2.02.2009241225310.22728@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.2009241225310.22728@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: Mike Snitzer <msnitzer@redhat.com>, device-mapper development <dm-devel@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

I don't understand how this works...

Can chunk_size_bytes be 0? If not, how is discard_granularity being set to 0?

I think also limits is local to the ti in question here, initialized
by blk_set_stacking_limits() via dm-table.c, and therefore has only
default values and not anything to do with the underlying queue. So
setting discard_granularity=max(discard_granularity, chunk_size_bytes)
doesn't seem like it should be working, unless I'm not understanding
what it's there for...

And shouldn't melding in the target's desired io_hints into the
existing queue limits be happening in blk_stack_limits() instead?
(Also, it does lcm_not_zero() for stacking granularity, instead of
max()...)


On Thu, Sep 24, 2020 at 12:29 PM Mikulas Patocka <mpatocka@redhat.com> wrote:
>
> This patch fixes a warning WARN_ON_ONCE(!q->limits.discard_granularity).
> The reason is that the function raid_io_hints overwrote
> limits->discard_granularity with zero. We need to properly stack the
> limits instead of overwriting them.
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org
>
> ---
>  drivers/md/dm-raid.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> Index: linux-2.6/drivers/md/dm-raid.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-raid.c 2020-09-24 18:16:45.000000000 +0200
> +++ linux-2.6/drivers/md/dm-raid.c      2020-09-24 18:16:45.000000000 +0200
> @@ -3734,8 +3734,8 @@ static void raid_io_hints(struct dm_targ
>          * RAID0/4/5/6 don't and process large discard bios properly.
>          */
>         if (rs_is_raid1(rs) || rs_is_raid10(rs)) {
> -               limits->discard_granularity = chunk_size_bytes;
> -               limits->max_discard_sectors = rs->md.chunk_sectors;
> +               limits->discard_granularity = max(limits->discard_granularity, chunk_size_bytes);
> +               limits->max_discard_sectors = min_not_zero(limits->max_discard_sectors, (unsigned)rs->md.chunk_sectors);
>         }
>  }
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
