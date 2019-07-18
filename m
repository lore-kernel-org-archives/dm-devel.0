From: Milan Broz <gmazyland@gmail.com>
Subject: Re: xts fuzz testing and lack of ciphertext stealing
	support
Date: Thu, 18 Jul 2019 13:19:41 +0200
Message-ID: <b042649c-db98-9710-b063-242bdf520252@gmail.com>
References: <VI1PR0402MB34858E4EF0ACA7CDB446FF5798CE0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
	<20190716221639.GA44406@gmail.com>
	<VI1PR0402MB34857BBB18C2BB8CBA2DEC7198C90@VI1PR0402MB3485.eurprd04.prod.outlook.com>
	<20190717172823.GA205944@gmail.com>
	<CAKv+Gu__offPaWvyURJr8v56ig58q-Deo16QhP26EJ32uf5m3w@mail.gmail.com>
	<20190718065223.4xaefcwjoxvujntw@gondor.apana.org.au>
	<CAKv+Gu9-EWNpJ9viSsjhYRdOZb=7a=Mpddmyt8SLEq9aFtawjg@mail.gmail.com>
	<20190718072154.m2umem24x4grbf6w@gondor.apana.org.au>
	<36e78459-1594-6d19-0ab4-95b03a6de036@gmail.com>
	<MN2PR20MB2973E61815F069E8C7D74177CAC80@MN2PR20MB2973.namprd20.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <MN2PR20MB2973E61815F069E8C7D74177CAC80@MN2PR20MB2973.namprd20.prod.outlook.com>
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
To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>, Herbert Xu <herbert@gondor.apana.org.au>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, Horia Geanta <horia.geanta@nxp.com>
List-Id: dm-devel.ids

On 18/07/2019 12:40, Pascal Van Leeuwen wrote:
...
>> See the reference in generic code - the 3rd line - link to the IEEE standard.
>> We do not implement it properly - for more than 12 years!
>>
> 
> Full XTS is XEX-TCB-CTS so the proper terminology for "XTS without CTS" would be XEX-TCB.
> But the problem there is that TCB and CTS are generic terms that do not imply a specific 
> implementation for generating the tweak -or- performing the ciphertext stealing.
> Only the *full* XTS operation is standardized (as IEEE Std P1619).

Yes. Also XTS is allowed in FIPS now. Because the current code cannot submit
anything else than aligned blocks, we are ok.
(I hope. Speaking for disk encryption, dm-crypt, only).

> In fact, using the current cts template around the current xts template actually does NOT
> implement standards compliant XTS at all, as the CTS *implementation* for XTS is 
> different from the one for CBC as implemented by the current CTS template.
> The actual implementation of the ciphertext stealing has (or may have) a security impact,
> so the *combined* operation must be cryptanalyzed and adding some random CTS scheme
> to some random block cipher mode would be a case of "roll your own crypto" (i.e. bad).

> From that perspective - to prevent people from doing cryptographically stupid things -
> IMHO it would be better to just pull the CTS into the XTS implementation i.e. make
> xts natively support blocks that are not a multiple of (but >=) the cipher blocksize ...

I would definitely prefer adding CTS directly to XTS (as it is in gcrypt or OpenSSL now)
instead of some new compositions.

Also, I would like to avoid another "just because it is nicer" module dependence (XTS->XEX->ECB).
Last time (when XTS was reimplemented using ECB) we have many reports with initramfs
missing ECB module preventing boot from AES-XTS encrypted root after kernel upgrade...
Just saying. (Despite the last time it was keyring what broke encrypted boot ;-)

(That said, I will try to find some volunteer to help with CTS in XTS implementation, if needed.)

>> Reality check - nobody in block layer needs ciphertext stealing, we are always
>> aligned to block. AF_ALG is a different story, though.
> 
> So you don't support odd sector sizes like 520 , 528, 4112, 4160 or 4224 bytes?

No. Dm-crypt supports only power of two blocks, up to 4k (IOW: 512, 1024, 2048, 4096 bytes).
(Not more, because of compatible page size - this could be fixed in future though.)

The 520 hw sector is usually 512 + 8 bytes for DIF (data integrity field).
We can emulate something similar with dm-integrity, but the data section (input to encryption)
must be always as specified above (rest is in integrity bio section).

Milan
