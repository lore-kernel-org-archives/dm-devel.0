Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4362EC433EF
	for <dm-devel@archiver.kernel.org>; Thu, 14 Apr 2022 04:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1649910480;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=zPjI4xP8kYcjaK3WsIthwgsKJtvVsRcQvrvGHVybVas=;
	b=E0SJdEdqd8T7bs7L/CvrvAi1oaCCnaepOD6U06nEIAyEEqlLuGcqDmfZsCf6j5dOw2KvAz
	DqowUlR+iQe004DECgi1DlBPtFAdV9lBBwEnGr7z0eHk0i/c7ADgqMH31ycgYlOHP/fx/5
	/ib3u1LMN9WYhuUYKKhaA+EznERWQ00=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-197-c8VzKiTBMtC74J-fmzCawQ-1; Thu, 14 Apr 2022 00:27:56 -0400
X-MC-Unique: c8VzKiTBMtC74J-fmzCawQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2CA4A1C05ECF;
	Thu, 14 Apr 2022 04:27:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1BE03580931;
	Thu, 14 Apr 2022 04:27:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DAFEC1940345;
	Thu, 14 Apr 2022 04:27:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B1B48193F6E0
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Apr 2022 04:27:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A38332166BA4; Thu, 14 Apr 2022 04:27:52 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 936CC2166B1B;
 Thu, 14 Apr 2022 04:27:52 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 23E4RpG2025329;
 Wed, 13 Apr 2022 23:27:51 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 23E4Rojn025328;
 Wed, 13 Apr 2022 23:27:50 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed, 13 Apr 2022 23:27:41 -0500
Message-Id: <1649910461-25263-8-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1649910461-25263-1-git-send-email-bmarzins@redhat.com>
References: <1649910461-25263-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: [dm-devel] [PATCH v2 7/7] libmultipath: Add documentation for the
 protocol subsection
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
 multipath/multipath.conf.5 | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 97695da4..198a79dd 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -1764,6 +1764,38 @@ the values are taken from the \fIdevices\fR or \fIdefaults\fR sections:
 .RE
 .PD
 .LP
+The overrides section also recognizes the optional \fIprotocol\fR subsection,
+and can contain multiple protocol subsections. Path devices are matched against
+the protocol subsection using the mandatory \fItype\fR attribute.  Attributes
+in a matching protocol subsection take precedence over attributes in the rest
+of the overrides section. If there are multiple matching protocol subsections,
+later entries take precedence.
+.TP
+.B protocol subsection
+The protocol subsection recognizes the following mandatory attribute:
+.RS
+.TP
+.B type
+The protocol string of the path device. The possible values are \fIscsi:fcp\fR,
+\fIscsi:spi\fR, \fIscsi:ssa\fR, \fIscsi:sbp\fR, \fIscsi:srp\fR,
+\fIscsi:iscsi\fR, \fIscsi:sas\fR, \fIscsi:adt\fR, \fIscsi:ata\fR,
+\fIscsi:unspec\fR, \fIccw\fR, \fIcciss\fR, \fInvme\fR, and \fIundef\fR. This is
+\fBnot\fR a regular expression. the path device protcol string must match
+exactly. The protocol that a path is using can be viewed by running
+\fBmultipathd show paths format "%d %P"\fR
+.LP
+The following attributes are optional; if not set, the default values are taken
+from the \fIoverrides\fR, \fIdevices\fR, or \fIdefaults\fR section:
+.sp 1
+.PD .1v
+.RS
+.TP
+.B fast_io_fail_tmo
+.TP
+.B dev_loss_tmo
+.TP
+.B eh_deadline
+.PD
 .
 .
 .\" ----------------------------------------------------------------------------
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

