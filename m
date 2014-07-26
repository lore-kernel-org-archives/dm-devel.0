From: Anssi Hannula <anssi.hannula@iki.fi>
Subject: dm-cache race on nr_dirty in set_dirty/clear_dirty?
Date: Sat, 26 Jul 2014 07:07:53 +0300
Message-ID: <53D32999.6080206@iki.fi>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi,

I'm seeing the following "dmsetup status" on one volume:
> 0 5368709120 cache 8 3926/32768 128 335265/1978880 5589425 8052258 2254781 3910141 0 335265 4294967293 1 writeback 2 migration_threshold 2048 mq 10 random_threshold 4 sequential_threshold 512 discard_promote_adjustment 1 read_promote_adjustment 4 write_promote_adjustment 8

Note the clearly wrong 4294967293 in the nr_dirty field.

Looking at the code, I see nr_dirty is set in the following functions in
dm-cache-target.c:

> static void set_dirty(struct cache *cache, dm_oblock_t oblock, dm_cblock_t cblock)
> {
>         if (!test_and_set_bit(from_cblock(cblock), cache->dirty_bitset)) {
>                 cache->nr_dirty = to_cblock(from_cblock(cache->nr_dirty) + 1);
>                 policy_set_dirty(cache->policy, oblock);
>         }
> }
> 
> static void clear_dirty(struct cache *cache, dm_oblock_t oblock, dm_cblock_t cblock)
> {
>         if (test_and_clear_bit(from_cblock(cblock), cache->dirty_bitset)) {
>                 policy_clear_dirty(cache->policy, oblock);
>                 cache->nr_dirty = to_cblock(from_cblock(cache->nr_dirty) - 1);
>                 if (!from_cblock(cache->nr_dirty))
>                         dm_table_event(cache->ti->table);
>         }
> }

That looks like a race to me? As nothing is protecting cache->nr_dirty
from multiple access (unlike cache->dirty_bitset).

Unless I'm missing something, as I'm not familiar with this code...

-- 
Anssi Hannula
