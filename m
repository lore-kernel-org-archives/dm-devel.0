From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH] crypto: mark unused ciphers as obsolete
Date: Sat, 12 Sep 2020 12:05:40 +0200
Message-ID: <ddbf295b-1e02-6553-0d78-5543923ba100@gmail.com>
References: <20200911141103.14832-1-ardb@kernel.org>
 <CY4PR0401MB3652AD749C06D0ACD9F085F3C3240@CY4PR0401MB3652.namprd04.prod.outlook.com>
 <CAMj1kXHOrGoGv6Tse9Vju9mTV_+ks8cUMqx_iSQHPfc+2DVkmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <CAMj1kXHOrGoGv6Tse9Vju9mTV_+ks8cUMqx_iSQHPfc+2DVkmw@mail.gmail.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
To: Ard Biesheuvel <ardb@kernel.org>, "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>, dm-devel@redhat.com
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>, "ebiggers@kernel.org" <ebiggers@kernel.org>
List-Id: dm-devel.ids

On 11/09/2020 18:30, Ard Biesheuvel wrote:
> (cc Milan and dm-devel)
> 
> On Fri, 11 Sep 2020 at 19:24, Van Leeuwen, Pascal
> <pvanleeuwen@rambus.com> wrote:
>>
>>> -----Original Message-----
>>> From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.org> On Behalf Of Ard Biesheuvel
>>> Sent: Friday, September 11, 2020 4:11 PM
>>> To: linux-crypto@vger.kernel.org
>>> Cc: herbert@gondor.apana.org.au; ebiggers@kernel.org; Ard Biesheuvel <ardb@kernel.org>
>>> Subject: [PATCH] crypto: mark unused ciphers as obsolete
>>>
>>> <<< External Email >>>
>>> We have a few interesting pieces in our cipher museum, which are never
>>> used internally, and were only ever provided as generic C implementations.
>>>
>>> Unfortunately, we cannot simply remove this code, as we cannot be sure
>>> that it is not being used via the AF_ALG socket API, however unlikely.
>>> So let's mark the Anubis, Khazad, SEED and TEA algorithms as obsolete,
>>>
>> Wouldn't the IKE deamon be able to utilize these algorithms through the XFRM API?
>> I'm by no means an expert on the subject, but it looks like the cipher template is
>> provided there directly via XFRM, so it does not need to live in the kernel source.
>> And I know for a fact that SEED is being used for IPsec (and TLS) in Korea.
>>
> 
> I have been staring at net/xfrm/xfrm_algo.c, and as far as I can tell,
> algorithms have to be mentioned there in order to be usable. None of
> the ciphers that this patch touches are listed there or anywhere else
> in the kernel.
> 
>> The point being, there are more users to consider beyond "internal" (meaning hard
>> coded in the kernel source in this context?) and AF_ALG.
>>
> 
> That is a good point, actually, since dm-crypt could be affected here
> as well, hence the CCs.
> 
> Milan (or others): are you aware of any of these ciphers being used
> for dm-crypt?

Cryptsetup/dm-crypt can use them (talking about Seed, Khazad, Anubis, TEA), but I think
there is no real use of these.
(IOW these are used only if someone deliberately uses them - manually specifying on format.)

For dm-crypt. there should be no big harm if these are marked obsolete.

Milan
