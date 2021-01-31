Return-Path: <SRS0=uUVj=HD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F16FC433E0
	for <dm-devel@archiver.kernel.org>; Mon,  1 Feb 2021 09:37:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B925F64EA4
	for <dm-devel@archiver.kernel.org>; Mon,  1 Feb 2021 09:37:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B925F64EA4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-qw0GA7GtN3iedkUIXjqX_Q-1; Mon, 01 Feb 2021 04:37:50 -0500
X-MC-Unique: qw0GA7GtN3iedkUIXjqX_Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B18AC1005504;
	Mon,  1 Feb 2021 09:37:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 097C96E405;
	Mon,  1 Feb 2021 09:37:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BB2AB4A7C6;
	Mon,  1 Feb 2021 09:37:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10VI9lUM004647 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 31 Jan 2021 13:09:47 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 549EF2026D13; Sun, 31 Jan 2021 18:09:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 503762026D12
	for <dm-devel@redhat.com>; Sun, 31 Jan 2021 18:09:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2471B1875040
	for <dm-devel@redhat.com>; Sun, 31 Jan 2021 18:09:45 +0000 (UTC)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com
	[209.85.208.182]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-564--pkYvSJRNpaZdvdYvaWIOg-1; Sun, 31 Jan 2021 13:09:42 -0500
X-MC-Unique: -pkYvSJRNpaZdvdYvaWIOg-1
Received: by mail-lj1-f182.google.com with SMTP id y14so4133535ljn.8
	for <dm-devel@redhat.com>; Sun, 31 Jan 2021 10:09:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:from:date:message-id:subject:to
	:content-transfer-encoding;
	bh=hMQknbcWkNO20UF1cw6lE0C18O/rjPLmr23R6LbAT8o=;
	b=nP2U352iQAuUUinWsWCgI2TySAS2tsEfn5mjTFkTN3SxZUP8esQ0BP8G+/vLG90+vd
	LdKXWKYxyZD6prthpxIj9N27U8/ak3Y2+gWFIwwkf4szXvPiTIS3Iw0aprgr9Dji7c9x
	cA8Kc9S4WvJIhgGmxQKZqdWpPrSOSeW8a6fbR352rkjtnlURml2K9pWq/HgiQr98PMSn
	BN2CG0WK5t66Ups9LeMTDFmdR9meY6tYYMY54TijnrtC35/CARL+R/hOO7NtmC5Gk52o
	jzzafFN9mICxf7tUwbliEIUXttGxoPQyZVAFSjCVmB7Il1J40rKV/J1xEka95pMD3/uC
	c80g==
X-Gm-Message-State: AOAM532FvtWmuz+lusOEpNKpUXnRvuUgrEjCGT+1fqS+IKueiFJvNEsk
	Yo1G3/L+JbJL9uu6R1yf1Z89ULLsBR+NWbL1jXU/7CQJqFjijw==
X-Google-Smtp-Source: ABdhPJxzoBcU1t85b0e5v9FUe3s+EEnErHTebGj1tE19rtEHqnVWzvYvQxgDPr/FZKDBg7XNaK208+xlFWvnSWKHTD8=
X-Received: by 2002:a2e:b8c7:: with SMTP id s7mr7573934ljp.397.1612116581106; 
	Sun, 31 Jan 2021 10:09:41 -0800 (PST)
MIME-Version: 1.0
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Date: Sun, 31 Jan 2021 19:09:27 +0100
Message-ID: <CAFED-j=gJZSEghHkHp9d-PE1pAe0ghEvW-MOJZ=L+b2pO7qXtA@mail.gmail.com>
To: dm-devel@redhat.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 10VI9lUM004647
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 01 Feb 2021 04:37:41 -0500
Subject: [dm-devel] kcryptd, copy/remove big file, unresponsive system (GUI)
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

SGVsbG8sCgpUZXN0ZWQgd2l0aCA1LjQvNS44LzUuMTEtcmM0IHdpdGggc2FtZSBwcm9ibGVtcyAt
IGFsbCBjb3JlcyAxMDAlIGluIFdBLgoKUGxlYXNlIGNoZWNrIHRoaXM6Cmh0dHBzOi8vbGF1bmNo
cGFkbGlicmFyaWFuLm5ldC81MjAxOTI0MTIvNS44X2tlcm5lbF8yMDIxLTAxLTI5JTIwMTMtNDQt
MzUucG5nCgpudm1lMG4xIDI1OTowIDAgNDY1LDhHIDAgZGlzawrilJzilIBudm1lMG4xcDEgMjU5
OjEgMCA1MTJNIDAgcGFydCAvYm9vdC9lZmkK4pSc4pSAbnZtZTBuMXAyIDI1OToyIDAgNzMyTSAw
IHBhcnQgL2Jvb3QK4pSU4pSAbnZtZTBuMXAzIDI1OTozIDAgNDY0LDZHIDAgcGFydAogIOKUlOKU
gG52bWUwbjFwM19jcnlwdCAyNTM6MCAwIDQ2NCw2RyAwIGNyeXB0CiAgICDilJzilIB1YnVudHUt
LXZnLXJvb3QgMjUzOjEgMCA0NjMsNkcgMCBsdm0gLwogICAg4pSU4pSAdWJ1bnR1LS12Zy1zd2Fw
XzEgMjUzOjIgMCA5ODBNIDAgbHZtIFtTV0FQXQoKQW55IGlkZWEgaG93IHRvIHR1bmUvd29ya2Fy
b3VuZCB0aGlzPwpXaGVuIHJlbW92ZS9jb3B5IGJpZyBmaWxlICh+NEdCKSAtIG5vIG9wdGlvbiB0
byB1c2UKZmlyZWZveC90ZWFtcy9zbGFjayAuLi4gZm9yIG1pbnV0ZShzKS4KCkJSCkphbnVzegoK
Ci0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vd3d3
LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==

