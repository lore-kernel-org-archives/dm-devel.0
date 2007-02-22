From: Piet Delaney <piet@bluelane.com>
Subject: Re: [dm-devel] [PATCH] device-mapper: Bad Block
	relocation target
Date: Thu, 22 Feb 2007 15:27:51 -0800
Message-ID: <1172186872.8709.114.camel@piet2.bluelane.com>
References: <20070210010159.835207B409F@zog.reactivated.net>
Reply-To: piet@bluelane.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0777968439=="
Return-path: <evms-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20070210010159.835207B409F@zog.reactivated.net>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/evms-devel>,
	<mailto:evms-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=evms-devel>
List-Post: <mailto:evms-devel@lists.sourceforge.net>
List-Help: <mailto:evms-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/evms-devel>,
	<mailto:evms-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: evms-devel-bounces@lists.sourceforge.net
Errors-To: evms-devel-bounces@lists.sourceforge.net
To: device-mapper development <dm-devel@redhat.com>, Daniel Drake <dsd@gentoo.org>
Cc: akpm@osdl.org, evms-devel@lists.sourceforge.net, Piet Delaney <piet@bluelane.com>
List-Id: dm-devel.ids


--===============0777968439==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-PnQz2yWWpwT5Oqrnad+/"


--=-PnQz2yWWpwT5Oqrnad+/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-02-10 at 01:01 +0000, Daniel Drake wrote:

Nice patch Daniel, wondering about using it in 2.6.12.=20

You code is very nicely commented, a feature I personally
find more important than the redundant brackets on one line
'if' statements. Over in Germany some of our best kernel programmers
considered the extra braces a cleaner coding style. I continue to
share that point of view. Feels like my eyes can parse the code a bit
faster. One of the very few things I like about Larry Wall's Perl
language it the required brackets on if statements.

If I was to add this to our dm components I was wondering how I'd
test it. No idea on how to get the hardware BBR replacement sectors
to be used up.=20

I'll look around for the EVMS tar ball you mentioned.

Thanks for the nicely documented code. I'll re-read it this evening.

-piet


> The BBR target is designed to remap I/O write failures to another safe
> location on disk. Note that most disk drives have BBR built into them,
> this means that our software BBR will be only activated when all hardware
> BBR replacement sectors have been used.
>=20
> This patch is included in the EVMS tarball, and Gentoo have been shipping
> it as part of the default kernel for a long time. I know that some users
> are running it, and haven't seen any reported bugs in a long time.
>=20
> Please consider this for -mm and possible later inclusion in mainline.
>=20
> I haven't been involved in the development of this target, but have brush=
ed
> it up a little from the one included in the EVMS tarball.
>=20
> Kevin, I see from mailing list archives that you were somehow involved in
> this project. Can you clarify who the main developers were so that we can
> include this in the history if it gets merged?
>=20
> Signed-off-by: Daniel Drake <dsd@gentoo.org>
>=20
> Index: linux-2.6.20-git4/drivers/md/Kconfig
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.20-git4.orig/drivers/md/Kconfig
> +++ linux-2.6.20-git4/drivers/md/Kconfig
> @@ -262,6 +262,17 @@ config DM_MULTIPATH_EMC
>  	---help---
>  	  Multipath support for EMC CX/AX series hardware.
> =20
> +config BLK_DEV_DM_BBR
> +	tristate "Bad Block Relocation Device Target (EXPERIMENTAL)"
> +	depends on BLK_DEV_DM && EXPERIMENTAL
> +	---help---
> +	  Support for devices with software-based bad-block-relocation.
> +
> +	  To compile this as a module, choose M here: the module will be
> +	  called dm-bbr.
> +
> +	  If unsure, say N.
> +
>  endmenu
> =20
>  endif
> Index: linux-2.6.20-git4/drivers/md/Makefile
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.20-git4.orig/drivers/md/Makefile
> +++ linux-2.6.20-git4/drivers/md/Makefile
> @@ -36,6 +36,7 @@ obj-$(CONFIG_DM_MULTIPATH_EMC)	+=3D dm-emc
>  obj-$(CONFIG_DM_SNAPSHOT)	+=3D dm-snapshot.o
>  obj-$(CONFIG_DM_MIRROR)		+=3D dm-mirror.o
>  obj-$(CONFIG_DM_ZERO)		+=3D dm-zero.o
> +obj-$(CONFIG_BLK_DEV_DM_BBR)	+=3D dm-bbr.o
> =20
>  quiet_cmd_unroll =3D UNROLL  $@
>        cmd_unroll =3D $(PERL) $(srctree)/$(src)/unroll.pl $(UNROLL) \
> Index: linux-2.6.20-git4/drivers/md/dm-bbr.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- /dev/null
> +++ linux-2.6.20-git4/drivers/md/dm-bbr.c
> @@ -0,0 +1,1004 @@
> +/*
> + *   (C) Copyright IBM Corp. 2002, 2004
> + *
> + *   This program is free software;  you can redistribute it and/or modi=
fy
> + *   it under the terms of the GNU General Public License as published b=
y
> + *   the Free Software Foundation; either version 2 of the License, or
> + *   (at your option) any later version.
> + *
> + *   This program is distributed in the hope that it will be useful,
> + *   but WITHOUT ANY WARRANTY;  without even the implied warranty of
> + *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
> + *   the GNU General Public License for more details.
> + *
> + *   You should have received a copy of the GNU General Public License
> + *   along with this program;  if not, write to the Free Software
> + *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307=
 USA
> + *
> + * linux/drivers/md/dm-bbr.c
> + *
> + * Bad-block-relocation (BBR) target for device-mapper.
> + *
> + * The BBR target is designed to remap I/O write failures to another saf=
e
> + * location on disk. Note that most disk drives have BBR built into them=
,
> + * this means that our software BBR will be only activated when all hard=
ware
> + * BBR replacement sectors have been used.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/bio.h>
> +#include <linux/spinlock.h>
> +#include <linux/slab.h>
> +#include <linux/mempool.h>
> +#include <linux/workqueue.h>
> +#include <linux/vmalloc.h>
> +
> +#include "dm.h"
> +#include "dm-bio-list.h"
> +#include "dm-bio-record.h"
> +#include "dm-bbr.h"
> +#include "dm-io.h"
> +
> +#define DM_MSG_PREFIX "bbr"
> +#define SECTOR_SIZE (1 << SECTOR_SHIFT)
> +
> +static struct workqueue_struct *dm_bbr_wq =3D NULL;
> +static void bbr_remap_handler(void *data);
> +static kmem_cache_t *bbr_remap_cache;
> +static kmem_cache_t *bbr_io_cache;
> +static mempool_t *bbr_io_pool;
> +
> +/**
> + * bbr_binary_tree_destroy
> + *
> + * Destroy the binary tree.
> + **/
> +static void bbr_binary_tree_destroy(struct bbr_runtime_remap *root)
> +{
> +	struct bbr_runtime_remap **link =3D NULL;
> +	struct bbr_runtime_remap *node =3D root;
> +
> +	while (node) {
> +		if (node->left) {
> +			link =3D &(node->left);
> +			node =3D node->left;
> +			continue;
> +		}
> +		if (node->right) {
> +			link =3D &(node->right);
> +			node =3D node->right;
> +			continue;
> +		}
> +
> +		kmem_cache_free(bbr_remap_cache, node);
> +		if (node =3D=3D root) {
> +			/* If root is deleted, we're done. */
> +			break;
> +		}
> +
> +		/* Back to root. */
> +		node =3D root;
> +		*link =3D NULL;
> +	}
> +}
> +
> +static void bbr_free_remap(struct bbr_private *bbr_id)
> +{
> +	spin_lock_irq(&bbr_id->remap_root_lock);
> +	bbr_binary_tree_destroy(bbr_id->remap_root);
> +	bbr_id->remap_root =3D NULL;
> +	spin_unlock_irq(&bbr_id->remap_root_lock);
> +}
> +
> +static struct bbr_private *bbr_alloc_private(void)
> +{
> +	struct bbr_private *bbr_id;
> +
> +	bbr_id =3D kmalloc(sizeof(*bbr_id), GFP_KERNEL);
> +	if (bbr_id) {
> +		memset(bbr_id, 0, sizeof(*bbr_id));
> +		INIT_WORK(&bbr_id->remap_work, bbr_remap_handler, bbr_id);
> +		bbr_id->remap_root_lock =3D SPIN_LOCK_UNLOCKED;
> +		bbr_id->remap_ios_lock =3D SPIN_LOCK_UNLOCKED;
> +		bbr_id->in_use_replacement_blks =3D (atomic_t)ATOMIC_INIT(0);
> +	}
> +
> +	return bbr_id;
> +}
> +
> +static void bbr_free_private(struct bbr_private *bbr_id)
> +{
> +	if (bbr_id->bbr_table) {
> +		vfree(bbr_id->bbr_table);
> +	}
> +	bbr_free_remap(bbr_id);
> +	kfree(bbr_id);
> +}
> +
> +static u32 crc_table[256];
> +static u32 crc_table_built =3D 0;
> +
> +static void build_crc_table(void)
> +{
> +	u32 i, j, crc;
> +
> +	for (i =3D 0; i <=3D 255; i++) {
> +		crc =3D i;
> +		for (j =3D 8; j > 0; j--) {
> +			if (crc & 1)
> +				crc =3D (crc >> 1) ^ CRC_POLYNOMIAL;
> +			else
> +				crc >>=3D 1;
> +		}
> +		crc_table[i] =3D crc;
> +	}
> +	crc_table_built =3D 1;
> +}
> +
> +static u32 calculate_crc(u32 crc, void *buffer, u32 buffersize)
> +{
> +	unsigned char *current_byte;
> +	u32 temp1, temp2, i;
> +
> +	current_byte =3D (unsigned char *) buffer;
> +	/* Make sure the crc table is available */
> +	if (!crc_table_built)
> +		build_crc_table();
> +	/* Process each byte in the buffer. */
> +	for (i =3D 0; i < buffersize; i++) {
> +		temp1 =3D (crc >> 8) & 0x00FFFFFF;
> +		temp2 =3D crc_table[(crc ^ (u32) * current_byte) &
> +				  (u32) 0xff];
> +		current_byte++;
> +		crc =3D temp1 ^ temp2;
> +	}
> +	return crc;
> +}
> +
> +/**
> + * le_bbr_table_sector_to_cpu
> + *
> + * Convert bbr meta data from on-disk (LE) format
> + * to the native cpu endian format.
> + **/
> +static void le_bbr_table_sector_to_cpu(struct bbr_table *p)
> +{
> +	int i;
> +	p->signature		=3D le32_to_cpup(&p->signature);
> +	p->crc			=3D le32_to_cpup(&p->crc);
> +	p->sequence_number	=3D le32_to_cpup(&p->sequence_number);
> +	p->in_use_cnt		=3D le32_to_cpup(&p->in_use_cnt);
> +	for (i =3D 0; i < BBR_ENTRIES_PER_SECT; i++) {
> +		p->entries[i].bad_sect =3D
> +			le64_to_cpup(&p->entries[i].bad_sect);
> +		p->entries[i].replacement_sect =3D
> +			le64_to_cpup(&p->entries[i].replacement_sect);
> +	}
> +}
> +
> +/**
> + * cpu_bbr_table_sector_to_le
> + *
> + * Convert bbr meta data from cpu endian format to on-disk (LE) format
> + **/
> +static void cpu_bbr_table_sector_to_le(struct bbr_table *p,
> +				       struct bbr_table *le)
> +{
> +	int i;
> +	le->signature		=3D cpu_to_le32p(&p->signature);
> +	le->crc			=3D cpu_to_le32p(&p->crc);
> +	le->sequence_number	=3D cpu_to_le32p(&p->sequence_number);
> +	le->in_use_cnt		=3D cpu_to_le32p(&p->in_use_cnt);
> +	for (i =3D 0; i < BBR_ENTRIES_PER_SECT; i++) {
> +		le->entries[i].bad_sect =3D
> +			cpu_to_le64p(&p->entries[i].bad_sect);
> +		le->entries[i].replacement_sect =3D
> +			cpu_to_le64p(&p->entries[i].replacement_sect);
> +	}
> +}
> +
> +/**
> + * validate_bbr_table_sector
> + *
> + * Check the specified BBR table sector for a valid signature and CRC. I=
f it's
> + * valid, endian-convert the table sector.
> + **/
> +static int validate_bbr_table_sector(struct bbr_table *p)
> +{
> +	int rc =3D 0;
> +	int org_crc, final_crc;
> +
> +	if (le32_to_cpup(&p->signature) !=3D BBR_TABLE_SIGNATURE) {
> +		DMERR("dm-bbr: BBR table signature doesn't match!");
> +		DMERR("dm-bbr: Found 0x%x. Expecting 0x%x",
> +		      le32_to_cpup(&p->signature), BBR_TABLE_SIGNATURE);
> +		rc =3D -EINVAL;
> +		goto out;
> +	}
> +
> +	if (!p->crc) {
> +		DMERR("dm-bbr: BBR table sector has no CRC!");
> +		rc =3D -EINVAL;
> +		goto out;
> +	}
> +
> +	org_crc =3D le32_to_cpup(&p->crc);
> +	p->crc =3D 0;
> +	final_crc =3D calculate_crc(INITIAL_CRC, (void *)p, sizeof(*p));
> +	if (final_crc !=3D org_crc) {
> +		DMERR("dm-bbr: CRC failed!");
> +		DMERR("dm-bbr: Found 0x%x. Expecting 0x%x",
> +		      org_crc, final_crc);
> +		rc =3D -EINVAL;
> +		goto out;
> +	}
> +
> +	p->crc =3D cpu_to_le32p(&org_crc);
> +	le_bbr_table_sector_to_cpu(p);
> +
> +out:
> +	return rc;
> +}
> +
> +/**
> + * bbr_binary_tree_insert
> + *
> + * Insert a node into the binary tree.
> + **/
> +static void bbr_binary_tree_insert(struct bbr_runtime_remap **root,
> +				   struct bbr_runtime_remap *newnode)
> +{
> +	struct bbr_runtime_remap **node =3D root;
> +	while (node && *node) {
> +		if (newnode->remap.bad_sect > (*node)->remap.bad_sect) {
> +			node =3D &((*node)->right);
> +		} else {
> +			node =3D &((*node)->left);
> +		}
> +	}
> +
> +	newnode->left =3D newnode->right =3D NULL;
> +	*node =3D newnode;
> +}
> +
> +/**
> + * bbr_binary_search
> + *
> + * Search for a node that contains bad_sect =3D=3D lsn.
> + **/
> +static struct bbr_runtime_remap *bbr_binary_search(
> +	struct bbr_runtime_remap *root,
> +	u64 lsn)
> +{
> +	struct bbr_runtime_remap *node =3D root;
> +	while (node) {
> +		if (node->remap.bad_sect =3D=3D lsn) {
> +			break;
> +		}
> +		if (lsn > node->remap.bad_sect) {
> +			node =3D node->right;
> +		} else {
> +			node =3D node->left;
> +		}
> +	}
> +	return node;
> +}
> +
> +/**
> + * bbr_insert_remap_entry
> + *
> + * Create a new remap entry and add it to the binary tree for this node.
> + **/
> +static int bbr_insert_remap_entry(struct bbr_private *bbr_id,
> +				  struct bbr_table_entry *new_bbr_entry)
> +{
> +	struct bbr_runtime_remap *newnode;
> +
> +	newnode =3D kmem_cache_alloc(bbr_remap_cache, GFP_NOIO);
> +	if (!newnode) {
> +		DMERR("dm-bbr: Could not allocate from remap cache!");
> +		return -ENOMEM;
> +	}
> +	newnode->remap.bad_sect  =3D new_bbr_entry->bad_sect;
> +	newnode->remap.replacement_sect =3D new_bbr_entry->replacement_sect;
> +	spin_lock_irq(&bbr_id->remap_root_lock);
> +	bbr_binary_tree_insert(&bbr_id->remap_root, newnode);
> +	spin_unlock_irq(&bbr_id->remap_root_lock);
> +	return 0;
> +}
> +
> +/**
> + * bbr_table_to_remap_list
> + *
> + * The on-disk bbr table is sorted by the replacement sector LBA. In ord=
er to
> + * improve run time performance, the in memory remap list must be sorted=
 by
> + * the bad sector LBA. This function is called at discovery time to init=
ialize
> + * the remap list. This function assumes that at least one copy of meta =
data
> + * is valid.
> + **/
> +static u32 bbr_table_to_remap_list(struct bbr_private *bbr_id)
> +{
> +	u32 in_use_blks =3D 0;
> +	int i, j;
> +	struct bbr_table *p;
> +
> +	for (i =3D 0, p =3D bbr_id->bbr_table;
> +	     i < bbr_id->nr_sects_bbr_table;
> +	     i++, p++) {
> +		if (!p->in_use_cnt) {
> +			break;
> +		}
> +		in_use_blks +=3D p->in_use_cnt;
> +		for (j =3D 0; j < p->in_use_cnt; j++) {
> +			bbr_insert_remap_entry(bbr_id, &p->entries[j]);
> +		}
> +	}
> +	if (in_use_blks) {
> +		char b[32];
> +		DMWARN("dm-bbr: There are %u BBR entries for device %s",
> +		       in_use_blks, format_dev_t(b, bbr_id->dev->bdev->bd_dev));
> +	}
> +
> +	return in_use_blks;
> +}
> +
> +/**
> + * bbr_search_remap_entry
> + *
> + * Search remap entry for the specified sector. If found, return a point=
er to
> + * the table entry. Otherwise, return NULL.
> + **/
> +static struct bbr_table_entry *bbr_search_remap_entry(
> +	struct bbr_private *bbr_id,
> +	u64 lsn)
> +{
> +	struct bbr_runtime_remap *p;
> +
> +	spin_lock_irq(&bbr_id->remap_root_lock);
> +	p =3D bbr_binary_search(bbr_id->remap_root, lsn);
> +	spin_unlock_irq(&bbr_id->remap_root_lock);
> +	if (p) {
> +		return (&p->remap);
> +	} else {
> +		return NULL;
> +	}
> +}
> +
> +/**
> + * bbr_remap
> + *
> + * If *lsn is in the remap table, return TRUE and modify *lsn,
> + * else, return FALSE.
> + **/
> +static inline int bbr_remap(struct bbr_private *bbr_id,
> +			    u64 *lsn)
> +{
> +	struct bbr_table_entry *e;
> +
> +	if (atomic_read(&bbr_id->in_use_replacement_blks)) {
> +		e =3D bbr_search_remap_entry(bbr_id, *lsn);
> +		if (e) {
> +			*lsn =3D e->replacement_sect;
> +			return 1;
> +		}
> +	}
> +	return 0;
> +}
> +
> +/**
> + * bbr_remap_probe
> + *
> + * If any of the sectors in the range [lsn, lsn+nr_sects] are in the rem=
ap
> + * table return TRUE, Else, return FALSE.
> + **/
> +static inline int bbr_remap_probe(struct bbr_private *bbr_id,
> +				  u64 lsn, u64 nr_sects)
> +{
> +	u64 tmp, cnt;
> +
> +	if (atomic_read(&bbr_id->in_use_replacement_blks)) {
> +		for (cnt =3D 0, tmp =3D lsn;
> +		     cnt < nr_sects;
> +		     cnt +=3D bbr_id->blksize_in_sects, tmp =3D lsn + cnt) {
> +			if (bbr_remap(bbr_id,&tmp)) {
> +				return 1;
> +			}
> +		}
> +	}
> +	return 0;
> +}
> +
> +/**
> + * bbr_setup
> + *
> + * Read the remap tables from disk and set up the initial remap tree.
> + **/
> +static int bbr_setup(struct bbr_private *bbr_id)
> +{
> +	struct bbr_table *table =3D bbr_id->bbr_table;
> +	struct io_region job;
> +	unsigned long error;
> +	int i, rc =3D 0;
> +
> +	job.bdev =3D bbr_id->dev->bdev;
> +	job.count =3D 1;
> +
> +	/* Read and verify each BBR table sector individually. */
> +	for (i =3D 0; i < bbr_id->nr_sects_bbr_table; i++, table++) {
> +		job.sector =3D bbr_id->lba_table1 + i;
> +		rc =3D dm_io_sync_vm(1, &job, READ, table, &error);
> +		if (rc && bbr_id->lba_table2) {
> +			job.sector =3D bbr_id->lba_table2 + i;
> +			rc =3D dm_io_sync_vm(1, &job, READ, table, &error);
> +		}
> +		if (rc) {
> +			goto out;
> +		}
> +
> +		rc =3D validate_bbr_table_sector(table);
> +		if (rc) {
> +			goto out;
> +		}
> +	}
> +	atomic_set(&bbr_id->in_use_replacement_blks,
> +		   bbr_table_to_remap_list(bbr_id));
> +
> +out:
> +	if (rc) {
> +		DMERR("dm-bbr: error during device setup: %d", rc);
> +	}
> +	return rc;
> +}
> +
> +/**
> + * bbr_io_remap_error
> + * @bbr_id:		Private data for the BBR node.
> + * @rw:			READ or WRITE.
> + * @starting_lsn:	Starting sector of request to remap.
> + * @count:		Number of sectors in the request.
> + * @page:		Page containing the data for the request.
> + * @offset:		Byte-offset of the data within the page.
> + *
> + * For the requested range, try to write each sector individually. For e=
ach
> + * sector that fails, find the next available remap location and write t=
he
> + * data to that new location. Then update the table and write both copie=
s
> + * of the table to disk. Finally, update the in-memory mapping and do an=
y
> + * other necessary bookkeeping.
> + **/
> +static int bbr_io_remap_error(struct bbr_private *bbr_id,
> +			      int rw,
> +			      u64 starting_lsn,
> +			      u64 count,
> +			      struct page *page,
> +			      unsigned int offset)
> +{
> +	struct bbr_table *bbr_table;
> +	struct io_region job;
> +	struct page_list pl;
> +	unsigned long table_sector_index;
> +	unsigned long table_sector_offset;
> +	unsigned long index;
> +	unsigned long error;
> +	u64 lsn, new_lsn;
> +	char b[32];
> +	int rc;
> +
> +	job.bdev =3D bbr_id->dev->bdev;
> +	job.count =3D 1;
> +	pl.page =3D page;
> +	pl.next =3D NULL;
> +
> +	/* For each sector in the request. */
> +	for (lsn =3D 0; lsn < count; lsn++, offset +=3D SECTOR_SIZE) {
> +		job.sector =3D starting_lsn + lsn;
> +		rc =3D dm_io_sync(1, &job, rw, &pl, offset, &error);
> +		while (rc) {
> +			/* Find the next available relocation sector. */
> +			new_lsn =3D atomic_read(&bbr_id->in_use_replacement_blks);
> +			if (new_lsn >=3D bbr_id->nr_replacement_blks) {
> +				/* No more replacement sectors available. */
> +				return -EIO;
> +			}
> +			new_lsn +=3D bbr_id->start_replacement_sect;
> +
> +			/* Write the data to its new location. */
> +			DMWARN("dm-bbr: device %s: Trying to remap bad sector "PFU64" to sect=
or "PFU64,
> +			       format_dev_t(b, bbr_id->dev->bdev->bd_dev),
> +			       starting_lsn + lsn, new_lsn);
> +			job.sector =3D new_lsn;
> +			rc =3D dm_io_sync(1, &job, rw, &pl, offset, &error);
> +			if (rc) {
> +				/* This replacement sector is bad.
> +				 * Try the next one.
> +				 */
> +				DMERR("dm-bbr: device %s: replacement sector "PFU64" is bad. Skippin=
g.",
> +				      format_dev_t(b, bbr_id->dev->bdev->bd_dev), new_lsn);
> +				atomic_inc(&bbr_id->in_use_replacement_blks);
> +				continue;
> +			}
> +
> +			/* Add this new entry to the on-disk table. */
> +			table_sector_index =3D new_lsn -
> +					     bbr_id->start_replacement_sect;
> +			table_sector_offset =3D table_sector_index /
> +					      BBR_ENTRIES_PER_SECT;
> +			index =3D table_sector_index % BBR_ENTRIES_PER_SECT;
> +
> +			bbr_table =3D &bbr_id->bbr_table[table_sector_offset];
> +			bbr_table->entries[index].bad_sect =3D starting_lsn + lsn;
> +			bbr_table->entries[index].replacement_sect =3D new_lsn;
> +			bbr_table->in_use_cnt++;
> +			bbr_table->sequence_number++;
> +			bbr_table->crc =3D 0;
> +			bbr_table->crc =3D calculate_crc(INITIAL_CRC,
> +						       bbr_table,
> +						       sizeof(struct bbr_table));
> +
> +			/* Write the table to disk. */
> +			cpu_bbr_table_sector_to_le(bbr_table, bbr_table);
> +			if (bbr_id->lba_table1) {
> +				job.sector =3D bbr_id->lba_table1 + table_sector_offset;
> +				rc =3D dm_io_sync_vm(1, &job, WRITE, bbr_table, &error);
> +			}
> +			if (bbr_id->lba_table2) {
> +				job.sector =3D bbr_id->lba_table2 + table_sector_offset;
> +				rc |=3D dm_io_sync_vm(1, &job, WRITE, bbr_table, &error);
> +			}
> +			le_bbr_table_sector_to_cpu(bbr_table);
> +
> +			if (rc) {
> +				/* Error writing one of the tables to disk. */
> +				DMERR("dm-bbr: device %s: error updating BBR tables on disk.",
> +				      format_dev_t(b, bbr_id->dev->bdev->bd_dev));
> +				return rc;
> +			}
> +
> +			/* Insert a new entry in the remapping binary-tree. */
> +			rc =3D bbr_insert_remap_entry(bbr_id,
> +						    &bbr_table->entries[index]);
> +			if (rc) {
> +				DMERR("dm-bbr: device %s: error adding new entry to remap tree.",
> +				      format_dev_t(b, bbr_id->dev->bdev->bd_dev));
> +				return rc;
> +			}
> +
> +			atomic_inc(&bbr_id->in_use_replacement_blks);
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * bbr_io_process_request
> + *
> + * For each sector in this request, check if the sector has already
> + * been remapped. If so, process all previous sectors in the request,
> + * followed by the remapped sector. Then reset the starting lsn and
> + * count, and keep going with the rest of the request as if it were
> + * a whole new request. If any of the sync_io's return an error,
> + * call the remapper to relocate the bad sector(s).
> + *
> + * 2.5 Note: When switching over to bio's for the I/O path, we have made
> + * the assumption that the I/O request described by the bio is one
> + * virtually contiguous piece of memory (even though the bio vector
> + * describes it using a series of physical page addresses).
> + **/
> +static int bbr_io_process_request(struct bbr_private *bbr_id,
> +				  struct bio *bio)
> +{
> +	struct io_region job;
> +	u64 starting_lsn =3D bio->bi_sector;
> +	u64 count, lsn, remapped_lsn;
> +	struct page_list pl;
> +	unsigned int offset;
> +	unsigned long error;
> +	int i, rw =3D bio_data_dir(bio);
> +	int rc =3D 0;
> +
> +	job.bdev =3D bbr_id->dev->bdev;
> +	pl.next =3D NULL;
> +
> +	/* Each bio can contain multiple vectors, each with a different page.
> +	 * Treat each vector as a separate request.
> +	 */
> +	/* KMC: Is this the right way to walk the bvec list? */
> +	for (i =3D 0;
> +	     i < bio->bi_vcnt;
> +	     i++, bio->bi_idx++, starting_lsn +=3D count) {
> +
> +		/* Bvec info: number of sectors, page,
> +		 * and byte-offset within page.
> +		 */
> +		count =3D bio_iovec(bio)->bv_len >> SECTOR_SHIFT;
> +		pl.page =3D bio_iovec(bio)->bv_page;
> +		offset =3D bio_iovec(bio)->bv_offset;
> +
> +		/* For each sector in this bvec, check if the sector has
> +		 * already been remapped. If so, process all previous sectors
> +		 * in this request, followed by the remapped sector. Then reset
> +		 * the starting lsn and count and keep going with the rest of
> +		 * the request as if it were a whole new request.
> +		 */
> +		for (lsn =3D 0; lsn < count; lsn++) {
> +			remapped_lsn =3D starting_lsn + lsn;
> +			rc =3D bbr_remap(bbr_id, &remapped_lsn);
> +			if (!rc) {
> +				/* This sector is fine. */
> +				continue;
> +			}
> +
> +			/* Process all sectors in the request up to this one. */
> +			if (lsn > 0) {
> +				job.sector =3D starting_lsn;
> +				job.count =3D lsn;
> +				rc =3D dm_io_sync(1, &job, rw, &pl,
> +						offset, &error);
> +				if (rc) {
> +					/* If this I/O failed, then one of the
> +					 * sectors in this request needs to be
> +					 * relocated.
> +					 */
> +					rc =3D bbr_io_remap_error(bbr_id, rw,
> +								starting_lsn,
> +								lsn, pl.page,
> +								offset);
> +					if (rc) {
> +						/* KMC: Return? Or continue to next bvec? */
> +						return rc;
> +					}
> +				}
> +				offset +=3D (lsn << SECTOR_SHIFT);
> +			}
> +
> +			/* Process the remapped sector. */
> +			job.sector =3D remapped_lsn;
> +			job.count =3D 1;
> +			rc =3D dm_io_sync(1, &job, rw, &pl, offset, &error);
> +			if (rc) {
> +				/* BUGBUG - Need more processing if this caused
> +				 * an error. If this I/O failed, then the
> +				 * existing remap is now bad, and we need to
> +				 * find a new remap. Can't use
> +				 * bbr_io_remap_error(), because the existing
> +				 * map entry needs to be changed, not added
> +				 * again, and the original table entry also
> +				 * needs to be changed.
> +				 */
> +				return rc;
> +			}
> +
> +			starting_lsn	+=3D (lsn + 1);
> +			count		-=3D (lsn + 1);
> +			lsn		=3D -1;
> +			offset		+=3D SECTOR_SIZE;
> +		}
> +
> +		/* Check for any remaining sectors after the last split. This
> +		 * could potentially be the whole request, but that should be a
> +		 * rare case because requests should only be processed by the
> +		 * thread if we know an error occurred or they contained one or
> +		 * more remapped sectors.
> +		 */
> +		if (count) {
> +			job.sector =3D starting_lsn;
> +			job.count =3D count;
> +			rc =3D dm_io_sync(1, &job, rw, &pl, offset, &error);
> +			if (rc) {
> +				/* If this I/O failed, then one of the sectors
> +				 * in this request needs to be relocated.
> +				 */
> +				rc =3D bbr_io_remap_error(bbr_id, rw, starting_lsn,
> +							count, pl.page, offset);
> +				if (rc) {
> +					/* KMC: Return? Or continue to next bvec? */
> +					return rc;
> +				}
> +			}
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static void bbr_io_process_requests(struct bbr_private *bbr_id,
> +				    struct bio *bio)
> +{
> +	struct bio *next;
> +	int rc;
> +
> +	while (bio) {
> +		next =3D bio->bi_next;
> +		bio->bi_next =3D NULL;
> +
> +		rc =3D bbr_io_process_request(bbr_id, bio);
> +
> +		bio_endio(bio, bio->bi_size, rc);
> +
> +		bio =3D next;
> +	}
> +}
> +
> +/**
> + * bbr_remap_handler
> + *
> + * This is the handler for the bbr work-queue.
> + *
> + * I/O requests should only be sent to this handler if we know that:
> + * a) the request contains at least one remapped sector.
> + *   or
> + * b) the request caused an error on the normal I/O path.
> + *
> + * This function uses synchronous I/O, so sending a request to this
> + * thread that doesn't need special processing will cause severe
> + * performance degredation.
> + **/
> +static void bbr_remap_handler(void *data)
> +{
> +	struct bbr_private *bbr_id =3D data;
> +	struct bio *bio;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&bbr_id->remap_ios_lock, flags);
> +	bio =3D bio_list_get(&bbr_id->remap_ios);
> +	spin_unlock_irqrestore(&bbr_id->remap_ios_lock, flags);
> +
> +	bbr_io_process_requests(bbr_id, bio);
> +}
> +
> +/**
> + * bbr_endio
> + *
> + * This is the callback for normal write requests. Check for an error
> + * during the I/O, and send to the thread for processing if necessary.
> + **/
> +static int bbr_endio(struct dm_target *ti, struct bio *bio,
> +		     int error, union map_info *map_context)
> +{
> +	struct bbr_private *bbr_id =3D ti->private;
> +	struct dm_bio_details *bbr_io =3D map_context->ptr;
> +
> +	if (error && bbr_io) {
> +		unsigned long flags;
> +		char b[32];
> +
> +		dm_bio_restore(bbr_io, bio);
> +		map_context->ptr =3D NULL;
> +
> +		DMERR("dm-bbr: device %s: I/O failure on sector %lu. "
> +		      "Scheduling for retry.",
> +		      format_dev_t(b, bbr_id->dev->bdev->bd_dev),
> +		      (unsigned long)bio->bi_sector);
> +
> +		spin_lock_irqsave(&bbr_id->remap_ios_lock, flags);
> +		bio_list_add(&bbr_id->remap_ios, bio);
> +		spin_unlock_irqrestore(&bbr_id->remap_ios_lock, flags);
> +
> +		queue_work(dm_bbr_wq, &bbr_id->remap_work);
> +
> +		error =3D 1;
> +	}
> +
> +	if (bbr_io)
> +		mempool_free(bbr_io, bbr_io_pool);
> +
> +	return error;
> +}
> +
> +/**
> + * Construct a bbr mapping
> + **/
> +static int bbr_ctr(struct dm_target *ti, unsigned int argc, char **argv)
> +{
> +	struct bbr_private *bbr_id;
> +	unsigned long block_size;
> +	char *end;
> +	int rc =3D -EINVAL;
> +
> +	if (argc !=3D 8) {
> +		ti->error =3D "dm-bbr requires exactly 8 arguments: "
> +			    "device offset table1_lsn table2_lsn table_size start_replacement=
 nr_replacement_blks block_size";
> +		goto out1;
> +	}
> +
> +	bbr_id =3D bbr_alloc_private();
> +	if (!bbr_id) {
> +		ti->error =3D "dm-bbr: Error allocating bbr private data.";
> +		goto out1;
> +	}
> +
> +	bbr_id->offset =3D simple_strtoull(argv[1], &end, 10);
> +	bbr_id->lba_table1 =3D simple_strtoull(argv[2], &end, 10);
> +	bbr_id->lba_table2 =3D simple_strtoull(argv[3], &end, 10);
> +	bbr_id->nr_sects_bbr_table =3D simple_strtoull(argv[4], &end, 10);
> +	bbr_id->start_replacement_sect =3D simple_strtoull(argv[5], &end, 10);
> +	bbr_id->nr_replacement_blks =3D simple_strtoull(argv[6], &end, 10);
> +	block_size =3D simple_strtoul(argv[7], &end, 10);
> +	bbr_id->blksize_in_sects =3D (block_size >> SECTOR_SHIFT);
> +
> +	bbr_id->bbr_table =3D vmalloc(bbr_id->nr_sects_bbr_table << SECTOR_SHIF=
T);
> +	if (!bbr_id->bbr_table) {
> +		ti->error =3D "dm-bbr: Error allocating bbr table.";
> +		goto out2;
> +	}
> +
> +	if (dm_get_device(ti, argv[0], 0, ti->len,
> +			  dm_table_get_mode(ti->table), &bbr_id->dev)) {
> +		ti->error =3D "dm-bbr: Device lookup failed";
> +		goto out2;
> +	}
> +
> +	rc =3D bbr_setup(bbr_id);
> +	if (rc) {
> +		ti->error =3D "dm-bbr: Device setup failed";
> +		goto out3;
> +	}
> +
> +	ti->private =3D bbr_id;
> +	return 0;
> +
> +out3:
> +	dm_put_device(ti, bbr_id->dev);
> +out2:
> +	bbr_free_private(bbr_id);
> +out1:
> +	return rc;
> +}
> +
> +static void bbr_dtr(struct dm_target *ti)
> +{
> +	struct bbr_private *bbr_id =3D ti->private;
> +
> +	dm_put_device(ti, bbr_id->dev);
> +	bbr_free_private(bbr_id);
> +}
> +
> +static int bbr_map(struct dm_target *ti, struct bio *bio,
> +		   union map_info *map_context)
> +{
> +	struct bbr_private *bbr_id =3D ti->private;
> +	struct dm_bio_details *bbr_io;
> +	unsigned long flags;
> +	int rc =3D 1;
> +
> +	bio->bi_sector +=3D bbr_id->offset;
> +
> +	if (atomic_read(&bbr_id->in_use_replacement_blks) =3D=3D 0 ||
> +	    !bbr_remap_probe(bbr_id, bio->bi_sector, bio_sectors(bio))) {
> +		/* No existing remaps or this request doesn't
> +		 * contain any remapped sectors.
> +		 */
> +		bio->bi_bdev =3D bbr_id->dev->bdev;
> +
> +		bbr_io =3D mempool_alloc(bbr_io_pool, GFP_NOIO);
> +		dm_bio_record(bbr_io, bio);
> +		map_context->ptr =3D bbr_io;
> +	} else {
> +		/* This request has at least one remapped sector.
> +		 * Give it to the work-queue for processing.
> +		 */
> +		map_context->ptr =3D NULL;
> +		spin_lock_irqsave(&bbr_id->remap_ios_lock, flags);
> +		bio_list_add(&bbr_id->remap_ios, bio);
> +		spin_unlock_irqrestore(&bbr_id->remap_ios_lock, flags);
> +
> +		queue_work(dm_bbr_wq, &bbr_id->remap_work);
> +		rc =3D 0;
> +	}
> +
> +	return rc;
> +}
> +
> +static int bbr_status(struct dm_target *ti, status_type_t type,
> +		      char *result, unsigned int maxlen)
> +{
> +	struct bbr_private *bbr_id =3D ti->private;
> +	char b[BDEVNAME_SIZE];
> +
> +	switch (type) {
> +	case STATUSTYPE_INFO:
> +		result[0] =3D '\0';
> +		break;
> +
> +	case STATUSTYPE_TABLE:
> +		snprintf(result, maxlen, "%s "PFU64" "PFU64" "PFU64" "PFU64" "PFU64" "=
PFU64" %u",
> +			 format_dev_t(b, bbr_id->dev->bdev->bd_dev),
> +			 bbr_id->offset, bbr_id->lba_table1, bbr_id->lba_table2,
> +			 bbr_id->nr_sects_bbr_table,
> +			 bbr_id->start_replacement_sect,
> +			 bbr_id->nr_replacement_blks,
> +			 bbr_id->blksize_in_sects << SECTOR_SHIFT);
> +		 break;
> +	}
> +	return 0;
> +}
> +
> +static struct target_type bbr_target =3D {
> +	.name	=3D "bbr",
> +	.version=3D {1, 0, 1},
> +	.module	=3D THIS_MODULE,
> +	.ctr	=3D bbr_ctr,
> +	.dtr	=3D bbr_dtr,
> +	.map	=3D bbr_map,
> +	.end_io	=3D bbr_endio,
> +	.status	=3D bbr_status,
> +};
> +
> +int __init dm_bbr_init(void)
> +{
> +	int rc;
> +
> +	rc =3D dm_register_target(&bbr_target);
> +	if (rc) {
> +		DMERR("dm-bbr: error registering target.");
> +		goto err1;
> +	}
> +
> +	bbr_remap_cache =3D kmem_cache_create("bbr-remap",
> +					    sizeof(struct bbr_runtime_remap),
> +					    0, SLAB_HWCACHE_ALIGN, NULL, NULL);
> +	if (!bbr_remap_cache) {
> +		DMERR("dm-bbr: error creating remap cache.");
> +		rc =3D ENOMEM;
> +		goto err2;
> +	}
> +
> +	bbr_io_cache =3D kmem_cache_create("bbr-io", sizeof(struct dm_bio_detai=
ls),
> +					 0, SLAB_HWCACHE_ALIGN, NULL, NULL);
> +	if (!bbr_io_cache) {
> +		DMERR("dm-bbr: error creating io cache.");
> +		rc =3D ENOMEM;
> +		goto err3;
> +	}
> +
> +	bbr_io_pool =3D mempool_create(256, mempool_alloc_slab,
> +				     mempool_free_slab, bbr_io_cache);
> +	if (!bbr_io_pool) {
> +		DMERR("dm-bbr: error creating io mempool.");
> +		rc =3D ENOMEM;
> +		goto err4;
> +	}
> +
> +	dm_bbr_wq =3D create_workqueue("dm-bbr");
> +	if (!dm_bbr_wq) {
> +		DMERR("dm-bbr: error creating work-queue.");
> +		rc =3D ENOMEM;
> +		goto err5;
> +	}
> +
> +	rc =3D dm_io_get(1);
> +	if (rc) {
> +		DMERR("dm-bbr: error initializing I/O service.");
> +		goto err6;
> +	}
> +
> +	return 0;
> +
> +err6:
> +	destroy_workqueue(dm_bbr_wq);
> +err5:
> +	mempool_destroy(bbr_io_pool);
> +err4:
> +	kmem_cache_destroy(bbr_io_cache);
> +err3:
> +	kmem_cache_destroy(bbr_remap_cache);
> +err2:
> +	dm_unregister_target(&bbr_target);
> +err1:
> +	return rc;
> +}
> +
> +void __exit dm_bbr_exit(void)
> +{
> +	dm_io_put(1);
> +	destroy_workqueue(dm_bbr_wq);
> +	mempool_destroy(bbr_io_pool);
> +	kmem_cache_destroy(bbr_io_cache);
> +	kmem_cache_destroy(bbr_remap_cache);
> +	dm_unregister_target(&bbr_target);
> +}
> +
> +module_init(dm_bbr_init);
> +module_exit(dm_bbr_exit);
> +MODULE_LICENSE("GPL");
> Index: linux-2.6.20-git4/drivers/md/dm-bbr.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- /dev/null
> +++ linux-2.6.20-git4/drivers/md/dm-bbr.h
> @@ -0,0 +1,125 @@
> +/*
> + *   (C) Copyright IBM Corp. 2002, 2004
> + *
> + *   This program is free software;  you can redistribute it and/or modi=
fy
> + *   it under the terms of the GNU General Public License as published b=
y
> + *   the Free Software Foundation; either version 2 of the License, or
> + *   (at your option) any later version.
> + *
> + *   This program is distributed in the hope that it will be useful,
> + *   but WITHOUT ANY WARRANTY;  without even the implied warranty of
> + *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
> + *   the GNU General Public License for more details.
> + *
> + *   You should have received a copy of the GNU General Public License
> + *   along with this program;  if not, write to the Free Software
> + *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307=
 USA
> + *
> + * linux/drivers/md/dm-bbr.h
> + *
> + * Bad-block-relocation (BBR) target for device-mapper.
> + *
> + * The BBR target is designed to remap I/O write failures to another saf=
e
> + * location on disk. Note that most disk drives have BBR built into them=
,
> + * this means that our software BBR will be only activated when all hard=
ware
> + * BBR replacement sectors have been used.
> + */
> +
> +#define BBR_TABLE_SIGNATURE		0x42627254 /* BbrT */
> +#define BBR_ENTRIES_PER_SECT		31
> +#define INITIAL_CRC			0xFFFFFFFF
> +#define CRC_POLYNOMIAL			0xEDB88320L
> +
> +/**
> + * Macros to cleanly print 64-bit numbers on both 32-bit and 64-bit mach=
ines.
> + * Use these in place of %Ld, %Lu, and %Lx.
> + **/
> +#if BITS_PER_LONG > 32
> +#define PFU64 "%lu"
> +#else
> +#define PFU64 "%Lu"
> +#endif
> +
> +/**
> + * struct bbr_table_entry
> + * @bad_sect:		LBA of bad location.
> + * @replacement_sect:	LBA of new location.
> + *
> + * Structure to describe one BBR remap.
> + **/
> +struct bbr_table_entry {
> +	u64 bad_sect;
> +	u64 replacement_sect;
> +};
> +
> +/**
> + * struct bbr_table
> + * @signature:		Signature on each BBR table sector.
> + * @crc:		CRC for this table sector.
> + * @sequence_number:	Used to resolve conflicts when primary and secondar=
y
> + *			tables do not match.
> + * @in_use_cnt:		Number of in-use table entries.
> + * @entries:		Actual table of remaps.
> + *
> + * Structure to describe each sector of the metadata table. Each sector =
in this
> + * table can describe 31 remapped sectors.
> + **/
> +struct bbr_table {
> +	u32			signature;
> +	u32			crc;
> +	u32			sequence_number;
> +	u32			in_use_cnt;
> +	struct bbr_table_entry	entries[BBR_ENTRIES_PER_SECT];
> +};
> +
> +/**
> + * struct bbr_runtime_remap
> + *
> + * Node in the binary tree used to keep track of remaps.
> + **/
> +struct bbr_runtime_remap {
> +	struct bbr_table_entry		remap;
> +	struct bbr_runtime_remap	*left;
> +	struct bbr_runtime_remap	*right;
> +};
> +
> +/**
> + * struct bbr_private
> + * @dev:			Info about underlying device.
> + * @bbr_table:			Copy of metadata table.
> + * @remap_root:			Binary tree containing all remaps.
> + * @remap_root_lock:		Lock for the binary tree.
> + * @remap_work:			For adding work items to the work-queue.
> + * @remap_ios:			List of I/Os for the work-queue to handle.
> + * @remap_ios_lock:		Lock for the remap_ios list.
> + * @offset:			LBA of data area.
> + * @lba_table1:			LBA of primary BBR table.
> + * @lba_table2:			LBA of secondary BBR table.
> + * @nr_sects_bbr_table:		Size of each BBR table.
> + * @nr_replacement_blks:	Number of replacement blocks.
> + * @start_replacement_sect:	LBA of start of replacement blocks.
> + * @blksize_in_sects:		Size of each block.
> + * @in_use_replacement_blks:	Current number of remapped blocks.
> + *
> + * Private data for each BBR target.
> + **/
> +struct bbr_private {
> +	struct dm_dev			*dev;
> +	struct bbr_table		*bbr_table;
> +	struct bbr_runtime_remap	*remap_root;
> +	spinlock_t			remap_root_lock;
> +
> +	struct work_struct		remap_work;
> +	struct bio_list			remap_ios;
> +	spinlock_t			remap_ios_lock;
> +
> +	u64				offset;
> +	u64				lba_table1;
> +	u64				lba_table2;
> +	u64				nr_sects_bbr_table;
> +	u64				start_replacement_sect;
> +	u64				nr_replacement_blks;
> +	u32				blksize_in_sects;
> +	atomic_t			in_use_replacement_blks;
> +};
> +
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
--=20
Piet Delaney                                    Phone: (408) 200-5256
Blue Lane Technologies                          Fax:   (408) 200-5299
10450 Bubb Rd.
Cupertino, Ca. 95014                            Email: piet@bluelane.com

--=-PnQz2yWWpwT5Oqrnad+/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQBF3ib3JICwm/rv3hoRApM+AJ9OT9PiwC9uQIJ/ZMwRDKLcuWADFQCbBhWv
ngv/CpED8IpUpCdQ5vW48+0=
=C/gh
-----END PGP SIGNATURE-----

--=-PnQz2yWWpwT5Oqrnad+/--



--===============0777968439==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-------------------------------------------------------------------------
Take Surveys. Earn Cash. Influence the Future of IT
Join SourceForge.net's Techsay panel and you'll get the chance to share your
opinions on IT & business topics through brief surveys-and earn cash
http://www.techsay.com/default.php?page=join.php&p=sourceforge&CID=DEVDEV
--===============0777968439==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Evms-devel mailing list
Evms-devel@lists.sourceforge.net
To subscribe/unsubscribe, please visit:
https://lists.sourceforge.net/lists/listinfo/evms-devel

--===============0777968439==--
