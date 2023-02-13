Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F383C6379F
	for <dm-devel@archiver.kernel.org>; Mon, 13 Feb 2023 20:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676319341;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=5njxBpqjRdMN4RYP4lW7hBiII/YbEMw2BeA1YqPFsNA=;
	b=gU8WOpahkf6WMa05/7YzWnUEagUoMpm/htOTjPOVxxhILS9JpqXReMAbyCNk407nhe5Fg4
	SP1FgbMYIKUxeOoWquZTuWARojOimn/GOVNnboW3czXN5JxIYp9BOG/GDzBVzXSNocXhUo
	+b6mUiqiCEd62b+yASVPcNnsbbNJzcE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-90-1xbuXKACONqdrEwBesTkXA-1; Mon, 13 Feb 2023 15:15:38 -0500
X-MC-Unique: 1xbuXKACONqdrEwBesTkXA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CE6A6101A521;
	Mon, 13 Feb 2023 20:15:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BC456140EBF4;
	Mon, 13 Feb 2023 20:15:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8FF881946588;
	Mon, 13 Feb 2023 20:15:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1310F1946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 13 Feb 2023 20:15:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 07396112131B; Mon, 13 Feb 2023 20:15:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 000431121319
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:15:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D7ADD3C18352
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:15:27 +0000 (UTC)
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com
 [209.85.160.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-325-BsMfPak2NKWb9JHCZNeZWA-5; Mon, 13 Feb 2023 15:15:22 -0500
X-MC-Unique: BsMfPak2NKWb9JHCZNeZWA-5
Received: by mail-qt1-f175.google.com with SMTP id q13so15218978qtx.2
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 12:15:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=4Pp22DySfHAmJ4cbt2aGWUJfC2SadezTVjdVb3Vxy/w=;
 b=JNqcxbEsyX/lTtK5iPC0Ap6xm629O3hLIBgNXTLVFa8gVmBYTWHy5ORGjkGEe7lkGJ
 TAD4XsYT18gqXLnzQUsP/uSV23WHzQDTFA9uCAL8oeND87Yaugl8UPFlzkhzr+9PGOft
 +G/fQPn/U3kbVvLRo0P7yOqqxc0jcccVckkZHqdmRQGR8DlOhxsl9zUSvnkRoz+ncAJs
 ymRMofcXX7oPXxvWFOslZmqOkPOatGAxab3bsH7feBUBkyyuAW8lUQHSuwKVD0fyedC+
 QUzectepsdaOhaXPcaYqP5ZFFhRFq1CX1AJAACuZBGbRoq2nk0qdjkdi7h6FSIrlQc9w
 8R4Q==
X-Gm-Message-State: AO0yUKWy4XjBSbVzv0NTXf44mWCqbHfwxrUquQa+YNrHlEF8z8nuvDcl
 FKphGgQrWnMW/16gw8JYCXifiCUiv1S2p9vjUZIynWxvNPjY3fGwPJD7h+myFuvP7t8rq+YPSEh
 5b199DpOL2JUWvjPWR6tiYQEIoqwvUJdtXWR2WgubIXZrY/sBF1krJm19GhNIW0rxg1ajMQ==
X-Google-Smtp-Source: AK7set/xXgGPCEUgzYY46sjSWQuzlvp/0VMG2MjKY9PGzBQ8zl4BkMEXe4ITdv9oJ33JBUCHgoR3eg==
X-Received: by 2002:ac8:5705:0:b0:3b8:3bd9:9c19 with SMTP id
 5-20020ac85705000000b003b83bd99c19mr46470951qtw.54.1676319320270; 
 Mon, 13 Feb 2023 12:15:20 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 r77-20020a374450000000b0073b425f6e33sm2832192qka.100.2023.02.13.12.15.19
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 13 Feb 2023 12:15:19 -0800 (PST)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 13 Feb 2023 15:13:54 -0500
Message-Id: <20230213201401.45973-33-snitzer@kernel.org>
In-Reply-To: <20230213201401.45973-1-snitzer@kernel.org>
References: <20230213201401.45973-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: [dm-devel] [PATCH 32/39] dm: avoid 'do {} while(0)' loop in single
 statement macros
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-integrity.c | 4 ++--
 drivers/md/dm-mpath.c     | 4 +---
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 4729e641bf8b..63cf42ee6017 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -113,9 +113,9 @@ struct journal_entry {
 #endif
 #define journal_entry_get_sector(je)		le64_to_cpu((je)->u.sector)
 #define journal_entry_is_unused(je)		((je)->u.s.sector_hi == cpu_to_le32(-1))
-#define journal_entry_set_unused(je)		do { ((je)->u.s.sector_hi = cpu_to_le32(-1)); } while (0)
+#define journal_entry_set_unused(je)		((je)->u.s.sector_hi = cpu_to_le32(-1))
 #define journal_entry_is_inprogress(je)		((je)->u.s.sector_hi == cpu_to_le32(-2))
-#define journal_entry_set_inprogress(je)	do { ((je)->u.s.sector_hi = cpu_to_le32(-2)); } while (0)
+#define journal_entry_set_inprogress(je)	((je)->u.s.sector_hi = cpu_to_le32(-2))
 
 #define JOURNAL_BLOCK_SECTORS		8
 #define JOURNAL_SECTOR_DATA		((1 << SECTOR_SHIFT) - sizeof(commit_id_t))
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 2524ac702145..9c4583b31e7b 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -472,13 +472,11 @@ static struct pgpath *choose_pgpath(struct multipath *m, size_t nr_bytes)
  * it has been invoked.
  */
 #define dm_report_EIO(m)						\
-do {									\
 	DMDEBUG_LIMIT("%s: returning EIO; QIFNP = %d; SQIFNP = %d; DNFS = %d", \
 		      dm_table_device_name((m)->ti->table),		\
 		      test_bit(MPATHF_QUEUE_IF_NO_PATH, &(m)->flags),	\
 		      test_bit(MPATHF_SAVED_QUEUE_IF_NO_PATH, &(m)->flags), \
-		      dm_noflush_suspending((m)->ti));			\
-} while (0)
+		      dm_noflush_suspending((m)->ti))
 
 /*
  * Check whether bios must be queued in the device-mapper core rather
-- 
2.37.0 (Apple Git-136)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

