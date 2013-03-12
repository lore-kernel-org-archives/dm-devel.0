From: majianpeng <majianpeng@gmail.com>
Subject: About function bio_detain in file dm-cache-target.c
Date: Tue, 12 Mar 2013 15:47:28 +0800
Message-ID: <513EDD90.6090305@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
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
To: alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi all,
    I think bio_detain(in dm-cache-target.c) may cause some bug.
>static int bio_detain(struct cache *cache, dm_oblock_t oblock,
>                      struct bio *bio, struct dm_bio_prison_cell *cell_prealloc,
>                      cell_free_fn free_fn, void *free_context,
>                      struct dm_bio_prison_cell **cell_result)
>{
>       int r;
>        struct dm_cell_key key;

>        build_key(oblock, &key);
>        r = dm_bio_detain(cache->prison, &key, bio, cell_prealloc, cell_result);
>       if (r)
>                free_fn(free_context, cell_prealloc);

>     return r;
>}
If the returned value of dm_bio_detain is not zero, it indicated cell existing.So it should defer bio.
But in dm_bio_detain-->bio_detain--->__bio->detain
>        cell = __search_bucket(prison->cells + hash, key);
>        if (cell) {
>               if (inmate)
>                        bio_list_add(&cell->bios, inmate);
>                *cell_result = cell;
>                return 1;
>        }  
If found the cell, it will add bio to ->bios of cell.

Maybe bio_detain(in dm-cache) is like:
    r=dm_get_cell();
    if (!r)
      dm_bio_detain


Thanks!
Jianpeng Ma
