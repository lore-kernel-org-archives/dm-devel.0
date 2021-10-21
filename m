Return-Path: <SRS0=XsJU=PJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA43EC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 21 Oct 2021 21:24:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F04E26128E
	for <dm-devel@archiver.kernel.org>; Thu, 21 Oct 2021 21:24:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org F04E26128E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=rere.qmqm.pl
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-a-L8tefdMjStmDeOcIPVpg-1; Thu, 21 Oct 2021 17:24:34 -0400
X-MC-Unique: a-L8tefdMjStmDeOcIPVpg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 747311006AA2;
	Thu, 21 Oct 2021 21:24:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2A91D196AE;
	Thu, 21 Oct 2021 21:24:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1DF9D1800FDD;
	Thu, 21 Oct 2021 21:24:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19LLKBcr003724 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 21 Oct 2021 17:20:12 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id B06B540CFD11; Thu, 21 Oct 2021 21:20:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AA93E40CFD08
	for <dm-devel@redhat.com>; Thu, 21 Oct 2021 21:20:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 92427106655B
	for <dm-devel@redhat.com>; Thu, 21 Oct 2021 21:20:11 +0000 (UTC)
Received: from rere.qmqm.pl (rere.qmqm.pl [91.227.64.183]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-424-3wn1DdIgMaWpy1E6uJ4S1A-1;
	Thu, 21 Oct 2021 17:20:09 -0400
X-MC-Unique: 3wn1DdIgMaWpy1E6uJ4S1A-1
Received: from remote.user (localhost [127.0.0.1])
	by rere.qmqm.pl (Postfix) with ESMTPSA id 4Hb0ZZ6NJmz6R;
	Thu, 21 Oct 2021 23:13:26 +0200 (CEST)
X-Virus-Status: Clean
X-Virus-Scanned: clamav-milter 0.103.3 at mail
Date: Thu, 21 Oct 2021 23:13:25 +0200
Message-Id: <cf80c4bae90f587cac975d69905f6dc7642a05e3.1634850725.git.mirq-linux@rere.qmqm.pl>
From: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
MIME-Version: 1.0
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 19LLKBcr003724
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: [dm-devel] [PATCH] dm: make workqueue names device-specific
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

QWRkIGRldmljZSBudW1iZXIgdG8ga2RtZmx1c2ggd29ya3F1ZXVlIG5hbWUgdG8gaGVscCBkZWJ1
Z2dpbmcgQ1BVIHVzYWdlLgoKUmVzdWx0aW5nIGBwcyBheGZ1YCBzbmlwcGV0OgoKcm9vdCAgICAg
ICAgMzc5MSAgMC4wICAwLjAgICAgICAwICAgICAwID8gICAgICAgIEk8ICAgcGHFujE5ICAgMDow
MCAgXF8gW2tkbWZsdXNoLzI1Mzo3XQpyb290ICAgICAgICAzNzkyICAwLjAgIDAuMCAgICAgIDAg
ICAgIDAgPyAgICAgICAgSTwgICBwYcW6MTkgICAwOjAwICBcXyBba2NyeXB0ZF9pby8yNTM6N10K
cm9vdCAgICAgICAgMzc5MyAgMC4wICAwLjAgICAgICAwICAgICAwID8gICAgICAgIEk8ICAgcGHF
ujE5ICAgMDowMCAgXF8gW2tjcnlwdGQvMjUzOjddCnJvb3QgICAgICAgIDM3OTQgIDAuMCAgMC4w
ICAgICAgMCAgICAgMCA/ICAgICAgICBTICAgIHBhxboxOSAgIDA6MDAgIFxfIFtkbWNyeXB0X3dy
aXRlLzI1Mzo3XQpyb290ICAgICAgICAzODE0ICAwLjAgIDAuMCAgICAgIDAgICAgIDAgPyAgICAg
ICAgSTwgICBwYcW6MTkgICAwOjAwICBcXyBba2RtZmx1c2gvMjUzOjhdCnJvb3QgICAgICAgIDM4
MTUgIDAuMCAgMC4wICAgICAgMCAgICAgMCA/ICAgICAgICBJPCAgIHBhxboxOSAgIDA6MDAgIFxf
IFtrZG1mbHVzaC8yNTM6OV0Kcm9vdCAgICAgICAgMzgxNiAgMC4wICAwLjAgICAgICAwICAgICAw
ID8gICAgICAgIEk8ICAgcGHFujE5ICAgMDowMCAgXF8gW2tkbWZsdXNoLzI1MzoxMF0KClNpZ25l
ZC1vZmYtYnk6IE1pY2hhxYLCoE1pcm9zxYJhdyA8bWlycS1saW51eEByZXJlLnFtcW0ucGw+ClNp
Z25lZC1vZmYtYnk6IE1pY2hhxYIgTWlyb3PFgmF3IDxtaXJxLWxpbnV4QHJlcmUucW1xbS5wbD4K
LS0tCiBkcml2ZXJzL21kL2RtLmMgfCAyICstCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24o
KyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL21kL2RtLmMgYi9kcml2ZXJz
L21kL2RtLmMKaW5kZXggNzZkOWRhNDlmZGE3Li4zMDgzMGY3MzdhOWMgMTAwNjQ0Ci0tLSBhL2Ry
aXZlcnMvbWQvZG0uYworKysgYi9kcml2ZXJzL21kL2RtLmMKQEAgLTE4MDAsNyArMTgwMCw3IEBA
IHN0YXRpYyBzdHJ1Y3QgbWFwcGVkX2RldmljZSAqYWxsb2NfZGV2KGludCBtaW5vcikKIAogCWZv
cm1hdF9kZXZfdChtZC0+bmFtZSwgTUtERVYoX21ham9yLCBtaW5vcikpOwogCi0JbWQtPndxID0g
YWxsb2Nfd29ya3F1ZXVlKCJrZG1mbHVzaCIsIFdRX01FTV9SRUNMQUlNLCAwKTsKKwltZC0+d3Eg
PSBhbGxvY193b3JrcXVldWUoImtkbWZsdXNoLyVzIiwgV1FfTUVNX1JFQ0xBSU0sIDAsIG1kLT5u
YW1lKTsKIAlpZiAoIW1kLT53cSkKIAkJZ290byBiYWQ7CiAKLS0gCjIuMzAuMgoKCi0tCmRtLWRl
dmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRo
YXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=

