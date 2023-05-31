Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07A5FC7EE23
	for <dm-devel@archiver.kernel.org>; Wed, 31 May 2023 14:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685542376;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ucoAdE2fv8MTmk9xL38SJuEKH0/q4P7ZNpsp3x4A4ks=;
	b=FWzIBDlchofxrjRDk/LR4v53QJcN7cQreR4oskjlrn/HcaagOcarFt2AcTUovXH4gmp4HD
	QfZPpngDBcwqaqNZ5tgLWwlkvFibW6mlmwEfqaXXXnTTJ+so5E4tY38fuJHZfoJIj8p18v
	jyjzX4Ws7Y/blFjrqgeP2zHreyMD+LU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-222-EtOGbUfMOSaZ5dURPmwx8g-1; Wed, 31 May 2023 10:12:52 -0400
X-MC-Unique: EtOGbUfMOSaZ5dURPmwx8g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2A2C78030D7;
	Wed, 31 May 2023 14:12:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 12B202166B28;
	Wed, 31 May 2023 14:12:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C9DEE19465BD;
	Wed, 31 May 2023 14:12:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1346C1946595
 for <dm-devel@listman.corp.redhat.com>; Wed, 31 May 2023 13:57:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F22B640CFD45; Wed, 31 May 2023 13:57:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EB35D40CFD46
 for <dm-devel@redhat.com>; Wed, 31 May 2023 13:57:24 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CD029802E58
 for <dm-devel@redhat.com>; Wed, 31 May 2023 13:57:24 +0000 (UTC)
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com
 [209.85.128.42]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-199-E9PRYeNGP3W9YCUMyGqxpw-1; Wed, 31 May 2023 09:57:20 -0400
X-MC-Unique: E9PRYeNGP3W9YCUMyGqxpw-1
Received: by mail-wm1-f42.google.com with SMTP id
 5b1f17b1804b1-3f61530506aso61357415e9.1; 
 Wed, 31 May 2023 06:57:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685541437; x=1688133437;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=Di3fqTS7xTczziB0FPO0VOdl9UVDHaATd6+DxUAuHMg=;
 b=fEl5FPSzCdLjjC6DzKcoMK+jvp3uDon/PFPhzU7R9eV1UqamY1rPS79k0Yb9H9TW+N
 xFpXXP38a2a1bqfF9TvjJ75z/P/7e+ICojDQ0YWYYvIxhy9ydwF69yqS846ynyDjOsue
 968d1Pn1SF+/aw8fBDli3BDERw36qxOzqqWtnwPm67RBXVDSpKh3txIr2m6OAYMuHw4C
 5aKwSjKYVk9BfnQnjs6xOPKowl3IDn45qpKvQHeErb0SWG2n1o7y1ZJBIxpSVCGVUI0V
 lw7gHjU3CgUUPgyRWnVCbWyUVP/MuJBnjKQ9fdfAu7MHa3sglZMWrOJcW8oMzhf1uDgX
 4DlA==
X-Gm-Message-State: AC+VfDwSQRg7ePdBzjFm2V9z34VXa5gqhJ7lLiACvphPZceUJlolC9a5
 H75PuC17c5UBqR0wcI34vA==
X-Google-Smtp-Source: ACHHUZ66TOIzYGNMuC9R6eu+PQOTXBJmUu12lU4mUOWUZa6QA68I0tbZ7Dhsj+LQYhHhecFnL76jrA==
X-Received: by 2002:adf:e409:0:b0:30a:f17e:e02e with SMTP id
 g9-20020adfe409000000b0030af17ee02emr4195777wrm.12.1685541436827; 
 Wed, 31 May 2023 06:57:16 -0700 (PDT)
Received: from localhost (74.red-88-28-4.dynamicip.rima-tde.net. [88.28.4.74])
 by smtp.gmail.com with ESMTPSA id
 v4-20020a5d4a44000000b0030497b3224bsm6918810wrs.64.2023.05.31.06.57.15
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 31 May 2023 06:57:16 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Wed, 31 May 2023 15:57:13 +0200
Message-Id: <20230531135713.13914-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] [PATCH] multipath-tools: adapt HITACHI/OPEN- config to
 work with alua and multibus
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
Cc: Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>,
 Xose Vazquez Perez <xose.vazquez@gmail.com>, DM-DEVEL ML <dm-devel@redhat.com>,
 Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

ALUA is needed by Hitachi Global-Active Device (GAD):
https://knowledge.hitachivantara.com/Documents/Management_Software/SVOS/8.1/Global-Active_Device/Overview_of_global-active_device

Cc: Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 65bca744..a858ffa9 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -485,7 +485,9 @@ static struct hwentry default_hw[] = {
 		/* USP-V, HUS VM, VSP, VSP G1X00 and VSP GX00 families / HPE XP */
 		.vendor        = "(HITACHI|HP|HPE)",
 		.product       = "^OPEN-",
-		.pgpolicy      = MULTIBUS,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.no_path_retry = 10,
 	},
 	{
 		/* AMS other than AMS 2000 */
-- 
2.40.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

