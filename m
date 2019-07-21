From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: xts fuzz testing and lack of ciphertext stealing
	support
Date: Sun, 21 Jul 2019 12:50:06 +0300
Message-ID: <CAKv+Gu9UF+a1UhVU19g1XcLaEqEaAwwkSm3-2wTHEAdD-q4mLQ@mail.gmail.com>
References: <20190716221639.GA44406@gmail.com>
	<VI1PR0402MB34857BBB18C2BB8CBA2DEC7198C90@VI1PR0402MB3485.eurprd04.prod.outlook.com>
	<20190717172823.GA205944@gmail.com>
	<CAKv+Gu__offPaWvyURJr8v56ig58q-Deo16QhP26EJ32uf5m3w@mail.gmail.com>
	<20190718065223.4xaefcwjoxvujntw@gondor.apana.org.au>
	<CAKv+Gu9-EWNpJ9viSsjhYRdOZb=7a=Mpddmyt8SLEq9aFtawjg@mail.gmail.com>
	<20190718072154.m2umem24x4grbf6w@gondor.apana.org.au>
	<36e78459-1594-6d19-0ab4-95b03a6de036@gmail.com>
	<MN2PR20MB2973E61815F069E8C7D74177CAC80@MN2PR20MB2973.namprd20.prod.outlook.com>
	<b042649c-db98-9710-b063-242bdf520252@gmail.com>
	<20190720065807.GA711@sol.localdomain>
	<0d4d6387-777c-bfd3-e54a-e7244fde0096@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <0d4d6387-777c-bfd3-e54a-e7244fde0096@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <gmazyland@gmail.com>
Cc: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>, Horia Geanta <horia.geanta@nxp.com>, Herbert Xu <herbert@gondor.apana.org.au>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
List-Id: dm-devel.ids

On Sat, 20 Jul 2019 at 10:35, Milan Broz <gmazyland@gmail.com> wrote:
>
> On 20/07/2019 08:58, Eric Biggers wrote:
> > On Thu, Jul 18, 2019 at 01:19:41PM +0200, Milan Broz wrote:
> >> Also, I would like to avoid another "just because it is nicer" module dependence (XTS->XEX->ECB).
> >> Last time (when XTS was reimplemented using ECB) we have many reports with initramfs
> >> missing ECB module preventing boot from AES-XTS encrypted root after kernel upgrade...
> >> Just saying. (Despite the last time it was keyring what broke encrypted boot ;-)
> >>
> >
> > Can't the "missing modules in initramfs" issue be solved by using a
> > MODULE_SOFTDEP()?  Actually, why isn't that being used for xts -> ecb already?
> >
> > (There was also a bug where CONFIG_CRYPTO_XTS didn't select CONFIG_CRYPTO_ECB,
> > but that was simply a bug, which was fixed.)
>
> Sure, and it is solved now. (Some systems with a hardcoded list of modules
> have to be manually updated etc., but that is just bad design).
> It can be done properly from the beginning.
>
> I just want to say that that switching to XEX looks like wasting time to me
> for no additional benefit.
>
> Fully implementing XTS does make much more sense for me, even though it is long-term
> the effort and the only user, for now, would be testmgr.
>
> So, there are no users because it does not work. It makes no sense
> to implement it, because there are no users... (sorry, sounds like catch 22 :)
>
> (Maybe someone can use it for keyslot encryption for keys not aligned to
> block size, dunno. Actually, some filesystem encryption could have use for it.)
>
> > Or "xts" and "xex" could go in the same kernel module xts.ko, which would make
> > this a non-issue.
>
> If it is not available for users, I really see no reason to introduce XEX when
> it is just XTS with full blocks.
>
> If it is visible to users, it needs some work in userspace - XEX (as XTS) need two keys,
> people are already confused enough that 256bit key in AES-XTS means AES-128...
> So the examples, hints, man pages need to be updated, at least.
>

OK, consider me persuaded. We are already exposing xts(...) to
userland, and since we already implement a proper subset of true XTS,
it will be simply a matter of making sure that the existing XTS
implementations don't regress in performance on the non-CTS code
paths.

It would be useful, though, to have some generic helper functions,
e.g., like the one we have for CBC, or the one I recently proposed for
CTS, so that existing implementations (such as the bit sliced AES) can
easily be augmented with a CTS code path (but performance may not be
optimal in those cases). For the ARM implementations based on AES
instructions, it should be reasonably straight forward to implement it
close to optimally by reusing some of the code I added for CBC-CTS
(but I won't get around to doing that for a while). If there are any
volunteers for looking into the generic or x86/AES-NI implementations,
please come forward :-) Also, if any of the publications that were
quoted in this thread have suitable test vectors, that would be good
to know.
