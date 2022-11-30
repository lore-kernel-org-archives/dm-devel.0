Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63A7BC433FE
	for <dm-devel@archiver.kernel.org>; Wed, 30 Nov 2022 16:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669826582;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=GtbwmghrG5FHKHCCTdruE2N+AXOubB+KXfIgwXnzE3Q=;
	b=VLk0/wi3nj1ErKODNVHAvp6s2oNo5VAjOvCNMqXo+ulqhzGkfnSEOQRaJ5K7i56g4ZSB16
	3hrPdGKSbyrHLmF5oxqnvpByyAp07IPSwmAWx3ixZ4S9lbcnbo1oT/a3QMeRjDCR9FkN7p
	cP9megRD8QqVadP2In7T5wkmUNc89ew=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-158-BAigQ8ZsMgCDGRxIWD879A-1; Wed, 30 Nov 2022 11:42:59 -0500
X-MC-Unique: BAigQ8ZsMgCDGRxIWD879A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 12D1229324A8;
	Wed, 30 Nov 2022 16:42:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AAD54422A9;
	Wed, 30 Nov 2022 16:42:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B1ED919465B3;
	Wed, 30 Nov 2022 16:42:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BAEC21946586
 for <dm-devel@listman.corp.redhat.com>; Wed, 30 Nov 2022 16:04:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AAE04492B10; Wed, 30 Nov 2022 16:04:57 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 85DC6492B04;
 Wed, 30 Nov 2022 16:04:57 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 2AUG4usY013481;
 Wed, 30 Nov 2022 10:04:56 -0600
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 2AUG4trC013480;
 Wed, 30 Nov 2022 10:04:55 -0600
Date: Wed, 30 Nov 2022 10:04:54 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: miaoguanqin <miaoguanqin@huawei.com>
Message-ID: <20221130160454.GZ19568@octiron.msp.redhat.com>
References: <feab383d-f3fa-fb8d-caf2-10830757522b@huawei.com>
 <ea94d029-a5a8-7498-2254-a980fb764935@huawei.com>
MIME-Version: 1.0
In-Reply-To: <ea94d029-a5a8-7498-2254-a980fb764935@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
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
Cc: lixiaokeng@huawei.com, "liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>,
 linfeilong <linfeilong@huawei.com>,
 dm-devel mailing list <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gV2VkLCBOb3YgMzAsIDIwMjIgYXQgMDU6MTM6MjhQTSArMDgwMCwgbWlhb2d1YW5xaW4gd3Jv
dGU6Cj4gcGluZwoKSSBmaXhlZCB0aGlzIGlzc3VlIGEgZGlmZmVyZW50IHdheS4gUHJldmlvdXNs
eSB3ZSBhY2NlcHRlZCBhbnkgb3JkZXJpbmcKb2Yga2V5d29yZHMsIGJ1dCB3ZSBoYXZlIGFsd2F5
cyBhZHZlcnRpc2VkIGEgc3BlY2lmaWMgb3JkZXIgaW4gdGhlIENMSQpjb21tYW5kcyByZWZlcmVu
Y2UgKHRvIHNlZSBpdCwganVzdCBydW4gIm11bGl0cGF0aGQgaGVscCIgb3IgdXNlIGFueQpvdGhl
ciBpbnZhbGlkIGtleXdvcmQpLiBUaGUgY29tbWFuZCB3b3JkIGlzIGZpcnN0IGFuZCB0aGUgYXJn
dW1lbnRzCmZvbGxvdy4gIEkgdGhpbmsgd2Ugc2hvdWxkIGtlZXAgdGhpcyBjb25zaXN0ZW50LCBh
bmQgSSBkb24ndCB0aGluayB3ZQpzaG91bGQgZ28gY2hhbmdpbmcgdGhlIG9yZGVyIG9mIGV4aXN0
aW5nIGNvbW1hbmRzLiBJbnN0ZWFkLCBteSBwYXRjaAptYWtlcyBsaWJtcGF0aHBlcnNpc3QgaXNz
dWUgY29tbWFuZHMgaW4gdGhlIGNvcnJlY3Qgb3JkZXIuIENvdWxkIHlvdQpsb29rIGF0OgoKW2Rt
LWRldmVsXSBbUEFUQ0ggMi8yXSBsaWJtcGF0aHBlcnNpc3Q6IGZpeCBjb21tYW5kIGtleXdvcmQg
b3JkZXJpbmcKaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vYXJjaGl2ZXMvZG0tZGV2ZWwvMjAy
Mi1Ob3ZlbWJlci8wNTI3NzMuaHRtbAoKYW5kIHNlZSBpZiB0aGF0IHNvbHZlcyB5b3VyIGlzc3Vl
LgoKLUJlbgoKPiAKPiBPbiAyMDIyLzExLzI1IDk6MjYsIG1pYW9ndWFucWluIHdyb3RlOgo+ID5V
c2VycyBtYXkgZmFpbCB0byBleGVjdXRlIGNvbW1hbmQ6IG11bHRpcGF0aGQgYW5kIG1wYXRocGVy
c2lzdC4KPiA+Cj4gPldoZW4gd2UgZXhlY3V0ZSB0aGUgY29tbWFuZCBtcGF0aHBlcnNpc3TvvJoK
PiA+bXBhdGhwZXJzaXN0IC0tb3V0IC0tcmVnaXN0ZXIgLS1wYXJhbS1zYXJrPTEyMyAtLXByb3V0
LXR5cGU9NQo+ID4vZGV2L21hcHBlci9tcGF0aGIKPiA+SXQgcmV0dXJuIGFuIGVycm9yIDogTWlz
c2luZyBhcmd1ZW1lbnQuIFRoZSBwcmVjZWRpbmcgY29tbWFuZCBjYWxscyB0aGUKPiA+ZnVuY3Rp
b24KPiA+Y2xpX3NldHBya2V5LCB3aGljaCBpcyBjYWxsZWQgYnkgY2hlY2tpbmcgd2hldGhlciB0
aGUgaGFuZGxlIHZhbHVlcyBhcmUKPiA+Y29uc2lzdGVudAo+ID53aXRoIHRoZSBjb21tYW5kIGlu
cHV0LiBDVkUtMjAyMi00MTk3NCBjaGFuZ2VkIHRoZSBoYW5kbGVyIHZhbHVlIG9mCj4gPmZ1bmN0
aW9uIGFuZAo+ID5jaGFuZ2VkIHRoZSBtb2RlIG9mIGNhbGN1bGF0aW5nIGhhbmRsZS7CoCBUaGUg
aGFuZGxlciB2YWx1ZSBpcyBub3QgZXF1YWwgdG8KPiA+dGhlCj4gPmNvbW1hbmQgaW5wdXQsIGNh
dXNpbmcgbXVsdGlwYXRoZCBjYW4gbm90IGV4ZWN1dGUgdGhlIHRydWUgZnVuY2lvbi4gSXQKPiA+
Y291bGQgYmUKPiA+YW4gc2FtZSBlcnJvciBmb3IgZXhlY3V0aW5nIG11bHRpcGF0aGQgYnkgdGhl
IG9sZCBtb2RlLgo+ID4KPiA+bXVsdGlwYXRoZCBpbnZva2VzIHRoZSBjb3JyZXNwb25kaW5nIGZ1
bmN0aW9uIGJhc2VkIG9uIHRoZSBoYW5kbGUgdmFsdWUuCj4gPkNWRS0yMDIyLTQxOTY0IGNoYW5n
ZWQgdGhlIG1ldGhvZCBvZiBjYWxjdWxhdGluZyBoYW5kbGVyIHZhbHVlLiBNb2RpZnkgdGhlCj4g
PmhhbmRsZQo+ID52YWx1ZSBzbyB0aGF0IHRoZSBjb3JyZXNwb25kaW5nIGZ1bmN0aW9uIGNhbiBi
ZSBjb3JyZWN0bHkgZXhlY3V0ZS4KPiA+Cj4gPlNpZ25lZC1vZmYtYnk6IG1pYW9ndWFucWluIDxt
aWFvZ3VhbnFpbkBodWF3ZWkuY29tPgo+ID5TaWduZWQtb2ZmLWJ5OiBsaXhpYW9rZW5nIDxsaXhp
YW9rZW5nQGh1YXdlaS5jb20+Cj4gPi0tLQo+ID4gwqBtdWx0aXBhdGhkL2NhbGxiYWNrcy5jIHwg
MTggKysrKysrKysrLS0tLS0tLS0tCj4gPiDCoG11bHRpcGF0aGQvY2xpLmjCoMKgwqDCoMKgwqAg
fMKgIDkgKysrKysrKystCj4gPiDCoDIgZmlsZXMgY2hhbmdlZCwgMTcgaW5zZXJ0aW9ucygrKSwg
MTAgZGVsZXRpb25zKC0pCj4gPgo+ID5kaWZmIC0tZ2l0IGEvbXVsdGlwYXRoZC9jYWxsYmFja3Mu
YyBiL211bHRpcGF0aGQvY2FsbGJhY2tzLmMKPiA+aW5kZXggZmI4N2IyODAuLmYzMjY2NmJlIDEw
MDY0NAo+ID4tLS0gYS9tdWx0aXBhdGhkL2NhbGxiYWNrcy5jCj4gPisrKyBiL211bHRpcGF0aGQv
Y2FsbGJhY2tzLmMKPiA+QEAgLTU3LDE2ICs1NywxNiBAQCB2b2lkIGluaXRfaGFuZGxlcl9jYWxs
YmFja3Modm9pZCkKPiA+IMKgwqDCoMKgIHNldF9oYW5kbGVyX2NhbGxiYWNrKFZSQl9SRVNUT1JF
USB8IFExX01BUFMsCj4gPkhBTkRMRVIoY2xpX3Jlc3RvcmVfYWxsX3F1ZXVlaW5nKSk7Cj4gPiDC
oMKgwqDCoCBzZXRfdW5sb2NrZWRfaGFuZGxlcl9jYWxsYmFjayhWUkJfUVVJVCwgSEFORExFUihj
bGlfcXVpdCkpOwo+ID4gwqDCoMKgwqAgc2V0X3VubG9ja2VkX2hhbmRsZXJfY2FsbGJhY2soVlJC
X1NIVVRET1dOLCBIQU5ETEVSKGNsaV9zaHV0ZG93bikpOwo+ID4twqDCoMKgIHNldF9oYW5kbGVy
X2NhbGxiYWNrKFZSQl9HRVRQUlNUQVRVUyB8IFExX01BUCwKPiA+SEFORExFUihjbGlfZ2V0cHJz
dGF0dXMpKTsKPiA+LcKgwqDCoCBzZXRfaGFuZGxlcl9jYWxsYmFjayhWUkJfU0VUUFJTVEFUVVMg
fCBRMV9NQVAsCj4gPkhBTkRMRVIoY2xpX3NldHByc3RhdHVzKSk7Cj4gPi3CoMKgwqAgc2V0X2hh
bmRsZXJfY2FsbGJhY2soVlJCX1VOU0VUUFJTVEFUVVMgfCBRMV9NQVAsCj4gPkhBTkRMRVIoY2xp
X3Vuc2V0cHJzdGF0dXMpKTsKPiA+K8KgwqDCoCBzZXRfaGFuZGxlcl9jYWxsYmFjayhLRVlfTUFQ
IHwgUTFfR0VUUFJTVEFUVVMsCj4gPkhBTkRMRVIoY2xpX2dldHByc3RhdHVzKSk7Cj4gPivCoMKg
wqAgc2V0X2hhbmRsZXJfY2FsbGJhY2soS0VZX01BUCB8IFExX1NFVFNUQVRVUywKPiA+SEFORExF
UihjbGlfc2V0cHJzdGF0dXMpKTsKPiA+K8KgwqDCoCBzZXRfaGFuZGxlcl9jYWxsYmFjayhLRVlf
TUFQIHwgUTFfVU5TRVRTVEFUVVMsCj4gPkhBTkRMRVIoY2xpX3Vuc2V0cHJzdGF0dXMpKTsKPiA+
IMKgwqDCoMKgIHNldF9oYW5kbGVyX2NhbGxiYWNrKFZSQl9GT1JDRVEgfCBRMV9EQUVNT04sCj4g
PkhBTkRMRVIoY2xpX2ZvcmNlX25vX2RhZW1vbl9xKSk7Cj4gPiDCoMKgwqDCoCBzZXRfaGFuZGxl
cl9jYWxsYmFjayhWUkJfUkVTVE9SRVEgfCBRMV9EQUVNT04sCj4gPkhBTkRMRVIoY2xpX3Jlc3Rv
cmVfbm9fZGFlbW9uX3EpKTsKPiA+LcKgwqDCoCBzZXRfaGFuZGxlcl9jYWxsYmFjayhWUkJfR0VU
UFJLRVkgfCBRMV9NQVAsIEhBTkRMRVIoY2xpX2dldHBya2V5KSk7Cj4gPi3CoMKgwqAgc2V0X2hh
bmRsZXJfY2FsbGJhY2soVlJCX1NFVFBSS0VZIHwgUTFfTUFQIHwgUTJfS0VZLAo+ID5IQU5ETEVS
KGNsaV9zZXRwcmtleSkpOwo+ID4twqDCoMKgIHNldF9oYW5kbGVyX2NhbGxiYWNrKFZSQl9VTlNF
VFBSS0VZIHwgUTFfTUFQLAo+ID5IQU5ETEVSKGNsaV91bnNldHBya2V5KSk7Cj4gPi3CoMKgwqAg
c2V0X2hhbmRsZXJfY2FsbGJhY2soVlJCX1NFVE1BUkdJTkFMIHwgUTFfUEFUSCwKPiA+SEFORExF
UihjbGlfc2V0X21hcmdpbmFsKSk7Cj4gPi3CoMKgwqAgc2V0X2hhbmRsZXJfY2FsbGJhY2soVlJC
X1VOU0VUTUFSR0lOQUwgfCBRMV9QQVRILAo+ID5IQU5ETEVSKGNsaV91bnNldF9tYXJnaW5hbCkp
Owo+ID4twqDCoMKgIHNldF9oYW5kbGVyX2NhbGxiYWNrKFZSQl9VTlNFVE1BUkdJTkFMIHwgUTFf
TUFQLAo+ID4rwqDCoMKgIHNldF9oYW5kbGVyX2NhbGxiYWNrKEtFWV9NQVAgfCBRMV9HRVRQUktF
WSwgSEFORExFUihjbGlfZ2V0cHJrZXkpKTsKPiA+K8KgwqDCoCBzZXRfaGFuZGxlcl9jYWxsYmFj
ayhLRVlfTUFQIHwgUTFfU0VUS0VZIHwgUTJfS0VZLAo+ID5IQU5ETEVSKGNsaV9zZXRwcmtleSkp
Owo+ID4rwqDCoMKgIHNldF9oYW5kbGVyX2NhbGxiYWNrKEtFWV9NQVAgfCBRMV9VTlNFVEtFWSwg
SEFORExFUihjbGlfdW5zZXRwcmtleSkpOwo+ID4rwqDCoMKgIHNldF9oYW5kbGVyX2NhbGxiYWNr
KEtFWV9QQVRIIHwgUTFfU0VUTUFSR0lOQUwsCj4gPkhBTkRMRVIoY2xpX3NldF9tYXJnaW5hbCkp
Owo+ID4rwqDCoMKgIHNldF9oYW5kbGVyX2NhbGxiYWNrKEtFWV9QQVRIIHwgUTFfVU5TRVRNQVJH
SU5BTCwKPiA+SEFORExFUihjbGlfdW5zZXRfbWFyZ2luYWwpKTsKPiA+K8KgwqDCoCBzZXRfaGFu
ZGxlcl9jYWxsYmFjayhLRVlfTUFQIHwgUTFfVU5TRVRNQVJHSU5BTCwKPiA+IMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgSEFORExFUihjbGlfdW5zZXRfYWxsX21hcmdpbmFsKSk7
Cj4gPiDCoH0KPiA+ZGlmZiAtLWdpdCBhL211bHRpcGF0aGQvY2xpLmggYi9tdWx0aXBhdGhkL2Ns
aS5oCj4gPmluZGV4IGM2Yjc5YzlkLi4wOGVlNWM4ZCAxMDA2NDQKPiA+LS0tIGEvbXVsdGlwYXRo
ZC9jbGkuaAo+ID4rKysgYi9tdWx0aXBhdGhkL2NsaS5oCj4gPkBAIC04MCw3ICs4MCwxNCBAQCBl
bnVtIHsKPiA+IMKgwqDCoMKgIFExX0FMTMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgPSBLRVlfQUxM
IDw8IDgsCj4gPiDCoMKgwqDCoCBRMV9EQUVNT07CoMKgwqDCoMKgwqDCoCA9IEtFWV9EQUVNT04g
PDwgOCwKPiA+IMKgwqDCoMKgIFExX1NUQVRVU8KgwqDCoMKgwqDCoMKgID0gS0VZX1NUQVRVUyA8
PCA4LAo+ID4tCj4gPivCoMKgwqAgUTFfU0VUS0VZwqDCoMKgwqDCoMKgwqAgPSBWUkJfU0VUUFJL
RVkgPDwgOCwKPiA+K8KgwqDCoCBRMV9VTlNFVEtFWcKgwqDCoMKgwqDCoMKgID0gVlJCX1VOU0VU
UFJLRVkgPDwgOCwKPiA+K8KgwqDCoCBRMV9TRVRTVEFUVVPCoMKgwqDCoMKgwqDCoCA9IFZSQl9T
RVRQUlNUQVRVUyA8PCA4LAo+ID4rwqDCoMKgIFExX1VOU0VUU1RBVFVTwqDCoMKgwqDCoMKgwqAg
PSBWUkJfVU5TRVRQUlNUQVRVUyA8PCA4LAo+ID4rwqDCoMKgIFExX0dFVFBSU1RBVFVTwqDCoMKg
wqDCoMKgwqAgPSBWUkJfR0VUUFJTVEFUVVMgPDwgOCwKPiA+K8KgwqDCoCBRMV9HRVRQUktFWcKg
wqDCoMKgwqDCoMKgID0gVlJCX0dFVFBSS0VZIDw8IDgsCj4gPivCoMKgwqAgUTFfU0VUTUFSR0lO
QUzCoMKgwqDCoMKgwqDCoCA9IFZSQl9TRVRNQVJHSU5BTCA8PCA4LAo+ID4rwqDCoMKgIFExX1VO
U0VUTUFSR0lOQUzCoMKgwqAgPSBWUkJfVU5TRVRNQVJHSU5BTCA8PCA4LAo+ID4gwqDCoMKgwqAg
LyogYnl0ZSAyOiBxdWFsaWZpZXIgMiAqLwo+ID4gwqDCoMKgwqAgUTJfRk1UwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCA9IEtFWV9GTVQgPDwgMTYsCj4gPiDCoMKgwqDCoCBRMl9SQVfCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgID0gS0VZX1JBVyA8PCAxNiwKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRt
LWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0
aW5mby9kbS1kZXZlbAo=

