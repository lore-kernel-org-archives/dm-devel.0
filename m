From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: xts fuzz testing and lack of ciphertext stealing
	support
Date: Thu, 18 Jul 2019 09:15:39 +0200
Message-ID: <CAKv+Gu9-EWNpJ9viSsjhYRdOZb=7a=Mpddmyt8SLEq9aFtawjg@mail.gmail.com>
References: <VI1PR0402MB34858E4EF0ACA7CDB446FF5798CE0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
	<20190716221639.GA44406@gmail.com>
	<VI1PR0402MB34857BBB18C2BB8CBA2DEC7198C90@VI1PR0402MB3485.eurprd04.prod.outlook.com>
	<20190717172823.GA205944@gmail.com>
	<CAKv+Gu__offPaWvyURJr8v56ig58q-Deo16QhP26EJ32uf5m3w@mail.gmail.com>
	<20190718065223.4xaefcwjoxvujntw@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190718065223.4xaefcwjoxvujntw@gondor.apana.org.au>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, Horia Geanta <horia.geanta@nxp.com>
List-Id: dm-devel.ids

On Thu, 18 Jul 2019 at 08:52, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Wed, Jul 17, 2019 at 08:08:27PM +0200, Ard Biesheuvel wrote:
> >
> > Since the kernel does not support CTS for XTS any way, and since no
> > AF_ALG users can portably rely on this, I agree with Eric that the
> > only sensible way to address this is to disable this functionality in
> > the driver.
>
> But the whole point of XTS is that it supports sizes that are
> not multiples of the block size.  So implementing it without
> supporting ciphertext stealing is just wrong.
>
> So let's fix the generic implementation rather than breaking
> the caam driver.
>

Not just the generic implementation: there are numerous synchronous
and asynchronous implementations of xts(aes) in the kernel that would
have to be fixed, while there are no in-kernel users that actually
rely on CTS. Also, in the cbc case, we support CTS by wrapping it into
another template, i.e., cts(cbc(aes)).

So retroactively redefining what xts(...) means seems like a bad idea
to me. If we want to support XTS ciphertext stealing for the benefit
of userland, let's do so via the existing cts template, and add
support for wrapping XTS to it.
