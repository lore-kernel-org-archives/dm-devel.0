Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D558AEEB589
	for <dm-devel@archiver.kernel.org>; Sat,  9 Sep 2023 11:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694257784;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=TX0wyM5VXTb9ybbjXU0WRohoDNIPUY2ajwplIEWbNoI=;
	b=ImLkTSAyfe8D2pqGYkLtg0zQP3riAbUmPWJnM9sOWdIydXx0Una8eMzsLtX6r+Zf1B6LNO
	UY13KSBG/trUWD1lXvLuq6XeE6KlsmDePP3swuRErOZVTHz9FfaA0teU0uphHGP8dmhqvF
	LfPcMnfOABM15k8fdw9DReOVAtJ80Cs=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-377-E5vYZTcuPNKxzzlX0ryYng-1; Sat, 09 Sep 2023 07:09:41 -0400
X-MC-Unique: E5vYZTcuPNKxzzlX0ryYng-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2A5DB3C0E218;
	Sat,  9 Sep 2023 11:09:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 21FC4140E967;
	Sat,  9 Sep 2023 11:09:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B55BE1946588;
	Sat,  9 Sep 2023 11:09:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1ADFA1946586
 for <dm-devel@listman.corp.redhat.com>; Sat,  9 Sep 2023 11:09:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C7E7D1121318; Sat,  9 Sep 2023 11:09:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BEAEA1121314
 for <dm-devel@redhat.com>; Sat,  9 Sep 2023 11:09:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9F405181A6E0
 for <dm-devel@redhat.com>; Sat,  9 Sep 2023 11:09:33 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com
 [45.249.212.187]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-675-C_LF4aiWM7SxEoVzyH6STQ-1; Sat, 09 Sep 2023 07:09:30 -0400
X-MC-Unique: C_LF4aiWM7SxEoVzyH6STQ-1
Received: from dggpemm500011.china.huawei.com (unknown [172.30.72.57])
 by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4RjVWR2C0YztRXM;
 Sat,  9 Sep 2023 19:05:23 +0800 (CST)
Received: from [10.174.179.155] (10.174.179.155) by
 dggpemm500011.china.huawei.com (7.185.36.110) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Sat, 9 Sep 2023 19:09:25 +0800
Message-ID: <dbbb7133-9796-6546-e227-5528a1bbd4e9@huawei.com>
Date: Sat, 9 Sep 2023 19:09:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101
 Thunderbird/104.0
To: <dm-devel@redhat.com>
References: <20230810064406.1672148-1-lilingfeng3@huawei.com>
From: Li Lingfeng <lilingfeng3@huawei.com>
In-Reply-To: <20230810064406.1672148-1-lilingfeng3@huawei.com>
X-Originating-IP: [10.174.179.155]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500011.china.huawei.com (7.185.36.110)
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH -next] dm snapshot: record cause of
 invalidating snapshot
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
Cc: yi.zhang@huawei.com, yangerkun@huawei.com, snitzer@kernel.org,
 lilingfeng@huaweicloud.com, linan122@huawei.com, houtao1@huawei.com,
 yukuai3@huawei.com, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huawei.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

RnJpZW5kbHkgcGluZyAuLi4KClRoYW5rcwoK5ZyoIDIwMjMvOC8xMCAxNDo0NCwgTGkgTGluZ2Zl
bmcg5YaZ6YGTOgo+IFRoZSBjYXVzZSBvZiBpbnZhbGlkYXRpbmcgc25hcHNob3Qgd2lsbCBiZSBw
cmludCBpbiBsb2cuIEhvd2V2ZXIsIGlmIHdlCj4gbG9zdCB0aGUgbG9nLCB3ZSB3aWxsIG5ldmVy
IGdldCB0aGUgY2F1c2UuIFdoYXQgd2UgY2FuIGdldCBieSAiZG1zZXR1cAo+IHN0YXR1cyIgaXMg
dGhlIHN0YXRlIG9mICJJbnZhbGlkIiB3aXRob3V0IHRoZSBjYXVzZS4KPgo+IFJlY29yZCBjYXVz
ZSBvZiBpbnZhbGlkYXRpbmcgc25hcHNob3QgaW4gc25hcHNob3QtPnZhbGlkLCBzbyB0aGF0IHdl
IGNhbgo+IHF1ZXJ5IHRoZSBjYXVzZSBieSAiZG1zZXR1cCBzdGF0dXMiLgo+Cj4gU2lnbmVkLW9m
Zi1ieTogTGkgTGluZ2ZlbmcgPGxpbGluZ2ZlbmczQGh1YXdlaS5jb20+Cj4gLS0tCj4gICBkcml2
ZXJzL21kL2RtLXNuYXAuYyB8IDYwICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0t
LS0tLS0tLS0tCj4gICAxIGZpbGUgY2hhbmdlZCwgNDUgaW5zZXJ0aW9ucygrKSwgMTUgZGVsZXRp
b25zKC0pCj4KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9kbS1zbmFwLmMgYi9kcml2ZXJzL21k
L2RtLXNuYXAuYwo+IGluZGV4IDQxNzM1YTI1ZDUwYS4uNDg3ODg0MzFlN2JmIDEwMDY0NAo+IC0t
LSBhL2RyaXZlcnMvbWQvZG0tc25hcC5jCj4gKysrIGIvZHJpdmVycy9tZC9kbS1zbmFwLmMKPiBA
QCAtMzksNiArMzksMjggQEAgc3RhdGljIGNvbnN0IGNoYXIgZG1fc25hcHNob3RfbWVyZ2VfdGFy
Z2V0X25hbWVbXSA9ICJzbmFwc2hvdC1tZXJnZSI7Cj4gICAjZGVmaW5lIERNX1RSQUNLRURfQ0hV
TktfSEFTSCh4KQkoKHVuc2lnbmVkIGxvbmcpKHgpICYgXAo+ICAgCQkJCQkgKERNX1RSQUNLRURf
Q0hVTktfSEFTSF9TSVpFIC0gMSkpCj4gICAKPiArI2RlZmluZSBJTlZBTElEX0NBVVNFX0JJVAkJ
MTYKPiArI2RlZmluZSBETV9TTkFQU0hPVF9WQUxJRChzKQkJKHMtPnZhbGlkICYgXAo+ICsJCQkJ
CSgoMSA8PCBJTlZBTElEX0NBVVNFX0JJVCkgLSAxKSkKPiArI2RlZmluZSBETV9TTkFQU0hPVF9J
TlZBTElEX0NBVVNFKHMpCShzLT52YWxpZCA+PiBJTlZBTElEX0NBVVNFX0JJVCkKPiArI2RlZmlu
ZSBTRVRfSU5WQUxJRF9DQVVTRShzLCBjYXVzZSkJKHMtPnZhbGlkID0gXAo+ICsJCQkJCShETV9T
TkFQU0hPVF9WQUxJRChzKSB8IFwKPiArCQkJCQkoY2F1c2UgPDwgSU5WQUxJRF9DQVVTRV9CSVQp
KSkKPiArCj4gK2VudW0gaW52YWxpZF9jYXVzZSB7Cj4gKwlJTlZBTElEX0JZX01FVEFEQVRBID0g
MSwKPiArCUlOVkFMSURfQllfSEFORE9WRVIgPSAyLAo+ICsJSU5WQUxJRF9CWV9DQUNFTExJTkdf
SEFORE9WRVIgPSAzLAo+ICsJSU5WQUxJRF9CWV9FSU8gPSA0LAo+ICsJSU5WQUxJRF9CWV9FTk9N
RU0gPSA1Cj4gK307Cj4gKwo+ICtjaGFyICpkaXNwbGF5X2ludmFsaWRfY2F1c2VbXSA9IHsiYnkg
TUVUQURBVEEiLAo+ICsJCQkJICJieSBIQU5ET1ZFUiIsCj4gKwkJCQkgImJ5IENBTkNFTExJTkcg
SEFORE9WRVIiLAo+ICsJCQkJICJieSBFSU8iLAo+ICsJCQkJICJieSBFTk9NRU0ifTsKPiArCj4g
ICBzdHJ1Y3QgZG1fZXhjZXB0aW9uX3RhYmxlIHsKPiAgIAl1aW50MzJfdCBoYXNoX21hc2s7Cj4g
ICAJdW5zaWduZWQgaGFzaF9zaGlmdDsKPiBAQCAtMTA1NCw3ICsxMDc2LDcgQEAgc3RhdGljIHZv
aWQgc25hcHNob3RfbWVyZ2VfbmV4dF9jaHVua3Moc3RydWN0IGRtX3NuYXBzaG90ICpzKQo+ICAg
CS8qCj4gICAJICogdmFsaWQgZmxhZyBuZXZlciBjaGFuZ2VzIGR1cmluZyBtZXJnZSwgc28gbm8g
bG9jayByZXF1aXJlZC4KPiAgIAkgKi8KPiAtCWlmICghcy0+dmFsaWQpIHsKPiArCWlmICghRE1f
U05BUFNIT1RfVkFMSUQocykpIHsKPiAgIAkJRE1FUlIoIlNuYXBzaG90IGlzIGludmFsaWQ6IGNh
bid0IG1lcmdlIik7Cj4gICAJCWdvdG8gc2h1dDsKPiAgIAl9Cj4gQEAgLTE0MDMsNiArMTQyNSw3
IEBAIHN0YXRpYyBpbnQgc25hcHNob3RfY3RyKHN0cnVjdCBkbV90YXJnZXQgKnRpLCB1bnNpZ25l
ZCBpbnQgYXJnYywgY2hhciAqKmFyZ3YpCj4gICAJCWdvdG8gYmFkX3JlYWRfbWV0YWRhdGE7Cj4g
ICAJfSBlbHNlIGlmIChyID4gMCkgewo+ICAgCQlzLT52YWxpZCA9IDA7Cj4gKwkJU0VUX0lOVkFM
SURfQ0FVU0UocywgSU5WQUxJRF9CWV9NRVRBREFUQSk7Cj4gICAJCURNV0FSTigiU25hcHNob3Qg
aXMgbWFya2VkIGludmFsaWQuIik7Cj4gICAJfQo+ICAgCj4gQEAgLTE0ODAsNiArMTUwMyw3IEBA
IHN0YXRpYyB2b2lkIF9faGFuZG92ZXJfZXhjZXB0aW9ucyhzdHJ1Y3QgZG1fc25hcHNob3QgKnNu
YXBfc3JjLAo+ICAgCSAqIFNldCBzb3VyY2UgaW52YWxpZCB0byBlbnN1cmUgaXQgcmVjZWl2ZXMg
bm8gZnVydGhlciBJL08uCj4gICAJICovCj4gICAJc25hcF9zcmMtPnZhbGlkID0gMDsKPiArCVNF
VF9JTlZBTElEX0NBVVNFKHNuYXBfc3JjLCBJTlZBTElEX0JZX0hBTkRPVkVSKTsKPiAgIH0KPiAg
IAo+ICAgc3RhdGljIHZvaWQgc25hcHNob3RfZHRyKHN0cnVjdCBkbV90YXJnZXQgKnRpKQo+IEBA
IC0xNDk2LDYgKzE1MjAsNyBAQCBzdGF0aWMgdm9pZCBzbmFwc2hvdF9kdHIoc3RydWN0IGRtX3Rh
cmdldCAqdGkpCj4gICAJaWYgKHNuYXBfc3JjICYmIHNuYXBfZGVzdCAmJiAocyA9PSBzbmFwX3Ny
YykpIHsKPiAgIAkJZG93bl93cml0ZSgmc25hcF9kZXN0LT5sb2NrKTsKPiAgIAkJc25hcF9kZXN0
LT52YWxpZCA9IDA7Cj4gKwkJU0VUX0lOVkFMSURfQ0FVU0Uoc25hcF9kZXN0LCBJTlZBTElEX0JZ
X0hBTkRPVkVSKTsKPiAgIAkJdXBfd3JpdGUoJnNuYXBfZGVzdC0+bG9jayk7Cj4gICAJCURNRVJS
KCJDYW5jZWxsaW5nIHNuYXBzaG90IGhhbmRvdmVyLiIpOwo+ICAgCX0KPiBAQCAtMTYzNSwxOCAr
MTY2MCwyMSBAQCBzdGF0aWMgdm9pZCBlcnJvcl9iaW9zKHN0cnVjdCBiaW8gKmJpbykKPiAgIAo+
ICAgc3RhdGljIHZvaWQgX19pbnZhbGlkYXRlX3NuYXBzaG90KHN0cnVjdCBkbV9zbmFwc2hvdCAq
cywgaW50IGVycikKPiAgIHsKPiAtCWlmICghcy0+dmFsaWQpCj4gKwlpZiAoIURNX1NOQVBTSE9U
X1ZBTElEKHMpKQo+ICAgCQlyZXR1cm47Cj4gICAKPiAtCWlmIChlcnIgPT0gLUVJTykKPiAtCQlE
TUVSUigiSW52YWxpZGF0aW5nIHNuYXBzaG90OiBFcnJvciByZWFkaW5nL3dyaXRpbmcuIik7Cj4g
LQllbHNlIGlmIChlcnIgPT0gLUVOT01FTSkKPiAtCQlETUVSUigiSW52YWxpZGF0aW5nIHNuYXBz
aG90OiBVbmFibGUgdG8gYWxsb2NhdGUgZXhjZXB0aW9uLiIpOwo+IC0KPiAgIAlpZiAocy0+c3Rv
cmUtPnR5cGUtPmRyb3Bfc25hcHNob3QpCj4gICAJCXMtPnN0b3JlLT50eXBlLT5kcm9wX3NuYXBz
aG90KHMtPnN0b3JlKTsKPiAgIAo+ICAgCXMtPnZhbGlkID0gMDsKPiArCWlmIChlcnIgPT0gLUVJ
Tykgewo+ICsJCVNFVF9JTlZBTElEX0NBVVNFKHMsIElOVkFMSURfQllfRUlPKTsKPiArCQlETUVS
UigiSW52YWxpZGF0aW5nIHNuYXBzaG90OiBFcnJvciByZWFkaW5nL3dyaXRpbmcuIik7Cj4gKwl9
IGVsc2UgaWYgKGVyciA9PSAtRU5PTUVNKSB7Cj4gKwkJU0VUX0lOVkFMSURfQ0FVU0UocywgSU5W
QUxJRF9CWV9FTk9NRU0pOwo+ICsJCURNRVJSKCJJbnZhbGlkYXRpbmcgc25hcHNob3Q6IFVuYWJs
ZSB0byBhbGxvY2F0ZSBleGNlcHRpb24uIik7Cj4gKwl9Cj4gKwo+ICAgCj4gICAJZG1fdGFibGVf
ZXZlbnQocy0+dGktPnRhYmxlKTsKPiAgIH0KPiBAQCAtMTY5Miw3ICsxNzIwLDcgQEAgc3RhdGlj
IHZvaWQgcGVuZGluZ19jb21wbGV0ZSh2b2lkICpjb250ZXh0LCBpbnQgc3VjY2VzcykKPiAgIAo+
ICAgCWRvd25fcmVhZCgmcy0+bG9jayk7Cj4gICAJZG1fZXhjZXB0aW9uX3RhYmxlX2xvY2soJmxv
Y2spOwo+IC0JaWYgKCFzLT52YWxpZCkgewo+ICsJaWYgKCFETV9TTkFQU0hPVF9WQUxJRChzKSkg
ewo+ICAgCQl1cF9yZWFkKCZzLT5sb2NrKTsKPiAgIAkJZnJlZV9jb21wbGV0ZWRfZXhjZXB0aW9u
KGUpOwo+ICAgCQllcnJvciA9IDE7Cj4gQEAgLTE5ODQsNyArMjAxMiw3IEBAIHN0YXRpYyBpbnQg
c25hcHNob3RfbWFwKHN0cnVjdCBkbV90YXJnZXQgKnRpLCBzdHJ1Y3QgYmlvICpiaW8pCj4gICAK
PiAgIAkvKiBGdWxsIHNuYXBzaG90cyBhcmUgbm90IHVzYWJsZSAqLwo+ICAgCS8qIFRvIGdldCBo
ZXJlIHRoZSB0YWJsZSBtdXN0IGJlIGxpdmUgc28gcy0+YWN0aXZlIGlzIGFsd2F5cyBzZXQuICov
Cj4gLQlpZiAoIXMtPnZhbGlkKQo+ICsJaWYgKCFETV9TTkFQU0hPVF9WQUxJRChzKSkKPiAgIAkJ
cmV0dXJuIERNX01BUElPX0tJTEw7Cj4gICAKPiAgIAlpZiAoYmlvX2RhdGFfZGlyKGJpbykgPT0g
V1JJVEUpIHsKPiBAQCAtMTk5NSw3ICsyMDIzLDcgQEAgc3RhdGljIGludCBzbmFwc2hvdF9tYXAo
c3RydWN0IGRtX3RhcmdldCAqdGksIHN0cnVjdCBiaW8gKmJpbykKPiAgIAlkb3duX3JlYWQoJnMt
PmxvY2spOwo+ICAgCWRtX2V4Y2VwdGlvbl90YWJsZV9sb2NrKCZsb2NrKTsKPiAgIAo+IC0JaWYg
KCFzLT52YWxpZCB8fCAodW5saWtlbHkocy0+c25hcHNob3Rfb3ZlcmZsb3dlZCkgJiYKPiArCWlm
ICghRE1fU05BUFNIT1RfVkFMSUQocykgfHwgKHVubGlrZWx5KHMtPnNuYXBzaG90X292ZXJmbG93
ZWQpICYmCj4gICAJICAgIGJpb19kYXRhX2RpcihiaW8pID09IFdSSVRFKSkgewo+ICAgCQlyID0g
RE1fTUFQSU9fS0lMTDsKPiAgIAkJZ290byBvdXRfdW5sb2NrOwo+IEBAIC0yMDY4LDcgKzIwOTYs
NyBAQCBzdGF0aWMgaW50IHNuYXBzaG90X21hcChzdHJ1Y3QgZG1fdGFyZ2V0ICp0aSwgc3RydWN0
IGJpbyAqYmlvKQo+ICAgCQkJCWRvd25fd3JpdGUoJnMtPmxvY2spOwo+ICAgCj4gICAJCQkJaWYg
KHMtPnN0b3JlLT51c2Vyc3BhY2Vfc3VwcG9ydHNfb3ZlcmZsb3cpIHsKPiAtCQkJCQlpZiAocy0+
dmFsaWQgJiYgIXMtPnNuYXBzaG90X292ZXJmbG93ZWQpIHsKPiArCQkJCQlpZiAoRE1fU05BUFNI
T1RfVkFMSUQocykgJiYgIXMtPnNuYXBzaG90X292ZXJmbG93ZWQpIHsKPiAgIAkJCQkJCXMtPnNu
YXBzaG90X292ZXJmbG93ZWQgPSAxOwo+ICAgCQkJCQkJRE1FUlIoIlNuYXBzaG90IG92ZXJmbG93
ZWQ6IFVuYWJsZSB0byBhbGxvY2F0ZSBleGNlcHRpb24uIik7Cj4gICAJCQkJCX0KPiBAQCAtMjE1
OSw3ICsyMTg3LDcgQEAgc3RhdGljIGludCBzbmFwc2hvdF9tZXJnZV9tYXAoc3RydWN0IGRtX3Rh
cmdldCAqdGksIHN0cnVjdCBiaW8gKmJpbykKPiAgIAlkb3duX3dyaXRlKCZzLT5sb2NrKTsKPiAg
IAo+ICAgCS8qIEZ1bGwgbWVyZ2luZyBzbmFwc2hvdHMgYXJlIHJlZGlyZWN0ZWQgdG8gdGhlIG9y
aWdpbiAqLwo+IC0JaWYgKCFzLT52YWxpZCkKPiArCWlmICghRE1fU05BUFNIT1RfVkFMSUQocykp
Cj4gICAJCWdvdG8gcmVkaXJlY3RfdG9fb3JpZ2luOwo+ICAgCj4gICAJLyogSWYgdGhlIGJsb2Nr
IGlzIGFscmVhZHkgcmVtYXBwZWQgLSB1c2UgdGhhdCAqLwo+IEBAIC0yMzQ0LDggKzIzNzIsMTAg
QEAgc3RhdGljIHZvaWQgc25hcHNob3Rfc3RhdHVzKHN0cnVjdCBkbV90YXJnZXQgKnRpLCBzdGF0
dXNfdHlwZV90IHR5cGUsCj4gICAKPiAgIAkJZG93bl93cml0ZSgmc25hcC0+bG9jayk7Cj4gICAK
PiAtCQlpZiAoIXNuYXAtPnZhbGlkKQo+IC0JCQlETUVNSVQoIkludmFsaWQiKTsKPiArCQlpZiAo
IURNX1NOQVBTSE9UX1ZBTElEKHNuYXApKQo+ICsJCQlETUVNSVQoIkludmFsaWQgJXMiLCBETV9T
TkFQU0hPVF9JTlZBTElEX0NBVVNFKHNuYXApID8KPiArCQkJCQlkaXNwbGF5X2ludmFsaWRfY2F1
c2VbRE1fU05BUFNIT1RfSU5WQUxJRF9DQVVTRShzbmFwKSAtIDFdIDoKPiArCQkJCQkiIik7Cj4g
ICAJCWVsc2UgaWYgKHNuYXAtPm1lcmdlX2ZhaWxlZCkKPiAgIAkJCURNRU1JVCgiTWVyZ2UgZmFp
bGVkIik7Cj4gICAJCWVsc2UgaWYgKHNuYXAtPnNuYXBzaG90X292ZXJmbG93ZWQpCj4gQEAgLTI0
NzcsNyArMjUwNyw3IEBAIHN0YXRpYyBpbnQgX19vcmlnaW5fd3JpdGUoc3RydWN0IGxpc3RfaGVh
ZCAqc25hcHNob3RzLCBzZWN0b3JfdCBzZWN0b3IsCj4gICAJCWRtX2V4Y2VwdGlvbl90YWJsZV9s
b2NrKCZsb2NrKTsKPiAgIAo+ICAgCQkvKiBPbmx5IGRlYWwgd2l0aCB2YWxpZCBhbmQgYWN0aXZl
IHNuYXBzaG90cyAqLwo+IC0JCWlmICghc25hcC0+dmFsaWQgfHwgIXNuYXAtPmFjdGl2ZSkKPiAr
CQlpZiAoIURNX1NOQVBTSE9UX1ZBTElEKHNuYXApIHx8ICFzbmFwLT5hY3RpdmUpCj4gICAJCQln
b3RvIG5leHRfc25hcHNob3Q7Cj4gICAKPiAgIAkJcGUgPSBfX2xvb2t1cF9wZW5kaW5nX2V4Y2Vw
dGlvbihzbmFwLCBjaHVuayk7CgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVk
aGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRl
dmVsCg==

