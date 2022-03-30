Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B20FC433EF
	for <dm-devel@archiver.kernel.org>; Wed, 30 Mar 2022 18:51:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-149-cJIKdz99MsaWq5xAJpMsWA-1; Wed, 30 Mar 2022 14:51:40 -0400
X-MC-Unique: cJIKdz99MsaWq5xAJpMsWA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8C67B3802AD4;
	Wed, 30 Mar 2022 18:51:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EAFC35805A5;
	Wed, 30 Mar 2022 18:51:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B5BDC1947BBB;
	Wed, 30 Mar 2022 18:51:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B1FE219451F3
 for <dm-devel@listman.corp.redhat.com>; Wed, 30 Mar 2022 18:51:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A1FC958059D; Wed, 30 Mar 2022 18:51:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9D87758059A
 for <dm-devel@redhat.com>; Wed, 30 Mar 2022 18:51:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 85600185A7BA
 for <dm-devel@redhat.com>; Wed, 30 Mar 2022 18:51:35 +0000 (UTC)
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com
 [209.85.166.43]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-644-TaOqbrUPNQy1EtyeCFfAEg-1; Wed, 30 Mar 2022 14:51:33 -0400
X-MC-Unique: TaOqbrUPNQy1EtyeCFfAEg-1
Received: by mail-io1-f43.google.com with SMTP id 125so25890328iov.10
 for <dm-devel@redhat.com>; Wed, 30 Mar 2022 11:51:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
 :message-id:date:mime-version:content-transfer-encoding;
 bh=y92bvKVGil+XZIjxQXyncjq3AMwQmOj/Se4/L6WvBo8=;
 b=N6nXYzVmlAkVuUJ2tPi4BcnivZKKkx3AS9JHprAGBWXgFqP7hYcHI1r6lnZnG74lo3
 DIuAfypYTJD+nftlmzI69q3EC37oZ311LlmvsqzmHI6UjA5HUAwwlCbc2QXl/vLHlZ9C
 ug/OAlkQygKLDwA+GEEGBBqUiDTvLO+dJ4XoWpEE51GDruJhZtwVtwgFrdO0nEU9LljK
 UGIeOHAo1e63pTt1+1TAJjTBKJtbiqxBbfEVvqDbZIJF62u1wpdYWgCiUoBKZwyTbA8S
 xHUGldu9nzFzrq+mKwEt4R+nPtqSMBMiegS0Tle/nhwwZEyRJ2a8h+6tYrFlqh7Hhnyp
 iaTA==
X-Gm-Message-State: AOAM530NABas01iedjCoe5aFXii8+lhPgUaM0WshoHw77YUqyKAJEBGV
 nMgoMBpvCVT30iafgVV3GAp8Rbzy7Anq4ak3
X-Google-Smtp-Source: ABdhPJxFa1K1f4C5BONxN28/ytYaG07W6F2EgJyQSyUkT/eiqQ9cyCL99l6RfDPPlj/FGN6oO03b9g==
X-Received: by 2002:a02:7050:0:b0:321:440c:5e11 with SMTP id
 f77-20020a027050000000b00321440c5e11mr680586jac.35.1648666292621; 
 Wed, 30 Mar 2022 11:51:32 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
 by smtp.gmail.com with ESMTPSA id
 z17-20020a92da11000000b002c83987c2ffsm10383622ilm.76.2022.03.30.11.51.32
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 30 Mar 2022 11:51:32 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Mike Snitzer <snitzer@kernel.org>
In-Reply-To: <20220324203526.62306-1-snitzer@kernel.org>
References: <20220324203526.62306-1-snitzer@kernel.org>
Message-Id: <164866629201.257072.14870349731518355925.b4-ty@kernel.dk>
Date: Wed, 30 Mar 2022 12:51:32 -0600
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] (subset) [PATCH v3 0/3] block/dm: use
 BIOSET_PERCPU_CACHE from bio_alloc_bioset
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, hch@lst.de,
 ming.lei@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, 24 Mar 2022 16:35:23 -0400, Mike Snitzer wrote:
> This v3 is a rebase of the previous v2 series ontop of the revised v2
> patch that Christoph provided.
> 
> Linus hasn't pulled the for-5.18/dm-changes branch yet, so the 3rd DM
> patch cannot be applied yet.  But feel free to pickup the first 2
> block patches for 5.19 and I'll rebase dm-5.19 on block accordingly.
> 
> [...]

Applied, thanks!

[1/3] block: allow using the per-cpu bio cache from bio_alloc_bioset
      commit: a147e4805855e34f8e1027b88baf59a7f7c8b8d3
[2/3] block: allow use of per-cpu bio alloc cache by block drivers
      commit: e866e4dbad251b4dd1e134c295afd862333864bc

Best regards,
-- 
Jens Axboe


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

