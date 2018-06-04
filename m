From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git pull] device mapper changes for 4.18
Date: Mon, 4 Jun 2018 12:39:11 -0700
Message-ID: <CA+55aFwkyzV81yEjoFAcjQ68PXxjZ_k-o+oYMobeVMFuj72OHQ@mail.gmail.com>
References: <20180604153254.GA4793@redhat.com>
	<CA+55aFyZk6Yeo0DSdakROxXRPvx9HWutbP1TwfoFd6fi-1FSUw@mail.gmail.com>
	<20180604190922.GA5586@redhat.com>
	<CA+55aFyEVcS11N_7BwKV=k0RDqAWdMTJyWDpuFmkXy796k26_w@mail.gmail.com>
	<20180604193653.GC12217@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180604193653.GC12217@hirez.programming.kicks-ass.net>
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

On Mon, Jun 4, 2018 at 12:37 PM Peter Zijlstra <peterz@infradead.org> wrote:
>
> Would it help if we did s/swake_up/swake_up_one/g ?
>
> Then there would not be an swake_up() to cause confusion.

Yes, i think that would already be a big improvement, forcing people
to be aware of the exclusive nature.

           Linus
