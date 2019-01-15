From: james harvey <jamespharvey20@gmail.com>
Subject: Re: dm thin pool discarding
Date: Tue, 15 Jan 2019 17:55:51 -0500
Message-ID: <CA+X5Wn6GmVTCnc3g0SPBXir2mGSzau+vNh8z=cZ6yVhXmy8B8g@mail.gmail.com>
References: <CA+X5Wn4fqXZa_Ecc75CfmA2LBq7y8qFzzdDcdFugZwaPgq-Aeg@mail.gmail.com>
	<ba0c0646-29f3-f876-6454-8c80b613a46a@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <ba0c0646-29f3-f876-6454-8c80b613a46a@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Jan 10, 2019 at 4:18 AM Zdenek Kabelac <zkabelac@redhat.com> wrote:
>
> Dne 10. 01. 19 v 1:39 james harvey napsal(a):
> > Q1 - Is it correct that a filesystem's discard code needs to look for
> > an entire block of size discard_granularity to send to the block
> > device (dm/LVM)?  ...
>
> ... Only after 'trimming' whole chunk (on chunk
> boundaries) - you will get zero.  It's worth to note that every thin LV is
> composed from chunks - so to have successful trim - trimming happens only on
> aligned chunks - i.e. chunk_size == 64K and then if you try to trim 64K from
> position 32K - nothing happens....

If chunk_size == 64K, and you try to trim 96K from position 32K, with
bad alignment, would the last 64K get trimmed?

> I hope this makes it clear.
>
> Zdenek

Definitely, thanks!


If an LVM thin volume has a partition within it, which is not aligned
with discard_granularity, and that partition is exposed using kpartx,
I'm pretty sure LVM/dm/kpartx is computing discard_alignment
incorrectly.

It's defined here:
https://www.kernel.org/doc/Documentation/ABI/testing/sysfs-block ---
as: "Devices that support discard functionality may internally
allocate space in units that are bigger than the exported logical
block size. The discard_alignment parameter indicates how many bytes
the beginning of the device is offset from the internal allocation
unit's natural alignment."

I emailed the linux-kernel list, also sending to Martin Petersen,
listed as the contact for the sysfs entry.  See
https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1895560.html
-- He replied, including:

"The common alignment scenario is 3584 on a device with 4K physical
blocks. That's because of the 63-sector legacy FAT partition table
offset. Which essentially means that the first LBA is misaligned and
the first aligned [L]BA is 7."

So, there, I think he's saying given:
* A device of 4K physical blocks
* The first partition being at sector 63 (512 bytes each)

Then discard_alignment should be 63*512 mod 4096, which is 3584.
Meaning, the offset from the beginning of the allocation unit that
holds the beginning of the block device (here, a partition), to the
beginning of the block device.


But, LVM/dm/kpartx seems to be calculating it in reverse, instead
giving the offset from where the block device (partition) starts to
the beginning of the NEXT allocation unit.  Given:
* An LVM thin volume with chunk_size 128MB
* The first partition being at sector 2048 (512 bytes each)

I would expect discard_alignment to be 1MB (2048 sectors * 512
bytes/sector.)  But, LVM/dm/kpartx is giving 127MB (128MB chunk_size -
2048 sectors * 512 bytes/sector.)


I don't know how important this is.  If I understand all of this
correctly, I think it just potentially reduces how many areas are
trimmed.


I ran across this using small values, while figuring out why ntfs-3g
wasn't discarding when on an LVM thin volume.  Putting a partition
within the LVM thin volume is meant to be a stand-in for giving it to
a VM which would have its own partition table.

It appears fdisk typically forces a partition's first sector to be at
a minimum of the chunk_size.  Without looking at the code, I'm
guessing it's using I/O size (optimal.)  But, since I was using really
small values in my test, I think I found that at some point, fdisk
starts allowing the partition's first sector to be much earlier, as in
my scenario it would be starting the partition halfway through the
disk.  Where in the example below it allows a starting sector of 34,
and the user chooses 2048 to at least 1MB align), with a larger
volume, it allows a starting sector of 262144 (=128MB chunk size.)

But, this probably reproduced much more commonly in real applications
by giving the LVM thin volume to a VM, then later using it in the host
through kpartx.  At least in the case of QEMU, within the guest OS,
discard_alignment is 0, even if within the host it has a different
value.  Reported to QEMU here:
https://bugs.launchpad.net/qemu/+bug/1811543 -- So, within the guest,
fdisk is going to immediately allow the first partition to begin at
sector 2048.


How to reproduce this on one system, without VM's involved:

# pvcreate /dev/sdd1
  Physical volume "/dev/sdd1" successfully created.
# pvs | grep sdd1
  /dev/sdd1          lvm2 ---  <100.00g <100.00g
# vgextend lvm /dev/sdd1
  Volume group "lvm" successfully extended
# lvcreate --size 1g --chunksize 128M --zero n --thin lvm/tmpthinpool /dev/sdd1
  Thin pool volume with chunk size 128.00 MiB can address at most
31.62 PiB of data.
  Logical volume "tmpthinpool" created.
# lvcreate --virtualsize 256M --thin lvm/tmpthinpool --name tmp
  Logical volume "tmp" created.
# fdisk /dev/lvm/tmp
...
Command (m for help): g
Created a new GPT disklabel (GUID: 7D31AE50-32AA-BC47-9D7B-CFD6497D520B).

Command (m for help): n
Partition number (1-128, default 1):
First sector (34-524254, default 40): 2048  **** This is what allows
this problem ****
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-524254, default 524254):

Created a new partition 1 of type 'Linux filesystem' and of size 255 MiB.

Command (m for help): p
Disk /dev/lvm/tmp: 256 MiB, 268435456 bytes, 524288 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 262144 bytes / 134217728 bytes

# kpartx -a /dev/lvm/tmp
# dmsetup ls | grep tmp
lvm-tmp (254:13)
lvm-tmp1        (254:14)
lvm-tmpthinpool-tpool   (254:8)
lvm-tmpthinpool_tdata   (254:7)
lvm-tmpthinpool_tmeta   (254:6)
lvm-tmpthinpool (254:9)
$ cat /sys/dev/block/254:13/discard_alignment
0
(All good, on the LV itself)
$ cat /sys/dev/block/254:14/discard_alignment
133169152

That's the value that I think is wrong.  It's reporting the chunk size
- the location of the partition, or 128*1024*1024 - 512 bytes/sector *
2048 sectors.

I think it should be 1048576 (512 bytes/sector * 2048 sectors.)
