Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B972BCCA47F
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jul 2022 14:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657119096;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=yDatVeINzuG81AhoOkBRljNmSxA7K3esv8QIuA+GEy8=;
	b=P3u9EQ2ty6dMXvwtiim0Osc+qaDf2wus0T0uVnjfuqTWXfS07Ft5UswbybzdZZzIjB/uDv
	vsiTc7/+mMBtRNZ68OW2xOgOIPyNQPQO2YbXbLDlF2RWXAtd42VTgLj1/JlWyWwVT+/Jx/
	xNF+tUd9j6pWSMpNAsgBq1zFWkSscYI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-549-Vt1YaX7OO_-0FMRPUyUcng-1; Wed, 06 Jul 2022 10:51:33 -0400
X-MC-Unique: Vt1YaX7OO_-0FMRPUyUcng-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7048785A582;
	Wed,  6 Jul 2022 14:51:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2A95B2166B26;
	Wed,  6 Jul 2022 14:51:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6076C1947071;
	Wed,  6 Jul 2022 14:51:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2334D1947040
 for <dm-devel@listman.corp.redhat.com>; Sun,  3 Jul 2022 06:50:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F014A492CA3; Sun,  3 Jul 2022 06:50:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EC20F492C3B
 for <dm-devel@redhat.com>; Sun,  3 Jul 2022 06:50:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D4D353804516
 for <dm-devel@redhat.com>; Sun,  3 Jul 2022 06:50:25 +0000 (UTC)
Received: from smtp.smtpout.orange.fr (smtp02.smtpout.orange.fr
 [80.12.242.124]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 us-mta-414-tHJQEG8tMuy1uHEh9VtKsg-1; Sun, 03 Jul 2022 02:50:23 -0400
X-MC-Unique: tHJQEG8tMuy1uHEh9VtKsg-1
Received: from [192.168.1.18] ([90.11.190.129]) by smtp.orange.fr with ESMTPA
 id 7tQyovloGEMbD7tQyoi3Jm; Sun, 03 Jul 2022 08:50:22 +0200
X-ME-Helo: [192.168.1.18]
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 03 Jul 2022 08:50:22 +0200
X-ME-IP: 90.11.190.129
Message-ID: <4dc5d50a-2291-1d3a-efac-3f6378a15d69@wanadoo.fr>
Date: Sun, 3 Jul 2022 08:50:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
To: Yury Norov <yury.norov@gmail.com>
Newsgroups: gmane.linux.kernel.janitors, gmane.linux.kernel.device-mapper.devel,
 gmane.linux.kernel
References: <cover.1656785856.git.christophe.jaillet@wanadoo.fr>
 <98f5d3d855a9c687ccc035edf62016b02a6876b7.1656785856.git.christophe.jaillet@wanadoo.fr>
 <YsC0GpltMVaCPhkJ@yury-laptop>
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <YsC0GpltMVaCPhkJ@yury-laptop>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mailman-Approved-At: Wed, 06 Jul 2022 14:51:05 +0000
Subject: Re: [dm-devel] [PATCH 3/4] bitmap: Introduce bitmap_size()
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
Cc: linux-s390@vger.kernel.org, kernel-janitors@vger.kernel.org,
 andriy.shevchenko@linux.intel.com, gor@linux.ibm.com, linux@rasmusvillemoes.dk,
 hca@linux.ibm.com, ntfs3@lists.linux.dev, snitzer@kernel.org,
 oberpar@linux.ibm.com, linux-kernel@vger.kernel.org,
 almaz.alexandrovich@paragon-software.com, dm-devel@redhat.com,
 svens@linux.ibm.com, vneethv@linux.ibm.com, agordeev@linux.ibm.com,
 borntraeger@linux.ibm.com, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

TGUgMDIvMDcvMjAyMiDDoCAyMzowOSwgWXVyeSBOb3JvdiBhIMOpY3JpdMKgOgo+IE9uIFNhdCwg
SnVsIDAyLCAyMDIyIGF0IDA4OjI5OjM2UE0gKzAyMDAsIENocmlzdG9waGUgSkFJTExFVCB3cm90
ZToKPj4gVGhlIG5ldyBiaXRtYXBfc2l6ZSgpIGZ1bmN0aW9uIHJldHVybnMgdGhlIHNpemUsIGlu
IGJ5dGVzLCBvZiBhIGJpdG1hcC4KPj4KPj4gUmVtb3ZlIHRoZSBhbHJlYWR5IGV4aXN0aW5nIGJp
dG1hcF9zaXplKCkgZnVuY3Rpb25zIGFuZCBtYWNybyBpbiBzb21lCj4+IGZpbGVzLgo+PiBUaGVz
ZSBmaWxlcyBhbHJlYWR5IHVzZSB0aGUgYml0bWFwIEFQSSBhbmQgd2lsbCB1c2UgdGhlIG5ldyBm
dW5jdGlvbgo+PiBpbiBiaXRtYXAuaCBhdXRvbWF0aWNhbGx5Lgo+Pgo+PiBTaWduZWQtb2ZmLWJ5
OiBDaHJpc3RvcGhlIEpBSUxMRVQgPGNocmlzdG9waGUuamFpbGxldEB3YW5hZG9vLmZyPgo+PiAt
LS0KPj4gICBkcml2ZXJzL21kL2RtLWNsb25lLW1ldGFkYXRhLmMgfCA1IC0tLS0tCj4+ICAgaW5j
bHVkZS9saW51eC9iaXRtYXAuaCAgICAgICAgIHwgNiArKysrKysKPj4gICBsaWIvbWF0aC9wcmlt
ZV9udW1iZXJzLmMgICAgICAgfCAyIC0tCj4+ICAgMyBmaWxlcyBjaGFuZ2VkLCA2IGluc2VydGlv
bnMoKyksIDcgZGVsZXRpb25zKC0pCj4+Cj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21kL2RtLWNs
b25lLW1ldGFkYXRhLmMgYi9kcml2ZXJzL21kL2RtLWNsb25lLW1ldGFkYXRhLmMKPj4gaW5kZXgg
YzQzZDU1NjcyYmNlLi40N2MxZmE3YWFkOGIgMTAwNjQ0Cj4+IC0tLSBhL2RyaXZlcnMvbWQvZG0t
Y2xvbmUtbWV0YWRhdGEuYwo+PiArKysgYi9kcml2ZXJzL21kL2RtLWNsb25lLW1ldGFkYXRhLmMK
Pj4gQEAgLTQ2NSwxMSArNDY1LDYgQEAgc3RhdGljIHZvaWQgX19kZXN0cm95X3BlcnNpc3RlbnRf
ZGF0YV9zdHJ1Y3R1cmVzKHN0cnVjdCBkbV9jbG9uZV9tZXRhZGF0YSAqY21kKQo+PiAgIAo+PiAg
IC8qLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tKi8KPj4gICAKPj4gLXN0YXRpYyBzaXplX3QgYml0bWFwX3Np
emUodW5zaWduZWQgbG9uZyBucl9iaXRzKQo+PiAtewo+PiAtCXJldHVybiBCSVRTX1RPX0xPTkdT
KG5yX2JpdHMpICogc2l6ZW9mKGxvbmcpOwo+PiAtfQo+PiAtCj4+ICAgc3RhdGljIGludCBfX2Rp
cnR5X21hcF9pbml0KHN0cnVjdCBkaXJ0eV9tYXAgKmRtYXAsIHVuc2lnbmVkIGxvbmcgbnJfd29y
ZHMsCj4+ICAgCQkJICAgIHVuc2lnbmVkIGxvbmcgbnJfcmVnaW9ucykKPj4gICB7Cj4+IGRpZmYg
LS1naXQgYS9pbmNsdWRlL2xpbnV4L2JpdG1hcC5oIGIvaW5jbHVkZS9saW51eC9iaXRtYXAuaAo+
PiBpbmRleCBmMDkxYTE2NjRiZjEuLmY2NmZiOThhNDEyNiAxMDA2NDQKPj4gLS0tIGEvaW5jbHVk
ZS9saW51eC9iaXRtYXAuaAo+PiArKysgYi9pbmNsdWRlL2xpbnV4L2JpdG1hcC5oCj4+IEBAIC00
OCw2ICs0OCw3IEBAIHN0cnVjdCBkZXZpY2U7Cj4+ICAgICogIGJpdG1hcF9lcXVhbChzcmMxLCBz
cmMyLCBuYml0cykgICAgICAgICAgICAgQXJlICpzcmMxIGFuZCAqc3JjMiBlcXVhbD8KPj4gICAg
KiAgYml0bWFwX2ludGVyc2VjdHMoc3JjMSwgc3JjMiwgbmJpdHMpICAgICAgICBEbyAqc3JjMSBh
bmQgKnNyYzIgb3ZlcmxhcD8KPj4gICAgKiAgYml0bWFwX3N1YnNldChzcmMxLCBzcmMyLCBuYml0
cykgICAgICAgICAgICBJcyAqc3JjMSBhIHN1YnNldCBvZiAqc3JjMj8KPj4gKyAqICBiaXRtYXBf
c2l6ZShuYml0cykgICAgICAgICAgICAgICAgICAgICAgICAgIFNpemUsIGluIGJ5dGVzLCBvZiBh
IGJpdG1hcAo+PiAgICAqICBiaXRtYXBfZW1wdHkoc3JjLCBuYml0cykgICAgICAgICAgICAgICAg
ICAgIEFyZSBhbGwgYml0cyB6ZXJvIGluICpzcmM/Cj4+ICAgICogIGJpdG1hcF9mdWxsKHNyYywg
bmJpdHMpICAgICAgICAgICAgICAgICAgICAgQXJlIGFsbCBiaXRzIHNldCBpbiAqc3JjPwo+PiAg
ICAqICBiaXRtYXBfd2VpZ2h0KHNyYywgbmJpdHMpICAgICAgICAgICAgICAgICAgIEhhbW1pbmcg
V2VpZ2h0OiBudW1iZXIgc2V0IGJpdHMKPj4gQEAgLTEyNCw2ICsxMjUsMTEgQEAgdW5zaWduZWQg
bG9uZyAqYml0bWFwX2FsbG9jX25vZGUodW5zaWduZWQgaW50IG5iaXRzLCBnZnBfdCBmbGFncywg
aW50IG5vZGUpOwo+PiAgIHVuc2lnbmVkIGxvbmcgKmJpdG1hcF96YWxsb2Nfbm9kZSh1bnNpZ25l
ZCBpbnQgbmJpdHMsIGdmcF90IGZsYWdzLCBpbnQgbm9kZSk7Cj4+ICAgdm9pZCBiaXRtYXBfZnJl
ZShjb25zdCB1bnNpZ25lZCBsb25nICpiaXRtYXApOwo+PiAgIAo+PiArc3RhdGljIF9fYWx3YXlz
X2lubGluZSBzaXplX3QgYml0bWFwX3NpemUodW5zaWduZWQgbG9uZyBuYml0cykKPj4gK3sKPj4g
KwlyZXR1cm4gQklUU19UT19MT05HUyhuYml0cykgKiBzaXplb2YodW5zaWduZWQgbG9uZyk7Cj4+
ICt9Cj4+ICsKPj4gICAvKiBNYW5hZ2VkIHZhcmlhbnRzIG9mIHRoZSBhYm92ZS4gKi8KPj4gICB1
bnNpZ25lZCBsb25nICpkZXZtX2JpdG1hcF9hbGxvYyhzdHJ1Y3QgZGV2aWNlICpkZXYsCj4+ICAg
CQkJCSB1bnNpZ25lZCBpbnQgbmJpdHMsIGdmcF90IGZsYWdzKTsKPj4gZGlmZiAtLWdpdCBhL2xp
Yi9tYXRoL3ByaW1lX251bWJlcnMuYyBiL2xpYi9tYXRoL3ByaW1lX251bWJlcnMuYwo+PiBpbmRl
eCBkNDJjZWJmNzQwN2YuLmQzYjY0YjEwZGExYyAxMDA2NDQKPj4gLS0tIGEvbGliL21hdGgvcHJp
bWVfbnVtYmVycy5jCj4+ICsrKyBiL2xpYi9tYXRoL3ByaW1lX251bWJlcnMuYwo+PiBAQCAtNiw4
ICs2LDYgQEAKPj4gICAjaW5jbHVkZSA8bGludXgvcHJpbWVfbnVtYmVycy5oPgo+PiAgICNpbmNs
dWRlIDxsaW51eC9zbGFiLmg+Cj4+ICAgCj4+IC0jZGVmaW5lIGJpdG1hcF9zaXplKG5iaXRzKSAo
QklUU19UT19MT05HUyhuYml0cykgKiBzaXplb2YodW5zaWduZWQgbG9uZykpCj4+IC0KPiAKPiBU
aGlzIHNob3VsZCBiZSBkcm9wcGVkLCBmb3Igc3VyZSwgYW5kIGttYWxsb2MoKSBhdCBsaW5lIDEy
OCBzaG91bGQgYmUKPiByZXBsYWNlZCB3aXRoIGJpdG1hcF9hbGxvYygpLgoKVGhpcyBrbWFsbG9j
KCkgaXMgZm9yIGEgc3RydWN0dXJlIGFuZCBhIGZsZXhpYmxlIGFycmF5LgoKWW91IG1lYW4gcmUt
YXJyYW5naW5nIHRoZSBjb2RlIHRvIGFsbG9jYXRlIHRoZSBzdHJ1Y3R1cmUgYWxvbmUgYXQgZmly
c3QsIAp0aGVuIHRoZSBiaXRtYXA/CgpDSgoKPiAKPiBGb3IgdGhlIGRyaXZlciwgd2UgbmVlZCB0
byBpbnRyb2R1Y2UgYml0bWFwX2t2bWFsbG9jL2JpdG1hcF9rdmZyZWUgZXRjLgo+IAo+PiAgIHN0
cnVjdCBwcmltZXMgewo+PiAgIAlzdHJ1Y3QgcmN1X2hlYWQgcmN1Owo+PiAgIAl1bnNpZ25lZCBs
b25nIGxhc3QsIHN6Owo+PiAtLSAKPj4gMi4zNC4xCj4gCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxp
c3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFu
L2xpc3RpbmZvL2RtLWRldmVsCg==

