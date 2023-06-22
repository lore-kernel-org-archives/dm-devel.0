Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77F88C001DF
	for <dm-devel@archiver.kernel.org>; Fri, 23 Jun 2023 05:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687498015;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=qw9Hv5nb/943eLJ9BkopCcTl7iMD5KeWNuFSwcdLv6k=;
	b=dqQskHbclxEvV6zztPL+Yj7sfXw9lK/3aVYkBiwG+Und8Kqnt0URsLhQ8Wpzgm3dZipUTY
	9nsM9ffQ91c0rlzGndPclssB4jpNmX1X05jRUoL6qIZrMAMXB4NgGWEKntJ4S5ZliOReCf
	kzI8shpisHEPWhwb9LKAQBJBhRVUKqQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-557-IiVw3_jKPJCO8td3KLeyuw-1; Fri, 23 Jun 2023 01:26:53 -0400
X-MC-Unique: IiVw3_jKPJCO8td3KLeyuw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C8FED2800C32;
	Fri, 23 Jun 2023 05:26:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B861340C2063;
	Fri, 23 Jun 2023 05:26:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 29BD519452CF;
	Fri, 23 Jun 2023 05:25:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1A1171946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 22 Jun 2023 08:57:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EF165C1ED96; Thu, 22 Jun 2023 08:57:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E6D95C1ED98
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 08:57:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CBAE83C13507
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 08:57:38 +0000 (UTC)
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com
 [209.85.214.171]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-298-k8HnbdVvNiuc88NuBL9_wg-1; Thu, 22 Jun 2023 04:57:32 -0400
X-MC-Unique: k8HnbdVvNiuc88NuBL9_wg-1
Received: by mail-pl1-f171.google.com with SMTP id
 d9443c01a7336-1b693afe799so2466745ad.1
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 01:57:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1687424252; x=1690016252;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=YpqAnPCFjvBxCUJyQNRij7IdVYJH6Jib7EICYqtSs4Q=;
 b=Q860dJXBcTmUHNDlR9dI5JXlLBTjzlp968OlKsTMXE9/eu2XZXxL7+CD6p5Fyg7MDV
 VNbf5ZDjOKBPGxBSpCAv66HGj4K4vVPdYLqj8SzBGbLyjpN8xvNmueY/eYeEhxX3kY6M
 2wyu5LQnP7Td1UTyOjqhtsteT1UDM11PbsUCSllnUM8CmzGHRaD/bVyhxgOaB0UC/MOL
 XmRWtY8f/t+DveboSKiv3AA/r1YFpHwWvZfCxbX6WewK0P+NiPXl33NFXkOgToF67KRi
 0G+2IhrxGAwfjtAXWa8WUIfFehnQ0fuat2+NcaAThPAb1eDIuEafzecs/TicH/wHUnOr
 CKsw==
X-Gm-Message-State: AC+VfDwDonyoMjjN+2+wP0fS9vxmQHIV5SNxlWacJuKovdvaEGaFe++u
 vONU2rmmSX7+QzXW8Cb0o2Dwjw==
X-Google-Smtp-Source: ACHHUZ6FoF5W+f0N2ZUpFBUVBh1vs3Mj6G9dcM80ve0PhcTP+4niqZQRBrFmYJGvwbhs9MGB3E6MuA==
X-Received: by 2002:a17:903:32c4:b0:1b3:e352:6d88 with SMTP id
 i4-20020a17090332c400b001b3e3526d88mr21673124plr.6.1687424251794; 
 Thu, 22 Jun 2023 01:57:31 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([139.177.225.254])
 by smtp.gmail.com with ESMTPSA id
 h2-20020a170902f7c200b001b549fce345sm4806971plw.230.2023.06.22.01.57.24
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 22 Jun 2023 01:57:31 -0700 (PDT)
From: Qi Zheng <zhengqi.arch@bytedance.com>
To: akpm@linux-foundation.org, david@fromorbit.com, tkhai@ya.ru,
 vbabka@suse.cz, roman.gushchin@linux.dev, djwong@kernel.org,
 brauner@kernel.org, paulmck@kernel.org, tytso@mit.edu
Date: Thu, 22 Jun 2023 16:53:32 +0800
Message-Id: <20230622085335.77010-27-zhengqi.arch@bytedance.com>
In-Reply-To: <20230622085335.77010-1-zhengqi.arch@bytedance.com>
References: <20230622085335.77010-1-zhengqi.arch@bytedance.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Fri, 23 Jun 2023 05:25:40 +0000
Subject: [dm-devel] [PATCH 26/29] mm: shrinker: make count and scan in
 shrinker debugfs lockless
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
Cc: linux-bcache@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-nfs@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, virtualization@lists.linux-foundation.org,
 linux-raid@vger.kernel.org, linux-mm@kvack.org, dm-devel@redhat.com,
 Qi Zheng <zhengqi.arch@bytedance.com>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: bytedance.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Like global and memcg slab shrink, also make count and scan
operations in memory shrinker debugfs lockless.

The debugfs_remove_recursive() will wait for debugfs_file_put()
to return, so there is no need to call rcu_read_lock() before
calling shrinker_try_get().

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/shrinker_debug.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/shrinker_debug.c b/mm/shrinker_debug.c
index 3ab53fad8876..c18fa9b6b7f0 100644
--- a/mm/shrinker_debug.c
+++ b/mm/shrinker_debug.c
@@ -55,8 +55,8 @@ static int shrinker_debugfs_count_show(struct seq_file *m, void *v)
 	if (!count_per_node)
 		return -ENOMEM;
 
-	ret = down_read_killable(&shrinker_rwsem);
-	if (ret) {
+	ret = shrinker_try_get(shrinker);
+	if (!ret) {
 		kfree(count_per_node);
 		return ret;
 	}
@@ -92,7 +92,7 @@ static int shrinker_debugfs_count_show(struct seq_file *m, void *v)
 	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)) != NULL);
 
 	rcu_read_unlock();
-	up_read(&shrinker_rwsem);
+	shrinker_put(shrinker);
 
 	kfree(count_per_node);
 	return ret;
@@ -146,8 +146,8 @@ static ssize_t shrinker_debugfs_scan_write(struct file *file,
 		return -EINVAL;
 	}
 
-	ret = down_read_killable(&shrinker_rwsem);
-	if (ret) {
+	ret = shrinker_try_get(shrinker);
+	if (!ret) {
 		mem_cgroup_put(memcg);
 		return ret;
 	}
@@ -159,7 +159,7 @@ static ssize_t shrinker_debugfs_scan_write(struct file *file,
 
 	shrinker->scan_objects(shrinker, &sc);
 
-	up_read(&shrinker_rwsem);
+	shrinker_put(shrinker);
 	mem_cgroup_put(memcg);
 
 	return size;
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

