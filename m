From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 4/5] crypto: Add IV generation templates
Date: Thu, 19 Jul 2018 10:50:12 +0200
Message-ID: <CAK8P3a2oubqRKg1tnoG6CsmUs-U5Ab6q5rwpfg08PRNJLhEjEw@mail.gmail.com>
References: <1531899055-29362-1-git-send-email-wangxiongfeng2@huawei.com>
 <1531899055-29362-5-git-send-email-wangxiongfeng2@huawei.com>
 <b6eaf471-7279-ca4f-bb7c-d25df8db2419@gmail.com> <20180718164625.GA20360@sirena.org.uk>
 <82248c13-42fe-b598-0cd7-68e5db0b51be@gmail.com> <cda1d3de-3f21-2dfc-0423-c1cf456838b4@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cda1d3de-3f21-2dfc-0423-c1cf456838b4@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Cc: Milan Broz <gmazyland@gmail.com>, Mark Brown <broonie@kernel.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>, dm-devel@redhat.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jonathan Cameron <jonathan.cameron@huawei.com>
List-Id: dm-devel.ids

On Thu, Jul 19, 2018 at 3:46 AM, Xiongfeng Wang
<wangxiongfeng2@huawei.com> wrote:
> Hi,
>
> On 2018/7/19 1:17, Milan Broz wrote:
>> On 18/07/18 18:46, Mark Brown wrote:
>>> On Wed, Jul 18, 2018 at 10:16:05AM +0200, Milan Broz wrote:
>>>
>>>> So we are here again and moving INTERNAL dm-crypt functionality into
>>>> cryptoapi.
>>
>> 2) If the reason is performance, please provide numbers with the patch.
>> What I see now is that the performance is almost the same. So why you are doing it?
>> Any real hw that benefits from it?
>
> Because the internal implementation of the IV template 'benbi()' is still
> dividing the whole bio into sectors, so the performance is almost the same.
> The purpose of this patch is to let dm-crypt rely on the new algorithm 'aes-cbc-benbi'
> and pass the whole bio to the new algorithm.
> And then if the hardware driver implements this new algorithm, it can get the data of
> the bio at one time, and return the processed data at one time.
> I think it will decrease the overhead of passing each sector alternatively.
> But the hardware need to implement the new algorithm if it want to benefit from this.

There seems to be some support for at least essiv(aes) in
drivers/crypto/ccree/cc_cipher.c, is that compatible with your essiv(*)
template, or is that something else?

       Arnd
