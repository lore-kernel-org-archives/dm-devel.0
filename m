From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Persistent memory interface
Date: Fri, 19 Jun 2015 12:52:30 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1506191251250.2479@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1506191211480.30318@file01.intranet.prod.int.rdu2.redhat.com>
	<20150619164825.GB1971@linux.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150619164825.GB1971@linux.intel.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Matthew Wilcox <willy@linux.intel.com>
Cc: linux-nvdimm@ml01.01.org, dm-devel@redhat.com
List-Id: dm-devel.ids



On Fri, 19 Jun 2015, Matthew Wilcox wrote:

> On Fri, Jun 19, 2015 at 12:33:09PM -0400, Mikulas Patocka wrote:
> > If I want to use persistent memory in another driver, for a different 
> > purpose, how can I make sure that that drivers/block/pmem.c doesn't attach 
> > to this piece of memory and export it? It seems not possible. 
> > drivers/block/pmem.c attaches to everything without regard that there may 
> > be other users of persistent memory.
> 
> You need to look at the patches that Dan has been posting to add support
> for Labels (and NFIT and ...).  Those weren't available earlier because
> the label spec wasn't public.

Please, give me a link to those patches.

Mikulas
