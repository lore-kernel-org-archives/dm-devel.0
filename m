Return-Path: <SRS0=wTOt=JX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4E4EC433B4
	for <dm-devel@archiver.kernel.org>; Mon, 26 Apr 2021 11:24:23 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7746A608FE
	for <dm-devel@archiver.kernel.org>; Mon, 26 Apr 2021 11:24:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7746A608FE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=rz.uni-regensburg.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-347-BE_3AVoAPlyL7adxeNT62A-1; Mon, 26 Apr 2021 07:24:16 -0400
X-MC-Unique: BE_3AVoAPlyL7adxeNT62A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9E8FB18397AD;
	Mon, 26 Apr 2021 11:24:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 936182BFC7;
	Mon, 26 Apr 2021 11:24:09 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 222081806D1A;
	Mon, 26 Apr 2021 11:24:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13QBO3ew004486 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 26 Apr 2021 07:24:04 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id EF829223033F; Mon, 26 Apr 2021 11:24:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E9BC220148E7
	for <dm-devel@redhat.com>; Mon, 26 Apr 2021 11:24:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8863280158D
	for <dm-devel@redhat.com>; Mon, 26 Apr 2021 11:24:00 +0000 (UTC)
Received: from mx4.uni-regensburg.de (mx4.uni-regensburg.de
	[194.94.157.149]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-357-1_5OZsymPlO7B9Y4ln3V_Q-1; Mon, 26 Apr 2021 07:23:56 -0400
X-MC-Unique: 1_5OZsymPlO7B9Y4ln3V_Q-1
Received: from mx4.uni-regensburg.de (localhost [127.0.0.1])
	by localhost (Postfix) with SMTP id 5FFAB600005E;
	Mon, 26 Apr 2021 13:15:00 +0200 (CEST)
Received: from gwsmtp.uni-regensburg.de (gwsmtp1.uni-regensburg.de
	[132.199.5.51])
	by mx4.uni-regensburg.de (Postfix) with ESMTP id 318AC600005B;
	Mon, 26 Apr 2021 13:15:00 +0200 (CEST)
Received: from uni-regensburg-smtp1-MTA by gwsmtp.uni-regensburg.de
	with Novell_GroupWise; Mon, 26 Apr 2021 13:14:59 +0200
Message-Id: <6086A0B2020000A100040BBE@gwsmtp.uni-regensburg.de>
Date: Mon, 26 Apr 2021 13:14:58 +0200
From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To: <martin.petersen@oracle.com>, <martin.wilck@suse.com>
References: <c524ce68d9a9582732db8350f8a1def461a1a847.camel@suse.com>
	<yq135w4cam3.fsf@ca-mkp.ca.oracle.com>
	<06489ea37311fe7bf73b27a41b5209ee4cca85fe.camel@suse.com>
	<yq1pmynt6f6.fsf@ca-mkp.ca.oracle.com>
	<685c40341d2ddef2fe5a54dd656d10104b0c1bfa.camel@suse.com>
	<yq1im4dre94.fsf@ca-mkp.ca.oracle.com>
	<e3184501cbf23ab0ae94d664725e72b693c64ba9.camel@suse.com>
In-Reply-To: <e3184501cbf23ab0ae94d664725e72b693c64ba9.camel@suse.com>
Mime-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 13QBO3ew004486
X-loop: dm-devel@redhat.com
Cc: hare@suse.com, "systemd-devel@lists.freedesktop.org"
	<systemd-devel@lists.freedesktop.org>,
	linux-scsi@vger.kernel.org, dm-devel@redhat.com,
	dgilbert@interlog.com, jejb@linux.vnet.ibm.com, hch@lst.de
Subject: [dm-devel] Antw: [EXT] Re: [systemd-devel] RFC: one more time: SCSI
 device identification
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

Pj4+IE1hcnRpbiBXaWxjayA8bWFydGluLndpbGNrQHN1c2UuY29tPiBzY2hyaWViIGFtIDIzLjA0
LjIwMjEgdW0gMTI6MjggaW4KTmFjaHJpY2h0IDxlMzE4NDUwMWNiZjIzYWIwYWU5NGQ2NjQ3MjVl
NzJiNjkzYzY0YmE5LmNhbWVsQHN1c2UuY29tPjoKPiBPbiBUaHUsIDIwMjHigJEwNOKAkTIyIGF0
IDIxOjQwIOKAkTA0MDAsIE1hcnRpbiBLLiBQZXRlcnNlbiB3cm90ZToKPj4gCj4+IE1hcnRpbiwK
Pj4gCj4+ID4gSSBzdXBwb3NlIDk5LjklIG9mIHVzZXJzIG5ldmVyIGJvdGhlciB3aXRoIGN1c3Rv
bWl6aW5nIHRoZSB1ZGV2Cj4+ID4gcnVsZXMuCj4+IAo+PiBFeGNlcHQgZm9yIHRoZSBvdGhlciA5
OS45JSwgcGVyaGFwcz8gOikgV2UgZGVmaW5pdGVseSBoYXZlIG1hbnkgdXNlcnMKPj4gdGhhdCB0
d2VhayB1ZGV2IHN0b3JhZ2UgcnVsZXMgZm9yIGEgdmFyaWV0eSBvZiByZWFzb25zLiBJbmNsdWRp
bmcKPj4gYmVpbmcKPj4gYWJsZSB0byB1c2UgUklJIGZvciBMVU4gbmFtaW5nIHB1cnBvc2VzLgo+
PiAKPj4gPiBCdXQgd2UgY2FuIGFjdHVhbGx5IGNvbWJpbmUgYm90aCBhcHByb2FjaGVzLiBJZiAi
d3dpZCIgeWllbGRzIGEKPj4gPiBnb29kCj4+ID4gdmFsdWUgbW9zdCBvZiB0aGUgdGltZSAod2hp
Y2ggaXMgdHJ1ZSBJTU8pLCB3ZSBjb3VsZCBtYWtlIHVzZXIKPj4gPiBzcGFjZQo+PiA+IHJlbHkg
b24gaXQgYnkgZGVmYXVsdCwgYW5kIG1ha2UgaXQgcG9zc2libGUgdG8gc2V0IGFuIHVkZXYgcHJv
cGVydHkKPj4gPiAoZS5nLiBFTlZ7SURfTEVHQUNZfT0iMSIpIHRvIHRlbGwgdWRldiBydWxlcyB0
byBkZXRlcm1pbmUgV1dJRAo+PiA+IGRpZmZlcmVudGx5LiBVc2Vy4oCRc3BhY2UgYXBwcyBsaWtl
IG11bHRpcGF0aCBjb3VsZCBjaGVjayB0aGUKPj4gPiBJRF9MRUdBQ1kKPj4gPiBwcm9wZXJ0eSB0
byBkZXRlcm1pbmUgd2hldGhlciBvciBub3QgcmVhZGluZyB0aGUgInd3aWQiIGF0dHJpYnV0ZQo+
PiA+IHdvdWxkCj4+ID4gYmUgY29uc2lzdGVudCB3aXRoIHVkZXYuIFRoYXQgd291bGQgc2ltcGxp
ZnkgbWF0dGVycyBhIGxvdCBmb3IgdXMKPj4gPiAoQmVuLAo+PiA+IGRvIHlvdSBhZ3JlZT8pLCB3
aXRob3V0IHRoZSBuZWVkIG9mIGFkZGluZyBlbmRsZXNzIEJMSVNUIGVudHJpZXMuCj4+IAo+PiBU
aGF0J3MgZmluZSB3aXRoIG1lLgo+PiAKPj4gPiBBRkFJQ1QsIG5vIG1ham9yIGRpc3RyaWJ1dGlv
biB1c2VzICJ3d2lkIiBmb3IgdGhpcyBwdXJwb3NlICh5ZXQpLgo+PiAKPj4gV2UgZGVmaW5pdGVs
eSBoYXZlIHVzZXJzIHRoYXQgY3VycmVudGx5IHJlbHkgb24gd3dpZCwgYWx0aG91Z2gKPj4gcHJv
YmFibHkKPj4gbm90IHRocm91Z2ggc3RhbmRhcmQgZGlzdHJvIHNjcmlwdHMuCj4+IAo+PiA+IElu
IGEgcmVjZW50IGRpc2N1c3Npb24gd2l0aCBIYW5uZXMsIHRoZSBpZGVhIGNhbWUgdXAgdGhhdCB0
aGUKPj4gPiBwcmlvcml0eQo+PiA+IG9mICJTQ1NJIG5hbWUgc3RyaW5nIiBkZXNpZ25hdG9ycyBz
aG91bGQgYWN0dWFsbHkgZGVwZW5kIG9uIHRoZWlyCj4+ID4gc3VidHlwZS4gIm5hYS4iIG5hbWUg
c3RyaW5ncyBzaG91bGQgbWFwIHRvIHRoZSByZXNwZWN0aXZlIE5BQQo+PiA+IGRlc2NyaXB0b3Jz
LCBhbmQgImV1aS4iLCBsaWtld2lzZSAob25seSAiaXFuLiIgZGVzY3JpcHRvcnMgaGF2ZSBubwo+
PiA+IGJpbmFyeSBjb3VudGVycGFydDsgd2UgdGhvdWdodCB0aGV5IHNob3VsZCByYXRoZXIgYmUg
cHV0IGJlbG93IE5BQSwKPj4gPiBwcmlv4oCRd2lzZSkuCj4+IAo+PiBJIGxpa2Ugd2hhdCBOVk1l
IGRpZCB3cnQuIHRvIGV4cG9ydGluZyBldWksIG5ndWlkLCB1dWlkIHNlcGFyYXRlbHkKPj4gZnJv
bQo+PiB0aGUgYmVzdOKAkWVmZm9ydCB3d2lkLiBUaGF0J3Mgd2h5IEkgc3VnZ2VzdGVkIHNlcGFy
YXRlIHN5c2ZzIGZpbGVzIGZvcgo+PiB0aGUgdmFyaW91cyBwYWdlIDB4ODMgZGVzY3JpcHRvcnMu
IEkgbGlrZSB0aGUgaWRlYSBvZiBiZWluZyBhYmxlIHRvCj4+IGV4cGxpY2l0bHkgYXNrIGZvciBh
biBldWkgaWYgdGhhdCdzIHdoYXQgSSBuZWVkLiBCdXQgdGhhdCBhcHBlYXJzIHRvCj4+IGJlCj4+
IHNvbWV3aGF0IG9ydGhvZ29uYWwgdG8geW91ciByZXF1ZXN0Lgo+PiAKPj4gPiBJIHdvbmRlciBp
ZiB5b3UnZCBhZ3JlZSB3aXRoIGEgY2hhbmdlIG1hZGUgdGhhdCB3YXkgZm9yICJ3d2lkIi4gSQo+
PiA+IHN1cHBvc2UgeW91IGRvbid0LiBJJ2QgdGhlbiBwcm9wb3NlIHRvIGFkZCBhIG5ldyBhdHRy
aWJ1dGUKPj4gPiBmb2xsb3dpbmcKPj4gPiB0aGlzIGxvZ2ljLiBJdCBjb3VsZCBzaW1wbHkgYmUg
YW4gYWRkaXRpb25hbCBhdHRyaWJ1dGUgd2l0aCBhCj4+ID4gZGlmZmVyZW50Cj4+ID4gbmFtZS4g
T3IgdGhpcyBuZXcgYXR0cmlidXRlIGNvdWxkIGJlIGEgcHJvcGVydHkgb2YgdGhlIGJsb2NrIGRl
dmljZQo+PiA+IHJhdGhlciB0aGFuIHRoZSBTQ1NJIGRldmljZSwgbGlrZSBOVk1lIGRvZXMgaXQK
Pj4gPiAoL3N5cy9ibG9jay9udm1lMG4yL3d3aWQpLgo+PiAKPj4gVGhhdCdzIGZpbmUuIEkgYW0g
bm90IGEgYmlnIGZhbiBvZiB0aGUgaWRlYSB0aGF0IGJsb2NrL2Zvby93d2lkIGFuZAo+PiBibG9j
ay9mb28vZGV2aWNlL3d3aWQgY291bGQgZW5kIHVwIGJlaW5nIGRpZmZlcmVudC4gQnV0IEkgZG8g
dGhpbmsKPj4gdGhhdAo+PiBmcm9tIGEgdXNlcmxhbmQgdG9vbGluZyBwZXJzcGVjdGl2ZSB0aGUg
Y29uc2lzdGVuY3kgd2l0aCBOVk1lIGlzIG1vcmUKPj4gaW1wb3J0YW50Lgo+IAo+IE9LLCB0aGVu
IGhlcmUncyB0aGUgcGxhbjogQ2hhbmdlIFNDU0kgKGJsb2NrKSBkZXZpY2UgaWRlbnRpZmljYXRp
b24gdG8KPiB3b3JrIHNpbWlsYXIgdG8gTlZNZSAoaW4gYWRkaXRpb24gdG8gd2hhdCB3ZSBoYXZl
IG5vdykuCj4gCj4gIDEuIGFkZCBhIG5ldyBzeXNmcyBhdHRyaWJ1dGUgZm9yIFNDU0kgYmxvY2sg
ZGV2aWNlcyBhcwo+IC9zeXMvYmxvY2svc2QkWC93d2lkLCB0aGUgdmFsdWUgZGVyaXZlZCBzaW1p
bGFyIHRvIHRoZSBjdXJyZW50ICJ3d2lkIgo+IFNDU0kgZGV2aWNlIGF0dHJpYnV0ZSwgYnV0IHVz
aW5nIHRoZSBzYW1lIHByaW8gZm9yIFNDU0kgbmFtZSBzdHJpbmdzIGFzCj4gZm9yIHRoZWlyIGJp
bmFyeSBjb3VudGVycGFydHMsIGFzIGRlc2NyaWJlZCBhYm92ZS4KPiAKPiAgMi4gYWRkICJuYWEi
IGFuZCAiZXVpIiBhdHRyaWJ1dGVzLCB0b28sIGZvciB1c2Vy4oCRc3BhY2UgYXBwbGljYXRpb25z
Cj4gdGhhdCBhcmUgaW50ZXJlc3RlZCBpbiB0aGVzZSBzcGVjaWZpYyBhdHRyaWJ1dGVzLiAKPiBG
aXhtZTogc2hvdWxkIHdlIGRpZmZlcmVudGlhdGUgYmV0d2VlbiBkaWZmZXJlbnQgIm5hYSIgb3Ig
ZXVpIHN1YnR5cGVzLAo+IGxpa2UgIm5hYV9yZWdleHQiLCAiZXVpNjQiIG9yIHNpbWlsYXI/IElm
IHRoZSBkZXZpY2UgZGVmaW5lcyBtdWx0aXBsZQo+ICJuYWEiIGRlc2lnbmF0b3JzLCB3aGljaCBv
bmUgc2hvdWxkIHdlIGNob29zZT8KPiAKPiAgMy4gQ2hhbmdlIHVkZXYgcnVsZXMgc3VjaCB0aGF0
IHRoZXkgcHJpbWFyaWx5IGxvb2sgYXQgdGhlIGF0dHJpYnV0ZSBpbgo+IDEuKSBvbiBuZXcgaW5z
dGFsbG1lbnRzLCBhbmQgaW50cm9kdWNlIGEgdmFyaWFibGUgSURfTEVHQUNZIHRvIHRlbGwgdGhl
Cj4gcnVsZXMgdG8gZmFsbCBiYWNrIHRvIHRoZSBjdXJyZW50IGFsZ29yaXRobS4gSSBzdXBwb3Nl
IGl0IG1ha2VzIHNlbnNlCj4gdG8gaGF2ZSBhdCBsZWFzdCBJRF9WRU5ET1IgYW5kIElEX1BST0RV
Q1QgYXZhaWxhYmxlIHdoZW4gbWFraW5nIHRoaXMKPiBkZWNpc2lvbiwgc28gdGhhdCBpdCBkb2Vz
bid0IGhhdmUgdG8gYmUgYSBnbG9iYWwgc2V0dGluZyBvbiBhIGdpdmVuCj4gaG9zdC4KPiAKPiBX
aGlsZSB3ZSdyZSBhdCBpdCwgSSdkIGxpa2UgdG8gbWVudGlvbiBhbm90aGVyIGlzc3VlOiBXV0lE
IGNoYW5nZXMuCj4gCj4gVGhpcyBpcyBhIGJpZyBwcm9ibGVtIGZvciBtdWx0aXBhdGhkLiBUaGUg
Z2lzdCBpcyB0aGF0IHRoZSBkZXZpY2UKPiBpZGVudGlmaWNhdGlvbiBhdHRyaWJ1dGVzIGluIHN5
c2ZzIG9ubHkgY2hhbmdlIGFmdGVyIHJlc2Nhbm5pbmcgdGhlCj4gZGV2aWNlLiBUaHVzIGlmIGEg
dXNlciBjaGFuZ2VzIExVTiBhc3NpZ25tZW50cyBvbiBhIHN0b3JhZ2Ugc3lzdGVtLCAKPiBpdCBj
YW4gaGFwcGVuIHRoYXQgYSBkaXJlY3QgSU5RVUlSWSByZXR1cm5zIGEgZGlmZmVyZW50IFdXSUQg
YXMgaW4KPiBzeXNmcywgd2hpY2ggaXMgZmF0YWwuIElmIHdlIHBsYW4gdG8gcmVseSBtb3JlIG9u
IHN5c2ZzIGZvciBkZXZpY2UKPiBpZGVudGlmaWNhdGlvbiBpbiB0aGUgZnV0dXJlLCB0aGUgcHJv
YmxlbSBnZXRzIHdvcnNlLiAKCkkgdGhpbmsgbWFueSBkZXZpY2VzIHJlbHkgb24gdGhlIGZhY3Qg
dGhhdCB0aGV5IGFyZSBpZGVudGlmaWVkIGJ5ClZlbmRvci9tb2RlbC9zZXJpYWxfbnIsIGJlY2F1
c2UgaW4gbW9zdCBwcm9mZXNzaW9uYWwgU0FOIHN0b3JhZ2Ugc3lzdGVtcyB5b3UKY2FuIHByZS1z
ZXQgdGhlIHNlcmlhbCBudW1iZXIgdG8gYSBjdXN0b20gdmFsdWU7IHNvIGlmIHlvdSB3YW50IGEg
bmV3IGRpc2sKKG1heWJlIGEgc25hcHNob3QpIHRvIGJlIGNvbXBhdGlibGUgd2l0aCB0aGUgb2xk
IG9uZSwganVzdCBhc3NpZ24gdGhlIHNhbWUKc2VyaWFsIG51bWJlci4gSSBndWVzcyB0aGF0J3Mg
dGhlIGlkZWEgYmVoaW5kLgoKPiAKPiBJIHdvbmRlciBpZiB0aGVyZSdzIGEgY2hhbmNlIHRoYXQg
ZnV0dXJlIGtlcm5lbHMgd291bGQgYXV0b21hdGljYWxseQo+IHVwZGF0ZSB0aGUgYXR0cmlidXRl
cyBpZiBhIGNvcnJlc3BvbmRpbmcgVU5JVCBBVFRFTlRJT04gY29uZGl0aW9uIHN1Y2gKPiBhcyBJ
TlFVSVJZIERBVEEgSEFTIENIQU5HRUQgaXMgcmVjZWl2ZWQgKCopLCBvciBpZiB3ZSBjYW4gZmlu
ZCBzb21lCj4gb3RoZXIgd2F5IHRvIGF2b2lkIGRhdGEgY29ycnVwdGlvbiByZXN1bHRpbmcgZnJv
bSB3cml0aW5nIHRvIHRoZSB3cm9uZwo+IGRldmljZS4KPiAKPiBSZWdhcmRzLAo+IE1hcnRpbgo+
IAo+ICgqKSBJJ3ZlIGJlZW4gdG9sZCB0aGF0IFdXSUQgY2hhbmdlcyBjYW4gaGFwcGVuIGV2ZW4g
d2l0aG91dCByZWNlaXZpbmcKPiBhbiBVQS4gQnV0IGluIHRoYXQgY2FzZSBJJ20gaW5jbGluZWQg
dG8gcHV0IHRoZSBibGFtZSBvbiB0aGUgc3RvcmFnZS4KPiAKPiDigJHigJEgCj4gRHIuIE1hcnRp
biBXaWxjayA8bXdpbGNrQHN1c2UuY29tPiwgVGVsLiArNDkgKDApOTExIDc0MDUzIDIxMDcKPiBT
VVNFIFNvZnR3YXJlIFNvbHV0aW9ucyBHZXJtYW55IEdtYkgKPiBIUkIgMzY4MDksIEFHIE7DvHJu
YmVyZyBHRjogRmVsaXggSW1lbmTDtnJmZmVyCj4gCj4gCj4gX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18KPiBzeXN0ZW1k4oCRZGV2ZWwgbWFpbGluZyBsaXN0
Cj4gc3lzdGVtZOKAkWRldmVsQGxpc3RzLmZyZWVkZXNrdG9wLm9yZyAKPiBodHRwczovL2xpc3Rz
LmZyZWVkZXNrdG9wLm9yZy9tYWlsbWFuL2xpc3RpbmZvL3N5c3RlbWTigJFkZXZlbCAKCgoKCi0t
CmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1h
bi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=

