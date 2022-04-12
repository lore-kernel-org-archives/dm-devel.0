Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D561EC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 12 Apr 2022 02:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1649728828;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=F6HgnrNRVqmQ9Y/j3CEGkJla3u5XCY/IsBqixFua+lE=;
	b=JhWG5OX6wzohqKmIToVs21rWrn49VLnNZUbjYh5cKliCDM+CrRZLASxaydfqu1TJ2scFZB
	cXxI9n5PW11LChQ83gDTrspIpoeudWvHcZSj45bVo+sYNON2Cqu9dc/hCg+67cSLp2TTjL
	KDJhedYBrp/V5oPV0242QhRCs65Cb6Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-637-TnoDk_KoNUq6twSSzrODAw-1; Mon, 11 Apr 2022 22:00:27 -0400
X-MC-Unique: TnoDk_KoNUq6twSSzrODAw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2644D8038E3;
	Tue, 12 Apr 2022 02:00:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 12CC92166B5D;
	Tue, 12 Apr 2022 02:00:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BF9511940365;
	Tue, 12 Apr 2022 02:00:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6EA751947BBF
 for <dm-devel@listman.corp.redhat.com>; Tue, 12 Apr 2022 02:00:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3F2717C2F; Tue, 12 Apr 2022 02:00:24 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AC0587C2B;
 Tue, 12 Apr 2022 02:00:12 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 23C20BGs011864;
 Mon, 11 Apr 2022 21:00:11 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 23C20B2D011863;
 Mon, 11 Apr 2022 21:00:11 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Mon, 11 Apr 2022 20:59:59 -0500
Message-Id: <1649728799-11790-10-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1649728799-11790-1-git-send-email-bmarzins@redhat.com>
References: <1649728799-11790-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: [dm-devel] [PATCH 9/9] libmultipath: Add documentation for the
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipath/multipath.conf.5 | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 97695da4..dab1d58f 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -1678,6 +1678,41 @@ section:
 .RE
 .PD
 .LP
+The device subsection also recognizes the optional \fIprotocol\fR subsection. A
+single device subsection can contain multiple protocol subsections. Devices are
+matched against the protocol subsection using the mandatory \fItype\fR
+attribute.  Attributes in a matching protocol subsection take precedence over
+attributes in the containing device subsection. If there are multiple matching
+protocol subsections within a device subsection, later entries take precedence.
+If there are multiple matching device subsections, attributes in later device
+subsections still take precedence over attributes in a protocol subsection of
+an earlier device subsection.
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
+from the containing \fIdevice\fR subsection:
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
@@ -1764,6 +1799,9 @@ the values are taken from the \fIdevices\fR or \fIdefaults\fR sections:
 .RE
 .PD
 .LP
+The overrides section also recognizes the optional \fIprotocol\fR subsection
+and can contain multiple protocol subsections. For a full description of this
+subsection please see its description in the \fIdevices\fR section.
 .
 .
 .\" ----------------------------------------------------------------------------
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

