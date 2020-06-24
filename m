From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [dm-devel] [dm-crypt] [RFC PATCH 1/1] Add DM_CRYPT_FORCE_INLINE
 flag to dm-crypt target
Date: Wed, 24 Jun 2020 05:21:24 +0000
Message-ID: <CY4PR04MB37515EB3C74CCAE2A006202FE7950@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200619164132.1648-1-ignat@cloudflare.com>
 <20200619164132.1648-2-ignat@cloudflare.com>
 <20200624050452.GB844@sol.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Biggers <ebiggers@kernel.org>, Ignat Korchagin <ignat@cloudflare.com>
Cc: "snitzer@redhat.com" <snitzer@redhat.com>, "kernel-team@cloudflare.com" <kernel-team@cloudflare.com>, "dm-crypt@saout.de" <dm-crypt@saout.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "agk@redhat.com" <agk@redhat.com>
List-Id: dm-devel.ids

On 2020/06/24 14:05, Eric Biggers wrote:=0A=
> On Fri, Jun 19, 2020 at 05:41:32PM +0100, Ignat Korchagin wrote:=0A=
>> Sometimes extra thread offloading imposed by dm-crypt hurts IO latency. =
This is=0A=
>> especially visible on busy systems with many processes/threads. Moreover=
, most=0A=
>> Crypto API implementaions are async, that is they offload crypto operati=
ons on=0A=
>> their own, so this dm-crypt offloading is excessive.=0A=
> =0A=
> This really should say "some Crypto API implementations are async" instea=
d of=0A=
> "most Crypto API implementations are async".=0A=
> =0A=
> Notably, the AES-NI implementation of AES-XTS is synchronous if you call =
it in a=0A=
> context where SIMD instructions are usable.  It's only asynchronous when =
SIMD is=0A=
> not usable.  (This seems to have been missed in your blog post.)=0A=
> =0A=
>> This adds a new flag, which directs dm-crypt not to offload crypto opera=
tions=0A=
>> and process everything inline. For cases, where crypto operations cannot=
 happen=0A=
>> inline (hard interrupt context, for example the read path of the NVME dr=
iver),=0A=
>> we offload the work to a tasklet rather than a workqueue.=0A=
> =0A=
> This patch both removes some dm-crypt specific queueing, and changes decr=
yption=0A=
> to use softIRQ context instead of a workqueue.  It would be useful to kno=
w how=0A=
> much of a difference the workqueue =3D> softIRQ change makes by itself.  =
Such a=0A=
> change could be useful for fscrypt as well.  (fscrypt uses a workqueue fo=
r=0A=
> decryption, but besides that doesn't use any other queueing.)=0A=
> =0A=
>> @@ -127,7 +128,7 @@ struct iv_elephant_private {=0A=
>>   * and encrypts / decrypts at the same time.=0A=
>>   */=0A=
>>  enum flags { DM_CRYPT_SUSPENDED, DM_CRYPT_KEY_VALID,=0A=
>> -	     DM_CRYPT_SAME_CPU, DM_CRYPT_NO_OFFLOAD };=0A=
>> +	     DM_CRYPT_SAME_CPU, DM_CRYPT_NO_OFFLOAD, DM_CRYPT_FORCE_INLINE =3D=
 (sizeof(unsigned long) * 8 - 1) };=0A=
> =0A=
> Assigning a specific enum value isn't necessary.=0A=
> =0A=
>> @@ -1458,13 +1459,18 @@ static void crypt_alloc_req_skcipher(struct cryp=
t_config *cc,=0A=
>>  =0A=
>>  	skcipher_request_set_tfm(ctx->r.req, cc->cipher_tfm.tfms[key_index]);=
=0A=
>>  =0A=
>> -	/*=0A=
>> -	 * Use REQ_MAY_BACKLOG so a cipher driver internally backlogs=0A=
>> -	 * requests if driver request queue is full.=0A=
>> -	 */=0A=
>> -	skcipher_request_set_callback(ctx->r.req,=0A=
>> -	    CRYPTO_TFM_REQ_MAY_BACKLOG,=0A=
>> -	    kcryptd_async_done, dmreq_of_req(cc, ctx->r.req));=0A=
>> +	if (test_bit(DM_CRYPT_FORCE_INLINE, &cc->flags))=0A=
>> +		/* make sure we zero important fields of the request */=0A=
>> +		skcipher_request_set_callback(ctx->r.req,=0A=
>> +	        0, NULL, NULL);=0A=
>> +	else=0A=
>> +		/*=0A=
>> +		 * Use REQ_MAY_BACKLOG so a cipher driver internally backlogs=0A=
>> +		 * requests if driver request queue is full.=0A=
>> +		 */=0A=
>> +		skcipher_request_set_callback(ctx->r.req,=0A=
>> +	        CRYPTO_TFM_REQ_MAY_BACKLOG,=0A=
>> +	        kcryptd_async_done, dmreq_of_req(cc, ctx->r.req));=0A=
>>  }=0A=
> =0A=
> This looks wrong.  Unless type=3D0 and mask=3DCRYPTO_ALG_ASYNC are passed=
 to=0A=
> crypto_alloc_skcipher(), the skcipher implementation can still be asynchr=
onous,=0A=
> in which case providing a callback is required.=0A=
> =0A=
> Do you intend that the "force_inline" option forces the use of a synchron=
ous=0A=
> skcipher (alongside the other things it does)?  Or should it still allow=
=0A=
> asynchronous ones?=0A=
> =0A=
> We may not actually have a choice in that matter, since xts-aes-aesni has=
 the=0A=
> CRYPTO_ALG_ASYNC bit set (as I mentioned) despite being synchronous in mo=
st=0A=
> cases; thus, the crypto API won't give you it if you ask for a synchronou=
s=0A=
> cipher.  So I think you still need to allow async skciphers?  That means =
a=0A=
> callback is still always required.=0A=
=0A=
Arg... So it means that some skciphers will not be OK at all for SMR writes=
. I=0A=
was not aware of these differences (tested with aes-xts-plain64 only). The =
ugly=0A=
way to support async ciphers would be to just wait inline for the crypto AP=
I to=0A=
complete using a completion for instance. But that is very ugly. Back to=0A=
brainstorming, and need to learn more about the crypto API...=0A=
=0A=
> =0A=
> - Eric=0A=
> =0A=
> --=0A=
> dm-devel mailing list=0A=
> dm-devel@redhat.com=0A=
> https://www.redhat.com/mailman/listinfo/dm-devel=0A=
> =0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
