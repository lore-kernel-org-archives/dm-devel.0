From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [dm-devel] [dm-crypt] [RFC PATCH 1/1] Add DM_CRYPT_FORCE_INLINE
 flag to dm-crypt target
Date: Wed, 24 Jun 2020 07:24:46 +0000
Message-ID: <CY4PR04MB37510A3565060D9243607A80E7950@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200619164132.1648-1-ignat@cloudflare.com>
 <20200619164132.1648-2-ignat@cloudflare.com>
 <20200624050452.GB844@sol.localdomain>
 <CY4PR04MB37515EB3C74CCAE2A006202FE7950@CY4PR04MB3751.namprd04.prod.outlook.com>
 <20200624052739.GC844@sol.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Biggers <ebiggers@kernel.org>
Cc: Ignat Korchagin <ignat@cloudflare.com>, "snitzer@redhat.com" <snitzer@redhat.com>, "kernel-team@cloudflare.com" <kernel-team@cloudflare.com>, "dm-crypt@saout.de" <dm-crypt@saout.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "agk@redhat.com" <agk@redhat.com>
List-Id: dm-devel.ids

On 2020/06/24 14:27, Eric Biggers wrote:=0A=
> On Wed, Jun 24, 2020 at 05:21:24AM +0000, Damien Le Moal wrote:=0A=
>>>> @@ -1458,13 +1459,18 @@ static void crypt_alloc_req_skcipher(struct cr=
ypt_config *cc,=0A=
>>>>  =0A=
>>>>  	skcipher_request_set_tfm(ctx->r.req, cc->cipher_tfm.tfms[key_index])=
;=0A=
>>>>  =0A=
>>>> -	/*=0A=
>>>> -	 * Use REQ_MAY_BACKLOG so a cipher driver internally backlogs=0A=
>>>> -	 * requests if driver request queue is full.=0A=
>>>> -	 */=0A=
>>>> -	skcipher_request_set_callback(ctx->r.req,=0A=
>>>> -	    CRYPTO_TFM_REQ_MAY_BACKLOG,=0A=
>>>> -	    kcryptd_async_done, dmreq_of_req(cc, ctx->r.req));=0A=
>>>> +	if (test_bit(DM_CRYPT_FORCE_INLINE, &cc->flags))=0A=
>>>> +		/* make sure we zero important fields of the request */=0A=
>>>> +		skcipher_request_set_callback(ctx->r.req,=0A=
>>>> +	        0, NULL, NULL);=0A=
>>>> +	else=0A=
>>>> +		/*=0A=
>>>> +		 * Use REQ_MAY_BACKLOG so a cipher driver internally backlogs=0A=
>>>> +		 * requests if driver request queue is full.=0A=
>>>> +		 */=0A=
>>>> +		skcipher_request_set_callback(ctx->r.req,=0A=
>>>> +	        CRYPTO_TFM_REQ_MAY_BACKLOG,=0A=
>>>> +	        kcryptd_async_done, dmreq_of_req(cc, ctx->r.req));=0A=
>>>>  }=0A=
>>>=0A=
>>> This looks wrong.  Unless type=3D0 and mask=3DCRYPTO_ALG_ASYNC are pass=
ed to=0A=
>>> crypto_alloc_skcipher(), the skcipher implementation can still be async=
hronous,=0A=
>>> in which case providing a callback is required.=0A=
=0A=
Digging the code further, in light of your hints, it looks like to fix this=
, all=0A=
that needs to be done is to change crypt_convert_block_skcipher() from doin=
g:=0A=
=0A=
	if (bio_data_dir(ctx->bio_in) =3D=3D WRITE)=0A=
		r =3D crypto_skcipher_encrypt(req);=0A=
	else=0A=
		r =3D crypto_skcipher_decrypt(req);=0A=
=0A=
to do something like:=0A=
=0A=
	struct crypto_wait wait;=0A=
=0A=
	...=0A=
=0A=
	if (bio_data_dir(ctx->bio_in) =3D=3D WRITE) {=0A=
		if (test_bit(DM_CRYPT_FORCE_INLINE_WRITE, &cc->flags))=0A=
			r =3D crypto_wait_req(crypto_skcipher_encrypt(req),=0A=
					    &wait);=0A=
		else=0A=
			r =3D crypto_skcipher_encrypt(req);=0A=
	} else {=0A=
		if (test_bit(DM_CRYPT_FORCE_INLINE_READ, &cc->flags))=0A=
=0A=
=0A=
			r =3D crypto_wait_req(crypto_skcipher_decrypt(req),=0A=
					    &wait);=0A=
		else=0A=
			r =3D crypto_skcipher_decrypt(req);=0A=
	}=0A=
=0A=
Doing so, crypt_convert_block_skcipher() cannot return -EBUSY nor -EINPROGR=
ESS=0A=
for inline IOs, leading to crypt_convert() to see synchronous completions, =
as=0A=
expected for inline case. The above likely does not add much overhead at al=
l for=0A=
synchronous skcipher/accelerators, and handles asynchronous ones as if they=
 were=0A=
synchronous. Would this be correct ?=0A=
=0A=
=0A=
=0A=
>>>=0A=
>>> Do you intend that the "force_inline" option forces the use of a synchr=
onous=0A=
>>> skcipher (alongside the other things it does)?  Or should it still allo=
w=0A=
>>> asynchronous ones?=0A=
>>>=0A=
>>> We may not actually have a choice in that matter, since xts-aes-aesni h=
as the=0A=
>>> CRYPTO_ALG_ASYNC bit set (as I mentioned) despite being synchronous in =
most=0A=
>>> cases; thus, the crypto API won't give you it if you ask for a synchron=
ous=0A=
>>> cipher.  So I think you still need to allow async skciphers?  That mean=
s a=0A=
>>> callback is still always required.=0A=
>>=0A=
>> Arg... So it means that some skciphers will not be OK at all for SMR wri=
tes. I=0A=
>> was not aware of these differences (tested with aes-xts-plain64 only). T=
he ugly=0A=
>> way to support async ciphers would be to just wait inline for the crypto=
 API to=0A=
>> complete using a completion for instance. But that is very ugly. Back to=
=0A=
>> brainstorming, and need to learn more about the crypto API...=0A=
>>=0A=
> =0A=
> It's easy to wait for crypto API requests to complete if you need to --=
=0A=
> just use crypto_wait_req().=0A=
> =0A=
> We do this in fs/crypto/, for example.  (Not many people are using fscryp=
t with=0A=
> crypto API based accelerators, so there hasn't yet been much need to supp=
ort the=0A=
> complexity of issuing multiple async crypto requests like dm-crypt suppor=
ts.)=0A=
> =0A=
> - Eric=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
