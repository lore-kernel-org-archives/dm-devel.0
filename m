From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: RFC for multipath queue_if_no_path timeout.
Date: Thu, 26 Sep 2013 13:52:55 -0400
Message-ID: <20130926175254.GA32410@redhat.com>
References: <1380215696.25252.36.camel@bobble.lax.corp.google.com>
	<20130926172422.GA31328@agk-dp.fab.redhat.com>
	<1380216716.25252.39.camel@bobble.lax.corp.google.com>
	<20130926173814.GB31328@agk-dp.fab.redhat.com>
	<1380217633.25252.46.camel@bobble.lax.corp.google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1380217633.25252.46.camel@bobble.lax.corp.google.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Frank Mayhar <fmayhar@google.com>
Cc: dm-devel <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Sep 26 2013 at  1:47pm -0400,
Frank Mayhar <fmayhar@google.com> wrote:

> On Thu, 2013-09-26 at 18:38 +0100, Alasdair G Kergon wrote:
> > On Thu, Sep 26, 2013 at 10:31:56AM -0700, Frank Mayhar wrote:
> > > Uh, huh.  And what about when (not if) _that_ fails?  (For one thing,
> > > what if the stuckness caused by the queued I/O prevents the binary from
> > > being successfully pulled in from storage?)
> >  
> > Lock the daemon in memory (or launch from ramdisk), don't allocate any new
> > memory while it's doing critical monitoring, tell the OOM killer not to kill
> > it, set high/real-time priority etc.
> > 
> > lvm2 and multipath-tools use some of these techniques and seem to cope OK.
> 
> Launching it from ramdisk won't help, particularly, since it still goes
> through the block layer.  The other stuff won't help if a (potentially
> unrelated) bug in the daemon happens to be being tickled at the same
> time, or if some dependency happens to be broken and _that's_ what's
> preventing the daemon from making progress.
> 
> And as far as lvm2 and multipath-tools, yeah, they cope okay in the kind
> of environments most people have, but that's not the kind of environment
> (or scale) we have to deal with.

Fine, please see the post I made earlier in this thread and let me know
what you think.
