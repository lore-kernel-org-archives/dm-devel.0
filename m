Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE1D1C74A5B
	for <dm-devel@archiver.kernel.org>; Fri, 17 Mar 2023 14:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679064891;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=gB+m0AxJ4UITh/WbyLnQeLO83R/XGjJks5whNlICI8c=;
	b=ClguDqdxpsn295dmFD0evpBQVUAOdsAD1OvWNnY5fqFY8r7R02AiRzTadRTdnyLsh65jno
	Sj5umHdcK7MyB40Z9CLdd30OqATuvum02Iv9OcA6XQnXr9V8UxfChYugZDjuImv9YINbgd
	JGhQxm8m9NfbHvnQ5b/qH7Y2EbuI/3o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-634-zwHagYELNA2fiF9gnCYRQg-1; Fri, 17 Mar 2023 10:54:48 -0400
X-MC-Unique: zwHagYELNA2fiF9gnCYRQg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EB135801CF5;
	Fri, 17 Mar 2023 14:54:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D2D5F6B590;
	Fri, 17 Mar 2023 14:54:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AA35C19466DF;
	Fri, 17 Mar 2023 14:54:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3F7931946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 16 Mar 2023 21:47:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1C74EC15BAE; Thu, 16 Mar 2023 21:47:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 11870C15BAD
 for <dm-devel@redhat.com>; Thu, 16 Mar 2023 21:47:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E976281B139
 for <dm-devel@redhat.com>; Thu, 16 Mar 2023 21:47:42 +0000 (UTC)
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com
 [209.85.216.41]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-669-tE311B_rOw-08kgDUObZCg-1; Thu, 16 Mar 2023 17:47:41 -0400
X-MC-Unique: tE311B_rOw-08kgDUObZCg-1
Received: by mail-pj1-f41.google.com with SMTP id
 om3-20020a17090b3a8300b0023efab0e3bfso6758625pjb.3
 for <dm-devel@redhat.com>; Thu, 16 Mar 2023 14:47:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679003260;
 h=to:date:message-id:subject:mime-version:content-transfer-encoding
 :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=MjF319vrDOXTMMZCq6yJyrLxh04HE1U+nk0vH75Tljc=;
 b=NPKLfxm4ZkiG4UrdbCIRqlRnDG0reEiaUfqkOivbuPWzVEJjRjnYaEmPelZNTlyNGw
 x12D6OQZpWllW+6XfTRTOr8dXKPik1MrcWh/Rv5uYNC7Zyxkj0rwoGJVKk0VWnxExV1R
 V9hJuqKp7HZSRHJKRd/BKInaPyNfhicW1/Vq96N+NWsQnv7xAGHEc7wBxjNVWvSh1Cq7
 N5OYd+321ukkxkb9/gokxu1ooyt/jlpdQf8kpfPUNiIErbKoKUi/PyKmsECEyuFaVBeY
 3xqiHGBB7mwswH51z8KjqinF/nCzO6P09nrN3cInCwapwPkikAB8mT4w7NH/w/5KKmLZ
 YEDQ==
X-Gm-Message-State: AO0yUKVCEXuzeoyjGvP37/O+DGvw/T+RMnd++vMtRVU4KVazA6DBjeCn
 PQ3rGNBCqt6RpHik2bctm4rcom/gl0KNI1JiuLhBLP4bfvdDXCZd8pULbvYb3YfNjYuF4bRMFYh
 ZVc/82r0yS2a5CLlaTiPmjg7UKm2ZefKOU2zO6OdZdyBrTQbKm51XD5c3Zh/N2Ja4OIVBtzpy
X-Google-Smtp-Source: AK7set/KTZkx5UVMbU3+JEKKGG+Mi9GNlNxyWCwopUcfK4jhISI35sz+p83rg3s41qVu4iKiBGlMhw==
X-Received: by 2002:a05:6a20:6982:b0:d3:d236:f5ae with SMTP id
 t2-20020a056a20698200b000d3d236f5aemr7929252pzk.49.1679003259406; 
 Thu, 16 Mar 2023 14:47:39 -0700 (PDT)
Received: from smtpclient.apple ([136.226.78.254])
 by smtp.gmail.com with ESMTPSA id
 d16-20020aa78150000000b005825b8e0540sm138268pfn.204.2023.03.16.14.47.38
 (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
 Thu, 16 Mar 2023 14:47:38 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.400.51.1.1\))
Message-Id: <CD5EC3B3-9A64-416A-A04C-C68EDB82F4C6@purestorage.com>
Date: Thu, 16 Mar 2023 14:47:27 -0700
To: device-mapper development <dm-devel@redhat.com>,
 Martin Wilck <mwilck@suse.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [PATCH] multipath-tools Consider making 'smart' the
 default
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

As a target vendor, it is nice to be able control initiator
behavior from the target without relying on user intervention
on the initiator. There could be a very large number of initiators
at a site.

When ACLs are first added for a volume on our array, we use the
transport layer, so that the initiator will discover the volumes
without any manual intervention.

kernel: scsi 8:0:0:1: Direct-Access PURE Flash Array
8888 PQ: 0 ANSI: 6
kernel: scsi 9:0:0:1: Direct-Access PURE Flash Array
8888 PQ: 0 ANSI: 6
kernel: scsi 6:0:0:1: Direct-Access PURE Flash Array
8888 PQ: 0 ANSI: 6
kernel: scsi 7:0:0:1: Direct-Access PURE Flash Array
8888 PQ: 0 ANSI: 6
...
kernel: sd 6:0:0:1: [sdd] Attached SCSI disk
kernel: sd 8:0:0:1: [sdb] Attached SCSI disk
kernel: sd 9:0:0:1: [sdc] Attached SCSI disk
kernel: sd 7:0:0:1: [sde] Attached SCSI disk

Subsequent volumes after the first one are discovered via unit
attentions triggering the udev rule which calls scan-scsi-target.
The SCSI devices being discovered without creating the corresponding
multipath devices seems to be a bad default. We would like to
control as much as possible from the target side to dictate initiator
behavior. This comes as a regression to how it previously worked.

Signed-off-by: Brian Bunker <brian@purestorage.com>
---
 libmultipath/defaults.h    | 2 +-
 multipath/multipath.conf.5 | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index a5e9ea0c..6dfdb63b 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -23,7 +23,7 @@
 #define DEFAULT_NO_PATH_RETRY  NO_PATH_RETRY_UNDEF
 #define DEFAULT_VERBOSITY      2
 #define DEFAULT_REASSIGN_MAPS  0
-#define DEFAULT_FIND_MULTIPATHS        FIND_MULTIPATHS_STRICT
+#define DEFAULT_FIND_MULTIPATHS        FIND_MULTIPATHS_SMART
 #define DEFAULT_FAST_IO_FAIL   5
 #define DEFAULT_DEV_LOSS_TMO   600
 #define DEFAULT_RETAIN_HWHANDLER RETAIN_HWHANDLER_ON
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index b4dccd1b..4447fe1b 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -1164,7 +1164,7 @@ as non-multipath and passed on to upper layers.
 \fBNote:\fR this may cause delays during device detection if
 there are single-path devices which aren\'t blacklisted.
 .TP
-The default is: \fBstrict\fR
+The default is: \fBsmart\fR
 .RE
 .
 .
-- 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

