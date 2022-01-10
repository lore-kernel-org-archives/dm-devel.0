Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01D0AC433EF
	for <dm-devel@archiver.kernel.org>; Mon, 10 Jan 2022 23:33:30 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-241-mYZJd8PBOsmOiYZSQTErFw-1; Mon, 10 Jan 2022 18:33:26 -0500
X-MC-Unique: mYZJd8PBOsmOiYZSQTErFw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E68492F25;
	Mon, 10 Jan 2022 23:33:19 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B6AC0108BA;
	Mon, 10 Jan 2022 23:33:19 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 86BDA1809CB8;
	Mon, 10 Jan 2022 23:33:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20ANX0c6023225 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 10 Jan 2022 18:33:00 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A3F982166B40; Mon, 10 Jan 2022 23:33:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9EE612166B2F
	for <dm-devel@redhat.com>; Mon, 10 Jan 2022 23:32:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C39D53806705
	for <dm-devel@redhat.com>; Mon, 10 Jan 2022 23:32:55 +0000 (UTC)
Received: from rere.qmqm.pl (rere.qmqm.pl [91.227.64.183]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-132-O1yt6PSPMnq6uZe8xApBEw-1; Mon, 10 Jan 2022 18:32:52 -0500
X-MC-Unique: O1yt6PSPMnq6uZe8xApBEw-1
Received: from remote.user (localhost [127.0.0.1])
	by rere.qmqm.pl (Postfix) with ESMTPSA id 4JXqg80kSzzFc;
	Tue, 11 Jan 2022 00:25:08 +0100 (CET)
X-Virus-Status: Clean
X-Virus-Scanned: clamav-milter 0.103.4 at mail
Date: Tue, 11 Jan 2022 00:25:06 +0100
Message-Id: <87ddcac4c4e017a42e20dbbfcb8343468a0efc12.1641857023.git.mirq-linux@rere.qmqm.pl>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 20ANX0c6023225
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: [dm-devel] [PATCH 1/2] dm integrity: use alloc_ordered_workqueue()
 for dm-integrity-wait
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

TWFrZSB0aGUgcmVxdWlyZW1lbnQgZm9yIG9yZGVyaW5nIG9mIGRtLWludGVncml0eS13YWl0IHdv
cmsKZXhwbGljaXQuICBObyBiZWhhdmlvdXIgY2hhbmdlIGJlY2F1c2Ugb2YgY29tbWl0IDVjMDMz
OGM2ODcwNgooIndvcmtxdWV1ZTogcmVzdG9yZSBXUV9VTkJPVU5EL21heF9hY3RpdmU9PTEgdG8g
YmUgb3JkZXJlZCIpLgoKU2lnbmVkLW9mZi1ieTogTWljaGHFgiBNaXJvc8WCYXcgPG1pcnEtbGlu
dXhAcmVyZS5xbXFtLnBsPgotLS0KIGRyaXZlcnMvbWQvZG0taW50ZWdyaXR5LmMgfCAyICstCiAx
IGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQg
YS9kcml2ZXJzL21kL2RtLWludGVncml0eS5jIGIvZHJpdmVycy9tZC9kbS1pbnRlZ3JpdHkuYwpp
bmRleCA3YWYyNDJkZTMyMDIuLjZkYzlhZWJmODQ4NyAxMDA2NDQKLS0tIGEvZHJpdmVycy9tZC9k
bS1pbnRlZ3JpdHkuYworKysgYi9kcml2ZXJzL21kL2RtLWludGVncml0eS5jCkBAIC00MjEyLDcg
KzQyMTIsNyBAQCBzdGF0aWMgaW50IGRtX2ludGVncml0eV9jdHIoc3RydWN0IGRtX3RhcmdldCAq
dGksIHVuc2lnbmVkIGFyZ2MsIGNoYXIgKiphcmd2KQogCSAqIElmIHRoaXMgd29ya3F1ZXVlIHdl
cmUgcGVyY3B1LCBpdCB3b3VsZCBjYXVzZSBiaW8gcmVvcmRlcmluZwogCSAqIGFuZCByZWR1Y2Vk
IHBlcmZvcm1hbmNlLgogCSAqLwotCWljLT53YWl0X3dxID0gYWxsb2Nfd29ya3F1ZXVlKCJkbS1p
bnRlZ3JpdHktd2FpdCIsIFdRX01FTV9SRUNMQUlNIHwgV1FfVU5CT1VORCwgMSk7CisJaWMtPndh
aXRfd3EgPSBhbGxvY19vcmRlcmVkX3dvcmtxdWV1ZSgiZG0taW50ZWdyaXR5LXdhaXQiLCBXUV9N
RU1fUkVDTEFJTSk7CiAJaWYgKCFpYy0+d2FpdF93cSkgewogCQl0aS0+ZXJyb3IgPSAiQ2Fubm90
IGFsbG9jYXRlIHdvcmtxdWV1ZSI7CiAJCXIgPSAtRU5PTUVNOwotLSAKMi4zMC4yCgoKLS0KZG0t
ZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJl
ZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==

