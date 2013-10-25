From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 11/24] dm table: print error on preresume
	failure
Date: Fri, 25 Oct 2013 15:58:55 -0400
Message-ID: <20131025195802.GD4804@redhat.com>
References: <1382639437-27007-1-git-send-email-snitzer@redhat.com>
	<1382639437-27007-12-git-send-email-snitzer@redhat.com>
	<20131025192216.GJ17070@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20131025192216.GJ17070@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, Morgan Mears <morgan.mears@netapp.com>, Heinz Mauelshagen <heinzm@redhat.com>, ejt@redhat.com
List-Id: dm-devel.ids

On Fri, Oct 25 2013 at  3:22pm -0400,
Alasdair G Kergon <agk@redhat.com> wrote:

> On Thu, Oct 24, 2013 at 02:30:24PM -0400, Mike Snitzer wrote:
> > If preresume fails it is worth logging an error given that a device is
> > left suspended due to the failure.
>  
> Indeed.
> 
> > This change was motivated by local preresume error logging that was
> > added to the cache target.  Elevating this error logging to DM core
> > makes sense.
>  
> But here I disagree: I think it makes more sense not to elevate this
> logging, but to leave the responsibility for it with the targets
> themselves.
> 
> > +			DMERR("%s: %s: preresume failed, error = %d",
> > +			      dm_device_name(t->md), ti->type->name, r);
> 
> Elevated, you're only getting a single number displayed.

Elevated was over-stated, I'll revise the header.  I was trying to say
that the target shouldn't need to worry about stating that the failure
happens to be in the preresume method on the target.

> If the targets retain the responsibility, then you should get a
> more-detailed error message such as:
> 
>                 DMERR("aborting resume - crypt key is not set.");
> 
>                         DMERR("Unable to resume snapshot source until "
>                               "handover completes.");
> 
>                         DMERR("Unable to perform snapshot handover until "
>                               "source is suspended.");
> 
>                         DMERR("could not resize cache metadata");
>                         DMERR("could not load cache mappings");
>                         DMERR("could not load origin discards");
> 
> I think we should retain the requirement that each target must log
> a meaningful message whenever preresume fails.

Yeah, I agree.  I just want DM core to make it clear that the target
failure resulted in preresume failing.
