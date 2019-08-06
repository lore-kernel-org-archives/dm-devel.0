From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [RFC PATCH 2/2] md/dm-crypt - switch to AES library
	for EBOIV
Date: Tue, 6 Aug 2019 15:19:34 +0200
Message-ID: <922068a1-6123-b4b6-fe2e-d453c28c45dd@gmail.com>
References: <20190806080234.27998-1-ard.biesheuvel@linaro.org>
	<20190806080234.27998-3-ard.biesheuvel@linaro.org>
	<22f5bfd5-7563-b85b-925e-6d46e7584966@gmail.com>
	<CAKv+Gu_LQwtM47njiksCJL2tMx_Zv8Paoegfkah--T6Mh55u3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAKv+Gu_LQwtM47njiksCJL2tMx_Zv8Paoegfkah--T6Mh55u3A@mail.gmail.com>
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
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Milan Broz <gmazyland@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Mike Snitzer <snitzer@redhat.com>, Eric Biggers <ebiggers@kernel.org>, device-mapper development <dm-devel@redhat.com>, "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On 06/08/2019 14:17, Ard Biesheuvel wrote:
> On Tue, 6 Aug 2019 at 13:43, Milan Broz <gmazyland@gmail.com> wrote:
>>
>> On 06/08/2019 10:02, Ard Biesheuvel wrote:
>>> The EBOIV IV mode reuses the same AES encryption key that is used for
>>> encrypting the data, and uses it to perform a single block encryption
>>> of the byte offset to produce the IV.
>>>
>>> Since table-based AES is known to be susceptible to known-plaintext
>>> attacks on the key, and given that the same key is used to encrypt
>>> the byte offset (which is known to an attacker), we should be
>>> careful not to permit arbitrary instantiations where the allocated
>>> AES cipher is provided by aes-generic or other table-based drivers
>>> that are known to be time variant and thus susceptible to this kind
>>> of attack.
>>>
>>> Instead, let's switch to the new AES library, which has a D-cache
>>> footprint that is only 1/32th of the generic AES driver, and which
>>> contains some mitigations to reduce the timing variance even further.
>>
>> NACK.
>>
>> We discussed here that we will not limit combinations inside dm-crypt.
>> For generic crypto API, this policy should be different, but I really
>> do not want these IVs to be visible outside of dm-crypt.
>>
>> Allowing arbitrary combinations of a cipher, mode, and IV is how dm-crypt
>> works since the beginning, and I really do not see the reason to change it.
>>
>> This IV mode is intended to be used for accessing old BitLocker images,
>> so I do not care about performance much.
>>
> 
> Apologies for being blunt, but you are basically driving home the
> point I made before about why the cipher API should become internal to
> the crypto subsystem.
> 
> Even though EBOIV is explicitly only intended for accessing old
> BitLocker images, you prioritize non-functional properties like API
> symmetry and tradition over sound cryptographic engineering practice,
> even after I pointed out to you that
> a) the way EBOIV uses the same symmetric key for two different
> purposes is a bad idea in general, and
> b) table based AES in particular is a hazard for this mode, since the
> way the IV is generated is susceptible to exactly the attack that
> table based AES is most criticized for.
> 
> So if you insist on supporting EBOIV in combination with arbitrary
> skciphers or AEADs (or AES on systems where crypto_alloc_cipher()
> produces a table based AES driver), how do you intend to mitigate
> these issues?
 I am not going to mitigate these. We will never format new devices
using these exotic configurations. And if user enforces it, there can be
a reason - or it is just stupid, like using cipher_null.
(Which is entirely insecure but very useful for testing.)

The IV concept in dm-crypt is straightforward and allows many insecure
and obscure combinations (aes-ecb-null, for example - and this is used
for millions of chipset encrypted drivers, people used it to access through
dmcrypt without the USB bridge.) The same applies for obscure cryptloop
image combinations. (I would better spent time to remove cryptoloop,
it is much worse that what we are discussing here :)

So I see no reason to spend hours and hours attacks for devices
that use crypto that is obsolete anyway (all new drives use XTS).

I would like to provide way to access data on existing, maybe obsolete and insecure,
encrypted images from foreign OSes.

But all that said is meant in the isolated context of dm-crypt driver,
if you want to provide generic API, it perhaps makes sense to enforce such a policy.

I understand you want to propose more secure ways of implementing crypto,
but then - if you decide to remove existing API I used, we can switch to something better.
(Is there something better except AES-only lib you used?)

I just disagree with adding various checks for cipher/mode/iv combinations inside dm-crypt.
It was meant to be configurable from userspace.

Milan
