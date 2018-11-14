From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [patch 5/5] block: use a driver-specific handler for
 the "inflight" value
Date: Wed, 14 Nov 2018 17:35:43 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1811141726480.7875@file01.intranet.prod.int.rdu2.redhat.com>
References: <20181106213858.391264280@debian-a64.vm>
	<20181108145240.GA20087@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181108145240.GA20087@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids



On Thu, 8 Nov 2018, Christoph Hellwig wrote:

> On Tue, Nov 06, 2018 at 10:35:03PM +0100, Mikulas Patocka wrote:
> > Device mapper was converted to percpu inflight counters. In order to
> > display the correct values in the "inflight" sysfs file, we need a custom
> > callback that sums the percpu counters.
> 
> The attribute that calls this is per-partition, while your method
> is per-queue, so there is some impedence mismatch here.

Device mapper doesn't use partitions.

> Is there any way you could look into just making the generic code
> use percpu counters?

In the next merge window, single-queue request-based block drivers will be 
eliminated - all the drivers will be multiqueue. So, they won't use 
the in_flight variables at all.

in_flight will be only use by bio-based stacking drivers like md.

> Also please cc linux-block on patches that touch the generic block
> code.

Mikulas
