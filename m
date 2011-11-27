From: Milan Broz <mbroz@redhat.com>
Subject: Re: [dm-devel] [PATCH 17/62] md: remove the second argument of k[un]map_atomic()
Date: Sun, 27 Nov 2011 11:27:27 +0100
Message-ID: <4ED2108F.9000203@redhat.com>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com> <1322371662-26166-18-git-send-email-amwang@redhat.com> <20111127170013.20d180a9@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111127170013.20d180a9@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: NeilBrown <neilb@suse.de>, Cong Wang <amwang@redhat.com>, linux-raid@vger.kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On 11/27/2011 07:00 AM, NeilBrown wrote:
> On Sun, 27 Nov 2011 13:26:57 +0800 Cong Wang <amwang@redhat.com> wrote:
> 
>>
>> Signed-off-by: Cong Wang <amwang@redhat.com>
> 
> This and patch 57/62
> 
>  Acked-by: NeilBrown <neilb@suse.de>
> 
> thanks.
> 
> Not sure why there are two separate patches to md/bitmap.c though...
> 
> ... and I cannot offically 'ack' the dm-crypt.c parts of this as I'm not the
>     maintainer.  'md' and 'dm' are separate systems in the same directory -
>     confusing, isn't it :-(

These little walled gardens ... :)

I hope I can ack that dm-crypt code, I added that chunk
as part of loop-aes compatibility code.
(Anyway Alasdair as dm maintainer should ack it too.)

Acked-by: Milan Broz <mbroz@redhat.com>


>> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
>> index 8c2a000..db6b516 100644
>> --- a/drivers/md/dm-crypt.c
>> +++ b/drivers/md/dm-crypt.c
>> @@ -590,9 +590,9 @@ static int crypt_iv_lmk_gen(struct crypt_config *cc, u8 *iv,
>>  	int r = 0;
>>  
>>  	if (bio_data_dir(dmreq->ctx->bio_in) == WRITE) {
>> -		src = kmap_atomic(sg_page(&dmreq->sg_in), KM_USER0);
>> +		src = kmap_atomic(sg_page(&dmreq->sg_in));
>>  		r = crypt_iv_lmk_one(cc, iv, dmreq, src + dmreq->sg_in.offset);
>> -		kunmap_atomic(src, KM_USER0);
>> +		kunmap_atomic(src);
>>  	} else
>>  		memset(iv, 0, cc->iv_size);
>>  
>> @@ -608,14 +608,14 @@ static int crypt_iv_lmk_post(struct crypt_config *cc, u8 *iv,
>>  	if (bio_data_dir(dmreq->ctx->bio_in) == WRITE)
>>  		return 0;
>>  
>> -	dst = kmap_atomic(sg_page(&dmreq->sg_out), KM_USER0);
>> +	dst = kmap_atomic(sg_page(&dmreq->sg_out));
>>  	r = crypt_iv_lmk_one(cc, iv, dmreq, dst + dmreq->sg_out.offset);
>>  
>>  	/* Tweak the first block of plaintext sector */
>>  	if (!r)
>>  		crypto_xor(dst + dmreq->sg_out.offset, iv, cc->iv_size);
>>  
>> -	kunmap_atomic(dst, KM_USER0);
>> +	kunmap_atomic(dst);
>>  	return r;
>>  }
>>  
