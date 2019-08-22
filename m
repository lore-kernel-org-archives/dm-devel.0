From: Denis Efremov <efremov@ispras.ru>
Subject: Re: [PATCH] lib/memweight.c: optimize by inlining bitmap_weight()
Date: Thu, 22 Aug 2019 10:30:07 +0300
Message-ID: <ad15bc93-0283-2518-8185-7683614d9965@ispras.ru>
References: <20190821074200.2203-1-efremov@ispras.ru>
 <20190821182507.b0dea16f57360cf0ac40deb6@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190821182507.b0dea16f57360cf0ac40deb6@linux-foundation.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Jan Kara <jack@suse.cz>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org, Erdem Tumurov <erdemus@gmail.com>, Vladimir Shelekhov <vshel@iis.nsk.su>
List-Id: dm-devel.ids



On 22.08.2019 04:25, Andrew Morton wrote:
> On Wed, 21 Aug 2019 10:42:00 +0300 Denis Efremov <efremov@ispras.ru> wrote:
> 
>> This patch inlines bitmap_weight() call.
> 
> It is better to say the patch "open codes" the bitmap_weight() call.
> 
>> Thus, removing the BUG_ON,
> 
> Why is that OK to do?

BUG_ON was necessary here to check that bitmap_weight will return a correct value,
i.e. the computed weight will fit the int type: 
static __always_inline int bitmap_weight(const unsigned long *src, unsigned int nbits);

BUG_ON was added in the memweight v2
https://lore.kernel.org/lkml/20120523092113.GG10452@quack.suse.cz/
Jan Kara wrote:
>> +
>> +	for (longs = bytes / sizeof(long); longs > 0; ) {
>> +		size_t bits = min_t(size_t, INT_MAX & ~(BITS_PER_LONG - 1),
> +					longs * BITS_PER_LONG);
>  I find it highly unlikely that someone would have such a large bitmap
> (256 MB or more on 32-bit). Also the condition as you wrote it can just
> overflow so it won't have the desired effect. Just do
>	BUG_ON(longs >= ULONG_MAX / BITS_PER_LONG);
> and remove the loop completely. If someone comes with such a huge bitmap,
> the code can be modified easily (after really closely inspecting whether
> such a huge bitmap is really well justified).
>> +
>> +		w += bitmap_weight(bitmap.ptr, bits);
>> +		bytes -= bits / BITS_PER_BYTE;
>> +		bitmap.address += bits / BITS_PER_BYTE;
>> +		longs -= bits / BITS_PER_LONG;

Akinobu Mita wrote:
> The bits argument of bitmap_weight() is int type. So this should be
>
>        BUG_ON(longs >= INT_MAX / BITS_PER_LONG);

We don't need this check, since we removed the bitmap_weight call and
control the computation directly with size_t everywhere.

We could add BUG_ON(bytes >= SIZE_MAX / BITS_PER_BYTE);
at the very beginning of the function to check that the array is not
very big (>2000PiB), but it seems excessive.

> 
> I expect all the code size improvements are from doing this?

Yes, but I thought it's good to show that the total size is not
increasing because of the manual "inlining".

> 
>> and 'longs to bits -> bits to longs' conversion by directly calling
>> hweight_long().
>>
>> ./scripts/bloat-o-meter lib/memweight.o.old lib/memweight.o.new
>> add/remove: 0/0 grow/shrink: 0/1 up/down: 0/-10 (-10)
>> Function                                     old     new   delta
>> memweight                                    162     152     -10
>>
> 

Regards,
Denis
