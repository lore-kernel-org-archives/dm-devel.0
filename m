From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH][RFC] Emulate BLKRRPART on device-mapper
Date: Wed, 22 Jul 2009 09:06:08 +0200
Message-ID: <4A66BA60.2020500@suse.de>
References: <200907081414.50698.knikanth@suse.de>
	<20090720182324.GD32330@agk-dp.fab.redhat.com>
	<4A65E912.6020706@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4A65E912.6020706@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <mbroz@redhat.com>
Cc: Nikanth Karthikesan <knikanth@suse.de>, device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Jens Axboe <jens.axboe@oracle.com>
List-Id: dm-devel.ids

Milan Broz wrote:
> Alasdair G Kergon wrote:
>> On Wed, Jul 08, 2009 at 02:14:50PM +0530, Nikanth Karthikesan wrote:
>>  =20
>>> From: Hannes Reinecke <hare@suse.de>
>>> Subject: Emulate BLKRRPART on device-mapper
>>>
>>> Partitions on device-mapper devices are managed by kpartx (if at
>>> all). So if we were just to send out a 'change' event if someone
>>> called BLKRRPART on these devices, kpartx will be triggered via udev
>>> and can manage the partitions accordingly.
>>>
>>>    =20
>> Please could I have a 'Tested-by' for this one?
>>  =20
> I am afraid that this patch cannot work, BLRRPART never reach this code=
.
> I tried another idea - or is there better way how to achieve that?
>=20
Hey, that is cool. And what's more, that's exactly what I need for anothe=
r
pet-project of mine, switching off the in-kernel partitioning code altoge=
ther.

But there are some comments, see below.

> Milan
> ---
>=20
> From: Milan Broz <mbroz@redhat.com>
>=20
> Add genhd flag requesting notification of partition changes only.
>=20
> This patch provides notification mechanism which allows handle partitio=
n
> code in userspace.
>=20
> If the BLKRRPART ioctl arrives and GENHD_FL_PARTITION_CHANGE_NOTIFY
> is set, just send uevent and ignore in-kernel partitioning code.
>=20
> This is useful e.g. for device-mapper devices, which can use kpartx
> or similar tool in udev rules.
>=20
> Signed-off-by: Milan Broz <mbroz@redhat.com>
> ---
>  block/ioctl.c         |    3 ++-
>  drivers/md/dm.c       |    1 +
>  fs/partitions/check.c |    6 ++++++
>  include/linux/genhd.h |    8 ++++++++
>  4 files changed, 17 insertions(+), 1 deletions(-)
>=20
> diff --git a/block/ioctl.c b/block/ioctl.c
> index 500e4c7..bce793f 100644
> --- a/block/ioctl.c
> +++ b/block/ioctl.c
> @@ -101,7 +101,8 @@ static int blkdev_reread_part(struct block_device *=
bdev)
>  	struct gendisk *disk =3D bdev->bd_disk;
>  	int res;
> =20
> -	if (!disk_partitionable(disk) || bdev !=3D bdev->bd_contains)
> +	if (!disk_userspace_partitions(disk) &&
> +	    (!disk_partitionable(disk) || bdev !=3D bdev->bd_contains))
>  		return -EINVAL;
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EACCES;
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 9acd54a..1186ce1 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1791,6 +1791,7 @@ static struct mapped_device *alloc_dev(int minor)
>  	md->disk->queue =3D md->queue;
>  	md->disk->private_data =3D md;
>  	sprintf(md->disk->disk_name, "dm-%d", minor);
> +	md->disk->flags |=3D GENHD_FL_PARTITION_CHANGE_NOTIFY;
>  	add_disk(md->disk);
>  	format_dev_t(md->name, MKDEV(_major, minor));
> =20
> diff --git a/fs/partitions/check.c b/fs/partitions/check.c
> index ea4e6cb..bb42c44 100644
> --- a/fs/partitions/check.c
> +++ b/fs/partitions/check.c
> @@ -521,6 +521,12 @@ int rescan_partitions(struct gendisk *disk, struct=
 block_device *bdev)
>  	struct parsed_partitions *state;
>  	int p, highest, res;
> =20
> +	/* partitions handled in userspace, just send change event */
> +	if (disk_userspace_partitions(disk)) {
> +		kobject_uevent(&disk_to_dev(disk)->kobj, KOBJ_CHANGE);
> +		return 0;
> +	}
> +
Wrong. If you do it here, you'll never be able to catch any size changes
of the disk. You'll have to move it to after the 'bdev->bd_invalidated =3D=
 0'
line.

>  	if (bdev->bd_part_count)
>  		return -EBUSY;
>  	res =3D invalidate_partition(disk, 0);
> diff --git a/include/linux/genhd.h b/include/linux/genhd.h
> index 45fc320..a241bd6 100644
> --- a/include/linux/genhd.h
> +++ b/include/linux/genhd.h
> @@ -116,6 +116,9 @@ struct hd_struct {
>  #define GENHD_FL_EXT_DEVT			64 /* allow extended devt */
>  #define GENHD_FL_NATIVE_CAPACITY		128
> =20
> +/* notify udev instead of use in-kernel partitioning */
> +#define GENHD_FL_PARTITION_CHANGE_NOTIFY	256
> +
I would suggest renaming it to GENHD_FL_USERSPACE_PARTITIONS, as this is
more in line with the function of the flag.
Plus I have a patch making use of it :-)

I'll send an adapted patchset.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
