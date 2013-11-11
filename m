From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 1/6] dm cache: cache shrinking support
Date: Mon, 11 Nov 2013 21:48:56 +0000
Message-ID: <20131111214855.GC24324@agk-dp.fab.redhat.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Nov 11, 2013 at 04:32:33PM -0500, Mike Snitzer wrote:
> On Mon, Nov 11 2013 at  4:19pm -0500,
> Alasdair G Kergon <agk@redhat.com> wrote:
  
> > > +			DMERR("unable to shrink cache due to dirty blocks");
> > This error is highly undesirable: part of a device has been removed
> > while it is still needed!
> Huh?  The device still had dirty blocks, so the cache wasn't resized.

The device no longer has those dirty blocks: you already removed them 
(otherwise you wouldn't have reached this point).
 
> Use the cleaner policy to purge the cache first.
 
But how do you do that without also cleaning the part of the cache that
you're keeping?  (For example, why should it be necessary to stop using
your preferred cache policy for a while and clean the entire cache just in
order to reduce the size of the cache slightly?)

If the current situation is temporary then can we indicate what a better
solution is likely to look like and whether it is likely still to use this
proposed shrinker interface or whether it could replace it with something else?

Alasdair
