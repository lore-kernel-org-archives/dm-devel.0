Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57576C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 29 Nov 2021 04:16:55 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-498-Okbn8c0RMP2gujZiOmC1Og-1; Sun, 28 Nov 2021 23:16:50 -0500
X-MC-Unique: Okbn8c0RMP2gujZiOmC1Og-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1840D80573B;
	Mon, 29 Nov 2021 04:16:46 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8C7A460854;
	Mon, 29 Nov 2021 04:16:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1EFBA1809C89;
	Mon, 29 Nov 2021 04:16:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AT4GX0P017781 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 28 Nov 2021 23:16:33 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 651C5404727A; Mon, 29 Nov 2021 04:16:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 60B004047272
	for <dm-devel@redhat.com>; Mon, 29 Nov 2021 04:16:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4719C801212
	for <dm-devel@redhat.com>; Mon, 29 Nov 2021 04:16:33 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com
	[45.249.212.187]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-519-7Gs8WTyROg2fDHiu9YJ08w-1; Sun, 28 Nov 2021 23:16:30 -0500
X-MC-Unique: 7Gs8WTyROg2fDHiu9YJ08w-1
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4J2X642RSFzZdHn;
	Mon, 29 Nov 2021 12:13:48 +0800 (CST)
Received: from kwepemm600010.china.huawei.com (7.193.23.86) by
	dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2308.20; Mon, 29 Nov 2021 12:16:26 +0800
Received: from [10.174.179.176] (10.174.179.176) by
	kwepemm600010.china.huawei.com (7.193.23.86) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2308.20; Mon, 29 Nov 2021 12:16:26 +0800
To: Martin Wilck <mwilck@suse.com>, Christophe Varoqui
	<christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel mailing list <dm-devel@redhat.com>
References: <bfa69895-5b9e-5fe6-e5a0-78be2ee93163@huawei.com>
	<17f1efd1ce3372014ca67fd25c992ea169b7afbe.camel@suse.com>
From: lixiaokeng <lixiaokeng@huawei.com>
Message-ID: <1ccdd748-a77e-d52e-0816-6a2204a04010@huawei.com>
Date: Mon, 29 Nov 2021 12:16:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <17f1efd1ce3372014ca67fd25c992ea169b7afbe.camel@suse.com>
X-Originating-IP: [10.174.179.176]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AT4GX0P017781
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>,
	"liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>
Subject: Re: [dm-devel] [PATCH] libmultipath: clear removed path from mpp
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
Content-Language: en-GB
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

CgpPbiAyMDIxLzExLzI5IDc6MTgsIE1hcnRpbiBXaWxjayB3cm90ZToKCj4+IMKgwqDCoMKgwqDC
oMKgwqAvKgo+PiBAQCAtMzI5LDYgKzMzMSwyMCBAQCB2b2lkIHNldF9wYXRoX3JlbW92ZWQoc3Ry
dWN0IHBhdGggKnBwKQo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGNvbmRsb2co
MCwgIiVzOiBpbnRlcm5hbCBlcnJvcjogbXBwID09IE5VTEwiLCBwcC0KPj4+IGRldik7Cj4+IMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuOwo+PiDCoMKgwqDCoMKgwqDCoMKg
fQo+PiArCj4+ICvCoMKgwqDCoMKgwqDCoC8qCj4+ICvCoMKgwqDCoMKgwqDCoCAqIFRoZSBwYXRo
IGlzIHJlbW92ZWQsIGNsZWFyIGl0IGZyb20gbXAtPnBhdGhzIGFuZCBtcHAtPnBncy4KPj4gK8Kg
wqDCoMKgwqDCoMKgICovCj4+ICvCoMKgwqDCoMKgwqDCoGkgPSBmaW5kX3Nsb3QobXBwLT5wYXRo
cywgcHApOwo+PiArwqDCoMKgwqDCoMKgwqBpZiAoaSAhPSAtMSkKPj4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoHZlY3Rvcl9kZWxfc2xvdChtcHAtPnBhdGhzLCBpKTsKPj4gKwo+PiAr
wqDCoMKgwqDCoMKgwqB2ZWN0b3JfZm9yZWFjaF9zbG90KG1wcC0+cGcsIHBncCwgaikgewo+PiAr
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaSA9IGZpbmRfc2xvdChwZ3AtPnBhdGhzLCAo
dm9pZCAqKXBwKTsKPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmIChpICE9IC0x
KQo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHZlY3Rv
cl9kZWxfc2xvdChwZ3AtPnBhdGhzLCBpKTsKPj4gK8KgwqDCoMKgwqDCoMKgfQo+PiArCj4gCj4g
Tm8sIHdlIGNhbid0IGRvIHRoaXMuIEl0IHdvdWxkIGludmFsaWRhdGUgYWxsIHRoZSB3b3JrIHdl
IGRpZCBmb3IKPiBJTklUX1JFTU9WRUQuIEl0J3MgdGhlIHZlcnkgaWRlYSBvZiBJTklUX1JFTU9W
RUQgdGhhdCB3ZSBkbyBOT1QKPiBpbW1lZGlhdGVseSBjbGVhciB0aGUgcGF0aCBmcm9tIG91ciBk
YXRhIHN0cnVjdHVyZXMuIFRoZSBtYWluIHByb2JsZW0KPiBpcyB0aGF0IElOSVRfUkVNT1ZFRCBw
YXRocyBtYXkgc3RpbGwgYmUgcGFydCBvZiB0aGUgbWFwIGluIHRoZSBrZXJuZWwuCj4gVGh1cyB3
aGVuIHdlIHJlLXJlYWQgdGhlIGtlcm5lbCBzdGF0ZSwgdGhlIHBhdGggd2lsbCBiZSByZS1hZGRl
ZCB0bwo+IG1wcC0+cGF0aHMuCj4gCj4gV2UgbmVlZCB0byByZXdvcmsgdGhlIGZyZWVfbXVsdGlw
YXRoKCkgbG9naWMuIEl0IG1pZ2h0IGJlIHN1ZmZpY2llbnQKPiB0byBzaW1wbHkgY2xlYXIgdGhl
IHJlZmVyZW5jZXMgdG8gdGhlIGRldmljZXMgaW4gbXBwIGJlZm9yZSBjYWxsaW5nCj4gb3JwaGFu
X3BhdGhzKCkuIENhbiB5b3UgdHJ5IHRoZSBhdHRhY2hlZCBwYXRjaCwgcGxlYXNlPwo+IAoKVGhh
bmtzIGZvciByZXBsYXkuIFRoZSBhdHRhY2hlZCBwYXRjaCByZXNvbHZlcyB0aGlzIGVycm9yLgoK
SSBob3BlcyB0aGF0ICJSZXBvcnRlZC1ieTogTGl4aWFva2VuZyA8bGl4aWFva2VuZ0BodWF3ZWk+
IiBpcyBhZGRlZCB0bwp0aGUgcGF0Y2guIFRoYW5rcyBhZ2Fpbi4KClJlZ2FyZHMsCkxpeGlhb2tl
bmcKCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczov
L2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs

