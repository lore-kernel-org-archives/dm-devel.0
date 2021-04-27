Return-Path: <SRS0=s6iH=JY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D6ECC433ED
	for <dm-devel@archiver.kernel.org>; Tue, 27 Apr 2021 20:04:44 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BADC1613EF
	for <dm-devel@archiver.kernel.org>; Tue, 27 Apr 2021 20:04:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BADC1613EF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1619553882;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=4iGglZ2vuSW8pj0QdtehrptoOLwjXEfdVChc0do/z9E=;
	b=ZsTzG/lkhKIEMhGnNsZt3+1PYR0rfymCtHgYdVusCS7wIQ4v/R3hTyht0j3AOtSHva9jr7
	UhbL6AjBVneIiJNbC8CfhNxET+gB7/lps/i6lse2ckRT570YpySrTtC8TOf3Urr4Gskdku
	9L0Bo2tJfMjTmixk9eLAdqy4AhfO5uQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-88-TtAdushkMsyYqwS1mxPdmg-1; Tue, 27 Apr 2021 16:04:39 -0400
X-MC-Unique: TtAdushkMsyYqwS1mxPdmg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D6EAD80DDE2;
	Tue, 27 Apr 2021 20:04:34 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 224E45D769;
	Tue, 27 Apr 2021 20:04:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6652C44A58;
	Tue, 27 Apr 2021 20:04:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13RK4PLM028012 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 27 Apr 2021 16:04:25 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 25F215C260; Tue, 27 Apr 2021 20:04:25 +0000 (UTC)
Received: from ovpn-112-203.phx2.redhat.com (ovpn-112-203.phx2.redhat.com
	[10.3.112.203])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 976175C3F8;
	Tue, 27 Apr 2021 20:04:20 +0000 (UTC)
Message-ID: <731ece1c29243937c52ecdb1a3823d4fccd17bd1.camel@redhat.com>
From: "Ewan D. Milne" <emilne@redhat.com>
To: Ulrich Windl <Ulrich.Windl@rz.uni-regensburg.de>, erwin@erwinvanlonden.net,
	martin.petersen@oracle.com, martin.wilck@suse.com, hare@suse.de
Date: Tue, 27 Apr 2021 16:04:19 -0400
In-Reply-To: <6087ECF1020000A100040C7F@gwsmtp.uni-regensburg.de>
References: <c524ce68d9a9582732db8350f8a1def461a1a847.camel@suse.com>
	<yq135w4cam3.fsf@ca-mkp.ca.oracle.com>
	<06489ea37311fe7bf73b27a41b5209ee4cca85fe.camel@suse.com>
	<yq1pmynt6f6.fsf@ca-mkp.ca.oracle.com>
	<685c40341d2ddef2fe5a54dd656d10104b0c1bfa.camel@suse.com>
	<yq1im4dre94.fsf@ca-mkp.ca.oracle.com>
	<e3184501cbf23ab0ae94d664725e72b693c64ba9.camel@suse.com>
	<6086A0B2020000A100040BBE@gwsmtp.uni-regensburg.de>
	<59dc346de26997a6b8e3ae3d86d84ada60b3d26b.camel@suse.com>
	<b5f288fb43bc79e0206794a901aef5b1761813de.camel@erwinvanlonden.net>
	<15e1a6a493f55051eab844bab2a107f783dc27ee.camel@suse.com>
	<2a6903e4-ff2b-67d5-e772-6971db8448fb@suse.de>
	<6087ECF1020000A100040C7F@gwsmtp.uni-regensburg.de>
Mime-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
Cc: hare@suse.com, "systemd-devel@lists.freedesktop.org"
	<systemd-devel@lists.freedesktop.org>,
	linux-scsi@vger.kernel.org, dm-devel@redhat.com,
	dgilbert@interlog.com, jejb@linux.vnet.ibm.com, hch@lst.de
Subject: Re: [dm-devel] Antw: [EXT] Re: RFC: one more time: SCSI device
 identification
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVHVlLCAyMDIxLTA0LTI3IGF0IDEyOjUyICswMjAwLCBVbHJpY2ggV2luZGwgd3JvdGU6Cj4g
PiA+ID4gSGFubmVzIFJlaW5lY2tlIDxoYXJlQHN1c2UuZGU+IHNjaHJpZWIgYW0gMjcuMDQuMjAy
MSB1bSAxMDoyMQo+ID4gPiA+IGluIE5hY2hyaWNodAo+IAo+IDwyYTY5MDNlNC1mZjJiLTY3ZDUt
ZTc3Mi02OTcxZGI4NDQ4ZmJAc3VzZS5kZT46Cj4gPiBPbiA0LzI3LzIxIDEwOjEwIEFNLCBNYXJ0
aW4gV2lsY2sgd3JvdGU6Cj4gPiA+IE9uIFR1ZSwgMjAyMeKAkTA04oCRMjcgYXQgMTM6NDggKzEw
MDAsIEVyd2luIHZhbiBMb25kZW4gd3JvdGU6Cj4gPiA+ID4gPiAKPiA+ID4gPiA+IFdydCAxKSwg
d2UgY2FuIG9ubHkgaG9wZSB0aGF0IGl0J3MgdGhlIGNhc2UuIEJ1dCAyKSBhbmQgMykKPiA+ID4g
PiA+IG5lZWQgd29yaywKPiA+ID4gPiA+IGFmYWljcy4KPiA+ID4gPiA+IAo+ID4gPiA+IAo+ID4g
PiA+IEluIG15IHZpZXcgdGhlIFdXSUQgc2hvdWxkIG5ldmVyIGNoYW5nZS4gCj4gPiA+IAo+ID4g
PiBJbiBhbiBpZGVhbCB3b3JsZCwgcGVyaGFwcyBub3QuIEJ1dCBpbiB0aGUgZG3igJFtdWx0aXBh
dGggcmVhbG0sIHdlCj4gPiA+IGtub3cKPiA+ID4gdGhhdCBXV0lEIGNoYW5nZXMgY2FuIGhhcHBl
biB3aXRoIGNlcnRhaW4gc3RvcmFnZSBhcnJheXMuIFNlZSAKPiA+ID4gCmh0dHBzOi8vbGlzdG1h
bi5yZWRoYXQuY29tL2FyY2hpdmVzL2Rt4oCRZGV2ZWwvMjAyMeKAkUZlYnJ1YXJ5L21zZzAwMTE2
Lmh0bWwKPiA+ID4gIAo+ID4gPiBhbmQgZm9sbG934oCRdXBzLCBmb3IgZXhhbXBsZS4KPiA+ID4g
Cj4gPiAKPiA+IEFuZCBpdCdzIGFjdHVhbGx5IHNvbWV0aGluZyB3aGljaCBtaWdodCBoYXBwZW4g
cXVpdGUgZWFzaWx5Lgo+ID4gVGhlIHN0b3JhZ2UgYXJyYXkgY2FuIHVubWFwIGEgTFVOLCBkZWxl
dGUgaXQsIGNyZWF0ZSBhIG5ldyBvbmUsIGFuZAo+ID4gbWFwCj4gPiB0aGF0IG9uZSBpbnRvIHRo
ZSBzYW1lIExVTiBudW1iZXIgdGhhbiB0aGUgb2xkIG9uZS4KPiA+IElmIHdlIGRpZG4ndCBkbyBJ
L08gZHVyaW5nIHRoYXQgaW50ZXJ2YWwgdXBvbiB0aGUgbmV4dCBJL08gd2Ugd2lsbAo+ID4gYmUK
PiA+IGdldHRpbmcgdGhlIGRyZWFkZWQgJ1Bvd2Vy4oCRT24vUmVzZXQnIHNlbnNlIGNvZGUuCj4g
PiBfQW5kIG5vdGhpbmcgZWxzZV8sIGR1ZSB0byB0aGUgYXJjYW5lIHJ1bGVzIGZvciBzZW5zZSBj
b2RlCj4gPiBnZW5lcmF0aW9uIGluCj4gPiBTQU0uCj4gPiBCdXQgd2UgZW5kIHVwIHdpdGggYSBj
b21wbGV0ZWx5IGRpZmZlcmVudCBkZXZpY2UuCj4gPiAKPiA+IFRoZSBvbmx5IHdheSBvdXQgb2Yg
aXQgaXMgdG8gZG8gYSByZXNjYW4gZm9yIGV2ZXJ5IFBPUiBzZW5zZSBjb2RlLAo+ID4gYW5kCj4g
PiBkaXNhYmxlIHRoZSBkZXZpY2UgZWcgdmlhIERJRF9OT19DT05ORUNUIHdoZW5ldmVyIHdlIGZp
bmQgdGhhdCB0aGUKPiA+IGlkZW50aWZpY2F0aW9uIGhhcyBjaGFuZ2VkLiBXZSBhbHJlYWR5IGhh
dmUgYSBjb3B5IG9mIHRoZSBvcmlnaW5hbAo+ID4gVlBECj4gPiBwYWdlIDB4ODMgYXQgaGFuZCwg
c28gdGhhdCBzaG91bGQgYmUgcmVhc29uYWJseSBlYXN5Lgo+IAo+IEkgZG9uJ3Qga25vdyB0aGUg
ZGVwdGggb2YgdGhlIFNDU0kgb3IgRkMgcHJvdG9jb2wsIGJ1dCBzdG9yYWdlCj4gc3lzdGVtcwo+
IHR5cGljYWxseSBzaWduYWwgc3VjaCBldmVudHMsIG1heWJlIGVpdGhlciB2aWEgc29tZSB1bml0
IGF0dGVudGlvbiBvcgo+IHNvbWUgRkMKPiBldmVudC4gT2xkZXIga2VybmVscyBsb2dnZWQgdGhh
dCB0aGVyZSB3YXMgYSBjaGFuZ2UsIGJ1dCBhIG1hbnVhbAo+IFNDU0kgYnVzIHNjYW4KPiBpcyBu
ZWVkZWQsIHdoaWxlIG5ld2VyIGtlcm5lbHMgZmluZCBuZXcgZGV2aWNlcyAiYXV0b21hZ2ljYWxs
eSIgZm9yCj4gc29tZQo+IHByb2R1Y3RzLiBUaGUgSFAgRVZBIDYwMDAgc2VyaWVzIHdvcmVkIHRo
YXQgd2F5LCBhIDNQQVIgU290b3JTZXJ2Cj4gODAwMCBzZXJpZXMKPiBhbHNvIHNlZW1zIHRvIHdv
cmsgdGhhdCB3YXksIGJ1dCBub3QgUHVyZSBTdG9yYWdlIFg3MCBSMy4gRk9yIHRoZQo+IGxhdHRl
ciB5b3UKPiBuZWVkIHNvbWV0aGluZyBsaWtlIGEgRkMgTElQIHRvIG1ha2UgdGhlIGtlcm5lbCBk
ZXRlY3QgdGhlIG5ldwo+IGRldmljZXMgKExVTnMpLgo+IEknbSB1bnN1cmUgd2hlcmUgdGhlIHBy
b2JsZW0gaXMsIGJ1dCBpbiBwcmluY2lwbGUgdGhlIGtlcm5lbCBjYW4gYmUKPiBub3RpZmllZC4u
LgoKVGhlcmUgaGFzIHRvIGJlIHNvbWUgY29tbWFuZCBvbiB3aGljaCB0aGUgVW5pdCBBdHRlbnRp
b24gc3RhdHVzCmNhbiBiZSByZXR1cm5lZC4gIChJbiBhIG11bHRpcGF0aCBjb25maWd1cmF0aW9u
LCB0aGUgcGF0aCBjaGVja2VyCmNvbW1hbmRzIG1heSBkbyB0aGlzKS4gIEluIGFic2VuY2Ugb2Yg
YSBjb21tYW5kLCB0aGVyZSBpcyBubwphc3luY2hyb25vdXMgbWVjaGFuaXNtIGluIFNDU0kgdG8g
cmVwb3J0IHRoZSBzdGF0dXMuCgpPbiBGQyB0aGluZ3MgcmVsYXRlZCB0byBmaW5kaW5nIGEgcmVt
b3RlIHBvcnQgd2lsbCB0cmlnZ2VyIGEgcmVzY2FuLgoKLUV3YW4KCj4gCj4gPiAKPiA+IEkgaGFk
IGEgcmF0aGVyIGxlbmd0aHkgZGlzY3Vzc2lvbiB3aXRoIEZyZWQgS25pZ2h0IEAgTmV0QXBwIGFi
b3V0Cj4gPiBQb3dlcuKAkU9uL1Jlc2V0IGhhbmRsaW5nLCB3aGF0IHdpdGggaGltIGNvbXBsYWlu
aW5nIHRoYXQgd2UgZG9uJ3QKPiA+IGhhbmRsZQo+ID4gaXMgY29ycmVjdGx5LiBTbyB0aGlzIHJl
YWxseSBpcyBzb21ldGhpbmcgd2Ugc2hvdWxkIGJlIGxvb2tpbmcKPiA+IGludG8sCj4gPiBldmVu
IGluZGVwZW5kZW50bHkgb2YgbXVsdGlwYXRoaW5nLgo+ID4gCj4gPiBCdXQgYWN0dWFsbHkgSSBs
aWtlIHRoZSBpZGVhIGZyb20gTWFydGluIFBldGVyc2VuIHRvIGV4cG9zZSB0aGUKPiA+IHBhcnNl
ZAo+ID4gVlBEIGlkZW50aWZpZXJzIHRvIHN5c2ZzOyB0aGF0IHdvdWxkIGFsbG93IHVzIHRvIGRy
b3Agc2dfaW5xCj4gPiBjb21wbGV0ZWx5Cj4gPiBmcm9tIHRoZSB1ZGV2IHJ1bGVzLgo+IAo+IFRh
bGtpbmcgb2YgVlBEczogU29tZXdoZXJlIGluIHRoZSBsYXN0IDEyIHllYXJzICh3aXRoaW4gU0xF
UyAxMSl0aGVyZQo+IHdhcyBhCj4ga2VybmVsIGNoYW5nZSByZWdhcmRpbmcgdHJhaWxpbmcgYmxh
bmtzIGluIFZQRCBkYXRhLiBUaGF0IGNoYW5nZSBibGV3Cj4gdXAKPiBzZXZlcmFsIGNvbmZpZ3Vy
YXRpb25zIGJlaW5nIHVuYWJsZSB0byByZS1yZWNvZ25pemUgdGhlIGRldmljZXMuIEluCj4gb25l
IGNhc2UKPiB0aGUgc29mdHdhcmUgZXZlbiBoYWQgYm91bmQgYSBsaWNlbnNlIHRvIGEgc3BlY2lm
aWMgZGV2aWNlIHdpdGgKPiBzZXJpYWwgbnVtYmVyLAo+IGFuZCB0aGF0IHNvZnR3YXJlIGZvdW5k
ICJuZXciIGRldmljZXMgd2hpbGUgbWlzc2luZyB0aGUgIm9sZCIgb25lcy4uLgo+IAo+IFJlZ2Fy
ZHMsCj4gVWxyaWNoCj4gCj4gPiAKPiA+IENoZWVycywKPiA+IAo+ID4gSGFubmVzCj4gPiDigJHi
gJEgCj4gPiBEci4gSGFubmVzIFJlaW5lY2tlCQkgICAgICAgIEtlcm5lbCBTdG9yYWdlIEFyY2hp
dGVjdAo+ID4gaGFyZUBzdXNlLmRlCQkJICAgICAgICAgICAgICAgKzQ5IDkxMSA3NDA1Mwo+ID4g
Njg4Cj4gPiBTVVNFIFNvZnR3YXJlIFNvbHV0aW9ucyBHZXJtYW55IEdtYkgsIDkwNDA5IE7DvHJu
YmVyZwo+ID4gR0Y6IEYuIEltZW5kw7ZyZmZlciwgSFJCIDM2ODA5IChBRyBOw7xybmJlcmcpCj4g
Cj4gCj4gCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRw
czovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs

