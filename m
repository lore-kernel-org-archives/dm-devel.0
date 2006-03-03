From: Dan Smith <danms@us.ibm.com>
Subject: dm-cow: A userspace-controlled CoW implementation
Date: Fri, 03 Mar 2006 15:22:47 -0800
Message-ID: <877j7bglko.fsf@caffeine.beaverton.ibm.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi list,

I wanted to send out a link to my latest work on dm-cow.  I actually
have a working cow daemon and example plugin.  I am able to
successfully run bonnie against a filesystem backed by dm-cow, as well
as boot a Xen domain with a root device backed by dm-cow.

Performance is not great for disk-intensive workloads (of course), but
it is suitable for sharing a root disk image among virtual machines.
Right now with Xen, I see about a 50% performance hit over native,
when using loop-based CoW space.

Comments are welcome, as well as bug reports (if anyone is interested
in trying it out).

The kernel module and userspace tool code can be pulled from my
mercurial repository, located here:

  http://static.danplanet.com/hg/dm-cow/

The kernel module is getting pretty close to where it needs to be, I
think.  The daemon is quite ugly at the moment, but it works.

For those that don't remember, this is my original proposal for
dm-cow (updated of course):

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
Obviously, this would not lend itself to deferring to userspace.

Design
------
I have created a dm-cow module that would be initialized by a table
entry like this:

  0 100 cow ident /dev/hdb /dev/hdc 1024

The first argument is a unique identifier that allows all dm-cow
targets in a given table to coordinate with each other.  The next two
arguments are the base and CoW devices and the fourth argument is the
chunk size.  Reads to unaltered blocks are passed directly, just as
dm-linear does; write requests are queued.  The userspace daemon
(which polls or blocks on a character device) reads write requests,
makes a block-allocation decision for each, and writes a response back
to the character device.  This response write will trigger a copy of
the originating block to the CoW device, and, upon completion, a flush
of the queued write.

Subsequent accesses that arrive while waiting for userspace to provide
the mapping are queued with the initial write and are flushed after
the block copy has completed.

Periodically, the userspace daemon reloads the device with a new table
that uses dm-linear to map modified blocks directly into the CoW
device.  This eliminates the need to replicate the existing fast table
searching code.  The kernel module maintains a temporary list of
remapped blocks for use until a table reload occurs.

-- 
Dan Smith
IBM Linux Technology Center
Open Hypervisor Team
email: danms@us.ibm.com
