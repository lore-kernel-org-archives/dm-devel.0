Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEE68C4321E
	for <dm-devel@archiver.kernel.org>; Thu,  1 Dec 2022 07:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669880841;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ew5U9NRSLirgqhrPefuRN6JhJOduCwVhfq+pZz4Yj7w=;
	b=HeAuhL74bQxNhsU9Q4mRjL8ocMg7Iztt4eQF3mzrJJr/zCYWvtV8jHnBRGFH8Zz30FFxbp
	DgZKpNIaFReLI0nbFZj8zlEF8dcJutmKzYiwBsLXSI4eQ2frA7sMz98wYo0zNUaXe0wBuL
	7dTl6jsbaJaoHRWmN9pIvaGBe5pbm2g=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-459-FX4u9DXmNdqohf3xkae3MQ-1; Thu, 01 Dec 2022 02:47:18 -0500
X-MC-Unique: FX4u9DXmNdqohf3xkae3MQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2686E1C0691A;
	Thu,  1 Dec 2022 07:47:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C521D40C2064;
	Thu,  1 Dec 2022 07:47:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2D46019465A8;
	Thu,  1 Dec 2022 07:47:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 349DA19465A0
 for <dm-devel@listman.corp.redhat.com>; Thu,  1 Dec 2022 07:47:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D4E18111F3C7; Thu,  1 Dec 2022 07:47:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CB8251121314
 for <dm-devel@redhat.com>; Thu,  1 Dec 2022 07:47:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ABA02801755
 for <dm-devel@redhat.com>; Thu,  1 Dec 2022 07:47:11 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com
 [45.249.212.188]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-118-EfTqdgCkPs2h67MoTXJNzg-1; Thu, 01 Dec 2022 02:47:08 -0500
X-MC-Unique: EfTqdgCkPs2h67MoTXJNzg-1
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
 by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NN74n2cVpzHwPm;
 Thu,  1 Dec 2022 15:29:45 +0800 (CST)
Received: from kwepemm600010.china.huawei.com (7.193.23.86) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Dec 2022 15:30:04 +0800
Received: from [10.174.177.197] (10.174.177.197) by
 kwepemm600010.china.huawei.com (7.193.23.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Dec 2022 15:30:03 +0800
To: Benjamin Marzinski <bmarzins@redhat.com>, miaoguanqin
 <miaoguanqin@huawei.com>
References: <feab383d-f3fa-fb8d-caf2-10830757522b@huawei.com>
 <ea94d029-a5a8-7498-2254-a980fb764935@huawei.com>
 <20221130160454.GZ19568@octiron.msp.redhat.com>
From: lixiaokeng <lixiaokeng@huawei.com>
Message-ID: <04fc154b-0510-ddd5-0880-ccc4c7bb21bb@huawei.com>
Date: Thu, 1 Dec 2022 15:30:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20221130160454.GZ19568@octiron.msp.redhat.com>
X-Originating-IP: [10.174.177.197]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600010.china.huawei.com (7.193.23.86)
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH] multipathd: Fixed multipathd parameter
 invoking
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
Cc: linfeilong <linfeilong@huawei.com>,
 dm-devel mailing list <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>,
 "liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-GB
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

QmVmb3JlIHdlIGFwcGx5IGY4MTI0NjZmICgibXVsdGlwYXRoZDogbW9yZSByb2J1c3QgY29tbWFu
ZCBwYXJzaW5nIiksCm11bHRpcGF0aGQgaGVscCBzaG93czoKLi4uCiBtYXB8bXVsdGlwYXRoICRt
YXAgZ2V0cHJzdGF0dXMKIG1hcHxtdWx0aXBhdGggJG1hcCBzZXRwcnN0YXR1cwogbWFwfG11bHRp
cGF0aCAkbWFwIHVuc2V0cHJzdGF0dXMKIG1hcHxtdWx0aXBhdGggJG1hcCBnZXRwcmtleQogbWFw
fG11bHRpcGF0aCAkbWFwIHNldHBya2V5IGtleSAka2V5CiBtYXB8bXVsdGlwYXRoICRtYXAgdW5z
ZXRwcmtleQogZm9yY2VxdWV1ZWluZyBkYWVtb24KIHJlc3RvcmVxdWV1ZWluZyBkYWVtb24KIHBh
dGggJHBhdGggc2V0bWFyZ2luYWwKIHBhdGggJHBhdGggdW5zZXRtYXJnaW5hbAogbWFwfG11bHRp
cGF0aCAkbWFwIHVuc2V0bWFyZ2luYWwKCldlIHRoaW5rIGl0IGlzIGJldHRlciB0byBrZWVwIHRo
aXMgY29uc2lzdGVudCwgc28gd2UgZml4IGl0CmFzIHRoaXMgcGF0Y2guIEJlc2lkZXMgdGhhdCwg
d2UgYWxzbyBjaGFuZ2UgImdldHByc3RhdHVzJwoiZ2V0cHJrZXkiICJzZXRtYXJnaW5hbCIgInVu
c2V0bWFyZ2luYWwiIG9yZGVycyB0byBrZWVwCmNvbnNpc3RlbnQgYW5kIGF2b2lkIHNhbWUgcHJv
YmxlbSBpZiB1c2VycyB1c2UgIm11bHRpcGF0aGQKeHh4IiAobGlrZSBnZXRwcmtleSkuCgpPbiAy
MDIyLzEyLzEgMDowNCwgQmVuamFtaW4gTWFyemluc2tpIHdyb3RlOgo+IE9uIFdlZCwgTm92IDMw
LCAyMDIyIGF0IDA1OjEzOjI4UE0gKzA4MDAsIG1pYW9ndWFucWluIHdyb3RlOgo+PiBwaW5nCj4g
Cj4gSSBmaXhlZCB0aGlzIGlzc3VlIGEgZGlmZmVyZW50IHdheS4gUHJldmlvdXNseSB3ZSBhY2Nl
cHRlZCBhbnkgb3JkZXJpbmcKPiBvZiBrZXl3b3JkcywgYnV0IHdlIGhhdmUgYWx3YXlzIGFkdmVy
dGlzZWQgYSBzcGVjaWZpYyBvcmRlciBpbiB0aGUgQ0xJCj4gY29tbWFuZHMgcmVmZXJlbmNlICh0
byBzZWUgaXQsIGp1c3QgcnVuICJtdWxpdHBhdGhkIGhlbHAiIG9yIHVzZSBhbnkKPiBvdGhlciBp
bnZhbGlkIGtleXdvcmQpLiBUaGUgY29tbWFuZCB3b3JkIGlzIGZpcnN0IGFuZCB0aGUgYXJndW1l
bnRzCj4gZm9sbG93LiAgSSB0aGluayB3ZSBzaG91bGQga2VlcCB0aGlzIGNvbnNpc3RlbnQsIGFu
ZCBJIGRvbid0IHRoaW5rIHdlCj4gc2hvdWxkIGdvIGNoYW5naW5nIHRoZSBvcmRlciBvZiBleGlz
dGluZyBjb21tYW5kcy4gSW5zdGVhZCwgbXkgcGF0Y2gKPiBtYWtlcyBsaWJtcGF0aHBlcnNpc3Qg
aXNzdWUgY29tbWFuZHMgaW4gdGhlIGNvcnJlY3Qgb3JkZXIuIENvdWxkIHlvdQo+IGxvb2sgYXQ6
Cj4gCj4gW2RtLWRldmVsXSBbUEFUQ0ggMi8yXSBsaWJtcGF0aHBlcnNpc3Q6IGZpeCBjb21tYW5k
IGtleXdvcmQgb3JkZXJpbmcKPiBodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9hcmNoaXZlcy9k
bS1kZXZlbC8yMDIyLU5vdmVtYmVyLzA1Mjc3My5odG1sCj4gCj4gYW5kIHNlZSBpZiB0aGF0IHNv
bHZlcyB5b3VyIGlzc3VlLgo+IAo+IC1CZW4KPiAKPj4KPj4gT24gMjAyMi8xMS8yNSA5OjI2LCBt
aWFvZ3VhbnFpbiB3cm90ZToKPj4+IFVzZXJzIG1heSBmYWlsIHRvIGV4ZWN1dGUgY29tbWFuZDog
bXVsdGlwYXRoZCBhbmQgbXBhdGhwZXJzaXN0Lgo+Pj4KPj4+IFdoZW4gd2UgZXhlY3V0ZSB0aGUg
Y29tbWFuZCBtcGF0aHBlcnNpc3TvvJoKPj4+IG1wYXRocGVyc2lzdCAtLW91dCAtLXJlZ2lzdGVy
IC0tcGFyYW0tc2Fyaz0xMjMgLS1wcm91dC10eXBlPTUKPj4+IC9kZXYvbWFwcGVyL21wYXRoYgo+
Pj4gSXQgcmV0dXJuIGFuIGVycm9yIDogTWlzc2luZyBhcmd1ZW1lbnQuIFRoZSBwcmVjZWRpbmcg
Y29tbWFuZCBjYWxscyB0aGUKPj4+IGZ1bmN0aW9uCj4+PiBjbGlfc2V0cHJrZXksIHdoaWNoIGlz
IGNhbGxlZCBieSBjaGVja2luZyB3aGV0aGVyIHRoZSBoYW5kbGUgdmFsdWVzIGFyZQo+Pj4gY29u
c2lzdGVudAo+Pj4gd2l0aCB0aGUgY29tbWFuZCBpbnB1dC4gQ1ZFLTIwMjItNDE5NzQgY2hhbmdl
ZCB0aGUgaGFuZGxlciB2YWx1ZSBvZgo+Pj4gZnVuY3Rpb24gYW5kCj4+PiBjaGFuZ2VkIHRoZSBt
b2RlIG9mIGNhbGN1bGF0aW5nIGhhbmRsZS7CoCBUaGUgaGFuZGxlciB2YWx1ZSBpcyBub3QgZXF1
YWwgdG8KPj4+IHRoZQo+Pj4gY29tbWFuZCBpbnB1dCwgY2F1c2luZyBtdWx0aXBhdGhkIGNhbiBu
b3QgZXhlY3V0ZSB0aGUgdHJ1ZSBmdW5jaW9uLiBJdAo+Pj4gY291bGQgYmUKPj4+IGFuIHNhbWUg
ZXJyb3IgZm9yIGV4ZWN1dGluZyBtdWx0aXBhdGhkIGJ5IHRoZSBvbGQgbW9kZS4KPj4+Cj4+PiBt
dWx0aXBhdGhkIGludm9rZXMgdGhlIGNvcnJlc3BvbmRpbmcgZnVuY3Rpb24gYmFzZWQgb24gdGhl
IGhhbmRsZSB2YWx1ZS4KPj4+IENWRS0yMDIyLTQxOTY0IGNoYW5nZWQgdGhlIG1ldGhvZCBvZiBj
YWxjdWxhdGluZyBoYW5kbGVyIHZhbHVlLiBNb2RpZnkgdGhlCj4+PiBoYW5kbGUKPj4+IHZhbHVl
IHNvIHRoYXQgdGhlIGNvcnJlc3BvbmRpbmcgZnVuY3Rpb24gY2FuIGJlIGNvcnJlY3RseSBleGVj
dXRlLgo+Pj4KPj4+IFNpZ25lZC1vZmYtYnk6IG1pYW9ndWFucWluIDxtaWFvZ3VhbnFpbkBodWF3
ZWkuY29tPgo+Pj4gU2lnbmVkLW9mZi1ieTogbGl4aWFva2VuZyA8bGl4aWFva2VuZ0BodWF3ZWku
Y29tPgo+Pj4gLS0tCj4+PiDCoG11bHRpcGF0aGQvY2FsbGJhY2tzLmMgfCAxOCArKysrKysrKyst
LS0tLS0tLS0KPj4+IMKgbXVsdGlwYXRoZC9jbGkuaMKgwqDCoMKgwqDCoCB8wqAgOSArKysrKysr
Ky0KPj4+IMKgMiBmaWxlcyBjaGFuZ2VkLCAxNyBpbnNlcnRpb25zKCspLCAxMCBkZWxldGlvbnMo
LSkKPj4+Cj4+PiBkaWZmIC0tZ2l0IGEvbXVsdGlwYXRoZC9jYWxsYmFja3MuYyBiL211bHRpcGF0
aGQvY2FsbGJhY2tzLmMKPj4+IGluZGV4IGZiODdiMjgwLi5mMzI2NjZiZSAxMDA2NDQKPj4+IC0t
LSBhL211bHRpcGF0aGQvY2FsbGJhY2tzLmMKPj4+ICsrKyBiL211bHRpcGF0aGQvY2FsbGJhY2tz
LmMKPj4+IEBAIC01NywxNiArNTcsMTYgQEAgdm9pZCBpbml0X2hhbmRsZXJfY2FsbGJhY2tzKHZv
aWQpCj4+PiDCoMKgwqDCoCBzZXRfaGFuZGxlcl9jYWxsYmFjayhWUkJfUkVTVE9SRVEgfCBRMV9N
QVBTLAo+Pj4gSEFORExFUihjbGlfcmVzdG9yZV9hbGxfcXVldWVpbmcpKTsKPj4+IMKgwqDCoMKg
IHNldF91bmxvY2tlZF9oYW5kbGVyX2NhbGxiYWNrKFZSQl9RVUlULCBIQU5ETEVSKGNsaV9xdWl0
KSk7Cj4+PiDCoMKgwqDCoCBzZXRfdW5sb2NrZWRfaGFuZGxlcl9jYWxsYmFjayhWUkJfU0hVVERP
V04sIEhBTkRMRVIoY2xpX3NodXRkb3duKSk7Cj4+PiAtwqDCoMKgIHNldF9oYW5kbGVyX2NhbGxi
YWNrKFZSQl9HRVRQUlNUQVRVUyB8IFExX01BUCwKPj4+IEhBTkRMRVIoY2xpX2dldHByc3RhdHVz
KSk7Cj4+PiAtwqDCoMKgIHNldF9oYW5kbGVyX2NhbGxiYWNrKFZSQl9TRVRQUlNUQVRVUyB8IFEx
X01BUCwKPj4+IEhBTkRMRVIoY2xpX3NldHByc3RhdHVzKSk7Cj4+PiAtwqDCoMKgIHNldF9oYW5k
bGVyX2NhbGxiYWNrKFZSQl9VTlNFVFBSU1RBVFVTIHwgUTFfTUFQLAo+Pj4gSEFORExFUihjbGlf
dW5zZXRwcnN0YXR1cykpOwo+Pj4gK8KgwqDCoCBzZXRfaGFuZGxlcl9jYWxsYmFjayhLRVlfTUFQ
IHwgUTFfR0VUUFJTVEFUVVMsCj4+PiBIQU5ETEVSKGNsaV9nZXRwcnN0YXR1cykpOwo+Pj4gK8Kg
wqDCoCBzZXRfaGFuZGxlcl9jYWxsYmFjayhLRVlfTUFQIHwgUTFfU0VUU1RBVFVTLAo+Pj4gSEFO
RExFUihjbGlfc2V0cHJzdGF0dXMpKTsKPj4+ICvCoMKgwqAgc2V0X2hhbmRsZXJfY2FsbGJhY2so
S0VZX01BUCB8IFExX1VOU0VUU1RBVFVTLAo+Pj4gSEFORExFUihjbGlfdW5zZXRwcnN0YXR1cykp
Owo+Pj4gwqDCoMKgwqAgc2V0X2hhbmRsZXJfY2FsbGJhY2soVlJCX0ZPUkNFUSB8IFExX0RBRU1P
TiwKPj4+IEhBTkRMRVIoY2xpX2ZvcmNlX25vX2RhZW1vbl9xKSk7Cj4+PiDCoMKgwqDCoCBzZXRf
aGFuZGxlcl9jYWxsYmFjayhWUkJfUkVTVE9SRVEgfCBRMV9EQUVNT04sCj4+PiBIQU5ETEVSKGNs
aV9yZXN0b3JlX25vX2RhZW1vbl9xKSk7Cj4+PiAtwqDCoMKgIHNldF9oYW5kbGVyX2NhbGxiYWNr
KFZSQl9HRVRQUktFWSB8IFExX01BUCwgSEFORExFUihjbGlfZ2V0cHJrZXkpKTsKPj4+IC3CoMKg
wqAgc2V0X2hhbmRsZXJfY2FsbGJhY2soVlJCX1NFVFBSS0VZIHwgUTFfTUFQIHwgUTJfS0VZLAo+
Pj4gSEFORExFUihjbGlfc2V0cHJrZXkpKTsKPj4+IC3CoMKgwqAgc2V0X2hhbmRsZXJfY2FsbGJh
Y2soVlJCX1VOU0VUUFJLRVkgfCBRMV9NQVAsCj4+PiBIQU5ETEVSKGNsaV91bnNldHBya2V5KSk7
Cj4+PiAtwqDCoMKgIHNldF9oYW5kbGVyX2NhbGxiYWNrKFZSQl9TRVRNQVJHSU5BTCB8IFExX1BB
VEgsCj4+PiBIQU5ETEVSKGNsaV9zZXRfbWFyZ2luYWwpKTsKPj4+IC3CoMKgwqAgc2V0X2hhbmRs
ZXJfY2FsbGJhY2soVlJCX1VOU0VUTUFSR0lOQUwgfCBRMV9QQVRILAo+Pj4gSEFORExFUihjbGlf
dW5zZXRfbWFyZ2luYWwpKTsKPj4+IC3CoMKgwqAgc2V0X2hhbmRsZXJfY2FsbGJhY2soVlJCX1VO
U0VUTUFSR0lOQUwgfCBRMV9NQVAsCj4+PiArwqDCoMKgIHNldF9oYW5kbGVyX2NhbGxiYWNrKEtF
WV9NQVAgfCBRMV9HRVRQUktFWSwgSEFORExFUihjbGlfZ2V0cHJrZXkpKTsKPj4+ICvCoMKgwqAg
c2V0X2hhbmRsZXJfY2FsbGJhY2soS0VZX01BUCB8IFExX1NFVEtFWSB8IFEyX0tFWSwKPj4+IEhB
TkRMRVIoY2xpX3NldHBya2V5KSk7Cj4+PiArwqDCoMKgIHNldF9oYW5kbGVyX2NhbGxiYWNrKEtF
WV9NQVAgfCBRMV9VTlNFVEtFWSwgSEFORExFUihjbGlfdW5zZXRwcmtleSkpOwo+Pj4gK8KgwqDC
oCBzZXRfaGFuZGxlcl9jYWxsYmFjayhLRVlfUEFUSCB8IFExX1NFVE1BUkdJTkFMLAo+Pj4gSEFO
RExFUihjbGlfc2V0X21hcmdpbmFsKSk7Cj4+PiArwqDCoMKgIHNldF9oYW5kbGVyX2NhbGxiYWNr
KEtFWV9QQVRIIHwgUTFfVU5TRVRNQVJHSU5BTCwKPj4+IEhBTkRMRVIoY2xpX3Vuc2V0X21hcmdp
bmFsKSk7Cj4+PiArwqDCoMKgIHNldF9oYW5kbGVyX2NhbGxiYWNrKEtFWV9NQVAgfCBRMV9VTlNF
VE1BUkdJTkFMLAo+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBIQU5ETEVS
KGNsaV91bnNldF9hbGxfbWFyZ2luYWwpKTsKPj4+IMKgfQo+Pj4gZGlmZiAtLWdpdCBhL211bHRp
cGF0aGQvY2xpLmggYi9tdWx0aXBhdGhkL2NsaS5oCj4+PiBpbmRleCBjNmI3OWM5ZC4uMDhlZTVj
OGQgMTAwNjQ0Cj4+PiAtLS0gYS9tdWx0aXBhdGhkL2NsaS5oCj4+PiArKysgYi9tdWx0aXBhdGhk
L2NsaS5oCj4+PiBAQCAtODAsNyArODAsMTQgQEAgZW51bSB7Cj4+PiDCoMKgwqDCoCBRMV9BTEzC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgID0gS0VZX0FMTCA8PCA4LAo+Pj4gwqDCoMKgwqAgUTFfREFF
TU9OwqDCoMKgwqDCoMKgwqAgPSBLRVlfREFFTU9OIDw8IDgsCj4+PiDCoMKgwqDCoCBRMV9TVEFU
VVPCoMKgwqDCoMKgwqDCoCA9IEtFWV9TVEFUVVMgPDwgOCwKPj4+IC0KPj4+ICvCoMKgwqAgUTFf
U0VUS0VZwqDCoMKgwqDCoMKgwqAgPSBWUkJfU0VUUFJLRVkgPDwgOCwKPj4+ICvCoMKgwqAgUTFf
VU5TRVRLRVnCoMKgwqDCoMKgwqDCoCA9IFZSQl9VTlNFVFBSS0VZIDw8IDgsCj4+PiArwqDCoMKg
IFExX1NFVFNUQVRVU8KgwqDCoMKgwqDCoMKgID0gVlJCX1NFVFBSU1RBVFVTIDw8IDgsCj4+PiAr
wqDCoMKgIFExX1VOU0VUU1RBVFVTwqDCoMKgwqDCoMKgwqAgPSBWUkJfVU5TRVRQUlNUQVRVUyA8
PCA4LAo+Pj4gK8KgwqDCoCBRMV9HRVRQUlNUQVRVU8KgwqDCoMKgwqDCoMKgID0gVlJCX0dFVFBS
U1RBVFVTIDw8IDgsCj4+PiArwqDCoMKgIFExX0dFVFBSS0VZwqDCoMKgwqDCoMKgwqAgPSBWUkJf
R0VUUFJLRVkgPDwgOCwKPj4+ICvCoMKgwqAgUTFfU0VUTUFSR0lOQUzCoMKgwqDCoMKgwqDCoCA9
IFZSQl9TRVRNQVJHSU5BTCA8PCA4LAo+Pj4gK8KgwqDCoCBRMV9VTlNFVE1BUkdJTkFMwqDCoMKg
ID0gVlJCX1VOU0VUTUFSR0lOQUwgPDwgOCwKPj4+IMKgwqDCoMKgIC8qIGJ5dGUgMjogcXVhbGlm
aWVyIDIgKi8KPj4+IMKgwqDCoMKgIFEyX0ZNVMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgPSBLRVlf
Rk1UIDw8IDE2LAo+Pj4gwqDCoMKgwqAgUTJfUkFXwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCA9IEtF
WV9SQVcgPDwgMTYsCj4gCj4gLgo+IAoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVs
QHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9k
bS1kZXZlbAo=

