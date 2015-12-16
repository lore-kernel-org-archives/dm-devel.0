From: Baolin Wang <baolin.wang@linaro.org>
Subject: Re: [PATCH v2 0/2] Introduce the bulk IV mode for improving the
 crypto engine efficiency
Date: Wed, 16 Dec 2015 16:31:11 +0800
Message-ID: <CAMz4kuJ3W-oA9AsOQOT1BWS-cY8UUEgm1UzDKmsFY5QdNG0-oA@mail.gmail.com>
References: <cover.1450233399.git.baolin.wang@linaro.org>
	<56711C0F.8030105@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56711C0F.8030105@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <gmazyland@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Alasdair G Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, neilb@suse.com, dan.j.williams@intel.com, martin.petersen@oracle.com, sagig@mellanox.com, Kent Overstreet <kent.overstreet@gmail.com>, keith.busch@intel.com, tj@kernel.org, Mark Brown <broonie@kernel.org>, Arnd Bergmann <arnd@arndb.de>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On 16 December 2015 at 16:08, Milan Broz <gmazyland@gmail.com> wrote:
> On 12/16/2015 04:18 AM, Baolin Wang wrote:
>> From the dm-crypt performance report, we found it shows low efficiency
>> with crypto engine for some mode (like ecb or xts mode). Because in dm
>> crypt, it will map the IO data buffer with scatterlist, and send the
>> scatterlist of one bio to the encryption engine, if send more scatterlists
>> with bigger size at one time, that helps the engine palys best performance,
>> which means a high encryption speed.
>>
>> But now the dm-crypt only map one segment (always one sector) of one bio
>> with one scatterlist to the crypto engine at one time. which is more
>> time-consuming and ineffective for the crypto engine. Especially for some
>> modes which don't need different IV for each sector, we can map the whole
>> bio with multiple scatterlists to improve the engine performance.
>>
>> But this optimization is not support some ciphers and IV modes which should
>> do sector by sector and need different IV for each sector.
>>
>> Change since v1:
>>  - Introduce one different IV mode.
>>  - Change the conditions for bulk mode.
>
> I tried the patchset on 32bit Intel VM and kernel immediately OOPsed (just tried aes-ecb)...
>

I'm sorry for that. I'll check why it will crash though it can work
well on my beaglebone black board. Thanks.

> Crash log below.




-- 
Baolin.wang
Best Regards
