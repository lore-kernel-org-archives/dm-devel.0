Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC192C433FE
	for <dm-devel@archiver.kernel.org>; Wed, 30 Nov 2022 09:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669799631;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=D+AFt7XM6HrO214PsAbl9ZbArRVe/IWVPVwmkL7pwFY=;
	b=Rb1VZxK30W0hbN7/tv01hYiLXR1nUBRM2Gv/shpm4Ls1qJeQ1nuwFsoBn3G2SdIHF+86Ao
	NsFvo1/tqSEsXzAjoXllQVWU9DTEGdvlDiKdoHmt7+zsQ6RYxRIR3p3QSPXVwyYuo8gZSB
	4IRgr2h3vyqvtrGFQbDfuLgRHfUuN9M=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-252-njBVuFgQMiuC3IL1T4ZPuQ-1; Wed, 30 Nov 2022 04:13:48 -0500
X-MC-Unique: njBVuFgQMiuC3IL1T4ZPuQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5A246299E76B;
	Wed, 30 Nov 2022 09:13:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E8C75492B04;
	Wed, 30 Nov 2022 09:13:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 93BA919465A2;
	Wed, 30 Nov 2022 09:13:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3E8EA19465A2
 for <dm-devel@listman.corp.redhat.com>; Wed, 30 Nov 2022 09:13:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2FAF01121320; Wed, 30 Nov 2022 09:13:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2793C1121314
 for <dm-devel@redhat.com>; Wed, 30 Nov 2022 09:13:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 08ABB85A588
 for <dm-devel@redhat.com>; Wed, 30 Nov 2022 09:13:38 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com
 [45.249.212.187]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-241-R1N7C5oPO3mLXPbupu7bfA-1; Wed, 30 Nov 2022 04:13:33 -0500
X-MC-Unique: R1N7C5oPO3mLXPbupu7bfA-1
Received: from kwepemi500002.china.huawei.com (unknown [172.30.72.57])
 by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NMYQ86ptSzmWMm;
 Wed, 30 Nov 2022 17:12:48 +0800 (CST)
Received: from [10.174.179.167] (10.174.179.167) by
 kwepemi500002.china.huawei.com (7.221.188.171) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 30 Nov 2022 17:13:28 +0800
Message-ID: <ea94d029-a5a8-7498-2254-a980fb764935@huawei.com>
Date: Wed, 30 Nov 2022 17:13:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
From: miaoguanqin <miaoguanqin@huawei.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski
 <bmarzins@redhat.com>, Martin Wilck <mwilck@suse.com>, dm-devel mailing list
 <dm-devel@redhat.com>
References: <feab383d-f3fa-fb8d-caf2-10830757522b@huawei.com>
In-Reply-To: <feab383d-f3fa-fb8d-caf2-10830757522b@huawei.com>
X-Originating-IP: [10.174.179.167]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemi500002.china.huawei.com (7.221.188.171)
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
Cc: linfeilong <linfeilong@huawei.com>, lixiaokeng@huawei.com,
 "liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

cGluZwoKT24gMjAyMi8xMS8yNSA5OjI2LCBtaWFvZ3VhbnFpbiB3cm90ZToKPiBVc2VycyBtYXkg
ZmFpbCB0byBleGVjdXRlIGNvbW1hbmQ6IG11bHRpcGF0aGQgYW5kIG1wYXRocGVyc2lzdC4KPiAK
PiBXaGVuIHdlIGV4ZWN1dGUgdGhlIGNvbW1hbmQgbXBhdGhwZXJzaXN077yaCj4gbXBhdGhwZXJz
aXN0IC0tb3V0IC0tcmVnaXN0ZXIgLS1wYXJhbS1zYXJrPTEyMyAtLXByb3V0LXR5cGU9NSAKPiAv
ZGV2L21hcHBlci9tcGF0aGIKPiBJdCByZXR1cm4gYW4gZXJyb3IgOiBNaXNzaW5nIGFyZ3VlbWVu
dC4gVGhlIHByZWNlZGluZyBjb21tYW5kIGNhbGxzIHRoZSAKPiBmdW5jdGlvbgo+IGNsaV9zZXRw
cmtleSwgd2hpY2ggaXMgY2FsbGVkIGJ5IGNoZWNraW5nIHdoZXRoZXIgdGhlIGhhbmRsZSB2YWx1
ZXMgYXJlIAo+IGNvbnNpc3RlbnQKPiB3aXRoIHRoZSBjb21tYW5kIGlucHV0LiBDVkUtMjAyMi00
MTk3NCBjaGFuZ2VkIHRoZSBoYW5kbGVyIHZhbHVlIG9mIAo+IGZ1bmN0aW9uIGFuZAo+IGNoYW5n
ZWQgdGhlIG1vZGUgb2YgY2FsY3VsYXRpbmcgaGFuZGxlLsKgIFRoZSBoYW5kbGVyIHZhbHVlIGlz
IG5vdCBlcXVhbCAKPiB0byB0aGUKPiBjb21tYW5kIGlucHV0LCBjYXVzaW5nIG11bHRpcGF0aGQg
Y2FuIG5vdCBleGVjdXRlIHRoZSB0cnVlIGZ1bmNpb24uIEl0IAo+IGNvdWxkIGJlCj4gYW4gc2Ft
ZSBlcnJvciBmb3IgZXhlY3V0aW5nIG11bHRpcGF0aGQgYnkgdGhlIG9sZCBtb2RlLgo+IAo+IG11
bHRpcGF0aGQgaW52b2tlcyB0aGUgY29ycmVzcG9uZGluZyBmdW5jdGlvbiBiYXNlZCBvbiB0aGUg
aGFuZGxlIHZhbHVlLgo+IENWRS0yMDIyLTQxOTY0IGNoYW5nZWQgdGhlIG1ldGhvZCBvZiBjYWxj
dWxhdGluZyBoYW5kbGVyIHZhbHVlLiBNb2RpZnkgCj4gdGhlIGhhbmRsZQo+IHZhbHVlIHNvIHRo
YXQgdGhlIGNvcnJlc3BvbmRpbmcgZnVuY3Rpb24gY2FuIGJlIGNvcnJlY3RseSBleGVjdXRlLgo+
IAo+IFNpZ25lZC1vZmYtYnk6IG1pYW9ndWFucWluIDxtaWFvZ3VhbnFpbkBodWF3ZWkuY29tPgo+
IFNpZ25lZC1vZmYtYnk6IGxpeGlhb2tlbmcgPGxpeGlhb2tlbmdAaHVhd2VpLmNvbT4KPiAtLS0K
PiAgwqBtdWx0aXBhdGhkL2NhbGxiYWNrcy5jIHwgMTggKysrKysrKysrLS0tLS0tLS0tCj4gIMKg
bXVsdGlwYXRoZC9jbGkuaMKgwqDCoMKgwqDCoCB8wqAgOSArKysrKysrKy0KPiAgwqAyIGZpbGVz
IGNoYW5nZWQsIDE3IGluc2VydGlvbnMoKyksIDEwIGRlbGV0aW9ucygtKQo+IAo+IGRpZmYgLS1n
aXQgYS9tdWx0aXBhdGhkL2NhbGxiYWNrcy5jIGIvbXVsdGlwYXRoZC9jYWxsYmFja3MuYwo+IGlu
ZGV4IGZiODdiMjgwLi5mMzI2NjZiZSAxMDA2NDQKPiAtLS0gYS9tdWx0aXBhdGhkL2NhbGxiYWNr
cy5jCj4gKysrIGIvbXVsdGlwYXRoZC9jYWxsYmFja3MuYwo+IEBAIC01NywxNiArNTcsMTYgQEAg
dm9pZCBpbml0X2hhbmRsZXJfY2FsbGJhY2tzKHZvaWQpCj4gIMKgwqDCoMKgIHNldF9oYW5kbGVy
X2NhbGxiYWNrKFZSQl9SRVNUT1JFUSB8IFExX01BUFMsIAo+IEhBTkRMRVIoY2xpX3Jlc3RvcmVf
YWxsX3F1ZXVlaW5nKSk7Cj4gIMKgwqDCoMKgIHNldF91bmxvY2tlZF9oYW5kbGVyX2NhbGxiYWNr
KFZSQl9RVUlULCBIQU5ETEVSKGNsaV9xdWl0KSk7Cj4gIMKgwqDCoMKgIHNldF91bmxvY2tlZF9o
YW5kbGVyX2NhbGxiYWNrKFZSQl9TSFVURE9XTiwgSEFORExFUihjbGlfc2h1dGRvd24pKTsKPiAt
wqDCoMKgIHNldF9oYW5kbGVyX2NhbGxiYWNrKFZSQl9HRVRQUlNUQVRVUyB8IFExX01BUCwgCj4g
SEFORExFUihjbGlfZ2V0cHJzdGF0dXMpKTsKPiAtwqDCoMKgIHNldF9oYW5kbGVyX2NhbGxiYWNr
KFZSQl9TRVRQUlNUQVRVUyB8IFExX01BUCwgCj4gSEFORExFUihjbGlfc2V0cHJzdGF0dXMpKTsK
PiAtwqDCoMKgIHNldF9oYW5kbGVyX2NhbGxiYWNrKFZSQl9VTlNFVFBSU1RBVFVTIHwgUTFfTUFQ
LCAKPiBIQU5ETEVSKGNsaV91bnNldHByc3RhdHVzKSk7Cj4gK8KgwqDCoCBzZXRfaGFuZGxlcl9j
YWxsYmFjayhLRVlfTUFQIHwgUTFfR0VUUFJTVEFUVVMsIAo+IEhBTkRMRVIoY2xpX2dldHByc3Rh
dHVzKSk7Cj4gK8KgwqDCoCBzZXRfaGFuZGxlcl9jYWxsYmFjayhLRVlfTUFQIHwgUTFfU0VUU1RB
VFVTLCAKPiBIQU5ETEVSKGNsaV9zZXRwcnN0YXR1cykpOwo+ICvCoMKgwqAgc2V0X2hhbmRsZXJf
Y2FsbGJhY2soS0VZX01BUCB8IFExX1VOU0VUU1RBVFVTLCAKPiBIQU5ETEVSKGNsaV91bnNldHBy
c3RhdHVzKSk7Cj4gIMKgwqDCoMKgIHNldF9oYW5kbGVyX2NhbGxiYWNrKFZSQl9GT1JDRVEgfCBR
MV9EQUVNT04sIAo+IEhBTkRMRVIoY2xpX2ZvcmNlX25vX2RhZW1vbl9xKSk7Cj4gIMKgwqDCoMKg
IHNldF9oYW5kbGVyX2NhbGxiYWNrKFZSQl9SRVNUT1JFUSB8IFExX0RBRU1PTiwgCj4gSEFORExF
UihjbGlfcmVzdG9yZV9ub19kYWVtb25fcSkpOwo+IC3CoMKgwqAgc2V0X2hhbmRsZXJfY2FsbGJh
Y2soVlJCX0dFVFBSS0VZIHwgUTFfTUFQLCBIQU5ETEVSKGNsaV9nZXRwcmtleSkpOwo+IC3CoMKg
wqAgc2V0X2hhbmRsZXJfY2FsbGJhY2soVlJCX1NFVFBSS0VZIHwgUTFfTUFQIHwgUTJfS0VZLCAK
PiBIQU5ETEVSKGNsaV9zZXRwcmtleSkpOwo+IC3CoMKgwqAgc2V0X2hhbmRsZXJfY2FsbGJhY2so
VlJCX1VOU0VUUFJLRVkgfCBRMV9NQVAsIAo+IEhBTkRMRVIoY2xpX3Vuc2V0cHJrZXkpKTsKPiAt
wqDCoMKgIHNldF9oYW5kbGVyX2NhbGxiYWNrKFZSQl9TRVRNQVJHSU5BTCB8IFExX1BBVEgsIAo+
IEhBTkRMRVIoY2xpX3NldF9tYXJnaW5hbCkpOwo+IC3CoMKgwqAgc2V0X2hhbmRsZXJfY2FsbGJh
Y2soVlJCX1VOU0VUTUFSR0lOQUwgfCBRMV9QQVRILCAKPiBIQU5ETEVSKGNsaV91bnNldF9tYXJn
aW5hbCkpOwo+IC3CoMKgwqAgc2V0X2hhbmRsZXJfY2FsbGJhY2soVlJCX1VOU0VUTUFSR0lOQUwg
fCBRMV9NQVAsCj4gK8KgwqDCoCBzZXRfaGFuZGxlcl9jYWxsYmFjayhLRVlfTUFQIHwgUTFfR0VU
UFJLRVksIEhBTkRMRVIoY2xpX2dldHBya2V5KSk7Cj4gK8KgwqDCoCBzZXRfaGFuZGxlcl9jYWxs
YmFjayhLRVlfTUFQIHwgUTFfU0VUS0VZIHwgUTJfS0VZLCAKPiBIQU5ETEVSKGNsaV9zZXRwcmtl
eSkpOwo+ICvCoMKgwqAgc2V0X2hhbmRsZXJfY2FsbGJhY2soS0VZX01BUCB8IFExX1VOU0VUS0VZ
LCBIQU5ETEVSKGNsaV91bnNldHBya2V5KSk7Cj4gK8KgwqDCoCBzZXRfaGFuZGxlcl9jYWxsYmFj
ayhLRVlfUEFUSCB8IFExX1NFVE1BUkdJTkFMLCAKPiBIQU5ETEVSKGNsaV9zZXRfbWFyZ2luYWwp
KTsKPiArwqDCoMKgIHNldF9oYW5kbGVyX2NhbGxiYWNrKEtFWV9QQVRIIHwgUTFfVU5TRVRNQVJH
SU5BTCwgCj4gSEFORExFUihjbGlfdW5zZXRfbWFyZ2luYWwpKTsKPiArwqDCoMKgIHNldF9oYW5k
bGVyX2NhbGxiYWNrKEtFWV9NQVAgfCBRMV9VTlNFVE1BUkdJTkFMLAo+ICDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIEhBTkRMRVIoY2xpX3Vuc2V0X2FsbF9tYXJnaW5hbCkpOwo+
ICDCoH0KPiBkaWZmIC0tZ2l0IGEvbXVsdGlwYXRoZC9jbGkuaCBiL211bHRpcGF0aGQvY2xpLmgK
PiBpbmRleCBjNmI3OWM5ZC4uMDhlZTVjOGQgMTAwNjQ0Cj4gLS0tIGEvbXVsdGlwYXRoZC9jbGku
aAo+ICsrKyBiL211bHRpcGF0aGQvY2xpLmgKPiBAQCAtODAsNyArODAsMTQgQEAgZW51bSB7Cj4g
IMKgwqDCoMKgIFExX0FMTMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgPSBLRVlfQUxMIDw8IDgsCj4g
IMKgwqDCoMKgIFExX0RBRU1PTsKgwqDCoMKgwqDCoMKgID0gS0VZX0RBRU1PTiA8PCA4LAo+ICDC
oMKgwqDCoCBRMV9TVEFUVVPCoMKgwqDCoMKgwqDCoCA9IEtFWV9TVEFUVVMgPDwgOCwKPiAtCj4g
K8KgwqDCoCBRMV9TRVRLRVnCoMKgwqDCoMKgwqDCoCA9IFZSQl9TRVRQUktFWSA8PCA4LAo+ICvC
oMKgwqAgUTFfVU5TRVRLRVnCoMKgwqDCoMKgwqDCoCA9IFZSQl9VTlNFVFBSS0VZIDw8IDgsCj4g
K8KgwqDCoCBRMV9TRVRTVEFUVVPCoMKgwqDCoMKgwqDCoCA9IFZSQl9TRVRQUlNUQVRVUyA8PCA4
LAo+ICvCoMKgwqAgUTFfVU5TRVRTVEFUVVPCoMKgwqDCoMKgwqDCoCA9IFZSQl9VTlNFVFBSU1RB
VFVTIDw8IDgsCj4gK8KgwqDCoCBRMV9HRVRQUlNUQVRVU8KgwqDCoMKgwqDCoMKgID0gVlJCX0dF
VFBSU1RBVFVTIDw8IDgsCj4gK8KgwqDCoCBRMV9HRVRQUktFWcKgwqDCoMKgwqDCoMKgID0gVlJC
X0dFVFBSS0VZIDw8IDgsCj4gK8KgwqDCoCBRMV9TRVRNQVJHSU5BTMKgwqDCoMKgwqDCoMKgID0g
VlJCX1NFVE1BUkdJTkFMIDw8IDgsCj4gK8KgwqDCoCBRMV9VTlNFVE1BUkdJTkFMwqDCoMKgID0g
VlJCX1VOU0VUTUFSR0lOQUwgPDwgOCwKPiAgwqDCoMKgwqAgLyogYnl0ZSAyOiBxdWFsaWZpZXIg
MiAqLwo+ICDCoMKgwqDCoCBRMl9GTVTCoMKgwqDCoMKgwqDCoMKgwqDCoMKgID0gS0VZX0ZNVCA8
PCAxNiwKPiAgwqDCoMKgwqAgUTJfUkFXwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCA9IEtFWV9SQVcg
PDwgMTYsCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRw
czovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

