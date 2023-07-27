Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C70CC00528
	for <dm-devel@archiver.kernel.org>; Thu, 27 Jul 2023 17:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690480511;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=3iovA8XEB/q5WM6i5v/njqSxGczLAfxV299Gpnkrkkc=;
	b=dbgxIuN3e8W8W3DsIuD02+MkEq1yLmEmkYJknTqwvRn3lWgVAyokpM161A8E1/NixhMuGJ
	uVzSLIYCM6nseLn0+gITO7LlDqpTiUx7HBtofgbByPgJEsZZsNYV+a6T8uFDdxiwGTLBBX
	nkjlFwaETF26KTvowwLX1SjYS46SJBA=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-78-mdDAe0zNNBKJzpEB7giElA-1; Thu, 27 Jul 2023 13:55:08 -0400
X-MC-Unique: mdDAe0zNNBKJzpEB7giElA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6EA4928237D4;
	Thu, 27 Jul 2023 17:54:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5815C4094DC0;
	Thu, 27 Jul 2023 17:54:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BCC331946A78;
	Thu, 27 Jul 2023 17:54:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1C0021946A6C
 for <dm-devel@listman.corp.redhat.com>; Thu, 27 Jul 2023 08:06:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DF6841121339; Thu, 27 Jul 2023 08:06:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D77811121330
 for <dm-devel@redhat.com>; Thu, 27 Jul 2023 08:06:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8863238149B7
 for <dm-devel@redhat.com>; Thu, 27 Jul 2023 08:06:03 +0000 (UTC)
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com
 [209.85.210.171]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-374-1_i0__btPpuQv9FzZfOYrA-1; Thu, 27 Jul 2023 04:06:01 -0400
X-MC-Unique: 1_i0__btPpuQv9FzZfOYrA-1
Received: by mail-pf1-f171.google.com with SMTP id
 d2e1a72fcca58-686f6231bdeso112242b3a.1
 for <dm-devel@redhat.com>; Thu, 27 Jul 2023 01:06:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1690445160; x=1691049960;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=CmSKD1W4o1llBpukOwDAPdWOg+LYzWoL67ya0UPwqvg=;
 b=bSB2TSpOsNm9MJMNz7/MxtfJtV4/ROJe++7iHAfJ2TGTLMxlMINs9wtpb24UODgjOZ
 Q+pOk+rM6ANxnLHSEPEsGr/c9rK7zLFNCBKS+vXcln6zQzfflDptQ784tyB0TfJoxaUZ
 zheju4pypQf3NUuG/dPha4AZ0D2Xi3vxK/F+4qXyNQqVZ8Sbj1STglFarjf/1F4GntoH
 qQPrEThHr7KeOC1oqMShRlY4QVgHvX2HhOfPa0Qq/mG/hx92gqMP9qGyURpIV86KwhFs
 p2IbpOGQAOnqXa4yNgcBAkVCuimBnPTWHkiJ/WWW2MyJ3u5wCN30ExCWG8SDF1VylViE
 eOfg==
X-Gm-Message-State: ABy/qLaKWl2WS7D0YMa5/VcmFN7ezbWsL/nYdcXfjL3ZvB/+qlpY0jdu
 UaOcFQnmBa1uLA7Pg5lYNoRczw==
X-Google-Smtp-Source: APBJJlGsBl3klUilUFzaktHEHOMbkNlcOB/1K8g6HjcIbYlgfdxi92AgDTolw1HjCRkDLU6/tzA6hQ==
X-Received: by 2002:a05:6a21:78a8:b0:137:3eba:b81f with SMTP id
 bf40-20020a056a2178a800b001373ebab81fmr6002609pzc.3.1690445159927; 
 Thu, 27 Jul 2023 01:05:59 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([203.208.167.147])
 by smtp.gmail.com with ESMTPSA id
 j8-20020aa78d08000000b006828e49c04csm885872pfe.75.2023.07.27.01.05.48
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 27 Jul 2023 01:05:59 -0700 (PDT)
From: Qi Zheng <zhengqi.arch@bytedance.com>
To: akpm@linux-foundation.org, david@fromorbit.com, tkhai@ya.ru,
 vbabka@suse.cz, roman.gushchin@linux.dev, djwong@kernel.org,
 brauner@kernel.org, paulmck@kernel.org, tytso@mit.edu,
 steven.price@arm.com, cel@kernel.org, senozhatsky@chromium.org,
 yujie.liu@intel.com, gregkh@linuxfoundation.org, muchun.song@linux.dev
Date: Thu, 27 Jul 2023 16:04:14 +0800
Message-Id: <20230727080502.77895-2-zhengqi.arch@bytedance.com>
In-Reply-To: <20230727080502.77895-1-zhengqi.arch@bytedance.com>
References: <20230727080502.77895-1-zhengqi.arch@bytedance.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mailman-Approved-At: Thu, 27 Jul 2023 17:54:53 +0000
Subject: [dm-devel] [PATCH v3 01/49] binder: fix memory leak in binder_init()
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
Cc: kvm@vger.kernel.org, Carlos Llamas <cmllamas@google.com>,
 dri-devel@lists.freedesktop.org, virtualization@lists.linux-foundation.org,
 linux-mm@kvack.org, dm-devel@redhat.com, linux-mtd@lists.infradead.org,
 x86@kernel.org, cluster-devel@redhat.com, xen-devel@lists.xenproject.org,
 linux-ext4@vger.kernel.org, linux-arm-msm@vger.kernel.org, rcu@vger.kernel.org,
 linux-bcache@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>,
 linux-raid@vger.kernel.org, linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: bytedance.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

In binder_init(), the destruction of binder_alloc_shrinker_init() is not
performed in the wrong path, which will cause memory leaks. So this commit
introduces binder_alloc_shrinker_exit() and calls it in the wrong path to
fix that.

Fixes: f2517eb76f1f ("android: binder: Add global lru shrinker to binder")
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Carlos Llamas <cmllamas@google.com>
---
 drivers/android/binder.c       | 1 +
 drivers/android/binder_alloc.c | 6 ++++++
 drivers/android/binder_alloc.h | 1 +
 3 files changed, 8 insertions(+)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 486c8271cab7..d720f93d8b19 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -6617,6 +6617,7 @@ static int __init binder_init(void)
 
 err_alloc_device_names_failed:
 	debugfs_remove_recursive(binder_debugfs_dir_entry_root);
+	binder_alloc_shrinker_exit();
 
 	return ret;
 }
diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
index 662a2a2e2e84..e3db8297095a 100644
--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -1087,6 +1087,12 @@ int binder_alloc_shrinker_init(void)
 	return ret;
 }
 
+void binder_alloc_shrinker_exit(void)
+{
+	unregister_shrinker(&binder_shrinker);
+	list_lru_destroy(&binder_alloc_lru);
+}
+
 /**
  * check_buffer() - verify that buffer/offset is safe to access
  * @alloc: binder_alloc for this proc
diff --git a/drivers/android/binder_alloc.h b/drivers/android/binder_alloc.h
index 138d1d5af9ce..dc1e2b01dd64 100644
--- a/drivers/android/binder_alloc.h
+++ b/drivers/android/binder_alloc.h
@@ -129,6 +129,7 @@ extern struct binder_buffer *binder_alloc_new_buf(struct binder_alloc *alloc,
 						  int pid);
 extern void binder_alloc_init(struct binder_alloc *alloc);
 extern int binder_alloc_shrinker_init(void);
+extern void binder_alloc_shrinker_exit(void);
 extern void binder_alloc_vma_close(struct binder_alloc *alloc);
 extern struct binder_buffer *
 binder_alloc_prepare_to_free(struct binder_alloc *alloc,
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

