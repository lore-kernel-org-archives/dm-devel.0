Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA11FC6FD19
	for <dm-devel@archiver.kernel.org>; Mon, 13 Mar 2023 06:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678690520;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=LzkxOgL6mpqh51yD3KwRnkneJvdH7WYS13Kr0TWj3XQ=;
	b=BjDYWymnUOFPlapWeqBXp0vVhez8M75uy1vY6ejaxKLAD7Z3WBLwPo1okObNGmQnWTmlVY
	tgL0+j+aefZh/iHLG2sK60Zh2PdOMQhUGdmBLOucIZHzYphcroLvEXSYjCzyc6zko9OrqY
	RZOek4soaHyvoZm9UhNDul0jwgSkDSQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-252-wHM3zpRNNt2oz_BvnagdoQ-1; Mon, 13 Mar 2023 02:55:16 -0400
X-MC-Unique: wHM3zpRNNt2oz_BvnagdoQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 44DC6803462;
	Mon, 13 Mar 2023 06:55:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 19130202701E;
	Mon, 13 Mar 2023 06:55:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E0BCC194658F;
	Mon, 13 Mar 2023 06:55:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EE5971946587
 for <dm-devel@listman.corp.redhat.com>; Fri, 10 Mar 2023 10:05:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CE2534014CF3; Fri, 10 Mar 2023 10:05:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C71E140C945A
 for <dm-devel@redhat.com>; Fri, 10 Mar 2023 10:05:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 971E5101A52E
 for <dm-devel@redhat.com>; Fri, 10 Mar 2023 10:05:46 +0000 (UTC)
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com
 [209.85.214.181]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-202-TGK3oja8PFyYAJu22LAVDw-1; Fri, 10 Mar 2023 05:05:42 -0500
X-MC-Unique: TGK3oja8PFyYAJu22LAVDw-1
Received: by mail-pl1-f181.google.com with SMTP id p20so4986740plw.13;
 Fri, 10 Mar 2023 02:05:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1678442740;
 h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=pYD4GP98CzF/N9BqGG8dDrjPK08e+lr66ewu6A11gEM=;
 b=6+vWIfclxRvFi2VqtO8D6gWfuBtddNhfotWtHkGaFwbqjOKQz53sSJKwxumDj8ORGs
 FPguc2ogp8vVDyXN9gBpISoKXTQyKxF3+ufWVoMHefrdJ1ovC7ONqjRQx3IHe0Z21zZ9
 WmGvuoKMryaqs3/DGVaoP317C5+zg1P6xZwVdAt7gEp+KTLU76jTkT9OunaV/M29sA+E
 vxFx+MxtFaHu9o7QOHJpMJxDX9lJd8CpVMhnxnzCweriC6Xdql84FgKVIusl///WoX+M
 0sWjs9aFnT67EBNrYPT9SAC/qkTp022+r2M9A6CxxXsIBpJ3rM2VMtmtkvg8ejATqQTh
 8klw==
X-Gm-Message-State: AO0yUKV7X2oe762qQ5fICyM1oCvuI8vjAH7PIvOc8gQ6lCZoLX9HHsD/
 6Dvzy10h8MgQX4KL2VJyAevwvzCfeyk=
X-Google-Smtp-Source: AK7set/FgmKkUA1jCZyeRzCysiRJZFZzXfGh8mURDWZrDFnw2D+uMJKlY2RPv3WOVz8+NvlkAB5t8g==
X-Received: by 2002:a17:902:e80d:b0:19a:727e:d4f3 with SMTP id
 u13-20020a170902e80d00b0019a727ed4f3mr1493042plg.5.1678442740554; 
 Fri, 10 Mar 2023 02:05:40 -0800 (PST)
Received: from localhost ([58.34.94.196]) by smtp.gmail.com with ESMTPSA id
 b14-20020a170902d50e00b00198f73f9d54sm1085747plg.117.2023.03.10.02.05.39
 (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
 Fri, 10 Mar 2023 02:05:40 -0800 (PST)
From: "Jiazi.Li" <jqqlijiazi@gmail.com>
X-Google-Original-From: "Jiazi.Li" <jiazi.li@transsion.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>
Date: Fri, 10 Mar 2023 18:05:33 +0800
Message-Id: <20230310100533.6290-1-jiazi.li@transsion.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mailman-Approved-At: Mon, 13 Mar 2023 06:55:11 +0000
Subject: [dm-devel] [PATCH] dm: call remove_single_exception_chunk before
 commit_merge
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
Cc: "Jiazi.Li" <jiazi.li@transsion.com>, dm-devel@redhat.com
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Assume that the metadata of cow on the disk is corrupted after init
for some reason:
old chunk-id	new chunk-id
0               2
...
x ---> 0        y
After starting merge, old chunk 0 will be updated twice, and old
chunk x will not be updated.
And dm-snap will print err log after merge new chunk 2 to old chunk 0:

<3>[  731.921642]  (1)[4092:kworker/1:0]device-mapper: snapshots:
Corruption detected: exception for block 0 is on disk but not in memory
then set snap->merge_failed to true.

If userspace use "sectors_allocated == metadata_sectors" to determine
whether the merge is completed, there maybe the following race that
makes the userspace unable to know merge fail event:

kernel merge kworker                 userspace process
merge_callback
  ->commit_merge
                                     get snapshot_status by ioctl
  ->remove_single_exception_chunk
  set merge_failed to true
                                     think merge has been completed,
				     switch device to another target

Could we call remove_single_exception_chunk first to solve this race?

Signed-off-by: Jiazi.Li <jiazi.li@transsion.com>
---
 drivers/md/dm-snap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index f766c21408f1..f658d05752f2 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1141,15 +1141,15 @@ static void merge_callback(int read_err, unsigned long write_err, void *context)
 		goto shut;
 	}
 
+	if (remove_single_exception_chunk(s) < 0)
+		goto shut;
+
 	if (s->store->type->commit_merge(s->store,
 					 s->num_merging_chunks) < 0) {
 		DMERR("Write error in exception store: shutting down merge");
 		goto shut;
 	}
 
-	if (remove_single_exception_chunk(s) < 0)
-		goto shut;
-
 	snapshot_merge_next_chunks(s);
 
 	return;
-- 
2.17.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

