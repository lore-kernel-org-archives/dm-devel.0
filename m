Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2580C6379F
	for <dm-devel@archiver.kernel.org>; Mon, 13 Feb 2023 20:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676319344;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=wXlA4u6NfH5dc7M6uGQccztSjy35IRmhd9jJV7OO2oY=;
	b=GAl9TPRm7oOwlGRlWRIaseEmcybwy/hDOReUaRoKmCCCZcb6qS1b47n9MEc4n8iK40+IJG
	fsUXx2PjNdopOqZMwXL7OeKODUxK4GPxKp1pURH9aq02GG/fcINH79HyBOiwybSn/dujOD
	6PiOV0PNdQFJc+QRS4zpJ6rsQOuoHws=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-191-_uWPT8jNN1-YXlcNTMp5aw-1; Mon, 13 Feb 2023 15:15:41 -0500
X-MC-Unique: _uWPT8jNN1-YXlcNTMp5aw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 616C4100F908;
	Mon, 13 Feb 2023 20:15:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 196F9492B16;
	Mon, 13 Feb 2023 20:15:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 077401946595;
	Mon, 13 Feb 2023 20:15:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B283B194658C
 for <dm-devel@listman.corp.redhat.com>; Mon, 13 Feb 2023 20:15:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A3736C16022; Mon, 13 Feb 2023 20:15:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9CBD0C158BB
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:15:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 78FCB100F90B
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:15:31 +0000 (UTC)
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com
 [209.85.219.44]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-508-mSJZzBocMBetXEVDZScOGQ-1; Mon, 13 Feb 2023 15:15:29 -0500
X-MC-Unique: mSJZzBocMBetXEVDZScOGQ-1
Received: by mail-qv1-f44.google.com with SMTP id di14so4835522qvb.12
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 12:15:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=aj9rBpFrf+iPMbhUhTQXYH7tqMjv1u6bigkWiMvjL90=;
 b=fJvYnU1w5puP4GYzkUHDXsx+gkBMXC1noZxQ8M4Zlg+m33nG7x+8dwmHW+yXS/VDsK
 4fOKZUUxXbRauCKWzPo2rCA21GV0HTtt2UIZkFHjz3F6r7oWW1yByZQPM0ckpmcHYVnS
 wzmJd7UNTXCQEEC7uuSRyKyU1dHPs/bbzZswHsDyAYXeAKqg2bbOarH0HCMf3+QyGCzN
 fIqynpULe4gh3VQiTg6quT2THu+HBNhKZ95IF1MPxTlQdXl4tsQTReRsT2BTkyy9H3lh
 VrP8VZ0P7RRSzskWp0qCFk19/tpoEWP3OPjAxPDyVwegBjXLeOB8GFuUsEm6alPh8l66
 fR7Q==
X-Gm-Message-State: AO0yUKVaVHhjYhqux8r7CN3CZGqUImrcyRTNufLjXXIkzqyKJtJTYAfB
 Sn6WP4v2p8RxrvxdY2HcNMV6L6+0xhhyTk9S3mUFRPZDQUwr0RjLqslYM6XT1BbTQoS6rmlAiuX
 yQnvWmOky1nkhHN5gfscGM7r5CvdSjbq1dRSdqrdjLD4my94qu5GvdKzecyKGjV9YW5ZU6Q==
X-Google-Smtp-Source: AK7set+JRrvYYBw4Pj1dcLyImeM28L+J/NnIZNsWCDqMloTM29b1aU1g8k+FjruSuGdrn4SjB+jUGg==
X-Received: by 2002:a05:6214:2466:b0:56e:a6f1:8cf with SMTP id
 im6-20020a056214246600b0056ea6f108cfmr478303qvb.6.1676319328721; 
 Mon, 13 Feb 2023 12:15:28 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 191-20020a370bc8000000b0071a291f0a4asm10443145qkl.27.2023.02.13.12.15.28
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 13 Feb 2023 12:15:28 -0800 (PST)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 13 Feb 2023 15:13:59 -0500
Message-Id: <20230213201401.45973-38-snitzer@kernel.org>
In-Reply-To: <20230213201401.45973-1-snitzer@kernel.org>
References: <20230213201401.45973-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [PATCH 37/39] dm: fix suspect indent whitespace
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
Cc: ebiggers@kernel.org, Heinz Mauelshagen <heinzm@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-cache-target.c | 2 +-
 drivers/md/dm-raid.c         | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index a435edfb6a33..74ad5f27a257 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -189,7 +189,7 @@ static void issue_after_commit(struct batcher *b, struct bio *bio)
 	spin_unlock_irq(&b->lock);
 
 	if (commit_scheduled)
-	       async_commit(b);
+		async_commit(b);
 }
 
 /*
diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 390f23150ff4..69ac445d20a7 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -1082,7 +1082,7 @@ static int validate_raid_redundancy(struct raid_set *rs)
 			if ((!rs->dev[i].rdev.sb_page ||
 			     !test_bit(In_sync, &rs->dev[i].rdev.flags)) &&
 			    (++rebuilds_per_group >= copies))
-					goto too_many;
+				goto too_many;
 		}
 		break;
 	default:
-- 
2.37.0 (Apple Git-136)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

