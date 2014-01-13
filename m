From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 7/7] dm-snapshot: use bufio prefetch
Date: Mon, 13 Jan 2014 17:03:56 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1401131700490.12957@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401111222400.4018@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401111228220.4018@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401111229150.4018@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401111229390.4018@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401111230080.4018@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401111230330.4018@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401111231000.4018@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401111231420.4018@file01.intranet.prod.int.rdu2.redhat.com>
	<20140113212719.GB3268@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140113212719.GB3268@redhat.com>
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
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids



On Mon, 13 Jan 2014, Mike Snitzer wrote:

> The patch header should speak to why 12 is adequate.  Your 0th patch
> header said we should do further testing to arrive at a good value.

12 is optimal on my system (dm-loop on filesystem on 15k SCSI disk).

> I think a follow-on patch should make the 'prefetch_chunks' configurable.

I think the user wouldn't configure it anyway.

Find a configuration scenario where this request for prefetch came from 
and find the optimal value for that scenario.

> The dm_exception_store structure has a 4 byte hole before the context
> member.  Making prefetch_chunks configurable (either from table load or
> dm-snapshot module param) would help future-proof this code.

Mikulas
