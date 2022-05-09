Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BCB9C433F5
	for <dm-devel@archiver.kernel.org>; Mon,  9 May 2022 09:38:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-617-eDMi2AJSOUWtrqCaQ-aQww-1; Mon, 09 May 2022 05:38:26 -0400
X-MC-Unique: eDMi2AJSOUWtrqCaQ-aQww-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9E87E811E80;
	Mon,  9 May 2022 09:38:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 27C281467E28;
	Mon,  9 May 2022 09:38:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 054981947052;
	Mon,  9 May 2022 09:38:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0EF5A19466DF
 for <dm-devel@listman.corp.redhat.com>; Mon,  9 May 2022 09:38:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EF8EBC28105; Mon,  9 May 2022 09:38:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BAD8BC28100
 for <dm-devel@redhat.com>; Mon,  9 May 2022 09:38:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7EA273979690
 for <dm-devel@redhat.com>; Mon,  9 May 2022 09:38:22 +0000 (UTC)
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de
 [85.215.255.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-634-XhRy5I43OnC9uDaUttFk-Q-1; Mon, 09 May 2022 05:38:20 -0400
X-MC-Unique: XhRy5I43OnC9uDaUttFk-Q-1
X-RZG-AUTH: ":PHkGeUmrW+uCZmxs998QJRUX30nOwJd7j/79t2yVxcUdnYNcUb5wZPHWwAJ3XYfSj54="
X-RZG-CLASS-ID: mo00
Received: from [192.168.178.22] by smtp.strato.de (RZmta 47.42.2 DYNA|AUTH)
 with ESMTPSA id Y03eaey499XYTma
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
 (Client did not present a certificate);
 Mon, 9 May 2022 11:33:34 +0200 (CEST)
Message-ID: <6d306aff-aa9c-0723-a44f-620e2885483b@thson.de>
Date: Mon, 9 May 2022 11:33:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
To: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
 dm-devel@redhat.com, agk@redhat.com, snitzer@redhat.com
References: <20220106203436.281629-1-public@thson.de>
 <20220106203436.281629-3-public@thson.de>
 <b4c21ae2-3980-c7ca-7719-7477d0acaa72@linux.microsoft.com>
From: Thore Sommer <public@thson.de>
In-Reply-To: <b4c21ae2-3980-c7ca-7719-7477d0acaa72@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [RFC PATCH 2/3] dm verity: add support for IMA
 target update event
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
Cc: tusharsu@linux.microsoft.com, linux-integrity@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

SGkgTGFrc2htaSwKCk9uIDA2LjA1LjIyIDIyOjM1LCBMYWtzaG1pIFJhbWFzdWJyYW1hbmlhbiB3
cm90ZToKPiBIaSBUaG9yZSwKPiAKPiBPbiAxLzYvMjAyMiAxMjozNCBQTSwgVGhvcmUgU29tbWVy
IHdyb3RlOgo+PiBPbiBmaXJzdCBjb3JydXB0aW9uIHRoZSB2ZXJpdHkgdGFyZ2V0cyB0cmlnZ2Vy
cyBhIGRtX3RhcmdldF91cGRhdGUgZXZlbnQuCj4+IFRoaXMgYWxsb3dzIG90aGVyIHN5c3RlbXMg
dG8gY2hlY2sgdXNpbmcgSU1BIGlmIHRoZSBzdGF0ZSBvZiB0aGUgCj4+IGRldmljZSBpcwo+PiBz
dGlsbCB0cnVzdHdvcnRoeSB2aWEgcmVtb3RlIGF0dGVzdGF0aW9uLgo+IEluIHRoZSBwYXRjaCBk
ZXNjcmlwdGlvbiBwbGVhc2Ugc3RhdGUgdGhlIGV4aXN0aW5nIHByb2JsZW0gKG9yLCAKPiBsaW1p
dGF0aW9uIGluIHRoZSBleGlzdGluZyBpbXBsZW1lbnRhdGlvbikgYW5kIHRoZW4gZGVzY3JpYmUg
aG93IHRoZSAKPiBwcm9wb3NlZCBjaGFuZ2UgYWRkcmVzc2VzIHRoZSBpc3N1ZS4KClRoZSBwcm9i
bGVtIGlzIHRoYXQgd2UgbmV2ZXIgc2VlIGEgSU1BIGVudHJ5IHdoZW4gYSB0YXJnZXQgZ2V0cyBt
YXJrZWQgCmFzIGNvcnJ1cHRlZC4gVGhlIHByb3Bvc2VkIGNoYW5nZSB1c2VzIHRoZSBuZXcgZG1f
dGFyZ2V0X3VwZGF0ZSBldmVudCB0byAKcmVtZWFzdXJlIHRoZSB0YWJsZSB3aGVuIHRoZSB0YXJn
ZXQgdGFibGUgZW50cnkgY2hhbmdlcyBmcm9tIHZhbGlkIHRvIApjb3JydXB0ZWQuIEkgd2lsbCBh
ZGQgYSBtb3JlIGNvbXBsZXRlIGRlc2NyaXB0aW9uIHRvIHYyLgoKPiAKPj4KPj4gU2lnbmVkLW9m
Zi1ieTogVGhvcmUgU29tbWVyIDxwdWJsaWNAdGhzb24uZGU+Cj4+IC0tLQo+PiDCoCBkcml2ZXJz
L21kL2RtLXZlcml0eS10YXJnZXQuYyB8IDYgKysrKysrCj4+IMKgIDEgZmlsZSBjaGFuZ2VkLCA2
IGluc2VydGlvbnMoKykKPj4KPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvZG0tdmVyaXR5LXRh
cmdldC5jIAo+PiBiL2RyaXZlcnMvbWQvZG0tdmVyaXR5LXRhcmdldC5jCj4+IGluZGV4IDgwMTMz
YWFlMGRiMy4uMDk2OTZlMjViZjFjIDEwMDY0NAo+PiAtLS0gYS9kcml2ZXJzL21kL2RtLXZlcml0
eS10YXJnZXQuYwo+PiArKysgYi9kcml2ZXJzL21kL2RtLXZlcml0eS10YXJnZXQuYwo+PiBAQCAt
MTYsNiArMTYsNyBAQAo+PiDCoCAjaW5jbHVkZSAiZG0tdmVyaXR5LmgiCj4+IMKgICNpbmNsdWRl
ICJkbS12ZXJpdHktZmVjLmgiCj4+IMKgICNpbmNsdWRlICJkbS12ZXJpdHktdmVyaWZ5LXNpZy5o
Igo+PiArI2luY2x1ZGUgImRtLWltYS5oIgo+PiDCoCAjaW5jbHVkZSA8bGludXgvbW9kdWxlLmg+
Cj4+IMKgICNpbmNsdWRlIDxsaW51eC9yZWJvb3QuaD4KPj4gwqAgI2luY2x1ZGUgPGxpbnV4L3Nj
YXR0ZXJsaXN0Lmg+Cj4+IEBAIC0yMTgsMTAgKzIxOSwxNSBAQCBzdGF0aWMgaW50IHZlcml0eV9o
YW5kbGVfZXJyKHN0cnVjdCBkbV92ZXJpdHkgCj4+ICp2LCBlbnVtIHZlcml0eV9ibG9ja190eXBl
IHR5cGUsCj4+IMKgwqDCoMKgwqAgY2hhciAqZW52cFtdID0geyB2ZXJpdHlfZW52LCBOVUxMIH07
Cj4+IMKgwqDCoMKgwqAgY29uc3QgY2hhciAqdHlwZV9zdHIgPSAiIjsKPj4gwqDCoMKgwqDCoCBz
dHJ1Y3QgbWFwcGVkX2RldmljZSAqbWQgPSBkbV90YWJsZV9nZXRfbWQodi0+dGktPnRhYmxlKTsK
Pj4gK8KgwqDCoCBpbnQgb2xkX2hhc2hfZmFpbGVkID0gdi0+aGFzaF9mYWlsZWQ7Cj4+IMKgwqDC
oMKgwqAgLyogQ29ycnVwdGlvbiBzaG91bGQgYmUgdmlzaWJsZSBpbiBkZXZpY2Ugc3RhdHVzIGlu
IGFsbCBtb2RlcyAqLwo+PiDCoMKgwqDCoMKgIHYtPmhhc2hfZmFpbGVkID0gMTsKPj4gK8KgwqDC
oCAvKiBPbmx5IHJlbWVhc3VyZSBvbiBmaXJzdCBmYWlsdXJlICovCj4+ICvCoMKgwqAgaWYgKCFv
bGRfaGFzaF9mYWlsZWQpCj4+ICvCoMKgwqDCoMKgwqDCoCBkbV9pbWFfbWVhc3VyZV9vbl90YXJn
ZXRfdXBkYXRlKHYtPnRpKTsKPiBJdCBpcyBub3Qgb2J2aW91cyB0byBtZSB3aHkgdGhlIGNhbGwg
dG8gbWVhc3VyZSBvbiB0YXJnZXQgdXBkYXRlIGlzIG5vdCAKPiBkb25lIGhlcmUgaW1tZWRpYXRl
bHkuIFVwZGF0aW5nIHRoZSBjb21tZW50IHRvIGV4cGxhaW4gdGhlIGxvZ2ljIHdvdWxkIAo+IGhl
bHAuClRoZSBjaGFuZ2Ugc2hvdWxkIGJlIG9ubHkgbWVhc3VyZWQgb25jZSwgYmVjYXVzZSBvdGhl
cndpc2Ugd2Ugd291bGQgCmNyZWF0ZSBtYW55IElNQSBlbnRyaWVzIGVhY2ggZm9yIGV2ZXJ5IGNv
cnJ1cHRlZCBibG9jayByZWFkIGlmIEkgCnVuZGVyc3RhbmQgdGhlIHZlcml0eSBjb2RlIGNvcnJl
Y3RseS4gU28gd2UgbmVlZCB0byBjaGVjayBpZiB0aGUgc3RhdGUgCmJlZm9yZSB3YXMgdmFsaWQs
IGJ1dCB3ZSBuZWVkIHRvIG1lYXN1cmUgYWZ0ZXIgdGhlIHRhYmxlIHdhcyBjaGFuZ2VkIHRvIApj
b3JydXB0ZWQgKHYtPmhhc2hfZmFpbGVkID0gMSkuCgpTb21ldGhpbmcgbGlrZSB0aGlzIG1pZ2h0
IGJlIGEgYml0IGNsZWFyZXIgYW5kIGRvZXMgbm90IHVzZSBhIGV4dHJhIAp2YXJpYWJsZToKCisg
ICAgaWYgKCF2LT5oYXNoX2ZhaWxlZCkKKyAgICAgICAgdi0+aGFzaF9mYWlsZWQgPSAxOworICAg
ICAgICBkbV9pbWFfbWVhc3VyZV9vbl90YXJnZXRfdXBkYXRlKHYtPnRpKTsKCgpSZWdhcmRzLApU
aG9yZQoKPiAKPiB0aGFua3MsCj4gIMKgLWxha3NobWkKPiAKPj4gKwo+PiDCoMKgwqDCoMKgIGlm
ICh2LT5jb3JydXB0ZWRfZXJycyA+PSBETV9WRVJJVFlfTUFYX0NPUlJVUFRFRF9FUlJTKQo+PiDC
oMKgwqDCoMKgwqDCoMKgwqAgZ290byBvdXQ7CgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0t
ZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3Rp
bmZvL2RtLWRldmVsCg==

