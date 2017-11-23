From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [dm-devel] [PATCH 2/2] dm-writecache
Date: Thu, 23 Nov 2017 08:29:27 -0800
Message-ID: <CAA9_cmcBk8AMU=dc3A2fv2oS7Drk_a1iBQAxJRDrqLV0k=rLWg@mail.gmail.com>
References: <alpine.LRH.2.02.1711222135371.2330@file01.intranet.prod.int.rdu2.redhat.com>
 <20171123082946.GB17859@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20171123082946.GB17859-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
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
Cc: device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Snitzer <msnitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: dm-devel.ids

On Thu, Nov 23, 2017 at 12:29 AM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>> +/*
>> + * The clflushopt instruction is very slow on Broadwell, so we use non-temporal
>> + * stores instead.
>> + */
>> +#ifdef CONFIG_X86_64
>> +#define NT_STORE(dest, src)  asm ("movnti %1, %0" : "=m"(dest) : "r"(src))
>> +#define FLUSH_RANGE(dax, ptr, size)  do { } while (0)
>> +#define COMMIT_FLUSHED()     wmb()
>> +#else
>> +#define NT_STORE(dest, src)  ACCESS_ONCE(dest) = (src)
>> +#define FLUSH_RANGE          dax_flush
>> +#define COMMIT_FLUSHED()     do { } while (0)
>> +#endif
>
> Please go through the proper pmem APIs.

Yes, see _copy_from_iter_flushcache() and all its related apis.
Drivers shouldn't be doing anything different than what fs/dax.c is
using.
