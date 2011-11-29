From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC PATCH] block: change max_segments default to USHRT_MAX
Date: Tue, 29 Nov 2011 14:33:36 -0500
Message-ID: <20111129193335.GA6827@redhat.com>
References: <1322517615-28530-1-git-send-email-snitzer@redhat.com>
 <yq1mxbehkt6.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1mxbehkt6.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>, Shuichi Ihara <sihara@ddn.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Nov 29 2011 at 12:59pm -0500,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> >>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
> 
> Mike> The reported problem was that a DM multipath device's max_segemnts
> Mike> was constrained to BLK_MAX_SEGMENTS (128) even though the
> Mike> underlying paths' max_segments were larger.  For example, SCSI
> Mike> establishes a max_segments of SCSI_MAX_SG_CHAIN_SEGMENTS (2048).
> 
> I'd rather that we revisited the patches I posted a while back where we
> have different defaults for LLDs and stacking drivers.

Don't think I ever saw those patches.  But it isn't immediately clear to
me why we'd want to have to continue to think in different terms
depending on whether we're LLD or stacked (especially for max_segments).

Though I do understand why we need it in some cases, e.g.: the existing
conflicting default for discard_zeroes_data (block vs DM).  It is
unfortunate yet necessary given the current limits stacking.

(We _could_ make dzd=0 the uniform default if DM were made to look at
all devices in a table and decide whether dzd should be enabled,
something like we do for discards with dm_table_supports_discards())

Thing is we have the block layer doing the stacking of limits.. so
ideally the stacking drivers wouldn't need to work so hard to keep the
block layer non-committal on differentiating between LLD vs stacked.

I'd imagine your patches will formalize an interface that gets us away
from what may seem, to the uninitiated, like adhoc twiddling of certain
limits.

> I'll freshen those up and post them later today.

Great (please cc dm-devel when you post them).

Long story short, I look forward to seeing your patches ;)

Thanks!
