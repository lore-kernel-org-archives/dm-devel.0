From: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Subject: [RFC] [PATCH 0/1] Introduce emergency raid0 stop for
	mounted arrays
Date: Wed,  1 Aug 2018 11:56:07 -0300
Message-ID: <20180801145608.19880-1-gpiccoli@canonical.com>
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
To: linux-raid@vger.kernel.org, shli@kernel.org
Cc: kernel@gpiccoli.net, gpiccoli@canonical.com, neilb@suse.com, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, jay.vosburgh@canonical.com
List-Id: dm-devel.ids

Currently the md driver completely relies in the userspace to stop an
array in case of some failure. There's an interesting case for raid0: if
we remove a raid0 member, like PCI hot(un)plugging an NVMe device, and
the raid0 array is _mounted_, mdadm cannot stop the array, since the tool
tries to open the block device (to perform the ioctl) with O_EXCL flag.

So, in this case the array is still alive - users may write to this
"broken-yet-alive" array and unless they check the kernel log or some
other monitor tool, everything will seem fine and the writes are completed
with no errors. Being more precise, direct writes will not work, but since
usually writes are done in a regular form, i.e., backed by the page
cache, the most common scenario is an user being able to regularly write
to a broken raid0, and get all their data corrupted.

PROPOSAL:
The idea proposed here to fix this behavior is mimic other block devices:
if one have a filesystem mounted in a block device on top of an NVMe or
SCSI disk and the disk gets removed, writes are prevented, errors are
observed and it's obvious something is wrong. Same goes for USB sticks,
which are sometimes even removed physically from the machine without
getting their filesystem unmounted before.

We believe right now the md driver is not behaving properly for raid0
arrays (it is handling these errors for other levels though). The approach
took for raid-0 is basically an emergency removal procedure, in which I/O
is blocked from the device, the regular clean-up happens and the associate
disk is deleted. It went to extensive testing, as detailed below.

Not all are roses, we have some caveats that need to be resolved.
Feedback is _much appreciated_.
There is a caveats / questions / polemic choices section below the test
section.

Thanks in advance,


Guilherme


* Testing:

The device topology for the tests is as follows:


                            md6
                             |
              |******************************|
              |                              |
             md4                            md5
              |                              |
       |*************|                |*************|
       |             |                |             |
      md0           md2              md1           md3
       |             |                |             |
   |*******|       |***|            |***|       |*******|
   |       |       |   |            |   |       |       |
nvme1n1 nvme0n1   sda sdd          sde sdf   nvme2n1 nvme3n1


We chose to test such complex topology to prevent corner cases and timing
issues (which were found in the development phase). There are 3 test
subsets basically: the whole set of devices, called here "md cascade", and
2 small branches, called here "md direct" testing.

So, in summary:

### md direct (single arrays composed of SCSI/NVMe block devices) ###
A1 = md1      A2 = md3
C1 = sde      C1 = nvme2n1
C2 = sdf      C2 = nvme3n1

### md cascade (array composed of md devices) ###
A3 = md6
underlying component UC1 = nvme1n1
underlying component UC2 = sdd
underlying component UC3 = sdf
underlying component UC4 = nvme2n1


### Method of removal ###
- For NVMe devices, "echo 1 > /sys/block/nvmeXnY/device/device/remove"
- For SCSI devices, "echo 1 > /sys/block/sdX/device/delete"
When tests are marked with *, it means PCI/disk hotplug was exercised
too, using the qemu hotplug feature.


### Test ###
Write a file using the command: "dd if=/dev/zero of=tmpfile bs=X" where
X might be 1M or 4K - we've experimented with both.
Each array also contains a valid file to be checked later, in order to
validate that filesystem didn't get severely corrupted after the
procedure.
Tests marked with @ indicate direct writes were tested too.
Tests with a [] indicator exhibited some oddity/issue, detailed in the
caveats section.

After each test, guest was rebooted. We also tested in some cases
re-adding the previously removed SCSI/NVMe device (after unmounting
the previous mount points) and restarting the arrays - worked fine.


* Test results
("partition X" means we have a GPT table with 2 partitions in the device)


### md direct

Remove members and start writing to array right after:
A1 with:                               A2 with:
 -ext4                                  -ext4
 --Removed C1: PASSED @                 --Removed C2: PASSED @

 -xfs                                   -xfs
 --Removed C2: PASSED @                  --Removed C1: PASSED @

 -ext2                                  -btrfs
 --Removed C1: PASSED                   --Removed C2: PASSED

 -partition 1 + ext4                    -partition 1 + xfs
 -partition 2 + xfs                     -partition 2 + ext4
 --Removed C1: PASSED @                 --Removed C2: PASSED @

 -LVM + xfs                             -LVM + ext4
 --Removed C2: PASSED                   --Removed C1: PASSED

Start writing to array and remove member right after:
A1 with:                               A2 with:
 -ext4                                  -ext4
 --Removed C1: PASSED @                 --Removed C1: PASSED @
 --Removed C2: PASSED *@

 -xfs                                   -xfs
 --Removed C1: PARTIAL @ [(a)]          --Removed C1: PASSED *
                                        --Removed C2: PASSED *@

 -ext2                                  -btrfs
 --Removed C2: PASSED @                  --Removed C1: PASSED @

 -partition 1 + ext4                    -partition 1 + xfs
 -partition 2 + xfs                     -partition 2 + ext4
 --Removed C2: PARTIAL @ [(a)]          --Removed C1: PASSED *@


 -LVM + xfs                             -LVM + ext4
 --Removed C1: PASSED                   --Removed C2: PASSED

                                        -fuse (NTFS)
                                        --Removed C2: PASSED

### md cascade

Remove members and start writing to array right after:
A3 with:
 -ext4:
 --Removed UC2: PASSED @
 --Removed UC4: PASSED @

  -xfs:
 --Removed UC2: PASSED @
 --Removed UC4: PASSED @

 -partition 1 + ext4
 -partition 2 + xfs
 --Removed UC1: PASSED
 --Removed UC3: PASSED

 -ext2:
 --Removed UC3: PASSED @

 -btrfs:
 --Removed UC1:  PARTIAL [(d)]

Start writing to array and remove member right after:
A3 with:
 -ext4:
 --Removed UC2: PARTIAL @ [(a), (b)]
 --Removed UC4: PARTIAL @ [(b), (d)]

  -xfs:
 --Removed UC2: PARTIAL @  [(a), (c)]
 --Removed UC4: PARTIAL *@ [(c), (d)]

 -partition 1 + ext4
 -partition 2 + xfs
 --Removed UC1: PASSED *
 --Removed UC3: PASSED

 -ext2:
 --Removed UC3: PASSED @

 -btrfs:
 --Removed UC1: PARTIAL @ [(d)]


* Caveats / points of uncertainty / questions:

a) When using SCSI array members, depending "when" the raid member gets
removed, raid0 driver might not quickly observe a failure in the queue,
because the requests may be all "scheduled" in the SCSI cache to be
flushed to the device. In other words, depending on the timing, the
mechanism used in this patch to detect a failed array member will take
some time to be triggered. It does not happen in direct I/O mode nor with
NVMe - it's related with the SCSI cache sync. As soon a new I/O is queued
in the md device, that triggers the array removal.

#For md cascade only (nested arrays):

b) In the case of direct I/Os, we might face an ext4 journal task blocked
in io_schedule(). Stack trace: https://pastebin.ubuntu.com/p/RZ4qFvJjy2

c) Hung task in xfs after direct I/O only, when trying to unmount
[xlog_wait() or xlog_dealloc_log()]. Stack trace:
https://pastebin.ubuntu.com/p/fq3G45jHX2

d) Some arrays in the nested scenario still show in /sys/block after
the removal.


#Generic questions / polemic choices:

i) With this patch, the STOP_ARRAY ioctl won't proceed in case a disk is
removed and emergency stop routine already started to act, even in case of
unmounted md arrays. This is a change in the old behavior, triggered by
the way we check for failed members in raid0 driver.

ii) Currently, the patch implements a kernel-only removal policy - shall
it rely on userspace (mdadm) to do it? A first approach was based in
userspace, but it proved to be more problematic in tests.

iii) The patch implemented the md_delayed_stop() function to perform the
emergency stop - should we refactor do_md_stop() instead, to encompass
the emergency delayed stop minimal code?

Guilherme G. Piccoli (1):
  md/raid0: Introduce emergency stop for raid0 arrays

 drivers/md/md.c    | 126 +++++++++++++++++++++++++++++++++++++++++----
 drivers/md/md.h    |   6 +++
 drivers/md/raid0.c |  14 +++++
 3 files changed, 136 insertions(+), 10 deletions(-)

-- 
2.18.0
