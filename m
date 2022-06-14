Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA085C43334
	for <dm-devel@archiver.kernel.org>; Tue, 14 Jun 2022 16:39:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-186-R3N2h5XPOIiYofkkVk6iUw-1; Tue, 14 Jun 2022 12:39:28 -0400
X-MC-Unique: R3N2h5XPOIiYofkkVk6iUw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DFEE585A584;
	Tue, 14 Jun 2022 16:39:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 84D04492C3B;
	Tue, 14 Jun 2022 16:39:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4A8AC194707F;
	Tue, 14 Jun 2022 16:39:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 15AC41947067
 for <dm-devel@listman.corp.redhat.com>; Tue, 14 Jun 2022 16:39:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F3F44416164; Tue, 14 Jun 2022 16:39:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F0241492C3B
 for <dm-devel@redhat.com>; Tue, 14 Jun 2022 16:39:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D932818E5380
 for <dm-devel@redhat.com>; Tue, 14 Jun 2022 16:39:24 +0000 (UTC)
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com
 [209.85.214.174]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-564-2h6zjAqgPmCPqu1BkWTnVQ-1; Tue, 14 Jun 2022 12:39:22 -0400
X-MC-Unique: 2h6zjAqgPmCPqu1BkWTnVQ-1
Received: by mail-pl1-f174.google.com with SMTP id i15so8217498plr.1
 for <dm-devel@redhat.com>; Tue, 14 Jun 2022 09:39:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=8gfxpJvHcIjCg9eZ7VpKQJ9lwYv6reCJqVJnZWks3cE=;
 b=e+66Oh/MAuxsap7pw8y2oMcBUcitmRC4PcluJro61dOZ2xY4NZUWQr5t+uHyePkxut
 QPjfCBGn4ExJ0Q6U+HVJn2UAoPvoKGsMxeJUQEd+ymOOiWvdZFWHNVk969BHPZ29dNLY
 1WVU0vAcjxQ9aOVg2y13qPJGmCHKEQFRyqWsnquqfzkZMocZ3yuQiFW5043x7qO6yY/0
 aq0ZqnQOBhm6QUhZtuUbyUGXiueubmwFUTiQfa2rGUGf7EwVtzcZs5qJDxbQ2zgCptlu
 9aFsTrgtE3KfdE2jZ+N8XzUe9P1KeW8MkPXaOdSqmjVhiv7l7HbU+hOjjiyp1p/bkEqb
 SMWA==
X-Gm-Message-State: AJIora+hfO0ck9//OcptpS8fEL8w4hb+cVtlXbuLbAJGQvAjt6K7XLnI
 s5yx3GIG/g0jNmo2qEeu6wo=
X-Google-Smtp-Source: AGRyM1vmYNK+JN+7FV3Iy9BrVVtauHt15Mvwagcwi/WHAsUuZbIsqq5gugNNjIjt2hEv0WETxpOK9w==
X-Received: by 2002:a17:902:9b83:b0:164:59e:b189 with SMTP id
 y3-20020a1709029b8300b00164059eb189mr5016967plp.91.1655224760927; 
 Tue, 14 Jun 2022 09:39:20 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:ab60:e1ea:e2eb:c1b6?
 ([2620:15c:211:201:ab60:e1ea:e2eb:c1b6])
 by smtp.gmail.com with ESMTPSA id
 b10-20020a170902bd4a00b00168b7d639acsm7460789plx.170.2022.06.14.09.39.18
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 14 Jun 2022 09:39:19 -0700 (PDT)
Message-ID: <126e6f2e-a8a9-872e-0efd-668dfaa660c4@acm.org>
Date: Tue, 14 Jun 2022 09:39:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20220614090934.570632-1-hch@lst.de>
 <20220614090934.570632-2-hch@lst.de>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220614090934.570632-2-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH 1/6] block: factor out a chunk_size_left
 helper
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 6/14/22 02:09, Christoph Hellwig wrote:
> Factor out a helper from blk_max_size_offset so that it can be reused
> independently. 
Reviewed-by: Bart Van Assche <bvanassche@acm.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

