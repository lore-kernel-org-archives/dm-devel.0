From: Will Drewry <wad@chromium.org>
Subject: Re: [PATCH] dm: verity target
Date: Tue, 27 Sep 2011 14:02:05 -0500
Message-ID: <CABqD9hYWK2czEKN87xDu7YPbRcp9xrumJ5PZ8aQTzBLafrnBMw@mail.gmail.com>
References: <1316112359-6085-1-git-send-email-msb@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1316112359-6085-1-git-send-email-msb@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Mandeep Singh Baines <msb@chromium.org>, Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
Cc: dm-devel@redhat.com, Elly Jones <ellyjones@chromium.org>, Olof Johansson <olofj@chromium.org>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hi all!

I was just curious if there is any interest in pulling this change, or
if not, if there is any particular set of concerns, fixes, etc.  I
realize it's not a small amount of code to digest (though it is
smaller than the post from last year[1]).   Would re-posting with an
added blob explaining the name be useful, or, perhaps, a name change,
or is there anything further that would be beneficial to
consideration?  Jonathan Corbet was kind enough to wade through the
docs and code to write an article[2] which may help.  Additionally,
Mandeep and I presented[3] at the Security Summit and the Filesystems
track of Plumbers on the topic which I hope helped show the value of
this patch (everything from layering with EVM to providing tboot users
with a fast, efficient way to verify their system images without
requiring immutable media).

As usual, any and all guidance/feedback/flames will be appreciated - th=
anks!
will


1 - http://thread.gmane.org/gmane.linux.kernel/989307
2 - http://lwn.net/Articles/459420/
3 - http://selinuxproject.org/~jmorris/lss2011_slides/LSS_11_Integrity_=
checked_block_devices.pdf

On Thu, Sep 15, 2011 at 1:45 PM, Mandeep Singh Baines <msb@chromium.org=
> wrote:
> The verity target provides transparent integrity checking of block de=
vices
> using a cryptographic digest.
>
> dm-verity is meant to be setup as part of a verified boot path. =A0Th=
is
> may be anything ranging from a boot using tboot or trustedgrub to jus=
t
> booting from a known-good device (like a USB drive or CD).
>
> dm-verity is part of ChromeOS's verified boot path. It is used to ver=
ify
> the integrity of the root filesystem on boot. The root filesystem is
> mounted on a dm-verity partition which transparently verifies each bl=
ock
> with a bootloader verified hash passed into the kernel at boot.
>
> Signed-off-by: Will Drewry <wad@chromium.org>
> Signed-off-by: Elly Jones <ellyjones@chromium.org>
> Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
> Cc: Alasdair G Kergon <agk@redhat.com>
> Cc: Milan Broz <mbroz@redhat.com>
> Cc: Olof Johansson <olofj@chromium.org>
> Cc: dm-devel@redhat.com
> Cc: linux-kernel@vger.kernel.org
> ---
> =A0Documentation/device-mapper/dm-bht.txt =A0 =A0| =A0 59 ++
> =A0Documentation/device-mapper/dm-verity.txt | =A0 76 +++
> =A0drivers/md/Kconfig =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
| =A0 30 +
> =A0drivers/md/Makefile =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =
=A0 =A02 +
> =A0drivers/md/dm-bht.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =
=A0541 +++++++++++++++
> =A0drivers/md/dm-verity.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| 10=
43 +++++++++++++++++++++++++++++
> =A0drivers/md/dm-verity.h =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0=
 45 ++
> =A0include/linux/dm-bht.h =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0=
166 +++++
> =A08 files changed, 1962 insertions(+), 0 deletions(-)
> =A0create mode 100644 Documentation/device-mapper/dm-bht.txt
> =A0create mode 100644 Documentation/device-mapper/dm-verity.txt
> =A0create mode 100644 drivers/md/dm-bht.c
> =A0create mode 100644 drivers/md/dm-verity.c
> =A0create mode 100644 drivers/md/dm-verity.h
> =A0create mode 100644 include/linux/dm-bht.h
>
> diff --git a/Documentation/device-mapper/dm-bht.txt b/Documentation/d=
evice-mapper/dm-bht.txt
> new file mode 100644
> index 0000000..21d929f
> --- /dev/null
> +++ b/Documentation/device-mapper/dm-bht.txt
> @@ -0,0 +1,59 @@
> +dm-bht
> +=3D=3D=3D=3D=3D=3D
> +
> +dm-bht provides a block hash tree implementation. =A0The use of dm-b=
ht allows
> +for integrity checking of a given block device without reading the e=
ntire
> +set of blocks into memory before use.
> +
> +In particular, dm-bht supplies an interface for creating and verifyi=
ng a tree
> +of cryptographic digests with any algorithm supported by the kernel =
crypto API.
> +
> +The `verity' target is the motivating example.
> +
> +
> +Theory of operation
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +dm-bht is logically comprised of multiple nodes organized in a tree-=
like
> +structure. =A0Each node in the tree is a cryptographic hash. =A0If i=
t is a leaf
> +node, the hash is of some block data on disk. =A0If it is an interme=
diary node,
> +then the hash is of a number of child nodes.
> +
> +dm-bht has a given depth starting at 1 (ignoring the root node). =A0=
Each level in
> +the tree is concretely made up of dm_bht_entry structs. =A0Each entr=
y in the tree
> +is a collection of neighboring nodes that fit in one page-sized bloc=
k. =A0The
> +number is determined based on PAGE_SIZE and the size of the selected
> +cryptographic digest algorithm. =A0The hashes are linearly ordered i=
n this entry
> +and any unaligned trailing space is ignored but included when calcul=
ating the
> +parent node.
> +
> +The tree looks something like:
> +
> +alg=3D sha256, num_blocks =3D 32767
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 [ =A0=
 root =A0 =A0]
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/ =A0=
 =A0. . . =A0 =A0\
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 [entry_0] =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 [entry_1]
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/ =A0. . . =A0\ =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 . . . =A0 \
> + =A0 =A0 =A0 =A0 [entry_0_0] =A0 . . . =A0[entry_0_127] =A0 =A0. . .=
 . =A0[entry_1_127]
> + =A0 =A0 =A0 =A0 =A0 / ... \ =A0 =A0 =A0 =A0 =A0 =A0 / =A0 . . . =A0=
\ =A0 =A0 =A0 =A0 =A0 =A0 / =A0 =A0 =A0 =A0 =A0 \
> + =A0 =A0 blk_0 ... blk_127 =A0blk_16256 =A0 blk_16383 =A0 =A0 =A0blk=
_32640 . . . blk_32767
> +
> +root is treated independently from the depth and the blocks are expe=
cted to
> +be hashed and supplied to the dm-bht. =A0hash blocks that make up th=
e entry
> +contents are expected to be read from disk.
> +
> +dm-bht does not handle I/O directly but instead expects the consumer=
 to
> +supply callbacks. =A0The read callback will always receive a page-al=
ign value
> +to pass to the block device layer to read in a hash value.
> +
> +Usage
> +=3D=3D=3D=3D=3D
> +
> +The API provides mechanisms for reading and verifying a tree. When r=
eading, all
> +required data for the hash tree should be populated for a block befo=
re
> +attempting a verify. =A0This can be done by calling dm_bht_populate(=
). =A0When all
> +data is ready, a call to dm_bht_verify_block() with the expected has=
h value will
> +perform both the direct block hash check and the hashes of the paren=
t and
> +neighboring nodes where needed to ensure validity up to the root has=
h. =A0Note,
> +dm_bht_set_root_hexdigest() should be called before any verification=
 attempts
> +occur.
> diff --git a/Documentation/device-mapper/dm-verity.txt b/Documentatio=
n/device-mapper/dm-verity.txt
> new file mode 100644
> index 0000000..f33b984
> --- /dev/null
> +++ b/Documentation/device-mapper/dm-verity.txt
> @@ -0,0 +1,76 @@
> +dm-verity
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Device-Mapper's "verity" target provides transparent integrity check=
ing of
> +block devices using a cryptographic digest provided by the kernel cr=
ypto API.
> +This target is read-only.
> +
> +Parameters: payload=3D<device path> hashtree=3D<hash device path> al=
g=3D<alg> \
> + =A0 =A0 =A0 =A0 =A0 =A0salt=3D<salt> root_hexagiest=3D<root hash> \
> + =A0 =A0 =A0 =A0 =A0 =A0[ hashstart=3D<hash start> error_behavior=3D=
<error behavior> ]
> +
> +<device path>
> + =A0 =A0This is the device that is going to be integrity checked. =A0=
It may be
> + =A0 =A0a subset of the full device as specified to dmsetup (start s=
ector and count)
> + =A0 =A0It may be specified as a path, like /dev/sdaX, or a device n=
umber,
> + =A0 =A0<major>:<minor>.
> +
> +<hash device path>
> + =A0 =A0This is the device that that supplies the dm-bht hash data. =
=A0It may be
> + =A0 =A0specified similarly to the device path and may be the same d=
evice. =A0If the
> + =A0 =A0same device is used, the hash offset should be outside of th=
e dm-verity
> + =A0 =A0configured device size.
> +
> +<alg>
> + =A0 =A0The cryptographic hash algorithm used for this device. =A0Th=
is should
> + =A0 =A0be the name of the algorithm, like "sha1".
> +
> +<salt>
> + =A0 =A0Salt value (in hex).
> +
> +<root hash>
> + =A0 =A0The hexadecimal encoding of the cryptographic hash of all of=
 the
> + =A0 =A0neighboring nodes at the first level of the tree. =A0This ha=
sh should be
> + =A0 =A0trusted as there is no other authenticity beyond this point.
> +
> +<hash start>
> + =A0 =A0Start address of hashes (default 0).
> +
> +<error behavior>
> + =A0 =A00 =3D return -EIO. 1 =3D panic. 2 =3D none. 3 =3D call notif=
ier.
> +
> +Theory of operation
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +dm-verity is meant to be setup as part of a verified boot path. =A0T=
his
> +may be anything ranging from a boot using tboot or trustedgrub to ju=
st
> +booting from a known-good device (like a USB drive or CD).
> +
> +When a dm-verity device is configured, it is expected that the calle=
r
> +has been authenticated in some way (cryptographic signatures, etc).
> +After instantiation, all hashes will be verified on-demand during
> +disk access. =A0If they cannot be verified up to the root node of th=
e
> +tree, the root hash, then the I/O will fail. =A0This should identify
> +tampering with any data on the device and the hash data.
> +
> +Cryptographic hashes are used to assert the integrity of the device =
on a
> +per-block basis. =A0This allows for a lightweight hash computation o=
n first read
> +into the page cache. =A0Block hashes are stored linearly aligned to =
the nearest
> +block the size of a page.
> +
> +For more information on the hashing process, see dm-bht.txt.
> +
> +
> +Example
> +=3D=3D=3D=3D=3D=3D=3D
> +
> +Setup a device;
> +[[
> + =A0dmsetup create vroot --table \
> + =A0 =A0"0 204800 verity payload=3D/dev/sda1 hashtree=3D/dev/sda2 al=
g=3Dsha1 "\
> + =A0 =A0"root_hexdigest=3D9f74809a2ee7607b16fcc70d9399a4de9725a727"
> +]]
> +
> +A command line tool is available to compute the hash tree and return=
 the
> +root hash value.
> + =A0http://git.chromium.org/cgi-bin/gitweb.cgi?p=3Ddm-verity.git;a=3D=
tree
> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> index f75a66e..cb5f425 100644
> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -334,4 +334,34 @@ config DM_FLAKEY
> =A0 =A0 =A0 =A0---help---
> =A0 =A0 =A0 =A0 =A0A target that intermittently fails I/O for debuggi=
ng purposes.
>
> +config DM_BHT
> + =A0 =A0 =A0 =A0tristate "Block hash tree support"
> + =A0 =A0 =A0 =A0select CRYPTO
> + =A0 =A0 =A0 =A0select CRYPTO_HASH
> + =A0 =A0 =A0 =A0---help---
> + =A0 =A0 =A0 =A0 =A0Include support for device-mapper devices to use=
 a block hash
> + =A0 =A0 =A0 =A0 =A0tree for managing data integrity checks in a sca=
lable way.
> +
> + =A0 =A0 =A0 =A0 =A0Targets that use this functionality should inclu=
de it
> + =A0 =A0 =A0 =A0 =A0automatically.
> +
> + =A0 =A0 =A0 =A0 =A0If unsure, say N.
> +
> +config DM_VERITY
> + =A0 =A0 =A0 =A0tristate "Verity target support"
> + =A0 =A0 =A0 =A0depends on BLK_DEV_DM
> + =A0 =A0 =A0 =A0select DM_BHT
> + =A0 =A0 =A0 =A0select CRYPTO
> + =A0 =A0 =A0 =A0select CRYPTO_HASH
> + =A0 =A0 =A0 =A0---help---
> + =A0 =A0 =A0 =A0 =A0This device-mapper target allows you to create a=
 device that
> + =A0 =A0 =A0 =A0 =A0transparently integrity checks the data on it. Y=
ou'll need to
> + =A0 =A0 =A0 =A0 =A0activate the digests you're going to use in the =
cryptoapi
> + =A0 =A0 =A0 =A0 =A0configuration.
> +
> + =A0 =A0 =A0 =A0 =A0To compile this code as a module, choose M here:=
 the module will
> + =A0 =A0 =A0 =A0 =A0be called dm-verity.
> +
> + =A0 =A0 =A0 =A0 =A0If unsure, say N.
> +
> =A0endif # MD
> diff --git a/drivers/md/Makefile b/drivers/md/Makefile
> index 448838b..58eb088 100644
> --- a/drivers/md/Makefile
> +++ b/drivers/md/Makefile
> @@ -36,6 +36,8 @@ obj-$(CONFIG_DM_MULTIPATH_ST) +=3D dm-service-time.=
o
> =A0obj-$(CONFIG_DM_SNAPSHOT) =A0 =A0 =A0+=3D dm-snapshot.o
> =A0obj-$(CONFIG_DM_MIRROR) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0+=3D dm-mir=
ror.o dm-log.o dm-region-hash.o
> =A0obj-$(CONFIG_DM_LOG_USERSPACE) +=3D dm-log-userspace.o
> +obj-$(CONFIG_DM_BHT) =A0 =A0 =A0 =A0 =A0 =A0+=3D dm-bht.o
> +obj-$(CONFIG_DM_VERITY) =A0 =A0 =A0 =A0 +=3D dm-verity.o
> =A0obj-$(CONFIG_DM_ZERO) =A0 =A0 =A0 =A0 =A0+=3D dm-zero.o
> =A0obj-$(CONFIG_DM_RAID) =A0+=3D dm-raid.o
>
> diff --git a/drivers/md/dm-bht.c b/drivers/md/dm-bht.c
> new file mode 100644
> index 0000000..32b8ccf
> --- /dev/null
> +++ b/drivers/md/dm-bht.c
> @@ -0,0 +1,541 @@
> + /*
> + * Copyright (C) 2011 The Chromium OS Authors <chromium-os-dev@chrom=
ium.org>
> + *
> + * Device-Mapper block hash tree interface.
> + * See Documentation/device-mapper/dm-bht.txt for details.
> + *
> + * This file is released under the GPLv2.
> + */
> +
> +#include <linux/atomic.h>
> +#include <linux/bitops.h>
> +#include <linux/bug.h>
> +#include <linux/cpumask.h>
> +#include <linux/device-mapper.h>
> +#include <linux/dm-bht.h>
> +#include <linux/err.h>
> +#include <linux/errno.h>
> +#include <linux/gfp.h>
> +#include <linux/kernel.h>
> +#include <linux/mm_types.h>
> +#include <linux/scatterlist.h>
> +#include <linux/slab.h>
> +#include <linux/string.h>
> +
> +#define DM_MSG_PREFIX "dm bht"
> +
> +
> +/*
> + * Utilities
> + */
> +
> +static u8 from_hex(u8 ch)
> +{
> + =A0 =A0 =A0 if ((ch >=3D '0') && (ch <=3D '9'))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ch - '0';
> + =A0 =A0 =A0 if ((ch >=3D 'a') && (ch <=3D 'f'))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ch - 'a' + 10;
> + =A0 =A0 =A0 if ((ch >=3D 'A') && (ch <=3D 'F'))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ch - 'A' + 10;
> + =A0 =A0 =A0 return -1;
> +}
> +
> +/**
> + * dm_bht_bin_to_hex - converts a binary stream to human-readable he=
x
> + * @binary: =A0 =A0a byte array of length @binary_len
> + * @hex: =A0 =A0 =A0 a byte array of length @binary_len * 2 + 1
> + */
> +static void dm_bht_bin_to_hex(u8 *binary, u8 *hex, unsigned int bina=
ry_len)
> +{
> + =A0 =A0 =A0 while (binary_len-- > 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sprintf((char *)hex, "%02hhx", (int)*bi=
nary);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 hex +=3D 2;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 binary++;
> + =A0 =A0 =A0 }
> +}
> +
> +/**
> + * dm_bht_hex_to_bin - converts a hex stream to binary
> + * @binary: =A0 =A0a byte array of length @binary_len
> + * @hex: =A0 =A0 =A0 a byte array of length @binary_len * 2 + 1
> + */
> +static void dm_bht_hex_to_bin(u8 *binary, const u8 *hex,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned in=
t binary_len)
> +{
> + =A0 =A0 =A0 while (binary_len-- > 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *binary =3D from_hex(*(hex++));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *binary *=3D 16;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *binary +=3D from_hex(*(hex++));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 binary++;
> + =A0 =A0 =A0 }
> +}
> +
> +static void dm_bht_log_mismatch(struct dm_bht *bht, u8 *given, u8 *c=
omputed)
> +{
> + =A0 =A0 =A0 u8 given_hex[DM_BHT_MAX_DIGEST_SIZE * 2 + 1];
> + =A0 =A0 =A0 u8 computed_hex[DM_BHT_MAX_DIGEST_SIZE * 2 + 1];
> +
> + =A0 =A0 =A0 dm_bht_bin_to_hex(given, given_hex, bht->digest_size);
> + =A0 =A0 =A0 dm_bht_bin_to_hex(computed, computed_hex, bht->digest_s=
ize);
> + =A0 =A0 =A0 DMERR_LIMIT("%s !=3D %s", given_hex, computed_hex);
> +}
> +
> +/**
> + * dm_bht_compute_hash: hashes a page of data
> + */
> +static int dm_bht_compute_hash(struct dm_bht *bht, struct page *pg,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned=
 int offset, u8 *digest)
> +{
> + =A0 =A0 =A0 struct hash_desc *hash_desc =3D &bht->hash_desc[smp_pro=
cessor_id()];
> + =A0 =A0 =A0 struct scatterlist sg;
> +
> + =A0 =A0 =A0 sg_init_table(&sg, 1);
> + =A0 =A0 =A0 sg_set_page(&sg, pg, bht->block_size, offset);
> + =A0 =A0 =A0 /* Note, this is synchronous. */
> + =A0 =A0 =A0 if (crypto_hash_init(hash_desc)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMCRIT("failed to reinitialize crypto h=
ash (proc:%d)",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 smp_processor_id());
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 if (crypto_hash_update(hash_desc, &sg, bht->block_size)=
) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMCRIT("crypto_hash_update failed");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 sg_set_buf(&sg, bht->salt, sizeof(bht->salt));
> + =A0 =A0 =A0 if (crypto_hash_update(hash_desc, &sg, sizeof(bht->salt=
))) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMCRIT("crypto_hash_update failed");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 if (crypto_hash_final(hash_desc, digest)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMCRIT("crypto_hash_final failed");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 return 0;
> +}
> +
> +/*
> + * Implementation functions
> + */
> +
> +static int dm_bht_initialize_entries(struct dm_bht *bht)
> +{
> + =A0 =A0 =A0 /* last represents the index of the last digest store i=
n the tree.
> + =A0 =A0 =A0 =A0* By walking the tree with that index, it is possibl=
e to compute the
> + =A0 =A0 =A0 =A0* total number of entries at each level.
> + =A0 =A0 =A0 =A0*
> + =A0 =A0 =A0 =A0* Since each entry will contain up to |node_count| n=
odes of the tree,
> + =A0 =A0 =A0 =A0* it is possible that the last index may not be at t=
he end of a given
> + =A0 =A0 =A0 =A0* entry->nodes. =A0In that case, it is assumed the v=
alue is padded.
> + =A0 =A0 =A0 =A0*
> + =A0 =A0 =A0 =A0* Note, we treat both the tree root (1 hash) and the=
 tree leaves
> + =A0 =A0 =A0 =A0* independently from the bht data structures. =A0Log=
ically, the root is
> + =A0 =A0 =A0 =A0* depth=3D-1 and the block layer level is depth=3Dbh=
t->depth
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 unsigned int last =3D bht->block_count;
> + =A0 =A0 =A0 int depth;
> +
> + =A0 =A0 =A0 /* check that the largest level->count can't result in =
an int overflow
> + =A0 =A0 =A0 =A0* on allocation or sector calculation.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 if (((last >> bht->node_count_shift) + 1) >
> + =A0 =A0 =A0 =A0 =A0 UINT_MAX / max((unsigned int)sizeof(struct dm_b=
ht_entry),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(unsigned int)to=
_sector(bht->block_size))) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMCRIT("required entries %u is too larg=
e", last + 1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /* Track the current sector location for each level so =
we don't have to
> + =A0 =A0 =A0 =A0* compute it during traversals.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 bht->sectors =3D 0;
> + =A0 =A0 =A0 for (depth =3D 0; depth < bht->depth; ++depth) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct dm_bht_level *level =3D &bht->le=
vels[depth];
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 level->count =3D dm_bht_index_at_level(=
bht, depth, last) + 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 level->entries =3D (struct dm_bht_entry=
 *)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0kcal=
loc(level->count,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0sizeof(struct dm_bht_entry),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0GFP_KERNEL);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!level->entries) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMERR("failed to alloca=
te entries for depth %d", depth);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 level->sector =3D bht->sectors;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 bht->sectors +=3D level->count * to_sec=
tor(bht->block_size);
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 return 0;
> +}
> +
> +/**
> + * dm_bht_create - prepares @bht for us
> + * @bht: =A0 =A0 =A0 pointer to a dm_bht_create()d bht
> + * @depth: =A0 =A0 tree depth without the root; including block hash=
es
> + * @block_count:the number of block hashes / tree leaves
> + * @alg_name: =A0crypto hash algorithm name
> + *
> + * Returns 0 on success.
> + *
> + * Callers can offset into devices by storing the data in the io cal=
lbacks.
> + */
> +int dm_bht_create(struct dm_bht *bht, unsigned int block_count,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int block_size, const char=
 *alg_name)
> +{
> + =A0 =A0 =A0 int cpu, status;
> +
> + =A0 =A0 =A0 bht->block_size =3D block_size;
> + =A0 =A0 =A0 /* Verify that PAGE_SIZE >=3D block_size >=3D SECTOR_SI=
ZE. */
> + =A0 =A0 =A0 if ((block_size > PAGE_SIZE) ||
> + =A0 =A0 =A0 =A0 =A0 (PAGE_SIZE % block_size) ||
> + =A0 =A0 =A0 =A0 =A0 (to_sector(block_size) =3D=3D 0))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
> +
> + =A0 =A0 =A0 /* Setup the hash first. Its length determines much of =
the bht layout */
> + =A0 =A0 =A0 for (cpu =3D 0; cpu < nr_cpu_ids; ++cpu) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 bht->hash_desc[cpu].tfm =3D crypto_allo=
c_hash(alg_name, 0, 0);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(bht->hash_desc[cpu].tfm)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMERR("failed to alloca=
te crypto hash '%s'", alg_name);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 status =3D -ENOMEM;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bht->hash_desc[cpu].tfm=
 =3D NULL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto bad_arg;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 bht->digest_size =3D crypto_hash_digestsize(bht->hash_d=
esc[0].tfm);
> + =A0 =A0 =A0 /* We expect to be able to pack >=3D2 hashes into a blo=
ck */
> + =A0 =A0 =A0 if (block_size / bht->digest_size < 2) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMERR("too few hashes fit in a block");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 status =3D -EINVAL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto bad_arg;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 if (bht->digest_size > DM_BHT_MAX_DIGEST_SIZE) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMERR("DM_BHT_MAX_DIGEST_SIZE too small=
 for chosen digest");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 status =3D -EINVAL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto bad_arg;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /* Configure the tree */
> + =A0 =A0 =A0 bht->block_count =3D block_count;
> + =A0 =A0 =A0 if (block_count =3D=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMERR("block_count must be non-zero");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 status =3D -EINVAL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto bad_arg;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /* Each dm_bht_entry->nodes is one block. =A0The node c=
ode tracks
> + =A0 =A0 =A0 =A0* how many nodes fit into one entry where a node is =
a single
> + =A0 =A0 =A0 =A0* hash (message digest).
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 bht->node_count_shift =3D fls(block_size / bht->digest_=
size) - 1;
> + =A0 =A0 =A0 /* Round down to the nearest power of two. =A0This make=
s indexing
> + =A0 =A0 =A0 =A0* into the tree much less painful.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 bht->node_count =3D 1 << bht->node_count_shift;
> +
> + =A0 =A0 =A0 /* This is unlikely to happen, but with 64k pages, who =
knows. */
> + =A0 =A0 =A0 if (bht->node_count > UINT_MAX / bht->digest_size) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMERR("node_count * hash_len exceeds UI=
NT_MAX!");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 status =3D -EINVAL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto bad_arg;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 bht->depth =3D DIV_ROUND_UP(fls(block_count - 1), bht->=
node_count_shift);
> +
> + =A0 =A0 =A0 /* Ensure that we can safely shift by this value. */
> + =A0 =A0 =A0 if (bht->depth * bht->node_count_shift >=3D sizeof(unsi=
gned int) * 8) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMERR("specified depth and node_count_s=
hift is too large");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 status =3D -EINVAL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto bad_arg;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /* Allocate levels. Each level of the tree may have an =
arbitrary number
> + =A0 =A0 =A0 =A0* of dm_bht_entry structs. =A0Each entry contains no=
de_count nodes.
> + =A0 =A0 =A0 =A0* Each node in the tree is a cryptographic digest of=
 either node_count
> + =A0 =A0 =A0 =A0* nodes on the subsequent level or of a specific blo=
ck on disk.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 bht->levels =3D (struct dm_bht_level *)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kcalloc(bht->depth,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(=
struct dm_bht_level), GFP_KERNEL);
> + =A0 =A0 =A0 if (!bht->levels) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMERR("failed to allocate tree levels")=
;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 status =3D -ENOMEM;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto bad_level_alloc;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 bht->read_cb =3D NULL;
> +
> + =A0 =A0 =A0 status =3D dm_bht_initialize_entries(bht);
> + =A0 =A0 =A0 if (status)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto bad_entries_alloc;
> +
> + =A0 =A0 =A0 /* We compute depth such that there is only be 1 block =
at level 0. */
> + =A0 =A0 =A0 BUG_ON(bht->levels[0].count !=3D 1);
> +
> + =A0 =A0 =A0 return 0;
> +
> +bad_entries_alloc:
> + =A0 =A0 =A0 while (bht->depth-- > 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(bht->levels[bht->depth].entries);
> + =A0 =A0 =A0 kfree(bht->levels);
> +bad_level_alloc:
> +bad_arg:
> + =A0 =A0 =A0 for (cpu =3D 0; cpu < nr_cpu_ids; ++cpu)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (bht->hash_desc[cpu].tfm)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 crypto_free_hash(bht->h=
ash_desc[cpu].tfm);
> + =A0 =A0 =A0 return status;
> +}
> +EXPORT_SYMBOL(dm_bht_create);
> +
> +/**
> + * dm_bht_read_completed
> + * @entry: =A0 =A0 pointer to the entry that's been loaded
> + * @status: =A0 =A0I/O status. Non-zero is failure.
> + * MUST always be called after a read_cb completes.
> + */
> +void dm_bht_read_completed(struct dm_bht_entry *entry, int status)
> +{
> + =A0 =A0 =A0 if (status) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* TODO(wad) add retry support */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMCRIT("an I/O error occurred while rea=
ding entry");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_set(&entry->state, DM_BHT_ENTRY_=
ERROR_IO);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* entry->nodes will be freed later */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 BUG_ON(atomic_read(&entry->state) !=3D DM_BHT_ENTRY_PEN=
DING);
> + =A0 =A0 =A0 atomic_set(&entry->state, DM_BHT_ENTRY_READY);
> +}
> +EXPORT_SYMBOL(dm_bht_read_completed);
> +
> +/**
> + * dm_bht_verify_block - checks that all nodes in the path for @bloc=
k are valid
> + * @bht: =A0 =A0 =A0 pointer to a dm_bht_create()d bht
> + * @block: =A0 =A0 specific block data is expected from
> + * @pg: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0page holding the block data
> + * @offset: =A0 =A0offset into the page
> + *
> + * Returns 0 on success, DM_BHT_ENTRY_ERROR_MISMATCH on error.
> + */
> +int dm_bht_verify_block(struct dm_bht *bht, unsigned int block,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct page *pg, unsign=
ed int offset)
> +{
> + =A0 =A0 =A0 int state, depth =3D bht->depth;
> + =A0 =A0 =A0 u8 digest[DM_BHT_MAX_DIGEST_SIZE];
> + =A0 =A0 =A0 struct dm_bht_entry *entry;
> + =A0 =A0 =A0 void *node;
> +
> + =A0 =A0 =A0 do {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Need to check that the hash of the c=
urrent block is accurate
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* in its parent.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 entry =3D dm_bht_get_entry(bht, depth -=
 1, block);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 state =3D atomic_read(&entry->state);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* This call is only safe if all nodes =
along the path
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* are already populated (i.e. READY)=
 via dm_bht_populate.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG_ON(state < DM_BHT_ENTRY_READY);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 node =3D dm_bht_get_node(bht, entry, de=
pth, block);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (dm_bht_compute_hash(bht, pg, offset=
, digest) ||
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcmp(digest, node, bht->diges=
t_size))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto mismatch;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Keep the containing block of hashes =
to be verified in the
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* next pass.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 pg =3D virt_to_page(entry->nodes);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 offset =3D offset_in_page(entry->nodes)=
;
> + =A0 =A0 =A0 } while (--depth > 0 && state !=3D DM_BHT_ENTRY_VERIFIE=
D);
> +
> + =A0 =A0 =A0 if (depth =3D=3D 0 && state !=3D DM_BHT_ENTRY_VERIFIED)=
 {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (dm_bht_compute_hash(bht, pg, offset=
, digest) ||
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcmp(digest, bht->root_digest=
, bht->digest_size))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto mismatch;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_set(&entry->state, DM_BHT_ENTRY_=
VERIFIED);
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /* Mark path to leaf as verified. */
> + =A0 =A0 =A0 for (depth++; depth < bht->depth; depth++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 entry =3D dm_bht_get_entry(bht, depth, =
block);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* At this point, entry can only be in =
VERIFIED or READY state.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* So it is safe to use atomic_set in=
stead of atomic_cmpxchg.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_set(&entry->state, DM_BHT_ENTRY_=
VERIFIED);
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 return 0;
> +
> +mismatch:
> + =A0 =A0 =A0 DMERR_LIMIT("verify_path: failed to verify hash (d=3D%d=
,bi=3D%u)",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 depth, block);
> + =A0 =A0 =A0 dm_bht_log_mismatch(bht, node, digest);
> + =A0 =A0 =A0 return DM_BHT_ENTRY_ERROR_MISMATCH;
> +}
> +EXPORT_SYMBOL(dm_bht_verify_block);
> +
> +/**
> + * dm_bht_is_populated - check that entries from disk needed to veri=
fy a given
> + * =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 block are all ready
> + * @bht: =A0 =A0 =A0 pointer to a dm_bht_create()d bht
> + * @block: =A0 =A0 specific block data is expected from
> + *
> + * Callers may wish to call dm_bht_is_populated() when checking an i=
o
> + * for which entries were already pending.
> + */
> +bool dm_bht_is_populated(struct dm_bht *bht, unsigned int block)
> +{
> + =A0 =A0 =A0 int depth;
> +
> + =A0 =A0 =A0 for (depth =3D bht->depth - 1; depth >=3D 0; depth--) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct dm_bht_entry *entry =3D dm_bht_g=
et_entry(bht, depth,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 block);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (atomic_read(&entry->state) < DM_BHT=
_ENTRY_READY)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return false;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 return true;
> +}
> +EXPORT_SYMBOL(dm_bht_is_populated);
> +
> +/**
> + * dm_bht_populate - reads entries from disk needed to verify a give=
n block
> + * @bht: =A0 =A0 =A0 pointer to a dm_bht_create()d bht
> + * @ctx: =A0 =A0 =A0 =A0context used for all read_cb calls on this r=
equest
> + * @block: =A0 =A0 specific block data is expected from
> + *
> + * Returns negative value on error. Returns 0 on success.
> + */
> +int dm_bht_populate(struct dm_bht *bht, void *ctx, unsigned int bloc=
k)
> +{
> + =A0 =A0 =A0 int depth, state;
> +
> + =A0 =A0 =A0 BUG_ON(block >=3D bht->block_count);
> +
> + =A0 =A0 =A0 for (depth =3D bht->depth - 1; depth >=3D 0; --depth) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int index =3D dm_bht_index_at_=
level(bht, depth, block);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct dm_bht_level *level =3D &bht->le=
vels[depth];
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct dm_bht_entry *entry =3D dm_bht_g=
et_entry(bht, depth,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 block);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 state =3D atomic_cmpxchg(&entry->state,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0DM_BHT_ENTRY_UNALLOCATED,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0DM_BHT_ENTRY_PENDING);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (state =3D=3D DM_BHT_ENTRY_VERIFIED)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (state <=3D DM_BHT_ENTRY_ERROR)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto error_state;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (state !=3D DM_BHT_ENTRY_UNALLOCATED=
)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Current entry is claimed for allocat=
ion and loading */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 entry->nodes =3D kmalloc(bht->block_siz=
e, GFP_NOIO);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!entry->nodes)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto nomem;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 bht->read_cb(ctx,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0level->secto=
r + to_sector(index * bht->block_size),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0entry->nodes=
, to_sector(bht->block_size), entry);
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 return 0;
> +
> +error_state:
> + =A0 =A0 =A0 DMCRIT("block %u at depth %d is in an error state", blo=
ck, depth);
> + =A0 =A0 =A0 return -EPERM;
> +
> +nomem:
> + =A0 =A0 =A0 DMCRIT("failed to allocate memory for entry->nodes");
> + =A0 =A0 =A0 return -ENOMEM;
> +}
> +EXPORT_SYMBOL(dm_bht_populate);
> +
> +/**
> + * dm_bht_destroy - cleans up all memory used by @bht
> + * @bht: =A0 =A0 =A0 pointer to a dm_bht_create()d bht
> + */
> +void dm_bht_destroy(struct dm_bht *bht)
> +{
> + =A0 =A0 =A0 int depth, cpu;
> +
> + =A0 =A0 =A0 for (depth =3D 0; depth < bht->depth; depth++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct dm_bht_entry *entry =3D bht->lev=
els[depth].entries;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct dm_bht_entry *entry_end =3D entr=
y +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0bht->levels[depth].count;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (; entry < entry_end; ++entry)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(entry->nodes);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(bht->levels[depth].entries);
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 kfree(bht->levels);
> + =A0 =A0 =A0 for (cpu =3D 0; cpu < nr_cpu_ids; ++cpu)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (bht->hash_desc[cpu].tfm)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 crypto_free_hash(bht->h=
ash_desc[cpu].tfm);
> +}
> +EXPORT_SYMBOL(dm_bht_destroy);
> +
> +/*
> + * Accessors
> + */
> +
> +/**
> + * dm_bht_set_root_hexdigest - sets an unverified root digest hash f=
rom hex
> + * @bht: =A0 =A0 =A0 pointer to a dm_bht_create()d bht
> + * @hexdigest: array of u8s containing the new digest in binary
> + * Returns non-zero on error. =A0hexdigest should be NUL terminated.
> + */
> +int dm_bht_set_root_hexdigest(struct dm_bht *bht, const u8 *hexdiges=
t)
> +{
> + =A0 =A0 =A0 /* Make sure we have at least the bytes expected */
> + =A0 =A0 =A0 if (strnlen((char *)hexdigest, bht->digest_size * 2) !=3D
> + =A0 =A0 =A0 =A0 =A0 bht->digest_size * 2) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMERR("root digest length does not matc=
h hash algorithm");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -1;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 dm_bht_hex_to_bin(bht->root_digest, hexdigest, bht->dig=
est_size);
> + =A0 =A0 =A0 return 0;
> +}
> +EXPORT_SYMBOL(dm_bht_set_root_hexdigest);
> +
> +/**
> + * dm_bht_root_hexdigest - returns root digest in hex
> + * @bht: =A0 =A0 =A0 pointer to a dm_bht_create()d bht
> + * @hexdigest: u8 array of size @available
> + * @available: must be bht->digest_size * 2 + 1
> + */
> +int dm_bht_root_hexdigest(struct dm_bht *bht, u8 *hexdigest, int ava=
ilable)
> +{
> + =A0 =A0 =A0 if (available < 0 ||
> + =A0 =A0 =A0 =A0 =A0 ((unsigned int) available) < bht->digest_size *=
 2 + 1) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMERR("hexdigest has too few bytes avai=
lable");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 dm_bht_bin_to_hex(bht->root_digest, hexdigest, bht->dig=
est_size);
> + =A0 =A0 =A0 return 0;
> +}
> +EXPORT_SYMBOL(dm_bht_root_hexdigest);
> +
> +/**
> + * dm_bht_set_salt - sets the salt used, in hex
> + * @bht: =A0 =A0 =A0pointer to a dm_bht_create()d bht
> + * @hexsalt: =A0salt string, as hex; will be zero-padded or truncate=
d to
> + * =A0 =A0 =A0 =A0 =A0 =A0DM_BHT_SALT_SIZE * 2 hex digits.
> + */
> +void dm_bht_set_salt(struct dm_bht *bht, const char *hexsalt)
> +{
> + =A0 =A0 =A0 size_t saltlen =3D min(strlen(hexsalt) / 2, sizeof(bht-=
>salt));
> +
> + =A0 =A0 =A0 memset(bht->salt, 0, sizeof(bht->salt));
> + =A0 =A0 =A0 dm_bht_hex_to_bin(bht->salt, (const u8 *)hexsalt, saltl=
en);
> +}
> +EXPORT_SYMBOL(dm_bht_set_salt);
> +
> +/**
> + * dm_bht_salt - returns the salt used, in hex
> + * @bht: =A0 =A0 =A0pointer to a dm_bht_create()d bht
> + * @hexsalt: =A0buffer to put salt into, of length DM_BHT_SALT_SIZE =
* 2 + 1.
> + */
> +int dm_bht_salt(struct dm_bht *bht, char *hexsalt)
> +{
> + =A0 =A0 =A0 dm_bht_bin_to_hex(bht->salt, (u8 *)hexsalt, sizeof(bht-=
>salt));
> + =A0 =A0 =A0 return 0;
> +}
> +EXPORT_SYMBOL(dm_bht_salt);
> +
> diff --git a/drivers/md/dm-verity.c b/drivers/md/dm-verity.c
> new file mode 100644
> index 0000000..a9bd0e8
> --- /dev/null
> +++ b/drivers/md/dm-verity.c
> @@ -0,0 +1,1043 @@
> +/*
> + * Originally based on dm-crypt.c,
> + * Copyright (C) 2003 Christophe Saout <christophe@saout.de>
> + * Copyright (C) 2004 Clemens Fruhwirth <clemens@endorphin.org>
> + * Copyright (C) 2006-2008 Red Hat, Inc. All rights reserved.
> + * Copyright (C) 2011 The Chromium OS Authors <chromium-os-dev@chrom=
ium.org>
> + * =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0All Rights Reserved.
> + *
> + * This file is released under the GPLv2.
> + *
> + * Implements a verifying transparent block device.
> + * See Documentation/device-mapper/dm-verity.txt
> + */
> +#include <linux/async.h>
> +#include <linux/atomic.h>
> +#include <linux/bio.h>
> +#include <linux/blkdev.h>
> +#include <linux/delay.h>
> +#include <linux/device.h>
> +#include <linux/err.h>
> +#include <linux/genhd.h>
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/mempool.h>
> +#include <linux/mm_types.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/workqueue.h>
> +#include <linux/device-mapper.h>
> +#include <linux/dm-bht.h>
> +
> +#include "dm-verity.h"
> +
> +#define DM_MSG_PREFIX "verity"
> +
> +/* Supports up to 512-bit digests */
> +#define VERITY_MAX_DIGEST_SIZE 64
> +
> +/* TODO(wad) make both of these report the error line/file to a
> + * =A0 =A0 =A0 =A0 =A0 verity_bug function.
> + */
> +#define VERITY_BUG(msg...) BUG()
> +#define VERITY_BUG_ON(cond, msg...) BUG_ON(cond)
> +
> +/* Helper for printing sector_t */
> +#define ULL(x) ((unsigned long long)(x))
> +
> +#define MIN_IOS 32
> +#define MIN_BIOS (MIN_IOS * 2)
> +#define VERITY_DEFAULT_BLOCK_SIZE 4096
> +
> +/* Provide a lightweight means of specifying the global default for
> + * error behavior: eio, reboot, or none
> + * Legacy support for 0 =3D eio, 1 =3D reboot/panic, 2 =3D none, 3 =3D=
 notify.
> + * This is matched to the enum in dm-verity.h.
> + */
> +static const char * const allowed_error_behaviors[] =3D { "eio", "pa=
nic", "none",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "notify", NULL };
> +static char *error_behavior =3D "eio";
> +module_param(error_behavior, charp, 0644);
> +MODULE_PARM_DESC(error_behavior, "Behavior on error "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"(ei=
o, panic, none, notify)");
> +
> +/* Controls whether verity_get_device will wait forever for a device=
=2E */
> +static int dev_wait;
> +module_param(dev_wait, bool, 0444);
> +MODULE_PARM_DESC(dev_wait, "Wait forever for a backing device");
> +
> +/* per-requested-bio private data */
> +enum verity_io_flags {
> + =A0 =A0 =A0 VERITY_IOFLAGS_CLONED =3D 0x1, =A0 =A0/* original bio h=
as been cloned */
> +};
> +
> +struct dm_verity_io {
> + =A0 =A0 =A0 struct dm_target *target;
> + =A0 =A0 =A0 struct bio *bio;
> + =A0 =A0 =A0 struct delayed_work work;
> + =A0 =A0 =A0 unsigned int flags;
> +
> + =A0 =A0 =A0 int error;
> + =A0 =A0 =A0 atomic_t pending;
> +
> + =A0 =A0 =A0 u64 block; =A0/* aligned block index */
> + =A0 =A0 =A0 u64 count; =A0/* aligned count in blocks */
> +};
> +
> +struct verity_config {
> + =A0 =A0 =A0 struct dm_dev *dev;
> + =A0 =A0 =A0 sector_t start;
> + =A0 =A0 =A0 sector_t size;
> +
> + =A0 =A0 =A0 struct dm_dev *hash_dev;
> + =A0 =A0 =A0 sector_t hash_start;
> +
> + =A0 =A0 =A0 struct dm_bht bht;
> +
> + =A0 =A0 =A0 /* Pool required for io contexts */
> + =A0 =A0 =A0 mempool_t *io_pool;
> + =A0 =A0 =A0 /* Pool and bios required for making sure that backing =
device reads are
> + =A0 =A0 =A0 =A0* in PAGE_SIZE increments.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 struct bio_set *bs;
> +
> + =A0 =A0 =A0 char hash_alg[CRYPTO_MAX_ALG_NAME];
> +
> + =A0 =A0 =A0 int error_behavior;
> +};
> +
> +static struct kmem_cache *_verity_io_pool;
> +static struct workqueue_struct *kveritydq, *kverityd_ioq;
> +
> +static void kverityd_verify(struct work_struct *work);
> +static void kverityd_io(struct work_struct *work);
> +static void kverityd_io_bht_populate(struct dm_verity_io *io);
> +static void kverityd_io_bht_populate_end(struct bio *, int error);
> +
> +static BLOCKING_NOTIFIER_HEAD(verity_error_notifier);
> +
> +/*
> + * Exported interfaces
> + */
> +
> +int dm_verity_register_error_notifier(struct notifier_block *nb)
> +{
> + =A0 =A0 =A0 return blocking_notifier_chain_register(&verity_error_n=
otifier, nb);
> +}
> +EXPORT_SYMBOL_GPL(dm_verity_register_error_notifier);
> +
> +int dm_verity_unregister_error_notifier(struct notifier_block *nb)
> +{
> + =A0 =A0 =A0 return blocking_notifier_chain_unregister(&verity_error=
_notifier, nb);
> +}
> +EXPORT_SYMBOL_GPL(dm_verity_unregister_error_notifier);
> +
> +/*
> + * Allocation and utility functions
> + */
> +
> +static void kverityd_src_io_read_end(struct bio *clone, int error);
> +
> +/* Shared destructor for all internal bios */
> +static void dm_verity_bio_destructor(struct bio *bio)
> +{
> + =A0 =A0 =A0 struct dm_verity_io *io =3D bio->bi_private;
> + =A0 =A0 =A0 struct verity_config *vc =3D io->target->private;
> + =A0 =A0 =A0 bio_free(bio, vc->bs);
> +}
> +
> +static struct bio *verity_alloc_bioset(struct verity_config *vc, gfp=
_t gfp_mask,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0int nr_iovecs)
> +{
> + =A0 =A0 =A0 return bio_alloc_bioset(gfp_mask, nr_iovecs, vc->bs);
> +}
> +
> +static struct dm_verity_io *verity_io_alloc(struct dm_target *ti,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 struct bio *bio)
> +{
> + =A0 =A0 =A0 struct verity_config *vc =3D ti->private;
> + =A0 =A0 =A0 sector_t sector =3D bio->bi_sector - ti->begin;
> + =A0 =A0 =A0 struct dm_verity_io *io;
> +
> + =A0 =A0 =A0 io =3D mempool_alloc(vc->io_pool, GFP_NOIO);
> + =A0 =A0 =A0 if (unlikely(!io))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return NULL;
> + =A0 =A0 =A0 io->flags =3D 0;
> + =A0 =A0 =A0 io->target =3D ti;
> + =A0 =A0 =A0 io->bio =3D bio;
> + =A0 =A0 =A0 io->error =3D 0;
> +
> + =A0 =A0 =A0 /* Adjust the sector by the virtual starting sector */
> + =A0 =A0 =A0 io->block =3D to_bytes(sector) / vc->bht.block_size;
> + =A0 =A0 =A0 io->count =3D bio->bi_size / vc->bht.block_size;
> +
> + =A0 =A0 =A0 atomic_set(&io->pending, 0);
> +
> + =A0 =A0 =A0 return io;
> +}
> +
> +static struct bio *verity_bio_clone(struct dm_verity_io *io)
> +{
> + =A0 =A0 =A0 struct verity_config *vc =3D io->target->private;
> + =A0 =A0 =A0 struct bio *bio =3D io->bio;
> + =A0 =A0 =A0 struct bio *clone =3D verity_alloc_bioset(vc, GFP_NOIO,=
 bio->bi_max_vecs);
> +
> + =A0 =A0 =A0 if (!clone)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return NULL;
> +
> + =A0 =A0 =A0 __bio_clone(clone, bio);
> + =A0 =A0 =A0 clone->bi_private =3D io;
> + =A0 =A0 =A0 clone->bi_end_io =A0=3D kverityd_src_io_read_end;
> + =A0 =A0 =A0 clone->bi_bdev =A0 =A0=3D vc->dev->bdev;
> + =A0 =A0 =A0 clone->bi_sector +=3D vc->start - io->target->begin;
> + =A0 =A0 =A0 clone->bi_destructor =3D dm_verity_bio_destructor;
> +
> + =A0 =A0 =A0 return clone;
> +}
> +
> +/* If the request is not successful, this handler takes action.
> + * TODO make this call a registered handler.
> + */
> +static void verity_error(struct verity_config *vc, struct dm_verity_=
io *io,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int error)
> +{
> + =A0 =A0 =A0 const char *message;
> + =A0 =A0 =A0 int error_mode =3D DM_VERITY_ERROR_BEHAVIOR_PANIC;
> + =A0 =A0 =A0 dev_t devt =3D 0;
> + =A0 =A0 =A0 u64 block =3D ~0;
> + =A0 =A0 =A0 int transient =3D 1;
> + =A0 =A0 =A0 struct dm_verity_error_state error_state;
> +
> + =A0 =A0 =A0 if (vc) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 devt =3D vc->dev->bdev->bd_dev;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 error_mode =3D vc->error_behavior;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 if (io) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 io->error =3D -EIO;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 block =3D io->block;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 switch (error) {
> + =A0 =A0 =A0 case -ENOMEM:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 message =3D "out of memory";
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 case -EBUSY:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 message =3D "pending data seen during v=
erify";
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 case -EFAULT:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 message =3D "crypto operation failure";
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 case -EACCES:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 message =3D "integrity failure";
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Image is bad. */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 transient =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 case -EPERM:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 message =3D "hash tree population failu=
re";
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Should be dm-bht specific errors */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 transient =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 case -EINVAL:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 message =3D "unexpected missing/invalid=
 data";
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* The device was configured incorrectl=
y - fallback. */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 transient =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 default:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Other errors can be passed through a=
s IO errors */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 message =3D "unknown or I/O error";
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 DMERR_LIMIT("verification failure occurred: %s", messag=
e);
> +
> + =A0 =A0 =A0 if (error_mode =3D=3D DM_VERITY_ERROR_BEHAVIOR_NOTIFY) =
{
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 error_state.code =3D error;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 error_state.transient =3D transient;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 error_state.block =3D block;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 error_state.message =3D message;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 error_state.dev_start =3D vc->start;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 error_state.dev_len =3D vc->size;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 error_state.dev =3D vc->dev->bdev;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 error_state.hash_dev_start =3D vc->hash=
_start;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 error_state.hash_dev_len =3D vc->bht.se=
ctors;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 error_state.hash_dev =3D vc->hash_dev->=
bdev;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Set default fallthrough behavior. */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 error_state.behavior =3D DM_VERITY_ERRO=
R_BEHAVIOR_PANIC;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 error_mode =3D DM_VERITY_ERROR_BEHAVIOR=
_PANIC;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!blocking_notifier_call_chain(
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &verity_error_notifier, transie=
nt, &error_state)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 error_mode =3D error_st=
ate.behavior;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 switch (error_mode) {
> + =A0 =A0 =A0 case DM_VERITY_ERROR_BEHAVIOR_EIO:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 case DM_VERITY_ERROR_BEHAVIOR_NONE:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (error !=3D -EIO && io)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 io->error =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 default:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto do_panic;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 return;
> +
> +do_panic:
> + =A0 =A0 =A0 panic("dm-verity failure: "
> + =A0 =A0 =A0 =A0 =A0 =A0 "device:%u:%u error:%d block:%llu message:%=
s",
> + =A0 =A0 =A0 =A0 =A0 =A0 MAJOR(devt), MINOR(devt), error, ULL(block)=
, message);
> +}
> +
> +/**
> + * verity_parse_error_behavior - parse a behavior charp to the enum
> + * @behavior: =A0NUL-terminated char array
> + *
> + * Checks if the behavior is valid either as text or as an index dig=
it
> + * and returns the proper enum value or -1 on error.
> + */
> +static int verity_parse_error_behavior(const char *behavior)
> +{
> + =A0 =A0 =A0 const char * const *allowed =3D allowed_error_behaviors=
;
> + =A0 =A0 =A0 char index =3D '0';
> +
> + =A0 =A0 =A0 for (; *allowed; allowed++, index++)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!strcmp(*allowed, behavior) || beha=
vior[0] =3D=3D index)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> +
> + =A0 =A0 =A0 if (!*allowed)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -1;
> +
> + =A0 =A0 =A0 /* Convert to the integer index matching the enum. */
> + =A0 =A0 =A0 return allowed - allowed_error_behaviors;
> +}
> +
> +/*
> + * Reverse flow of requests into the device.
> + *
> + * (Start at the bottom with verity_map and work your way upward).
> + */
> +
> +static void verity_inc_pending(struct dm_verity_io *io);
> +
> +static void verity_return_bio_to_caller(struct dm_verity_io *io)
> +{
> + =A0 =A0 =A0 struct verity_config *vc =3D io->target->private;
> +
> + =A0 =A0 =A0 if (io->error)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 verity_error(vc, io, io->error);
> +
> + =A0 =A0 =A0 bio_endio(io->bio, io->error);
> + =A0 =A0 =A0 mempool_free(io, vc->io_pool);
> +}
> +
> +/* Check for any missing bht hashes. */
> +static bool verity_is_bht_populated(struct dm_verity_io *io)
> +{
> + =A0 =A0 =A0 struct verity_config *vc =3D io->target->private;
> + =A0 =A0 =A0 u64 block;
> +
> + =A0 =A0 =A0 for (block =3D io->block; block < io->block + io->count=
; ++block)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!dm_bht_is_populated(&vc->bht, bloc=
k))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return false;
> +
> + =A0 =A0 =A0 return true;
> +}
> +
> +/* verity_dec_pending manages the lifetime of all dm_verity_io struc=
ts.
> + * Non-bug error handling is centralized through this interface and
> + * all passage from workqueue to workqueue.
> + */
> +static void verity_dec_pending(struct dm_verity_io *io)
> +{
> + =A0 =A0 =A0 if (!atomic_dec_and_test(&io->pending))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto done;
> +
> + =A0 =A0 =A0 if (unlikely(io->error))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto io_error;
> +
> + =A0 =A0 =A0 /* I/Os that were pending may now be ready */
> + =A0 =A0 =A0 if (verity_is_bht_populated(io)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 INIT_DELAYED_WORK(&io->work, kverityd_v=
erify);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 queue_delayed_work(kveritydq, &io->work=
, 0);
> + =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 INIT_DELAYED_WORK(&io->work, kverityd_i=
o);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 queue_delayed_work(kverityd_ioq, &io->w=
ork, HZ/10);
> + =A0 =A0 =A0 }
> +
> +done:
> + =A0 =A0 =A0 return;
> +
> +io_error:
> + =A0 =A0 =A0 verity_return_bio_to_caller(io);
> +}
> +
> +/* Walks the data set and computes the hash of the data read from th=
e
> + * untrusted source device. =A0The computed hash is then passed to d=
m-bht
> + * for verification.
> + */
> +static int verity_verify(struct verity_config *vc,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct dm_verity_io =
*io)
> +{
> + =A0 =A0 =A0 unsigned int block_size =3D vc->bht.block_size;
> + =A0 =A0 =A0 struct bio *bio =3D io->bio;
> + =A0 =A0 =A0 u64 block =3D io->block;
> + =A0 =A0 =A0 unsigned int idx;
> + =A0 =A0 =A0 int r;
> +
> + =A0 =A0 =A0 for (idx =3D bio->bi_idx; idx < bio->bi_vcnt; idx++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct bio_vec *bv =3D bio_iovec_idx(bi=
o, idx);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int offset =3D bv->bv_offset;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int len =3D bv->bv_len;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 VERITY_BUG_ON(offset % block_size);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 VERITY_BUG_ON(len % block_size);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 while (len) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 r =3D dm_bht_verify_blo=
ck(&vc->bht, block,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 bv->bv_page, offset);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (r)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ba=
d_return;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 offset +=3D block_size;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 len -=3D block_size;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 block++;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cond_resched();
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 return 0;
> +
> +bad_return:
> + =A0 =A0 =A0 /* dm_bht functions aren't expected to return errno fri=
endly
> + =A0 =A0 =A0 =A0* values. =A0They are converted here for uniformity.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 if (r > 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMERR("Pending data for block %llu seen=
 at verify", ULL(block));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 r =3D -EBUSY;
> + =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMERR_LIMIT("Block hash does not match!=
");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 r =3D -EACCES;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 return r;
> +}
> +
> +/* Services the verify workqueue */
> +static void kverityd_verify(struct work_struct *work)
> +{
> + =A0 =A0 =A0 struct delayed_work *dwork =3D container_of(work, struc=
t delayed_work,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 work);
> + =A0 =A0 =A0 struct dm_verity_io *io =3D container_of(dwork, struct =
dm_verity_io,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0work);
> + =A0 =A0 =A0 struct verity_config *vc =3D io->target->private;
> +
> + =A0 =A0 =A0 io->error =3D verity_verify(vc, io);
> +
> + =A0 =A0 =A0 /* Free up the bio and tag with the return value */
> + =A0 =A0 =A0 verity_return_bio_to_caller(io);
> +}
> +
> +/* Asynchronously called upon the completion of dm-bht I/O. =A0The s=
tatus
> + * of the operation is passed back to dm-bht and the next steps are
> + * decided by verity_dec_pending.
> + */
> +static void kverityd_io_bht_populate_end(struct bio *bio, int error)
> +{
> + =A0 =A0 =A0 struct dm_bht_entry *entry =3D (struct dm_bht_entry *) =
bio->bi_private;
> + =A0 =A0 =A0 struct dm_verity_io *io =3D (struct dm_verity_io *) ent=
ry->io_context;
> +
> + =A0 =A0 =A0 /* Tell the tree to atomically update now that we've po=
pulated
> + =A0 =A0 =A0 =A0* the given entry.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 dm_bht_read_completed(entry, error);
> +
> + =A0 =A0 =A0 /* Clean up for reuse when reading data to be checked *=
/
> + =A0 =A0 =A0 bio->bi_vcnt =3D 0;
> + =A0 =A0 =A0 bio->bi_io_vec->bv_offset =3D 0;
> + =A0 =A0 =A0 bio->bi_io_vec->bv_len =3D 0;
> + =A0 =A0 =A0 bio->bi_io_vec->bv_page =3D NULL;
> + =A0 =A0 =A0 /* Restore the private data to I/O so the destructor ca=
n be shared. */
> + =A0 =A0 =A0 bio->bi_private =3D (void *) io;
> + =A0 =A0 =A0 bio_put(bio);
> +
> + =A0 =A0 =A0 /* We bail but assume the tree has been marked bad. */
> + =A0 =A0 =A0 if (unlikely(error)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMERR("Failed to read for sector %llu (=
%u)",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ULL(io->bio->bi_sector), io=
->bio->bi_size);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 io->error =3D error;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Pass through the error to verity_dec=
_pending below */
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 /* When pending =3D 0, it will transition to reading re=
al data */
> + =A0 =A0 =A0 verity_dec_pending(io);
> +}
> +
> +/* Called by dm-bht (via dm_bht_populate), this function provides
> + * the message digests to dm-bht that are stored on disk.
> + */
> +static int kverityd_bht_read_callback(void *ctx, sector_t start, u8 =
*dst,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 sector_t count,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 struct dm_bht_entry *entry)
> +{
> + =A0 =A0 =A0 struct dm_verity_io *io =3D ctx; =A0/* I/O for this bat=
ch */
> + =A0 =A0 =A0 struct verity_config *vc;
> + =A0 =A0 =A0 struct bio *bio;
> +
> + =A0 =A0 =A0 vc =3D io->target->private;
> +
> + =A0 =A0 =A0 /* The I/O context is nested inside the entry so that w=
e don't need one
> + =A0 =A0 =A0 =A0* io context per page read.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 entry->io_context =3D ctx;
> +
> + =A0 =A0 =A0 /* We should only get page size requests at present. */
> + =A0 =A0 =A0 verity_inc_pending(io);
> + =A0 =A0 =A0 bio =3D verity_alloc_bioset(vc, GFP_NOIO, 1);
> + =A0 =A0 =A0 if (unlikely(!bio)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMCRIT("Out of memory at bio_alloc_bios=
et");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dm_bht_read_completed(entry, -ENOMEM);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 bio->bi_private =3D (void *) entry;
> + =A0 =A0 =A0 bio->bi_idx =3D 0;
> + =A0 =A0 =A0 bio->bi_size =3D vc->bht.block_size;
> + =A0 =A0 =A0 bio->bi_sector =3D vc->hash_start + start;
> + =A0 =A0 =A0 bio->bi_bdev =3D vc->hash_dev->bdev;
> + =A0 =A0 =A0 bio->bi_end_io =3D kverityd_io_bht_populate_end;
> + =A0 =A0 =A0 bio->bi_rw =3D REQ_META;
> + =A0 =A0 =A0 /* Only need to free the bio since the page is managed =
by bht */
> + =A0 =A0 =A0 bio->bi_destructor =3D dm_verity_bio_destructor;
> + =A0 =A0 =A0 bio->bi_vcnt =3D 1;
> + =A0 =A0 =A0 bio->bi_io_vec->bv_offset =3D offset_in_page(dst);
> + =A0 =A0 =A0 bio->bi_io_vec->bv_len =3D to_bytes(count);
> + =A0 =A0 =A0 /* dst is guaranteed to be a page_pool allocation */
> + =A0 =A0 =A0 bio->bi_io_vec->bv_page =3D virt_to_page(dst);
> + =A0 =A0 =A0 /* Track that this I/O is in use. =A0There should be no=
 risk of the io
> + =A0 =A0 =A0 =A0* being removed prior since this is called synchrono=
usly.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 generic_make_request(bio);
> + =A0 =A0 =A0 return 0;
> +}
> +
> +/* Submits an io request for each missing block of block hashes.
> + * The last one to return will then enqueue this on the io workqueue=
=2E
> + */
> +static void kverityd_io_bht_populate(struct dm_verity_io *io)
> +{
> + =A0 =A0 =A0 struct verity_config *vc =3D io->target->private;
> + =A0 =A0 =A0 u64 block;
> +
> + =A0 =A0 =A0 for (block =3D io->block; block < io->block + io->count=
; ++block) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 int ret =3D dm_bht_populate(&vc->bht, i=
o, block);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret < 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* verity_dec_pending w=
ill handle the error case. */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 io->error =3D ret;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> +}
> +
> +/* Asynchronously called upon the completion of I/O issued
> + * from kverityd_src_io_read. verity_dec_pending() acts as
> + * the scheduler/flow manager.
> + */
> +static void kverityd_src_io_read_end(struct bio *clone, int error)
> +{
> + =A0 =A0 =A0 struct dm_verity_io *io =3D clone->bi_private;
> +
> + =A0 =A0 =A0 if (unlikely(!bio_flagged(clone, BIO_UPTODATE) && !erro=
r))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 error =3D -EIO;
> +
> + =A0 =A0 =A0 if (unlikely(error)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMERR("Error occurred: %d (%llu, %u)",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 error, ULL(clone->bi_se=
ctor), clone->bi_size);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 io->error =3D error;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /* Release the clone which just avoids the block layer =
from
> + =A0 =A0 =A0 =A0* leaving offsets, etc in unexpected states.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 bio_put(clone);
> +
> + =A0 =A0 =A0 verity_dec_pending(io);
> +}
> +
> +/* If not yet underway, an I/O request will be issued to the vc->dev
> + * device for the data needed. It is cloned to avoid unexpected chan=
ges
> + * to the original bio struct.
> + */
> +static void kverityd_src_io_read(struct dm_verity_io *io)
> +{
> + =A0 =A0 =A0 struct bio *clone;
> +
> + =A0 =A0 =A0 /* Check if the read is already issued. */
> + =A0 =A0 =A0 if (io->flags & VERITY_IOFLAGS_CLONED)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> +
> + =A0 =A0 =A0 io->flags |=3D VERITY_IOFLAGS_CLONED;
> +
> + =A0 =A0 =A0 /* Clone the bio. The block layer may modify the bvec a=
rray. */
> + =A0 =A0 =A0 clone =3D verity_bio_clone(io);
> + =A0 =A0 =A0 if (unlikely(!clone)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 io->error =3D -ENOMEM;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 verity_inc_pending(io);
> +
> + =A0 =A0 =A0 generic_make_request(clone);
> +}
> +
> +/* kverityd_io services the I/O workqueue. For each pass through
> + * the I/O workqueue, a call to populate both the origin drive
> + * data and the hash tree data is made.
> + */
> +static void kverityd_io(struct work_struct *work)
> +{
> + =A0 =A0 =A0 struct delayed_work *dwork =3D container_of(work, struc=
t delayed_work,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 work);
> + =A0 =A0 =A0 struct dm_verity_io *io =3D container_of(dwork, struct =
dm_verity_io,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0work);
> +
> + =A0 =A0 =A0 /* Issue requests asynchronously. */
> + =A0 =A0 =A0 verity_inc_pending(io);
> + =A0 =A0 =A0 kverityd_src_io_read(io);
> + =A0 =A0 =A0 kverityd_io_bht_populate(io);
> + =A0 =A0 =A0 verity_dec_pending(io);
> +}
> +
> +/* Paired with verity_dec_pending, the pending value in the io dicta=
te the
> + * lifetime of a request and when it is ready to be processed on the
> + * workqueues.
> + */
> +static void verity_inc_pending(struct dm_verity_io *io)
> +{
> + =A0 =A0 =A0 atomic_inc(&io->pending);
> +}
> +
> +/* Block-level requests start here. */
> +static int verity_map(struct dm_target *ti, struct bio *bio,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 union map_info *map_context=
)
> +{
> + =A0 =A0 =A0 struct dm_verity_io *io;
> + =A0 =A0 =A0 struct verity_config *vc;
> + =A0 =A0 =A0 struct request_queue *r_queue;
> +
> + =A0 =A0 =A0 if (unlikely(!ti)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMERR("dm_target was NULL");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EIO;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 vc =3D ti->private;
> + =A0 =A0 =A0 r_queue =3D bdev_get_queue(vc->dev->bdev);
> +
> + =A0 =A0 =A0 if (bio_data_dir(bio) =3D=3D WRITE) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* If we silently drop writes, then the=
 VFS layer will cache
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* the write and persist it in memory=
=2E While it doesn't change
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* the underlying storage, it still m=
ay be contrary to the
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* behavior expected by a verified, r=
ead-only device.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMWARN_LIMIT("write request received. r=
ejecting with -EIO.");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 verity_error(vc, NULL, -EIO);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EIO;
> + =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Queue up the request to be verified =
*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 io =3D verity_io_alloc(ti, bio);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!io) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMERR_LIMIT("Failed to =
allocate and init IO data");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return DM_MAPIO_REQUEUE=
;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 INIT_DELAYED_WORK(&io->work, kverityd_i=
o);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 queue_delayed_work(kverityd_ioq, &io->w=
ork, 0);
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 return DM_MAPIO_SUBMITTED;
> +}
> +
> +static void splitarg(char *arg, char **key, char **val)
> +{
> + =A0 =A0 =A0 *key =3D strsep(&arg, "=3D");
> + =A0 =A0 =A0 *val =3D strsep(&arg, "");
> +}
> +
> +/*
> + * Non-block interfaces and device-mapper specific code
> + */
> +
> +/**
> + * verity_ctr - Construct a verified mapping
> + * @ti: =A0 Target being created
> + * @argc: Number of elements in argv
> + * @argv: Vector of key-value pairs (see below).
> + *
> + * Accepts the following keys:
> + * @payload: =A0 =A0 =A0 =A0hashed device
> + * @hashtree: =A0 =A0 =A0 device hashtree is stored on
> + * @hashstart: =A0 =A0 =A0start address of hashes (default 0)
> + * @block_size: =A0 =A0 size of a hash block
> + * @alg: =A0 =A0 =A0 =A0 =A0 =A0hash algorithm
> + * @root_hexdigest: toplevel hash of the tree
> + * @error_behavior: what to do when verification fails [optional]
> + * @salt: =A0 =A0 =A0 =A0 =A0 salt, in hex [optional]
> + *
> + * E.g.,
> + * payload=3D/dev/sda2 hashtree=3D/dev/sda3 alg=3Dsha256
> + * root_hexdigest=3Df08aa4a3695290c569eb1b0ac032ae1040150afb527abbeb=
0a3da33d82fb2c6e
> + *
> + * TODO(wad):
> + * - Boot time addition
> + * - Track block verification to free block_hashes if memory use is =
a concern
> + * Testing needed:
> + * - Regular slub_debug tracing (on checkins)
> + * - Improper block hash padding
> + * - Improper bundle padding
> + * - Improper hash layout
> + * - Missing padding at end of device
> + * - Improperly sized underlying devices
> + * - Out of memory conditions (make sure this isn't too flaky under =
high load!)
> + * - Incorrect superhash
> + * - Incorrect block hashes
> + * - Incorrect bundle hashes
> + * - Boot-up read speed; sustained read speeds
> + */
> +static int verity_ctr(struct dm_target *ti, unsigned int argc, char =
**argv)
> +{
> + =A0 =A0 =A0 struct verity_config *vc =3D NULL;
> + =A0 =A0 =A0 int ret =3D 0;
> + =A0 =A0 =A0 sector_t blocks;
> + =A0 =A0 =A0 unsigned int block_size =3D VERITY_DEFAULT_BLOCK_SIZE;
> + =A0 =A0 =A0 const char *payload =3D NULL;
> + =A0 =A0 =A0 const char *hashtree =3D NULL;
> + =A0 =A0 =A0 unsigned long hashstart =3D 0;
> + =A0 =A0 =A0 const char *alg =3D NULL;
> + =A0 =A0 =A0 const char *root_hexdigest =3D NULL;
> + =A0 =A0 =A0 const char *dev_error_behavior =3D error_behavior;
> + =A0 =A0 =A0 const char *hexsalt =3D "";
> + =A0 =A0 =A0 int i;
> +
> + =A0 =A0 =A0 for (i =3D 0; i < argc; ++i) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 char *key, *val;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMWARN("Argument %d: '%s'", i, argv[i])=
;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 splitarg(argv[i], &key, &val);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!key) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMWARN("Bad argument %d=
: missing key?", i);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!val) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMWARN("Bad argument %d=
=3D'%s': missing value", i, key);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!strcmp(key, "alg")) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 alg =3D val;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (!strcmp(key, "payload")) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 payload =3D val;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (!strcmp(key, "hashtree")) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 hashtree =3D val;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (!strcmp(key, "root_hexdigest=
")) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 root_hexdigest =3D val;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (!strcmp(key, "hashstart")) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (strict_strtoul(val,=
 10, &hashstart)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ti->err=
or =3D "Invalid hashstart";
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
-EINVAL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (!strcmp(key, "block_size")) =
{
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned long tmp;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (strict_strtoul(val,=
 10, &tmp) ||
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (tmp > UINT_MAX=
)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ti->err=
or =3D "Invalid block_size";
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
-EINVAL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 block_size =3D (unsigne=
d int)tmp;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (!strcmp(key, "error_behavior=
")) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_error_behavior =3D =
val;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (!strcmp(key, "salt")) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 hexsalt =3D val;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (!strcmp(key, "error_behavior=
")) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_error_behavior =3D =
val;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> +
> +#define NEEDARG(n) \
> + =A0 =A0 =A0 if (!(n)) { \
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ti->error =3D "Missing argument: " #n; =
\
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL; \
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 NEEDARG(alg);
> + =A0 =A0 =A0 NEEDARG(payload);
> + =A0 =A0 =A0 NEEDARG(hashtree);
> + =A0 =A0 =A0 NEEDARG(root_hexdigest);
> +
> +#undef NEEDARG
> +
> + =A0 =A0 =A0 /* The device mapper device should be setup read-only *=
/
> + =A0 =A0 =A0 if ((dm_table_get_mode(ti->table) & ~FMODE_READ) !=3D 0=
) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ti->error =3D "Must be created readonly=
=2E";
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 vc =3D kzalloc(sizeof(*vc), GFP_KERNEL);
> + =A0 =A0 =A0 if (!vc) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* TODO(wad) if this is called from the=
 setup helper, then we
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* catch these errors and do a CrOS s=
pecific thing. if not, we
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* need to have this call the error h=
andler.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /* Calculate the blocks from the given device size */
> + =A0 =A0 =A0 vc->size =3D ti->len;
> + =A0 =A0 =A0 blocks =3D to_bytes(vc->size) / block_size;
> + =A0 =A0 =A0 if (dm_bht_create(&vc->bht, blocks, block_size, alg)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMERR("failed to create required bht");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto bad_bht;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 if (dm_bht_set_root_hexdigest(&vc->bht, root_hexdigest)=
) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMERR("root hexdigest error");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto bad_root_hexdigest;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 dm_bht_set_salt(&vc->bht, hexsalt);
> + =A0 =A0 =A0 vc->bht.read_cb =3D kverityd_bht_read_callback;
> +
> + =A0 =A0 =A0 /* payload: device to verify */
> + =A0 =A0 =A0 vc->start =3D 0; =A0/* TODO: should this support a star=
ting offset? */
> + =A0 =A0 =A0 /* We only ever grab the device in read-only mode. */
> + =A0 =A0 =A0 ret =3D dm_get_device(ti, payload,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dm_table_get_mo=
de(ti->table), &vc->dev);
> + =A0 =A0 =A0 if (ret) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMERR("Failed to acquire device '%s': %=
d", payload, ret);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ti->error =3D "Device lookup failed";
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto bad_verity_dev;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 if ((to_bytes(vc->start) % block_size) ||
> + =A0 =A0 =A0 =A0 =A0 (to_bytes(vc->size) % block_size)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ti->error =3D "Device must be block_siz=
e divisble/aligned";
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto bad_hash_start;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 vc->hash_start =3D (sector_t)hashstart;
> +
> + =A0 =A0 =A0 /* hashtree: device with hashes.
> + =A0 =A0 =A0 =A0* Note, payload =3D=3D hashtree is okay as long as t=
he size of
> + =A0 =A0 =A0 =A0* =A0 =A0 =A0 ti->len passed to device mapper does n=
ot include
> + =A0 =A0 =A0 =A0* =A0 =A0 =A0 the hashes.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 if (dm_get_device(ti, hashtree,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dm_table_get_mode(t=
i->table), &vc->hash_dev)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ti->error =3D "Hash device lookup faile=
d";
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto bad_hash_dev;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /* arg4: cryptographic digest algorithm */
> + =A0 =A0 =A0 if (snprintf(vc->hash_alg, CRYPTO_MAX_ALG_NAME, "%s", a=
lg) >=3D
> + =A0 =A0 =A0 =A0 =A0 CRYPTO_MAX_ALG_NAME) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ti->error =3D "Hash algorithm name is t=
oo long";
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto bad_hash;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /* override with optional device-specific error behavio=
r */
> + =A0 =A0 =A0 vc->error_behavior =3D verity_parse_error_behavior(dev_=
error_behavior);
> + =A0 =A0 =A0 if (vc->error_behavior =3D=3D -1) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ti->error =3D "Bad error_behavior suppl=
ied";
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto bad_err_behavior;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /* TODO: Maybe issues a request on the io queue for blo=
ck 0? */
> +
> + =A0 =A0 =A0 /* Argument processing is done, setup operational data =
*/
> + =A0 =A0 =A0 /* Pool for dm_verity_io objects */
> + =A0 =A0 =A0 vc->io_pool =3D mempool_create_slab_pool(MIN_IOS, _veri=
ty_io_pool);
> + =A0 =A0 =A0 if (!vc->io_pool) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ti->error =3D "Cannot allocate verity i=
o mempool";
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto bad_slab_pool;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /* Allocate the bioset used for request padding */
> + =A0 =A0 =A0 /* TODO(wad) allocate a separate bioset for the first v=
erify maybe */
> + =A0 =A0 =A0 vc->bs =3D bioset_create(MIN_BIOS, 0);
> + =A0 =A0 =A0 if (!vc->bs) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ti->error =3D "Cannot allocate verity b=
ioset";
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto bad_bs;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 ti->num_flush_requests =3D 1;
> + =A0 =A0 =A0 ti->private =3D vc;
> +
> + =A0 =A0 =A0 /* TODO(wad) add device and hash device names */
> + =A0 =A0 =A0 {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 char hashdev[BDEVNAME_SIZE], vdev[BDEVN=
AME_SIZE];
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 bdevname(vc->hash_dev->bdev, hashdev);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 bdevname(vc->dev->bdev, vdev);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMINFO("dev:%s hash:%s [sectors:%llu bl=
ocks:%llu]", vdev,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0hashdev, ULL(vc->bht.sec=
tors), ULL(blocks));
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 return 0;
> +
> +bad_bs:
> + =A0 =A0 =A0 mempool_destroy(vc->io_pool);
> +bad_slab_pool:
> +bad_err_behavior:
> +bad_hash:
> + =A0 =A0 =A0 dm_put_device(ti, vc->hash_dev);
> +bad_hash_dev:
> +bad_hash_start:
> + =A0 =A0 =A0 dm_put_device(ti, vc->dev);
> +bad_bht:
> +bad_root_hexdigest:
> +bad_verity_dev:
> + =A0 =A0 =A0 kfree(vc); =A0 /* hash is not secret so no need to zero=
 */
> + =A0 =A0 =A0 return -EINVAL;
> +}
> +
> +static void verity_dtr(struct dm_target *ti)
> +{
> + =A0 =A0 =A0 struct verity_config *vc =3D (struct verity_config *) t=
i->private;
> +
> + =A0 =A0 =A0 bioset_free(vc->bs);
> + =A0 =A0 =A0 mempool_destroy(vc->io_pool);
> + =A0 =A0 =A0 dm_bht_destroy(&vc->bht);
> + =A0 =A0 =A0 dm_put_device(ti, vc->hash_dev);
> + =A0 =A0 =A0 dm_put_device(ti, vc->dev);
> + =A0 =A0 =A0 kfree(vc);
> +}
> +
> +static int verity_status(struct dm_target *ti, status_type_t type,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 char *result, unsigned =
int maxlen)
> +{
> + =A0 =A0 =A0 struct verity_config *vc =3D (struct verity_config *) t=
i->private;
> + =A0 =A0 =A0 unsigned int sz =3D 0;
> + =A0 =A0 =A0 char hashdev[BDEVNAME_SIZE], vdev[BDEVNAME_SIZE];
> + =A0 =A0 =A0 u8 hexdigest[VERITY_MAX_DIGEST_SIZE * 2 + 1] =3D { 0 };
> +
> + =A0 =A0 =A0 dm_bht_root_hexdigest(&vc->bht, hexdigest, sizeof(hexdi=
gest));
> +
> + =A0 =A0 =A0 switch (type) {
> + =A0 =A0 =A0 case STATUSTYPE_INFO:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 case STATUSTYPE_TABLE:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 bdevname(vc->hash_dev->bdev, hashdev);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 bdevname(vc->dev->bdev, vdev);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMEMIT("/dev/%s /dev/%s %llu %u %s %s",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vdev,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 hashdev,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ULL(vc->hash_start),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vc->bht.depth,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vc->hash_alg,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 hexdigest);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 return 0;
> +}
> +
> +static int verity_merge(struct dm_target *ti, struct bvec_merge_data=
 *bvm,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct bio_vec *biovec, =
int max_size)
> +{
> + =A0 =A0 =A0 struct verity_config *vc =3D ti->private;
> + =A0 =A0 =A0 struct request_queue *q =3D bdev_get_queue(vc->dev->bde=
v);
> +
> + =A0 =A0 =A0 if (!q->merge_bvec_fn)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return max_size;
> +
> + =A0 =A0 =A0 bvm->bi_bdev =3D vc->dev->bdev;
> + =A0 =A0 =A0 bvm->bi_sector =3D vc->start + bvm->bi_sector - ti->beg=
in;
> +
> + =A0 =A0 =A0 /* Optionally, this could just return 0 to stick to sin=
gle pages. */
> + =A0 =A0 =A0 return min(max_size, q->merge_bvec_fn(q, bvm, biovec));
> +}
> +
> +static int verity_iterate_devices(struct dm_target *ti,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0iter=
ate_devices_callout_fn fn, void *data)
> +{
> + =A0 =A0 =A0 struct verity_config *vc =3D ti->private;
> +
> + =A0 =A0 =A0 return fn(ti, vc->dev, vc->start, ti->len, data);
> +}
> +
> +static void verity_io_hints(struct dm_target *ti,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct queue_li=
mits *limits)
> +{
> + =A0 =A0 =A0 struct verity_config *vc =3D ti->private;
> + =A0 =A0 =A0 unsigned int block_size =3D vc->bht.block_size;
> +
> + =A0 =A0 =A0 limits->logical_block_size =3D block_size;
> + =A0 =A0 =A0 limits->physical_block_size =3D block_size;
> + =A0 =A0 =A0 blk_limits_io_min(limits, block_size);
> +}
> +
> +static struct target_type verity_target =3D {
> + =A0 =A0 =A0 .name =A0 =3D "verity",
> + =A0 =A0 =A0 .version =3D {0, 1, 0},
> + =A0 =A0 =A0 .module =3D THIS_MODULE,
> + =A0 =A0 =A0 .ctr =A0 =A0=3D verity_ctr,
> + =A0 =A0 =A0 .dtr =A0 =A0=3D verity_dtr,
> + =A0 =A0 =A0 .map =A0 =A0=3D verity_map,
> + =A0 =A0 =A0 .merge =A0=3D verity_merge,
> + =A0 =A0 =A0 .status =3D verity_status,
> + =A0 =A0 =A0 .iterate_devices =3D verity_iterate_devices,
> + =A0 =A0 =A0 .io_hints =3D verity_io_hints,
> +};
> +
> +#define VERITY_WQ_FLAGS (WQ_CPU_INTENSIVE|WQ_HIGHPRI)
> +
> +static int __init dm_verity_init(void)
> +{
> + =A0 =A0 =A0 int r =3D -ENOMEM;
> +
> + =A0 =A0 =A0 _verity_io_pool =3D KMEM_CACHE(dm_verity_io, 0);
> + =A0 =A0 =A0 if (!_verity_io_pool) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMERR("failed to allocate pool dm_verit=
y_io");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto bad_io_pool;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 kverityd_ioq =3D alloc_workqueue("kverityd_io", VERITY_=
WQ_FLAGS, 1);
> + =A0 =A0 =A0 if (!kverityd_ioq) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMERR("failed to create workqueue kveri=
tyd_ioq");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto bad_io_queue;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 kveritydq =3D alloc_workqueue("kverityd", VERITY_WQ_FLA=
GS, 1);
> + =A0 =A0 =A0 if (!kveritydq) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMERR("failed to create workqueue kveri=
tydq");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto bad_verify_queue;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 r =3D dm_register_target(&verity_target);
> + =A0 =A0 =A0 if (r < 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMERR("register failed %d", r);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto register_failed;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 DMINFO("version %u.%u.%u loaded", verity_target.version=
[0],
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0verity_target.version[1], verity_target.=
version[2]);
> +
> + =A0 =A0 =A0 return r;
> +
> +register_failed:
> + =A0 =A0 =A0 destroy_workqueue(kveritydq);
> +bad_verify_queue:
> + =A0 =A0 =A0 destroy_workqueue(kverityd_ioq);
> +bad_io_queue:
> + =A0 =A0 =A0 kmem_cache_destroy(_verity_io_pool);
> +bad_io_pool:
> + =A0 =A0 =A0 return r;
> +}
> +
> +static void __exit dm_verity_exit(void)
> +{
> + =A0 =A0 =A0 destroy_workqueue(kveritydq);
> + =A0 =A0 =A0 destroy_workqueue(kverityd_ioq);
> +
> + =A0 =A0 =A0 dm_unregister_target(&verity_target);
> + =A0 =A0 =A0 kmem_cache_destroy(_verity_io_pool);
> +}
> +
> +module_init(dm_verity_init);
> +module_exit(dm_verity_exit);
> +
> +MODULE_AUTHOR("The Chromium OS Authors <chromium-os-dev@chromium.org=
>");
> +MODULE_DESCRIPTION(DM_NAME " target for transparent disk integrity c=
hecking");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/md/dm-verity.h b/drivers/md/dm-verity.h
> new file mode 100644
> index 0000000..e0664c9
> --- /dev/null
> +++ b/drivers/md/dm-verity.h
> @@ -0,0 +1,45 @@
> +/*
> + * Copyright (C) 2011 The Chromium OS Authors <chromium-os-dev@chrom=
ium.org>
> + * =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0All Rights Reserved.
> + *
> + * This file is released under the GPLv2.
> + *
> + * Provide error types for use when creating a custom error handler.
> + * See Documentation/device-mapper/dm-verity.txt
> + */
> +#ifndef DM_VERITY_H
> +#define DM_VERITY_H
> +
> +#include <linux/notifier.h>
> +
> +struct dm_verity_error_state {
> + =A0 =A0 =A0 int code;
> + =A0 =A0 =A0 int transient; =A0/* Likely to not happen after a reboo=
t */
> + =A0 =A0 =A0 u64 block;
> + =A0 =A0 =A0 const char *message;
> +
> + =A0 =A0 =A0 sector_t dev_start;
> + =A0 =A0 =A0 sector_t dev_len;
> + =A0 =A0 =A0 struct block_device *dev;
> +
> + =A0 =A0 =A0 sector_t hash_dev_start;
> + =A0 =A0 =A0 sector_t hash_dev_len;
> + =A0 =A0 =A0 struct block_device *hash_dev;
> +
> + =A0 =A0 =A0 /* Final behavior after all notifications are completed=
=2E */
> + =A0 =A0 =A0 int behavior;
> +};
> +
> +/* This enum must be matched to allowed_error_behaviors in dm-verity=
=2Ec */
> +enum dm_verity_error_behavior {
> + =A0 =A0 =A0 DM_VERITY_ERROR_BEHAVIOR_EIO =3D 0,
> + =A0 =A0 =A0 DM_VERITY_ERROR_BEHAVIOR_PANIC,
> + =A0 =A0 =A0 DM_VERITY_ERROR_BEHAVIOR_NONE,
> + =A0 =A0 =A0 DM_VERITY_ERROR_BEHAVIOR_NOTIFY
> +};
> +
> +
> +int dm_verity_register_error_notifier(struct notifier_block *nb);
> +int dm_verity_unregister_error_notifier(struct notifier_block *nb);
> +
> +#endif =A0/* DM_VERITY_H */
> diff --git a/include/linux/dm-bht.h b/include/linux/dm-bht.h
> new file mode 100644
> index 0000000..0595911
> --- /dev/null
> +++ b/include/linux/dm-bht.h
> @@ -0,0 +1,166 @@
> +/*
> + * Copyright (C) 2011 The Chromium OS Authors <chromium-os-dev@chrom=
ium.org>
> + *
> + * Device-Mapper block hash tree interface.
> + * See Documentation/device-mapper/dm-bht.txt for details.
> + *
> + * This file is released under the GPLv2.
> + */
> +#ifndef __LINUX_DM_BHT_H
> +#define __LINUX_DM_BHT_H
> +
> +#include <linux/compiler.h>
> +#include <linux/crypto.h>
> +#include <linux/types.h>
> +
> +/* To avoid allocating memory for digest tests, we just setup a
> + * max to use for now.
> + */
> +#define DM_BHT_MAX_DIGEST_SIZE 128 =A0/* 1k hashes are unlikely for =
now */
> +#define DM_BHT_SALT_SIZE =A0 =A0 =A0 32 =A0 /* 256 bits of salt is a=
 lot */
> +
> +/* UNALLOCATED, PENDING, READY, and VERIFIED are valid states. All o=
ther
> + * values are entry-related return codes.
> + */
> +#define DM_BHT_ENTRY_VERIFIED 8 =A0/* 'nodes' has been checked again=
st parent */
> +#define DM_BHT_ENTRY_READY 4 =A0/* 'nodes' is loaded and available *=
/
> +#define DM_BHT_ENTRY_PENDING 2 =A0/* 'nodes' is being loaded */
> +#define DM_BHT_ENTRY_UNALLOCATED 0 /* untouched */
> +#define DM_BHT_ENTRY_ERROR -1 /* entry is unsuitable for use */
> +#define DM_BHT_ENTRY_ERROR_IO -2 /* I/O error on load */
> +
> +/* Additional possible return codes */
> +#define DM_BHT_ENTRY_ERROR_MISMATCH -3 /* Digest mismatch */
> +
> +/* dm_bht_entry
> + * Contains dm_bht->node_count tree nodes at a given tree depth.
> + * state is used to transactionally assure that data is paged in
> + * from disk. =A0Unless dm_bht kept running crypto contexts for each
> + * level, we need to load in the data for on-demand verification.
> + */
> +struct dm_bht_entry {
> + =A0 =A0 =A0 atomic_t state; /* see defines */
> + =A0 =A0 =A0 /* Keeping an extra pointer per entry wastes up to ~33k=
 of
> + =A0 =A0 =A0 =A0* memory if a 1m blocks are used (or 66 on 64-bit ar=
ch)
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 void *io_context; =A0/* Reserve a pointer for use durin=
g io */
> + =A0 =A0 =A0 /* data should only be non-NULL if fully populated. */
> + =A0 =A0 =A0 void *nodes; =A0/* The hash data used to verify the chi=
ldren.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Guaranteed to be page-=
aligned.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> +};
> +
> +/* dm_bht_level
> + * Contains an array of entries which represent a page of hashes whe=
re
> + * each hash is a node in the tree at the given tree depth/level.
> + */
> +struct dm_bht_level {
> + =A0 =A0 =A0 struct dm_bht_entry *entries; =A0/* array of entries of=
 tree nodes */
> + =A0 =A0 =A0 unsigned int count; =A0/* number of entries at this lev=
el */
> + =A0 =A0 =A0 sector_t sector; =A0/* starting sector for this level *=
/
> +};
> +
> +/* opaque context, start, databuf, sector_count */
> +typedef int(*dm_bht_callback)(void *, =A0/* external context */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sector_t, =A0=
/* start sector */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 u8 *, =A0/*=
 destination page */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sector_t, =A0=
/* num sectors */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct dm_b=
ht_entry *);
> +/* dm_bht - Device mapper block hash tree
> + * dm_bht provides a fixed interface for comparing data blocks
> + * against a cryptographic hashes stored in a hash tree. It
> + * optimizes the tree structure for storage on disk.
> + *
> + * The tree is built from the bottom up. =A0A collection of data,
> + * external to the tree, is hashed and these hashes are stored
> + * as the blocks in the tree. =A0For some number of these hashes,
> + * a parent node is created by hashing them. =A0These steps are
> + * repeated.
> + *
> + * TODO(wad): All hash storage memory is pre-allocated and freed onc=
e an
> + * entire branch has been verified.
> + */
> +struct dm_bht {
> + =A0 =A0 =A0 /* Configured values */
> + =A0 =A0 =A0 int depth; =A0/* Depth of the tree including the root *=
/
> + =A0 =A0 =A0 unsigned int block_count; =A0/* Number of blocks hashed=
 */
> + =A0 =A0 =A0 unsigned int block_size; =A0/* Size of a hash block */
> + =A0 =A0 =A0 char hash_alg[CRYPTO_MAX_ALG_NAME];
> + =A0 =A0 =A0 unsigned char salt[DM_BHT_SALT_SIZE];
> +
> + =A0 =A0 =A0 /* Computed values */
> + =A0 =A0 =A0 unsigned int node_count; =A0/* Data size (in hashes) fo=
r each entry */
> + =A0 =A0 =A0 unsigned int node_count_shift; =A0/* first bit set - 1 =
*/
> + =A0 =A0 =A0 /* There is one per CPU so that verified can be simulta=
neous. */
> + =A0 =A0 =A0 struct hash_desc hash_desc[NR_CPUS]; =A0/* Container fo=
r the hash alg */
> + =A0 =A0 =A0 unsigned int digest_size;
> + =A0 =A0 =A0 sector_t sectors; =A0/* Number of disk sectors used */
> +
> + =A0 =A0 =A0 /* bool verified; =A0Full tree is verified */
> + =A0 =A0 =A0 u8 root_digest[DM_BHT_MAX_DIGEST_SIZE];
> + =A0 =A0 =A0 struct dm_bht_level *levels; =A0/* in reverse order */
> + =A0 =A0 =A0 /* Callback for reading from the hash device */
> + =A0 =A0 =A0 dm_bht_callback read_cb;
> +};
> +
> +/* Constructor for struct dm_bht instances. */
> +int dm_bht_create(struct dm_bht *bht,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int block_count,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int block_size,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const char *alg_name);
> +/* Destructor for struct dm_bht instances. =A0Does not free @bht */
> +void dm_bht_destroy(struct dm_bht *bht);
> +
> +/* Basic accessors for struct dm_bht */
> +int dm_bht_set_root_hexdigest(struct dm_bht *bht, const u8 *hexdiges=
t);
> +int dm_bht_root_hexdigest(struct dm_bht *bht, u8 *hexdigest, int ava=
ilable);
> +void dm_bht_set_salt(struct dm_bht *bht, const char *hexsalt);
> +int dm_bht_salt(struct dm_bht *bht, char *hexsalt);
> +
> +/* Functions for loading in data from disk for verification */
> +bool dm_bht_is_populated(struct dm_bht *bht, unsigned int block);
> +int dm_bht_populate(struct dm_bht *bht, void *read_cb_ctx,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int block);
> +int dm_bht_verify_block(struct dm_bht *bht, unsigned int block,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct page *pg, unsign=
ed int offset);
> +void dm_bht_read_completed(struct dm_bht_entry *entry, int status);
> +
> +/* Functions for converting indices to nodes. */
> +
> +static inline unsigned int dm_bht_get_level_shift(struct dm_bht *bht=
,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int depth)
> +{
> + =A0 =A0 =A0 return (bht->depth - depth) * bht->node_count_shift;
> +}
> +
> +/* For the given depth, this is the entry index. =A0At depth+1 it is=
 the node
> + * index for depth.
> + */
> +static inline unsigned int dm_bht_index_at_level(struct dm_bht *bht,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int depth,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int leaf)
> +{
> + =A0 =A0 =A0 return leaf >> dm_bht_get_level_shift(bht, depth);
> +}
> +
> +static inline struct dm_bht_entry *dm_bht_get_entry(struct dm_bht *b=
ht,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int depth,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int block)
> +{
> + =A0 =A0 =A0 unsigned int index =3D dm_bht_index_at_level(bht, depth=
, block);
> + =A0 =A0 =A0 struct dm_bht_level *level =3D &bht->levels[depth];
> +
> + =A0 =A0 =A0 return &level->entries[index];
> +}
> +
> +static inline void *dm_bht_get_node(struct dm_bht *bht,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 str=
uct dm_bht_entry *entry,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int=
 depth,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 uns=
igned int block)
> +{
> + =A0 =A0 =A0 unsigned int index =3D dm_bht_index_at_level(bht, depth=
, block);
> + =A0 =A0 =A0 unsigned int node_index =3D index % bht->node_count;
> +
> + =A0 =A0 =A0 return entry->nodes + (node_index * bht->digest_size);
> +}
> +#endif =A0/* __LINUX_DM_BHT_H */
> --
> 1.7.3.1
>
>
