Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3342DC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 31 Mar 2022 16:49:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-475-lmKo6mQuOB6pWZ5thMPz3Q-1; Thu, 31 Mar 2022 12:49:09 -0400
X-MC-Unique: lmKo6mQuOB6pWZ5thMPz3Q-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B187D833959;
	Thu, 31 Mar 2022 16:49:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5F590401053;
	Thu, 31 Mar 2022 16:49:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D8A121947BBB;
	Thu, 31 Mar 2022 16:49:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 973B619451F3
 for <dm-devel@listman.corp.redhat.com>; Thu, 31 Mar 2022 16:49:01 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 66854400E407; Thu, 31 Mar 2022 16:49:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 625E0400E43D
 for <dm-devel@redhat.com>; Thu, 31 Mar 2022 16:49:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4915E1C0B053
 for <dm-devel@redhat.com>; Thu, 31 Mar 2022 16:49:01 +0000 (UTC)
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com
 [209.85.166.46]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-455-niV08ki-NU2uo7rEm_3KJA-1; Thu, 31 Mar 2022 12:48:54 -0400
X-MC-Unique: niV08ki-NU2uo7rEm_3KJA-1
Received: by mail-io1-f46.google.com with SMTP id 9so167075iou.5
 for <dm-devel@redhat.com>; Thu, 31 Mar 2022 09:48:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=GVS+7ByfaDfRQ3cP7Su5v65xswUHpTm7s1D0XKCLUIc=;
 b=Dod/klm+SNBqEKBHyD13ee+HHZm2FLZ0K/MDdgaBoAJ6sAx8re3IomnyqkgGlA3e9o
 Ud7m512YDIu4GqnWc0qnP518IccZf/qUoCgzJKQq97aYvsFpSjZJayo415bvbxfL0AKP
 uFyfCtR3OEYss7gtaWfqS4edaUVUfGp1Lo5S7zYY9SsjsPpMbS8yukJZPOQQ4neBEHbv
 dB+125iI0qLEYppGfXZQNbjpw1rjXgO9kCDeJNdm1o4N7EXfNkmYOZlpoBxgynTlv3jJ
 hXY8KO1FdTYaDxZ0VEpBTpbisldNObnTkcSxLtQdvJAQNjVoDKLVQM2apqo/Qk5H9bLK
 ZF5w==
X-Gm-Message-State: AOAM532bqhRxhzCUqtjHMrWoqVHd3qBMxMmxNPeG/7q0Z9OeEaQojBjh
 uVXKXzTGwksvbbRi8QOqz1K4WQ==
X-Google-Smtp-Source: ABdhPJxO6cxAuydd+MYxjFrmEZWnATNnBLDhK+n22mh4Hzt3rKwlZEwEzWA3wPZWmZM8hKaYOdK5ag==
X-Received: by 2002:a02:c017:0:b0:323:6b24:5bde with SMTP id
 y23-20020a02c017000000b003236b245bdemr3323956jai.185.1648745331810; 
 Thu, 31 Mar 2022 09:48:51 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
 by smtp.gmail.com with ESMTPSA id
 j4-20020a056e02218400b002c82f195e80sm12730706ila.83.2022.03.31.09.48.50
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 31 Mar 2022 09:48:51 -0700 (PDT)
Message-ID: <572bf891-8b2b-b32e-af64-d80fb7f5963f@kernel.dk>
Date: Thu, 31 Mar 2022 10:48:50 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
To: Christoph Hellwig <hch@lst.de>, Qian Cai <quic_qiancai@quicinc.com>
References: <20220308061551.737853-1-hch@lst.de> <YkXYMGGbk/ZTbGaA@qian>
 <20220331164024.GA30404@lst.de>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220331164024.GA30404@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] cleanup bio_kmalloc v2
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
Cc: linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
 Mike Snitzer <snitzer@redhat.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-kernel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
 Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
 Song Liu <song@kernel.org>, dm-devel@redhat.com, target-devel@vger.kernel.org,
 David Sterba <dsterba@suse.com>, Phillip Lougher <phillip@squashfs.org.uk>,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 3/31/22 10:40 AM, Christoph Hellwig wrote:
> This should fix it:

Let's drop this one for 5.18, it's also causing a few conflicts and
would probably be more suited for 5.19 at this point.

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

