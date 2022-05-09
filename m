Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA35AC433F5
	for <dm-devel@archiver.kernel.org>; Mon,  9 May 2022 09:16:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-544-6YnZRhPIMkCIFkVYPZL92Q-1; Mon, 09 May 2022 05:16:09 -0400
X-MC-Unique: 6YnZRhPIMkCIFkVYPZL92Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A3A1E29AB3F8;
	Mon,  9 May 2022 09:16:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0DF60C27E80;
	Mon,  9 May 2022 09:16:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DC9431947052;
	Mon,  9 May 2022 09:16:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id ED6DF19466DF
 for <dm-devel@listman.corp.redhat.com>; Mon,  9 May 2022 09:16:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B93F7C27DB5; Mon,  9 May 2022 09:16:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B5479C15D7E
 for <dm-devel@redhat.com>; Mon,  9 May 2022 09:16:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9A1EF185A7A4
 for <dm-devel@redhat.com>; Mon,  9 May 2022 09:16:04 +0000 (UTC)
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de
 [85.215.255.53]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-172-7ABhTasiN0u1xYRb6XDL0Q-1; Mon, 09 May 2022 05:16:03 -0400
X-MC-Unique: 7ABhTasiN0u1xYRb6XDL0Q-1
X-RZG-AUTH: ":PHkGeUmrW+uCZmxs998QJRUX30nOwJd7j/79t2yVxcUdnYNcUb5wZPHWwAJ3XYfSj54="
X-RZG-CLASS-ID: mo00
Received: from [192.168.178.22] by smtp.strato.de (RZmta 47.42.2 DYNA|AUTH)
 with ESMTPSA id Y03eaey499CHTay
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
 (Client did not present a certificate);
 Mon, 9 May 2022 11:12:17 +0200 (CEST)
Message-ID: <8f8d7334-0812-7489-44a7-34c2bf0c9973@thson.de>
Date: Mon, 9 May 2022 11:12:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
To: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
 dm-devel@redhat.com, agk@redhat.com, snitzer@redhat.com
References: <20220106203436.281629-1-public@thson.de>
 <9fefc681-c8dd-0312-2d6b-ffe3fec05dcf@linux.microsoft.com>
From: Thore Sommer <public@thson.de>
In-Reply-To: <9fefc681-c8dd-0312-2d6b-ffe3fec05dcf@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [RFC PATCH 0/3] dm ima: allow targets to remeasure
 their state
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

SGkgTGFrc2htaSwKCnRoYW5rIHlvdSBmb3IgdGFraW5nIGEgY2xvc2VyIGxvb2sgYXQgdGhpcyBw
YXRjaCBzZXQuCgpPbiAwNi4wNS4yMiAyMjoxNiwgTGFrc2htaSBSYW1hc3VicmFtYW5pYW4gd3Jv
dGU6Cj4gSGkgVGhvcmUsCj4gCj4gT24gMS82LzIwMjIgMTI6MzQgUE0sIFRob3JlIFNvbW1lciB3
cm90ZToKPj4gVGhlIGN1cnJlbnQgRE0gSU1BIGV2ZW50cyBkbyBub3QgY292ZXIgdGhlIGNhc2Ug
d2hlcmUgYSBkZXZpY2UgY2hhbmdlcwo+PiB0aGVpciBhdHRyaWJ1dGVzIHRvIGluZGljYXRlIGEg
c3RhdGUgY2hhbmdlLiAKPiBJdCB3b3VsZCBiZSBnb29kIHRvIHN0YXRlIGhlcmUgd2hhdCBpc3N1
ZShzKSBhcmUgY2F1c2VkLCBpZiBhbnksIG9yIHdoYXQgCj4gZGF0YVxldmVudCB3ZSBtaWdodCBi
ZSBtaXNzaW5nIGFzIGEgcmVzdWx0IG9mIG5vdCBtZWFzdXJpbmcgdGhlIGRldmljZSAKPiBhdHRy
aWJ1dGUgY2hhbmdlcy4gQW5kLCB0aGVuIHN0YXRlIHRoZSBiZW5lZml0cyBvZiB0aGUgY2hhbmdl
cyB5b3UgaGF2ZSAKPiBpbXBsZW1lbnRlZCBpbiB0aGlzIHBhdGNoIHNlcmllcy4KClRoZSBleGlz
dGluZyBiZWhhdmlvciBvbmx5IG1lYXN1cmVzIHRoZSB0YWJsZSBjb250ZW50IG9uIHRhcmdldC9k
ZXZpY2UgCmNyZWF0aW9uLiBUaGlzIGlzIGZpbmUgZm9yIHRhcmdldHMgd2hlcmUgdGhlIHRhYmxl
IGNvbnRlbnQgbmV2ZXIgCmNoYW5nZXMsIGJ1dCBzb21lIHRhcmdldHMgbGlrZSB2ZXJpdHksIG11
bHRpcGF0aCBhbmQgcmFpZCBhbHNvIHVzZSB0aGUgCnRhYmxlIHRvIGluZGljYXRlIHN0YXRlIGNo
YW5nZXMuIFRob3NlIHN0YXRlIGNoYW5nZXMgYXJlIGN1cnJlbnRseSBub3QgCm1lYXN1cmVkIHZp
YSB0aGUgZGV2aWNlIG1hcHBlciBJTUEgaW50ZWdyYXRpb24uCgpNZWFzdXJpbmcgdGhlIHN0YXRl
IGNoYW5nZXMgZm9yIHZlcml0eSB0aGlzIGlzIGVzcGVjaWFsbHkgaW1wb3J0YW50IApiZWNhdXNl
IGFmdGVyIHRoZSBpbml0aWFsIGNyZWF0aW9uIHRoZSB0YXJnZXQgaXMgbmV2ZXIgY29ycnVwdGVk
IGFuZCAKb25seSBtYXJrZWQgYXMgc3VjaCB3aGVuIGEgY29ycnVwdGVkIGJsb2NrIHJlYWQuIFdl
IHdhbnQgdG8gbWVhc3VyZSB0aGF0IApjaGFuZ2UgdG8gcmVtb3RlbHkgYXR0ZXN0IHRoYXQgdGhl
IGNvcnJlY3QgZmlsZSBzeXN0ZW0gaXMgdXNlZCBhbmQgbm90IAp0YW1wZXJlZCB3aXRoLiBEb2lu
ZyB0aGF0IGlzIG5vdCBwb3NzaWJsZSB3aXRoIHRoZSBjdXJyZW50IGZlYXR1cmVzIGluIAp0aGUg
a2VybmVsLgoKPiBUaGlzIGFkZHMgYSBuZXcgZXZlbnQKPj4gKGRtX3RhcmdldF91cGRhdGUpIHdo
aWNoIGFsbG93cyB0YXJnZXRzIHRvIHJlbWVhc3VyZSB0aGVpciB0YWJsZSBlbnRyaWVzLgo+PiBU
aGUgZXZlbnQgaW5jbHVkZXMgdGhlIGRtIHZlcnNpb24sIGRldmljZSBtZXRhZGF0YSBhbmQgdGhl
IHRhcmdldCBkYXRhLgo+Pgo+PiBDdXJyZW50bHkgb25seSB2ZXJpdHkgc3VwcG9ydHMgdGhpcyBl
dmVudCB0byBlbnN1cmUgdGhhdCBkZXZpY2UgCj4+IGNvcnJ1cHRpb24KPj4gY2FuIGJlIGRldGVj
dGVkIHVzaW5nIElNQSB3aGljaCBpcyB1c2VmdWwgZm9yIHJlbW90ZSBhdHRlc3RhdGlvbi4KPiBV
c2luZyB0aGUgdGVybSAiY3VycmVudGx5IiBpbiB0aGlzIGNvbnRleHQgc2VlbXMgdG8gaW5kaWNh
dGUgdGhhdCB0aGlzIAo+IGlzIHRoZSBjdXJyZW50IHN0YXRlIChleGlzdGluZyBiZWhhdmlvcikg
aW4gdGhlIExpbnV4IGtlcm5lbCAKPiBpbXBsZW1lbnRhdGlvbi4gWW91IGNvdWxkIGluc3RlYWQg
cmV3b3JkIGl0IHRvIGluZGljYXRlIHRoYXQgeW91ciAKPiBwcm9wb3NlZCBtZWFzdXJlbWVudCBj
aGFuZ2UgaXMgdXNlZCBieSB2ZXJpdHkgdG8gYWRkIHN1cHBvcnQgZm9yIAo+IGRldGVjdGluZyBk
ZXZpY2UgY29ycnVwdGlvbi4KClllcyAiY3VycmVudGx5IiBpcyBjb25mdXNpbmcgaGVyZSwgSSB3
aWxsIGNoYW5nZSBpdCBpbiB2Mi4KClJlZ2FyZHMsClRob3JlCgoKPiAKPj4KPj4gVGhlIGN1cnJl
bnQgaW1wbGVtZW50YXRpb24gZG9lcyBub3QgdXBkYXRlIHRoZSBhY3RpdmUgdGFibGUgaGFzaCBi
ZWNhdXNlCj4+IGl0IHdvdWxkIHJlcXVpcmUgdG8gcmVoYXNoIHRoZSBlbnRpcmUgdGFibGUgb24g
ZXZlcnkgdGFyZ2V0IGNoYW5nZS4KPiBTaW1pbGFyIHRvIHRoZSBhYm92ZSBjb21tZW50IC0gY291
bGQgYmUgcmV3b3JkZWQgdG8gaW5kaWNhdGUgdGhpcyBpcyB0aGUgCj4gcHJvcG9zZWQgY2hhbmdl
IGFuZCBub3QgdGhlIGV4aXN0aW5nIGJlaGF2aW9yLgo+IAo+IHRoYW5rcywKPiAgwqAtbGFrc2ht
aQo+IAo+Pgo+PiBUaG9yZSBTb21tZXIgKDMpOgo+PiDCoMKgIGRtIGltYTogYWxsb3cgdGFyZ2V0
cyB0byByZW1lYXN1cmUgdGhlaXIgdGFibGUgZW50cnkKPj4gwqDCoCBkbSB2ZXJpdHk6IGFkZCBz
dXBwb3J0IGZvciBJTUEgdGFyZ2V0IHVwZGF0ZSBldmVudAo+PiDCoMKgIGRtIGltYTogYWRkIGRv
Y3VtZW50YXRpb24gdGFyZ2V0IHVwZGF0ZSBldmVudAo+Pgo+PiDCoCAuLi4vYWRtaW4tZ3VpZGUv
ZGV2aWNlLW1hcHBlci9kbS1pbWEucnN0wqDCoMKgwqDCoCB8IDMzICsrKysrKysrCj4+IMKgIGRy
aXZlcnMvbWQvZG0taW1hLmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIHwgNzYgKysrKysrKysrKysrKysrKysrKwo+PiDCoCBkcml2ZXJzL21kL2Rt
LWltYS5owqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCB8wqAgMiArCj4+IMKgIGRyaXZlcnMvbWQvZG0tdmVyaXR5LXRhcmdldC5jwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgfMKgIDYgKysKPj4gwqAgNCBmaWxlcyBjaGFuZ2VkLCAxMTcg
aW5zZXJ0aW9ucygrKQo+PgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhh
dC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZl
bAo=

