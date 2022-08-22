Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6A1AC38142
	for <dm-devel@archiver.kernel.org>; Mon, 22 Aug 2022 20:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661200922;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Ii9nU/n6D4JGf7BizG68vH+e8d6eMPMkxAwaCrDcApA=;
	b=c2j7kzAFQo7xfqgjgOLyD4LcHYNOgJluOnOMbqP4jbk+UNzuHR/y6FRBKrF5I2jbYxS5VZ
	MzuW7wKoFDEChx5IvK5tDGSnjVnZWJQQNNoPZ+sRl69g/F1l1+JFsPgcZqFHl5b1fYuixY
	JMFEJaCpgScxp3mQ41tU8SE9P4mygmg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-438-d3IgRNwGP5apIHcoweykEg-1; Mon, 22 Aug 2022 16:42:01 -0400
X-MC-Unique: d3IgRNwGP5apIHcoweykEg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2D8AB1C05159;
	Mon, 22 Aug 2022 20:41:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1C89C492C3B;
	Mon, 22 Aug 2022 20:41:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0EAA51946A47;
	Mon, 22 Aug 2022 20:41:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1A33E1946A5A
 for <dm-devel@listman.corp.redhat.com>; Mon, 22 Aug 2022 20:41:58 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0098E40334B; Mon, 22 Aug 2022 20:41:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F13AC492C3B
 for <dm-devel@redhat.com>; Mon, 22 Aug 2022 20:41:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D938E18E5356
 for <dm-devel@redhat.com>; Mon, 22 Aug 2022 20:41:57 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-17-OVS4546yOPKidWhY7xy9rg-1; Mon,
 22 Aug 2022 16:41:53 -0400
X-MC-Unique: OVS4546yOPKidWhY7xy9rg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id C760D37339;
 Mon, 22 Aug 2022 20:41:51 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8C79913523;
 Mon, 22 Aug 2022 20:41:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id kEG9IA/qA2MOAwAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 22 Aug 2022 20:41:51 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 22 Aug 2022 22:41:19 +0200
Message-Id: <20220822204119.20719-12-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: [dm-devel] [PATCH v2 11/11] multipathd: fix incompatible pointer
 type error with libedit
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Versions of libedit prior to 2016 were using a wrong prototype for
rl_completion_entry_function in readline.h. Internally, libedit casts this to
the correct type (char *)(*)(const char *, int) (aka CPFunction in libedit).
So we simply cast to the wrong prototype here.

See http://cvsweb.netbsd.org/bsdweb.cgi/src/lib/libedit/readline/readline.h.diff?r1=1.34&r2=1.35

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/multipathd/Makefile b/multipathd/Makefile
index 8a56304..28ebdc0 100644
--- a/multipathd/Makefile
+++ b/multipathd/Makefile
@@ -34,6 +34,10 @@ endif
 ifeq ($(READLINE),libreadline)
 RL_CPPFLAGS += -DUSE_LIBREADLINE
 RL_LIBDEPS += -lreadline
+# See comment in uxclnt.c
+ifeq ($(shell sed -En 's/.*\<Function\s*\*rl_completion_entry_function;.*/yes/p' /usr/include/editline/readline.h),yes)
+RL_CPPFLAGS += -DBROKEN_RL_COMPLETION_FUNC
+endif
 endif
 
 ifdef SYSTEMD
-- 
2.37.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

