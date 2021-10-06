Return-Path: <SRS0=PPuu=O2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C490C433F5
	for <dm-devel@archiver.kernel.org>; Wed,  6 Oct 2021 19:33:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E69AB61184
	for <dm-devel@archiver.kernel.org>; Wed,  6 Oct 2021 19:33:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E69AB61184
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1633548812;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=4Oux9j75xZoK+yhw2R6yXcd6RPVB2V7GhSDHBTgIsJM=;
	b=KrZ4XyD3irMV/PyLkrGcvpMhizLFOGgxHOg7uG+aCC2/Yz2Wnb7XAIJcimkXltoBAT2Y5v
	fUnlHLpOF0egLaDQdBUTBligAqNqrsRVOkXQZY29fcMEoM/hDDXqJ8Qf8cWO6WobG8yRd7
	D7LBNP+Jb/XrN440pm4h3MjLKLBNvbQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-325-E2hFB711P0eVcnFyLFdlkQ-1; Wed, 06 Oct 2021 15:33:27 -0400
X-MC-Unique: E2hFB711P0eVcnFyLFdlkQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 09A26362FD;
	Wed,  6 Oct 2021 19:33:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DF29A1F42C;
	Wed,  6 Oct 2021 19:33:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B60884EA3A;
	Wed,  6 Oct 2021 19:33:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
	[10.5.11.23])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 196JQ5X5016699 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 6 Oct 2021 15:26:05 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id AEFB71F443; Wed,  6 Oct 2021 19:26:05 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B01641F458;
	Wed,  6 Oct 2021 19:25:55 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 196JPsPu025273; 
	Wed, 6 Oct 2021 14:25:54 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 196JPrw3025272;
	Wed, 6 Oct 2021 14:25:53 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed,  6 Oct 2021 14:25:48 -0500
Message-Id: <1633548350-25227-3-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1633548350-25227-1-git-send-email-bmarzins@redhat.com>
References: <1633548350-25227-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH v2 2/4] multipathd: remove reconfigure from
	header file.
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
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Only multipathd/main.c uses it.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/multipathd/main.h b/multipathd/main.h
index 23ce919e..a1697a74 100644
--- a/multipathd/main.h
+++ b/multipathd/main.h
@@ -39,7 +39,6 @@ enum daemon_status wait_for_state_change_if(enum daemon_status oldstate,
 					    unsigned long ms);
 void schedule_reconfigure(void);
 int need_to_delay_reconfig (struct vectors *);
-int reconfigure (struct vectors *);
 int ev_add_path (struct path *, struct vectors *, int);
 int ev_remove_path (struct path *, struct vectors *, int);
 int ev_add_map (char *, const char *, struct vectors *);
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

