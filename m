From: Daniel Phillips <phillips@phunq.net>
Subject: [RFC] An alternative interface to device mapper
Date: Wed, 5 Mar 2008 01:29:42 -0800
Message-ID: <200803050129.43172.phillips@phunq.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-kernel@vger.kernel.org
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Q: If you have an axe with a rusty head and a rotten handle, how do you 
repair it?

A: It is a two step process.  First you replace the handle, then you 
replace the head.

At one time, volume management on Linux was new and shiny.  Today it has 
fallen well behind Sun, FreeBSD, NetApp and even Microsoft.  In order 
to avoid losing even more of the storage "market" than we have already 
lost, we must make a concerted effort to catch up with the state of the 
art, or ideally take the lead as has proved possible with so many other 
aspects of Linux.

This RFC is about replacing the handle of our not-so-shiny LVM axe.  
Design goals for this alternative "ddsetup" interface are:

  * Convenient to embed in a C program
  * Make it simple enough that a library is unnecessary
  * Support for creating detailed, accurate error messages
  * Error messages delivered to caller rather than logged
  * Naturally extensible as new requirements emerge
  * 32 bit ABI works on 64 bit kernel without translation
  * Avoid bad API practices identified by [ARND 07]
  * Do not break the existing ioctl interface

The patch below includes a new kernel interface generator called ddlink.  
The ddsetup device mapper interface is an instance of a ddlink 
interface, instantiated by supplying domain-specific methods for read, 
write, ioctl and poll.

In more detail: ddlink is a generic pipe-like interface for controlling 
device drivers.  It was inspired by Trond's venerable and successful 
rpc-pipefs, which he invented to control various aspects of NFS server 
and client operation.  ddlink takes the form of a virtual filesystem 
with no namespace.  It provides application programs with fd objects 
that can be read, written, ioctled and polled, suitable for efficient 
binary communication with kernel components.  Read, write and poll 
operations act similarly to a pipe.  Unlike a pipe, there is no write 
buffering.  Each write to a ddlink directly triggers some kernel 
handler.  Reads are buffered via an output queue of ddlink "items", each 
of which is an unrestricted blob.  Ioctls on ddlinks are unrestricted 
and the ioctl command space is unpolluted.

There are no partial reads on ddlinks.  A read call either provides 
enough space to hold the next outbound kernel item or EIO is triggered, 
meaning "make your buffer bigger and try again".  In practice this 
arrangement takes the onus off the userspace program to buffer partial 
reads in order to reassemble input that would otherwise be brutally 
dismembered.  As a bonus, the kernel code for ddlink is considerably 
simplified versus Trond's rpc-pipefs precursor.

Unlike a pipe, there is no waiting for input on a ddlink: if there is 
nothing to read then the read returns immediately with zero length.  If 
some other behavior is desired it can be obtained using poll.

There is a simple framework to provide for generalized allocation and 
destruction of dditems, the internal transaction unit for a ddlink.  
Finally, there is a small library of helper funcations that are useful 
for creating domain-specific ddlink interfaces.  The core code for 
ddlink is about 150 lines of lindented C, plus 100 lines of library 
functions and a header file that has already ballooned to the 
intimidating size of 50 lines.  In other words, ddlink is about as 
light and tight as an interface gets.  It is also highly efficient, 
flexible and extensible, and requires very little boilerplate code.

I do not know whether the lack of a ddlink namespace is a bug or a 
feature.  In current usage, a ddlink fd is delivered to an application 
program by some out of band means.  For example, to get a ddsetup ddlink 
to control device mapper, you ioctl /dev/mapper/control.  Makes sense? 
One can imagine many other methods of obtaining a ddlink, for example, 
by reading a fd number in ascii from a sysfs file (gah).  In practice, 
lacking a namespace feels more like a feature than a bug.

A quick tour of the ddlink library:

int ddlink(struct file_operations *fops,
	void *(*create)(struct ddinode *dd, void *info), void *info)

   Create a new ddlink fd that will use the supplied file operations.
   An optional create method may be supplied and arbitrary state 
   information supplied via "info".  (I am not sure why I set up the
   create as a callback, but I do recall that when I tried to do it
   otherwise, conciseness of usage was degraded.  I might revisit this
   detail.)

void ddlink_queue(struct ddinode *dd, struct dditem *item)

   Queue an output data item onto the tail of the output queue.

void ddlink_push(struct ddinode *dd, struct dditem *item)

   Push an output data item onto the head of the output queue.  Useful
   for error messages or transaction-type calls that can return data
   without disturbing any preexisting queue contents

struct dditem *ddlink_pop(struct ddinode *dd)

   Remove a data item from the front of the queue

struct dditem *dditem_new(struct ddinode *dd, size_t size)

   Create a new dditem with the indicated data size, whose char data
   area is available as item->data

void ddlink_clear(struct ddinode *dd)

   Destroy all queued data items

int ddlink_ready(struct ddinode *dd)

   Returns true if the ddlink queue is nonempty

unsigned ddlink_poll(struct file *file, poll_table *table)

   A simple poll method that only supports polling for input,
   nearly always just what is needed

int ddlink_error(struct ddinode *dd, int err, const char *fmt, ...)

   Format and push an error item onto the queue so that the error
   text will be retrieved by the next read from the ddlink

So that is ddlink, short and sweet.  Only a couple of trivial glue 
functions were omitted.  The remainder of this note is about ddsetup, 
which is the single extant example of a ddlink interface.

Device Mapper is actually a lot more capable than most people know.  
Each device mapper device consists of two layers: the virtual device 
exposed to applications, and an underlying table of "target devices", 
each of which is effectively a virtual block device in itself.

The "map" part of device mapper is about translating each bio directed 
at the virtual device into one or more bio transfers to some contiguous 
subset of the underlying device table.  In addition, device mapper 
implements stacking, whereby additional layers of virtual devices can 
be inserted into an existing top level virtual device while that device 
remains open and in use.  Details of how this is accomplished are 
surprisingly simple, but outside the scope of today's note.  The 
important thing here is to get a sense of just how rich the device 
mapper interface needs to be in order to expose the full range of 
device mapper capabilities to application programs.

Device mapper is currently exposed to userland via a stupifyingly 
complex interface, in which 16 different device mapper subfunctions are 
multiplexed via ioctls through one grand unified parameter structure.  
This interface has proved so unwieldy that exactly one userspace program 
uses it, namely libdevmapper.  Unfortunately, libdevmapper brings its 
own oddly structured interface to the party, in which a series of ioctl 
calls is recast as a "task", a thoroughly unsuccessful abstraction.  As 
far as I know, the libdevmapper interface is only used by three 
userspace programs: dmsetup, lvm2 and cryptsetup.  There may be others, 
but the point is, if this interface were well suited to its task then 
there would be lots of programs using it by now.  Instead nearly all 
device mapper usage continues to be scripted via dmsetup or (less 
commonly) lvm2 commands, or carried out manually using the lvm2 
interactive interface.

This many years into the effort we ought to be slicing and dicing 
volumes as second nature, changing configuration on the fly, 
transparently expanding, shrinking and migrating filesystems, and many 
other things that ZFS and GEOM are already doing and we are not.  It is 
not so much that device mapper is incapable of such fancy tricks, but 
that we have taken a very powerful kernel subsystem and hobbled it with 
a nearly unusable application interface.  Think about a jet turbine 
racecar with a two inch air intake.

So here I have attempted to create a granular interface to expose the 
same functionality as the existing device mapper ioctl interface does, 
but in a transparent and easy enough way that no library is required, 
and concise enough that when you need to, you can realistically embed
your lvm operations inline in a C program.

The ddsetup design does not abandon ioctls entirely.  Though ddlink is 
perfectly capable of implementing the entire interface via rpc-like 
write and read calls with function codes included in-line, this style 
does not map well onto the expressive capabilities of C.  A mix of 
writes and ioctls ended up looking better on the page and is easier to 
write.

In general, ddsetup uses write calls for variable length data and ioctls 
for fixed length structures.  One could also say: writes for data and 
ioctl commands for, ahem, commands.

There is a little state machine inside a ddsetup fd that keeps track of 
where you are in midst of a complex call sequence, particularly the 
device create sequence.  Using ddsetup, you push strings onto a stack 
with write calls and turn the strings into more complex objects using 
ioctls.  If you make a mistake and get a -1 error return from any
of the calls, you can then read from the ddlink to get a text 
description of what went wrong, complete with message formatting 
courtesy of the ddlink_error convenience function.

For example, given a ddsetup fd named dd:

   ioctl(dd, DMTABLE, &(struct ddtable){ .targets = 1 });
   write(dd, "linear", 6);
   write(dd, "/dev/hda5", 9);
   write(dd, "1234", 4);
   ioctl(dd, DMTARGET, &(struct ddtarget){ .sectors = 10000 });
   write(dd, "foo", 3);
   ioctl(dd, DMCREATE);
   read(dd, &result, sizeof(result));

Leaving out error handling for clarity, this creates a 10,000 sector 
virtual device named "foo" which is a linear mapping of hda5 starting 
at sector offset 1234, equivalent to the shell command:

   echo 0 10000 linear /dev/ubdb 1234 | dmsetup create foo

Except that we did not use the shell, or a library, just a header file 
to name the ioctl commands and provide some simple interface structs.
(Actually, the example above is more complex than necessary. I do not 
think the .targets field serves any useful purpose, and I will make it 
go away soon.)

Reflecting device mapper's table structured arrangement, the sequence 
from the "linear" write to the DMTARGET ioctl may be repeated 
arbitrarily many times to build up a complex mapping.  In fact, this is 
how device mapper maps extents from an lvm partition to your 
lvm "partitions".  Easy, no?  Well it is when written as above.

Such mappings are not restricted to linear targets.  Some fancy mappings 
have linear targets at each end and a temporary mirror of two devices 
in the middle.  This is how lvm2 implements pvmove, its clever ability 
to relocate physical targets of a virtual device while the device is 
running.  Powerful, and practically unknown to most Linux users.  
According to me, that is because it is hard to write programs to drive 
such functionality.  As a result, when Linux users do it, they do it by 
hand.  Solaris users are having a party with this kind of thing, and 
laughing at us.  Really.

There is not a lot more to say about ddsetup, which is actually the 
point.  It is pretty obvious how to use it, and how it is implemented.  
I did have to do some pretty serious spelunking in dm-ioctl.c to ferret 
out the bits of device mapper that do the actual work, in some cases 
having to go pretty deep to work past dependencies on the monolithic 
ioctl interface struct.  Some header files needed to be rearranged, 
arguably into the form they should have taken in the first place.  
There are some needlessly strange object lifetime rules to deal with 
internally, but otherwise this was a pretty straightforward romp.

An early version of this code was shown to Eric Biederman and Alasdair 
Kergon at OLS last year.  After taking all the C99 bits out, I managed 
to convince Eric and others to actually read the examples.  Let us now 
see if the (positive) reaction I observed at that time survives wider 
scrutiny.

A diffstat for ddlink and ddsetup together:

 Documentation/ioctl-number.txt |    1
 block/ll_rw_blk.c              |    2
 drivers/Makefile               |    1
 drivers/ddlink.c               |  294 ++++++++++++++++++++
 drivers/md/Makefile            |    1
 drivers/md/dm-ioctl.c          |  593 ++++++++++++++++++++++++++++++++++++++---
 drivers/md/dm-table.c          |   52 ---
 drivers/md/dm.c                |   53 ---
 drivers/md/dm.h                |   78 +++++
 include/linux/ddlink.h         |   41 ++
 include/linux/ddsetup.h        |   36 ++
 include/linux/device-mapper.h  |   37 ++
 12 files changed, 1056 insertions(+), 133 deletions(-)

Currently, this implements a majority of the device mapper interface 
calls, but not all of them, so expect another hundred or two lines 
before completion.  This is still significantly less code than the 
original ioctl interface (which is still in there) and much clearer.

I have written two example programs, ddsetup.c and ddcreate.c.  The 
former aims to be a drop-in replacement for dmsetup.c and the latter 
implements a (useful) demonstration command that creates a virtual 
device consisting of a single device mapper target, with all target 
parameters supplied on the command line.

For example:

   ddcreate foo 10000 linear /dev/ubdb 1234

ddcreate is 71 lines long including plenty of whitespace, while being 
quite general.  My message is about the 71 lines.

So who uses this ddsetup today?  Answer: nobody.  Better answer: the 
ddsnap cluster snapshot driver has a usability problem because of its 
reliance on PF_LOCAL sockets to glue components together.  Filesystem 
based sockets were adopted for the component glue because it is hard to 
do anything more elegant working with the command line device mapper 
setup utility.  We looked at hacking the device mapper ioctl interface 
to do what we needed, but then if we were willing to go that far then 
why not just drop the other shoe and improve the userspace interface to 
the point where it is actually pleasant to use, and maintainable too?  
This is how ddsetup was born.

The next thing we need to do with this interface is demonstrate a solid 
use case by adopting it on an experimental branch of zumastor.  I 
expect both ddsnap and zumastor systems to shrink as a result, 
including significantly shrinking the documentation.  This has not yet 
been done yet, and until it is, this effort deserves to be firmly 
relegated to the "nice but so what" category.  So, profound thanks to 
you, dear reader, for having had the stamina to read all the way to 
here, and we will see you here again after having eaten this delicious 
new dogfood ourselves.

http://code.google.com/p/zumastor/source/browse/www/ddsetup/ddsetup-2.6.23.12
http://code.google.com/p/zumastor/source/browse/www/ddsetup/ddsetup.c
http://code.google.com/p/zumastor/source/browse/www/ddsetup/ddcreate.c

[ARND 07] How to not invent kernel interfaces, Arnd Bergmann, 
   arnd@arndb.de, July 31, 2007
