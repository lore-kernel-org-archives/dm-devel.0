From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH v2] dm crypt: add flags to optionally bypass dm-crypt
 workqueues
Date: Tue, 30 Jun 2020 03:45:48 +0000
Message-ID: <CY4PR04MB37518C4BF580DABEDB1BD8F2E76F0@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200626210302.1813-1-ignat@cloudflare.com>
 <CY4PR04MB375127DC313F70875CAAC841E76F0@CY4PR04MB3751.namprd04.prod.outlook.com>
 <20200630030944.GA20706@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ignat Korchagin <ignat@cloudflare.com>, "agk@redhat.com" <agk@redhat.com>, "snitzer@redhat.com" <snitzer@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "dm-crypt@saout.de" <dm-crypt@saout.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "ebiggers@kernel.org" <ebiggers@kernel.org>, "mpatocka@redhat.com" <mpatocka@redhat.com>, "kernel-team@cloudflare.com" <kernel-team@cloudflare.com>
List-Id: dm-devel.ids

On 2020/06/30 12:09, Herbert Xu wrote:=0A=
> On Tue, Jun 30, 2020 at 02:51:17AM +0000, Damien Le Moal wrote:=0A=
>>=0A=
>>> @@ -1463,12 +1465,12 @@ static void crypt_alloc_req_skcipher(struct cry=
pt_config *cc,=0A=
>>>  	 * requests if driver request queue is full.=0A=
>>>  	 */=0A=
>>>  	skcipher_request_set_callback(ctx->r.req,=0A=
>>> -	    CRYPTO_TFM_REQ_MAY_BACKLOG,=0A=
>>> +	    nobacklog ? 0 : CRYPTO_TFM_REQ_MAY_BACKLOG,=0A=
>>>  	    kcryptd_async_done, dmreq_of_req(cc, ctx->r.req));=0A=
>>=0A=
>> Will not specifying CRYPTO_TFM_REQ_MAY_BACKLOG always cause the crypto A=
PI to=0A=
>> return -EBUSY ? From the comment above the skcipher_request_set_callback=
(), it=0A=
>> seems that this will be the case only if the skcipher diver queue is ful=
l. So in=0A=
>> other word, keeping the kcryptd_async_done() callback and executing the =
skcipher=0A=
>> request through crypt_convert() and crypt_convert_block_skcipher() may s=
till end=0A=
>> up being an asynchronous operation. Can you confirm this and is it what =
you=0A=
>> intended to implement ?=0A=
> =0A=
> The purpose of MAY_BACKLOG is to make the crypto request reliable.=0A=
> It has nothing to do with whether the request will be synchronous=0A=
> or not.=0A=
> =0A=
> Without the backlog flag, if the hardware queue is full the request=0A=
> will simply be dropped, which is appropriate in the network stack=0A=
> with IPsec where congestion can be dealt with at the source.=0A=
> =0A=
> Block layer on the other hand should always use the backlog flag=0A=
> and stop sending more requests to the crypto API until the congestion=0A=
> goes away.=0A=
=0A=
OK. Thanks for the information. So it sounds like this patch still needs so=
me=0A=
more fixes.=0A=
=0A=
> =0A=
> Cheers,=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
