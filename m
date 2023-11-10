Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D773AC12
	for <dm-devel@lists.linux.dev>; Fri, 10 Nov 2023 19:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JpSt4OEC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699645989;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F5xqaFRjBSKirM3rCKJogmpFVORnxUk/ffy2mqQIipo=;
	b=JpSt4OEC0BB8sIn97N3X+MTlcIsuvS/l6A3NSuwktMLQi75Lbeqk4vIHNzJ8VKSwGlVegy
	QkfKIdbp4BzPWh2Okh3SQjIkcn07ptcxQNvVTiNX35/srCz+bmCaMhitczyhx2KZUXR3zR
	8VgtqDfyK/zRdE4DPnr+1N2orpq4WWU=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-22-rjuofbozNrSCbGCPAn0aLQ-1; Fri,
 10 Nov 2023 14:53:06 -0500
X-MC-Unique: rjuofbozNrSCbGCPAn0aLQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B3FC52806689;
	Fri, 10 Nov 2023 19:53:05 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (bmarzins-01.fast.rdu2.eng.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AE147C1596F;
	Fri, 10 Nov 2023 19:53:05 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1) with ESMTPS id 3AAJr5Db107921
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 14:53:05 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1/Submit) id 3AAJr5hZ107920;
	Fri, 10 Nov 2023 14:53:05 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 2/2] Makefile.inc: always use /usr/include for includedir
Date: Fri, 10 Nov 2023 14:53:04 -0500
Message-ID: <20231110195304.107907-3-bmarzins@redhat.com>
In-Reply-To: <20231110195304.107907-1-bmarzins@redhat.com>
References: <20231110195304.107907-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

The current build system, with nothing overridden, will install the
header files to /include, which AFAIK isn't correct for any
distribution.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 Makefile.inc     | 3 +--
 create-config.mk | 4 ++--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/Makefile.inc b/Makefile.inc
index ed40b449..c5ec62d2 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -64,7 +64,7 @@ mandir		:= /usr/share/man
 LIB		:= $(if $(shell test -d /lib64 && echo 1),lib64,lib)
 syslibdir	:= $(prefix)$(LIB)
 usrlibdir	:= $(usr_prefix)$(LIB)
-includedir	:= $(usr_prefix)include
+includedir	:= /usr/include
 pkgconfdir	:= $(usrlibdir)/pkgconfig
 plugindir       := $(prefix)$(LIB)/multipath
 configdir       := $(etc_prefix)etc/multipath/conf.d
@@ -73,7 +73,6 @@ statedir        := $(etc_prefix)etc/multipath
 runtimedir      := $(if $(shell test -L /var/run -o ! -d /var/run && echo 1),/run,/var/run)
 devmapper_incdir := $(or $(shell $(PKG_CONFIG) --variable=includedir devmapper),/usr/include)
 libudev_incdir	:= $(or $(shell $(PKG_CONFIG) --variable=includedir libudev),/usr/include)
-kernel_incdir	:= /usr/include
 
 ifeq ($(V),)
 Q		:= @
diff --git a/create-config.mk b/create-config.mk
index 4d318b96..963f6074 100644
--- a/create-config.mk
+++ b/create-config.mk
@@ -103,7 +103,7 @@ ifneq ($(call check_func,dm_hold_control_dev,$(devmapper_incdir)/libdevmapper.h)
 	DEFINES += LIBDM_API_HOLD_CONTROL
 endif
 
-ifneq ($(call check_var,ELS_DTAG_LNK_INTEGRITY,$(kernel_incdir)/scsi/fc/fc_els.h),0)
+ifneq ($(call check_var,ELS_DTAG_LNK_INTEGRITY,$(includedir)/scsi/fc/fc_els.h),0)
 	DEFINES += FPIN_EVENT_HANDLER
 	FPIN_SUPPORT = 1
 endif
@@ -117,7 +117,7 @@ ifneq ($(call check_func,mnt_table_parse_swaps,$(libmount_h)),0)
 	DEFINES += LIBMOUNT_SUPPORTS_SWAP
 endif
 
-ifneq ($(call check_file,$(kernel_incdir)/linux/nvme_ioctl.h),0)
+ifneq ($(call check_file,$(includedir)/linux/nvme_ioctl.h),0)
 	ANA_SUPPORT := 1
 endif
 
-- 
2.41.0

