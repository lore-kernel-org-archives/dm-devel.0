From: Andi Kleen <ak@linux.intel.com>
Subject: Re: dm-crypt parallelization patches
Date: Wed, 11 Sep 2013 16:33:35 -0700
Message-ID: <20130911233335.GN11427@tassilo.jf.intel.com>
References: <alpine.LRH.2.02.1309031457480.28146@file01.intranet.prod.int.rdu2.redhat.com>
	<20130903200702.GJ16724@tassilo.jf.intel.com>
	<alpine.LRH.2.02.1309101947440.30003@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1309101947440.30003@file01.intranet.prod.int.rdu2.redhat.com>
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

> The patches mainly help with sequential I/O (sequential I/O is normally 
> submitted from a few CPUs, so existing dm-crypt doesn't parallelize 
> right). There is a decrease of performance when 12 threads are doing 
> writes on ramdisk:

That's a bit worrying. Could you please find a larger system (4S) in RH and
try with that?

I suspect you may need to limit the load balancing to smaller groups
of CPUs. Querying all other CPUs all the time is unlikely to scale.

-Andi
