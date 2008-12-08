From: Mikulas Patocka <mpatocka@redhat.com>
Subject: ANNOUNCE: consolidated patches for shared snapshots
Date: Sun, 7 Dec 2008 22:41:19 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0812072212380.19378@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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
To: Alasdair G Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Hi

I released new patches for shared snapshots. The functionality is the same 
as in previous releases, but the two snapshot exception stores, one 
created by Fujita Tomonori and one by me, are consolidated and common code 
is shared.

The patches are at:
http://people.redhat.com/mpatocka/patches/kernel/new-snapshots/

The patches don't alter existing snapshot implementation, they contain 
just new files (they alter only Kconfig and Makefile to make the new files 
compilable).

The new architecture is as follows:

The module dm-multisnapshot.ko contains common code for both exception 
stores. It has basically processing and queuing IOs and attaching 
snapshots and interfacing with device mapper.

This module loads the specific module for a given exception store:
dm-store-mikulas.ko for my store or dm-store-fujita-daniel.ko for Zumastor 
store. In the target constructor, there's an argument "mikulas" or 
"fujita-daniel" that tells which module to load.

The interface is what I designed --- the point is that Fujita's code can 
be converted to use my interface, but my code cannot be converted to use 
Fujita's interface --- so if we want to drive both exception stores with 
the same userspace code (we definitely want!), then there's no other 
option but to use my interface.

The difference from Fujita's old interface is that in my interface the 
kernel selects snapshot ID when creating a new snapshots and in old 
Fujita's interface the user selected it. For my snapshot store, it is a 
design requirement that the snapshot ID is seleted by the kernel driver.

There is really almost nothing to be shared with the old snapshot code. 
The data structures and the interface are have different logic --- for the 
old snapshots, there was one small structure for the origin and several 
big structures for the snapshots; for the new snapshots, there is one big 
structure for the origin and several small structures for the snapshots. 
So I wouldn't recommend to attempt to glue the new code on the old 
snapshots.

For Fujita:
You can take the file that I created and continue development on it.
I fixed some other bugs or non-portable constructs in the code, I marked 
them as comments so that you can review the fixes. I took the code from 
ftp://ftp.kernel.org/pub/linux/kernel/people/tomo/dm-snap/2008-11-26/ and 
ported it, so if you meanwhile made some other changes your the code, diff 
your changes against 2008-11-26 version and apply the diff by hand to the 
file that I release.

Mikulas
