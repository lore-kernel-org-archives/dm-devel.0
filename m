Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DF0EECAAA1
	for <dm-devel@archiver.kernel.org>; Thu, 27 Oct 2022 21:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666905338;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Oav2nRU/td/GHFnBdm8de9uOz5P3pP+448YzW04lnkE=;
	b=aSE0S+JqddT0bPKHW8V9XTWjPaN6XdKu/qIw3PyrP6WphP3V6SfhsDCsfGTeuemyRnso8E
	57cXUnx6tAGiknf2pgYunX98OO80fSdoIDPvu68dEJW7Fgzq3UNwLjtfHDRAuvZP2qh0i3
	xRJmKEJmRz4j9GhMA/lmx0EJAJbaSqk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-350-iWFjyGwRMdCaQyQ3r6syVA-1; Thu, 27 Oct 2022 17:15:34 -0400
X-MC-Unique: iWFjyGwRMdCaQyQ3r6syVA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 14500800B30;
	Thu, 27 Oct 2022 21:15:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2129E2024CB7;
	Thu, 27 Oct 2022 21:15:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B2BE019465A4;
	Thu, 27 Oct 2022 21:15:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3402B1946597
 for <dm-devel@listman.corp.redhat.com>; Thu, 27 Oct 2022 21:15:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 126EC2166B2B; Thu, 27 Oct 2022 21:15:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0B9932166B26
 for <dm-devel@redhat.com>; Thu, 27 Oct 2022 21:15:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D6D12800186
 for <dm-devel@redhat.com>; Thu, 27 Oct 2022 21:15:27 +0000 (UTC)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-142-5royGE5-NbSogz1ehfSUOQ-1; Thu, 27 Oct 2022 17:15:26 -0400
X-MC-Unique: 5royGE5-NbSogz1ehfSUOQ-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by sin.source.kernel.org (Postfix) with ESMTPS id 72066CE2816;
 Thu, 27 Oct 2022 21:08:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A08C433B5;
 Thu, 27 Oct 2022 21:08:52 +0000 (UTC)
Date: Thu, 27 Oct 2022 14:08:52 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: "ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>
Message-ID: <Y1rzZN0wgLcie47z@magnolia>
References: <Yzt6eWLuX/RTjmjj@magnolia>
 <f196bcab-6aa2-6313-8a7c-f8ab409621b7@fujitsu.com>
 <Yzx64zGt2kTiDYaP@magnolia>
 <6a83a56e-addc-f3c4-2357-9589a49bf582@fujitsu.com>
 <Y1NRNtToQTjs0Dbd@magnolia>
 <20221023220018.GX3600936@dread.disaster.area>
 <OSBPR01MB2920CA997DDE891C06776279F42E9@OSBPR01MB2920.jpnprd01.prod.outlook.com>
 <20221024053109.GY3600936@dread.disaster.area>
 <dd00529c-d3ef-40e3-9dea-834c5203e3df@fujitsu.com>
 <Y1gjQ4wNZr3ve2+K@magnolia>
MIME-Version: 1.0
In-Reply-To: <Y1gjQ4wNZr3ve2+K@magnolia>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH] xfs: fail dax mount if reflink is enabled on
 a partition
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
Cc: "hch@infradead.org" <hch@infradead.org>, Theodore Ts'o <tytso@mit.edu>,
 "toshi.kani@hpe.com" <toshi.kani@hpe.com>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 Brian Foster <bfoster@redhat.com>,
 "yangx.jy@fujitsu.com" <yangx.jy@fujitsu.com>,
 Dave Chinner <david@fromorbit.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Yasunori Gotou \(Fujitsu\)" <y-goto@fujitsu.com>,
 Jeff Moyer <jmoyer@redhat.com>, "zwisler@kernel.org" <zwisler@kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

W2FkZCB0eXRzbyB0byBjYyBzaW5jZSBoZSBhc2tlZCBhYm91dCAiSG93IGRvIHlvdSBhY3R1YWxs
eSAvZ2V0LyBmc2RheAptb2RlIHRoZXNlIGRheXM/IiB0aGlzIG1vcm5pbmddCgpPbiBUdWUsIE9j
dCAyNSwgMjAyMiBhdCAxMDo1NjoxOUFNIC0wNzAwLCBEYXJyaWNrIEouIFdvbmcgd3JvdGU6Cj4g
T24gVHVlLCBPY3QgMjUsIDIwMjIgYXQgMDI6MjY6NTBQTSArMDAwMCwgcnVhbnN5LmZuc3RAZnVq
aXRzdS5jb20gd3JvdGU6Cj4gPiAKPiA+IAo+ID4g5ZyoIDIwMjIvMTAvMjQgMTM6MzEsIERhdmUg
Q2hpbm5lciDlhpnpgZM6Cj4gPiA+IE9uIE1vbiwgT2N0IDI0LCAyMDIyIGF0IDAzOjE3OjUyQU0g
KzAwMDAsIHJ1YW5zeS5mbnN0QGZ1aml0c3UuY29tIHdyb3RlOgo+ID4gPj4g5ZyoIDIwMjIvMTAv
MjQgNjowMCwgRGF2ZSBDaGlubmVyIOWGmemBkzoKPiA+ID4+PiBPbiBGcmksIE9jdCAyMSwgMjAy
MiBhdCAwNzoxMTowMlBNIC0wNzAwLCBEYXJyaWNrIEouIFdvbmcgd3JvdGU6Cj4gPiA+Pj4+IE9u
IFRodSwgT2N0IDIwLCAyMDIyIGF0IDEwOjE3OjQ1UE0gKzA4MDAsIFlhbmcsIFhpYW8v5p2oIOaZ
kyB3cm90ZToKPiA+ID4+Pj4+IEluIGFkZGl0aW9uLCBJIGRvbid0IGxpa2UgeW91ciBpZGVhIGFi
b3V0IHRoZSB0ZXN0IGNoYW5nZSBiZWNhdXNlIGl0IHdpbGwKPiA+ID4+Pj4+IG1ha2UgZ2VuZXJp
Yy80NzAgYmVjb21lIHRoZSBzcGVjaWFsIHRlc3QgZm9yIFhGUy4gRG8geW91IGtub3cgaWYgd2Ug
Y2FuIGZpeAo+ID4gPj4+Pj4gdGhlIGlzc3VlIGJ5IGNoYW5naW5nIHRoZSB0ZXN0IGluIGFub3Ro
ZXIgd2F5PyBibGtkaXNjYXJkIC16IGNhbiBmaXggdGhlCj4gPiA+Pj4+PiBpc3N1ZSBiZWNhdXNl
IGl0IGRvZXMgemVyby1maWxsIHJhdGhlciB0aGFuIGRpc2NhcmQgb24gdGhlIGJsb2NrIGRldmlj
ZS4KPiA+ID4+Pj4+IEhvd2V2ZXIsIGJsa2Rpc2NhcmQgLXogd2lsbCB0YWtlIGEgbG90IG9mIHRp
bWUgd2hlbiB0aGUgYmxvY2sgZGV2aWNlIGlzCj4gPiA+Pj4+PiBsYXJnZS4KPiA+ID4+Pj4KPiA+
ID4+Pj4gV2VsbCB3ZSAvY291bGQvIGp1c3QgZG8gdGhhdCB0b28sIGJ1dCB0aGF0IHdpbGwgc3Vj
ayBpZiB5b3UgaGF2ZSAyVEIgb2YKPiA+ID4+Pj4gcG1lbS4gOykKPiA+ID4+Pj4KPiA+ID4+Pj4g
TWF5YmUgYXMgYW4gYWx0ZXJuYXRpdmUgcGF0aCB3ZSBjb3VsZCBqdXN0IGNyZWF0ZSBhIHZlcnkg
c21hbGwKPiA+ID4+Pj4gZmlsZXN5c3RlbSBvbiB0aGUgcG1lbSBhbmQgdGhlbiBibGtkaXNjYXJk
IC16IGl0Pwo+ID4gPj4+Pgo+ID4gPj4+PiBUaGF0IHNhaWQgLS0gZG9lcyBwZXJzaXN0ZW50IG1l
bW9yeSBhY3R1YWxseSBoYXZlIGEgZnV0dXJlPyAgSW50ZWwKPiA+ID4+Pj4gc2N1dHRsZWQgdGhl
IGVudGlyZSBPcHRhbmUgcHJvZHVjdCwgY3hsLm1lbSBzb3VuZHMgbGlrZSBleHBhbnNpb24KPiA+
ID4+Pj4gY2hhc3NpcyBmdWxsIG9mIERSQU0sIGFuZCBmc2RheCBpcyBob3JyaWJseSBicm9rZW4g
aW4gNi4wICh3ZWlyZCBrZXJuZWwKPiA+ID4+Pj4gYXNzZXJ0cyBldmVyeXdoZXJlKSBhbmQgNi4x
IChldmVyeSB0aW1lIEkgcnVuIGZzdGVzdHMgbm93IEkgc2VlIG1hc3NpdmUKPiA+ID4+Pj4gZGF0
YSBjb3JydXB0aW9uKS4KPiA+ID4+Pgo+ID4gPj4+IFl1cCwgSSBzZWUgdGhlIHNhbWUgdGhpbmcu
IGZzZGF4IHdhcyBhIHRyYWluIHdyZWNrIGluIDYuMCAtIGJyb2tlbgo+ID4gPj4+IG9uIGJvdGgg
ZXh0NCBhbmQgWEZTLiBOb3cgdGhhdCBJIHJ1biBhIHF1aWNrIGNoZWNrIG9uIDYuMS1yYzEsIEkK
PiA+ID4+PiBkb24ndCB0aGluayB0aGF0IGhhcyBjaGFuZ2VkIGF0IGFsbCAtIEkgc3RpbGwgc2Vl
IGxvdHMgb2Yga2VybmVsCj4gPiA+Pj4gd2FybmluZ3MsIGRhdGEgY29ycnVwdGlvbiBhbmQgIlhG
U19JT0NfQ0xPTkVfUkFOR0U6IEludmFsaWQKPiA+ID4+PiBhcmd1bWVudCIgZXJyb3JzLgo+ID4g
Pj4KPiA+ID4+IEZpcnN0bHksIEkgdGhpbmsgdGhlICJYRlNfSU9DX0NMT05FX1JBTkdFOiBJbnZh
bGlkIGFyZ3VtZW50IiBlcnJvciBpcwo+ID4gPj4gY2F1c2VkIGJ5IHRoZSByZXN0cmljdGlvbnMg
d2hpY2ggcHJldmVudCByZWZsaW5rIHdvcmsgdG9nZXRoZXIgd2l0aCBEQVg6Cj4gPiA+Pgo+ID4g
Pj4gYS4gZnMveGZzL3hmc19pb2N0bC5jOjExNDEKPiA+ID4+IC8qIERvbid0IGFsbG93IHVzIHRv
IHNldCBEQVggbW9kZSBmb3IgYSByZWZsaW5rZWQgZmlsZSBmb3Igbm93LiAqLwo+ID4gPj4gaWYg
KChmYS0+ZnN4X3hmbGFncyAmIEZTX1hGTEFHX0RBWCkgJiYgeGZzX2lzX3JlZmxpbmtfaW5vZGUo
aXApKQo+ID4gPj4gICAgICAgICAgcmV0dXJuIC1FSU5WQUw7Cj4gPiA+Pgo+ID4gPj4gYi4gZnMv
eGZzL3hmc19pb3BzLmM6MTE3NAo+ID4gPj4gLyogT25seSBzdXBwb3J0ZWQgb24gbm9uLXJlZmxp
bmtlZCBmaWxlcy4gKi8KPiA+ID4+IGlmICh4ZnNfaXNfcmVmbGlua19pbm9kZShpcCkpCj4gPiA+
PiAgICAgICAgICByZXR1cm4gZmFsc2U7Cj4gPiA+Pgo+ID4gPj4gVGhlc2UgcmVzdHJpY3Rpb25z
IHdlcmUgcmVtb3ZlZCBpbiAiZHJvcCBleHBlcmltZW50YWwgd2FybmluZyIgcGF0Y2hbMV0uCj4g
PiA+PiAgICBJIHRoaW5rIHRoZXkgc2hvdWxkIGJlIHNlcGFyYXRlZCBmcm9tIHRoYXQgcGF0Y2gu
Cj4gPiA+Pgo+ID4gPj4gWzFdCj4gPiA+PiBodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC14
ZnMvMTY2MzIzNDAwMi0xNy0xLWdpdC1zZW5kLWVtYWlsLXJ1YW5zeS5mbnN0QGZ1aml0c3UuY29t
Lwo+ID4gPj4KPiA+ID4+Cj4gPiA+PiBTZWNvbmRseSwgaG93IHRoZSBkYXRhIGNvcnJ1cHRpb24g
aGFwcGVuZWQ/Cj4gPiA+IAo+ID4gPiBObyBpZGVhIC0gaSJtIGp1c3QgcmVwb3J0aW5nIHRoYXQg
bG90cyBvZiBmc3ggdGVzdHMgZmFpbGVkIHdpdGggZGF0YQo+ID4gPiBjb3JydXB0aW9ucy4gSSBo
YXZlbid0IGhhZCB0aW1lIHRvIGxvb2sgYXQgd2h5LCBJJ20gc3RpbGwgdHJ5aW5nIHRvCj4gPiA+
IHNvcnQgb3V0IHRoZSBmaXggZm9yIGEgZGlmZmVyZW50IGRhdGEgY29ycnVwdGlvbi4uLgo+ID4g
PiAKPiA+ID4+IE9yIHdoaWNoIGNhc2UgZmFpbGVkPwo+ID4gPiAKPiA+ID4gKmxvdHMqIG9mIHRo
ZW0gZmFpbGVkIHdpdGgga2VybmVsIHdhcm5pbmdzIHdpdGggcmVmbGluayB0dXJuZWQgb2ZmOgo+
ID4gPiAKPiA+ID4gU0VDVElPTiAgICAgICAtLSB4ZnNfZGF4X25vcmVmbGluawo+ID4gPiA9PT09
PT09PT09PT09PT09PT09PT09PT09Cj4gPiA+IEZhaWx1cmVzOiBnZW5lcmljLzA1MSBnZW5lcmlj
LzA2OCBnZW5lcmljLzA3NSBnZW5lcmljLzA4Mwo+ID4gPiBnZW5lcmljLzExMiBnZW5lcmljLzEy
NyBnZW5lcmljLzE5OCBnZW5lcmljLzIzMSBnZW5lcmljLzI0Nwo+ID4gPiBnZW5lcmljLzI2OSBn
ZW5lcmljLzI3MCBnZW5lcmljLzM0MCBnZW5lcmljLzM0NCBnZW5lcmljLzM4OAo+ID4gPiBnZW5l
cmljLzQ2MSBnZW5lcmljLzQ3MSBnZW5lcmljLzQ3NiBnZW5lcmljLzUxOSBnZW5lcmljLzU2MSB4
ZnMvMDExCj4gPiA+IHhmcy8wMTMgeGZzLzA3MyB4ZnMvMjk3IHhmcy8zMDUgeGZzLzUxNyB4ZnMv
NTM4Cj4gPiA+IEZhaWxlZCAyNiBvZiAxMDc5IHRlc3RzCj4gPiA+IAo+ID4gPiBBbGwgb2YgdGhv
c2UgZXhjZXB0IHhmcy8wNzMgYW5kIGdlbmVyaWMvNDcxIGFyZSBmYWlsdXJlcyBkdWUgdG8KPiA+
ID4gd2FybmluZ3MgZm91bmQgaW4gZG1lc2cuCj4gPiA+IAo+ID4gPiBXaXRoIHJlZmxpbmsgZW5h
YmxlZCwgSSB0ZXJtaW5hdGVkIHRoZSBydW4gYWZ0ZXIgZy8wNzUsIGcvMDkxLCBnLzExMgo+ID4g
PiBhbmQgZ2VuZXJpYy8xMjcgcmVwb3J0ZWQgZnN4IGRhdGEgY29ycnVwdGlvbnMgYW5kIGcvMDUx
LCBnLzA2OCwKPiA+ID4gZy8wNzUgYW5kIGcvMDgzIGhhZCByZXBvcnRlZCBrZXJuZWwgd2Fybmlu
Z3MgaW4gZG1lc2cuCj4gPiA+IAo+ID4gPj4gQ291bGQKPiA+ID4+IHlvdSBnaXZlIG1lIG1vcmUg
aW5mbyAoc3VjaCBhcyBta2ZzIG9wdGlvbnMsIHhmc3Rlc3RzIGNvbmZpZ3MpPwo+ID4gPiAKPiA+
ID4gVGhleSBhcmUgZXhhY3RseSB0aGUgc2FtZSBhcyBsYXN0IHRpbWUgSSByZXBvcnRlZCB0aGVz
ZSBwcm9ibGVtcy4KPiA+ID4gCj4gPiA+IEZvciB0aGUgIm5vIHJlZmxpbmsiIHRlc3QgaXNzdWVz
Ogo+ID4gPiAKPiA+ID4gbWtmcyBvcHRpb25zIGFyZSAiLW0gcmVmbGluaz0wLHJtYXBidD0xIiwg
bW91bnQgb3B0aW9ucyAiLW8KPiA+ID4gZGF4PWFsd2F5cyIgZm9yIGJvdGggZmlsZXN5dGVtcy4g
IENvbmZpZyBvdXRwdXQgYXQgc3RhcnQgb2YgdGVzdAo+ID4gPiBydW46Cj4gPiA+IAo+ID4gPiBT
RUNUSU9OICAgICAgIC0tIHhmc19kYXhfbm9yZWZsaW5rCj4gPiA+IEZTVFlQICAgICAgICAgLS0g
eGZzIChkZWJ1ZykKPiA+ID4gUExBVEZPUk0gICAgICAtLSBMaW51eC94ODZfNjQgdGVzdDMgNi4x
LjAtcmMxLWRnYysgIzE2MTUgU01QIFBSRUVNUFRfRFlOQU1JQyBXZWQgT2N0IDE5IDEyOjI0OjE2
IEFFRFQgMjAyMgo+ID4gPiBNS0ZTX09QVElPTlMgIC0tIC1mIC1tIHJlZmxpbms9MCxybWFwYnQ9
MSAvZGV2L3BtZW0xCj4gPiA+IE1PVU5UX09QVElPTlMgLS0gLW8gZGF4PWFsd2F5cyAtbyBjb250
ZXh0PXN5c3RlbV91Om9iamVjdF9yOnJvb3RfdDpzMCAvZGV2L3BtZW0xIC9tbnQvc2NyYXRjaAo+
ID4gPiAKPiA+ID4gcG1lbSBkZXZpY2VzIGFyZSBhIHBhaXIgb2YgZmFrZSA4R0IgcG1lbSByZWdp
b25zIHNldCB1cCBieSBrZXJuZWwKPiA+ID4gQ0xJIHZpYSAibWVtbWFwPThHITE1Ryw4RyEyNEci
LiBJIGRvbid0IGhhdmUgYW55dGhpbmcgc3BlY2lhbCBzZXQgdXAKPiA+ID4gLSB0aGUga2VybmVs
IGNvbmZpZyBpcyBrZXB0IG1pbmltYWwgZm9yIHRoZXNlIFZNcyAtIGFuZCB0aGUgb25seQo+ID4g
PiBrZXJuZWwgZGVidWcgb3B0aW9uIEkgaGF2ZSB0dXJuZWQgb24gZm9yIHRoZXNlIHNwZWNpZmlj
IHRlc3QgcnVucyBpcwo+ID4gPiBDT05GSUdfWEZTX0RFQlVHPXkuCj4gPiAKPiA+IFRoYW5rcyBm
b3IgdGhlIGRldGFpbGVkIGluZm8uICBCdXQsIGluIG15IGVudmlyb25tZW50IChhbmQgbXkgCj4g
PiBjb2xsZWFndWVzJywgYW5kIG91ciByZWFsIHNlcnZlciB3aXRoIERDUE1NKSB0aGVzZSBmYWls
dXJlIGNhc2VzICh5b3UgCj4gPiBtZW50aW9uZWQgYWJvdmUsIGluIGRheCtub25fcmVmbGluayBt
b2RlLCB3aXRoIHNhbWUgdGVzdCBvcHRpb25zKSBjYW5ub3QgCj4gPiByZXByb2R1Y2UuCj4gPiAK
PiA+IEhlcmUncyBvdXIgdGVzdCBlbnZpcm9ubWVudCBpbmZvOgo+ID4gICAtIFJ1YW4ncyBlbnY6
IGZlZG9yYSAzNih2Ni4wLXJjMSkgb24ga3ZtLHBtZW0gMng0RzpmaWxlIGJhY2tlbmRlZAo+ID4g
ICAtIFlhbmcncyBlbnY6IGZlZG9yYSAzNSh2Ni4xLXJjMSkgb24ga3ZtLHBtZW0gMngxRzptZW1t
YXA9MUchMUcsMUchMkcKPiA+ICAgLSBTZXJ2ZXIncyAgOiBVYnVudHUgMjAuMDQodjYuMC1yYzEp
IHJlYWwgbWFjaGluZSxwbWVtIDJ4NEc6cmVhbCBEQ1BNTQo+ID4gCj4gPiAoVG8gcXVpY2tseSBj
b25maXJtIHRoZSBkaWZmZXJlbmNlLCBJIGp1c3QgcmFuIHRoZSBmYWlsZWQgMjYgY2FzZXMgeW91
IAo+ID4gbWVudGlvbmVkIGFib3ZlLikgIEV4Y2VwdCBmb3IgZ2VuZXJpYy80NzEgYW5kIGdlbmVy
aWMvNTE5LCB3aGljaCBmYWlsZWQgCj4gPiBldmVuIHdoZW4gZGF4IGlzIG9mZiwgdGhlIHJlc3Qg
cGFzc2VkLgo+ID4gCj4gPiAKPiA+IFdlIGRvbid0IHdhbnQgZnNkYXggdG8gYmUgdHJ1bmVkIG9m
Zi4gIFJpZ2h0IG5vdywgSSB0aGluayB0aGUgbW9zdCAKPiA+IGltcG9ydGFudCB0aGluZyBpcyBz
b2x2aW5nIHRoZSBmYWlsZWQgY2FzZXMgaW4gZGF4K25vbl9yZWZsaW5rIG1vZGUuIAo+ID4gU28s
IGZpcnN0bHksIEkgaGF2ZSB0byByZXByb2R1Y2UgdGhvc2UgZmFpbHVyZXMuICBJcyB0aGVyZSBh
bnkgdGhpbmcgCj4gPiB3cm9uZyB3aXRoIG15IHRlc3QgZW52aXJvbm1lbnRzPyAgSSBrb253IHlv
dSBhcmUgdXNpbmcgJ21lbW1hcD1YWEchWVlHJyB0byAKPiA+IHNpbXVsYXRlIHBtZW0uICBTbywg
KHRvIERhcnJpY2spIGNvdWxkIHlvdSBzaG93IG1lIHlvdXIgY29uZmlnIG9mIGRldiAKPiA+IGVu
dmlyb25tZW50IGFuZCB0aGUgJ3Rlc3RjbG91ZCcoSSBhbSBndWVzc2luZyBpdCdzIGEgc2VydmVy
IHdpdGggcmVhbCAKPiA+IG52ZGltbSBqdXN0IGxpa2Ugb3Vycyk/Cj4gCj4gTm9wZS4gIFNpbmNl
IHRoZSBhbm5vdW5jZW1lbnQgb2YgcG1lbSBhcyBhIHByb2R1Y3QsIEkgaGF2ZSBoYWQgMTUKPiBt
aW51dGVzIG9mIGFjY2VzIHRvIG9uZSBwcmVwcm9kdWN0aW9uIHByb3RvdHlwZSBzZXJ2ZXIgd2l0
aCBhY3R1YWwKPiBvcHRhbmUgRElNTXMgaW4gdGhlbS4KPiAKPiBJIGhhdmUgL25ldmVyLyBoYWQg
YWNjZXNzIHRvIHJlYWwgaGFyZHdhcmUgdG8gdGVzdCBhbnkgb2YgdGhpcywgc28gaXQncwo+IGFs
bCBjb25maWd1cmVkIHZpYSBsaWJ2aXJ0IHRvIHNpbXVsYXRlIHBtZW0gaW4gcWVtdToKPiBodHRw
czovL2xvcmUua2VybmVsLm9yZy9saW51eC14ZnMvWXpYc2F2T1dNU3V3VEJFQ0BtYWdub2xpYS8K
PiAKPiAvcnVuL210cmRpc2svW2doXS5tZW0gYXJlIGJvdGggcmVndWxhciBmaWxlcyBvbiBhIHRt
cGZzIGZpbGVzeXN0ZW06Cj4gCj4gJCBncmVwIG10cmRpc2sgL3Byb2MvbW91bnRzCj4gbm9uZSAv
cnVuL210cmRpc2sgdG1wZnMgcncscmVsYXRpbWUsc2l6ZT04Mjg5NDg0OGssaW5vZGU2NCAwIDAK
PiAKPiAkIGxzIC1sYSAvcnVuL210cmRpc2svW2doXS5tZW0KPiAtcnctci0tci0tIDEgbGlidmly
dC1xZW11IGt2bSAxMDczOTUxNTM5MiBPY3QgMjQgMTg6MDkgL3J1bi9tdHJkaXNrL2cubWVtCj4g
LXJ3LXItLXItLSAxIGxpYnZpcnQtcWVtdSBrdm0gMTA3Mzk1MTUzOTIgT2N0IDI0IDE5OjI4IC9y
dW4vbXRyZGlzay9oLm1lbQoKQWxzbyBmb3Jnb3QgdG8gbWVudGlvbiB0aGF0IHRoZSBWTSB3aXRo
IHRoZSBmYWtlIHBtZW0gYXR0YWNoZWQgaGFzIGEKc2NyaXB0IHRvIGRvOgoKbmRjdGwgY3JlYXRl
LW5hbWVzcGFjZSAtLW1vZGUgZnNkYXggLS1tYXAgZGV2IC1lIG5hbWVzcGFjZTAuMCAtZgpuZGN0
bCBjcmVhdGUtbmFtZXNwYWNlIC0tbW9kZSBmc2RheCAtLW1hcCBkZXYgLWUgbmFtZXNwYWNlMS4w
IC1mCgpFdmVyeSB0aW1lIHRoZSBwbWVtIGRldmljZSBnZXRzIHJlY3JlYXRlZCwgYmVjYXVzZSBh
cHBhcmVudGx5IHRoYXQncyB0aGUKb25seSB3YXkgdG8gZ2V0IFNfREFYIG1vZGUgbm93YWRheXM/
CgotLUQKCj4gLS1ECj4gCj4gPiAKPiA+IAo+ID4gKEkganVzdCBmb3VuZCBJIG9ubHkgdGVzdGVk
IG9uIDRHIGFuZCBzbWFsbGVyIHBtZW0gZGV2aWNlLiAgSSdsbCB0cnkgdGhlIAo+ID4gdGVzdCBv
biA4RyBwbWVtKQo+ID4gCj4gPiA+IAo+ID4gPiBUSGUgb25seSBkaWZmZXJlbmNlIGJldHdlZW4g
dGhlIG5vcmVmbGluayBhbmQgcmVmbGluayBydW5zIGlzIHRoYXQgSQo+ID4gPiBkcm9wIHRoZSAi
LW0gcmVmbGluaz0wIiBta2ZzIHBhcmFtZXRlci4gT3RoZXJ3aXNlIHRoZXkgYXJlIGlkZW50aWNh
bAo+ID4gPiBhbmQgdGhlIGVycm9ycyBJIHJlcG9ydGVkIGFyZSBmcm9tIGJhY2stdG8tYmFjayBm
c3Rlc3RzIHJ1bnMgd2l0aG91dAo+ID4gPiByZWJvb3RpbmcgdGhlIFZNLi4uLgo+ID4gPiAKPiA+
ID4gLURhdmUuCj4gPiAKPiA+IAo+ID4gLS0KPiA+IFRoYW5rcywKPiA+IFJ1YW4uCgotLQpkbS1k
ZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVk
aGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

