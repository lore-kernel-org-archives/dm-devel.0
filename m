From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH 0/5] crypto: add IV generation templates
Date: Sun, 22 Jul 2018 16:39:31 +0300
Message-ID: <CAOtvUMctPiTV4BMt7bp+Y7DocPtcP3HXykq4dJypN_ZcvV6b=Q@mail.gmail.com>
References: <1531899055-29362-1-git-send-email-wangxiongfeng2@huawei.com>
 <CAK8P3a0T0Ku-2GOY8fT38LVy4GpvVSsx=szi0ZNEUq8Z_hZweQ@mail.gmail.com>
 <CAKv+Gu8uD4NNS9SaWdSST7n+984ybTBLhGDpq3k5GG4o1+PMWA@mail.gmail.com>
 <5d0bb72c-862e-63be-3cc5-83ed02b9a575@huawei.com> <CAKv+Gu-hvEUyOOh_xpYsSj2WTcbM1FwRnJ1DkTGH1UjxkppNMQ@mail.gmail.com>
 <20180719155026.GF27938@sirena.org.uk> <CAKv+Gu_mb26HRi==5oeQyZ7ZOgifg7RUNt2c2V=tTqvFrMYq5g@mail.gmail.com>
 <20180720114509.GA10784@sirena.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180720114509.GA10784@sirena.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Brown <broonie@kernel.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Xiongfeng Wang <wangxiongfeng2@huawei.com>, Arnd Bergmann <arnd@arndb.de>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>, device-mapper development <dm-devel@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jonathan Cameron <jonathan.cameron@huawei.com>
List-Id: dm-devel.ids

Hi there,

Sorry for delay in response - the patch set was sent just as we shut
down the office for moving to a new location... :-)

On Fri, Jul 20, 2018 at 2:45 PM, Mark Brown <broonie@kernel.org> wrote:
> On Fri, Jul 20, 2018 at 10:02:21AM +0900, Ard Biesheuvel wrote:
>> On 20 July 2018 at 00:50, Mark Brown <broonie@kernel.org> wrote:
>
>> > Existing hardware can definitely do the IV generation and I believe th=
at
>> > it can chain multiple sectors together though I'd need to confirm this=
,
>> > as mentioned elsewhere in the thread the ccree driver is for one of
>> > the relevant devices.  I've poked some relevant people.
>
>> As far as I can infer from the ccree driver source, IV generation and
>> en/decryption are separate operations, and given that each sector
>> requires both operations to be applied in sequence, letting the crypto
>> layer handle an entire bio does not have any benefit *at the moment*.
>

So there are two separate things that can be considered IV generation
in the ccree driver:
- The ability to generate a none repeating IV for encryption mode of
operations that require it.
- The ability to compute an IV from sector number for storage related
modes of operation, such as xts

What you saw in the driver relates to the first whereas we are
discussing making use of the second.

In essence, it means providing a key, buffer to encrypt (that may span
a sector or possibly more) and the sector number
and the CryptoCell hardware can compute the IV hence forth for blocks
in the sector and across sector boundaries (it knows
the size of the sector so can increment the sector number as needed)
when fed a buffer that is bigger than a single sector.

Consider getting a 4k page with a sector size of 512 bytes and the
difference between 8 x 512 HW accesses and crypto APi calls
vs just one. Of course, you can just set the sector size to 4k and
indeed a recent change to dm-crypt allows that. You get similar
benefit
but at the cost of having to read 4k of data even if you just need 1 byte..=
.

I believe that other security hardware from other common vendors
posses similar abilities - but can't really speak for them.
I will note that the Android source code contains a hacked up dm-crypt
that uses an out-of-tree version of a common vendor
driver to drive this ability.

What is being aimed at here is to do the same but in an upstream-able,
community reviewed and accepted fashion.

Of course, breaking it up to stages is fine - it's just that it is
hard to show the benefits if you don't do the full monty....

I hope I've managed to shed some light on the matter and would be
happy to supply more details if needed.

Gilad


--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
