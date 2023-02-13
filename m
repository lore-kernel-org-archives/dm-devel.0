Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBB52C636CC
	for <dm-devel@archiver.kernel.org>; Mon, 13 Feb 2023 20:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676319332;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=AbccE0wm0ivnZw/p3TK9jiSAcvgJ7qUAeSpQpBktDjg=;
	b=jQFis80bV96uqmkAJSOABGiVV+1/tuqpxVIfRjRhkH05OyV20BESVjdPwluccI0X+izVLA
	nTMcoy5wNIJwBR3li5GSETksXYkOMQUXcAQXveup29G4sK3PVU5GhXWKQun9sTaHJe+Wd6
	Q1MSDAzwYpO9kx3FEwIxzALbvere66o=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-564-Zx4jZshiPnC4IIAPDyQ5tA-1; Mon, 13 Feb 2023 15:15:30 -0500
X-MC-Unique: Zx4jZshiPnC4IIAPDyQ5tA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3502738149A5;
	Mon, 13 Feb 2023 20:15:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 21491492B03;
	Mon, 13 Feb 2023 20:15:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 103D51946588;
	Mon, 13 Feb 2023 20:15:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2ACCE1946588
 for <dm-devel@listman.corp.redhat.com>; Mon, 13 Feb 2023 20:15:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1E9182026D76; Mon, 13 Feb 2023 20:15:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 161092026D2A
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:15:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 66B58857A89
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:15:17 +0000 (UTC)
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com
 [209.85.160.173]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-175-jzL1eQw9PsW57iAfi-zd3A-2; Mon, 13 Feb 2023 15:15:14 -0500
X-MC-Unique: jzL1eQw9PsW57iAfi-zd3A-2
Received: by mail-qt1-f173.google.com with SMTP id cr22so15169951qtb.10
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 12:15:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=0jRRiRVrOaOlEHGvBBy+iQ+4T1x7PBXcREkttqTpI5M=;
 b=MdhrBkHOGzqYX1fGm0xVpSINtwTaE++mu0ywybyNhO+xIwv9tZJsdtjFiqmzplGBv0
 D26UV7vFDnIc1iZ2dUmZ9tfLmfIIIP/ejFa4dbi1BnAdGxyiYbFoAgNf5BvYFl7+cOfo
 Ez0q0NWVVgXIShtMUByc5/oNrmLz4MUggQXSivKGrFG1wA41IGGGxHZdkFuRmhiHiOZh
 neWSGvplAjqMoKBQsMdER/Ey/XwOCW2PQl4dz3qWeFmElkAGKplZ+gUVVp/pYXiXLDQi
 isyJ5xMXPhiiwX3a7teepNY1rxtY8YJOAwWGwz/bpAgBHeN9vRb/Uu52h4aJNd8fu699
 V/4Q==
X-Gm-Message-State: AO0yUKXn7q6JrR9cCm/acCt0uuc/9jkq2sjVaaVnpPQLjFyviqiNMGzR
 q4ezneBUeJO+vmJUC8Wd+UN2psgFtv59fNA4Ke/+DankRrzpZIwnobVbXjp72ZNWyYjCMwWcV9j
 NpS2yHISk6REX77PTxCF3H/sGN+pRnDjt6ICj0R7UGWQFobwfNLPuFRyA16x5B7OAj4ICvQ==
X-Google-Smtp-Source: AK7set+7Njpf0PKYbmG/2IuRL3bOqMQG7dtxDMbgb5Bc27pyWiV1k8RLdr1FFj1lw1j4Sk2VqwZKyg==
X-Received: by 2002:ac8:5850:0:b0:3b8:4951:57b8 with SMTP id
 h16-20020ac85850000000b003b8495157b8mr48663823qth.15.1676319313719; 
 Mon, 13 Feb 2023 12:15:13 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 y16-20020ac87050000000b003b63dfad2b4sm10037016qtm.0.2023.02.13.12.15.13
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 13 Feb 2023 12:15:13 -0800 (PST)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 13 Feb 2023 15:13:50 -0500
Message-Id: <20230213201401.45973-29-snitzer@kernel.org>
In-Reply-To: <20230213201401.45973-1-snitzer@kernel.org>
References: <20230213201401.45973-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH 28/39] dm: don't indent labels
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-bio-prison-v1.c  | 2 +-
 drivers/md/dm-io.c             | 2 +-
 drivers/md/dm-linear.c         | 2 +-
 drivers/md/dm-zoned-metadata.c | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-bio-prison-v1.c b/drivers/md/dm-bio-prison-v1.c
index 6ff559f436a2..71106e61fd15 100644
--- a/drivers/md/dm-bio-prison-v1.c
+++ b/drivers/md/dm-bio-prison-v1.c
@@ -433,7 +433,7 @@ static int __init dm_bio_prison_init(void)
 
 	return 0;
 
-      bad:
+bad:
 	while (i--)
 		_exits[i]();
 
diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index 9844edc1ae7c..f42d6dd43ae6 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -66,7 +66,7 @@ struct dm_io_client *dm_io_client_create(void)
 
 	return client;
 
-   bad:
+bad:
 	mempool_exit(&client->pool);
 	kfree(client);
 	return ERR_PTR(ret);
diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 874da33f090f..fd164f3b77cd 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -65,7 +65,7 @@ static int linear_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	ti->private = lc;
 	return 0;
 
-      bad:
+bad:
 	kfree(lc);
 	return ret;
 }
diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index c90a8a7fb022..cf9402064aba 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -1342,7 +1342,7 @@ static int dmz_load_sb(struct dmz_metadata *zmd)
 			if (ret == -EINVAL)
 				goto out_kfree;
 		}
-	out_kfree:
+out_kfree:
 		kfree(sb);
 	}
 	return ret;
-- 
2.37.0 (Apple Git-136)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

