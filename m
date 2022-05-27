Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA48AC433EF
	for <dm-devel@archiver.kernel.org>; Fri, 27 May 2022 02:47:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-336-m6K5_4CXNZCmxhKH6hMzbQ-1; Thu, 26 May 2022 22:47:11 -0400
X-MC-Unique: m6K5_4CXNZCmxhKH6hMzbQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9F417185A7BA;
	Fri, 27 May 2022 02:47:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DC5242166B26;
	Fri, 27 May 2022 02:47:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AAC3D1932129;
	Fri, 27 May 2022 02:47:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CE3A31947052
 for <dm-devel@listman.corp.redhat.com>; Fri, 27 May 2022 02:47:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BC0E41410DD7; Fri, 27 May 2022 02:47:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B7D331410DD5
 for <dm-devel@redhat.com>; Fri, 27 May 2022 02:47:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4560C3C021A5
 for <dm-devel@redhat.com>; Fri, 27 May 2022 02:47:05 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com
 [45.249.212.187]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-575-Q0ZbHO8jN2G152FxRP7GUw-1; Thu, 26 May 2022 22:47:00 -0400
X-MC-Unique: Q0ZbHO8jN2G152FxRP7GUw-1
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.57])
 by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4L8TF917YWzgYN4;
 Fri, 27 May 2022 10:26:05 +0800 (CST)
Received: from dggpemm500014.china.huawei.com (7.185.36.153) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 27 May 2022 10:27:38 +0800
Received: from [10.174.177.211] (10.174.177.211) by
 dggpemm500014.china.huawei.com (7.185.36.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 27 May 2022 10:27:37 +0800
Message-ID: <d76b39d2-d6a8-8cb0-a1de-aa684c7371b8@huawei.com>
Date: Fri, 27 May 2022 10:27:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski
 <bmarzins@redhat.com>, Martin Wilck <mwilck@suse.com>, dm-devel mailing list
 <dm-devel@redhat.com>
From: Wu Guanghao <wuguanghao3@huawei.com>
X-Originating-IP: [10.174.177.211]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500014.china.huawei.com (7.185.36.153)
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: [dm-devel] [PATCH]dm_get_map: fix segfault when can't found target
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
Cc: lixiaokeng@huawei.com, linfeilong@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

We got a segfault when we test multipath + iscsi.

(gdb) bt
#0  __strlen_avx2 () at ../sysdeps/x86_64/multiarch/strlen-avx2.S:74
#1  0x00007f694306cd23 in __GI___strdup (s=0x0) at strdup.c:41
#2  0x00007f69433a147c in dm_get_map (name=0x55d4bc090320 "3600140537cde137ea8c43d8a971462c7",
    size=size@entry=0x55d4bc0270d8, outparams=outparams@entry=0x7f6941add640) at devmapper.c:688
#3  0x00007f69433cbbdf in update_multipath_table (mpp=mpp@entry=0x55d4bc026f30,
    pathvec=pathvec@entry=0x55d4bc063990, flags=flags@entry=0) at structs_vec.c:426
#4  0x00007f69433cbfe5 in update_multipath_strings (mpp=0x55d4bc026f30, pathvec=0x55d4bc063990)
    at structs_vec.c:526
#5  0x000055d4bb52e03e in check_path (vecs=0x55d4bbfad760, pp=0x7f692402d270, ticks=<optimized out>)
    at main.c:2280
#6  0x000055d4bb52f3e2 in checkerloop (ap=0x55d4bbfad760) at main.c:2542
#7  0x00007f694305b3ba in start_thread (arg=<optimized out>) at pthread_create.c:443
#8  0x00007f69430ddb40 in clone3 () at ../sysdeps/unix/sysv/linux/x86_64/clone3.S:81
(gdb) f 2
#2  0x00007f69433a147c in dm_get_map (name=0x55d4bc090320 "3600140537cde137ea8c43d8a971462c7",
    size=size@entry=0x55d4bc0270d8, outparams=outparams@entry=0x7f6941add640) at devmapper.c:688
688			*outparams = strdup(params);
(gdb) l
683			*size = length;
684	
685		if (!outparams)
686			r = DMP_OK;
687		else {
688			*outparams = strdup(params);
689			r = *outparams ? DMP_OK : DMP_ERR;
690		}
691	
692	out:
(gdb) p params
$1 = 0x0

If can't found target, we should goto out

Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
---
 libmultipath/devmapper.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 2507f77f..450b17ef 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -682,8 +682,8 @@ int dm_get_map(const char *name, unsigned long long *size, char **outparams)
        r = DMP_NOT_FOUND;
        /* Fetch 1st target */
        if (dm_get_next_target(dmt, NULL, &start, &length,
-                              &target_type, &params) != NULL)
-               /* more than one target */
+                              &target_type, &params) != NULL || !params)
+               /* more than one target or not found target */
                goto out;

        if (size)
--
2.27.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

