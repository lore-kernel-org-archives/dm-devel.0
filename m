Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C2D6C64ED6
	for <dm-devel@archiver.kernel.org>; Fri, 17 Feb 2023 20:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676664473;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=BxbnvpwW5FMA3gjI+dTNz1x9S1BiFIyNuYsHe71vkhQ=;
	b=Ecg2WkmgxajWOIgvNV3sqBVRWDRmT9wQPna2d/Jm6oog3z6cIeUL5k1uy8QQ/b9yW3uKHg
	0KWQop65Z14XV2tF9RYwBHRvs2LQnUibqy6itsdJHb8jpQosgTbRdICd+sX0qGgYtSxJE+
	Kw71Kv/qtUvmpigzUD+RD/hXaMr/Qbg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-451-a9jWBoJtNziLtSOMPb6eJw-1; Fri, 17 Feb 2023 15:07:50 -0500
X-MC-Unique: a9jWBoJtNziLtSOMPb6eJw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B08CA80D0E0;
	Fri, 17 Feb 2023 20:07:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9E0C4492C3E;
	Fri, 17 Feb 2023 20:07:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 822FF1946589;
	Fri, 17 Feb 2023 20:07:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9558D1946588
 for <dm-devel@listman.corp.redhat.com>; Fri, 17 Feb 2023 20:07:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 76C2440C1106; Fri, 17 Feb 2023 20:07:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6F11040C1423
 for <dm-devel@redhat.com>; Fri, 17 Feb 2023 20:07:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3A5B4833948
 for <dm-devel@redhat.com>; Fri, 17 Feb 2023 20:07:46 +0000 (UTC)
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com
 [209.85.160.181]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-626-ojj3FD0wNXC2paafcOhgFw-1; Fri, 17 Feb 2023 15:07:44 -0500
X-MC-Unique: ojj3FD0wNXC2paafcOhgFw-1
Received: by mail-qt1-f181.google.com with SMTP id s22so1981365qtw.11
 for <dm-devel@redhat.com>; Fri, 17 Feb 2023 12:07:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=/dBTvzFNpsYY5Dq++IzD2GfMUUn2IXMOpNWHHmxlR+U=;
 b=6JnSxaHkeJo8SBgXB8OWt+tuS8u+etcq9HwIkeeqi5nLicK3U1GAhNQrefG5VKKOVc
 fUa85DRHUV7hF1CRBjjUo27iYsbwrKBVCP/DoWgYPbIQXFhS+WMQ/vZd/005LVuS9fJz
 cxKhyEqTxyFUqfPEIWOkx2TfPbIQXD2Oy44qPhOAqgdDdAx58o/raT5aeB97Czwt2wep
 imW8FAxfFq+kKmT/38WA3NpAlt86si1hAUv/o/nuCsPsF6XA34yZkGd0MPTL4StcIgrE
 E4uBWmlHYHTSSbwbgwjpiDabT2B4l6rofbQLp0CvqqAa9WNNi5s8BR1c0Fy1yfixUYBq
 ilfw==
X-Gm-Message-State: AO0yUKVuVg/SfobdA4edePK9//wj4cUtiP3618fmzgQPySpvw2qFEMIs
 aqXOQF0Gjb3RQa4sOfceAvSQMPVKXjthJNaUqoYKkwYhAmtz2Rdh7gYDwKjCoC6Mfo5qzfKkWEo
 8qxeIzCPQzgmy4yzvjM6ZAqIc+ESmGVio5hdBc8AUaLDx8d/VfFihbSjIVWzJisZYOyhfEA==
X-Google-Smtp-Source: AK7set+tTEfyOdt8nXEoeMlmYUxZ9Lf2wMqniIOf0UCFo0++jF3OfyS9WlYpjHZqPjTmk8Kxlxbe8Q==
X-Received: by 2002:a05:622a:170f:b0:3bb:7875:1bd7 with SMTP id
 h15-20020a05622a170f00b003bb78751bd7mr3147985qtk.5.1676664463716; 
 Fri, 17 Feb 2023 12:07:43 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 o185-20020a375ac2000000b007339c5114a9sm3835065qkb.103.2023.02.17.12.07.43
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 17 Feb 2023 12:07:43 -0800 (PST)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Fri, 17 Feb 2023 15:07:34 -0500
Message-Id: <20230217200737.12481-4-snitzer@kernel.org>
In-Reply-To: <20230217200737.12481-1-snitzer@kernel.org>
References: <20230217200737.12481-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [PATCH 3/6] dm thin: add cond_resched() to various
 workqueue loops
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
Cc: Mike Snitzer <snitzer@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Otherwise on resource constrained systems these workqueues may be too
greedy.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-thin.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index affd91a53042..6cd105c1cef3 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2209,6 +2209,7 @@ static void process_thin_deferred_bios(struct thin_c *tc)
 			throttle_work_update(&pool->throttle);
 			dm_pool_issue_prefetches(pool->pmd);
 		}
+		cond_resched();
 	}
 	blk_finish_plug(&plug);
 }
@@ -2291,6 +2292,7 @@ static void process_thin_deferred_cells(struct thin_c *tc)
 			else
 				pool->process_cell(tc, cell);
 		}
+		cond_resched();
 	} while (!list_empty(&cells));
 }
 
-- 
2.37.0 (Apple Git-136)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

