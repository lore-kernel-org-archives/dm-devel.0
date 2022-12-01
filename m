Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1277CC47088
	for <dm-devel@archiver.kernel.org>; Thu,  1 Dec 2022 09:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669885914;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=aLAue2kPU3Esv9LkGCYg+AIDSbvTS2UtSWfgoUT+KvA=;
	b=UlJyfMiRPxjXhhO1hXOCKtMCqBrkXHhpjhIYeS9dVtBA8WwrvNNOjWq/heU8i0VanRWucQ
	EbB0TCLVV3dff7Blejj5Ry5couM3Dv6idNztGXAuCArTVbl4CNY2GOEh4VKopg8IXf1mWw
	i5LR4923LrlbK0IOp2k24147BGB+Q8c=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-467-eOusNaHTOH6wMBe1tkw5rw-1; Thu, 01 Dec 2022 04:11:51 -0500
X-MC-Unique: eOusNaHTOH6wMBe1tkw5rw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 968933817966;
	Thu,  1 Dec 2022 09:11:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9066E492B0D;
	Thu,  1 Dec 2022 09:11:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 52DE919465A8;
	Thu,  1 Dec 2022 09:11:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A0B8C19465A0
 for <dm-devel@listman.corp.redhat.com>; Thu,  1 Dec 2022 09:11:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1B10F40C83EE; Thu,  1 Dec 2022 09:11:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1389B400EA8E
 for <dm-devel@redhat.com>; Thu,  1 Dec 2022 09:11:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E531A3C0E449
 for <dm-devel@redhat.com>; Thu,  1 Dec 2022 09:11:43 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-371-Vh4y9dWFOWiuAieuPC_WVg-1; Thu,
 01 Dec 2022 04:11:42 -0500
X-MC-Unique: Vh4y9dWFOWiuAieuPC_WVg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 6335C21B13;
 Thu,  1 Dec 2022 09:11:40 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 22D0313B4A;
 Thu,  1 Dec 2022 09:11:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id HMECB8xviGNzJgAAMHmgww
 (envelope-from <mwilck@suse.com>); Thu, 01 Dec 2022 09:11:40 +0000
Message-ID: <e8c58e27647211fbb525358f59ffca3278f4f978.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: lixiaokeng <lixiaokeng@huawei.com>, Benjamin Marzinski
 <bmarzins@redhat.com>,  miaoguanqin <miaoguanqin@huawei.com>
Date: Thu, 01 Dec 2022 10:11:39 +0100
In-Reply-To: <04fc154b-0510-ddd5-0880-ccc4c7bb21bb@huawei.com>
References: <feab383d-f3fa-fb8d-caf2-10830757522b@huawei.com>
 <ea94d029-a5a8-7498-2254-a980fb764935@huawei.com>
 <20221130160454.GZ19568@octiron.msp.redhat.com>
 <04fc154b-0510-ddd5-0880-ccc4c7bb21bb@huawei.com>
User-Agent: Evolution 3.46.1
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
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
 dm-devel mailing list <dm-devel@redhat.com>,
 "liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVGh1LCAyMDIyLTEyLTAxIGF0IDE1OjMwICswODAwLCBsaXhpYW9rZW5nIHdyb3RlOgo+IEJl
Zm9yZSB3ZSBhcHBseSBmODEyNDY2ZiAoIm11bHRpcGF0aGQ6IG1vcmUgcm9idXN0IGNvbW1hbmQg
cGFyc2luZyIpLAo+IG11bHRpcGF0aGQgaGVscCBzaG93czoKPiAuLi4KPiDCoG1hcHxtdWx0aXBh
dGggJG1hcCBnZXRwcnN0YXR1cwo+IMKgbWFwfG11bHRpcGF0aCAkbWFwIHNldHByc3RhdHVzCj4g
wqBtYXB8bXVsdGlwYXRoICRtYXAgdW5zZXRwcnN0YXR1cwo+IMKgbWFwfG11bHRpcGF0aCAkbWFw
IGdldHBya2V5Cj4gwqBtYXB8bXVsdGlwYXRoICRtYXAgc2V0cHJrZXkga2V5ICRrZXkKPiDCoG1h
cHxtdWx0aXBhdGggJG1hcCB1bnNldHBya2V5Cj4gwqBmb3JjZXF1ZXVlaW5nIGRhZW1vbgo+IMKg
cmVzdG9yZXF1ZXVlaW5nIGRhZW1vbgo+IMKgcGF0aCAkcGF0aCBzZXRtYXJnaW5hbAo+IMKgcGF0
aCAkcGF0aCB1bnNldG1hcmdpbmFsCj4gwqBtYXB8bXVsdGlwYXRoICRtYXAgdW5zZXRtYXJnaW5h
bAo+IAo+IFdlIHRoaW5rIGl0IGlzIGJldHRlciB0byBrZWVwIHRoaXMgY29uc2lzdGVudCwgc28g
d2UgZml4IGl0Cj4gYXMgdGhpcyBwYXRjaC4gQmVzaWRlcyB0aGF0LCB3ZSBhbHNvIGNoYW5nZSAi
Z2V0cHJzdGF0dXMnCj4gImdldHBya2V5IiAic2V0bWFyZ2luYWwiICJ1bnNldG1hcmdpbmFsIiBv
cmRlcnMgdG8ga2VlcAo+IGNvbnNpc3RlbnQgYW5kIGF2b2lkIHNhbWUgcHJvYmxlbSBpZiB1c2Vy
cyB1c2UgIm11bHRpcGF0aGQKPiB4eHgiIChsaWtlIGdldHBya2V5KS4KClllcywgaXQncyB1bmZv
cnR1bmF0ZSB0aGF0IHRoZSBjdXJyZW50IGJlaGF2aW9yIGRvZXNuJ3QgY29tcGx5IHdpdGggdGhl
Cm9sZCBoZWxwIHRleHQuIEJ1dCBJIGRpc2FncmVlIHRoYXQgdGhpcyBzaG91bGQgYmUgImZpeGVk
IiBpbiB0aGUKY3VycmVudCBjb2RlLiBUaGUgb2xkIHN5bnRheCB3YXMgYXJndWFibHkgaW5jb25z
aXN0ZW50LiBXZSBub3cgaGF2ZSBhCnZlcnkgY29uc2lzdGVudCBjb21tYW5kIHN0cnVjdHVyZSB3
aXRoIGEgdmVyYiBmb2xsb3dlZCBieSBhcmd1bWVudHMsCmFuZCB3ZSBzaG91bGQga2VlcCBpdCBh
dCB0aGF0LCBldmVuIGlmIGl0IG1lYW5zIHRoYXQgc29tZSBzY3JpcHRzIG5lZWQKdG8gYmUgYWRh
cHRlZC4KClRoZXJlZm9yZSBJIHN1cHBvcnQgQmVuJ3MgYXBwcm9hY2guCgpNYXJ0aW4KCgoKPiAK
PiBPbiAyMDIyLzEyLzEgMDowNCwgQmVuamFtaW4gTWFyemluc2tpIHdyb3RlOgo+ID4gT24gV2Vk
LCBOb3YgMzAsIDIwMjIgYXQgMDU6MTM6MjhQTSArMDgwMCwgbWlhb2d1YW5xaW4gd3JvdGU6Cj4g
PiA+IHBpbmcKPiA+IAo+ID4gSSBmaXhlZCB0aGlzIGlzc3VlIGEgZGlmZmVyZW50IHdheS4gUHJl
dmlvdXNseSB3ZSBhY2NlcHRlZCBhbnkKPiA+IG9yZGVyaW5nCj4gPiBvZiBrZXl3b3JkcywgYnV0
IHdlIGhhdmUgYWx3YXlzIGFkdmVydGlzZWQgYSBzcGVjaWZpYyBvcmRlciBpbiB0aGUKPiA+IENM
SQo+ID4gY29tbWFuZHMgcmVmZXJlbmNlICh0byBzZWUgaXQsIGp1c3QgcnVuICJtdWxpdHBhdGhk
IGhlbHAiIG9yIHVzZQo+ID4gYW55Cj4gPiBvdGhlciBpbnZhbGlkIGtleXdvcmQpLiBUaGUgY29t
bWFuZCB3b3JkIGlzIGZpcnN0IGFuZCB0aGUgYXJndW1lbnRzCj4gPiBmb2xsb3cuwqAgSSB0aGlu
ayB3ZSBzaG91bGQga2VlcCB0aGlzIGNvbnNpc3RlbnQsIGFuZCBJIGRvbid0IHRoaW5rCj4gPiB3
ZQo+ID4gc2hvdWxkIGdvIGNoYW5naW5nIHRoZSBvcmRlciBvZiBleGlzdGluZyBjb21tYW5kcy4g
SW5zdGVhZCwgbXkKPiA+IHBhdGNoCj4gPiBtYWtlcyBsaWJtcGF0aHBlcnNpc3QgaXNzdWUgY29t
bWFuZHMgaW4gdGhlIGNvcnJlY3Qgb3JkZXIuIENvdWxkCj4gPiB5b3UKPiA+IGxvb2sgYXQ6Cj4g
PiAKPiA+IFtkbS1kZXZlbF0gW1BBVENIIDIvMl0gbGlibXBhdGhwZXJzaXN0OiBmaXggY29tbWFu
ZCBrZXl3b3JkCj4gPiBvcmRlcmluZwo+ID4gaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vYXJj
aGl2ZXMvZG0tZGV2ZWwvMjAyMi1Ob3ZlbWJlci8wNTI3NzMuaHRtbAo+ID4gCj4gPiBhbmQgc2Vl
IGlmIHRoYXQgc29sdmVzIHlvdXIgaXNzdWUuCj4gPiAKPiA+IC1CZW4KPiA+IAo+ID4gPiAKPiA+
ID4gT24gMjAyMi8xMS8yNSA5OjI2LCBtaWFvZ3VhbnFpbiB3cm90ZToKPiA+ID4gPiBVc2VycyBt
YXkgZmFpbCB0byBleGVjdXRlIGNvbW1hbmQ6IG11bHRpcGF0aGQgYW5kIG1wYXRocGVyc2lzdC4K
PiA+ID4gPiAKPiA+ID4gPiBXaGVuIHdlIGV4ZWN1dGUgdGhlIGNvbW1hbmQgbXBhdGhwZXJzaXN0
77yaCj4gPiA+ID4gbXBhdGhwZXJzaXN0IC0tb3V0IC0tcmVnaXN0ZXIgLS1wYXJhbS1zYXJrPTEy
MyAtLXByb3V0LXR5cGU9NQo+ID4gPiA+IC9kZXYvbWFwcGVyL21wYXRoYgo+ID4gPiA+IEl0IHJl
dHVybiBhbiBlcnJvciA6IE1pc3NpbmcgYXJndWVtZW50LiBUaGUgcHJlY2VkaW5nIGNvbW1hbmQK
PiA+ID4gPiBjYWxscyB0aGUKPiA+ID4gPiBmdW5jdGlvbgo+ID4gPiA+IGNsaV9zZXRwcmtleSwg
d2hpY2ggaXMgY2FsbGVkIGJ5IGNoZWNraW5nIHdoZXRoZXIgdGhlIGhhbmRsZQo+ID4gPiA+IHZh
bHVlcyBhcmUKPiA+ID4gPiBjb25zaXN0ZW50Cj4gPiA+ID4gd2l0aCB0aGUgY29tbWFuZCBpbnB1
dC4gQ1ZFLTIwMjItNDE5NzQgY2hhbmdlZCB0aGUgaGFuZGxlcgo+ID4gPiA+IHZhbHVlIG9mCj4g
PiA+ID4gZnVuY3Rpb24gYW5kCj4gPiA+ID4gY2hhbmdlZCB0aGUgbW9kZSBvZiBjYWxjdWxhdGlu
ZyBoYW5kbGUuwqAgVGhlIGhhbmRsZXIgdmFsdWUgaXMKPiA+ID4gPiBub3QgZXF1YWwgdG8KPiA+
ID4gPiB0aGUKPiA+ID4gPiBjb21tYW5kIGlucHV0LCBjYXVzaW5nIG11bHRpcGF0aGQgY2FuIG5v
dCBleGVjdXRlIHRoZSB0cnVlCj4gPiA+ID4gZnVuY2lvbi4gSXQKPiA+ID4gPiBjb3VsZCBiZQo+
ID4gPiA+IGFuIHNhbWUgZXJyb3IgZm9yIGV4ZWN1dGluZyBtdWx0aXBhdGhkIGJ5IHRoZSBvbGQg
bW9kZS4KPiA+ID4gPiAKPiA+ID4gPiBtdWx0aXBhdGhkIGludm9rZXMgdGhlIGNvcnJlc3BvbmRp
bmcgZnVuY3Rpb24gYmFzZWQgb24gdGhlCj4gPiA+ID4gaGFuZGxlIHZhbHVlLgo+ID4gPiA+IENW
RS0yMDIyLTQxOTY0IGNoYW5nZWQgdGhlIG1ldGhvZCBvZiBjYWxjdWxhdGluZyBoYW5kbGVyIHZh
bHVlLgo+ID4gPiA+IE1vZGlmeSB0aGUKPiA+ID4gPiBoYW5kbGUKPiA+ID4gPiB2YWx1ZSBzbyB0
aGF0IHRoZSBjb3JyZXNwb25kaW5nIGZ1bmN0aW9uIGNhbiBiZSBjb3JyZWN0bHkKPiA+ID4gPiBl
eGVjdXRlLgo+ID4gPiA+IAo+ID4gPiA+IFNpZ25lZC1vZmYtYnk6IG1pYW9ndWFucWluIDxtaWFv
Z3VhbnFpbkBodWF3ZWkuY29tPgo+ID4gPiA+IFNpZ25lZC1vZmYtYnk6IGxpeGlhb2tlbmcgPGxp
eGlhb2tlbmdAaHVhd2VpLmNvbT4KPiA+ID4gPiAtLS0KPiA+ID4gPiDCoG11bHRpcGF0aGQvY2Fs
bGJhY2tzLmMgfCAxOCArKysrKysrKystLS0tLS0tLS0KPiA+ID4gPiDCoG11bHRpcGF0aGQvY2xp
LmjCoMKgwqDCoMKgwqAgfMKgIDkgKysrKysrKystCj4gPiA+ID4gwqAyIGZpbGVzIGNoYW5nZWQs
IDE3IGluc2VydGlvbnMoKyksIDEwIGRlbGV0aW9ucygtKQo+ID4gPiA+IAo+ID4gPiA+IGRpZmYg
LS1naXQgYS9tdWx0aXBhdGhkL2NhbGxiYWNrcy5jIGIvbXVsdGlwYXRoZC9jYWxsYmFja3MuYwo+
ID4gPiA+IGluZGV4IGZiODdiMjgwLi5mMzI2NjZiZSAxMDA2NDQKPiA+ID4gPiAtLS0gYS9tdWx0
aXBhdGhkL2NhbGxiYWNrcy5jCj4gPiA+ID4gKysrIGIvbXVsdGlwYXRoZC9jYWxsYmFja3MuYwo+
ID4gPiA+IEBAIC01NywxNiArNTcsMTYgQEAgdm9pZCBpbml0X2hhbmRsZXJfY2FsbGJhY2tzKHZv
aWQpCj4gPiA+ID4gwqDCoMKgwqAgc2V0X2hhbmRsZXJfY2FsbGJhY2soVlJCX1JFU1RPUkVRIHwg
UTFfTUFQUywKPiA+ID4gPiBIQU5ETEVSKGNsaV9yZXN0b3JlX2FsbF9xdWV1ZWluZykpOwo+ID4g
PiA+IMKgwqDCoMKgIHNldF91bmxvY2tlZF9oYW5kbGVyX2NhbGxiYWNrKFZSQl9RVUlULAo+ID4g
PiA+IEhBTkRMRVIoY2xpX3F1aXQpKTsKPiA+ID4gPiDCoMKgwqDCoCBzZXRfdW5sb2NrZWRfaGFu
ZGxlcl9jYWxsYmFjayhWUkJfU0hVVERPV04sCj4gPiA+ID4gSEFORExFUihjbGlfc2h1dGRvd24p
KTsKPiA+ID4gPiAtwqDCoMKgIHNldF9oYW5kbGVyX2NhbGxiYWNrKFZSQl9HRVRQUlNUQVRVUyB8
IFExX01BUCwKPiA+ID4gPiBIQU5ETEVSKGNsaV9nZXRwcnN0YXR1cykpOwo+ID4gPiA+IC3CoMKg
wqAgc2V0X2hhbmRsZXJfY2FsbGJhY2soVlJCX1NFVFBSU1RBVFVTIHwgUTFfTUFQLAo+ID4gPiA+
IEhBTkRMRVIoY2xpX3NldHByc3RhdHVzKSk7Cj4gPiA+ID4gLcKgwqDCoCBzZXRfaGFuZGxlcl9j
YWxsYmFjayhWUkJfVU5TRVRQUlNUQVRVUyB8IFExX01BUCwKPiA+ID4gPiBIQU5ETEVSKGNsaV91
bnNldHByc3RhdHVzKSk7Cj4gPiA+ID4gK8KgwqDCoCBzZXRfaGFuZGxlcl9jYWxsYmFjayhLRVlf
TUFQIHwgUTFfR0VUUFJTVEFUVVMsCj4gPiA+ID4gSEFORExFUihjbGlfZ2V0cHJzdGF0dXMpKTsK
PiA+ID4gPiArwqDCoMKgIHNldF9oYW5kbGVyX2NhbGxiYWNrKEtFWV9NQVAgfCBRMV9TRVRTVEFU
VVMsCj4gPiA+ID4gSEFORExFUihjbGlfc2V0cHJzdGF0dXMpKTsKPiA+ID4gPiArwqDCoMKgIHNl
dF9oYW5kbGVyX2NhbGxiYWNrKEtFWV9NQVAgfCBRMV9VTlNFVFNUQVRVUywKPiA+ID4gPiBIQU5E
TEVSKGNsaV91bnNldHByc3RhdHVzKSk7Cj4gPiA+ID4gwqDCoMKgwqAgc2V0X2hhbmRsZXJfY2Fs
bGJhY2soVlJCX0ZPUkNFUSB8IFExX0RBRU1PTiwKPiA+ID4gPiBIQU5ETEVSKGNsaV9mb3JjZV9u
b19kYWVtb25fcSkpOwo+ID4gPiA+IMKgwqDCoMKgIHNldF9oYW5kbGVyX2NhbGxiYWNrKFZSQl9S
RVNUT1JFUSB8IFExX0RBRU1PTiwKPiA+ID4gPiBIQU5ETEVSKGNsaV9yZXN0b3JlX25vX2RhZW1v
bl9xKSk7Cj4gPiA+ID4gLcKgwqDCoCBzZXRfaGFuZGxlcl9jYWxsYmFjayhWUkJfR0VUUFJLRVkg
fCBRMV9NQVAsCj4gPiA+ID4gSEFORExFUihjbGlfZ2V0cHJrZXkpKTsKPiA+ID4gPiAtwqDCoMKg
IHNldF9oYW5kbGVyX2NhbGxiYWNrKFZSQl9TRVRQUktFWSB8IFExX01BUCB8IFEyX0tFWSwKPiA+
ID4gPiBIQU5ETEVSKGNsaV9zZXRwcmtleSkpOwo+ID4gPiA+IC3CoMKgwqAgc2V0X2hhbmRsZXJf
Y2FsbGJhY2soVlJCX1VOU0VUUFJLRVkgfCBRMV9NQVAsCj4gPiA+ID4gSEFORExFUihjbGlfdW5z
ZXRwcmtleSkpOwo+ID4gPiA+IC3CoMKgwqAgc2V0X2hhbmRsZXJfY2FsbGJhY2soVlJCX1NFVE1B
UkdJTkFMIHwgUTFfUEFUSCwKPiA+ID4gPiBIQU5ETEVSKGNsaV9zZXRfbWFyZ2luYWwpKTsKPiA+
ID4gPiAtwqDCoMKgIHNldF9oYW5kbGVyX2NhbGxiYWNrKFZSQl9VTlNFVE1BUkdJTkFMIHwgUTFf
UEFUSCwKPiA+ID4gPiBIQU5ETEVSKGNsaV91bnNldF9tYXJnaW5hbCkpOwo+ID4gPiA+IC3CoMKg
wqAgc2V0X2hhbmRsZXJfY2FsbGJhY2soVlJCX1VOU0VUTUFSR0lOQUwgfCBRMV9NQVAsCj4gPiA+
ID4gK8KgwqDCoCBzZXRfaGFuZGxlcl9jYWxsYmFjayhLRVlfTUFQIHwgUTFfR0VUUFJLRVksCj4g
PiA+ID4gSEFORExFUihjbGlfZ2V0cHJrZXkpKTsKPiA+ID4gPiArwqDCoMKgIHNldF9oYW5kbGVy
X2NhbGxiYWNrKEtFWV9NQVAgfCBRMV9TRVRLRVkgfCBRMl9LRVksCj4gPiA+ID4gSEFORExFUihj
bGlfc2V0cHJrZXkpKTsKPiA+ID4gPiArwqDCoMKgIHNldF9oYW5kbGVyX2NhbGxiYWNrKEtFWV9N
QVAgfCBRMV9VTlNFVEtFWSwKPiA+ID4gPiBIQU5ETEVSKGNsaV91bnNldHBya2V5KSk7Cj4gPiA+
ID4gK8KgwqDCoCBzZXRfaGFuZGxlcl9jYWxsYmFjayhLRVlfUEFUSCB8IFExX1NFVE1BUkdJTkFM
LAo+ID4gPiA+IEhBTkRMRVIoY2xpX3NldF9tYXJnaW5hbCkpOwo+ID4gPiA+ICvCoMKgwqAgc2V0
X2hhbmRsZXJfY2FsbGJhY2soS0VZX1BBVEggfCBRMV9VTlNFVE1BUkdJTkFMLAo+ID4gPiA+IEhB
TkRMRVIoY2xpX3Vuc2V0X21hcmdpbmFsKSk7Cj4gPiA+ID4gK8KgwqDCoCBzZXRfaGFuZGxlcl9j
YWxsYmFjayhLRVlfTUFQIHwgUTFfVU5TRVRNQVJHSU5BTCwKPiA+ID4gPiDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIEhBTkRMRVIoY2xpX3Vuc2V0X2FsbF9tYXJnaW5hbCkpOwo+
ID4gPiA+IMKgfQo+ID4gPiA+IGRpZmYgLS1naXQgYS9tdWx0aXBhdGhkL2NsaS5oIGIvbXVsdGlw
YXRoZC9jbGkuaAo+ID4gPiA+IGluZGV4IGM2Yjc5YzlkLi4wOGVlNWM4ZCAxMDA2NDQKPiA+ID4g
PiAtLS0gYS9tdWx0aXBhdGhkL2NsaS5oCj4gPiA+ID4gKysrIGIvbXVsdGlwYXRoZC9jbGkuaAo+
ID4gPiA+IEBAIC04MCw3ICs4MCwxNCBAQCBlbnVtIHsKPiA+ID4gPiDCoMKgwqDCoCBRMV9BTEzC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgID0gS0VZX0FMTCA8PCA4LAo+ID4gPiA+IMKgwqDCoMKgIFEx
X0RBRU1PTsKgwqDCoMKgwqDCoMKgID0gS0VZX0RBRU1PTiA8PCA4LAo+ID4gPiA+IMKgwqDCoMKg
IFExX1NUQVRVU8KgwqDCoMKgwqDCoMKgID0gS0VZX1NUQVRVUyA8PCA4LAo+ID4gPiA+IC0KPiA+
ID4gPiArwqDCoMKgIFExX1NFVEtFWcKgwqDCoMKgwqDCoMKgID0gVlJCX1NFVFBSS0VZIDw8IDgs
Cj4gPiA+ID4gK8KgwqDCoCBRMV9VTlNFVEtFWcKgwqDCoMKgwqDCoMKgID0gVlJCX1VOU0VUUFJL
RVkgPDwgOCwKPiA+ID4gPiArwqDCoMKgIFExX1NFVFNUQVRVU8KgwqDCoMKgwqDCoMKgID0gVlJC
X1NFVFBSU1RBVFVTIDw8IDgsCj4gPiA+ID4gK8KgwqDCoCBRMV9VTlNFVFNUQVRVU8KgwqDCoMKg
wqDCoMKgID0gVlJCX1VOU0VUUFJTVEFUVVMgPDwgOCwKPiA+ID4gPiArwqDCoMKgIFExX0dFVFBS
U1RBVFVTwqDCoMKgwqDCoMKgwqAgPSBWUkJfR0VUUFJTVEFUVVMgPDwgOCwKPiA+ID4gPiArwqDC
oMKgIFExX0dFVFBSS0VZwqDCoMKgwqDCoMKgwqAgPSBWUkJfR0VUUFJLRVkgPDwgOCwKPiA+ID4g
PiArwqDCoMKgIFExX1NFVE1BUkdJTkFMwqDCoMKgwqDCoMKgwqAgPSBWUkJfU0VUTUFSR0lOQUwg
PDwgOCwKPiA+ID4gPiArwqDCoMKgIFExX1VOU0VUTUFSR0lOQUzCoMKgwqAgPSBWUkJfVU5TRVRN
QVJHSU5BTCA8PCA4LAo+ID4gPiA+IMKgwqDCoMKgIC8qIGJ5dGUgMjogcXVhbGlmaWVyIDIgKi8K
PiA+ID4gPiDCoMKgwqDCoCBRMl9GTVTCoMKgwqDCoMKgwqDCoMKgwqDCoMKgID0gS0VZX0ZNVCA8
PCAxNiwKPiA+ID4gPiDCoMKgwqDCoCBRMl9SQVfCoMKgwqDCoMKgwqDCoMKgwqDCoMKgID0gS0VZ
X1JBVyA8PCAxNiwKPiA+IAo+ID4gLgo+ID4gCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0t
ZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3Rp
bmZvL2RtLWRldmVsCg==

