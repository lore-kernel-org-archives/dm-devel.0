From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/6] dm cache: cache shrinking support
Date: Mon, 11 Nov 2013 16:32:33 -0500
Message-ID: <20131111213232.GA5099@redhat.com>
References: <1384190448-3861-1-git-send-email-snitzer@redhat.com>
	<1384190448-3861-2-git-send-email-snitzer@redhat.com>
	<20131111211934.GB24324@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20131111211934.GB24324@agk-dp.fab.redhat.com>
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

On Mon, Nov 11 2013 at  4:19pm -0500,
Alasdair G Kergon <agk@redhat.com> wrote:

> On Mon, Nov 11, 2013 at 12:20:43PM -0500, Mike Snitzer wrote:
> > From: Joe Thornber <ejt@redhat.com>
> > 
> > Allow a cache to shrink if the blocks being removed from the cache are
> > not dirty.
>  
> Please would you document the intended procedure here?

I'm not rebasing this patch (and in turn all commits that follow) to
tweak this header.  We can add information to cache.txt as a follow-on
commit.
 
> > +			DMERR("unable to shrink cache due to dirty blocks");
> 
> This error is highly undesirable: part of a device has been removed
> while it is still needed!

Huh?  The device still had dirty blocks, so the cache wasn't resized.

> How does someone go about reducing the size of the cache avoiding this
> error?  (Analogy: to reduce size of a filesystem you run a filesystem
> resize process before reducing the size of the block device.)

Use the cleaner policy to purge the cache first.
