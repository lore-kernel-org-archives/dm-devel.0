From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/6] dm cache: cache shrinking support
Date: Mon, 11 Nov 2013 16:50:09 -0500
Message-ID: <20131111215009.GA17903@redhat.com>
References: <1384190448-3861-1-git-send-email-snitzer@redhat.com>
	<1384190448-3861-2-git-send-email-snitzer@redhat.com>
	<20131111211934.GB24324@agk-dp.fab.redhat.com>
	<20131111213232.GA5099@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20131111213232.GA5099@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Nov 11 2013 at  4:32pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Mon, Nov 11 2013 at  4:19pm -0500,
> Alasdair G Kergon <agk@redhat.com> wrote:
> 
> > On Mon, Nov 11, 2013 at 12:20:43PM -0500, Mike Snitzer wrote:
> > > From: Joe Thornber <ejt@redhat.com>
> > > 
> > > Allow a cache to shrink if the blocks being removed from the cache are
> > > not dirty.
> >  
> > Please would you document the intended procedure here?
> 
> I'm not rebasing this patch (and in turn all commits that follow) to
> tweak this header.  We can add information to cache.txt as a follow-on
> commit.
>  
> > > +			DMERR("unable to shrink cache due to dirty blocks");
> > 
> > This error is highly undesirable: part of a device has been removed
> > while it is still needed!
> 
> Huh?  The device still had dirty blocks, so the cache wasn't resized.

Maybe you were saying: the trigger to resize is based on the size of the
fast device having been reduced.. so getting that error _after_ the user
already resized the fast device isn't really useful.

Valid point... but given DM gives users a tremendous amount of room to
hang itself this is par for the course no?  Making this more
bullet-proof could have userspace detect that the device is being used
as in a dm-cache device... and then running userspace utils to analyze
whether the device still has dirty blocks.

Kernel is merely acting as it was told.. and yeah the user could do the
wrong thing.  So much more documentation is warranted for sure.

Mike
