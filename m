From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 0/5] crypto: add IV generation templates
Date: Wed, 18 Jul 2018 12:59:07 +0200
Message-ID: <CAK8P3a0T0Ku-2GOY8fT38LVy4GpvVSsx=szi0ZNEUq8Z_hZweQ@mail.gmail.com>
References: <1531899055-29362-1-git-send-email-wangxiongfeng2@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1531899055-29362-1-git-send-email-wangxiongfeng2@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>, dm-devel@redhat.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Mark Brown <broonie@kernel.org>, Jonathan Cameron <jonathan.cameron@huawei.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: dm-devel.ids

On Wed, Jul 18, 2018 at 9:30 AM, Xiongfeng Wang
<wangxiongfeng2@huawei.com> wrote:
>
> I tested the performance of software implemented ciphers before and after
> applying this patchset. The performance didn't change much except for
> slight regression when writting. The detail information is as follows.
>
> The command I used:
> cryptsetup -y -c aes-xts-plain -s 256 --hash sha256 luksFormat /dev/sdd1
> cryptsetup -y -c aes-cbc-essiv:sha256 -s 256 --hash sha256 luksFormat /dev/sdd1
> cryptsetup -y -c aes-cbc-benbi -s 256 --hash sha256 luksFormat /dev/sdd1
>
> cryptsetup luksOpen /dev/sdd1 crypt_fun
> time dd if=/dev/mapper/crypt_fun of=/dev/null bs=1M count=500 iflag=direct
> time dd if=/dev/zero of=/dev/mapper/crypt_fun bs=1M count=500 oflag=direct
>
> Performance comparision:
> --------------------------------------------------------
> algorithms      | before applying   |   after applying
> --------------------------------------------------------
>                 |  read  | write    |  read  | write
> --------------------------------------------------------
> aes-xts-plain   | 145.34 | 145.09   | 145.89 | 144.2
> --------------------------------------------------------
> aes-cbc-essiv   | 146.87 | 144.62   | 146.74 | 143.41
> --------------------------------------------------------
> aes-cbc-benbi   | 146.03 | 144.74   | 146.77 | 144.46
> --------------------------------------------------------

Do you have any estimate of the expected gains for hardware
implementations?

Would it make sense to try out implementing aes-cbc-essiv
on the ARMv8 crypto extensions? I see that Ard has done
some prior work on aes-ccm in arch/arm64/crypto/aes-ce-ccm-*
that (AFAICT) has a similar goal of avoiding overhead by
combining the usual operations, so maybe the same can
be done here.

      Arnd
