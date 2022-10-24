Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29C81C38A2D
	for <dm-devel@archiver.kernel.org>; Mon, 24 Oct 2022 04:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666584398;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=cRalAXLj+37H7b/4vqNPqrStljgIm7rbdbY/8JhAjyc=;
	b=TrcquDTAa20aAyljFnsx2SF/s2RBbdTk+aqUASc1w1XIG86nMiVdSy1VrIkWp82hZAGLPC
	lM33A+/36MuajiAj0zxectuKo6LZyD0SSElxBewmuoLh2eAnqE+cFFZZxFyv49ymEJz3LH
	KoEUadRoYrrBPWlekI447jMghag3pj8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-190-920l04ZxNoiE_1lIacUSkA-1; Mon, 24 Oct 2022 00:06:35 -0400
X-MC-Unique: 920l04ZxNoiE_1lIacUSkA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CCC7E833B09;
	Mon, 24 Oct 2022 04:06:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B53B1141511E;
	Mon, 24 Oct 2022 04:06:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4B9491946589;
	Mon, 24 Oct 2022 04:06:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C3E1C1946587
 for <dm-devel@listman.corp.redhat.com>; Mon, 24 Oct 2022 04:06:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 903DD40C2143; Mon, 24 Oct 2022 04:06:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8878440C2064
 for <dm-devel@redhat.com>; Mon, 24 Oct 2022 04:06:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2126785A5B6
 for <dm-devel@redhat.com>; Mon, 24 Oct 2022 04:06:17 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-440-ROCvyLbjNf2XGy6vw1-Hfw-1; Mon, 24 Oct 2022 00:05:50 -0400
X-MC-Unique: ROCvyLbjNf2XGy6vw1-Hfw-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 90D1DB80B00;
 Mon, 24 Oct 2022 04:05:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C62EC433D6;
 Mon, 24 Oct 2022 04:05:47 +0000 (UTC)
Date: Sun, 23 Oct 2022 21:05:46 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: "ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>
Message-ID: <Y1YPGm1+bUkr8At/@magnolia>
References: <e3d51a6b-12e9-2a19-1280-5fd9dd64117c@fujitsu.com>
 <deb54a77-90d3-df44-1880-61cce6e3f670@fujitsu.com>
 <1444b9b5-363a-163c-0513-55d1ea951799@fujitsu.com>
 <Yzt6eWLuX/RTjmjj@magnolia>
 <f196bcab-6aa2-6313-8a7c-f8ab409621b7@fujitsu.com>
 <Yzx64zGt2kTiDYaP@magnolia>
 <6a83a56e-addc-f3c4-2357-9589a49bf582@fujitsu.com>
 <Y1NRNtToQTjs0Dbd@magnolia>
 <20221023220018.GX3600936@dread.disaster.area>
 <OSBPR01MB2920CA997DDE891C06776279F42E9@OSBPR01MB2920.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
In-Reply-To: <OSBPR01MB2920CA997DDE891C06776279F42E9@OSBPR01MB2920.jpnprd01.prod.outlook.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gTW9uLCBPY3QgMjQsIDIwMjIgYXQgMDM6MTc6NTJBTSArMDAwMCwgcnVhbnN5LmZuc3RAZnVq
aXRzdS5jb20gd3JvdGU6Cj4g5ZyoIDIwMjIvMTAvMjQgNjowMCwgRGF2ZSBDaGlubmVyIOWGmemB
kzoKPiA+IE9uIEZyaSwgT2N0IDIxLCAyMDIyIGF0IDA3OjExOjAyUE0gLTA3MDAsIERhcnJpY2sg
Si4gV29uZyB3cm90ZToKPiA+PiBPbiBUaHUsIE9jdCAyMCwgMjAyMiBhdCAxMDoxNzo0NVBNICsw
ODAwLCBZYW5nLCBYaWFvL+adqCDmmZMgd3JvdGU6Cj4gPj4+IEluIGFkZGl0aW9uLCBJIGRvbid0
IGxpa2UgeW91ciBpZGVhIGFib3V0IHRoZSB0ZXN0IGNoYW5nZSBiZWNhdXNlIGl0IHdpbGwKPiA+
Pj4gbWFrZSBnZW5lcmljLzQ3MCBiZWNvbWUgdGhlIHNwZWNpYWwgdGVzdCBmb3IgWEZTLiBEbyB5
b3Uga25vdyBpZiB3ZSBjYW4gZml4Cj4gPj4+IHRoZSBpc3N1ZSBieSBjaGFuZ2luZyB0aGUgdGVz
dCBpbiBhbm90aGVyIHdheT8gYmxrZGlzY2FyZCAteiBjYW4gZml4IHRoZQo+ID4+PiBpc3N1ZSBi
ZWNhdXNlIGl0IGRvZXMgemVyby1maWxsIHJhdGhlciB0aGFuIGRpc2NhcmQgb24gdGhlIGJsb2Nr
IGRldmljZS4KPiA+Pj4gSG93ZXZlciwgYmxrZGlzY2FyZCAteiB3aWxsIHRha2UgYSBsb3Qgb2Yg
dGltZSB3aGVuIHRoZSBibG9jayBkZXZpY2UgaXMKPiA+Pj4gbGFyZ2UuCj4gPj4KPiA+PiBXZWxs
IHdlIC9jb3VsZC8ganVzdCBkbyB0aGF0IHRvbywgYnV0IHRoYXQgd2lsbCBzdWNrIGlmIHlvdSBo
YXZlIDJUQiBvZgo+ID4+IHBtZW0uIDspCj4gPj4KPiA+PiBNYXliZSBhcyBhbiBhbHRlcm5hdGl2
ZSBwYXRoIHdlIGNvdWxkIGp1c3QgY3JlYXRlIGEgdmVyeSBzbWFsbAo+ID4+IGZpbGVzeXN0ZW0g
b24gdGhlIHBtZW0gYW5kIHRoZW4gYmxrZGlzY2FyZCAteiBpdD8KPiA+Pgo+ID4+IFRoYXQgc2Fp
ZCAtLSBkb2VzIHBlcnNpc3RlbnQgbWVtb3J5IGFjdHVhbGx5IGhhdmUgYSBmdXR1cmU/ICBJbnRl
bAo+ID4+IHNjdXR0bGVkIHRoZSBlbnRpcmUgT3B0YW5lIHByb2R1Y3QsIGN4bC5tZW0gc291bmRz
IGxpa2UgZXhwYW5zaW9uCj4gPj4gY2hhc3NpcyBmdWxsIG9mIERSQU0sIGFuZCBmc2RheCBpcyBo
b3JyaWJseSBicm9rZW4gaW4gNi4wICh3ZWlyZCBrZXJuZWwKPiA+PiBhc3NlcnRzIGV2ZXJ5d2hl
cmUpIGFuZCA2LjEgKGV2ZXJ5IHRpbWUgSSBydW4gZnN0ZXN0cyBub3cgSSBzZWUgbWFzc2l2ZQo+
ID4+IGRhdGEgY29ycnVwdGlvbikuCj4gPgo+ID4gWXVwLCBJIHNlZSB0aGUgc2FtZSB0aGluZy4g
ZnNkYXggd2FzIGEgdHJhaW4gd3JlY2sgaW4gNi4wIC0gYnJva2VuCj4gPiBvbiBib3RoIGV4dDQg
YW5kIFhGUy4gTm93IHRoYXQgSSBydW4gYSBxdWljayBjaGVjayBvbiA2LjEtcmMxLCBJCj4gPiBk
b24ndCB0aGluayB0aGF0IGhhcyBjaGFuZ2VkIGF0IGFsbCAtIEkgc3RpbGwgc2VlIGxvdHMgb2Yg
a2VybmVsCj4gPiB3YXJuaW5ncywgZGF0YSBjb3JydXB0aW9uIGFuZCAiWEZTX0lPQ19DTE9ORV9S
QU5HRTogSW52YWxpZAo+ID4gYXJndW1lbnQiIGVycm9ycy4KPiAKPiBGaXJzdGx5LCBJIHRoaW5r
IHRoZSAiWEZTX0lPQ19DTE9ORV9SQU5HRTogSW52YWxpZCBhcmd1bWVudCIgZXJyb3IgaXMKPiBj
YXVzZWQgYnkgdGhlIHJlc3RyaWN0aW9ucyB3aGljaCBwcmV2ZW50IHJlZmxpbmsgd29yayB0b2dl
dGhlciB3aXRoIERBWDoKPiAKPiBhLiBmcy94ZnMveGZzX2lvY3RsLmM6MTE0MQo+IC8qIERvbid0
IGFsbG93IHVzIHRvIHNldCBEQVggbW9kZSBmb3IgYSByZWZsaW5rZWQgZmlsZSBmb3Igbm93LiAq
Lwo+IGlmICgoZmEtPmZzeF94ZmxhZ3MgJiBGU19YRkxBR19EQVgpICYmIHhmc19pc19yZWZsaW5r
X2lub2RlKGlwKSkKPiAgICAgICAgIHJldHVybiAtRUlOVkFMOwo+IAo+IGIuIGZzL3hmcy94ZnNf
aW9wcy5jOjExNzQKPiAvKiBPbmx5IHN1cHBvcnRlZCBvbiBub24tcmVmbGlua2VkIGZpbGVzLiAq
Lwo+IGlmICh4ZnNfaXNfcmVmbGlua19pbm9kZShpcCkpCj4gICAgICAgICByZXR1cm4gZmFsc2U7
CgpZZXMuLi4KCj4gVGhlc2UgcmVzdHJpY3Rpb25zIHdlcmUgcmVtb3ZlZCBpbiAiZHJvcCBleHBl
cmltZW50YWwgd2FybmluZyIgcGF0Y2hbMV0uCj4gICBJIHRoaW5rIHRoZXkgc2hvdWxkIGJlIHNl
cGFyYXRlZCBmcm9tIHRoYXQgcGF0Y2guCgouLi5hbmQgeWVzLgoKPiAKPiBbMV0KPiBodHRwczov
L2xvcmUua2VybmVsLm9yZy9saW51eC14ZnMvMTY2MzIzNDAwMi0xNy0xLWdpdC1zZW5kLWVtYWls
LXJ1YW5zeS5mbnN0QGZ1aml0c3UuY29tLwo+IAo+IAo+IFNlY29uZGx5LCBob3cgdGhlIGRhdGEg
Y29ycnVwdGlvbiBoYXBwZW5lZD8gT3Igd2hpY2ggY2FzZSBmYWlsZWQ/ICBDb3VsZAo+IHlvdSBn
aXZlIG1lIG1vcmUgaW5mbyAoc3VjaCBhcyBta2ZzIG9wdGlvbnMsIHhmc3Rlc3RzIGNvbmZpZ3Mp
Pwo+IAo+ID4KPiA+IElmIEkgdHVybiBvZmYgcmVmbGluaywgdGhlbiBpbnN0ZWFkIG9mIGRhdGEg
Y29ycnVwdGlvbiBJIGdldCBrZXJuZWwKPiA+IHdhcm5pbmdzIGxpa2UgdGhpcyBmcm9tIGZzeCBh
bmQgZnNzdHJlc3Mgd29ya2xvYWRzOgo+ID4KPiA+IFs0MTU0NzguNTU4NDI2XSAtLS0tLS0tLS0t
LS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KPiA+IFs0MTU0NzguNTYwNTQ4XSBXQVJOSU5HOiBD
UFU6IDEyIFBJRDogMTUxNTI2MCBhdCBmcy9kYXguYzozODAgZGF4X2luc2VydF9lbnRyeSsweDJh
NS8weDMyMAo+ID4gWzQxNTQ3OC41NjQwMjhdIE1vZHVsZXMgbGlua2VkIGluOgo+ID4gWzQxNTQ3
OC41NjU0ODhdIENQVTogMTIgUElEOiAxNTE1MjYwIENvbW06IGZzeCBUYWludGVkOiBHICAgICAg
ICBXIDYuMS4wLXJjMS1kZ2MrICMxNjE1Cj4gPiBbNDE1NDc4LjU2OTIyMV0gSGFyZHdhcmUgbmFt
ZTogUUVNVSBTdGFuZGFyZCBQQyAoaTQ0MEZYICsgUElJWCwgMTk5NiksIEJJT1MgMS4xNS4wLTEg
MDQvMDEvMjAxNAo+ID4gWzQxNTQ3OC41NzI4NzZdIFJJUDogMDAxMDpkYXhfaW5zZXJ0X2VudHJ5
KzB4MmE1LzB4MzIwCj4gPiBbNDE1NDc4LjU3NDk4MF0gQ29kZTogMDggNDggODMgYzQgMzAgNWIg
NWQgNDEgNWMgNDEgNWQgNDEgNWUgNDEgNWYgYzMgNDggOGIgNTggMjAgNDggOGQgNTMgMDEgZTkg
NjUgZmYgZmYgZmYgNDggOGIgNTggMjAgNDggOGQgNTMgMDEgZTkgNTAgZmYgZmYgZmYgPDBmPiAw
YiBlOSA3MCBmZiBmZiBmZiAzMSBmNiA0YyA4OSBlNyBlOCBkYSBlZSBhNyAwMCBlYiBhNCA0OCA4
MSBlNgo+ID4gWzQxNTQ3OC41ODI3NDBdIFJTUDogMDAwMDpmZmZmYzkwMDAyODY3YjcwIEVGTEFH
UzogMDAwMTAwMDIKPiA+IFs0MTU0NzguNTg0NzMwXSBSQVg6IGZmZmZlYTAwMGYwZDA4MDAgUkJY
OiAwMDAwMDAwMDAwMDAwMDAxIFJDWDogMDAwMDAwMDAwMDAwMDAwMQo+ID4gWzQxNTQ3OC41ODc0
ODddIFJEWDogZmZmZmVhMDAwMDAwMDAwMCBSU0k6IDAwMDAwMDAwMDAwMDAwM2EgUkRJOiBmZmZm
ZWEwMDBmMGQwODQwCj4gPiBbNDE1NDc4LjU5MDEyMl0gUkJQOiAwMDAwMDAwMDAwMDAwMDExIFIw
ODogMDAwMDAwMDAwMDAwMDAwMCBSMDk6IDAwMDAwMDAwMDAwMDAwMDAKPiA+IFs0MTU0NzguNTky
MzgwXSBSMTA6IGZmZmY4ODg4MDBkYzljMTggUjExOiAwMDAwMDAwMDAwMDAwMDAxIFIxMjogZmZm
ZmM5MDAwMjg2N2M1OAo+ID4gWzQxNTQ3OC41OTQ4NjVdIFIxMzogZmZmZjg4ODgwMGRjOWMxOCBS
MTQ6IGZmZmZjOTAwMDI4NjdlMTggUjE1OiAwMDAwMDAwMDAwMDAwMDAwCj4gPiBbNDE1NDc4LjU5
Njk4M10gRlM6ICAwMDAwN2ZkNzE5ZmEyYjgwKDAwMDApIEdTOmZmZmY4ODg4M2VjMDAwMDAoMDAw
MCkga25sR1M6MDAwMDAwMDAwMDAwMDAwMAo+ID4gWzQxNTQ3OC41OTkzNjRdIENTOiAgMDAxMCBE
UzogMDAwMCBFUzogMDAwMCBDUjA6IDAwMDAwMDAwODAwNTAwMzMKPiA+IFs0MTU0NzguNjAwOTA1
XSBDUjI6IDAwMDA3ZmQ3MWExYWQ2NDAgQ1IzOiAwMDAwMDAwNWNmMjQxMDA2IENSNDogMDAwMDAw
MDAwMDA2MGVlMAo+ID4gWzQxNTQ3OC42MDI4ODNdIENhbGwgVHJhY2U6Cj4gPiBbNDE1NDc4LjYw
MzU5OF0gIDxUQVNLPgo+ID4gWzQxNTQ3OC42MDQyMjldICBkYXhfZmF1bHRfaXRlcisweDI0MC8w
eDYwMAo+ID4gWzQxNTQ3OC42MDU0MTBdICBkYXhfaW9tYXBfcHRlX2ZhdWx0KzB4MTljLzB4M2Qw
Cj4gPiBbNDE1NDc4LjYwNjcwNl0gIF9feGZzX2ZpbGVtYXBfZmF1bHQrMHgxZGQvMHgyYjAKPiA+
IFs0MTU0NzguNjA3NzQ0XSAgX19kb19mYXVsdCsweDJlLzB4MWQwCj4gPiBbNDE1NDc4LjYwODU4
N10gIF9faGFuZGxlX21tX2ZhdWx0KzB4Y2VjLzB4MTdiMAo+ID4gWzQxNTQ3OC42MDk1OTNdICBo
YW5kbGVfbW1fZmF1bHQrMHhkMC8weDJhMAo+ID4gWzQxNTQ3OC42MTA1MTddICBleGNfcGFnZV9m
YXVsdCsweDFkOS8weDgxMAo+ID4gWzQxNTQ3OC42MTEzOThdICBhc21fZXhjX3BhZ2VfZmF1bHQr
MHgyMi8weDMwCj4gPiBbNDE1NDc4LjYxMjMxMV0gUklQOiAwMDMzOjB4N2ZkNzFhMDRiOWJhCj4g
PiBbNDE1NDc4LjYxMzE2OF0gQ29kZTogNGQgMjkgYzEgNGMgMjkgYzIgNDggM2IgMTUgZGIgOTUg
MTEgMDAgMGYgODcgYWYgMDAgMDAgMDAgMGYgMTAgMDEgMGYgMTAgNDkgZjAgMGYgMTAgNTEgZTAg
MGYgMTAgNTkgZDAgNDggODMgZTkgNDAgNDggODMgZWEgNDAgPDQxPiAwZiAyOSAwMSA0MSAwZiAy
OSA0OSBmMCA0MSAwZiAyOSA1MSBlMCA0MSAwZiAyOSA1OSBkMCA0OSA4MyBlOQo+ID4gWzQxNTQ3
OC42MTcwODNdIFJTUDogMDAyYjowMDAwN2ZmY2YyNzdiZTE4IEVGTEFHUzogMDAwMTAyMDYKPiA+
IFs0MTU0NzguNjE4MjEzXSBSQVg6IDAwMDA3ZmQ3MWExYTNmYzUgUkJYOiAwMDAwMDAwMDAwMDAw
ZmM1IFJDWDogMDAwMDdmZDcxOWY1YTYxMAo+ID4gWzQxNTQ3OC42MTk4NTRdIFJEWDogMDAwMDAw
MDAwMDAwOTY0YiBSU0k6IDAwMDA3ZmQ3MTlmNTBmZDUgUkRJOiAwMDAwN2ZkNzFhMWEzZmM1Cj4g
PiBbNDE1NDc4LjYyMTI4Nl0gUkJQOiAwMDAwMDAwMDAwMDMwZmM1IFIwODogMDAwMDAwMDAwMDAw
MDAwZSBSMDk6IDAwMDA3ZmQ3MWExYWQ2NDAKPiA+IFs0MTU0NzguNjIyNzMwXSBSMTA6IDAwMDAw
MDAwMDAwMDAwMDEgUjExOiAwMDAwN2ZkNzFhMWFkNjRlIFIxMjogMDAwMDAwMDAwMDAwOTY5OQo+
ID4gWzQxNTQ3OC42MjQxNjRdIFIxMzogMDAwMDAwMDAwMDAwYTY1ZSBSMTQ6IDAwMDA3ZmQ3MWEx
YTMwMDAgUjE1OiAwMDAwMDAwMDAwMDAwMDAxCj4gPiBbNDE1NDc4LjYyNTYwMF0gIDwvVEFTSz4K
PiA+IFs0MTU0NzguNjI2MDg3XSAtLS1bIGVuZCB0cmFjZSAwMDAwMDAwMDAwMDAwMDAwIF0tLS0K
PiA+Cj4gPiBFdmVuIGdlbmVyaWMvMjQ3IGlzIGdlbmVyYXRpbmcgYSB3YXJuaW5nIGxpa2UgdGhp
cyBmcm9tIHhmc19pbywKPiA+IHdoaWNoIGlzIGEgbW1hcCB2cyBESU8gcmFjZXIuIEdpdmVuIHRo
YXQgRElPIGRvZXNuJ3QgZXhpc3QgZm9yCj4gPiBmc2RheCwgdGhpcyB0ZXN0IHR1cm5zIGludG8g
anVzdCBhIG5vcm1hbCB3cml0ZSgpIHZzIG1tYXAoKSByYWNlci4KPiA+Cj4gPiBHaXZlbiB0aGVz
ZSBhcmUgdGhlIHNhbWUgZnNkYXggaW5mcmFzdHJ1Y3R1cmUgZmFpbHVyZXMgdGhhdCBJCj4gPiBy
ZXBvcnRlZCBmb3IgNi4wLCBpdCBpcyBhbHNvIGxpa2VseSB0aGF0IGV4dDQgaXMgc3RpbGwgdGhy
b3dpbmcKPiA+IHRoZW0uIElPV3MsIHdoYXRldmVyIGdvdCBicm9rZSBpbiB0aGUgNi4wIGN5Y2xl
IHdhc24ndCBmaXhlZCBpbiB0aGUKPiA+IDYuMSBjeWNsZS4KPiAKPiBTdGlsbCB3b3JraW5nIG9u
IGl0Li4uCgpZb3UnbGwgaGF2ZSB0byBwb3J0IHRoZSBlbnRpcmUgRkFMTE9DX0ZMX0ZVTlNIQVJF
IGNvZGUgcGF0aCB0byBmc2RheCB0b28KLS0gaXQgdXNlcyB0aGUgcGFnZSBjYWNoZSB0byBzdGFn
ZSB0aGUgQ09XLCB3aGljaCB0aGVuIGNvbmZ1c2VzIGZzZGF4CndoZW4gaXQgZmluZHMgYW5kIHRy
aXBzIG92ZXIgRFJBTSBwYWdlcyBpbiB0aGUgbWFwcGluZy4gIFRoYXQgZWxpbWluYXRlcwpvbmUg
b2YgdGhlIHdhcm5pbmdzICh0byBiZSBmYWlyIEkganVzdCBFT05PVFNVUFAnZCBGVU5TSEFSRSB0
byBtYWtlIHRoYXQKcGF0aCBnbyBhd2F5KSBidXQgaXQgc3RpbGwgcHJvZHVjZWQgbWFzc2l2ZSBk
YXRhIGNvcnJ1cHRpb24uCgo+ID4KPiA+PiBGcmFua2x5IGF0IHRoaXMgcG9pbnQgSSdtIHRlbXB0
ZWQganVzdCB0byB0dXJuIG9mIGZzZGF4IHN1cHBvcnQgZm9yIFhGUwo+ID4+IGZvciB0aGUgNi4x
IExUUyBiZWNhdXNlIEkgZG9uJ3QgaGF2ZSB0aW1lIHRvIGZpeCBpdC4KPiA+Cj4gPiAvbWUgc2hy
dWdzCj4gPgo+ID4gQmFja3BvcnRpbmcgZml4ZXMgKHdoZW5ldmVyIHRoZXkgY29tZSBhbG9uZykg
aXMgYSBwcm9ibGVtIGZvciB0aGUKPiA+IExUUyBrZXJuZWwgbWFpbnRhaW5lciB0byBkZWFsIHdp
dGgsIG5vdCB0aGUgdXBzdHJlYW0gbWFpbnRhaW5lci4KPiA+Cj4gPiBJTU8sIHRoZSBpc3N1ZSBy
aWdodCBub3cgaXMgdGhhdCB0aGUgREFYIG1haW50YWluZXJzIHNlZW0gdG8gaGF2ZQo+ID4gbGl0
dGxlIGludGVyZXN0IGluIGVuc3VyaW5nIHRoYXQgdGhlIEZTREFYIGluZnJhc3RydWN0dXJlIGFj
dHVhbGx5Cj4gPiB3b3JrcyBjb3JyZWN0bHkuIElmIGFueXRoaW5nLCB0aGV5IHNlZW0gdG8gd2Fu
dCB0byBtYWtlIHRoaW5ncwo+ID4gaGFyZGVyIGZvciBibG9jayBiYXNlZCBmaWxlc3lzdGVtcyB0
byB1c2UgcG1lbSBkZXZpY2VzIGFuZCBoZW5jZQo+ID4gRlNEQVguIGUuZy4gdGhlIGRpcmVjdGlv
biBvZiB0aGUgREFYIGNvcmUgYXdheSBmcm9tIGJsb2NrIGludGVyZmFjZXMKPiA+IHRoYXQgZmls
ZXN5c3RlbXMgbmVlZCBmb3IgdGhlaXIgdXNlcnNwYWNlIHRvb2xzIHRvIG1hbmFnZSB0aGUKPiA+
IHN0b3JhZ2UuCj4gPgo+ID4gQXQgd2hhdCBwb2ludCBkbyB3ZSBzaW1wbHkgc2F5ICJ0aGUgZXhw
ZXJpbWVudCBmYWlsZWQsIEZTREFYIGlzCj4gPiBkZWFkIiBhbmQgcmVtb3ZlIGl0IGZyb20gWEZT
IGFsdG9nZXRoZXI/CgpXZSBubyBsb25nZXIgaGF2ZSBhbnkgcG1lbSBwcm9kdWN0cyBpbiBvdXIg
cGlwZWxpbmUsIHNvIEkgd2lsbCBqdXN0IHNheQp0aGF0IGlmIHRoZSBjb3JydXB0aW9uIHByb2Js
ZW1zIGFyZW4ndCByZXNvbHZlZCBieSB0aGUgZW5kIG9mIDYuMS1yY1gKSSdtIGhpZGluZyBmc2Rh
eCBzdXBwb3J0IGJlaGluZCBDT05GSUdfWEZTX0RFQlVHIG9yIGp1c3QgdHVybmluZyBpdCBvZmYK
ZW50aXJlbHkuICBJIGRvbid0IHdhbnQgdG8gYnVyZGVuIHdob2V2ZXIgYmVjb21lcyB0aGUgNi4x
IFhGUyBMVFMKbWFpbnRhaW5lciB3aXRoIGEgc2xldyBvZiBmc2RheCBkYXRhIGNvcnJ1cHRpb24g
ZXJyb3JzLgoKPiBJJ2xsIGh1cnJ5IHVwIGFuZCB0cnkgbXkgYmVzdCB0byBzb2x2ZSB0aGVzZSBw
cm9ibGVtcy4KCk9rLCB0aGFuayB5b3UuIDopCgotLUQKCj4gCj4gCj4gLS0KPiBUaGFua3MsCj4g
UnVhbi4KPiAKPiA+Cj4gPiBDaGVlcnMsCj4gPgo+ID4gRGF2ZS4KCi0tCmRtLWRldmVsIG1haWxp
bmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21h
aWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

