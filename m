From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git pull] device mapper changes for 4.18
Date: Mon, 4 Jun 2018 14:22:32 -0700
Message-ID: <CA+55aFwSyiotexs3omf76=Ooo_rJFwdcpw=nF5pMd4bNkvN89A@mail.gmail.com>
References: <20180604153254.GA4793@redhat.com>
	<CA+55aFyZk6Yeo0DSdakROxXRPvx9HWutbP1TwfoFd6fi-1FSUw@mail.gmail.com>
	<20180604190922.GA5586@redhat.com>
	<CA+55aFyEVcS11N_7BwKV=k0RDqAWdMTJyWDpuFmkXy796k26_w@mail.gmail.com>
	<20180604193653.GC12217@hirez.programming.kicks-ass.net>
	<CA+55aFwkyzV81yEjoFAcjQ68PXxjZ_k-o+oYMobeVMFuj72OHQ@mail.gmail.com>
	<20180604195858.GD12217@hirez.programming.kicks-ass.net>
	<20180604211343.GB6079@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180604211343.GB6079@redhat.com>
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
Cc: Peter Zijlstra <peterz@infradead.org>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Jun 4, 2018 at 2:13 PM Mike Snitzer <snitzer@redhat.com> wrote:
>
> (Mikulas would like to still use swait for the dm-writecache's endio
> thread, since endio_thread_wait only has a single waiter.

If you already know it has a single waiter, please don't use a queue at all.

Just have the "struct task_struct *" in the waiter field, and use
"wake_up_process()". Use NULL for "no process".

That's *much* simpler than swait(), and is a well-accepted traditional
wake interface. It's also really really obvious.

The "there is only a single waiter" is *NOT* an excuse for using
swait. Quite the reverse. Using swait is stupid, slow, and complex.
And it generates code that is harder to understand.

And yes, the fact that KVM also made that completely idiotic choice in
their apic code is not an excuse either. I have no idea why they did
it either. It's stupid. In the kvm case, I think what happened was
that they had a historical wait-queue model, and they just didn't
realize that they al;ways had just one waiter, so then they converted
a waitqueue to a swait queue.

But if you already know there is only ever one waiter, please don't do
that. Just avoid queues entirely.

                  Linus
