From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 21/24] dm cache: add trc policy shim
Date: Fri, 25 Oct 2013 18:44:55 -0400
Message-ID: <20131025224453.GG4804@redhat.com>
References: <1382639437-27007-1-git-send-email-snitzer@redhat.com>
	<1382639437-27007-22-git-send-email-snitzer@redhat.com>
	<20131025201356.GM17070@agk-dp.fab.redhat.com>
	<20131025210820.GA7589@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20131025210820.GA7589@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: Morgan Mears <morgan.mears@netapp.com>, Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com, Joe Thornber <ejt@redhat.com>
List-Id: dm-devel.ids

On Fri, Oct 25 2013 at  5:08pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Fri, Oct 25 2013 at  4:13pm -0400,
> Alasdair G Kergon <agk@redhat.com> wrote:
> 
> > On Thu, Oct 24, 2013 at 02:30:34PM -0400, Mike Snitzer wrote:
> > > From: Morgan Mears <morgan.mears@netapp.com>
> >  
> > > This commit includes a non-terminal policy (aka "shim") called trc that
> > > may be stacked ontop of a terminal policy (e.g. mq).
> > > The second shim, trc, adds function-call-level tracing to the policy
> > > stack.  By default, an INFO-level log message including function name
> > > and parameter(s) will be generated whenever most of the cache policy
> > > interface functions are called.  An interface to increase or decrease
> > > the verbosity of the trace output is also provided.
> >  
> > Firstly, why not call it 'trace' in full, rather than abbreviating it to 3
> > consonants?
> 
> We can easily rename.
>  
> > > +++ b/drivers/md/dm-cache-policy-trc.c
> > 
> > > +#define DM_TRC_OUT(lev, p, f, arg...) \
> > > +	do { \
> > > +		if (to_trc_policy(p)->trace_level >= lev) \
> > > +			DMINFO("%s: " f, __func__, ## arg); \
> > > +	} while (0)
> > 
> > OK for private debugging, but I can't pretend to be very keen on this
> > one going upstream in this form.   Might this not need to support high
> > volumes of messages sometimes?  Were other upstream mechanisms
> > considered?  (E.g. see Documentation/trace).
> 
> Think this would take care of it (not full-blown tracepoints like
> blktrace but certainly more performant than standard printk):

I folded this trace_printk change in and renamed from trc to trace, see:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=f6f5db50495b16ff23a0febf38f9ee9d964b12dd
