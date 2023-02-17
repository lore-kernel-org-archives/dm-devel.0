Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E3B4C05027
	for <dm-devel@archiver.kernel.org>; Fri, 17 Feb 2023 20:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676664472;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=vjhlkPOgA7ttKw1H0CI79hkQdUraoxZqOVzImbbHl64=;
	b=CFFFHErEk03/Ag58+cZ0o0w+DaBUm84fHjTW2OgO3FVt36aEi8vhkMf4WMMPn5mr9C5baV
	k6kUV46bdan0JxnTwzcGYzER6jWvXhybu3H/MGIZrlRWhDU2DhiICCr5HYFVKlxbyzKgRU
	oDNtXtv68lxY8HFcApnD5VEKR/xqi68=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-391-2NW9p56yNBONpqDDIznGEQ-1; Fri, 17 Feb 2023 15:07:49 -0500
X-MC-Unique: 2NW9p56yNBONpqDDIznGEQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D427F18E0923;
	Fri, 17 Feb 2023 20:07:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 350B140C10FA;
	Fri, 17 Feb 2023 20:07:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 12C021946589;
	Fri, 17 Feb 2023 20:07:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B944F1946588
 for <dm-devel@listman.corp.redhat.com>; Fri, 17 Feb 2023 20:07:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A8E6535454; Fri, 17 Feb 2023 20:07:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A122D175A2
 for <dm-devel@redhat.com>; Fri, 17 Feb 2023 20:07:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 81C711C0515F
 for <dm-devel@redhat.com>; Fri, 17 Feb 2023 20:07:43 +0000 (UTC)
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com
 [209.85.160.178]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-135-VA1BbkUxP4iGUIEhN9mFkg-1; Fri, 17 Feb 2023 15:07:41 -0500
X-MC-Unique: VA1BbkUxP4iGUIEhN9mFkg-1
Received: by mail-qt1-f178.google.com with SMTP id v3so1880363qta.2
 for <dm-devel@redhat.com>; Fri, 17 Feb 2023 12:07:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=AfXkCHjWxh7zwYWrNF8t4vHUyFiRRvNGcQ6aFfNYqdw=;
 b=VtXNrj3EU+IznvCpfc+FvXdsqPhKVQ2uUeHIMjXf89df4JU0DDUM3R1Rq8H7Sem6mU
 2jvwHSJ6D8W/bAgGvWmgDkak6DNq1hz1DtNMW9PlhlTV3nyivqzEjhfkx/8WoJ28gKbp
 mk73TNapW3LOtqPklyvu8U2Stc3dBcwHE4UKrmYxFiv2FmZMnRnbemb/2f6FXyoOKEqJ
 zFg092OfpsZKprfB23Z5A7HzvIZVT0bFJrAhl73SsUN0oRW4jZghpYACmUquXV29Efp0
 BCKrgff2+SvGc3GB6x8njMa3vXUZku28qsY/WB4Zd3KF+k1DFPKD1exAZhkZSlqrNq4u
 cplQ==
X-Gm-Message-State: AO0yUKWKXowBhgjQPVhhC395wk31uIlS8XC2WdkndfjOHIJYruzigeNv
 6gYD38IiZSvM+b1Ejy4xHiKuOBTPdZaWYYbvg/p3yBqUYYTfujupx9uEBqYSszaYQ6kuMVFYtza
 9lIS3vkiQawsrhNKEB6DFoeATZp4Vr0TvvTju3BVwCPhLuZevUSlFAsAie7kroEDdFOqYDA==
X-Google-Smtp-Source: AK7set8KfdKWo4WS9aMzfmIT5ZPP70gz3Rzk62kbY0JDOF0LuAl01QiRZvnnAxyK31Jhgbs+eMLH4g==
X-Received: by 2002:a05:622a:199f:b0:3b9:ba79:80d7 with SMTP id
 u31-20020a05622a199f00b003b9ba7980d7mr1926632qtc.12.1676664460712; 
 Fri, 17 Feb 2023 12:07:40 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 he29-20020a05622a601d00b003bd0f0b26b0sm3063146qtb.77.2023.02.17.12.07.40
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 17 Feb 2023 12:07:40 -0800 (PST)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Fri, 17 Feb 2023 15:07:32 -0500
Message-Id: <20230217200737.12481-2-snitzer@kernel.org>
In-Reply-To: <20230217200737.12481-1-snitzer@kernel.org>
References: <20230217200737.12481-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] [PATCH 1/6] dm: add cond_resched() to dm_wq_work()
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
Cc: Mike Snitzer <snitzer@kernel.org>, Pingfan Liu <piliu@redhat.com>,
 Ming Lei <ming.lei@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Pingfan Liu <piliu@redhat.com>

Otherwise the while() loop in dm_wq_work() can result in a "dead
loop" on systems that have preemption disabled. This is particularly
problematic on single cpu systems.

Cc: stable@vger.kernel.org
Signed-off-by: Pingfan Liu <piliu@redhat.com>
Acked-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 90b64bfc63b0..15b91959e433 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2570,6 +2570,7 @@ static void dm_wq_work(struct work_struct *work)
 			break;
 
 		submit_bio_noacct(bio);
+		cond_resched();
 	}
 }
 
-- 
2.37.0 (Apple Git-136)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

