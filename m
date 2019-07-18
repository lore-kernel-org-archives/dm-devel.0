From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: xts fuzz testing and lack of ciphertext stealing
	support
Date: Thu, 18 Jul 2019 18:19:24 +0200
Message-ID: <CAKv+Gu9qm8mDZASJasq18bW=4_oE-cKPGKvdF9+8=7VNo==_fA@mail.gmail.com>
References: <VI1PR0402MB34857BBB18C2BB8CBA2DEC7198C90@VI1PR0402MB3485.eurprd04.prod.outlook.com>
	<20190717172823.GA205944@gmail.com>
	<CAKv+Gu__offPaWvyURJr8v56ig58q-Deo16QhP26EJ32uf5m3w@mail.gmail.com>
	<20190718065223.4xaefcwjoxvujntw@gondor.apana.org.au>
	<CAKv+Gu9-EWNpJ9viSsjhYRdOZb=7a=Mpddmyt8SLEq9aFtawjg@mail.gmail.com>
	<20190718072154.m2umem24x4grbf6w@gondor.apana.org.au>
	<36e78459-1594-6d19-0ab4-95b03a6de036@gmail.com>
	<MN2PR20MB2973E61815F069E8C7D74177CAC80@MN2PR20MB2973.namprd20.prod.outlook.com>
	<20190718152908.xiuze3kb3fdc7ov6@gondor.apana.org.au>
	<MN2PR20MB2973E1A367986303566E80FCCAC80@MN2PR20MB2973.namprd20.prod.outlook.com>
	<20190718155140.b6ig3zq22askmfpy@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190718155140.b6ig3zq22askmfpy@gondor.apana.org.au>
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
Cc: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Milan Broz <gmazyland@gmail.com>, Horia Geanta <horia.geanta@nxp.com>, "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
List-Id: dm-devel.ids

On Thu, 18 Jul 2019 at 17:51, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Jul 18, 2019 at 03:43:28PM +0000, Pascal Van Leeuwen wrote:
> >
> > Hmmm ... so the generic CTS template would have to figure out whether it is wrapped
> > around ECB, CBC, XTS or whatever and then adjust to that?
>
> That's not hard to do.  Right now cts only supports cbc.  IOW
> if you pass it anything else it will refuse to instantiate.
>
> > For XTS, you have this additional curve ball being thrown in called the "tweak".
> > For encryption, the underlying "xts" would need to be able to chain the tweak,
> > from what I've seen of the source the implementation cannot do that.
>
> You simply use the underlying xts for the first n - 2 blocks and
> do the last two by hand.
>

OK, so it appears the XTS ciphertext stealing algorithm does not
include the peculiar reordering of the 2 final blocks, which means
that the kernel's implementation of XTS already conforms to the spec
for inputs that are a multiple of the block size.

The reason I am not a fan of making any changes here is that there are
no in-kernel users that require ciphertext stealing for XTS, nor is
anyone aware of any reason why we should be adding it to the userland
interface. So we are basically adding dead code so that we are
theoretically compliant in a way that we will never exercise in
practice.

Note that for software algorithms such as the bit sliced NEON
implementation of AES, which can only operate on 8 AES blocks at a
time, doing the final 2 blocks sequentially is going to seriously
impact performance. This means whatever wrapper we invent around xex()
(or whatever we call it) should go out of its way to ensure that the
common, non-CTS case does not regress in performance, and the special
handling is only invoked when necessary (which will be never).
