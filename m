Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33F69C433EF
	for <dm-devel@archiver.kernel.org>; Sat, 27 Nov 2021 10:20:38 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-382-FN4aBraaOouyDtU0otAVZw-1; Sat, 27 Nov 2021 05:20:36 -0500
X-MC-Unique: FN4aBraaOouyDtU0otAVZw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 36B561006AA2;
	Sat, 27 Nov 2021 10:20:31 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 32AFB5D6B1;
	Sat, 27 Nov 2021 10:20:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A762F1809C89;
	Sat, 27 Nov 2021 10:20:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ARAGCBl010311 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 27 Nov 2021 05:16:12 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2BF43404727A; Sat, 27 Nov 2021 10:16:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 27B824047272
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 10:16:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0CB9C85A5B5
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 10:16:12 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com
	[45.249.212.187]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-80-UPd0mEijN4eWrgo67TpqtQ-1; Sat, 27 Nov 2021 05:16:07 -0500
X-MC-Unique: UPd0mEijN4eWrgo67TpqtQ-1
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4J1SDr4NCvzcbH3;
	Sat, 27 Nov 2021 18:15:56 +0800 (CST)
Received: from kwepemm600010.china.huawei.com (7.193.23.86) by
	dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2308.20; Sat, 27 Nov 2021 18:16:00 +0800
Received: from [10.174.179.176] (10.174.179.176) by
	kwepemm600010.china.huawei.com (7.193.23.86) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2308.20; Sat, 27 Nov 2021 18:15:59 +0800
From: lixiaokeng <lixiaokeng@huawei.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski
	<bmarzins@redhat.com>, Martin Wilck <mwilck@suse.com>,
	dm-devel mailing list <dm-devel@redhat.com>
Message-ID: <bfa69895-5b9e-5fe6-e5a0-78be2ee93163@huawei.com>
Date: Sat, 27 Nov 2021 18:15:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
X-Originating-IP: [10.174.179.176]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
	kwepemm600010.china.huawei.com (7.193.23.86)
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ARAGCBl010311
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>,
	"liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>
Subject: [dm-devel] [PATCH] libmultipath: clear removed path from mpp
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-GB
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

bXVsdGlwYXRoZFszNTI1NjM1XTogPT0zNTI1NjM1PT1FUlJPUjogQWRkcmVzc1Nhbml0aXplcjog
aGVhcC11c2UtYWZ0ZXItZnJlZSBvbiBhZGRyZXNzIDB4ZmZmZmE0OTAyZmMwIGF0IHBjIDB4ZmZm
ZmFjN2Q1Yjg4IGJwIDB4ZmZmZmE5NDhkYWMwIHNwIDB4ZmZmZmE5NDhkYWUwCm11bHRpcGF0aGRb
MzUyNTYzNV06IFJFQUQgb2Ygc2l6ZSA4IGF0IDB4ZmZmZmE0OTAyZmMwIHRocmVhZCBUNwptdWx0
aXBhdGhkWzM1MjU2MzVdOiAgICAjMCAweGZmZmZhYzdkNWI4NyBpbiBmcmVlX211bHRpcGF0aCAo
L3Vzci9saWI2NC9saWJtdWx0aXBhdGguc28uMCsweDRiYjg3KQptdWx0aXBhdGhkWzM1MjU2MzVd
OiAgICAjMSAweGFhYWFkNmNmNzA1NyAgKC91c3Ivc2Jpbi9tdWx0aXBhdGhkKzB4MTcwNTcpCm11
bHRpcGF0aGRbMzUyNTYzNV06ICAgICMyIDB4YWFhYWQ2Y2Y3OGViICAoL3Vzci9zYmluL211bHRp
cGF0aGQrMHgxNzhlYikKbXVsdGlwYXRoZFszNTI1NjM1XTogICAgIzMgMHhhYWFhZDZjZmY0ZGYg
ICgvdXNyL3NiaW4vbXVsdGlwYXRoZCsweDFmNGRmKQptdWx0aXBhdGhkWzM1MjU2MzVdOiAgICAj
NCAweGFhYWFkNmNmZmZlNyAgKC91c3Ivc2Jpbi9tdWx0aXBhdGhkKzB4MWZmZTcpCm11bHRpcGF0
aGRbMzUyNTYzNV06ICAgICM1IDB4ZmZmZmFjODA3YmUzIGluIHVldmVudF9kaXNwYXRjaCAoL3Vz
ci9saWI2NC9saWJtdWx0aXBhdGguc28uMCsweDdkYmUzKQptdWx0aXBhdGhkWzM1MjU2MzVdOiAg
ICAjNiAweGFhYWFkNmNmNTYzZiAgKC91c3Ivc2Jpbi9tdWx0aXBhdGhkKzB4MTU2M2YpCm11bHRp
cGF0aGRbMzUyNTYzNV06ICAgICM3IDB4ZmZmZmFjNjg3N2FmICAoL3Vzci9saWI2NC9saWJwdGhy
ZWFkLnNvLjArMHg4N2FmKQptdWx0aXBhdGhkWzM1MjU2MzVdOiAgICAjOCAweGZmZmZhYzQ0MTE4
YiAgKC91c3IvbGliNjQvbGliYy5zby42KzB4ZDUxOGIpCm11bHRpcGF0aGRbMzUyNTYzNV06IDB4
ZmZmZmE0OTAyZmMwIGlzIGxvY2F0ZWQgMTM0NCBieXRlcyBpbnNpZGUgb2YgMTQ0MC1ieXRlIHJl
Z2lvbiBbMHhmZmZmYTQ5MDJhODAsMHhmZmZmYTQ5MDMwMjApCm11bHRpcGF0aGRbMzUyNTYzNV06
IGZyZWVkIGJ5IHRocmVhZCBUNyBoZXJlOgptdWx0aXBhdGhkWzM1MjU2MzVdOiAgICAjMCAweGZm
ZmZhYzk3ZDcwMyBpbiBmcmVlICgvdXNyL2xpYjY0L2xpYmFzYW4uc28uNCsweGQwNzAzKQptdWx0
aXBhdGhkWzM1MjU2MzVdOiAgICAjMSAweGZmZmZhYzgyNDgyNyBpbiBvcnBoYW5fcGF0aHMgKC91
c3IvbGliNjQvbGlibXVsdGlwYXRoLnNvLjArMHg5YTgyNykKbXVsdGlwYXRoZFszNTI1NjM1XTog
ICAgIzIgMHhmZmZmYWM4MjRhNDMgaW4gcmVtb3ZlX21hcCAoL3Vzci9saWI2NC9saWJtdWx0aXBh
dGguc28uMCsweDlhYTQzKQptdWx0aXBhdGhkWzM1MjU2MzVdOiAgICAjMyAweGFhYWFkNmNmNzA1
NyAgKC91c3Ivc2Jpbi9tdWx0aXBhdGhkKzB4MTcwNTcpCm11bHRpcGF0aGRbMzUyNTYzNV06ICAg
ICM0IDB4YWFhYWQ2Y2Y3OGViICAoL3Vzci9zYmluL211bHRpcGF0aGQrMHgxNzhlYikKbXVsdGlw
YXRoZFszNTI1NjM1XTogICAgIzUgMHhhYWFhZDZjZmY0ZGYgICgvdXNyL3NiaW4vbXVsdGlwYXRo
ZCsweDFmNGRmKQptdWx0aXBhdGhkWzM1MjU2MzVdOiAgICAjNiAweGFhYWFkNmNmZmZlNyAgKC91
c3Ivc2Jpbi9tdWx0aXBhdGhkKzB4MWZmZTcpCm11bHRpcGF0aGRbMzUyNTYzNV06ICAgICM3IDB4
ZmZmZmFjODA3YmUzIGluIHVldmVudF9kaXNwYXRjaCAoL3Vzci9saWI2NC9saWJtdWx0aXBhdGgu
c28uMCsweDdkYmUzKQptdWx0aXBhdGhkWzM1MjU2MzVdOiAgICAjOCAweGFhYWFkNmNmNTYzZiAg
KC91c3Ivc2Jpbi9tdWx0aXBhdGhkKzB4MTU2M2YpCm11bHRpcGF0aGRbMzUyNTYzNV06ICAgICM5
IDB4ZmZmZmFjNjg3N2FmICAoL3Vzci9saWI2NC9saWJwdGhyZWFkLnNvLjArMHg4N2FmKQptdWx0
aXBhdGhkWzM1MjU2MzVdOiAgICAjMTAgMHhmZmZmYWM0NDExOGIgICgvdXNyL2xpYjY0L2xpYmMu
c28uNisweGQ1MThiKQoKV2hlbiBtcHAgb25seSBoYXMgb25lIHBhdGggYW5kIGxvZyBvdXQgdGhl
IHBhdGgsIHRoZXJlIGlzIGFuIGFzYW4gZXJyb3IuCkluIHJlbW92ZV9tcHAsIHRoZSBwcCBpcyBm
cmVlZCBmaXJzdGx5IGluIG9ycGhhbl9wYXRoIGJ1dCBpcyBhY2Nlc3NlZCwKY2hhbmdlZCBpbiBm
cmVlX211bHRpcGF0aCBsYXRlci4gQmVmb3JlIGZyZWVfcGF0aChwcCksIHRoZSBwcCBzaG91bGQg
YmUKY2xlYXJlZCBmcm9tIHBwLT5tcHAuCgpXaGVuIHBwIGlzIHNldCB0byBSRU1PVkVE77yMIGl0
IHdpbGwgYmUgYW4gb3JwaGFuIHBhdGguIEF0IHRoZSBzYW1lIHRpbWUsCmNsZWFyIGl0IGZyb20g
aXQncyBtYXAuCgpTaWduZWQtb2ZmLWJ5OiBMaXhpYW9rZW5nIDxsaXhpYW9rZW5nQGh1YXdlaS5j
b20+Ci0tLQogbGlibXVsdGlwYXRoL3N0cnVjdHNfdmVjLmMgfCAyMCArKysrKysrKysrKysrKysr
Ky0tLQogbXVsdGlwYXRoZC9tYWluLmMgICAgICAgICAgfCAgOCAtLS0tLS0tLQogMiBmaWxlcyBj
aGFuZ2VkLCAxNyBpbnNlcnRpb25zKCspLCAxMSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9s
aWJtdWx0aXBhdGgvc3RydWN0c192ZWMuYyBiL2xpYm11bHRpcGF0aC9zdHJ1Y3RzX3ZlYy5jCmlu
ZGV4IDg1ZDk3YWMxLi5hYjUzMTFjYyAxMDA2NDQKLS0tIGEvbGlibXVsdGlwYXRoL3N0cnVjdHNf
dmVjLmMKKysrIGIvbGlibXVsdGlwYXRoL3N0cnVjdHNfdmVjLmMKQEAgLTMxOCw3ICszMTgsOSBA
QCB2b2lkIG9ycGhhbl9wYXRocyh2ZWN0b3IgcGF0aHZlYywgc3RydWN0IG11bHRpcGF0aCAqbXBw
LCBjb25zdCBjaGFyICpyZWFzb24pCgogdm9pZCBzZXRfcGF0aF9yZW1vdmVkKHN0cnVjdCBwYXRo
ICpwcCkKIHsKKwlpbnQgaSwgajsKIAlzdHJ1Y3QgbXVsdGlwYXRoICptcHAgPSBwcC0+bXBwOwor
CXN0cnVjdCBwYXRoZ3JvdXAgKiBwZ3A7CgogCW9ycGhhbl9wYXRoKHBwLCAicmVtb3ZlZCIpOwog
CS8qCkBAIC0zMjksNiArMzMxLDIwIEBAIHZvaWQgc2V0X3BhdGhfcmVtb3ZlZChzdHJ1Y3QgcGF0
aCAqcHApCiAJCWNvbmRsb2coMCwgIiVzOiBpbnRlcm5hbCBlcnJvcjogbXBwID09IE5VTEwiLCBw
cC0+ZGV2KTsKIAkJcmV0dXJuOwogCX0KKworCS8qCisJICogVGhlIHBhdGggaXMgcmVtb3ZlZCwg
Y2xlYXIgaXQgZnJvbSBtcC0+cGF0aHMgYW5kIG1wcC0+cGdzLgorCSAqLworCWkgPSBmaW5kX3Ns
b3QobXBwLT5wYXRocywgcHApOworCWlmIChpICE9IC0xKQorCQl2ZWN0b3JfZGVsX3Nsb3QobXBw
LT5wYXRocywgaSk7CisKKwl2ZWN0b3JfZm9yZWFjaF9zbG90KG1wcC0+cGcsIHBncCwgaikgewor
CQlpID0gZmluZF9zbG90KHBncC0+cGF0aHMsICh2b2lkICopcHApOworCQlpZiAoaSAhPSAtMSkK
KwkJCXZlY3Rvcl9kZWxfc2xvdChwZ3AtPnBhdGhzLCBpKTsKKwl9CisKIAlwcC0+bXBwID0gbXBw
OwogCXBwLT5pbml0aWFsaXplZCA9IElOSVRfUkVNT1ZFRDsKIH0KQEAgLTczMSwxNSArNzQ3LDEz
IEBAIGludCB2ZXJpZnlfcGF0aHMoc3RydWN0IG11bHRpcGF0aCAqbXBwKQogCQkJCQltcHAtPmFs
aWFzLCBwcC0+ZGV2KTsKIAkJCX0KIAkJCWNvdW50Kys7Ci0JCQl2ZWN0b3JfZGVsX3Nsb3QobXBw
LT5wYXRocywgaSk7Ci0JCQlpLS07Ci0KIAkJCS8qCiAJCQkgKiBEb24ndCBkZWxldGUgcGF0aCBm
cm9tIHBhdGh2ZWMgeWV0LiBXZSdsbCBkbyB0aGlzCiAJCQkgKiBhZnRlciB0aGUgcGF0aCBoYXMg
YmVlbiByZW1vdmVkIGZyb20gdGhlIG1hcCwgaW4KIAkJCSAqIHN5bmNfcGF0aHMoKS4KIAkJCSAq
LwogCQkJc2V0X3BhdGhfcmVtb3ZlZChwcCk7CisJCQlpLS07CiAJCX0gZWxzZSB7CiAJCQljb25k
bG9nKDQsICIlczogdmVyaWZpZWQgcGF0aCAlcyBkZXZfdCAlcyIsCiAJCQkJbXBwLT5hbGlhcywg
cHAtPmRldiwgcHAtPmRldl90KTsKZGlmZiAtLWdpdCBhL211bHRpcGF0aGQvbWFpbi5jIGIvbXVs
dGlwYXRoZC9tYWluLmMKaW5kZXggM2Y2NzUxMzYuLjM4ODIwN2EyIDEwMDY0NAotLS0gYS9tdWx0
aXBhdGhkL21haW4uYworKysgYi9tdWx0aXBhdGhkL21haW4uYwpAQCAtMTIyNiwxNCArMTIyNiw2
IEBAIGV2X3JlbW92ZV9wYXRoIChzdHJ1Y3QgcGF0aCAqcHAsIHN0cnVjdCB2ZWN0b3JzICogdmVj
cywgaW50IG5lZWRfZG9fbWFwKQogCQkJZ290byBmYWlsOwogCQl9CgotCQkvKgotCQkgKiB3ZSBo
YXZlIHRvIGV4cGxpY2l0bHkgcmVtb3ZlIHBwIGZyb20gbXBwLT5wYXRocywKLQkJICogdXBkYXRl
X21wcF9wYXRocygpIGRvZXNuJ3QgZG8gdGhhdC4KLQkJICovCi0JCWkgPSBmaW5kX3Nsb3QobXBw
LT5wYXRocywgcHApOwotCQlpZiAoaSAhPSAtMSkKLQkJCXZlY3Rvcl9kZWxfc2xvdChtcHAtPnBh
dGhzLCBpKTsKLQogCQkvKgogCQkgKiByZW1vdmUgdGhlIG1hcCBJRiByZW1vdmluZyB0aGUgbGFz
dCBwYXRoCiAJCSAqLwotLSAKCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVk
aGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRl
dmVs

