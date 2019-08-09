From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: xts fuzz testing and lack of ciphertext stealing
	support
Date: Fri, 9 Aug 2019 20:49:13 +0300
Message-ID: <CAKv+Gu-_WObNm+ySXDWjhqe2YPzajX83MofuF-WKPSdLg5t4Ew@mail.gmail.com>
References: <CAKv+Gu9C2AEbb++W=QTVWbeA_88Fo57NcOwgU5R8HBvzFwXkJw@mail.gmail.com>
	<MN2PR20MB2973C378AE5674F9E3E29445CAC60@MN2PR20MB2973.namprd20.prod.outlook.com>
	<CAKv+Gu-8n_DoauycDQS_9zzRew1rTuPaLxHyg6xhXMmqEvMaCA@mail.gmail.com>
	<MN2PR20MB2973CAE4E9CFFE1F417B2509CAC10@MN2PR20MB2973.namprd20.prod.outlook.com>
	<CAKv+Gu-j-8-bQS2A46-Kf1KHtkoPJ5Htk8WratqzyngnVu-wpw@mail.gmail.com>
	<MN2PR20MB29739591E1A3E54E7A8A8E18CAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
	<20f4832e-e3af-e3c2-d946-13bf8c367a60@nxp.com>
	<VI1PR0402MB34856F03FCE57AB62FC2257998D40@VI1PR0402MB3485.eurprd04.prod.outlook.com>
	<MN2PR20MB2973127E4C159A8F5CFDD0C9CAD70@MN2PR20MB2973.namprd20.prod.outlook.com>
	<VI1PR0402MB3485689B4B65C879BC1D137398D70@VI1PR0402MB3485.eurprd04.prod.outlook.com>
	<20190809024821.GA7186@gondor.apana.org.au>
	<CAKv+Gu9hk=PGpsAWWOU61VrA3mVQd10LudA1qg0LbiX7DG9RjA@mail.gmail.com>
	<VI1PR0402MB3485F94AECC495F133F6B3D798D60@VI1PR0402MB3485.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <VI1PR0402MB3485F94AECC495F133F6B3D798D60@VI1PR0402MB3485.eurprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Horia Geanta <horia.geanta@nxp.com>
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>, Herbert Xu <herbert@gondor.apana.org.au>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Milan Broz <gmazyland@gmail.com>
List-Id: dm-devel.ids

On Fri, 9 Aug 2019 at 10:44, Horia Geanta <horia.geanta@nxp.com> wrote:
>
> On 8/9/2019 9:45 AM, Ard Biesheuvel wrote:
> > On Fri, 9 Aug 2019 at 05:48, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >>
> >> On Thu, Aug 08, 2019 at 06:01:49PM +0000, Horia Geanta wrote:
> >>>
> >>> -- >8 --
> >>>
> >>> Subject: [PATCH] crypto: testmgr - Add additional AES-XTS vectors for covering
> >>>  CTS (part II)
> >>
> >> Patchwork doesn't like it when you do this and it'll discard
> >> your patch.  To make it into patchwork you need to put the new
> >> Subject in the email headers.
> >>
> >
> > IMO, pretending that your XTS implementation is compliant by only
> I've never said that.
> Some parts are compliant, some are not.
>
> > providing test vectors with the last 8 bytes of IV cleared is not the
> > right fix for this issue. If you want to be compliant, you will need
> It's not a fix.
> It's adding test vectors which are not provided in the P1619 standard,
> where "data unit sequence number" is at most 5B.
>

Indeed. But I would prefer not to limit ourselves to 5 bytes of sector
numbers in the test vectors. However, we should obviously not add test
vectors that are known to cause breakages on hardware that works fine
in practice.

> > to provide a s/w fallback for these cases.
> >
> Yes, the plan is to:
>
> -add 16B IV support for caam versions supporting it - caam Era 9+,
> currently deployed in lx2160a and ls108a
>
> -remove current 8B IV support and add s/w fallback for affected caam versions
> I'd assume this could be done dynamically, i.e. depending on IV provided
> in the crypto request to use either the caam engine or s/w fallback.
>

Yes. If the IV received from the caller has bytes 8..15 cleared, you
use the limited XTS h/w implementation, otherwise you fall back to
xts(ecb-aes-caam..).
