From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH v2] dm-io: deal with wandering queue limits
 when handling REQ_DISCARD and REQ_WRITE_SAME
Date: Fri, 27 Feb 2015 14:21:13 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1502271420480.32344@file01.intranet.prod.int.rdu2.redhat.com>
References: <20150227184438.GF5519@birch.djwong.org>
	<alpine.LRH.2.02.1502271407010.32344@file01.intranet.prod.int.rdu2.redhat.com>
	<20150227191904.GA6945@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150227191904.GA6945@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Srinivas Eeda <srinivas.eeda@oracle.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, agk@redhat.com, "Darrick J. Wong" <darrick.wong@oracle.com>
List-Id: dm-devel.ids



On Fri, 27 Feb 2015, Mike Snitzer wrote:

> On Fri, Feb 27 2015 at  2:09pm -0500,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > 
> > 
> > On Fri, 27 Feb 2015, Darrick J. Wong wrote:
> > 
> > > Since it's apparently possible that the queue limits for discard and
> > > write same can change while the upper level command is being sliced
> > > and diced, fix up both of them (a) to reject IO if the special command
> > > is unsupported at the start of the function and (b) read the limits
> > > once and let the commands error out on their own if the status happens
> > > to change.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > > +	unsigned int special_cmd_max_sectors;
> > > +
> > > +	/* Reject unsupported discard and write same requests */
> > > +	if (rw & REQ_DISCARD)
> > > +		special_cmd_max_sectors = q->limits.max_discard_sectors;
> > > +	else if (rw & REQ_WRITE_SAME)
> > > +		special_cmd_max_sectors = q->limits.max_write_same_sectors;
> > > +	if ((rw & (REQ_DISCARD | REQ_WRITE_SAME)) &&
> > > +	    special_cmd_max_sectors == 0) {
> > 
> > That results in uninitialized variable warning (although the warning is 
> > false positive). We need the macro uninitialized_var to suppress the 
> > warning.
> > 
> > It's better to use ACCESS_ONCE on variables that may be changing so that 
> > the compiler doesn't load them multiple times.
> > 
> > Here I'm sending the updated patch.
> > 
> > Mikulas
> > 
> > 
> > From: Mikulas Patocka <mpatocka@redhat.com>
> ...
> 
> I'm reviewing this now, but just to be clear, this patch will still be
> attributed to Darrick.

Yes.

Mikulas
