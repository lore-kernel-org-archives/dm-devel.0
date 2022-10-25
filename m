Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B7AAC38A2D
	for <dm-devel@archiver.kernel.org>; Tue, 25 Oct 2022 17:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666720599;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=iSTpoVME3w+xyNuOhSBqWY4bbphOzjx0fLYlmKrg2fI=;
	b=SRecuzqOZprwT3WD7YAxYQrslAXnB1sjOgwlC9kHPe9Bx5klAijC0exEviGlxAsvPZC5mT
	wT/HS6jCmg338SNZKEeUoc5qY5+EmWHOg6qIxr00c0V4jdkrAKOTbGwAsGzkvbUYD0encK
	W/AUAqyuMVADeDiCcE1eEbej8tradxE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-351-rq0YQfHYO2anFBiD64e8iw-1; Tue, 25 Oct 2022 13:56:35 -0400
X-MC-Unique: rq0YQfHYO2anFBiD64e8iw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5EE25381A72C;
	Tue, 25 Oct 2022 17:56:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 70439C15BB1;
	Tue, 25 Oct 2022 17:56:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2C96019465A4;
	Tue, 25 Oct 2022 17:56:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CD74B1946597
 for <dm-devel@listman.corp.redhat.com>; Tue, 25 Oct 2022 17:56:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 884A0492B11; Tue, 25 Oct 2022 17:56:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 809EF492B0A
 for <dm-devel@redhat.com>; Tue, 25 Oct 2022 17:56:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2B96988B776
 for <dm-devel@redhat.com>; Tue, 25 Oct 2022 17:56:27 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-573-QF2DLDckNDmsE2qtoEL6Yg-1; Tue, 25 Oct 2022 13:56:23 -0400
X-MC-Unique: QF2DLDckNDmsE2qtoEL6Yg-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 46C66B81E54;
 Tue, 25 Oct 2022 17:56:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D31C0C433C1;
 Tue, 25 Oct 2022 17:56:19 +0000 (UTC)
Date: Tue, 25 Oct 2022 10:56:19 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: "ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>
Message-ID: <Y1gjQ4wNZr3ve2+K@magnolia>
References: <1444b9b5-363a-163c-0513-55d1ea951799@fujitsu.com>
 <Yzt6eWLuX/RTjmjj@magnolia>
 <f196bcab-6aa2-6313-8a7c-f8ab409621b7@fujitsu.com>
 <Yzx64zGt2kTiDYaP@magnolia>
 <6a83a56e-addc-f3c4-2357-9589a49bf582@fujitsu.com>
 <Y1NRNtToQTjs0Dbd@magnolia>
 <20221023220018.GX3600936@dread.disaster.area>
 <OSBPR01MB2920CA997DDE891C06776279F42E9@OSBPR01MB2920.jpnprd01.prod.outlook.com>
 <20221024053109.GY3600936@dread.disaster.area>
 <dd00529c-d3ef-40e3-9dea-834c5203e3df@fujitsu.com>
MIME-Version: 1.0
In-Reply-To: <dd00529c-d3ef-40e3-9dea-834c5203e3df@fujitsu.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
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
Cc: "hch@infradead.org" <hch@infradead.org>,
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVHVlLCBPY3QgMjUsIDIwMjIgYXQgMDI6MjY6NTBQTSArMDAwMCwgcnVhbnN5LmZuc3RAZnVq
aXRzdS5jb20gd3JvdGU6Cj4gCj4gCj4g5ZyoIDIwMjIvMTAvMjQgMTM6MzEsIERhdmUgQ2hpbm5l
ciDlhpnpgZM6Cj4gPiBPbiBNb24sIE9jdCAyNCwgMjAyMiBhdCAwMzoxNzo1MkFNICswMDAwLCBy
dWFuc3kuZm5zdEBmdWppdHN1LmNvbSB3cm90ZToKPiA+PiDlnKggMjAyMi8xMC8yNCA2OjAwLCBE
YXZlIENoaW5uZXIg5YaZ6YGTOgo+ID4+PiBPbiBGcmksIE9jdCAyMSwgMjAyMiBhdCAwNzoxMTow
MlBNIC0wNzAwLCBEYXJyaWNrIEouIFdvbmcgd3JvdGU6Cj4gPj4+PiBPbiBUaHUsIE9jdCAyMCwg
MjAyMiBhdCAxMDoxNzo0NVBNICswODAwLCBZYW5nLCBYaWFvL+adqCDmmZMgd3JvdGU6Cj4gPj4+
Pj4gSW4gYWRkaXRpb24sIEkgZG9uJ3QgbGlrZSB5b3VyIGlkZWEgYWJvdXQgdGhlIHRlc3QgY2hh
bmdlIGJlY2F1c2UgaXQgd2lsbAo+ID4+Pj4+IG1ha2UgZ2VuZXJpYy80NzAgYmVjb21lIHRoZSBz
cGVjaWFsIHRlc3QgZm9yIFhGUy4gRG8geW91IGtub3cgaWYgd2UgY2FuIGZpeAo+ID4+Pj4+IHRo
ZSBpc3N1ZSBieSBjaGFuZ2luZyB0aGUgdGVzdCBpbiBhbm90aGVyIHdheT8gYmxrZGlzY2FyZCAt
eiBjYW4gZml4IHRoZQo+ID4+Pj4+IGlzc3VlIGJlY2F1c2UgaXQgZG9lcyB6ZXJvLWZpbGwgcmF0
aGVyIHRoYW4gZGlzY2FyZCBvbiB0aGUgYmxvY2sgZGV2aWNlLgo+ID4+Pj4+IEhvd2V2ZXIsIGJs
a2Rpc2NhcmQgLXogd2lsbCB0YWtlIGEgbG90IG9mIHRpbWUgd2hlbiB0aGUgYmxvY2sgZGV2aWNl
IGlzCj4gPj4+Pj4gbGFyZ2UuCj4gPj4+Pgo+ID4+Pj4gV2VsbCB3ZSAvY291bGQvIGp1c3QgZG8g
dGhhdCB0b28sIGJ1dCB0aGF0IHdpbGwgc3VjayBpZiB5b3UgaGF2ZSAyVEIgb2YKPiA+Pj4+IHBt
ZW0uIDspCj4gPj4+Pgo+ID4+Pj4gTWF5YmUgYXMgYW4gYWx0ZXJuYXRpdmUgcGF0aCB3ZSBjb3Vs
ZCBqdXN0IGNyZWF0ZSBhIHZlcnkgc21hbGwKPiA+Pj4+IGZpbGVzeXN0ZW0gb24gdGhlIHBtZW0g
YW5kIHRoZW4gYmxrZGlzY2FyZCAteiBpdD8KPiA+Pj4+Cj4gPj4+PiBUaGF0IHNhaWQgLS0gZG9l
cyBwZXJzaXN0ZW50IG1lbW9yeSBhY3R1YWxseSBoYXZlIGEgZnV0dXJlPyAgSW50ZWwKPiA+Pj4+
IHNjdXR0bGVkIHRoZSBlbnRpcmUgT3B0YW5lIHByb2R1Y3QsIGN4bC5tZW0gc291bmRzIGxpa2Ug
ZXhwYW5zaW9uCj4gPj4+PiBjaGFzc2lzIGZ1bGwgb2YgRFJBTSwgYW5kIGZzZGF4IGlzIGhvcnJp
Ymx5IGJyb2tlbiBpbiA2LjAgKHdlaXJkIGtlcm5lbAo+ID4+Pj4gYXNzZXJ0cyBldmVyeXdoZXJl
KSBhbmQgNi4xIChldmVyeSB0aW1lIEkgcnVuIGZzdGVzdHMgbm93IEkgc2VlIG1hc3NpdmUKPiA+
Pj4+IGRhdGEgY29ycnVwdGlvbikuCj4gPj4+Cj4gPj4+IFl1cCwgSSBzZWUgdGhlIHNhbWUgdGhp
bmcuIGZzZGF4IHdhcyBhIHRyYWluIHdyZWNrIGluIDYuMCAtIGJyb2tlbgo+ID4+PiBvbiBib3Ro
IGV4dDQgYW5kIFhGUy4gTm93IHRoYXQgSSBydW4gYSBxdWljayBjaGVjayBvbiA2LjEtcmMxLCBJ
Cj4gPj4+IGRvbid0IHRoaW5rIHRoYXQgaGFzIGNoYW5nZWQgYXQgYWxsIC0gSSBzdGlsbCBzZWUg
bG90cyBvZiBrZXJuZWwKPiA+Pj4gd2FybmluZ3MsIGRhdGEgY29ycnVwdGlvbiBhbmQgIlhGU19J
T0NfQ0xPTkVfUkFOR0U6IEludmFsaWQKPiA+Pj4gYXJndW1lbnQiIGVycm9ycy4KPiA+Pgo+ID4+
IEZpcnN0bHksIEkgdGhpbmsgdGhlICJYRlNfSU9DX0NMT05FX1JBTkdFOiBJbnZhbGlkIGFyZ3Vt
ZW50IiBlcnJvciBpcwo+ID4+IGNhdXNlZCBieSB0aGUgcmVzdHJpY3Rpb25zIHdoaWNoIHByZXZl
bnQgcmVmbGluayB3b3JrIHRvZ2V0aGVyIHdpdGggREFYOgo+ID4+Cj4gPj4gYS4gZnMveGZzL3hm
c19pb2N0bC5jOjExNDEKPiA+PiAvKiBEb24ndCBhbGxvdyB1cyB0byBzZXQgREFYIG1vZGUgZm9y
IGEgcmVmbGlua2VkIGZpbGUgZm9yIG5vdy4gKi8KPiA+PiBpZiAoKGZhLT5mc3hfeGZsYWdzICYg
RlNfWEZMQUdfREFYKSAmJiB4ZnNfaXNfcmVmbGlua19pbm9kZShpcCkpCj4gPj4gICAgICAgICAg
cmV0dXJuIC1FSU5WQUw7Cj4gPj4KPiA+PiBiLiBmcy94ZnMveGZzX2lvcHMuYzoxMTc0Cj4gPj4g
LyogT25seSBzdXBwb3J0ZWQgb24gbm9uLXJlZmxpbmtlZCBmaWxlcy4gKi8KPiA+PiBpZiAoeGZz
X2lzX3JlZmxpbmtfaW5vZGUoaXApKQo+ID4+ICAgICAgICAgIHJldHVybiBmYWxzZTsKPiA+Pgo+
ID4+IFRoZXNlIHJlc3RyaWN0aW9ucyB3ZXJlIHJlbW92ZWQgaW4gImRyb3AgZXhwZXJpbWVudGFs
IHdhcm5pbmciIHBhdGNoWzFdLgo+ID4+ICAgIEkgdGhpbmsgdGhleSBzaG91bGQgYmUgc2VwYXJh
dGVkIGZyb20gdGhhdCBwYXRjaC4KPiA+Pgo+ID4+IFsxXQo+ID4+IGh0dHBzOi8vbG9yZS5rZXJu
ZWwub3JnL2xpbnV4LXhmcy8xNjYzMjM0MDAyLTE3LTEtZ2l0LXNlbmQtZW1haWwtcnVhbnN5LmZu
c3RAZnVqaXRzdS5jb20vCj4gPj4KPiA+Pgo+ID4+IFNlY29uZGx5LCBob3cgdGhlIGRhdGEgY29y
cnVwdGlvbiBoYXBwZW5lZD8KPiA+IAo+ID4gTm8gaWRlYSAtIGkibSBqdXN0IHJlcG9ydGluZyB0
aGF0IGxvdHMgb2YgZnN4IHRlc3RzIGZhaWxlZCB3aXRoIGRhdGEKPiA+IGNvcnJ1cHRpb25zLiBJ
IGhhdmVuJ3QgaGFkIHRpbWUgdG8gbG9vayBhdCB3aHksIEknbSBzdGlsbCB0cnlpbmcgdG8KPiA+
IHNvcnQgb3V0IHRoZSBmaXggZm9yIGEgZGlmZmVyZW50IGRhdGEgY29ycnVwdGlvbi4uLgo+ID4g
Cj4gPj4gT3Igd2hpY2ggY2FzZSBmYWlsZWQ/Cj4gPiAKPiA+ICpsb3RzKiBvZiB0aGVtIGZhaWxl
ZCB3aXRoIGtlcm5lbCB3YXJuaW5ncyB3aXRoIHJlZmxpbmsgdHVybmVkIG9mZjoKPiA+IAo+ID4g
U0VDVElPTiAgICAgICAtLSB4ZnNfZGF4X25vcmVmbGluawo+ID4gPT09PT09PT09PT09PT09PT09
PT09PT09PQo+ID4gRmFpbHVyZXM6IGdlbmVyaWMvMDUxIGdlbmVyaWMvMDY4IGdlbmVyaWMvMDc1
IGdlbmVyaWMvMDgzCj4gPiBnZW5lcmljLzExMiBnZW5lcmljLzEyNyBnZW5lcmljLzE5OCBnZW5l
cmljLzIzMSBnZW5lcmljLzI0Nwo+ID4gZ2VuZXJpYy8yNjkgZ2VuZXJpYy8yNzAgZ2VuZXJpYy8z
NDAgZ2VuZXJpYy8zNDQgZ2VuZXJpYy8zODgKPiA+IGdlbmVyaWMvNDYxIGdlbmVyaWMvNDcxIGdl
bmVyaWMvNDc2IGdlbmVyaWMvNTE5IGdlbmVyaWMvNTYxIHhmcy8wMTEKPiA+IHhmcy8wMTMgeGZz
LzA3MyB4ZnMvMjk3IHhmcy8zMDUgeGZzLzUxNyB4ZnMvNTM4Cj4gPiBGYWlsZWQgMjYgb2YgMTA3
OSB0ZXN0cwo+ID4gCj4gPiBBbGwgb2YgdGhvc2UgZXhjZXB0IHhmcy8wNzMgYW5kIGdlbmVyaWMv
NDcxIGFyZSBmYWlsdXJlcyBkdWUgdG8KPiA+IHdhcm5pbmdzIGZvdW5kIGluIGRtZXNnLgo+ID4g
Cj4gPiBXaXRoIHJlZmxpbmsgZW5hYmxlZCwgSSB0ZXJtaW5hdGVkIHRoZSBydW4gYWZ0ZXIgZy8w
NzUsIGcvMDkxLCBnLzExMgo+ID4gYW5kIGdlbmVyaWMvMTI3IHJlcG9ydGVkIGZzeCBkYXRhIGNv
cnJ1cHRpb25zIGFuZCBnLzA1MSwgZy8wNjgsCj4gPiBnLzA3NSBhbmQgZy8wODMgaGFkIHJlcG9y
dGVkIGtlcm5lbCB3YXJuaW5ncyBpbiBkbWVzZy4KPiA+IAo+ID4+IENvdWxkCj4gPj4geW91IGdp
dmUgbWUgbW9yZSBpbmZvIChzdWNoIGFzIG1rZnMgb3B0aW9ucywgeGZzdGVzdHMgY29uZmlncyk/
Cj4gPiAKPiA+IFRoZXkgYXJlIGV4YWN0bHkgdGhlIHNhbWUgYXMgbGFzdCB0aW1lIEkgcmVwb3J0
ZWQgdGhlc2UgcHJvYmxlbXMuCj4gPiAKPiA+IEZvciB0aGUgIm5vIHJlZmxpbmsiIHRlc3QgaXNz
dWVzOgo+ID4gCj4gPiBta2ZzIG9wdGlvbnMgYXJlICItbSByZWZsaW5rPTAscm1hcGJ0PTEiLCBt
b3VudCBvcHRpb25zICItbwo+ID4gZGF4PWFsd2F5cyIgZm9yIGJvdGggZmlsZXN5dGVtcy4gIENv
bmZpZyBvdXRwdXQgYXQgc3RhcnQgb2YgdGVzdAo+ID4gcnVuOgo+ID4gCj4gPiBTRUNUSU9OICAg
ICAgIC0tIHhmc19kYXhfbm9yZWZsaW5rCj4gPiBGU1RZUCAgICAgICAgIC0tIHhmcyAoZGVidWcp
Cj4gPiBQTEFURk9STSAgICAgIC0tIExpbnV4L3g4Nl82NCB0ZXN0MyA2LjEuMC1yYzEtZGdjKyAj
MTYxNSBTTVAgUFJFRU1QVF9EWU5BTUlDIFdlZCBPY3QgMTkgMTI6MjQ6MTYgQUVEVCAyMDIyCj4g
PiBNS0ZTX09QVElPTlMgIC0tIC1mIC1tIHJlZmxpbms9MCxybWFwYnQ9MSAvZGV2L3BtZW0xCj4g
PiBNT1VOVF9PUFRJT05TIC0tIC1vIGRheD1hbHdheXMgLW8gY29udGV4dD1zeXN0ZW1fdTpvYmpl
Y3Rfcjpyb290X3Q6czAgL2Rldi9wbWVtMSAvbW50L3NjcmF0Y2gKPiA+IAo+ID4gcG1lbSBkZXZp
Y2VzIGFyZSBhIHBhaXIgb2YgZmFrZSA4R0IgcG1lbSByZWdpb25zIHNldCB1cCBieSBrZXJuZWwK
PiA+IENMSSB2aWEgIm1lbW1hcD04RyExNUcsOEchMjRHIi4gSSBkb24ndCBoYXZlIGFueXRoaW5n
IHNwZWNpYWwgc2V0IHVwCj4gPiAtIHRoZSBrZXJuZWwgY29uZmlnIGlzIGtlcHQgbWluaW1hbCBm
b3IgdGhlc2UgVk1zIC0gYW5kIHRoZSBvbmx5Cj4gPiBrZXJuZWwgZGVidWcgb3B0aW9uIEkgaGF2
ZSB0dXJuZWQgb24gZm9yIHRoZXNlIHNwZWNpZmljIHRlc3QgcnVucyBpcwo+ID4gQ09ORklHX1hG
U19ERUJVRz15Lgo+IAo+IFRoYW5rcyBmb3IgdGhlIGRldGFpbGVkIGluZm8uICBCdXQsIGluIG15
IGVudmlyb25tZW50IChhbmQgbXkgCj4gY29sbGVhZ3VlcycsIGFuZCBvdXIgcmVhbCBzZXJ2ZXIg
d2l0aCBEQ1BNTSkgdGhlc2UgZmFpbHVyZSBjYXNlcyAoeW91IAo+IG1lbnRpb25lZCBhYm92ZSwg
aW4gZGF4K25vbl9yZWZsaW5rIG1vZGUsIHdpdGggc2FtZSB0ZXN0IG9wdGlvbnMpIGNhbm5vdCAK
PiByZXByb2R1Y2UuCj4gCj4gSGVyZSdzIG91ciB0ZXN0IGVudmlyb25tZW50IGluZm86Cj4gICAt
IFJ1YW4ncyBlbnY6IGZlZG9yYSAzNih2Ni4wLXJjMSkgb24ga3ZtLHBtZW0gMng0RzpmaWxlIGJh
Y2tlbmRlZAo+ICAgLSBZYW5nJ3MgZW52OiBmZWRvcmEgMzUodjYuMS1yYzEpIG9uIGt2bSxwbWVt
IDJ4MUc6bWVtbWFwPTFHITFHLDFHITJHCj4gICAtIFNlcnZlcidzICA6IFVidW50dSAyMC4wNCh2
Ni4wLXJjMSkgcmVhbCBtYWNoaW5lLHBtZW0gMng0RzpyZWFsIERDUE1NCj4gCj4gKFRvIHF1aWNr
bHkgY29uZmlybSB0aGUgZGlmZmVyZW5jZSwgSSBqdXN0IHJhbiB0aGUgZmFpbGVkIDI2IGNhc2Vz
IHlvdSAKPiBtZW50aW9uZWQgYWJvdmUuKSAgRXhjZXB0IGZvciBnZW5lcmljLzQ3MSBhbmQgZ2Vu
ZXJpYy81MTksIHdoaWNoIGZhaWxlZCAKPiBldmVuIHdoZW4gZGF4IGlzIG9mZiwgdGhlIHJlc3Qg
cGFzc2VkLgo+IAo+IAo+IFdlIGRvbid0IHdhbnQgZnNkYXggdG8gYmUgdHJ1bmVkIG9mZi4gIFJp
Z2h0IG5vdywgSSB0aGluayB0aGUgbW9zdCAKPiBpbXBvcnRhbnQgdGhpbmcgaXMgc29sdmluZyB0
aGUgZmFpbGVkIGNhc2VzIGluIGRheCtub25fcmVmbGluayBtb2RlLiAKPiBTbywgZmlyc3RseSwg
SSBoYXZlIHRvIHJlcHJvZHVjZSB0aG9zZSBmYWlsdXJlcy4gIElzIHRoZXJlIGFueSB0aGluZyAK
PiB3cm9uZyB3aXRoIG15IHRlc3QgZW52aXJvbm1lbnRzPyAgSSBrb253IHlvdSBhcmUgdXNpbmcg
J21lbW1hcD1YWEchWVlHJyB0byAKPiBzaW11bGF0ZSBwbWVtLiAgU28sICh0byBEYXJyaWNrKSBj
b3VsZCB5b3Ugc2hvdyBtZSB5b3VyIGNvbmZpZyBvZiBkZXYgCj4gZW52aXJvbm1lbnQgYW5kIHRo
ZSAndGVzdGNsb3VkJyhJIGFtIGd1ZXNzaW5nIGl0J3MgYSBzZXJ2ZXIgd2l0aCByZWFsIAo+IG52
ZGltbSBqdXN0IGxpa2Ugb3Vycyk/CgpOb3BlLiAgU2luY2UgdGhlIGFubm91bmNlbWVudCBvZiBw
bWVtIGFzIGEgcHJvZHVjdCwgSSBoYXZlIGhhZCAxNQptaW51dGVzIG9mIGFjY2VzIHRvIG9uZSBw
cmVwcm9kdWN0aW9uIHByb3RvdHlwZSBzZXJ2ZXIgd2l0aCBhY3R1YWwKb3B0YW5lIERJTU1zIGlu
IHRoZW0uCgpJIGhhdmUgL25ldmVyLyBoYWQgYWNjZXNzIHRvIHJlYWwgaGFyZHdhcmUgdG8gdGVz
dCBhbnkgb2YgdGhpcywgc28gaXQncwphbGwgY29uZmlndXJlZCB2aWEgbGlidmlydCB0byBzaW11
bGF0ZSBwbWVtIGluIHFlbXU6Cmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LXhmcy9Zelhz
YXZPV01TdXdUQkVDQG1hZ25vbGlhLwoKL3J1bi9tdHJkaXNrL1tnaF0ubWVtIGFyZSBib3RoIHJl
Z3VsYXIgZmlsZXMgb24gYSB0bXBmcyBmaWxlc3lzdGVtOgoKJCBncmVwIG10cmRpc2sgL3Byb2Mv
bW91bnRzCm5vbmUgL3J1bi9tdHJkaXNrIHRtcGZzIHJ3LHJlbGF0aW1lLHNpemU9ODI4OTQ4NDhr
LGlub2RlNjQgMCAwCgokIGxzIC1sYSAvcnVuL210cmRpc2svW2doXS5tZW0KLXJ3LXItLXItLSAx
IGxpYnZpcnQtcWVtdSBrdm0gMTA3Mzk1MTUzOTIgT2N0IDI0IDE4OjA5IC9ydW4vbXRyZGlzay9n
Lm1lbQotcnctci0tci0tIDEgbGlidmlydC1xZW11IGt2bSAxMDczOTUxNTM5MiBPY3QgMjQgMTk6
MjggL3J1bi9tdHJkaXNrL2gubWVtCgotLUQKCj4gCj4gCj4gKEkganVzdCBmb3VuZCBJIG9ubHkg
dGVzdGVkIG9uIDRHIGFuZCBzbWFsbGVyIHBtZW0gZGV2aWNlLiAgSSdsbCB0cnkgdGhlIAo+IHRl
c3Qgb24gOEcgcG1lbSkKPiAKPiA+IAo+ID4gVEhlIG9ubHkgZGlmZmVyZW5jZSBiZXR3ZWVuIHRo
ZSBub3JlZmxpbmsgYW5kIHJlZmxpbmsgcnVucyBpcyB0aGF0IEkKPiA+IGRyb3AgdGhlICItbSBy
ZWZsaW5rPTAiIG1rZnMgcGFyYW1ldGVyLiBPdGhlcndpc2UgdGhleSBhcmUgaWRlbnRpY2FsCj4g
PiBhbmQgdGhlIGVycm9ycyBJIHJlcG9ydGVkIGFyZSBmcm9tIGJhY2stdG8tYmFjayBmc3Rlc3Rz
IHJ1bnMgd2l0aG91dAo+ID4gcmVib290aW5nIHRoZSBWTS4uLi4KPiA+IAo+ID4gLURhdmUuCj4g
Cj4gCj4gLS0KPiBUaGFua3MsCj4gUnVhbi4KCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1k
ZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGlu
Zm8vZG0tZGV2ZWwK

