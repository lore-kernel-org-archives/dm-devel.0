Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 675FFC433F5
	for <dm-devel@archiver.kernel.org>; Mon, 18 Apr 2022 21:54:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-539-2x3lwtbXPJqkOSm6FJglsw-1; Mon, 18 Apr 2022 17:54:36 -0400
X-MC-Unique: 2x3lwtbXPJqkOSm6FJglsw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1B9848001EA;
	Mon, 18 Apr 2022 21:54:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1EEEE4087D7F;
	Mon, 18 Apr 2022 21:54:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C4CBF1947BBD;
	Mon, 18 Apr 2022 21:54:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 574E31947BBB
 for <dm-devel@listman.corp.redhat.com>; Mon, 18 Apr 2022 21:54:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E922540FF40E; Mon, 18 Apr 2022 21:54:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E528740FF407
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 21:54:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C90CA3C01B83
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 21:54:30 +0000 (UTC)
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com
 [209.85.167.44]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-365-yByp9rMJPFuz-D7BOXKbFQ-1; Mon, 18 Apr 2022 17:54:29 -0400
X-MC-Unique: yByp9rMJPFuz-D7BOXKbFQ-1
Received: by mail-lf1-f44.google.com with SMTP id w19so26219401lfu.11
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 14:54:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
 bh=KvtWVhnRkap4llvSBMKDO0/vr0SgwJcwI6KlHUkehoU=;
 b=H3JmqeTY9b2FY7vCJxKVPfvhHJiv7UmiiL4aN2pP45bwJeAIKYt+nk/B4wTVr+cYsn
 jjK7j2rBOm6AcU5DO3hhXWBgFN5QeWb9q3vgSmb1sl/SpxfsaFV2vAfIlSR5QK/TL2KY
 VBCQsNFRBWQ0ymO2bgf7DD5xqmS4iORRDIFvWlbeHUxoXFiCrj0dg9KXvGxdoD0JQHlW
 P7Sgfoa/kq6IZaelntjTwCfASuhuKGB31VD3WJfoihPJQi6McYNbdcA1giMXPouS/jDT
 dm1VZZctCuCNxl7AGNye2aWC7FAA8ElkrRdq7G3qRhhBYuyIKN3A8mbBQwvwqHrzLfF3
 4AUg==
X-Gm-Message-State: AOAM531ZgevjeJk//UbYPtfemkRfJlWkGXjdWhvl5o5wB3x+U1RRWdqf
 emnZYS9tkA7pwih6tRsV/mUCo/BccINtDCxPtOkWiGBIGut60ONu
X-Google-Smtp-Source: ABdhPJzzy3G3lh0LaIWoAS7+1boiGNOqTyvKuPp+SdVYBP9VRGXF8cTX8nCQYG72JS7fK1550Ml4iLBjwLKgUld27KI=
X-Received: by 2002:a05:6512:16a1:b0:44a:2c56:3952 with SMTP id
 bu33-20020a05651216a100b0044a2c563952mr9540625lfb.382.1650318866020; Mon, 18
 Apr 2022 14:54:26 -0700 (PDT)
MIME-Version: 1.0
From: Brian Bunker <brian@purestorage.com>
Date: Mon, 18 Apr 2022 14:54:15 -0700
Message-ID: <CAHZQxyLeK6L_wtGr=YN6AYPq1CucozjpTPHf194jxUiH=RyzOg@mail.gmail.com>
To: device-mapper development <dm-devel@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: [dm-devel] [PATCH] multipath-tools: prevent a kernel upgrade
 leading to all paths lost
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

With the kernel commit 268940b80fa4096397fd0a28e6ad807e64120215, the
handling of ALUA state transitioning state changed. It used to be that
paths which returned with ALUA transitioning state would not result in
those paths being failed. With this patch, that state returned will
result in the path being failed. The result of this will result in all
paths down events when a configuration has the no_path_retry set to 0.
Before this kernel change that same configuration would not reach all
paths down.

If the kernel is not changed back to the previous behavior, the
multipath-tools have to protect against this condition or
configurations which were working correctly prior to the kernel change
will lead to an unexpected failure.

See the kernel discussions here:
https://marc.info/?l=linux-scsi&m=162636826305740&w=2
https://marc.info/?l=linux-scsi&m=164987222322261&w=2

Signed-off-by: brian@purestorage.com
Reviewed-by: sconnor@purestorage.com
___
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index d94f93a0..0af7e598 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -370,6 +370,7 @@ struct multipath {
        int failback_tick;

        int no_path_retry; /* number of retries after all paths are down */
+       int no_path_retry_configured; /* value in config */
        int retry_tick;    /* remaining times for retries */
        int disable_queueing;
        int minio;
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 6c23df86..3db4e6f7 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -780,8 +780,15 @@ void update_queue_mode_add_path(struct multipath *mpp)
 {
        int active = count_active_paths(mpp);

-       if (active > 0)
+       if (active > 0) {
                leave_recovery_mode(mpp);
+               if (mpp->no_path_retry != mpp->no_path_retry_configured) {
+                       condlog(2, "%s: return no path retry to %d
from %d", mpp->alias,
+                       mpp->no_path_retry_configured, mpp->no_path_retry);
+                       mpp->no_path_retry = mpp->no_path_retry_configured;
+               }
+       }
+
        condlog(2, "%s: remaining active paths: %d", mpp->alias, active);
 }

diff --git a/multipathd/main.c b/multipathd/main.c
index f2c0b280..92841d13 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -524,7 +524,7 @@ int update_multipath (struct vectors *vecs, char
*mapname, int reset)
        struct multipath *mpp;
        struct pathgroup  *pgp;
        struct path *pp;
-       int i, j;
+       int i, j, tpg;

        mpp = find_mp_by_alias(vecs->mpvec, mapname);

@@ -553,6 +553,15 @@ int update_multipath (struct vectors *vecs, char
*mapname, int reset)
                                checkint = conf->checkint;
                                put_multipath_config(conf);
                                condlog(2, "%s: mark as failed", pp->dev);
+                               tpg = get_target_port_group(pp, DEF_TIMEOUT);
+                               if ((tpg >= 0) &&
+                                   (mpp->no_path_retry == 0) &&
+                                   (get_asymmetric_access_state(pp,
tpg, DEF_TIMEOUT) == AAS_TRANSITIONING)) {
+                                       mpp->no_path_retry_configured
= mpp->no_path_retry;
+                                       mpp->no_path_retry = (60 / checkint);
+                                       condlog(2, "%s: changed %s no
path retry to %d", pp->dev, mpp->alias,
+                                               (60 / checkint));
+                               }
                                mpp->stat_path_failures++;
                                pp->state = PATH_DOWN;
                                if (oldstate == PATH_UP ||
___

-- 
Brian Bunker
PURE Storage, Inc.
brian@purestorage.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

