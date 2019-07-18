From: Milan Broz <gmazyland@gmail.com>
Subject: Re: xts fuzz testing and lack of ciphertext stealing
	support
Date: Thu, 18 Jul 2019 09:40:11 +0200
Message-ID: <36e78459-1594-6d19-0ab4-95b03a6de036@gmail.com>
References: <VI1PR0402MB34858E4EF0ACA7CDB446FF5798CE0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
	<20190716221639.GA44406@gmail.com>
	<VI1PR0402MB34857BBB18C2BB8CBA2DEC7198C90@VI1PR0402MB3485.eurprd04.prod.outlook.com>
	<20190717172823.GA205944@gmail.com>
	<CAKv+Gu__offPaWvyURJr8v56ig58q-Deo16QhP26EJ32uf5m3w@mail.gmail.com>
	<20190718065223.4xaefcwjoxvujntw@gondor.apana.org.au>
	<CAKv+Gu9-EWNpJ9viSsjhYRdOZb=7a=Mpddmyt8SLEq9aFtawjg@mail.gmail.com>
	<20190718072154.m2umem24x4grbf6w@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190718072154.m2umem24x4grbf6w@gondor.apana.org.au>
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
To: Herbert Xu <herbert@gondor.apana.org.au>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, Horia Geanta <horia.geanta@nxp.com>
List-Id: dm-devel.ids

On 18/07/2019 09:21, Herbert Xu wrote:
> On Thu, Jul 18, 2019 at 09:15:39AM +0200, Ard Biesheuvel wrote:
>>
>> Not just the generic implementation: there are numerous synchronous
>> and asynchronous implementations of xts(aes) in the kernel that would
>> have to be fixed, while there are no in-kernel users that actually
>> rely on CTS. Also, in the cbc case, we support CTS by wrapping it into
>> another template, i.e., cts(cbc(aes)).
>>
>> So retroactively redefining what xts(...) means seems like a bad idea
>> to me. If we want to support XTS ciphertext stealing for the benefit
>> of userland, let's do so via the existing cts template, and add
>> support for wrapping XTS to it.
> 
> XTS without stealing should be renamed as XEX.  Sure you can then
> wrap it inside cts to form xts but the end result needs to be called
> xts.

While I fully agree here from the technical point of view,
academically XEX, XEX* is a different mode.
It would create even more confusion.

Couldn't resist, but this is a nice example of what happens when academic,
standardization, and reality meets in one place :)

XTS is already implemented in gcrypt and OpenSSL.
IMO all the implementation should be exactly the same.

I agree with Herbert that the proper way is to implement ciphertext stealing.
Otherwise, it is just incomplete implementation, not a redefining XTS mode!

See the reference in generic code - the 3rd line - link to the IEEE standard.
We do not implement it properly - for more than 12 years!

Reality check - nobody in block layer needs ciphertext stealing, we are always
aligned to block. AF_ALG is a different story, though.

Milan
