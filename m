From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [git pull] device mapper changes for 4.18
Date: Mon, 4 Jun 2018 17:13:44 -0400
Message-ID: <20180604211343.GB6079@redhat.com>
References: <20180604153254.GA4793@redhat.com>
	<CA+55aFyZk6Yeo0DSdakROxXRPvx9HWutbP1TwfoFd6fi-1FSUw@mail.gmail.com>
	<20180604190922.GA5586@redhat.com>
	<CA+55aFyEVcS11N_7BwKV=k0RDqAWdMTJyWDpuFmkXy796k26_w@mail.gmail.com>
	<20180604193653.GC12217@hirez.programming.kicks-ass.net>
	<CA+55aFwkyzV81yEjoFAcjQ68PXxjZ_k-o+oYMobeVMFuj72OHQ@mail.gmail.com>
	<20180604195858.GD12217@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180604195858.GD12217@hirez.programming.kicks-ass.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Jun 04 2018 at  3:58pm -0400,
Peter Zijlstra <peterz@infradead.org> wrote:

> On Mon, Jun 04, 2018 at 12:39:11PM -0700, Linus Torvalds wrote:
> > On Mon, Jun 4, 2018 at 12:37 PM Peter Zijlstra <peterz@infradead.org> wrote:
> > >
> > > Would it help if we did s/swake_up/swake_up_one/g ?
> > >
> > > Then there would not be an swake_up() to cause confusion.
> > 
> > Yes, i think that would already be a big improvement, forcing people
> > to be aware of the exclusive nature.
> 
> The below will of course conflict with the merge request under
> discussion. Also completely untested.

No worries there since I'll be resubmitting dm-writecache for 4.19.

(Mikulas would like to still use swait for the dm-writecache's endio
thread, since endio_thread_wait only has a single waiter.  I told him to
convert the other 2, benchmark it with still swait in endio path, then
convert the one used in endio, benchmark will all converted and we'd
revisit if there is a compelling performance difference.  But even then
I'm not sure I want DM on the list of swait consumers... to be
continued)
