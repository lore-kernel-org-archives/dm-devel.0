From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH 2/4] kpartx: read devices with direct IO
Date: Thu, 2 Jul 2020 15:00:37 +0000
Message-ID: <14f1d07b336e2939ddcf9fb87be763c4a42f061d.camel@suse.com>
References: <1593643176-6206-1-git-send-email-bmarzins@redhat.com>
	<1593643176-6206-3-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1593643176-6206-3-git-send-email-bmarzins@redhat.com>
Content-Language: en-US
Content-ID: <CBC0FE3F5C911547A9F0367573ECD0F1@eurprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "bmarzins@redhat.com" <bmarzins@redhat.com>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, 2020-07-01 at 17:39 -0500, Benjamin Marzinski wrote:
> If kpartx is used on top of shared storage, and a device has its
> partition table changed on one machine, and then kpartx is run on
> another, it may not see the new data, because the cache still
> contains
> the old data, and there is nothing to tell the machine running kpartx
> to
> invalidate it. To solve this, kpartx should read the devices using
> direct io.
>=20
> One issue with how this code has been updated is that the original
> code
> for getblock() always read 1024 bytes. The new code reads a logical
> sector size chunk of the device, and returns a pointer to the 512
> byte
> sector that the caller asked for, within that (possibly larger)
> chunk.
> This means that if the logical sector size is 512, then the code is
> now
> only reading 512 bytes.  Looking through the code for the various
> partition types, I can't see a case where more than 512 bytes is
> needed
> and getblock() is used.  If anyone has a reason why this code should
> be
> reading 1024 bytes at minmum, I can certainly change this.  But when
> I
> looked, I couldn't find a case where reading 512 bytes would cause a
> problem.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

The value 1024 comes from first partx in util-linux, where Christophe=20
pulled the first kpartx from:=20
http://ftp.be.debian.org/pub/linux/utils/util-linux/v2.10/util-linux-2.10m.=
tar.gz=20
I, too, see no reason for reading more than a single block.

Two nits below. Here's one more, I'd have preferred two separate
patches for these two different issues. But never mind.

Regards,
Martin

> ---
>  kpartx/dasd.c   |  7 ++++---
>  kpartx/gpt.c    | 22 ++++++++++------------
>  kpartx/kpartx.c | 46 +++++++++++++++++++++++++++++++++++-----------
>  kpartx/kpartx.h |  2 ++
>  4 files changed, 51 insertions(+), 26 deletions(-)
>=20
> diff --git a/kpartx/dasd.c b/kpartx/dasd.c
> index 14b9d3aa..f0398645 100644
> --- a/kpartx/dasd.c
> +++ b/kpartx/dasd.c
> @@ -22,6 +22,7 @@
>   * along with this program.  If not, see <
> http://www.gnu.org/licenses/>;.
>   */
> =20
> +#define _GNU_SOURCE
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <unistd.h>
> @@ -117,13 +118,13 @@ read_dasd_pt(int fd, __attribute__((unused))
> struct slice all,
> =20
>  =09=09sprintf(pathname, "/dev/.kpartx-node-%u-%u",
>  =09=09=09(unsigned int)major(dev), (unsigned
> int)minor(dev));
> -=09=09if ((fd_dasd =3D open(pathname, O_RDONLY)) =3D=3D -1) {
> +=09=09if ((fd_dasd =3D open(pathname, O_RDONLY | O_DIRECT)) =3D=3D
> -1) {
>  =09=09=09/* Devicenode does not exist. Try to create one
> */
>  =09=09=09if (mknod(pathname, 0600 | S_IFBLK, dev) =3D=3D -1)
> {
>  =09=09=09=09/* Couldn't create a device node */
>  =09=09=09=09return -1;
>  =09=09=09}
> -=09=09=09fd_dasd =3D open(pathname, O_RDONLY);
> +=09=09=09fd_dasd =3D open(pathname, O_RDONLY | O_DIRECT);
>  =09=09=09/*
>  =09=09=09 * The file will vanish when the last process
> (we)
>  =09=09=09 * has ceased to access it.
> @@ -175,7 +176,7 @@ read_dasd_pt(int fd, __attribute__((unused))
> struct slice all,
>  =09 * Get volume label, extract name and type.
>  =09 */
> =20
> -=09if (!(data =3D (unsigned char *)malloc(blocksize)))
> +=09if (aligned_malloc((void **)&data, blocksize, NULL))
>  =09=09goto out;
> =20
> =20
> diff --git a/kpartx/gpt.c b/kpartx/gpt.c
> index 785b34ea..f7fefb70 100644
> --- a/kpartx/gpt.c
> +++ b/kpartx/gpt.c
> @@ -243,8 +243,7 @@ alloc_read_gpt_entries(int fd, gpt_header * gpt)
> =20
>  =09if (!count) return NULL;
> =20
> -=09pte =3D (gpt_entry *)malloc(count);
> -=09if (!pte)
> +=09if (aligned_malloc((void **)&pte, get_sector_size(fd), &count))
>  =09=09return NULL;
>  =09memset(pte, 0, count);
> =20
> @@ -269,12 +268,11 @@ static gpt_header *
>  alloc_read_gpt_header(int fd, uint64_t lba)
>  {
>  =09gpt_header *gpt;
> -=09gpt =3D (gpt_header *)
> -=09    malloc(sizeof (gpt_header));
> -=09if (!gpt)
> +=09size_t size =3D sizeof (gpt_header);
> +=09if (aligned_malloc((void **)&gpt, get_sector_size(fd), &size))
>  =09=09return NULL;
> -=09memset(gpt, 0, sizeof (*gpt));
> -=09if (!read_lba(fd, lba, gpt, sizeof (gpt_header))) {
> +=09memset(gpt, 0, size);
> +=09if (!read_lba(fd, lba, gpt, size)) {
>  =09=09free(gpt);
>  =09=09return NULL;
>  =09}
> @@ -498,6 +496,7 @@ find_valid_gpt(int fd, gpt_header ** gpt,
> gpt_entry ** ptes)
>  =09gpt_header *pgpt =3D NULL, *agpt =3D NULL;
>  =09gpt_entry *pptes =3D NULL, *aptes =3D NULL;
>  =09legacy_mbr *legacymbr =3D NULL;
> +=09size_t size =3D sizeof(legacy_mbr);
>  =09uint64_t lastlba;
>  =09if (!gpt || !ptes)
>  =09=09return 0;
> @@ -526,11 +525,10 @@ find_valid_gpt(int fd, gpt_header ** gpt,
> gpt_entry ** ptes)
>  =09}
> =20
>  =09/* This will be added to the EFI Spec. per Intel after v1.02.
> */
> -=09legacymbr =3D malloc(sizeof (*legacymbr));
> -=09if (legacymbr) {
> -=09=09memset(legacymbr, 0, sizeof (*legacymbr));
> -=09=09read_lba(fd, 0, (uint8_t *) legacymbr,
> -=09=09=09 sizeof (*legacymbr));
> +=09if (aligned_malloc((void **)&legacymbr, get_sector_size(fd),
> +=09=09=09   &size) =3D=3D 0) {
> +=09=09memset(legacymbr, 0, size);
> +=09=09read_lba(fd, 0, (uint8_t *) legacymbr, size);
>  =09=09good_pmbr =3D is_pmbr_valid(legacymbr);
>  =09=09free(legacymbr);
>  =09=09legacymbr=3DNULL;
> diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
> index d3620c5c..4716dd4d 100644
> --- a/kpartx/kpartx.c
> +++ b/kpartx/kpartx.c
> @@ -19,6 +19,7 @@
>   * cva, 2002-10-26
>   */
> =20
> +#define _GNU_SOURCE
>  #include <stdio.h>
>  #include <fcntl.h>
>  #include <errno.h>
> @@ -41,7 +42,6 @@
> =20
>  #define SIZE(a) (sizeof(a)/sizeof((a)[0]))
> =20
> -#define READ_SIZE=091024
>  #define MAXTYPES=0964
>  #define MAXSLICES=09256
>  #define DM_TARGET=09"linear"
> @@ -388,7 +388,7 @@ main(int argc, char **argv){
>  =09=09set_delimiter(mapname, delim);
>  =09}
> =20
> -=09fd =3D open(device, O_RDONLY);
> +=09fd =3D open(device, O_RDONLY | O_DIRECT);
> =20
>  =09if (fd =3D=3D -1) {
>  =09=09perror(device);
> @@ -690,9 +690,9 @@ xmalloc (size_t size) {
>   */
> =20
>  static int
> -sseek(int fd, unsigned int secnr) {
> +sseek(int fd, unsigned int secnr, int secsz) {
>  =09off64_t in, out;
> -=09in =3D ((off64_t) secnr << 9);
> +=09in =3D ((off64_t) secnr * secsz);
>  =09out =3D 1;
> =20
>  =09if ((out =3D lseek64(fd, in, SEEK_SET)) !=3D in)
> @@ -703,6 +703,21 @@ sseek(int fd, unsigned int secnr) {
>  =09return 0;
>  }
> =20
> +int
> +aligned_malloc(void **mem_p, size_t align, size_t *size_p)
> +{
> +=09size_t pgsize =3D getpagesize();

Nit: I'd use a static variable here and call getpagesize() only once.

> +=09size_t size =3D pgsize;
> +=09if (!mem_p || !align || (size_p && !*size_p))
> +=09=09return EINVAL;
> +
> +=09if (size_p)
> +=09=09*size_p =3D size =3D ((*size_p + align - 1) / align) *
> align;

It would be cleaner to set *size_p only after successful return from
posix_memalign().

> +
> +=09return posix_memalign(mem_p, pgsize, size);
> +}




> +
> +/* always in sector size blocks */
>  static
>  struct block {
>  =09unsigned int secnr;
> @@ -710,30 +725,39 @@ struct block {
>  =09struct block *next;
>  } *blockhead;
> =20
> +/* blknr is always in 512 byte blocks */
>  char *
> -getblock (int fd, unsigned int secnr) {
> +getblock (int fd, unsigned int blknr) {
> +=09unsigned int secsz =3D get_sector_size(fd);
> +=09unsigned int blks_per_sec =3D secsz / 512;
> +=09unsigned int secnr =3D blknr / blks_per_sec;
> +=09unsigned int blk_off =3D (blknr % blks_per_sec) * 512;
>  =09struct block *bp;
> =20
>  =09for (bp =3D blockhead; bp; bp =3D bp->next)
> =20
>  =09=09if (bp->secnr =3D=3D secnr)
> -=09=09=09return bp->block;
> +=09=09=09return bp->block + blk_off;
> =20
> -=09if (sseek(fd, secnr))
> +=09if (sseek(fd, secnr, secsz))
>  =09=09return NULL;
> =20
>  =09bp =3D xmalloc(sizeof(struct block));
>  =09bp->secnr =3D secnr;
>  =09bp->next =3D blockhead;
>  =09blockhead =3D bp;
> -=09bp->block =3D (char *) xmalloc(READ_SIZE);
> +=09if (aligned_malloc((void **)&bp->block, secsz, NULL)) {
> +=09=09fprintf(stderr, "aligned_malloc failed\n");
> +=09=09exit(1);
> +=09}
> =20
> -=09if (read(fd, bp->block, READ_SIZE) !=3D READ_SIZE) {
> +=09if (read(fd, bp->block, secsz) !=3D secsz) {
>  =09=09fprintf(stderr, "read error, sector %d\n", secnr);
> -=09=09bp->block =3D NULL;
> +=09=09blockhead =3D bp->next;
> +=09=09return NULL;
>  =09}
> =20
> -=09return bp->block;
> +=09return bp->block + blk_off;
>  }
> =20
>  int
> diff --git a/kpartx/kpartx.h b/kpartx/kpartx.h
> index 67edeb82..727632c1 100644
> --- a/kpartx/kpartx.h
> +++ b/kpartx/kpartx.h
> @@ -1,6 +1,7 @@
>  #ifndef _KPARTX_H
>  #define _KPARTX_H
> =20
> +#include <stddef.h>
>  #include <stdint.h>
>  #include <sys/ioctl.h>
> =20
> @@ -61,6 +62,7 @@ extern ptreader read_mac_pt;
>  extern ptreader read_sun_pt;
>  extern ptreader read_ps3_pt;
> =20
> +int aligned_malloc(void **mem_p, size_t align, size_t *size_p);
>  char *getblock(int fd, unsigned int secnr);
> =20
>  static inline unsigned int

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer
