Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A5A2C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 14 Jun 2022 16:48:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-308-oytIywa_MlG7LW5d66pkjw-1; Tue, 14 Jun 2022 12:48:39 -0400
X-MC-Unique: oytIywa_MlG7LW5d66pkjw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 742C085A580;
	Tue, 14 Jun 2022 16:48:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 62D8C1415103;
	Tue, 14 Jun 2022 16:48:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 18DD1194707F;
	Tue, 14 Jun 2022 16:48:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 33A591947067
 for <dm-devel@listman.corp.redhat.com>; Tue, 14 Jun 2022 16:48:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 00BDC2166B29; Tue, 14 Jun 2022 16:48:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F0C882166B26
 for <dm-devel@redhat.com>; Tue, 14 Jun 2022 16:48:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D674B3C025AF
 for <dm-devel@redhat.com>; Tue, 14 Jun 2022 16:48:35 +0000 (UTC)
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com
 [209.85.216.53]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-580-7SamiF5_ObyeJzOYvpIcGg-1; Tue, 14 Jun 2022 12:48:34 -0400
X-MC-Unique: 7SamiF5_ObyeJzOYvpIcGg-1
Received: by mail-pj1-f53.google.com with SMTP id z14so4201120pjb.4
 for <dm-devel@redhat.com>; Tue, 14 Jun 2022 09:48:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=c2KqkaSirHWOrrAQw1VC+PyGO2MeCmppR3zyYxox92k=;
 b=zVh3aJqFFWaBfksm67ZsUeRlgMn2fjIDww3nrDLjKmTy+vzzFWBJ9sXAzJncBZH/Rx
 3nOzb3jXRDcYEOMXN1rAr45nv0n+TWpSj89LXgO9hMOcCACD+bj00CFqydHGa5usBpTE
 /707Pqz2pmVyErup7RWOkZIOfTR61h6+MIZCou9q0Q1moLVblYgF6LXMaJfC5DwG+yN1
 llOTgrXUcD/cnDu3ahKVrso1GhItqSVHeE/ErLNvpeE2mflbVytScAqUqJUcTelhYC6B
 Iv8WNOzFXPvqUBH5eRd+J/j6F3HzSQ2sIYC01lOMh/JkKVEM2kY4dH7h9eWw7jK7X9b/
 fA2A==
X-Gm-Message-State: AJIora/RzZBbjxPQ/e28w6NApgWjPPwv6BoeueliI+xm1/PXDYOJl9R3
 OxKztJ4eMMYlM/u9R8o4KpU=
X-Google-Smtp-Source: AGRyM1tjUmtBMcCiU4gTQbOUdr192bm9HtNqYwOlXmyTivvTuBfRm8o98/YtExWV1FWEa3DgVsndkQ==
X-Received: by 2002:a17:90a:df18:b0:1ea:96b7:b328 with SMTP id
 gp24-20020a17090adf1800b001ea96b7b328mr5447146pjb.183.1655225312853; 
 Tue, 14 Jun 2022 09:48:32 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:ab60:e1ea:e2eb:c1b6?
 ([2620:15c:211:201:ab60:e1ea:e2eb:c1b6])
 by smtp.gmail.com with ESMTPSA id
 x8-20020a170902a38800b001640537511esm7422334pla.71.2022.06.14.09.48.31
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 14 Jun 2022 09:48:32 -0700 (PDT)
Message-ID: <3d28498a-98b8-9168-d7f9-71c88e0034ee@acm.org>
Date: Tue, 14 Jun 2022 09:48:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20220614090934.570632-1-hch@lst.de>
 <20220614090934.570632-7-hch@lst.de>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220614090934.570632-7-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH 6/6] block: move blk_queue_get_max_sectors to
 blk.h
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 6/14/22 02:09, Christoph Hellwig wrote:
> blk_queue_get_max_sectors is private to the block layer, so move it out
> of blkdev.h.
Reviewed-by: Bart Van Assche <bvanassche@acm.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

