Return-Path: <SRS0=X5vH=D3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C763C433E7
	for <dm-devel@archiver.kernel.org>; Tue, 20 Oct 2020 08:22:25 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 743792222F
	for <dm-devel@archiver.kernel.org>; Tue, 20 Oct 2020 08:22:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 743792222F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-534-0JebO1EtN9usqsboHU1ifg-1; Tue, 20 Oct 2020 04:22:20 -0400
X-MC-Unique: 0JebO1EtN9usqsboHU1ifg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CD8FE56FDC;
	Tue, 20 Oct 2020 08:22:15 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7218575139;
	Tue, 20 Oct 2020 08:22:15 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E191118037CC;
	Tue, 20 Oct 2020 08:22:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09JBK0KL022384 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 19 Oct 2020 07:20:00 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 7B8821010B11; Mon, 19 Oct 2020 11:20:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 77D351015917
	for <dm-devel@redhat.com>; Mon, 19 Oct 2020 11:20:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5077E811E76
	for <dm-devel@redhat.com>; Mon, 19 Oct 2020 11:20:00 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-590-teYfB0QqO6WhUbyi0qW9Aw-1;
	Mon, 19 Oct 2020 07:19:58 -0400
X-MC-Unique: teYfB0QqO6WhUbyi0qW9Aw-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id A6127B2E6;
	Mon, 19 Oct 2020 11:19:56 +0000 (UTC)
From: Anthony Iliopoulos <ailiop@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Mon, 19 Oct 2020 13:20:15 +0200
Message-Id: <20201019112017.18544-2-ailiop@suse.com>
In-Reply-To: <20201019112017.18544-1-ailiop@suse.com>
References: <20201019112017.18544-1-ailiop@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 09JBK0KL022384
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 20 Oct 2020 04:22:10 -0400
Cc: dm-devel@redhat.com
Subject: [dm-devel] [PATCH 1/3] libdmmp: fix compilation on newer json-c
	releases
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

json-c has removed the boolean typedefs since json-c-0.14-20200419
release (upstream commit 0992aac61f8b ("Remove the TRUE and FALSE
defines.").

Replace all occurences of TRUE/FALSE with 1/0 to unbreak compilation,
following the json-c upstream convention.

Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
---
 libdmmp/libdmmp_private.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libdmmp/libdmmp_private.h b/libdmmp/libdmmp_private.h
index ac85b63f88f3..2940082666a2 100644
--- a/libdmmp/libdmmp_private.h
+++ b/libdmmp/libdmmp_private.h
@@ -82,7 +82,7 @@ static out_type func_name(struct dmmp_context *ctx, const char *var_name) { \
 do { \
 	json_type j_type = json_type_null; \
 	json_object *j_obj_tmp = NULL; \
-	if (json_object_object_get_ex(j_obj, key, &j_obj_tmp) != TRUE) { \
+	if (json_object_object_get_ex(j_obj, key, &j_obj_tmp) != 1) { \
 		_error(ctx, "Invalid JSON output from multipathd IPC: " \
 		       "key '%s' not found", key); \
 		rc = DMMP_ERR_IPC_ERROR; \
@@ -90,7 +90,7 @@ do { \
 	} \
 	if (j_obj_tmp == NULL) { \
 		_error(ctx, "BUG: Got NULL j_obj_tmp from " \
-		       "json_object_object_get_ex() while it return TRUE"); \
+		       "json_object_object_get_ex() while it return 1"); \
 		rc = DMMP_ERR_BUG; \
 		goto out; \
 	} \
-- 
2.28.0


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

