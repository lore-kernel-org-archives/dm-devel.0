From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [PATCH] dm-crypt: limit the number of allocated pages
Date: Tue, 15 Aug 2017 04:22:20 +0800
Message-ID: <CAGnHSEm2Jz35Em6h-a8ofXr9ApgBKJq5mOCG9ZtN4+FuRxj8Aw@mail.gmail.com>
References: <alpine.LRH.2.02.1708132240130.18210@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1708132240130.18210@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Ondrej Kozina <okozina@redhat.com>, dm-devel@redhat.com, hch@lst.de, Mike Snitzer <msnitzer@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Just tested the patch with kernel 4.12.6. Well it sort of worked. No
more OOM or kernel panic. Memory takeup is around ~250M on a machine
with 8G RAM. However I keep getting this:

Aug 15 04:04:10 archlinux kernel: INFO: task blkdiscard:538 blocked
for more than 120 seconds.
Aug 15 04:04:10 archlinux kernel:       Tainted: P         C O
4.12.6-1-ARCH #1
Aug 15 04:04:10 archlinux kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug 15 04:04:10 archlinux kernel: blkdiscard      D    0   538    537 0x00000000
Aug 15 04:04:10 archlinux kernel: Call Trace:
Aug 15 04:04:10 archlinux kernel:  __schedule+0x236/0x870
Aug 15 04:04:10 archlinux kernel:  schedule+0x3d/0x90
Aug 15 04:04:10 archlinux kernel:  schedule_timeout+0x21f/0x330
Aug 15 04:04:10 archlinux kernel:  io_schedule_timeout+0x1e/0x50
Aug 15 04:04:10 archlinux kernel:  ? io_schedule_timeout+0x1e/0x50
Aug 15 04:04:10 archlinux kernel:  wait_for_completion_io+0xa5/0x120
Aug 15 04:04:10 archlinux kernel:  ? wake_up_q+0x80/0x80
Aug 15 04:04:10 archlinux kernel:  submit_bio_wait+0x68/0x90
Aug 15 04:04:10 archlinux kernel:  blkdev_issue_zeroout+0x80/0xc0
Aug 15 04:04:10 archlinux kernel:  blkdev_ioctl+0x707/0x940
Aug 15 04:04:10 archlinux kernel:  ? blkdev_ioctl+0x707/0x940
Aug 15 04:04:10 archlinux kernel:  block_ioctl+0x3d/0x50
Aug 15 04:04:10 archlinux kernel:  do_vfs_ioctl+0xa5/0x600
Aug 15 04:04:10 archlinux kernel:  ? SYSC_newfstat+0x44/0x70
Aug 15 04:04:10 archlinux kernel:  ? getrawmonotonic64+0x36/0xc0
Aug 15 04:04:10 archlinux kernel:  SyS_ioctl+0x79/0x90
Aug 15 04:04:10 archlinux kernel:  entry_SYSCALL_64_fastpath+0x1a/0xa5
Aug 15 04:04:10 archlinux kernel: RIP: 0033:0x7f2b463378b7
Aug 15 04:04:10 archlinux kernel: RSP: 002b:00007fffb2dad8b8 EFLAGS:
00000246 ORIG_RAX: 0000000000000010
Aug 15 04:04:10 archlinux kernel: RAX: ffffffffffffffda RBX:
000000568a3922c8 RCX: 00007f2b463378b7
Aug 15 04:04:10 archlinux kernel: RDX: 00007fffb2dad910 RSI:
000000000000127f RDI: 0000000000000003
Aug 15 04:04:10 archlinux kernel: RBP: 0000000000000000 R08:
0000000000000200 R09: 0000000000000000
Aug 15 04:04:10 archlinux kernel: R10: 00007fffb2dad870 R11:
0000000000000246 R12: 0000000000000000
Aug 15 04:04:10 archlinux kernel: R13: 0000000000000003 R14:
00007fffb2dadae8 R15: 0000000000000000

which I do not get if I do `blkdiscard -z` on the underlying device
(which does not support SCSI WRITE SAME) instead of the dm-crypt
container.

In the first trial I got some more lower-level errors. blkdiscard
could not exit after the job was seemingly finished (no more write
according to iostat). The container could not be closed either so I
had to just disconnect the drive. I could not reproduce it in second
trial though, so I am not sure if it was just some coincidental
hardware hiccup. My systemd journal happened to be broken as well so
the log of that trial was lost.

I also have doubt in the approach. Can't we split the bio chain as per
how it was chained and allocate memory bio per bio, and if it's not
enough, also limit the memory allocation with a maximum number
(arbitrary or not) of bios?

On 14 August 2017 at 10:45, Mikulas Patocka <mpatocka@redhat.com> wrote:
> dm-crypt consumes excessive amount memory when the user attempts to zero
> a dm-crypt device with "blkdiscard -z". The command "blkdiscard -z" calls
> the BLKZEROOUT ioctl, it goes to the function __blkdev_issue_zeroout,
> __blkdev_issue_zeroout sends large amount of write bios that contain the
> zero page as their payload.
>
> For each incoming page, dm-crypt allocates another page that holds the
> encrypted data, so when processing "blkdiscard -z", dm-crypt tries to
> allocate the amount of memory that is equal to the size of the device.
> This can trigger OOM killer or cause system crash.
>
> This patch fixes the bug by limiting the amount of memory that dm-crypt
> allocates to 2% of total system memory.
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org
>
> ---
>  drivers/md/dm-crypt.c |   60 +++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 59 insertions(+), 1 deletion(-)
>
> Index: linux-2.6/drivers/md/dm-crypt.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-crypt.c
> +++ linux-2.6/drivers/md/dm-crypt.c
> @@ -148,6 +148,8 @@ struct crypt_config {
>         mempool_t *tag_pool;
>         unsigned tag_pool_max_sectors;
>
> +       struct percpu_counter n_allocated_pages;
> +
>         struct bio_set *bs;
>         struct mutex bio_alloc_lock;
>
> @@ -219,6 +221,12 @@ struct crypt_config {
>  #define MAX_TAG_SIZE   480
>  #define POOL_ENTRY_SIZE        512
>
> +static DEFINE_SPINLOCK(dm_crypt_clients_lock);
> +static unsigned dm_crypt_clients_n = 0;
> +static volatile unsigned long dm_crypt_pages_per_client;
> +#define DM_CRYPT_MEMORY_PERCENT                        2
> +#define DM_CRYPT_MIN_PAGES_PER_CLIENT          (BIO_MAX_PAGES * 16)
> +
>  static void clone_init(struct dm_crypt_io *, struct bio *);
>  static void kcryptd_queue_crypt(struct dm_crypt_io *io);
>  static struct scatterlist *crypt_get_sg_data(struct crypt_config *cc,
> @@ -2158,6 +2166,37 @@ static int crypt_wipe_key(struct crypt_c
>         return r;
>  }
>
> +static void crypt_calculate_pages_per_client(void)
> +{
> +       unsigned long pages = (totalram_pages - totalhigh_pages) * DM_CRYPT_MEMORY_PERCENT / 100;
> +       if (!dm_crypt_clients_n)
> +               return;
> +       pages /= dm_crypt_clients_n;
> +       if (pages < DM_CRYPT_MIN_PAGES_PER_CLIENT)
> +               pages = DM_CRYPT_MIN_PAGES_PER_CLIENT;
> +       dm_crypt_pages_per_client = pages;
> +}
> +
> +static void *crypt_page_alloc(gfp_t gfp_mask, void *pool_data)
> +{
> +       struct crypt_config *cc = pool_data;
> +       struct page *page;
> +       if (unlikely(percpu_counter_compare(&cc->n_allocated_pages, dm_crypt_pages_per_client) >= 0) &&
> +           likely(gfp_mask & __GFP_NORETRY))
> +               return NULL;
> +       page = alloc_page(gfp_mask);
> +       if (likely(page != NULL))
> +               percpu_counter_add(&cc->n_allocated_pages, 1);
> +       return page;
> +}
> +
> +static void crypt_page_free(void *page, void *pool_data)
> +{
> +       struct crypt_config *cc = pool_data;
> +       __free_page(page);
> +       percpu_counter_sub(&cc->n_allocated_pages, 1);
> +}
> +
>  static void crypt_dtr(struct dm_target *ti)
>  {
>         struct crypt_config *cc = ti->private;
> @@ -2184,6 +2223,10 @@ static void crypt_dtr(struct dm_target *
>         mempool_destroy(cc->req_pool);
>         mempool_destroy(cc->tag_pool);
>
> +       if (cc->page_pool)
> +               WARN_ON(percpu_counter_sum(&cc->n_allocated_pages) != 0);
> +       percpu_counter_destroy(&cc->n_allocated_pages);
> +
>         if (cc->iv_gen_ops && cc->iv_gen_ops->dtr)
>                 cc->iv_gen_ops->dtr(cc);
>
> @@ -2198,6 +2241,12 @@ static void crypt_dtr(struct dm_target *
>
>         /* Must zero key material before freeing */
>         kzfree(cc);
> +
> +       spin_lock(&dm_crypt_clients_lock);
> +       WARN_ON(!dm_crypt_clients_n);
> +       dm_crypt_clients_n--;
> +       crypt_calculate_pages_per_client();
> +       spin_unlock(&dm_crypt_clients_lock);
>  }
>
>  static int crypt_ctr_ivmode(struct dm_target *ti, const char *ivmode)
> @@ -2636,6 +2685,15 @@ static int crypt_ctr(struct dm_target *t
>
>         ti->private = cc;
>
> +       spin_lock(&dm_crypt_clients_lock);
> +       dm_crypt_clients_n++;
> +       crypt_calculate_pages_per_client();
> +       spin_unlock(&dm_crypt_clients_lock);
> +
> +       ret = percpu_counter_init(&cc->n_allocated_pages, 0, GFP_KERNEL);
> +       if (ret < 0)
> +               goto bad;
> +
>         /* Optional parameters need to be read before cipher constructor */
>         if (argc > 5) {
>                 ret = crypt_ctr_optional(ti, argc - 5, &argv[5]);
> @@ -2690,7 +2748,7 @@ static int crypt_ctr(struct dm_target *t
>                 ALIGN(sizeof(struct dm_crypt_io) + cc->dmreq_start + additional_req_size,
>                       ARCH_KMALLOC_MINALIGN);
>
> -       cc->page_pool = mempool_create_page_pool(BIO_MAX_PAGES, 0);
> +       cc->page_pool = mempool_create(BIO_MAX_PAGES, crypt_page_alloc, crypt_page_free, cc);
>         if (!cc->page_pool) {
>                 ti->error = "Cannot allocate page mempool";
>                 goto bad;
