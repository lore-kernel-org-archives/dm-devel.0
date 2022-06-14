Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5775BC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 14 Jun 2022 16:52:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-46-RJTj-rzKNCybQF_cRH3AbA-1; Tue, 14 Jun 2022 12:52:00 -0400
X-MC-Unique: RJTj-rzKNCybQF_cRH3AbA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 444D338173C9;
	Tue, 14 Jun 2022 16:51:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B69069D7F;
	Tue, 14 Jun 2022 16:51:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8041E194707C;
	Tue, 14 Jun 2022 16:51:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D24D51947067
 for <dm-devel@listman.corp.redhat.com>; Tue, 14 Jun 2022 16:51:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A798C1415108; Tue, 14 Jun 2022 16:51:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A41891415106
 for <dm-devel@redhat.com>; Tue, 14 Jun 2022 16:51:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8D45C801E80
 for <dm-devel@redhat.com>; Tue, 14 Jun 2022 16:51:56 +0000 (UTC)
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com
 [209.85.214.181]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-38-3L3OIu5UOlSkDqIakUauZQ-1; Tue, 14 Jun 2022 12:51:55 -0400
X-MC-Unique: 3L3OIu5UOlSkDqIakUauZQ-1
Received: by mail-pl1-f181.google.com with SMTP id n18so8231725plg.5
 for <dm-devel@redhat.com>; Tue, 14 Jun 2022 09:51:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=t83AYSlzSApM9nN7I9alCqcQKbV28raP6GborJR/Amc=;
 b=DDuE45ZP6gISII9y2bW6Xg9edruc9H28bU3pX7d95mPOZj86g7ToaTuUpgeEqMlaFj
 AdlNnfkA5x1kkXaoTlS1ZpIQAgM8vHYYwxIliBRPkK793O4rNd7loAlaveN3Wz8gcjdp
 x9N8WHq2wGgxeArFXoRVPPHIk5ycYLt92cnCp0f9Duti6oZt51RWO1E46ln7S96pJWo/
 e+PQmjhbevXK+u65tDxw00WhGvKt0Tj96YwsinYbL+tBHGPeWJluEA4jY4QvQIapFu6c
 GpzxH+GG223l1Tl1RkBZI5+Houy2p3/wlqPrAcbfzWxeE6rASYG0dzV8VUc5S8PWlkYo
 Jxrw==
X-Gm-Message-State: AJIora9tYR7WCq5flZxJeLfc1HAnNzRNizF182LRbgEsAZx4SRQnuJ9z
 obN3EkblJn9x9Uo1ni7wZA0=
X-Google-Smtp-Source: AGRyM1tOVC0y3KN8th4nAQ9ARAtBJYthGH8OTKQsbaJOi+L4VnA8dzugaAeEIDnpN4lXIixQ2w+otg==
X-Received: by 2002:a17:90b:4c4a:b0:1e3:3b3:8800 with SMTP id
 np10-20020a17090b4c4a00b001e303b38800mr5662384pjb.6.1655225513748; 
 Tue, 14 Jun 2022 09:51:53 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:ab60:e1ea:e2eb:c1b6?
 ([2620:15c:211:201:ab60:e1ea:e2eb:c1b6])
 by smtp.gmail.com with ESMTPSA id
 p127-20020a62d085000000b0050dc7628137sm8169880pfg.17.2022.06.14.09.51.52
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 14 Jun 2022 09:51:53 -0700 (PDT)
Message-ID: <6ed896d6-0167-9501-ab68-01d979c1d98c@acm.org>
Date: Tue, 14 Jun 2022 09:51:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20220614090934.570632-1-hch@lst.de>
 <20220614090934.570632-6-hch@lst.de>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220614090934.570632-6-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH 5/6] block: fold blk_max_size_offset into
 get_max_io_size
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
 Mike Snitzer <snitzer@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 6/14/22 02:09, Christoph Hellwig wrote:
> Now that blk_max_size_offset has a single caller left, fold it into that
> and clean up the naming convention for the local variables there.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

