From: "goggin, edward" <egoggin@emc.com>
Subject: RE: dm-devel Digest, Vol 11, Issue 17
Date: Mon, 31 Jan 2005 10:47:27 -0500
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321A737@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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
To: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
List-Id: dm-devel.ids

> on Wed, 26 Jan 2005 09:52:11 +0100, Lars Marowsky-Bree wrote:
> 
> This is the first issue: The lower level devices not showing 
> the "right"
> partition table when the partition table is changed via the 
> higher level
> device (in this case, dm multipath).
> 
> I think this probably needs to be solved in-kernel: When DM 
> bd_claim()s
> the whole disk (ie, /dev/sda), the kernel should unmap 
> /dev/sda[0-9]+ -
> bd_claim() has declared this one owner (the multipath table) to be the
> one way of accessing the device, and that's that.
> 
> When the multipath table is released, the kernel can rereadpt 
> the device
> and the partition table entries would reappear.
> 

Does the "unmap" reference above refer to what is done by
invalidate_bdev()?

I realize that data consistency across the multipath mapped device
and all of its target devices is not a goal, but what about achieving
meta-data consistency across this set of devices (1) at all times and
(2) for all "block device relative" metadata, and not just the
partition table contents at the time the target devices are opened?
This metadata could include the device's partition table, its
physical capacity, its logical block size, its read-only state,
and its read-ahead sector count.  Of course, path specific metadata,
(e.g., bus/target/lun address), should not be made consistent across
the members of this set. 

Invalidating all cached pages (including the partition table page)
for the target devices at the time these devices are opened may
not be sufficient in cases where revalidate_disk() is called
on the target device.  A call to revalidate_disk() will repopulate
the page cache with a cached copy of the partition table for one
of the target devices.  Although this seems to happen mostly due
to manual invocation of some partition management tool, (i.e.,
servicing a partition management RRPART ioctl), revalidate_disk()
could be invoked on SCSI media without manual by check_media_change()
if the SAN storage systems units are to be treated as removal media.

While we are discussing this general topic, anyone know how a
change to the capacity of a SCSI logical unit "automatically"
makes its way into the gendisk structure for both the multipath
mapped device and all of its target devices?  A call to
revalidate_disk() will do the trick, but I'm thinking that
there is currently no mechanism in place to automate this
procedure (I don't think a UNIT_ATTENTION check condition is
generated when the logical unit's capacity is changed), and
that there should be one.

Also, if the new capacity is smaller than before, this smaller
capacity could affect the validity of any number of the sector
offset and length fields of the device mapper multipath maps.
Any automated procedure would need to take this into account.

> Now, second issue: Having the kpartx generated mappings be 
> updated when
> someone uses the fdisk/sfdisk etc tools. This one is 
> reasonably simple:
> Generate a hotplug event for the rereadpt ioctl() and map it to kpartx
> rescanning the table. Et voila.
>

Jjjjj

> > 2) flames to me for suggesting we could get away altogether with the
> > kernel partitioning code ?
> 
> This one has been suggested a number of times to me. ie, use the
> in-kernel partition code to partition the DM (multipath) device, much
> like the md entries can be partitioned.
> 
> For a while, I actually thought this was a good idea ;-) But then I've
> had to reconsider. It's much more powerful to have the partitions be
> feature-complete DMs, because then they can be remapped, 
> snapshotted and
> so on; so eventually one of the volume managers would want to 
> implement
> them this way, and then all the issues would pop up again. I'd rather
> solve them like this right now.
> 

jjjjj

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
