Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 571B6156880
	for <dm-devel@lists.linux.dev>; Thu, 25 Apr 2024 23:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714088124; cv=none; b=Db5xci8evuHMRoFhcg4r4SuslHK1DIY1q3+z19htRsjUhGpJo1tOALIFSWHjPejxDU/FVjEP6O0XdROBbTnlAfDsqri+C7GmboX2cId/7c64Zza3FsuI159IDVyIjFImS36ZLnF60sMACbZLkM8/Set9vex45S0fqhvFz0MTIUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714088124; c=relaxed/simple;
	bh=gIXjVEdPkB9nUekpb545jMp0pgXNbz4sub5Vw0Zd5w0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DwOAh5p+ahnYJ+LuTa0QZubDJYUCkyn8THhlbKCvbPmcsJZGKEujuluuglV0spuIDfgBteHbfPugybP3PvJLII4XsIt+HdyJb902umjnLOx6xEOLCNyqfwq3MQdxti3SLBcxn5hSTdjFijHdC620CWoXXJjtytXmlUnBDCzWH24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A13aCWqV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A13aCWqV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714088122;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TTmObKnhDAkO7D9oRNftg3SlmH4jF6dOC1JFAV1IEVY=;
	b=A13aCWqVvdy1SQEzh/NzeVWgrlybW/bZhETWxparsoBTnqWlUT2w55j26I/AYJQO2nMBFu
	YmmfgwVBYG0Ok1bjelmVGwc0P+R8JjZaa4nS3SlTp+yLffDBjk7ApPsFGqqNemo/PRKKQW
	8iLlgaDspaRxCIpmavVxnvX9noAOI1M=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-534-D_jyO-G4OOOGMiOPGr8aRw-1; Thu,
 25 Apr 2024 19:35:19 -0400
X-MC-Unique: D_jyO-G4OOOGMiOPGr8aRw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8BC0E29AA385;
	Thu, 25 Apr 2024 23:35:18 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 85084492BC7;
	Thu, 25 Apr 2024 23:35:18 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 43PNZIwJ2125172
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 25 Apr 2024 19:35:18 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 43PNZIN72125171;
	Thu, 25 Apr 2024 19:35:18 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 4/5] libmultipath: pad dev_loss_tmo to avoid race with no_path_retry
Date: Thu, 25 Apr 2024 19:35:16 -0400
Message-ID: <20240425233517.2125142-5-bmarzins@redhat.com>
In-Reply-To: <20240425233517.2125142-1-bmarzins@redhat.com>
References: <20240425233517.2125142-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Currently multipath makes sure that dev_loss_tmo is at least as long as
the configured no path queueing time. The goal is to make sure that path
devices aren't removed while the multipath device is still queueing in
hopes that they will become usable again.

This is racy. Multipathd may take longer to check the paths than
configured. If strict_timing isn't set, it will definitely take longer.
To account for this, pad the minimum dev_loss_tmo value by five seconds
(one default checker interval) plus one second per minute of no path
queueing time.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 6fd4dabb..e2052422 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -901,6 +901,11 @@ sysfs_set_scsi_tmo (struct config *conf, struct multipath *mpp)
 		uint64_t no_path_retry_tmo =
 			(uint64_t)mpp->no_path_retry * conf->checkint;
 
+		/* pad no_path_retry_tmo by one standard check interval
+		 * plus one second per minute to account for timing
+		 * issues with the rechecks */
+		no_path_retry_tmo += no_path_retry_tmo / 60 + DEFAULT_CHECKINT;
+
 		if (no_path_retry_tmo > MAX_DEV_LOSS_TMO)
 			min_dev_loss = MAX_DEV_LOSS_TMO;
 		else
-- 
2.43.0

