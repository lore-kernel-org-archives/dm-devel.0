From: Baolin Wang <baolin.wang@linaro.org>
Subject: Re: [dm-devel] [PATCH 0/2] Introduce the request handling for dm-crypt
Date: Thu, 3 Dec 2015 19:27:15 +0800
Message-ID: <CAMz4kuJR1JUm9w+W6=WJk72cWzwVq53qTPcWBzLABhQdMQ4png@mail.gmail.com>
References: <cover.1447233227.git.baolin.wang@linaro.org>
	<20151111181813.GD12236@redhat.com>
	<CAMz4kuKNAkFG4-f6TU1HRxgkAn+YX-D_tTQAWio-A_np3brr+A@mail.gmail.com>
	<20151112100422.GM12392@sirena.org.uk>
	<5644AFA2.6040201@kernel.dk>
	<20151113115144.GR12392@sirena.org.uk>
	<CAMz4kuLTuY5CpTfW4Gijesy1Pp9PxbWj076XeoV24Hj3EydifQ@mail.gmail.com>
	<20151202195657.GB11127@agk-dp.fab.redhat.com>
	<CAMz4kuL3qE-jE14F6ovAMRv6D-UFCdtiyUyi4ZDo+Lkr7_nA0Q@mail.gmail.com>
	<CAMz4ku+5HpOJfqTd0C0i0_SMODFZw38dKqwK15Db4U37VNDVeg@mail.gmail.com>
	<5660225E.30808@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5660225E.30808@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: Mark Brown <broonie@kernel.org>, Jens Axboe <axboe@kernel.dk>, keith.busch@intel.com, Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>, Mike Snitzer <snitzer@redhat.com>, neilb@suse.com, LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org, dm-devel@redhat.com, "Garg, Dinesh" <dineshg@quicinc.com>, tj@kernel.org, bart.vanassche@sandisk.com, jmoyer@redhat.com, Alasdair G Kergon <agk@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On 3 December 2015 at 19:07, Zdenek Kabelac <zkabelac@redhat.com> wrote:
> Dne 3.12.2015 v 11:36 Baolin Wang napsal(a):
>
>> On 3 December 2015 at 10:56, Baolin Wang <baolin.wang@linaro.org> wrote:
>>>
>>> On 3 December 2015 at 03:56, Alasdair G Kergon <agk@redhat.com> wrote:
>>>>
>>>> On Wed, Dec 02, 2015 at 08:46:54PM +0800, Baolin Wang wrote:
>>>>>
>>>>> These are the benchmarks for request based dm-crypt. Please check it.
>>>>
>>>>
>>>> Now please put request-based dm-crypt completely to one side and focus
>>>> just on the existing bio-based code.  Why is it slower and what can be
>>>> adjusted to improve this?
>>>>
>>>
>>> OK. I think I find something need to be point out.
>>> 1. From the IO block size test in the performance report, for the
>>> request based, we can find it can not get the corresponding
>>> performance if we just expand the IO size. Because In dm crypt, it
>>> will map the data buffer of one request with scatterlists, and send
>>> all scatterlists of one request to the encryption engine to encrypt or
>>> decrypt.  I found if the scatterlist list number is small and each
>>> scatterlist length is bigger, it will improve the encryption speed,
>>> that helps the engine palys best performance. But a big IO size does
>>> not mean bigger scatterlists (maybe many scatterlists with small
>>> length), that's why we can not get the corresponding performance if we
>>> just expand the IO size I think.
>>>
>>> 2. Why bio based is slower?
>>> If you understand 1, you can obviously understand the crypto engine
>>> likes bigger scatterlists to improve the performance. But for bio
>>> based, it only send one scatterlist (the scatterlist's length is
>>> always '1 << SECTOR_SHIFT' = 512) to the crypto engine at one time. It
>>> means if the bio size is 1M, the bio based will send 2048 times (evey
>>> time the only one scatterlist length is 512 bytes) to crypto engine to
>>> handle, which is more time-consuming and ineffective for the crypto
>>> engine. But for request based, it can map the whole request with many
>>> scatterlists (not just one scatterlist), and send all the scatterlists
>>> to the crypto engine which can improve the performance, is it right?
>>>
>>> Another optimization solution I think is we can expand the scatterlist
>>> entry number for bio based.
>>>
>>
>> I did some testing about my assumption of expanding the scatterlist
>> entry number for bio based. I did some modification for the bio based
>> to support multiple scatterlists, then it will get the same
>> performance as the request based things.
>>
>> 1. bio based with expanding the scatterlist entry
>> time dd if=/dev/dm-0 of=/dev/null bs=64K count=16384 iflag=direct
>> 1073741824 bytes (1.1 GB) copied, 94.5458 s, 11.4 MB/s
>> real    1m34.562s
>> user    0m0.030s
>> sys     0m3.850s
>>
>> 2. Sequential read 1G with requset based:
>> time dd if=/dev/dm-0 of=/dev/null bs=64K count=16384 iflag=direct
>> 1073741824 bytes (1.1 GB) copied, 94.8922 s, 11.3 MB/s
>> real    1m34.908s
>> user    0m0.030s
>> sys     0m4.000s
>>
>>  From the data, we can find the bio based also can get the same
>> performance as the request based. So if someone still don't like the
>> request based things, I think we can optimize the bio based by
>> expanding the scatterlists number. Thanks.
>>
>
>
> Hi
>
> Do you see any performance impact if you use with cryptsetup options:
>
>  --perf-same_cpu_crypt
>  --perf-submit_from_crypt_cpus
>
> with your regular unpatched kernel.

I did not see the performance impact with these options you said,
cause my board only has one cpu.

>
> Zdenek
>



-- 
Baolin.wang
Best Regards
