Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6619C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 10 Jan 2022 23:33:11 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-368-wC08Oqf_OIifm841nz_93Q-1; Mon, 10 Jan 2022 18:33:07 -0500
X-MC-Unique: wC08Oqf_OIifm841nz_93Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2FF4F2F45;
	Mon, 10 Jan 2022 23:33:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CB17555F7F;
	Mon, 10 Jan 2022 23:33:00 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BE2714BB7C;
	Mon, 10 Jan 2022 23:32:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20ANWtWN023214 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 10 Jan 2022 18:32:56 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id ADBEF1402407; Mon, 10 Jan 2022 23:32:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A913C1402400
	for <dm-devel@redhat.com>; Mon, 10 Jan 2022 23:32:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8F0A51064E69
	for <dm-devel@redhat.com>; Mon, 10 Jan 2022 23:32:55 +0000 (UTC)
Received: from rere.qmqm.pl (rere.qmqm.pl [91.227.64.183]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-518-3HDE09eMOuCKivYYAlaXsw-1; Mon, 10 Jan 2022 18:32:52 -0500
X-MC-Unique: 3HDE09eMOuCKivYYAlaXsw-1
Received: from remote.user (localhost [127.0.0.1])
	by rere.qmqm.pl (Postfix) with ESMTPSA id 4JXqg83mb5zTV;
	Tue, 11 Jan 2022 00:25:08 +0100 (CET)
X-Virus-Status: Clean
X-Virus-Scanned: clamav-milter 0.103.4 at mail
Date: Tue, 11 Jan 2022 00:25:08 +0100
Message-Id: <21a208d4b72f04a75cc5f4a81e3402dd13fadad7.1641857023.git.mirq-linux@rere.qmqm.pl>
In-Reply-To: <87ddcac4c4e017a42e20dbbfcb8343468a0efc12.1641857023.git.mirq-linux@rere.qmqm.pl>
References: <87ddcac4c4e017a42e20dbbfcb8343468a0efc12.1641857023.git.mirq-linux@rere.qmqm.pl>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 20ANWtWN023214
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: [dm-devel] [PATCH 2/2] dm integrity: mark workqueues with device
	they belong to
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

QWRkIGRldmljZSBuYW1lIHRvIHdvcmtxdWV1ZSBuYW1lcyB0byBoZWxwIGRlYnVnZ2luZyBDUFUg
dXNhZ2UgcGVyCmRldmljZSBtYXBwZXIgdGFyZ2V0LgoKU2lnbmVkLW9mZi1ieTogTWljaGHFgiBN
aXJvc8WCYXcgPG1pcnEtbGludXhAcmVyZS5xbXFtLnBsPgotLS0KIGRyaXZlcnMvbWQvZG0taW50
ZWdyaXR5LmMgfCAxNyArKysrKysrKystLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDkgaW5zZXJ0
aW9ucygrKSwgOCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL21kL2RtLWludGVn
cml0eS5jIGIvZHJpdmVycy9tZC9kbS1pbnRlZ3JpdHkuYwppbmRleCA2ZGM5YWViZjg0ODcuLmNk
NjA0ODg5MzhlYSAxMDA2NDQKLS0tIGEvZHJpdmVycy9tZC9kbS1pbnRlZ3JpdHkuYworKysgYi9k
cml2ZXJzL21kL2RtLWludGVncml0eS5jCkBAIC0zOTU4LDYgKzM5NTgsNyBAQCBzdGF0aWMgaW50
IGNyZWF0ZV9qb3VybmFsKHN0cnVjdCBkbV9pbnRlZ3JpdHlfYyAqaWMsIGNoYXIgKiplcnJvcikK
ICAqLwogc3RhdGljIGludCBkbV9pbnRlZ3JpdHlfY3RyKHN0cnVjdCBkbV90YXJnZXQgKnRpLCB1
bnNpZ25lZCBhcmdjLCBjaGFyICoqYXJndikKIHsKKwljb25zdCBjaGFyICpkZXZuYW1lID0gZG1f
dGFibGVfZGV2aWNlX25hbWUodGktPnRhYmxlKTsKIAlzdHJ1Y3QgZG1faW50ZWdyaXR5X2MgKmlj
OwogCWNoYXIgZHVtbXk7CiAJaW50IHI7CkBAIC00MjAwLDggKzQyMDEsOCBAQCBzdGF0aWMgaW50
IGRtX2ludGVncml0eV9jdHIoc3RydWN0IGRtX3RhcmdldCAqdGksIHVuc2lnbmVkIGFyZ2MsIGNo
YXIgKiphcmd2KQogCQlnb3RvIGJhZDsKIAl9CiAKLQlpYy0+bWV0YWRhdGFfd3EgPSBhbGxvY193
b3JrcXVldWUoImRtLWludGVncml0eS1tZXRhZGF0YSIsCi0JCQkJCSAgV1FfTUVNX1JFQ0xBSU0s
IE1FVEFEQVRBX1dPUktRVUVVRV9NQVhfQUNUSVZFKTsKKwlpYy0+bWV0YWRhdGFfd3EgPSBhbGxv
Y193b3JrcXVldWUoImRtLWludGVncml0eS1tZXRhZGF0YS8lcyIsIFdRX01FTV9SRUNMQUlNLAor
CQkJCQkgIE1FVEFEQVRBX1dPUktRVUVVRV9NQVhfQUNUSVZFLCBkZXZuYW1lKTsKIAlpZiAoIWlj
LT5tZXRhZGF0YV93cSkgewogCQl0aS0+ZXJyb3IgPSAiQ2Fubm90IGFsbG9jYXRlIHdvcmtxdWV1
ZSI7CiAJCXIgPSAtRU5PTUVNOwpAQCAtNDIxMiwyMiArNDIxMywyMiBAQCBzdGF0aWMgaW50IGRt
X2ludGVncml0eV9jdHIoc3RydWN0IGRtX3RhcmdldCAqdGksIHVuc2lnbmVkIGFyZ2MsIGNoYXIg
Kiphcmd2KQogCSAqIElmIHRoaXMgd29ya3F1ZXVlIHdlcmUgcGVyY3B1LCBpdCB3b3VsZCBjYXVz
ZSBiaW8gcmVvcmRlcmluZwogCSAqIGFuZCByZWR1Y2VkIHBlcmZvcm1hbmNlLgogCSAqLwotCWlj
LT53YWl0X3dxID0gYWxsb2Nfb3JkZXJlZF93b3JrcXVldWUoImRtLWludGVncml0eS13YWl0Iiwg
V1FfTUVNX1JFQ0xBSU0pOworCWljLT53YWl0X3dxID0gYWxsb2Nfb3JkZXJlZF93b3JrcXVldWUo
ImRtLWludGVncml0eS13YWl0LyVzIiwgV1FfTUVNX1JFQ0xBSU0sIGRldm5hbWUpOwogCWlmICgh
aWMtPndhaXRfd3EpIHsKIAkJdGktPmVycm9yID0gIkNhbm5vdCBhbGxvY2F0ZSB3b3JrcXVldWUi
OwogCQlyID0gLUVOT01FTTsKIAkJZ290byBiYWQ7CiAJfQogCi0JaWMtPm9mZmxvYWRfd3EgPSBh
bGxvY193b3JrcXVldWUoImRtLWludGVncml0eS1vZmZsb2FkIiwgV1FfTUVNX1JFQ0xBSU0sCi0J
CQkJCSAgTUVUQURBVEFfV09SS1FVRVVFX01BWF9BQ1RJVkUpOworCWljLT5vZmZsb2FkX3dxID0g
YWxsb2Nfd29ya3F1ZXVlKCJkbS1pbnRlZ3JpdHktb2ZmbG9hZC8lcyIsIFdRX01FTV9SRUNMQUlN
LAorCQkJCQkgIE1FVEFEQVRBX1dPUktRVUVVRV9NQVhfQUNUSVZFLCBkZXZuYW1lKTsKIAlpZiAo
IWljLT5vZmZsb2FkX3dxKSB7CiAJCXRpLT5lcnJvciA9ICJDYW5ub3QgYWxsb2NhdGUgd29ya3F1
ZXVlIjsKIAkJciA9IC1FTk9NRU07CiAJCWdvdG8gYmFkOwogCX0KIAotCWljLT5jb21taXRfd3Eg
PSBhbGxvY193b3JrcXVldWUoImRtLWludGVncml0eS1jb21taXQiLCBXUV9NRU1fUkVDTEFJTSwg
MSk7CisJaWMtPmNvbW1pdF93cSA9IGFsbG9jX3dvcmtxdWV1ZSgiZG0taW50ZWdyaXR5LWNvbW1p
dC8lcyIsIFdRX01FTV9SRUNMQUlNLCAxLCBkZXZuYW1lKTsKIAlpZiAoIWljLT5jb21taXRfd3Ep
IHsKIAkJdGktPmVycm9yID0gIkNhbm5vdCBhbGxvY2F0ZSB3b3JrcXVldWUiOwogCQlyID0gLUVO
T01FTTsKQEAgLTQyMzYsNyArNDIzNyw3IEBAIHN0YXRpYyBpbnQgZG1faW50ZWdyaXR5X2N0cihz
dHJ1Y3QgZG1fdGFyZ2V0ICp0aSwgdW5zaWduZWQgYXJnYywgY2hhciAqKmFyZ3YpCiAJSU5JVF9X
T1JLKCZpYy0+Y29tbWl0X3dvcmssIGludGVncml0eV9jb21taXQpOwogCiAJaWYgKGljLT5tb2Rl
ID09ICdKJyB8fCBpYy0+bW9kZSA9PSAnQicpIHsKLQkJaWMtPndyaXRlcl93cSA9IGFsbG9jX3dv
cmtxdWV1ZSgiZG0taW50ZWdyaXR5LXdyaXRlciIsIFdRX01FTV9SRUNMQUlNLCAxKTsKKwkJaWMt
PndyaXRlcl93cSA9IGFsbG9jX3dvcmtxdWV1ZSgiZG0taW50ZWdyaXR5LXdyaXRlci8lcyIsIFdR
X01FTV9SRUNMQUlNLCAxLCBkZXZuYW1lKTsKIAkJaWYgKCFpYy0+d3JpdGVyX3dxKSB7CiAJCQl0
aS0+ZXJyb3IgPSAiQ2Fubm90IGFsbG9jYXRlIHdvcmtxdWV1ZSI7CiAJCQlyID0gLUVOT01FTTsK
QEAgLTQzOTUsNyArNDM5Niw3IEBAIHN0YXRpYyBpbnQgZG1faW50ZWdyaXR5X2N0cihzdHJ1Y3Qg
ZG1fdGFyZ2V0ICp0aSwgdW5zaWduZWQgYXJnYywgY2hhciAqKmFyZ3YpCiAJfQogCiAJaWYgKGlj
LT5pbnRlcm5hbF9oYXNoKSB7Ci0JCWljLT5yZWNhbGNfd3EgPSBhbGxvY193b3JrcXVldWUoImRt
LWludGVncml0eS1yZWNhbGMiLCBXUV9NRU1fUkVDTEFJTSwgMSk7CisJCWljLT5yZWNhbGNfd3Eg
PSBhbGxvY193b3JrcXVldWUoImRtLWludGVncml0eS1yZWNhbGMvJXMiLCBXUV9NRU1fUkVDTEFJ
TSwgMSwgZGV2bmFtZSk7CiAJCWlmICghaWMtPnJlY2FsY193cSApIHsKIAkJCXRpLT5lcnJvciA9
ICJDYW5ub3QgYWxsb2NhdGUgd29ya3F1ZXVlIjsKIAkJCXIgPSAtRU5PTUVNOwotLSAKMi4zMC4y
CgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9s
aXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==

