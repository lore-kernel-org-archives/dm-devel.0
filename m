From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [RFC PATCH v2] md/dm-crypt - reuse eboiv skcipher
 for IV generation
Date: Thu, 8 Aug 2019 01:30:59 -0700
Message-ID: <20190808083059.GB5319@sol.localdomain>
References: <20190807055022.15551-1-ard.biesheuvel@linaro.org>
	<MN2PR20MB297336108DF89337DDEEE2F6CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
	<CAKv+Gu_jFW26boEhpnAZg9sjWWZf60FXSWuSqNvC5FJiL7EVSA@mail.gmail.com>
	<MN2PR20MB2973A02FC4D6F1D11BA80792CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
	<CAKv+Gu8fgg=gt4LSnCfShnf0-PZ=B1TNwM3zdQr+V6hkozgDOA@mail.gmail.com>
	<MN2PR20MB29733EEF59CCD754256D5621CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <MN2PR20MB29733EEF59CCD754256D5621CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>, "snitzer@redhat.com" <snitzer@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "gmazyland@gmail.com" <gmazyland@gmail.com>, "agk@redhat.com" <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, Aug 07, 2019 at 04:14:22PM +0000, Pascal Van Leeuwen wrote:
> > > > In your case, we are not dealing with known plaintext attacks,
> > > >
> > > Since this is XTS, which is used for disk encryption, I would argue
> > > we do! For the tweak encryption, the sector number is known plaintext,
> > > same as for EBOIV. Also, you may be able to control data being written
> > > to the disk encrypted, either directly or indirectly.
> > > OK, part of the data into the CTS encryption will be previous ciphertext,
> > > but that may be just 1 byte with the rest being the known plaintext.
> > >
> > 
> > The tweak encryption uses a dedicated key, so leaking it does not have
> > the same impact as it does in the EBOIV case. 
> >
> Well ... yes and no. The spec defines them as seperately controllable -
> deviating from the original XEX definition - but in most practicle use cases 
> I've seen, the same key is used for both, as having 2 keys just increases 
> key  storage requirements and does not actually improve effective security 
> (of the algorithm itself, implementation peculiarities like this one aside 
> :-), as  XEX has been proven secure using a single key. And the security 
> proof for XTS actually builds on that while using 2 keys deviates from it.
> 

This is a common misconception.  Actually, XTS needs 2 distinct keys to be a
CCA-secure tweakable block cipher, due to another subtle difference from XEX:
XEX (by which I really mean "XEX[E,2]") builds the sequence of masks starting
with x^1, while XTS starts with x^0.  If only 1 key is used, the inclusion of
the 0th power in XTS allows the attack described in Section 6 of the XEX paper
(https://web.cs.ucdavis.edu/~rogaway/papers/offsets.pdf).

Of course, it's debatable what this means *in practice* to the usual XTS use
cases like disk encryption, for which CCA security may not be critical...  But
technically, single-key XTS isn't secure under as strong an attack model as XEX.

- Eric
