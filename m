From: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Subject: Re: [BUG] dm-writeboost: too big nr_rambuf_pool causes
 massive memory pressure or panic.
Date: Sat, 19 Jul 2014 11:13:13 +0900
Message-ID: <CAMym5wu+DUrxqOaenW1h4WgcJOGzMK1H1amMbYS7783qugQFNg@mail.gmail.com>
References: <87egxr0wul.wl%satoru.takeuchi@gmail.com>
	<20140718100130.5bc9f9cc4e9ce674ab014423@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140718100130.5bc9f9cc4e9ce674ab014423@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Akira Hayakawa <ruby.wktk@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>, ejt@redhat.com
List-Id: dm-devel.ids

Hi Akira,

2014-07-18 10:01 GMT+09:00 Akira Hayakawa <ruby.wktk@gmail.com>:
> Hi, Satoru,
>
> I totally agree with removing the BUG() at (2).
>
> However, I don't agree with setting the upper limit of nr_rambuf_pool.
> You are saying that any memory allocation failure on initialization should be avoided
> but that sounds going too far. Removing that possibility from all kernel codes is impossible in practice.
> Carefully terminating the initialization on allocation failure is sufficient.

My opinion is not avoiding any memory allocation failure, but avoiding
easy-to-remove case.
This kind of ENOMEM can easily be avoided if user can't set too big
value to this argument.
This is completely the different from ENOMEM happened in the
actually-memory-exhausting
system.

In addition, even if ENOMEM doesn't happen, users can consume massive amount of
"kernel" memory. It results in the unstable system behavior, for
example users can't create
processes, almost all anon pages and page caches are evicted and can't
get it again
since kernel memory can't be reclaimable. In worst case, it can be a
security hole.
So, I consider it's apparently a bug.

>
> For your guidance,
> the amount of memory we need depends on how fast the SSD is.
> In practice, few MB for RAM buffer is sufficient for
> commodity SSD as caching device. However, it could be higher with much more faster SSD
> or one may want to set it up for higher value in experiments.

I don't think so. If sufficient upper limit can't easily be estimated,
setting almost all of
memory as write cache is inappropriate since it get whole system useless as I
mentioned above. Even if  you can't determine the appropriate upper
limit at all,
I strongly recommend you to set the upper limit lower than reclaimable
memory anyway.
For example "(free memory)/<n>(*1)."

Even If there is no theoretical reason to set such upper limit, it's
OK. It's better than
no upper limit case. It can avoid inappropriate ENOMEM and kernel memory
exhausting anyway.

*1) <n> is integer, for example 2, 3, 4.

Thanks,
Satoru

>
> - Akira
>
> On Sat, 12 Jul 2014 18:06:58 +0900
> Satoru Takeuchi <satoru.takeuchi@gmail.com> wrote:
>
>> Hi,
>>
>> Since the upper limit of nr_rambuf_pool argument, user can set too big value
>> to this argument.
>>
>> drivers/md/dm-writeboost-target.c:
>> ===============================================================================
>> static int consume_optional_argv(struct wb_device *wb, struct dm_arg_set *as)
>> {
>>         int r = 0;
>>         struct dm_target *ti = wb->ti;
>>
>>         static struct dm_arg _args[] = {
>>                 {0, 4, "Invalid optional argc"},
>>                 {4, 10, "Invalid segment_size_order"},
>>                 {1, UINT_MAX, "Invalid nr_rambuf_pool"},
>>         };
>> ===============================================================================
>>
>> It can cause the massive memory pressure to kernel by user's mistake
>> and results in
>>
>>  - ENOMEM at the (1) or somewhere, and
>>  - panic at (2).
>>
>> drivers/md/dm-writeboost-metadata.c:
>> ===============================================================================
>> ...
>> static int init_rambuf_pool(struct wb_device *wb)
>> {
>>         int r = 0;
>>         size_t i;
>>
>>         wb->rambuf_pool = kmalloc(sizeof(struct rambuffer) * wb->nr_rambuf_pool,
>>                                   GFP_KERNEL);
>>         if (!wb->rambuf_pool)
>>                 return -ENOMEM; # ................. (1)
>>
>>         wb->rambuf_cachep = kmem_cache_create("dmwb_rambuf",
>>                         1 << (wb->segment_size_order + SECTOR_SHIFT),
>>                         1 << (wb->segment_size_order + SECTOR_SHIFT),
>>                         SLAB_RED_ZONE, NULL);
>>         if (!wb->rambuf_cachep) {
>>                 r = -ENOMEM;
>>                 goto bad_cachep;
>>         }
>>
>>         for (i = 0; i < wb->nr_rambuf_pool; i++) {
>>                 size_t j;
>>                 struct rambuffer *rambuf = wb->rambuf_pool + i;
>>
>>                 rambuf->data = kmem_cache_alloc(wb->rambuf_cachep, GFP_KERNEL);
>>                 if (!rambuf->data) {
>>                         WBERR("Failed to allocate rambuf->data");
>>                         for (j = 0; j < i; j++) {
>>                                 rambuf = wb->rambuf_pool + j;
>>                                 kmem_cache_free(wb->rambuf_cachep, rambuf->data);
>>                         }
>>                         r = -ENOMEM;
>>                         goto bad_alloc_data;
>>                 }
>>                 check_buffer_alignment(rambuf->data);
>>         }
>>
>>         return r;
>>
>> bad_alloc_data:
>>         kmem_cache_destroy(wb->rambuf_cachep);
>> bad_cachep:
>>         kfree(wb->rambuf_pool);
>>         BUG();                         # ........(2)
>>         return r;
>> }
>> ...
>> ===============================================================================
>>
>> Please decide the appropriate upper limit of nr_rambuf_pool (unfortunately
>> I don't know about it), and remove BUG() at (2) if it's unnecessary.
>>
>> Thanks,
>> Satoru
>>
>> --
>> dm-devel mailing list
>> dm-devel@redhat.com
>> https://www.redhat.com/mailman/listinfo/dm-devel
