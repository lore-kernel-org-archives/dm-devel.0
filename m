Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 259B7C7EE23
	for <dm-devel@archiver.kernel.org>; Thu,  1 Jun 2023 19:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685646629;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=++wnEBLydvmco7YG5vZEd3C1BpJfpRU9NsVFBdjWAuE=;
	b=CPqSaxWPEmOgB+H/qLzzAhV1oRoQgPeLiZISS281uTKxXi/VZo7f0tOFMtoumM1J5RelDJ
	NyZq8eAKWzPpax7bfmSYREySgAhrplluVCn6BmMXo9jPzqdLkerQc4BpCzglq7mDTjJfI8
	j+LrlpUKPY3dmV6nsuOPdC2RnbWouT4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-567-Naqqk7T9M4yNAx6hlFqYYA-1; Thu, 01 Jun 2023 15:10:27 -0400
X-MC-Unique: Naqqk7T9M4yNAx6hlFqYYA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E51BC1C01E99;
	Thu,  1 Jun 2023 19:10:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D7657C15474;
	Thu,  1 Jun 2023 19:10:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9E3C91946595;
	Thu,  1 Jun 2023 19:10:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CE31B194658C
 for <dm-devel@listman.corp.redhat.com>; Thu,  1 Jun 2023 19:10:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B9F022166B27; Thu,  1 Jun 2023 19:10:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B19E32166B25
 for <dm-devel@redhat.com>; Thu,  1 Jun 2023 19:10:22 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 95438811E7F
 for <dm-devel@redhat.com>; Thu,  1 Jun 2023 19:10:22 +0000 (UTC)
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com
 [209.85.219.49]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-65-CWvZh6yZNoa8t-oz8OyAIA-1; Thu, 01 Jun 2023 15:10:20 -0400
X-MC-Unique: CWvZh6yZNoa8t-oz8OyAIA-1
Received: by mail-qv1-f49.google.com with SMTP id
 6a1803df08f44-626195b4909so11056816d6.0
 for <dm-devel@redhat.com>; Thu, 01 Jun 2023 12:10:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685646620; x=1688238620;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=hm7Jjh9TF3Bsq+esRbEZ2y936YTbpq5qnxQF0w6eX7M=;
 b=AhnQGEdYydmVchOzNJ+RvChM8DE8n68O4wj2jj7/+nPIzOzXEGTu60iHdnWAteSIzR
 5JPaIWD6g35spWIGFU7We/6bcEVePOkIHR4XMQPqcLyXN0iiiQHN9V1s2uuUkbyAfMdg
 9XKwRqpq4XX1iypvhLgu/PwnonxQv6iQP64C2+UqxhTq3IksOS2rY77xRkcreDSmHhb5
 OyJdeDf+wCjFXIUS7QKoivh8Zz2IQlL6L6IGNb+zdb4z76zZL5MQ8HmMwbgzsqbAvVOc
 6QKbY+ufJDifYYkmNVUFuWAil+ZkIRtf/Ngq1Wafvj7YfC6l43Aoklo7slbfkDr0opv7
 33zg==
X-Gm-Message-State: AC+VfDzGJ43Gj+9G1z6c9RkSgz349UKo65ZxSfXxWgr90lHYSpSHMnRH
 mqUqwMl68zvuaMplBlEnbqhEo4M=
X-Google-Smtp-Source: ACHHUZ7bZ4cyi3vQcWjCBhem09VoTvBAo4ZBUsrNepalRX5b0TnPcFZq7rotFJybrs3TC5fTvPZnGQ==
X-Received: by 2002:a05:6214:1bcb:b0:628:3e37:e175 with SMTP id
 m11-20020a0562141bcb00b006283e37e175mr6190986qvc.25.1685646620329; 
 Thu, 01 Jun 2023 12:10:20 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 mn6-20020a0562145ec600b0060530c942f4sm7830403qvb.46.2023.06.01.12.10.19
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 01 Jun 2023 12:10:19 -0700 (PDT)
Date: Thu, 1 Jun 2023 15:10:18 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Message-ID: <ZHjtGvf+gHxeV83V@redhat.com>
References: <ZHhbL+SbWRnTW4b7@gondor.apana.org.au>
MIME-Version: 1.0
In-Reply-To: <ZHhbL+SbWRnTW4b7@gondor.apana.org.au>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] dm crypt: Avoid using MAX_CIPHER_BLOCKSIZE
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Jun 01 2023 at  4:47P -0400,
Herbert Xu <herbert@gondor.apana.org.au> wrote:

> MAX_CIPHER_BLOCKSIZE is an internal implementation detail and should
> not be relied on by users of the Crypto API.
> 
> Instead of storing the IV on the stack, allocate it together with
> the crypto request.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
> 
>  drivers/md/dm-crypt.c |   15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index 40cb1719ae4d..0e7e443dde11 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -31,10 +31,10 @@
>  #include <asm/unaligned.h>
>  #include <crypto/hash.h>
>  #include <crypto/md5.h>
> -#include <crypto/algapi.h>
>  #include <crypto/skcipher.h>
>  #include <crypto/aead.h>
>  #include <crypto/authenc.h>
> +#include <crypto/utils.h>
>  #include <linux/rtnetlink.h> /* for struct rtattr and RTA macros only */
>  #include <linux/key-type.h>
>  #include <keys/user-type.h>
> @@ -743,16 +743,23 @@ static int crypt_iv_eboiv_ctr(struct crypt_config *cc, struct dm_target *ti,
>  static int crypt_iv_eboiv_gen(struct crypt_config *cc, u8 *iv,
>  			    struct dm_crypt_request *dmreq)
>  {
> -	u8 buf[MAX_CIPHER_BLOCKSIZE] __aligned(__alignof__(__le64));
> +	struct crypto_skcipher *tfm = any_tfm(cc);
>  	struct skcipher_request *req;
>  	struct scatterlist src, dst;
>  	DECLARE_CRYPTO_WAIT(wait);
> +	unsigned int reqsize;
>  	int err;
> +	u8 *buf;
>  
> -	req = skcipher_request_alloc(any_tfm(cc), GFP_NOIO);
> +	reqsize = ALIGN(crypto_skcipher_reqsize(tfm), __alignof__(__le64));
> +
> +	req = kmalloc(reqsize + cc->iv_size, GFP_NOIO);
>  	if (!req)
>  		return -ENOMEM;
>  
> +	skcipher_request_set_tfm(req, tfm);
> +
> +	buf = (u8 *)req + reqsize;
>  	memset(buf, 0, cc->iv_size);
>  	*(__le64 *)buf = cpu_to_le64(dmreq->iv_sector * cc->sector_size);
>  
> @@ -761,7 +768,7 @@ static int crypt_iv_eboiv_gen(struct crypt_config *cc, u8 *iv,
>  	skcipher_request_set_crypt(req, &src, &dst, cc->iv_size, buf);
>  	skcipher_request_set_callback(req, 0, crypto_req_done, &wait);
>  	err = crypto_wait_req(crypto_skcipher_encrypt(req), &wait);
> -	skcipher_request_free(req);
> +	kfree_sensitive(req);
>  
>  	return err;
>  }


Strikes me as strange that open-coding skcipher_request_{alloc,free}
is ideal, but dm-crypt is the only non-crypto consumer of
MAX_CIPHER_BLOCKSIZE so really not worth standing up yet another
interface wrapper.

Anyway, this code is certainly better for dm-crypt's needs.  I'm happy
with you applying this change via your crypto tree.

Reviewed-by: Mike Snitzer <snitzer@kernel.org>

Thanks.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

