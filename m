From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH v3] dm ebs: new block size emulating target
Date: Mon, 24 Feb 2020 10:20:35 +0000
Message-ID: <BYAPR04MB58161415900003B80E88636CE7EC0@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <9cbb6827dbf3ff7cfdfbd0238c164cf5ee6d63e8.1582149828.git.heinzm@redhat.com>
	<BYAPR04MB5816D3DC50B6ACAC8E8DEA86E7120@BYAPR04MB5816.namprd04.prod.outlook.com>
	<3f80cf45-cdf3-3973-2001-a2562df32761@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Heinz Mauelshagen <heinzm@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
Cc: "awalsh@redhat.com" <awalsh@redhat.com>, "mpatocka@redhat.com" <mpatocka@redhat.com>, "msnitzer@redhat.com" <msnitzer@redhat.com>, "jdorminy@redhat.com" <jdorminy@redhat.com>, "corwin@redhat.com" <corwin@redhat.com>
List-Id: dm-devel.ids

Heinz,

On 2020/02/21 23:25, Heinz Mauelshagen wrote:
> Hi Damien,
>=20
> thanks for your review, much appreciated.
>=20
> Please find my statements inline with yours below, working in=20
> uncontroversial ones now...
>=20
> Heinz
>=20
>=20
> On 2/21/20 10:44 AM, Damien Le Moal wrote:
>> On 2020/02/20 7:12, heinzm@redhat.com wrote:
>>> From: Heinz Mauelshagen <heinzm@redhat.com>
>>>
>>> This new target is similar to the linear target except that it emulates
>>> a smaller logical block size on devices with larger ones.  It's main
>>> purpose is to emulate 512 byte sectors on 4K native disks (i.e. 512e).
>> 512e drives have a 512B LBA, so no emulation is needed (the drive does t=
hat
>> itself). Did you mean to say 4Kn here ? Or is the intent to bypass the
>> drive level 512B emulation and do all 4K aligned read-modify-write acces=
ses
>> on the host ?
>=20
> dm-ebs is mainly providing software 512e, that's what the sentence
> "It's main purpose is to emulate 512 byte sectors on 4K native disks=20
> (i.e. 512e)
> aimed to state.
>=20
> Would changing to '(i.e. software 512e)' help understanding?
>=20
>=20
>>
>>> See Documentation/admin-guide/device-mapper/dm-ebs.rst for details.
>>>
>>> Changes versus version 2 sent on 2/13/2020:
>>> - fix __nr_blocks() to return the correct number of blocks
>>> - fix __ebs_forget_bio() to process the last block of a bio
>>> - fix __ebs_process_bios() to avoid prefetching the same block twice
>>> - use op_is_flush() in the map function
>>> - comments
>>>
>>> Reviewed-by: John Dorminy <jdorminy@redhat.com>
>>> Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
>>> ---
>>>   .../admin-guide/device-mapper/dm-ebs.rst      |  49 ++
>>>   drivers/md/Kconfig                            |   8 +
>>>   drivers/md/Makefile                           |   2 +
>>>   drivers/md/dm-ebs-target.c                    | 429 +++++++++++++++++=
+
>>>   4 files changed, 488 insertions(+)
>>>   create mode 100644 Documentation/admin-guide/device-mapper/dm-ebs.rst
>>>   create mode 100644 drivers/md/dm-ebs-target.c
>>>
>>> diff --git a/Documentation/admin-guide/device-mapper/dm-ebs.rst b/Docum=
entation/admin-guide/device-mapper/dm-ebs.rst
>>> new file mode 100644
>>> index 000000000000..530771dbb352
>>> --- /dev/null
>>> +++ b/Documentation/admin-guide/device-mapper/dm-ebs.rst
>>> @@ -0,0 +1,49 @@
>>> +=3D=3D=3D=3D=3D=3D
>>> +dm-ebs
>>> +=3D=3D=3D=3D=3D=3D
>>> +
>>> +This target is similar to the linear target except that it emulates
>>> +smaller logical block size on devices with larger ones.   It's main
>>> +purpose is to emulate 512 byte sectors on 4K native disks (i.e 512e).
>> Same comment as above. Clarifying this would help users.
>=20
> See above...
>=20
>>
>>> +
>>> +Supported emulated logical block sizes 512, 1024, 2048 and 4096.
>>> +
>>> +Underlying block size can be set to > 4K to test buffering larger unit=
s.
>> If I understand this correctly, your target can also emulate physical
>> sector sizes larger than 4K ? Is this correct ?
>=20
>=20
> This is flexibly offering dm-bufio features.=A0 dm-ebs can be configured =
to
> use larger dm-bufio buffer sizes if that's requested for e.g. testing,=20
> though its
> main use case is software 512e on 4K native disks.

OK. Uderstood.

>=20
>=20
>>
>> All this description should I think clarify the combinations of
>> logical/physical sector size that the target can take and change into so=
me
>> other combination.
>=20
>=20
> You think Documentation/admin-guide/device-mapper/dm-ebs.rst,
> lines 9+11 don't provide enough information in this regard?
>=20
> Maybe the change to '(i.e. software 512e)' as mentioned above
> in combination with that documentation addresses your point?
>=20
>>
>>> +
>>> +
>>> +Table parameters
>>> +----------------
>>> +  <dev path> <offset> <emulated sectors> [<underlying sectors>]
>>> +
>>> +Mandatory parameters:
>>> +
>>> +    <dev path>:
>>> +        Full pathname to the underlying block-device,
>>> +        or a "major:minor" device-number.
>>> +    <offset>:
>>> +        Starting sector within the device;
>>> +        has to be a multiple of <emulated sectors>.
>>> +    <emulated sectors>:
>>> +        Number of sectors defining the logical block size to be emulat=
ed;
>>> +        1, 2, 4, 8 sectors of 512 bytes supported.
>>> +
>>> +Optional parameter:
>>> +
>>> +    <underyling sectors>:
>>> +        Number of sectors defining the logical block size of <dev path=
>.
>>> +        2^N supported, e.g. 8 =3D emulate 8 sectors of 512 bytes =3D 4=
KiB.
>>> +        If not provided, the logical block size of <dev path> will be =
used.
>>> +
>>> +
>>> +Examples:
>>> +
>>> +Emulate 1 sector =3D 512 bytes logical block size on /dev/sda starting=
 at
>>> +offset 1024 sectors with underlying devices block size automatically s=
et:
>>> +
>>> +ebs /dev/sda 1024 1
>>> +
>>> +Emulate 2 sector =3D 1KiB logical block size on /dev/sda starting at
>>> +offset 128 sectors, enforce 2KiB underlying device block size.
>>> +This presumes 2KiB logical blocksize on /dev/sda or less to work:
>>> +
>>> +ebs /dev/sda 128 2 4
>>> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
>>> index d6d5ab23c088..392974a2999d 100644
>>> --- a/drivers/md/Kconfig
>>> +++ b/drivers/md/Kconfig
>>> @@ -336,6 +336,14 @@ config DM_WRITECACHE
>>>   =09   The writecache target doesn't cache reads because reads are sup=
posed
>>>   =09   to be cached in standard RAM.
>>>  =20
>>> +config DM_EBS
>>> +       tristate "Emulated block size target (EXPERIMENTAL)"
>>> +       depends on BLK_DEV_DM
>>> +       default n
>>> +       ---help---
>>> +=09 dm-ebs emulates smaller logical block size on backing devices
>>> +=09 with larger ones (e.g. 512 byte sectors on 4K native disks).
>>> +
>>>   config DM_ERA
>>>          tristate "Era target (EXPERIMENTAL)"
>>>          depends on BLK_DEV_DM
>>> diff --git a/drivers/md/Makefile b/drivers/md/Makefile
>>> index d91a7edcd2ab..9a2d673f94bc 100644
>>> --- a/drivers/md/Makefile
>>> +++ b/drivers/md/Makefile
>>> @@ -17,6 +17,7 @@ dm-thin-pool-y=09+=3D dm-thin.o dm-thin-metadata.o
>>>   dm-cache-y=09+=3D dm-cache-target.o dm-cache-metadata.o dm-cache-poli=
cy.o \
>>>   =09=09    dm-cache-background-tracker.o
>>>   dm-cache-smq-y   +=3D dm-cache-policy-smq.o
>>> +dm-ebs-y=09+=3D dm-ebs-target.o
>>>   dm-era-y=09+=3D dm-era-target.o
>>>   dm-clone-y=09+=3D dm-clone-target.o dm-clone-metadata.o
>>>   dm-verity-y=09+=3D dm-verity-target.o
>>> @@ -65,6 +66,7 @@ obj-$(CONFIG_DM_THIN_PROVISIONING)=09+=3D dm-thin-poo=
l.o
>>>   obj-$(CONFIG_DM_VERITY)=09=09+=3D dm-verity.o
>>>   obj-$(CONFIG_DM_CACHE)=09=09+=3D dm-cache.o
>>>   obj-$(CONFIG_DM_CACHE_SMQ)=09+=3D dm-cache-smq.o
>>> +obj-$(CONFIG_DM_EBS)=09=09+=3D dm-ebs.o
>>>   obj-$(CONFIG_DM_ERA)=09=09+=3D dm-era.o
>>>   obj-$(CONFIG_DM_CLONE)=09=09+=3D dm-clone.o
>>>   obj-$(CONFIG_DM_LOG_WRITES)=09+=3D dm-log-writes.o
>>> diff --git a/drivers/md/dm-ebs-target.c b/drivers/md/dm-ebs-target.c
>>> new file mode 100644
>>> index 000000000000..a241af82543a
>>> --- /dev/null
>>> +++ b/drivers/md/dm-ebs-target.c
>>> @@ -0,0 +1,429 @@
>>> +/*
>>> + * Copyright (C) 2020 Red Hat GmbH
>>> + *
>>> + * This file is released under the GPL.
>>> + *
>>> + * Device-mapper target to emulate smaller logical block
>>> + * size on backing devices exposing (natively) larger ones.
>>> + *
>>> + * E.g. 512 byte sector emulation on 4K native disks.
>>> + */
>>> +
>>> +#include "dm.h"
>>> +#include <linux/module.h>
>>> +#include <linux/workqueue.h>
>>> +#include <linux/dm-bufio.h>
>>> +
>>> +#define DM_MSG_PREFIX "ebs"
>>> +
>>> +static void ebs_dtr(struct dm_target *ti);
>>> +
>>> +/* Emulated block size context. */
>>> +struct ebs_c {
>>> +=09struct dm_dev *dev;
>>> +=09struct dm_bufio_client *bufio;
>>> +=09struct work_struct ws;
>>> +=09struct workqueue_struct *wq;
>>> +=09struct bio_list bios_in;
>>> +=09spinlock_t lock; /* Guard bios_in list above */
>>> +=09sector_t start;
>>> +=09unsigned int ebs;
>>> +=09unsigned int ubs;
>> These two should have better name to help clarifying the code.
>> May be:
>> ebs -> elblocksz
>> ubs -> epblocksz
>=20
>=20
> I'd prefer ebs and ubs vs. those. What about e_bs and u_bs?

I am fine with the "bs" part. The "e" and "u" are a little more confusing
since these are not the regular terms used in the block layer, nor on
storage device specs. logical/physical block size is well understood by
everybody. If you say "ebs", we surely understand that it is an emulated
block size, but which one ? Logical or physical ? Same for "u". It is not
super clear and a beginner with the code will need digging though their use
to understand what they are.

Reusing already well understood terms will help with code readability. So
something like "elbs" aand "epbs" with a description of the meaning as
comments in the structure would make everything easier I think.

But this is just my opinion. Not a show stopper I think. Feel free to ignor=
e :)

>=20
> Besides, we don't use '*blocksz' in dm and rarely the long 'blocksize'=20
> var name.
>=20
>=20
>>
>> And add comments to describe the struct fields.
>=20
> Ok.
>=20
>>
>>> +=09unsigned char shift;
>>> +=09unsigned short ubs_set:1;
>>> +};
>>> +
>>> +static sector_t __sector_to_block(struct ebs_c *ec, sector_t sector)
>>> +{
>>> +=09return sector >> ec->shift;
>>> +}
>> static inline sector_t ?
> Does it make sense vs. relying on compiler optimizations.

Yes, with regular -02 compilation, that most likely endup inline anyway.
But since this is a one-liner, you may as well tell the compiler that you
want this inline and -Os or other less aggressive optimization options will
not uselessly use a call (I do not think they do for that kind of small
funtion, but I have not checked).

>>
>>> +
>>> +static sector_t __block_mod(sector_t sector, unsigned int bs)
>>> +{
>>> +=09return sector & (bs - 1);
>>> +}
>> inline for this one too ?
> See above question.
>>
>>> +
>>> +/* Return number of blocks for a bio accounting for misalignement of s=
tart and end sectors. */
>>> +static unsigned int __nr_blocks(struct ebs_c *ec, struct bio *bio)
>>> +{
>>> +=09sector_t end_sector =3D __block_mod(bio->bi_iter.bi_sector, ec->ubs=
) + bio_sectors(bio);
>>> +
>>> +=09return __sector_to_block(ec, end_sector) + (__block_mod(end_sector,=
 ec->ubs) ? 1 : 0);
>>> +}
>>> +
>>> +static bool __ebs_check_bs(unsigned int bs)
>>> +{
>>> +=09return bs && is_power_of_2(bs);
>>> +}
>>> +
>>> +/* READ/WRITE bio vector: copy blocks between bufio blocks and bio vec=
tor's (partial/overlapping) pages. */
>> May be use the regular comment block for functions here:
>>
>> /*
>>   * READ/WRITE...
>>   */
>>
>> Same for other functions below.
> Ok.
>>
>>> +static int __ebs_rw_bvec(struct ebs_c *ec, int rw, struct bio_vec *bv,=
 struct bvec_iter *iter)
>>> +{
>>> +=09int r =3D 0;
>>> +=09unsigned char *ba, *pa =3D page_address(bv->bv_page) + bv->bv_offse=
t;
>>> +=09unsigned int cur_len;
>>> +=09unsigned int bv_len =3D bv->bv_len;
>>> +=09unsigned int buf_off =3D to_bytes(__block_mod(iter->bi_sector, ec->=
ubs));
>>> +=09sector_t block =3D __sector_to_block(ec, iter->bi_sector);
>>> +=09struct dm_buffer *b;
>>> +
>>> +=09if (!bv->bv_page || !bv_len)
>>> +=09=09return -EIO;
>>> +
>>> +=09/* Handle overlapping page <-> blocks */
>>> +=09while (bv_len) {
>>> +=09=09cur_len =3D min(dm_bufio_get_block_size(ec->bufio) - buf_off, bv=
_len);
>>> +
>>> +=09=09/* Avoid reading for writes in case bio vector's page overwrites=
 block completely. */
>>> +=09=09if (rw =3D=3D READ || buf_off || bv_len < dm_bufio_get_block_siz=
e(ec->bufio))
>>> +=09=09=09ba =3D dm_bufio_read(ec->bufio, block, &b);
>>> +=09=09else
>>> +=09=09=09ba =3D dm_bufio_new(ec->bufio, block, &b);
>>> +
>>> +=09=09if (unlikely(IS_ERR(ba)))
>>> +=09=09=09r =3D PTR_ERR(ba); /* Carry on with next buffer if any to I/O=
 all possible data but return error. */
>>> +=09=09else {
>>> +=09=09=09/* Copy data to/from bio to buffer if read/new was successful=
 above. */
>>> +=09=09=09ba +=3D buf_off;
>>> +=09=09=09if (rw =3D=3D READ)
>>> +=09=09=09=09memcpy(pa, ba, cur_len);
>>> +=09=09=09else {
>>> +=09=09=09=09memcpy(ba, pa, cur_len);
>>> +=09=09=09=09dm_bufio_mark_partial_buffer_dirty(b, buf_off, buf_off + c=
ur_len);
>>> +=09=09=09}
>>> +
>>> +=09=09=09dm_bufio_release(b);
>>> +=09=09}
>>> +
>>> +=09=09pa +=3D cur_len;
>>> +=09=09bv_len -=3D cur_len;
>>> +=09=09buf_off =3D 0;
>>> +=09=09block++;
>>> +=09}
>>> +
>>> +=09return r;
>>> +}
>>> +
>>> +/* READ/WRITE: iterate bio vector's copying between (partial) pages an=
d bufio blocks. */
>>> +static int __ebs_rw_bio(struct ebs_c *ec, int rw, struct bio *bio)
>>> +{
>>> +=09int r =3D 0, rr;
>>> +=09struct bio_vec bv;
>>> +=09struct bvec_iter iter;
>>> +
>>> +=09bio_for_each_bvec(bv, bio, iter) {
>>> +=09=09rr =3D __ebs_rw_bvec(ec, rw, &bv, &iter);
>>> +=09=09if (rr)
>>> +=09=09=09r =3D rr;
>>> +=09}
>>> +
>>> +=09return r;
>>> +}
>>> +
>>> +/* 'Discard' blocks, i.e. release them from the bufio cache. */
>>> +static int __ebs_forget_bio(struct ebs_c *ec, struct bio *bio)
>>> +{
>>> +=09sector_t blocks, sector =3D bio->bi_iter.bi_sector;;
>>> +
>>> +=09blocks =3D __nr_blocks(ec, bio);
>>> +=09for (; blocks--; sector +=3D ec->ubs)
>>> +=09=09dm_bufio_forget(ec->bufio, __sector_to_block(ec, sector));
>>> +
>>> +=09return 0;
>>> +}
>>> +
>>> +/* Worker funtion to process incoming bios. */
>>> +static void __ebs_process_bios(struct work_struct *ws)
>>> +{
>>> +=09int r;
>>> +=09bool write =3D false;
>>> +=09sector_t block1, block2;
>>> +=09struct ebs_c *ec =3D container_of(ws, struct ebs_c, ws);
>>> +=09struct bio *bio;
>>> +=09struct bio_list bios;
>>> +
>>> +=09bio_list_init(&bios);
>>> +
>>> +=09spin_lock_irq(&ec->lock);
>>> +=09bios =3D ec->bios_in;
>>> +=09bio_list_init(&ec->bios_in);
>>> +=09spin_unlock_irq(&ec->lock);
>>> +
>>> +=09/* Prefetch all read and any mis-aligned write buffers */
>>> +=09bio_list_for_each(bio, &bios) {
>>> +=09=09block1 =3D __sector_to_block(ec, bio->bi_iter.bi_sector);
>>> +=09=09if (bio_op(bio) =3D=3D REQ_OP_READ)
>>> +=09=09=09dm_bufio_prefetch(ec->bufio, block1, __nr_blocks(ec, bio));
>>> +=09=09else if (bio_op(bio) =3D=3D REQ_OP_WRITE && !(bio->bi_opf & REQ_=
PREFLUSH)) {
>>> +=09=09=09block2 =3D __sector_to_block(ec, bio_end_sector(bio));
>>> +=09=09=09if (__block_mod(bio->bi_iter.bi_sector, ec->ubs))
>>> +=09=09=09=09dm_bufio_prefetch(ec->bufio, block1, 1);
>>> +=09=09=09if (__block_mod(bio_end_sector(bio), ec->ubs) && block2 !=3D =
block1)
>>> +=09=09=09=09dm_bufio_prefetch(ec->bufio, block2, 1);
>>> +=09=09}
>>> +=09}
>>> +
>>> +=09bio_list_for_each(bio, &bios) {
>>> +=09=09r =3D -EIO;
>>> +
>>> +=09=09if (bio_op(bio) =3D=3D REQ_OP_READ)
>>> +=09=09=09r =3D __ebs_rw_bio(ec, READ, bio);
>>> +=09=09else if (bio_op(bio) =3D=3D REQ_OP_WRITE) {
>>> +=09=09=09write =3D true;
>>> +=09=09=09r =3D __ebs_rw_bio(ec, WRITE, bio);
>>> +=09=09} else if (bio_op(bio) =3D=3D REQ_OP_DISCARD)
>>> +=09=09=09/* FIXME: (optionally) call dm_bufio_discard_buffers() once u=
pstream. */
>>> +=09=09=09r =3D __ebs_forget_bio(ec, bio);
>>> +
>>> +=09=09if (r)
>>> +=09=09=09bio->bi_status =3D BLK_STS_IOERR;
>>> +=09}
>>> +
>>> +=09r =3D write ? dm_bufio_write_dirty_buffers(ec->bufio) : 0;
>>> +
>>> +=09while ((bio =3D bio_list_pop(&bios))) {
>>> +=09=09/* FIXME: any other request is just endioed for now. */
>> Then please fix it...
> Yep.
>>
>>> +=09=09if (unlikely(r && bio_op(bio) =3D=3D REQ_OP_WRITE))
>>> +=09=09=09bio_io_error(bio);
>>> +=09=09else
>>> +=09=09=09bio_endio(bio);
>>> +=09}
>>> +}
>>> +
>>> +/*
>>> + * Construct an emulated block size mapping: <dev_path> <offset> <ebs>=
 [<ubs>]
>>> + *
>>> + * <dev_path>: path of the underlying device
>>> + * <offset>: offset in 512 bytes sectors into <dev_path>
>>> + * <ebs>: emulated block size in units of 512 bytes exposed to the upp=
er layer
>>> + * [<ubs>]: underlying block size in units of 512 bytes imposed on the=
 lower layer;
>>> + * =09     optional, if not supplied, retrieve logical block size from=
 underlying device
>>> + */
>>> +static int ebs_ctr(struct dm_target *ti, unsigned int argc, char **arg=
v)
>>> +{
>>> +=09int r;
>>> +=09unsigned short tmp1;
>>> +=09unsigned long long tmp;
>>> +=09char dummy;
>>> +=09struct ebs_c *ec;
>>> +
>>> +=09if (argc < 3 || argc > 4) {
>>> +=09=09ti->error =3D "Invalid argument count";
>>> +=09=09return -EINVAL;
>>> +=09}
>>> +
>>> +=09ec =3D ti->private =3D kzalloc(sizeof(*ec), GFP_KERNEL);
>>> +=09if (!ec) {
>>> +=09=09ti->error =3D "Cannot allocate ebs context";
>>> +=09=09return -ENOMEM;
>>> +=09}
>>> +
>>> +=09r =3D -EINVAL;
>>> +=09if (sscanf(argv[1], "%llu%c", &tmp, &dummy) !=3D 1 ||
>>> +=09=09   tmp !=3D (sector_t)tmp ||
>>> +=09=09   (sector_t)tmp >=3D ti->len) {
>> please indent to the "if (", not "sscanf("
>=20
> Ok.
>=20
>>
>>> +=09=09ti->error =3D "Invalid device offset sector";
>>> +=09=09goto bad;
>>> +=09}
>>> +=09ec->start =3D tmp;
>>> +
>>> +=09if (sscanf(argv[2], "%hu%c", &tmp1, &dummy) !=3D 1 ||
>>> +=09    !__ebs_check_bs(tmp1) ||
>>> +=09    to_bytes(tmp1) > PAGE_SIZE) {
>>> +=09=09ti->error =3D "Invalid emulated block size";
>>> +=09=09goto bad;
>>> +=09}
>>> +=09ec->ebs =3D tmp1;
>>> +
>>> +=09if (argc > 3) {
>>> +=09=09if (sscanf(argv[3], "%hu%c", &tmp1, &dummy) !=3D 1 || !__ebs_che=
ck_bs(tmp1)) {
>>> +=09=09=09ti->error =3D "Invalid underlying block size";
>>> +=09=09=09goto bad;
>>> +=09=09}
>>> +=09=09ec->ubs =3D tmp1;
>>> +=09=09ec->ubs_set =3D true;
>>> +=09} else
>>> +=09=09ec->ubs_set =3D false;
>>> +
>>> +=09r =3D dm_get_device(ti, argv[0], dm_table_get_mode(ti->table), &ec-=
>dev);
>>> +=09if (r) {
>>> +=09=09ti->error =3D "Device lookup failed";
>>> +=09=09ec->dev =3D NULL;
>>> +=09=09goto bad;
>>> +=09}
>>> +
>>> +=09r =3D -EINVAL;
>>> +=09if (!ec->ubs_set) {
>>> +=09=09ec->ubs =3D to_sector(bdev_logical_block_size(ec->dev->bdev));
>>> +=09=09if (!__ebs_check_bs(ec->ubs)) {
>>> +=09=09=09ti->error =3D "Invalid retrieved underlying block size";
>> The message is confusing here. The device LBA size is certainly fine, bu=
t
>> the parameters passed cannot accomodate it right ? So stricktly speaking=
,
>> it is not the backend device LBA size that is invalid. No ?
>=20
> The check's just about being cautious here.

Yes, I understood. I was refering to the fact that the message is not
really super clear about what exactly is invalid. It is very unlikely that
bdev_logical_block_size() give you a bad value. The check here is about
"are the emulation parameters given compatible with the underlying block
device LBA size ?", isn't it ? To me "Invalid retrieved underlying block
size" means that the device is bad. I would rather phrase this something
like: "Emulation parameter not compatible with underlying block size".
This is almost shedding bikes here :) But this points out that the user is
trying a setup that cannot work rather than using a bad underlying
device... Or I am completely missing the point with __ebs_check_bs() ?

>=20
>>
>>> +=09=09=09goto bad;
>>> +=09=09}
>>> +=09}
>>> +
>>> +=09if (!ec->ubs_set && ec->ebs =3D=3D ec->ubs)
>>> +=09=09DMERR("Emulation superfluous: emulated equal to underlying block=
 size");
>> This is an error message but you do nothing about it. May be change this
>> into a info level output since that is not a real problem.
>=20
> That's along a change point I forget because I allow this for flexibility
> Using DMINFO now...
>=20
>>
>>> +
>>> +=09if (__block_mod(ec->start, ec->ubs)) {
>>> +=09=09ti->error =3D "Device offset must be multiple of underlying bloc=
k size";
>>> +=09=09goto bad;
>>> +=09}
>>> +
>>> +=09ec->bufio =3D dm_bufio_client_create(ec->dev->bdev, to_bytes(ec->ub=
s), 1, 0, NULL, NULL);
>>> +=09if (IS_ERR(ec->bufio)) {
>>> +=09=09ti->error =3D "Cannot create dm bufio client";
>>> +=09=09r =3D PTR_ERR(ec->bufio);
>>> +=09=09ec->bufio =3D NULL;
>>> +=09=09goto bad;
>>> +=09}
>>> +
>>> +=09ec->wq =3D alloc_ordered_workqueue("dm-" DM_MSG_PREFIX, WQ_MEM_RECL=
AIM);
>>> +=09if (!ec->wq) {
>>> +=09=09ti->error =3D "Cannot create dm-" DM_MSG_PREFIX " workqueue";
>>> +=09=09r =3D -ENOMEM;
>>> +=09=09goto bad;
>>> +=09}
>>> +
>>> +=09ec->shift =3D __ffs(ec->ubs);
>>> +=09INIT_WORK(&ec->ws, &__ebs_process_bios);
>>> +=09bio_list_init(&ec->bios_in);
>>> +=09spin_lock_init(&ec->lock);
>>> +
>>> +=09ti->num_flush_bios =3D 1;
>>> +=09ti->num_discard_bios =3D 1;
>>> +=09ti->num_secure_erase_bios =3D 0;
>>> +=09ti->num_write_same_bios =3D 0;
>>> +=09ti->num_write_zeroes_bios =3D 0;
>>> +=09return 0;
>>> +bad:
>>> +=09ebs_dtr(ti);
>>> +=09return r;
>>> +}
>>> +
>>> +static void ebs_dtr(struct dm_target *ti)
>>> +{
>>> +=09struct ebs_c *ec =3D ti->private;
>>> +
>>> +=09if (ec->wq)
>>> +=09=09destroy_workqueue(ec->wq);
>>> +=09if (ec->bufio)
>>> +=09=09dm_bufio_client_destroy(ec->bufio);
>>> +=09if (ec->dev)
>>> +=09=09dm_put_device(ti, ec->dev);
>>> +=09kfree(ec);
>>> +}
>>> +
>>> +static int ebs_map(struct dm_target *ti, struct bio *bio)
>>> +{
>>> +=09struct ebs_c *ec =3D ti->private;
>>> +
>>> +=09bio_set_dev(bio, ec->dev->bdev);
>>> +=09bio->bi_iter.bi_sector =3D ec->start + dm_target_offset(ti, bio->bi=
_iter.bi_sector);
>>> +
>>> +=09if (unlikely(op_is_flush(bio->bi_opf)))
>>> +=09=09return DM_MAPIO_REMAPPED;
>>> +
>>> +=09/*
>>> +=09 * Only queue for bufio processing in case of partial or overlappin=
g buffers
>>> +=09 * -or-
>>> +=09 * emulation with ebs =3D=3D ubs aiming for tests of dm-bufio overh=
ead.
>>> +=09 */
>>> +=09if (likely(__block_mod(bio->bi_iter.bi_sector, ec->ubs) ||
>>> +=09=09   __block_mod(bio_end_sector(bio), ec->ubs) ||
>>> +=09=09   ec->ebs =3D=3D ec->ubs)) {
>>> +=09=09spin_lock_irq(&ec->lock);
>>> +=09=09bio_list_add(&ec->bios_in, bio);
>>> +=09=09spin_unlock_irq(&ec->lock);
>>> +
>>> +=09=09queue_work(ec->wq, &ec->ws);
>>> +
>>> +=09=09return DM_MAPIO_SUBMITTED;
>>> +=09}
>>> +
>>> +=09/* Forget any buffer content relative to this direct backing device=
 I/O. */
>>> +=09__ebs_forget_bio(ec, bio);
>>> +
>>> +=09return DM_MAPIO_REMAPPED;
>>> +}
>>> +
>>> +static void ebs_status(struct dm_target *ti, status_type_t type,
>>> +=09=09       unsigned status_flags, char *result, unsigned maxlen)
>>> +{
>>> +=09struct ebs_c *ec =3D ti->private;
>>> +
>>> +=09switch (type) {
>>> +=09case STATUSTYPE_INFO:
>>> +=09=09*result =3D '\0';
>>> +=09=09break;
>>> +=09case STATUSTYPE_TABLE:
>>> +=09=09snprintf(result, maxlen, ec->ubs_set ? "%s %llu %u %u" : "%s %ll=
u %u",
>>> +=09=09=09 ec->dev->name, (unsigned long long) ec->start, ec->ebs, ec->=
ubs);
>>> +=09=09break;
>>> +=09}
>>> +}
>>> +
>>> +static int ebs_prepare_ioctl(struct dm_target *ti, struct block_device=
 **bdev)
>>> +{
>>> +=09struct ebs_c *ec =3D ti->private;
>>> +=09struct dm_dev *dev =3D ec->dev;
>>> +
>>> +=09/*
>>> +=09 * Only pass ioctls through if the device sizes match exactly.
>>> +=09 */
>>> +=09*bdev =3D dev->bdev;
>>> +=09return !!(ec->start || ti->len !=3D i_size_read(dev->bdev->bd_inode=
) >> SECTOR_SHIFT);
>>> +}
>>> +
>>> +static void ebs_io_hints(struct dm_target *ti, struct queue_limits *li=
mits)
>>> +{
>>> +=09struct ebs_c *ec =3D ti->private;
>>> +
>>> +=09limits->logical_block_size =3D to_bytes(ec->ebs);
>>> +=09limits->physical_block_size =3D to_bytes(ec->ubs);
>>> +=09limits->alignment_offset =3D limits->physical_block_size;
>>> +=09blk_limits_io_min(limits, limits->logical_block_size);
>>> +}
>>> +
>>> +static int ebs_iterate_devices(struct dm_target *ti,
>>> +=09=09=09=09  iterate_devices_callout_fn fn, void *data)
>>> +{
>>> +=09struct ebs_c *ec =3D ti->private;
>>> +
>>> +=09return fn(ti, ec->dev, ec->start, ti->len, data);
>>> +}
>>> +
>>> +static struct target_type ebs_target =3D {
>>> +=09.name=09=09 =3D "ebs",
>>> +=09.version=09 =3D {1, 0, 0},
>>> +=09.features=09 =3D DM_TARGET_PASSES_INTEGRITY,
>>> +=09.module=09=09 =3D THIS_MODULE,
>>> +=09.ctr=09=09 =3D ebs_ctr,
>>> +=09.dtr=09=09 =3D ebs_dtr,
>>> +=09.map=09=09 =3D ebs_map,
>>> +=09.status=09=09 =3D ebs_status,
>>> +=09.io_hints=09 =3D ebs_io_hints,
>>> +=09.prepare_ioctl=09 =3D ebs_prepare_ioctl,
>>> +=09.iterate_devices =3D ebs_iterate_devices,
>>> +};
>>> +
>>> +int __init dm_ebs_init(void)
>>> +{
>>> +=09int r =3D dm_register_target(&ebs_target);
>>> +
>>> +=09if (r < 0)
>>> +=09=09DMERR("register failed %d", r);
>>> +
>>> +=09return r;
>>> +}
>>> +
>>> +void dm_ebs_exit(void)
>>> +{
>>> +=09dm_unregister_target(&ebs_target);
>>> +}
>>> +
>>> +module_init(dm_ebs_init);
>>> +module_exit(dm_ebs_exit);
>>> +
>>> +MODULE_AUTHOR("Heinz Mauelshagen <dm-devel@redhat.com>");
>>> +MODULE_DESCRIPTION(DM_NAME " emulated block size target");
>>> +MODULE_LICENSE("GPL");
>>>
>=20
>=20


--=20
Damien Le Moal
Western Digital Research
