From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 6/6] dm cache: add cache block invalidation
	support
Date: Tue, 12 Nov 2013 12:35:57 -0500
Message-ID: <20131112173557.GA10829@redhat.com>
References: <1384190448-3861-1-git-send-email-snitzer@redhat.com>
	<1384190448-3861-7-git-send-email-snitzer@redhat.com>
	<20131112004633.GJ24324@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20131112004633.GJ24324@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Nov 11 2013 at  7:46pm -0500,
Alasdair G Kergon <agk@redhat.com> wrote:

> On Mon, Nov 11, 2013 at 12:20:48PM -0500, Mike Snitzer wrote:
> > From: Joe Thornber <ejt@redhat.com>
>  
> > Cache block invalidation is removing an entry from the cache without
> > writing it back.  Cache blocks can be invalidated via the
> > 'invalidate_cblocks' message, which takes an arbitrary number of cblock
> > ranges:
> >    invalidate_cblocks [<cblock>|<cblock begin>-<cblock end>]*
>  
> If we're expecting to need to invalidate a large number of ranges, should we
> switch this over to hexadecimal like we did for dm-switch?
> 
> Should we consider changing this to <cblock>+<length> as the dm
> interfaces tend to work with a start offset and a length?
> 
> Or will it be that the userspace interface will not be the bottleneck in
> this code so it really doesn't matter about attempting to optimise that
> part?

TBD.  Plan is to introduce "invalidate_cblocks_hex" variant if needed.

> > +++ b/Documentation/device-mapper/cache.txt
> 
> >  The test suite can be found here:
> > -https://github.com/jthornber/thinp-test-suite
> > +https://github.com/jthornber/device-mapper-test-suite
> 
> It's really not good if URLs in existing documentation become invalid
> like this: Could an obvious pointer be placed at the old location to
> direct people to the new location?
> 
> Can we document whether or not all the ranges will have been invalidated
> before the message returns?
> 
> > +	if (!passthrough_mode(&cache->features)) {
> > +		DMERR("cache has to be in passthrough mode for invalidation");
> 
> Can we document this too?
> 
> > @@ -2841,6 +3054,12 @@ static int cache_message(struct dm_target *ti, unsigned argc, char **argv)
> > +	if (!strcmp(argv[0], "invalidate_cblocks"))
> 
> strcasecmp please!

Pushed the following commit to address your comments in this patchset,
can rebase this commit if you have any further suggestions:
http://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=e67df7acf867b654c6eca7d08ee0452e9c5e4534
