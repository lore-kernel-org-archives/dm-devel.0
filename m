From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: Adding/removing multi-pathed disk partitions
Date: Wed, 26 Jan 2005 09:52:11 +0100
Message-ID: <20050126085211.GB29023@marowsky-bree.de>
References: <C2EEB4E538D3DC48BF57F391F422779321A708@SRMANNING.eng.emc.com>
	<1106692465.10990.98.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1106692465.10990.98.camel@zezette>
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

On 2005-01-25T23:34:25, christophe varoqui <christophe.varoqui@free.fr> w=
rote:

Yeah, the issue of partitioning device mapper targets has come up here
too. It's definetely an important discussion to have right now.

> May be that's not a problem, as we don't need the kernel partitioning
> code. Though it's not nice to have the kernel not in sync with reality.

This is the first issue: The lower level devices not showing the "right"
partition table when the partition table is changed via the higher level
device (in this case, dm multipath).

I think this probably needs to be solved in-kernel: When DM bd_claim()s
the whole disk (ie, /dev/sda), the kernel should unmap /dev/sda[0-9]+ -
bd_claim() has declared this one owner (the multipath table) to be the
one way of accessing the device, and that's that.

When the multipath table is released, the kernel can rereadpt the device
and the partition table entries would reappear.

(One issue: If any partition on the device was already bd_claim()ed at
the time where multipath tried to bd_claim the whole disk, the full disk
claim should error out.)

> If kpartx reads the partition table directly from disk, ie bypassing th=
e
> cache, the correct layout will be mapped. Note it recquires a manual
> execution, as no hotplug event is generated upon fdisk's sync. This als=
o
> applies to "blockdev --rereadpt" anyway.

Now, second issue: Having the kpartx generated mappings be updated when
someone uses the fdisk/sfdisk etc tools. This one is reasonably simple:
Generate a hotplug event for the rereadpt ioctl() and map it to kpartx
rescanning the table. Et voila.

There's a third issue, namely being able to figure out from user-space
that a /dev/498984348484304p1 is actually a partition of the ...304
device. (This might be needed for grouping the partition entries
correctly in various admin tools.) But, short of storing a list of
"parent" dev entries in sysfs, I think this would need to be solved by
them parsing the DM table if they really cared...

> 2) flames to me for suggesting we could get away altogether with the
> kernel partitioning code ?

This one has been suggested a number of times to me. ie, use the
in-kernel partition code to partition the DM (multipath) device, much
like the md entries can be partitioned.

For a while, I actually thought this was a good idea ;-) But then I've
had to reconsider. It's much more powerful to have the partitions be
feature-complete DMs, because then they can be remapped, snapshotted and
so on; so eventually one of the volume managers would want to implement
them this way, and then all the issues would pop up again. I'd rather
solve them like this right now.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
