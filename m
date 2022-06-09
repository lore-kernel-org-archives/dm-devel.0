Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AB44C43334
	for <dm-devel@archiver.kernel.org>; Thu,  9 Jun 2022 16:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1654792622;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=zqy/jNoy/KjdbhDXHAUAw9U/Uub3jb7NL48y7t6sRfg=;
	b=aSwHBFe3mZ4VubFXUysy7E12Yb6kJhtE+3dbzCsTcjrXKl8N17/+SmsT8+5f68VFqYoeKg
	mw8PSnMuStBG1tY8L3rZiiKLCj6fVieaEeT3fzpK95DLMa7D7ehfCnRRfE/vZhMY67OKmP
	LUY58lY908fMNwrNeL6jWC0QlYfhZI8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-281-MqvgKaTLMm2_vnyPPJ6pHQ-1; Thu, 09 Jun 2022 12:36:59 -0400
X-MC-Unique: MqvgKaTLMm2_vnyPPJ6pHQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 963251815CFA;
	Thu,  9 Jun 2022 16:36:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7CD901730C;
	Thu,  9 Jun 2022 16:36:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4D8611947061;
	Thu,  9 Jun 2022 16:36:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A6FE71947040
 for <dm-devel@listman.corp.redhat.com>; Thu,  9 Jun 2022 16:36:54 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9160840CFD0A; Thu,  9 Jun 2022 16:36:54 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 77E6F40CF8E2;
 Thu,  9 Jun 2022 16:36:54 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 259GarQe000678;
 Thu, 9 Jun 2022 11:36:53 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 259Gaqqf000677;
 Thu, 9 Jun 2022 11:36:52 -0500
Date: Thu, 9 Jun 2022 11:36:52 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20220609163652.GC5254@octiron.msp.redhat.com>
References: <1654641901-12324-1-git-send-email-bmarzins@redhat.com>
 <1675cd007bfee3f944c986e7e8a9eec8969487cd.camel@suse.com>
 <20220608144006.GW5254@octiron.msp.redhat.com>
 <b5ad7b428d5998e39863a3144d57e40d32f72c1d.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <b5ad7b428d5998e39863a3144d57e40d32f72c1d.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH] libmultipath: unset detect_checker for
 clariion / Unity arrays
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
Cc: "vincent.chen1@dell.com" <vincent.chen1@dell.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "xose.vazquez@gmail.com" <xose.vazquez@gmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gV2VkLCBKdW4gMDgsIDIwMjIgYXQgMDQ6NDc6MzdQTSArMDAwMCwgTWFydGluIFdpbGNrIHdy
b3RlOgo+IE9uIFdlZCwgMjAyMi0wNi0wOCBhdCAwOTo0MCAtMDUwMCwgQmVuamFtaW4gTWFyemlu
c2tpIHdyb3RlOgo+ID4gT24gV2VkLCBKdW4gMDgsIDIwMjIgYXQgMDc6NTY6MjdBTSArMDAwMCwg
TWFydGluIFdpbGNrIHdyb3RlOgo+ID4gPiBPbiBUdWUsIDIwMjItMDYtMDcgYXQgMTc6NDUgLTA1
MDAsIEJlbmphbWluIE1hcnppbnNraSB3cm90ZToKPiA+ID4gPiBEZWxsIEVNQyB3b3VsZCBsaWtl
IHRvIGFsd2F5cyB1c2UgdGhlIGVtY19jbGFyaWlvbiBjaGVja2VyLgo+ID4gPiA+IEN1cnJlbnRs
eQo+ID4gPiA+IGRldGVjdF9jaGVja2VyIHdpbGwgc3dpdGNoIHRoZSBjaGVja2VyIHRvIFRVUiBm
b3IgVW5pdHkgYXJyYXlzLgo+ID4gPiA+IFRoaXMgY2FuIGNhdXNlIHByb2JsZW1zIG9uIHNvbWUg
c2V0dXBzIHdpdGggcmVwbGljYXRlZCBVbml0eQo+ID4gPiA+IExVTnMsCj4gPiA+ID4gd2hpY2gg
YXJlIGhhbmRsZWQgY29ycmVjdGx5IHRoZSB0aGUgZW1jX2NoZWNrZXIsIGJ1dCBub3QgdGhlIFRV
Ugo+ID4gPiA+IGNoZWNrZXIuCj4gPiA+ID4gCj4gPiA+ID4gQ2M6IHZpbmNlbnQuY2hlbjFAZGVs
bC5jb20KPiA+ID4gPiBTaWduZWQtb2ZmLWJ5OiBCZW5qYW1pbiBNYXJ6aW5za2kgPGJtYXJ6aW5z
QHJlZGhhdC5jb20+Cj4gPiA+IAo+ID4gPiBUaGlzIHBvaW50cyB1cyB0byBhIGZsYXcgaW4gb3Vy
IGxvZ2ljLgo+ID4gPiAKPiA+ID4gSXQgd2FzIHdyb25nIGluIHRoZSBmaXJzdCBwbGFjZSB0byBo
YXZlIGF1dG9kZXRlY3Rpb24gdGFrZQo+ID4gPiBwcmVjZWRlbmNlLAo+ID4gPiBldmVuIG92ZXIg
Im92ZXJyaWRlcyIuIFRoZSBlZmZlY3QgZm9yIHVzZXJzIGlzIHRoYXQgd2hlbmV2ZXIKPiA+ID4g
InBhdGhfY2hlY2tlciIgaXMgc2V0LCAiZGV0ZWN0X2NoZWNrZXIgbm8iIG11c3QgYWxzbyBiZSBz
ZXQsIHdoaWNoCj4gPiA+IGlzIGhpZ2hseSBzdXJwcmlzaW5nIGFuZCBhZGRzIG5vIGJlbmVmaXQu
Cj4gPiA+IAo+ID4gPiBXZSBzaG91bGQgYXNzdW1lIHRoYXQgaWYgYSBkZXZpY2UgaGFzIGFuIGV4
cGxpY2l0IGNoZWNrZXIKPiA+ID4gY29uZmlndXJlZAo+ID4gPiBlaXRoZXIgaW4gdGhlIGRldmlj
ZSBjb25maWd1cmF0aW9uLCBvdmVycmlkZXMsIG9yIHRoZSBod3RhYmxlLCB0aGlzCj4gPiA+IGNo
ZWNrZXIgbXVzdCBiZSB1c2VkLCBhbmQgZmFsbCBiYWNrIHRvIGF1dG9kZXRlY3Rpb24gb25seSBp
ZiB0aGlzCj4gPiA+IGlzCj4gPiA+IG5vdCB0aGUgY2FzZS4KPiA+ID4gCj4gPiA+IFNvIHdoaWxl
IHRoaXMgcGF0Y2ggaXMgYWxyaWdodCwgSSdkIHByZWZlciBhIHBhdGNoIHRoYXQgZml4ZXMgdGhl
Cj4gPiA+IGxvZ2ljLgo+ID4gCj4gPiBJJ20gbm90IHN1cmUgdGhhdCB0aGlzIGlzIGEgZ29vZCBp
ZGVhLiBJSVJDLCB0aGUgY3VycmVudCBtZXRob2Qgd2FzCj4gPiBhbgo+ID4gaW50ZW50aW9uYWwg
Y2hvaWNlLsKgIFRoZSBpZGVhIHdhcyB0aGF0IGlmIGEgY2hlY2tlciB3YXMgYXV0b2RldGVjdGVk
LAo+ID4gd2UKPiA+IHdvdWxkIHVzZSB0aGF0LiBJZiBub3QsIHdlIHdvdWxkIGZhbGwgYmFjayB0
byB0aGUgdXNlciBkZWZpbmVkCj4gPiBjaGVja2VyLgo+ID4gRm9yIHRoZSBtb3N0IHBhcnQgdGhp
cyBpcyB1c2VmdWwgZm9yIGFycmF5cyB0aGF0IGNvdWxkIGJlIHJ1biBpbiBBTFVBCj4gPiBvcgo+
ID4gbm9uLWFsdWEgbW9kZS7CoCBDaGFuZ2luZyB0aGUgcHJpb3JpdHkgb2YgZGV0ZWN0X2NoZWNr
ZXIgd2lsbCBzdWRkZW5seQo+ID4gY2hhbmdlIGhvdyB0aGVzZSBhcnJheXMgYXJlIGNvbmZpZ3Vy
ZWQuwqAgVXNlcnMgdGhhdCBjb25maWd1cmVkIGEKPiA+IGZhaWxiYWNrIGNoZWNrZXIgZm9yIGNh
c2VzIHdoZXJlIHRoZWlyIGFycmF5cyB3ZXJlbid0IGluIEFMVUEgbW9kZQo+ID4gd291bGQKPiA+
IHN1ZGRlbmx5IGZpbmQgdGhhdCB0aGVpciBhcnJheXMgd2VyZSBhbHdheXMgdXNpbmcgdGhlIGZh
bGxiYWNrCj4gPiBtZXRob2QuIAo+IAo+ID4gTm93IEknbSBub3Qgc2F5aW5nIHRoYXQgdGhlIG9y
aWdpbmFsIGxvZ2ljIHdhcyB0aGUgYmVzdCBvcHRpb24uIEJ1dCBJCj4gPiBhbQo+ID4gc2F5aW5n
IHRoYXQgaXQgaGFzbid0IGNhdXNlZCBtYW55IGlzc3VlcyBvdmVyIHRoZSB5ZWFycyB0aGF0IGl0
J3MKPiA+IGJlZW4KPiA+IGluIGV4aXN0YW5jZS4gVGhlcmUgYXJlIGEgbnVtYmVyIG9mIGFycmF5
cyBpbiB0aGUgYnVpbHRpbiBoYXJkd2FyZQo+ID4gdGFibGUKPiA+IHRoYXQgZGVmaW5lIGNoZWNr
ZXJzLiBJIGFzc3VtZSB0aGF0IHRoZXkgZWl0aGVyIGRvbid0IHN1cHBvcnQgQUxVQSwKPiA+IG9y
Cj4gPiB0aGV5IGFyZSBoYXBweSB3aXRoIG9ubHkgdXNpbmcgdGhlaXIgY29uZmlndXJlZCBjaGVj
a2VyIHdoZW4KPiA+IHRoZWlyPFRoaW5raW5nIGFib3V0IGl0LCAKPiA+IGFycmF5cyBhcmVuJ3Qg
aW4gQUxVQSBtb2RlLgo+IAo+IE1vc3Qgb2YgdGhlIGJ1aWx0LWluIGh3dGFibGUgZW50cmllcyBz
ZXQgdGhlIFJEQUMgY2hlY2tlci4gRm9yIHRoZXNlLAo+IHRoZSByZXN1bHQgd2lsbCBiZSB1bmNo
YW5nZWQgaWYgd2UgbG93ZXIgdGhlIHByZWNlZGVuY2Ugb2YKPiBkZXRlY3RfY2hlY2tlci4gVGhl
cmUgYXJlIHR3byBlbnRyaWVzIHNldHRpbmcgRElSRUNUSU8gZm9yIG5vbi1TQ1NJCj4gZGV2aWNl
cyAoREFTRCBhbmQgSHVhd2VpIE5WTWUpOiBubyByZWdyZXNzaW9uIHJpc2sgdGhlcmUuIFRoZW4g
dGhlcmUncwo+IENsYXJpaW9uIENYL0FYL1ZOWCwgZm9yIHdoaWNoIHRoZSBjaGFuZ2UgaW4gYmVo
YXZpb3IgaXMgaW50ZW5kZWQuCj4gRmluYWxseSwgdGhlcmUgYXJlIHR3byBlbnRyaWVzIGZvciBh
bmNpZW50IEhQRSBkZXZpY2VzIHVzaW5nIEhQX1NXLiBJZgo+IHdlIGNoYW5nZSB0aGUgcHJlY2Vk
ZW5jZSwgdGhlc2UgZGV2aWNlcyBtaWdodCBzd2l0Y2ggZnJvbSBUVVIgdG8gSFBfU1cKPiAoaWYg
dGhleSBzdXBwb3J0IEFMVUEsIGR1bm5vKS4KCkFzIHdlbGwgYXMgYW55IHVzZXIgY29uZmlndXJh
dGlvbnMgdGhhdCBzZXQgdGhpcy4gIEkgcmVhbGl6ZSB0aGF0IGl0IGhhcwpiZWVuIGEgd2hpbGUg
c2luY2UgdGhlIGRheXMgd2hlbiBtb3N0IG9mIHRoZSBkZWZhdWx0IGRldmljZSBjb25maWdzCmV4
cGxpY2l0bHkgc2V0IGEgY2hlY2tlciwgYnV0IEkgZG9uJ3QgaGF2ZSBhbnkgaWRlYSBob3cgbWFu
eSB1c2VycyBhcmUKc3RpbGwgcnVubmluZyB3aXRoIGEgdXNlciBjb25maWcgbGlrZSB0aGF0Lgog
Cj4gPiAgSSB3b3VsZCByYXRoZXIgZml4IHRoZSByZW1haW5pbmcgY2FzZXMgd2hlcmUKPiA+IHRo
ZSBleGlzdGluZyBwcmlvcml0eSBnaXZlcyB0aGUgd3JvbmcgYW5zd2VyIHRoYW4gc3VkZGVubHkg
Y2hhbmdlIGhvdwo+ID4gdGhpbmdzIHdvcmssIGluIGEgd2F5IHRoYXQgY291bGQgc3VkZGVubHkg
YnJlYWsgdGhpbmdzIGZvciBhbiB1bmtub3duCj4gPiAoYnV0IHF1aXRlIHBvc3NpYmx5IGxhcmdl
KSBudW1iZXIgb2YgZXhpc3RpbmcgdXNlcnMuCj4gCj4gQWNjb3JkaW5nIHRvIHRoZSBhYm92ZSwg
b25seSBwZW9wbGUgd2hvJ2QgdXNlIHZlcnkgb2xkIEhQRSBzdG9yYWdlCj4gYXJyYXlzIHdpdGgg
bGF0ZXN0IHVwc3RyZWFtIG11bHRpcGF0aC10b29scyB3b3VsZCBiZSBhZmZlY3RlZC4KPiAKPiBS
ZW1haW4gdGhvc2UgdXNlcnMgdGhhdCB5b3UgbWVudGlvbmVkIOKAlCBwZW9wbGUgd2hvIG9wZXJh
dGUgaW4gQUxVQSBtb2RlCj4gYnV0IGtlZXAgc29tZSBleHBsaWNpdCBtdWx0aXBhdGguY29uZiBz
ZXR0aW5ncyBhcm91bmQgYXMgZmFsbGJhY2sgIndoZW4KPiB0aGVpciBhcnJheXMgYXJlbid0IGlu
IEFMVUEgbW9kZSIgKGZvciB3aGF0ZXZlciByZWFzb24pLiBUaGVzZSB1c2Vycwo+IHdvdWxkIG5v
dyBvYnNlcnZlIHRoYXQgdGhlaXIgYXJyYXlzIG9wZXJhdGUgaW4gZmFsbGJhY2sgbW9kZSwgZXZl
biBpZgo+IEFMVUEgd2FzIGVuYWJsZWQuCj4gCj4gSSdtIG5vdCBzdXJlIGlmIHRoaXMgbWF0dGVy
cyBtdWNoLiBPVE9ILCBpdCdzIHJhdGhlciBjb21tb24gZm9yIHBlb3BsZQo+IHRvIGZvcmdldCB0
byBzZXQgImRldGVjdF9jaGVja2VyIG5vIiBhbmQgd29uZGVyIHdoeSB0aGVpcgo+IG11bHRpcGF0
aC5jb25mIHNldHRpbmdzIGRvbid0IHRha2UgZWZmZWN0LgoKQnV0IGxpa2UgbXkgcGF0Y2ggc2hv
d2VkLCBpdCdzIGEgc2ltcGxlIGZpeC4gSWYgdXNlcnMgd2FudGVkIHRvIGRlZmluZSBhCmZhbGxi
YWNrIG1ldGhvZCBmb3IgYXJyYXlzIHRoYXQgb3B0aW9uYWxseSBzdXBwb3J0IEFMVUEgKGFuZCBJ
IGFkbWl0CnRoYXQgSSBoYXZlIG5vIGlkZWEgaG93IG1hbnkgYXJyYXlzIGxpa2UgdGhpcyBhcmUg
c3RpbGwgYmVpbmcgdXNlZCkgaXQncwphIGxvdCB0cmlja2VyIGlmIHRoZSBkZXZpY2VzIHNlY3Rp
b24gcGF0aF9jaGVja2VyIHRha2VzIHByZWNlZGVuY2UuIFRoZXkKY2FuJ3Qgc2V0IHRoZSBmYWxs
YmFjayBjaGVja2VyIHRoZXJlLiBUaGV5IHdvdWxkIGhhdmUgdG8gc2V0IGl0IGluIHRoZQpkZWZh
dWx0cyBzZWN0aW9uLiBUaGlzIGlzIHByb2JsZW1hdGljLCBzaW5jZSB5b3UgYXJlIGNoYW5naW5n
IHRoZQpjaGVja2VyIG9uIGFycmF5cyB5b3UgbWF5IG5vdCBoYXZlIGludGVuZGVkLgoKPiA+IAo+
ID4gPiAoVGhlIHNhbWUgY291bGQgYmUgc2FpZCBmb3IgZGV0ZWN0X3ByaW8sIGJ1dCBJIGRvbid0
IHdhbnQgdG8gbWFrZQo+ID4gPiBvdXRyYWdlb3VzIGRlbWFuZHMpLgo+ID4gCj4gPiBUaGUgYWJv
dmUgYXJndW1lbnRzIGFwcGx5IGhlcmUsIG9ubHkgbW9yZXNvLgo+IAo+IEJlc2lkZXMgdGhlIGRl
dmljZXMgYWxyZWFkeSBtZW50aW9uZWQgZm9yIGRldGVjdF9jaGVja2VyLCB0aGVyZSdzIHRoZQo+
IEhpdGFjaGkgVmFudGFyYSBBTVMgc2V0dGluZyBQUklPX0hEUywgYW5kIE9OVEFQIHVzaW5nIFBS
SU9fT05UQVAuIFRoZQo+IGJpZyBkaWZmZXJlbmNlIGlzIHRoYXQgaW4gZGV0ZWN0X3ByaW8oKSwg
UkRBQyBhcnJheXMgYXJlIGNvbmZpZ3VyZWQgdG8KPiB1c2UgQUxVQSByYXRoZXIgdGhhbiBSREFD
LiBTbyBpZiB3ZSBzd2l0Y2ggdGhlIHByZWNlZGVuY2UsIGFsbCB0aG9zZQo+IGFycmF5cyB3b3Vs
ZCBzd2l0Y2ggZnJvbSBBTFVBIHRvIFJEQUMuIEkgYWdyZWUgdGhpcyB3b3VsZCBiZSBzdXJwcmlz
aW5nCj4gYW5kIHVuZGVzaXJhYmxlLiBBcmUgdGhlc2UgYXJyYXlzIHN0aWxsIGNvbmZpZ3VyYWJs
ZSB0byBub3Qgc3VwcG9ydAo+IEFMVUE/IElmIG5vLCB3ZSBjb3VsZCBqdXN0IHJlbW92ZSB0aGUg
UkRBQyBlbnRyaWVzLiBTYW1lIGZvciBPTlRBUC4KPiAKPiBBbnl3YXksIF9pZl8gd2UgY2hhbmdl
IHRoZSBwcmVjZWRlbmNlIHJ1bGVzLCB3ZSBzaG91bGQgZG8gaXQgZm9yIGJvdGgKPiBkZXRlY3Rf
cHJpbyBhbmQgZGV0ZWN0X2NoZWNrZXIsIG90aGVyd2lzZSBvdXIgYmVoYXZpb3IgbWlnaHQgYXBw
ZWFyCj4gbW9yZSBpbmNvbnNpc3RlbnQgdGhhbiBpdCdzIG5vdy4KCkFncmVlZC4gdGhlIGhhcmR3
YXJlX2hhbmRsZXIgYWxzbyB3b3JrcyBpbiBhIHNpbWlsYXIgd2F5ICh3aXRoIHJldGFpbmluZwp0
aGUga2VybmVsIGRldGVjdGVkIG9uZSBieSBkZWZhdWx0LCBhbmQgdXNpbmcgdGhlIGRldmljZSdz
IHNlY3Rpb24KaGFyZHdhcmVfaGFuZGxlciBvcHRpb24gYXMgYSBiYWNrdXApLiBJIGRvbid0IHRo
aW5rIHdlIHdhbnQgdG8gY2hhbmdlCnRoYXQgb25lIGVpdGhlci4KCi1CZW4KCj4gRm9yIG5vdywg
SSdsbCBhY2sgeW91ciBwYXRjaCBhbmQgbGV0IHRoaXMgZGlzY3Vzc2lvbiBzaW5rIGluIGEgYml0
Lgo+IENvbW1lbnRzIGZyb20gdXNlcnMgd2VsY29tZSEKPiAKPiBSZWdhcmRzCj4gTWFydGluCj4g
Ci0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlz
dG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

