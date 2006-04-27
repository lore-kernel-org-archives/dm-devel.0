From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: [RFC] dm-userspace
Date: Thu, 27 Apr 2006 09:09:55 -0400
Message-ID: <1146143395.5436.25.camel@localhost.localdomain>
References: <87u08g553l.fsf@caffeine.beaverton.ibm.com>
	<1146092129.14129.333.camel@localhost.localdomain>
	<87psj45420.fsf@caffeine.beaverton.ibm.com>
	<1146094877.14129.343.camel@localhost.localdomain>
	<87irov69l3.fsf@caffeine.beaverton.ibm.com>
Reply-To: mingz@ele.uri.edu,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <87irov69l3.fsf@caffeine.beaverton.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Dan Smith <danms@us.ibm.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Wed, 2006-04-26 at 19:22 -0700, Dan Smith wrote:
> MZ> o. :P 50% is a considerable amount. anyway, good start. ;)
> 
> Indeed, it is a considerable performance hit, but I haven't really
> done much in the way of a serious performance analysis.
> 
> MZ> pure read or read and write mixed?
> 
> Actually IIRC, that was the write performance only (I used bonnie++ to
> get the numbers).  I believe the read performance is generally good
> for large blocks.  If the block is already mapped for write, then you
> get the reads for free.  I really should resurrect my older tests and
> see if I can produce something more current :)

yes, considering you load a mapping for every 2MB data block, then it
should close to dm-linear for sequential read.

> 
> My previous numbers were gathered by using an additional step of
> actually rewriting the device-mapper table periodically, using
> dm-linear to statically map blocks that were mapped for writing.  I
> think that with a better data structure in dm-userspace (i.e. better
> than a linked-list), performance will be better without the need to
> constantly suspend and resume the device to change tables.

ic. sounds reasonable.

> 
> MZ> if this is the scenario, then may be more aggressive mapping can
> MZ> be used here.
> 
> Right, so the userspace side may be able to improve performance by
> mapping blocks in advance.  If it is believed that the next several
> blocks will be written to sequentially, the userspace app can push
> mappings for those in the same message as the response to the initial
> block, which would eliminate several additional requests.

this is like the prefetch of mapping information.

> 
> Perhaps something could be done with certain CoW formats that would
> allow the userspace app to push a bunch of mappings that it believes
> might be needed, and then have the kernel report back later which were
> actually used.  In that case, you could reclaim space in the CoW
> device that you incorrectly predicted would be needed.

right. and i think this might be COW formats unrelated. this solely
depends on the mapping logic at user space to do intentional allocation,
tracing, and cleaning.

> 
> MZ> u might have interest on this. some developers are working on a
> MZ> general scsi target layer that pass scsi cdb to user space for
> MZ> processing while keep data transfer in kernel space. so both of u
> MZ> will meet same overhead here. so 2 projects might learn from each
> MZ> other on this.
> 
> Great!

project name is stgt, you can find it at berlios.de, which is down right
now. :P


> 
> MZ> ps, trivial thing, the userspace_request is frequently used and
> MZ> can use a slab cache.
> 
> Ah, ok, good point... thanks ;)
> 
