From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [git pull] device mapper changes for 4.18
Date: Tue, 5 Jun 2018 10:59:21 +0200
Message-ID: <20180605085921.GG12217@hirez.programming.kicks-ass.net>
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
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CA+55aFz8WL99++EeU=HjSo=w153zwsFqNaRcQk+nkjf8u_3beQ@mail.gmail.com>
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

On Mon, Jun 04, 2018 at 03:16:31PM -0700, Linus Torvalds wrote:
> We've always had that issue, and yes, we should handle it fine. Code
> that doesn't handle it fine is broken, but I don't think we've ever
> had that situation.

We've had a whole bunch of broken. We fixed a pile of them a few
years back but I'm sure that if you look hard you can still find a few.

The one commit I can readily find is:

  91f65facba5a ("iommu/amd: Fix amd_iommu_free_device()")

But I'm fairly sure there was more..
