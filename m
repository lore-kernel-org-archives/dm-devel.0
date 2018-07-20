From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 0/5] crypto: add IV generation templates
Date: Fri, 20 Jul 2018 10:02:21 +0900
Message-ID: <CAKv+Gu_mb26HRi==5oeQyZ7ZOgifg7RUNt2c2V=tTqvFrMYq5g@mail.gmail.com>
References: <1531899055-29362-1-git-send-email-wangxiongfeng2@huawei.com>
	<CAK8P3a0T0Ku-2GOY8fT38LVy4GpvVSsx=szi0ZNEUq8Z_hZweQ@mail.gmail.com>
	<CAKv+Gu8uD4NNS9SaWdSST7n+984ybTBLhGDpq3k5GG4o1+PMWA@mail.gmail.com>
	<5d0bb72c-862e-63be-3cc5-83ed02b9a575@huawei.com>
	<CAKv+Gu-hvEUyOOh_xpYsSj2WTcbM1FwRnJ1DkTGH1UjxkppNMQ@mail.gmail.com>
	<20180719155026.GF27938@sirena.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180719155026.GF27938@sirena.org.uk>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mark Brown <broonie@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Mike Snitzer <snitzer@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, dm-devel@redhat.com, Jonathan Cameron <jonathan.cameron@huawei.com>, Xiongfeng Wang <wangxiongfeng2@huawei.com>, Alasdair Kergon <agk@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>
List-Id: dm-devel.ids

On 20 July 2018 at 00:50, Mark Brown <broonie@kernel.org> wrote:
> On Thu, Jul 19, 2018 at 11:08:52PM +0900, Ard Biesheuvel wrote:
>
>> But this will only be the case if the accelerator is capable of doing
>> the IV generation and en/decryption of multiple contiguous sectors in
>> a single call. Otherwise, you are just shifting work from one layer to
>> the next.
>
>> So at this point, it would be useful to clarify what exactly these
>> accelerators are doing and how.
>
> Existing hardware can definitely do the IV generation and I believe that
> it can chain multiple sectors together though I'd need to confirm this,
> as mentioned elsewhere in the thread the ccree driver is for one of
> the relevant devices.  I've poked some relevant people.

As far as I can infer from the ccree driver source, IV generation and
en/decryption are separate operations, and given that each sector
requires both operations to be applied in sequence, letting the crypto
layer handle an entire bio does not have any benefit *at the moment*.

In fact, it seems to me that the ability to use protected AES keys is
much more appealing than any performance argument (including 'it may
be slower but at least it does not load the CPU'), so some background
on how such a change would enable this use case would be beneficial as
well to getting this adopted.

So my recommendation would be to focus on moving the IV generation
into the crypto layer, but conservatively, and not confuse people by
making additional changes that could theoretically improve
performance, but only on hardware that does not exist.

-- 
Ard.
