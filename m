Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 565A4C38145
	for <dm-devel@archiver.kernel.org>; Mon, 22 Aug 2022 20:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661200923;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=o2Zh6nKjyeHfDk2fg51GjklERe7KG2MWp/GD/OBfF60=;
	b=MjwO/X1ldXtTnRElpKUcJdCrmTBSEE+tGq6UTkFILtfjw6myd474t7n0Lu4dNUkmljZ+aO
	TSwJpcHdn4XxH/FJYKFQ/8ioyMPqTnZlrv4WdczLvo5LK6Ltu0QZQ6Fvh6gaOOrhj9Y8Lt
	T0xS5upoP1Z6MrET9REKHdElxcc7KGM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-212-nrVnxOY5Pg2-mo8tcChPhA-1; Mon, 22 Aug 2022 16:41:59 -0400
X-MC-Unique: nrVnxOY5Pg2-mo8tcChPhA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F0CBF8039B0;
	Mon, 22 Aug 2022 20:41:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DEAD240D2830;
	Mon, 22 Aug 2022 20:41:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C63F41946A67;
	Mon, 22 Aug 2022 20:41:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DFCA61946A52
 for <dm-devel@listman.corp.redhat.com>; Mon, 22 Aug 2022 20:41:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C244B1121315; Mon, 22 Aug 2022 20:41:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BEE291121319
 for <dm-devel@redhat.com>; Mon, 22 Aug 2022 20:41:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A50F08117B0
 for <dm-devel@redhat.com>; Mon, 22 Aug 2022 20:41:53 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-211-hRZEwb36NMK2vfOsq31byw-1; Mon,
 22 Aug 2022 16:41:51 -0400
X-MC-Unique: hRZEwb36NMK2vfOsq31byw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id A2689202ED;
 Mon, 22 Aug 2022 20:41:49 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 66B9013523;
 Mon, 22 Aug 2022 20:41:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id oJeDFw3qA2MOAwAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 22 Aug 2022 20:41:49 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 22 Aug 2022 22:41:12 +0200
Message-Id: <20220822204119.20719-5-mwilck@suse.com>
In-Reply-To: <20220822204119.20719-1-mwilck@suse.com>
References: <20220822204119.20719-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: [dm-devel] [PATCH v2 04/11] libmultipath: always set _GNU_SOURCE
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
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>,
 Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

... not only if dm_task_no_flush is available. Also, look for
includes under libmultipath but not under libmpathpersist.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index 033fc83..348af3f 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -8,7 +8,7 @@ DEVLIB = libmultipath.so
 LIBS = $(DEVLIB).$(SONAME)
 VERSION_SCRIPT := libmultipath.version
 
-CPPFLAGS += -I$(mpathcmddir) -I$(nvmedir)
+CPPFLAGS += -I$(mpathcmddir) -I$(nvmedir) -D_GNU_SOURCE
 CFLAGS += $(LIB_CFLAGS)
 
 LIBDEPS += -lpthread -ldl -ldevmapper -ludev -L$(mpathcmddir) -lmpathcmd -lurcu -laio
@@ -23,7 +23,7 @@ ifdef SYSTEMD
 endif
 
 ifneq ($(call check_func,dm_task_no_flush,$(DEVMAPPER_INCDIR)/libdevmapper.h),0)
-	CPPFLAGS += -DLIBDM_API_FLUSH -D_GNU_SOURCE
+	CPPFLAGS += -DLIBDM_API_FLUSH
 endif
 
 ifneq ($(call check_func,dm_task_get_errno,$(DEVMAPPER_INCDIR)/libdevmapper.h),0)
-- 
2.37.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

