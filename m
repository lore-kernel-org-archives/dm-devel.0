Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04540C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 26 Apr 2022 14:25:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-582-HjY1W4gEOt6-SrgAK2gBMA-1; Tue, 26 Apr 2022 10:25:29 -0400
X-MC-Unique: HjY1W4gEOt6-SrgAK2gBMA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2A1F8833942;
	Tue, 26 Apr 2022 14:25:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7DCAC54CE34;
	Tue, 26 Apr 2022 14:25:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2A6C11947BBB;
	Tue, 26 Apr 2022 14:25:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EC02219451EC
 for <dm-devel@listman.corp.redhat.com>; Tue, 26 Apr 2022 14:25:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D93C114682C6; Tue, 26 Apr 2022 14:25:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D436D14682C5
 for <dm-devel@redhat.com>; Tue, 26 Apr 2022 14:25:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BA6D33839755
 for <dm-devel@redhat.com>; Tue, 26 Apr 2022 14:25:22 +0000 (UTC)
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com
 [209.85.221.54]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-235-0MQfEYZbMFC4Y9LHdj9EaQ-1; Tue, 26 Apr 2022 10:25:18 -0400
X-MC-Unique: 0MQfEYZbMFC4Y9LHdj9EaQ-1
Received: by mail-wr1-f54.google.com with SMTP id k2so5288112wrd.5;
 Tue, 26 Apr 2022 07:25:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
 b=MsNJHQQNIvqKoa1cpXS0iZ2wZIbWQ6jGMxpMCkivcpyF5CnqG/8a7Of/NfpCYpJ9I3
 DdwRr4Z867bX9fpaU8Uq/ttKluFJr8RJ0GqMkd6G/LrlMtQhLVSJ7Xs51ZkTv5QZTGlG
 ibCZam2EyarLLoJvQ4pE3v7PYDWzHb/1gK9guyERSIs8gQxlYbEFs+8FjhjGq8yDLDxi
 jaLe832GhYo3cLhyVS+DwTlwOIqOYzfDhxum9rWZyJUYQ1a+fvyjk32kVAb19FCRuKsr
 0R97dbUq8LwpGxvhUsbcnYgJXpWQhaKS8tqpAbV/CoH3akcXyG9GLh5IMEFXHmo3uEUf
 YGvg==
X-Gm-Message-State: AOAM531D/89DTqCoRwKJmYvK7YairBBzt329lM4DlotEQGjzKmpTRqH9
 iX8o4QeasVRoPHtyNfQdXFQ=
X-Google-Smtp-Source: ABdhPJx+tGjrozc2v+hkDAQGkKaaKd6tvj25GGtU09S+2P3NV6/kZmjHHHaKsKLq0MduUfwGvhoEcw==
X-Received: by 2002:a05:6000:1a8d:b0:20a:ab7c:efb1 with SMTP id
 f13-20020a0560001a8d00b0020aab7cefb1mr18901071wry.716.1650983116938; 
 Tue, 26 Apr 2022 07:25:16 -0700 (PDT)
Received: from [192.168.64.180] (bzq-219-42-90.isdn.bezeqint.net.
 [62.219.42.90]) by smtp.gmail.com with ESMTPSA id
 j39-20020a05600c1c2700b00393ee3deaf1sm5525786wms.9.2022.04.26.07.25.13
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 26 Apr 2022 07:25:16 -0700 (PDT)
Message-ID: <c658f5cc-7b9a-84ee-ac22-cefc03e3dbf2@grimberg.me>
Date: Tue, 26 Apr 2022 17:25:12 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20220418045314.360785-1-hch@lst.de>
 <20220418045314.360785-10-hch@lst.de>
From: Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20220418045314.360785-10-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH 09/11] nvme: remove a spurious clear of
 discard_alignment
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
Cc: Jan Hoeppner <hoeppner@linux.ibm.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 linux-nvme@lists.infradead.org, virtualization@lists.linux-foundation.org,
 Song Liu <song@kernel.org>, dm-devel@redhat.com,
 "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>,
 linux-s390@vger.kernel.org, Richard Weinberger <richard@nod.at>,
 xen-devel@lists.xenproject.org, linux-um@lists.infradead.org,
 Mike Snitzer <snitzer@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
 nbd@other.debian.org, linux-block@vger.kernel.org,
 Stefan Haberland <sth@linux.ibm.com>, linux-raid@vger.kernel.org,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 =?UTF-8?Q?Roger_Pau_Monn=c3=a9?= <roger.pau@citrix.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

