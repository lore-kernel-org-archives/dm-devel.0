Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97525C636D6
	for <dm-devel@archiver.kernel.org>; Fri, 17 Feb 2023 20:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676664478;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=+infrSr3LtQDDmI0JkjKAzzMby+riafNb1+VZ/05SU0=;
	b=FfniF0tToNOdYFGGWlBdOmpcaerR+br8XHdtbtEFh44M4TdizjlH2G3zUcNx5dYInYaYcM
	hsuMtGr/+ax467tdnnyRz5xcwupa0VnUiKguMoxwZ17a2Ysi/VrVa6VPiOFzH37BPyfQWy
	vKjm15ihfFtsubHgPozWj/YGOqUSnqc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-390-s8sATNEaNXysFblLPantFg-1; Fri, 17 Feb 2023 15:07:55 -0500
X-MC-Unique: s8sATNEaNXysFblLPantFg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B52AA1C05B16;
	Fri, 17 Feb 2023 20:07:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A52D4492C3E;
	Fri, 17 Feb 2023 20:07:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8C16C1946595;
	Fri, 17 Feb 2023 20:07:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 40FDC1946588
 for <dm-devel@listman.corp.redhat.com>; Fri, 17 Feb 2023 20:07:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 323C040CF8EC; Fri, 17 Feb 2023 20:07:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2B0744010E83
 for <dm-devel@redhat.com>; Fri, 17 Feb 2023 20:07:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 112BD1024D28
 for <dm-devel@redhat.com>; Fri, 17 Feb 2023 20:07:51 +0000 (UTC)
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com
 [209.85.219.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-35-iWzp0pblMkWw9J7wEODxIQ-1; Fri, 17 Feb 2023 15:07:49 -0500
X-MC-Unique: iWzp0pblMkWw9J7wEODxIQ-1
Received: by mail-qv1-f51.google.com with SMTP id l4so2392031qvv.7
 for <dm-devel@redhat.com>; Fri, 17 Feb 2023 12:07:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=sZZVS1BQ772kU8mUFZkQcPajBCfh+eU0H6LbUQq+D8I=;
 b=l57RnrJLgB0nUljxGCwUR93nWraMBxj/eVSLFtRy4bCQ1tEt3asw1d0E4vddscEeQ5
 TgnBsz8pMIFV7m0gRsVDqvBBrFEjplXU/6EjJF/0A0INIsGRPG6PZ4aGvwZvzIRPWj9E
 aGvBUDUetNKzu9g86PeztMNPT8dmhPHHjZGtGGYXrZlaAbAl9+5N0SsELElPpN5T43Qo
 KKOrkFCd3CdaWbNttgonzUvxknVcR8nRUXlkh4fLZU3nriB3lMgzCdy/dQID0jD8WTOK
 +h1McZ2b5AsaRS0aZD4wwl1WTvIa2otPUJvIJMsfBruFEJqnyDwG64u07DtF7VGi+plC
 P0jw==
X-Gm-Message-State: AO0yUKWwyY+cl0L4ihxQsqPke71hemsskT/lnavWYHPwK3jd88QZ4q44
 1t2KKgfNrVWK3FJp1M95meaSMO4I+YpZbOl29vzzTlwGtplPSWh+s76n4Lk7yPWmXHN0ZCfj3wE
 xEafw+O7zQfnW/lzrq3Unoig51dNS4cwKA9DaL3RbpNLtM/kw3S4AjAzI5cN/wMgI2zS6Tw==
X-Google-Smtp-Source: AK7set894zqHFGFaFRFDrxQLBorzsXEosTVVgdA7/G8zAwdSNTLR+wnit06Pmr/fD8GJts3iMf2WKg==
X-Received: by 2002:a05:6214:f2e:b0:56f:9d:1e29 with SMTP id
 iw14-20020a0562140f2e00b0056f009d1e29mr12053381qvb.21.1676664468304; 
 Fri, 17 Feb 2023 12:07:48 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 a186-20020a3798c3000000b0073b878e3f30sm3954144qke.59.2023.02.17.12.07.47
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 17 Feb 2023 12:07:47 -0800 (PST)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Fri, 17 Feb 2023 15:07:37 -0500
Message-Id: <20230217200737.12481-7-snitzer@kernel.org>
In-Reply-To: <20230217200737.12481-1-snitzer@kernel.org>
References: <20230217200737.12481-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] [PATCH 6/6] dm ioctl: remove unnecessary check when
 using dm_get_mdptr()
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
Cc: Mike Snitzer <snitzer@kernel.org>, Hou Tao <houtao1@huawei.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Hou Tao <houtao1@huawei.com>

__hash_remove() removes hash_cell with _hash_lock locked, so acquiring
_hash_lock can guarantee no-NULL hc returned from dm_get_mdptr() must
have not been removed and hc->md must still be md.

__hash_remove() also acquires dm_hash_cells_mutex before setting mdptr
as NULL. So in dm_copy_name_and_uuid(), after acquiring
dm_hash_cells_mutex and ensuring returned hc is not NULL, the returned
hc must still be alive and hc->md must still be md.

Remove the unnecessary hc->md != md checks when using dm_get_mdptr()
with _hash_lock or dm_hash_cells_mutex acquired.

Signed-off-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-ioctl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 067dfc08d4c3..50a1259294d1 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -789,7 +789,7 @@ static struct dm_table *dm_get_inactive_table(struct mapped_device *md, int *src
 
 	down_read(&_hash_lock);
 	hc = dm_get_mdptr(md);
-	if (!hc || hc->md != md) {
+	if (!hc) {
 		DMERR("device has been removed from the dev hash table.");
 		goto out;
 	}
@@ -1500,7 +1500,7 @@ static int table_load(struct file *filp, struct dm_ioctl *param, size_t param_si
 	/* stage inactive table */
 	down_write(&_hash_lock);
 	hc = dm_get_mdptr(md);
-	if (!hc || hc->md != md) {
+	if (!hc) {
 		DMERR("device has been removed from the dev hash table.");
 		up_write(&_hash_lock);
 		r = -ENXIO;
@@ -2152,7 +2152,7 @@ int dm_copy_name_and_uuid(struct mapped_device *md, char *name, char *uuid)
 
 	mutex_lock(&dm_hash_cells_mutex);
 	hc = dm_get_mdptr(md);
-	if (!hc || hc->md != md) {
+	if (!hc) {
 		r = -ENXIO;
 		goto out;
 	}
-- 
2.37.0 (Apple Git-136)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

