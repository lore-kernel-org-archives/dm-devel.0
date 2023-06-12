Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FE22C7EE2E
	for <dm-devel@archiver.kernel.org>; Mon, 12 Jun 2023 17:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686591918;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=daHBPIii8DWoRLfEO62s9h6W3GRS3JPKNvL6iRTlITw=;
	b=ANN81Oz1lf5765bNHsjBPIVIwm3x/9g8PcYT+3iW9r+eS3lVzAQ5BFrRHtF1MVw3ZHPCTu
	LR+Yh6yaSbuq8C/vfakRH7aWrwwycanWwBSWqUirB2f2Jrv4cwgxqn3gOk0x/p7/pF0QAR
	lC/CUaQsUNsNJVrdr1ZFThOhkX8ANiQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-456-6Q1PqZ7aNHanfP8TJH9EjQ-1; Mon, 12 Jun 2023 13:45:16 -0400
X-MC-Unique: 6Q1PqZ7aNHanfP8TJH9EjQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6985A185A7A7;
	Mon, 12 Jun 2023 17:45:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9FBE6C1604C;
	Mon, 12 Jun 2023 17:45:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5EE2819465B6;
	Mon, 12 Jun 2023 17:45:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CF631194658C
 for <dm-devel@listman.corp.redhat.com>; Mon, 12 Jun 2023 17:45:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BD1DD2166B28; Mon, 12 Jun 2023 17:45:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7AC362166B25
 for <dm-devel@redhat.com>; Mon, 12 Jun 2023 17:45:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5B17A1C01E85
 for <dm-devel@redhat.com>; Mon, 12 Jun 2023 17:45:09 +0000 (UTC)
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com
 [209.85.167.174]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-175-TMcyB82sML-kX7fL3VFkLQ-1; Mon, 12 Jun 2023 13:45:07 -0400
X-MC-Unique: TMcyB82sML-kX7fL3VFkLQ-1
Received: by mail-oi1-f174.google.com with SMTP id
 5614622812f47-39cc64e4a22so1066867b6e.3
 for <dm-devel@redhat.com>; Mon, 12 Jun 2023 10:45:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686591907; x=1689183907;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=RAlb9volQIGj45ZSIOc8zo0X80J8Ja06Rm5bQqeTV0A=;
 b=JJm8ACRqAeLyLclHQq1FGLJcEOtx7/s7dx8JhEIa99CkDvcVL6gRLKcvNhSoOzj6ms
 UPOkgu8oakaSRH8SN2nPqVgVK3EYg0wfHa3EP6gjuiFKGS5AFgjkEyMVRWd4iIBNqL/V
 TT2DNz8270cDGRLnPNzUn8QKssSKbOyxUcdqd5np2OHog8eozuES3DV2rzIDhtAsIFFq
 le9EULY+2AFw7cdfcyKjLKaGuoeM4JkJRPCo8mh8iVqApIfW8JEjKBvUy3mHy+Bzjloz
 BEw0AREpidDXG3pAbAMtytQz29Z6N8vmBlZfWTuBZHRWWLqM9+YY9gJTJyMDLRlePVm5
 IC5Q==
X-Gm-Message-State: AC+VfDwdLwQyb+rBkyIjpVJHzIVea0KVHo4C/SWSX+kxbjbCUD0dk7hs
 wU90D7NQIiuSm3m43w8hJaU=
X-Google-Smtp-Source: ACHHUZ4ZxRGPjrlBLv4O9Uv924tulj6XNcgslKjQVlxjFSao0rsSaIgHq9oGc4KzfAb/8oKZPxwYHQ==
X-Received: by 2002:a54:4805:0:b0:39a:ba1d:89a9 with SMTP id
 j5-20020a544805000000b0039aba1d89a9mr4341090oij.46.1686591906497; 
 Mon, 12 Jun 2023 10:45:06 -0700 (PDT)
Received: from [192.168.3.219] ([98.51.102.78])
 by smtp.gmail.com with ESMTPSA id
 g3-20020a17090a3c8300b0024e33c69ee5sm7664051pjc.5.2023.06.12.10.45.05
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 12 Jun 2023 10:45:05 -0700 (PDT)
Message-ID: <a663fc71-3a06-f4bf-8451-1fbee328c2b6@acm.org>
Date: Mon, 12 Jun 2023 10:45:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
To: Eric Biggers <ebiggers@kernel.org>, linux-block@vger.kernel.org
References: <20230610061139.212085-1-ebiggers@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230610061139.212085-1-ebiggers@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH] blk-crypto: use dynamic lock class for
 blk_crypto_profile::lock
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
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: acm.org
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 6/9/23 23:11, Eric Biggers wrote:
> When a device-mapper device is passing through the inline encryption
> support of an underlying device, calls to blk_crypto_evict_key() take
> the blk_crypto_profile::lock of the device-mapper device, then take the
> blk_crypto_profile::lock of the underlying device (nested).  This isn't
> a real deadlock, but it causes a lockdep report because there is only
> one lock class for all instances of this lock.
> 
> Lockdep subclasses don't really work here because the hierarchy of block
> devices is dynamic and could have more than 2 levels.
> 
> Instead, register a dynamic lock class for each blk_crypto_profile, and
> associate that with the lock.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

