From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: [RFC] dm-lc target
Date: Tue, 16 Jul 2013 00:37:22 +0900
Message-ID: <CABmKtjcsZUbafxtmPb=2-Gkxz9PkFq7KVsQBqRkHduEn7aaqkw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7201987044636837253=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: koverstreet@google.com, thornber@redhat.com, sunnikrishnan@stec-inc.com
List-Id: dm-devel.ids

--===============7201987044636837253==
Content-Type: multipart/alternative; boundary=001a11c24d16f9374104e18ea250

--001a11c24d16f9374104e18ea250
Content-Type: text/plain; charset=ISO-8859-1

I propose a new DM target, dm-lc.

"lc" means Log-sturctured Caching and as the name implies
dm-lc is a caching software with only write-back mode.
It batches random writes into a big sequential write to
the cache device.

It is now under development as a
portable kernel module in my Github repo
https://github.com/akiradeveloper/dm-lc

Features:

(1) Simplicity
Since dm-lc only focuses on write-back caching,
the implementation is simpler, 3k LOC, than existing ones
such as dm-cache, bcache and enhanceIO
and thus less buggy. This is the point.
I think write-back cache software should be small and simple
because write-back cache may destroy the storage
in worst case scenario.

Stacking above the write-through/write-around mode of
existing caching software is a choice of usage.
dm-lc can co-exists with existing cache softwares.

(2) Superb Performance
Because the code is simple,
dm-lc performs better than existing ones
in random write throughput.
The benchmark is done using fio tool.
It only loses 3% throughtput compared to
cache device's sequential write throughput.
The detail is, 259MB/sec random writes by HDD+SSD
against 266MB/sec sequential write on SSD.

Plus, dm-lc is capable of 1.5GB/sec random write
throughput with a fast enough cache.
This means the code path is short and the locking is effective.

For more detail, please read
https://github.com/akiradeveloper/dm-lc/tree/develop/performance

(3) Durability for server crash
Servers sometimes crash but any data
on the storage should not be gone.
Some existing softwares have
cache metadata on memory in runtime
and lose them all in server crash.
dm-lc, as it write in log-structured manner
which means it writes metadata and data together
on the cache device, does't lose any data in such failures.

To answer to the expectation from upper layer,
dm-lc can handle REQ_FUA/REQ_FLUSH flags correctly
but not loses performance badly by lazy execution technique.

(4) Autonomous migration
The algorithm of migration or writing back
is key factor in write-back cache.
dm-lc have a userland daemon to
autonomusly turn on and off migration
according to the load of backing store.

For more detail, please read dm-lc.txt
that is now copy and paste on this mail below.

How to Taste?:
Clone the repository and follow the
"Quick Start" guideline.
It is almost automated and just 5 minutes work.
Benchmarkings and testings are prepared
in scripts and you can try them.

About Upstreaming:
Now, I think it's time to go upstreaming.
The softwares is well-tested and
shows nice performance boost in benchmarking using fio.
Merging into the mainline tree is the only way to
sophisticate the code and document more
for dm-lc at this point.

Before that, I think I need to discuss with you DM guys.
Q. Do you have some comments on the code and document?

Actually, I am not a programming newbie but
really new to Linux upstreaming community
so I have no clue to what to do next.

My plan is to first remove
all the code for version switch
and merge into some kernel tree in local, test
and then repost to this ML as a patch.
Q. What tree do I need to use for merging and testing?

Research Background:
The philosophy is based on Disk Caching Disk
http://www.ele.uri.edu/research/hpcl/DCD/DCD.html
My work is to build an efficient and thorough
implementation for Linux.

As a related work,
There is a recent study by Microsoft
"Extending SSD Lifetimes with Disk-Based Write Caches"
which is also on the philosophy of DCD.
http://research.microsoft.com/apps/pubs/default.aspx?id=115352



Belows are the 3k lines of kernel code (dm-lc.c) and document (dm-lc.txt).
The kernel code went through the checkpatch.pl and
only 17 warnings for version switch is remained at this time.

(dm-lc.c)

/*
 * dm-lc.c : Log-structured Caching for Linux.
 * Copyright (C) 2012-2013 Akira Hayakawa <ruby.wktk@gmail.com>
 *
 * This file is released under the GPL.
 */

#define DM_MSG_PREFIX "lc"

#include <linux/module.h>
#include <linux/version.h>
#include <linux/list.h>
#include <linux/slab.h>
#include <linux/mutex.h>
#include <linux/sched.h>
#include <linux/device-mapper.h>
#include <linux/dm-io.h>
#include <linux/timer.h>

/*
 * Comments are described
 * in the case the segment size order is 11
 * which means the segment size is the maxium, 1MB.
 */

/*
 * (1 << x) sector.
 * 4 <= x <= 11
 */
#define LC_SEGMENTSIZE_ORDER 11
#define NR_CACHES_INSEG ((1 << (LC_SEGMENTSIZE_ORDER - 3)) - 1)

static void *do_kmalloc_retry(size_t size, gfp_t flags, int lineno)
{
int count = 0;
void *p;

retry_alloc:
p = kmalloc(size, flags);
if (!p) {
count++;
DMERR("L.%d: fail allocation(count:%d)", lineno, count);
schedule_timeout_interruptible(msecs_to_jiffies(1));
goto retry_alloc;
}
return p;
}
#define kmalloc_retry(size, flags) do_kmalloc_retry((size), (flags),
__LINE__)

struct part {
void *memory;
};

struct arr {
struct part *parts;
size_t nr_elems;
size_t elemsize;
};

#define ALLOC_SIZE (1 << 16)
static size_t nr_elems_in_part(struct arr *arr)
{
return ALLOC_SIZE / arr->elemsize;
};

static size_t nr_parts(struct arr *arr)
{
return dm_div_up(arr->nr_elems, nr_elems_in_part(arr));
}

static struct arr *make_arr(size_t elemsize, size_t nr_elems)
{
struct arr *arr = kmalloc(sizeof(*arr), GFP_KERNEL);
arr->elemsize = elemsize;
arr->nr_elems = nr_elems;
arr->parts = kmalloc(sizeof(struct part) * nr_parts(arr), GFP_KERNEL);

size_t i;
for (i = 0; i < nr_parts(arr); i++) {
struct part *part = arr->parts + i;
part->memory = kmalloc(ALLOC_SIZE, GFP_KERNEL);
}
return arr;
}

static void kill_arr(struct arr *arr)
{
size_t i;
for (i = 0; i < nr_parts(arr); i++) {
struct part *part = arr->parts + i;
kfree(part->memory);
}
kfree(arr->parts);
kfree(arr);
}

static void *arr_at(struct arr *arr, size_t i)
{
size_t n = nr_elems_in_part(arr);
size_t j = i / n;
size_t k = i % n;
struct part *part = arr->parts + j;
return part->memory + (arr->elemsize * k);
}

static struct dm_io_client *lc_io_client;

struct safe_io {
struct work_struct work;
int err;
unsigned long err_bits;
struct dm_io_request *io_req;
struct dm_io_region *region;
unsigned num_regions;
};
static struct workqueue_struct *safe_io_wq;

static void safe_io_proc(struct work_struct *work)
{
struct safe_io *io = container_of(work, struct safe_io, work);
io->err_bits = 0;
io->err = dm_io(io->io_req, io->num_regions, io->region, &io->err_bits);
}

/*
 * dm_io wrapper.
 * @thread run operation this in other thread to avoid deadlock.
 */
static int dm_safe_io_internal(
struct dm_io_request *io_req,
struct dm_io_region *region, unsigned num_regions,
unsigned long *err_bits, bool thread, int lineno)
{
int err;
if (thread) {
struct safe_io io = {
.io_req = io_req,
.region = region,
.num_regions = num_regions,
};

INIT_WORK_ONSTACK(&io.work, safe_io_proc);

queue_work(safe_io_wq, &io.work);
flush_work(&io.work);

err = io.err;
*err_bits = io.err_bits;
} else {
err = dm_io(io_req, num_regions, region, err_bits);
}

dev_t dev = region->bdev->bd_dev;
if (err || *err_bits) {
DMERR("L.%d: io err occurs err(%d), err_bits(%lu)",
lineno, err, *err_bits);
DMERR("rw(%d), sector(%lu), dev(%u:%u)",
io_req->bi_rw, region->sector,
MAJOR(dev), MINOR(dev));
}

return err;
}
#define dm_safe_io(io_req, region, num_regions, thread) \
dm_safe_io_internal((io_req), (region), (num_regions), \
(thread), __LINE__)

static void dm_safe_io_retry_internal(
struct dm_io_request *io_req,
struct dm_io_region *region, unsigned num_regions,
bool thread, int lineno)
{
int err;
unsigned long err_bits;

int count = 0;

retry_io:
err_bits = 0;
err = dm_safe_io_internal(io_req, region, num_regions, &err_bits,
thread, lineno);

dev_t dev = region->bdev->bd_dev;
if (err || err_bits) {
count++;
DMERR("failed io count(%d)", count);

schedule_timeout_interruptible(msecs_to_jiffies(1000));
goto retry_io;
}

if (count) {
DMERR("L.%d: io has just turned fail to OK.", lineno);
DMERR("rw(%d), sector(%lu), dev(%u:%u)",
io_req->bi_rw, region->sector, MAJOR(dev), MINOR(dev));
}
}
#define dm_safe_io_retry(io_req, region, num_regions, thread) \
dm_safe_io_retry_internal((io_req), (region), \
  (num_regions), (thread), __LINE__)

/*
 * device_id = 0
 * is reserved for invalid cache block.
 */
typedef u8 device_id;

struct lc_device {
struct kobject kobj;

unsigned char migrate_threshold;

struct lc_cache *cache;

device_id id;
struct dm_dev *device;

atomic64_t nr_dirty_caches;

struct mapped_device *md;
};

/*
 * cache_id = 0
 * is reserved for no cache.
 */
typedef u8 cache_id;

/*
 * dm-lc can't manange
 * more than (1 << 8)
 * virtual devices and cache devices.
 */
#define LC_NR_SLOTS ((1 << 8) - 1)

cache_id cache_id_ptr;

struct lc_cache *lc_caches[LC_NR_SLOTS];

struct lc_device *lc_devices[LC_NR_SLOTS];

/*
 * Type for cache line index.
 *
 * dm-lc can supoort a cache device
 * with size less than 4KB * (1 << 32)
 * that is 16TB.
 * Needless to say, this is enough.
 */
typedef u32 cache_nr;

/*
 * Accounts for a 4KB cache line
 * which consists of eight sectors
 * that is managed by dirty bit for each.
 *
 * This allows partial writes
 * that frees VFS layer from
 * operating read-modify-write to
 * commit full 4KB page to block layer.
 */
struct metablock {
sector_t sector;

cache_nr idx; /* const. 4B. */

struct hlist_node ht_list;

/*
 * 8 bit flag for dirtiness
 * for each sector in cache line.
 *
 * Now we recover only dirty caches
 * in crash recovery.
 *
 * Adding recover flag
 * to recover clean caches
 * complicate the code.
 */
u8 dirty_bits;

device_id device_id;
};

static void inc_nr_dirty_caches(device_id id)
{
struct lc_device *o = lc_devices[id];
BUG_ON(!o);
atomic64_inc(&o->nr_dirty_caches);
}

static void dec_nr_dirty_caches(device_id id)
{
struct lc_device *o = lc_devices[id];
BUG_ON(!o);
atomic64_dec(&o->nr_dirty_caches);
}

struct metablock_device {
sector_t sector;
device_id device_id;

u8 dirty_bits;

u32 lap;
} __packed;

/*
 * We preallocate 64 * 1MB writebuffers and use them cyclically.
 * Dynamic allocation using kmalloc results in get_free_page path
 * that may incur page reclaim which slowdown the system.
 * This is why we statically preallocate these buffers.
 *
 * The number 64, though hueristically determined,
 * is usually enough for any workload
 * if having cache device with sufficient
 * sequential write throughput, say 100MB/s.
 */
#define NR_WB_POOL 64
struct writebuffer {
void *data;
struct completion done;
};

#define SZ_MAX (~(size_t)0) /* renamed backport */
struct segment_header {
struct metablock mb_array[NR_CACHES_INSEG];

/*
 * id is not circulated but uniformly increases.
 * id = 0 is used to tell that the segment is invalid
 * and valid id starts from 1.
 */
size_t global_id;

u8 length; /* Log length. <= NR_CACHES_INSEG */

cache_nr start_idx; /* const */
sector_t start_sector; /* const */

struct completion flush_done;

struct completion migrate_done;

spinlock_t lock;

atomic_t nr_inflight_ios;
};

#define lockseg(seg, flags) spin_lock_irqsave(&(seg)->lock, flags)
#define unlockseg(seg, flags) spin_unlock_irqrestore(&(seg)->lock, flags)

static u8 atomic_read_mb_dirtiness(struct segment_header *seg,
   struct metablock *mb)
{
u8 r;
unsigned long flags;

lockseg(seg, flags);
r = mb->dirty_bits;
unlockseg(seg, flags);

return r;
}

/* At most 4KB in total. */
struct segment_header_device {
/* --- at most512 byte for atomicity. ---*/
size_t global_id;
u8 length;
u32 lap; /* initially 0. 1 for the first lap. */
/* -----------------------*/
/* This array must locate at the tail */
struct metablock_device mbarr[NR_CACHES_INSEG];
} __packed;

struct lookup_key {
device_id device_id;
sector_t sector;
};

enum STATFLAG {
STAT_WRITE = 0,
STAT_HIT,
STAT_ON_BUFFER,
STAT_FULLSIZE,
};
#define STATLEN (1 << 4)

struct ht_head {
struct hlist_head ht_list;
};

struct lc_cache {
struct kobject kobj;

cache_id id;
struct dm_dev *device;
struct mutex io_lock;
cache_nr nr_caches; /* const */
size_t nr_segments; /* const */
struct arr *segment_header_array;

/*
 * Chained hashtable.
 */
struct arr *htable;
size_t htsize;
struct ht_head *null_head;

cache_nr cursor; /* Index that has done write */
struct segment_header *current_seg;
struct writebuffer *current_wb; /* Preallocated buffer. 1024KB */
struct writebuffer *wb_pool;

size_t last_migrated_segment_id;
size_t last_flushed_segment_id;
size_t reserving_segment_id;

/*
 * For Flush daemon
 */
spinlock_t flush_queue_lock;
struct list_head flush_queue;
struct work_struct flush_work;
wait_queue_head_t flush_wait_queue;
struct workqueue_struct *flush_wq;

/*
 * For Migration daemon
 */
bool allow_migrate;
bool force_migrate;
struct workqueue_struct *migrate_wq;
struct work_struct migrate_work;

/*
 * For migration I/O
 */
wait_queue_head_t migrate_wait_queue;
atomic_t migrate_fail_count;
atomic_t migrate_io_count;
u8 dirtiness_snapshot[NR_CACHES_INSEG];
bool migrate_dests[LC_NR_SLOTS];
void *migrate_buffer;

/*
 * For deferred flush/FUA handling.
 */
struct timer_list barrier_deadline_timer;
struct bio_list barrier_ios;
unsigned long barrier_deadline_ms;
struct work_struct barrier_deadline_work;

bool on_terminate;

atomic64_t stat[STATLEN];

unsigned long update_interval;
unsigned long commit_super_block_interval;
unsigned long flush_current_buffer_interval;
};

static void inc_stat(struct lc_cache *cache,
     int rw, bool found, bool on_buffer, bool fullsize)
{
int i = 0;
if (rw)
i |= (1 << STAT_WRITE);
if (found)
i |= (1 << STAT_HIT);
if (on_buffer)
i |= (1 << STAT_ON_BUFFER);
if (fullsize)
i |= (1 << STAT_FULLSIZE);

atomic64_t *v = &cache->stat[i];
atomic64_inc(v);
}

static void clear_stat(struct lc_cache *cache)
{
int i;
for (i = 0; i < STATLEN; i++) {
atomic64_t *v = &cache->stat[i];
atomic64_set(v, 0);
}
}

static struct metablock *mb_at(struct lc_cache *cache, cache_nr idx)
{
size_t seg_idx = idx / NR_CACHES_INSEG;
struct segment_header *seg =
arr_at(cache->segment_header_array, seg_idx);
cache_nr idx_inseg = idx % NR_CACHES_INSEG;
return seg->mb_array + idx_inseg;
}

static void mb_array_empty_init(struct lc_cache *cache)
{
size_t i;
for (i = 0; i < cache->nr_caches; i++) {
struct metablock *mb = mb_at(cache, i);
INIT_HLIST_NODE(&mb->ht_list);

mb->idx = i;
mb->dirty_bits = 0;
}
}

static void ht_empty_init(struct lc_cache *cache)
{
cache->htsize = cache->nr_caches;

size_t nr_heads = (cache->htsize + 1);
struct arr *arr = make_arr(sizeof(struct ht_head), nr_heads);

cache->htable = arr;

size_t i;
for (i = 0; i < nr_heads; i++) {
struct ht_head *hd = arr_at(arr, i);
INIT_HLIST_HEAD(&hd->ht_list);
}

/*
 * Our hashtable has one special bucket called null head.
 * A metablock is linked to the null head
 * if it is not counted in hashtable search.
 */
cache->null_head = arr_at(cache->htable, cache->htsize);

cache_nr idx;
for (idx = 0; idx < cache->nr_caches; idx++) {
struct metablock *mb = mb_at(cache, idx);
hlist_add_head(&mb->ht_list, &cache->null_head->ht_list);
}
}

static cache_nr ht_hash(struct lc_cache *cache, struct lookup_key *key)
{
return key->sector % cache->htsize;
}

static bool mb_hit(struct metablock *mb, struct lookup_key *key)
{
return (mb->sector == key->sector) && (mb->device_id == key->device_id);
}

static void ht_del(struct lc_cache *cache, struct metablock *mb)
{
hlist_del(&mb->ht_list);

struct ht_head *null_head = cache->null_head;
hlist_add_head(&mb->ht_list, &null_head->ht_list);
}

static void ht_register(struct lc_cache *cache, struct ht_head *head,
struct lookup_key *key, struct metablock *mb)
{
hlist_del(&mb->ht_list);
hlist_add_head(&mb->ht_list, &head->ht_list);

mb->device_id = key->device_id;
mb->sector = key->sector;
};

static struct metablock *ht_lookup(struct lc_cache *cache,
   struct ht_head *head, struct lookup_key *key)
{
struct metablock *found = NULL;
struct metablock *mb;

#if LINUX_VERSION_CODE >= KERNEL_VERSION(3, 9, 0)
hlist_for_each_entry(mb, &head->ht_list, ht_list)
#else
struct hlist_node *pos;
hlist_for_each_entry(mb, pos, &head->ht_list, ht_list)
#endif
{
if (mb_hit(mb, key)) {
found = mb;
break;
}
}
return found;
}

static void discard_caches_inseg(struct lc_cache *cache,
 struct segment_header *seg)
{
u8 i;
for (i = 0; i < NR_CACHES_INSEG; i++) {
struct metablock *mb = seg->mb_array + i;
ht_del(cache, mb);
}
}

static void init_segment_header_array(struct lc_cache *cache)
{
size_t nr_segments = cache->nr_segments;

cache->segment_header_array =
make_arr(sizeof(struct segment_header), nr_segments);

size_t segment_idx;
for (segment_idx = 0; segment_idx < nr_segments; segment_idx++) {
struct segment_header *seg =
arr_at(cache->segment_header_array, segment_idx);
seg->start_idx = NR_CACHES_INSEG * segment_idx;
seg->start_sector =
((segment_idx % nr_segments) + 1) *
(1 << LC_SEGMENTSIZE_ORDER);

seg->length = 0;

atomic_set(&seg->nr_inflight_ios, 0);

spin_lock_init(&seg->lock);

init_completion(&seg->flush_done);
complete_all(&seg->flush_done);

init_completion(&seg->migrate_done);
complete_all(&seg->migrate_done);
}
}

static struct segment_header *get_segment_header_by_id(struct lc_cache
*cache,
       size_t segment_id)
{
struct segment_header *r =
arr_at(cache->segment_header_array,
       (segment_id - 1) % cache->nr_segments);
return r;
}

static u32 calc_segment_lap(struct lc_cache *cache, size_t segment_id)
{
u32 a = (segment_id - 1) / cache->nr_segments;
return a + 1;
};

static sector_t calc_mb_start_sector(struct segment_header *seg,
     cache_nr mb_idx)
{
size_t k = 1 + (mb_idx % NR_CACHES_INSEG);
return seg->start_sector + (k << 3);
}

static u8 count_dirty_caches_remained(struct segment_header *seg)
{
u8 count = 0;
u8 i;
struct metablock *mb;
for (i = 0; i < seg->length; i++) {
mb = seg->mb_array + i;
if (mb->dirty_bits)
count++;
}
return count;
}

static void prepare_segment_header_device(
struct segment_header_device *dest,
struct lc_cache *cache, struct segment_header *src)
{
dest->global_id = src->global_id;
dest->length = src->length;
dest->lap = calc_segment_lap(cache, src->global_id);

u8 left = src->length - 1;
u8 right = (cache->cursor) % NR_CACHES_INSEG;
BUG_ON(left != right);

cache_nr i;
for (i = 0; i < src->length; i++) {
struct metablock *mb = src->mb_array + i;
struct metablock_device *mbdev = &dest->mbarr[i];
mbdev->device_id = mb->device_id;
mbdev->sector = mb->sector;
mbdev->dirty_bits = mb->dirty_bits;
mbdev->lap = dest->lap;
}
}

struct flush_context {
struct list_head flush_queue;
struct segment_header *seg;
struct writebuffer *wb;
struct bio_list barrier_ios;
};

static void flush_proc(struct work_struct *work)
{
unsigned long flags;
struct lc_cache *cache =
container_of(work, struct lc_cache, flush_work);

while (true) {
spin_lock_irqsave(&cache->flush_queue_lock, flags);
while (list_empty(&cache->flush_queue)) {
spin_unlock_irqrestore(&cache->flush_queue_lock, flags);
wait_event_interruptible_timeout(
cache->flush_wait_queue,
(!list_empty(&cache->flush_queue)),
msecs_to_jiffies(100));
spin_lock_irqsave(&cache->flush_queue_lock, flags);

if (cache->on_terminate)
return;
}

/* Pop the first entry */
struct flush_context *ctx;
ctx = list_first_entry(
&cache->flush_queue, struct flush_context, flush_queue);
list_del(&ctx->flush_queue);
spin_unlock_irqrestore(&cache->flush_queue_lock, flags);

struct segment_header *seg = ctx->seg;

struct dm_io_request io_req = {
.client = lc_io_client,
.bi_rw = WRITE,
.notify.fn = NULL,
.mem.type = DM_IO_KMEM,
.mem.ptr.addr = ctx->wb->data,
};
struct dm_io_region region = {
.bdev = cache->device->bdev,
.sector = seg->start_sector,
.count = (seg->length + 1) << 3,
};
dm_safe_io_retry(&io_req, &region, 1, false);

cache->last_flushed_segment_id = seg->global_id;

complete_all(&seg->flush_done);

complete_all(&ctx->wb->done);

if (!bio_list_empty(&ctx->barrier_ios)) {
blkdev_issue_flush(cache->device->bdev, GFP_NOIO, NULL);
struct bio *bio;
while ((bio = bio_list_pop(&ctx->barrier_ios)))
bio_endio(bio, 0);

mod_timer(&cache->barrier_deadline_timer,
  msecs_to_jiffies(cache->barrier_deadline_ms));
}

kfree(ctx);
}
}

static void prepare_meta_writebuffer(void *writebuffer, struct lc_cache
*cache,
     struct segment_header *seg)
{
prepare_segment_header_device(writebuffer, cache, seg);
}

static void queue_flushing(struct lc_cache *cache)
{
unsigned long flags;
struct segment_header *current_seg = cache->current_seg;

size_t n1 = 0;
while (atomic_read(&current_seg->nr_inflight_ios)) {
n1++;
if (n1 == 100)
DMWARN(
"Too long to wait for current_seg ios to finish.");
schedule_timeout_interruptible(msecs_to_jiffies(1));
}

prepare_meta_writebuffer(cache->current_wb->data, cache,
 cache->current_seg);

INIT_COMPLETION(current_seg->migrate_done);
INIT_COMPLETION(current_seg->flush_done);

struct flush_context *ctx = kmalloc_retry(sizeof(*ctx), GFP_NOIO);
INIT_LIST_HEAD(&ctx->flush_queue);
ctx->seg = current_seg;
ctx->wb = cache->current_wb;

bio_list_init(&ctx->barrier_ios);
bio_list_merge(&ctx->barrier_ios, &cache->barrier_ios);
bio_list_init(&cache->barrier_ios);

spin_lock_irqsave(&cache->flush_queue_lock, flags);
bool empty = list_empty(&cache->flush_queue);
list_add_tail(&ctx->flush_queue, &cache->flush_queue);
spin_unlock_irqrestore(&cache->flush_queue_lock, flags);
if (empty)
wake_up_interruptible(&cache->flush_wait_queue);

size_t next_id = current_seg->global_id + 1;
struct segment_header *new_seg =
get_segment_header_by_id(cache, next_id);
new_seg->global_id = next_id;

size_t n2 = 0;
while (atomic_read(&new_seg->nr_inflight_ios)) {
n2++;
if (n2 == 100)
DMWARN(
"Too long to wait for new_seg ios to finish.");
schedule_timeout_interruptible(msecs_to_jiffies(1));
}

u8 nr_new = count_dirty_caches_remained(new_seg);
BUG_ON(nr_new);

discard_caches_inseg(cache, new_seg);

/* Set the cursor to the last of the flushed segment. */
cache->cursor = current_seg->start_idx + (NR_CACHES_INSEG - 1);
new_seg->length = 0;

struct writebuffer *next_wb = cache->wb_pool + (next_id % NR_WB_POOL);
wait_for_completion(&next_wb->done);
INIT_COMPLETION(next_wb->done);

cache->current_wb = next_wb;

cache->current_seg = new_seg;
}

static void migrate_mb(
struct lc_cache *cache, struct segment_header *seg,
struct metablock *mb, u8 dirty_bits, bool thread)
{
struct lc_device *lc = lc_devices[mb->device_id];

if (!dirty_bits)
return;

if (dirty_bits == 255) {
void *buf = kmalloc_retry(1 << 12, GFP_NOIO);

struct dm_io_request io_req_r = {
.client = lc_io_client,
.bi_rw = READ,
.notify.fn = NULL,
.mem.type = DM_IO_KMEM,
.mem.ptr.addr = buf,
};
struct dm_io_region region_r = {
.bdev = cache->device->bdev,
.sector = calc_mb_start_sector(seg, mb->idx),
.count = (1 << 3),
};
dm_safe_io_retry(&io_req_r, &region_r, 1, thread);

struct dm_io_request io_req_w = {
.client = lc_io_client,
.bi_rw = WRITE_FUA,
.notify.fn = NULL,
.mem.type = DM_IO_KMEM,
.mem.ptr.addr = buf,
};
struct dm_io_region region_w = {
.bdev = lc->device->bdev,
.sector = mb->sector,
.count = (1 << 3),
};
dm_safe_io_retry(&io_req_w, &region_w, 1, thread);

kfree(buf);
} else {
void *buf = kmalloc_retry(1 << SECTOR_SHIFT, GFP_NOIO);
size_t i;
for (i = 0; i < 8; i++) {
bool bit_on = dirty_bits & (1 << i);
if (!bit_on)
continue;

struct dm_io_request io_req_r = {
.client = lc_io_client,
.bi_rw = READ,
.notify.fn = NULL,
.mem.type = DM_IO_KMEM,
.mem.ptr.addr = buf,
};
/* A tmp variable just to avoid 80 cols rule */
sector_t src = calc_mb_start_sector(seg, mb->idx) + i;
struct dm_io_region region_r = {
.bdev = cache->device->bdev,
.sector = src,
.count = 1,
};
dm_safe_io_retry(&io_req_r, &region_r, 1, thread);

struct dm_io_request io_req_w = {
.client = lc_io_client,
.bi_rw = WRITE,
.notify.fn = NULL,
.mem.type = DM_IO_KMEM,
.mem.ptr.addr = buf,
};
struct dm_io_region region_w = {
.bdev = lc->device->bdev,
.sector = mb->sector + 1 * i,
.count = 1,
};
dm_safe_io_retry(&io_req_w, &region_w, 1, thread);
}
kfree(buf);
}
}

static void migrate_endio(unsigned long error, void *__context)
{
struct lc_cache *cache = __context;

if (error)
atomic_inc(&cache->migrate_fail_count);

if (atomic_dec_and_test(&cache->migrate_io_count))
wake_up_interruptible(&cache->migrate_wait_queue);
}

static void migrate_whole_segment(struct lc_cache *cache,
  struct segment_header *seg)
{
struct dm_io_request io_req_r = {
.client = lc_io_client,
.bi_rw = READ,
.notify.fn = NULL,
.mem.type = DM_IO_KMEM,
.mem.ptr.addr = cache->migrate_buffer,
};
struct dm_io_region region_r = {
.bdev = cache->device->bdev,
.sector = seg->start_sector,
.count = (seg->length + 1) << 3,
};
dm_safe_io_retry(&io_req_r, &region_r, 1, false);

migrate_write:
;
unsigned long flags;
struct metablock *mb;
u8 i, j;

atomic_set(&cache->migrate_io_count, 0);
atomic_set(&cache->migrate_fail_count, 0);

for (i = 0; i < LC_NR_SLOTS; i++)
*(cache->migrate_dests + i) = false;

for (i = 0; i < seg->length; i++) {
mb = seg->mb_array + i;
*(cache->dirtiness_snapshot + i) =
atomic_read_mb_dirtiness(seg, mb);
}

for (i = 0; i < seg->length; i++) {
mb = seg->mb_array + i;

u8 dirty_bits = *(cache->dirtiness_snapshot + i);

if (!dirty_bits)
continue;

*(cache->migrate_dests + mb->device_id) = true;

if (dirty_bits == 255) {
atomic_inc(&cache->migrate_io_count);
} else {
for (j = 0; j < 8; j++) {
if (dirty_bits & (1 << j))
atomic_inc(&cache->migrate_io_count);
}
}
}

struct lc_device *lc;
for (i = 0; i < seg->length; i++) {
mb = seg->mb_array + i;

lc = lc_devices[mb->device_id];
u8 dirty_bits = *(cache->dirtiness_snapshot + i);

if (!dirty_bits)
continue;

unsigned long diff = ((1 + i) << 3) << SECTOR_SHIFT;
void *base = cache->migrate_buffer + diff;

void *addr;
if (dirty_bits == 255) {
addr = base;
struct dm_io_request io_req_w = {
.client = lc_io_client,
.bi_rw = WRITE,
.notify.fn = migrate_endio,
.notify.context = cache,
.mem.type = DM_IO_KMEM,
.mem.ptr.addr = addr,
};
struct dm_io_region region_w = {
.bdev = lc->device->bdev,
.sector = mb->sector,
.count = (1 << 3),
};
dm_safe_io_retry(&io_req_w, &region_w, 1, false);
} else {
for (j = 0; j < 8; j++) {
bool b = dirty_bits & (1 << j);
if (!b)
continue;

addr = base + (j << SECTOR_SHIFT);
struct dm_io_request io_req_w = {
.client = lc_io_client,
.bi_rw = WRITE,
.notify.fn = migrate_endio,
.notify.context = cache,
.mem.type = DM_IO_KMEM,
.mem.ptr.addr = addr,
};
struct dm_io_region region_w = {
.bdev = lc->device->bdev,
.sector = mb->sector + j,
.count = 1,
};
dm_safe_io_retry(
&io_req_w, &region_w, 1, false);
}
}
}

wait_event_interruptible(cache->migrate_wait_queue,
 (atomic_read(&cache->migrate_io_count) == 0));

if (atomic_read(&cache->migrate_fail_count)) {
DMERR("migrate failed. %u writebacks failed. redo.",
atomic_read(&cache->migrate_fail_count));
goto migrate_write;
}

BUG_ON(atomic_read(&cache->migrate_io_count));

for (i = 0; i < seg->length; i++) {
mb = seg->mb_array + i;

bool b = false;
lockseg(seg, flags);
if (mb->dirty_bits) {
mb->dirty_bits = 0;
b = true;
}
unlockseg(seg, flags);

if (b)
dec_nr_dirty_caches(mb->device_id);
}

for (i = 1; i < LC_NR_SLOTS; i++) {
bool b = *(cache->migrate_dests + i);
if (!b)
continue;

lc = lc_devices[i];
blkdev_issue_flush(lc->device->bdev, GFP_NOIO, NULL);
}

/*
 * Discarding the migrated regions
 * can avoid unnecessary wear amplifier in the future.
 * But note that we should not discard
 * the metablock region because
 * it varies across flash devices whether to ensure
 * the discarded block returns certain value
 * and discarding the metablock may lead to
 * integrity collapsion.
 */
blkdev_issue_discard(
cache->device->bdev,
seg->start_sector + (1 << 3),
seg->length << 3,
GFP_NOIO, 0);
}

static void migrate_proc(struct work_struct *work)
{
struct lc_cache *cache =
container_of(work, struct lc_cache, migrate_work);

while (true) {
if (cache->on_terminate)
return;

/*
 * reserving_id > 0 means
 * that migration is immediate.
 */
bool allow_migrate =
cache->reserving_segment_id || cache->allow_migrate;

if (!allow_migrate) {
schedule_timeout_interruptible(msecs_to_jiffies(1000));
continue;
}

bool need_migrate =
(cache->last_migrated_segment_id <
 cache->last_flushed_segment_id);

if (!need_migrate) {
schedule_timeout_interruptible(msecs_to_jiffies(1000));
continue;
}

struct segment_header *seg =
get_segment_header_by_id(cache,
cache->last_migrated_segment_id + 1);

migrate_whole_segment(cache, seg);

/*
 * (Locking)
 * Only this line alter last_migrate_segment_id in runtime.
 */
cache->last_migrated_segment_id++;

complete_all(&seg->migrate_done);
}
}

static void wait_for_migration(struct lc_cache *cache, size_t id)
{
struct segment_header *seg = get_segment_header_by_id(cache, id);

cache->reserving_segment_id = id;
wait_for_completion(&seg->migrate_done);
cache->reserving_segment_id = 0;
}

struct superblock_device {
size_t last_migrated_segment_id;
} __packed;

static void commit_super_block(struct lc_cache *cache)
{
struct superblock_device o;

o.last_migrated_segment_id = cache->last_migrated_segment_id;

void *buf = kmalloc_retry(1 << SECTOR_SHIFT, GFP_NOIO);
memcpy(buf, &o, sizeof(o));

struct dm_io_request io_req = {
.client = lc_io_client,
.bi_rw = WRITE_FUA,
.notify.fn = NULL,
.mem.type = DM_IO_KMEM,
.mem.ptr.addr = buf,
};
struct dm_io_region region = {
.bdev = cache->device->bdev,
.sector = 0,
.count = 1,
};
dm_safe_io_retry(&io_req, &region, 1, true);
kfree(buf);
}

static void read_superblock_device(struct superblock_device *dest,
   struct lc_cache *cache)
{
void *buf = kmalloc(1 << SECTOR_SHIFT, GFP_KERNEL);
struct dm_io_request io_req = {
.client = lc_io_client,
.bi_rw = READ,
.notify.fn = NULL,
.mem.type = DM_IO_KMEM,
.mem.ptr.addr = buf,
};
struct dm_io_region region = {
.bdev = cache->device->bdev,
.sector = 0,
.count = 1,
};
dm_safe_io_retry(&io_req, &region, 1, true);
memcpy(dest, buf, sizeof(*dest));
kfree(buf);
}

static sector_t calc_segment_header_start(size_t segment_idx)
{
return (1 << LC_SEGMENTSIZE_ORDER) * (segment_idx + 1);
}

static void read_segment_header_device(
struct segment_header_device *dest,
struct lc_cache *cache, size_t segment_idx)
{
void *buf = kmalloc(1 << 12, GFP_KERNEL);
struct dm_io_request io_req = {
.client = lc_io_client,
.bi_rw = READ,
.notify.fn = NULL,
.mem.type = DM_IO_KMEM,
.mem.ptr.addr = buf,
};
struct dm_io_region region = {
.bdev = cache->device->bdev,
.sector = calc_segment_header_start(segment_idx),
.count = (1 << 3),
};
dm_safe_io_retry(&io_req, &region, 1, true);
memcpy(dest, buf, sizeof(*dest));
kfree(buf);
}

static void update_by_segment_header_device(struct lc_cache *cache,
    struct segment_header_device *src)
{
struct segment_header *seg =
get_segment_header_by_id(cache, src->global_id);
seg->length = src->length;

INIT_COMPLETION(seg->migrate_done);

cache_nr i;
for (i = 0 ; i < src->length; i++) {
struct metablock *mb = seg->mb_array + i;

struct metablock_device *mbdev = &src->mbarr[i];

if (!mbdev->dirty_bits)
continue;

mb->sector = mbdev->sector;
mb->device_id = mbdev->device_id;
mb->dirty_bits = mbdev->dirty_bits;

inc_nr_dirty_caches(mb->device_id);

struct lookup_key key = {
.device_id = mb->device_id,
.sector = mb->sector,
};

cache_nr k = ht_hash(cache, &key);
struct ht_head *head = arr_at(cache->htable, k);

struct metablock *found = ht_lookup(cache, head, &key);
if (found)
ht_del(cache, found);
ht_register(cache, head, &key, mb);
}
}

static bool checkup_atomicity(struct segment_header_device *header)
{
size_t i;
struct metablock_device *o;
for (i = 0; i < header->length; i++) {
o = header->mbarr + i;
if (o->lap != header->lap)
return false;
}
return true;
}


static void recover_cache(struct lc_cache *cache)
{
struct superblock_device sup;
read_superblock_device(&sup, cache);

size_t i;
size_t nr_segments = cache->nr_segments;

struct segment_header_device *header =
kmalloc(sizeof(*header), GFP_KERNEL);

/*
 * Finding the oldest, non-zero id and its index.
 */

size_t max_id = SZ_MAX; /* This global_id is forbidden. */
size_t oldest_id = max_id;
size_t oldest_idx = 0;
for (i = 0; i < nr_segments; i++) {
read_segment_header_device(header, cache, i);

if (header->global_id < 1)
continue;

if (header->global_id < oldest_id) {
oldest_idx = i;
oldest_id = header->global_id;
}
}

size_t last_flushed_id = 0;

/*
 * This is an invariant.
 * We always start from the segment
 * that is right after the last_flush_id.
 */
size_t init_segment_id = last_flushed_id + 1;

/*
 * If no segment was flushed
 * then there is nothing to recover.
 */
if (oldest_id == max_id)
goto setup_init_segment;

/*
 * What we have to do in the next loop is to
 * reincarnate the segments that are
 * flushed but yet not migrated.
 */

/*
 * Example:
 * There are only 5 segments.
 * The segments we will consider is of id k+2 and k+3.
 *
 * id: [   k+3   ][    k+4   ][     k     ][   k+1    ][   K+2   ]
 *       flushed    init_seg    last         migrated    flushed
 *                              _migrated
 */
size_t j;
for (i = oldest_idx; i < (nr_segments + oldest_idx); i++) {
j = i % nr_segments;
read_segment_header_device(header, cache, j);

/*
 * global_id must uniformly increase from 1.
 * Since last_flush_id is 0 at first,
 * if global_id is 0,
 * we consider this and the subsequents
 * are all invalid.
 */
if (header->global_id <= last_flushed_id)
break;

if (!checkup_atomicity(header))
break;

/*
 * Now the header is proven valid.
 */

last_flushed_id = header->global_id;
init_segment_id = last_flushed_id + 1;

/*
 * If the data is already on the backing store,
 * we ignore the segment.
 */
if (header->global_id <= sup.last_migrated_segment_id)
continue;

/*
 * Only those to be migrated are counted in.
 * These segments will not be available until migrated.
 */
update_by_segment_header_device(cache, header);
}

setup_init_segment:
kfree(header);

struct segment_header *seg =
get_segment_header_by_id(cache, init_segment_id);
seg->global_id = init_segment_id;
atomic_set(&seg->nr_inflight_ios, 0);

cache->last_flushed_segment_id = seg->global_id - 1;

cache->last_migrated_segment_id =
cache->last_flushed_segment_id > cache->nr_segments ?
cache->last_flushed_segment_id - cache->nr_segments : 0;

if (sup.last_migrated_segment_id > cache->last_migrated_segment_id)
cache->last_migrated_segment_id = sup.last_migrated_segment_id;

wait_for_migration(cache, seg->global_id);

discard_caches_inseg(cache, seg);

/*
 * cursor is set to the first element of the segment.
 * This means that we will not use the element.
 * I believe this is the simplest implementation.
 */
cache->cursor = seg->start_idx;
seg->length = 1;

cache->current_seg = seg;
}

static sector_t dm_devsize(struct dm_dev *dev)
{
return i_size_read(dev->bdev->bd_inode) >> SECTOR_SHIFT;
}

static size_t calc_nr_segments(struct dm_dev *dev)
{
sector_t devsize = dm_devsize(dev);

/*
 * disk format:
 * superblock(512B/1024KB) [segment(1024KB)]+
 * We reserve the first segment (1MB) as the superblock.
 *
 * segment:
 * segment_header(4KB) metablock(4KB)*NR_CACHES_INSEG
 */
return devsize / (1 << LC_SEGMENTSIZE_ORDER) - 1;
}

struct format_segmd_context {
atomic64_t count;
};

static void format_segmd_endio(unsigned long error, void *__context)
{
struct format_segmd_context *context = __context;
atomic64_dec(&context->count);
}

static void format_cache_device(struct dm_dev *dev)
{
size_t nr_segments = calc_nr_segments(dev);
void *buf;

buf = kzalloc(1 << SECTOR_SHIFT, GFP_KERNEL);
struct dm_io_request io_req_sup = {
.client = lc_io_client,
.bi_rw = WRITE_FUA,
.notify.fn = NULL,
.mem.type = DM_IO_KMEM,
.mem.ptr.addr = buf,
};
struct dm_io_region region_sup = {
.bdev = dev->bdev,
.sector = 0,
.count = 1,
};
dm_safe_io_retry(&io_req_sup, &region_sup, 1, false);
kfree(buf);

struct format_segmd_context context;
atomic64_set(&context.count, nr_segments);

size_t i;
buf = kzalloc(1 << 12, GFP_KERNEL);
for (i = 0; i < nr_segments; i++) {
struct dm_io_request io_req_seg = {
.client = lc_io_client,
.bi_rw = WRITE,
.notify.fn = format_segmd_endio,
.notify.context = &context,
.mem.type = DM_IO_KMEM,
.mem.ptr.addr = buf,
};
struct dm_io_region region_seg = {
.bdev = dev->bdev,
.sector = calc_segment_header_start(i),
.count = (1 << 3),
};
dm_safe_io_retry(&io_req_seg, &region_seg, 1, false);
}
kfree(buf);

while (atomic64_read(&context.count))
schedule_timeout_interruptible(msecs_to_jiffies(100));

blkdev_issue_flush(dev->bdev, GFP_KERNEL, NULL);
}

static bool is_on_buffer(struct lc_cache *cache, cache_nr mb_idx)
{
cache_nr start = cache->current_seg->start_idx;
if (mb_idx < start)
return false;

if (mb_idx >= (start + NR_CACHES_INSEG))
return false;

return true;
}

static void bio_remap(struct bio *bio, struct dm_dev *dev, sector_t sector)
{
bio->bi_bdev = dev->bdev;
bio->bi_sector = sector;
}

static sector_t calc_cache_alignment(struct lc_cache *cache,
     sector_t bio_sector)
{
return (bio_sector / (1 << 3)) * (1 << 3);
}

static void migrate_buffered_mb(struct lc_cache *cache,
struct metablock *mb, u8 dirty_bits)
{
u8 k = 1 + (mb->idx % NR_CACHES_INSEG);
sector_t offset = (k << 3);

u8 i;
void *buf = kmalloc_retry(1 << SECTOR_SHIFT, GFP_NOIO);
for (i = 0; i < 8; i++) {
bool bit_on = dirty_bits & (1 << i);
if (!bit_on)
continue;

void *src = cache->current_wb->data +
((offset + i) << SECTOR_SHIFT);
memcpy(buf, src, 1 << SECTOR_SHIFT);

struct dm_io_request io_req = {
.client = lc_io_client,
.bi_rw = WRITE_FUA,
.notify.fn = NULL,
.mem.type = DM_IO_KMEM,
.mem.ptr.addr = buf,
};

struct lc_device *lc = lc_devices[mb->device_id];
sector_t dest = mb->sector + 1 * i;
struct dm_io_region region = {
.bdev = lc->device->bdev,
.sector = dest,
.count = 1,
};

dm_safe_io_retry(&io_req, &region, 1, true);
}
kfree(buf);
}

static void queue_current_buffer(struct lc_cache *cache)
{
/*
 * Before we get the next segment
 * We must wait until the segment is all clean.
 * A clean segment desn't have
 * log to flush and dirties to migrate.
 */
size_t next_id = cache->current_seg->global_id + 1;

struct segment_header *next_seg =
get_segment_header_by_id(cache, next_id);

wait_for_completion(&next_seg->flush_done);

wait_for_migration(cache, next_id);

queue_flushing(cache);
}

static void flush_current_buffer_sync(struct lc_cache *cache)
{
mutex_lock(&cache->io_lock);
struct segment_header *old_seg = cache->current_seg;

queue_current_buffer(cache);
cache->cursor = (cache->cursor + 1) % cache->nr_caches;
cache->current_seg->length = 1;
mutex_unlock(&cache->io_lock);

wait_for_completion(&old_seg->flush_done);
}

static void flush_barrier_ios(struct work_struct *work)
{
struct lc_cache *cache =
container_of(work, struct lc_cache,
     barrier_deadline_work);

if (bio_list_empty(&cache->barrier_ios))
return;

flush_current_buffer_sync(cache);
}

static void barrier_deadline_proc(unsigned long data)
{
struct lc_cache *cache = (struct lc_cache *) data;
schedule_work(&cache->barrier_deadline_work);
}

static void queue_barrier_io(struct lc_cache *cache, struct bio *bio)
{
mutex_lock(&cache->io_lock);
bio_list_add(&cache->barrier_ios, bio);
mutex_unlock(&cache->io_lock);

if (!timer_pending(&cache->barrier_deadline_timer))
mod_timer(&cache->barrier_deadline_timer,
  msecs_to_jiffies(cache->barrier_deadline_ms));
}

#define PER_BIO_VERSION KERNEL_VERSION(3, 8, 0)
#if LINUX_VERSION_CODE >= PER_BIO_VERSION
struct per_bio_data {
void *ptr;
};
#endif

static int lc_map(struct dm_target *ti, struct bio *bio
#if LINUX_VERSION_CODE < PER_BIO_VERSION
, union map_info *map_context
#endif
)
{
struct lc_device *lc = ti->private;
struct dm_dev *orig = lc->device;

if (!lc->cache) {
bio_remap(bio, orig, bio->bi_sector);
return DM_MAPIO_REMAPPED;
}

/*
 * We only discard the backing store.
 * 1. 3.4 kernel doesn't support split_discard_requests.
 *    Hence, it is close to impossible to discard blocks on cache.
 * 2. Discarding the blocks on cache is meaningless.
 *    Because they will be overwritten eventually.
 */
if (bio->bi_rw & REQ_DISCARD) {
bio_remap(bio, orig, bio->bi_sector);
return DM_MAPIO_REMAPPED;
}

struct lc_cache *cache = lc->cache;

if (bio->bi_rw & REQ_FLUSH) {
BUG_ON(bio->bi_size);
queue_barrier_io(cache, bio);
return DM_MAPIO_SUBMITTED;
}

unsigned long flags;

#if LINUX_VERSION_CODE >= PER_BIO_VERSION
struct per_bio_data *map_context =
dm_per_bio_data(bio, ti->per_bio_data_size);
#endif
map_context->ptr = NULL;

sector_t bio_count = bio->bi_size >> SECTOR_SHIFT;
bool bio_fullsize = (bio_count == (1 << 3));
sector_t bio_offset = bio->bi_sector % (1 << 3);

int rw = bio_data_dir(bio);

struct lookup_key key = {
.sector = calc_cache_alignment(cache, bio->bi_sector),
.device_id = lc->id,
};

cache_nr k = ht_hash(cache, &key);
struct ht_head *head = arr_at(cache->htable, k);

struct segment_header *seg;
struct metablock *mb;

mutex_lock(&cache->io_lock);
mb = ht_lookup(cache, head, &key);
if (mb) {
seg = ((void *) mb) - ((mb->idx % NR_CACHES_INSEG) *
       sizeof(struct metablock));
atomic_inc(&seg->nr_inflight_ios);
}

bool found = (mb != NULL);
bool on_buffer = false;
if (found)
on_buffer = is_on_buffer(cache, mb->idx);

inc_stat(cache, rw, found, on_buffer, bio_fullsize);

if (!rw) {
mutex_unlock(&cache->io_lock);

if (!found) {
bio_remap(bio, orig, bio->bi_sector);
return DM_MAPIO_REMAPPED;
}

u8 dirty_bits = atomic_read_mb_dirtiness(seg, mb);

if (unlikely(on_buffer)) {

if (dirty_bits)
migrate_buffered_mb(cache, mb, dirty_bits);

/*
 * Dirtiness of a live cache
 *
 * We can assume dirtiness of a cache only increase
 * when it is on the buffer, we call this cache is live.
 * This eases the locking because
 * we don't worry the dirtiness of
 * a live cache fluctuates.
 */

atomic_dec(&seg->nr_inflight_ios);
bio_remap(bio, orig, bio->bi_sector);
return DM_MAPIO_REMAPPED;
}

wait_for_completion(&seg->flush_done);
if (likely(dirty_bits == 255)) {
bio_remap(
bio, cache->device,
calc_mb_start_sector(seg, mb->idx)
+ bio_offset);
map_context->ptr = seg;
} else {

/*
 * Dirtiness of a stable cache
 *
 * Unlike the live caches doesn't
 * fluctuate the dirtiness,
 * stable caches which is not on the buffer
 * but on the cache device
 * may decrease the dirtiness by other processes
 * other than the migrate daemon.
 * This works fine
 * because migrating the same cache twice
 * doesn't destroy the cache concistency.
 */

migrate_mb(cache, seg, mb, dirty_bits, true);

bool b = false;
lockseg(seg, flags);
if (mb->dirty_bits) {
mb->dirty_bits = 0;
b = true;
}
unlockseg(seg, flags);

if (b)
dec_nr_dirty_caches(mb->device_id);

atomic_dec(&seg->nr_inflight_ios);
bio_remap(bio, orig, bio->bi_sector);
}
return DM_MAPIO_REMAPPED;
}

cache_nr update_mb_idx;
if (found) {

if (unlikely(on_buffer)) {
mutex_unlock(&cache->io_lock);

update_mb_idx = mb->idx;
goto write_on_buffer;
} else {

u8 dirty_bits = atomic_read_mb_dirtiness(seg, mb);

/*
 * First clean up the previous cache
 * and migrate the cache if needed.
 */
bool needs_cleanup_prev_cache =
!bio_fullsize || !(dirty_bits == 255);

if (unlikely(needs_cleanup_prev_cache)) {
wait_for_completion(&seg->flush_done);
migrate_mb(cache, seg, mb, dirty_bits, true);
}

/*
 * Fullsize dirty cache
 * can be discarded without migration.
 */
bool b = false;
lockseg(seg, flags);
if (mb->dirty_bits) {
mb->dirty_bits = 0;
b = true;
}
unlockseg(seg, flags);

if (b)
dec_nr_dirty_caches(mb->device_id);

ht_del(cache, mb);

atomic_dec(&seg->nr_inflight_ios);
goto write_not_found;
}
}

write_not_found:
;

/*
 * If cache->cursor is 254, 509, ...
 * that is the last cache line in the segment.
 * We must flush the current segment and
 * get the new one.
 */
bool refresh_segment = !((cache->cursor + 1) % NR_CACHES_INSEG);

if (refresh_segment)
queue_current_buffer(cache);

cache->cursor = (cache->cursor + 1) % cache->nr_caches;

/*
 * update_mb_idx is the cache line index to update.
 */
update_mb_idx = cache->cursor;

seg = cache->current_seg;
atomic_inc(&seg->nr_inflight_ios);

struct metablock *new_mb =
seg->mb_array + (update_mb_idx % NR_CACHES_INSEG);
new_mb->dirty_bits = 0;
ht_register(cache, head, &key, new_mb);
mutex_unlock(&cache->io_lock);

mb = new_mb;

write_on_buffer:
;
cache_nr idx_inseg = update_mb_idx % NR_CACHES_INSEG;
sector_t s = (idx_inseg + 1) << 3;

bool b = false;
lockseg(seg, flags);
if (!mb->dirty_bits) {
seg->length++;
BUG_ON(seg->length >  NR_CACHES_INSEG);
b = true;
}

if (likely(bio_fullsize)) {
mb->dirty_bits = 255;
} else {
s += bio_offset;
u8 i;
u8 acc_bits = 0;
for (i = bio_offset; i < (bio_offset+bio_count); i++)
acc_bits += (1 << i);

mb->dirty_bits |= acc_bits;
}

BUG_ON(!mb->dirty_bits);

unlockseg(seg, flags);

if (b)
inc_nr_dirty_caches(mb->device_id);

size_t start = s << SECTOR_SHIFT;
void *data = bio_data(bio);

memcpy(cache->current_wb->data + start, data, bio->bi_size);
atomic_dec(&seg->nr_inflight_ios);

if (bio->bi_rw & REQ_FUA) {
queue_barrier_io(cache, bio);
return DM_MAPIO_SUBMITTED;
}

bio_endio(bio, 0);
return DM_MAPIO_SUBMITTED;
}

static int lc_end_io(struct dm_target *ti, struct bio *bio, int error
#if LINUX_VERSION_CODE < PER_BIO_VERSION
, union map_info *map_context
#endif
)
{
#if LINUX_VERSION_CODE >= PER_BIO_VERSION
struct per_bio_data *map_context =
dm_per_bio_data(bio, ti->per_bio_data_size);
#endif
if (!map_context->ptr)
return 0;

struct segment_header *seg = map_context->ptr;
atomic_dec(&seg->nr_inflight_ios);

return 0;
}


static ssize_t var_show(unsigned long var, char *page)
{
return sprintf(page, "%lu\n", var);
}

static ssize_t var_store(unsigned long *var, const char *page, size_t len)
{
char *p = (char *) page;
int r = kstrtoul(p, 10, var);
if (r)
return r;
return len;
}

static struct kobject *devices_kobj;

struct device_sysfs_entry {
struct attribute attr;
ssize_t (*show)(struct lc_device *, char *);
ssize_t (*store)(struct lc_device *, const char *, size_t);
};

#define to_device(attr) container_of((attr), struct device_sysfs_entry,
attr)
static ssize_t device_attr_show(struct kobject *kobj, struct attribute
*attr,
char *page)
{
struct device_sysfs_entry *entry = to_device(attr);
struct lc_device *device =
container_of(kobj, struct lc_device, kobj);

return entry->show(device, page);
}

static ssize_t device_attr_store(struct kobject *kobj, struct attribute
*attr,
 const char *page, size_t len)
{
struct device_sysfs_entry *entry = to_device(attr);
if (!entry->store)
return -EIO;

struct lc_device *device = container_of(kobj, struct lc_device, kobj);
return entry->store(device, page, len);
}

static cache_id cache_id_of(struct lc_device *device)
{
cache_id id;
if (!device->cache)
id = 0;
else
id = device->cache->id;
return id;
}

static ssize_t cache_id_show(struct lc_device *device, char *page)
{
return var_show(cache_id_of(device), (page));
}

static struct device_sysfs_entry cache_id_entry = {
.attr = { .name = "cache_id", .mode = S_IRUGO },
.show = cache_id_show,
};

static ssize_t dev_show(struct lc_device *device, char *page)
{
return sprintf(page, "%s\n", dm_device_name(device->md));
}

static struct device_sysfs_entry dev_entry = {
.attr = { .name = "dev", .mode = S_IRUGO },
.show = dev_show,
};

static ssize_t migrate_threshold_show(struct lc_device *device, char *page)
{
return var_show(device->migrate_threshold, (page));
}

static ssize_t migrate_threshold_store(struct lc_device *device,
       const char *page, size_t count)
{
unsigned long x;
ssize_t r = var_store(&x, page, count);
device->migrate_threshold = x;
return r;
}

static struct device_sysfs_entry migrate_threshold_entry = {
.attr = { .name = "migrate_threshold", .mode = S_IRUGO | S_IWUSR },
.show = migrate_threshold_show,
.store = migrate_threshold_store,
};

static ssize_t nr_dirty_caches_show(struct lc_device *device, char *page)
{
unsigned long val = atomic64_read(&device->nr_dirty_caches);
return var_show(val, page);
}

static struct device_sysfs_entry nr_dirty_caches_entry = {
.attr = { .name = "nr_dirty_caches", .mode = S_IRUGO },
.show = nr_dirty_caches_show,
};

static struct attribute *device_default_attrs[] = {
&cache_id_entry.attr,
&dev_entry.attr,
&migrate_threshold_entry.attr,
&nr_dirty_caches_entry.attr,
NULL,
};

static const struct sysfs_ops device_sysfs_ops = {
.show = device_attr_show,
.store = device_attr_store,
};

static void device_release(struct kobject *kobj)
{
return;
}

static struct kobj_type device_ktype = {
.sysfs_ops = &device_sysfs_ops,
.default_attrs = device_default_attrs,
.release = device_release,
};

/*
 * <device-id> <path> <cache-id>
 */
static int lc_ctr(struct dm_target *ti, unsigned int argc, char **argv)
{
#if LINUX_VERSION_CODE >= KERNEL_VERSION(3, 6, 0)
int r;
r = dm_set_target_max_io_len(ti, (1 << 3));
if (r)
return r;

#else
ti->split_io = (1 << 3);
#endif

struct lc_device *lc = kzalloc(sizeof(*lc), GFP_KERNEL);

/*
 * EMC's book says
 * storage should keep its disk util less than 70%.
 */
lc->migrate_threshold = 70;

atomic64_set(&lc->nr_dirty_caches, 0);
atomic64_inc(&lc->nr_dirty_caches);
atomic64_dec(&lc->nr_dirty_caches);

unsigned device_id;
if (sscanf(argv[0], "%u", &device_id) != 1)
return -EINVAL;

lc->id = device_id;

struct dm_dev *dev;
if (dm_get_device(ti, argv[1], dm_table_get_mode(ti->table), &dev))
return -EINVAL;

lc->device = dev;

lc->cache = NULL;
unsigned cache_id;
if (sscanf(argv[2], "%u", &cache_id) != 1)
return -EINVAL;

if (cache_id)
lc->cache = lc_caches[cache_id];

lc_devices[lc->id] = lc;
ti->private = lc;

#if LINUX_VERSION_CODE >= PER_BIO_VERSION
ti->per_bio_data_size = sizeof(struct per_bio_data);
#endif

#if LINUX_VERSION_CODE >= KERNEL_VERSION(3, 9, 0)
ti->num_flush_bios = 1;
ti->num_discard_bios = 1;
#else
ti->num_flush_requests = 1;
ti->num_discard_requests = 1;
#endif

ti->discard_zeroes_data_unsupported = true;

/*
 * /sys/module/dm_lc/devices/$id/$atribute
 *                              /dev # -> Note
 *                              /device
 */

/*
 * Note:
 * Reference to the mapped_device
 * is used to show device name (major:minor).
 * major:minor is used in admin scripts
 * to get the sysfs node of a lc_device.
 */
lc->md = dm_table_get_md(ti->table);

return 0;
}

static void lc_dtr(struct dm_target *ti)
{
struct lc_device *lc = ti->private;

dm_put_device(ti, lc->device);

ti->private = NULL;
kfree(lc);
}

struct kobject *get_bdev_kobject(struct block_device *bdev)
{
return &disk_to_dev(bdev->bd_disk)->kobj;
}

static int lc_message(struct dm_target *ti, unsigned argc, char **argv)
{
int r;

struct lc_device *lc = ti->private;

char *cmd = argv[0];

if (!strcasecmp(cmd, "add_sysfs")) {
r = kobject_init_and_add(&lc->kobj, &device_ktype,
 devices_kobj, "%u", lc->id);
struct kobject *dev_kobj = get_bdev_kobject(lc->device->bdev);
r = sysfs_create_link(&lc->kobj, dev_kobj, "device");

/* kobject_uevent(&lc->kobj, KOBJ_ADD); */
return 0;
}

if (!strcasecmp(cmd, "remove_sysfs")) {
sysfs_remove_link(&lc->kobj, "device");
kobject_del(&lc->kobj);
kobject_put(&lc->kobj);

lc_devices[lc->id] = NULL;

/* kobject_uevent(&lc->kobj, KOBJ_REMOVE); */
return 0;
}

return -EINVAL;
}

static int lc_merge(struct dm_target *ti, struct bvec_merge_data *bvm,
    struct bio_vec *biovec, int max_size)
{
struct lc_device *lc = ti->private;
struct dm_dev *device = lc->device;
struct request_queue *q = bdev_get_queue(device->bdev);

if (!q->merge_bvec_fn)
return max_size;

bvm->bi_bdev = device->bdev;
return min(max_size, q->merge_bvec_fn(q, bvm, biovec));
}

static int lc_iterate_devices(struct dm_target *ti,
      iterate_devices_callout_fn fn, void *data)
{
struct lc_device *lc = ti->private;
struct dm_dev *orig = lc->device;
sector_t start = 0;
sector_t len = dm_devsize(orig);
return fn(ti, orig, start, len, data);
}

static void lc_io_hints(struct dm_target *ti, struct queue_limits *limits)
{
blk_limits_io_min(limits, 512);
blk_limits_io_opt(limits, 4096);
}

static
#if LINUX_VERSION_CODE >= KERNEL_VERSION(3, 8, 0)
void
#else
int
#endif
lc_status(
struct dm_target *ti, status_type_t type,
#if LINUX_VERSION_CODE >= KERNEL_VERSION(3, 6, 0)
unsigned flags,
#endif
char *result,
unsigned maxlen)
{
unsigned int sz = 0;

struct lc_device *lc = ti->private;
switch (type) {
case STATUSTYPE_INFO:
result[0] = '\0';
break;

case STATUSTYPE_TABLE:
DMEMIT("%d %s %d", lc->id, lc->device->name, cache_id_of(lc));
break;
}
#if LINUX_VERSION_CODE < KERNEL_VERSION(3, 8, 0)
return 0;
#endif
}

static struct target_type lc_target = {
.name = "lc",
.version = {1, 0, 0},
.module = THIS_MODULE,
.map = lc_map,
.ctr = lc_ctr,
.dtr = lc_dtr,
.end_io = lc_end_io,
.merge = lc_merge,
.message = lc_message,
.status = lc_status,
.io_hints = lc_io_hints,
.iterate_devices = lc_iterate_devices,
};

static int lc_mgr_map(struct dm_target *ti, struct bio *bio
#if LINUX_VERSION_CODE < KERNEL_VERSION(3, 8, 0)
, union map_info *map_context
#endif
)
{
bio_endio(bio, 0);
return DM_MAPIO_SUBMITTED;
}

static int lc_mgr_ctr(struct dm_target *ti, unsigned int argc, char **argv)
{
return 0;
}

static void lc_mgr_dtr(struct dm_target *ti)
{
return;
}

static struct kobject *caches_kobj;

struct cache_sysfs_entry {
struct attribute attr;
ssize_t (*show)(struct lc_cache *, char *);
ssize_t (*store)(struct lc_cache *, const char *, size_t);
};

#define to_cache(attr) container_of((attr), struct cache_sysfs_entry, attr)
static ssize_t cache_attr_show(struct kobject *kobj,
       struct attribute *attr, char *page)
{
struct cache_sysfs_entry *entry = to_cache(attr);
struct lc_cache *cache =
container_of(kobj, struct lc_cache, kobj);

return entry->show(cache, page);
}

static ssize_t cache_attr_store(struct kobject *kobj, struct attribute
*attr,
const char *page, size_t len)
{
struct cache_sysfs_entry *entry = to_cache(attr);
if (!entry->store)
return -EIO;

struct lc_cache *cache = container_of(kobj, struct lc_cache, kobj);
return entry->store(cache, page, len);
}

static ssize_t commit_super_block_interval_show(struct lc_cache *cache,
char *page)
{
return var_show(cache->commit_super_block_interval, (page));
}

static ssize_t commit_super_block_interval_store(struct lc_cache *cache,
 const char *page, size_t count)
{
unsigned long x;
ssize_t r = var_store(&x, page, count);
cache->commit_super_block_interval = x;
return r;
}

static struct cache_sysfs_entry commit_super_block_interval_entry = {
.attr = { .name = "commit_super_block_interval",
  .mode = S_IRUGO | S_IWUSR },
.show = commit_super_block_interval_show,
.store = commit_super_block_interval_store,
};

static ssize_t allow_migrate_show(struct lc_cache *cache, char *page)
{
return var_show(cache->allow_migrate, (page));
}

static ssize_t allow_migrate_store(struct lc_cache *cache,
   const char *page, size_t count)
{
unsigned long x;
ssize_t r = var_store(&x, page, count);
cache->allow_migrate = x;
return r;
}

static struct cache_sysfs_entry allow_migrate_entry = {
.attr = { .name = "allow_migrate", .mode = S_IRUGO | S_IWUSR },
.show = allow_migrate_show,
.store = allow_migrate_store,
};

static ssize_t force_migrate_show(struct lc_cache *cache, char *page)
{
return var_show(cache->force_migrate, page);
}

static ssize_t force_migrate_store(struct lc_cache *cache,
   const char *page, size_t count)
{
unsigned long x;
ssize_t r = var_store(&x, page, count);
cache->force_migrate = x;
return r;
}

static struct cache_sysfs_entry force_migrate_entry = {
.attr = { .name = "force_migrate", .mode = S_IRUGO | S_IWUSR },
.show = force_migrate_show,
.store = force_migrate_store,
};

static ssize_t update_interval_show(struct lc_cache *cache, char *page)
{
return var_show(cache->update_interval, page);
}

static ssize_t update_interval_store(struct lc_cache *cache,
     const char *page, size_t count)
{
unsigned long x;
ssize_t r = var_store(&x, page, count);
cache->update_interval = x;
return r;
}

static struct cache_sysfs_entry update_interval_entry = {
.attr = { .name = "update_interval", .mode = S_IRUGO | S_IWUSR },
.show = update_interval_show,
.store = update_interval_store,
};

static ssize_t flush_current_buffer_interval_show(struct lc_cache *cache,
  char *page)
{
return var_show(cache->flush_current_buffer_interval, page);
}

static ssize_t flush_current_buffer_interval_store(
struct lc_cache *cache, const char *page, size_t count)
{
unsigned long x;
ssize_t r = var_store(&x, page, count);
cache->flush_current_buffer_interval = x;
return r;
}

static struct cache_sysfs_entry flush_current_buffer_interval_entry = {
.attr = { .name = "flush_current_buffer_interval",
  .mode = S_IRUGO | S_IWUSR },
.show = flush_current_buffer_interval_show,
.store = flush_current_buffer_interval_store,
};

static ssize_t commit_super_block_show(struct lc_cache *cache, char *page)
{
return var_show(0, (page));
}

static ssize_t commit_super_block_store(struct lc_cache *cache,
const char *page, size_t count)
{
unsigned long x;
ssize_t r = var_store(&x, page, count);

if (x < 1)
return -EIO;

mutex_lock(&cache->io_lock);
commit_super_block(cache);
mutex_unlock(&cache->io_lock);

return r;
}

static struct cache_sysfs_entry commit_super_block_entry = {
.attr = { .name = "commit_super_block", .mode = S_IRUGO | S_IWUSR },
.show = commit_super_block_show,
.store = commit_super_block_store,
};

static ssize_t flush_current_buffer_show(struct lc_cache *cache, char *page)
{
return var_show(0, (page));
}

static ssize_t flush_current_buffer_store(struct lc_cache *cache,
  const char *page, size_t count)
{
unsigned long x;

ssize_t r = var_store(&x, page, count);
if (x < 1)
return -EIO;

flush_current_buffer_sync(cache);
return r;
}

static struct cache_sysfs_entry flush_current_buffer_entry = {
.attr = { .name = "flush_current_buffer", .mode = S_IRUGO | S_IWUSR },
.show = flush_current_buffer_show,
.store = flush_current_buffer_store,
};

static ssize_t last_flushed_segment_id_show(struct lc_cache *cache, char
*page)
{
return var_show(cache->last_flushed_segment_id, (page));
}

static struct cache_sysfs_entry last_flushed_segment_id_entry = {
.attr = { .name = "last_flushed_segment_id", .mode = S_IRUGO },
.show = last_flushed_segment_id_show,
};

static ssize_t last_migrated_segment_id_show(struct lc_cache *cache, char
*page)
{
return var_show(cache->last_migrated_segment_id, (page));
}

static struct cache_sysfs_entry last_migrated_segment_id_entry = {
.attr = { .name = "last_migrated_segment_id", .mode = S_IRUGO },
.show = last_migrated_segment_id_show,
};

static ssize_t barrier_deadline_ms_show(struct lc_cache *cache, char *page)
{
return var_show(cache->barrier_deadline_ms, (page));
}

static ssize_t barrier_deadline_ms_store(struct lc_cache *cache,
 const char *page, size_t count)
{
unsigned long x;
ssize_t r = var_store(&x, page, count);

cache->barrier_deadline_ms = x;
return r;
}

static struct cache_sysfs_entry barrier_deadline_ms_entry = {
.attr = { .name = "barrier_deadline_ms", .mode = S_IRUGO | S_IWUSR },
.show = barrier_deadline_ms_show,
.store = barrier_deadline_ms_store,
};

static struct attribute *cache_default_attrs[] = {
&commit_super_block_interval_entry.attr,
&allow_migrate_entry.attr,
&commit_super_block_entry.attr,
&flush_current_buffer_entry.attr,
&flush_current_buffer_interval_entry.attr,
&force_migrate_entry.attr,
&update_interval_entry.attr,
&last_flushed_segment_id_entry.attr,
&last_migrated_segment_id_entry.attr,
&barrier_deadline_ms_entry.attr,
NULL,
};

static const struct sysfs_ops cache_sysfs_ops = {
.show = cache_attr_show,
.store = cache_attr_store,
};

static void cache_release(struct kobject *kobj)
{
return;
}

static struct kobj_type cache_ktype = {
.sysfs_ops = &cache_sysfs_ops,
.default_attrs = cache_default_attrs,
.release = cache_release,
};

static int lc_mgr_message(struct dm_target *ti, unsigned int argc, char
**argv)
{
char *cmd = argv[0];

/*
 * <path>
 * @path path to the cache device
 */
if (!strcasecmp(cmd, "format_cache_device")) {
struct dm_dev *dev;
if (dm_get_device(ti, argv[1],
  dm_table_get_mode(ti->table), &dev))
return -EINVAL;

format_cache_device(dev);

dm_put_device(ti, dev);
return 0;
}

/*
 * <id>
 *
 * lc-mgr has cursor to point the
 * cache device to operate.
 */
if (!strcasecmp(cmd, "switch_to")) {
unsigned id;
if (sscanf(argv[1], "%u", &id) != 1)
return -EINVAL;

cache_id_ptr = id;
return 0;
}

if (!strcasecmp(cmd, "clear_stat")) {
struct lc_cache *cache = lc_caches[cache_id_ptr];
if (!cache)
return -EINVAL;

clear_stat(cache);
return 0;
}

/*
 * <path>
 */
if (!strcasecmp(cmd, "resume_cache")) {
struct lc_cache *cache = kzalloc(sizeof(*cache), GFP_KERNEL);

struct dm_dev *dev;
if (dm_get_device(ti, argv[1],
  dm_table_get_mode(ti->table), &dev))
return -EINVAL;

cache->id = cache_id_ptr;
cache->device = dev;
cache->nr_segments = calc_nr_segments(cache->device);
cache->nr_caches = cache->nr_segments * NR_CACHES_INSEG;

mutex_init(&cache->io_lock);

cache->wb_pool = kmalloc(
sizeof(struct writebuffer) * NR_WB_POOL, GFP_KERNEL);
struct writebuffer *wb;
int i;
for (i = 0; i < NR_WB_POOL; i++) {
wb = cache->wb_pool + i;
init_completion(&wb->done);
complete_all(&wb->done);

wb->data = kmalloc(
1 << (LC_SEGMENTSIZE_ORDER + SECTOR_SHIFT),
GFP_KERNEL);
}

/*
 * Select arbitrary one
 * as the initial writebuffer.
 */
cache->current_wb = cache->wb_pool + 0;

init_segment_header_array(cache);
mb_array_empty_init(cache);
ht_empty_init(cache);

cache->on_terminate = false;
cache->allow_migrate = false;
cache->force_migrate = false;
cache->reserving_segment_id = 0;

cache->flush_wq = create_singlethread_workqueue("flushwq");
spin_lock_init(&cache->flush_queue_lock);
INIT_WORK(&cache->flush_work, flush_proc);
INIT_LIST_HEAD(&cache->flush_queue);
init_waitqueue_head(&cache->flush_wait_queue);
queue_work(cache->flush_wq, &cache->flush_work);

cache->migrate_wq = create_singlethread_workqueue("migratewq");
INIT_WORK(&cache->migrate_work, migrate_proc);
queue_work(cache->migrate_wq, &cache->migrate_work);

init_waitqueue_head(&cache->migrate_wait_queue);
atomic_set(&cache->migrate_fail_count, 0);
atomic_set(&cache->migrate_io_count, 0);
cache->migrate_buffer = kmalloc(
1 << (LC_SEGMENTSIZE_ORDER + SECTOR_SHIFT),
GFP_KERNEL);

setup_timer(&cache->barrier_deadline_timer,
    barrier_deadline_proc, (unsigned long) cache);
bio_list_init(&cache->barrier_ios);

/*
 * deadline is 3 ms by default.
 * 2.5 us to process on bio
 * and 3 ms is enough long to process 255 bios.
 * If the buffer doesn't get full within 3 ms,
 * we can doubt write starves
 * by waiting formerly submitted barrier to be complete.
 */
cache->barrier_deadline_ms = 3;
INIT_WORK(&cache->barrier_deadline_work, flush_barrier_ios);

recover_cache(cache);
lc_caches[cache->id] = cache;

clear_stat(cache);

/*
 * /sys/module/dm_lc/caches/$id/$attribute
 *                             /device -> /sys/block/$name
 */

int r;

cache->update_interval = 1;
cache->commit_super_block_interval = 0;
cache->flush_current_buffer_interval = 0;
r = kobject_init_and_add(&cache->kobj, &cache_ktype,
 caches_kobj, "%u", cache->id);

struct kobject *dev_kobj =
get_bdev_kobject(cache->device->bdev);
r = sysfs_create_link(&cache->kobj, dev_kobj, "device");

return 0;
}

if (!strcasecmp(cmd, "free_cache")) {
cache_id id = cache_id_ptr;
struct lc_cache *cache = lc_caches[id];

cache->on_terminate = true;

cancel_work_sync(&cache->flush_work);
destroy_workqueue(cache->flush_wq);

cancel_work_sync(&cache->barrier_deadline_work);

kfree(cache->migrate_buffer);
cancel_work_sync(&cache->migrate_work);
destroy_workqueue(cache->migrate_wq);

size_t i;
struct writebuffer *wb;
for (i = 0; i < NR_WB_POOL; i++) {
wb = cache->wb_pool + i;
kfree(wb->data);
}
kfree(cache->wb_pool);

kill_arr(cache->htable);
kill_arr(cache->segment_header_array);

sysfs_remove_link(&cache->kobj, "device");
kobject_del(&cache->kobj);
kobject_put(&cache->kobj);

dm_put_device(ti, cache->device);
kfree(cache);

lc_caches[id] = NULL;

return 0;
}

return -EINVAL;
}

static size_t calc_static_memory_consumption(struct lc_cache *cache)
{
size_t seg = sizeof(struct segment_header) * cache->nr_segments;
size_t ht = sizeof(struct ht_head) * cache->htsize;

return seg + ht;
};

static
#if LINUX_VERSION_CODE >= KERNEL_VERSION(3, 8, 0)
void
#else
int
#endif
lc_mgr_status(
struct dm_target *ti, status_type_t type,
#if LINUX_VERSION_CODE >= KERNEL_VERSION(3, 6, 0)
unsigned flags,
#endif
char *result, unsigned int maxlen)
{
unsigned int sz = 0;

switch (type) {
case STATUSTYPE_INFO:
DMEMIT("\n");
DMEMIT("current cache_id_ptr: %u\n", cache_id_ptr);

if (cache_id_ptr == 0) {
DMEMIT(
"sizeof(struct metablock): %lu\n",
       sizeof(struct metablock));
DMEMIT(
"sizeof(struct metablock_device): %lu\n",
       sizeof(struct metablock_device));
DMEMIT(
"sizeof(struct segment_header): %lu\n",
       sizeof(struct segment_header));
DMEMIT(
"sizeof(struct segment_header_device): %lu (<= 4096)",
       sizeof(struct segment_header_device));
break;
}

struct lc_cache *cache = lc_caches[cache_id_ptr];
if (!cache)
#if LINUX_VERSION_CODE < KERNEL_VERSION(3, 8, 0)
return -EINVAL;
#else
return;
#endif

DMEMIT("static RAM(approx.): %lu (byte)\n",
       calc_static_memory_consumption(cache));
DMEMIT("allow_migrate: %d\n", cache->allow_migrate);
DMEMIT("nr_segments: %lu\n", cache->nr_segments);
DMEMIT("last_migrated_segment_id: %lu\n",
       cache->last_migrated_segment_id);
DMEMIT("last_flushed_segment_id: %lu\n",
       cache->last_flushed_segment_id);
DMEMIT("current segment id: %lu\n",
       cache->current_seg->global_id);
DMEMIT("cursor: %u\n", cache->cursor);
DMEMIT("\n");
DMEMIT("write? hit? on_buffer? fullsize?\n");
int i;
for (i = 0; i < STATLEN; i++) {
if (i == (STATLEN-1))
break;

atomic64_t *v = &cache->stat[i];
DMEMIT("%d %d %d %d %lu",
i & (1 << STAT_WRITE)      ? 1 : 0,
i & (1 << STAT_HIT)        ? 1 : 0,
i & (1 << STAT_ON_BUFFER)  ? 1 : 0,
i & (1 << STAT_FULLSIZE)   ? 1 : 0,
atomic64_read(v));
DMEMIT("\n");
}
break;

case STATUSTYPE_TABLE:
break;
}

#if LINUX_VERSION_CODE < KERNEL_VERSION(3, 8, 0)
return 0;
#endif
}

static struct target_type lc_mgr_target = {
.name = "lc-mgr",
.version = {1, 0, 0},
.module = THIS_MODULE,
.map = lc_mgr_map,
.ctr = lc_mgr_ctr,
.dtr = lc_mgr_dtr,
.message = lc_mgr_message,
.status = lc_mgr_status,
};

static int __init lc_module_init(void)
{
int r;

safe_io_wq = alloc_workqueue("safeiowq",
     WQ_NON_REENTRANT | WQ_MEM_RECLAIM, 0);

lc_io_client = dm_io_client_create();

r = dm_register_target(&lc_target);
if (r < 0) {
DMERR("register lc failed %d", r);
return r;
}

r = dm_register_target(&lc_mgr_target);
if (r < 0) {
DMERR("register lc-mgr failed %d", r);
return r;
}

cache_id_ptr = 0;

size_t i;
for (i = 0; i < LC_NR_SLOTS; i++)
lc_devices[i] = NULL;

for (i = 0; i < LC_NR_SLOTS; i++)
lc_caches[i] = NULL;

/*
 * /sys/module/dm_lc/devices
 *                  /caches
 */

struct module *mod = THIS_MODULE;
struct kobject *lc_kobj = &(mod->mkobj.kobj);
devices_kobj = kobject_create_and_add("devices", lc_kobj);
caches_kobj = kobject_create_and_add("caches", lc_kobj);

return 0;
}

static void __exit lc_module_exit(void)
{
destroy_workqueue(safe_io_wq);
dm_io_client_destroy(lc_io_client);

kobject_put(devices_kobj);
kobject_put(caches_kobj);

dm_unregister_target(&lc_mgr_target);
dm_unregister_target(&lc_target);
}

module_init(lc_module_init);
module_exit(lc_module_exit);

MODULE_AUTHOR("Akira Hayakawa <ruby.wktk@gmail.com>");
MODULE_DESCRIPTION(DM_NAME " lc target");
MODULE_LICENSE("GPL");



(dm-lc.txt)

dm-lc
=====

dm-lc provides write-back log-structured caching.
It batches random writes into a big sequential write.

1. Setup
========
dm-lc is composed of two target_type instances named lc and lc-mgr.
lc is responsible for creating logical volumes and controlling ios and
lc-mgr is reponsible for managing
formatting/initializing/destructing cache devices on the other hand.
Operating dm-lc through these native interfaces are not recommended.

To easily get started with dm-lc, nice userland tools are provided in
https://github.com/akiradeveloper/dm-lc
where you are also accesible to portable dm-lc kernel code
that supports since 3.2 kernel until before dm-lc staged upstream, 3.x.
please git clone it.

To install the tools, move under Admin directory and run
python setup.py install
and now you have a lisence for dm-lc admin.

2. Example scripts
==================
Let's create a logical volume named myLV
backed by /dev/myVg/myBacking
and use /dev/myCache as a cache device.

myLV -- (backing store) /dev/myVg/myBacking
     -- (cache device)  /dev/myCache

Note that backing store is restricted to
a logical device that is created by LVM
for technical reasons.

1. Format myCache
Format the medata blocks on a device.
Note that this erases all the existing data.

lc-format-cache /dev/myCache

2. Create myLV
Create a logical volume just backed by a existing volume.
We give device id 5 to the volume in this example.

As of now, this operation create a logical volume
with different name from the backing store.
But some users don't want to change the name
because the backing store is in use
and want to apply dm-lc on the fly.
This can be technically realizable
but I haven't implemented it at this time
because it is too tricky to be portable.

lc-create myLV 5 /dev/myVg/myBacking

3. Resume myCache
Resuming cache device builds in-memory structures
such as a hashtable scanned from the metadata on the device.
We give cache id 3 to the device in this example.

Note that you MUST create all the LVs as the destinations
of the dirty caches on the cache device for technical reasons.
Otherwise, it leads to kernel crash. Be careful.

lc-resume 3 /dev/myCache

4. Attach myCache to myLV
To start caching writes to the myLV, you must attach myCache to myLV.
This can be done on the fly.

lc-attach 5 3

5. Start userland daemon
dm-lc provides daemon program
that autonomously control the module behavior
such as write-back from myCache to myBacking
which dm-lc calls "Migration".

lc-daemon start

6. Terminate myLV
Safely terminating myLV already attached to myCache
is easy to mistake and that's why dm-lc provides these admin tools.
myLV can not detach from myCache
until all the dirty caches on myCache
are migrated to myBacking

lc-detach 5
lc-remove 5

7. Terminate myCache
After terminate all the LVs that is attached
to myCache. myCache can be terminated.

lc-daemon stop
lc-free-cache 3

3. Sysfs
========
dm-lc provides some sysfs interfaces to control the module behavior.
The sysfs tree is located under /sys/module/dm_lc.

/sys/module/dm_lc
|
|-- devices
|   `-- 5
|       |-- cache_id
|       |-- dev
|       |-- device -> ../../../../devices/virtual/block/dm-0
|       |-- migrate_threshold
|       |-- nr_dirty_caches
|
|-- caches
|   `-- 3
|       |-- allow_migrate
|       |-- barrier_deadline_ms
|       |-- commit_super_block
|       |-- commit_super_block_interval
|       |-- device -> ../../../../devices/virtual/block/dm-1
|       |-- flush_current_buffer
|       |-- flush_current_buffer_interval
|       |-- force_migrate
|       |-- last_flushed_segment_id
|       |-- last_migrated_segment_id
|       `-- update_interval

4. Technical Issues
===================
There are not a few technical issues
that distinguishes dm-lc from other cache softwares.

4.1 RAM buffer and immediate completion
dm-lc allocated RAM buffers of 64MB in total by default.
All of the writes are first stored in one of these RAM buffers
and immediate completion is notified to the upper layer
that is usually in few microseconds that is unimaginably fast.

4.2 Metadata durability
After RAM buffer gets full or some deadline comes
dm-lc creates segment log that gathers RAM buffer and its metadata.
Metadata have information such as connection between
address in cache device and the counterpart in backing store.
As the segment log finally is written to persistent cache device,
any data will not be lost after machine failure.

4.3 Asynchronous log flushing
dm-lc has a background worker called flush daemon.
Flushing segment log starts from simply queueing the flush task.
Flush daemon in background asynchronously checks if the queue has some tasks
and actually executes the tasks if exists.
The fact that the upper layer doesn't block in queueing the task
maximizes the write throughput
that is 259MB/s random writes with cache device of 266MB/s sequential write
which is only 3% loss
and 1.5GB/s theoritically with a fast enough cache like PCI-e SSDs.

4.4 Asynchronous and automated migration
Some time after a log segment is flushed to cache device
it will be migrated to backing store.
Migrate daemon is also a background worker
that periodically check if log segments to migrate exist.

Restlessly migrating highly loads backing store
so migration is better to execute when the backing store is in lazy time.
lc-daemon in userland surveils the load of backing store
and turns migration on and off according to the load.

4.5 Lazy handling of REQ_FUA and REQ_FLUSH bios
Some applications such as NFS, journal filesystems
and databases often submit SYNC write that
leads to bios flagged with REQ_FUA or REQ_FLUSH.
Handling these irregular bios immediately and thus synchronously
desparately deteriorates the whole throughput.
To address this issue, dm-lc handles these bios lazily or in deferred
manner.
Completion related to these bios will not be done until
they are written persistently to the cache device
so this storategy doesn't break the semantics.
In the worst case scenario, a bio with some of these flags
is completed in deadline period that is described
in barrier_deadline_ms in sysfs.


Thanks for reading,
Akira

--001a11c24d16f9374104e18ea250
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>I propose a new DM target, dm-lc.</div><div><br></div=
><div>&quot;lc&quot; means Log-sturctured Caching and as the name implies</=
div><div>dm-lc is a caching software with only write-back mode.</div><div>
It batches random writes into a big sequential write to</div><div>the cache=
 device.</div><div><br></div><div>It is now under development as a</div><di=
v>portable kernel module in my Github repo</div><div><a href=3D"https://git=
hub.com/akiradeveloper/dm-lc">https://github.com/akiradeveloper/dm-lc</a></=
div>
<div><br></div><div>Features:</div><div><br></div><div>(1) Simplicity</div>=
<div>Since dm-lc only focuses on write-back caching,</div><div>the implemen=
tation is simpler, 3k LOC, than existing ones</div><div>such as dm-cache, b=
cache and enhanceIO</div>
<div>and thus less buggy. This is the point.</div><div>I think write-back c=
ache software should be small and simple</div><div>because write-back cache=
 may destroy the storage</div><div>in worst case scenario.</div><div><br>
</div><div>Stacking above the write-through/write-around mode of</div><div>=
existing caching software is a choice of usage.</div><div>dm-lc can co-exis=
ts with existing cache softwares.</div><div><br></div><div>(2) Superb Perfo=
rmance</div>
<div>Because the code is simple,</div><div>dm-lc performs better than exist=
ing ones</div><div>in random write throughput.</div><div>The benchmark is d=
one using fio tool.</div><div>It only loses 3% throughtput compared to</div=
>
<div>cache device&#39;s sequential write throughput.</div><div>The detail i=
s, 259MB/sec random writes by HDD+SSD</div><div>against 266MB/sec sequentia=
l write on SSD.</div><div><br></div><div>Plus, dm-lc is capable of 1.5GB/se=
c random write</div>
<div>throughput with a fast enough cache.</div><div>This means the code pat=
h is short and the locking is effective.</div><div><br></div><div>For more =
detail, please read</div><div><a href=3D"https://github.com/akiradeveloper/=
dm-lc/tree/develop/performance">https://github.com/akiradeveloper/dm-lc/tre=
e/develop/performance</a></div>
<div><br></div><div>(3) Durability for server crash</div><div>Servers somet=
imes crash but any data</div><div>on the storage should not be gone.</div><=
div>Some existing softwares have</div><div>cache metadata on memory in runt=
ime</div>
<div>and lose them all in server crash.</div><div>dm-lc, as it write in log=
-structured manner</div><div>which means it writes metadata and data togeth=
er</div><div>on the cache device, does&#39;t lose any data in such failures=
.</div>
<div><br></div><div>To answer to the expectation from upper layer,</div><di=
v>dm-lc can handle REQ_FUA/REQ_FLUSH flags correctly</div><div>but not lose=
s performance badly by lazy execution technique.</div><div><br></div><div>
(4) Autonomous migration</div><div>The algorithm of migration or writing ba=
ck</div><div>is key factor in write-back cache.</div><div>dm-lc have a user=
land daemon to</div><div>autonomusly turn on and off migration</div><div>
according to the load of backing store.</div><div><br></div><div>For more d=
etail, please read dm-lc.txt</div><div>that is now copy and paste on this m=
ail below.</div><div><br></div><div>How to Taste?:</div><div>Clone the repo=
sitory and follow the</div>
<div>&quot;Quick Start&quot; guideline.</div><div>It is almost automated an=
d just 5 minutes work.</div><div>Benchmarkings and testings are prepared</d=
iv><div>in scripts and you can try them.</div><div><br></div><div>About Ups=
treaming:</div>
<div>Now, I think it&#39;s time to go upstreaming.</div><div>The softwares =
is well-tested and</div><div>shows nice performance boost in benchmarking u=
sing fio.</div><div>Merging into the mainline tree is the only way to</div>
<div>sophisticate the code and document more</div><div>for dm-lc at this po=
int.</div><div><br></div><div>Before that, I think I need to discuss with y=
ou DM guys.</div><div>Q. Do you have some comments on the code and document=
?</div>
<div><br></div><div>Actually, I am not a programming newbie but</div><div>r=
eally new to Linux upstreaming community</div><div>so I have no clue to wha=
t to do next.</div><div><br></div><div>My plan is to first remove</div>
<div>all the code for version switch</div><div>and merge into some kernel t=
ree in local, test</div><div>and then repost to this ML as a patch.</div><d=
iv>Q. What tree do I need to use for merging and testing?</div><div><br>
</div><div>Research Background:</div><div>The philosophy is based on Disk C=
aching Disk</div><div><a href=3D"http://www.ele.uri.edu/research/hpcl/DCD/D=
CD.html">http://www.ele.uri.edu/research/hpcl/DCD/DCD.html</a></div><div>
My work is to build an efficient and thorough</div><div>implementation for =
Linux.</div><div><br></div><div>As a related work,</div><div>There is a rec=
ent study by Microsoft</div><div>&quot;Extending SSD Lifetimes with Disk-Ba=
sed Write Caches&quot;</div>
<div>which is also on the philosophy of DCD.</div><div><a href=3D"http://re=
search.microsoft.com/apps/pubs/default.aspx?id=3D115352">http://research.mi=
crosoft.com/apps/pubs/default.aspx?id=3D115352</a></div><div><br></div><div=
><br>
</div><div><br></div><div>Belows are the 3k lines of kernel code (dm-lc.c) =
and document (dm-lc.txt).</div><div>The kernel code went through the <a hre=
f=3D"http://checkpatch.pl">checkpatch.pl</a> and</div><div>only 17 warnings=
 for version switch is remained at this time.</div>
<div><br></div><div>(dm-lc.c)</div><div><br></div><div>/*</div><div>=A0* dm=
-lc.c : Log-structured Caching for Linux.</div><div>=A0* Copyright (C) 2012=
-2013 Akira Hayakawa &lt;<a href=3D"mailto:ruby.wktk@gmail.com">ruby.wktk@g=
mail.com</a>&gt;</div>
<div>=A0*</div><div>=A0* This file is released under the GPL.</div><div>=A0=
*/</div><div><br></div><div>#define DM_MSG_PREFIX &quot;lc&quot;</div><div>=
<br></div><div>#include &lt;linux/module.h&gt;</div><div>#include &lt;linux=
/version.h&gt;</div>
<div>#include &lt;linux/list.h&gt;</div><div>#include &lt;linux/slab.h&gt;<=
/div><div>#include &lt;linux/mutex.h&gt;</div><div>#include &lt;linux/sched=
.h&gt;</div><div>#include &lt;linux/device-mapper.h&gt;</div><div>#include =
&lt;linux/dm-io.h&gt;</div>
<div>#include &lt;linux/timer.h&gt;</div><div><br></div><div>/*</div><div>=
=A0* Comments are described</div><div>=A0* in the case the segment size ord=
er is 11</div><div>=A0* which means the segment size is the maxium, 1MB.</d=
iv>
<div>=A0*/</div><div><br></div><div>/*</div><div>=A0* (1 &lt;&lt; x) sector=
.</div><div>=A0* 4 &lt;=3D x &lt;=3D 11</div><div>=A0*/</div><div>#define L=
C_SEGMENTSIZE_ORDER 11</div><div>#define NR_CACHES_INSEG ((1 &lt;&lt; (LC_S=
EGMENTSIZE_ORDER - 3)) - 1)</div>
<div><br></div><div>static void *do_kmalloc_retry(size_t size, gfp_t flags,=
 int lineno)</div><div>{</div><div><span class=3D"" style=3D"white-space:pr=
e">	</span>int count =3D 0;</div><div><span class=3D"" style=3D"white-space=
:pre">	</span>void *p;</div>
<div><br></div><div>retry_alloc:</div><div><span class=3D"" style=3D"white-=
space:pre">	</span>p =3D kmalloc(size, flags);</div><div><span class=3D"" s=
tyle=3D"white-space:pre">	</span>if (!p) {</div><div><span class=3D"" style=
=3D"white-space:pre">		</span>count++;</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>DMERR(&quot;L.%d: =
fail allocation(count:%d)&quot;, lineno, count);</div><div><span class=3D""=
 style=3D"white-space:pre">		</span>schedule_timeout_interruptible(msecs_to=
_jiffies(1));</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>goto retry_alloc;<=
/div><div><span class=3D"" style=3D"white-space:pre">	</span>}</div><div><s=
pan class=3D"" style=3D"white-space:pre">	</span>return p;</div><div>}</div=
><div>#define kmalloc_retry(size, flags) do_kmalloc_retry((size), (flags), =
__LINE__)</div>
<div><br></div><div>struct part {</div><div><span class=3D"" style=3D"white=
-space:pre">	</span>void *memory;</div><div>};</div><div><br></div><div>str=
uct arr {</div><div><span class=3D"" style=3D"white-space:pre">	</span>stru=
ct part *parts;</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>size_t nr_elems;</d=
iv><div><span class=3D"" style=3D"white-space:pre">	</span>size_t elemsize;=
</div><div>};</div><div><br></div><div>#define ALLOC_SIZE (1 &lt;&lt; 16)</=
div>
<div>static size_t nr_elems_in_part(struct arr *arr)</div><div>{</div><div>=
<span class=3D"" style=3D"white-space:pre">	</span>return ALLOC_SIZE / arr-=
&gt;elemsize;</div><div>};</div><div><br></div><div>static size_t nr_parts(=
struct arr *arr)</div>
<div>{</div><div><span class=3D"" style=3D"white-space:pre">	</span>return =
dm_div_up(arr-&gt;nr_elems, nr_elems_in_part(arr));</div><div>}</div><div><=
br></div><div>static struct arr *make_arr(size_t elemsize, size_t nr_elems)=
</div>
<div>{</div><div><span class=3D"" style=3D"white-space:pre">	</span>struct =
arr *arr =3D kmalloc(sizeof(*arr), GFP_KERNEL);</div><div><span class=3D"" =
style=3D"white-space:pre">	</span>arr-&gt;elemsize =3D elemsize;</div><div>=
<span class=3D"" style=3D"white-space:pre">	</span>arr-&gt;nr_elems =3D nr_=
elems;</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>arr-&gt;parts =3D k=
malloc(sizeof(struct part) * nr_parts(arr), GFP_KERNEL);</div><div><br></di=
v><div><span class=3D"" style=3D"white-space:pre">	</span>size_t i;</div><d=
iv><span class=3D"" style=3D"white-space:pre">	</span>for (i =3D 0; i &lt; =
nr_parts(arr); i++) {</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>struct part *part =
=3D arr-&gt;parts + i;</div><div><span class=3D"" style=3D"white-space:pre"=
>		</span>part-&gt;memory =3D kmalloc(ALLOC_SIZE, GFP_KERNEL);</div><div><s=
pan class=3D"" style=3D"white-space:pre">	</span>}</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>return arr;</div><d=
iv>}</div><div><br></div><div>static void kill_arr(struct arr *arr)</div><d=
iv>{</div><div><span class=3D"" style=3D"white-space:pre">	</span>size_t i;=
</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>for (i =3D 0; i &lt=
; nr_parts(arr); i++) {</div><div><span class=3D"" style=3D"white-space:pre=
">		</span>struct part *part =3D arr-&gt;parts + i;</div><div><span class=
=3D"" style=3D"white-space:pre">		</span>kfree(part-&gt;memory);</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>}</div><div><span c=
lass=3D"" style=3D"white-space:pre">	</span>kfree(arr-&gt;parts);</div><div=
><span class=3D"" style=3D"white-space:pre">	</span>kfree(arr);</div><div>}=
</div><div>
<br></div><div>static void *arr_at(struct arr *arr, size_t i)</div><div>{</=
div><div><span class=3D"" style=3D"white-space:pre">	</span>size_t n =3D nr=
_elems_in_part(arr);</div><div><span class=3D"" style=3D"white-space:pre">	=
</span>size_t j =3D i / n;</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>size_t k =3D i % n;=
</div><div><span class=3D"" style=3D"white-space:pre">	</span>struct part *=
part =3D arr-&gt;parts + j;</div><div><span class=3D"" style=3D"white-space=
:pre">	</span>return part-&gt;memory + (arr-&gt;elemsize * k);</div>
<div>}</div><div><br></div><div>static struct dm_io_client *lc_io_client;</=
div><div><br></div><div>struct safe_io {</div><div><span class=3D"" style=
=3D"white-space:pre">	</span>struct work_struct work;</div><div><span class=
=3D"" style=3D"white-space:pre">	</span>int err;</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>unsigned long err_b=
its;</div><div><span class=3D"" style=3D"white-space:pre">	</span>struct dm=
_io_request *io_req;</div><div><span class=3D"" style=3D"white-space:pre">	=
</span>struct dm_io_region *region;</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>unsigned num_region=
s;</div><div>};</div><div>static struct workqueue_struct *safe_io_wq;</div>=
<div><br></div><div>static void safe_io_proc(struct work_struct *work)</div=
>
<div>{</div><div><span class=3D"" style=3D"white-space:pre">	</span>struct =
safe_io *io =3D container_of(work, struct safe_io, work);</div><div><span c=
lass=3D"" style=3D"white-space:pre">	</span>io-&gt;err_bits =3D 0;</div><di=
v><span class=3D"" style=3D"white-space:pre">	</span>io-&gt;err =3D dm_io(i=
o-&gt;io_req, io-&gt;num_regions, io-&gt;region, &amp;io-&gt;err_bits);</di=
v>
<div>}</div><div><br></div><div>/*</div><div>=A0* dm_io wrapper.</div><div>=
=A0* @thread run operation this in other thread to avoid deadlock.</div><di=
v>=A0*/</div><div>static int dm_safe_io_internal(</div><div><span class=3D"=
" style=3D"white-space:pre">		</span>struct dm_io_request *io_req,</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>struct dm_io_regio=
n *region, unsigned num_regions,</div><div><span class=3D"" style=3D"white-=
space:pre">		</span>unsigned long *err_bits, bool thread, int lineno)</div>=
<div>
{</div><div><span class=3D"" style=3D"white-space:pre">	</span>int err;</di=
v><div><span class=3D"" style=3D"white-space:pre">	</span>if (thread) {</di=
v><div><span class=3D"" style=3D"white-space:pre">		</span>struct safe_io i=
o =3D {</div>
<div><span class=3D"" style=3D"white-space:pre">			</span>.io_req =3D io_re=
q,</div><div><span class=3D"" style=3D"white-space:pre">			</span>.region =
=3D region,</div><div><span class=3D"" style=3D"white-space:pre">			</span>=
.num_regions =3D num_regions,</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>};</div><div><br><=
/div><div><span class=3D"" style=3D"white-space:pre">		</span>INIT_WORK_ONS=
TACK(&amp;io.work, safe_io_proc);</div><div><br></div><div><span class=3D""=
 style=3D"white-space:pre">		</span>queue_work(safe_io_wq, &amp;io.work);</=
div>
<div><span class=3D"" style=3D"white-space:pre">		</span>flush_work(&amp;io=
.work);</div><div><br></div><div><span class=3D"" style=3D"white-space:pre"=
>		</span>err =3D io.err;</div><div><span class=3D"" style=3D"white-space:p=
re">		</span>*err_bits =3D io.err_bits;</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>} else {</div><div>=
<span class=3D"" style=3D"white-space:pre">		</span>err =3D dm_io(io_req, n=
um_regions, region, err_bits);</div><div><span class=3D"" style=3D"white-sp=
ace:pre">	</span>}</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>dev_=
t dev =3D region-&gt;bdev-&gt;bd_dev;</div><div><span class=3D"" style=3D"w=
hite-space:pre">	</span>if (err || *err_bits) {</div><div><span class=3D"" =
style=3D"white-space:pre">		</span>DMERR(&quot;L.%d: io err occurs err(%d),=
 err_bits(%lu)&quot;,</div>
<div><span class=3D"" style=3D"white-space:pre">				</span>lineno, err, *er=
r_bits);</div><div><span class=3D"" style=3D"white-space:pre">		</span>DMER=
R(&quot;rw(%d), sector(%lu), dev(%u:%u)&quot;,</div><div><span class=3D"" s=
tyle=3D"white-space:pre">				</span>io_req-&gt;bi_rw, region-&gt;sector,</d=
iv>
<div><span class=3D"" style=3D"white-space:pre">				</span>MAJOR(dev), MINO=
R(dev));</div><div><span class=3D"" style=3D"white-space:pre">	</span>}</di=
v><div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>re=
turn err;</div>
<div>}</div><div>#define dm_safe_io(io_req, region, num_regions, thread) \<=
/div><div><span class=3D"" style=3D"white-space:pre">	</span>dm_safe_io_int=
ernal((io_req), (region), (num_regions), \</div><div><span class=3D"" style=
=3D"white-space:pre">			</span>(thread), __LINE__)</div>
<div><br></div><div>static void dm_safe_io_retry_internal(</div><div><span =
class=3D"" style=3D"white-space:pre">		</span>struct dm_io_request *io_req,=
</div><div><span class=3D"" style=3D"white-space:pre">		</span>struct dm_io=
_region *region, unsigned num_regions,</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>bool thread, int l=
ineno)</div><div>{</div><div><span class=3D"" style=3D"white-space:pre">	</=
span>int err;</div><div><span class=3D"" style=3D"white-space:pre">	</span>=
unsigned long err_bits;</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>int =
count =3D 0;</div><div><br></div><div>retry_io:</div><div><span class=3D"" =
style=3D"white-space:pre">	</span>err_bits =3D 0;</div><div><span class=3D"=
" style=3D"white-space:pre">	</span>err =3D dm_safe_io_internal(io_req, reg=
ion, num_regions, &amp;err_bits,</div>
<div><span class=3D"" style=3D"white-space:pre">			</span>thread, lineno);<=
/div><div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span=
>dev_t dev =3D region-&gt;bdev-&gt;bd_dev;</div><div><span class=3D"" style=
=3D"white-space:pre">	</span>if (err || err_bits) {</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>count++;</div><div=
><span class=3D"" style=3D"white-space:pre">		</span>DMERR(&quot;failed io =
count(%d)&quot;, count);</div><div><br></div><div><span class=3D"" style=3D=
"white-space:pre">		</span>schedule_timeout_interruptible(msecs_to_jiffies(=
1000));</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>goto retry_io;</di=
v><div><span class=3D"" style=3D"white-space:pre">	</span>}</div><div><br><=
/div><div><span class=3D"" style=3D"white-space:pre">	</span>if (count) {</=
div><div>
<span class=3D"" style=3D"white-space:pre">		</span>DMERR(&quot;L.%d: io ha=
s just turned fail to OK.&quot;, lineno);</div><div><span class=3D"" style=
=3D"white-space:pre">		</span>DMERR(&quot;rw(%d), sector(%lu), dev(%u:%u)&q=
uot;,</div>
<div><span class=3D"" style=3D"white-space:pre">			</span>io_req-&gt;bi_rw,=
 region-&gt;sector, MAJOR(dev), MINOR(dev));</div><div><span class=3D"" sty=
le=3D"white-space:pre">	</span>}</div><div>}</div><div>#define dm_safe_io_r=
etry(io_req, region, num_regions, thread) \</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>dm_safe_io_retry_in=
ternal((io_req), (region), \</div><div><span class=3D"" style=3D"white-spac=
e:pre">				</span> =A0(num_regions), (thread), __LINE__)</div><div><br></di=
v><div>
/*</div><div>=A0* device_id =3D 0</div><div>=A0* is reserved for invalid ca=
che block.</div><div>=A0*/</div><div>typedef u8 device_id;</div><div><br></=
div><div>struct lc_device {</div><div><span class=3D"" style=3D"white-space=
:pre">	</span>struct kobject kobj;</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>unsi=
gned char migrate_threshold;</div><div><br></div><div><span class=3D"" styl=
e=3D"white-space:pre">	</span>struct lc_cache *cache;</div><div><br></div><=
div>
<span class=3D"" style=3D"white-space:pre">	</span>device_id id;</div><div>=
<span class=3D"" style=3D"white-space:pre">	</span>struct dm_dev *device;</=
div><div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>=
atomic64_t nr_dirty_caches;</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>stru=
ct mapped_device *md;</div><div>};</div><div><br></div><div>/*</div><div>=
=A0* cache_id =3D 0</div><div>=A0* is reserved for no cache.</div><div>=A0*=
/</div><div>
typedef u8 cache_id;</div><div><br></div><div>/*</div><div>=A0* dm-lc can&#=
39;t manange</div><div>=A0* more than (1 &lt;&lt; 8)</div><div>=A0* virtual=
 devices and cache devices.</div><div>=A0*/</div><div>#define LC_NR_SLOTS (=
(1 &lt;&lt; 8) - 1)</div>
<div><br></div><div>cache_id cache_id_ptr;</div><div><br></div><div>struct =
lc_cache *lc_caches[LC_NR_SLOTS];</div><div><br></div><div>struct lc_device=
 *lc_devices[LC_NR_SLOTS];</div><div><br></div><div>/*</div><div>=A0* Type =
for cache line index.</div>
<div>=A0*</div><div>=A0* dm-lc can supoort a cache device</div><div>=A0* wi=
th size less than 4KB * (1 &lt;&lt; 32)</div><div>=A0* that is 16TB.</div><=
div>=A0* Needless to say, this is enough.</div><div>=A0*/</div><div>typedef=
 u32 cache_nr;</div>
<div><br></div><div>/*</div><div>=A0* Accounts for a 4KB cache line</div><d=
iv>=A0* which consists of eight sectors</div><div>=A0* that is managed by d=
irty bit for each.</div><div>=A0*</div><div>=A0* This allows partial writes=
</div>
<div>=A0* that frees VFS layer from</div><div>=A0* operating read-modify-wr=
ite to</div><div>=A0* commit full 4KB page to block layer.</div><div>=A0*/<=
/div><div>struct metablock {</div><div><span class=3D"" style=3D"white-spac=
e:pre">	</span>sector_t sector;</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>cach=
e_nr idx; /* const. 4B. */</div><div><br></div><div><span class=3D"" style=
=3D"white-space:pre">	</span>struct hlist_node ht_list;</div><div><br></div=
><div>
<span class=3D"" style=3D"white-space:pre">	</span>/*</div><div><span class=
=3D"" style=3D"white-space:pre">	</span> * 8 bit flag for dirtiness</div><d=
iv><span class=3D"" style=3D"white-space:pre">	</span> * for each sector in=
 cache line.</div>
<div><span class=3D"" style=3D"white-space:pre">	</span> *</div><div><span =
class=3D"" style=3D"white-space:pre">	</span> * Now we recover only dirty c=
aches</div><div><span class=3D"" style=3D"white-space:pre">	</span> * in cr=
ash recovery.</div>
<div><span class=3D"" style=3D"white-space:pre">	</span> *</div><div><span =
class=3D"" style=3D"white-space:pre">	</span> * Adding recover flag</div><d=
iv><span class=3D"" style=3D"white-space:pre">	</span> * to recover clean c=
aches</div>
<div><span class=3D"" style=3D"white-space:pre">	</span> * complicate the c=
ode.</div><div><span class=3D"" style=3D"white-space:pre">	</span> */</div>=
<div><span class=3D"" style=3D"white-space:pre">	</span>u8 dirty_bits;</div=
><div><br>
</div><div><span class=3D"" style=3D"white-space:pre">	</span>device_id dev=
ice_id;</div><div>};</div><div><br></div><div>static void inc_nr_dirty_cach=
es(device_id id)</div><div>{</div><div><span class=3D"" style=3D"white-spac=
e:pre">	</span>struct lc_device *o =3D lc_devices[id];</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>BUG_ON(!o);</div><d=
iv><span class=3D"" style=3D"white-space:pre">	</span>atomic64_inc(&amp;o-&=
gt;nr_dirty_caches);</div><div>}</div><div><br></div><div>static void dec_n=
r_dirty_caches(device_id id)</div>
<div>{</div><div><span class=3D"" style=3D"white-space:pre">	</span>struct =
lc_device *o =3D lc_devices[id];</div><div><span class=3D"" style=3D"white-=
space:pre">	</span>BUG_ON(!o);</div><div><span class=3D"" style=3D"white-sp=
ace:pre">	</span>atomic64_dec(&amp;o-&gt;nr_dirty_caches);</div>
<div>}</div><div><br></div><div>struct metablock_device {</div><div><span c=
lass=3D"" style=3D"white-space:pre">	</span>sector_t sector;</div><div><spa=
n class=3D"" style=3D"white-space:pre">	</span>device_id device_id;</div><d=
iv><br>
</div><div><span class=3D"" style=3D"white-space:pre">	</span>u8 dirty_bits=
;</div><div><br></div><div><span class=3D"" style=3D"white-space:pre">	</sp=
an>u32 lap;</div><div>} __packed;</div><div><br></div><div>/*</div><div>=A0=
* We preallocate 64 * 1MB writebuffers and use them cyclically.</div>
<div>=A0* Dynamic allocation using kmalloc results in get_free_page path</d=
iv><div>=A0* that may incur page reclaim which slowdown the system.</div><d=
iv>=A0* This is why we statically preallocate these buffers.</div><div>=A0*=
</div>
<div>=A0* The number 64, though hueristically determined,</div><div>=A0* is=
 usually enough for any workload</div><div>=A0* if having cache device with=
 sufficient</div><div>=A0* sequential write throughput, say 100MB/s.</div><=
div>
=A0*/</div><div>#define NR_WB_POOL 64</div><div>struct writebuffer {</div><=
div><span class=3D"" style=3D"white-space:pre">	</span>void *data;</div><di=
v><span class=3D"" style=3D"white-space:pre">	</span>struct completion done=
;</div>
<div>};</div><div><br></div><div>#define SZ_MAX (~(size_t)0) /* renamed bac=
kport */</div><div>struct segment_header {</div><div><span class=3D"" style=
=3D"white-space:pre">	</span>struct metablock mb_array[NR_CACHES_INSEG];</d=
iv>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>/*</=
div><div><span class=3D"" style=3D"white-space:pre">	</span> * id is not ci=
rculated but uniformly increases.</div><div><span class=3D"" style=3D"white=
-space:pre">	</span> * id =3D 0 is used to tell that the segment is invalid=
</div>
<div><span class=3D"" style=3D"white-space:pre">	</span> * and valid id sta=
rts from 1.</div><div><span class=3D"" style=3D"white-space:pre">	</span> *=
/</div><div><span class=3D"" style=3D"white-space:pre">	</span>size_t globa=
l_id;</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>u8 l=
ength; /* Log length. &lt;=3D NR_CACHES_INSEG */</div><div><br></div><div><=
span class=3D"" style=3D"white-space:pre">	</span>cache_nr start_idx; /* co=
nst */</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>sector_t start_sect=
or; /* const */</div><div><br></div><div><span class=3D"" style=3D"white-sp=
ace:pre">	</span>struct completion flush_done;</div><div><br></div><div><sp=
an class=3D"" style=3D"white-space:pre">	</span>struct completion migrate_d=
one;</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>spin=
lock_t lock;</div><div><br></div><div><span class=3D"" style=3D"white-space=
:pre">	</span>atomic_t nr_inflight_ios;</div><div>};</div><div><br></div><d=
iv>#define lockseg(seg, flags) spin_lock_irqsave(&amp;(seg)-&gt;lock, flags=
)</div>
<div>#define unlockseg(seg, flags) spin_unlock_irqrestore(&amp;(seg)-&gt;lo=
ck, flags)</div><div><br></div><div>static u8 atomic_read_mb_dirtiness(stru=
ct segment_header *seg,</div><div><span class=3D"" style=3D"white-space:pre=
">				</span> =A0 struct metablock *mb)</div>
<div>{</div><div><span class=3D"" style=3D"white-space:pre">	</span>u8 r;</=
div><div><span class=3D"" style=3D"white-space:pre">	</span>unsigned long f=
lags;</div><div><br></div><div><span class=3D"" style=3D"white-space:pre">	=
</span>lockseg(seg, flags);</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>r =3D mb-&gt;dirty_=
bits;</div><div><span class=3D"" style=3D"white-space:pre">	</span>unlockse=
g(seg, flags);</div><div><br></div><div><span class=3D"" style=3D"white-spa=
ce:pre">	</span>return r;</div>
<div>}</div><div><br></div><div>/* At most 4KB in total. */</div><div>struc=
t segment_header_device {</div><div><span class=3D"" style=3D"white-space:p=
re">	</span>/* --- at most512 byte for atomicity. ---*/</div><div><span cla=
ss=3D"" style=3D"white-space:pre">	</span>size_t global_id;</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>u8 length;</div><di=
v><span class=3D"" style=3D"white-space:pre">	</span>u32 lap; /* initially =
0. 1 for the first lap. */</div><div><span class=3D"" style=3D"white-space:=
pre">	</span>/* -----------------------*/</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>/* This array must =
locate at the tail */</div><div><span class=3D"" style=3D"white-space:pre">=
	</span>struct metablock_device mbarr[NR_CACHES_INSEG];</div><div>} __packe=
d;</div>
<div><br></div><div>struct lookup_key {</div><div><span class=3D"" style=3D=
"white-space:pre">	</span>device_id device_id;</div><div><span class=3D"" s=
tyle=3D"white-space:pre">	</span>sector_t sector;</div><div>};</div><div><b=
r></div>
<div>enum STATFLAG {</div><div><span class=3D"" style=3D"white-space:pre">	=
</span>STAT_WRITE =3D 0,</div><div><span class=3D"" style=3D"white-space:pr=
e">	</span>STAT_HIT,</div><div><span class=3D"" style=3D"white-space:pre">	=
</span>STAT_ON_BUFFER,</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>STAT_FULLSIZE,</div=
><div>};</div><div>#define STATLEN (1 &lt;&lt; 4)</div><div><br></div><div>=
struct ht_head {</div><div><span class=3D"" style=3D"white-space:pre">	</sp=
an>struct hlist_head ht_list;</div>
<div>};</div><div><br></div><div>struct lc_cache {</div><div><span class=3D=
"" style=3D"white-space:pre">	</span>struct kobject kobj;</div><div><br></d=
iv><div><span class=3D"" style=3D"white-space:pre">	</span>cache_id id;</di=
v><div>
<span class=3D"" style=3D"white-space:pre">	</span>struct dm_dev *device;</=
div><div><span class=3D"" style=3D"white-space:pre">	</span>struct mutex io=
_lock;</div><div><span class=3D"" style=3D"white-space:pre">	</span>cache_n=
r nr_caches; /* const */</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>size_t nr_segments;=
 /* const */</div><div><span class=3D"" style=3D"white-space:pre">	</span>s=
truct arr *segment_header_array;</div><div><br></div><div><span class=3D"" =
style=3D"white-space:pre">	</span>/*</div>
<div><span class=3D"" style=3D"white-space:pre">	</span> * Chained hashtabl=
e.</div><div><span class=3D"" style=3D"white-space:pre">	</span> */</div><d=
iv><span class=3D"" style=3D"white-space:pre">	</span>struct arr *htable;</=
div><div>
<span class=3D"" style=3D"white-space:pre">	</span>size_t htsize;</div><div=
><span class=3D"" style=3D"white-space:pre">	</span>struct ht_head *null_he=
ad;</div><div><br></div><div><span class=3D"" style=3D"white-space:pre">	</=
span>cache_nr cursor; /* Index that has done write */</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>struct segment_head=
er *current_seg;</div><div><span class=3D"" style=3D"white-space:pre">	</sp=
an>struct writebuffer *current_wb; /* Preallocated buffer. 1024KB */</div><=
div>
<span class=3D"" style=3D"white-space:pre">	</span>struct writebuffer *wb_p=
ool;</div><div><br></div><div><span class=3D"" style=3D"white-space:pre">	<=
/span>size_t last_migrated_segment_id;</div><div><span class=3D"" style=3D"=
white-space:pre">	</span>size_t last_flushed_segment_id;</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>size_t reserving_se=
gment_id;</div><div><br></div><div><span class=3D"" style=3D"white-space:pr=
e">	</span>/*</div><div><span class=3D"" style=3D"white-space:pre">	</span>=
 * For Flush daemon</div>
<div><span class=3D"" style=3D"white-space:pre">	</span> */</div><div><span=
 class=3D"" style=3D"white-space:pre">	</span>spinlock_t flush_queue_lock;<=
/div><div><span class=3D"" style=3D"white-space:pre">	</span>struct list_he=
ad flush_queue;</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>struct work_struct =
flush_work;</div><div><span class=3D"" style=3D"white-space:pre">	</span>wa=
it_queue_head_t flush_wait_queue;</div><div><span class=3D"" style=3D"white=
-space:pre">	</span>struct workqueue_struct *flush_wq;</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>/*</=
div><div><span class=3D"" style=3D"white-space:pre">	</span> * For Migratio=
n daemon</div><div><span class=3D"" style=3D"white-space:pre">	</span> */</=
div><div>
<span class=3D"" style=3D"white-space:pre">	</span>bool allow_migrate;</div=
><div><span class=3D"" style=3D"white-space:pre">	</span>bool force_migrate=
;</div><div><span class=3D"" style=3D"white-space:pre">	</span>struct workq=
ueue_struct *migrate_wq;</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>struct work_struct =
migrate_work;</div><div><br></div><div><span class=3D"" style=3D"white-spac=
e:pre">	</span>/*</div><div><span class=3D"" style=3D"white-space:pre">	</s=
pan> * For migration I/O</div>
<div><span class=3D"" style=3D"white-space:pre">	</span> */</div><div><span=
 class=3D"" style=3D"white-space:pre">	</span>wait_queue_head_t migrate_wai=
t_queue;</div><div><span class=3D"" style=3D"white-space:pre">	</span>atomi=
c_t migrate_fail_count;</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>atomic_t migrate_io=
_count;</div><div><span class=3D"" style=3D"white-space:pre">	</span>u8 dir=
tiness_snapshot[NR_CACHES_INSEG];</div><div><span class=3D"" style=3D"white=
-space:pre">	</span>bool migrate_dests[LC_NR_SLOTS];</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>void *migrate_buffe=
r;</div><div><br></div><div><span class=3D"" style=3D"white-space:pre">	</s=
pan>/*</div><div><span class=3D"" style=3D"white-space:pre">	</span> * For =
deferred flush/FUA handling.</div>
<div><span class=3D"" style=3D"white-space:pre">	</span> */</div><div><span=
 class=3D"" style=3D"white-space:pre">	</span>struct timer_list barrier_dea=
dline_timer;</div><div><span class=3D"" style=3D"white-space:pre">	</span>s=
truct bio_list barrier_ios;</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>unsigned long barri=
er_deadline_ms;</div><div><span class=3D"" style=3D"white-space:pre">	</spa=
n>struct work_struct barrier_deadline_work;</div><div><br></div><div><span =
class=3D"" style=3D"white-space:pre">	</span>bool on_terminate;</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>atom=
ic64_t stat[STATLEN];</div><div><br></div><div><span class=3D"" style=3D"wh=
ite-space:pre">	</span>unsigned long update_interval;</div><div><span class=
=3D"" style=3D"white-space:pre">	</span>unsigned long commit_super_block_in=
terval;</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>unsigned long flush=
_current_buffer_interval;</div><div>};</div><div><br></div><div>static void=
 inc_stat(struct lc_cache *cache,</div><div><span class=3D"" style=3D"white=
-space:pre">		</span> =A0 =A0 int rw, bool found, bool on_buffer, bool full=
size)</div>
<div>{</div><div><span class=3D"" style=3D"white-space:pre">	</span>int i =
=3D 0;</div><div><span class=3D"" style=3D"white-space:pre">	</span>if (rw)=
</div><div><span class=3D"" style=3D"white-space:pre">		</span>i |=3D (1 &l=
t;&lt; STAT_WRITE);</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>if (found)</div><di=
v><span class=3D"" style=3D"white-space:pre">		</span>i |=3D (1 &lt;&lt; ST=
AT_HIT);</div><div><span class=3D"" style=3D"white-space:pre">	</span>if (o=
n_buffer)</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>i |=3D (1 &lt;&lt;=
 STAT_ON_BUFFER);</div><div><span class=3D"" style=3D"white-space:pre">	</s=
pan>if (fullsize)</div><div><span class=3D"" style=3D"white-space:pre">		</=
span>i |=3D (1 &lt;&lt; STAT_FULLSIZE);</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>atom=
ic64_t *v =3D &amp;cache-&gt;stat[i];</div><div><span class=3D"" style=3D"w=
hite-space:pre">	</span>atomic64_inc(v);</div><div>}</div><div><br></div><d=
iv>static void clear_stat(struct lc_cache *cache)</div>
<div>{</div><div><span class=3D"" style=3D"white-space:pre">	</span>int i;<=
/div><div><span class=3D"" style=3D"white-space:pre">	</span>for (i =3D 0; =
i &lt; STATLEN; i++) {</div><div><span class=3D"" style=3D"white-space:pre"=
>		</span>atomic64_t *v =3D &amp;cache-&gt;stat[i];</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>atomic64_set(v, 0)=
;</div><div><span class=3D"" style=3D"white-space:pre">	</span>}</div><div>=
}</div><div><br></div><div>static struct metablock *mb_at(struct lc_cache *=
cache, cache_nr idx)</div>
<div>{</div><div><span class=3D"" style=3D"white-space:pre">	</span>size_t =
seg_idx =3D idx / NR_CACHES_INSEG;</div><div><span class=3D"" style=3D"whit=
e-space:pre">	</span>struct segment_header *seg =3D</div><div><span class=
=3D"" style=3D"white-space:pre">		</span>arr_at(cache-&gt;segment_header_ar=
ray, seg_idx);</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>cache_nr idx_inseg =
=3D idx % NR_CACHES_INSEG;</div><div><span class=3D"" style=3D"white-space:=
pre">	</span>return seg-&gt;mb_array + idx_inseg;</div><div>}</div><div><br=
></div>
<div>static void mb_array_empty_init(struct lc_cache *cache)</div><div>{</d=
iv><div><span class=3D"" style=3D"white-space:pre">	</span>size_t i;</div><=
div><span class=3D"" style=3D"white-space:pre">	</span>for (i =3D 0; i &lt;=
 cache-&gt;nr_caches; i++) {</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>struct metablock *=
mb =3D mb_at(cache, i);</div><div><span class=3D"" style=3D"white-space:pre=
">		</span>INIT_HLIST_NODE(&amp;mb-&gt;ht_list);</div><div><br></div><div><=
span class=3D"" style=3D"white-space:pre">		</span>mb-&gt;idx =3D i;</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>mb-&gt;dirty_bits =
=3D 0;</div><div><span class=3D"" style=3D"white-space:pre">	</span>}</div>=
<div>}</div><div><br></div><div>static void ht_empty_init(struct lc_cache *=
cache)</div>
<div>{</div><div><span class=3D"" style=3D"white-space:pre">	</span>cache-&=
gt;htsize =3D cache-&gt;nr_caches;</div><div><br></div><div><span class=3D"=
" style=3D"white-space:pre">	</span>size_t nr_heads =3D (cache-&gt;htsize +=
 1);</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>struct arr *arr =3D=
 make_arr(sizeof(struct ht_head), nr_heads);</div><div><br></div><div><span=
 class=3D"" style=3D"white-space:pre">	</span>cache-&gt;htable =3D arr;</di=
v><div><br>
</div><div><span class=3D"" style=3D"white-space:pre">	</span>size_t i;</di=
v><div><span class=3D"" style=3D"white-space:pre">	</span>for (i =3D 0; i &=
lt; nr_heads; i++) {</div><div><span class=3D"" style=3D"white-space:pre">	=
	</span>struct ht_head *hd =3D arr_at(arr, i);</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>INIT_HLIST_HEAD(&a=
mp;hd-&gt;ht_list);</div><div><span class=3D"" style=3D"white-space:pre">	<=
/span>}</div><div><br></div><div><span class=3D"" style=3D"white-space:pre"=
>	</span>/*</div>
<div><span class=3D"" style=3D"white-space:pre">	</span> * Our hashtable ha=
s one special bucket called null head.</div><div><span class=3D"" style=3D"=
white-space:pre">	</span> * A metablock is linked to the null head</div><di=
v><span class=3D"" style=3D"white-space:pre">	</span> * if it is not counte=
d in hashtable search.</div>
<div><span class=3D"" style=3D"white-space:pre">	</span> */</div><div><span=
 class=3D"" style=3D"white-space:pre">	</span>cache-&gt;null_head =3D arr_a=
t(cache-&gt;htable, cache-&gt;htsize);</div><div><br></div><div><span class=
=3D"" style=3D"white-space:pre">	</span>cache_nr idx;</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>for (idx =3D 0; idx=
 &lt; cache-&gt;nr_caches; idx++) {</div><div><span class=3D"" style=3D"whi=
te-space:pre">		</span>struct metablock *mb =3D mb_at(cache, idx);</div><di=
v><span class=3D"" style=3D"white-space:pre">		</span>hlist_add_head(&amp;m=
b-&gt;ht_list, &amp;cache-&gt;null_head-&gt;ht_list);</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>}</div><div>}</div>=
<div><br></div><div>static cache_nr ht_hash(struct lc_cache *cache, struct =
lookup_key *key)</div><div>{</div><div><span class=3D"" style=3D"white-spac=
e:pre">	</span>return key-&gt;sector % cache-&gt;htsize;</div>
<div>}</div><div><br></div><div>static bool mb_hit(struct metablock *mb, st=
ruct lookup_key *key)</div><div>{</div><div><span class=3D"" style=3D"white=
-space:pre">	</span>return (mb-&gt;sector =3D=3D key-&gt;sector) &amp;&amp;=
 (mb-&gt;device_id =3D=3D key-&gt;device_id);</div>
<div>}</div><div><br></div><div>static void ht_del(struct lc_cache *cache, =
struct metablock *mb)</div><div>{</div><div><span class=3D"" style=3D"white=
-space:pre">	</span>hlist_del(&amp;mb-&gt;ht_list);</div><div><br></div><di=
v>
<span class=3D"" style=3D"white-space:pre">	</span>struct ht_head *null_hea=
d =3D cache-&gt;null_head;</div><div><span class=3D"" style=3D"white-space:=
pre">	</span>hlist_add_head(&amp;mb-&gt;ht_list, &amp;null_head-&gt;ht_list=
);</div>
<div>}</div><div><br></div><div>static void ht_register(struct lc_cache *ca=
che, struct ht_head *head,</div><div><span class=3D"" style=3D"white-space:=
pre">			</span>struct lookup_key *key, struct metablock *mb)</div><div>{</d=
iv>
<div><span class=3D"" style=3D"white-space:pre">	</span>hlist_del(&amp;mb-&=
gt;ht_list);</div><div><span class=3D"" style=3D"white-space:pre">	</span>h=
list_add_head(&amp;mb-&gt;ht_list, &amp;head-&gt;ht_list);</div><div><br></=
div>
<div><span class=3D"" style=3D"white-space:pre">	</span>mb-&gt;device_id =
=3D key-&gt;device_id;</div><div><span class=3D"" style=3D"white-space:pre"=
>	</span>mb-&gt;sector =3D key-&gt;sector;</div><div>};</div><div><br></div=
><div>static struct metablock *ht_lookup(struct lc_cache *cache,</div>
<div><span class=3D"" style=3D"white-space:pre">				</span> =A0 struct ht_h=
ead *head, struct lookup_key *key)</div><div>{</div><div><span class=3D"" s=
tyle=3D"white-space:pre">	</span>struct metablock *found =3D NULL;</div><di=
v><span class=3D"" style=3D"white-space:pre">	</span>struct metablock *mb;<=
/div>
<div><br></div><div>#if LINUX_VERSION_CODE &gt;=3D KERNEL_VERSION(3, 9, 0)<=
/div><div><span class=3D"" style=3D"white-space:pre">	</span>hlist_for_each=
_entry(mb, &amp;head-&gt;ht_list, ht_list)</div><div>#else</div><div><span =
class=3D"" style=3D"white-space:pre">	</span>struct hlist_node *pos;</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>hlist_for_each_entr=
y(mb, pos, &amp;head-&gt;ht_list, ht_list)</div><div>#endif</div><div><span=
 class=3D"" style=3D"white-space:pre">	</span>{</div><div><span class=3D"" =
style=3D"white-space:pre">		</span>if (mb_hit(mb, key)) {</div>
<div><span class=3D"" style=3D"white-space:pre">			</span>found =3D mb;</di=
v><div><span class=3D"" style=3D"white-space:pre">			</span>break;</div><di=
v><span class=3D"" style=3D"white-space:pre">		</span>}</div><div><span cla=
ss=3D"" style=3D"white-space:pre">	</span>}</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>return found;</div>=
<div>}</div><div><br></div><div>static void discard_caches_inseg(struct lc_=
cache *cache,</div><div><span class=3D"" style=3D"white-space:pre">				</sp=
an> struct segment_header *seg)</div>
<div>{</div><div><span class=3D"" style=3D"white-space:pre">	</span>u8 i;</=
div><div><span class=3D"" style=3D"white-space:pre">	</span>for (i =3D 0; i=
 &lt; NR_CACHES_INSEG; i++) {</div><div><span class=3D"" style=3D"white-spa=
ce:pre">		</span>struct metablock *mb =3D seg-&gt;mb_array + i;</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>ht_del(cache, mb);=
</div><div><span class=3D"" style=3D"white-space:pre">	</span>}</div><div>}=
</div><div><br></div><div>static void init_segment_header_array(struct lc_c=
ache *cache)</div>
<div>{</div><div><span class=3D"" style=3D"white-space:pre">	</span>size_t =
nr_segments =3D cache-&gt;nr_segments;</div><div><br></div><div><span class=
=3D"" style=3D"white-space:pre">	</span>cache-&gt;segment_header_array =3D<=
/div><div>
<span class=3D"" style=3D"white-space:pre">		</span>make_arr(sizeof(struct =
segment_header), nr_segments);</div><div><br></div><div><span class=3D"" st=
yle=3D"white-space:pre">	</span>size_t segment_idx;</div><div><span class=
=3D"" style=3D"white-space:pre">	</span>for (segment_idx =3D 0; segment_idx=
 &lt; nr_segments; segment_idx++) {</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>struct segment_hea=
der *seg =3D</div><div><span class=3D"" style=3D"white-space:pre">			</span=
>arr_at(cache-&gt;segment_header_array, segment_idx);</div><div><span class=
=3D"" style=3D"white-space:pre">		</span>seg-&gt;start_idx =3D NR_CACHES_IN=
SEG * segment_idx;</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>seg-&gt;start_sect=
or =3D</div><div><span class=3D"" style=3D"white-space:pre">			</span>((seg=
ment_idx % nr_segments) + 1) *</div><div><span class=3D"" style=3D"white-sp=
ace:pre">			</span>(1 &lt;&lt; LC_SEGMENTSIZE_ORDER);</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">		</span>seg=
-&gt;length =3D 0;</div><div><br></div><div><span class=3D"" style=3D"white=
-space:pre">		</span>atomic_set(&amp;seg-&gt;nr_inflight_ios, 0);</div><div=
><br></div>
<div><span class=3D"" style=3D"white-space:pre">		</span>spin_lock_init(&am=
p;seg-&gt;lock);</div><div><br></div><div><span class=3D"" style=3D"white-s=
pace:pre">		</span>init_completion(&amp;seg-&gt;flush_done);</div><div><spa=
n class=3D"" style=3D"white-space:pre">		</span>complete_all(&amp;seg-&gt;f=
lush_done);</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">		</span>ini=
t_completion(&amp;seg-&gt;migrate_done);</div><div><span class=3D"" style=
=3D"white-space:pre">		</span>complete_all(&amp;seg-&gt;migrate_done);</div=
><div>
<span class=3D"" style=3D"white-space:pre">	</span>}</div><div>}</div><div>=
<br></div><div>static struct segment_header *get_segment_header_by_id(struc=
t lc_cache *cache,</div><div><span class=3D"" style=3D"white-space:pre">			=
			</span> =A0 =A0 =A0 size_t segment_id)</div>
<div>{</div><div><span class=3D"" style=3D"white-space:pre">	</span>struct =
segment_header *r =3D</div><div><span class=3D"" style=3D"white-space:pre">=
		</span>arr_at(cache-&gt;segment_header_array,</div><div><span class=3D"" =
style=3D"white-space:pre">		</span> =A0 =A0 =A0 (segment_id - 1) % cache-&g=
t;nr_segments);</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>return r;</div><div=
>}</div><div><br></div><div>static u32 calc_segment_lap(struct lc_cache *ca=
che, size_t segment_id)</div><div>{</div><div><span class=3D"" style=3D"whi=
te-space:pre">	</span>u32 a =3D (segment_id - 1) / cache-&gt;nr_segments;</=
div>
<div><span class=3D"" style=3D"white-space:pre">	</span>return a + 1;</div>=
<div>};</div><div><br></div><div>static sector_t calc_mb_start_sector(struc=
t segment_header *seg,</div><div><span class=3D"" style=3D"white-space:pre"=
>				</span> =A0 =A0 cache_nr mb_idx)</div>
<div>{</div><div><span class=3D"" style=3D"white-space:pre">	</span>size_t =
k =3D 1 + (mb_idx % NR_CACHES_INSEG);</div><div><span class=3D"" style=3D"w=
hite-space:pre">	</span>return seg-&gt;start_sector + (k &lt;&lt; 3);</div>=
<div>}</div>
<div><br></div><div>static u8 count_dirty_caches_remained(struct segment_he=
ader *seg)</div><div>{</div><div><span class=3D"" style=3D"white-space:pre"=
>	</span>u8 count =3D 0;</div><div><span class=3D"" style=3D"white-space:pr=
e">	</span>u8 i;</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>struct metablock *m=
b;</div><div><span class=3D"" style=3D"white-space:pre">	</span>for (i =3D =
0; i &lt; seg-&gt;length; i++) {</div><div><span class=3D"" style=3D"white-=
space:pre">		</span>mb =3D seg-&gt;mb_array + i;</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>if (mb-&gt;dirty_b=
its)</div><div><span class=3D"" style=3D"white-space:pre">			</span>count++=
;</div><div><span class=3D"" style=3D"white-space:pre">	</span>}</div><div>=
<span class=3D"" style=3D"white-space:pre">	</span>return count;</div>
<div>}</div><div><br></div><div>static void prepare_segment_header_device(<=
/div><div><span class=3D"" style=3D"white-space:pre">		</span>struct segmen=
t_header_device *dest,</div><div><span class=3D"" style=3D"white-space:pre"=
>		</span>struct lc_cache *cache, struct segment_header *src)</div>
<div>{</div><div><span class=3D"" style=3D"white-space:pre">	</span>dest-&g=
t;global_id =3D src-&gt;global_id;</div><div><span class=3D"" style=3D"whit=
e-space:pre">	</span>dest-&gt;length =3D src-&gt;length;</div><div><span cl=
ass=3D"" style=3D"white-space:pre">	</span>dest-&gt;lap =3D calc_segment_la=
p(cache, src-&gt;global_id);</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>u8 l=
eft =3D src-&gt;length - 1;</div><div><span class=3D"" style=3D"white-space=
:pre">	</span>u8 right =3D (cache-&gt;cursor) % NR_CACHES_INSEG;</div><div>=
<span class=3D"" style=3D"white-space:pre">	</span>BUG_ON(left !=3D right);=
</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>cach=
e_nr i;</div><div><span class=3D"" style=3D"white-space:pre">	</span>for (i=
 =3D 0; i &lt; src-&gt;length; i++) {</div><div><span class=3D"" style=3D"w=
hite-space:pre">		</span>struct metablock *mb =3D src-&gt;mb_array + i;</di=
v>
<div><span class=3D"" style=3D"white-space:pre">		</span>struct metablock_d=
evice *mbdev =3D &amp;dest-&gt;mbarr[i];</div><div><span class=3D"" style=
=3D"white-space:pre">		</span>mbdev-&gt;device_id =3D mb-&gt;device_id;</di=
v><div><span class=3D"" style=3D"white-space:pre">		</span>mbdev-&gt;sector=
 =3D mb-&gt;sector;</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>mbdev-&gt;dirty_bi=
ts =3D mb-&gt;dirty_bits;</div><div><span class=3D"" style=3D"white-space:p=
re">		</span>mbdev-&gt;lap =3D dest-&gt;lap;</div><div><span class=3D"" sty=
le=3D"white-space:pre">	</span>}</div>
<div>}</div><div><br></div><div>struct flush_context {</div><div><span clas=
s=3D"" style=3D"white-space:pre">	</span>struct list_head flush_queue;</div=
><div><span class=3D"" style=3D"white-space:pre">	</span>struct segment_hea=
der *seg;</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>struct writebuffer =
*wb;</div><div><span class=3D"" style=3D"white-space:pre">	</span>struct bi=
o_list barrier_ios;</div><div>};</div><div><br></div><div>static void flush=
_proc(struct work_struct *work)</div>
<div>{</div><div><span class=3D"" style=3D"white-space:pre">	</span>unsigne=
d long flags;</div><div><span class=3D"" style=3D"white-space:pre">	</span>=
struct lc_cache *cache =3D</div><div><span class=3D"" style=3D"white-space:=
pre">		</span>container_of(work, struct lc_cache, flush_work);</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>whil=
e (true) {</div><div><span class=3D"" style=3D"white-space:pre">		</span>sp=
in_lock_irqsave(&amp;cache-&gt;flush_queue_lock, flags);</div><div><span cl=
ass=3D"" style=3D"white-space:pre">		</span>while (list_empty(&amp;cache-&g=
t;flush_queue)) {</div>
<div><span class=3D"" style=3D"white-space:pre">			</span>spin_unlock_irqre=
store(&amp;cache-&gt;flush_queue_lock, flags);</div><div><span class=3D"" s=
tyle=3D"white-space:pre">			</span>wait_event_interruptible_timeout(</div><=
div>
<span class=3D"" style=3D"white-space:pre">				</span>cache-&gt;flush_wait_=
queue,</div><div><span class=3D"" style=3D"white-space:pre">				</span>(!li=
st_empty(&amp;cache-&gt;flush_queue)),</div><div><span class=3D"" style=3D"=
white-space:pre">				</span>msecs_to_jiffies(100));</div>
<div><span class=3D"" style=3D"white-space:pre">			</span>spin_lock_irqsave=
(&amp;cache-&gt;flush_queue_lock, flags);</div><div><br></div><div><span cl=
ass=3D"" style=3D"white-space:pre">			</span>if (cache-&gt;on_terminate)</d=
iv><div>
<span class=3D"" style=3D"white-space:pre">				</span>return;</div><div><sp=
an class=3D"" style=3D"white-space:pre">		</span>}</div><div><br></div><div=
><span class=3D"" style=3D"white-space:pre">		</span>/* Pop the first entry=
 */</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>struct flush_conte=
xt *ctx;</div><div><span class=3D"" style=3D"white-space:pre">		</span>ctx =
=3D list_first_entry(</div><div><span class=3D"" style=3D"white-space:pre">=
			</span>&amp;cache-&gt;flush_queue, struct flush_context, flush_queue);</=
div>
<div><span class=3D"" style=3D"white-space:pre">		</span>list_del(&amp;ctx-=
&gt;flush_queue);</div><div><span class=3D"" style=3D"white-space:pre">		</=
span>spin_unlock_irqrestore(&amp;cache-&gt;flush_queue_lock, flags);</div><=
div>
<br></div><div><span class=3D"" style=3D"white-space:pre">		</span>struct s=
egment_header *seg =3D ctx-&gt;seg;</div><div><br></div><div><span class=3D=
"" style=3D"white-space:pre">		</span>struct dm_io_request io_req =3D {</di=
v><div><span class=3D"" style=3D"white-space:pre">			</span>.client =3D lc_=
io_client,</div>
<div><span class=3D"" style=3D"white-space:pre">			</span>.bi_rw =3D WRITE,=
</div><div><span class=3D"" style=3D"white-space:pre">			</span>.notify.fn =
=3D NULL,</div><div><span class=3D"" style=3D"white-space:pre">			</span>.m=
em.type =3D DM_IO_KMEM,</div>
<div><span class=3D"" style=3D"white-space:pre">			</span>.mem.ptr.addr =3D=
 ctx-&gt;wb-&gt;data,</div><div><span class=3D"" style=3D"white-space:pre">=
		</span>};</div><div><span class=3D"" style=3D"white-space:pre">		</span>s=
truct dm_io_region region =3D {</div>
<div><span class=3D"" style=3D"white-space:pre">			</span>.bdev =3D cache-&=
gt;device-&gt;bdev,</div><div><span class=3D"" style=3D"white-space:pre">		=
	</span>.sector =3D seg-&gt;start_sector,</div><div><span class=3D"" style=
=3D"white-space:pre">			</span>.count =3D (seg-&gt;length + 1) &lt;&lt; 3,<=
/div>
<div><span class=3D"" style=3D"white-space:pre">		</span>};</div><div><span=
 class=3D"" style=3D"white-space:pre">		</span>dm_safe_io_retry(&amp;io_req=
, &amp;region, 1, false);</div><div><br></div><div><span class=3D"" style=
=3D"white-space:pre">		</span>cache-&gt;last_flushed_segment_id =3D seg-&gt=
;global_id;</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">		</span>com=
plete_all(&amp;seg-&gt;flush_done);</div><div><br></div><div><span class=3D=
"" style=3D"white-space:pre">		</span>complete_all(&amp;ctx-&gt;wb-&gt;done=
);</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">		</span>if =
(!bio_list_empty(&amp;ctx-&gt;barrier_ios)) {</div><div><span class=3D"" st=
yle=3D"white-space:pre">			</span>blkdev_issue_flush(cache-&gt;device-&gt;b=
dev, GFP_NOIO, NULL);</div>
<div><span class=3D"" style=3D"white-space:pre">			</span>struct bio *bio;<=
/div><div><span class=3D"" style=3D"white-space:pre">			</span>while ((bio =
=3D bio_list_pop(&amp;ctx-&gt;barrier_ios)))</div><div><span class=3D"" sty=
le=3D"white-space:pre">				</span>bio_endio(bio, 0);</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">			</span>mo=
d_timer(&amp;cache-&gt;barrier_deadline_timer,</div><div><span class=3D"" s=
tyle=3D"white-space:pre">				</span> =A0msecs_to_jiffies(cache-&gt;barrier_=
deadline_ms));</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>}</div><div><br></=
div><div><span class=3D"" style=3D"white-space:pre">		</span>kfree(ctx);</d=
iv><div><span class=3D"" style=3D"white-space:pre">	</span>}</div><div>}</d=
iv><div>
<br></div><div>static void prepare_meta_writebuffer(void *writebuffer, stru=
ct lc_cache *cache,</div><div><span class=3D"" style=3D"white-space:pre">		=
		</span> =A0 =A0 struct segment_header *seg)</div><div>{</div><div><span c=
lass=3D"" style=3D"white-space:pre">	</span>prepare_segment_header_device(w=
ritebuffer, cache, seg);</div>
<div>}</div><div><br></div><div>static void queue_flushing(struct lc_cache =
*cache)</div><div>{</div><div><span class=3D"" style=3D"white-space:pre">	<=
/span>unsigned long flags;</div><div><span class=3D"" style=3D"white-space:=
pre">	</span>struct segment_header *current_seg =3D cache-&gt;current_seg;<=
/div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>size=
_t n1 =3D 0;</div><div><span class=3D"" style=3D"white-space:pre">	</span>w=
hile (atomic_read(&amp;current_seg-&gt;nr_inflight_ios)) {</div><div><span =
class=3D"" style=3D"white-space:pre">		</span>n1++;</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>if (n1 =3D=3D 100)=
</div><div><span class=3D"" style=3D"white-space:pre">			</span>DMWARN(</di=
v><div><span class=3D"" style=3D"white-space:pre">			</span>&quot;Too long =
to wait for current_seg ios to finish.&quot;);</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>schedule_timeout_i=
nterruptible(msecs_to_jiffies(1));</div><div><span class=3D"" style=3D"whit=
e-space:pre">	</span>}</div><div><br></div><div><span class=3D"" style=3D"w=
hite-space:pre">	</span>prepare_meta_writebuffer(cache-&gt;current_wb-&gt;d=
ata, cache,</div>
<div><span class=3D"" style=3D"white-space:pre">				</span> cache-&gt;curre=
nt_seg);</div><div><br></div><div><span class=3D"" style=3D"white-space:pre=
">	</span>INIT_COMPLETION(current_seg-&gt;migrate_done);</div><div><span cl=
ass=3D"" style=3D"white-space:pre">	</span>INIT_COMPLETION(current_seg-&gt;=
flush_done);</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>stru=
ct flush_context *ctx =3D kmalloc_retry(sizeof(*ctx), GFP_NOIO);</div><div>=
<span class=3D"" style=3D"white-space:pre">	</span>INIT_LIST_HEAD(&amp;ctx-=
&gt;flush_queue);</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>ctx-&gt;seg =3D cur=
rent_seg;</div><div><span class=3D"" style=3D"white-space:pre">	</span>ctx-=
&gt;wb =3D cache-&gt;current_wb;</div><div><br></div><div><span class=3D"" =
style=3D"white-space:pre">	</span>bio_list_init(&amp;ctx-&gt;barrier_ios);<=
/div>
<div><span class=3D"" style=3D"white-space:pre">	</span>bio_list_merge(&amp=
;ctx-&gt;barrier_ios, &amp;cache-&gt;barrier_ios);</div><div><span class=3D=
"" style=3D"white-space:pre">	</span>bio_list_init(&amp;cache-&gt;barrier_i=
os);</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>spin=
_lock_irqsave(&amp;cache-&gt;flush_queue_lock, flags);</div><div><span clas=
s=3D"" style=3D"white-space:pre">	</span>bool empty =3D list_empty(&amp;cac=
he-&gt;flush_queue);</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>list_add_tail(&amp;=
ctx-&gt;flush_queue, &amp;cache-&gt;flush_queue);</div><div><span class=3D"=
" style=3D"white-space:pre">	</span>spin_unlock_irqrestore(&amp;cache-&gt;f=
lush_queue_lock, flags);</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>if (empty)</div><di=
v><span class=3D"" style=3D"white-space:pre">		</span>wake_up_interruptible=
(&amp;cache-&gt;flush_wait_queue);</div><div><br></div><div><span class=3D"=
" style=3D"white-space:pre">	</span>size_t next_id =3D current_seg-&gt;glob=
al_id + 1;</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>struct segment_head=
er *new_seg =3D</div><div><span class=3D"" style=3D"white-space:pre">		</sp=
an>get_segment_header_by_id(cache, next_id);</div><div><span class=3D"" sty=
le=3D"white-space:pre">	</span>new_seg-&gt;global_id =3D next_id;</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>size=
_t n2 =3D 0;</div><div><span class=3D"" style=3D"white-space:pre">	</span>w=
hile (atomic_read(&amp;new_seg-&gt;nr_inflight_ios)) {</div><div><span clas=
s=3D"" style=3D"white-space:pre">		</span>n2++;</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>if (n2 =3D=3D 100)=
</div><div><span class=3D"" style=3D"white-space:pre">			</span>DMWARN(</di=
v><div><span class=3D"" style=3D"white-space:pre">			</span>&quot;Too long =
to wait for new_seg ios to finish.&quot;);</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>schedule_timeout_i=
nterruptible(msecs_to_jiffies(1));</div><div><span class=3D"" style=3D"whit=
e-space:pre">	</span>}</div><div><br></div><div><span class=3D"" style=3D"w=
hite-space:pre">	</span>u8 nr_new =3D count_dirty_caches_remained(new_seg);=
</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>BUG_ON(nr_new);</di=
v><div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>di=
scard_caches_inseg(cache, new_seg);</div><div><br></div><div><span class=3D=
"" style=3D"white-space:pre">	</span>/* Set the cursor to the last of the f=
lushed segment. */</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>cache-&gt;cursor =
=3D current_seg-&gt;start_idx + (NR_CACHES_INSEG - 1);</div><div><span clas=
s=3D"" style=3D"white-space:pre">	</span>new_seg-&gt;length =3D 0;</div><di=
v><br></div>
<div><span class=3D"" style=3D"white-space:pre">	</span>struct writebuffer =
*next_wb =3D cache-&gt;wb_pool + (next_id % NR_WB_POOL);</div><div><span cl=
ass=3D"" style=3D"white-space:pre">	</span>wait_for_completion(&amp;next_wb=
-&gt;done);</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>INIT_COMPLETION(nex=
t_wb-&gt;done);</div><div><br></div><div><span class=3D"" style=3D"white-sp=
ace:pre">	</span>cache-&gt;current_wb =3D next_wb;</div><div><br></div><div=
><span class=3D"" style=3D"white-space:pre">	</span>cache-&gt;current_seg =
=3D new_seg;</div>
<div>}</div><div><br></div><div>static void migrate_mb(</div><div><span cla=
ss=3D"" style=3D"white-space:pre">		</span>struct lc_cache *cache, struct s=
egment_header *seg,</div><div><span class=3D"" style=3D"white-space:pre">		=
</span>struct metablock *mb, u8 dirty_bits, bool thread)</div>
<div>{</div><div><span class=3D"" style=3D"white-space:pre">	</span>struct =
lc_device *lc =3D lc_devices[mb-&gt;device_id];</div><div><br></div><div><s=
pan class=3D"" style=3D"white-space:pre">	</span>if (!dirty_bits)</div><div=
><span class=3D"" style=3D"white-space:pre">		</span>return;</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>if (=
dirty_bits =3D=3D 255) {</div><div><span class=3D"" style=3D"white-space:pr=
e">		</span>void *buf =3D kmalloc_retry(1 &lt;&lt; 12, GFP_NOIO);</div><div=
><br></div>
<div><span class=3D"" style=3D"white-space:pre">		</span>struct dm_io_reque=
st io_req_r =3D {</div><div><span class=3D"" style=3D"white-space:pre">			<=
/span>.client =3D lc_io_client,</div><div><span class=3D"" style=3D"white-s=
pace:pre">			</span>.bi_rw =3D READ,</div>
<div><span class=3D"" style=3D"white-space:pre">			</span>.notify.fn =3D NU=
LL,</div><div><span class=3D"" style=3D"white-space:pre">			</span>.mem.typ=
e =3D DM_IO_KMEM,</div><div><span class=3D"" style=3D"white-space:pre">			<=
/span>.mem.ptr.addr =3D buf,</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>};</div><div><span=
 class=3D"" style=3D"white-space:pre">		</span>struct dm_io_region region_r=
 =3D {</div><div><span class=3D"" style=3D"white-space:pre">			</span>.bdev=
 =3D cache-&gt;device-&gt;bdev,</div>
<div><span class=3D"" style=3D"white-space:pre">			</span>.sector =3D calc_=
mb_start_sector(seg, mb-&gt;idx),</div><div><span class=3D"" style=3D"white=
-space:pre">			</span>.count =3D (1 &lt;&lt; 3),</div><div><span class=3D""=
 style=3D"white-space:pre">		</span>};</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>dm_safe_io_retry(&=
amp;io_req_r, &amp;region_r, 1, thread);</div><div><br></div><div><span cla=
ss=3D"" style=3D"white-space:pre">		</span>struct dm_io_request io_req_w =
=3D {</div>
<div><span class=3D"" style=3D"white-space:pre">			</span>.client =3D lc_io=
_client,</div><div><span class=3D"" style=3D"white-space:pre">			</span>.bi=
_rw =3D WRITE_FUA,</div><div><span class=3D"" style=3D"white-space:pre">			=
</span>.notify.fn =3D NULL,</div>
<div><span class=3D"" style=3D"white-space:pre">			</span>.mem.type =3D DM_=
IO_KMEM,</div><div><span class=3D"" style=3D"white-space:pre">			</span>.me=
m.ptr.addr =3D buf,</div><div><span class=3D"" style=3D"white-space:pre">		=
</span>};</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>struct dm_io_regio=
n region_w =3D {</div><div><span class=3D"" style=3D"white-space:pre">			</=
span>.bdev =3D lc-&gt;device-&gt;bdev,</div><div><span class=3D"" style=3D"=
white-space:pre">			</span>.sector =3D mb-&gt;sector,</div>
<div><span class=3D"" style=3D"white-space:pre">			</span>.count =3D (1 &lt=
;&lt; 3),</div><div><span class=3D"" style=3D"white-space:pre">		</span>};<=
/div><div><span class=3D"" style=3D"white-space:pre">		</span>dm_safe_io_re=
try(&amp;io_req_w, &amp;region_w, 1, thread);</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">		</span>kfr=
ee(buf);</div><div><span class=3D"" style=3D"white-space:pre">	</span>} els=
e {</div><div><span class=3D"" style=3D"white-space:pre">		</span>void *buf=
 =3D kmalloc_retry(1 &lt;&lt; SECTOR_SHIFT, GFP_NOIO);</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>size_t i;</div><di=
v><span class=3D"" style=3D"white-space:pre">		</span>for (i =3D 0; i &lt; =
8; i++) {</div><div><span class=3D"" style=3D"white-space:pre">			</span>bo=
ol bit_on =3D dirty_bits &amp; (1 &lt;&lt; i);</div>
<div><span class=3D"" style=3D"white-space:pre">			</span>if (!bit_on)</div=
><div><span class=3D"" style=3D"white-space:pre">				</span>continue;</div>=
<div><br></div><div><span class=3D"" style=3D"white-space:pre">			</span>st=
ruct dm_io_request io_req_r =3D {</div>
<div><span class=3D"" style=3D"white-space:pre">				</span>.client =3D lc_i=
o_client,</div><div><span class=3D"" style=3D"white-space:pre">				</span>.=
bi_rw =3D READ,</div><div><span class=3D"" style=3D"white-space:pre">				</=
span>.notify.fn =3D NULL,</div>
<div><span class=3D"" style=3D"white-space:pre">				</span>.mem.type =3D DM=
_IO_KMEM,</div><div><span class=3D"" style=3D"white-space:pre">				</span>.=
mem.ptr.addr =3D buf,</div><div><span class=3D"" style=3D"white-space:pre">=
			</span>};</div>
<div><span class=3D"" style=3D"white-space:pre">			</span>/* A tmp variable=
 just to avoid 80 cols rule */</div><div><span class=3D"" style=3D"white-sp=
ace:pre">			</span>sector_t src =3D calc_mb_start_sector(seg, mb-&gt;idx) +=
 i;</div>
<div><span class=3D"" style=3D"white-space:pre">			</span>struct dm_io_regi=
on region_r =3D {</div><div><span class=3D"" style=3D"white-space:pre">				=
</span>.bdev =3D cache-&gt;device-&gt;bdev,</div><div><span class=3D"" styl=
e=3D"white-space:pre">				</span>.sector =3D src,</div>
<div><span class=3D"" style=3D"white-space:pre">				</span>.count =3D 1,</d=
iv><div><span class=3D"" style=3D"white-space:pre">			</span>};</div><div><=
span class=3D"" style=3D"white-space:pre">			</span>dm_safe_io_retry(&amp;i=
o_req_r, &amp;region_r, 1, thread);</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">			</span>st=
ruct dm_io_request io_req_w =3D {</div><div><span class=3D"" style=3D"white=
-space:pre">				</span>.client =3D lc_io_client,</div><div><span class=3D""=
 style=3D"white-space:pre">				</span>.bi_rw =3D WRITE,</div>
<div><span class=3D"" style=3D"white-space:pre">				</span>.notify.fn =3D N=
ULL,</div><div><span class=3D"" style=3D"white-space:pre">				</span>.mem.t=
ype =3D DM_IO_KMEM,</div><div><span class=3D"" style=3D"white-space:pre">		=
		</span>.mem.ptr.addr =3D buf,</div>
<div><span class=3D"" style=3D"white-space:pre">			</span>};</div><div><spa=
n class=3D"" style=3D"white-space:pre">			</span>struct dm_io_region region=
_w =3D {</div><div><span class=3D"" style=3D"white-space:pre">				</span>.b=
dev =3D lc-&gt;device-&gt;bdev,</div>
<div><span class=3D"" style=3D"white-space:pre">				</span>.sector =3D mb-&=
gt;sector + 1 * i,</div><div><span class=3D"" style=3D"white-space:pre">			=
	</span>.count =3D 1,</div><div><span class=3D"" style=3D"white-space:pre">=
			</span>};</div>
<div><span class=3D"" style=3D"white-space:pre">			</span>dm_safe_io_retry(=
&amp;io_req_w, &amp;region_w, 1, thread);</div><div><span class=3D"" style=
=3D"white-space:pre">		</span>}</div><div><span class=3D"" style=3D"white-s=
pace:pre">		</span>kfree(buf);</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>}</div><div>}</div>=
<div><br></div><div>static void migrate_endio(unsigned long error, void *__=
context)</div><div>{</div><div><span class=3D"" style=3D"white-space:pre">	=
</span>struct lc_cache *cache =3D __context;</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>if (=
error)</div><div><span class=3D"" style=3D"white-space:pre">		</span>atomic=
_inc(&amp;cache-&gt;migrate_fail_count);</div><div><br></div><div><span cla=
ss=3D"" style=3D"white-space:pre">	</span>if (atomic_dec_and_test(&amp;cach=
e-&gt;migrate_io_count))</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>wake_up_interrupti=
ble(&amp;cache-&gt;migrate_wait_queue);</div><div>}</div><div><br></div><di=
v>static void migrate_whole_segment(struct lc_cache *cache,</div><div><span=
 class=3D"" style=3D"white-space:pre">				</span> =A0struct segment_header =
*seg)</div>
<div>{</div><div><span class=3D"" style=3D"white-space:pre">	</span>struct =
dm_io_request io_req_r =3D {</div><div><span class=3D"" style=3D"white-spac=
e:pre">		</span>.client =3D lc_io_client,</div><div><span class=3D"" style=
=3D"white-space:pre">		</span>.bi_rw =3D READ,</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>.notify.fn =3D NUL=
L,</div><div><span class=3D"" style=3D"white-space:pre">		</span>.mem.type =
=3D DM_IO_KMEM,</div><div><span class=3D"" style=3D"white-space:pre">		</sp=
an>.mem.ptr.addr =3D cache-&gt;migrate_buffer,</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>};</div><div><span =
class=3D"" style=3D"white-space:pre">	</span>struct dm_io_region region_r =
=3D {</div><div><span class=3D"" style=3D"white-space:pre">		</span>.bdev =
=3D cache-&gt;device-&gt;bdev,</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>.sector =3D seg-&g=
t;start_sector,</div><div><span class=3D"" style=3D"white-space:pre">		</sp=
an>.count =3D (seg-&gt;length + 1) &lt;&lt; 3,</div><div><span class=3D"" s=
tyle=3D"white-space:pre">	</span>};</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>dm_safe_io_retry(&a=
mp;io_req_r, &amp;region_r, 1, false);</div><div><br></div><div>migrate_wri=
te:</div><div><span class=3D"" style=3D"white-space:pre">	</span>;</div><di=
v><span class=3D"" style=3D"white-space:pre">	</span>unsigned long flags;</=
div>
<div><span class=3D"" style=3D"white-space:pre">	</span>struct metablock *m=
b;</div><div><span class=3D"" style=3D"white-space:pre">	</span>u8 i, j;</d=
iv><div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>a=
tomic_set(&amp;cache-&gt;migrate_io_count, 0);</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>atomic_set(&amp;cac=
he-&gt;migrate_fail_count, 0);</div><div><br></div><div><span class=3D"" st=
yle=3D"white-space:pre">	</span>for (i =3D 0; i &lt; LC_NR_SLOTS; i++)</div=
><div>
<span class=3D"" style=3D"white-space:pre">		</span>*(cache-&gt;migrate_des=
ts + i) =3D false;</div><div><br></div><div><span class=3D"" style=3D"white=
-space:pre">	</span>for (i =3D 0; i &lt; seg-&gt;length; i++) {</div><div><=
span class=3D"" style=3D"white-space:pre">		</span>mb =3D seg-&gt;mb_array =
+ i;</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>*(cache-&gt;dirtin=
ess_snapshot + i) =3D</div><div><span class=3D"" style=3D"white-space:pre">=
			</span>atomic_read_mb_dirtiness(seg, mb);</div><div><span class=3D"" sty=
le=3D"white-space:pre">	</span>}</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>for =
(i =3D 0; i &lt; seg-&gt;length; i++) {</div><div><span class=3D"" style=3D=
"white-space:pre">		</span>mb =3D seg-&gt;mb_array + i;</div><div><br></div=
><div><span class=3D"" style=3D"white-space:pre">		</span>u8 dirty_bits =3D=
 *(cache-&gt;dirtiness_snapshot + i);</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">		</span>if =
(!dirty_bits)</div><div><span class=3D"" style=3D"white-space:pre">			</spa=
n>continue;</div><div><br></div><div><span class=3D"" style=3D"white-space:=
pre">		</span>*(cache-&gt;migrate_dests + mb-&gt;device_id) =3D true;</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">		</span>if =
(dirty_bits =3D=3D 255) {</div><div><span class=3D"" style=3D"white-space:p=
re">			</span>atomic_inc(&amp;cache-&gt;migrate_io_count);</div><div><span =
class=3D"" style=3D"white-space:pre">		</span>} else {</div>
<div><span class=3D"" style=3D"white-space:pre">			</span>for (j =3D 0; j &=
lt; 8; j++) {</div><div><span class=3D"" style=3D"white-space:pre">				</sp=
an>if (dirty_bits &amp; (1 &lt;&lt; j))</div><div><span class=3D"" style=3D=
"white-space:pre">					</span>atomic_inc(&amp;cache-&gt;migrate_io_count);<=
/div>
<div><span class=3D"" style=3D"white-space:pre">			</span>}</div><div><span=
 class=3D"" style=3D"white-space:pre">		</span>}</div><div><span class=3D""=
 style=3D"white-space:pre">	</span>}</div><div><br></div><div><span class=
=3D"" style=3D"white-space:pre">	</span>struct lc_device *lc;</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>for (i =3D 0; i &lt=
; seg-&gt;length; i++) {</div><div><span class=3D"" style=3D"white-space:pr=
e">		</span>mb =3D seg-&gt;mb_array + i;</div><div><br></div><div><span cla=
ss=3D"" style=3D"white-space:pre">		</span>lc =3D lc_devices[mb-&gt;device_=
id];</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>u8 dirty_bits =3D =
*(cache-&gt;dirtiness_snapshot + i);</div><div><br></div><div><span class=
=3D"" style=3D"white-space:pre">		</span>if (!dirty_bits)</div><div><span c=
lass=3D"" style=3D"white-space:pre">			</span>continue;</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">		</span>uns=
igned long diff =3D ((1 + i) &lt;&lt; 3) &lt;&lt; SECTOR_SHIFT;</div><div><=
span class=3D"" style=3D"white-space:pre">		</span>void *base =3D cache-&gt=
;migrate_buffer + diff;</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">		</span>voi=
d *addr;</div><div><span class=3D"" style=3D"white-space:pre">		</span>if (=
dirty_bits =3D=3D 255) {</div><div><span class=3D"" style=3D"white-space:pr=
e">			</span>addr =3D base;</div>
<div><span class=3D"" style=3D"white-space:pre">			</span>struct dm_io_requ=
est io_req_w =3D {</div><div><span class=3D"" style=3D"white-space:pre">			=
	</span>.client =3D lc_io_client,</div><div><span class=3D"" style=3D"white=
-space:pre">				</span>.bi_rw =3D WRITE,</div>
<div><span class=3D"" style=3D"white-space:pre">				</span>.notify.fn =3D m=
igrate_endio,</div><div><span class=3D"" style=3D"white-space:pre">				</sp=
an>.notify.context =3D cache,</div><div><span class=3D"" style=3D"white-spa=
ce:pre">				</span>.mem.type =3D DM_IO_KMEM,</div>
<div><span class=3D"" style=3D"white-space:pre">				</span>.mem.ptr.addr =
=3D addr,</div><div><span class=3D"" style=3D"white-space:pre">			</span>};=
</div><div><span class=3D"" style=3D"white-space:pre">			</span>struct dm_i=
o_region region_w =3D {</div>
<div><span class=3D"" style=3D"white-space:pre">				</span>.bdev =3D lc-&gt=
;device-&gt;bdev,</div><div><span class=3D"" style=3D"white-space:pre">				=
</span>.sector =3D mb-&gt;sector,</div><div><span class=3D"" style=3D"white=
-space:pre">				</span>.count =3D (1 &lt;&lt; 3),</div>
<div><span class=3D"" style=3D"white-space:pre">			</span>};</div><div><spa=
n class=3D"" style=3D"white-space:pre">			</span>dm_safe_io_retry(&amp;io_r=
eq_w, &amp;region_w, 1, false);</div><div><span class=3D"" style=3D"white-s=
pace:pre">		</span>} else {</div>
<div><span class=3D"" style=3D"white-space:pre">			</span>for (j =3D 0; j &=
lt; 8; j++) {</div><div><span class=3D"" style=3D"white-space:pre">				</sp=
an>bool b =3D dirty_bits &amp; (1 &lt;&lt; j);</div><div><span class=3D"" s=
tyle=3D"white-space:pre">				</span>if (!b)</div>
<div><span class=3D"" style=3D"white-space:pre">					</span>continue;</div>=
<div><br></div><div><span class=3D"" style=3D"white-space:pre">				</span>a=
ddr =3D base + (j &lt;&lt; SECTOR_SHIFT);</div><div><span class=3D"" style=
=3D"white-space:pre">				</span>struct dm_io_request io_req_w =3D {</div>
<div><span class=3D"" style=3D"white-space:pre">					</span>.client =3D lc_=
io_client,</div><div><span class=3D"" style=3D"white-space:pre">					</span=
>.bi_rw =3D WRITE,</div><div><span class=3D"" style=3D"white-space:pre">			=
		</span>.notify.fn =3D migrate_endio,</div>
<div><span class=3D"" style=3D"white-space:pre">					</span>.notify.context=
 =3D cache,</div><div><span class=3D"" style=3D"white-space:pre">					</spa=
n>.mem.type =3D DM_IO_KMEM,</div><div><span class=3D"" style=3D"white-space=
:pre">					</span>.mem.ptr.addr =3D addr,</div>
<div><span class=3D"" style=3D"white-space:pre">				</span>};</div><div><sp=
an class=3D"" style=3D"white-space:pre">				</span>struct dm_io_region regi=
on_w =3D {</div><div><span class=3D"" style=3D"white-space:pre">					</span=
>.bdev =3D lc-&gt;device-&gt;bdev,</div>
<div><span class=3D"" style=3D"white-space:pre">					</span>.sector =3D mb-=
&gt;sector + j,</div><div><span class=3D"" style=3D"white-space:pre">					<=
/span>.count =3D 1,</div><div><span class=3D"" style=3D"white-space:pre">		=
		</span>};</div>
<div><span class=3D"" style=3D"white-space:pre">				</span>dm_safe_io_retry=
(</div><div><span class=3D"" style=3D"white-space:pre">					</span>&amp;io_=
req_w, &amp;region_w, 1, false);</div><div><span class=3D"" style=3D"white-=
space:pre">			</span>}</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>}</div><div><span =
class=3D"" style=3D"white-space:pre">	</span>}</div><div><br></div><div><sp=
an class=3D"" style=3D"white-space:pre">	</span>wait_event_interruptible(ca=
che-&gt;migrate_wait_queue,</div>
<div><span class=3D"" style=3D"white-space:pre">				</span> (atomic_read(&a=
mp;cache-&gt;migrate_io_count) =3D=3D 0));</div><div><br></div><div><span c=
lass=3D"" style=3D"white-space:pre">	</span>if (atomic_read(&amp;cache-&gt;=
migrate_fail_count)) {</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>DMERR(&quot;migrat=
e failed. %u writebacks failed. redo.&quot;,</div><div><span class=3D"" sty=
le=3D"white-space:pre">				</span>atomic_read(&amp;cache-&gt;migrate_fail_c=
ount));</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>goto migrate_write=
;</div><div><span class=3D"" style=3D"white-space:pre">	</span>}</div><div>=
<br></div><div><span class=3D"" style=3D"white-space:pre">	</span>BUG_ON(at=
omic_read(&amp;cache-&gt;migrate_io_count));</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>for =
(i =3D 0; i &lt; seg-&gt;length; i++) {</div><div><span class=3D"" style=3D=
"white-space:pre">		</span>mb =3D seg-&gt;mb_array + i;</div><div><br></div=
><div><span class=3D"" style=3D"white-space:pre">		</span>bool b =3D false;=
</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>lockseg(seg, flags=
);</div><div><span class=3D"" style=3D"white-space:pre">		</span>if (mb-&gt=
;dirty_bits) {</div><div><span class=3D"" style=3D"white-space:pre">			</sp=
an>mb-&gt;dirty_bits =3D 0;</div>
<div><span class=3D"" style=3D"white-space:pre">			</span>b =3D true;</div>=
<div><span class=3D"" style=3D"white-space:pre">		</span>}</div><div><span =
class=3D"" style=3D"white-space:pre">		</span>unlockseg(seg, flags);</div><=
div><br></div>
<div><span class=3D"" style=3D"white-space:pre">		</span>if (b)</div><div><=
span class=3D"" style=3D"white-space:pre">			</span>dec_nr_dirty_caches(mb-=
&gt;device_id);</div><div><span class=3D"" style=3D"white-space:pre">	</spa=
n>}</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>for =
(i =3D 1; i &lt; LC_NR_SLOTS; i++) {</div><div><span class=3D"" style=3D"wh=
ite-space:pre">		</span>bool b =3D *(cache-&gt;migrate_dests + i);</div><di=
v><span class=3D"" style=3D"white-space:pre">		</span>if (!b)</div>
<div><span class=3D"" style=3D"white-space:pre">			</span>continue;</div><d=
iv><br></div><div><span class=3D"" style=3D"white-space:pre">		</span>lc =
=3D lc_devices[i];</div><div><span class=3D"" style=3D"white-space:pre">		<=
/span>blkdev_issue_flush(lc-&gt;device-&gt;bdev, GFP_NOIO, NULL);</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>}</div><div><br></d=
iv><div><span class=3D"" style=3D"white-space:pre">	</span>/*</div><div><sp=
an class=3D"" style=3D"white-space:pre">	</span> * Discarding the migrated =
regions</div>
<div><span class=3D"" style=3D"white-space:pre">	</span> * can avoid unnece=
ssary wear amplifier in the future.</div><div><span class=3D"" style=3D"whi=
te-space:pre">	</span> * But note that we should not discard</div><div><spa=
n class=3D"" style=3D"white-space:pre">	</span> * the metablock region beca=
use</div>
<div><span class=3D"" style=3D"white-space:pre">	</span> * it varies across=
 flash devices whether to ensure</div><div><span class=3D"" style=3D"white-=
space:pre">	</span> * the discarded block returns certain value</div><div><=
span class=3D"" style=3D"white-space:pre">	</span> * and discarding the met=
ablock may lead to</div>
<div><span class=3D"" style=3D"white-space:pre">	</span> * integrity collap=
sion.</div><div><span class=3D"" style=3D"white-space:pre">	</span> */</div=
><div><span class=3D"" style=3D"white-space:pre">	</span>blkdev_issue_disca=
rd(</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>cache-&gt;device-&=
gt;bdev,</div><div><span class=3D"" style=3D"white-space:pre">		</span>seg-=
&gt;start_sector + (1 &lt;&lt; 3),</div><div><span class=3D"" style=3D"whit=
e-space:pre">		</span>seg-&gt;length &lt;&lt; 3,</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>GFP_NOIO, 0);</div=
><div>}</div><div><br></div><div>static void migrate_proc(struct work_struc=
t *work)</div><div>{</div><div><span class=3D"" style=3D"white-space:pre">	=
</span>struct lc_cache *cache =3D</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>container_of(work,=
 struct lc_cache, migrate_work);</div><div><br></div><div><span class=3D"" =
style=3D"white-space:pre">	</span>while (true) {</div><div><span class=3D""=
 style=3D"white-space:pre">		</span>if (cache-&gt;on_terminate)</div>
<div><span class=3D"" style=3D"white-space:pre">			</span>return;</div><div=
><br></div><div><span class=3D"" style=3D"white-space:pre">		</span>/*</div=
><div><span class=3D"" style=3D"white-space:pre">		</span> * reserving_id &=
gt; 0 means</div>
<div><span class=3D"" style=3D"white-space:pre">		</span> * that migration =
is immediate.</div><div><span class=3D"" style=3D"white-space:pre">		</span=
> */</div><div><span class=3D"" style=3D"white-space:pre">		</span>bool all=
ow_migrate =3D</div>
<div><span class=3D"" style=3D"white-space:pre">			</span>cache-&gt;reservi=
ng_segment_id || cache-&gt;allow_migrate;</div><div><br></div><div><span cl=
ass=3D"" style=3D"white-space:pre">		</span>if (!allow_migrate) {</div><div=
><span class=3D"" style=3D"white-space:pre">			</span>schedule_timeout_inte=
rruptible(msecs_to_jiffies(1000));</div>
<div><span class=3D"" style=3D"white-space:pre">			</span>continue;</div><d=
iv><span class=3D"" style=3D"white-space:pre">		</span>}</div><div><br></di=
v><div><span class=3D"" style=3D"white-space:pre">		</span>bool need_migrat=
e =3D</div>
<div><span class=3D"" style=3D"white-space:pre">			</span>(cache-&gt;last_m=
igrated_segment_id &lt;</div><div><span class=3D"" style=3D"white-space:pre=
">			</span> cache-&gt;last_flushed_segment_id);</div><div><br></div><div><=
span class=3D"" style=3D"white-space:pre">		</span>if (!need_migrate) {</di=
v>
<div><span class=3D"" style=3D"white-space:pre">			</span>schedule_timeout_=
interruptible(msecs_to_jiffies(1000));</div><div><span class=3D"" style=3D"=
white-space:pre">			</span>continue;</div><div><span class=3D"" style=3D"wh=
ite-space:pre">		</span>}</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">		</span>str=
uct segment_header *seg =3D</div><div><span class=3D"" style=3D"white-space=
:pre">			</span>get_segment_header_by_id(cache,</div><div><span class=3D"" =
style=3D"white-space:pre">				</span>cache-&gt;last_migrated_segment_id + 1=
);</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">		</span>mig=
rate_whole_segment(cache, seg);</div><div><br></div><div><span class=3D"" s=
tyle=3D"white-space:pre">		</span>/*</div><div><span class=3D"" style=3D"wh=
ite-space:pre">		</span> * (Locking)</div>
<div><span class=3D"" style=3D"white-space:pre">		</span> * Only this line =
alter last_migrate_segment_id in runtime.</div><div><span class=3D"" style=
=3D"white-space:pre">		</span> */</div><div><span class=3D"" style=3D"white=
-space:pre">		</span>cache-&gt;last_migrated_segment_id++;</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">		</span>com=
plete_all(&amp;seg-&gt;migrate_done);</div><div><span class=3D"" style=3D"w=
hite-space:pre">	</span>}</div><div>}</div><div><br></div><div>static void =
wait_for_migration(struct lc_cache *cache, size_t id)</div>
<div>{</div><div><span class=3D"" style=3D"white-space:pre">	</span>struct =
segment_header *seg =3D get_segment_header_by_id(cache, id);</div><div><br>=
</div><div><span class=3D"" style=3D"white-space:pre">	</span>cache-&gt;res=
erving_segment_id =3D id;</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>wait_for_completion=
(&amp;seg-&gt;migrate_done);</div><div><span class=3D"" style=3D"white-spac=
e:pre">	</span>cache-&gt;reserving_segment_id =3D 0;</div><div>}</div><div>=
<br></div>
<div>struct superblock_device {</div><div><span class=3D"" style=3D"white-s=
pace:pre">	</span>size_t last_migrated_segment_id;</div><div>} __packed;</d=
iv><div><br></div><div>static void commit_super_block(struct lc_cache *cach=
e)</div>
<div>{</div><div><span class=3D"" style=3D"white-space:pre">	</span>struct =
superblock_device o;</div><div><br></div><div><span class=3D"" style=3D"whi=
te-space:pre">	</span>o.last_migrated_segment_id =3D cache-&gt;last_migrate=
d_segment_id;</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>void=
 *buf =3D kmalloc_retry(1 &lt;&lt; SECTOR_SHIFT, GFP_NOIO);</div><div><span=
 class=3D"" style=3D"white-space:pre">	</span>memcpy(buf, &amp;o, sizeof(o)=
);</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>stru=
ct dm_io_request io_req =3D {</div><div><span class=3D"" style=3D"white-spa=
ce:pre">		</span>.client =3D lc_io_client,</div><div><span class=3D"" style=
=3D"white-space:pre">		</span>.bi_rw =3D WRITE_FUA,</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>.notify.fn =3D NUL=
L,</div><div><span class=3D"" style=3D"white-space:pre">		</span>.mem.type =
=3D DM_IO_KMEM,</div><div><span class=3D"" style=3D"white-space:pre">		</sp=
an>.mem.ptr.addr =3D buf,</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>};</div><div><span =
class=3D"" style=3D"white-space:pre">	</span>struct dm_io_region region =3D=
 {</div><div><span class=3D"" style=3D"white-space:pre">		</span>.bdev =3D =
cache-&gt;device-&gt;bdev,</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>.sector =3D 0,</di=
v><div><span class=3D"" style=3D"white-space:pre">		</span>.count =3D 1,</d=
iv><div><span class=3D"" style=3D"white-space:pre">	</span>};</div><div><sp=
an class=3D"" style=3D"white-space:pre">	</span>dm_safe_io_retry(&amp;io_re=
q, &amp;region, 1, true);</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>kfree(buf);</div><d=
iv>}</div><div><br></div><div>static void read_superblock_device(struct sup=
erblock_device *dest,</div><div><span class=3D"" style=3D"white-space:pre">=
				</span> =A0 struct lc_cache *cache)</div>
<div>{</div><div><span class=3D"" style=3D"white-space:pre">	</span>void *b=
uf =3D kmalloc(1 &lt;&lt; SECTOR_SHIFT, GFP_KERNEL);</div><div><span class=
=3D"" style=3D"white-space:pre">	</span>struct dm_io_request io_req =3D {</=
div><div>
<span class=3D"" style=3D"white-space:pre">		</span>.client =3D lc_io_clien=
t,</div><div><span class=3D"" style=3D"white-space:pre">		</span>.bi_rw =3D=
 READ,</div><div><span class=3D"" style=3D"white-space:pre">		</span>.notif=
y.fn =3D NULL,</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>.mem.type =3D DM_I=
O_KMEM,</div><div><span class=3D"" style=3D"white-space:pre">		</span>.mem.=
ptr.addr =3D buf,</div><div><span class=3D"" style=3D"white-space:pre">	</s=
pan>};</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>struct dm_io_region=
 region =3D {</div><div><span class=3D"" style=3D"white-space:pre">		</span=
>.bdev =3D cache-&gt;device-&gt;bdev,</div><div><span class=3D"" style=3D"w=
hite-space:pre">		</span>.sector =3D 0,</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>.count =3D 1,</div=
><div><span class=3D"" style=3D"white-space:pre">	</span>};</div><div><span=
 class=3D"" style=3D"white-space:pre">	</span>dm_safe_io_retry(&amp;io_req,=
 &amp;region, 1, true);</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>memcpy(dest, buf, s=
izeof(*dest));</div><div><span class=3D"" style=3D"white-space:pre">	</span=
>kfree(buf);</div><div>}</div><div><br></div><div>static sector_t calc_segm=
ent_header_start(size_t segment_idx)</div>
<div>{</div><div><span class=3D"" style=3D"white-space:pre">	</span>return =
(1 &lt;&lt; LC_SEGMENTSIZE_ORDER) * (segment_idx + 1);</div><div>}</div><di=
v><br></div><div>static void read_segment_header_device(</div><div><span cl=
ass=3D"" style=3D"white-space:pre">		</span>struct segment_header_device *d=
est,</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>struct lc_cache *c=
ache, size_t segment_idx)</div><div>{</div><div><span class=3D"" style=3D"w=
hite-space:pre">	</span>void *buf =3D kmalloc(1 &lt;&lt; 12, GFP_KERNEL);</=
div><div>
<span class=3D"" style=3D"white-space:pre">	</span>struct dm_io_request io_=
req =3D {</div><div><span class=3D"" style=3D"white-space:pre">		</span>.cl=
ient =3D lc_io_client,</div><div><span class=3D"" style=3D"white-space:pre"=
>		</span>.bi_rw =3D READ,</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>.notify.fn =3D NUL=
L,</div><div><span class=3D"" style=3D"white-space:pre">		</span>.mem.type =
=3D DM_IO_KMEM,</div><div><span class=3D"" style=3D"white-space:pre">		</sp=
an>.mem.ptr.addr =3D buf,</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>};</div><div><span =
class=3D"" style=3D"white-space:pre">	</span>struct dm_io_region region =3D=
 {</div><div><span class=3D"" style=3D"white-space:pre">		</span>.bdev =3D =
cache-&gt;device-&gt;bdev,</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>.sector =3D calc_s=
egment_header_start(segment_idx),</div><div><span class=3D"" style=3D"white=
-space:pre">		</span>.count =3D (1 &lt;&lt; 3),</div><div><span class=3D"" =
style=3D"white-space:pre">	</span>};</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>dm_safe_io_retry(&a=
mp;io_req, &amp;region, 1, true);</div><div><span class=3D"" style=3D"white=
-space:pre">	</span>memcpy(dest, buf, sizeof(*dest));</div><div><span class=
=3D"" style=3D"white-space:pre">	</span>kfree(buf);</div>
<div>}</div><div><br></div><div>static void update_by_segment_header_device=
(struct lc_cache *cache,</div><div><span class=3D"" style=3D"white-space:pr=
e">					</span> =A0 =A0struct segment_header_device *src)</div><div>{</div>=
<div>
<span class=3D"" style=3D"white-space:pre">	</span>struct segment_header *s=
eg =3D</div><div><span class=3D"" style=3D"white-space:pre">		</span>get_se=
gment_header_by_id(cache, src-&gt;global_id);</div><div><span class=3D"" st=
yle=3D"white-space:pre">	</span>seg-&gt;length =3D src-&gt;length;</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>INIT=
_COMPLETION(seg-&gt;migrate_done);</div><div><br></div><div><span class=3D"=
" style=3D"white-space:pre">	</span>cache_nr i;</div><div><span class=3D"" =
style=3D"white-space:pre">	</span>for (i =3D 0 ; i &lt; src-&gt;length; i++=
) {</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>struct metablock *=
mb =3D seg-&gt;mb_array + i;</div><div><br></div><div><span class=3D"" styl=
e=3D"white-space:pre">		</span>struct metablock_device *mbdev =3D &amp;src-=
&gt;mbarr[i];</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">		</span>if =
(!mbdev-&gt;dirty_bits)</div><div><span class=3D"" style=3D"white-space:pre=
">			</span>continue;</div><div><br></div><div><span class=3D"" style=3D"wh=
ite-space:pre">		</span>mb-&gt;sector =3D mbdev-&gt;sector;</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>mb-&gt;device_id =
=3D mbdev-&gt;device_id;</div><div><span class=3D"" style=3D"white-space:pr=
e">		</span>mb-&gt;dirty_bits =3D mbdev-&gt;dirty_bits;</div><div><br></div=
><div><span class=3D"" style=3D"white-space:pre">		</span>inc_nr_dirty_cach=
es(mb-&gt;device_id);</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">		</span>str=
uct lookup_key key =3D {</div><div><span class=3D"" style=3D"white-space:pr=
e">			</span>.device_id =3D mb-&gt;device_id,</div><div><span class=3D"" st=
yle=3D"white-space:pre">			</span>.sector =3D mb-&gt;sector,</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>};</div><div><br><=
/div><div><span class=3D"" style=3D"white-space:pre">		</span>cache_nr k =
=3D ht_hash(cache, &amp;key);</div><div><span class=3D"" style=3D"white-spa=
ce:pre">		</span>struct ht_head *head =3D arr_at(cache-&gt;htable, k);</div=
>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">		</span>str=
uct metablock *found =3D ht_lookup(cache, head, &amp;key);</div><div><span =
class=3D"" style=3D"white-space:pre">		</span>if (found)</div><div><span cl=
ass=3D"" style=3D"white-space:pre">			</span>ht_del(cache, found);</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>ht_register(cache,=
 head, &amp;key, mb);</div><div><span class=3D"" style=3D"white-space:pre">=
	</span>}</div><div>}</div><div><br></div><div>static bool checkup_atomicit=
y(struct segment_header_device *header)</div>
<div>{</div><div><span class=3D"" style=3D"white-space:pre">	</span>size_t =
i;</div><div><span class=3D"" style=3D"white-space:pre">	</span>struct meta=
block_device *o;</div><div><span class=3D"" style=3D"white-space:pre">	</sp=
an>for (i =3D 0; i &lt; header-&gt;length; i++) {</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>o =3D header-&gt;m=
barr + i;</div><div><span class=3D"" style=3D"white-space:pre">		</span>if =
(o-&gt;lap !=3D header-&gt;lap)</div><div><span class=3D"" style=3D"white-s=
pace:pre">			</span>return false;</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>}</div><div><span c=
lass=3D"" style=3D"white-space:pre">	</span>return true;</div><div>}</div><=
div><br></div><div><br></div><div>static void recover_cache(struct lc_cache=
 *cache)</div>
<div>{</div><div><span class=3D"" style=3D"white-space:pre">	</span>struct =
superblock_device sup;</div><div><span class=3D"" style=3D"white-space:pre"=
>	</span>read_superblock_device(&amp;sup, cache);</div><div><br></div><div>=
<span class=3D"" style=3D"white-space:pre">	</span>size_t i;</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>size_t nr_segments =
=3D cache-&gt;nr_segments;</div><div><br></div><div><span class=3D"" style=
=3D"white-space:pre">	</span>struct segment_header_device *header =3D</div>=
<div><span class=3D"" style=3D"white-space:pre">		</span>kmalloc(sizeof(*he=
ader), GFP_KERNEL);</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>/*</=
div><div><span class=3D"" style=3D"white-space:pre">	</span> * Finding the =
oldest, non-zero id and its index.</div><div><span class=3D"" style=3D"whit=
e-space:pre">	</span> */</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>size=
_t max_id =3D SZ_MAX; /* This global_id is forbidden. */</div><div><span cl=
ass=3D"" style=3D"white-space:pre">	</span>size_t oldest_id =3D max_id;</di=
v><div><span class=3D"" style=3D"white-space:pre">	</span>size_t oldest_idx=
 =3D 0;</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>for (i =3D 0; i &lt=
; nr_segments; i++) {</div><div><span class=3D"" style=3D"white-space:pre">=
		</span>read_segment_header_device(header, cache, i);</div><div><br></div>=
<div><span class=3D"" style=3D"white-space:pre">		</span>if (header-&gt;glo=
bal_id &lt; 1)</div>
<div><span class=3D"" style=3D"white-space:pre">			</span>continue;</div><d=
iv><br></div><div><span class=3D"" style=3D"white-space:pre">		</span>if (h=
eader-&gt;global_id &lt; oldest_id) {</div><div><span class=3D"" style=3D"w=
hite-space:pre">			</span>oldest_idx =3D i;</div>
<div><span class=3D"" style=3D"white-space:pre">			</span>oldest_id =3D hea=
der-&gt;global_id;</div><div><span class=3D"" style=3D"white-space:pre">		<=
/span>}</div><div><span class=3D"" style=3D"white-space:pre">	</span>}</div=
><div><br>
</div><div><span class=3D"" style=3D"white-space:pre">	</span>size_t last_f=
lushed_id =3D 0;</div><div><br></div><div><span class=3D"" style=3D"white-s=
pace:pre">	</span>/*</div><div><span class=3D"" style=3D"white-space:pre">	=
</span> * This is an invariant.</div>
<div><span class=3D"" style=3D"white-space:pre">	</span> * We always start =
from the segment</div><div><span class=3D"" style=3D"white-space:pre">	</sp=
an> * that is right after the last_flush_id.</div><div><span class=3D"" sty=
le=3D"white-space:pre">	</span> */</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>size_t init_segment=
_id =3D last_flushed_id + 1;</div><div><br></div><div><span class=3D"" styl=
e=3D"white-space:pre">	</span>/*</div><div><span class=3D"" style=3D"white-=
space:pre">	</span> * If no segment was flushed</div>
<div><span class=3D"" style=3D"white-space:pre">	</span> * then there is no=
thing to recover.</div><div><span class=3D"" style=3D"white-space:pre">	</s=
pan> */</div><div><span class=3D"" style=3D"white-space:pre">	</span>if (ol=
dest_id =3D=3D max_id)</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>goto setup_init_se=
gment;</div><div><br></div><div><span class=3D"" style=3D"white-space:pre">=
	</span>/*</div><div><span class=3D"" style=3D"white-space:pre">	</span> * =
What we have to do in the next loop is to</div>
<div><span class=3D"" style=3D"white-space:pre">	</span> * reincarnate the =
segments that are</div><div><span class=3D"" style=3D"white-space:pre">	</s=
pan> * flushed but yet not migrated.</div><div><span class=3D"" style=3D"wh=
ite-space:pre">	</span> */</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>/*</=
div><div><span class=3D"" style=3D"white-space:pre">	</span> * Example:</di=
v><div><span class=3D"" style=3D"white-space:pre">	</span> * There are only=
 5 segments.</div>
<div><span class=3D"" style=3D"white-space:pre">	</span> * The segments we =
will consider is of id k+2 and k+3.</div><div><span class=3D"" style=3D"whi=
te-space:pre">	</span> *</div><div><span class=3D"" style=3D"white-space:pr=
e">	</span> * id: [ =A0 k+3 =A0 ][ =A0 =A0k+4 =A0 ][ =A0 =A0 k =A0 =A0 ][ =
=A0 k+1 =A0 =A0][ =A0 K+2 =A0 ]</div>
<div><span class=3D"" style=3D"white-space:pre">	</span> * =A0 =A0 =A0 flus=
hed =A0 =A0init_seg =A0 =A0last =A0 =A0 =A0 =A0 migrated =A0 =A0flushed</di=
v><div><span class=3D"" style=3D"white-space:pre">	</span> * =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0_migrated</div>
<div><span class=3D"" style=3D"white-space:pre">	</span> */</div><div><span=
 class=3D"" style=3D"white-space:pre">	</span>size_t j;</div><div><span cla=
ss=3D"" style=3D"white-space:pre">	</span>for (i =3D oldest_idx; i &lt; (nr=
_segments + oldest_idx); i++) {</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>j =3D i % nr_segme=
nts;</div><div><span class=3D"" style=3D"white-space:pre">		</span>read_seg=
ment_header_device(header, cache, j);</div><div><br></div><div><span class=
=3D"" style=3D"white-space:pre">		</span>/*</div>
<div><span class=3D"" style=3D"white-space:pre">		</span> * global_id must =
uniformly increase from 1.</div><div><span class=3D"" style=3D"white-space:=
pre">		</span> * Since last_flush_id is 0 at first,</div><div><span class=
=3D"" style=3D"white-space:pre">		</span> * if global_id is 0,</div>
<div><span class=3D"" style=3D"white-space:pre">		</span> * we consider thi=
s and the subsequents</div><div><span class=3D"" style=3D"white-space:pre">=
		</span> * are all invalid.</div><div><span class=3D"" style=3D"white-spac=
e:pre">		</span> */</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>if (header-&gt;glo=
bal_id &lt;=3D last_flushed_id)</div><div><span class=3D"" style=3D"white-s=
pace:pre">			</span>break;</div><div><br></div><div><span class=3D"" style=
=3D"white-space:pre">		</span>if (!checkup_atomicity(header))</div>
<div><span class=3D"" style=3D"white-space:pre">			</span>break;</div><div>=
<br></div><div><span class=3D"" style=3D"white-space:pre">		</span>/*</div>=
<div><span class=3D"" style=3D"white-space:pre">		</span> * Now the header =
is proven valid.</div>
<div><span class=3D"" style=3D"white-space:pre">		</span> */</div><div><br>=
</div><div><span class=3D"" style=3D"white-space:pre">		</span>last_flushed=
_id =3D header-&gt;global_id;</div><div><span class=3D"" style=3D"white-spa=
ce:pre">		</span>init_segment_id =3D last_flushed_id + 1;</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">		</span>/*<=
/div><div><span class=3D"" style=3D"white-space:pre">		</span> * If the dat=
a is already on the backing store,</div><div><span class=3D"" style=3D"whit=
e-space:pre">		</span> * we ignore the segment.</div>
<div><span class=3D"" style=3D"white-space:pre">		</span> */</div><div><spa=
n class=3D"" style=3D"white-space:pre">		</span>if (header-&gt;global_id &l=
t;=3D sup.last_migrated_segment_id)</div><div><span class=3D"" style=3D"whi=
te-space:pre">			</span>continue;</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">		</span>/*<=
/div><div><span class=3D"" style=3D"white-space:pre">		</span> * Only those=
 to be migrated are counted in.</div><div><span class=3D"" style=3D"white-s=
pace:pre">		</span> * These segments will not be available until migrated.<=
/div>
<div><span class=3D"" style=3D"white-space:pre">		</span> */</div><div><spa=
n class=3D"" style=3D"white-space:pre">		</span>update_by_segment_header_de=
vice(cache, header);</div><div><span class=3D"" style=3D"white-space:pre">	=
</span>}</div>
<div><br></div><div>setup_init_segment:</div><div><span class=3D"" style=3D=
"white-space:pre">	</span>kfree(header);</div><div><br></div><div><span cla=
ss=3D"" style=3D"white-space:pre">	</span>struct segment_header *seg =3D</d=
iv><div>
<span class=3D"" style=3D"white-space:pre">		</span>get_segment_header_by_i=
d(cache, init_segment_id);</div><div><span class=3D"" style=3D"white-space:=
pre">	</span>seg-&gt;global_id =3D init_segment_id;</div><div><span class=
=3D"" style=3D"white-space:pre">	</span>atomic_set(&amp;seg-&gt;nr_inflight=
_ios, 0);</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>cach=
e-&gt;last_flushed_segment_id =3D seg-&gt;global_id - 1;</div><div><br></di=
v><div><span class=3D"" style=3D"white-space:pre">	</span>cache-&gt;last_mi=
grated_segment_id =3D</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>cache-&gt;last_flu=
shed_segment_id &gt; cache-&gt;nr_segments ?</div><div><span class=3D"" sty=
le=3D"white-space:pre">		</span>cache-&gt;last_flushed_segment_id - cache-&=
gt;nr_segments : 0;</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>if (=
sup.last_migrated_segment_id &gt; cache-&gt;last_migrated_segment_id)</div>=
<div><span class=3D"" style=3D"white-space:pre">		</span>cache-&gt;last_mig=
rated_segment_id =3D sup.last_migrated_segment_id;</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>wait=
_for_migration(cache, seg-&gt;global_id);</div><div><br></div><div><span cl=
ass=3D"" style=3D"white-space:pre">	</span>discard_caches_inseg(cache, seg)=
;</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>/*</=
div><div><span class=3D"" style=3D"white-space:pre">	</span> * cursor is se=
t to the first element of the segment.</div><div><span class=3D"" style=3D"=
white-space:pre">	</span> * This means that we will not use the element.</d=
iv>
<div><span class=3D"" style=3D"white-space:pre">	</span> * I believe this i=
s the simplest implementation.</div><div><span class=3D"" style=3D"white-sp=
ace:pre">	</span> */</div><div><span class=3D"" style=3D"white-space:pre">	=
</span>cache-&gt;cursor =3D seg-&gt;start_idx;</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>seg-&gt;length =3D =
1;</div><div><br></div><div><span class=3D"" style=3D"white-space:pre">	</s=
pan>cache-&gt;current_seg =3D seg;</div><div>}</div><div><br></div><div>sta=
tic sector_t dm_devsize(struct dm_dev *dev)</div>
<div>{</div><div><span class=3D"" style=3D"white-space:pre">	</span>return =
i_size_read(dev-&gt;bdev-&gt;bd_inode) &gt;&gt; SECTOR_SHIFT;</div><div>}</=
div><div><br></div><div>static size_t calc_nr_segments(struct dm_dev *dev)<=
/div>
<div>{</div><div><span class=3D"" style=3D"white-space:pre">	</span>sector_=
t devsize =3D dm_devsize(dev);</div><div><br></div><div><span class=3D"" st=
yle=3D"white-space:pre">	</span>/*</div><div><span class=3D"" style=3D"whit=
e-space:pre">	</span> * disk format:</div>
<div><span class=3D"" style=3D"white-space:pre">	</span> * superblock(512B/=
1024KB) [segment(1024KB)]+</div><div><span class=3D"" style=3D"white-space:=
pre">	</span> * We reserve the first segment (1MB) as the superblock.</div>=
<div>
<span class=3D"" style=3D"white-space:pre">	</span> *</div><div><span class=
=3D"" style=3D"white-space:pre">	</span> * segment:</div><div><span class=
=3D"" style=3D"white-space:pre">	</span> * segment_header(4KB) metablock(4K=
B)*NR_CACHES_INSEG</div>
<div><span class=3D"" style=3D"white-space:pre">	</span> */</div><div><span=
 class=3D"" style=3D"white-space:pre">	</span>return devsize / (1 &lt;&lt; =
LC_SEGMENTSIZE_ORDER) - 1;</div><div>}</div><div><br></div><div>struct form=
at_segmd_context {</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>atomic64_t count;</=
div><div>};</div><div><br></div><div>static void format_segmd_endio(unsigne=
d long error, void *__context)</div><div>{</div><div><span class=3D"" style=
=3D"white-space:pre">	</span>struct format_segmd_context *context =3D __con=
text;</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>atomic64_dec(&amp;c=
ontext-&gt;count);</div><div>}</div><div><br></div><div>static void format_=
cache_device(struct dm_dev *dev)</div><div>{</div><div><span class=3D"" sty=
le=3D"white-space:pre">	</span>size_t nr_segments =3D calc_nr_segments(dev)=
;</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>void *buf;</div><di=
v><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>buf =3D=
 kzalloc(1 &lt;&lt; SECTOR_SHIFT, GFP_KERNEL);</div><div><span class=3D"" s=
tyle=3D"white-space:pre">	</span>struct dm_io_request io_req_sup =3D {</div=
>
<div><span class=3D"" style=3D"white-space:pre">		</span>.client =3D lc_io_=
client,</div><div><span class=3D"" style=3D"white-space:pre">		</span>.bi_r=
w =3D WRITE_FUA,</div><div><span class=3D"" style=3D"white-space:pre">		</s=
pan>.notify.fn =3D NULL,</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>.mem.type =3D DM_I=
O_KMEM,</div><div><span class=3D"" style=3D"white-space:pre">		</span>.mem.=
ptr.addr =3D buf,</div><div><span class=3D"" style=3D"white-space:pre">	</s=
pan>};</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>struct dm_io_region=
 region_sup =3D {</div><div><span class=3D"" style=3D"white-space:pre">		</=
span>.bdev =3D dev-&gt;bdev,</div><div><span class=3D"" style=3D"white-spac=
e:pre">		</span>.sector =3D 0,</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>.count =3D 1,</div=
><div><span class=3D"" style=3D"white-space:pre">	</span>};</div><div><span=
 class=3D"" style=3D"white-space:pre">	</span>dm_safe_io_retry(&amp;io_req_=
sup, &amp;region_sup, 1, false);</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>kfree(buf);</div><d=
iv><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>struct=
 format_segmd_context context;</div><div><span class=3D"" style=3D"white-sp=
ace:pre">	</span>atomic64_set(&amp;context.count, nr_segments);</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>size=
_t i;</div><div><span class=3D"" style=3D"white-space:pre">	</span>buf =3D =
kzalloc(1 &lt;&lt; 12, GFP_KERNEL);</div><div><span class=3D"" style=3D"whi=
te-space:pre">	</span>for (i =3D 0; i &lt; nr_segments; i++) {</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>struct dm_io_reque=
st io_req_seg =3D {</div><div><span class=3D"" style=3D"white-space:pre">		=
	</span>.client =3D lc_io_client,</div><div><span class=3D"" style=3D"white=
-space:pre">			</span>.bi_rw =3D WRITE,</div>
<div><span class=3D"" style=3D"white-space:pre">			</span>.notify.fn =3D fo=
rmat_segmd_endio,</div><div><span class=3D"" style=3D"white-space:pre">			<=
/span>.notify.context =3D &amp;context,</div><div><span class=3D"" style=3D=
"white-space:pre">			</span>.mem.type =3D DM_IO_KMEM,</div>
<div><span class=3D"" style=3D"white-space:pre">			</span>.mem.ptr.addr =3D=
 buf,</div><div><span class=3D"" style=3D"white-space:pre">		</span>};</div=
><div><span class=3D"" style=3D"white-space:pre">		</span>struct dm_io_regi=
on region_seg =3D {</div>
<div><span class=3D"" style=3D"white-space:pre">			</span>.bdev =3D dev-&gt=
;bdev,</div><div><span class=3D"" style=3D"white-space:pre">			</span>.sect=
or =3D calc_segment_header_start(i),</div><div><span class=3D"" style=3D"wh=
ite-space:pre">			</span>.count =3D (1 &lt;&lt; 3),</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>};</div><div><span=
 class=3D"" style=3D"white-space:pre">		</span>dm_safe_io_retry(&amp;io_req=
_seg, &amp;region_seg, 1, false);</div><div><span class=3D"" style=3D"white=
-space:pre">	</span>}</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>kfree(buf);</div><d=
iv><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>while =
(atomic64_read(&amp;context.count))</div><div><span class=3D"" style=3D"whi=
te-space:pre">		</span>schedule_timeout_interruptible(msecs_to_jiffies(100)=
);</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>blkd=
ev_issue_flush(dev-&gt;bdev, GFP_KERNEL, NULL);</div><div>}</div><div><br><=
/div><div>static bool is_on_buffer(struct lc_cache *cache, cache_nr mb_idx)=
</div>
<div>{</div><div><span class=3D"" style=3D"white-space:pre">	</span>cache_n=
r start =3D cache-&gt;current_seg-&gt;start_idx;</div><div><span class=3D""=
 style=3D"white-space:pre">	</span>if (mb_idx &lt; start)</div><div><span c=
lass=3D"" style=3D"white-space:pre">		</span>return false;</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>if (=
mb_idx &gt;=3D (start + NR_CACHES_INSEG))</div><div><span class=3D"" style=
=3D"white-space:pre">		</span>return false;</div><div><br></div><div><span =
class=3D"" style=3D"white-space:pre">	</span>return true;</div>
<div>}</div><div><br></div><div>static void bio_remap(struct bio *bio, stru=
ct dm_dev *dev, sector_t sector)</div><div>{</div><div><span class=3D"" sty=
le=3D"white-space:pre">	</span>bio-&gt;bi_bdev =3D dev-&gt;bdev;</div><div>=
<span class=3D"" style=3D"white-space:pre">	</span>bio-&gt;bi_sector =3D se=
ctor;</div>
<div>}</div><div><br></div><div>static sector_t calc_cache_alignment(struct=
 lc_cache *cache,</div><div><span class=3D"" style=3D"white-space:pre">				=
</span> =A0 =A0 sector_t bio_sector)</div><div>{</div><div><span class=3D""=
 style=3D"white-space:pre">	</span>return (bio_sector / (1 &lt;&lt; 3)) * (=
1 &lt;&lt; 3);</div>
<div>}</div><div><br></div><div>static void migrate_buffered_mb(struct lc_c=
ache *cache,</div><div><span class=3D"" style=3D"white-space:pre">				</spa=
n>struct metablock *mb, u8 dirty_bits)</div><div>{</div><div><span class=3D=
"" style=3D"white-space:pre">	</span>u8 k =3D 1 + (mb-&gt;idx % NR_CACHES_I=
NSEG);</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>sector_t offset =3D=
 (k &lt;&lt; 3);</div><div><br></div><div><span class=3D"" style=3D"white-s=
pace:pre">	</span>u8 i;</div><div><span class=3D"" style=3D"white-space:pre=
">	</span>void *buf =3D kmalloc_retry(1 &lt;&lt; SECTOR_SHIFT, GFP_NOIO);</=
div>
<div><span class=3D"" style=3D"white-space:pre">	</span>for (i =3D 0; i &lt=
; 8; i++) {</div><div><span class=3D"" style=3D"white-space:pre">		</span>b=
ool bit_on =3D dirty_bits &amp; (1 &lt;&lt; i);</div><div><span class=3D"" =
style=3D"white-space:pre">		</span>if (!bit_on)</div>
<div><span class=3D"" style=3D"white-space:pre">			</span>continue;</div><d=
iv><br></div><div><span class=3D"" style=3D"white-space:pre">		</span>void =
*src =3D cache-&gt;current_wb-&gt;data +</div><div><span class=3D"" style=
=3D"white-space:pre">			</span>((offset + i) &lt;&lt; SECTOR_SHIFT);</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>memcpy(buf, src, 1=
 &lt;&lt; SECTOR_SHIFT);</div><div><br></div><div><span class=3D"" style=3D=
"white-space:pre">		</span>struct dm_io_request io_req =3D {</div><div><spa=
n class=3D"" style=3D"white-space:pre">			</span>.client =3D lc_io_client,<=
/div>
<div><span class=3D"" style=3D"white-space:pre">			</span>.bi_rw =3D WRITE_=
FUA,</div><div><span class=3D"" style=3D"white-space:pre">			</span>.notify=
.fn =3D NULL,</div><div><span class=3D"" style=3D"white-space:pre">			</spa=
n>.mem.type =3D DM_IO_KMEM,</div>
<div><span class=3D"" style=3D"white-space:pre">			</span>.mem.ptr.addr =3D=
 buf,</div><div><span class=3D"" style=3D"white-space:pre">		</span>};</div=
><div><br></div><div><span class=3D"" style=3D"white-space:pre">		</span>st=
ruct lc_device *lc =3D lc_devices[mb-&gt;device_id];</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>sector_t dest =3D =
mb-&gt;sector + 1 * i;</div><div><span class=3D"" style=3D"white-space:pre"=
>		</span>struct dm_io_region region =3D {</div><div><span class=3D"" style=
=3D"white-space:pre">			</span>.bdev =3D lc-&gt;device-&gt;bdev,</div>
<div><span class=3D"" style=3D"white-space:pre">			</span>.sector =3D dest,=
</div><div><span class=3D"" style=3D"white-space:pre">			</span>.count =3D =
1,</div><div><span class=3D"" style=3D"white-space:pre">		</span>};</div><d=
iv><br></div>
<div><span class=3D"" style=3D"white-space:pre">		</span>dm_safe_io_retry(&=
amp;io_req, &amp;region, 1, true);</div><div><span class=3D"" style=3D"whit=
e-space:pre">	</span>}</div><div><span class=3D"" style=3D"white-space:pre"=
>	</span>kfree(buf);</div>
<div>}</div><div><br></div><div>static void queue_current_buffer(struct lc_=
cache *cache)</div><div>{</div><div><span class=3D"" style=3D"white-space:p=
re">	</span>/*</div><div><span class=3D"" style=3D"white-space:pre">	</span=
> * Before we get the next segment</div>
<div><span class=3D"" style=3D"white-space:pre">	</span> * We must wait unt=
il the segment is all clean.</div><div><span class=3D"" style=3D"white-spac=
e:pre">	</span> * A clean segment desn&#39;t have</div><div><span class=3D"=
" style=3D"white-space:pre">	</span> * log to flush and dirties to migrate.=
</div>
<div><span class=3D"" style=3D"white-space:pre">	</span> */</div><div><span=
 class=3D"" style=3D"white-space:pre">	</span>size_t next_id =3D cache-&gt;=
current_seg-&gt;global_id + 1;</div><div><br></div><div><span class=3D"" st=
yle=3D"white-space:pre">	</span>struct segment_header *next_seg =3D</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>get_segment_header=
_by_id(cache, next_id);</div><div><br></div><div><span class=3D"" style=3D"=
white-space:pre">	</span>wait_for_completion(&amp;next_seg-&gt;flush_done);=
</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>wait=
_for_migration(cache, next_id);</div><div><br></div><div><span class=3D"" s=
tyle=3D"white-space:pre">	</span>queue_flushing(cache);</div><div>}</div><d=
iv><br>
</div><div>static void flush_current_buffer_sync(struct lc_cache *cache)</d=
iv><div>{</div><div><span class=3D"" style=3D"white-space:pre">	</span>mute=
x_lock(&amp;cache-&gt;io_lock);</div><div><span class=3D"" style=3D"white-s=
pace:pre">	</span>struct segment_header *old_seg =3D cache-&gt;current_seg;=
</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>queu=
e_current_buffer(cache);</div><div><span class=3D"" style=3D"white-space:pr=
e">	</span>cache-&gt;cursor =3D (cache-&gt;cursor + 1) % cache-&gt;nr_cache=
s;</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>cache-&gt;current_s=
eg-&gt;length =3D 1;</div><div><span class=3D"" style=3D"white-space:pre">	=
</span>mutex_unlock(&amp;cache-&gt;io_lock);</div><div><br></div><div><span=
 class=3D"" style=3D"white-space:pre">	</span>wait_for_completion(&amp;old_=
seg-&gt;flush_done);</div>
<div>}</div><div><br></div><div>static void flush_barrier_ios(struct work_s=
truct *work)</div><div>{</div><div><span class=3D"" style=3D"white-space:pr=
e">	</span>struct lc_cache *cache =3D</div><div><span class=3D"" style=3D"w=
hite-space:pre">		</span>container_of(work, struct lc_cache,</div>
<div><span class=3D"" style=3D"white-space:pre">			</span> =A0 =A0 barrier_=
deadline_work);</div><div><br></div><div><span class=3D"" style=3D"white-sp=
ace:pre">	</span>if (bio_list_empty(&amp;cache-&gt;barrier_ios))</div><div>=
<span class=3D"" style=3D"white-space:pre">		</span>return;</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>flus=
h_current_buffer_sync(cache);</div><div>}</div><div><br></div><div>static v=
oid barrier_deadline_proc(unsigned long data)</div><div>{</div><div><span c=
lass=3D"" style=3D"white-space:pre">	</span>struct lc_cache *cache =3D (str=
uct lc_cache *) data;</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>schedule_work(&amp;=
cache-&gt;barrier_deadline_work);</div><div>}</div><div><br></div><div>stat=
ic void queue_barrier_io(struct lc_cache *cache, struct bio *bio)</div><div=
>
{</div><div><span class=3D"" style=3D"white-space:pre">	</span>mutex_lock(&=
amp;cache-&gt;io_lock);</div><div><span class=3D"" style=3D"white-space:pre=
">	</span>bio_list_add(&amp;cache-&gt;barrier_ios, bio);</div><div><span cl=
ass=3D"" style=3D"white-space:pre">	</span>mutex_unlock(&amp;cache-&gt;io_l=
ock);</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>if (=
!timer_pending(&amp;cache-&gt;barrier_deadline_timer))</div><div><span clas=
s=3D"" style=3D"white-space:pre">		</span>mod_timer(&amp;cache-&gt;barrier_=
deadline_timer,</div>
<div><span class=3D"" style=3D"white-space:pre">			</span> =A0msecs_to_jiff=
ies(cache-&gt;barrier_deadline_ms));</div><div>}</div><div><br></div><div>#=
define PER_BIO_VERSION KERNEL_VERSION(3, 8, 0)</div><div>#if LINUX_VERSION_=
CODE &gt;=3D PER_BIO_VERSION</div>
<div>struct per_bio_data {</div><div><span class=3D"" style=3D"white-space:=
pre">	</span>void *ptr;</div><div>};</div><div>#endif</div><div><br></div><=
div>static int lc_map(struct dm_target *ti, struct bio *bio</div><div>#if L=
INUX_VERSION_CODE &lt; PER_BIO_VERSION</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>, union map_info *=
map_context</div><div>#endif</div><div><span class=3D"" style=3D"white-spac=
e:pre">		</span>)</div><div>{</div><div><span class=3D"" style=3D"white-spa=
ce:pre">	</span>struct lc_device *lc =3D ti-&gt;private;</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>struct dm_dev *orig=
 =3D lc-&gt;device;</div><div><br></div><div><span class=3D"" style=3D"whit=
e-space:pre">	</span>if (!lc-&gt;cache) {</div><div><span class=3D"" style=
=3D"white-space:pre">		</span>bio_remap(bio, orig, bio-&gt;bi_sector);</div=
>
<div><span class=3D"" style=3D"white-space:pre">		</span>return DM_MAPIO_RE=
MAPPED;</div><div><span class=3D"" style=3D"white-space:pre">	</span>}</div=
><div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>/*<=
/div><div>
<span class=3D"" style=3D"white-space:pre">	</span> * We only discard the b=
acking store.</div><div><span class=3D"" style=3D"white-space:pre">	</span>=
 * 1. 3.4 kernel doesn&#39;t support split_discard_requests.</div><div><spa=
n class=3D"" style=3D"white-space:pre">	</span> * =A0 =A0Hence, it is close=
 to impossible to discard blocks on cache.</div>
<div><span class=3D"" style=3D"white-space:pre">	</span> * 2. Discarding th=
e blocks on cache is meaningless.</div><div><span class=3D"" style=3D"white=
-space:pre">	</span> * =A0 =A0Because they will be overwritten eventually.<=
/div><div>
<span class=3D"" style=3D"white-space:pre">	</span> */</div><div><span clas=
s=3D"" style=3D"white-space:pre">	</span>if (bio-&gt;bi_rw &amp; REQ_DISCAR=
D) {</div><div><span class=3D"" style=3D"white-space:pre">		</span>bio_rema=
p(bio, orig, bio-&gt;bi_sector);</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>return DM_MAPIO_RE=
MAPPED;</div><div><span class=3D"" style=3D"white-space:pre">	</span>}</div=
><div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>str=
uct lc_cache *cache =3D lc-&gt;cache;</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>if (=
bio-&gt;bi_rw &amp; REQ_FLUSH) {</div><div><span class=3D"" style=3D"white-=
space:pre">		</span>BUG_ON(bio-&gt;bi_size);</div><div><span class=3D"" sty=
le=3D"white-space:pre">		</span>queue_barrier_io(cache, bio);</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>return DM_MAPIO_SU=
BMITTED;</div><div><span class=3D"" style=3D"white-space:pre">	</span>}</di=
v><div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>un=
signed long flags;</div>
<div><br></div><div>#if LINUX_VERSION_CODE &gt;=3D PER_BIO_VERSION</div><di=
v><span class=3D"" style=3D"white-space:pre">	</span>struct per_bio_data *m=
ap_context =3D</div><div><span class=3D"" style=3D"white-space:pre">		</spa=
n>dm_per_bio_data(bio, ti-&gt;per_bio_data_size);</div>
<div>#endif</div><div><span class=3D"" style=3D"white-space:pre">	</span>ma=
p_context-&gt;ptr =3D NULL;</div><div><br></div><div><span class=3D"" style=
=3D"white-space:pre">	</span>sector_t bio_count =3D bio-&gt;bi_size &gt;&gt=
; SECTOR_SHIFT;</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>bool bio_fullsize =
=3D (bio_count =3D=3D (1 &lt;&lt; 3));</div><div><span class=3D"" style=3D"=
white-space:pre">	</span>sector_t bio_offset =3D bio-&gt;bi_sector % (1 &lt=
;&lt; 3);</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>int =
rw =3D bio_data_dir(bio);</div><div><br></div><div><span class=3D"" style=
=3D"white-space:pre">	</span>struct lookup_key key =3D {</div><div><span cl=
ass=3D"" style=3D"white-space:pre">		</span>.sector =3D calc_cache_alignmen=
t(cache, bio-&gt;bi_sector),</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>.device_id =3D lc-=
&gt;id,</div><div><span class=3D"" style=3D"white-space:pre">	</span>};</di=
v><div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>ca=
che_nr k =3D ht_hash(cache, &amp;key);</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>struct ht_head *hea=
d =3D arr_at(cache-&gt;htable, k);</div><div><br></div><div><span class=3D"=
" style=3D"white-space:pre">	</span>struct segment_header *seg;</div><div><=
span class=3D"" style=3D"white-space:pre">	</span>struct metablock *mb;</di=
v>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>mute=
x_lock(&amp;cache-&gt;io_lock);</div><div><span class=3D"" style=3D"white-s=
pace:pre">	</span>mb =3D ht_lookup(cache, head, &amp;key);</div><div><span =
class=3D"" style=3D"white-space:pre">	</span>if (mb) {</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>seg =3D ((void *) =
mb) - ((mb-&gt;idx % NR_CACHES_INSEG) *</div><div><span class=3D"" style=3D=
"white-space:pre">				</span> =A0 =A0 =A0 sizeof(struct metablock));</div><=
div><span class=3D"" style=3D"white-space:pre">		</span>atomic_inc(&amp;seg=
-&gt;nr_inflight_ios);</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>}</div><div><br></d=
iv><div><span class=3D"" style=3D"white-space:pre">	</span>bool found =3D (=
mb !=3D NULL);</div><div><span class=3D"" style=3D"white-space:pre">	</span=
>bool on_buffer =3D false;</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>if (found)</div><di=
v><span class=3D"" style=3D"white-space:pre">		</span>on_buffer =3D is_on_b=
uffer(cache, mb-&gt;idx);</div><div><br></div><div><span class=3D"" style=
=3D"white-space:pre">	</span>inc_stat(cache, rw, found, on_buffer, bio_full=
size);</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>if (=
!rw) {</div><div><span class=3D"" style=3D"white-space:pre">		</span>mutex_=
unlock(&amp;cache-&gt;io_lock);</div><div><br></div><div><span class=3D"" s=
tyle=3D"white-space:pre">		</span>if (!found) {</div>
<div><span class=3D"" style=3D"white-space:pre">			</span>bio_remap(bio, or=
ig, bio-&gt;bi_sector);</div><div><span class=3D"" style=3D"white-space:pre=
">			</span>return DM_MAPIO_REMAPPED;</div><div><span class=3D"" style=3D"w=
hite-space:pre">		</span>}</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">		</span>u8 =
dirty_bits =3D atomic_read_mb_dirtiness(seg, mb);</div><div><br></div><div>=
<span class=3D"" style=3D"white-space:pre">		</span>if (unlikely(on_buffer)=
) {</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">			</span>if=
 (dirty_bits)</div><div><span class=3D"" style=3D"white-space:pre">				</sp=
an>migrate_buffered_mb(cache, mb, dirty_bits);</div><div><br></div><div><sp=
an class=3D"" style=3D"white-space:pre">			</span>/*</div>
<div><span class=3D"" style=3D"white-space:pre">			</span> * Dirtiness of a=
 live cache</div><div><span class=3D"" style=3D"white-space:pre">			</span>=
 *</div><div><span class=3D"" style=3D"white-space:pre">			</span> * We can=
 assume dirtiness of a cache only increase</div>
<div><span class=3D"" style=3D"white-space:pre">			</span> * when it is on =
the buffer, we call this cache is live.</div><div><span class=3D"" style=3D=
"white-space:pre">			</span> * This eases the locking because</div><div><sp=
an class=3D"" style=3D"white-space:pre">			</span> * we don&#39;t worry the=
 dirtiness of</div>
<div><span class=3D"" style=3D"white-space:pre">			</span> * a live cache f=
luctuates.</div><div><span class=3D"" style=3D"white-space:pre">			</span> =
*/</div><div><br></div><div><span class=3D"" style=3D"white-space:pre">			<=
/span>atomic_dec(&amp;seg-&gt;nr_inflight_ios);</div>
<div><span class=3D"" style=3D"white-space:pre">			</span>bio_remap(bio, or=
ig, bio-&gt;bi_sector);</div><div><span class=3D"" style=3D"white-space:pre=
">			</span>return DM_MAPIO_REMAPPED;</div><div><span class=3D"" style=3D"w=
hite-space:pre">		</span>}</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">		</span>wai=
t_for_completion(&amp;seg-&gt;flush_done);</div><div><span class=3D"" style=
=3D"white-space:pre">		</span>if (likely(dirty_bits =3D=3D 255)) {</div><di=
v><span class=3D"" style=3D"white-space:pre">			</span>bio_remap(</div>
<div><span class=3D"" style=3D"white-space:pre">				</span>bio, cache-&gt;d=
evice,</div><div><span class=3D"" style=3D"white-space:pre">				</span>calc=
_mb_start_sector(seg, mb-&gt;idx)</div><div><span class=3D"" style=3D"white=
-space:pre">				</span>+ bio_offset);</div>
<div><span class=3D"" style=3D"white-space:pre">			</span>map_context-&gt;p=
tr =3D seg;</div><div><span class=3D"" style=3D"white-space:pre">		</span>}=
 else {</div><div><br></div><div><span class=3D"" style=3D"white-space:pre"=
>			</span>/*</div>
<div><span class=3D"" style=3D"white-space:pre">			</span> * Dirtiness of a=
 stable cache</div><div><span class=3D"" style=3D"white-space:pre">			</spa=
n> *</div><div><span class=3D"" style=3D"white-space:pre">			</span> * Unli=
ke the live caches doesn&#39;t</div>
<div><span class=3D"" style=3D"white-space:pre">			</span> * fluctuate the =
dirtiness,</div><div><span class=3D"" style=3D"white-space:pre">			</span> =
* stable caches which is not on the buffer</div><div><span class=3D"" style=
=3D"white-space:pre">			</span> * but on the cache device</div>
<div><span class=3D"" style=3D"white-space:pre">			</span> * may decrease t=
he dirtiness by other processes</div><div><span class=3D"" style=3D"white-s=
pace:pre">			</span> * other than the migrate daemon.</div><div><span class=
=3D"" style=3D"white-space:pre">			</span> * This works fine</div>
<div><span class=3D"" style=3D"white-space:pre">			</span> * because migrat=
ing the same cache twice</div><div><span class=3D"" style=3D"white-space:pr=
e">			</span> * doesn&#39;t destroy the cache concistency.</div><div><span =
class=3D"" style=3D"white-space:pre">			</span> */</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">			</span>mi=
grate_mb(cache, seg, mb, dirty_bits, true);</div><div><br></div><div><span =
class=3D"" style=3D"white-space:pre">			</span>bool b =3D false;</div><div>=
<span class=3D"" style=3D"white-space:pre">			</span>lockseg(seg, flags);</=
div>
<div><span class=3D"" style=3D"white-space:pre">			</span>if (mb-&gt;dirty_=
bits) {</div><div><span class=3D"" style=3D"white-space:pre">				</span>mb-=
&gt;dirty_bits =3D 0;</div><div><span class=3D"" style=3D"white-space:pre">=
				</span>b =3D true;</div>
<div><span class=3D"" style=3D"white-space:pre">			</span>}</div><div><span=
 class=3D"" style=3D"white-space:pre">			</span>unlockseg(seg, flags);</div=
><div><br></div><div><span class=3D"" style=3D"white-space:pre">			</span>i=
f (b)</div>
<div><span class=3D"" style=3D"white-space:pre">				</span>dec_nr_dirty_cac=
hes(mb-&gt;device_id);</div><div><br></div><div><span class=3D"" style=3D"w=
hite-space:pre">			</span>atomic_dec(&amp;seg-&gt;nr_inflight_ios);</div><d=
iv><span class=3D"" style=3D"white-space:pre">			</span>bio_remap(bio, orig=
, bio-&gt;bi_sector);</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>}</div><div><span =
class=3D"" style=3D"white-space:pre">		</span>return DM_MAPIO_REMAPPED;</di=
v><div><span class=3D"" style=3D"white-space:pre">	</span>}</div><div><br><=
/div><div>
<span class=3D"" style=3D"white-space:pre">	</span>cache_nr update_mb_idx;<=
/div><div><span class=3D"" style=3D"white-space:pre">	</span>if (found) {</=
div><div><br></div><div><span class=3D"" style=3D"white-space:pre">		</span=
>if (unlikely(on_buffer)) {</div>
<div><span class=3D"" style=3D"white-space:pre">			</span>mutex_unlock(&amp=
;cache-&gt;io_lock);</div><div><br></div><div><span class=3D"" style=3D"whi=
te-space:pre">			</span>update_mb_idx =3D mb-&gt;idx;</div><div><span class=
=3D"" style=3D"white-space:pre">			</span>goto write_on_buffer;</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>} else {</div><div=
><br></div><div><span class=3D"" style=3D"white-space:pre">			</span>u8 dir=
ty_bits =3D atomic_read_mb_dirtiness(seg, mb);</div><div><br></div><div><sp=
an class=3D"" style=3D"white-space:pre">			</span>/*</div>
<div><span class=3D"" style=3D"white-space:pre">			</span> * First clean up=
 the previous cache</div><div><span class=3D"" style=3D"white-space:pre">		=
	</span> * and migrate the cache if needed.</div><div><span class=3D"" styl=
e=3D"white-space:pre">			</span> */</div>
<div><span class=3D"" style=3D"white-space:pre">			</span>bool needs_cleanu=
p_prev_cache =3D</div><div><span class=3D"" style=3D"white-space:pre">				<=
/span>!bio_fullsize || !(dirty_bits =3D=3D 255);</div><div><br></div><div><=
span class=3D"" style=3D"white-space:pre">			</span>if (unlikely(needs_clea=
nup_prev_cache)) {</div>
<div><span class=3D"" style=3D"white-space:pre">				</span>wait_for_complet=
ion(&amp;seg-&gt;flush_done);</div><div><span class=3D"" style=3D"white-spa=
ce:pre">				</span>migrate_mb(cache, seg, mb, dirty_bits, true);</div><div>=
<span class=3D"" style=3D"white-space:pre">			</span>}</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">			</span>/*=
</div><div><span class=3D"" style=3D"white-space:pre">			</span> * Fullsize=
 dirty cache</div><div><span class=3D"" style=3D"white-space:pre">			</span=
> * can be discarded without migration.</div>
<div><span class=3D"" style=3D"white-space:pre">			</span> */</div><div><sp=
an class=3D"" style=3D"white-space:pre">			</span>bool b =3D false;</div><d=
iv><span class=3D"" style=3D"white-space:pre">			</span>lockseg(seg, flags)=
;</div><div>
<span class=3D"" style=3D"white-space:pre">			</span>if (mb-&gt;dirty_bits)=
 {</div><div><span class=3D"" style=3D"white-space:pre">				</span>mb-&gt;d=
irty_bits =3D 0;</div><div><span class=3D"" style=3D"white-space:pre">				<=
/span>b =3D true;</div>
<div><span class=3D"" style=3D"white-space:pre">			</span>}</div><div><span=
 class=3D"" style=3D"white-space:pre">			</span>unlockseg(seg, flags);</div=
><div><br></div><div><span class=3D"" style=3D"white-space:pre">			</span>i=
f (b)</div>
<div><span class=3D"" style=3D"white-space:pre">				</span>dec_nr_dirty_cac=
hes(mb-&gt;device_id);</div><div><br></div><div><span class=3D"" style=3D"w=
hite-space:pre">			</span>ht_del(cache, mb);</div><div><br></div><div><span=
 class=3D"" style=3D"white-space:pre">			</span>atomic_dec(&amp;seg-&gt;nr_=
inflight_ios);</div>
<div><span class=3D"" style=3D"white-space:pre">			</span>goto write_not_fo=
und;</div><div><span class=3D"" style=3D"white-space:pre">		</span>}</div><=
div><span class=3D"" style=3D"white-space:pre">	</span>}</div><div><br></di=
v><div>write_not_found:</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>;</div><div><br></d=
iv><div><span class=3D"" style=3D"white-space:pre">	</span>/*</div><div><sp=
an class=3D"" style=3D"white-space:pre">	</span> * If cache-&gt;cursor is 2=
54, 509, ...</div>
<div><span class=3D"" style=3D"white-space:pre">	</span> * that is the last=
 cache line in the segment.</div><div><span class=3D"" style=3D"white-space=
:pre">	</span> * We must flush the current segment and</div><div><span clas=
s=3D"" style=3D"white-space:pre">	</span> * get the new one.</div>
<div><span class=3D"" style=3D"white-space:pre">	</span> */</div><div><span=
 class=3D"" style=3D"white-space:pre">	</span>bool refresh_segment =3D !((c=
ache-&gt;cursor + 1) % NR_CACHES_INSEG);</div><div><br></div><div><span cla=
ss=3D"" style=3D"white-space:pre">	</span>if (refresh_segment)</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>queue_current_buff=
er(cache);</div><div><br></div><div><span class=3D"" style=3D"white-space:p=
re">	</span>cache-&gt;cursor =3D (cache-&gt;cursor + 1) % cache-&gt;nr_cach=
es;</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>/*</=
div><div><span class=3D"" style=3D"white-space:pre">	</span> * update_mb_id=
x is the cache line index to update.</div><div><span class=3D"" style=3D"wh=
ite-space:pre">	</span> */</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>update_mb_idx =3D c=
ache-&gt;cursor;</div><div><br></div><div><span class=3D"" style=3D"white-s=
pace:pre">	</span>seg =3D cache-&gt;current_seg;</div><div><span class=3D""=
 style=3D"white-space:pre">	</span>atomic_inc(&amp;seg-&gt;nr_inflight_ios)=
;</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>stru=
ct metablock *new_mb =3D</div><div><span class=3D"" style=3D"white-space:pr=
e">		</span>seg-&gt;mb_array + (update_mb_idx % NR_CACHES_INSEG);</div><div=
><span class=3D"" style=3D"white-space:pre">	</span>new_mb-&gt;dirty_bits =
=3D 0;</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>ht_register(cache, =
head, &amp;key, new_mb);</div><div><span class=3D"" style=3D"white-space:pr=
e">	</span>mutex_unlock(&amp;cache-&gt;io_lock);</div><div><br></div><div><=
span class=3D"" style=3D"white-space:pre">	</span>mb =3D new_mb;</div>
<div><br></div><div>write_on_buffer:</div><div><span class=3D"" style=3D"wh=
ite-space:pre">	</span>;</div><div><span class=3D"" style=3D"white-space:pr=
e">	</span>cache_nr idx_inseg =3D update_mb_idx % NR_CACHES_INSEG;</div><di=
v><span class=3D"" style=3D"white-space:pre">	</span>sector_t s =3D (idx_in=
seg + 1) &lt;&lt; 3;</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>bool=
 b =3D false;</div><div><span class=3D"" style=3D"white-space:pre">	</span>=
lockseg(seg, flags);</div><div><span class=3D"" style=3D"white-space:pre">	=
</span>if (!mb-&gt;dirty_bits) {</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>seg-&gt;length++;<=
/div><div><span class=3D"" style=3D"white-space:pre">		</span>BUG_ON(seg-&g=
t;length &gt; =A0NR_CACHES_INSEG);</div><div><span class=3D"" style=3D"whit=
e-space:pre">		</span>b =3D true;</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>}</div><div><br></d=
iv><div><span class=3D"" style=3D"white-space:pre">	</span>if (likely(bio_f=
ullsize)) {</div><div><span class=3D"" style=3D"white-space:pre">		</span>m=
b-&gt;dirty_bits =3D 255;</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>} else {</div><div>=
<span class=3D"" style=3D"white-space:pre">		</span>s +=3D bio_offset;</div=
><div><span class=3D"" style=3D"white-space:pre">		</span>u8 i;</div><div><=
span class=3D"" style=3D"white-space:pre">		</span>u8 acc_bits =3D 0;</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>for (i =3D bio_off=
set; i &lt; (bio_offset+bio_count); i++)</div><div><span class=3D"" style=
=3D"white-space:pre">			</span>acc_bits +=3D (1 &lt;&lt; i);</div><div><br>=
</div><div>
<span class=3D"" style=3D"white-space:pre">		</span>mb-&gt;dirty_bits |=3D =
acc_bits;</div><div><span class=3D"" style=3D"white-space:pre">	</span>}</d=
iv><div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>B=
UG_ON(!mb-&gt;dirty_bits);</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>unlo=
ckseg(seg, flags);</div><div><br></div><div><span class=3D"" style=3D"white=
-space:pre">	</span>if (b)</div><div><span class=3D"" style=3D"white-space:=
pre">		</span>inc_nr_dirty_caches(mb-&gt;device_id);</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>size=
_t start =3D s &lt;&lt; SECTOR_SHIFT;</div><div><span class=3D"" style=3D"w=
hite-space:pre">	</span>void *data =3D bio_data(bio);</div><div><br></div><=
div><span class=3D"" style=3D"white-space:pre">	</span>memcpy(cache-&gt;cur=
rent_wb-&gt;data + start, data, bio-&gt;bi_size);</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>atomic_dec(&amp;seg=
-&gt;nr_inflight_ios);</div><div><br></div><div><span class=3D"" style=3D"w=
hite-space:pre">	</span>if (bio-&gt;bi_rw &amp; REQ_FUA) {</div><div><span =
class=3D"" style=3D"white-space:pre">		</span>queue_barrier_io(cache, bio);=
</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>return DM_MAPIO_SU=
BMITTED;</div><div><span class=3D"" style=3D"white-space:pre">	</span>}</di=
v><div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>bi=
o_endio(bio, 0);</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>return DM_MAPIO_SUB=
MITTED;</div><div>}</div><div><br></div><div>static int lc_end_io(struct dm=
_target *ti, struct bio *bio, int error</div><div>#if LINUX_VERSION_CODE &l=
t; PER_BIO_VERSION</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>, union map_info *=
map_context</div><div>#endif</div><div><span class=3D"" style=3D"white-spac=
e:pre">		</span>)</div><div>{</div><div>#if LINUX_VERSION_CODE &gt;=3D PER_=
BIO_VERSION</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>struct per_bio_data=
 *map_context =3D</div><div><span class=3D"" style=3D"white-space:pre">		</=
span>dm_per_bio_data(bio, ti-&gt;per_bio_data_size);</div><div>#endif</div>=
<div><span class=3D"" style=3D"white-space:pre">	</span>if (!map_context-&g=
t;ptr)</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>return 0;</div><di=
v><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>struct =
segment_header *seg =3D map_context-&gt;ptr;</div><div><span class=3D"" sty=
le=3D"white-space:pre">	</span>atomic_dec(&amp;seg-&gt;nr_inflight_ios);</d=
iv>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>retu=
rn 0;</div><div>}</div><div><br></div><div><br></div><div>static ssize_t va=
r_show(unsigned long var, char *page)</div><div>{</div><div><span class=3D"=
" style=3D"white-space:pre">	</span>return sprintf(page, &quot;%lu\n&quot;,=
 var);</div>
<div>}</div><div><br></div><div>static ssize_t var_store(unsigned long *var=
, const char *page, size_t len)</div><div>{</div><div><span class=3D"" styl=
e=3D"white-space:pre">	</span>char *p =3D (char *) page;</div><div><span cl=
ass=3D"" style=3D"white-space:pre">	</span>int r =3D kstrtoul(p, 10, var);<=
/div>
<div><span class=3D"" style=3D"white-space:pre">	</span>if (r)</div><div><s=
pan class=3D"" style=3D"white-space:pre">		</span>return r;</div><div><span=
 class=3D"" style=3D"white-space:pre">	</span>return len;</div><div>}</div>=
<div><br>
</div><div>static struct kobject *devices_kobj;</div><div><br></div><div>st=
ruct device_sysfs_entry {</div><div><span class=3D"" style=3D"white-space:p=
re">	</span>struct attribute attr;</div><div><span class=3D"" style=3D"whit=
e-space:pre">	</span>ssize_t (*show)(struct lc_device *, char *);</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>ssize_t (*store)(st=
ruct lc_device *, const char *, size_t);</div><div>};</div><div><br></div><=
div>#define to_device(attr) container_of((attr), struct device_sysfs_entry,=
 attr)</div>
<div>static ssize_t device_attr_show(struct kobject *kobj, struct attribute=
 *attr,</div><div><span class=3D"" style=3D"white-space:pre">				</span>cha=
r *page)</div><div>{</div><div><span class=3D"" style=3D"white-space:pre">	=
</span>struct device_sysfs_entry *entry =3D to_device(attr);</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>struct lc_device *d=
evice =3D</div><div><span class=3D"" style=3D"white-space:pre">		</span>con=
tainer_of(kobj, struct lc_device, kobj);</div><div><br></div><div><span cla=
ss=3D"" style=3D"white-space:pre">	</span>return entry-&gt;show(device, pag=
e);</div>
<div>}</div><div><br></div><div>static ssize_t device_attr_store(struct kob=
ject *kobj, struct attribute *attr,</div><div><span class=3D"" style=3D"whi=
te-space:pre">				</span> const char *page, size_t len)</div><div>{</div><d=
iv>
<span class=3D"" style=3D"white-space:pre">	</span>struct device_sysfs_entr=
y *entry =3D to_device(attr);</div><div><span class=3D"" style=3D"white-spa=
ce:pre">	</span>if (!entry-&gt;store)</div><div><span class=3D"" style=3D"w=
hite-space:pre">		</span>return -EIO;</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>stru=
ct lc_device *device =3D container_of(kobj, struct lc_device, kobj);</div><=
div><span class=3D"" style=3D"white-space:pre">	</span>return entry-&gt;sto=
re(device, page, len);</div>
<div>}</div><div><br></div><div>static cache_id cache_id_of(struct lc_devic=
e *device)</div><div>{</div><div><span class=3D"" style=3D"white-space:pre"=
>	</span>cache_id id;</div><div><span class=3D"" style=3D"white-space:pre">=
	</span>if (!device-&gt;cache)</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>id =3D 0;</div><di=
v><span class=3D"" style=3D"white-space:pre">	</span>else</div><div><span c=
lass=3D"" style=3D"white-space:pre">		</span>id =3D device-&gt;cache-&gt;id=
;</div><div>
<span class=3D"" style=3D"white-space:pre">	</span>return id;</div><div>}</=
div><div><br></div><div>static ssize_t cache_id_show(struct lc_device *devi=
ce, char *page)</div><div>{</div><div><span class=3D"" style=3D"white-space=
:pre">	</span>return var_show(cache_id_of(device), (page));</div>
<div>}</div><div><br></div><div>static struct device_sysfs_entry cache_id_e=
ntry =3D {</div><div><span class=3D"" style=3D"white-space:pre">	</span>.at=
tr =3D { .name =3D &quot;cache_id&quot;, .mode =3D S_IRUGO },</div><div><sp=
an class=3D"" style=3D"white-space:pre">	</span>.show =3D cache_id_show,</d=
iv>
<div>};</div><div><br></div><div>static ssize_t dev_show(struct lc_device *=
device, char *page)</div><div>{</div><div><span class=3D"" style=3D"white-s=
pace:pre">	</span>return sprintf(page, &quot;%s\n&quot;, dm_device_name(dev=
ice-&gt;md));</div>
<div>}</div><div><br></div><div>static struct device_sysfs_entry dev_entry =
=3D {</div><div><span class=3D"" style=3D"white-space:pre">	</span>.attr =
=3D { .name =3D &quot;dev&quot;, .mode =3D S_IRUGO },</div><div><span class=
=3D"" style=3D"white-space:pre">	</span>.show =3D dev_show,</div>
<div>};</div><div><br></div><div>static ssize_t migrate_threshold_show(stru=
ct lc_device *device, char *page)</div><div>{</div><div><span class=3D"" st=
yle=3D"white-space:pre">	</span>return var_show(device-&gt;migrate_threshol=
d, (page));</div>
<div>}</div><div><br></div><div>static ssize_t migrate_threshold_store(stru=
ct lc_device *device,</div><div><span class=3D"" style=3D"white-space:pre">=
				</span> =A0 =A0 =A0 const char *page, size_t count)</div><div>{</div><d=
iv><span class=3D"" style=3D"white-space:pre">	</span>unsigned long x;</div=
>
<div><span class=3D"" style=3D"white-space:pre">	</span>ssize_t r =3D var_s=
tore(&amp;x, page, count);</div><div><span class=3D"" style=3D"white-space:=
pre">	</span>device-&gt;migrate_threshold =3D x;</div><div><span class=3D""=
 style=3D"white-space:pre">	</span>return r;</div>
<div>}</div><div><br></div><div>static struct device_sysfs_entry migrate_th=
reshold_entry =3D {</div><div><span class=3D"" style=3D"white-space:pre">	<=
/span>.attr =3D { .name =3D &quot;migrate_threshold&quot;, .mode =3D S_IRUG=
O | S_IWUSR },</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>.show =3D migrate_t=
hreshold_show,</div><div><span class=3D"" style=3D"white-space:pre">	</span=
>.store =3D migrate_threshold_store,</div><div>};</div><div><br></div><div>=
static ssize_t nr_dirty_caches_show(struct lc_device *device, char *page)</=
div>
<div>{</div><div><span class=3D"" style=3D"white-space:pre">	</span>unsigne=
d long val =3D atomic64_read(&amp;device-&gt;nr_dirty_caches);</div><div><s=
pan class=3D"" style=3D"white-space:pre">	</span>return var_show(val, page)=
;</div>
<div>}</div><div><br></div><div>static struct device_sysfs_entry nr_dirty_c=
aches_entry =3D {</div><div><span class=3D"" style=3D"white-space:pre">	</s=
pan>.attr =3D { .name =3D &quot;nr_dirty_caches&quot;, .mode =3D S_IRUGO },=
</div><div>
<span class=3D"" style=3D"white-space:pre">	</span>.show =3D nr_dirty_cache=
s_show,</div><div>};</div><div><br></div><div>static struct attribute *devi=
ce_default_attrs[] =3D {</div><div><span class=3D"" style=3D"white-space:pr=
e">	</span>&amp;cache_id_entry.attr,</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>&amp;dev_entry.attr=
,</div><div><span class=3D"" style=3D"white-space:pre">	</span>&amp;migrate=
_threshold_entry.attr,</div><div><span class=3D"" style=3D"white-space:pre"=
>	</span>&amp;nr_dirty_caches_entry.attr,</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>NULL,</div><div>};<=
/div><div><br></div><div>static const struct sysfs_ops device_sysfs_ops =3D=
 {</div><div><span class=3D"" style=3D"white-space:pre">	</span>.show =3D d=
evice_attr_show,</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>.store =3D device_a=
ttr_store,</div><div>};</div><div><br></div><div>static void device_release=
(struct kobject *kobj)</div><div>{</div><div><span class=3D"" style=3D"whit=
e-space:pre">	</span>return;</div>
<div>}</div><div><br></div><div>static struct kobj_type device_ktype =3D {<=
/div><div><span class=3D"" style=3D"white-space:pre">	</span>.sysfs_ops =3D=
 &amp;device_sysfs_ops,</div><div><span class=3D"" style=3D"white-space:pre=
">	</span>.default_attrs =3D device_default_attrs,</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>.release =3D device=
_release,</div><div>};</div><div><br></div><div>/*</div><div>=A0* &lt;devic=
e-id&gt; &lt;path&gt; &lt;cache-id&gt;</div><div>=A0*/</div><div>static int=
 lc_ctr(struct dm_target *ti, unsigned int argc, char **argv)</div>
<div>{</div><div>#if LINUX_VERSION_CODE &gt;=3D KERNEL_VERSION(3, 6, 0)</di=
v><div><span class=3D"" style=3D"white-space:pre">	</span>int r;</div><div>=
<span class=3D"" style=3D"white-space:pre">	</span>r =3D dm_set_target_max_=
io_len(ti, (1 &lt;&lt; 3));</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>if (r)</div><div><s=
pan class=3D"" style=3D"white-space:pre">		</span>return r;</div><div><br><=
/div><div>#else</div><div><span class=3D"" style=3D"white-space:pre">	</spa=
n>ti-&gt;split_io =3D (1 &lt;&lt; 3);</div>
<div>#endif</div><div><br></div><div><span class=3D"" style=3D"white-space:=
pre">	</span>struct lc_device *lc =3D kzalloc(sizeof(*lc), GFP_KERNEL);</di=
v><div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>/*=
</div>
<div><span class=3D"" style=3D"white-space:pre">	</span> * EMC&#39;s book s=
ays</div><div><span class=3D"" style=3D"white-space:pre">	</span> * storage=
 should keep its disk util less than 70%.</div><div><span class=3D"" style=
=3D"white-space:pre">	</span> */</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>lc-&gt;migrate_thre=
shold =3D 70;</div><div><br></div><div><span class=3D"" style=3D"white-spac=
e:pre">	</span>atomic64_set(&amp;lc-&gt;nr_dirty_caches, 0);</div><div><spa=
n class=3D"" style=3D"white-space:pre">	</span>atomic64_inc(&amp;lc-&gt;nr_=
dirty_caches);</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>atomic64_dec(&amp;l=
c-&gt;nr_dirty_caches);</div><div><br></div><div><span class=3D"" style=3D"=
white-space:pre">	</span>unsigned device_id;</div><div><span class=3D"" sty=
le=3D"white-space:pre">	</span>if (sscanf(argv[0], &quot;%u&quot;, &amp;dev=
ice_id) !=3D 1)</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>return -EINVAL;</d=
iv><div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>l=
c-&gt;id =3D device_id;</div><div><br></div><div><span class=3D"" style=3D"=
white-space:pre">	</span>struct dm_dev *dev;</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>if (dm_get_device(t=
i, argv[1], dm_table_get_mode(ti-&gt;table), &amp;dev))</div><div><span cla=
ss=3D"" style=3D"white-space:pre">		</span>return -EINVAL;</div><div><br></=
div>
<div><span class=3D"" style=3D"white-space:pre">	</span>lc-&gt;device =3D d=
ev;</div><div><br></div><div><span class=3D"" style=3D"white-space:pre">	</=
span>lc-&gt;cache =3D NULL;</div><div><span class=3D"" style=3D"white-space=
:pre">	</span>unsigned cache_id;</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>if (sscanf(argv[2],=
 &quot;%u&quot;, &amp;cache_id) !=3D 1)</div><div><span class=3D"" style=3D=
"white-space:pre">		</span>return -EINVAL;</div><div><br></div><div><span c=
lass=3D"" style=3D"white-space:pre">	</span>if (cache_id)</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>lc-&gt;cache =3D l=
c_caches[cache_id];</div><div><br></div><div><span class=3D"" style=3D"whit=
e-space:pre">	</span>lc_devices[lc-&gt;id] =3D lc;</div><div><span class=3D=
"" style=3D"white-space:pre">	</span>ti-&gt;private =3D lc;</div>
<div><br></div><div>#if LINUX_VERSION_CODE &gt;=3D PER_BIO_VERSION</div><di=
v><span class=3D"" style=3D"white-space:pre">	</span>ti-&gt;per_bio_data_si=
ze =3D sizeof(struct per_bio_data);</div><div>#endif</div><div><br></div><d=
iv>#if LINUX_VERSION_CODE &gt;=3D KERNEL_VERSION(3, 9, 0)</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>ti-&gt;num_flush_bi=
os =3D 1;</div><div><span class=3D"" style=3D"white-space:pre">	</span>ti-&=
gt;num_discard_bios =3D 1;</div><div>#else</div><div><span class=3D"" style=
=3D"white-space:pre">	</span>ti-&gt;num_flush_requests =3D 1;</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>ti-&gt;num_discard_=
requests =3D 1;</div><div>#endif</div><div><br></div><div><span class=3D"" =
style=3D"white-space:pre">	</span>ti-&gt;discard_zeroes_data_unsupported =
=3D true;</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>/*</=
div><div><span class=3D"" style=3D"white-space:pre">	</span> * /sys/module/=
dm_lc/devices/$id/$atribute</div><div><span class=3D"" style=3D"white-space=
:pre">	</span> * =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0/dev # -&gt; Note</div>
<div><span class=3D"" style=3D"white-space:pre">	</span> * =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/device</div><div><span class=3D=
"" style=3D"white-space:pre">	</span> */</div><div><br></div><div><span cla=
ss=3D"" style=3D"white-space:pre">	</span>/*</div>
<div><span class=3D"" style=3D"white-space:pre">	</span> * Note:</div><div>=
<span class=3D"" style=3D"white-space:pre">	</span> * Reference to the mapp=
ed_device</div><div><span class=3D"" style=3D"white-space:pre">	</span> * i=
s used to show device name (major:minor).</div>
<div><span class=3D"" style=3D"white-space:pre">	</span> * major:minor is u=
sed in admin scripts</div><div><span class=3D"" style=3D"white-space:pre">	=
</span> * to get the sysfs node of a lc_device.</div><div><span class=3D"" =
style=3D"white-space:pre">	</span> */</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>lc-&gt;md =3D dm_ta=
ble_get_md(ti-&gt;table);</div><div><br></div><div><span class=3D"" style=
=3D"white-space:pre">	</span>return 0;</div><div>}</div><div><br></div><div=
>static void lc_dtr(struct dm_target *ti)</div>
<div>{</div><div><span class=3D"" style=3D"white-space:pre">	</span>struct =
lc_device *lc =3D ti-&gt;private;</div><div><br></div><div><span class=3D""=
 style=3D"white-space:pre">	</span>dm_put_device(ti, lc-&gt;device);</div><=
div><br>
</div><div><span class=3D"" style=3D"white-space:pre">	</span>ti-&gt;privat=
e =3D NULL;</div><div><span class=3D"" style=3D"white-space:pre">	</span>kf=
ree(lc);</div><div>}</div><div><br></div><div>struct kobject *get_bdev_kobj=
ect(struct block_device *bdev)</div>
<div>{</div><div><span class=3D"" style=3D"white-space:pre">	</span>return =
&amp;disk_to_dev(bdev-&gt;bd_disk)-&gt;kobj;</div><div>}</div><div><br></di=
v><div>static int lc_message(struct dm_target *ti, unsigned argc, char **ar=
gv)</div>
<div>{</div><div><span class=3D"" style=3D"white-space:pre">	</span>int r;<=
/div><div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span=
>struct lc_device *lc =3D ti-&gt;private;</div><div><br></div><div><span cl=
ass=3D"" style=3D"white-space:pre">	</span>char *cmd =3D argv[0];</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>if (=
!strcasecmp(cmd, &quot;add_sysfs&quot;)) {</div><div><span class=3D"" style=
=3D"white-space:pre">		</span>r =3D kobject_init_and_add(&amp;lc-&gt;kobj, =
&amp;device_ktype,</div>
<div><span class=3D"" style=3D"white-space:pre">					</span> devices_kobj, =
&quot;%u&quot;, lc-&gt;id);</div><div><span class=3D"" style=3D"white-space=
:pre">		</span>struct kobject *dev_kobj =3D get_bdev_kobject(lc-&gt;device-=
&gt;bdev);</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>r =3D sysfs_create=
_link(&amp;lc-&gt;kobj, dev_kobj, &quot;device&quot;);</div><div><br></div>=
<div><span class=3D"" style=3D"white-space:pre">		</span>/* kobject_uevent(=
&amp;lc-&gt;kobj, KOBJ_ADD); */</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>return 0;</div><di=
v><span class=3D"" style=3D"white-space:pre">	</span>}</div><div><br></div>=
<div><span class=3D"" style=3D"white-space:pre">	</span>if (!strcasecmp(cmd=
, &quot;remove_sysfs&quot;)) {</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>sysfs_remove_link(=
&amp;lc-&gt;kobj, &quot;device&quot;);</div><div><span class=3D"" style=3D"=
white-space:pre">		</span>kobject_del(&amp;lc-&gt;kobj);</div><div><span cl=
ass=3D"" style=3D"white-space:pre">		</span>kobject_put(&amp;lc-&gt;kobj);<=
/div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">		</span>lc_=
devices[lc-&gt;id] =3D NULL;</div><div><br></div><div><span class=3D"" styl=
e=3D"white-space:pre">		</span>/* kobject_uevent(&amp;lc-&gt;kobj, KOBJ_REM=
OVE); */</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>return 0;</div><di=
v><span class=3D"" style=3D"white-space:pre">	</span>}</div><div><br></div>=
<div><span class=3D"" style=3D"white-space:pre">	</span>return -EINVAL;</di=
v><div>}</div>
<div><br></div><div>static int lc_merge(struct dm_target *ti, struct bvec_m=
erge_data *bvm,</div><div><span class=3D"" style=3D"white-space:pre">		</sp=
an> =A0 =A0struct bio_vec *biovec, int max_size)</div><div>{</div><div><spa=
n class=3D"" style=3D"white-space:pre">	</span>struct lc_device *lc =3D ti-=
&gt;private;</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>struct dm_dev *devi=
ce =3D lc-&gt;device;</div><div><span class=3D"" style=3D"white-space:pre">=
	</span>struct request_queue *q =3D bdev_get_queue(device-&gt;bdev);</div><=
div><br>
</div><div><span class=3D"" style=3D"white-space:pre">	</span>if (!q-&gt;me=
rge_bvec_fn)</div><div><span class=3D"" style=3D"white-space:pre">		</span>=
return max_size;</div><div><br></div><div><span class=3D"" style=3D"white-s=
pace:pre">	</span>bvm-&gt;bi_bdev =3D device-&gt;bdev;</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>return min(max_size=
, q-&gt;merge_bvec_fn(q, bvm, biovec));</div><div>}</div><div><br></div><di=
v>static int lc_iterate_devices(struct dm_target *ti,</div><div><span class=
=3D"" style=3D"white-space:pre">			</span> =A0 =A0 =A0iterate_devices_callo=
ut_fn fn, void *data)</div>
<div>{</div><div><span class=3D"" style=3D"white-space:pre">	</span>struct =
lc_device *lc =3D ti-&gt;private;</div><div><span class=3D"" style=3D"white=
-space:pre">	</span>struct dm_dev *orig =3D lc-&gt;device;</div><div><span =
class=3D"" style=3D"white-space:pre">	</span>sector_t start =3D 0;</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>sector_t len =3D dm=
_devsize(orig);</div><div><span class=3D"" style=3D"white-space:pre">	</spa=
n>return fn(ti, orig, start, len, data);</div><div>}</div><div><br></div><d=
iv>static void lc_io_hints(struct dm_target *ti, struct queue_limits *limit=
s)</div>
<div>{</div><div><span class=3D"" style=3D"white-space:pre">	</span>blk_lim=
its_io_min(limits, 512);</div><div><span class=3D"" style=3D"white-space:pr=
e">	</span>blk_limits_io_opt(limits, 4096);</div><div>}</div><div><br></div=
><div>
static</div><div>#if LINUX_VERSION_CODE &gt;=3D KERNEL_VERSION(3, 8, 0)</di=
v><div>void</div><div>#else</div><div>int</div><div>#endif</div><div>lc_sta=
tus(</div><div><span class=3D"" style=3D"white-space:pre">		</span>struct d=
m_target *ti, status_type_t type,</div>
<div>#if LINUX_VERSION_CODE &gt;=3D KERNEL_VERSION(3, 6, 0)</div><div><span=
 class=3D"" style=3D"white-space:pre">		</span>unsigned flags,</div><div>#e=
ndif</div><div><span class=3D"" style=3D"white-space:pre">		</span>char *re=
sult,</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>unsigned maxlen)</=
div><div>{</div><div><span class=3D"" style=3D"white-space:pre">	</span>uns=
igned int sz =3D 0;</div><div><br></div><div><span class=3D"" style=3D"whit=
e-space:pre">	</span>struct lc_device *lc =3D ti-&gt;private;</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>switch (type) {</di=
v><div><span class=3D"" style=3D"white-space:pre">	</span>case STATUSTYPE_I=
NFO:</div><div><span class=3D"" style=3D"white-space:pre">		</span>result[0=
] =3D &#39;\0&#39;;</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>break;</div><div><=
br></div><div><span class=3D"" style=3D"white-space:pre">	</span>case STATU=
STYPE_TABLE:</div><div><span class=3D"" style=3D"white-space:pre">		</span>=
DMEMIT(&quot;%d %s %d&quot;, lc-&gt;id, lc-&gt;device-&gt;name, cache_id_of=
(lc));</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>break;</div><div><=
span class=3D"" style=3D"white-space:pre">	</span>}</div><div>#if LINUX_VER=
SION_CODE &lt; KERNEL_VERSION(3, 8, 0)</div><div><span class=3D"" style=3D"=
white-space:pre">	</span>return 0;</div>
<div>#endif</div><div>}</div><div><br></div><div>static struct target_type =
lc_target =3D {</div><div><span class=3D"" style=3D"white-space:pre">	</spa=
n>.name =3D &quot;lc&quot;,</div><div><span class=3D"" style=3D"white-space=
:pre">	</span>.version =3D {1, 0, 0},</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>.module =3D THIS_MO=
DULE,</div><div><span class=3D"" style=3D"white-space:pre">	</span>.map =3D=
 lc_map,</div><div><span class=3D"" style=3D"white-space:pre">	</span>.ctr =
=3D lc_ctr,</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>.dtr =3D lc_dtr,</d=
iv><div><span class=3D"" style=3D"white-space:pre">	</span>.end_io =3D lc_e=
nd_io,</div><div><span class=3D"" style=3D"white-space:pre">	</span>.merge =
=3D lc_merge,</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>.message =3D lc_mes=
sage,</div><div><span class=3D"" style=3D"white-space:pre">	</span>.status =
=3D lc_status,</div><div><span class=3D"" style=3D"white-space:pre">	</span=
>.io_hints =3D lc_io_hints,</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>.iterate_devices =
=3D lc_iterate_devices,</div><div>};</div><div><br></div><div>static int lc=
_mgr_map(struct dm_target *ti, struct bio *bio</div><div>#if LINUX_VERSION_=
CODE &lt; KERNEL_VERSION(3, 8, 0)</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>, union map_info *=
map_context</div><div>#endif</div><div><span class=3D"" style=3D"white-spac=
e:pre">		</span>)</div><div>{</div><div><span class=3D"" style=3D"white-spa=
ce:pre">	</span>bio_endio(bio, 0);</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>return DM_MAPIO_SUB=
MITTED;</div><div>}</div><div><br></div><div>static int lc_mgr_ctr(struct d=
m_target *ti, unsigned int argc, char **argv)</div><div>{</div><div><span c=
lass=3D"" style=3D"white-space:pre">	</span>return 0;</div>
<div>}</div><div><br></div><div>static void lc_mgr_dtr(struct dm_target *ti=
)</div><div>{</div><div><span class=3D"" style=3D"white-space:pre">	</span>=
return;</div><div>}</div><div><br></div><div>static struct kobject *caches_=
kobj;</div>
<div><br></div><div>struct cache_sysfs_entry {</div><div><span class=3D"" s=
tyle=3D"white-space:pre">	</span>struct attribute attr;</div><div><span cla=
ss=3D"" style=3D"white-space:pre">	</span>ssize_t (*show)(struct lc_cache *=
, char *);</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>ssize_t (*store)(st=
ruct lc_cache *, const char *, size_t);</div><div>};</div><div><br></div><d=
iv>#define to_cache(attr) container_of((attr), struct cache_sysfs_entry, at=
tr)</div>
<div>static ssize_t cache_attr_show(struct kobject *kobj,</div><div><span c=
lass=3D"" style=3D"white-space:pre">			</span> =A0 =A0 =A0 struct attribute=
 *attr, char *page)</div><div>{</div><div><span class=3D"" style=3D"white-s=
pace:pre">	</span>struct cache_sysfs_entry *entry =3D to_cache(attr);</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>struct lc_cache *ca=
che =3D</div><div><span class=3D"" style=3D"white-space:pre">		</span>conta=
iner_of(kobj, struct lc_cache, kobj);</div><div><br></div><div><span class=
=3D"" style=3D"white-space:pre">	</span>return entry-&gt;show(cache, page);=
</div>
<div>}</div><div><br></div><div>static ssize_t cache_attr_store(struct kobj=
ect *kobj, struct attribute *attr,</div><div><span class=3D"" style=3D"whit=
e-space:pre">		</span>const char *page, size_t len)</div><div>{</div><div><=
span class=3D"" style=3D"white-space:pre">	</span>struct cache_sysfs_entry =
*entry =3D to_cache(attr);</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>if (!entry-&gt;stor=
e)</div><div><span class=3D"" style=3D"white-space:pre">		</span>return -EI=
O;</div><div><br></div><div><span class=3D"" style=3D"white-space:pre">	</s=
pan>struct lc_cache *cache =3D container_of(kobj, struct lc_cache, kobj);</=
div>
<div><span class=3D"" style=3D"white-space:pre">	</span>return entry-&gt;st=
ore(cache, page, len);</div><div>}</div><div><br></div><div>static ssize_t =
commit_super_block_interval_show(struct lc_cache *cache,</div><div><span cl=
ass=3D"" style=3D"white-space:pre">						</span>char *page)</div>
<div>{</div><div><span class=3D"" style=3D"white-space:pre">	</span>return =
var_show(cache-&gt;commit_super_block_interval, (page));</div><div>}</div><=
div><br></div><div>static ssize_t commit_super_block_interval_store(struct =
lc_cache *cache,</div>
<div><span class=3D"" style=3D"white-space:pre">						</span> const char *p=
age, size_t count)</div><div>{</div><div><span class=3D"" style=3D"white-sp=
ace:pre">	</span>unsigned long x;</div><div><span class=3D"" style=3D"white=
-space:pre">	</span>ssize_t r =3D var_store(&amp;x, page, count);</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>cache-&gt;commit_su=
per_block_interval =3D x;</div><div><span class=3D"" style=3D"white-space:p=
re">	</span>return r;</div><div>}</div><div><br></div><div>static struct ca=
che_sysfs_entry commit_super_block_interval_entry =3D {</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>.attr =3D { .name =
=3D &quot;commit_super_block_interval&quot;,</div><div><span class=3D"" sty=
le=3D"white-space:pre">		</span> =A0.mode =3D S_IRUGO | S_IWUSR },</div><di=
v><span class=3D"" style=3D"white-space:pre">	</span>.show =3D commit_super=
_block_interval_show,</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>.store =3D commit_s=
uper_block_interval_store,</div><div>};</div><div><br></div><div>static ssi=
ze_t allow_migrate_show(struct lc_cache *cache, char *page)</div><div>{</di=
v>
<div><span class=3D"" style=3D"white-space:pre">	</span>return var_show(cac=
he-&gt;allow_migrate, (page));</div><div>}</div><div><br></div><div>static =
ssize_t allow_migrate_store(struct lc_cache *cache,</div><div><span class=
=3D"" style=3D"white-space:pre">				</span> =A0 const char *page, size_t co=
unt)</div>
<div>{</div><div><span class=3D"" style=3D"white-space:pre">	</span>unsigne=
d long x;</div><div><span class=3D"" style=3D"white-space:pre">	</span>ssiz=
e_t r =3D var_store(&amp;x, page, count);</div><div><span class=3D"" style=
=3D"white-space:pre">	</span>cache-&gt;allow_migrate =3D x;</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>return r;</div><div=
>}</div><div><br></div><div>static struct cache_sysfs_entry allow_migrate_e=
ntry =3D {</div><div><span class=3D"" style=3D"white-space:pre">	</span>.at=
tr =3D { .name =3D &quot;allow_migrate&quot;, .mode =3D S_IRUGO | S_IWUSR }=
,</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>.show =3D allow_mig=
rate_show,</div><div><span class=3D"" style=3D"white-space:pre">	</span>.st=
ore =3D allow_migrate_store,</div><div>};</div><div><br></div><div>static s=
size_t force_migrate_show(struct lc_cache *cache, char *page)</div>
<div>{</div><div><span class=3D"" style=3D"white-space:pre">	</span>return =
var_show(cache-&gt;force_migrate, page);</div><div>}</div><div><br></div><d=
iv>static ssize_t force_migrate_store(struct lc_cache *cache,</div><div><sp=
an class=3D"" style=3D"white-space:pre">				</span> =A0 const char *page, s=
ize_t count)</div>
<div>{</div><div><span class=3D"" style=3D"white-space:pre">	</span>unsigne=
d long x;</div><div><span class=3D"" style=3D"white-space:pre">	</span>ssiz=
e_t r =3D var_store(&amp;x, page, count);</div><div><span class=3D"" style=
=3D"white-space:pre">	</span>cache-&gt;force_migrate =3D x;</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>return r;</div><div=
>}</div><div><br></div><div>static struct cache_sysfs_entry force_migrate_e=
ntry =3D {</div><div><span class=3D"" style=3D"white-space:pre">	</span>.at=
tr =3D { .name =3D &quot;force_migrate&quot;, .mode =3D S_IRUGO | S_IWUSR }=
,</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>.show =3D force_mig=
rate_show,</div><div><span class=3D"" style=3D"white-space:pre">	</span>.st=
ore =3D force_migrate_store,</div><div>};</div><div><br></div><div>static s=
size_t update_interval_show(struct lc_cache *cache, char *page)</div>
<div>{</div><div><span class=3D"" style=3D"white-space:pre">	</span>return =
var_show(cache-&gt;update_interval, page);</div><div>}</div><div><br></div>=
<div>static ssize_t update_interval_store(struct lc_cache *cache,</div><div=
>
<span class=3D"" style=3D"white-space:pre">				</span> =A0 =A0 const char *=
page, size_t count)</div><div>{</div><div><span class=3D"" style=3D"white-s=
pace:pre">	</span>unsigned long x;</div><div><span class=3D"" style=3D"whit=
e-space:pre">	</span>ssize_t r =3D var_store(&amp;x, page, count);</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>cache-&gt;update_in=
terval =3D x;</div><div><span class=3D"" style=3D"white-space:pre">	</span>=
return r;</div><div>}</div><div><br></div><div>static struct cache_sysfs_en=
try update_interval_entry =3D {</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>.attr =3D { .name =
=3D &quot;update_interval&quot;, .mode =3D S_IRUGO | S_IWUSR },</div><div><=
span class=3D"" style=3D"white-space:pre">	</span>.show =3D update_interval=
_show,</div><div>
<span class=3D"" style=3D"white-space:pre">	</span>.store =3D update_interv=
al_store,</div><div>};</div><div><br></div><div>static ssize_t flush_curren=
t_buffer_interval_show(struct lc_cache *cache,</div><div><span class=3D"" s=
tyle=3D"white-space:pre">						</span> =A0char *page)</div>
<div>{</div><div><span class=3D"" style=3D"white-space:pre">	</span>return =
var_show(cache-&gt;flush_current_buffer_interval, page);</div><div>}</div><=
div><br></div><div>static ssize_t flush_current_buffer_interval_store(</div=
>
<div><span class=3D"" style=3D"white-space:pre">		</span>struct lc_cache *c=
ache, const char *page, size_t count)</div><div>{</div><div><span class=3D"=
" style=3D"white-space:pre">	</span>unsigned long x;</div><div><span class=
=3D"" style=3D"white-space:pre">	</span>ssize_t r =3D var_store(&amp;x, pag=
e, count);</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>cache-&gt;flush_cur=
rent_buffer_interval =3D x;</div><div><span class=3D"" style=3D"white-space=
:pre">	</span>return r;</div><div>}</div><div><br></div><div>static struct =
cache_sysfs_entry flush_current_buffer_interval_entry =3D {</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>.attr =3D { .name =
=3D &quot;flush_current_buffer_interval&quot;,</div><div><span class=3D"" s=
tyle=3D"white-space:pre">		</span> =A0.mode =3D S_IRUGO | S_IWUSR },</div><=
div><span class=3D"" style=3D"white-space:pre">	</span>.show =3D flush_curr=
ent_buffer_interval_show,</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>.store =3D flush_cu=
rrent_buffer_interval_store,</div><div>};</div><div><br></div><div>static s=
size_t commit_super_block_show(struct lc_cache *cache, char *page)</div><di=
v>
{</div><div><span class=3D"" style=3D"white-space:pre">	</span>return var_s=
how(0, (page));</div><div>}</div><div><br></div><div>static ssize_t commit_=
super_block_store(struct lc_cache *cache,</div><div><span class=3D"" style=
=3D"white-space:pre">					</span>const char *page, size_t count)</div>
<div>{</div><div><span class=3D"" style=3D"white-space:pre">	</span>unsigne=
d long x;</div><div><span class=3D"" style=3D"white-space:pre">	</span>ssiz=
e_t r =3D var_store(&amp;x, page, count);</div><div><br></div><div><span cl=
ass=3D"" style=3D"white-space:pre">	</span>if (x &lt; 1)</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>return -EIO;</div>=
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>mute=
x_lock(&amp;cache-&gt;io_lock);</div><div><span class=3D"" style=3D"white-s=
pace:pre">	</span>commit_super_block(cache);</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>mutex_unlock(&amp;c=
ache-&gt;io_lock);</div><div><br></div><div><span class=3D"" style=3D"white=
-space:pre">	</span>return r;</div><div>}</div><div><br></div><div>static s=
truct cache_sysfs_entry commit_super_block_entry =3D {</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>.attr =3D { .name =
=3D &quot;commit_super_block&quot;, .mode =3D S_IRUGO | S_IWUSR },</div><di=
v><span class=3D"" style=3D"white-space:pre">	</span>.show =3D commit_super=
_block_show,</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>.store =3D commit_s=
uper_block_store,</div><div>};</div><div><br></div><div>static ssize_t flus=
h_current_buffer_show(struct lc_cache *cache, char *page)</div><div>{</div>=
<div>
<span class=3D"" style=3D"white-space:pre">	</span>return var_show(0, (page=
));</div><div>}</div><div><br></div><div>static ssize_t flush_current_buffe=
r_store(struct lc_cache *cache,</div><div><span class=3D"" style=3D"white-s=
pace:pre">					</span> =A0const char *page, size_t count)</div>
<div>{</div><div><span class=3D"" style=3D"white-space:pre">	</span>unsigne=
d long x;</div><div><br></div><div><span class=3D"" style=3D"white-space:pr=
e">	</span>ssize_t r =3D var_store(&amp;x, page, count);</div><div><span cl=
ass=3D"" style=3D"white-space:pre">	</span>if (x &lt; 1)</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>return -EIO;</div>=
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>flus=
h_current_buffer_sync(cache);</div><div><span class=3D"" style=3D"white-spa=
ce:pre">	</span>return r;</div>
<div>}</div><div><br></div><div>static struct cache_sysfs_entry flush_curre=
nt_buffer_entry =3D {</div><div><span class=3D"" style=3D"white-space:pre">=
	</span>.attr =3D { .name =3D &quot;flush_current_buffer&quot;, .mode =3D S=
_IRUGO | S_IWUSR },</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>.show =3D flush_cur=
rent_buffer_show,</div><div><span class=3D"" style=3D"white-space:pre">	</s=
pan>.store =3D flush_current_buffer_store,</div><div>};</div><div><br></div=
><div>static ssize_t last_flushed_segment_id_show(struct lc_cache *cache, c=
har *page)</div>
<div>{</div><div><span class=3D"" style=3D"white-space:pre">	</span>return =
var_show(cache-&gt;last_flushed_segment_id, (page));</div><div>}</div><div>=
<br></div><div>static struct cache_sysfs_entry last_flushed_segment_id_entr=
y =3D {</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>.attr =3D { .name =
=3D &quot;last_flushed_segment_id&quot;, .mode =3D S_IRUGO },</div><div><sp=
an class=3D"" style=3D"white-space:pre">	</span>.show =3D last_flushed_segm=
ent_id_show,</div>
<div>};</div><div><br></div><div>static ssize_t last_migrated_segment_id_sh=
ow(struct lc_cache *cache, char *page)</div><div>{</div><div><span class=3D=
"" style=3D"white-space:pre">	</span>return var_show(cache-&gt;last_migrate=
d_segment_id, (page));</div>
<div>}</div><div><br></div><div>static struct cache_sysfs_entry last_migrat=
ed_segment_id_entry =3D {</div><div><span class=3D"" style=3D"white-space:p=
re">	</span>.attr =3D { .name =3D &quot;last_migrated_segment_id&quot;, .mo=
de =3D S_IRUGO },</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>.show =3D last_migr=
ated_segment_id_show,</div><div>};</div><div><br></div><div>static ssize_t =
barrier_deadline_ms_show(struct lc_cache *cache, char *page)</div><div>{</d=
iv>
<div><span class=3D"" style=3D"white-space:pre">	</span>return var_show(cac=
he-&gt;barrier_deadline_ms, (page));</div><div>}</div><div><br></div><div>s=
tatic ssize_t barrier_deadline_ms_store(struct lc_cache *cache,</div><div><=
span class=3D"" style=3D"white-space:pre">					</span> const char *page, si=
ze_t count)</div>
<div>{</div><div><span class=3D"" style=3D"white-space:pre">	</span>unsigne=
d long x;</div><div><span class=3D"" style=3D"white-space:pre">	</span>ssiz=
e_t r =3D var_store(&amp;x, page, count);</div><div><br></div><div><span cl=
ass=3D"" style=3D"white-space:pre">	</span>cache-&gt;barrier_deadline_ms =
=3D x;</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>return r;</div><div=
>}</div><div><br></div><div>static struct cache_sysfs_entry barrier_deadlin=
e_ms_entry =3D {</div><div><span class=3D"" style=3D"white-space:pre">	</sp=
an>.attr =3D { .name =3D &quot;barrier_deadline_ms&quot;, .mode =3D S_IRUGO=
 | S_IWUSR },</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>.show =3D barrier_d=
eadline_ms_show,</div><div><span class=3D"" style=3D"white-space:pre">	</sp=
an>.store =3D barrier_deadline_ms_store,</div><div>};</div><div><br></div><=
div>static struct attribute *cache_default_attrs[] =3D {</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>&amp;commit_super_b=
lock_interval_entry.attr,</div><div><span class=3D"" style=3D"white-space:p=
re">	</span>&amp;allow_migrate_entry.attr,</div><div><span class=3D"" style=
=3D"white-space:pre">	</span>&amp;commit_super_block_entry.attr,</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>&amp;flush_current_=
buffer_entry.attr,</div><div><span class=3D"" style=3D"white-space:pre">	</=
span>&amp;flush_current_buffer_interval_entry.attr,</div><div><span class=
=3D"" style=3D"white-space:pre">	</span>&amp;force_migrate_entry.attr,</div=
>
<div><span class=3D"" style=3D"white-space:pre">	</span>&amp;update_interva=
l_entry.attr,</div><div><span class=3D"" style=3D"white-space:pre">	</span>=
&amp;last_flushed_segment_id_entry.attr,</div><div><span class=3D"" style=
=3D"white-space:pre">	</span>&amp;last_migrated_segment_id_entry.attr,</div=
>
<div><span class=3D"" style=3D"white-space:pre">	</span>&amp;barrier_deadli=
ne_ms_entry.attr,</div><div><span class=3D"" style=3D"white-space:pre">	</s=
pan>NULL,</div><div>};</div><div><br></div><div>static const struct sysfs_o=
ps cache_sysfs_ops =3D {</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>.show =3D cache_att=
r_show,</div><div><span class=3D"" style=3D"white-space:pre">	</span>.store=
 =3D cache_attr_store,</div><div>};</div><div><br></div><div>static void ca=
che_release(struct kobject *kobj)</div>
<div>{</div><div><span class=3D"" style=3D"white-space:pre">	</span>return;=
</div><div>}</div><div><br></div><div>static struct kobj_type cache_ktype =
=3D {</div><div><span class=3D"" style=3D"white-space:pre">	</span>.sysfs_o=
ps =3D &amp;cache_sysfs_ops,</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>.default_attrs =3D =
cache_default_attrs,</div><div><span class=3D"" style=3D"white-space:pre">	=
</span>.release =3D cache_release,</div><div>};</div><div><br></div><div>st=
atic int lc_mgr_message(struct dm_target *ti, unsigned int argc, char **arg=
v)</div>
<div>{</div><div><span class=3D"" style=3D"white-space:pre">	</span>char *c=
md =3D argv[0];</div><div><br></div><div><span class=3D"" style=3D"white-sp=
ace:pre">	</span>/*</div><div><span class=3D"" style=3D"white-space:pre">	<=
/span> * &lt;path&gt;</div>
<div><span class=3D"" style=3D"white-space:pre">	</span> * @path path to th=
e cache device</div><div><span class=3D"" style=3D"white-space:pre">	</span=
> */</div><div><span class=3D"" style=3D"white-space:pre">	</span>if (!strc=
asecmp(cmd, &quot;format_cache_device&quot;)) {</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>struct dm_dev *dev=
;</div><div><span class=3D"" style=3D"white-space:pre">		</span>if (dm_get_=
device(ti, argv[1],</div><div><span class=3D"" style=3D"white-space:pre">		=
		</span> =A0dm_table_get_mode(ti-&gt;table), &amp;dev))</div>
<div><span class=3D"" style=3D"white-space:pre">			</span>return -EINVAL;</=
div><div><br></div><div><span class=3D"" style=3D"white-space:pre">		</span=
>format_cache_device(dev);</div><div><br></div><div><span class=3D"" style=
=3D"white-space:pre">		</span>dm_put_device(ti, dev);</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>return 0;</div><di=
v><span class=3D"" style=3D"white-space:pre">	</span>}</div><div><br></div>=
<div><span class=3D"" style=3D"white-space:pre">	</span>/*</div><div><span =
class=3D"" style=3D"white-space:pre">	</span> * &lt;id&gt;</div>
<div><span class=3D"" style=3D"white-space:pre">	</span> *</div><div><span =
class=3D"" style=3D"white-space:pre">	</span> * lc-mgr has cursor to point =
the</div><div><span class=3D"" style=3D"white-space:pre">	</span> * cache d=
evice to operate.</div>
<div><span class=3D"" style=3D"white-space:pre">	</span> */</div><div><span=
 class=3D"" style=3D"white-space:pre">	</span>if (!strcasecmp(cmd, &quot;sw=
itch_to&quot;)) {</div><div><span class=3D"" style=3D"white-space:pre">		</=
span>unsigned id;</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>if (sscanf(argv[1]=
, &quot;%u&quot;, &amp;id) !=3D 1)</div><div><span class=3D"" style=3D"whit=
e-space:pre">			</span>return -EINVAL;</div><div><br></div><div><span class=
=3D"" style=3D"white-space:pre">		</span>cache_id_ptr =3D id;</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>return 0;</div><di=
v><span class=3D"" style=3D"white-space:pre">	</span>}</div><div><br></div>=
<div><span class=3D"" style=3D"white-space:pre">	</span>if (!strcasecmp(cmd=
, &quot;clear_stat&quot;)) {</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>struct lc_cache *c=
ache =3D lc_caches[cache_id_ptr];</div><div><span class=3D"" style=3D"white=
-space:pre">		</span>if (!cache)</div><div><span class=3D"" style=3D"white-=
space:pre">			</span>return -EINVAL;</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">		</span>cle=
ar_stat(cache);</div><div><span class=3D"" style=3D"white-space:pre">		</sp=
an>return 0;</div><div><span class=3D"" style=3D"white-space:pre">	</span>}=
</div><div>
<br></div><div><span class=3D"" style=3D"white-space:pre">	</span>/*</div><=
div><span class=3D"" style=3D"white-space:pre">	</span> * &lt;path&gt;</div=
><div><span class=3D"" style=3D"white-space:pre">	</span> */</div><div><spa=
n class=3D"" style=3D"white-space:pre">	</span>if (!strcasecmp(cmd, &quot;r=
esume_cache&quot;)) {</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>struct lc_cache *c=
ache =3D kzalloc(sizeof(*cache), GFP_KERNEL);</div><div><br></div><div><spa=
n class=3D"" style=3D"white-space:pre">		</span>struct dm_dev *dev;</div><d=
iv><span class=3D"" style=3D"white-space:pre">		</span>if (dm_get_device(ti=
, argv[1],</div>
<div><span class=3D"" style=3D"white-space:pre">				</span> =A0dm_table_get=
_mode(ti-&gt;table), &amp;dev))</div><div><span class=3D"" style=3D"white-s=
pace:pre">			</span>return -EINVAL;</div><div><br></div><div><span class=3D=
"" style=3D"white-space:pre">		</span>cache-&gt;id =3D cache_id_ptr;</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>cache-&gt;device =
=3D dev;</div><div><span class=3D"" style=3D"white-space:pre">		</span>cach=
e-&gt;nr_segments =3D calc_nr_segments(cache-&gt;device);</div><div><span c=
lass=3D"" style=3D"white-space:pre">		</span>cache-&gt;nr_caches =3D cache-=
&gt;nr_segments * NR_CACHES_INSEG;</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">		</span>mut=
ex_init(&amp;cache-&gt;io_lock);</div><div><br></div><div><span class=3D"" =
style=3D"white-space:pre">		</span>cache-&gt;wb_pool =3D kmalloc(</div><div=
><span class=3D"" style=3D"white-space:pre">			</span>sizeof(struct writebu=
ffer) * NR_WB_POOL, GFP_KERNEL);</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>struct writebuffer=
 *wb;</div><div><span class=3D"" style=3D"white-space:pre">		</span>int i;<=
/div><div><span class=3D"" style=3D"white-space:pre">		</span>for (i =3D 0;=
 i &lt; NR_WB_POOL; i++) {</div>
<div><span class=3D"" style=3D"white-space:pre">			</span>wb =3D cache-&gt;=
wb_pool + i;</div><div><span class=3D"" style=3D"white-space:pre">			</span=
>init_completion(&amp;wb-&gt;done);</div><div><span class=3D"" style=3D"whi=
te-space:pre">			</span>complete_all(&amp;wb-&gt;done);</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">			</span>wb=
-&gt;data =3D kmalloc(</div><div><span class=3D"" style=3D"white-space:pre"=
>				</span>1 &lt;&lt; (LC_SEGMENTSIZE_ORDER + SECTOR_SHIFT),</div><div><sp=
an class=3D"" style=3D"white-space:pre">				</span>GFP_KERNEL);</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>}</div><div><br></=
div><div><span class=3D"" style=3D"white-space:pre">		</span>/*</div><div><=
span class=3D"" style=3D"white-space:pre">		</span> * Select arbitrary one<=
/div><div>
<span class=3D"" style=3D"white-space:pre">		</span> * as the initial write=
buffer.</div><div><span class=3D"" style=3D"white-space:pre">		</span> */</=
div><div><span class=3D"" style=3D"white-space:pre">		</span>cache-&gt;curr=
ent_wb =3D cache-&gt;wb_pool + 0;</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">		</span>ini=
t_segment_header_array(cache);</div><div><span class=3D"" style=3D"white-sp=
ace:pre">		</span>mb_array_empty_init(cache);</div><div><span class=3D"" st=
yle=3D"white-space:pre">		</span>ht_empty_init(cache);</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">		</span>cac=
he-&gt;on_terminate =3D false;</div><div><span class=3D"" style=3D"white-sp=
ace:pre">		</span>cache-&gt;allow_migrate =3D false;</div><div><span class=
=3D"" style=3D"white-space:pre">		</span>cache-&gt;force_migrate =3D false;=
</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>cache-&gt;reservin=
g_segment_id =3D 0;</div><div><br></div><div><span class=3D"" style=3D"whit=
e-space:pre">		</span>cache-&gt;flush_wq =3D create_singlethread_workqueue(=
&quot;flushwq&quot;);</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>spin_lock_init(&am=
p;cache-&gt;flush_queue_lock);</div><div><span class=3D"" style=3D"white-sp=
ace:pre">		</span>INIT_WORK(&amp;cache-&gt;flush_work, flush_proc);</div><d=
iv><span class=3D"" style=3D"white-space:pre">		</span>INIT_LIST_HEAD(&amp;=
cache-&gt;flush_queue);</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>init_waitqueue_hea=
d(&amp;cache-&gt;flush_wait_queue);</div><div><span class=3D"" style=3D"whi=
te-space:pre">		</span>queue_work(cache-&gt;flush_wq, &amp;cache-&gt;flush_=
work);</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">		</span>cac=
he-&gt;migrate_wq =3D create_singlethread_workqueue(&quot;migratewq&quot;);=
</div><div><span class=3D"" style=3D"white-space:pre">		</span>INIT_WORK(&a=
mp;cache-&gt;migrate_work, migrate_proc);</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>queue_work(cache-&=
gt;migrate_wq, &amp;cache-&gt;migrate_work);</div><div><br></div><div><span=
 class=3D"" style=3D"white-space:pre">		</span>init_waitqueue_head(&amp;cac=
he-&gt;migrate_wait_queue);</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>atomic_set(&amp;ca=
che-&gt;migrate_fail_count, 0);</div><div><span class=3D"" style=3D"white-s=
pace:pre">		</span>atomic_set(&amp;cache-&gt;migrate_io_count, 0);</div><di=
v><span class=3D"" style=3D"white-space:pre">		</span>cache-&gt;migrate_buf=
fer =3D kmalloc(</div>
<div><span class=3D"" style=3D"white-space:pre">				</span>1 &lt;&lt; (LC_S=
EGMENTSIZE_ORDER + SECTOR_SHIFT),</div><div><span class=3D"" style=3D"white=
-space:pre">				</span>GFP_KERNEL);</div><div><br></div><div><span class=3D=
"" style=3D"white-space:pre">		</span>setup_timer(&amp;cache-&gt;barrier_de=
adline_timer,</div>
<div><span class=3D"" style=3D"white-space:pre">			</span> =A0 =A0barrier_d=
eadline_proc, (unsigned long) cache);</div><div><span class=3D"" style=3D"w=
hite-space:pre">		</span>bio_list_init(&amp;cache-&gt;barrier_ios);</div><d=
iv><br></div>
<div><span class=3D"" style=3D"white-space:pre">		</span>/*</div><div><span=
 class=3D"" style=3D"white-space:pre">		</span> * deadline is 3 ms by defau=
lt.</div><div><span class=3D"" style=3D"white-space:pre">		</span> * 2.5 us=
 to process on bio</div>
<div><span class=3D"" style=3D"white-space:pre">		</span> * and 3 ms is eno=
ugh long to process 255 bios.</div><div><span class=3D"" style=3D"white-spa=
ce:pre">		</span> * If the buffer doesn&#39;t get full within 3 ms,</div><d=
iv><span class=3D"" style=3D"white-space:pre">		</span> * we can doubt writ=
e starves</div>
<div><span class=3D"" style=3D"white-space:pre">		</span> * by waiting form=
erly submitted barrier to be complete.</div><div><span class=3D"" style=3D"=
white-space:pre">		</span> */</div><div><span class=3D"" style=3D"white-spa=
ce:pre">		</span>cache-&gt;barrier_deadline_ms =3D 3;</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>INIT_WORK(&amp;cac=
he-&gt;barrier_deadline_work, flush_barrier_ios);</div><div><br></div><div>=
<span class=3D"" style=3D"white-space:pre">		</span>recover_cache(cache);</=
div>
<div><span class=3D"" style=3D"white-space:pre">		</span>lc_caches[cache-&g=
t;id] =3D cache;</div><div><br></div><div><span class=3D"" style=3D"white-s=
pace:pre">		</span>clear_stat(cache);</div><div><br></div><div><span class=
=3D"" style=3D"white-space:pre">		</span>/*</div>
<div><span class=3D"" style=3D"white-space:pre">		</span> * /sys/module/dm_=
lc/caches/$id/$attribute</div><div><span class=3D"" style=3D"white-space:pr=
e">		</span> * =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /dev=
ice -&gt; /sys/block/$name</div>
<div><span class=3D"" style=3D"white-space:pre">		</span> */</div><div><br>=
</div><div><span class=3D"" style=3D"white-space:pre">		</span>int r;</div>=
<div><br></div><div><span class=3D"" style=3D"white-space:pre">		</span>cac=
he-&gt;update_interval =3D 1;</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>cache-&gt;commit_s=
uper_block_interval =3D 0;</div><div><span class=3D"" style=3D"white-space:=
pre">		</span>cache-&gt;flush_current_buffer_interval =3D 0;</div><div><spa=
n class=3D"" style=3D"white-space:pre">		</span>r =3D kobject_init_and_add(=
&amp;cache-&gt;kobj, &amp;cache_ktype,</div>
<div><span class=3D"" style=3D"white-space:pre">					</span> caches_kobj, &=
quot;%u&quot;, cache-&gt;id);</div><div><br></div><div><span class=3D"" sty=
le=3D"white-space:pre">		</span>struct kobject *dev_kobj =3D</div><div><spa=
n class=3D"" style=3D"white-space:pre">			</span>get_bdev_kobject(cache-&gt=
;device-&gt;bdev);</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>r =3D sysfs_create=
_link(&amp;cache-&gt;kobj, dev_kobj, &quot;device&quot;);</div><div><br></d=
iv><div><span class=3D"" style=3D"white-space:pre">		</span>return 0;</div>=
<div><span class=3D"" style=3D"white-space:pre">	</span>}</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>if (=
!strcasecmp(cmd, &quot;free_cache&quot;)) {</div><div><span class=3D"" styl=
e=3D"white-space:pre">		</span>cache_id id =3D cache_id_ptr;</div><div><spa=
n class=3D"" style=3D"white-space:pre">		</span>struct lc_cache *cache =3D =
lc_caches[id];</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">		</span>cac=
he-&gt;on_terminate =3D true;</div><div><br></div><div><span class=3D"" sty=
le=3D"white-space:pre">		</span>cancel_work_sync(&amp;cache-&gt;flush_work)=
;</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>destroy_workqueue(=
cache-&gt;flush_wq);</div><div><br></div><div><span class=3D"" style=3D"whi=
te-space:pre">		</span>cancel_work_sync(&amp;cache-&gt;barrier_deadline_wor=
k);</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">		</span>kfr=
ee(cache-&gt;migrate_buffer);</div><div><span class=3D"" style=3D"white-spa=
ce:pre">		</span>cancel_work_sync(&amp;cache-&gt;migrate_work);</div><div><=
span class=3D"" style=3D"white-space:pre">		</span>destroy_workqueue(cache-=
&gt;migrate_wq);</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">		</span>siz=
e_t i;</div><div><span class=3D"" style=3D"white-space:pre">		</span>struct=
 writebuffer *wb;</div><div><span class=3D"" style=3D"white-space:pre">		</=
span>for (i =3D 0; i &lt; NR_WB_POOL; i++) {</div>
<div><span class=3D"" style=3D"white-space:pre">			</span>wb =3D cache-&gt;=
wb_pool + i;</div><div><span class=3D"" style=3D"white-space:pre">			</span=
>kfree(wb-&gt;data);</div><div><span class=3D"" style=3D"white-space:pre">	=
	</span>}</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>kfree(cache-&gt;wb=
_pool);</div><div><br></div><div><span class=3D"" style=3D"white-space:pre"=
>		</span>kill_arr(cache-&gt;htable);</div><div><span class=3D"" style=3D"w=
hite-space:pre">		</span>kill_arr(cache-&gt;segment_header_array);</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">		</span>sys=
fs_remove_link(&amp;cache-&gt;kobj, &quot;device&quot;);</div><div><span cl=
ass=3D"" style=3D"white-space:pre">		</span>kobject_del(&amp;cache-&gt;kobj=
);</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>kobject_put(&amp;c=
ache-&gt;kobj);</div><div><br></div><div><span class=3D"" style=3D"white-sp=
ace:pre">		</span>dm_put_device(ti, cache-&gt;device);</div><div><span clas=
s=3D"" style=3D"white-space:pre">		</span>kfree(cache);</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">		</span>lc_=
caches[id] =3D NULL;</div><div><br></div><div><span class=3D"" style=3D"whi=
te-space:pre">		</span>return 0;</div><div><span class=3D"" style=3D"white-=
space:pre">	</span>}</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>retu=
rn -EINVAL;</div><div>}</div><div><br></div><div>static size_t calc_static_=
memory_consumption(struct lc_cache *cache)</div><div>{</div><div><span clas=
s=3D"" style=3D"white-space:pre">	</span>size_t seg =3D sizeof(struct segme=
nt_header) * cache-&gt;nr_segments;</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>size_t ht =3D sizeo=
f(struct ht_head) * cache-&gt;htsize;</div><div><br></div><div><span class=
=3D"" style=3D"white-space:pre">	</span>return seg + ht;</div><div>};</div>=
<div><br>
</div><div>static</div><div>#if LINUX_VERSION_CODE &gt;=3D KERNEL_VERSION(3=
, 8, 0)</div><div>void</div><div>#else</div><div>int</div><div>#endif</div>=
<div>lc_mgr_status(</div><div><span class=3D"" style=3D"white-space:pre">		=
</span>struct dm_target *ti, status_type_t type,</div>
<div>#if LINUX_VERSION_CODE &gt;=3D KERNEL_VERSION(3, 6, 0)</div><div><span=
 class=3D"" style=3D"white-space:pre">		</span>unsigned flags,</div><div>#e=
ndif</div><div><span class=3D"" style=3D"white-space:pre">		</span>char *re=
sult, unsigned int maxlen)</div>
<div>{</div><div><span class=3D"" style=3D"white-space:pre">	</span>unsigne=
d int sz =3D 0;</div><div><br></div><div><span class=3D"" style=3D"white-sp=
ace:pre">	</span>switch (type) {</div><div><span class=3D"" style=3D"white-=
space:pre">	</span>case STATUSTYPE_INFO:</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>DMEMIT(&quot;\n&qu=
ot;);</div><div><span class=3D"" style=3D"white-space:pre">		</span>DMEMIT(=
&quot;current cache_id_ptr: %u\n&quot;, cache_id_ptr);</div><div><br></div>=
<div>
<span class=3D"" style=3D"white-space:pre">		</span>if (cache_id_ptr =3D=3D=
 0) {</div><div><span class=3D"" style=3D"white-space:pre">			</span>DMEMIT=
(</div><div><span class=3D"" style=3D"white-space:pre">			</span>&quot;size=
of(struct metablock): %lu\n&quot;,</div>
<div><span class=3D"" style=3D"white-space:pre">			</span> =A0 =A0 =A0 size=
of(struct metablock));</div><div><span class=3D"" style=3D"white-space:pre"=
>			</span>DMEMIT(</div><div><span class=3D"" style=3D"white-space:pre">			=
</span>&quot;sizeof(struct metablock_device): %lu\n&quot;,</div>
<div><span class=3D"" style=3D"white-space:pre">			</span> =A0 =A0 =A0 size=
of(struct metablock_device));</div><div><span class=3D"" style=3D"white-spa=
ce:pre">			</span>DMEMIT(</div><div><span class=3D"" style=3D"white-space:p=
re">			</span>&quot;sizeof(struct segment_header): %lu\n&quot;,</div>
<div><span class=3D"" style=3D"white-space:pre">			</span> =A0 =A0 =A0 size=
of(struct segment_header));</div><div><span class=3D"" style=3D"white-space=
:pre">			</span>DMEMIT(</div><div><span class=3D"" style=3D"white-space:pre=
">			</span>&quot;sizeof(struct segment_header_device): %lu (&lt;=3D 4096)&=
quot;,</div>
<div><span class=3D"" style=3D"white-space:pre">			</span> =A0 =A0 =A0 size=
of(struct segment_header_device));</div><div><span class=3D"" style=3D"whit=
e-space:pre">			</span>break;</div><div><span class=3D"" style=3D"white-spa=
ce:pre">		</span>}</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">		</span>str=
uct lc_cache *cache =3D lc_caches[cache_id_ptr];</div><div><span class=3D""=
 style=3D"white-space:pre">		</span>if (!cache)</div><div>#if LINUX_VERSION=
_CODE &lt; KERNEL_VERSION(3, 8, 0)</div>
<div><span class=3D"" style=3D"white-space:pre">			</span>return -EINVAL;</=
div><div>#else</div><div><span class=3D"" style=3D"white-space:pre">			</sp=
an>return;</div><div>#endif</div><div><br></div><div><span class=3D"" style=
=3D"white-space:pre">		</span>DMEMIT(&quot;static RAM(approx.): %lu (byte)\=
n&quot;,</div>
<div><span class=3D"" style=3D"white-space:pre">		</span> =A0 =A0 =A0 calc_=
static_memory_consumption(cache));</div><div><span class=3D"" style=3D"whit=
e-space:pre">		</span>DMEMIT(&quot;allow_migrate: %d\n&quot;, cache-&gt;all=
ow_migrate);</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>DMEMIT(&quot;nr_se=
gments: %lu\n&quot;, cache-&gt;nr_segments);</div><div><span class=3D"" sty=
le=3D"white-space:pre">		</span>DMEMIT(&quot;last_migrated_segment_id: %lu\=
n&quot;,</div>
<div><span class=3D"" style=3D"white-space:pre">		</span> =A0 =A0 =A0 cache=
-&gt;last_migrated_segment_id);</div><div><span class=3D"" style=3D"white-s=
pace:pre">		</span>DMEMIT(&quot;last_flushed_segment_id: %lu\n&quot;,</div>=
<div><span class=3D"" style=3D"white-space:pre">		</span> =A0 =A0 =A0 cache=
-&gt;last_flushed_segment_id);</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>DMEMIT(&quot;curre=
nt segment id: %lu\n&quot;,</div><div><span class=3D"" style=3D"white-space=
:pre">		</span> =A0 =A0 =A0 cache-&gt;current_seg-&gt;global_id);</div><div=
><span class=3D"" style=3D"white-space:pre">		</span>DMEMIT(&quot;cursor: %=
u\n&quot;, cache-&gt;cursor);</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>DMEMIT(&quot;\n&qu=
ot;);</div><div><span class=3D"" style=3D"white-space:pre">		</span>DMEMIT(=
&quot;write? hit? on_buffer? fullsize?\n&quot;);</div><div><span class=3D""=
 style=3D"white-space:pre">		</span>int i;</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>for (i =3D 0; i &l=
t; STATLEN; i++) {</div><div><span class=3D"" style=3D"white-space:pre">			=
</span>if (i =3D=3D (STATLEN-1))</div><div><span class=3D"" style=3D"white-=
space:pre">				</span>break;</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">			</span>at=
omic64_t *v =3D &amp;cache-&gt;stat[i];</div><div><span class=3D"" style=3D=
"white-space:pre">			</span>DMEMIT(&quot;%d %d %d %d %lu&quot;,</div><div><=
span class=3D"" style=3D"white-space:pre">				</span>i &amp; (1 &lt;&lt; ST=
AT_WRITE) =A0 =A0 =A0? 1 : 0,</div>
<div><span class=3D"" style=3D"white-space:pre">				</span>i &amp; (1 &lt;&=
lt; STAT_HIT) =A0 =A0 =A0 =A0? 1 : 0,</div><div><span class=3D"" style=3D"w=
hite-space:pre">				</span>i &amp; (1 &lt;&lt; STAT_ON_BUFFER) =A0? 1 : 0,<=
/div><div><span class=3D"" style=3D"white-space:pre">				</span>i &amp; (1 =
&lt;&lt; STAT_FULLSIZE) =A0 ? 1 : 0,</div>
<div><span class=3D"" style=3D"white-space:pre">				</span>atomic64_read(v)=
);</div><div><span class=3D"" style=3D"white-space:pre">			</span>DMEMIT(&q=
uot;\n&quot;);</div><div><span class=3D"" style=3D"white-space:pre">		</spa=
n>}</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>break;</div><div><=
br></div><div><span class=3D"" style=3D"white-space:pre">	</span>case STATU=
STYPE_TABLE:</div><div><span class=3D"" style=3D"white-space:pre">		</span>=
break;</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>}</div><div><br></d=
iv><div>#if LINUX_VERSION_CODE &lt; KERNEL_VERSION(3, 8, 0)</div><div><span=
 class=3D"" style=3D"white-space:pre">	</span>return 0;</div><div>#endif</d=
iv><div>
}</div><div><br></div><div>static struct target_type lc_mgr_target =3D {</d=
iv><div><span class=3D"" style=3D"white-space:pre">	</span>.name =3D &quot;=
lc-mgr&quot;,</div><div><span class=3D"" style=3D"white-space:pre">	</span>=
.version =3D {1, 0, 0},</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>.module =3D THIS_MO=
DULE,</div><div><span class=3D"" style=3D"white-space:pre">	</span>.map =3D=
 lc_mgr_map,</div><div><span class=3D"" style=3D"white-space:pre">	</span>.=
ctr =3D lc_mgr_ctr,</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>.dtr =3D lc_mgr_dtr=
,</div><div><span class=3D"" style=3D"white-space:pre">	</span>.message =3D=
 lc_mgr_message,</div><div><span class=3D"" style=3D"white-space:pre">	</sp=
an>.status =3D lc_mgr_status,</div>
<div>};</div><div><br></div><div>static int __init lc_module_init(void)</di=
v><div>{</div><div><span class=3D"" style=3D"white-space:pre">	</span>int r=
;</div><div><br></div><div><span class=3D"" style=3D"white-space:pre">	</sp=
an>safe_io_wq =3D alloc_workqueue(&quot;safeiowq&quot;,</div>
<div><span class=3D"" style=3D"white-space:pre">				</span> =A0 =A0 WQ_NON_=
REENTRANT | WQ_MEM_RECLAIM, 0);</div><div><br></div><div><span class=3D"" s=
tyle=3D"white-space:pre">	</span>lc_io_client =3D dm_io_client_create();</d=
iv><div><br>
</div><div><span class=3D"" style=3D"white-space:pre">	</span>r =3D dm_regi=
ster_target(&amp;lc_target);</div><div><span class=3D"" style=3D"white-spac=
e:pre">	</span>if (r &lt; 0) {</div><div><span class=3D"" style=3D"white-sp=
ace:pre">		</span>DMERR(&quot;register lc failed %d&quot;, r);</div>
<div><span class=3D"" style=3D"white-space:pre">		</span>return r;</div><di=
v><span class=3D"" style=3D"white-space:pre">	</span>}</div><div><br></div>=
<div><span class=3D"" style=3D"white-space:pre">	</span>r =3D dm_register_t=
arget(&amp;lc_mgr_target);</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>if (r &lt; 0) {</di=
v><div><span class=3D"" style=3D"white-space:pre">		</span>DMERR(&quot;regi=
ster lc-mgr failed %d&quot;, r);</div><div><span class=3D"" style=3D"white-=
space:pre">		</span>return r;</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>}</div><div><br></d=
iv><div><span class=3D"" style=3D"white-space:pre">	</span>cache_id_ptr =3D=
 0;</div><div><br></div><div><span class=3D"" style=3D"white-space:pre">	</=
span>size_t i;</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>for (i =3D 0; i &lt=
; LC_NR_SLOTS; i++)</div><div><span class=3D"" style=3D"white-space:pre">		=
</span>lc_devices[i] =3D NULL;</div><div><br></div><div><span class=3D"" st=
yle=3D"white-space:pre">	</span>for (i =3D 0; i &lt; LC_NR_SLOTS; i++)</div=
>
<div><span class=3D"" style=3D"white-space:pre">		</span>lc_caches[i] =3D N=
ULL;</div><div><br></div><div><span class=3D"" style=3D"white-space:pre">	<=
/span>/*</div><div><span class=3D"" style=3D"white-space:pre">	</span> * /s=
ys/module/dm_lc/devices</div>
<div><span class=3D"" style=3D"white-space:pre">	</span> * =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0/caches</div><div><span class=3D"" style=3D"white-space:=
pre">	</span> */</div><div><br></div><div><span class=3D"" style=3D"white-s=
pace:pre">	</span>struct module *mod =3D THIS_MODULE;</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>struct kobject *lc_=
kobj =3D &amp;(mod-&gt;mkobj.kobj);</div><div><span class=3D"" style=3D"whi=
te-space:pre">	</span>devices_kobj =3D kobject_create_and_add(&quot;devices=
&quot;, lc_kobj);</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>caches_kobj =3D kob=
ject_create_and_add(&quot;caches&quot;, lc_kobj);</div><div><br></div><div>=
<span class=3D"" style=3D"white-space:pre">	</span>return 0;</div><div>}</d=
iv><div>
<br></div><div>static void __exit lc_module_exit(void)</div><div>{</div><di=
v><span class=3D"" style=3D"white-space:pre">	</span>destroy_workqueue(safe=
_io_wq);</div><div><span class=3D"" style=3D"white-space:pre">	</span>dm_io=
_client_destroy(lc_io_client);</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>kobj=
ect_put(devices_kobj);</div><div><span class=3D"" style=3D"white-space:pre"=
>	</span>kobject_put(caches_kobj);</div><div><br></div><div><span class=3D"=
" style=3D"white-space:pre">	</span>dm_unregister_target(&amp;lc_mgr_target=
);</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>dm_unregister_targe=
t(&amp;lc_target);</div><div>}</div><div><br></div><div>module_init(lc_modu=
le_init);</div><div>module_exit(lc_module_exit);</div><div><br></div><div>M=
ODULE_AUTHOR(&quot;Akira Hayakawa &lt;<a href=3D"mailto:ruby.wktk@gmail.com=
">ruby.wktk@gmail.com</a>&gt;&quot;);</div>
<div>MODULE_DESCRIPTION(DM_NAME &quot; lc target&quot;);</div><div>MODULE_L=
ICENSE(&quot;GPL&quot;);</div><div><br></div><div><br></div><div><br></div>=
<div>(dm-lc.txt)</div><div><br></div><div>dm-lc</div><div>=3D=3D=3D=3D=3D</=
div><div>
<br></div><div>dm-lc provides write-back log-structured caching.</div><div>=
It batches random writes into a big sequential write.</div><div><br></div><=
div>1. Setup</div><div>=3D=3D=3D=3D=3D=3D=3D=3D</div><div>dm-lc is composed=
 of two target_type instances named lc and lc-mgr.</div>
<div>lc is responsible for creating logical volumes and controlling ios and=
</div><div>lc-mgr is reponsible for managing</div><div>formatting/initializ=
ing/destructing cache devices on the other hand.</div><div>Operating dm-lc =
through these native interfaces are not recommended.</div>
<div><br></div><div>To easily get started with dm-lc, nice userland tools a=
re provided in</div><div><span class=3D"" style=3D"white-space:pre">	</span=
><a href=3D"https://github.com/akiradeveloper/dm-lc">https://github.com/aki=
radeveloper/dm-lc</a></div>
<div>where you are also accesible to portable dm-lc kernel code</div><div>t=
hat supports since 3.2 kernel until before dm-lc staged upstream, 3.x.</div=
><div>please git clone it.</div><div><br></div><div>To install the tools, m=
ove under Admin directory and run</div>
<div><span class=3D"" style=3D"white-space:pre">	</span>python setup.py ins=
tall</div><div>and now you have a lisence for dm-lc admin.</div><div><br></=
div><div>2. Example scripts</div><div>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D</div><div>Let&#39;s create a logical volume named myLV</=
div>
<div>backed by /dev/myVg/myBacking</div><div>and use /dev/myCache as a cach=
e device.</div><div><br></div><div>myLV -- (backing store) /dev/myVg/myBack=
ing</div><div>=A0 =A0 =A0-- (cache device) =A0/dev/myCache</div><div><br></=
div>
<div>Note that backing store is restricted to</div><div>a logical device th=
at is created by LVM</div><div>for technical reasons.</div><div><br></div><=
div>1. Format myCache</div><div>Format the medata blocks on a device.</div>
<div>Note that this erases all the existing data.</div><div><br></div><div>=
<span class=3D"" style=3D"white-space:pre">	</span>lc-format-cache /dev/myC=
ache</div><div><br></div><div>2. Create myLV</div><div>Create a logical vol=
ume just backed by a existing volume.</div>
<div>We give device id 5 to the volume in this example.</div><div><br></div=
><div>As of now, this operation create a logical volume</div><div>with diff=
erent name from the backing store.</div><div>But some users don&#39;t want =
to change the name</div>
<div>because the backing store is in use</div><div>and want to apply dm-lc =
on the fly.</div><div>This can be technically realizable</div><div>but I ha=
ven&#39;t implemented it at this time</div><div>because it is too tricky to=
 be portable.</div>
<div><br></div><div><span class=3D"" style=3D"white-space:pre">	</span>lc-c=
reate myLV 5 /dev/myVg/myBacking</div><div><br></div><div>3. Resume myCache=
</div><div>Resuming cache device builds in-memory structures</div><div>such=
 as a hashtable scanned from the metadata on the device.</div>
<div>We give cache id 3 to the device in this example.</div><div><br></div>=
<div>Note that you MUST create all the LVs as the destinations</div><div>of=
 the dirty caches on the cache device for technical reasons.</div><div>
Otherwise, it leads to kernel crash. Be careful.</div><div><br></div><div><=
span class=3D"" style=3D"white-space:pre">	</span>lc-resume 3 /dev/myCache<=
/div><div><br></div><div>4. Attach myCache to myLV</div><div>To start cachi=
ng writes to the myLV, you must attach myCache to myLV.</div>
<div>This can be done on the fly.</div><div><br></div><div><span class=3D""=
 style=3D"white-space:pre">	</span>lc-attach 5 3</div><div><br></div><div>5=
. Start userland daemon</div><div>dm-lc provides daemon program</div><div>t=
hat autonomously control the module behavior</div>
<div>such as write-back from myCache to myBacking</div><div>which dm-lc cal=
ls &quot;Migration&quot;.</div><div><br></div><div><span class=3D"" style=
=3D"white-space:pre">	</span>lc-daemon start</div><div><br></div><div>6. Te=
rminate myLV</div>
<div>Safely terminating myLV already attached to myCache</div><div>is easy =
to mistake and that&#39;s why dm-lc provides these admin tools.</div><div>m=
yLV can not detach from myCache</div><div>until all the dirty caches on myC=
ache</div>
<div>are migrated to myBacking</div><div><br></div><div><span class=3D"" st=
yle=3D"white-space:pre">	</span>lc-detach 5</div><div><span class=3D"" styl=
e=3D"white-space:pre">	</span>lc-remove 5</div><div><br></div><div>7. Termi=
nate myCache</div>
<div>After terminate all the LVs that is attached</div><div>to myCache. myC=
ache can be terminated.</div><div><br></div><div><span class=3D"" style=3D"=
white-space:pre">	</span>lc-daemon stop</div><div><span class=3D"" style=3D=
"white-space:pre">	</span>lc-free-cache 3</div>
<div><br></div><div>3. Sysfs</div><div>=3D=3D=3D=3D=3D=3D=3D=3D</div><div>d=
m-lc provides some sysfs interfaces to control the module behavior.</div><d=
iv>The sysfs tree is located under /sys/module/dm_lc.</div><div><br></div><=
div>/sys/module/dm_lc</div>
<div>|</div><div>|-- devices</div><div>| =A0 `-- 5</div><div>| =A0 =A0 =A0 =
|-- cache_id</div><div>| =A0 =A0 =A0 |-- dev</div><div>| =A0 =A0 =A0 |-- de=
vice -&gt; ../../../../devices/virtual/block/dm-0</div><div>| =A0 =A0 =A0 |=
-- migrate_threshold</div>
<div>| =A0 =A0 =A0 |-- nr_dirty_caches</div><div>|</div><div>|-- caches</di=
v><div>| =A0 `-- 3</div><div>| =A0 =A0 =A0 |-- allow_migrate</div><div>| =
=A0 =A0 =A0 |-- barrier_deadline_ms</div><div>| =A0 =A0 =A0 |-- commit_supe=
r_block</div><div>| =A0 =A0 =A0 |-- commit_super_block_interval</div>
<div>| =A0 =A0 =A0 |-- device -&gt; ../../../../devices/virtual/block/dm-1<=
/div><div>| =A0 =A0 =A0 |-- flush_current_buffer</div><div>| =A0 =A0 =A0 |-=
- flush_current_buffer_interval</div><div>| =A0 =A0 =A0 |-- force_migrate</=
div><div>| =A0 =A0 =A0 |-- last_flushed_segment_id</div>
<div>| =A0 =A0 =A0 |-- last_migrated_segment_id</div><div>| =A0 =A0 =A0 `--=
 update_interval</div><div><br></div><div>4. Technical Issues</div><div>=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D</div><div>There are =
not a few technical issues</div><div>that distinguishes dm-lc from other ca=
che softwares.</div>
<div><br></div><div>4.1 RAM buffer and immediate completion</div><div>dm-lc=
 allocated RAM buffers of 64MB in total by default.</div><div>All of the wr=
ites are first stored in one of these RAM buffers</div><div>and immediate c=
ompletion is notified to the upper layer</div>
<div>that is usually in few microseconds that is unimaginably fast.</div><d=
iv><br></div><div>4.2 Metadata durability</div><div>After RAM buffer gets f=
ull or some deadline comes</div><div>dm-lc creates segment log that gathers=
 RAM buffer and its metadata.</div>
<div>Metadata have information such as connection between</div><div>address=
 in cache device and the counterpart in backing store.</div><div>As the seg=
ment log finally is written to persistent cache device,</div><div>any data =
will not be lost after machine failure.</div>
<div><br></div><div>4.3 Asynchronous log flushing</div><div>dm-lc has a bac=
kground worker called flush daemon.</div><div>Flushing segment log starts f=
rom simply queueing the flush task.</div><div>Flush daemon in background as=
ynchronously checks if the queue has some tasks</div>
<div>and actually executes the tasks if exists.</div><div>The fact that the=
 upper layer doesn&#39;t block in queueing the task</div><div>maximizes the=
 write throughput</div><div>that is 259MB/s random writes with cache device=
 of 266MB/s sequential write</div>
<div>which is only 3% loss</div><div>and 1.5GB/s theoritically with a fast =
enough cache like PCI-e SSDs.</div><div><br></div><div>4.4 Asynchronous and=
 automated migration</div><div>Some time after a log segment is flushed to =
cache device</div>
<div>it will be migrated to backing store.</div><div>Migrate daemon is also=
 a background worker</div><div>that periodically check if log segments to m=
igrate exist.</div><div><br></div><div>Restlessly migrating highly loads ba=
cking store</div>
<div>so migration is better to execute when the backing store is in lazy ti=
me.</div><div>lc-daemon in userland surveils the load of backing store</div=
><div>and turns migration on and off according to the load.</div><div><br>
</div><div>4.5 Lazy handling of REQ_FUA and REQ_FLUSH bios</div><div>Some a=
pplications such as NFS, journal filesystems</div><div>and databases often =
submit SYNC write that</div><div>leads to bios flagged with REQ_FUA or REQ_=
FLUSH.</div>
<div>Handling these irregular bios immediately and thus synchronously</div>=
<div>desparately deteriorates the whole throughput.</div><div>To address th=
is issue, dm-lc handles these bios lazily or in deferred manner.</div><div>
Completion related to these bios will not be done until</div><div>they are =
written persistently to the cache device</div><div>so this storategy doesn&=
#39;t break the semantics.</div><div>In the worst case scenario, a bio with=
 some of these flags</div>
<div>is completed in deadline period that is described</div><div>in barrier=
_deadline_ms in sysfs.</div><div><br></div><div><br></div><div>Thanks for r=
eading,</div><div>Akira</div></div>

--001a11c24d16f9374104e18ea250--


--===============7201987044636837253==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7201987044636837253==--
