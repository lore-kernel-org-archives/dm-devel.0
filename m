Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EC4CC433EF
	for <dm-devel@archiver.kernel.org>; Wed,  1 Dec 2021 23:11:07 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-471-2tqZPj-YNfSQOzTrqC_dOQ-1; Wed, 01 Dec 2021 18:11:03 -0500
X-MC-Unique: 2tqZPj-YNfSQOzTrqC_dOQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D8FCF1006AA1;
	Wed,  1 Dec 2021 23:10:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 875C260C04;
	Wed,  1 Dec 2021 23:10:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D70C41809C8A;
	Wed,  1 Dec 2021 23:10:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B1NAtjM015990 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 1 Dec 2021 18:10:55 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6FA5F1121315; Wed,  1 Dec 2021 23:10:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6B4EB1121314
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 23:10:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 43D7D811E78
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 23:10:51 +0000 (UTC)
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com
	[209.85.128.44]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-233-1d4fSR-cPnKnHJ83Bj8fbw-1; Wed, 01 Dec 2021 18:10:49 -0500
X-MC-Unique: 1d4fSR-cPnKnHJ83Bj8fbw-1
Received: by mail-wm1-f44.google.com with SMTP id i12so21629046wmq.4;
	Wed, 01 Dec 2021 15:10:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=ho6ArdUfbB6nPM9dtEC0hP99Xu59t+gu+xhwAgYNCPk=;
	b=HRq/gx42S+pn3rh+2ttceCTeWddZ9JC0cjs8Mbv2kHZiQ+KoCWhCAUDTS12jkfGf+i
	/TsFtQsXJjtXB3dYichj0LQld9MNLTsr0dgxumjpo2DTXhRDsWnB80celCt53Tg8MbE0
	+XaLzq38phMNxZg/I5+UKXU5hofDCNHn4+wde4UDAH5ZL3oN0iblIAhUwfKVT6kseKm2
	+yDODtRr6TGaAAbkLWVOvDjqClMsAujxZR3si1fXySdkMdsn9yEIHh+yeXHwM/JL9+Rn
	fSQ4XpBh0imwuB2LlsovPJn6b+QcgX4ylp3wQPr0TQ+CDHCydfTtb/bTQExOqqBmSwrP
	P43A==
X-Gm-Message-State: AOAM533tpevtpz9Xp90nedGa8UvbNDwdSoWulZST7Dwbw0at+2Z8Pv3Q
	WDxsMbJdGFUmxWm0yPSEIA==
X-Google-Smtp-Source: ABdhPJzlB1TlJCLpUkdaUpEVRqu1iH/L9t2K2YgdSj5+UxNUWmKIiuazRrf8VcOpvLan3C3fCfk2xw==
X-Received: by 2002:a05:600c:3584:: with SMTP id
	p4mr1480231wmq.109.1638400248057; 
	Wed, 01 Dec 2021 15:10:48 -0800 (PST)
Received: from localhost (50.red-83-33-156.dynamicip.rima-tde.net.
	[83.33.156.50])
	by smtp.gmail.com with ESMTPSA id g16sm708967wmq.20.2021.12.01.15.10.47
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 01 Dec 2021 15:10:47 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Thu,  2 Dec 2021 00:10:46 +0100
Message-Id: <20211201231046.5638-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>,
	DM-DEVEL ML <dm-devel@redhat.com>
Subject: [dm-devel] [PATCH] multipath-tools: add .mailmap file
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
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 .mailmap | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)
 create mode 100644 .mailmap

diff --git a/.mailmap b/.mailmap
new file mode 100644
index 00000000..2c04cb0a
--- /dev/null
+++ b/.mailmap
@@ -0,0 +1,24 @@
+#
+# This list is used by git-shortlog to fix a few botched name translations
+# in the git archive, either because the author's full name was messed up
+# and/or not always written the same way, making contributions from the
+# same person appearing not to be so or badly displayed. Also allows for
+# old email addresses to map to new email addresses.
+#
+# For format details, see "MAPPING AUTHORS" in "man git-shortlog".
+#
+# Please keep this list dictionary sorted.
+#
+Benjamin Marzinski <bmarzins@redhat.com> <bmarzin@redhat.com>
+Benjamin Marzinski <bmarzins@redhat.com> <bmarzins@sourceware.org>
+Benjamin Marzinski <bmarzins@redhat.com> bmarzins@sourceware.org <bmarzins@sourceware.org>
+Christophe Varoqui <christophe.varoqui@opensvc.com> <christophe.varoqui@free.fr>
+Christophe Varoqui <christophe.varoqui@opensvc.com> <cvaroqui@cl039.(none)>
+Christophe Varoqui <christophe.varoqui@opensvc.com> <cvaroqui@hera.kernel.org>
+Christophe Varoqui <christophe.varoqui@opensvc.com> <cvaroqui@zezette.localdomain>
+Christophe Varoqui <christophe.varoqui@opensvc.com> root <root@potab.(none)>
+Christophe Varoqui <christophe.varoqui@opensvc.com> root <root@xa-s05.(none)>
+Christophe Varoqui <christophe.varoqui@opensvc.com> root <root@zezette.localdomain>
+Christophe Varoqui <christophe.varoqui@opensvc.com> <root@xa-s05.(none)>
+Martin Wilck <mwilck@suse.com> <Martin.Wilck@suse.com>
+Martin Wilck <mwilck@suse.com> <mwilck@suse.de>
-- 
2.33.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

