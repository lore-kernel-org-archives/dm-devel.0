From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [RFC][PATCH] dm-mirror: fix data corruption
Date: Fri, 10 Jul 2009 09:44:14 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0907100939060.568@hs20-bc2-1.build.redhat.com>
References: <4A568333.6090901@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4A568333.6090901@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Takahiro Yasui <tyasui@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi

For me this approach looks very complex, I would be much more simple to 
hold back bios until dmeventd processes the failed mirror.

This approach has redundant data structures (log and superblock) that 
could really be joined to one structure. You need an extra code to 
allocate the superblocks.

Note that you also need to handle errors superblocks without loss of 
functionality (raid1 is supposed to survive failing disks) ... and it just 
increases testing time and increases possibility for other bugs.


If someone wants to make new dm-raid1 design that wouldn't be dependent on 
dmeventd, I'm not against it, but make it from scratch without patching 
over existing code (for example, store superblocks and bitmap at the end 
of the legs like raid-145 does).

Mikulas

On Thu, 9 Jul 2009, Takahiro Yasui wrote:

> Hi,
> 
> This is a prototype patch to fix data corruption issue on dm-raid1.
> It is just a draft patch and is not tested well, but let me post it
> to review and discuss this in-kernel superblock approach.
> 
> I appreciate your comments and suggestions.
> 
> 
> DATA CORRUPTION ISSUE
> =====================
> 
> dm-mirror has a possibility of data corruption by the following scenario.
> 
>     1) Primary mirror disk fails.
>     2) A write request is submitted to the mirror disk, and the request
>         is written on the secondary disk but not on the primary disk.
>     3) The write request completes and returns success to upper layer.
>     4) A system crash occures before dmeventd handles the error.
>     5) On the next boot, the failed disk is back online.
>     6) Data is copied from the primary disk to secondary disk according
>         to the dirty bit of the log disk.
>     7) Data corruption happens.
> 
> 
> DISCUSSION
> ==========
> 
> DM-RAID1 data corruption
> https://www.redhat.com/archives/dm-devel/2009-April/msg00178.html
> 
> 
> DESIGN OVERVIEW
> ===============
> 
>   * Introduce superblock area
> 
>     A superblock area is related to a mirror leg on a one-to-one basis and
>     keeps a sequential number to decide the default mirror when the mirror
>     is resumed.
> 
>     A superblock area is managed by kernel (dm-raid1), and its sequential
>     number is incremented at the following cases:
> 
>       1. The mirror is resumed.
>       2. The first write error on the mirror leg is detected.
>       3. I/O error happened during superblock update process.
> 
>   * block write I/Os
> 
>     When the first write error was reported, all write I/Os are blocked until
>     superblock update procesure completes.
> 
>   * ioctl intarface
> 
>     This patch introduces a new feature string, "superblock", followed
>     by superblock device information.
> 
>     <interface definition>
> 
>     mirror_ctr()
>         log_type #log_params <log_params> \
>         #mirrors [mirror_path offset]{2,} [#features <features>] \
>         [[superblock_path offset]{2,}]
> 
>     mirror_status() - STATUSTYPE_INFO:
>         No information is added because the status of superblock is the same
>         as the related mirror leg.
> 
>         #mirrors [mirror_path]{2,} <sync info> 1 "DSRU"{2,} <log info>
> 
>     mirror_status() - STATUSTYPE_TABLE:
>         Superblock information is added at the end of the mirror information.
> 
>         <log info> #mirrors [mirror_path offset]{2,} [#features <features>] \
>         [[superblock_path offset]{2,}]
> 
> 
> EXAMPLES
> ========
> 
>   Here is three examples of mirror with two mirror legs and superblocks.
>   mirror legs and superblocs are expected to exist on the same devices,
>   but superblocks can be allocated on different devices from mirror legs.
> 
>   * core log (mirror legs and superblocks are on the same devices)
> 
>     # dmsetup create mirror --table "0 1000 mirror core 1 8 \
>         2 /dev/sda 0 /dev/sdb 0 2 handle_errors superblock \
>         /dev/sda 2000 /dev/sdb 2000"
> 
>     # dmsetup table
>     mirror: 0 1000 mirror core 1 8 2 /dev/sda 0 /dev/sdb 0 2 \
>     handle_errors superblock 2 /dev/sda 2000 /dev/sdb 2000
> 
>   * disk log (mirror legs and superblock are on the different devices)
> 
>     # dmsetup create mirror --table "0 1000 mirror disk 2 /dev/sdc 8 \
>         2 /dev/sda 0 /dev/sdb 0 2 handle_errors superblock \
>         /dev/sdd 0 /dev/sde 0"
> 
>     # dmsetup table
>     mirror: 0 1000 mirror disk 2 /dev/sdc 8 2 /dev/sda 0 /dev/sdb 0 2 \
>     handle_errors superblock 2 /dev/sdd 2000 /dev/sde 2000
> 
> Regards,
> ---
> Takahiro Yasui
> Hitachi Computer Products (America) Inc.
> 
> 
> Signed-off-by: Takahiro Yasui <tyasui@redhat.com>
> ---
>  drivers/md/Makefile      |    2 
>  drivers/md/dm-raid1-sb.c |  367 +++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/md/dm-raid1-sb.h |   44 +++++
>  drivers/md/dm-raid1.c    |  102 +++++++++++--
>  4 files changed, 503 insertions(+), 12 deletions(-)
> 
> Index: linux-2.6.30/drivers/md/Makefile
> ===================================================================
> --- linux-2.6.30.orig/drivers/md/Makefile
> +++ linux-2.6.30/drivers/md/Makefile
> @@ -7,7 +7,7 @@ dm-mod-y	+= dm.o dm-table.o dm-target.o 
>  dm-multipath-y	+= dm-path-selector.o dm-mpath.o
>  dm-snapshot-y	+= dm-snap.o dm-exception-store.o dm-snap-transient.o \
>  		    dm-snap-persistent.o
> -dm-mirror-y	+= dm-raid1.o
> +dm-mirror-y	+= dm-raid1.o dm-raid1-sb.o
>  md-mod-y	+= md.o bitmap.o
>  raid456-y	+= raid5.o
>  raid6_pq-y	+= raid6algos.o raid6recov.o raid6tables.o \
> Index: linux-2.6.30/drivers/md/dm-raid1-sb.c
> ===================================================================
> --- /dev/null
> +++ linux-2.6.30/drivers/md/dm-raid1-sb.c
> @@ -0,0 +1,367 @@
> +/*
> + * Device Mapper RAID1 Superblock Support
> + *
> + * Written by Takahiro Yasui <tyasui@redhat.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the
> + * Free Software Foundation; either version 2 of the License, or (at your
> + * option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, write to the Free Software Foundation, Inc.,
> + * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> + *
> + */
> +
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/device-mapper.h>
> +#include <linux/dm-io.h>
> +
> +#include "dm-raid1-sb.h"
> +
> +/*
> + * macros
> + */
> +#define DM_MSG_PREFIX		"raid1-sb"
> +
> +#define MIRROR_SB_MAGIC		0x4D695362 /* "MiSb" */
> +#define MIRROR_SB_VERSION	1
> +#define MIRROR_SB_SECT_SIZE	1
> +#define MIRROR_SB_SIZE		(MIRROR_SB_SECT_SIZE << SECTOR_SHIFT)
> +
> +/*
> + * superblock data structure
> + */
> +struct msb {
> +	uint32_t magic;
> +	uint32_t version;
> +	uint32_t seqno;		/*  0 ... initalized superblock
> +				   >0 ... valid superblock */
> +};
> +
> +struct msb_dev {
> +	struct msb_context *sbc;
> +	struct msb sb;
> +	struct dm_dev *dev;
> +	struct dm_io_region loc;
> +};
> +
> +struct msb_context {
> +	struct dm_target *ti;
> +	struct mirror_set *ms;
> +	struct msb sb;
> +
> +	struct dm_io_request io_req;
> +	struct msb *io_buf;
> +
> +	struct mutex worker_lock;
> +	struct work_struct update_work;
> +
> +	unsigned int nr_sbd;	/* = ms->nr_mirrors */
> +	struct msb_dev sbd[0];
> +};
> +
> +/*
> + * converters memory to/from disk
> + */
> +static void msb_mem_to_disk(struct msb *mem, struct msb *disk)
> +{
> +	disk->magic   = cpu_to_le32(mem->magic);
> +	disk->version = cpu_to_le32(mem->version);
> +	disk->seqno   = cpu_to_le32(mem->seqno);
> +}
> +
> +static void msb_disk_to_mem(struct msb *disk, struct msb *mem)
> +{
> +	mem->magic   = le32_to_cpu(disk->magic);
> +	mem->version = le32_to_cpu(disk->version);
> +	mem->seqno   = le32_to_cpu(disk->seqno);
> +}
> +
> +static void msb_map_region(struct dm_io_region *io,
> +			   struct msb_context *sbc,
> +			   int idx)
> +{
> +	if (check_mirror_valid(sbc->ms, idx))
> +		*io = sbc->sbd[idx].loc;
> +	else
> +		io->count = 0;
> +}
> +
> +static void msb_read(struct msb_context *sbc)
> +{
> +	struct msb_dev *sbd;
> +	int r, i;
> +
> +	sbc->io_req.bi_rw = READ;
> +
> +	for (i = 0; i < sbc->nr_sbd; i++) {
> +		if (!check_mirror_valid(sbc->ms, i))
> +			continue;
> +
> +		sbd = &sbc->sbd[i];
> +
> +		r = dm_io(&sbc->io_req, 1, &sbd->loc, NULL);
> +		if (r) {
> +			DMWARN("Failed to read mirror superblock on"
> +			       " device %s", sbd->dev->name);
> +			disable_mirror(sbc->ms, i);
> +			continue;
> +		}
> +
> +		msb_disk_to_mem(sbc->io_buf, &sbd->sb);
> +
> +		/*
> +		 * When magic or version doesn't match, the mirror
> +		 * superblock is new and needs to be initialized.
> +		 */
> +		if (sbd->sb.magic != MIRROR_SB_MAGIC ||
> +		    sbd->sb.version != MIRROR_SB_VERSION)
> +			sbd->sb.seqno = 1;
> +	}
> +}
> +
> +static void msb_update(struct msb_context *sbc)
> +{
> +	struct dm_io_region io[sbc->nr_sbd], *dest = io;
> +	unsigned long error;
> +	int i;
> +
> +retry:
> +	sbc->sb.seqno++;
> +
> +	msb_mem_to_disk(&sbc->sb, sbc->io_buf);
> +
> +	sbc->io_req.bi_rw = WRITE;
> +
> +	for (i = 0; i < sbc->nr_sbd; i++)
> +		msb_map_region(dest++, sbc, i);
> +
> +	error = 0;
> +	if (dm_io(&sbc->io_req, sbc->nr_sbd, io, &error)) {
> +		for (i = 0; i < sbc->nr_sbd; i++)
> +			if (test_bit(i, &error))
> +				disable_mirror(sbc->ms, i);
> +		/*
> +		 * When an I/O error happens on a superblock, it is
> +		 * possible that the sequence data is updated in the
> +		 * physical disk. Therefore a sequence counter needs
> +		 * to be incremented again to prevent the mirror from
> +		 * being selected as a default mirror next time.
> +		 */
> +		if (error)
> +			goto retry;
> +	}
> +}
> +
> +/*
> + * check superblock and return valid default mirror
> + */
> +static int msb_check(struct msb_context *sbc)
> +{
> +	int def_mirror = -1;
> +	int i;
> +
> +	sbc->sb.seqno = 0;
> +
> +	for (i = 0; i < sbc->nr_sbd; i++) {
> +		if (!check_mirror_valid(sbc->ms, i))
> +			continue;
> +
> +		if (sbc->sbd[i].sb.seqno > sbc->sb.seqno) {
> +			sbc->sb.seqno = sbc->sbd[i].sb.seqno;
> +			def_mirror = i;
> +		}
> +	}
> +
> +	return def_mirror;
> +}
> +
> +static void msb_update_fn(struct work_struct *work)
> +{
> +	struct msb_context *sbc =
> +		container_of(work, struct msb_context, update_work);
> +
> +	mutex_lock(&sbc->worker_lock);
> +	msb_update(sbc);
> +	unblock_write(sbc->ms);
> +	mutex_unlock(&sbc->worker_lock);
> +}
> +
> +static int create_msb_devices(struct msb_context *sbc, char **argv)
> +{
> +	unsigned long long offset;
> +	struct msb_dev *sbd;
> +	int i, r;
> +
> +	for (i = 0; i < sbc->nr_sbd; i++) {
> +		sbd = &sbc->sbd[i];
> +
> +		if (sscanf(argv[1], "%llu", &offset) != 1) {
> +			while (i--)
> +				dm_put_device(sbc->ti, sbc->sbd[i].dev);
> +
> +			sbc->ti->error = "Invalid offset";
> +			return -EINVAL;
> +		}
> +
> +		r = dm_get_device(sbc->ti, argv[0], offset,
> +				  MIRROR_SB_SECT_SIZE,
> +				  FMODE_READ | FMODE_WRITE,
> +				  &sbd->dev);
> +		if (r) {
> +			while (i--)
> +				dm_put_device(sbc->ti, sbc->sbd[i].dev);
> +
> +			sbc->ti->error = "Device lookup failure";
> +			return r;
> +		}
> +
> +		sbd->sbc = sbc;
> +
> +		sbd->sb.magic = 0;
> +		sbd->sb.version = 0;
> +		sbd->sb.seqno = 0;
> +
> +		sbd->loc.bdev = sbd->dev->bdev;
> +		sbd->loc.sector = offset;
> +		sbd->loc.count = MIRROR_SB_SECT_SIZE;
> +
> +		argv += 2;
> +	}
> +
> +	return 0;
> +}
> +
> +static void destroy_msb_devices(struct msb_context *sbc)
> +{
> +	int i;
> +
> +	for (i = 0; i < sbc->nr_sbd; i++)
> +		dm_put_device(sbc->ti, sbc->sbd[i].dev);
> +}
> +
> +/*
> + * argv: [superblock_path offset]{2,}
> + *
> + * Note: argc should be nr_mirrors * 2
> + */
> +struct msb_context *msb_create(struct dm_target *ti,
> +			       struct mirror_set *ms,
> +			       unsigned int argc, char **argv,
> +			       unsigned int nr_mirrors,
> +			       unsigned int *args_used)
> +{
> +	struct msb_context *sbc;
> +
> +	if (argc < nr_mirrors * 2) {
> +		ti->error = "Insufficient mirror sb arguments";
> +		return NULL;
> +	}
> +
> +	sbc = kzalloc(sizeof(*sbc) + sizeof(sbc->sbd[0]) * nr_mirrors,
> +		      GFP_KERNEL);
> +	if (!sbc) {
> +		ti->error = "Couldn't allocate mirror sb context";
> +		return NULL;
> +	}
> +
> +	sbc->io_buf = vmalloc(MIRROR_SB_SIZE);
> +	if (!sbc->io_buf) {
> +		ti->error = "Couldn't allocate mirror sb I/O buffer";
> +		goto err1;
> +	}
> +
> +	sbc->ti = ti;
> +	sbc->ms = ms;
> +
> +	sbc->nr_sbd = nr_mirrors;
> +
> +	mutex_init(&sbc->worker_lock);
> +	INIT_WORK(&sbc->update_work, msb_update_fn);
> +
> +	sbc->sb.magic = MIRROR_SB_MAGIC;
> +	sbc->sb.version = MIRROR_SB_VERSION;
> +	sbc->sb.seqno = 0;
> +
> +	sbc->io_req.mem.type = DM_IO_VMA;
> +	sbc->io_req.mem.ptr.vma = sbc->io_buf;
> +	sbc->io_req.notify.fn = NULL;
> +	sbc->io_req.client = dm_io_client_create(1);
> +
> +	if (IS_ERR(sbc->io_req.client)) {
> +		ti->error = "couldn't allocate disk io client";
> +		goto err2;
> +	}
> +
> +	if (create_msb_devices(sbc, argv))
> +		goto err3;
> +
> +	*args_used = nr_mirrors * 2;
> +
> +	return sbc;
> +
> +err3:
> +	dm_io_client_destroy(sbc->io_req.client);
> +err2:
> +	vfree(sbc->io_buf);
> +err1:
> +	kfree(sbc);
> +	return NULL;
> +}
> +
> +void msb_destroy(struct msb_context *sbc)
> +{
> +	destroy_msb_devices(sbc);
> +	dm_io_client_destroy(sbc->io_req.client);
> +	vfree(sbc->io_buf);
> +	kfree(sbc);
> +}
> +
> +void msb_trigger_update(struct msb_context *sbc)
> +{
> +	schedule_work(&sbc->update_work);
> +}
> +
> +/*
> + * msb_resume - read all superblocks and decide default_mirror
> + */
> +int msb_resume(struct msb_context *sbc, int *default_mirror)
> +{
> +	msb_read(sbc);
> +
> +	*default_mirror = msb_check(sbc);
> +	if (*default_mirror < 0)
> +		return -ENXIO;
> +
> +	memset(sbc->io_buf, 0, MIRROR_SB_SIZE);
> +	msb_update(sbc);
> +
> +	return 0;
> +}
> +
> +int msb_status(struct msb_context *msb, status_type_t type,
> +	       char *result, unsigned int maxlen)
> +{
> +	unsigned int i, sz = 0;
> +
> +	if (type == STATUSTYPE_TABLE) {
> +		DMEMIT("%d", msb->nr_sbd);
> +		for (i = 0; i < msb->nr_sbd; i++)
> +			DMEMIT(" %s %llu", msb->sbd[i].dev->name,
> +			       (unsigned long long)msb->sbd[i].loc.sector);
> +	}
> +
> +	return sz;
> +}
> +
> +MODULE_DESCRIPTION(DM_NAME " mirror superblock");
> +MODULE_AUTHOR("Takahiro Yasui <dm-devel@redhat.com>");
> +MODULE_LICENSE("GPL");
> Index: linux-2.6.30/drivers/md/dm-raid1-sb.h
> ===================================================================
> --- /dev/null
> +++ linux-2.6.30/drivers/md/dm-raid1-sb.h
> @@ -0,0 +1,44 @@
> +/*
> + * Device Mapper RAID1 Superblock Support
> + *
> + * Written by Takahiro Yasui <tyasui@redhat.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the
> + * Free Software Foundation; either version 2 of the License, or (at your
> + * option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, write to the Free Software Foundation, Inc.,
> + * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> + *
> + */
> +#ifndef DM_RAID1_SB_H
> +#define DM_RAID1_SB_H
> +
> +struct mirror_set;
> +struct msb_context;
> +
> +/* defined in dm-raid1-sb.c */
> +extern struct msb_context *msb_create(struct dm_target *ti,
> +				      struct mirror_set *ms,
> +				      unsigned int argc, char **argv,
> +				      unsigned int nr_mirrors,
> +				      unsigned int *args_used);
> +extern void msb_destroy(struct msb_context *sbc);
> +extern void msb_trigger_update(struct msb_context *sbc);
> +extern int msb_resume(struct msb_context *sbc, int *default_mirror);
> +extern int msb_status(struct msb_context *msb, status_type_t type,
> +		      char *result, unsigned int maxlen);
> +
> +/* defined in dm-raid1.c */
> +extern int check_mirror_valid(struct mirror_set *ms, int idx);
> +extern void disable_mirror(struct mirror_set *ms, int idx);
> +extern void unblock_write(struct mirror_set *ms);
> +
> +#endif	/* DM_RAID1_SB_H */
> Index: linux-2.6.30/drivers/md/dm-raid1.c
> ===================================================================
> --- linux-2.6.30.orig/drivers/md/dm-raid1.c
> +++ linux-2.6.30/drivers/md/dm-raid1.c
> @@ -19,6 +19,8 @@
>  #include <linux/dm-kcopyd.h>
>  #include <linux/dm-region-hash.h>
>  
> +#include "dm-raid1-sb.h"
> +
>  #define DM_MSG_PREFIX "raid1"
>  
>  #define MAX_RECOVERY 1	/* Maximum number of regions recovered in parallel. */
> @@ -26,7 +28,9 @@
>  #define DM_KCOPYD_PAGES 64
>  
>  #define DM_RAID1_HANDLE_ERRORS 0x01
> +#define DM_RAID1_USE_SUPERBLOCK 0x02
>  #define errors_handled(p)	((p)->features & DM_RAID1_HANDLE_ERRORS)
> +#define use_superblock(p)	((p)->features & DM_RAID1_USE_SUPERBLOCK)
>  
>  static DECLARE_WAIT_QUEUE_HEAD(_kmirrord_recovery_stopped);
>  
> @@ -58,6 +62,7 @@ struct mirror_set {
>  	struct bio_list writes;
>  	struct bio_list failures;
>  
> +	struct msb_context *sbc;
>  	struct dm_region_hash *rh;
>  	struct dm_kcopyd_client *kcopyd_client;
>  	struct dm_io_client *io_client;
> @@ -67,6 +72,7 @@ struct mirror_set {
>  	region_t nr_regions;
>  	int in_sync;
>  	int log_failure;
> +	atomic_t write_blocked;
>  	atomic_t suspend;
>  
>  	atomic_t default_mirror;	/* Default mirror */
> @@ -211,6 +217,11 @@ static void fail_mirror(struct mirror *m
>  	if (!errors_handled(ms))
>  		return;
>  
> +	if (use_superblock(ms) && error_type == DM_RAID1_WRITE_ERROR) {
> +		atomic_inc(&ms->write_blocked);
> +		msb_trigger_update(ms->sbc);
> +	}
> +
>  	if (m != get_default_mirror(ms))
>  		goto out;
>  
> @@ -237,6 +248,22 @@ out:
>  	schedule_work(&ms->trigger_event);
>  }
>  
> +int check_mirror_valid(struct mirror_set *ms, int idx)
> +{
> +	return atomic_read(&ms->mirror[idx].error_count) ? 0 : 1;
> +}
> +
> +void disable_mirror(struct mirror_set *ms, int idx)
> +{
> +	fail_mirror(&ms->mirror[idx], DM_RAID1_WRITE_ERROR);
> +}
> +
> +void unblock_write(struct mirror_set *ms)
> +{
> +	if (!atomic_dec_return(&ms->write_blocked))
> +		wakeup_mirrord(ms);
> +}
> +
>  /*-----------------------------------------------------------------
>   * Recovery.
>   *
> @@ -594,6 +621,13 @@ static void do_writes(struct mirror_set 
>  	if (!writes->head)
>  		return;
>  
> +	if (use_superblock(ms) && atomic_read(&ms->write_blocked)) {
> +		spin_lock_irq(&ms->lock);
> +		bio_list_merge(&ms->writes, writes);
> +		spin_unlock_irq(&ms->lock);
> +		return;
> +	}
> +
>  	/*
>  	 * Classify each write.
>  	 */
> @@ -677,6 +711,13 @@ static void do_failures(struct mirror_se
>  	if (!failures->head)
>  		return;
>  
> +	if (use_superblock(ms) && atomic_read(&ms->write_blocked)) {
> +		spin_lock_irq(&ms->lock);
> +		bio_list_merge(&ms->failures, failures);
> +		spin_unlock_irq(&ms->lock);
> +		return;
> +	}
> +
>  	if (!ms->log_failure) {
>  		while ((bio = bio_list_pop(failures))) {
>  			ms->in_sync = 0;
> @@ -783,6 +824,7 @@ static struct mirror_set *alloc_context(
>  	ms->nr_regions = dm_sector_div_up(ti->len, region_size);
>  	ms->in_sync = 0;
>  	ms->log_failure = 0;
> +	atomic_set(&ms->write_blocked, 0);
>  	atomic_set(&ms->suspend, 0);
>  	atomic_set(&ms->default_mirror, DEFAULT_MIRROR);
>  
> @@ -916,14 +958,20 @@ static int parse_features(struct mirror_
>  		return -EINVAL;
>  	}
>  
> -	if (!strcmp("handle_errors", argv[0]))
> -		ms->features |= DM_RAID1_HANDLE_ERRORS;
> -	else {
> -		ti->error = "Unrecognised feature requested";
> -		return -EINVAL;
> -	}
> +	while (num_features--) {
> +		if (!strcmp("handle_errors", argv[0]))
> +			ms->features |= DM_RAID1_HANDLE_ERRORS;
> +		else if (!strcmp("superblock", argv[0]))
> +			ms->features |= DM_RAID1_USE_SUPERBLOCK;
> +		else {
> +			ti->error = "Unrecognised feature requested";
> +			return -EINVAL;
> +		}
>  
> -	(*args_used)++;
> +		argc--;
> +		argv++;
> +		(*args_used)++;
> +	}
>  
>  	return 0;
>  }
> @@ -934,6 +982,7 @@ static int parse_features(struct mirror_
>   * log_type #log_params <log_params>
>   * #mirrors [mirror_path offset]{2,}
>   * [#features <features>]
> + * [[superblock_path offset]{2,}]
>   *
>   * log_type is "core" or "disk"
>   * #log_params is between 1 and 3
> @@ -1016,19 +1065,35 @@ static int mirror_ctr(struct dm_target *
>  	 * the sync state may be inaccurate.
>  	 */
>  
> +	if (use_superblock(ms)) {
> +		ms->sbc = msb_create(ti, ms, argc, argv, nr_mirrors,
> +				     &args_used);
> +		if (!ms->sbc) {
> +			r = -EINVAL;
> +			goto err_destroy_wq;
> +		}
> +
> +		argv += args_used;
> +		argc -= args_used;
> +	}
> +
>  	if (argc) {
> +		printk(KERN_INFO "%s: argc=%d\n", __func__, argc);
>  		ti->error = "Too many mirror arguments";
>  		r = -EINVAL;
> -		goto err_destroy_wq;
> +		goto err_msb_destroy;
>  	}
>  
>  	r = dm_kcopyd_client_create(DM_KCOPYD_PAGES, &ms->kcopyd_client);
>  	if (r)
> -		goto err_destroy_wq;
> +		goto err_msb_destroy;
>  
>  	wakeup_mirrord(ms);
>  	return 0;
>  
> +err_msb_destroy:
> +	if (use_superblock(ms))
> +		msb_destroy(ms->sbc);
>  err_destroy_wq:
>  	destroy_workqueue(ms->kmirrord_wq);
>  err_free_context:
> @@ -1043,6 +1108,8 @@ static void mirror_dtr(struct dm_target 
>  	del_timer_sync(&ms->timer);
>  	flush_workqueue(ms->kmirrord_wq);
>  	flush_scheduled_work();
> +	if (use_superblock(ms))
> +		msb_destroy(ms->sbc);
>  	dm_kcopyd_client_destroy(ms->kcopyd_client);
>  	destroy_workqueue(ms->kmirrord_wq);
>  	free_context(ms, ti, ms->nr_mirrors);
> @@ -1213,6 +1280,13 @@ static void mirror_resume(struct dm_targ
>  	struct dm_dirty_log *log = dm_rh_dirty_log(ms->rh);
>  
>  	atomic_set(&ms->suspend, 0);
> +	if (use_superblock(ms)) {
> +		int default_mirror;
> +		if (!msb_resume(ms->sbc, &default_mirror))
> +			set_default_mirror(&ms->mirror[default_mirror]);
> +		else
> +			DMWARN("could not choose default mirror");
> +	}
>  	if (log->type->resume && log->type->resume(log))
>  		/* FIXME: need better error handling */
>  		DMWARN("log resume failed");
> @@ -1276,8 +1350,14 @@ static int mirror_status(struct dm_targe
>  			DMEMIT(" %s %llu", ms->mirror[m].dev->name,
>  			       (unsigned long long)ms->mirror[m].offset);
>  
> -		if (ms->features & DM_RAID1_HANDLE_ERRORS)
> -			DMEMIT(" 1 handle_errors");
> +		if (errors_handled(ms) || use_superblock(ms))
> +			DMEMIT(" %u%s%s",
> +			       !!errors_handled(ms) + !!use_superblock(ms),
> +			       errors_handled(ms) ? " handle_errors" : "",
> +			       use_superblock(ms) ? " superblock " : "");
> +
> +		if (use_superblock(ms))
> +			sz += msb_status(ms->sbc, type, result+sz, maxlen-sz);
>  	}
>  
>  	return 0;
> 
