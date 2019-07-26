From: Horia Geanta <horia.geanta@nxp.com>
Subject: Re: xts fuzz testing and lack of ciphertext stealing
 support
Date: Fri, 26 Jul 2019 19:59:07 +0000
Message-ID: <VI1PR0402MB34850A016F3228124C0D360698C00@VI1PR0402MB3485.eurprd04.prod.outlook.com>
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
	<CAKv+Gu9UF+a1UhVU19g1XcLaEqEaAwwkSm3-2wTHEAdD-q4mLQ@mail.gmail.com>
	<MN2PR20MB2973B9C2DDC508A81AF4A207CAC40@MN2PR20MB2973.namprd20.prod.outlook.com>
	<CAKv+Gu9C2AEbb++W=QTVWbeA_88Fo57NcOwgU5R8HBvzFwXkJw@mail.gmail.com>
	<MN2PR20MB2973C378AE5674F9E3E29445CAC60@MN2PR20MB2973.namprd20.prod.outlook.com>
	<CAKv+Gu-8n_DoauycDQS_9zzRew1rTuPaLxHyg6xhXMmqEvMaCA@mail.gmail.com>
	<MN2PR20MB2973CAE4E9CFFE1F417B2509CAC10@MN2PR20MB2973.namprd20.prod.outlook.com>
	<CAKv+Gu-j-8-bQS2A46-Kf1KHtkoPJ5Htk8WratqzyngnVu-wpw@mail.gmail.com>
	<MN2PR20MB29739591E1A3E54E7A8A8E18CAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Milan Broz <gmazyland@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>
List-Id: dm-devel.ids

On 7/26/2019 1:31 PM, Pascal Van Leeuwen wrote:
> Ok, find below a patch file that adds your vectors from the specification
> plus my set of additional vectors covering all CTS alignments combined
> with the block sizes you desired. Please note though that these vectors
> are from our in-house home-grown model so no warranties.
I've checked the test vectors against caam (HW + driver).

Test vectors from IEEE 1619-2007 (i.e. up to and including "XTS-AES 18")
are fine.

caam complains when /* Additional vectors to increase CTS coverage */
section starts:
alg: skcipher: xts-aes-caam encryption test failed (wrong result) on test vector 9, cfg="in-place"

(Unfortunately it seems that testmgr lost the capability of dumping
the incorrect output.)

IMO we can't rely on test vectors if they are not taken
straight out of a spec, or cross-checked with other implementations.

Horia

> They do run fine on the inside-secure driver + HW though, and I hereby
> donate them to the public domain i.e. feel free to use them as you see fit.
> (in case Outlook 365 messed up the patch below, it's also available from
> my public Git: https://github.com/pvanleeuwen/linux-cryptodev.git,
> branch is_driver_patch2)
> 
> --
> 
> This patch adds testvectors for AES-XTS that cover data inputs that are
> not a multiple of 16 bytes and therefore require cipher text stealing
> (CTS) to be applied. Vectors were added to cover all possible alignments
> combined with various interesting (i.e. for vector implementations working
> on 3,4,5 or 8 AES blocks in parallel) lengths.
> 
> Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
> ---
>  crypto/testmgr.h | 368 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 368 insertions(+)
> 
> diff --git a/crypto/testmgr.h b/crypto/testmgr.h
> index 105f2ce..1046e47 100644
> --- a/crypto/testmgr.h
> +++ b/crypto/testmgr.h
> @@ -15594,6 +15594,374 @@ struct len_range_sel {
>  			  "\xc4\xf3\x6f\xfd\xa9\xfc\xea\x70"
>  			  "\xb9\xc6\xe6\x93\xe1\x48\xc1\x51",
>  		.len	= 512,
> +	}, { /* XTS-AES 15 */
> +		.key    = "\xff\xfe\xfd\xfc\xfb\xfa\xf9\xf8"
> +			  "\xf7\xf6\xf5\xf4\xf3\xf2\xf1\xf0"
> +			  "\xbf\xbe\xbd\xbc\xbb\xba\xb9\xb8"
> +			  "\xb7\xb6\xb5\xb4\xb3\xb2\xb1\xb0",
> +		.klen   = 32,
> +		.iv     = "\x9a\x78\x56\x34\x12\x00\x00\x00"
> +			  "\x00\x00\x00\x00\x00\x00\x00\x00",
> +		.ptext	= "\x00\x01\x02\x03\x04\x05\x06\x07"
> +			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
> +			  "\x10",
> +		.ctext	= "\x6c\x16\x25\xdb\x46\x71\x52\x2d"
> +			  "\x3d\x75\x99\x60\x1d\xe7\xca\x09"
> +			  "\xed",
> +		.len	= 17,
[...]
> +	}, { /* XTS-AES 18 */
> +		.key    = "\xff\xfe\xfd\xfc\xfb\xfa\xf9\xf8"
> +			  "\xf7\xf6\xf5\xf4\xf3\xf2\xf1\xf0"
> +			  "\xbf\xbe\xbd\xbc\xbb\xba\xb9\xb8"
> +			  "\xb7\xb6\xb5\xb4\xb3\xb2\xb1\xb0",
> +		.klen   = 32,
> +		.iv     = "\x9a\x78\x56\x34\x12\x00\x00\x00"
> +			  "\x00\x00\x00\x00\x00\x00\x00\x00",
> +		.ptext	= "\x00\x01\x02\x03\x04\x05\x06\x07"
> +			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
> +			  "\x10\x11\x12\x13",
> +		.ctext	= "\x9d\x84\xc8\x13\xf7\x19\xaa\x2c"
> +			  "\x7b\xe3\xf6\x61\x71\xc7\xc5\xc2"
> +			  "\xed\xbf\x9d\xac",
> +		.len	= 20,
> +	/* Additional vectors to increase CTS coverage */
> +	}, { /* 1 block + 21 bytes */
> +		.key    = "\xa1\x34\x0e\x49\x38\xfd\x8b\xf6"
> +			  "\x45\x60\x67\x07\x0f\x50\xa8\x2b"
> +			  "\xa8\xf1\xfe\x7e\xf4\xf0\x47\xcd"
> +			  "\xfd\x91\x78\xf9\x14\x8b\x7d\x27"
> +			  "\x0e\xdc\xca\xe6\xf4\xfc\xd7\x4f"
> +			  "\x19\x8c\xd0\xe6\x9e\x2f\xf8\x75"
> +			  "\xb5\xe2\x48\x00\x4f\x07\xd9\xa1"
> +			  "\x42\xbc\x9d\xfc\x17\x98\x00\x48",
> +		.klen   = 64,
> +		.iv     = "\xcb\x35\x47\x5a\x7a\x06\x28\xb9"
> +			  "\x80\xf5\xa7\xe6\x8a\x23\x42\xf8",
> +		.ptext	= "\x04\x52\xc8\x7f\xb0\x5a\x12\xc5"
> +			  "\x96\x47\x6b\xf4\xbc\x2e\xdb\x74"
> +			  "\xd2\x20\x24\x32\xe5\x84\xb6\x25"
> +			  "\x4c\x2f\x96\xc7\x55\x9c\x90\x6f"
> +			  "\x0e\x96\x94\x68\xf4",
> +		.ctext	= "\x6a\x2d\x57\xb8\x72\x49\x10\x6b"
> +			  "\x5b\x5a\xc9\x92\xab\x59\x79\x36"
> +			  "\x7a\x01\x95\xf7\xdd\xcb\x3f\xbf"
> +			  "\xb2\xe3\x7e\x35\xe3\x11\x04\x68"
> +			  "\x28\xc3\x70\x6a\xe1",
> +		.len	= 37,
> +	}, { /* 3 blocks + 22 bytes */
[...]
