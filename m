Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CE14C7EE23
	for <dm-devel@archiver.kernel.org>; Wed, 24 May 2023 15:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684940568;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=sVU+SqixsVIxNJpFokN/0j8i3zWdncb4Qf/kfEtYfB8=;
	b=bmcivJj9aIV+HMLmrG14JrNTQmdo8Ed2MUW4vdDwY9kLWdgAjHDJqJUBUrf4Mj0H5e2RCO
	KkyWe8YjEdIrxDRigapU6cT8E/id4tOSFmJJi97e8UrvzCilALPyCKrsvm7xWTo3Z9Jf/R
	3dphMelOuoHov25xM+soX4dsj+XYccU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-157-YCZ4s18hO1-jfyp1VXheQA-1; Wed, 24 May 2023 11:02:46 -0400
X-MC-Unique: YCZ4s18hO1-jfyp1VXheQA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EA17A811E88;
	Wed, 24 May 2023 15:02:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 662937AE4;
	Wed, 24 May 2023 15:02:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 35F6519465A8;
	Wed, 24 May 2023 15:02:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7B1D619465A0
 for <dm-devel@listman.corp.redhat.com>; Wed, 24 May 2023 15:02:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5FB489E60; Wed, 24 May 2023 15:02:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5842F8162
 for <dm-devel@redhat.com>; Wed, 24 May 2023 15:02:15 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3B80180331C
 for <dm-devel@redhat.com>; Wed, 24 May 2023 15:02:15 +0000 (UTC)
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com
 [209.85.166.44]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-550-IcIB2jZoNeSg3lUgaCFmgw-1; Wed, 24 May 2023 11:02:12 -0400
X-MC-Unique: IcIB2jZoNeSg3lUgaCFmgw-1
Received: by mail-io1-f44.google.com with SMTP id
 ca18e2360f4ac-7747f082d98so7924339f.1
 for <dm-devel@redhat.com>; Wed, 24 May 2023 08:02:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1684940531; x=1687532531;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=rwf57azNybT9v+Lg2CMN2sb9fLVIIGUOGeYghvdjLPg=;
 b=ZdsRtJF0aTLVzzxIhvjdFKwOHJ8wCwDS78uMa8TgliordbPtlBWF9WRJUvH8rNZ8fF
 /KMR+CO4JQ7CoEMhTOzkdG41okLOxNqds0ATlURUpWxXyXlZ2H9MDzaJXNp+GH2cxFqS
 bnuyoa4CQSSCA8FLzWnLl60k1OuqeOkDhBvMfmTWKGbTOEa/cx2I9Rc77SIeAVBsjOPg
 pLph34n5RGMHO0S5QiSbrmRQf6eeAt+7hmX4oF/+bUh5f24BD0IMI4uUYV3mFS/KCN/l
 rT0v9qtkXXpeylOCH2J6rRMlXzVzenbbbN9dLJict+by2In4bTiJ4nXa6EmhQwk09YjW
 xMHw==
X-Gm-Message-State: AC+VfDzI6EPD641XXhPyqo3uOb0Zc6L8h617dwRbZ36+mt/oI/bTZfIw
 o1CBYELUx4xBxjuZUeD149MVuQ==
X-Google-Smtp-Source: ACHHUZ50tzfDRcH1j6S2Z6TgSbqpVFNpX8Jv88XOuQFTADKkXBGAMy329r3aqgfQXEN+hNSP1qppLQ==
X-Received: by 2002:a05:6602:3420:b0:774:8571:a6dd with SMTP id
 n32-20020a056602342000b007748571a6ddmr3685006ioz.2.1684940531189; 
 Wed, 24 May 2023 08:02:11 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2]) by smtp.gmail.com with ESMTPSA id
 f13-20020a056638112d00b0040fb2ba7357sm3209457jar.4.2023.05.24.08.02.09
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 24 May 2023 08:02:10 -0700 (PDT)
Message-ID: <3235f123-0638-b39f-f902-426059b87f81@kernel.dk>
Date: Wed, 24 May 2023 09:02:09 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
References: <20230502101934.24901-1-johannes.thumshirn@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230502101934.24901-1-johannes.thumshirn@wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v5 00/20] bio: check return values of
 bio_add_page
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
Cc: linux-block@vger.kernel.org, damien.lemoal@wdc.com, kch@nvidia.com,
 agruenba@redhat.com, shaggy@kernel.org, song@kernel.org, snitzer@kernel.org,
 jfs-discussion@lists.sourceforge.net, willy@infradead.org, ming.lei@redhat.com,
 cluster-devel@redhat.com, linux-mm@kvack.org, dm-devel@redhat.com,
 linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de,
 rpeterso@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.dk
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 5/2/23 4:19?AM, Johannes Thumshirn wrote:
> We have two functions for adding a page to a bio, __bio_add_page() which is
> used to add a single page to a freshly created bio and bio_add_page() which is
> used to add a page to an existing bio.
> 
> While __bio_add_page() is expected to succeed, bio_add_page() can fail.
> 
> This series converts the callers of bio_add_page() which can easily use
> __bio_add_page() to using it and checks the return of bio_add_page() for
> callers that don't work on a freshly created bio.
> 
> Lastly it marks bio_add_page() as __must_check so we don't have to go again
> and audit all callers.

Looks fine to me, though it would be nice if the fs and dm people could
give this a quick look. Should not take long, any empty bio addition
should, by definition, be able to use a non-checked page addition for
the first page.

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

