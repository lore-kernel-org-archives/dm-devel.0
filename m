Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B35CC636CC
	for <dm-devel@archiver.kernel.org>; Mon, 13 Feb 2023 20:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676319342;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=oQMlZmfuE2KCee3vit1wDUjSlcD9qZZQDkBHVLDCFlg=;
	b=Rawwtr+hl/FiBcI+gKkVXovS1YVpOj8P9R2a8+G65f2auJ5HExl1HV4zPH7kyeeQ93NIVF
	e4+KXFfs5ue4ZIWaiWYq2i51GAkveT2qJtUx7HaesV6VVm1Duj3n8R+djtjk6ebkzIiB3S
	GcXkpU7xNFa3rQLT64DOYBmmzVEVcAE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-312-M-S1jw0pM7O7QMZFyUJytw-1; Mon, 13 Feb 2023 15:15:38 -0500
X-MC-Unique: M-S1jw0pM7O7QMZFyUJytw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 39FDF100F909;
	Mon, 13 Feb 2023 20:15:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 233101121318;
	Mon, 13 Feb 2023 20:15:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 10B151946588;
	Mon, 13 Feb 2023 20:15:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C43331946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 13 Feb 2023 20:15:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B31A1492B04; Mon, 13 Feb 2023 20:15:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AAEA6492B03
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:15:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8E755882832
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:15:30 +0000 (UTC)
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com
 [209.85.160.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-571-ExiZH07DM-mzIdvRKWD8yQ-6; Mon, 13 Feb 2023 15:15:28 -0500
X-MC-Unique: ExiZH07DM-mzIdvRKWD8yQ-6
Received: by mail-qt1-f175.google.com with SMTP id 5so15178559qtp.9
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 12:15:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=frX3fYFq7shQuUmgK4wWenIZKQnNEkd1J8tyM9viHKA=;
 b=7IEX6FmrM176ZYSM10rW2iBIKPqT4NhiNBUjxb5mGe7QIchLNozBRQlgZg7nQ2e1fG
 Aooji2u9r0r/WDASrpxcHPCqt4OkFYc0ih4e8HG6zKIiwbTdiaSz4yejKpYcoQfOuNtN
 0hX5IOlvDg4QSpileT6KHMlp/0NmKyLUyIyPdXYRHmXfPHKlL3dxbaNHaipNciRmTkKh
 dys7H0VzXE7S/aPGSuMhLRCof6HstF9Z3r0tTqAXIzxnXGX4RYWE3OjhDswYd2IQdgXx
 6v0s5gr6OjzNC4RCrTe3S0qJXVil8Ry7LXI80Ua7hE4ROIV/X3qPg8/zfsW9ffACTVAQ
 kMjw==
X-Gm-Message-State: AO0yUKWDdYHM7sBM7+pCrxiEjlMSAv1+qwIGd05BtufSztav9Ys5du8K
 WZErfXAouS5Vo4/cwlpIKoEJmIiMj1ZAGPdeENARP82Kd2BzJGlnXPpzk98dcrlBoqlMq38Hiwc
 q7lcneFyW24l7SdfUCPfmJgehQ4JhGngcfkFeMOT0NZrt0rsTjMjeHzv8hmnJ6c5jaYLFiQ==
X-Google-Smtp-Source: AK7set/766+HhjgwWQ/lww9f3Brkup/ae+TpOIAHW6yjG7PBxIMObjbPmSLeBtZe6oxhkvQ1vj+uRA==
X-Received: by 2002:a05:622a:cd:b0:3b0:98c3:217c with SMTP id
 p13-20020a05622a00cd00b003b098c3217cmr43837868qtw.6.1676319327216; 
 Mon, 13 Feb 2023 12:15:27 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 k17-20020a05622a03d100b003bb7af2125fsm10061181qtx.90.2023.02.13.12.15.26
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 13 Feb 2023 12:15:26 -0800 (PST)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 13 Feb 2023 15:13:58 -0500
Message-Id: <20230213201401.45973-37-snitzer@kernel.org>
In-Reply-To: <20230213201401.45973-1-snitzer@kernel.org>
References: <20230213201401.45973-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] [PATCH 36/39] dm ioctl: prefer strscpy() instead of
 strlcpy()
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index e1eddb91cc2b..1fed9a9719f6 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -937,9 +937,9 @@ static struct hash_cell *__find_device_hash_cell(struct dm_ioctl *param)
 	 * Sneakily write in both the name and the uuid
 	 * while we have the cell.
 	 */
-	strlcpy(param->name, hc->name, sizeof(param->name));
+	strscpy(param->name, hc->name, sizeof(param->name));
 	if (hc->uuid)
-		strlcpy(param->uuid, hc->uuid, sizeof(param->uuid));
+		strscpy(param->uuid, hc->uuid, sizeof(param->uuid));
 	else
 		param->uuid[0] = '\0';
 
-- 
2.37.0 (Apple Git-136)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

