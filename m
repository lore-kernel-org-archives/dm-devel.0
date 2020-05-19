From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCHv2 0/6] dm-zoned: improve cache performance
Date: Tue, 19 May 2020 13:36:56 -0400
Message-ID: <20200519173655.GA30916@redhat.com>
References: <20200519081424.103318-1-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200519081424.103318-1-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Hannes Reinecke <hare@suse.de>
Cc: Damien LeMoal <damien.lemoal@wdc.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, May 19 2020 at  4:14am -0400,
Hannes Reinecke <hare@suse.de> wrote:

> Hi all,
> 
> here's an update to dm-zoned to separate out cache zones.
> In the update to metadata version 2 the regular drive was split
> in emulated zones, which were handled just like 'normal' random
> write zones.
> This causes a performance drop once these emulated zones have
> been mapped, as typicall the random zones from the zoned drive
> will perform noticeably slower than those from the regular drive.
> (After all, that was kinda the idea of using a regular disk in
> the first place ...)
> 
> So in this patchset I've introduced a separate 'cache' zone type,
> allowing us to differentiate between emulated and real zones.
> With that we can switch the allocation mode to use only cache
> zones, and use random zones similar to sequential write zones.
> That avoids the performance issue noted above.
> 
> I've also found that the sequential write zones perform noticeably
> better on writes (which is all we're caching anyway), so I've
> added another patch switching the allocation routine from preferring
> sequential write zones for reclaim.
> 
> This patchset also contains some minor fixes like remving an unused
> variable etc.
> 
> As usual, comments and reviews are welcome.
> 
> Changes to v1:
> - Include reviews from Damien

I'll take a look at this series now, but I'm still waiting for formal
Reviewed-by: or Acked-by: from Damien before I'll stage for 5.8 --
current development window is coming to a close though.

> - Introduce allocation flags
> - Terminate reclaim on contention
> - Rework original patch series
> 
> Hannes Reinecke (6):
>   dm-zoned: return NULL if dmz_get_zone_for_reclaim() fails to find a zone
>   dm-zoned: separate random and cache zones
>   dm-zoned: reclaim random zones when idle
>   dm-zoned: start reclaim with sequential zones
>   dm-zoned: terminate reclaim on congestion
>   dm-zoned: remove unused variable in dmz_do_reclaim()

FYI I folded the last 6/6 patch back into the original commit that
introduced the unused variable (via rebase).

Thanks,
Mike
