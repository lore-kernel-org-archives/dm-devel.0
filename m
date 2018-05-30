From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] dm: add writecache target
Date: Wed, 30 May 2018 15:44:24 +0300
Message-ID: <20180530124422.uuxdkscr5lkkgcgx@kili.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: mpatocka@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hello Mikulas Patocka,

The patch 2105231db61b: "dm: add writecache target" from Mar 8, 2018,
leads to the following static checker warning:

	drivers/md/dm-writecache.c:1868 writecache_ctr()
	warn: 'wc->dm_io' is an error pointer or valid

drivers/md/dm-writecache.c
  1854  
  1855          wc = kzalloc(sizeof(struct dm_writecache), GFP_KERNEL);
  1856          if (!wc) {
  1857                  ti->error = "Cannot allocate writecache structure";
  1858                  r = -ENOMEM;
  1859                  goto bad;
  1860          }
  1861          ti->private = wc;
  1862          wc->ti = ti;
  1863  
  1864          mutex_init(&wc->lock);
  1865          writecache_poison_lists(wc);
  1866          init_swait_queue_head(&wc->freelist_wait);
  1867          timer_setup(&wc->autocommit_timer, writecache_autocommit_timer, 0);
  1868  
  1869          for (i = 0; i < 2; i++) {
  1870                  atomic_set(&wc->bio_in_progress[i], 0);
  1871                  init_swait_queue_head(&wc->bio_in_progress_wait[i]);
  1872          }
  1873  
  1874          wc->dm_io = dm_io_client_create();
  1875          if (!wc->dm_io) {
                     ^^^^^^^^^
dm_io_client_create() returns error pointers.

  1876                  r = -ENOMEM;
  1877                  ti->error = "Unable to allocate dm-io client";
  1878                  goto bad;
                        ^^^^^^^^
I always tell people that one err style error handling is always buggy.

  1879          }
  1880  
  1881          wc->writeback_wq = alloc_workqueue("writecache-writeabck", WQ_MEM_RECLAIM, 1);
  1882          if (!wc->writeback_wq) {
  1883                  r = -ENOMEM;
  1884                  ti->error = "Could not allocate writeback workqueue";
  1885                  goto bad;
  1886          }

regards,
dan carpenter
