From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/2] dm: update max_io_len to support a
 split_io that is not a power of 2
Date: Mon, 30 Apr 2012 13:24:00 -0400
Message-ID: <20120430172359.GA19033@redhat.com>
References: <1335588269-807-1-git-send-email-snitzer@redhat.com>
	<20120430161043.GB8713@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20120430161043.GB8713@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jonathan Brassow <jbrassow@redhat.com>, dm-devel@redhat.com, ejt@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On Mon, Apr 30 2012 at 12:10pm -0400,
Alasdair G Kergon <agk@redhat.com> wrote:

> On Sat, Apr 28, 2012 at 12:44:28AM -0400, Mike Snitzer wrote:
> > Required to support a target's use of a non power of 2 blocksize.
>  
> For which targets?

striped and thin-pool for starters.

> (merge_bvec supported?)

Yes.

> > +		boundary = ti->split_io - do_div(tmp, ti->split_io);
> 
> sector_div()?
>
> What about 32-bit arch + LBD + large split_io (from raid?)
>   - Is a 32-bit restriction on split_io unreasonable nowadays?
>     - OR reasonable on 32bit/LBD?
>     - OR fallback to old code there?

I cannot see why we'd need a split_io that is larger than 32 bits -- a
32bit split_io can support up to 2TB (2**32 * 512b sectors).  Even
on a LBD (raid) the stripe size (split_io) will not be so large.

(though yes we would need to establish a check in DM core that split_io is
limited to 32-bit -- even though the 'sector_t' is used for split_io;
and the comment inside the 'struct dm_target' would need updating).

But what I think what you're driving at is: is there a benefit/reason to
maintain the old code for some target that won't ever use non power of 2
split_io (e.g. dm-raid at the moment)?  I see no point for the duality
in the code but I'm open to the idea if you have a specific reason in
mind -- are you concerned about perf on more obscure/older hardware?
