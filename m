Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03342C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 29 Mar 2022 05:32:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-599--vExYks5N9aioz3coFBaNA-1; Tue, 29 Mar 2022 01:32:10 -0400
X-MC-Unique: -vExYks5N9aioz3coFBaNA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 53A8A100BACF;
	Tue, 29 Mar 2022 05:32:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3E5F040D1B9B;
	Tue, 29 Mar 2022 05:32:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7A3161940349;
	Tue, 29 Mar 2022 05:32:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0824A1947BBE
 for <dm-devel@listman.corp.redhat.com>; Mon, 28 Mar 2022 11:18:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DC9B4140265C; Mon, 28 Mar 2022 11:18:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D8D6E1402642
 for <dm-devel@redhat.com>; Mon, 28 Mar 2022 11:18:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C0683899EC1
 for <dm-devel@redhat.com>; Mon, 28 Mar 2022 11:18:32 +0000 (UTC)
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com
 [209.85.167.49]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-262-su40I26sOweYkZtuk6-xlQ-2; Mon, 28 Mar 2022 07:18:31 -0400
X-MC-Unique: su40I26sOweYkZtuk6-xlQ-2
Received: by mail-lf1-f49.google.com with SMTP id 5so24112159lfp.1
 for <dm-devel@redhat.com>; Mon, 28 Mar 2022 04:18:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:from:to:date:message-id:in-reply-to
 :references:user-agent:mime-version:content-transfer-encoding;
 bh=CQb3mBxSCWM+ulf0NN0OcDqev6TRbJ0Ip390Rr+PwxE=;
 b=0i0H12QOBo4bc2Fvf3EU7HlDvXDhk6jl1zDjhuHgE9oBRU5RVK1pRyNvExd4cp2gfv
 YCXc6eieOC1qOkGe0SFV4P+yWKD0bVGsHtcP71Ui+hKI3153FnCoYf1A8zRkjPjiv1xG
 jpvD/cYo06EKr60CWnzMrPNwxKOxcfuUTx8tlxcNJg1eGYCaOq45qRiXJZvx1R8LJOvY
 kQL3xaBslMIIYg7ogZhMIzmksqfRO1aVaElZrki5P6oQIOawKrdBYwRskpGFpYmN81ja
 bOss9w0cvqI6ifOEsFiZY6tO1Use6iDInN+ubxGCYXLxzvlUJwASmmYiqULOAM9g2pYH
 j2gA==
X-Gm-Message-State: AOAM5310DYPMsfW2EagevCcyycJKLAHrPTQpiao3FtUlNclCd74UhWq9
 8LAHG4s/K4jRQpkuT8Ln8babTo83DVRlT63W
X-Google-Smtp-Source: ABdhPJzC9I5iTmkp1bV3jvbqseRJhFE1aB29rKJ9JSfKooecWBKUfY8aJyGzmUFdJjF2jaH2tVLXbw==
X-Received: by 2002:a05:6512:1156:b0:44a:1027:e505 with SMTP id
 m22-20020a056512115600b0044a1027e505mr19494729lfg.88.1648466310213; 
 Mon, 28 Mar 2022 04:18:30 -0700 (PDT)
Received: from [127.0.1.1] ([2.92.192.17]) by smtp.gmail.com with ESMTPSA id
 f3-20020a056512228300b0044a0e0a609bsm1605694lfu.38.2022.03.28.04.18.29
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 28 Mar 2022 04:18:29 -0700 (PDT)
From: Kirill Tkhai <kirill.tkhai@openvz.org>
To: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, song@kernel.org, 
 linux-kernel@vger.kernel.org, khorenko@virtuozzo.com,
 kirill.tkhai@openvz.org
Date: Mon, 28 Mar 2022 14:18:29 +0300
Message-ID: <164846630905.251310.11706161266244591219.stgit@pro>
In-Reply-To: <164846619932.251310.3668540533992131988.stgit@pro>
References: <164846619932.251310.3668540533992131988.stgit@pro>
User-Agent: StGit/1.5
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Mailman-Approved-At: Tue, 29 Mar 2022 05:32:01 +0000
Subject: [dm-devel] [PATCH 2/4] dm: Process .io_hints for drivers not having
 underlying devices
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This makes dm_calculate_queue_limits() sets the hints also for drivers,
which do not have underlying devices.
This is useful for dm-qcow2 driver, that wants to have incomming requests
are likely splitted by QCOW2 cluster size alignment.

Signed-off-by: Kirill Tkhai <kirill.tkhai@openvz.org>
---
 drivers/md/dm-table.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index e43096cfe9e2..aa2e85bef6e7 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1660,8 +1660,11 @@ int dm_calculate_queue_limits(struct dm_table *table,
 
 		ti = dm_table_get_target(table, i);
 
-		if (!ti->type->iterate_devices)
+		if (!ti->type->iterate_devices) {
+			if (ti->type->io_hints)
+				ti->type->io_hints(ti, &ti_limits);
 			goto combine_limits;
+		}
 
 		/*
 		 * Combine queue limits of all the devices this target uses.


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

