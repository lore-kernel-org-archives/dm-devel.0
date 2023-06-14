Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 231AFEB64DB
	for <dm-devel@archiver.kernel.org>; Wed, 14 Jun 2023 07:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686726425;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=rbKriimm4mtC6KXCQl5m9xlQyBHHTtr239NxNcJPXqk=;
	b=O/efZUpTDj2rbN47aQSc7bFFUSF2tu45j5zP3RC6gSPcPxT5z4n6fF942Qcxj2s+v0emWj
	dleFz69ZGPILyPj176sUYxYJfMbcTZik7A8SaavGS8G4l05q5LyN6zjrcTLvN2x8FPCvqp
	0g6TIoKS9ScIQweD+ujt9lfWANvBpJY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-91-tYYif-BoOO2PSVkZ08rjDw-1; Wed, 14 Jun 2023 03:07:00 -0400
X-MC-Unique: tYYif-BoOO2PSVkZ08rjDw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 66661858282;
	Wed, 14 Jun 2023 07:06:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 123D72166B26;
	Wed, 14 Jun 2023 07:06:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 99FC419452C2;
	Wed, 14 Jun 2023 07:06:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 18086194658C
 for <dm-devel@listman.corp.redhat.com>; Wed, 14 Jun 2023 02:19:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EB5E8141510A; Wed, 14 Jun 2023 02:19:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E3BE01415102
 for <dm-devel@redhat.com>; Wed, 14 Jun 2023 02:19:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 88BEF1C05AB7
 for <dm-devel@redhat.com>; Wed, 14 Jun 2023 02:19:02 +0000 (UTC)
Received: from mail.208.org (183.242.55.162 [183.242.55.162]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-303-HdpT3P2uM8-I57rRcq_YNQ-1; Tue,
 13 Jun 2023 22:17:43 -0400
X-MC-Unique: HdpT3P2uM8-I57rRcq_YNQ-1
Received: from mail.208.org (email.208.org [127.0.0.1])
 by mail.208.org (Postfix) with ESMTP id 4QgpmT6RpfzBJL9v
 for <dm-devel@redhat.com>; Wed, 14 Jun 2023 10:10:33 +0800 (CST)
X-Virus-Scanned: amavisd-new at mail.208.org
Received: from mail.208.org ([127.0.0.1])
 by mail.208.org (mail.208.org [127.0.0.1]) (amavisd-new, port 10026)
 with ESMTP id PN0ESNAmdWUL for <dm-devel@redhat.com>;
 Wed, 14 Jun 2023 10:10:33 +0800 (CST)
Received: from localhost (email.208.org [127.0.0.1])
 by mail.208.org (Postfix) with ESMTPSA id 4QgpmT3xcVzBJL9m;
 Wed, 14 Jun 2023 10:10:33 +0800 (CST)
MIME-Version: 1.0
Date: Wed, 14 Jun 2023 10:10:33 +0800
From: baomingtong001@208suo.com
To: agk <agk@redhat.com>, snitzer <snitzer@kernel.org>, dm-devel
 <dm-devel@redhat.com>
User-Agent: Roundcube Webmail
Message-ID: <202306141008237478337@208suo.com>
X-Sender: baomingtong001@208suo.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Wed, 14 Jun 2023 07:06:43 +0000
Subject: [dm-devel] [PATCH] dm: remove unneeded variable
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
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: 208suo.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

Zml4IHRoZSBmb2xsb3dpbmcgY29jY2ljaGVjayB3YXJuaW5nOgoKCgrCoAoKCgpkcml2ZXJzL21k
L2RtLXNuYXAtcGVyc2lzdGVudC5jOjkwOToxNC0xNjogVW5uZWVkZWQgdmFyaWFibGU6ICJzeiIu
CgoKCsKgCgoKClNpZ25lZC1vZmYtYnk6IE1pbmd0b25nIEJhbyA8YmFvbWluZ3RvbmcwMDFAMjA4
c3VvLmNvbT4KCgoKLS0tCgoKCmRyaXZlcnMvbWQvZG0tc25hcC1wZXJzaXN0ZW50LmMgfCAzICst
LQoKCgoxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDIgZGVsZXRpb25zKC0pCgoKCsKg
CgoKCmRpZmYgLS1naXQgYS9kcml2ZXJzL21kL2RtLXNuYXAtcGVyc2lzdGVudC5jIApiL2RyaXZl
cnMvbWQvZG0tc25hcC1wZXJzaXN0ZW50LmMKCgoKaW5kZXggMTU2NDk5MjFmMmE5Li43ZWEwMWJj
ZWJhNTkgMTAwNjQ0CgoKCi0tLSBhL2RyaXZlcnMvbWQvZG0tc25hcC1wZXJzaXN0ZW50LmMKCgoK
KysrIGIvZHJpdmVycy9tZC9kbS1zbmFwLXBlcnNpc3RlbnQuYwoKCgpAQCAtOTA2LDcgKzkwNiw2
IEBAIHN0YXRpYyB1bnNpZ25lZCBpbnQgcGVyc2lzdGVudF9zdGF0dXMoc3RydWN0IApkbV9leGNl
cHRpb25fc3RvcmUgKnN0b3JlLAoKCgrCoCBzdGF0dXNfdHlwZV90IHN0YXR1cywgY2hhciAqcmVz
dWx0LAoKCgrCoCB1bnNpZ25lZCBpbnQgbWF4bGVuKQoKCgp7CgoKCi0gdW5zaWduZWQgaW50IHN6
ID0gMDsKCgoKc3dpdGNoIChzdGF0dXMpIHsKCgoKY2FzZSBTVEFUVVNUWVBFX0lORk86CgoKCkBA
IC05MjAsNyArOTE5LDcgQEAgc3RhdGljIHVuc2lnbmVkIGludCBwZXJzaXN0ZW50X3N0YXR1cyhz
dHJ1Y3QgCmRtX2V4Y2VwdGlvbl9zdG9yZSAqc3RvcmUsCgoKCmJyZWFrOwoKCgp9CgoKCi0gcmV0
dXJuIHN6OwoKCgorIHJldHVybiAwOwoKCgp9CgoKCnN0YXRpYyBzdHJ1Y3QgZG1fZXhjZXB0aW9u
X3N0b3JlX3R5cGUgX3BlcnNpc3RlbnRfdHlwZSA9IHsKCgoKLS0KCgoKMi40MC4xCgoKCsKgCgoK
LS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0
bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

