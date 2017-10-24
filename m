From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [dm:for-next 8/9]
 drivers//md/dm-log-writes.c:279:17: note: in expansion of macro 'min'
Date: Tue, 24 Oct 2017 15:50:04 -0600
Message-ID: <20171024215003.GA6963@linux.intel.com>
References: <201710250527.qUFkoPkl%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <201710250527.qUFkoPkl%fengguang.wu@intel.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: kbuild test robot <fengguang.wu@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Mike Snitzer <snitzer@redhat.com>, kbuild-all@01.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Oct 25, 2017 at 05:44:34AM +0800, kbuild test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next
> head:   ae613bbb0144e84cb3c0ebfa9f4fd4d1507c2f0e
> commit: 6a697d036324c7fbe63fb49599027269006161e7 [8/9] dm log writes: add support for inline data buffers
> config: i386-randconfig-x014-201743 (attached as .config)
> compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
> reproduce:
>         git checkout 6a697d036324c7fbe63fb49599027269006161e7
>         # save the attached .config to linux build tree
>         make ARCH=i386 
> 
> All warnings (new ones prefixed by >>):
> 
>    In file included from include/linux/list.h:8:0,
>                     from include/linux/wait.h:6,
>                     from include/linux/wait_bit.h:7,
>                     from include/linux/fs.h:5,
>                     from include/linux/highmem.h:4,
>                     from include/linux/bio.h:21,
>                     from include/linux/device-mapper.h:11,
>                     from drivers//md/dm-log-writes.c:7:
>    drivers//md/dm-log-writes.c: In function 'write_inline_data':
>    include/linux/kernel.h:790:16: warning: comparison of distinct pointer types lacks a cast
>      (void) (&min1 == &min2);   \
>                    ^
>    include/linux/kernel.h:799:2: note: in expansion of macro '__min'
>      __min(typeof(x), typeof(y),   \
>      ^~~~~
> >> drivers//md/dm-log-writes.c:279:17: note: in expansion of macro 'min'
>        pg_datalen = min(datalen, PAGE_SIZE);
>                     ^~~
> 
> vim +/min +279 drivers//md/dm-log-writes.c
> 
>    248	
>    249	static int write_inline_data(struct log_writes_c *lc, void *entry,
>    250				     size_t entrylen, void *data, size_t datalen,
>    251				     sector_t sector)
>    252	{
>    253		int num_pages, bio_pages, pg_datalen, pg_sectorlen, i;
>    254		struct page *page;
>    255		struct bio *bio;
>    256		size_t ret;
>    257		void *ptr;
>    258	
>    259		while (datalen) {
>    260			num_pages = ALIGN(datalen, PAGE_SIZE) >> PAGE_SHIFT;
>    261			bio_pages = min(num_pages, BIO_MAX_PAGES);
>    262	
>    263			atomic_inc(&lc->io_blocks);
>    264	
>    265			bio = bio_alloc(GFP_KERNEL, bio_pages);
>    266			if (!bio) {
>    267				DMERR("Couldn't alloc inline data bio");
>    268				goto error;
>    269			}
>    270	
>    271			bio->bi_iter.bi_size = 0;
>    272			bio->bi_iter.bi_sector = sector;
>    273			bio_set_dev(bio, lc->logdev->bdev);
>    274			bio->bi_end_io = log_end_io;
>    275			bio->bi_private = lc;
>    276			bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
>    277	
>    278			for (i = 0; i < bio_pages; i++) {
>  > 279				pg_datalen = min(datalen, PAGE_SIZE);

Thanks, 0-day, for the report.

So I think this just needs to be 

					pg_datalen = min((int)datalen, PAGE_SIZE);

since the resulting pg_datalen is also an int.

Mike can you fix up, or would you like an updated patch (or follow-on patch)
from me?

- Ross
