From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] dm crypt: add cryptographic data integrity
 protection (authenticated encryption)
Date: Mon, 13 Mar 2017 17:19:09 +0300
Message-ID: <20170313141909.GA25761@mwanda>
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
To: gmazyland@gmail.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hello Milan Broz,

This is a semi-automatic email about new static checker warnings.

The patch 858516b7881e: "dm crypt: add cryptographic data integrity
protection (authenticated encryption)" from Jan 4, 2017, leads to the
following Smatch complaint:

drivers/md/dm-crypt.c:1390 crypt_alloc_buffer()
	 error: we previously assumed 'clone' could be null (see line 1362)

drivers/md/dm-crypt.c
  1361		clone = bio_alloc_bioset(GFP_NOIO, nr_iovecs, cc->bs);
  1362		if (!clone)
                    ^^^^^^
We can be NULL on this path.

  1363			goto return_clone;
  1364	
  1365		clone_init(io, clone);
  1366	
  1367		remaining_size = size;
  1368	
  1369		for (i = 0; i < nr_iovecs; i++) {
  1370			page = mempool_alloc(cc->page_pool, gfp_mask);
  1371			if (!page) {
  1372				crypt_free_buffer_pages(cc, clone);
  1373				bio_put(clone);
  1374				gfp_mask |= __GFP_DIRECT_RECLAIM;
  1375				goto retry;
  1376			}
  1377	
  1378			len = (remaining_size > PAGE_SIZE) ? PAGE_SIZE : remaining_size;
  1379	
  1380			bio_add_page(clone, page, len, 0);
  1381	
  1382			remaining_size -= len;
  1383		}
  1384	
  1385	return_clone:
  1386		if (unlikely(gfp_mask & __GFP_DIRECT_RECLAIM))
  1387			mutex_unlock(&cc->bio_alloc_lock);
  1388	
  1389		/* Allocate space for integrity tags */
  1390		if (dm_crypt_integrity_io_alloc(io, clone)) {
                                                    ^^^^^
Oops inside new function call.

  1391			crypt_free_buffer_pages(cc, clone);
  1392			bio_put(clone);

regards,
dan carpenter
