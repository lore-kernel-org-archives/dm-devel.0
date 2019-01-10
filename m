From: james harvey <jamespharvey20@gmail.com>
Subject: dm thin pool discarding
Date: Wed, 9 Jan 2019 19:39:18 -0500
Message-ID: <CA+X5Wn4fqXZa_Ecc75CfmA2LBq7y8qFzzdDcdFugZwaPgq-Aeg@mail.gmail.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

I've been talking with ntfs-3g developers, and they're updating their
discard code to work when an NTFS volume is within an LVM thin volume.

It turns out their code was refusing to discard if discard_granularity
was > the NTFS cluster size.  By default, a LVM thick volume is giving
a discard_granularity of 512 bytes, and the NTFS cluster size is 4096.
By default, a LVM thin volume is giving a discard_granularity of 65536
bytes.

For thin volumes, LVM seems to be returning a discard_granularity
equal to the thin pool's chunksize, which totally makes sense.

Q1 - Is it correct that a filesystem's discard code needs to look for
an entire block of size discard_granularity to send to the block
device (dm/LVM)?  That dm/LVM cannot accept discarding smaller amounts
than this?  (Seems to make sense to me, since otherwise I think the
metadata would need to keep track of smaller chunks than the
chunksize, and it doesn't have the metadata space to do that.)

Q2 - Is it correct that the blocks of size discard_granularity sent to
dm/LVM need to be aligned from the start of the volume, rather than
the start of the partition?  Let's say the thin pool chunk size is set
high, like 128MB.  And, the LVM volume is given to a Virtual Machine
as a raw disk, which creates a partition table within it.  The VM is
going to "properly align" the partitions
Meaning, let's say the chunk size is set high, like 128MB.  And, the
LVM volume is given to a Virtual Machine, which creates a partition
table within it.  Using fdisk 2.33 and gpt, on a thin pool chunk size
of 128MB, it shows sectors of 512 bytes, and puts partition 1 starting
at sector 2048, so at 1MB.  If the filesystem merely considers
alignment from the beginning of where its partition is, that's not
going to line up with alignment of the beginning of the block device,
unless 1MB is a multiple of the thin pool chunk size.

Q3 - Does a LVM thin volume zero out the bytes that are discarded?  At
least for me, queue/discard_zeroes_data is 0.  I see there was
discussion on the list of adding this back in 2012, but I'm not sure
it was ever added for there to be a way to enable it.

Q4 - Are there dragons here?  If I'm right about how Q1&Q2 need to be
handled, if the filesystem incorrectly sends a discard starting at a
location not properly aligned, will LVM/dm reject the request, or will
it still perform an action?  I saw references to block devices
"rounding" discard requests which sounds really scary to me, as if a
filesystem which does this incorrectly could lead to data
corruption/loss.  (I'm not talking about the filesystem going haywire
and discarding areas it should know are in use, but rather
misunderstanding the alignment issues.)
