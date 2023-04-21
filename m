Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D45C5C77B73
	for <dm-devel@archiver.kernel.org>; Mon, 24 Apr 2023 06:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1682316250;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=B5ozoFbmwHGNcUi1ZWBIe045dVXGDpjG5YjhxaaZcl4=;
	b=aagdvMaNf++YHu6O+Ve4WkwEPnKAquxPsLRFEaV5NXm7ueas4+E8d4cHp2ukZBQLaHQe5a
	pb6M7+lZ1TIAFizAxKO9gFIJN7vdfW6qercxCCaOMVaUv8Zyp0g0i33BzbLr6+zCpedmw5
	jk0oxOqNMvCvDHXANIKZ+HJFqvCWSnE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-605-huUgEPVCM2CeyEIPMKl0KQ-1; Mon, 24 Apr 2023 02:04:07 -0400
X-MC-Unique: huUgEPVCM2CeyEIPMKl0KQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 076C21C17437;
	Mon, 24 Apr 2023 06:04:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5384E492B0F;
	Mon, 24 Apr 2023 06:04:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3CF011946A48;
	Mon, 24 Apr 2023 06:04:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BC72B1946A40
 for <dm-devel@listman.corp.redhat.com>; Fri, 21 Apr 2023 06:58:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 98822492C14; Fri, 21 Apr 2023 06:57:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 912CB492C13
 for <dm-devel@redhat.com>; Fri, 21 Apr 2023 06:57:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 74D28101A554
 for <dm-devel@redhat.com>; Fri, 21 Apr 2023 06:57:58 +0000 (UTC)
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com
 [209.85.210.171]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-471-LzbeR3XWOgyjXUsl_qux8A-1; Fri, 21 Apr 2023 02:57:56 -0400
X-MC-Unique: LzbeR3XWOgyjXUsl_qux8A-1
Received: by mail-pf1-f171.google.com with SMTP id
 d2e1a72fcca58-63d4595d60fso12425913b3a.0
 for <dm-devel@redhat.com>; Thu, 20 Apr 2023 23:57:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1682060276; x=1684652276;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=iCQQOrDHvv7muofgTvhggno9gmpvYe5WVwBD+zXre78=;
 b=dVD1Nnd3Ngfyd6AO2pqXOigEaBDBLwtMMpZKLMI1Cq7xps/T4T9fhLVRzBho40FPEE
 Oxq8mf73ni9Ebqj3oVdwiLWCsePyV2lfYLqjQWWoBlbvc9eQdjDn/yCOIXAi7wnUI62p
 JWt11sLp09No3lSw78w2yjaD9735lNYyIgm7qGZCuJzxJRJ1a7uooM2ZYvWfr/8bjRNU
 ng/PWUXywkWePlJZVmOSSH5FfnuZQPOlF09k/Xd/6JPWK5uFTdHkAtlDU78eH6Tjt7I1
 Yc11IoLu3zV8c5zrICWyf60yqorMmlr35mBVe2mCBE9jtoMt3WGCsW8IlIwVwWprgavD
 E81A==
X-Gm-Message-State: AAQBX9f1hpK8my9HnevuXAsumQl5r7VgIXNkGw9xdiR6hhjRIKWndgoc
 KoJLKdUheSCYwOwqJjUlloTfLQ==
X-Google-Smtp-Source: AKy350ZEEP/PrU7kYgyyZkKivdaMPHUVf5WGz+Wiu1WQ8mlkUVfjfkCNB7ZnxyH4DOCp4JsT1PbWNg==
X-Received: by 2002:aa7:8554:0:b0:63d:40bb:a88b with SMTP id
 y20-20020aa78554000000b0063d40bba88bmr8194787pfn.14.1682060275718; 
 Thu, 20 Apr 2023 23:57:55 -0700 (PDT)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
 by smtp.gmail.com with ESMTPSA id
 136-20020a63008e000000b0051806da5cd6sm2038374pga.60.2023.04.20.23.57.49
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 20 Apr 2023 23:57:54 -0700 (PDT)
Date: Fri, 21 Apr 2023 15:57:47 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Johannes Thumshirn <jth@kernel.org>
Message-ID: <20230421065747.GB1496740@google.com>
References: <20230420100501.32981-1-jth@kernel.org>
 <20230420100501.32981-14-jth@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230420100501.32981-14-jth@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Mon, 24 Apr 2023 06:04:00 +0000
Subject: Re: [dm-devel] [PATCH v4 13/22] zram: use __bio_add_page for adding
 single page to bio
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
Cc: shaggy@kernel.org, jfs-discussion@lists.sourceforge.net, linux-mm@kvack.org,
 dm-devel@redhat.com, hch@lst.de, agruenba@redhat.com,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>, willy@infradead.org,
 cluster-devel@redhat.com, kch@nvidia.com, snitzer@kernel.org,
 ming.lei@redhat.com, linux-block@vger.kernel.org, rpeterso@redhat.com,
 dsterba@suse.com, axboe@kernel.dk, linux-raid@vger.kernel.org,
 damien.lemoal@wdc.com, song@kernel.org, johannes.thumshirn@wdc.com,
 Minchan Kim <minchan@kernel.org>, linux-fsdevel@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: chromium.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

+ Minchan

On (23/04/20 12:04), Johannes Thumshirn wrote:
> 
> From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> 
> The zram writeback code uses bio_add_page() to add a page to a newly
> created bio. bio_add_page() can fail, but the return value is never
> checked.
> 
> Use __bio_add_page() as adding a single page to a newly created bio is
> guaranteed to succeed.
> 
> This brings us a step closer to marking bio_add_page() as __must_check.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

