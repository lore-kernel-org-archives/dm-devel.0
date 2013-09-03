From: Mikulas Patocka <mpatocka@redhat.com>
Subject: dm-crypt parallelization patches
Date: Tue, 3 Sep 2013 15:06:03 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1309031457480.28146@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andi Kleen <ak@linux.intel.com>
Cc: dm-devel@redhat.com, Milan Broz <gmazyland@gmail.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

Hi Andi

You wrote the original dm-crypt paralllelization patch (commit 
c029772125594e31eb1a5ad9e0913724ed9891f2). This patch improves 
parallelization, it makes data being encrypted on the same CPU that 
submitted the request.

I improved that so that encryption is performed by all processors, it uses 
unbound workqueue, so that any processor can do encryption. My patches 
improves performance mainly when doing sequential read - your original 
patch paralellized sequential read badly because most requests were 
submitted by the same cpu.

I put my patch series at 
http://people.redhat.com/mpatocka/patches/kernel/dm-crypt-paralelizace/current/series.html

I'd like if you could look at it and ack it for inclusion in the upstream 
kernel.

Mikulas
