Return-Path: <SRS0=cSVF=KM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5B92C433ED
	for <dm-devel@archiver.kernel.org>; Mon, 17 May 2021 21:20:10 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4DE7D611ED
	for <dm-devel@archiver.kernel.org>; Mon, 17 May 2021 21:20:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4DE7D611ED
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-1aWf-_lxNKeXSQEmklBWLA-1; Mon, 17 May 2021 17:20:06 -0400
X-MC-Unique: 1aWf-_lxNKeXSQEmklBWLA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8B2216D249;
	Mon, 17 May 2021 21:20:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F8DA5E26F;
	Mon, 17 May 2021 21:20:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2AEB655350;
	Mon, 17 May 2021 21:20:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14HLJkGF030484 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 17 May 2021 17:19:47 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id DDED8216FD47; Mon, 17 May 2021 21:19:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A7668216FD5A
	for <dm-devel@redhat.com>; Mon, 17 May 2021 21:19:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2610F101D225
	for <dm-devel@redhat.com>; Mon, 17 May 2021 21:19:44 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-237-yjcpJMFINKSXrQSQaEp5Lw-1;
	Mon, 17 May 2021 17:19:41 -0400
X-MC-Unique: yjcpJMFINKSXrQSQaEp5Lw-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id D39BFB132;
	Mon, 17 May 2021 21:19:39 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Xose Vazquez Perez <xose.vazquez@gmail.com>
Date: Mon, 17 May 2021 23:19:09 +0200
Message-Id: <20210517211909.21776-4-mwilck@suse.com>
In-Reply-To: <20210517211909.21776-1-mwilck@suse.com>
References: <20210517211909.21776-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14HLJkGF030484
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 4/4] libdmmp: use KBUILD_BUILD_TIMESTAMP when
	building man pages
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Use the latest commit timestamp of the "libdmmp.h" file as
the timestamp for the man pages. This should avoid spurious rebuilds
of the documentation.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libdmmp/Makefile                                 | 2 ++
 libdmmp/docs/man/dmmp_context_free.3             | 2 +-
 libdmmp/docs/man/dmmp_context_log_func_set.3     | 2 +-
 libdmmp/docs/man/dmmp_context_log_priority_get.3 | 2 +-
 libdmmp/docs/man/dmmp_context_log_priority_set.3 | 2 +-
 libdmmp/docs/man/dmmp_context_new.3              | 2 +-
 libdmmp/docs/man/dmmp_context_timeout_get.3      | 2 +-
 libdmmp/docs/man/dmmp_context_timeout_set.3      | 2 +-
 libdmmp/docs/man/dmmp_context_userdata_get.3     | 2 +-
 libdmmp/docs/man/dmmp_context_userdata_set.3     | 2 +-
 libdmmp/docs/man/dmmp_flush_mpath.3              | 2 +-
 libdmmp/docs/man/dmmp_last_error_msg.3           | 2 +-
 libdmmp/docs/man/dmmp_log_priority_str.3         | 2 +-
 libdmmp/docs/man/dmmp_mpath_array_free.3         | 2 +-
 libdmmp/docs/man/dmmp_mpath_array_get.3          | 2 +-
 libdmmp/docs/man/dmmp_mpath_kdev_name_get.3      | 2 +-
 libdmmp/docs/man/dmmp_mpath_name_get.3           | 2 +-
 libdmmp/docs/man/dmmp_mpath_wwid_get.3           | 2 +-
 libdmmp/docs/man/dmmp_path_array_get.3           | 2 +-
 libdmmp/docs/man/dmmp_path_blk_name_get.3        | 2 +-
 libdmmp/docs/man/dmmp_path_group_array_get.3     | 2 +-
 libdmmp/docs/man/dmmp_path_group_id_get.3        | 2 +-
 libdmmp/docs/man/dmmp_path_group_priority_get.3  | 2 +-
 libdmmp/docs/man/dmmp_path_group_selector_get.3  | 2 +-
 libdmmp/docs/man/dmmp_path_group_status_get.3    | 2 +-
 libdmmp/docs/man/dmmp_path_group_status_str.3    | 2 +-
 libdmmp/docs/man/dmmp_path_status_get.3          | 2 +-
 libdmmp/docs/man/dmmp_path_status_str.3          | 2 +-
 libdmmp/docs/man/dmmp_reconfig.3                 | 2 +-
 libdmmp/docs/man/dmmp_strerror.3                 | 2 +-
 30 files changed, 31 insertions(+), 29 deletions(-)

diff --git a/libdmmp/Makefile b/libdmmp/Makefile
index 764a0bc..79b92fb 100644
--- a/libdmmp/Makefile
+++ b/libdmmp/Makefile
@@ -76,6 +76,8 @@ docs/man/%.3.gz:	docs/man/%.3
 docs/man/dmmp_strerror.3:	$(HEADERS)
 	TEMPFILE=$(shell mktemp); \
 	cat $^ | perl docs/doc-preclean.pl >$$TEMPFILE; \
+	LC_ALL=C \
+	KBUILD_BUILD_TIMESTAMP=`git log -n1 --pretty=%cd --date=iso -- $^` \
 	perl docs/kernel-doc -man $$TEMPFILE | \
 	    perl docs/split-man.pl docs/man; \
 	rm -f $$TEMPFILE
diff --git a/libdmmp/docs/man/dmmp_context_free.3 b/libdmmp/docs/man/dmmp_context_free.3
index 0d26f42..7c109e1 100644
--- a/libdmmp/docs/man/dmmp_context_free.3
+++ b/libdmmp/docs/man/dmmp_context_free.3
@@ -1,4 +1,4 @@
-.TH "dmmp_context_free" 3 "dmmp_context_free" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_context_free" 3 "dmmp_context_free" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_context_free \- Release the memory of struct dmmp_context.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_context_log_func_set.3 b/libdmmp/docs/man/dmmp_context_log_func_set.3
index 986793d..be311ec 100644
--- a/libdmmp/docs/man/dmmp_context_log_func_set.3
+++ b/libdmmp/docs/man/dmmp_context_log_func_set.3
@@ -1,4 +1,4 @@
-.TH "dmmp_context_log_func_set" 3 "dmmp_context_log_func_set" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_context_log_func_set" 3 "dmmp_context_log_func_set" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_context_log_func_set \- Set log handler function.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_context_log_priority_get.3 b/libdmmp/docs/man/dmmp_context_log_priority_get.3
index 9a273a2..be38301 100644
--- a/libdmmp/docs/man/dmmp_context_log_priority_get.3
+++ b/libdmmp/docs/man/dmmp_context_log_priority_get.3
@@ -1,4 +1,4 @@
-.TH "dmmp_context_log_priority_get" 3 "dmmp_context_log_priority_get" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_context_log_priority_get" 3 "dmmp_context_log_priority_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_context_log_priority_get \- Get log priority.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_context_log_priority_set.3 b/libdmmp/docs/man/dmmp_context_log_priority_set.3
index 469c5a4..79e4d2e 100644
--- a/libdmmp/docs/man/dmmp_context_log_priority_set.3
+++ b/libdmmp/docs/man/dmmp_context_log_priority_set.3
@@ -1,4 +1,4 @@
-.TH "dmmp_context_log_priority_set" 3 "dmmp_context_log_priority_set" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_context_log_priority_set" 3 "dmmp_context_log_priority_set" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_context_log_priority_set \- Set log priority.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_context_new.3 b/libdmmp/docs/man/dmmp_context_new.3
index 0eaeb00..12505f9 100644
--- a/libdmmp/docs/man/dmmp_context_new.3
+++ b/libdmmp/docs/man/dmmp_context_new.3
@@ -1,4 +1,4 @@
-.TH "dmmp_context_new" 3 "dmmp_context_new" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_context_new" 3 "dmmp_context_new" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_context_new \- Create struct dmmp_context.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_context_timeout_get.3 b/libdmmp/docs/man/dmmp_context_timeout_get.3
index 1df2793..2ed825d 100644
--- a/libdmmp/docs/man/dmmp_context_timeout_get.3
+++ b/libdmmp/docs/man/dmmp_context_timeout_get.3
@@ -1,4 +1,4 @@
-.TH "dmmp_context_timeout_get" 3 "dmmp_context_timeout_get" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_context_timeout_get" 3 "dmmp_context_timeout_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_context_timeout_get \- Get IPC timeout.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_context_timeout_set.3 b/libdmmp/docs/man/dmmp_context_timeout_set.3
index f3d7709..16bc9d9 100644
--- a/libdmmp/docs/man/dmmp_context_timeout_set.3
+++ b/libdmmp/docs/man/dmmp_context_timeout_set.3
@@ -1,4 +1,4 @@
-.TH "dmmp_context_timeout_set" 3 "dmmp_context_timeout_set" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_context_timeout_set" 3 "dmmp_context_timeout_set" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_context_timeout_set \- Set IPC timeout.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_context_userdata_get.3 b/libdmmp/docs/man/dmmp_context_userdata_get.3
index fb713d5..eff446c 100644
--- a/libdmmp/docs/man/dmmp_context_userdata_get.3
+++ b/libdmmp/docs/man/dmmp_context_userdata_get.3
@@ -1,4 +1,4 @@
-.TH "dmmp_context_userdata_get" 3 "dmmp_context_userdata_get" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_context_userdata_get" 3 "dmmp_context_userdata_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_context_userdata_get \- Get user data pointer.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_context_userdata_set.3 b/libdmmp/docs/man/dmmp_context_userdata_set.3
index c5bf63f..d7be869 100644
--- a/libdmmp/docs/man/dmmp_context_userdata_set.3
+++ b/libdmmp/docs/man/dmmp_context_userdata_set.3
@@ -1,4 +1,4 @@
-.TH "dmmp_context_userdata_set" 3 "dmmp_context_userdata_set" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_context_userdata_set" 3 "dmmp_context_userdata_set" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_context_userdata_set \- Set user data pointer.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_flush_mpath.3 b/libdmmp/docs/man/dmmp_flush_mpath.3
index cdfd526..359607e 100644
--- a/libdmmp/docs/man/dmmp_flush_mpath.3
+++ b/libdmmp/docs/man/dmmp_flush_mpath.3
@@ -1,4 +1,4 @@
-.TH "dmmp_flush_mpath" 3 "dmmp_flush_mpath" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_flush_mpath" 3 "dmmp_flush_mpath" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_flush_mpath \- Flush specified multipath device map if unused.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_last_error_msg.3 b/libdmmp/docs/man/dmmp_last_error_msg.3
index 20acbc6..378c55a 100644
--- a/libdmmp/docs/man/dmmp_last_error_msg.3
+++ b/libdmmp/docs/man/dmmp_last_error_msg.3
@@ -1,4 +1,4 @@
-.TH "dmmp_last_error_msg" 3 "dmmp_last_error_msg" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_last_error_msg" 3 "dmmp_last_error_msg" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_last_error_msg \- Retrieves the last error message.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_log_priority_str.3 b/libdmmp/docs/man/dmmp_log_priority_str.3
index 3b5f828..b276160 100644
--- a/libdmmp/docs/man/dmmp_log_priority_str.3
+++ b/libdmmp/docs/man/dmmp_log_priority_str.3
@@ -1,4 +1,4 @@
-.TH "dmmp_log_priority_str" 3 "dmmp_log_priority_str" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_log_priority_str" 3 "dmmp_log_priority_str" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_log_priority_str \- Convert log priority to string.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_mpath_array_free.3 b/libdmmp/docs/man/dmmp_mpath_array_free.3
index 8c294e0..0514a66 100644
--- a/libdmmp/docs/man/dmmp_mpath_array_free.3
+++ b/libdmmp/docs/man/dmmp_mpath_array_free.3
@@ -1,4 +1,4 @@
-.TH "dmmp_mpath_array_free" 3 "dmmp_mpath_array_free" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_mpath_array_free" 3 "dmmp_mpath_array_free" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_mpath_array_free \- Free 'struct dmmp_mpath' pointer array.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_mpath_array_get.3 b/libdmmp/docs/man/dmmp_mpath_array_get.3
index e211db4..8b0e5b5 100644
--- a/libdmmp/docs/man/dmmp_mpath_array_get.3
+++ b/libdmmp/docs/man/dmmp_mpath_array_get.3
@@ -1,4 +1,4 @@
-.TH "dmmp_mpath_array_get" 3 "dmmp_mpath_array_get" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_mpath_array_get" 3 "dmmp_mpath_array_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_mpath_array_get \- Query all existing multipath devices.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_mpath_kdev_name_get.3 b/libdmmp/docs/man/dmmp_mpath_kdev_name_get.3
index e802fe6..ddead55 100644
--- a/libdmmp/docs/man/dmmp_mpath_kdev_name_get.3
+++ b/libdmmp/docs/man/dmmp_mpath_kdev_name_get.3
@@ -1,4 +1,4 @@
-.TH "dmmp_mpath_kdev_name_get" 3 "dmmp_mpath_kdev_name_get" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_mpath_kdev_name_get" 3 "dmmp_mpath_kdev_name_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_mpath_kdev_name_get \- Retrieve kernel DEVNAME of certain mpath.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_mpath_name_get.3 b/libdmmp/docs/man/dmmp_mpath_name_get.3
index d70579e..2b0027e 100644
--- a/libdmmp/docs/man/dmmp_mpath_name_get.3
+++ b/libdmmp/docs/man/dmmp_mpath_name_get.3
@@ -1,4 +1,4 @@
-.TH "dmmp_mpath_name_get" 3 "dmmp_mpath_name_get" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_mpath_name_get" 3 "dmmp_mpath_name_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_mpath_name_get \- Retrieve name(alias) of certain mpath.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_mpath_wwid_get.3 b/libdmmp/docs/man/dmmp_mpath_wwid_get.3
index 3d060e9..b8e9e7d 100644
--- a/libdmmp/docs/man/dmmp_mpath_wwid_get.3
+++ b/libdmmp/docs/man/dmmp_mpath_wwid_get.3
@@ -1,4 +1,4 @@
-.TH "dmmp_mpath_wwid_get" 3 "dmmp_mpath_wwid_get" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_mpath_wwid_get" 3 "dmmp_mpath_wwid_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_mpath_wwid_get \- Retrieve WWID of certain mpath.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_path_array_get.3 b/libdmmp/docs/man/dmmp_path_array_get.3
index 53340b3..21f486b 100644
--- a/libdmmp/docs/man/dmmp_path_array_get.3
+++ b/libdmmp/docs/man/dmmp_path_array_get.3
@@ -1,4 +1,4 @@
-.TH "dmmp_path_array_get" 3 "dmmp_path_array_get" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_path_array_get" 3 "dmmp_path_array_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_path_array_get \- Retrieve path pointer array.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_path_blk_name_get.3 b/libdmmp/docs/man/dmmp_path_blk_name_get.3
index da5f9f0..5938f0e 100644
--- a/libdmmp/docs/man/dmmp_path_blk_name_get.3
+++ b/libdmmp/docs/man/dmmp_path_blk_name_get.3
@@ -1,4 +1,4 @@
-.TH "dmmp_path_blk_name_get" 3 "dmmp_path_blk_name_get" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_path_blk_name_get" 3 "dmmp_path_blk_name_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_path_blk_name_get \- Retrieve block name.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_path_group_array_get.3 b/libdmmp/docs/man/dmmp_path_group_array_get.3
index 6eee4a2..ca3187c 100644
--- a/libdmmp/docs/man/dmmp_path_group_array_get.3
+++ b/libdmmp/docs/man/dmmp_path_group_array_get.3
@@ -1,4 +1,4 @@
-.TH "dmmp_path_group_array_get" 3 "dmmp_path_group_array_get" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_path_group_array_get" 3 "dmmp_path_group_array_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_path_group_array_get \- Retrieve path groups pointer array.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_path_group_id_get.3 b/libdmmp/docs/man/dmmp_path_group_id_get.3
index 4f07b53..a84f31f 100644
--- a/libdmmp/docs/man/dmmp_path_group_id_get.3
+++ b/libdmmp/docs/man/dmmp_path_group_id_get.3
@@ -1,4 +1,4 @@
-.TH "dmmp_path_group_id_get" 3 "dmmp_path_group_id_get" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_path_group_id_get" 3 "dmmp_path_group_id_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_path_group_id_get \- Retrieve path group ID.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_path_group_priority_get.3 b/libdmmp/docs/man/dmmp_path_group_priority_get.3
index a48b270..1cda8af 100644
--- a/libdmmp/docs/man/dmmp_path_group_priority_get.3
+++ b/libdmmp/docs/man/dmmp_path_group_priority_get.3
@@ -1,4 +1,4 @@
-.TH "dmmp_path_group_priority_get" 3 "dmmp_path_group_priority_get" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_path_group_priority_get" 3 "dmmp_path_group_priority_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_path_group_priority_get \- Retrieve path group priority.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_path_group_selector_get.3 b/libdmmp/docs/man/dmmp_path_group_selector_get.3
index 407b3f4..f55477b 100644
--- a/libdmmp/docs/man/dmmp_path_group_selector_get.3
+++ b/libdmmp/docs/man/dmmp_path_group_selector_get.3
@@ -1,4 +1,4 @@
-.TH "dmmp_path_group_selector_get" 3 "dmmp_path_group_selector_get" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_path_group_selector_get" 3 "dmmp_path_group_selector_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_path_group_selector_get \- Retrieve path group selector.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_path_group_status_get.3 b/libdmmp/docs/man/dmmp_path_group_status_get.3
index a81aeb3..53e68b8 100644
--- a/libdmmp/docs/man/dmmp_path_group_status_get.3
+++ b/libdmmp/docs/man/dmmp_path_group_status_get.3
@@ -1,4 +1,4 @@
-.TH "dmmp_path_group_status_get" 3 "dmmp_path_group_status_get" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_path_group_status_get" 3 "dmmp_path_group_status_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_path_group_status_get \- Retrieve path group status.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_path_group_status_str.3 b/libdmmp/docs/man/dmmp_path_group_status_str.3
index e4a9f74..98f877a 100644
--- a/libdmmp/docs/man/dmmp_path_group_status_str.3
+++ b/libdmmp/docs/man/dmmp_path_group_status_str.3
@@ -1,4 +1,4 @@
-.TH "dmmp_path_group_status_str" 3 "dmmp_path_group_status_str" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_path_group_status_str" 3 "dmmp_path_group_status_str" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_path_group_status_str \- Convert path group status to string.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_path_status_get.3 b/libdmmp/docs/man/dmmp_path_status_get.3
index 025cfee..baa4437 100644
--- a/libdmmp/docs/man/dmmp_path_status_get.3
+++ b/libdmmp/docs/man/dmmp_path_status_get.3
@@ -1,4 +1,4 @@
-.TH "dmmp_path_status_get" 3 "dmmp_path_status_get" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_path_status_get" 3 "dmmp_path_status_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_path_status_get \- Retrieve the path status.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_path_status_str.3 b/libdmmp/docs/man/dmmp_path_status_str.3
index 3944d39..425e472 100644
--- a/libdmmp/docs/man/dmmp_path_status_str.3
+++ b/libdmmp/docs/man/dmmp_path_status_str.3
@@ -1,4 +1,4 @@
-.TH "dmmp_path_status_str" 3 "dmmp_path_status_str" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_path_status_str" 3 "dmmp_path_status_str" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_path_status_str \- Convert path status to string.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_reconfig.3 b/libdmmp/docs/man/dmmp_reconfig.3
index a743e30..36bd504 100644
--- a/libdmmp/docs/man/dmmp_reconfig.3
+++ b/libdmmp/docs/man/dmmp_reconfig.3
@@ -1,4 +1,4 @@
-.TH "dmmp_reconfig" 3 "dmmp_reconfig" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_reconfig" 3 "dmmp_reconfig" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_reconfig \- Instruct multipathd daemon to do reconfiguration.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_strerror.3 b/libdmmp/docs/man/dmmp_strerror.3
index 4d753d3..3acd9c9 100644
--- a/libdmmp/docs/man/dmmp_strerror.3
+++ b/libdmmp/docs/man/dmmp_strerror.3
@@ -1,4 +1,4 @@
-.TH "dmmp_strerror" 3 "dmmp_strerror" "March 2021" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_strerror" 3 "dmmp_strerror" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_strerror \- Convert error code to string.
 .SH SYNOPSIS
-- 
2.31.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

