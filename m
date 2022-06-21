Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF1C5C43334
	for <dm-devel@archiver.kernel.org>; Tue, 21 Jun 2022 12:24:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-96-s5FTthO9PAiOX8HPCUuL4g-1; Tue, 21 Jun 2022 08:24:32 -0400
X-MC-Unique: s5FTthO9PAiOX8HPCUuL4g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 727221C1394E;
	Tue, 21 Jun 2022 12:24:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8F2E940466B3;
	Tue, 21 Jun 2022 12:24:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3292C1947042;
	Tue, 21 Jun 2022 12:24:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C5FC61947041
 for <dm-devel@listman.corp.redhat.com>; Tue, 21 Jun 2022 12:24:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C70D72166B29; Tue, 21 Jun 2022 12:24:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C32692166B26
 for <dm-devel@redhat.com>; Tue, 21 Jun 2022 12:24:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 77BBC1C13944
 for <dm-devel@redhat.com>; Tue, 21 Jun 2022 12:24:23 +0000 (UTC)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com
 [209.85.208.41]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-346-w91xMENnN-2WPicW8Q1Hrg-1; Tue, 21 Jun 2022 08:24:21 -0400
X-MC-Unique: w91xMENnN-2WPicW8Q1Hrg-1
Received: by mail-ed1-f41.google.com with SMTP id fd6so16366795edb.5
 for <dm-devel@redhat.com>; Tue, 21 Jun 2022 05:24:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=cK3UOKouU8D4gxoTwgollrKPcROsm0h0esqNtPEXGO8=;
 b=INSbP3G6mAE5NKp7jPqgW4mulX5tgt7dWXMsI65Nvr/t9J5mq1E47Pcmi2C1G5vusl
 i0sIpJo+6pZB9ccelW+pLUfYdCI/ZZFUIKmLO4xeFKBTsgSYeNnMdo4uvnKvvgf87Of0
 cBk0cS9F+AICQPpngvIJhWAVnU42vCQTsr8tYHkbUyu3he4D+I40Wl+0fzyvXGaqzeAl
 aunxAOsHapWus+p1+Ze/fUpOcX3owp8IFEwQoPRe495U9VCiW8IfQh8gxM6hE4ZzoP4N
 M9q5JzKhAKCTI8WaH1T72j+5OfpHJea7R0BEnPawRnbcnTtMYrfdvDGqKA40sWeIM/l9
 h1uQ==
X-Gm-Message-State: AJIora/ikFzlv2nMpaqgDTniQdMhaaOvA3cfA5Zu05oVj//zh+6j4VBJ
 gSs3GwuruUHbHdkOz83SUX1sLw==
X-Google-Smtp-Source: AGRyM1unGwh8h+iCheUL7SQywEOqWDr53ZHxy1c9qr2YDPhbXnJ85X06hGQJrMizyWr9pNbJyQG6DQ==
X-Received: by 2002:a05:6402:ca6:b0:435:8009:aa37 with SMTP id
 cn6-20020a0564020ca600b004358009aa37mr13034170edb.183.1655814260266; 
 Tue, 21 Jun 2022 05:24:20 -0700 (PDT)
Received: from localhost.localdomain ([31.177.62.212])
 by smtp.gmail.com with ESMTPSA id
 kx1-20020a170907774100b006ffa19b7782sm7489118ejc.74.2022.06.21.05.24.19
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 21 Jun 2022 05:24:19 -0700 (PDT)
From: Nikos Tsironis <ntsironis@arrikto.com>
To: snitzer@kernel.org,
	dm-devel@redhat.com,
	agk@redhat.com
Date: Tue, 21 Jun 2022 15:24:03 +0300
Message-Id: <20220621122403.17982-1-ntsironis@arrikto.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: [dm-devel] [PATCH] dm era: commit metadata in postsuspend after
 worker stops
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
Cc: ejt@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

During postsuspend dm-era does the following:

1. Archives the current era
2. Commits the metadata, as part of the RPC call for archiving the
   current era
3. Stops the worker

Until the worker stops, it might write to the metadata again. Moreover,
these writes are not flushed to disk immediately, but are cached by the
dm-bufio client, which writes them back asynchronously.

As a result, the committed metadata of a suspended dm-era device might
not be consistent with the in-core metadata.

In some cases, this can result in the corruption of the on-disk
metadata. Suppose the following sequence of events:

1. Load a new table, e.g. a snapshot-origin table, to a device with a
   dm-era table
2. Suspend the device
3. dm-era commits its metadata, but the worker does a few more metadata
   writes until it stops, as part of digesting an archived writeset
4. These writes are cached by the dm-bufio client
5. Load the dm-era table to another device.
6. The new instance of the dm-era target loads the committed, on-disk
   metadata, which don't include the extra writes done by the worker
   after the metadata commit.
7. Resume the new device
8. The new dm-era target instance starts using the metadata
9. Resume the original device
10. The destructor of the old dm-era target instance is called and
    destroys the dm-bufio client, which results in flushing the cached
    writes to disk
11. These writes might overwrite the writes done by the new dm-era
    instance, hence corrupting its metadata.

Fix this by committing the metadata after the worker stops running.

stop_worker uses flush_workqueue to flush the current work. However, the
work item may re-queue itself and flush_workqueue doesn't wait for
re-queued works to finish.

This could result in the worker changing the metadata after they have
been committed, or writing to the metadata concurrently with the commit
in the postsuspend thread.

Use drain_workqueue instead, which waits until the work and all
re-queued works finish.

Fixes: eec40579d8487 ("dm: add era target")
Cc: stable@vger.kernel.org # v3.15+
Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
---
 drivers/md/dm-era-target.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index 1f6bf152b3c7..e92c1afc3677 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -1400,7 +1400,7 @@ static void start_worker(struct era *era)
 static void stop_worker(struct era *era)
 {
 	atomic_set(&era->suspended, 1);
-	flush_workqueue(era->wq);
+	drain_workqueue(era->wq);
 }
 
 /*----------------------------------------------------------------
@@ -1570,6 +1570,12 @@ static void era_postsuspend(struct dm_target *ti)
 	}
 
 	stop_worker(era);
+
+	r = metadata_commit(era->md);
+	if (r) {
+		DMERR("%s: metadata_commit failed", __func__);
+		/* FIXME: fail mode */
+	}
 }
 
 static int era_preresume(struct dm_target *ti)
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

