From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm-bufio
Date: Mon, 17 Oct 2011 10:04:16 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1110170958520.14928@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1110141500160.29246@hs20-bc2-1.build.redhat.com>
	<20111017100808.GA4635@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20111017100808.GA4635@ubuntu>
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
Cc: dm-devel@redhat.com, Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids



On Mon, 17 Oct 2011, Joe Thornber wrote:

> On Fri, Oct 14, 2011 at 03:14:34PM -0400, Mikulas Patocka wrote:
> > Hi
> > 
> > This is a patch for dm-bufio.
> > 
> > Changes:
> > * fixed a bug in i/o submission, introduced by someone who changed the 
> > code
> 
> Could you point me at the specific part of this patch that does this
> please?

this:
                        BUG_ON(b->c->block_size <= PAGE_SIZE);
                        use_dmio(b, rw, block, end_io);
+                       return;


> > * simplified some constructs
> > * more likely/unlikely hints
> 
> They clutter the code, and have been used without discrimination.  What
> is the point of using it on a slow path?

I think I added them only to the possible hot paths.

> > * dm-bufio.h moved from drivers/md to include/linux
> 
> Who outside dm do you expect to use this?

I don't know, Alasdair said that he wants it there (like 
include/linux/dm-io.h for example). BTW dm-bufio has nothing to do with 
device mapper actually, so it can be used by any code.

> > * put cond_resched() to loops (it was there originally and then someone 
> > deleted it)
> 
> If you're going to use cond_resched() at least do so a little more
> intelligently than putting it in _every_ loop.  For instance you call it on
> every iteration of a sweep through the hash table.  The call to
> cond_resched will take more time than the loop body.  At least make a
> change so it's only done every n'th iteration.

I think it would be better to use
#ifndef CONFIG_PREEMPT
if (need_resched()) cond_resched();
#endif

need_resched() is inlined and translates to a single condition.

I don't know why Linux doesn't provide a macro for it, this would be 
useful far beyond dm code.

Mikulas

> Can I also point out that I asked you to make a lot of these changes
> over a year ago.  You've only got yourself to blame if 'someone' does
> it for you.
> 
> - Someone
