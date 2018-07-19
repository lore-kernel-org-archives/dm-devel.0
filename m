From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 0/5] crypto: add IV generation templates
Date: Thu, 19 Jul 2018 23:08:52 +0900
Message-ID: <CAKv+Gu-hvEUyOOh_xpYsSj2WTcbM1FwRnJ1DkTGH1UjxkppNMQ@mail.gmail.com>
References: <1531899055-29362-1-git-send-email-wangxiongfeng2@huawei.com>
 <CAK8P3a0T0Ku-2GOY8fT38LVy4GpvVSsx=szi0ZNEUq8Z_hZweQ@mail.gmail.com>
 <CAKv+Gu8uD4NNS9SaWdSST7n+984ybTBLhGDpq3k5GG4o1+PMWA@mail.gmail.com> <5d0bb72c-862e-63be-3cc5-83ed02b9a575@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5d0bb72c-862e-63be-3cc5-83ed02b9a575@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>, dm-devel@redhat.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Mark Brown <broonie@kernel.org>, Jonathan Cameron <jonathan.cameron@huawei.com>
List-Id: dm-devel.ids

On 19 July 2018 at 19:55, Xiongfeng Wang <wangxiongfeng2@huawei.com> wrote:
> Hi,
>
> On 2018/7/18 23:34, Ard Biesheuvel wrote:
>> On 18 July 2018 at 19:59, Arnd Bergmann <arnd@arndb.de> wrote:
>>> On Wed, Jul 18, 2018 at 9:30 AM, Xiongfeng Wang
>>> <wangxiongfeng2@huawei.com> wrote:
>>>>
>>>> I tested the performance of software implemented ciphers before and after
>>>> applying this patchset. The performance didn't change much except for
>>>> slight regression when writting. The detail information is as follows.
>>>>
>>>> The command I used:
>>>> cryptsetup -y -c aes-xts-plain -s 256 --hash sha256 luksFormat /dev/sdd1
>>>> cryptsetup -y -c aes-cbc-essiv:sha256 -s 256 --hash sha256 luksFormat /dev/sdd1
>>>> cryptsetup -y -c aes-cbc-benbi -s 256 --hash sha256 luksFormat /dev/sdd1
>>>>
>>>> cryptsetup luksOpen /dev/sdd1 crypt_fun
>>>> time dd if=/dev/mapper/crypt_fun of=/dev/null bs=1M count=500 iflag=direct
>>>> time dd if=/dev/zero of=/dev/mapper/crypt_fun bs=1M count=500 oflag=direct
>>>>
>>>> Performance comparision:
>>>> --------------------------------------------------------
>>>> algorithms      | before applying   |   after applying
>>>> --------------------------------------------------------
>>>>                 |  read  | write    |  read  | write
>>>> --------------------------------------------------------
>>>> aes-xts-plain   | 145.34 | 145.09   | 145.89 | 144.2
>>>> --------------------------------------------------------
>>>> aes-cbc-essiv   | 146.87 | 144.62   | 146.74 | 143.41
>>>> --------------------------------------------------------
>>>> aes-cbc-benbi   | 146.03 | 144.74   | 146.77 | 144.46
>>>> --------------------------------------------------------
>>>
>>> Do you have any estimate of the expected gains for hardware
>>> implementations?
>>>
>>> Would it make sense to try out implementing aes-cbc-essiv
>>> on the ARMv8 crypto extensions? I see that Ard has done
>>> some prior work on aes-ccm in arch/arm64/crypto/aes-ce-ccm-*
>>> that (AFAICT) has a similar goal of avoiding overhead by
>>> combining the usual operations, so maybe the same can
>>> be done here.
>>>
>>
>> I am having trouble understanding what exactly this series aims to achieve.
>>
>> Calling into the crypto layer fewer times is a nice goal, but a disk
>> sector seems like a reasonable granularity for the dm layer to operate
>> on, and I don't think any hardware exists that operates on multi
>> sector sequences, where it would pay off to amortize the latency of
>> invoking the hardware over an entire bio.
>
> I don't know much about crypto hardware, but I think a crypto hardware can handle
> data more than one sector at one time. So I think passing the whole bio to the hardware
> at one time will decrease the overhead in passing each sector alternatively.
>

But this will only be the case if the accelerator is capable of doing
the IV generation and en/decryption of multiple contiguous sectors in
a single call. Otherwise, you are just shifting work from one layer to
the next.

So at this point, it would be useful to clarify what exactly these
accelerators are doing and how.
