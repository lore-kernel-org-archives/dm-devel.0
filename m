From: Baolin Wang <baolin.wang@linaro.org>
Subject: Re: [dm-devel] [PATCH 0/2] Introduce the request handling for dm-crypt
Date: Fri, 4 Dec 2015 12:57:19 +0800
Message-ID: <CAMz4kuKj7+YhELFnjUqJm=MtX0UrS1oPLqWr+riAKXKng55+Ow@mail.gmail.com>
References: <cover.1447233227.git.baolin.wang@linaro.org>
	<20151111181813.GD12236@redhat.com>
	<CAMz4kuKNAkFG4-f6TU1HRxgkAn+YX-D_tTQAWio-A_np3brr+A@mail.gmail.com>
	<20151112100422.GM12392@sirena.org.uk>
	<5644AFA2.6040201@kernel.dk>
	<20151113115144.GR12392@sirena.org.uk>
	<CAMz4kuLTuY5CpTfW4Gijesy1Pp9PxbWj076XeoV24Hj3EydifQ@mail.gmail.com>
	<20151202195657.GB11127@agk-dp.fab.redhat.com>
	<CAMz4kuL3qE-jE14F6ovAMRv6D-UFCdtiyUyi4ZDo+Lkr7_nA0Q@mail.gmail.com>
	<alpine.LRH.2.02.1512031039001.15134@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1512031039001.15134@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mark Brown <broonie@kernel.org>, Jens Axboe <axboe@kernel.dk>, keith.busch@intel.com, Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>, Mike Snitzer <snitzer@redhat.com>, neilb@suse.com, LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org, dm-devel@redhat.com, "Garg, Dinesh" <dineshg@quicinc.com>, tj@kernel.org, bart.vanassche@sandisk.com, jmoyer@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 3 December 2015 at 23:47, Mikulas Patocka <mpatocka@redhat.com> wrote:
>
>
> On Thu, 3 Dec 2015, Baolin Wang wrote:
>
>> On 3 December 2015 at 03:56, Alasdair G Kergon <agk@redhat.com> wrote:
>> > On Wed, Dec 02, 2015 at 08:46:54PM +0800, Baolin Wang wrote:
>> >> These are the benchmarks for request based dm-crypt. Please check it.
>> >
>> > Now please put request-based dm-crypt completely to one side and focus
>> > just on the existing bio-based code.  Why is it slower and what can be
>> > adjusted to improve this?
>> >
>>
>> OK. I think I find something need to be point out.
>> 1. From the IO block size test in the performance report, for the
>> request based, we can find it can not get the corresponding
>> performance if we just expand the IO size. Because In dm crypt, it
>> will map the data buffer of one request with scatterlists, and send
>> all scatterlists of one request to the encryption engine to encrypt or
>> decrypt.  I found if the scatterlist list number is small and each
>> scatterlist length is bigger, it will improve the encryption speed,
>
> This optimization is only applicable to XTS mode. XTS has its weaknesses
> and it is not recommended for encryption of more than 1TB of data
> ( http://grouper.ieee.org/groups/1619/email/msg02357.html )
>
> You can optimize bio-based dm-crypt as well (use larger encryption chunk
> than 512 bytes when the mode is XTS).
>
> The most commonly used mode aes-cbc-essiv:sha256 can't be optimized that
> way. You have to do encryption and decryption sector by sector because
> every sector has different IV.

Make sense. We'll optimize bio-based dm-crypt for XTS mode, and do
some investigations for none XTS mode.

>
> Mikulas
>



-- 
Baolin.wang
Best Regards
