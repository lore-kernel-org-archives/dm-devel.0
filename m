From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git pull] device mapper changes for 4.18
Date: Tue, 5 Jun 2018 08:53:14 -0700
Message-ID: <CA+55aFz_g8UJNOJk2-gMb2rfvWsDEMDQhXxS9YK0dhrtiMfJTg@mail.gmail.com>
References: <CA+55aFyZk6Yeo0DSdakROxXRPvx9HWutbP1TwfoFd6fi-1FSUw@mail.gmail.com>
	<20180604190922.GA5586@redhat.com>
	<CA+55aFyEVcS11N_7BwKV=k0RDqAWdMTJyWDpuFmkXy796k26_w@mail.gmail.com>
	<20180604193653.GC12217@hirez.programming.kicks-ass.net>
	<CA+55aFwkyzV81yEjoFAcjQ68PXxjZ_k-o+oYMobeVMFuj72OHQ@mail.gmail.com>
	<20180604195858.GD12217@hirez.programming.kicks-ass.net>
	<20180604211343.GB6079@redhat.com>
	<CA+55aFwSyiotexs3omf76=Ooo_rJFwdcpw=nF5pMd4bNkvN89A@mail.gmail.com>
	<alpine.LRH.2.02.1806041734390.11883@file01.intranet.prod.int.rdu2.redhat.com>
	<CA+55aFz8WL99++EeU=HjSo=w153zwsFqNaRcQk+nkjf8u_3beQ@mail.gmail.com>
	<20180605085921.GG12217@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180605085921.GG12217@hirez.programming.kicks-ass.net>
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
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Tue, Jun 5, 2018 at 1:59 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> We've had a whole bunch of broken. We fixed a pile of them a few
> years back but I'm sure that if you look hard you can still find a few.
>
> The one commit I can readily find is:
>
>   91f65facba5a ("iommu/amd: Fix amd_iommu_free_device()")

Ugh, ok, I stand corrected.

These things definitely are bugs and they aren't even because of some
"old model", because we've pretty much always had the "loop to wait"
rule.

Even going back to linux-0.01, when we had that "sleep_on()" primitive
that is really bad (because of fundamental races), we had code like
this:

    static inline void wait_on_buffer(struct buffer_head * bh)
    {
        cli();
        while (bh->b_lock)
                sleep_on(&bh->b_wait);
        sti();
    }

and the above wasn't some fluke that I searched for, they're all that
way (and by "all" I mean "the first three I looked at", which probably
means that if I had looked at a fourth, I'd have found somebody
violating the "loop on condition" rule ;)

               Linus
