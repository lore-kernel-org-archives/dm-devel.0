Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B02BC61DA4
	for <dm-devel@archiver.kernel.org>; Tue, 14 Feb 2023 07:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676360907;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=LKKl/TVXK2FF36Dw7GcnkLygtsEcQ6DmNbxae5S/N3U=;
	b=QTIqf6ET7DFOHcwPDzSIkumQOAAQ8wtWeFcj77Iz2nZEmL0WaoHwFrvvVZ9VZGoiRc2U1l
	87JG2+GK3XcU3b/kP77wg6q8oCyam4II8Xle0i5SRALJH6RxfQ7HGjWqmB1MayZkDyZuu9
	IV+WeyEpItpA7WonTzMfBhA1/xgz6CQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-652-F6SGttQeNi-8yhZlFUyr7g-1; Tue, 14 Feb 2023 02:48:24 -0500
X-MC-Unique: F6SGttQeNi-8yhZlFUyr7g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9CDD129A9CA8;
	Tue, 14 Feb 2023 07:48:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D6541140EBF6;
	Tue, 14 Feb 2023 07:48:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EB05619465BA;
	Tue, 14 Feb 2023 07:48:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0E2061946586
 for <dm-devel@listman.corp.redhat.com>; Tue, 14 Feb 2023 03:29:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D380F492B16; Tue, 14 Feb 2023 03:29:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CCC17492B15
 for <dm-devel@redhat.com>; Tue, 14 Feb 2023 03:29:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B024C1C068C0
 for <dm-devel@redhat.com>; Tue, 14 Feb 2023 03:29:43 +0000 (UTC)
Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-228-CkVMO6PVPby7cJIWWl1kuQ-1; Mon,
 13 Feb 2023 22:29:39 -0500
X-MC-Unique: CkVMO6PVPby7cJIWWl1kuQ-1
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
Date: Tue, 14 Feb 2023 03:20:55 +0000
MIME-Version: 1.0
Message-Id: <20230214-kobj_type-dm-v1-1-f1e0ffee5373@weissschuh.net>
X-B4-Tracking: v=1; b=H4sIABb+6mMC/x2NzQqDMBAGX0X23IUk/hx8lVJKol91rY2StKUiv
 rtLjzMwzE4ZSZCpLXZK+EqWJSrYS0Hd6OMAll6ZnHGlcbbi5xKm+3tbwf2LmwYBFpWpS0OaBJ/
 BIfnYjRrFzzyrXBMe8vs/rrfjOAGEf9SNcwAAAA==
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
 dm-devel@redhat.com
X-Developer-Signature: v=1; a=ed25519-sha256; t=1676344855; l=991;
 i=linux@weissschuh.net; s=20221212; h=from:subject:message-id;
 bh=l509B6JSeU+8vu09VCB2XMYyL5OSKdktVVV0A47CNNk=;
 b=t4RJry/Zs8Bb9v35RfLtQosyNKrTqcuQO9hoT/iSqbm11M1KXOcJVnjg9LN4Mfbo727DRCW5s
 bra94Dw7MyoD9+W42CErMJZLOtZ+dzTyGBA6k8njIZ6+8b9lw4ScigO
X-Developer-Key: i=linux@weissschuh.net; a=ed25519;
 pk=KcycQgFPX2wGR5azS7RhpBqedglOZVgRPfdFSPB1LNw=
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Tue, 14 Feb 2023 07:48:03 +0000
Subject: [dm-devel] [PATCH] dm sysfs: make kobj_type structure constant
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
Cc: linux-kernel@vger.kernel.org,
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

U2luY2UgY29tbWl0IGVlNmQzZGQ0ZWQ0OCAoImRyaXZlciBjb3JlOiBtYWtlIGtvYmpfdHlwZSBj
b25zdGFudC4iKQp0aGUgZHJpdmVyIGNvcmUgYWxsb3dzIHRoZSB1c2FnZSBvZiBjb25zdCBzdHJ1
Y3Qga29ial90eXBlLgoKVGFrZSBhZHZhbnRhZ2Ugb2YgdGhpcyB0byBjb25zdGlmeSB0aGUgc3Ry
dWN0dXJlIGRlZmluaXRpb24gdG8gcHJldmVudAptb2RpZmljYXRpb24gYXQgcnVudGltZS4KClNp
Z25lZC1vZmYtYnk6IFRob21hcyBXZWnDn3NjaHVoIDxsaW51eEB3ZWlzc3NjaHVoLm5ldD4KLS0t
CiBkcml2ZXJzL21kL2RtLXN5c2ZzLmMgfCAyICstCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRp
b24oKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL21kL2RtLXN5c2ZzLmMg
Yi9kcml2ZXJzL21kL2RtLXN5c2ZzLmMKaW5kZXggZTI4YzkyNDc4NTM2Li5kYzI4MTE2MmYxZDQg
MTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbWQvZG0tc3lzZnMuYworKysgYi9kcml2ZXJzL21kL2RtLXN5
c2ZzLmMKQEAgLTExOSw3ICsxMTksNyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IHN5c2ZzX29wcyBk
bV9zeXNmc19vcHMgPSB7CiAJLnN0b3JlCT0gZG1fYXR0cl9zdG9yZSwKIH07CiAKLXN0YXRpYyBz
dHJ1Y3Qga29ial90eXBlIGRtX2t0eXBlID0geworc3RhdGljIGNvbnN0IHN0cnVjdCBrb2JqX3R5
cGUgZG1fa3R5cGUgPSB7CiAJLnN5c2ZzX29wcwk9ICZkbV9zeXNmc19vcHMsCiAJLmRlZmF1bHRf
Z3JvdXBzCT0gZG1fZ3JvdXBzLAogCS5yZWxlYXNlCT0gZG1fa29iamVjdF9yZWxlYXNlLAoKLS0t
CmJhc2UtY29tbWl0OiBmNmZlZWE1NmY2NmQzNDI1OWM0MjIyZmEwMmU4MTcxYzRmMjY3M2QxCmNo
YW5nZS1pZDogMjAyMzAyMTQta29ial90eXBlLWRtLTY2ZWJlMWU0MDUzMAoKQmVzdCByZWdhcmRz
LAotLSAKVGhvbWFzIFdlacOfc2NodWggPGxpbnV4QHdlaXNzc2NodWgubmV0PgoKLS0KZG0tZGV2
ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhh
dC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

