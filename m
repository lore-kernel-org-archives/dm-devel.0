From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH] dm-bufio
Date: Mon, 17 Oct 2011 15:15:22 +0100
Message-ID: <20111017141521.GB10136@ubuntu>
References: <Pine.LNX.4.64.1110141500160.29246@hs20-bc2-1.build.redhat.com>
	<20111017100808.GA4635@ubuntu>
	<Pine.LNX.4.64.1110170958520.14928@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1110170958520.14928@hs20-bc2-1.build.redhat.com>
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
Cc: dm-devel@redhat.com, Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Oct 17, 2011 at 10:04:16AM -0400, Mikulas Patocka wrote:
> > If you're going to use cond_resched() at least do so a little more
> > intelligently than putting it in _every_ loop.  For instance you call it on
> > every iteration of a sweep through the hash table.  The call to
> > cond_resched will take more time than the loop body.  At least make a
> > change so it's only done every n'th iteration.
> 
> I think it would be better to use
> #ifndef CONFIG_PREEMPT
> if (need_resched()) cond_resched();
> #endif
> 
> need_resched() is inlined and translates to a single condition.

Yep, that would be fine.

> I don't know why Linux doesn't provide a macro for it, this would be 
> useful far beyond dm code.

Agreed, I was very surprised that cond_resched() expands out to a
function call rather than a test + fn call.

Get a patch together and I'll merge.

- Joe
