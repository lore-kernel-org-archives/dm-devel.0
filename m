From: Dan Smith <danms@us.ibm.com>
Subject: [RFC] Userspace-Controlled CoW Device
Date: Fri, 03 Feb 2006 14:18:56 -0800
Message-ID: <87fyn03x2n.fsf@caffeine.beaverton.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi all,

I'm planning to begin work on a device mapper extension for flexible
CoW devices.  By flexible, I mean that the block-allocation decisions
are made by a userspace daemon, as opposed to the current kernel-based
method used by dm-snap.  Below, I explain my motivation and proposed
design.  I would appreciate comments, criticisms, and suggestions.

Motivation
----------
By moving the block-allocation decisions from kernel to userspace,
you gain the ability to easily support different algorithms.  For
example, a plugin could be written that would allow reading and
writing of QEMU's qcow disk images.  Xen would directly benefit from
this feature.

I did investigate extending the existing exception-store facility in
dm-snap, but decided against it.  AFAICT, dm-snap expects to write a
block immediately after letting the store decide where to put it.
Obviously, this would not lend itself to deferring to userspace.  If a
modification to dm-snap would be preferred to a separate
implementation, I could focus my efforts there.  I think, however,
that putting the complexity into userspace rather than kernel space
would be a Good Thing.

Design
------
I plan to create a dm-cow module that would be initialized by a table
entry like this:

  0 100 cow /dev/hdb /dev/hdc [32]

The first two arguments would be the base and CoW devices and the
optional third argument would be the chunk size in megabytes.  Reads
to unaltered blocks are passed directly, just as dm-linear does; write
requests are queued.  The userspace daemon (which polls or blocks on a
character device) will read write requests, make a block-allocation
decision for each, and write a response back to the character device.
This response write will trigger a copy of the originating block to
the CoW device, and, upon completion, a flush of the queued write.

Subsequent accesses that arrive while waiting for userspace to provide
the mapping will be queued with the initial write and flushed after
the block copy has completed.

Periodically, the userspace daemon would reload the device with a new
table that uses dm-linear to map modified blocks directly into the CoW
device.  This would eliminate the need to replicate the existing fast
table searching code.  The kernel module would maintain a temporary
list of remapped blocks for use until a table reload occurs.

Comments?

I've been working on a proof-of-concept of the above design.  It is
all bubble-gum-and-duct-tape right now.  Below is a link to the
work-in-progress kernel module, if anyone is interested.

  http://static.danplanet.com/tmp/dm-cow.c

-- 
Dan Smith
IBM Linux Technology Center
Open Hypervisor Team
email: danms@us.ibm.com
