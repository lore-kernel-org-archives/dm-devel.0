From: Andi Kleen <ak@linux.intel.com>
Subject: Re: dm-crypt parallelization patches
Date: Tue, 3 Sep 2013 13:07:02 -0700
Message-ID: <20130903200702.GJ16724@tassilo.jf.intel.com>
References: <alpine.LRH.2.02.1309031457480.28146@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1309031457480.28146@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: dm-devel@redhat.com, Milan Broz <gmazyland@gmail.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Sep 03, 2013 at 03:06:03PM -0400, Mikulas Patocka wrote:
> Hi Andi
> 
> You wrote the original dm-crypt paralllelization patch (commit 
> c029772125594e31eb1a5ad9e0913724ed9891f2). This patch improves 
> parallelization, it makes data being encrypted on the same CPU that 
> submitted the request.

The motivation for my patches was to make large systems with many
cores scale.

I think the motivation for yours is to make small systems without
hardware crypto offload slightly faster.

That's fine (although I suspect it's more and more obscure), as long as
you don't impact the large systems scalability.

Can you do some tests with a larger system with very parallel IO
(many CPUs submitting)  and see if the IO rate is equivalent?

If that's given the patches are ok for me.

-Andi
