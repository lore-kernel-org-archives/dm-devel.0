Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7FDDC433FE
	for <dm-devel@archiver.kernel.org>; Tue,  8 Nov 2022 14:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667919130;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=WmenWpFhMA2vmVZol27FpIF92UNQEQ4hES53dWtTgXo=;
	b=gWY2yt+mfc6MUxXN5NmlthOgtRGJMi9WTxGuN+BMuwwu1KTG79WeKPbw6JEXrWLuHa7tLS
	QV6dUNbJasZ0Yg2fzxt4PiPFbGi3RN/LHK31ihtRY8Z4BMq6u3sMSTVo34/081enmIsISz
	iRbG9wEwmfpJ53C0WOZuGULezewfq60=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-480-KsjRXrErOZa8t50sHyqQOg-1; Tue, 08 Nov 2022 09:52:09 -0500
X-MC-Unique: KsjRXrErOZa8t50sHyqQOg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6079088B7BF;
	Tue,  8 Nov 2022 14:52:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D110940C94AD;
	Tue,  8 Nov 2022 14:52:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A1461194658F;
	Tue,  8 Nov 2022 14:52:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EC1981946588
 for <dm-devel@listman.corp.redhat.com>; Tue,  8 Nov 2022 14:52:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CC7934B3FC6; Tue,  8 Nov 2022 14:52:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C56174B3FC8
 for <dm-devel@redhat.com>; Tue,  8 Nov 2022 14:52:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A97A585A5A6
 for <dm-devel@redhat.com>; Tue,  8 Nov 2022 14:52:02 +0000 (UTC)
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com
 [209.85.218.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-663-5qVjefL9PZKq_z6rAP7D-A-1; Tue, 08 Nov 2022 09:51:58 -0500
X-MC-Unique: 5qVjefL9PZKq_z6rAP7D-A-1
Received: by mail-ej1-f51.google.com with SMTP id b2so39249024eja.6;
 Tue, 08 Nov 2022 06:51:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=VVlX3J2MRZ0bpfrT1wqBoqQdfnyP5OOMorGU3/AIj0Q=;
 b=Vzp1QkbdTnEeIbFth+lcEFn0Kaz+FnWheUqnn53+ZTM8ZstulF+432p18W6wEvPI9D
 4KRCA9v0AwVciEp47lZqvUfBPnPiBFQJcYSTq7Fyqmw2fZEXmODS1Dz6JkQjloZCHHoa
 Vtk/BXZw/0wCg5vgYmb+leWt6kPRTx6JdGQ8zHoyL+mGA2HKUb894x9spA4mK5T4UrD+
 hEUzkmvQ3P8dEWqFC/hgBPFlPxe0ySy1ulyUM6ZJbwlXzxlUucIu+SARCE5NpUye+0+Q
 Xg6qwRDkxOZ1ZgjzD3D0DWh6wVdSXoRjbeFvjbMWE9AM21HvBHSNJYSlfFntVnNLFYDq
 qG0w==
X-Gm-Message-State: ACrzQf3iKgepquDzZ09PfbgZjBfyf51939SXTQMf3g1VjajmbK0tLLlJ
 5nYCETa9ydoohHaxkeEzLQy+B4fo6pY=
X-Google-Smtp-Source: AMsMyM5lBicYYShK82H77NBIMdHdrcaJuLKtsrgoguKRMcBe5j9fGhygFlfXYP9tHF1v92hrcjZ5/A==
X-Received: by 2002:a17:906:195b:b0:7ae:108:9729 with SMTP id
 b27-20020a170906195b00b007ae01089729mr33254321eje.604.1667919114796; 
 Tue, 08 Nov 2022 06:51:54 -0800 (PST)
Received: from [147.251.42.107] (nbbroz2.fi.muni.cz. [147.251.42.107])
 by smtp.gmail.com with ESMTPSA id
 s18-20020aa7c552000000b00461c1804cdasm5663142edr.3.2022.11.08.06.51.53
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 08 Nov 2022 06:51:53 -0800 (PST)
Message-ID: <31526702-6b27-b1e1-be80-4ffb7b42647a@gmail.com>
Date: Tue, 8 Nov 2022 15:51:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
To: Coiby Xu <coxu@redhat.com>, dm-devel@redhat.com
References: <20221107122233.261096-1-coxu@redhat.com>
From: Milan Broz <gmazyland@gmail.com>
In-Reply-To: <20221107122233.261096-1-coxu@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH] dm-crypt: fix incorrect use of strcmp when
 telling if there is no key
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
Cc: Mike Snitzer <snitzer@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 11/7/22 13:22, Coiby Xu wrote:
> strcmp returns 0 when two strings are equal.
> 
> Fixes: 69a8cfcda210 ("dm crypt: set key size early")
> Signed-off-by: Coiby Xu <coxu@redhat.com>
> ---
>   drivers/md/dm-crypt.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index 159c6806c19b..cfefe0f18150 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -2590,7 +2590,7 @@ static int crypt_set_key(struct crypt_config *cc, char *key)
>   	int key_string_len = strlen(key);
>   
>   	/* Hyphen (which gives a key_size of zero) means there is no key. */
> -	if (!cc->key_size && strcmp(key, "-"))
> +	if (!cc->key_size && !strcmp(key, "-"))
>   		goto out;

NACK. The code is correct.

The comment is a little bit misleading - it actually says that "-" is valid here.

If key_size is 0 (see above: key_size = strlen(key) >> 1;)  and key
is NOT "-" (empty key) return error.

Key "-" is a valid key, means no key used (used for null cipher).

Try this with and without your patch (it uses null cipher that takes no key):

dmsetup create test --table "0 8 crypt cipher_null-ecb - 0 /dev/sdb 0"

With your patch it no longer works.

Please, run cryptsetup testsuite before sending patches, tests/mode-tests fails
immediately with your patch!

Thanks,
Milan

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

