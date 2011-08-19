From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: convert dm-thin to use dm-bufio
Date: Fri, 19 Aug 2011 14:25:32 -0400
Message-ID: <20110819182532.GA3774@redhat.com>
References: <Pine.LNX.4.64.1108141602440.28009@hs20-bc2-1.build.redhat.com>
	<20110815090416.GE3159@ubuntu>
	<Pine.LNX.4.64.1108151316300.18170@hs20-bc2-1.build.redhat.com>
	<20110816091600.GA4284@ubuntu>
	<Pine.LNX.4.64.1108161755510.15859@hs20-bc2-1.build.redhat.com>
	<20110817082656.GA3267@ubuntu>
	<Pine.LNX.4.64.1108181830050.7668@hs20-bc2-1.build.redhat.com>
	<20110819070435.GA32300@redhat.com>
	<Pine.LNX.4.64.1108190926530.2592@hs20-bc2-1.build.redhat.com>
	<20110819153706.GA23736@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20110819153706.GA23736@ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <thornber@redhat.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Aug 19 2011 at 11:37am -0400,
Joe Thornber <thornber@redhat.com> wrote:

> On Fri, Aug 19, 2011 at 09:31:56AM -0400, Mikulas Patocka wrote:
> > On Fri, 19 Aug 2011, Mike Snitzer wrote:
> > > -struct dm_block;
> > > +#define dm_block		dm_buffer
> > > +#define dm_block_manager	dm_bufio_client
> > > 
> > > But I think it'd be best, in the long run, to have a follow-on patch
> > > that does away with the aliases and just use the bufio structs
> > > throughout the code.  Anyway, don't need to worry about this now.  But
> > > what you've done is hack that should probably be cleaned up.
> > 
> > This way, it's easy to swap the original block manager and dm-bufio.
> > 
> > If I changed the names throughout the whole dm-thinp code, it would 
> > conflict with any changes Joe may do.
> 
> I agree with Mikulas here.

It could be that we're all in agreement here.

In the near term it makes no sense to have the structure name churn
given the merge of bufio will be disruptive enough as it is.

I tried to convey as much above with: "Anyway, don't need to worry about
this now."

But if thinp is to be the first consumer of bufio (a substantial chunk
of code in its own right) then it stands to reason we should have thinp
act as the reference for how other targets should consume it.

So all I was suggesting is that once thinp is converted to bufio, and
there is confidence in the result, it should be updated to not have the
intermediate structure aliases that helped ease the conversion.

If what you're saying is thinp should always use the structure aliases
then I guess we'll just disagree and that'll be the end of it.  All I
can do is say my peace.
