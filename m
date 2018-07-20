From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 0/5] crypto: add IV generation templates
Date: Fri, 20 Jul 2018 21:23:15 +0900
Message-ID: <CAKv+Gu8=M-EE11dZwcAzy1ZrnEoz=nF++v9bneY2SUq+e217Rg@mail.gmail.com>
References: <1531899055-29362-1-git-send-email-wangxiongfeng2@huawei.com>
 <CAK8P3a0T0Ku-2GOY8fT38LVy4GpvVSsx=szi0ZNEUq8Z_hZweQ@mail.gmail.com>
 <CAKv+Gu8uD4NNS9SaWdSST7n+984ybTBLhGDpq3k5GG4o1+PMWA@mail.gmail.com>
 <5d0bb72c-862e-63be-3cc5-83ed02b9a575@huawei.com> <CAKv+Gu-hvEUyOOh_xpYsSj2WTcbM1FwRnJ1DkTGH1UjxkppNMQ@mail.gmail.com>
 <20180719155026.GF27938@sirena.org.uk> <CAKv+Gu_mb26HRi==5oeQyZ7ZOgifg7RUNt2c2V=tTqvFrMYq5g@mail.gmail.com>
 <20180720114509.GA10784@sirena.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180720114509.GA10784@sirena.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Brown <broonie@kernel.org>
Cc: Xiongfeng Wang <wangxiongfeng2@huawei.com>, Arnd Bergmann <arnd@arndb.de>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>, dm-devel@redhat.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jonathan Cameron <jonathan.cameron@huawei.com>
List-Id: dm-devel.ids

On 20 July 2018 at 20:45, Mark Brown <broonie@kernel.org> wrote:
> On Fri, Jul 20, 2018 at 10:02:21AM +0900, Ard Biesheuvel wrote:
>> On 20 July 2018 at 00:50, Mark Brown <broonie@kernel.org> wrote:
>
>> > Existing hardware can definitely do the IV generation and I believe that
>> > it can chain multiple sectors together though I'd need to confirm this,
>> > as mentioned elsewhere in the thread the ccree driver is for one of
>> > the relevant devices.  I've poked some relevant people.
>
>> As far as I can infer from the ccree driver source, IV generation and
>> en/decryption are separate operations, and given that each sector
>> requires both operations to be applied in sequence, letting the crypto
>> layer handle an entire bio does not have any benefit *at the moment*.
>
> Interesting...  they were reporting some benefits from that with their
> out of tree driver prior to upstreaming (and there are other
> implementations out there, that's the only one I definitely know about).
> I have to confess I didn't look at their in tree driver, looking briefly
> now it looks awfully like the hardware should be able to chain IV
> generation together with encryption without bothering the CPU which
> would be good enough.
>

Indeed interesting. But afaict, that would still mean that the IV
generation transform and the payload transform would be expressed as a
single crypto algorithm, e.g., 'dm(essiv-foo(aes),gcm(aes)), or the DM
layer would still need to be involved in sequencing one operation
after the other, and I don't think any of that support is in the
current series. But I'm just a drive by reviewer here, so please
correct me if I am wrong.

>> In fact, it seems to me that the ability to use protected AES keys is
>> much more appealing than any performance argument (including 'it may
>> be slower but at least it does not load the CPU'), so some background
>> on how such a change would enable this use case would be beneficial as
>> well to getting this adopted.
>
> Right, that's another benefit which was on the radar for followup work.
>
>> So my recommendation would be to focus on moving the IV generation
>> into the crypto layer, but conservatively, and not confuse people by
>> making additional changes that could theoretically improve
>> performance, but only on hardware that does not exist.
>
> It certainly seems like splitting things up will at least allow things
> to progress.

Indeed.
