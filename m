From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [dm-devel] [PATCH] dm-writecache
Date: Thu, 8 Mar 2018 09:08:32 -0800
Message-ID: <CAPcyv4gBUt5NYK2Lx0dMZAnENeSgKm3KaUvY9kkqB+PNPyQu4w@mail.gmail.com>
References: <alpine.LRH.2.02.1803080824210.2819@file01.intranet.prod.int.rdu2.redhat.com>
 <20180308145153.GB23262@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20180308145153.GB23262-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Mike Snitzer <msnitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Alasdair G. Kergon" <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: dm-devel.ids

On Thu, Mar 8, 2018 at 6:51 AM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>> --- /dev/null 1970-01-01 00:00:00.000000000 +0000
>> +++ linux-2.6/drivers/md/dm-writecache.c      2018-03-08 14:23:31.059999000 +0100
>> @@ -0,0 +1,2417 @@
>> +#include <linux/device-mapper.h>
>
> missing copyright statement, or for those new-fashioned SPDX statement.
>
>> +#define WRITEBACK_FUA                        true
>
> no business having this around.
>
>> +#ifndef bio_set_dev
>> +#define      bio_set_dev(bio, dev)   ((bio)->bi_bdev = (dev))
>> +#endif
>> +#ifndef timer_setup
>> +#define timer_setup(t, c, f) setup_timer(t, c, (unsigned long)(t))
>> +#endif
>
> no business in mainline.
>
>> +/*
>> + * On X86, non-temporal stores are more efficient than cache flushing.
>> + * On ARM64, cache flushing is more efficient.
>> + */
>> +#if defined(CONFIG_X86_64)
>> +#define NT_STORE(dest, src)                          \
>> +do {                                                 \
>> +     typeof(src) val = (src);                        \
>> +     memcpy_flushcache(&(dest), &val, sizeof(src));  \
>> +} while (0)
>> +#define COMMIT_FLUSHED()     wmb()
>> +#else
>> +#define NT_STORE(dest, src)  WRITE_ONCE(dest, src)
>> +#define FLUSH_RANGE          dax_flush
>> +#define COMMIT_FLUSHED()     do { } while (0)
>> +#endif
>
> Please use proper APIs for this, this has no business in a driver.

I had the same feedback, and Mikulas sent this useful enhancement to
the memcpy_flushcache API:

    https://patchwork.kernel.org/patch/10217655/

...it's in my queue to either push through -tip or add it to the next
libnvdimm pull request for 4.17-rc1.
