From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [dm-devel] [RFC] dm-bow working prototype
Date: Thu, 25 Oct 2018 14:43:57 -0700
Message-ID: <20181025214357.GD6703@magnolia>
References: <20181023212358.60292-1-paullawrence@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181023212358.60292-1-paullawrence@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Lawrence <paullawrence@google.com>
Cc: linux-raid@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Oct 23, 2018 at 02:23:28PM -0700, Paul Lawrence wrote:
> bow == backup on write
> 
> Similar to dm-snap, add the ability to take a snapshot of a device.
> Unlike dm-snap, a separate volume is not required.
> 
> dm-bow can be in one of three states.
> 
> In state one, the free blocks on the device are identified by issuing
> an FSTRIM to the filesystem.

So, uh, what happens if the filesystem is so full that you run out of
space for stashing old block contents?

Also, what happens with things like ext4 that don't send discard
requests for uninitialized blockgroups and blockgroups that haven't been
touched since the last FITRIM call?

> In state two, any writes cause the overwritten data to be backup up
> to the available free space. While in this state, the device can be
> restored by unmounting the filesystem, removing the dm-bow device
> and running a usermode tool over the underlying device.
> 
> In state three, the changes are committed, dm-bow is in pass-through
> mode and the drive can no longer be restored.
> 
> It is planned to use this driver to enable restoration of a failed
> update attempt on Android devices using ext4.
> 
> Test: Can boot Android with userdata mounted on this device. Can commit
> userdata after SUW has run. Can then reboot, make changes and roll back.
> 
> Known issues:
> 
> Recovery tool needed
> 
> Remove BUG_ONs
> 
> Assumtion is that bios are always page aligned. This is not in general
> true. Fix to work with file systems which use 1k blocks.

Or filesystems with 512b blocks?

> Mutex is held around entire flush operation, including lengthy I/O. Plan
> is to convert to state machine with pending queues.
> 
> Add a linked list of free ranges to avoid linear searches of the tree.

(Don't we usually remove linked lists to avoid linear searches?
Anyway...)

> Similarly sector0_current should be stored in bow_context. There should
> be no linear searches of the map.
> 
> Interaction with block encryption is unknown, especially with respect
> to sector 0.
> 
> Signed-off-by: Paul Lawrence <paullawrence@google.com>
> Cc: Alasdair Kergon <agk@redhat.com>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: dm-devel@redhat.com
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Shaohua Li <shli@kernel.org>
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-raid@vger.kernel.org
> 
> ---
>  Documentation/device-mapper/dm-bow.txt |  103 +++
>  drivers/md/Kconfig                     |   12 +
>  drivers/md/Makefile                    |    1 +
>  drivers/md/dm-bow.c                    | 1033 ++++++++++++++++++++++++
>  4 files changed, 1149 insertions(+)
>  create mode 100644 Documentation/device-mapper/dm-bow.txt
>  create mode 100644 drivers/md/dm-bow.c
> 
> diff --git a/Documentation/device-mapper/dm-bow.txt b/Documentation/device-mapper/dm-bow.txt
> new file mode 100644
> index 000000000000..a77d5bf8f98b
> --- /dev/null
> +++ b/Documentation/device-mapper/dm-bow.txt
> @@ -0,0 +1,103 @@
> +dm_bow (backup on write)
> +========================
> +
> +dm_bow is a device mapper driver that uses the free space on a device to back up
> +data that is overwritten. The changes can then be committed by a simple state
> +change, or rolled back by removing the dm_bow device and running a command line
> +utility over the underlying device.
> +
> +dm_bow has three states, set by writing ‘1’ or ‘2’ to /sys/block/dm-?/bow/state.
> +It is only possible to go from state 0 (initial state) to state 1, and then from
> +state 1 to state 2.
> +
> +State 0: dm_bow collects all trims to the device and assumes that these mark
> +free space on the overlying file system that can be safely used. Typically the
> +mount code would create the dm_bow device, mount the file system, call the
> +FITRIM ioctl on the file system then switch to state 1. These trims are not
> +propagated to the underlying device.
> +
> +TODO: There are some race conditions if there are writes in state 0. Test
> +mounting the drive ro and see if trims are still allowed. If that fails, test
> +holding all writes in a queue until we switch to state 1. If that fails,
> +consider implementing a ram disk type affair, which will be complex and risky.
> +
> +State 1: All writes to the device cause the underlying data to be backed up to
> +the free (trimmed) area as needed in such a way as they can be restored.
> +However, the writes, with one exception, then happen exactly as they would
> +without dm_bow, so the device is always in a good final state. The exception is
> +that sector 0 is used to keep a log of the latest changes, both to indicate that
> +we are in this state and to allow rollback. See below for all details.
> +
> +State 2: The transition to state 2 triggers replacing the special sector 0 with
> +the normal sector 0, and the freeing of all state information. dm_bow then
> +becomes a pass-through driver, allowing the device to continue to be used with
> +minimal performance impact.

What about state 3?

> +Usage
> +=====
> +dm-bow takes one command line parameter, the name of the underlying device.
> +
> +dm-bow will typically be used in the following way. dm-bow will be loaded with a
> +suitable underlying device and the resultant device will be mounted. A file
> +system trim will be issued via the FITRIM ioctl, then the device will be
> +switched to state 1. The file system will now be used as normal. At some point,
> +the changes can either be committed by switching to state 2, or rolled back by
> +unmounting the file system, removing the dm-bow device and running the command
> +line utility. Note that rebooting the device will be equivalent to unmounting
> +and removing, but the command line utility must still be run
> +
> +Details of operation in state 1
> +===============================
> +
> +dm_bow maintains a type for all sectors. A sector can be any of:
> +
> +SECTOR0
> +SECTOR0_CURRENT
> +UNCHANGED
> +FREE
> +CHANGED
> +BACKUP
> +
> +SECTOR0 is the first sector on the device, and is used to hold the log of
> +changes. This is the one exception.
> +
> +SECTOR0_CURRENT is a sector picked from the FREE sectors, and is where reads and
> +writes from the true sector zero are redirected to. Note that like any backup
> +sector, if the sector is written to directly, it must be moved again.
> +
> +UNCHANGED means that the sector has not been changed since we entered state 1.
> +Thus if it is written to or trimmed, the contents must first be backed up.
> +
> +FREE means that the sector was trimmed in state 0 and has not yet been written
> +to or used for backup. On being written to, a FREE sector is changed to CHANGED.
> +
> +CHANGED means that the sector has been modified, and can be further modified
> +without further backup.
> +
> +BACKUP means that this is a free sector being used as a backup. On being written
> +to, the contents must first be backed up again.
> +
> +All backup operations are logged to the first sector. The log sector has the
> +format:
> +--------------------------------------------------------
> +| Magic | Count | Sequence | Log entry | Log entry | …
> +--------------------------------------------------------
> +
> +Magic is a magic number. Count is the number of log entries. Sequence is 0
> +initially. A log entry is
> +
> +-----------------------------------
> +| Source | Dest | Size | Checksum |
> +-----------------------------------
> +
> +When SECTOR0 is full, the log sector is backup up and another empty log sector
> +created with sequence number one higher. The first entry in any log entry with
> +sequence > 0 therefore must be the log of the backing up of the previous log
> +sector. Note that sequence is not strictly needed, but is a useful sanity check
> +and potentially limits the time spent trying to restore a corrupted snapshot.
> +
> +On entering state 1, dm_bow has a list of free sectors. All other sectors are
> +unchanged. Sector0_current is selected from the free sectors and the contents of
> +sector 0 are copied there. The sector 0 is backed up, which triggers the first
> +log entry to be written.

Hmm.  I guess it's neat how you can discard the old fs simply by copying
the SECTOR0_CURRENT to sector 0 and exiting.

ext4 writes its superblock 512 bytes into the disk (so you can cram a
x86 boot sector and an ext4 fs into a floopy drive!) which means that a
bowed (bow'd?) block device will have both the bow log at byte offset 0
and a ext4 superblock at byte offset 512...?

> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> index 7baee86ded7c..21c95032f698 100644
> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -569,4 +569,16 @@ config DM_ANDROID_VERITY
>  	  of the metadata contents are verified against the key included
>  	  in the system keyring. Upon success, the underlying verity
>  	  target is setup.
> +
> +config DM_BOW
> +	tristate "Create a device that backs up all changes to free blocks"
> +	depends on BLK_DEV_DM
> +	---help---
> +	  This device-mapper target takes a device and keeps a log of all
> +	  changes using free blocks identified by issuing a trim command.
> +	  This can then be restored by running a command line utility,
> +	  or committed by simply replacing the target.
> +
> +	  If unsure, say N.
> +
>  endif # MD
> diff --git a/drivers/md/Makefile b/drivers/md/Makefile
> index c3bf33b35674..7503427e2f3b 100644
> --- a/drivers/md/Makefile
> +++ b/drivers/md/Makefile
> @@ -62,6 +62,7 @@ obj-$(CONFIG_DM_ERA)		+= dm-era.o
>  obj-$(CONFIG_DM_LOG_WRITES)	+= dm-log-writes.o
>  obj-$(CONFIG_DM_REQ_CRYPT)	+= dm-req-crypt.o
>  obj-$(CONFIG_DM_ANDROID_VERITY) += dm-android-verity.o
> +obj-$(CONFIG_DM_BOW)		+= dm-bow.o
>  
>  ifeq ($(CONFIG_DM_UEVENT),y)
>  dm-mod-objs			+= dm-uevent.o
> diff --git a/drivers/md/dm-bow.c b/drivers/md/dm-bow.c
> new file mode 100644
> index 000000000000..2f3d6dfd3d6b
> --- /dev/null
> +++ b/drivers/md/dm-bow.c
> @@ -0,0 +1,1033 @@
> +/*
> + * Copyright (C) 2018 Google Limited.
> + *
> + * This file is released under the GPL.
> + */
> +
> +#include "dm.h"
> +#include "dm-bufio.h"
> +#include "dm-core.h"
> +
> +#include <linux/crc32.h>
> +#include <linux/module.h>
> +
> +#define DM_MSG_PREFIX "bow"
> +#define SECTOR_SIZE 512
> +
> +struct log_entry {
> +	u64 source;
> +	u64 dest;
> +	u32 size;
> +	u32 checksum;
> +} __packed;

On-disk structure is host-endian?

--D

> +
> +struct log_sector {
> +	u32 magic;
> +	u32 count;
> +	u32 sequence;
> +	struct log_entry entries[];
> +} __packed;
> +
> +/*
> + * MAGIC is BOW in ascii
> + */
> +#define MAGIC 0x00574f42
> +
> +struct bow_range {
> +	struct rb_node		node;
> +	sector_t		sector;
> +	enum {
> +		SECTOR0,	/* First sector - holds log record */
> +		SECTOR0_CURRENT,/* Live contents of sector0 */
> +		UNCHANGED,	/* Original contents */
> +		TRIMMED,	/* Range has been trimmed */
> +		CHANGED,	/* Range has been changed */
> +		BACKUP,		/* Range is being used as a backup */
> +		TOP,		/* Final range - sector is size of device */
> +	} type;
> +};
> +
> +static const char * const readable_type[] = {
> +	"Sector0",
> +	"Sector0_current",
> +	"Unchanged",
> +	"Free",
> +	"Changed",
> +	"Backup",
> +	"Top",
> +};
> +
> +enum state {
> +	TRIM,
> +	CHECKPOINT,
> +	COMMITTED,
> +};
> +
> +struct bow_context {
> +	struct dm_dev *dev;
> +	struct workqueue_struct *workqueue;
> +	struct dm_bufio_client *bufio;
> +	struct mutex ranges_lock;
> +	struct rb_root ranges;
> +	struct dm_kobject_holder kobj_holder;	/* for sysfs attributes */
> +	atomic_t state; /* One of the enum state values above */
> +	union {
> +		u8			raw_log_sector[PAGE_SIZE];
> +		struct log_sector	log_sector;
> +	};
> +};
> +
> +sector_t range_top(struct bow_range *br)
> +{
> +	return container_of(rb_next(&br->node), struct bow_range, node)
> +		->sector;
> +}
> +
> +unsigned int range_size(struct bow_range *br)
> +{
> +	return (range_top(br) - br->sector) * SECTOR_SIZE;
> +}
> +
> +static sector_t bvec_top(struct bvec_iter *bi_iter)
> +{
> +	return bi_iter->bi_sector + bi_iter->bi_size / SECTOR_SIZE;
> +}
> +
> +static struct bow_range *find_first_overlapping_range(struct rb_root *ranges,
> +						      struct bvec_iter *bi_iter)
> +{
> +	struct rb_node *node = ranges->rb_node;
> +
> +	while (node) {
> +		struct bow_range *br;
> +
> +		br = container_of(node, struct bow_range, node);
> +		if (br->sector <= bi_iter->bi_sector
> +		    && bi_iter->bi_sector < range_top(br))
> +			return br;
> +		if (bi_iter->bi_sector < br->sector)
> +			node = node->rb_left;
> +		else
> +			node = node->rb_right;
> +	}
> +
> +	BUG_ON(true);
> +	return NULL;
> +}
> +
> +void add_before(struct rb_root *ranges, struct bow_range *new_br,
> +		struct bow_range *existing)
> +{
> +	struct rb_node *parent = &(existing->node);
> +	struct rb_node **link = &(parent->rb_left);
> +
> +	while (*link) {
> +		parent = *link;
> +		link = &((*link)->rb_right);
> +	}
> +
> +	rb_link_node(&new_br->node, parent, link);
> +	rb_insert_color(&new_br->node, ranges);
> +}
> +
> +/*
> + * Given a range br returned by find_first_overlapping_range, split br
> + * into a leading range, a range matching the bio and a trailing range.
> + * Leading and trailing may end up size 0 and will then be deleted. The
> + * new range matching the bio is then returned and should have its type
> + * and type specific fields populated.
> + * If the bio runs off the end of the range, the bio is truncated
> + * accordingly
> + */
> +static int split_range(struct rb_root *ranges, struct bow_range **br,
> +		       struct bvec_iter *bi_iter)
> +{
> +	struct bow_range *new_br;
> +
> +	BUG_ON(bi_iter->bi_sector < (*br)->sector);
> +
> +	if (bi_iter->bi_sector > (*br)->sector) {
> +		struct bow_range *leading_br =
> +			kzalloc(sizeof(*leading_br), GFP_KERNEL);
> +
> +		if (!leading_br)
> +			return -ENOMEM;
> +
> +		*leading_br = **br;
> +		add_before(ranges, leading_br, *br);
> +		(*br)->sector = bi_iter->bi_sector;
> +	}
> +
> +	if (bvec_top(bi_iter) >= range_top(*br)) {
> +		bi_iter->bi_size = (range_top(*br) - (*br)->sector)
> +					* SECTOR_SIZE;
> +		return 0;
> +	}
> +
> +	/* new_br will be the beginning, existing br will be the tail */
> +	new_br = kzalloc(sizeof(*new_br), GFP_KERNEL);
> +	if (!new_br)
> +		return -ENOMEM;
> +
> +	new_br->sector = (*br)->sector;
> +	(*br)->sector = bvec_top(bi_iter);
> +	add_before(ranges, new_br, *br);
> +	*br = new_br;
> +
> +	return 0;
> +}
> +
> +/*
> + * Sets type of a range. May merge range into surrounding ranges
> + * Since br may be invalidated, always sets br to NULL to prevent
> + * usage after this is called
> + */
> +static void set_type(struct rb_root *ranges, struct bow_range **br, int type)
> +{
> +	struct bow_range *prev = container_of(rb_prev(&(*br)->node),
> +						      struct bow_range, node);
> +	struct bow_range *next = container_of(rb_next(&(*br)->node),
> +						      struct bow_range, node);
> +
> +	(*br)->type = type;
> +
> +	if (next->type == type) {
> +		rb_erase(&next->node, ranges);
> +		kfree(next);
> +	}
> +
> +	if (prev->type == type) {
> +		rb_erase(&(*br)->node, ranges);
> +		kfree(*br);
> +	}
> +
> +	*br = NULL;
> +}
> +
> +static struct bow_range *find_free_range(struct rb_root *ranges)
> +{
> +	struct rb_node *i;
> +
> +	for (i = rb_first(ranges); i; i = rb_next(i)) {
> +		struct bow_range *br = container_of(i, struct bow_range, node);
> +
> +		if (br->type == TRIMMED)
> +			return br;
> +	}
> +
> +	DMERR("Unable to find free space to back up to");
> +	return NULL;
> +}
> +
> +static sector_t sector_to_page(sector_t sector)
> +{
> +	BUG_ON(sector % (PAGE_SIZE / SECTOR_SIZE) != 0);
> +	return sector >> (PAGE_SHIFT - SECTOR_SHIFT);
> +}
> +
> +static int copy_data(struct dm_bufio_client *bufio, struct bow_range *source,
> +		     struct bow_range *dest, u32 *checksum)
> +{
> +	int i;
> +
> +	BUG_ON(range_size(source) != range_size(dest));
> +
> +	if (checksum)
> +		*checksum = sector_to_page(source->sector);
> +
> +	for (i = 0; i < range_size(source) / PAGE_SIZE; ++i) {
> +		struct dm_buffer *read_buffer, *write_buffer;
> +		u8 *read, *write;
> +
> +		read = dm_bufio_read(bufio, sector_to_page(source->sector) + i,
> +				     &read_buffer);
> +		if (IS_ERR(read)) {
> +			DMERR("Cannot read sector");
> +			dm_bufio_release(read_buffer);
> +			return PTR_ERR(read);
> +		}
> +
> +		if (checksum)
> +			*checksum = crc32(*checksum, read, PAGE_SIZE);
> +
> +		write = dm_bufio_new(bufio, sector_to_page(dest->sector) + i,
> +				      &write_buffer);
> +		if (IS_ERR(write)) {
> +			DMERR("Cannot write sector");
> +			dm_bufio_release(write_buffer);
> +			dm_bufio_release(read_buffer);
> +			return PTR_ERR(write);
> +		}
> +
> +		memcpy(write, read, PAGE_SIZE);
> +
> +		dm_bufio_mark_buffer_dirty(write_buffer);
> +		dm_bufio_release(write_buffer);
> +		dm_bufio_release(read_buffer);
> +	}
> +
> +	dm_bufio_write_dirty_buffers(bufio);
> +	return 0;
> +}
> +
> +/****** logging functions ******/
> +
> +static int add_log_entry(struct bow_context *bc, sector_t source, sector_t dest,
> +			 unsigned int size, u32 checksum);
> +
> +static int backup_log_sector(struct bow_context *bc)
> +{
> +	struct bow_range *first_br, *free_br;
> +	struct bvec_iter bi_iter;
> +	u32 checksum;
> +	int ret;
> +
> +	first_br = container_of(rb_first(&bc->ranges), struct bow_range, node);
> +	BUG_ON(first_br->type != SECTOR0);
> +	BUG_ON(range_size(first_br) != PAGE_SIZE);
> +
> +	free_br = find_free_range(&bc->ranges);
> +	/* No space left - return this error to userspace */
> +	if (!free_br)
> +		return -ENOSPC;
> +	bi_iter.bi_sector = free_br->sector;
> +	bi_iter.bi_size = PAGE_SIZE;
> +	ret = split_range(&bc->ranges, &free_br, &bi_iter);
> +	if (ret)
> +		return ret;
> +	BUG_ON(bi_iter.bi_size != PAGE_SIZE);
> +
> +	ret = copy_data(bc->bufio, first_br, free_br, &checksum);
> +	if (ret)
> +		return ret;
> +
> +	bc->log_sector.count = 0;
> +	bc->log_sector.sequence++;
> +	ret = add_log_entry(bc, first_br->sector, free_br->sector,
> +			    range_size(first_br), checksum);
> +	if (ret)
> +		return ret;
> +
> +	set_type(&bc->ranges, &free_br, BACKUP);
> +	return 0;
> +}
> +
> +static int add_log_entry(struct bow_context *bc, sector_t source, sector_t dest,
> +			 unsigned int size, u32 checksum)
> +{
> +	struct dm_buffer *sector_buffer;
> +	u8 *sector;
> +
> +	if (sizeof(struct log_sector)
> +			+ sizeof(struct log_entry) * (bc->log_sector.count + 1)
> +		   > sizeof(bc->raw_log_sector)) {
> +		int ret = backup_log_sector(bc);
> +
> +		if (ret)
> +			return ret;
> +	}
> +
> +	bc->log_sector.entries[bc->log_sector.count].source = source;
> +	bc->log_sector.entries[bc->log_sector.count].dest = dest;
> +	bc->log_sector.entries[bc->log_sector.count].size = size;
> +	bc->log_sector.entries[bc->log_sector.count].checksum = checksum;
> +	bc->log_sector.count++;
> +
> +	sector = dm_bufio_new(bc->bufio, 0, &sector_buffer);
> +	if (IS_ERR(sector)) {
> +		DMERR("Cannot write boot sector");
> +		dm_bufio_release(sector_buffer);
> +		return -ENOSPC;
> +	}
> +	memcpy(sector, bc->raw_log_sector, PAGE_SIZE);
> +	dm_bufio_mark_buffer_dirty(sector_buffer);
> +	dm_bufio_release(sector_buffer);
> +	dm_bufio_write_dirty_buffers(bc->bufio);
> +	return 0;
> +}
> +
> +static int prepare_log(struct bow_context *bc)
> +{
> +	struct bow_range *free_br, *first_br;
> +	struct bvec_iter bi_iter;
> +	u32 checksum;
> +	int ret;
> +
> +	/* Carve out first sector as log sector */
> +	first_br = container_of(rb_first(&bc->ranges), struct bow_range, node);
> +	BUG_ON(first_br->type != UNCHANGED || range_size(first_br) < PAGE_SIZE);
> +	bi_iter.bi_sector = 0;
> +	bi_iter.bi_size = PAGE_SIZE;
> +	ret = split_range(&bc->ranges, &first_br, &bi_iter);
> +	if (ret)
> +		return ret;
> +	first_br->type = SECTOR0;
> +	BUG_ON(range_size(first_br) != PAGE_SIZE);
> +
> +	/* Find free sector for active sector0 reads/writes */
> +	free_br = find_free_range(&bc->ranges);
> +	if (!free_br)
> +		return -ENOSPC;
> +	bi_iter.bi_sector = free_br->sector;
> +	bi_iter.bi_size = PAGE_SIZE;
> +	ret = split_range(&bc->ranges, &free_br, &bi_iter);
> +	if (ret)
> +		return ret;
> +	free_br->type = SECTOR0_CURRENT;
> +
> +	/* Copy data */
> +	ret = copy_data(bc->bufio, first_br, free_br, NULL);
> +	if (ret)
> +		return ret;
> +
> +	/* Find free sector to back up first sector */
> +	free_br = find_free_range(&bc->ranges);
> +	if (!free_br)
> +		return -ENOSPC;
> +	bi_iter.bi_sector = free_br->sector;
> +	bi_iter.bi_size = PAGE_SIZE;
> +	ret = split_range(&bc->ranges, &free_br, &bi_iter);
> +	if (ret)
> +		return ret;
> +
> +	/* Back up */
> +	ret = copy_data(bc->bufio, first_br, free_br, &checksum);
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * Set up our replacement boot sector - it will get written when we
> +	 * add the first log entry, which we do immediately
> +	 */
> +	bc->log_sector.magic = MAGIC;
> +	bc->log_sector.count = 0;
> +	bc->log_sector.sequence = 0;
> +
> +	/* Add log entry */
> +	ret = add_log_entry(bc, first_br->sector, free_br->sector,
> +			    range_size(first_br), checksum);
> +	if (ret)
> +		return ret;
> +
> +	set_type(&bc->ranges, &free_br, BACKUP);
> +	return 0;
> +}
> +
> +static struct bow_range *find_sector0_current(struct bow_context *bc)
> +{
> +	struct rb_node *i;
> +
> +	for (i = rb_first(&bc->ranges); i; i = rb_next(i)) {
> +		struct bow_range *br = container_of(i, struct bow_range, node);
> +
> +		if (br->type == SECTOR0_CURRENT)
> +			return br;
> +	}
> +
> +	BUG_ON(true);
> +}
> +
> +/****** sysfs interface functions ******/
> +
> +static ssize_t state_show(struct kobject *kobj, struct kobj_attribute *attr,
> +			  char *buf)
> +{
> +	struct bow_context *bc = container_of(kobj, struct bow_context,
> +					      kobj_holder.kobj);
> +
> +	return scnprintf(buf, PAGE_SIZE, "%d\n", atomic_read(&bc->state));
> +}
> +
> +static ssize_t state_store(struct kobject *kobj, struct kobj_attribute *attr,
> +			   const char *buf, size_t count)
> +{
> +	struct bow_context *bc = container_of(kobj, struct bow_context,
> +					      kobj_holder.kobj);
> +	enum state state, original_state;
> +	int ret;
> +
> +	state = buf[0] - '0';
> +	if (state < TRIM || state > COMMITTED) {
> +		DMERR("State value %d out of range", state);
> +		return -EINVAL;
> +	}
> +
> +	mutex_lock(&bc->ranges_lock);
> +	original_state = atomic_read(&bc->state);
> +	if (state != original_state + 1) {
> +		DMERR("Invalid state change from %d to %d",
> +		      original_state, state);
> +		ret = -EINVAL;
> +		goto bad;
> +	}
> +
> +	DMINFO("Switching to state %s", state == CHECKPOINT ? "Checkpoint"
> +	       : state == COMMITTED ? "Committed" : "Unknown");
> +
> +	if (state == CHECKPOINT) {
> +		ret = prepare_log(bc);
> +		if (ret) {
> +			DMERR("Failed to switch to checkpoint state");
> +			goto bad;
> +		}
> +	} else if (state == COMMITTED) {
> +		struct bow_range *br = find_sector0_current(bc);
> +		struct bow_range *sector0_br =
> +			container_of(rb_first(&bc->ranges), struct bow_range,
> +				     node);
> +
> +		ret = copy_data(bc->bufio, br, sector0_br, 0);
> +		if (ret) {
> +			DMERR("Failed to switch to committed state");
> +			goto bad;
> +		}
> +	}
> +	atomic_inc(&bc->state);
> +	ret = count;
> +
> +bad:
> +	mutex_unlock(&bc->ranges_lock);
> +	return ret;
> +}
> +
> +static int prepare_one_range(struct bow_context *bc, struct bvec_iter *bi_iter);
> +static ssize_t write_store(struct kobject *kobj, struct kobj_attribute *attr,
> +			   const char *buf, size_t count)
> +{
> +	struct bow_context *bc = container_of(kobj, struct bow_context,
> +					      kobj_holder.kobj);
> +	sector_t sector = *(sector_t *)buf;
> +	unsigned int size = *(unsigned int *)(buf + sizeof(sector));
> +	struct bvec_iter bio_bi_iter, bi_iter;
> +	int ret, i;
> +
> +	bio_bi_iter.bi_sector = sector;
> +	bio_bi_iter.bi_size = size;
> +	bi_iter = bio_bi_iter;
> +
> +	DMINFO("Simulate Write: %lu, %u",
> +	       bio_bi_iter.bi_sector,
> +	       bio_bi_iter.bi_size);
> +
> +	mutex_lock(&bc->ranges_lock);
> +	do {
> +		ret = prepare_one_range(bc, &bi_iter);
> +		bi_iter.bi_sector += bi_iter.bi_size / SECTOR_SIZE;
> +		bi_iter.bi_size = bio_bi_iter.bi_size
> +			- (bi_iter.bi_sector - bio_bi_iter.bi_sector)
> +			  * SECTOR_SIZE;
> +	} while (!ret && bi_iter.bi_size);
> +	mutex_unlock(&bc->ranges_lock);
> +
> +	if (ret)
> +		return ret;
> +
> +	for (i = 0; i < size / PAGE_SIZE; i++) {
> +		struct dm_buffer *dm_buffer;
> +		u8 *ptr;
> +
> +		ptr = dm_bufio_new(bc->bufio, sector_to_page(sector) + i,
> +				   &dm_buffer);
> +		dm_bufio_mark_buffer_dirty(dm_buffer);
> +		dm_bufio_release(dm_buffer);
> +	}
> +	dm_bufio_write_dirty_buffers(bc->bufio);
> +
> +	return count;
> +}
> +
> +static struct kobj_attribute attr_state = __ATTR_RW(state);
> +static struct kobj_attribute attr_write = __ATTR_WO(write);
> +
> +static struct attribute *bow_attrs[] = {
> +	&attr_state.attr,
> +	&attr_write.attr,
> +	NULL
> +};
> +
> +static struct kobj_type bow_ktype = {
> +	.sysfs_ops = &kobj_sysfs_ops,
> +	.default_attrs = bow_attrs,
> +	.release = dm_kobject_release
> +};
> +
> +/****** constructor/destructor ******/
> +
> +static void dm_bow_dtr(struct dm_target *ti)
> +{
> +	struct bow_context *bc = (struct bow_context *) ti->private;
> +	struct list_head *i, *q;
> +	struct kobject *kobj;
> +
> +	while (rb_first(&bc->ranges)) {
> +		struct bow_range *br = container_of(rb_first(&bc->ranges),
> +						    struct bow_range, node);
> +
> +		rb_erase(&br->node, &bc->ranges);
> +		kfree(br);
> +	}
> +	if (bc->workqueue)
> +		destroy_workqueue(bc->workqueue);
> +	if (bc->bufio)
> +		dm_bufio_client_destroy(bc->bufio);
> +
> +	kobj = &bc->kobj_holder.kobj;
> +	if (kobj->state_initialized) {
> +		kobject_put(kobj);
> +		wait_for_completion(dm_get_completion_from_kobject(kobj));
> +	}
> +	kfree(bc);
> +}
> +
> +static int dm_bow_ctr(struct dm_target *ti, unsigned int argc, char **argv)
> +{
> +	struct bow_context *bc;
> +	struct bow_range *br;
> +	int ret;
> +	struct mapped_device *md = dm_table_get_md(ti->table);
> +
> +	if (argc != 1) {
> +		ti->error = "Invalid argument count";
> +		return -EINVAL;
> +	}
> +
> +	bc = kzalloc(sizeof(*bc), GFP_KERNEL);
> +	if (!bc) {
> +		ti->error = "Cannot allocate bow context";
> +		return -ENOMEM;
> +	}
> +
> +	ti->num_flush_bios = 1;
> +	ti->num_discard_bios = 1;
> +	ti->num_write_same_bios = 1;
> +	ti->private = bc;
> +
> +	ret = dm_get_device(ti, argv[0], dm_table_get_mode(ti->table),
> +			    &bc->dev);
> +	if (ret) {
> +		ti->error = "Device lookup failed";
> +		goto bad;
> +	}
> +
> +	init_completion(&bc->kobj_holder.completion);
> +	ret = kobject_init_and_add(&bc->kobj_holder.kobj, &bow_ktype,
> +				   &disk_to_dev(dm_disk(md))->kobj, "%s",
> +				   "bow");
> +	if (ret) {
> +		ti->error = "Cannot create sysfs node";
> +		goto bad;
> +	}
> +
> +	mutex_init(&bc->ranges_lock);
> +	bc->ranges = RB_ROOT;
> +	bc->bufio = dm_bufio_client_create(bc->dev->bdev, PAGE_SIZE, 1, 0,
> +					   NULL, NULL);
> +	if (IS_ERR(bc->bufio)) {
> +		ti->error = "Cannot initialize dm-bufio";
> +		ret = PTR_ERR(bc->bufio);
> +		bc->bufio = NULL;
> +		goto bad;
> +	}
> +
> +	bc->workqueue = alloc_workqueue("dm-bow",
> +					WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM
> +					| WQ_UNBOUND, num_online_cpus());
> +	if (!bc->workqueue) {
> +		ti->error = "Cannot allocate workqueue";
> +		ret = -ENOMEM;
> +		goto bad;
> +	}
> +
> +	br = kzalloc(sizeof(*br), GFP_KERNEL);
> +	if (!br) {
> +		ti->error = "Cannot allocate ranges";
> +		ret = -ENOMEM;
> +		goto bad;
> +	}
> +
> +	br->sector = ti->len;
> +	br->type = TOP;
> +	rb_link_node(&br->node, NULL, &bc->ranges.rb_node);
> +	rb_insert_color(&br->node, &bc->ranges);
> +
> +	br = kzalloc(sizeof(*br), GFP_KERNEL);
> +	if (!br) {
> +		ti->error = "Cannot allocate ranges";
> +		ret = -ENOMEM;
> +		goto bad;
> +	}
> +
> +	br->sector = 0;
> +	br->type = UNCHANGED;
> +	rb_link_node(&br->node, bc->ranges.rb_node,
> +		     &bc->ranges.rb_node->rb_left);
> +	rb_insert_color(&br->node, &bc->ranges);
> +
> +	ti->discards_supported = true;
> +
> +	return 0;
> +
> +bad:
> +	dm_bow_dtr(ti);
> +	return ret;
> +}
> +
> +/****** Handle writes ******/
> +
> +static int prepare_unchanged_range(struct bow_context *bc, struct bow_range *br,
> +				   struct bvec_iter *bi_iter)
> +{
> +	struct bow_range *backup_br;
> +	struct bvec_iter backup_bi;
> +	sector_t log_source, log_dest;
> +	unsigned int log_size;
> +	u32 checksum;
> +	int ret;
> +
> +	/* Find a free range */
> +	backup_br = find_free_range(&bc->ranges);
> +	if (!backup_br)
> +		return -ENOSPC;
> +
> +	/* Carve out a backup range. This may be smaller than the br given */
> +	backup_bi.bi_sector = backup_br->sector;
> +	backup_bi.bi_size = min(range_size(backup_br), bi_iter->bi_size);
> +	ret = split_range(&bc->ranges, &backup_br, &backup_bi);
> +	if (ret)
> +		return ret; /* TODO make sure structures are consistent */
> +
> +	/*
> +	 * Carve out a changed range. This will not be smaller than the backup
> +	 * br since the backup br is smaller than the source range and iterator
> +	 */
> +	bi_iter->bi_size = backup_bi.bi_size;
> +	ret = split_range(&bc->ranges, &br, bi_iter);
> +	if (ret)
> +		return ret; /* TODO make sure structures are consistent */
> +	BUG_ON(range_size(br) != range_size(backup_br));
> +
> +	/* Copy data over */
> +	ret = copy_data(bc->bufio, br, backup_br, &checksum);
> +	if (ret)
> +		return ret;
> +
> +	/* Add an entry to the log */
> +	log_source = br->sector;
> +	log_dest = backup_br->sector;
> +	log_size = range_size(br);
> +
> +	/*
> +	 * Set the types last. Note that since set_type also amalgamates ranges
> +	 * we have to be careful of the order here.
> +	 * TODO: This is brittle. Work out better solution, maybe separate
> +	 * set_type and amalgamate_ranges?
> +	 */
> +	backup_br->type = br->type == SECTOR0_CURRENT ? SECTOR0_CURRENT
> +						      : BACKUP;
> +	br->type = CHANGED;
> +
> +	set_type(&bc->ranges, &backup_br, backup_br->type);
> +	set_type(&bc->ranges, &br, br->type);
> +
> +	/*
> +	 * Actually add the log entry at the end, since adding a log can cause
> +	 * another backup, which is not safe until this one is committed
> +	 */
> +	return add_log_entry(bc, log_source, log_dest, log_size, checksum);
> +}
> +
> +static int prepare_free_range(struct bow_context *bc, struct bow_range *br,
> +			      struct bvec_iter *bi_iter)
> +{
> +	int ret;
> +
> +	ret = split_range(&bc->ranges, &br, bi_iter);
> +	if (ret)
> +		return ret;
> +	set_type(&bc->ranges, &br, CHANGED);
> +	return 0;
> +}
> +
> +static int prepare_changed_range(struct bow_context *bc, struct bow_range *br,
> +				 struct bvec_iter *bi_iter)
> +{
> +	/* Nothing to do ... */
> +	return 0;
> +}
> +
> +static int prepare_one_range(struct bow_context *bc,
> +			     struct bvec_iter *bi_iter)
> +{
> +	struct bow_range *br = find_first_overlapping_range(&bc->ranges,
> +							    bi_iter);
> +	bi_iter->bi_size = min(bi_iter->bi_size,
> +			       (unsigned int)(range_top(br)
> +					      - bi_iter->bi_sector)
> +				* SECTOR_SIZE);
> +
> +	switch (br->type) {
> +	case CHANGED:
> +		return prepare_changed_range(bc, br, bi_iter);
> +
> +	case TRIMMED:
> +		return prepare_free_range(bc, br, bi_iter);
> +
> +	case UNCHANGED:
> +	case BACKUP:
> +	case SECTOR0_CURRENT:
> +		return prepare_unchanged_range(bc, br, bi_iter);
> +
> +	case SECTOR0:	/* Handled in the dm_bow_map */
> +	case TOP:	/* Illegal - top is off the end of the device */
> +	default:
> +		BUG_ON(true);
> +	}
> +}
> +
> +struct write_work {
> +	struct work_struct work;
> +	struct bow_context *bc;
> +	struct bio *bio;
> +};
> +
> +static void bow_write(struct work_struct *work)
> +{
> +	struct write_work *ww = container_of(work, struct write_work, work);
> +	struct bow_context *bc = ww->bc;
> +	struct bio *bio = ww->bio;
> +	struct bvec_iter bi_iter = bio->bi_iter;
> +	int ret = 0;
> +
> +	kfree(ww);
> +
> +	mutex_lock(&bc->ranges_lock);
> +	do {
> +		ret = prepare_one_range(bc, &bi_iter);
> +		bi_iter.bi_sector += bi_iter.bi_size / SECTOR_SIZE;
> +		bi_iter.bi_size = bio->bi_iter.bi_size
> +			- (bi_iter.bi_sector - bio->bi_iter.bi_sector)
> +			  * SECTOR_SIZE;
> +	} while (!ret && bi_iter.bi_size);
> +
> +	mutex_unlock(&bc->ranges_lock);
> +
> +	if (!ret) {
> +		bio->bi_bdev = bc->dev->bdev;
> +		submit_bio(bio);
> +	} else {
> +		DMERR("Write failure with error %d", -ret);
> +		bio->bi_error = ret;
> +		bio_endio(bio);
> +	}
> +}
> +
> +static int queue_write(struct bow_context *bc, struct bio *bio)
> +{
> +	struct write_work *ww = kmalloc(sizeof(*ww), GFP_NOIO | __GFP_NORETRY
> +					| __GFP_NOMEMALLOC | __GFP_NOWARN);
> +	if (!ww) {
> +		DMERR("Failed to allocate write_work");
> +		return -ENOMEM;
> +	}
> +
> +	INIT_WORK(&ww->work, bow_write);
> +	ww->bc = bc;
> +	ww->bio = bio;
> +	queue_work(bc->workqueue, &ww->work);
> +	return DM_MAPIO_SUBMITTED;
> +}
> +
> +static int handle_sector0(struct bow_context *bc, struct bio *bio)
> +{
> +	int ret = DM_MAPIO_REMAPPED;
> +
> +	if (bio->bi_iter.bi_size > PAGE_SIZE) {
> +		struct bio *split = bio_split(bio,
> +					      1 << (PAGE_SHIFT - SECTOR_SHIFT),
> +					      GFP_NOIO, fs_bio_set);
> +		bio_chain(split, bio);
> +		if (bio_data_dir(split) == WRITE) {
> +			ret = queue_write(bc, split);
> +			if (ret == DM_MAPIO_SUBMITTED)
> +				ret = DM_MAPIO_REMAPPED;
> +		} else {
> +			submit_bio(split);
> +		}
> +	}
> +
> +	bio->bi_iter.bi_sector = find_sector0_current(bc)->sector;
> +	return ret;
> +}
> +
> +/****** dm interface ******/
> +
> +static int dm_bow_map(struct dm_target *ti, struct bio *bio)
> +{
> +	int ret = DM_MAPIO_REMAPPED;
> +	struct bow_context *bc = ti->private;
> +
> +	if (atomic_read(&bc->state) != COMMITTED) {
> +		enum state state;
> +
> +		mutex_lock(&bc->ranges_lock);
> +		state = atomic_read(&bc->state);
> +		if (state == TRIM && bio_op(bio) == REQ_OP_DISCARD) {
> +			struct bow_range *br;
> +
> +			DMDEBUG("Trim: %lu, %u",
> +			       bio->bi_iter.bi_sector,
> +			       bio->bi_iter.bi_size);
> +
> +			br = find_first_overlapping_range(&bc->ranges,
> +							  &bio->bi_iter);
> +
> +			/*
> +			 * TODO - we assume this will always be an unmapped
> +			 * block containing the whole bio
> +			 */
> +			BUG_ON(br->type != UNCHANGED);
> +			if (!split_range(&bc->ranges, &br, &bio->bi_iter))
> +				set_type(&bc->ranges, &br, TRIMMED);
> +			bio_endio(bio);
> +			ret = DM_MAPIO_SUBMITTED;
> +		} else if (state == CHECKPOINT) {
> +			if (bio->bi_iter.bi_sector == 0)
> +				ret = handle_sector0(bc, bio);
> +			else if (bio_data_dir(bio) == WRITE)
> +				ret = queue_write(bc, bio);
> +			else
> +				/* passthrough */;
> +		} else {
> +			/* passthrough */
> +		}
> +		mutex_unlock(&bc->ranges_lock);
> +	}
> +	if (ret == DM_MAPIO_REMAPPED)
> +		bio->bi_bdev = bc->dev->bdev;
> +	return ret;
> +}
> +
> +static void dm_bow_tablestatus(struct dm_target *ti, char *result,
> +			       unsigned int maxlen)
> +{
> +	char *end = result + maxlen;
> +	struct bow_context *bc = ti->private;
> +	struct rb_node *i;
> +
> +	if (maxlen == 0)
> +		return;
> +	result[0] = 0;
> +
> +	if (!rb_first(&bc->ranges)) {
> +		scnprintf(result, end - result, "ERROR: Empty ranges");
> +		return;
> +	}
> +
> +	if (container_of(rb_first(&bc->ranges), struct bow_range, node)
> +	    ->sector) {
> +		scnprintf(result, end - result,
> +			 "ERROR: First range does not start at sector 0");
> +		return;
> +	}
> +
> +	for (i = rb_first(&bc->ranges); i; i = rb_next(i)) {
> +		struct bow_range *br = container_of(i, struct bow_range, node);
> +
> +		result += scnprintf(result, end - result, "%s: %lu",
> +				    readable_type[br->type], br->sector);
> +		if (result >= end)
> +			return;
> +
> +		result += scnprintf(result, end - result, "\n");
> +		if (result >= end)
> +			return;
> +
> +		switch (br->type) {
> +		case TOP:
> +			if (br->sector != ti->len) {
> +				scnprintf(result, end - result,
> +					 "\nERROR: Top sector is incorrect");
> +			}
> +
> +			if (&br->node != rb_last(&bc->ranges)) {
> +				scnprintf(result, end - result,
> +					  "\nERROR: Top sector is not last");
> +			}
> +			return;
> +
> +		default:
> +			break;
> +		}
> +
> +		if (br->sector > range_top(br)) {
> +			scnprintf(result, end - result,
> +				  "\nERROR: sector too big");
> +			return;
> +		}
> +	}
> +}
> +
> +static void dm_bow_status(struct dm_target *ti, status_type_t type,
> +			  unsigned int status_flags, char *result,
> +			  unsigned int maxlen)
> +{
> +	switch (type) {
> +	case STATUSTYPE_INFO:
> +		result[0] = 0;
> +		break;
> +
> +	case STATUSTYPE_TABLE:
> +		dm_bow_tablestatus(ti, result, maxlen);
> +		break;
> +	}
> +}
> +
> +int dm_bow_prepare_ioctl(struct dm_target *ti,
> +			 struct block_device **bdev, fmode_t *mode)
> +{
> +	struct bow_context *bc = ti->private;
> +	struct dm_dev *dev = bc->dev;
> +
> +	*bdev = dev->bdev;
> +	/* Only pass ioctls through if the device sizes match exactly. */
> +	return ti->len != i_size_read(dev->bdev->bd_inode) >> SECTOR_SHIFT;
> +}
> +
> +static int dm_bow_iterate_devices(struct dm_target *ti,
> +				  iterate_devices_callout_fn fn, void *data)
> +{
> +	struct bow_context *bc = ti->private;
> +
> +	return fn(ti, bc->dev, 0, ti->len, data);
> +}
> +
> +static struct target_type bow_target = {
> +	.name   = "bow",
> +	.version = {1, 1, 1},
> +	.module = THIS_MODULE,
> +	.ctr    = dm_bow_ctr,
> +	.dtr    = dm_bow_dtr,
> +	.map    = dm_bow_map,
> +	.status = dm_bow_status,
> +	.prepare_ioctl  = dm_bow_prepare_ioctl,
> +	.iterate_devices = dm_bow_iterate_devices,
> +};
> +
> +int __init dm_bow_init(void)
> +{
> +	int r = dm_register_target(&bow_target);
> +
> +	if (r < 0)
> +		DMERR("registering bow failed %d", r);
> +	return r;
> +}
> +
> +void dm_bow_exit(void)
> +{
> +	dm_unregister_target(&bow_target);
> +}
> +
> +MODULE_LICENSE("GPL");
> +
> +module_init(dm_bow_init);
> +module_exit(dm_bow_exit);
> -- 
> 2.19.1.568.g152ad8e336-goog
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
