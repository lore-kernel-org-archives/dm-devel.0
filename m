Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6020EC43217
	for <dm-devel@archiver.kernel.org>; Thu, 14 Apr 2022 04:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1649910478;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=V1Rw4ur07OthX2qkJZ6vxx6QSVNv3QzhXk38Dz88XxE=;
	b=i6hIlpgTk9PHrLwtrnbEjD7DMMzJXpJbkLEIESWDICBgqEUzxj8gp0tXMM38VW6py5BDI7
	8Ogz+krxCEUmZ5NHwAlP9CYp/Mx7RKKtNv7XFjh30RogR4Vksd9F0u9W4KC+FDp4LePfsJ
	LIahhiou9RD0gDPNvlSgy2J6yvUIAvM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-550-y8fmJaDPOgenLOf59M593A-1; Thu, 14 Apr 2022 00:27:55 -0400
X-MC-Unique: y8fmJaDPOgenLOf59M593A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E3EFC1014A6B;
	Thu, 14 Apr 2022 04:27:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D249B58092F;
	Thu, 14 Apr 2022 04:27:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A423D1940345;
	Thu, 14 Apr 2022 04:27:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 70ED21940345
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Apr 2022 04:27:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 62AE82166BA4; Thu, 14 Apr 2022 04:27:51 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 524DA2166B4F;
 Thu, 14 Apr 2022 04:27:51 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 23E4Ro7C025325;
 Wed, 13 Apr 2022 23:27:50 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 23E4RnM0025324;
 Wed, 13 Apr 2022 23:27:49 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed, 13 Apr 2022 23:27:40 -0500
Message-Id: <1649910461-25263-7-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1649910461-25263-1-git-send-email-bmarzins@redhat.com>
References: <1649910461-25263-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: [dm-devel] [PATCH v2 6/7] libmultipath: fix eh_deadline
 documentation
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
Cc: device-mapper development <dm-devel@redhat.com>,
 Martin Wilck <Martin.Wilck@suse.com>
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipath/multipath.conf.5 | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 605b46e0..97695da4 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -1636,6 +1636,8 @@ section:
 .TP
 .B dev_loss_tmo
 .TP
+.B eh_deadline
+.TP
 .B flush_on_last_del
 .TP
 .B user_friendly_names
@@ -1722,6 +1724,8 @@ the values are taken from the \fIdevices\fR or \fIdefaults\fR sections:
 .TP
 .B dev_loss_tmo
 .TP
+.B eh_deadline
+.TP
 .B user_friendly_names
 .TP
 .B retain_attached_hw_handler
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

