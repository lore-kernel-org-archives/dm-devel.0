Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CE33C64EC4
	for <dm-devel@archiver.kernel.org>; Fri,  3 Mar 2023 04:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677816059;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=+ma9fj8qumbiFOB2hCdqo1UTRyxUYMd2Z5auT90unho=;
	b=ScOfcY5pFBNBeOt+/fOribwHk6Js7u5ng/HV5oDLDNt1h/UW6SGZQadkOFZi9buye+noUM
	5MBEmjACoUBSGU+EsWtd24NoUjO2THpxnDtAZg+tqlTli0kFiBPASUJriYaX/ib8ByZawG
	12ofhpeSS84UqDKk56vKC+Eqdrz9dT8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-589-xjJCAP0dNqqIZc7GBQTF_g-1; Thu, 02 Mar 2023 23:00:56 -0500
X-MC-Unique: xjJCAP0dNqqIZc7GBQTF_g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C840E185A78B;
	Fri,  3 Mar 2023 04:00:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9A04C440D9;
	Fri,  3 Mar 2023 04:00:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 631BE19452CD;
	Fri,  3 Mar 2023 04:00:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 63E4119465A0
 for <dm-devel@listman.corp.redhat.com>; Fri,  3 Mar 2023 04:00:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D7C91440DC; Fri,  3 Mar 2023 04:00:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D0099440D9
 for <dm-devel@redhat.com>; Fri,  3 Mar 2023 04:00:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B100A1C05142
 for <dm-devel@redhat.com>; Fri,  3 Mar 2023 04:00:50 +0000 (UTC)
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com
 [209.85.216.54]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-353-gaerpoO_PCe-OfLfxtxFlA-1; Thu, 02 Mar 2023 23:00:48 -0500
X-MC-Unique: gaerpoO_PCe-OfLfxtxFlA-1
Received: by mail-pj1-f54.google.com with SMTP id
 m8-20020a17090a4d8800b002377bced051so4955779pjh.0
 for <dm-devel@redhat.com>; Thu, 02 Mar 2023 20:00:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1677816047;
 h=content-transfer-encoding:mime-version:date:message-id:subject
 :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=VO74g2mNwHzYzU/yV1CgDrAplD3wm5JXJvrOGFj1g+g=;
 b=sLPtNKPJd8UxbSmUWUzAhBjybK1NxeGtH+EruayspDPZ5ImGQ+84RLkr60RpxfXWrk
 FKFAsx6Fw9IxT15/xh5laKtSDiJ3oF8GBn1Q6rmpMPQeMbM/1Bnh4Q2lEyOsqzspwyZi
 FGHr6r3GoDvY03PY+0dMiyILWwnE+yjBI/HC1iUeqTlbwpqfKGLL4nSDUXWzS0Kx4KY2
 LQy4DpOT8wtakvAPViRHz8amap8+qkJrbc0WvInw4t/8vsRGub/ZooJd3v3vLRKUKwhi
 0ZDTz7QJ04OF6pCBNfsnsmG4uUzL8guL49B6RzG/A1T+JXd9sU/SH3R/CBqFCQ0FwqAI
 bqMA==
X-Gm-Message-State: AO0yUKXvXOyAoz3gbNc60knUyfekNYXCGTFpKXOmTT8FEnraz9cqltfp
 vx0AfYO72u9tDDTiXma/JPIzVA==
X-Google-Smtp-Source: AK7set/uNWyGtRPehTwL47DKKom5XL9HpMg9zcRF+pvE9PUmTVBtVsOF2bq8/Jsgp1lT4Xv1v2+SPA==
X-Received: by 2002:a17:902:d4d0:b0:19a:8202:2dad with SMTP id
 o16-20020a170902d4d000b0019a82022dadmr776157plg.2.1677816046820; 
 Thu, 02 Mar 2023 20:00:46 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157]) by smtp.gmail.com with ESMTPSA id
 b20-20020a170902d31400b0019a7363e752sm396753plc.276.2023.03.02.20.00.45
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 02 Mar 2023 20:00:46 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
 Christoph Hellwig <hch@infradead.org>, Keith Busch <kbusch@kernel.org>, 
 Uday Shankar <ushankar@purestorage.com>
In-Reply-To: <20230301000655.48112-1-ushankar@purestorage.com>
References: <20230301000655.48112-1-ushankar@purestorage.com>
Message-Id: <167781604577.209443.3783406495581654903.b4-ty@kernel.dk>
Date: Thu, 02 Mar 2023 21:00:45 -0700
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v3] blk-mq: enforce op-specific segment
 limits in blk_insert_cloned_request
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
 kernel test robot <lkp@intel.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


On Tue, 28 Feb 2023 17:06:55 -0700, Uday Shankar wrote:
> The block layer might merge together discard requests up until the
> max_discard_segments limit is hit, but blk_insert_cloned_request checks
> the segment count against max_segments regardless of the req op. This
> can result in errors like the following when discards are issued through
> a DM device and max_discard_segments exceeds max_segments for the queue
> of the chosen underlying device.
> 
> [...]

Applied, thanks!

[1/1] blk-mq: enforce op-specific segment limits in blk_insert_cloned_request
      commit: 49d24398327e32265eccdeec4baeb5a6a609c0bd

Best regards,
-- 
Jens Axboe



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

