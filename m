Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D039D314A9F
	for <dm-devel@lists.linux.dev>; Tue,  9 Sep 2025 00:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757376015; cv=none; b=QR+NGvS1eX7mUyLAQijn9xCr03XWNYLCAKfjwdIfDF4QgyHYg2u15j7zenGSVVdkFnNClz7HHqk2htgudZGhu1XLVRAue9xuEVBgP5HV2QWDr9ecn0lid6a8rH+zOhMqTzZoA7tqaJCdjPB0wHHaKqEb7sFcnJt3MfnWGVGJkAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757376015; c=relaxed/simple;
	bh=uGrcW+vb37euJAeMKWDMJXn6CbU/x1TtQh4Bviln70I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=iSmj38PYR5XzdyUwo63OYp3P5aSlWHvm/UXhQEuwIG0RdckkHegL5IRfDwkfVbLZNYJq5Zd2ALZw2TXuEsMii0lnNvjJWdRYf6cN5NJJax1gxrQ9zXVexl59waHTvkq+7ygh6BLeTbek8QWQ1bUal1GVhwTewrSvtLsAEY1oX4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MS1cTRJE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MS1cTRJE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757376012;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=73+qKTkJQb3zoFbkr9jJezvduf9m6m6tzS9FOfJhzLU=;
	b=MS1cTRJEdpI+iVohjpOLL2eB8lIrEH3Vwh/zoZi1kdahnd7IpODKeQxEcRI0XCs5DTp6gB
	3jasAlr2R6yyoGf/VI8SxV9EteoDNH0rFWCCKPy0jAG3irUXmuRyH+XJa3zsNYCnXHi/xf
	ltXj3pQYsurl/tzCwZ+wsnyJgJEuXns=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-638-p9Cng8bcMh6NY_F9ykCSvQ-1; Mon,
 08 Sep 2025 20:00:09 -0400
X-MC-Unique: p9Cng8bcMh6NY_F9ykCSvQ-1
X-Mimecast-MFC-AGG-ID: p9Cng8bcMh6NY_F9ykCSvQ_1757376008
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F282C1800284;
	Tue,  9 Sep 2025 00:00:07 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A95C63000198;
	Tue,  9 Sep 2025 00:00:07 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 589006Jx751159
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 8 Sep 2025 20:00:06 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5890067r751158;
	Mon, 8 Sep 2025 20:00:06 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 19/32] libmpathpersist: clean up duplicate function declarations
Date: Mon,  8 Sep 2025 19:59:49 -0400
Message-ID: <20250909000002.751039-20-bmarzins@redhat.com>
In-Reply-To: <20250909000002.751039-1-bmarzins@redhat.com>
References: <20250909000002.751039-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Iks7I_Wy7BHd9KfBdjK7ddSa-6o-KlMmEfiX5mdxUmk_1757376008
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/mpath_persist_int.h |  1 -
 libmpathpersist/mpath_pr_ioctl.c    | 10 +++-------
 mpathpersist/main.c                 |  2 --
 3 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.h b/libmpathpersist/mpath_persist_int.h
index 4d23606b..cdb444ae 100644
--- a/libmpathpersist/mpath_persist_int.h
+++ b/libmpathpersist/mpath_persist_int.h
@@ -6,7 +6,6 @@
  * but aren't part of the public libmpathpersist API.
  */
 
-void * mpath_alloc_prin_response(int prin_sa);
 int do_mpath_persistent_reserve_in(vector curmp, vector pathvec,
 				   int fd, int rq_servact,
 				   struct prin_resp *resp, int noisy);
diff --git a/libmpathpersist/mpath_pr_ioctl.c b/libmpathpersist/mpath_pr_ioctl.c
index 7e1d2896..dfdbbb65 100644
--- a/libmpathpersist/mpath_pr_ioctl.c
+++ b/libmpathpersist/mpath_pr_ioctl.c
@@ -14,19 +14,15 @@
 #include "mpath_pr_ioctl.h"
 #include "mpath_persist.h"
 #include "unaligned.h"
-
 #include "debug.h"
 #include "structs.h" /* FILE_NAME_SIZE */
+#include "mpath_persist_int.h"
 
 #define TIMEOUT 2000
 #define MAXRETRY 5
 
-int prin_do_scsi_ioctl(char * dev, int rq_servact, struct prin_resp *resp, int noisy);
-int mpath_translate_response (char * dev, struct sg_io_hdr io_hdr,
-			      SenseData_t *Sensedata);
-void dumpHex(const char* str, int len, int no_ascii);
-int prout_do_scsi_ioctl( char * dev, int rq_servact, int rq_scope,
-		unsigned int rq_type, struct prout_param_descriptor *paramp, int noisy);
+int mpath_translate_response(char *dev, struct sg_io_hdr io_hdr,
+			     SenseData_t *Sensedata);
 uint32_t  format_transportids(struct prout_param_descriptor *paramp);
 void convert_be32_to_cpu(uint32_t *num);
 void convert_be16_to_cpu(uint16_t *num);
diff --git a/mpathpersist/main.c b/mpathpersist/main.c
index efb46b95..97fd5a43 100644
--- a/mpathpersist/main.c
+++ b/mpathpersist/main.c
@@ -38,8 +38,6 @@ void mpath_print_buf_readcap(struct prin_resp *pr_buff);
 void mpath_print_buf_readfullstat(struct prin_resp *pr_buff);
 void mpath_print_buf_readresv(struct prin_resp *pr_buff);
 void mpath_print_buf_readkeys(struct prin_resp *pr_buff);
-void dumpHex(const char* str, int len, int no_ascii);
-void * mpath_alloc_prin_response(int prin_sa);
 void mpath_print_transport_id(struct prin_fulldescr *fdesc);
 int construct_transportid(const char * inp, struct transportid transid[], int num_transportids);
 
-- 
2.50.1

