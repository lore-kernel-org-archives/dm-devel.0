From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH] multipath: fix scsi async tur
	checker	corruption
Date: Wed, 4 Jan 2012 12:45:51 -0600
Message-ID: <20120104184551.GA1241@ether.msp.redhat.com>
References: <20111220230130.GB17034@ether.msp.redhat.com>
	<4EF19630.4020709@suse.de>
	<20111221154149.GC17034@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20111221154149.GC17034@ether.msp.redhat.com>
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On Wed, Dec 21, 2011 at 09:41:49AM -0600, Benjamin Marzinski wrote:
> On Wed, Dec 21, 2011 at 09:17:52AM +0100, Hannes Reinecke wrote:
> > Hmm. Why do we need ->holders here?
> > In theory we can have only two states; async thread running or no
> > thread running. I really cannot imagine a scenario where ->holders
> > would be > 1.
> 
> Holders will be greater than 1 whenever the thread is running (It's
> initialized to 1 in libcheck_init).  There are two holders of the
> checker context. One is the thread and one is the checker structure
> itself.  The checker context is created when the path first gets a
> checker, and usually lasts until the path puts the checker when it is
> getting either orphaned or removed.  In the async tur checker case, we
> need it to last until both the the checker structure has been freed, and
> the thread has finished running. Unless we wanted to do something
> different in the tur code where it creates a new checker context each
> time it fires off the thread, we only want to free the context when both
> of these holders are gone. And since the path can be removed of orphaned
> at any time with respect to the thread, we need some sort of lock to
> make sure they both aren't decrementing holders at the same time,
> meaning nobody would clean up the context.
> 
> Just to spell out the possible cases:
> 
> If the path's checker is freed, but the thread is still running, we
> can't remove the checker context, since the thread is still using it.
> This is the case that I saw causing memory corruption.
> 
> If the thread gets finished, but the path's checker is still there, we
> can't remove the checker context, because the checker is still using it.
> This is the standard case.  The thread usually finishes between path
> checker calls, and the result needs to get pulled from the context.
> 
> Only when both of these are done can the context get freed.
> 
> -Ben
> 

Hannes, do you still have objections to this patch, or can it be merged?

Thanks

-Ben

> > Or, to stress the point a bit more, any scenario where holders > 1
> > would most definitely be a bug, as this would indicate that an async
> > tur thread is running, but we somehow failed to notice this, and
> > started a new one. Which means we end with two threads doing exactly
> > the same thing. And which was _exactly_ what we want to avoid with
> > at startup.
> > So I guess we can do away with ->holders.
> > And once ->holders is gone, I doubt it'll make any sense to retain
> > the spinlock, as we then just have ->thread to worry about.
> > And this doesn't need to be spinlock protected, as we take care to
> > synchronize during startup. And during shutdown we simply don't
> > care, as pthread_cancel() will return an error if the thread is
> > already done for.
> > 
> > Cheers,
> > 
> > Hannes
