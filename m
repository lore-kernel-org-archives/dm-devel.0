From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] dm: writecache: Use 2-factor allocator arguments
Date: Mon, 18 Jun 2018 15:10:48 -0700
Message-ID: <CAGXu5jLYQtqWjsKcUeDyBkaaPSc_m9-56yQU3B=ovDc_AjS6dQ@mail.gmail.com>
References: <20180618175033.GA2627@beast> <alpine.LRH.2.02.1806181708060.15433@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1806181708060.15433@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, dm-devel@redhat.com, Dan Williams <dan.j.williams@intel.com>, Mike Snitzer <msnitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Jun 18, 2018 at 2:12 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
>
>
> On Mon, 18 Jun 2018, Kees Cook wrote:
>
>> This adjusts the allocator calls to use the 2-factor argument style, as
>> already done treewide for better defense against allocator overflows.
>> Additionally adjusts style nit to avoid assignments in test expressions.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>  drivers/md/dm-writecache.c | 16 ++++++++++------
>>  1 file changed, 10 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
>> index 5961c7794ef3..7773f4c75701 100644
>> --- a/drivers/md/dm-writecache.c
>> +++ b/drivers/md/dm-writecache.c
>> @@ -259,7 +259,7 @@ static int persistent_memory_claim(struct dm_writecache *wc)
>>       if (da != p) {
>>               long i;
>>               wc->memory_map = NULL;
>> -             pages = kvmalloc(p * sizeof(struct page *), GFP_KERNEL);
>> +             pages = kvmalloc_array(p, sizeof(struct page *), GFP_KERNEL);
>>               if (!pages) {
>>                       r = -ENOMEM;
>>                       goto err2;
>> @@ -859,7 +859,8 @@ static int writecache_alloc_entries(struct dm_writecache *wc)
>>
>>       if (wc->entries)
>>               return 0;
>> -     wc->entries = vmalloc(sizeof(struct wc_entry) * wc->n_blocks);
>> +     wc->entries = vmalloc(array_size(sizeof(struct wc_entry),
>> +                                      wc->n_blocks));
>>       if (!wc->entries)
>>               return -ENOMEM;
>>       for (b = 0; b < wc->n_blocks; b++) {
>> @@ -1480,10 +1481,13 @@ static void __writecache_writeback_pmem(struct dm_writecache *wc, struct writeba
>>               bio_set_dev(&wb->bio, wc->dev->bdev);
>>               wb->bio.bi_iter.bi_sector = read_original_sector(wc, e);
>>               wb->page_offset = PAGE_SIZE;
>> -             if (max_pages <= WB_LIST_INLINE ||
>> -                 unlikely(!(wb->wc_list = kmalloc(max_pages * sizeof(struct wc_entry *),
>> -                                                  GFP_NOIO | __GFP_NORETRY |
>> -                                                  __GFP_NOMEMALLOC | __GFP_NOWARN)))) {
>> +             if (max_pages > WB_LIST_INLINE)
>> +                     wb->wc_list = kmalloc_array(max_pages,
>> +                                                 sizeof(struct wc_entry *),
>> +                                                 GFP_NOIO | __GFP_NORETRY |
>> +                                                 __GFP_NOMEMALLOC |
>> +                                                 __GFP_NOWARN);
>> +             if (max_pages <= WB_LIST_INLINE || !wb->wc_list) {
>
> The rest of patch is OK - but you shouldn't duplicate the comparison
> against WB_LIST_INLINE.

I couldn't find a better way to avoid an assignment in a test... open
to suggestions! :)

-Kees

-- 
Kees Cook
Pixel Security
