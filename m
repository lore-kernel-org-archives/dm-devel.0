From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [git pull] device mapper changes for 4.18
Date: Mon, 4 Jun 2018 21:36:53 +0200
Message-ID: <20180604193653.GC12217@hirez.programming.kicks-ass.net>
References: <20180604153254.GA4793@redhat.com>
	<CA+55aFyZk6Yeo0DSdakROxXRPvx9HWutbP1TwfoFd6fi-1FSUw@mail.gmail.com>
	<20180604190922.GA5586@redhat.com>
	<CA+55aFyEVcS11N_7BwKV=k0RDqAWdMTJyWDpuFmkXy796k26_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CA+55aFyEVcS11N_7BwKV=k0RDqAWdMTJyWDpuFmkXy796k26_w@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Mon, Jun 04, 2018 at 12:29:21PM -0700, Linus Torvalds wrote:
> On Mon, Jun 4, 2018 at 12:09 PM Mike Snitzer <snitzer@redhat.com> wrote:
> >
> > Mikulas elected to use swait because of the very low latency nature of
> > layering ontop of persistent memory.  Use of "simple waitqueues"
> > _seemed_ logical to me.
> 
> I know. It's actually the main reason I have an almost irrational
> hatred of those interfaces. They _look_ so simple and obvious, and
> they are very tempting to use. And then they have that very subtle
> issue that the default wakeup is exclusive.

Would it help if we did s/swake_up/swake_up_one/g ?

Then there would not be an swake_up() to cause confusion.
