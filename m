From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] dm-io: deal with wandering queue limits
 when handling REQ_DISCARD and REQ_WRITE_SAME
Date: Fri, 27 Feb 2015 17:55:38 -0500
Message-ID: <20150227225538.GA7961@redhat.com>
References: <20150227184438.GF5519@birch.djwong.org>
	<alpine.LRH.2.02.1502271407010.32344@file01.intranet.prod.int.rdu2.redhat.com>
	<20150227195826.GB6945@redhat.com>
	<alpine.LRH.2.02.1502271727050.861@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1502271727050.861@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Srinivas Eeda <srinivas.eeda@oracle.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, agk@redhat.com, "Darrick J. Wong" <darrick.wong@oracle.com>
List-Id: dm-devel.ids

On Fri, Feb 27 2015 at  5:39pm -0500,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Fri, 27 Feb 2015, Mike Snitzer wrote:
> 
> > On Fri, Feb 27 2015 at  2:09pm -0500,
> > Mikulas Patocka <mpatocka@redhat.com> wrote:
> > 
> > > 
> > > 
> > > On Fri, 27 Feb 2015, Darrick J. Wong wrote:
> > > 
> > > > Since it's apparently possible that the queue limits for discard and
> > > > write same can change while the upper level command is being sliced
> > > > and diced, fix up both of them (a) to reject IO if the special command
> > > > is unsupported at the start of the function and (b) read the limits
> > > > once and let the commands error out on their own if the status happens
> > > > to change.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > > +	unsigned int special_cmd_max_sectors;
> > > > +
> > > > +	/* Reject unsupported discard and write same requests */
> > > > +	if (rw & REQ_DISCARD)
> > > > +		special_cmd_max_sectors = q->limits.max_discard_sectors;
> > > > +	else if (rw & REQ_WRITE_SAME)
> > > > +		special_cmd_max_sectors = q->limits.max_write_same_sectors;
> > > > +	if ((rw & (REQ_DISCARD | REQ_WRITE_SAME)) &&
> > > > +	    special_cmd_max_sectors == 0) {
> > > 
> > > That results in uninitialized variable warning (although the warning is 
> > > false positive). We need the macro uninitialized_var to suppress the 
> > > warning.
> > > 
> > > It's better to use ACCESS_ONCE on variables that may be changing so that 
> > > the compiler doesn't load them multiple times.
> > 
> > I dropped the use of ACCESS_ONCE.  We access queue_limits all over block
> > related code.  If the performance is quantifiable then all accesses
> > should be updated.  Until then, I'm maintaining status-quo.
> 
> ACCESS_ONCE is not there because of performance.

Yes, clearly not, I've had "performance" on the brain lately (see
request-based DM merge threads) ;)

I understand this is about correctness concerns.

> Without ACCESS_ONCE, the 
> compiler may reload the variable multple times and reintroduce the bug 
> that we are trying to fix.
> 
> 
> See this piece of code.
> 
> special_cmd_max_sectors = q->limits.max_discard_sectors;
> if (special_cmd_max_sectors == 0) {
> 	dec_count(io, region, -EOPNOTSUPP);                                                                                                                                        
>         return;                  
> }
> ....
> num_sectors = special_cmd_max_sectors;
> remaining -= num_sectors;
> 
> 
> At first sight, it seems that the variable num_sectors can't be zero. But 
> in fact, it can. The compiler may eliminate the variable 
> special_cmd_max_sectors and translate the code into this:
> 
> if (q->limits.max_discard_sectors == 0) {
> 	dec_count(io, region, -EOPNOTSUPP);                                                                                                                                        
>         return;                  
> }
> ....
> num_sectors = q->limits.max_discard_sectors;
> remaining -= num_sectors;
> 
> - and now, if we have the same bug that we were trying to fix.
> 
> That's why we need ACCESS_ONCE - to prevent the compiler from doing this 
> transformation.

Do we have proof that a gcc from the last 5-10 years actually does crap
like this?  Again, if so and that compiler is likely to be in
production, this isn't a concern localized to dm-io.  It would be a
rampant problem in the kernel!

> It's true that the kernel misses the ACCESS_ONCE at many places where it 
> should be. But the fact that there is a lot of broken code doesn't mean 
> that we should write broken code too.

I'm saying in practice this type of code isn't broken (and that gcc
isn't doing this.. but I have no _real_ proof other than all the other
places we access structures whose members may change).  ACCESS_ONCE() is
one of the biggest warts in all of the kernel code -- and you happen to
be very persistent about adding them.  I appreciate that it is safer to
have them then not but I'm at the point where I'm starting to question
certain uses of ACCESS_ONCE() -- this one just feels unnecessary.
