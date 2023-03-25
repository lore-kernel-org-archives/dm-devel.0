Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C52FAC6FD1C
	for <dm-devel@archiver.kernel.org>; Sat, 25 Mar 2023 22:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679783329;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=oO2zSYa3r7la4/3SxQZojS5A5IxzAB+r4X4VKvFXmBQ=;
	b=KDthWCFnNLpEpjqvDeYhFgpdcGDt2HRhdb47N6iCFPYAKEUMyl81+0SfBBOYvs/74bXL1I
	Ayto5/BQZj8BQvLh8NQqCOKTfkZPRreqNnHG+jNgyGVhuZfG04Vq9DS3esvSK0UdCI6li+
	g3y0Hp9BlUHq1OoxXplDlxuUiS5VEMs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-605-Y2Mmo70TNzy2NR3IiE14Kw-1; Sat, 25 Mar 2023 18:28:46 -0400
X-MC-Unique: Y2Mmo70TNzy2NR3IiE14Kw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7A7C2811E7C;
	Sat, 25 Mar 2023 22:28:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D889E2166B26;
	Sat, 25 Mar 2023 22:28:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7CCF919465A0;
	Sat, 25 Mar 2023 22:28:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B370D194658F
 for <dm-devel@listman.corp.redhat.com>; Sat, 25 Mar 2023 22:28:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9C8AF492B01; Sat, 25 Mar 2023 22:28:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 95B83492C3E
 for <dm-devel@redhat.com>; Sat, 25 Mar 2023 22:28:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7A617811E7C
 for <dm-devel@redhat.com>; Sat, 25 Mar 2023 22:28:39 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-633-cmV_Faw4OXirr_HXpqerZQ-1; Sat,
 25 Mar 2023 18:28:37 -0400
X-MC-Unique: cmV_Faw4OXirr_HXpqerZQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 4387A336AD;
 Sat, 25 Mar 2023 22:28:30 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0D5EB13463;
 Sat, 25 Mar 2023 22:28:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id CLWQAY51H2QpWgAAMHmgww
 (envelope-from <mwilck@suse.com>); Sat, 25 Mar 2023 22:28:30 +0000
From: mwilck@suse.com
To: Benjamin Marzinski <bmarzins@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>, lixiaokeng@huawei.com
Date: Sat, 25 Mar 2023 23:28:20 +0100
Message-Id: <20230325222820.3392-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: [dm-devel] [PATCH] multipathd.service: remove
 "Also=multipathd.socket"
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

This "Also=" directive is wrong. It was meant for enabling socket activation,
but it actually does the opposite. "Also=multipathd.socket" means that
enabling/disabling the service will enable/disable the socket, too. This is
not what we want: socket activation means that we can enable the socket
while the service is disabled and will be activated by the socket on demand.

See https://github.com/dracutdevs/dracut/pull/2290,
https://github.com/opensvc/multipath-tools/issues/65

Fixes: ca985df ("multipathd: switch to socket activation for systemd")
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/multipathd.service | 1 -
 1 file changed, 1 deletion(-)

diff --git a/multipathd/multipathd.service b/multipathd/multipathd.service
index aec62db..5a9cde1 100644
--- a/multipathd/multipathd.service
+++ b/multipathd/multipathd.service
@@ -22,4 +22,3 @@ TasksMax=infinity
 
 [Install]
 WantedBy=sysinit.target
-Also=multipathd.socket
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

