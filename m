Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26974C433FE
	for <dm-devel@archiver.kernel.org>; Tue,  4 Oct 2022 00:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1664842855;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ODc3pjvoTp8E6c9PWy7ONZ8BBEaA3Ip4l9rw01cDAwo=;
	b=Kj9dNw2hwyHZ+KeiXel70QK+QUdTvMum30zrUorZDD0tX8Tm92npxoiBNZ3l9V6vUmlm5e
	XlZN0ENjtQEDGM9pJwopyPZ+nrOnV6FNGtcZLCUN93ywBQn6YF0tyHVHXI6SLBEhtfOIra
	Pjmp1pbEsdPgP3hYPooLUoDO8AFnhIM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-414-iog75tJlNPeqRGbP7FQqVg-1; Mon, 03 Oct 2022 20:20:52 -0400
X-MC-Unique: iog75tJlNPeqRGbP7FQqVg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 52C2D101A528;
	Tue,  4 Oct 2022 00:20:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E1546492CA2;
	Tue,  4 Oct 2022 00:20:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A5D4C19465A2;
	Tue,  4 Oct 2022 00:20:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6BA641946588
 for <dm-devel@listman.corp.redhat.com>; Tue,  4 Oct 2022 00:20:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 59E39492CA4; Tue,  4 Oct 2022 00:20:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 52B29492CA2
 for <dm-devel@redhat.com>; Tue,  4 Oct 2022 00:20:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2EE841C0519A
 for <dm-devel@redhat.com>; Tue,  4 Oct 2022 00:20:46 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-177-2RMLWb0wMV2lSMt5hUyV7A-1; Mon, 03 Oct 2022 20:20:44 -0400
X-MC-Unique: 2RMLWb0wMV2lSMt5hUyV7A-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id C844EB80DE3;
 Tue,  4 Oct 2022 00:12:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ECDFC433C1;
 Tue,  4 Oct 2022 00:12:42 +0000 (UTC)
Date: Mon, 3 Oct 2022 17:12:41 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: =?utf-8?B?R290b3UsIFlhc3Vub3JpL+S6lOWztiDlurfmloc=?= <y-goto@fujitsu.com>
Message-ID: <Yzt6eWLuX/RTjmjj@magnolia>
References: <dd363bd8-2dbd-5d9c-0406-380b60c5f510@fujitsu.com>
 <Yxs5Jb7Yt2c6R6eW@bfoster>
 <7fdc9e88-f255-6edb-7964-a5a82e9b1292@fujitsu.com>
 <76ea04b4-bad7-8cb3-d2c6-4ad49def4e05@fujitsu.com>
 <YyHKUhOgHdTKPQXL@bfoster> <YyIBMJzmbZsUBHpy@magnolia>
 <a6e7f4eb-0664-bbe8-98d2-f8386b226113@fujitsu.com>
 <e3d51a6b-12e9-2a19-1280-5fd9dd64117c@fujitsu.com>
 <deb54a77-90d3-df44-1880-61cce6e3f670@fujitsu.com>
 <1444b9b5-363a-163c-0513-55d1ea951799@fujitsu.com>
MIME-Version: 1.0
In-Reply-To: <1444b9b5-363a-163c-0513-55d1ea951799@fujitsu.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, toshi.kani@hpe.com,
 dm-devel@redhat.com, "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 Brian Foster <bfoster@redhat.com>,
 =?utf-8?B?WWFuZywgWGlhby/mnagg5pmT?= <yangx.jy@fujitsu.com>,
 "david@fromorbit.com" <david@fromorbit.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 =?utf-8?B?UnVhbiwgU2hpeWFuZy/pmK4g5LiW6Ziz?= <ruansy.fnst@fujitsu.com>,
 "hch@infradead.org" <hch@infradead.org>, Jeff Moyer <jmoyer@redhat.com>,
 zwisler@kernel.org,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gRnJpLCBTZXAgMzAsIDIwMjIgYXQgMDk6NTY6NDFBTSArMDkwMCwgR290b3UsIFlhc3Vub3Jp
L+S6lOWztiDlurfmlocgd3JvdGU6Cj4gSGVsbG8gZXZlcnlvbmUsCj4gCj4gT24gMjAyMi8wOS8y
MCAxMTozOCwgWWFuZywgWGlhby/mnagg5pmTIHdyb3RlOgo+ID4gSGkgRGFycmljaywgQnJpYW4g
YW5kIENocmlzdG9waAo+ID4gCj4gPiBQaW5nLiBJIGhvcGUgdG8gZ2V0IHlvdXIgZmVlZGJhY2su
Cj4gPiAKPiA+IDEpIEkgaGF2ZSBjb25maXJtZWQgdGhhdCB0aGUgZm9sbG93aW5nIHBhdGNoIHNl
dCBkaWQgbm90IGNoYW5nZSB0aGUgdGVzdAo+ID4gcmVzdWx0IG9mIGdlbmVyaWMvNDcwIHdpdGgg
dGhpbi12b2x1bWUuIEJlc2lkZXMsIEkgZGlkbid0IHNlZSBhbnkKPiA+IGZhaWx1cmUgd2hlbiBy
dW5uaW5nIGdlbmVyaWMvNDcwIGJhc2VkIG9uIG5vcm1hbCBQTUVNIGRldmljZSBpbnN0YWVkIG9m
Cj4gPiB0aGluLXZvbHVtZS4KPiA+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LXhmcy8y
MDIxMTEyOTEwMjIwMy4yMjQzNTA5LTEtaGNoQGxzdC5kZS8KPiA+IAo+ID4gMikgSSBjYW4gcmVw
cm9kdWNlIHRoZSBmYWlsdXJlIG9mIGdlbmVyaWMvNDgyIHdpdGhvdXQgdGhpbi12b2x1bWUuCj4g
PiAKPiA+IDMpIElzIGl0IG5lY2Vzc2FyeSB0byBtYWtlIHRoaW4tdm9sdW1lIHN1cHBvcnQgREFY
LiBJcyB0aGVyZSBhbnkgdXNlCj4gPiBjYXNlIGZvciB0aGUgcmVxdWlyZW1lbnQ/Cj4gCj4gCj4g
VGhvdWdoIEkgYXNrZWQgb3RoZXIgcGxhY2UoKiksIEkgcmVhbGx5IHdhbnQgdG8ga25vdyB0aGUg
dXNlY2FzZSBvZgo+IGRtLXRoaW4tdm9sdW1lIHdpdGggREFYIGFuZCByZWZsaW5rLgo+IAo+IAo+
IEluIG15IHVuZGVyc3RhbmRpbmcsIGRtLXRoaW4tdm9sdW1lIHNlZW1zIHRvIHByb3ZpZGUgc2lt
aWxhciBmZWF0dXJlIGxpa2UKPiByZWZsaW5rIG9mIHhmcy4gQm90aCBmZWF0dXJlIHByb3ZpZGUg
Q09XIHVwZGF0ZSB0byByZWR1Y2UgdXNhZ2Ugb2YKPiBpdHMgcmVnaW9uLCBhbmQgc25hcHNob3Qg
ZmVhdHVyZSwgcmlnaHQ/Cj4gCj4gSSBmb3VuZCB0aGF0IGRvY2tlciBzZWVtcyB0byBzZWxlY3Qg
b25lIG9mIHRoZW0gKG9yIG90aGVyIGZlYXR1cmUgd2hpY2gKPiBzdXBwb3J0cyBDT1cpLiBUaGVu
IHVzZXIgZG9uJ3QgbmVlZCB0byB1c2UgdGhpbi12b2x1bWUgYW5kIHJlZmxpbmsgYXQgc2FtZQo+
IHRpbWUuCj4gCj4gRGF0YWJhc2Ugd2hpY2ggdXNlcyBGUy1EQVggbWF5IHdhbnQgdG8gdXNlIHNu
YXBzaG90IGZvciBpdHMgZGF0YSBvZiBGUy1EQVgsCj4gaXRzIHVzZXIgc2VlbXMgdG8gYmUgc2F0
aXNmaWVkIHdpdGggcmVmbGluayBvciB0aGluLXZvbHVtZS4KPiAKPiBTbyBJIGNvdWxkIG5vdCBm
aW5kIG9uIHdoYXQgdXNlLWNhc2UgdXNlciB3b3VsZCBsaWtlIHRvIHVzZSBkbS10aGluLXZvbHVt
ZQo+IGFuZCByZWZsaW5rIGF0IHNhbWUgdGltZS4KPiAKPiBUaGUgb25seSBwb3NzaWJpbGl0eSBp
cyB0aGF0IHRoZSB1c2VyIGhhcyBtaXN0YWtlbmx5IGNvbmZpZ3VyZWQgZG0tdGhpbnBvb2wKPiBh
bmQgcmVmbGluayB0byBiZSB1c2VkIGF0IHRoZSBzYW1lIHRpbWUsIGJ1dCBpZiB0aGF0IGlzIHRo
ZSBjYXNlLCBpdCBzZWVtcwo+IHRvIGJlIGJldHRlciBmb3IgdGhlIHVzZXIgdG8gZGlzYWJsZSBv
bmUgb3IgdGhlIG90aGVyLgo+IAo+IEkgcmVhbGx5IHdhbmRlciB3aHkgZG0tdGhpbi12b2x1bWUg
bXVzdCBiZSB1c2VkIHdpdGggcmVmbGlrIGFuZCBGUy1EQVguCgpUaGVyZSBpc24ndCBhIGhhcmQg
cmVxdWlyZW1lbnQgYmV0d2VlbiBmc2RheCBhbmQgZG0tdGhpbnAuICBUaGUgL3Rlc3QvCm5lZWRz
IGRtLWxvZ3dyaXRlcyB0byBjaGVjayB0aGF0IHdyaXRlIHBhZ2UgZmF1bHRzIG9uIGEgTUFQX1NZ
TkMKbW1hcHBpbmcgYXJlIHBlcnNpc3RlZCBkaXJlY3RseSB0byBkaXNrLiAgZG0tbG9nd3JpdGVz
IHJlcXVpcmVzIGEgZmFzdAp3YXkgdG8gemVybyBhbiBlbnRpcmUgZGV2aWNlIGZvciBjb3JyZWN0
IG9wZXJhdGlvbiBvZiB0aGUgcmVwbGF5IHN0ZXAsCmFuZCB0aGlucCBpcyB0aGUgb25seSB3YXkg
dG8gZ3VhcmFudGVlIHRoYXQuCgotLUQKCj4gSWYgbXkgdW5kZXJzdGFuZGluZyBpcyBzb21ldGhp
bmcgd3JvbmcsIHBsZWFzZSBjb3JyZWN0IG1lLgo+IAo+ICgqKWh0dHBzOi8vbG9yZS5rZXJuZWwu
b3JnL2FsbC9UWVdQUjAxTUIxMDA4MjU4RjQ3NENBMjI5NUI0Q0QzRDlCOTA1NDlAVFlXUFIwMU1C
MTAwODIuanBucHJkMDEucHJvZC5vdXRsb29rLmNvbS8KPiAKPiBUaGFua3MsCj4gLS0tCj4gWWFz
dW5vcmkgR290bwo+IAo+IAo+ID4gCj4gPiBCZXN0IFJlZ2FyZHMsCj4gPiBYaWFvIFlhbmcKPiA+
IAo+ID4gT24gMjAyMi85LzE2IDEwOjA0LCBZYW5nLCBYaWFvL+adqCDmmZMgd3JvdGU6Cj4gPiA+
IE9uIDIwMjIvOS8xNSAxODoxNCwgWWFuZywgWGlhby/mnagg5pmTIHdyb3RlOgo+ID4gPiA+IE9u
IDIwMjIvOS8xNSAwOjI4LCBEYXJyaWNrIEouIFdvbmcgd3JvdGU6Cj4gPiA+ID4gPiBPbiBXZWQs
IFNlcCAxNCwgMjAyMiBhdCAwODozNDoyNkFNIC0wNDAwLCBCcmlhbiBGb3N0ZXIgd3JvdGU6Cj4g
PiA+ID4gPiA+IE9uIFdlZCwgU2VwIDE0LCAyMDIyIGF0IDA1OjM4OjAyUE0gKzA4MDAsIFlhbmcs
IFhpYW8v5p2oIOaZkyB3cm90ZToKPiA+ID4gPiA+ID4gPiBPbiAyMDIyLzkvMTQgMTQ6NDQsIFlh
bmcsIFhpYW8v5p2oIOaZkyB3cm90ZToKPiA+ID4gPiA+ID4gPiA+IE9uIDIwMjIvOS85IDIxOjAx
LCBCcmlhbiBGb3N0ZXIgd3JvdGU6Cj4gPiA+ID4gPiA+ID4gPiA+IFllcy4uIEkgZG9uJ3QgcmVj
YWxsIGFsbCB0aGUgaW50ZXJuYWxzIG9mCj4gPiA+ID4gPiA+ID4gPiA+IHRoZSB0b29scyBhbmQg
dGVzdCwgYnV0IElJUkMKPiA+ID4gPiA+ID4gPiA+ID4gaXQgcmVsaWVkIG9uIGRpc2NhcmQgdG8g
cGVyZm9ybSB6ZXJvaW5nCj4gPiA+ID4gPiA+ID4gPiA+IGJldHdlZW4gY2hlY2twb2ludHMgb3Ig
c29tZSBzdWNoCj4gPiA+ID4gPiA+ID4gPiA+IGFuZCBhdm9pZCBzcHVyaW91cyBmYWlsdXJlcy4g
VGhlIHB1cnBvc2Ugb2YgcnVubmluZyBvbiBkbS10aGluIHdhcwo+ID4gPiA+ID4gPiA+ID4gPiBt
ZXJlbHkgdG8gcHJvdmlkZSByZWxpYWJsZSBkaXNjYXJkIHplcm9pbmcKPiA+ID4gPiA+ID4gPiA+
ID4gYmVoYXZpb3Igb24gdGhlIHRhcmdldCBkZXZpY2UKPiA+ID4gPiA+ID4gPiA+ID4gYW5kIHRo
dXMgdG8gYWxsb3cgdGhlIHRlc3QgdG8gcnVuIHJlbGlhYmx5Lgo+ID4gPiA+ID4gPiA+ID4gSGkg
QnJpYW4sCj4gPiA+ID4gPiA+ID4gPiAKPiA+ID4gPiA+ID4gPiA+IEFzIGZhciBhcyBJIGtub3cs
IGdlbmVyaWMvNDcwIHdhcyBvcmlnaW5hbCBkZXNpZ25lZCB0byB2ZXJpZnkKPiA+ID4gPiA+ID4g
PiA+IG1tYXAoTUFQX1NZTkMpIG9uIHRoZSBkbS1sb2ctd3JpdGVzIGRldmljZSBlbmFibGluZyBE
QVguIER1ZSB0byB0aGUKPiA+ID4gPiA+ID4gPiA+IHJlYXNvbiwgd2UgbmVlZCB0byBlbnN1cmUg
dGhhdCBhbGwgdW5kZXJseWluZyBkZXZpY2VzIHVuZGVyCj4gPiA+ID4gPiA+ID4gPiBkbS1sb2ct
d3JpdGVzIGRldmljZSBzdXBwb3J0IERBWC4gSG93ZXZlcgo+ID4gPiA+ID4gPiA+ID4gZG0tdGhp
biBkZXZpY2UgbmV2ZXIgc3VwcG9ydHMKPiA+ID4gPiA+ID4gPiA+IERBWCBzbwo+ID4gPiA+ID4g
PiA+ID4gcnVubmluZyBnZW5lcmljLzQ3MCB3aXRoIGRtLXRoaW4gZGV2aWNlIGFsd2F5cyByZXR1
cm5zICJub3QgcnVuIi4KPiA+ID4gPiA+ID4gPiA+IAo+ID4gPiA+ID4gPiA+ID4gUGxlYXNlIHNl
ZSB0aGUgZGlmZmVyZW5jZSBiZXR3ZWVuIG9sZCBhbmQgbmV3IGxvZ2ljOgo+ID4gPiA+ID4gPiA+
ID4gCj4gPiA+ID4gPiA+ID4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIG9sZCBsb2dpY8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIG5ldyBsb2dpYwo+
ID4gPiA+ID4gPiA+ID4gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tCj4gPiA+ID4gPiA+ID4gPiBsb2ctd3JpdGVzIGRldmljZShE
QVgpwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbG9nLXdyaXRlcyBkZXZpY2UoREFY
KQo+ID4gPiA+ID4gPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgfAo+ID4gPiA+ID4gPiA+ID4gUE1FTTAoREFYKSArIFBNRU0xKERBWCnCoMKgwqDC
oMKgwqAgVGhpbiBkZXZpY2Uobm9uLURBWCkgKyBQTUVNMShEQVgpCj4gPiA+ID4gPiA+ID4gPiDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8Cj4gPiA+ID4gPiA+ID4gPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIFBNRU0wKERBWCkKPiA+ID4gPiA+ID4gPiA+IC0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQo+ID4gPiA+
ID4gPiA+ID4gCj4gPiA+ID4gPiA+ID4gPiBXZSB0aGluayBkbS10aGluIGRldmljZSBpcyBub3Qg
YSBnb29kIHNvbHV0aW9uCj4gPiA+ID4gPiA+ID4gPiBmb3IgZ2VuZXJpYy80NzAsIGlzIHRoZXJl
Cj4gPiA+ID4gPiA+ID4gPiBhbnkgb3RoZXIgc29sdXRpb24gdG8gc3VwcG9ydCBib3RoIGRpc2Nh
cmQgemVybyBhbmQgREFYPwo+ID4gPiA+ID4gPiA+IAo+ID4gPiA+ID4gPiA+IEhpIEJyaWFuLAo+
ID4gPiA+ID4gPiA+IAo+ID4gPiA+ID4gPiA+IEkgaGF2ZSBzZW50IGEgcGF0Y2hbMV0gdG8gcmV2
ZXJ0IHlvdXIgZml4IGJlY2F1c2UgSQo+ID4gPiA+ID4gPiA+IHRoaW5rIGl0J3Mgbm90IGdvb2Qg
Zm9yCj4gPiA+ID4gPiA+ID4gZ2VuZXJpYy80NzAgdG8gdXNlIHRoaW4gdm9sdW1lIGFzIG15IHJl
dmVydCBwYXRjaFsxXSBkZXNjcmliZXM6Cj4gPiA+ID4gPiA+ID4gWzFdIGh0dHBzOi8vbG9yZS5r
ZXJuZWwub3JnL2ZzdGVzdHMvMjAyMjA5MTQwOTA2MjUuMzIyMDctMS15YW5neC5qeUBmdWppdHN1
LmNvbS9ULyN1Cj4gPiA+ID4gPiA+ID4gCj4gPiA+ID4gPiA+ID4gCj4gPiA+ID4gPiA+IAo+ID4g
PiA+ID4gPiBJIHRoaW5rIHRoZSBoaXN0b3J5IGhlcmUgaXMgdGhhdCBnZW5lcmljLzQ4MiB3YXMg
Y2hhbmdlZCBvdmVyIGZpcnN0IGluCj4gPiA+ID4gPiA+IGNvbW1pdCA2NWNjOWEyMzU5MTkgKCJn
ZW5lcmljLzQ4MjogdXNlIHRoaW4gdm9sdW1lIGFzCj4gPiA+ID4gPiA+IGRhdGEgZGV2aWNlIiks
IGFuZAo+ID4gPiA+ID4gPiB0aGVuIHNvbWV0aW1lIGxhdGVyIHdlIHJlYWxpemVkIGdlbmVyaWMv
NDU1LDQ1Nyw0NzAgaGFkCj4gPiA+ID4gPiA+IHRoZSBzYW1lIGdlbmVyYWwKPiA+ID4gPiA+ID4g
ZmxhdyBhbmQgd2VyZSBzd2l0Y2hlZCBvdmVyLiBUaGUgZG0vZGF4IGNvbXBhdGliaWxpdHkKPiA+
ID4gPiA+ID4gdGhpbmcgd2FzIHByb2JhYmx5Cj4gPiA+ID4gPiA+IGp1c3QgYW4gb3ZlcnNpZ2h0
LCBidXQgSSBhbSBhIGxpdHRsZSBjdXJpb3VzIGFib3V0IHRoYXQKPiA+ID4gPiA+ID4gYmVjYXVz
ZSBpdCBzaG91bGQKPiA+ID4gPiA+IAo+ID4gPiA+ID4gSXQncyBub3QgYW4gb3ZlcnNpZ2h0IC0t
IGl0IHVzZWQgdG8gd29yayAoYWxiZWl0IHdpdGggRVhQRVJJTUVOVEFMCj4gPiA+ID4gPiB0YWdz
KSwgYW5kIG5vdyB3ZSd2ZSBicm9rZW4gaXQgb24gZnNkYXggYXMgdGhlIHBtZW0vYmxvY2tkZXYg
ZGl2b3JjZQo+ID4gPiA+ID4gcHJvZ3Jlc3Nlcy4KPiA+ID4gPiBIaQo+ID4gPiA+IAo+ID4gPiA+
IERvIHlvdSBtZWFuIHRoYXQgdGhlIGZvbGxvd2luZyBwYXRjaCBzZXQgY2hhbmdlZCB0aGUgdGVz
dCByZXN1bHQKPiA+ID4gPiBvZiBnZW5lcmljLzQ3MCB3aXRoIHRoaW4tdm9sdW1lPyAocGFzcyA9
PiBub3QgcnVuL2ZhaWx1cmUpCj4gPiA+ID4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgt
eGZzLzIwMjExMTI5MTAyMjAzLjIyNDM1MDktMS1oY2hAbHN0LmRlLwo+ID4gPiA+IAo+ID4gPiA+
ID4gCj4gPiA+ID4gPiA+IGhhdmUgYmVlbiBvYnZpb3VzIHRoYXQgdGhlIGNoYW5nZSBjYXVzZWQg
dGhlIHRlc3QgdG8gbm8KPiA+ID4gPiA+ID4gbG9uZ2VyIHJ1bi4gRGlkCj4gPiA+ID4gPiA+IHNv
bWV0aGluZyBjaGFuZ2UgYWZ0ZXIgdGhhdCB0byB0cmlnZ2VyIHRoYXQgY2hhbmdlIGluIGJlaGF2
aW9yPwo+ID4gPiA+ID4gPiAKPiA+ID4gPiA+ID4gPiBXaXRoIHRoZSByZXZlcnQsIGdlbmVyaWMv
NDcwIGNhbiBhbHdheXMgcnVuCj4gPiA+ID4gPiA+ID4gc3VjY2Vzc2Z1bGx5IG9uIG15IGVudmly
b25tZW50Cj4gPiA+ID4gPiA+ID4gc28gSSB3b25kZXIgaG93IHRvIHJlcHJvZHVjZSB0aGUgb3V0
LW9mLW9yZGVyIHJlcGxheSBpc3N1ZSBvbiBYRlMgdjUKPiA+ID4gPiA+ID4gPiBmaWxlc3lzdGVt
Pwo+ID4gPiA+ID4gPiA+IAo+ID4gPiA+ID4gPiAKPiA+ID4gPiA+ID4gSSBkb24ndCBxdWl0ZSBy
ZWNhbGwgdGhlIGNoYXJhY3RlcmlzdGljcyBvZiB0aGUgZmFpbHVyZXMKPiA+ID4gPiA+ID4gYmV5
b25kIHRoYXQgd2UKPiA+ID4gPiA+ID4gd2VyZSBzZWVpbmcgc3B1cmlvdXMgdGVzdCBmYWlsdXJl
cyB3aXRoIGdlbmVyaWMvNDgyIHRoYXQgd2VyZSBkdWUgdG8KPiA+ID4gPiA+ID4gZXNzZW50aWFs
bHkgcHV0dGluZyB0aGUgZnMvbG9nIGJhY2sgaW4gdGltZSBpbiBhIHdheSB0aGF0IHdhc24ndCBx
dWl0ZQo+ID4gPiA+ID4gPiBhY2N1cmF0ZSBkdWUgdG8gdGhlIGNsZWFyaW5nIGJ5IHRoZSBsb2d3
cml0ZXMgdG9vbCBub3QKPiA+ID4gPiA+ID4gdGFraW5nIHBsYWNlLiBJZgo+ID4gPiA+ID4gPiB5
b3Ugd2FudGVkIHRvIHJlcHJvZHVjZSBpbiBvcmRlciB0byByZXZpc2l0IHRoYXQsIHBlcmhhcHMg
c3RhcnQgd2l0aAo+ID4gPiA+ID4gPiBnZW5lcmljLzQ4MiBhbmQgbGV0IGl0IHJ1biBpbiBhIGxv
b3AgZm9yIGEgd2hpbGUgYW5kIHNlZSBpZiBpdAo+ID4gPiA+ID4gPiBldmVudHVhbGx5IHRyaWdn
ZXJzIGEgZmFpbHVyZS9jb3JydXB0aW9uLi4/Cj4gPiA+ID4gPiA+IAo+ID4gPiA+ID4gPiA+IFBT
OiBJIHdhbnQgdG8gcmVwcm9kdWNlIHRoZSBpc3N1ZSBhbmQgdHJ5IHRvIGZpbmQgYQo+ID4gPiA+
ID4gPiA+IGJldHRlciBzb2x1dGlvbiB0byBmaXgKPiA+ID4gPiA+ID4gPiBpdC4KPiA+ID4gPiA+
ID4gPiAKPiA+ID4gPiA+ID4gCj4gPiA+ID4gPiA+IEl0J3MgYmVlbiBhIHdoaWxlIHNpbmNlIEkg
bG9va2VkIGF0IGFueSBvZiB0aGlzIHRvb2xpbmcKPiA+ID4gPiA+ID4gdG8gc2VtaS1ncm9rIGhv
dwo+ID4gPiA+ID4gPiBpdCB3b3Jrcy4KPiA+ID4gPiA+IAo+ID4gPiA+ID4gSSAvdGhpbmsvIHRo
aXMgd2FzIHRoZSBjcnV4IG9mIHRoZSBwcm9ibGVtLCBiYWNrIGluIDIwMTk/Cj4gPiA+ID4gPiBo
dHRwczovL2xvcmUua2VybmVsLm9yZy9mc3Rlc3RzLzIwMTkwMjI3MDYxNTI5LkdGMTY0MzZAZGFz
dGFyZC8KPiA+ID4gPiAKPiA+ID4gPiBBZ3JlZWQuCj4gPiA+ID4gCj4gPiA+ID4gPiAKPiA+ID4g
PiA+ID4gUGVyaGFwcyBpdCBjb3VsZCBsZWFybiB0byByZWx5IG9uIHNvbWV0aGluZyBtb3JlIGV4
cGxpY2l0IGxpa2UKPiA+ID4gPiA+ID4gemVybyByYW5nZSAoaW5zdGVhZCBvZiBkaXNjYXJkPykg
b3IgZmFsbCBiYWNrIHRvIG1hbnVhbCB6ZXJvaW5nPwo+ID4gPiA+ID4gCj4gPiA+ID4gPiBBRkFJ
Q1Qgc3JjL2xvZy13cml0ZXMvIGFjdHVhbGx5IC9jYW4vIGRvIHplcm9pbmcsIGJ1dCAoYSkgaXQg
cHJvYmFibHkKPiA+ID4gPiA+IG91Z2h0IHRvIGJlIGFkYXB0ZWQgdG8gY2FsbCBCTEtaRVJPT1VU
IGFuZCAoYikgaW4gdGhlIHdvcnN0IGNhc2UgaXQKPiA+ID4gPiA+IHdyaXRlcyB6ZXJvZXMgdG8g
dGhlIGVudGlyZSBkZXZpY2UsIHdoaWNoIGlzL2NhbiBiZSBzbG93Lgo+ID4gPiA+ID4gCj4gPiA+
ID4gPiBGb3IgYSAoY3Jhc3MpIGV4YW1wbGUsIG9uZSBvZiBteSBjbG91ZHkgdGVzdCBWTXMgdXNl
cyAzNEdCIHBhcnRpdGlvbnMsCj4gPiA+ID4gPiBhbmQgZm9yIGNvc3Qgb3B0aW1pemF0aW9uIHB1
cnBvc2VzIHdlJ3JlIG9ubHkgInBheWluZyIgZm9yIHRoZSBjaGVhcGVzdAo+ID4gPiA+ID4gdGll
ci7CoCBXZWlyZGx5IHRoYXQgbWFwcyB0byBhbiB1cHBlciBsaW1pdCBvZiA2NTAwIHdyaXRlIGlv
cHMgYW5kCj4gPiA+ID4gPiA0OE1CL3MoISkgYnV0IHRoYXQgd291bGQgdGFrZSBhYm91dCAyMCBt
aW51dGVzIHRvIHplcm8gdGhlIGVudGlyZQo+ID4gPiA+ID4gZGV2aWNlIGlmIHRoZSBkbS10aGlu
IGhhY2sgd2Fzbid0IGluIHBsYWNlLsKgIEZydXN0cmF0aW5nbHksIGl0IGRvZXNuJ3QKPiA+ID4g
PiA+IHN1cHBvcnQgZGlzY2FyZCBvciB3cml0ZS16ZXJvZXMuCj4gPiA+ID4gCj4gPiA+ID4gRG8g
eW91IG1lYW4gdGhhdCBkaXNjYXJkIHplcm8oQkxLRElTQ0FSRCkgaXMgZmFzdGVyIHRoYW4gYm90
aAo+ID4gPiA+IGZpbGwgemVybyhCTEtaRVJPT1VUKSBhbmQgd3JpdGUgemVybyBvbiB1c2VyIHNw
YWNlPwo+ID4gPiAKPiA+ID4gSGkgRGFycmljaywgQnJpYW4gYW5kIENocmlzdG9waAo+ID4gPiAK
PiA+ID4gQWNjb3JkaW5nIHRvIHRoZSBkaXNjdXNzaW9uIGFib3V0IGdlbmVyaWMvNDcwLiBJIHdv
bmRlciBpZiBpdCBpcwo+ID4gPiBuZWNlc3NhcnkgdG8gbWFrZSB0aGluLXBvb2wgc3VwcG9ydCBE
QVguIElzIHRoZXJlIGFueSB1c2UgY2FzZSBmb3IKPiA+ID4gdGhlIHJlcXVpcmVtZW50Pwo+ID4g
PiAKPiA+ID4gQmVzdCBSZWdhcmRzLAo+ID4gPiBYaWFvIFlhbmcKPiA+ID4gPiAKPiA+ID4gPiBC
ZXN0IFJlZ2FyZHMsCj4gPiA+ID4gWGlhbyBZYW5nCj4gPiA+ID4gPiAKPiA+ID4gPiA+ID4gSWYg
dGhlCj4gPiA+ID4gPiA+IGV2ZW50dWFsIHNvbHV0aW9uIGlzIHNpbXBsZSBhbmQgbG93IGVub3Vn
aCBvdmVyaGVhZCwgaXQKPiA+ID4gPiA+ID4gbWlnaHQgbWFrZSBzb21lCj4gPiA+ID4gPiA+IHNl
bnNlIHRvIHJlcGxhY2UgdGhlIGRtdGhpbiBoYWNrIGFjcm9zcyB0aGUgc2V0IG9mIHRlc3RzIG1l
bnRpb25lZAo+ID4gPiA+ID4gPiBhYm92ZS4KPiA+ID4gPiA+IAo+ID4gPiA+ID4gVGhhdCBzYWlk
LCBmb3IgYSAqcG1lbSogdGVzdCB5b3UnZCBleHBlY3QgaXQgdG8gYmUgZmFzdGVyIHRoYW4gdGhh
dC4uLgo+ID4gPiA+ID4gCj4gPiA+ID4gPiAtLUQKPiA+ID4gPiA+IAo+ID4gPiA+ID4gPiBCcmlh
bgo+ID4gPiA+ID4gPiAKPiA+ID4gPiA+ID4gPiBCZXN0IFJlZ2FyZHMsCj4gPiA+ID4gPiA+ID4g
WGlhbyBZYW5nCj4gPiA+ID4gPiA+ID4gCj4gPiA+ID4gPiA+ID4gPiAKPiA+ID4gPiA+ID4gPiA+
IEJUVywgb25seSBsb2ctd3JpdGVzLCBzdHJpcGUgYW5kIGxpbmVhciBzdXBwb3J0IERBWCBmb3Ig
bm93Lgo+ID4gPiA+ID4gPiA+IAo+ID4gPiA+ID4gPiAKPiAKCi0tCmRtLWRldmVsIG1haWxpbmcg
bGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxt
YW4vbGlzdGluZm8vZG0tZGV2ZWwK

