Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4D47C0729B
	for <dm-devel@archiver.kernel.org>; Tue,  8 Aug 2023 06:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691477628;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=otnc/qtVF+y2yBj7o9GZ8tlpjkQTTLrzNYkI5M7evhY=;
	b=fjXfkulYd8e7TUZNNkESQKDantB1SFmtezPLTPmqE1OG0HYtiXbnHrgNjrRcWwqTQUD4AS
	KVzzg7WrWyG9MNxj+BArcCQAh0/pZxvxbNm/sqjfBa6GDvRWuWa8m4mIzuQEL2UI4hCJJe
	4rm4j3VgArAQAQj/dlRX2ZM/fyO8bnw=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-550-yMYqeWmmOAya3YIzGJ7ROg-1; Tue, 08 Aug 2023 02:53:45 -0400
X-MC-Unique: yMYqeWmmOAya3YIzGJ7ROg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9DCB1382C05A;
	Tue,  8 Aug 2023 06:53:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 81B6BC15BC0;
	Tue,  8 Aug 2023 06:53:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9DEF11947224;
	Tue,  8 Aug 2023 06:53:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 227101946586
 for <dm-devel@listman.corp.redhat.com>; Mon,  7 Aug 2023 11:20:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 02F792166B27; Mon,  7 Aug 2023 11:20:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EFDF32166B25
 for <dm-devel@redhat.com>; Mon,  7 Aug 2023 11:20:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D0F8229AB3E8
 for <dm-devel@redhat.com>; Mon,  7 Aug 2023 11:20:02 +0000 (UTC)
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com
 [209.85.216.45]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-257-s5-sswOhNHu-nN1k50sdwg-1; Mon, 07 Aug 2023 07:20:01 -0400
X-MC-Unique: s5-sswOhNHu-nN1k50sdwg-1
Received: by mail-pj1-f45.google.com with SMTP id
 98e67ed59e1d1-2680edb9767so931610a91.0
 for <dm-devel@redhat.com>; Mon, 07 Aug 2023 04:20:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1691407200; x=1692012000;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=X5ij/O+E/bk/tTzX9mgxwiCynzBHcXx4EKtI9EsHayo=;
 b=cmC86kvbWHv0moaUXWIdFOnWmWAPOTuu07xiGtMbgSPclZFqPigxKIW2yzJm/12iP1
 q6dudo4kD9BNYqqs/+U7cLx28tRp99CIZ3hTaN+xZYPUD0iA9lLRC1Rw2igDw9V62ZYp
 Yz/F2QIF4GDbwMxG3913IvA1KDQIJhZLbckgmaIbgyyXo/p8D80JTl97n3CecD1YM/CU
 KuM2XWnPywY3YUMOEbIBQcS4Crp3auMrfR5ZqO2MNASIGBogcHfEJN6ibA2D6isEhB/6
 9vMl5OQziLNacnLFXweAQ7xiYTL8+tE+6UfUcYBNX5CbqZIbWXDXSE7LJ7ucUOH3hgwJ
 Bi8w==
X-Gm-Message-State: AOJu0YxyJvflkl9TlZ9ADM7fKVivcKz0YBCmayCwusya0qXaApjfp9NY
 WQeTc5QQ2mPJUQCBbRO/0Rohxg==
X-Google-Smtp-Source: AGHT+IH1iUQIXRu8fJbzxUHSh+kWmc44BJdJFh0ZxZy41KSEiq7lusFAb/6JfkXEPdg45Q03TKbByg==
X-Received: by 2002:a17:90a:9c3:b0:269:41cf:7212 with SMTP id
 61-20020a17090a09c300b0026941cf7212mr4973775pjo.4.1691407200010; 
 Mon, 07 Aug 2023 04:20:00 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([203.208.167.146])
 by smtp.gmail.com with ESMTPSA id
 y13-20020a17090aca8d00b0025be7b69d73sm5861191pjt.12.2023.08.07.04.19.47
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 07 Aug 2023 04:19:59 -0700 (PDT)
From: Qi Zheng <zhengqi.arch@bytedance.com>
To: akpm@linux-foundation.org, david@fromorbit.com, tkhai@ya.ru,
 vbabka@suse.cz, roman.gushchin@linux.dev, djwong@kernel.org,
 brauner@kernel.org, paulmck@kernel.org, tytso@mit.edu,
 steven.price@arm.com, cel@kernel.org, senozhatsky@chromium.org,
 yujie.liu@intel.com, gregkh@linuxfoundation.org, muchun.song@linux.dev,
 simon.horman@corigine.com, dlemoal@kernel.org
Date: Mon,  7 Aug 2023 19:09:35 +0800
Message-Id: <20230807110936.21819-48-zhengqi.arch@bytedance.com>
In-Reply-To: <20230807110936.21819-1-zhengqi.arch@bytedance.com>
References: <20230807110936.21819-1-zhengqi.arch@bytedance.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mailman-Approved-At: Tue, 08 Aug 2023 06:53:24 +0000
Subject: [dm-devel] [PATCH v4 47/48] mm: shrinker: hold write lock to
 reparent shrinker nr_deferred
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
Cc: kvm@vger.kernel.org, dri-devel@lists.freedesktop.org,
 virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
 dm-devel@redhat.com, linux-mtd@lists.infradead.org, x86@kernel.org,
 cluster-devel@redhat.com, xen-devel@lists.xenproject.org,
 linux-ext4@vger.kernel.org, linux-arm-msm@vger.kernel.org, rcu@vger.kernel.org,
 linux-bcache@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>,
 linux-raid@vger.kernel.org, linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: bytedance.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

For now, reparent_shrinker_deferred() is the only holder of read lock of
shrinker_rwsem. And it already holds the global cgroup_mutex, so it will
not be called in parallel.

Therefore, in order to convert shrinker_rwsem to shrinker_mutex later,
here we change to hold the write lock of shrinker_rwsem to reparent.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/shrinker.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/shrinker.c b/mm/shrinker.c
index fee6f62904fb..a12dede5d21f 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -299,7 +299,7 @@ void reparent_shrinker_deferred(struct mem_cgroup *memcg)
 		parent = root_mem_cgroup;
 
 	/* Prevent from concurrent shrinker_info expand */
-	down_read(&shrinker_rwsem);
+	down_write(&shrinker_rwsem);
 	for_each_node(nid) {
 		child_info = shrinker_info_protected(memcg, nid);
 		parent_info = shrinker_info_protected(parent, nid);
@@ -312,7 +312,7 @@ void reparent_shrinker_deferred(struct mem_cgroup *memcg)
 			}
 		}
 	}
-	up_read(&shrinker_rwsem);
+	up_write(&shrinker_rwsem);
 }
 #else
 static int shrinker_memcg_alloc(struct shrinker *shrinker)
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

