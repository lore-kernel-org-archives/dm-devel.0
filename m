From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/4] Check that the target supports discard
Date: Fri, 2 Jul 2010 14:05:29 -0400
Message-ID: <20100702180529.GC26916@redhat.com>
References: <Pine.LNX.4.64.1007021107420.7296@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.1007021112340.7296@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1007021112340.7296@hs20-bc2-1.build.redhat.com>
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
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Jul 02 2010 at 11:17am -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Check that the target supports discard
> 
> Because of a various race conditions, discard request may be submitted to
> device mapper even if device mapper advertises that it doesn't support
> discards. (for example, the device is linear, dm advertises discard support,
> discard request is constructed, the table is reloaded with mirror, the discard
> is submitted to the mirror target that doesn't support it).
> 
> To solve these problems we must check that the target supports discard
> just before submitting discard request to it.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>  drivers/md/dm.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> Index: linux-2.6.35-rc3-fast/drivers/md/dm.c
> ===================================================================
> --- linux-2.6.35-rc3-fast.orig/drivers/md/dm.c	2010-07-02 16:10:25.000000000 +0200
> +++ linux-2.6.35-rc3-fast/drivers/md/dm.c	2010-07-02 16:11:22.000000000 +0200
> @@ -1223,6 +1223,9 @@ static int __clone_and_map_discard(struc
>  	if (!dm_target_is_valid(ti))
>  		return -EIO;
>  
> +	if (!(ti->type->features & DM_TARGET_SUPPORTS_DISCARDS))
> +		return -EOPNOTSUPP;
> +
>  	max = max_io_len(ci->md, ci->sector, ti);
>  
>  	if (ci->sector_count > max)
> 

The current model is that the static DM_TARGET_SUPPORTS_DISCARDS is
consulted when the target is added to table.  And then at the end of the
table load we check all devices to see if they actually do support
discards.

That said, I understand that IOs in flight before a table is suspended
will be attempted after the table is reload.  So this patch is good.

It should be noted that checking for this race condition gets much
harder once DM supports splitting discards that span devices.  We'll
have potential for partial completion that in the end returns
-EOPNOTSUPP.  Which is fine; but I think we'll need to be careful to not
return -EOPNOTSUPP before outstanding IO (associated with the discard
we're intending to return -EOPNOTSUPP for) completes?

Anyway, we'll cross that bridge later.  Nice catch.

Acked-by: Mike Snitzer <snitzer@redhat.com>
