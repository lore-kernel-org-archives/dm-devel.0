Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40220C4332F
	for <dm-devel@archiver.kernel.org>; Thu,  3 Nov 2022 16:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667492274;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=t2aD0Nsh8L/9gUTmFmrOmyXJ0aFTdUXA3zrMb1DIQok=;
	b=M3OW12booOSsoEoezIUu62vl6AjrWNvFVLRFJElxvHlkHQq00DInwBZ4yAO+acLtW70QRE
	REiX56+d28/PWIFJVZi+oL9N0Igc4gmFqFDd6Rc/J4SVpzXQLRpLFeiD3d7J9D4T1EIfBU
	ViFHk8R4moMLMY7SN6gJyEJABCw4DXk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-350-AiNANEO5MCuJ9mhPI-2CZg-1; Thu, 03 Nov 2022 12:17:50 -0400
X-MC-Unique: AiNANEO5MCuJ9mhPI-2CZg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 99CFD381A736;
	Thu,  3 Nov 2022 16:17:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4FC394A9254;
	Thu,  3 Nov 2022 16:17:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3A84D1946597;
	Thu,  3 Nov 2022 16:17:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 878971946594
 for <dm-devel@listman.corp.redhat.com>; Thu,  3 Nov 2022 16:17:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6DFD92166B2E; Thu,  3 Nov 2022 16:17:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 670452166B26
 for <dm-devel@redhat.com>; Thu,  3 Nov 2022 16:17:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 48BD985A59D
 for <dm-devel@redhat.com>; Thu,  3 Nov 2022 16:17:46 +0000 (UTC)
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com
 [209.85.221.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-307-h0pc9UfFMN-JiHsIFQJuFw-1; Thu, 03 Nov 2022 12:17:44 -0400
X-MC-Unique: h0pc9UfFMN-JiHsIFQJuFw-1
Received: by mail-wr1-f47.google.com with SMTP id z14so3519689wrn.7;
 Thu, 03 Nov 2022 09:17:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=UGTuhwD/+vaQLqs8kaDehP096CTGNweQ9I6hIbED7ak=;
 b=cw9bm3i707cS+mQPtr3kALk9DYyp91BnT3/Cb+VAWNXqGbI2c26hZt8/X9F6SBpHyI
 VoCXoWlyrdEQH+bxgC9x9RAdqW63NMcnkdOfG0OBYl6QnTPw/u3h25zO1HLVWsDILeBu
 dap6sT6BOOPRspmqsxKjY3e3goZHjoLfD9H4bQ88Swd/coqvF/AmMtkGMdkSwQ7ZEj58
 yY/ZH9YR169AGfDWJnovZvVdPPuXZE8WI0H4SkuopvvNDYbk4Y66+9eqATGM6NHGrjLy
 giUVGoUNknQVPPb+1TMbzd8X55nDqTcVkM7THaywaOaN9Y+HF7Fk4QgDzkm2LQr4QR5p
 XDYw==
X-Gm-Message-State: ACrzQf0Bn1dLh5KCM+rJQT10FUiW38Cg7yxnuLWBlaOz2mtJFeneVMqu
 RPf2aO7XyCtWTq7QARXTEg==
X-Google-Smtp-Source: AMsMyM5hwsD2kjTb6ytlwsrY/8aYFGp7P4ixJKvu9ngd99igOiCBWhiJmkmRKFo5RbNYVHB8pvxNmg==
X-Received: by 2002:a5d:6488:0:b0:22b:3b0b:5e72 with SMTP id
 o8-20020a5d6488000000b0022b3b0b5e72mr19604510wri.138.1667492262508; 
 Thu, 03 Nov 2022 09:17:42 -0700 (PDT)
Received: from localhost (230.red-81-44-152.dynamicip.rima-tde.net.
 [81.44.152.230]) by smtp.gmail.com with ESMTPSA id
 f11-20020a05600c4e8b00b003b435c41103sm646122wmq.0.2022.11.03.09.17.42
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 03 Nov 2022 09:17:42 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Thu,  3 Nov 2022 17:17:30 +0100
Message-Id: <20221103161730.93378-4-xose.vazquez@gmail.com>
In-Reply-To: <20221103161730.93378-1-xose.vazquez@gmail.com>
References: <20221103161730.93378-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] [PATCH 3/3] multipath-tools: add more info for NetApp
 ontap prio
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
Cc: George Martin <Martin.George@netapp.com>,
 Xose Vazquez Perez <xose.vazquez@gmail.com>, DM-DEVEL ML <dm-devel@redhat.com>,
 Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

and format fixes.

Cc: George Martin <Martin.George@netapp.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 README.md                  |  2 +-
 multipath/multipath.conf.5 | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/README.md b/README.md
index bbeb44fe..31ddbaba 100644
--- a/README.md
+++ b/README.md
@@ -209,7 +209,7 @@ To enable ALUA, the following options should be changed:
 - LSI/Engenio/NetApp RDAC class, as NetApp SANtricity E/EF Series and rebranded arrays:
    "Select operating system:" should be changed to "Linux DM-MP (Kernel 3.10 or later)".
 
-- NetApp ONTAP:
+- NetApp ONTAP FAS/AFF Series:
    To check ALUA state: "igroup show -v <igroup_name>", and to enable ALUA:
    "igroup set <igroup_name> alua yes".
 
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 1fea9d5a..8e28ba12 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -6,7 +6,7 @@
 .\" Update the date below if you make any significant change.
 .\" ----------------------------------------------------------------------------
 .
-.TH MULTIPATH.CONF 5 2022-09-09 Linux
+.TH MULTIPATH.CONF 5 2022-10-01 Linux
 .
 .
 .\" ----------------------------------------------------------------------------
@@ -315,7 +315,8 @@ accepts the optional prio_arg \fIexclusive_pref_bit\fR.
 .TP
 .I ontap
 (Hardware-dependent)
-Generate the path priority for NetApp ONTAP class, and rebranded arrays.
+Generate the path priority for NetApp ONTAP FAS/AFF Series and rebranded arrays,
+with ONTAP native mode(not ALUA).
 .TP
 .I rdac
 (Hardware-dependent)
@@ -1292,8 +1293,6 @@ wwid.
 The default is: \fBno\fR
 .RE
 .
-.
-
 .
 .\" ----------------------------------------------------------------------------
 .SH "blacklist and blacklist_exceptions sections"
@@ -1852,7 +1851,7 @@ the logic when to reinstate, differs between the three methods.
 This method is \fBdeprecated\fR and mapped to the \(dqsan_path_err\(dq method.
 See the \fIdelay_watch_checks\fR and \fIdelay_wait_checks\fR options above
 for more information.
-
+.
 .TP
 .B \(dqmarginal_path\(dq failure tracking
 If a second failure event (good->bad transition) occurs within
@@ -1924,6 +1923,7 @@ size=167772160 features='n/a' hwhandler='ANA' wp=rw
 The \(dqnvme\(dq foreign library provides support for NVMe native multipathing
 in the kernel. It is part of the standard multipath package.
 .
+.
 .\" ----------------------------------------------------------------------------
 .SH "KNOWN ISSUES"
 .\" ----------------------------------------------------------------------------
-- 
2.38.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

