From: Will Drewry <wad@chromium.org>
Subject: Re: [PATCH] dm: remake of the verity target
Date: Wed, 14 Mar 2012 16:13:19 -0500
Message-ID: <CABqD9hYUVpC-NQ_WQ5bH8ZxLein+zxHQHDGJzwyRWHokMiPSbg@mail.gmail.com>
References: <1330648393-20692-1-git-send-email-msb@chromium.org>
	<Pine.LNX.4.64.1203031340340.10937@file.rdu.redhat.com>
	<20120306215947.GB27051@google.com>
	<Pine.LNX.4.64.1203131742230.24876@file.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1203131742230.24876@file.rdu.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mandeep Singh Baines <msb@chromium.org>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>, Elly Jones <ellyjones@chromium.org>, Milan Broz <mbroz@redhat.com>, Olof Johansson <olofj@chromium.org>, Steffen Klassert <steffen.klassert@secunet.com>, Andrew Morton <akpm@linux-foundation.org>
List-Id: dm-devel.ids

Hi Mikulas,

This is a nice rewrite and takes advantage of your dm-bufio layer. I
wish it'd existed (and or we wrote it :) in 2009 when we started this
work!  Some comments below:

On Tue, Mar 13, 2012 at 5:20 PM, Mikulas Patocka <mpatocka@redhat.com> =
wrote:
> Hi
>
>> Hi Mikulus,
>>
>> This is some nice work. I like that you've been able to abstract a l=
ot
>> of the hash buffer management with dm-bufio. You got rid of the I/O =
queue.
>> I've been meaning to do that for a while. The prefetch is also nice.
>> We planned to do this but I decided to not do it now in order to get=
 the
>> base functionality in:
>>
>> http://crosbug.com/25441
>>
>> However, there are some things that I don't like. I don't like comme=
nts
>> either but you have none. You also removed our documentation. You ar=
e
>
> I added some comments. As for documentation, it's OK to use documenta=
tion
> from your patch because the on-disk format and the target arguments a=
re
> the same (with an enhancement that my code supports different data an=
d
> metadata bock size and it has variable-length salt).

Sounds good.

>> allocated a complete shash_desc per I/O. We only allocate one per CP=
U.
>
> The hash of 4k block takes 174000 cycles. So trying to optimize
> memory latency that is about 250 cycles doesn't make much sense.
>
> I actually observed better performance using verity on ramdisk with
> workqueue unbound to specific CPUs. The reason is that the ramdisk bi=
o
> completion routine is always run on the same CPU (that one that submi=
tted
> the request), so with bound workqueue, everything was executing on on=
e
> CPU. With unbound workqueue, I got parallelism.
>
>> We short-circuit the hash at any level. Your implementation can only
>> shirt circuit at the lowest level.
>
> It short-circuits hash at all levels. If the function
> "verity_verify_level" finds out that "aux->hash_verified" is non-zero=
, it
> doesn't do any hashing, it just copies the hash for the lower level. =
My
> implementation walks the tree from the top to the bottom, but it does=
n't
> do hash verification if the same block has been verified before.
>
> All this tree-walking from the root to the bottom is 50-times faster =
than
> the actual hashing of the data block (I measured that), so there's no=
t
> much point in trying to optimize it. I did a simple optimization (don=
't
> walk the tree if the lowest block is already verified) and I don't ne=
ed to
> do anything complicated given the fact that it can't improve more tha=
n by
> 2%.

All we'd done was reverse the walk (we've had it both ways now :),
nothing complicated, but I don't think it's a problem.

>> I'd like to propose that we get the version we sent upstream and the=
n work
>> together on adding some of your enhancements incrementally.
>
> If you add dm-bufio support, you end up deleting majority of the orig=
inal
> code anyway. That's why I wrote it from scratch and that's why I didn=
't
> attempt to morph your code.
>
> It's simpler to write the code from scratch and it is also less bug-p=
rone.
>
>> Other than
>> the changes we've made to cleanup for upstreaming, the version I
>> submitted is the code we are using in production.
>>
>> I'm happy to add prefetch now if that is required for merging.
>>
>> What do you think?
>>
>> Regards,
>> Mandeep
>
> This is the version with comments added:
>
> Mikulas
>
> ----
>
> Remake of the google dm-verity patch.
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>
> ---
> =A0drivers/md/Kconfig =A0 =A0 | =A0 17
> =A0drivers/md/Makefile =A0 =A0| =A0 =A01
> =A0drivers/md/dm-verity.c | =A0851 ++++++++++++++++++++++++++++++++++=
+++++++++++++++
> =A03 files changed, 869 insertions(+)
>
> Index: linux-3.3-rc6-fast/drivers/md/Kconfig
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-3.3-rc6-fast.orig/drivers/md/Kconfig =A02012-03-13 21:46:03=
=2E000000000 +0100
> +++ linux-3.3-rc6-fast/drivers/md/Kconfig =A0 =A0 =A0 2012-03-13 21:4=
6:05.000000000 +0100
> @@ -404,4 +404,21 @@ config DM_VERITY2
>
> =A0 =A0 =A0 =A0 =A0 If unsure, say N.
>
> +config DM_VERITY
> + =A0 =A0 =A0 tristate "Verity target support"
> + =A0 =A0 =A0 depends on BLK_DEV_DM
> + =A0 =A0 =A0 select CRYPTO
> + =A0 =A0 =A0 select CRYPTO_HASH
> + =A0 =A0 =A0 select DM_BUFIO
> + =A0 =A0 =A0 ---help---
> + =A0 =A0 =A0 =A0 This device-mapper target allows you to create a de=
vice that
> + =A0 =A0 =A0 =A0 transparently integrity checks the data on it. You'=
ll need to
> + =A0 =A0 =A0 =A0 activate the digests you're going to use in the cry=
ptoapi
> + =A0 =A0 =A0 =A0 configuration.
> +
> + =A0 =A0 =A0 =A0 To compile this code as a module, choose M here: th=
e module will
> + =A0 =A0 =A0 =A0 be called dm-verity.
> +
> + =A0 =A0 =A0 =A0 If unsure, say N.
> +
> =A0endif # MD
> Index: linux-3.3-rc6-fast/drivers/md/Makefile
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-3.3-rc6-fast.orig/drivers/md/Makefile 2012-03-13 21:46:03.0=
00000000 +0100
> +++ linux-3.3-rc6-fast/drivers/md/Makefile =A0 =A0 =A02012-03-13 21:4=
6:05.000000000 +0100
> @@ -29,6 +29,7 @@ obj-$(CONFIG_MD_FAULTY) =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 +=3D faulty.o
> =A0obj-$(CONFIG_BLK_DEV_MD) =A0 =A0 =A0 +=3D md-mod.o
> =A0obj-$(CONFIG_BLK_DEV_DM) =A0 =A0 =A0 +=3D dm-mod.o
> =A0obj-$(CONFIG_DM_BUFIO) =A0 =A0 =A0 =A0 +=3D dm-bufio.o
> +obj-$(CONFIG_DM_VERITY) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0+=3D dm-verit=
y.o
> =A0obj-$(CONFIG_DM_CRYPT) =A0 =A0 =A0 =A0 +=3D dm-crypt.o
> =A0obj-$(CONFIG_DM_DELAY) =A0 =A0 =A0 =A0 +=3D dm-delay.o
> =A0obj-$(CONFIG_DM_FLAKEY) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0+=3D dm-fla=
key.o
> Index: linux-3.3-rc6-fast/drivers/md/dm-verity.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- /dev/null =A0 1970-01-01 00:00:00.000000000 +0000
> +++ linux-3.3-rc6-fast/drivers/md/dm-verity.c =A0 2012-03-13 22:02:05=
=2E000000000 +0100
> @@ -0,0 +1,851 @@
> +/*
> + * Copyright (C) 2012 Red Hat, Inc.
> + *
> + * Author: Mikulas Patocka <mpatocka@redhat.com>
> + *
> + * Based on Chromium dm-verity driver (C) 2011 The Chromium OS Autho=
rs
> + *
> + * This file is released under the GPLv2.
> + *
> + * Device mapper target parameters:
> + * =A0 =A0 <version> =A0 =A0 =A0 0
> + * =A0 =A0 <data device>
> + * =A0 =A0 <hash device>
> + * =A0 =A0 <hash start> =A0 =A0(typically 0)
> + * =A0 =A0 <block size> =A0 =A0(typically 4096)
> + * =A0 =A0 <algorithm>
> + * =A0 =A0 <digest>
> + * =A0 =A0 optional parameters:
> + * =A0 =A0 =A0 =A0 =A0 =A0 <salt> (should have 32 bytes for compatib=
ility with Google code)
> + * =A0 =A0 =A0 =A0 =A0 =A0 <hash block size> (by default it is the s=
ame as data block size)
> + *
> + * In the file "/sys/module/dm_verity/parameters/prefetch_cluster" y=
ou can set
> + * default prefetch value. Data are read in "prefetch_cluster" chunk=
s from the
> + * hash device. Prefetch cluster greatly improves performance when d=
ata and hash
> + * are on the same disk on different partitions.

=2E.. on different partitions on devices with poor random access behavi=
or.

> + */
> +
> +#include <linux/module.h>
> +#include <linux/device-mapper.h>
> +#include <crypto/hash.h>
> +#include "dm-bufio.h"
> +
> +#define DM_MSG_PREFIX =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"verity"
> +
> +#define DM_VERITY_IO_VEC_INLINE =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A016
> +#define DM_VERITY_MEMPOOL_SIZE =A0 =A0 =A0 =A0 4
> +#define DM_VERITY_DEFAULT_PREFETCH_SIZE =A0 =A0 =A0 =A0262144
> +
> +#define DM_VERITY_MAX_LEVELS =A0 =A0 =A0 =A0 =A0 63
> +
> +static unsigned prefetch_cluster =3D DM_VERITY_DEFAULT_PREFETCH_SIZE=
;
> +
> +module_param_named(prefetch_cluster, prefetch_cluster, uint, S_IRUGO=
 | S_IWUSR);
> +
> +struct dm_verity {
> + =A0 =A0 =A0 struct dm_dev *data_dev;
> + =A0 =A0 =A0 struct dm_dev *hash_dev;
> + =A0 =A0 =A0 struct dm_target *ti;
> + =A0 =A0 =A0 struct dm_bufio_client *bufio;
> + =A0 =A0 =A0 char *alg_name;
> + =A0 =A0 =A0 struct crypto_shash *tfm;
> + =A0 =A0 =A0 u8 *root_digest; =A0 =A0 =A0 =A0/* digest of the root b=
lock */
> + =A0 =A0 =A0 u8 *salt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* salt, its size=
 is salt_size */
> + =A0 =A0 =A0 unsigned salt_size;
> + =A0 =A0 =A0 sector_t data_start; =A0 =A0/* data offset in 512-byte =
sectors */
> + =A0 =A0 =A0 sector_t hash_start; =A0 =A0/* hash start in blocks */
> + =A0 =A0 =A0 sector_t data_blocks; =A0 /* the number of data blocks =
*/
> + =A0 =A0 =A0 sector_t hash_blocks; =A0 /* the number of hash blocks =
*/
> + =A0 =A0 =A0 unsigned char data_dev_block_bits; =A0 =A0 =A0/* log2(d=
ata blocksize) */
> + =A0 =A0 =A0 unsigned char hash_dev_block_bits; =A0 =A0 =A0/* log2(h=
ash blocksize) */
> + =A0 =A0 =A0 unsigned char hash_per_block_bits; =A0 =A0 =A0/* log2(h=
ashes in hash block) */
> + =A0 =A0 =A0 unsigned char levels; =A0 /* the number of tree levels =
*/
> + =A0 =A0 =A0 unsigned digest_size; =A0 /* digest size for the curren=
t hash algorithm */
> + =A0 =A0 =A0 unsigned shash_descsize;/* the size of temporary space =
for crypto */
> +
> + =A0 =A0 =A0 mempool_t *io_mempool; =A0/* mempool of struct dm_verit=
y_io */
> + =A0 =A0 =A0 mempool_t *vec_mempool; /* mempool of bio vector */
> +
> + =A0 =A0 =A0 struct workqueue_struct *verify_wq;
> +
> + =A0 =A0 =A0 /* starting blocks for each tree level. 0 is the lowest=
 level. */
> + =A0 =A0 =A0 sector_t hash_level_block[DM_VERITY_MAX_LEVELS];
> +};
> +
> +struct dm_verity_io {
> + =A0 =A0 =A0 struct dm_verity *v;
> + =A0 =A0 =A0 struct bio *bio;
> +
> + =A0 =A0 =A0 /* original values of bio->bi_end_io and bio->bi_privat=
e */
> + =A0 =A0 =A0 bio_end_io_t *orig_bi_end_io;
> + =A0 =A0 =A0 void *orig_bi_private;
> +
> + =A0 =A0 =A0 sector_t block;
> + =A0 =A0 =A0 unsigned n_blocks;
> +
> + =A0 =A0 =A0 /* saved bio vector */
> + =A0 =A0 =A0 struct bio_vec *io_vec;
> + =A0 =A0 =A0 unsigned io_vec_size;
> +
> + =A0 =A0 =A0 struct work_struct work;
> +
> + =A0 =A0 =A0 /* a space for short vectors; longer vectors are alloca=
ted separately */
> + =A0 =A0 =A0 struct bio_vec io_vec_inline[DM_VERITY_IO_VEC_INLINE];
> +
> + =A0 =A0 =A0 /* variable-size fields, accessible with functions
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 io_hash_desc, io_real_digest, io_want_d=
igest */
> + =A0 =A0 =A0 /* u8 hash_desc[crypto_shash_descsize(v->tfm)]; */
> + =A0 =A0 =A0 /* u8 real_digest[v->digest_size]; */
> + =A0 =A0 =A0 /* u8 want_digest[v->digest_size]; */
> +};
> +
> +static struct shash_desc *io_hash_desc(struct dm_verity *v, struct d=
m_verity_io *io)
> +{
> + =A0 =A0 =A0 return (struct shash_desc *)(io + 1);
> +}
> +
> +static u8 *io_real_digest(struct dm_verity *v, struct dm_verity_io *=
io)
> +{
> + =A0 =A0 =A0 return (u8 *)(io + 1) + v->shash_descsize;
> +}
> +
> +static u8 *io_want_digest(struct dm_verity *v, struct dm_verity_io *=
io)
> +{
> + =A0 =A0 =A0 return (u8 *)(io + 1) + v->shash_descsize + v->digest_s=
ize;
> +}
> +
> +/*
> + * Auxiliary structure appended to each dm-bufio buffer. If the valu=
e
> + * hash_verified is nonzero, hash of the block has been verified.
> + *
> + * There is no lock around this value, a race condition can at worst=
 cause
> + * that multiple processes verify the hash of the same buffer simult=
aneously.
> + * This condition is harmless, so we don't need locking.
> + */

Might be worth clarifying that no consumer will ever write a 0 value
to the hash_verified field after dm_bufio_alloc_callback, as that is
the critical constraint.  It's what makes lockless/atomic-less access
acceptable.  As you say, the worst case you over verify or you
over-write.

bufio is nice for this use since it encapsulates the need for the
atomic state transitions we were using in our module to stay
lock-free.

> +struct buffer_aux {
> + =A0 =A0 =A0 int hash_verified;
> +};
> +
> +/*
> + * Initialize struct buffer_aux for a freshly created buffer.
> + */
> +static void dm_bufio_alloc_callback(struct dm_buffer *buf)
> +{
> + =A0 =A0 =A0 struct buffer_aux *aux =3D dm_bufio_get_aux_data(buf);
> + =A0 =A0 =A0 aux->hash_verified =3D 0;
> +}
> +
> +/*
> + * Translate input sector number to the sector number on the target =
device.
> + */
> +static sector_t verity_map_sector(struct dm_verity *v, sector_t bi_s=
ector)
> +{
> + =A0 =A0 =A0 return v->data_start + dm_target_offset(v->ti, bi_secto=
r);
> +}
> +
> +/*
> + * Return hash position of a specified block at a specified tree lev=
el
> + * (0 is the lowest level).
> + * The lowest "hash_per_block_bits"-bits of the result denote hash p=
osition
> + * inside a hash block. The remaining bits denode location of the ha=
sh block.

s/denode/denote/

> + */
> +static sector_t verity_position_at_level(struct dm_verity *v, sector=
_t block,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0int level)
> +{
> + =A0 =A0 =A0 return block >> (level * v->hash_per_block_bits);
> +}
> +
> +static void verity_hash_at_level(struct dm_verity *v, sector_t block=
, int level,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sect=
or_t *hash_block, unsigned *offset)
> +{
> + =A0 =A0 =A0 sector_t position =3D verity_position_at_level(v, block=
, level);
> +
> + =A0 =A0 =A0 *hash_block =3D v->hash_level_block[level] + (position =
>> v->hash_per_block_bits);
> + =A0 =A0 =A0 if (offset)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *offset =3D v->digest_size * (position =
& ((1 << v->hash_per_block_bits) - 1));
> +}
> +
> +/*
> + * Verify hash of a metadata block pertaining to the specified data =
block
> + * ("block" argument) at a specified level ("level" argument).
> + *
> + * On successful return, io_want_digest(v, io) contains the hash val=
ue for
> + * a lower tree level or for the data block (if we're at the lowest =
leve).
> + *
> + * If "skip_unverified" is true, unverified buffer is skipped an 1 i=
s returned.
> + * If "skip_unverified" is false, unverified buffer is hashed and ve=
rified
> + * against current value of io_want_digest(v, io).
> + */
> +static int verity_verify_level(struct dm_verity_io *io, sector_t blo=
ck,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int leve=
l, bool skip_unverified)
> +{
> + =A0 =A0 =A0 struct dm_verity *v =3D io->v;
> + =A0 =A0 =A0 struct dm_buffer *buf;
> + =A0 =A0 =A0 struct buffer_aux *aux;
> + =A0 =A0 =A0 u8 *data;
> + =A0 =A0 =A0 int r;
> + =A0 =A0 =A0 sector_t hash_block;
> + =A0 =A0 =A0 unsigned offset;
> +
> + =A0 =A0 =A0 verity_hash_at_level(v, block, level, &hash_block, &off=
set);
> +
> + =A0 =A0 =A0 data =3D dm_bufio_read(v->bufio, hash_block, &buf);
> + =A0 =A0 =A0 if (unlikely(IS_ERR(data)))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return PTR_ERR(data);
> +
> + =A0 =A0 =A0 aux =3D dm_bufio_get_aux_data(buf);
> +
> + =A0 =A0 =A0 if (!aux->hash_verified) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct shash_desc *desc;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 u8 *result;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (skip_unverified) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 r =3D 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto release_ret_r;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 desc =3D io_hash_desc(v, io);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 desc->tfm =3D v->tfm;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 desc->flags =3D CRYPTO_TFM_REQ_MAY_SLEE=
P;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 r =3D crypto_shash_init(desc);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (r < 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMERR("crypto_shash_ini=
t failed: %d", r);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto release_ret_r;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 r =3D crypto_shash_update(desc, data, 1=
 << v->hash_dev_block_bits);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (r < 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMERR("crypto_shash_upd=
ate failed: %d", r);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto release_ret_r;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 r =3D crypto_shash_update(desc, v->salt=
, v->salt_size);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (r < 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMERR("crypto_shash_upd=
ate failed: %d", r);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto release_ret_r;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 result =3D io_real_digest(v, io);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 r =3D crypto_shash_final(desc, result);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (r < 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMERR("crypto_shash_fin=
al failed: %d", r);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto release_ret_r;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (unlikely(memcmp(result, io_want_dig=
est(v, io), v->digest_size))) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMERR_LIMIT("metadata b=
lock %llu is corrupted",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (unsign=
ed long long)hash_block);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 r =3D -EIO;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto release_ret_r;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 aux->hash_verified =3D =
1;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 data +=3D offset;
> +
> + =A0 =A0 =A0 memcpy(io_want_digest(v, io), data, v->digest_size);
> +
> + =A0 =A0 =A0 dm_bufio_release(buf);
> + =A0 =A0 =A0 return 0;
> +
> +release_ret_r:
> + =A0 =A0 =A0 dm_bufio_release(buf);
> + =A0 =A0 =A0 return r;
> +}
> +
> +/*
> + * Verify one "dm_verity_io" structure.
> + */
> +static int verity_verify_io(struct dm_verity_io *io)
> +{
> + =A0 =A0 =A0 struct dm_verity *v =3D io->v;
> + =A0 =A0 =A0 unsigned b;
> + =A0 =A0 =A0 int i;
> + =A0 =A0 =A0 unsigned vector =3D 0, offset =3D 0;
> + =A0 =A0 =A0 for (b =3D 0; b < io->n_blocks; b++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct shash_desc *desc;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 u8 *result;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 int r;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned todo;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (likely(v->levels)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* First, we try to g=
et the requested hash for
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* the current block.=
 If the hash block itself is
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* verified, zero is =
returned. If it isn't, this
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* function returns 0=
 and we fall back to whole
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* chain verification=
=2E
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int r =3D verity_verify=
_level(io, io->block + b, 0, true);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (likely(!r))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto te=
st_block_hash;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (r < 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
r;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(io_want_digest(v, io), v->root_d=
igest, v->digest_size);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (i =3D v->levels - 1; i >=3D 0; i--=
) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int r =3D verity_verify=
_level(io, io->block + b, i, false);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (unlikely(r))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
r;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> +test_block_hash:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 desc =3D io_hash_desc(v, io);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 desc->tfm =3D v->tfm;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 desc->flags =3D CRYPTO_TFM_REQ_MAY_SLEE=
P;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 r =3D crypto_shash_init(desc);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (r < 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMERR("crypto_shash_ini=
t failed: %d", r);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return r;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 todo =3D 1 << v->data_dev_block_bits;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 do {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct bio_vec *bv;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 u8 *page;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned len;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG_ON(vector >=3D io->=
io_vec_size);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bv =3D &io->io_vec[vect=
or];
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 page =3D kmap_atomic(bv=
->bv_page, KM_USER0);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D bv->bv_len - of=
fset;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (likely(len >=3D tod=
o))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D=
 todo;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 r =3D crypto_shash_upda=
te(desc,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 page + bv->bv_offset + offset, len);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kunmap_atomic(page, KM_=
USER0);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (r < 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMERR("=
crypto_shash_update failed: %d", r);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
r;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 offset +=3D len;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (likely(offset =3D=3D=
 bv->bv_len)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 offset =
=3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vector+=
+;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 todo -=3D len;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } while (todo);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 r =3D crypto_shash_update(desc, v->salt=
, v->salt_size);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (r < 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMERR("crypto_shash_upd=
ate failed: %d", r);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return r;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 result =3D io_real_digest(v, io);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 r =3D crypto_shash_final(desc, result);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (r < 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMERR("crypto_shash_fin=
al failed: %d", r);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return r;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (unlikely(memcmp(result, io_want_dig=
est(v, io), v->digest_size))) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMERR_LIMIT("data block=
 %llu is corrupted",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (unsign=
ed long long)(io->block + b));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EIO;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 BUG_ON(vector !=3D io->io_vec_size);
> + =A0 =A0 =A0 BUG_ON(offset);
> + =A0 =A0 =A0 return 0;
> +}
> +
> +/*
> + * End one "io" structure with a given error.
> + */
> +static void verity_finish_io(struct dm_verity_io *io, int error)
> +{
> + =A0 =A0 =A0 struct bio *bio =3D io->bio;
> + =A0 =A0 =A0 struct dm_verity *v =3D io->v;
> +
> + =A0 =A0 =A0 bio->bi_end_io =3D io->orig_bi_end_io;
> + =A0 =A0 =A0 bio->bi_private =3D io->orig_bi_private;
> +
> + =A0 =A0 =A0 if (io->io_vec !=3D io->io_vec_inline)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mempool_free(io->io_vec, v->vec_mempool=
);
> + =A0 =A0 =A0 mempool_free(io, v->io_mempool);
> +
> + =A0 =A0 =A0 bio_endio(bio, error);
> +}
> +
> +static void verity_work(struct work_struct *w)
> +{
> + =A0 =A0 =A0 struct dm_verity_io *io =3D container_of(w, struct dm_v=
erity_io, work);
> +
> + =A0 =A0 =A0 verity_finish_io(io, verity_verify_io(io));
> +}
> +
> +static void verity_end_io(struct bio *bio, int error)
> +{
> + =A0 =A0 =A0 struct dm_verity_io *io =3D bio->bi_private;
> + =A0 =A0 =A0 if (error) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 verity_finish_io(io, error);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 INIT_WORK(&io->work, verity_work);
> + =A0 =A0 =A0 queue_work(io->v->verify_wq, &io->work);
> +}
> +
> +/*
> + * Prefetch buffers for the specified io.
> + * The root buffer is not prefetched, it is assumed that it will be =
cached
> + * all the time.
> + */
> +static void verity_prefetch_io(struct dm_verity *v, struct dm_verity=
_io *io)
> +{
> + =A0 =A0 =A0 int i;
> + =A0 =A0 =A0 for (i =3D v->levels - 2; i >=3D 0; i--) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sector_t hash_block_start;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sector_t hash_block_end;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 verity_hash_at_level(v, io->block, i, &=
hash_block_start, NULL);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 verity_hash_at_level(v, io->block + io-=
>n_blocks - 1, i, &hash_block_end, NULL);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!i) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned cluster =3D pr=
efetch_cluster;
> + =A0 =A0 =A0 =A0/* barrier to stop GCC from re-reading prefetch_clus=
ter again */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 barrier();
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cluster >>=3D v->data_d=
ev_block_bits;

Would:
  unsigned cluster =3D prefetch_cluster >> v->data_dev_block_bits;
not have similar behavior without a barrier?  (Yeah yeah I could
compile and see, but I was curious if you already had.)

Since the max iterations here is 61 in a worst-case, I don't think
it's a big deal to barrier() each time, just thought I'd ask.

> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (unlikely(!cluster))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto no=
_prefetch_cluster;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (unlikely(cluster & =
(cluster - 1)))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cluster=
 =3D 1 << (fls(cluster) - 1);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 hash_block_start &=3D ~=
(sector_t)(cluster - 1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 hash_block_end |=3D clu=
ster - 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (unlikely(hash_block=
_end >=3D v->hash_blocks))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 hash_bl=
ock_end =3D v->hash_blocks - 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +no_prefetch_cluster:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dm_bufio_prefetch(v->bufio, hash_block_=
start,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 hash_block_end - hash_block_start + 1);
> + =A0 =A0 =A0 }
> +}
> +
> +/*
> + * Bio map function. It allocates dm_verity_io structure and bio vec=
tor and
> + * fills them. Then it issues prefetches and the I/O.
> + */
> +static int verity_map(struct dm_target *ti, struct bio *bio,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 union map_info *map_context=
)
> +{
> + =A0 =A0 =A0 struct dm_verity *v =3D ti->private;
> + =A0 =A0 =A0 struct dm_verity_io *io;
> +
> + =A0 =A0 =A0 if (((unsigned)bio->bi_sector | bio_sectors(bio)) &
> + =A0 =A0 =A0 =A0 =A0 ((1 << (v->data_dev_block_bits - SECTOR_SHIFT))=
 - 1)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMERR_LIMIT("unaligned io");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EIO;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 if ((bio->bi_sector + bio_sectors(bio)) >>
> + =A0 =A0 =A0 =A0 =A0 (v->data_dev_block_bits - SECTOR_SHIFT) > v->da=
ta_blocks) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMERR_LIMIT("io out of range");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EIO;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 if (bio_data_dir(bio) =3D=3D WRITE)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EIO;
> +
> + =A0 =A0 =A0 io =3D mempool_alloc(v->io_mempool, GFP_NOIO);
> + =A0 =A0 =A0 io->v =3D v;
> + =A0 =A0 =A0 io->bio =3D bio;
> + =A0 =A0 =A0 io->orig_bi_end_io =3D bio->bi_end_io;
> + =A0 =A0 =A0 io->orig_bi_private =3D bio->bi_private;
> + =A0 =A0 =A0 io->block =3D bio->bi_sector >> (v->data_dev_block_bits=
 - SECTOR_SHIFT);
> + =A0 =A0 =A0 io->n_blocks =3D bio->bi_size >> v->data_dev_block_bits=
;
> +
> + =A0 =A0 =A0 bio->bi_end_io =3D verity_end_io;
> + =A0 =A0 =A0 bio->bi_private =3D io;
> + =A0 =A0 =A0 bio->bi_bdev =3D v->data_dev->bdev;
> + =A0 =A0 =A0 bio->bi_sector =3D verity_map_sector(v, bio->bi_sector)=
;
> +
> + =A0 =A0 =A0 io->io_vec_size =3D bio->bi_vcnt - bio->bi_idx;
> + =A0 =A0 =A0 if (io->io_vec_size < DM_VERITY_IO_VEC_INLINE)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 io->io_vec =3D io->io_vec_inline;
> + =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 io->io_vec =3D mempool_alloc(v->vec_mem=
pool, GFP_NOIO);
> + =A0 =A0 =A0 memcpy(io->io_vec, bio_iovec(bio),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0io->io_vec_size * sizeof(struct bio_vec)=
);
> +
> + =A0 =A0 =A0 verity_prefetch_io(v, io);
> +
> + =A0 =A0 =A0 generic_make_request(bio);
> +
> + =A0 =A0 =A0 return DM_MAPIO_SUBMITTED;
> +}
> +
> +static int verity_status(struct dm_target *ti, status_type_t type,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0char *result, unsign=
ed maxlen)
> +{
> + =A0 =A0 =A0 struct dm_verity *v =3D ti->private;
> + =A0 =A0 =A0 unsigned sz =3D 0;
> + =A0 =A0 =A0 unsigned x;
> +
> + =A0 =A0 =A0 switch (type) {
> + =A0 =A0 =A0 case STATUSTYPE_INFO:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 result[0] =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 case STATUSTYPE_TABLE:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMEMIT("%u %s %s %llu %u %s ",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 v->data_dev->name,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 v->hash_dev->name,

I understand the new approach is to use major:minor instead of the
device name.  I don't care which, but I believe agk@ requested that.

> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (unsigned long long)v->=
hash_start << (v->hash_dev_block_bits - SECTOR_SHIFT),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 1 << v->data_dev_block_=
bits,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 v->alg_name
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 );
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (x =3D 0; x < v->digest_size; x++)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMEMIT("%02x", v->root_=
digest[x]);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMEMIT(" ");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!v->salt_size)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMEMIT("-");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (x =3D 0; x < v->sa=
lt_size; x++)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMEMIT(=
"%02x", v->salt[x]);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (v->data_dev_block_bits !=3D v->hash=
_dev_block_bits)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMEMIT(" %u", 1 << v->h=
ash_dev_block_bits);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 return 0;
> +}
> +
> +static int verity_ioctl(struct dm_target *ti, unsigned cmd,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned long arg)
> +{
> + =A0 =A0 =A0 struct dm_verity *v =3D ti->private;
> + =A0 =A0 =A0 int r =3D 0;
> +
> + =A0 =A0 =A0 if (v->data_start ||
> + =A0 =A0 =A0 =A0 =A0 ti->len !=3D i_size_read(v->data_dev->bdev->bd_=
inode) >> SECTOR_SHIFT)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 r =3D scsi_verify_blk_ioctl(NULL, cmd);
> +

Is it worth supporting ioctl at all given these hoops?  Nothing stops
a privileged user from directly running the ioctl on the underlying
device/devices, it's just very inconvenient :)

> + =A0 =A0 =A0 return r ? : __blkdev_driver_ioctl(v->data_dev->bdev, v=
->data_dev->mode,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0cmd, arg);
> +}
> +
> +static int verity_merge(struct dm_target *ti, struct bvec_merge_data=
 *bvm,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct bio_vec *biovec,=
 int max_size)
> +{
> + =A0 =A0 =A0 struct dm_verity *v =3D ti->private;
> + =A0 =A0 =A0 struct request_queue *q =3D bdev_get_queue(v->data_dev-=
>bdev);
> +
> + =A0 =A0 =A0 if (!q->merge_bvec_fn)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return max_size;
> +
> + =A0 =A0 =A0 bvm->bi_bdev =3D v->data_dev->bdev;
> + =A0 =A0 =A0 bvm->bi_sector =3D verity_map_sector(v, bvm->bi_sector)=
;
> +
> + =A0 =A0 =A0 return min(max_size, q->merge_bvec_fn(q, bvm, biovec));
> +}
> +
> +static int verity_iterate_devices(struct dm_target *ti,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ite=
rate_devices_callout_fn fn, void *data)
> +{
> + =A0 =A0 =A0 struct dm_verity *v =3D ti->private;
> + =A0 =A0 =A0 return fn(ti, v->data_dev, v->data_start, ti->len, data=
);
> +}
> +
> +static void verity_io_hints(struct dm_target *ti, struct queue_limit=
s *limits)
> +{
> + =A0 =A0 =A0 struct dm_verity *v =3D ti->private;
> +
> + =A0 =A0 =A0 if (limits->logical_block_size < 1 << v->data_dev_block=
_bits)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 limits->logical_block_size =3D 1 << v->=
data_dev_block_bits;
> + =A0 =A0 =A0 if (limits->physical_block_size < 1 << v->data_dev_bloc=
k_bits)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 limits->physical_block_size =3D 1 << v-=
>data_dev_block_bits;
> + =A0 =A0 =A0 blk_limits_io_min(limits, limits->logical_block_size);
> +}
> +
> +static void verity_dtr(struct dm_target *ti);
> +
> +static int verity_ctr(struct dm_target *ti, unsigned argc, char **ar=
gv)
> +{
> + =A0 =A0 =A0 struct dm_verity *v;
> + =A0 =A0 =A0 unsigned num;
> + =A0 =A0 =A0 unsigned long long hs;
> + =A0 =A0 =A0 int r;
> + =A0 =A0 =A0 int i;
> + =A0 =A0 =A0 sector_t hash_position;
> + =A0 =A0 =A0 char dummy;
> +
> + =A0 =A0 =A0 v =3D kzalloc(sizeof(struct dm_verity), GFP_KERNEL);
> + =A0 =A0 =A0 if (!v) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ti->error =3D "Cannot allocate verity s=
tructure";
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 ti->private =3D v;
> + =A0 =A0 =A0 v->ti =3D ti;
> +
> + =A0 =A0 =A0 if ((dm_table_get_mode(ti->table) & ~FMODE_READ) !=3D 0=
) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ti->error =3D "Device must be readonly"=
;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 r =3D -EINVAL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto bad;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 if (argc < 7) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ti->error =3D "Not enough arguments";
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 r =3D -EINVAL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto bad;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 if (sscanf(argv[0], "%d%c", &num, &dummy) !=3D 1 ||
> + =A0 =A0 =A0 =A0 =A0 num !=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ti->error =3D "Invalid version";
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 r =3D -EINVAL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto bad;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 r =3D dm_get_device(ti, argv[1], FMODE_READ, &v->data_d=
ev);
> + =A0 =A0 =A0 if (r) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ti->error =3D "Data device lookup faile=
d";
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto bad;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 r =3D dm_get_device(ti, argv[2], FMODE_READ, &v->hash_d=
ev);
> + =A0 =A0 =A0 if (r) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ti->error =3D "Data device lookup faile=
d";
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto bad;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 if (sscanf(argv[3], "%llu%c", &hs, &dummy) !=3D 1 ||
> + =A0 =A0 =A0 =A0 =A0 hs !=3D (sector_t)hs) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ti->error =3D "Invalid hash start";
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 r =3D -EINVAL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto bad;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 if (sscanf(argv[4], "%u%c", &num, &dummy) !=3D 1 ||
> + =A0 =A0 =A0 =A0 =A0 !num || (num & (num - 1)) ||
> + =A0 =A0 =A0 =A0 =A0 num < bdev_logical_block_size(v->data_dev->bdev=
) ||
> + =A0 =A0 =A0 =A0 =A0 num > PAGE_SIZE) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ti->error =3D "Invalid data device bloc=
k size";
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 r =3D -EINVAL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto bad;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 v->data_dev_block_bits =3D ffs(num) - 1;
> + =A0 =A0 =A0 v->hash_dev_block_bits =3D ffs(num) - 1;
> +
> + =A0 =A0 =A0 v->alg_name =3D kstrdup(argv[5], GFP_KERNEL);
> + =A0 =A0 =A0 if (!v->alg_name) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ti->error =3D "Cannot allocate algorith=
m name";
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 r =3D -ENOMEM;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto bad;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 v->tfm =3D crypto_alloc_shash(v->alg_name, 0, 0);
> + =A0 =A0 =A0 if (IS_ERR(v->tfm)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ti->error =3D "Cannot initialize hash f=
unction";
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 r =3D PTR_ERR(v->tfm);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 v->tfm =3D NULL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto bad;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 v->digest_size =3D crypto_shash_digestsize(v->tfm);
> + =A0 =A0 =A0 if ((1 << v->hash_dev_block_bits) < v->digest_size * 2)=
 {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ti->error =3D "Digest size too big";
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 r =3D -EINVAL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto bad;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 v->shash_descsize =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(struct shash_desc) + crypto_shas=
h_descsize(v->tfm);
> +
> + =A0 =A0 =A0 v->root_digest =3D kmalloc(v->digest_size, GFP_KERNEL);
> + =A0 =A0 =A0 if (!v->root_digest) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ti->error =3D "Cannot allocate root dig=
est";
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 r =3D -ENOMEM;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto bad;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 if (strlen(argv[6]) !=3D v->digest_size * 2 ||
> + =A0 =A0 =A0 =A0 =A0 hex2bin(v->root_digest, argv[6], v->digest_size=
)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ti->error =3D "Invalid root digest";
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 r =3D -EINVAL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto bad;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 if (argc > 7 && strcmp(argv[7], "-")) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 v->salt_size =3D strlen(argv[7]) / 2;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 v->salt =3D kmalloc(v->salt_size, GFP_K=
ERNEL);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!v->salt) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ti->error =3D "Cannot a=
llocate salt";
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 r =3D -ENOMEM;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto bad;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (strlen(argv[7]) !=3D v->salt_size *=
 2 ||
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 hex2bin(v->salt, argv[7], v->sa=
lt_size)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ti->error =3D "Invalid =
salt";
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 r =3D -EINVAL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto bad;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 if (argc > 8) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (sscanf(argv[8], "%u%c", &num, &dumm=
y) !=3D 1 ||
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 !num || (num & (num - 1)) ||
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 num < bdev_logical_block_size(v=
->hash_dev->bdev) ||
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 num > INT_MAX) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ti->error =3D "Invalid =
hash device block size";
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 r =3D -EINVAL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto bad;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 v->hash_dev_block_bits =3D ffs(num) - 1=
;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 if (hs & ((1 << (v->hash_dev_block_bits - SECTOR_SHIFT)=
) - 1)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ti->error =3D "Hash start not aligned o=
n block boundary";
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 r =3D -EINVAL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto bad;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 v->hash_start =3D hs >> (v->hash_dev_block_bits - SECTO=
R_SHIFT);
> +
> + =A0 =A0 =A0 if (ti->len > i_size_read(v->data_dev->bdev->bd_inode) =
>> SECTOR_SHIFT) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ti->error =3D "Data device si too small=
";

s/si/is

Should this also check ti->start + ti->len to ensure it isn't reading
off the end or do you just rely on the requests failing?

> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 r =3D -EINVAL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto bad;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 if (ti->len & ((1 << (v->data_dev_block_bits - SECTOR_S=
HIFT)) - 1)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ti->error =3D "Data device length is no=
t aligned to block size";
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 r =3D -EINVAL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto bad;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 v->data_blocks =3D ti->len >> (v->data_dev_block_bits -=
 SECTOR_SHIFT);
> +
> + =A0 =A0 =A0 v->hash_per_block_bits =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 fls((1 << v->hash_dev_block_bits) / v->=
digest_size) - 1;
> +
> + =A0 =A0 =A0 v->levels =3D 0;
> + =A0 =A0 =A0 if (v->data_blocks)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 while (v->hash_per_block_bits * v->leve=
ls < 64 &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(unsigned long long)(v->=
data_blocks - 1) >>
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(v->hash_per_block_bits =
* v->levels))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 v->levels++;
> +
> + =A0 =A0 =A0 if (v->levels > DM_VERITY_MAX_LEVELS) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ti->error =3D "Too many tree levels";
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 r =3D -E2BIG;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto bad;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 hash_position =3D v->hash_start;
> + =A0 =A0 =A0 for (i =3D v->levels - 1; i >=3D 0; i--) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sector_t s;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 v->hash_level_block[i] =3D hash_positio=
n;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 s =3D verity_position_at_level(v, v->da=
ta_blocks, i);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 s =3D (s >> v->hash_per_block_bits) +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 !!(s & ((1 << v->hash_per_block=
_bits) - 1));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (hash_position + s < hash_position) =
{
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ti->error =3D "Hash dev=
ice offset overflow";
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 r =3D -E2BIG;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto bad;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 hash_position +=3D s;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 v->hash_blocks =3D hash_position;
> +
> + =A0 =A0 =A0 v->bufio =3D dm_bufio_client_create(v->hash_dev->bdev,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 1 << v->hash_dev_block_bits, 1, sizeof(=
struct buffer_aux),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dm_bufio_alloc_callback, NULL);
> + =A0 =A0 =A0 if (IS_ERR(v->bufio)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ti->error =3D "Cannot initialize dm-buf=
io";
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 r =3D PTR_ERR(v->bufio);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 v->bufio =3D NULL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto bad;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 if (dm_bufio_get_device_size(v->bufio) < v->hash_blocks=
) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ti->error =3D "Hash device is too small=
";
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 r =3D -E2BIG;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto bad;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 v->io_mempool =3D mempool_create_kmalloc_pool(DM_VERITY=
_MEMPOOL_SIZE,
> + =A0 =A0 =A0 =A0 sizeof(struct dm_verity_io) + v->shash_descsize + v=
->digest_size * 2);
> + =A0 =A0 =A0 if (!v->io_mempool) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ti->error =3D "Cannot allocate io mempo=
ol";
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 r =3D -ENOMEM;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto bad;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 v->vec_mempool =3D mempool_create_kmalloc_pool(DM_VERIT=
Y_MEMPOOL_SIZE,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 BIO_MAX_PAGES * sizeof(struct bio_vec));
> + =A0 =A0 =A0 if (!v->vec_mempool) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ti->error =3D "Cannot allocate vector m=
empool";
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 r =3D -ENOMEM;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto bad;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /*v->verify_wq =3D alloc_workqueue("verityd", WQ_CPU_IN=
TENSIVE | WQ_MEM_RECLAIM, 1);*/
> + =A0 =A0 =A0 /* WQ_UNBOUND greatly improves performance when running=
 on ramdisk */
> + =A0 =A0 =A0 v->verify_wq =3D alloc_workqueue("verityd", WQ_CPU_INTE=
NSIVE | WQ_MEM_RECLAIM | WQ_UNBOUND, num_online_cpus());
> + =A0 =A0 =A0 if (!v->verify_wq) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ti->error =3D "Cannot allocate workqueu=
e";
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 r =3D -ENOMEM;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto bad;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 return 0;
> +
> +bad:
> + =A0 =A0 =A0 verity_dtr(ti);
> + =A0 =A0 =A0 return r;
> +}
> +
> +static void verity_dtr(struct dm_target *ti)
> +{
> + =A0 =A0 =A0 struct dm_verity *v =3D ti->private;
> +
> + =A0 =A0 =A0 if (v->verify_wq)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 destroy_workqueue(v->verify_wq);
> + =A0 =A0 =A0 if (v->vec_mempool)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mempool_destroy(v->vec_mempool);
> + =A0 =A0 =A0 if (v->io_mempool)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mempool_destroy(v->io_mempool);
> + =A0 =A0 =A0 if (v->bufio)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dm_bufio_client_destroy(v->bufio);
> + =A0 =A0 =A0 kfree(v->salt);
> + =A0 =A0 =A0 kfree(v->root_digest);
> + =A0 =A0 =A0 if (v->tfm)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 crypto_free_shash(v->tfm);
> + =A0 =A0 =A0 kfree(v->alg_name);
> + =A0 =A0 =A0 if (v->hash_dev)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dm_put_device(ti, v->hash_dev);
> + =A0 =A0 =A0 if (v->data_dev)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dm_put_device(ti, v->data_dev);
> + =A0 =A0 =A0 kfree(v);
> +}
> +
> +static struct target_type verity_target =3D {
> + =A0 =A0 =A0 .name =A0 =A0 =A0 =A0 =A0 =3D "verity",
> + =A0 =A0 =A0 .version =A0 =A0 =A0 =A0=3D {1, 0, 0},
> + =A0 =A0 =A0 .module =A0 =A0 =A0 =A0 =3D THIS_MODULE,
> + =A0 =A0 =A0 .ctr =A0 =A0 =A0 =A0 =A0 =A0=3D verity_ctr,
> + =A0 =A0 =A0 .dtr =A0 =A0 =A0 =A0 =A0 =A0=3D verity_dtr,
> + =A0 =A0 =A0 .map =A0 =A0 =A0 =A0 =A0 =A0=3D verity_map,
> + =A0 =A0 =A0 .status =A0 =A0 =A0 =A0 =3D verity_status,
> + =A0 =A0 =A0 .ioctl =A0 =A0 =A0 =A0 =A0=3D verity_ioctl,
> + =A0 =A0 =A0 .merge =A0 =A0 =A0 =A0 =A0=3D verity_merge,
> + =A0 =A0 =A0 .iterate_devices =3D verity_iterate_devices,
> + =A0 =A0 =A0 .io_hints =A0 =A0 =A0 =3D verity_io_hints,
> +};
> +
> +static int __init dm_verity_init(void)
> +{
> + =A0 =A0 =A0 int r;
> + =A0 =A0 =A0 r =3D dm_register_target(&verity_target);
> + =A0 =A0 =A0 if (r < 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMERR("register failed %d", r);
> + =A0 =A0 =A0 return r;
> +}
> +
> +static void __exit dm_verity_exit(void)
> +{
> + =A0 =A0 =A0 dm_unregister_target(&verity_target);
> +}
> +
> +module_init(dm_verity_init);
> +module_exit(dm_verity_exit);
> +
> +MODULE_AUTHOR("Mikulas Patocka <mpatocka@redhat.com>");

As per linux/module.h, I'd welcome additional authors as per the
lkml/patch lineage:
MODULE_AUTHOR("Mandeep Baines <msb@chromium.org>");
MODULE_AUTHOR("Will Drewry <wad@chromium.org>");

Regardless, I'll just be happy to see this functionality merge.

> +MODULE_DESCRIPTION(DM_NAME " target for transparent disk integrity c=
hecking");
> +MODULE_LICENSE("GPL");
> +
> Index: linux-3.3-rc6-fast/drivers/md/dm-bufio.c

This should be in a separate patch I think.

> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-3.3-rc6-fast.orig/drivers/md/dm-bufio.c =A0 =A0 =A0 2012-03=
-12 22:43:23.000000000 +0100
> +++ linux-3.3-rc6-fast/drivers/md/dm-bufio.c =A0 =A02012-03-13 15:41:=
02.000000000 +0100
[snip]
> @@ -882,6 +888,19 @@ static struct dm_buffer *__bufio_new(str
>
> =A0 =A0 =A0 =A0b =3D __find(c, block);
> =A0 =A0 =A0 =A0if (b) {
> +found_buffer:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (nf =3D=3D NF_PREFETCH)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return NULL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Note: it is essential that we don'=
t wait for the buffer to be
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* read if dm_bufio_get function is u=
sed. Both dm_bufio_get and
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* dm_bufio_prefetch can be used in t=
he driver request routine.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* If the user called both dm_bufio_p=
refetch and dm_bufio_get on
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* the same buffer, it would deadlock=
 if we waited.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (nf =3D=3D NF_GET && unlikely(test_b=
it(B_READING, &b->state)))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return NULL;
> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0b->hold_count++;

Are these hold_counts safe on architectures with weak memory models?
Should they be atomic_ts?   I haven't looked at them in context, but
based on what I see here they make me a bit nervous.

Thanks for jumping in to the fray!  None of my comments are blocking,
so I believe the following is appropriate (if not
s/Signed-off/Reviewed-by/).

Signed-off-by: Will Drewry <wad@chromium.org>

cheers!
will
