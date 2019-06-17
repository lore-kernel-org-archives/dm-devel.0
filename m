From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [RFC PATCH 0/3] crypto: switch to shash for ESSIV
	generation
Date: Mon, 17 Jun 2019 19:05:51 +0200
Message-ID: <af1b7ea1-bc98-06ff-e46c-945e6bae20d8@gmail.com>
References: <20190614083404.20514-1-ard.biesheuvel@linaro.org>
	<20190616204419.GE923@sol.localdomain>
	<CAOtvUMf86_TGYLoAHWuRW0Jz2=cXbHHJnAsZhEvy6SpSp_xgOQ@mail.gmail.com>
	<CAKv+Gu_r_WXf2y=FVYHL-T8gFSV6e4TmGkLNJ-cw6UjK_s=A=g@mail.gmail.com>
	<8e58230a-cf0e-5a81-886b-6aa72a8e5265@gmail.com>
	<CAKv+Gu9sb0t6EC=MwVfqTw5TKtatK-c8k3ryNUhV8O0876NV7g@mail.gmail.com>
	<CAKv+Gu-LFShLW-Tt7hwBpni1vQRvv7k+L_bpP-wU86x88v+eRg@mail.gmail.com>
	<90214c3d-55ef-cc3a-3a04-f200d6f96cfd@gmail.com>
	<CAKv+Gu82BLPWrX1UzUBLf7UB+qJT6ZPtkvJ2Sa9t28OpXArhnw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAKv+Gu82BLPWrX1UzUBLf7UB+qJT6ZPtkvJ2Sa9t28OpXArhnw@mail.gmail.com>
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
Cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-fscrypt@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>, Gilad Ben-Yossef <gilad@benyossef.com>, device-mapper development <dm-devel@redhat.com>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
List-Id: dm-devel.ids

On 17/06/2019 16:39, Ard Biesheuvel wrote:
>>
>> In other words, if you add some additional limit, we are breaking backward compatibility.
>> (Despite the configuration is "wrong" from the security point of view.)
>>
> 
> Yes, but breaking backward compatibility only happens if you break
> something that is actually being *used*. So sure,
> xts(aes)-essiv:sha256 makes no sense but people use it anyway. But is
> that also true for, say, gcm(aes)-essiv:sha256 ?

These should not be used.  The only way when ESSIV can combine with AEAD mode
is when you combine length-preserving mode with additional integrity tag, for example

  # cryptsetup luksFormat -c aes-cbc-essiv:sha256 --integrity hmac-sha256 /dev/sdb

it will produce this dm-crypt cipher spec:
  capi:authenc(hmac(sha256),cbc(aes))-essiv:sha256

the authenc(hmac(sha256),cbc(aes)) is direct crypto API cipher composition, the essiv:sha256
IV is processed inside dm-crypt as IV.

So if authenc() composition is problem, then yes, I am afraid these can be used in reality.

But for things like gcm(aes)-essiv:sha256 (IOW real AEAD mode with ESSIV) - these are
not supported by cryptsetup (we support only random IV in this case), so these should
not be used anywhere.

Milan
