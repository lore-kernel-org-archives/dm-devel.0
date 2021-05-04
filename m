Return-Path: <SRS0=e+QJ=J7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56F54C433ED
	for <dm-devel@archiver.kernel.org>; Tue,  4 May 2021 07:32:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9BCBF6139A
	for <dm-devel@archiver.kernel.org>; Tue,  4 May 2021 07:32:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9BCBF6139A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-450-ZL9x_kLNPJ-s8tdEHJPQ8w-1; Tue, 04 May 2021 03:32:48 -0400
X-MC-Unique: ZL9x_kLNPJ-s8tdEHJPQ8w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C3848800D62;
	Tue,  4 May 2021 07:32:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C97545D9D0;
	Tue,  4 May 2021 07:32:41 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BC63955346;
	Tue,  4 May 2021 07:32:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1447WXSd013627 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 4 May 2021 03:32:33 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 1EFB1200BD8A; Tue,  4 May 2021 07:32:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B2EA200BC93
	for <dm-devel@redhat.com>; Tue,  4 May 2021 07:32:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B01F6858F0D
	for <dm-devel@redhat.com>; Tue,  4 May 2021 07:32:30 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-348-mDz63H6NO4WYDW2Q2HjNSQ-1;
	Tue, 04 May 2021 03:32:28 -0400
X-MC-Unique: mDz63H6NO4WYDW2Q2HjNSQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 29392AD09;
	Tue,  4 May 2021 07:32:27 +0000 (UTC)
To: Ulrich Windl <Ulrich.Windl@rz.uni-regensburg.de>, erwin@erwinvanlonden.net,
	martin.petersen@oracle.com, martin.wilck@suse.com
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
From: Hannes Reinecke <hare@suse.de>
Message-ID: <b7d593cc-2adb-1350-be16-39c7c309fdaf@suse.de>
Date: Tue, 4 May 2021 09:32:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <6087ECF1020000A100040C7F@gwsmtp.uni-regensburg.de>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1447WXSd013627
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gNC8yNy8yMSAxMjo1MiBQTSwgVWxyaWNoIFdpbmRsIHdyb3RlOgo+Pj4+IEhhbm5lcyBSZWlu
ZWNrZSA8aGFyZUBzdXNlLmRlPiBzY2hyaWViIGFtIDI3LjA0LjIwMjEgdW0gMTA6MjEgaW4gTmFj
aHJpY2h0Cj4gPDJhNjkwM2U0LWZmMmItNjdkNS1lNzcyLTY5NzFkYjg0NDhmYkBzdXNlLmRlPjoK
Pj4gT24gNC8yNy8yMSAxMDoxMCBBTSwgTWFydGluIFdpbGNrIHdyb3RlOgo+Pj4gT24gVHVlLCAy
MDIx4oCRMDTigJEyNyBhdCAxMzo0OCArMTAwMCwgRXJ3aW4gdmFuIExvbmRlbiB3cm90ZToKPj4+
Pj4KPj4+Pj4gV3J0IDEpLCB3ZSBjYW4gb25seSBob3BlIHRoYXQgaXQncyB0aGUgY2FzZS4gQnV0
IDIpIGFuZCAzKSBuZWVkIHdvcmssCj4+Pj4+IGFmYWljcy4KPj4+Pj4KPj4+PiBJbiBteSB2aWV3
IHRoZSBXV0lEIHNob3VsZCBuZXZlciBjaGFuZ2UuCj4+Pgo+Pj4gSW4gYW4gaWRlYWwgd29ybGQs
IHBlcmhhcHMgbm90LiBCdXQgaW4gdGhlIGRt4oCRbXVsdGlwYXRoIHJlYWxtLCB3ZSBrbm93Cj4+
PiB0aGF0IFdXSUQgY2hhbmdlcyBjYW4gaGFwcGVuIHdpdGggY2VydGFpbiBzdG9yYWdlIGFycmF5
cy4gU2VlCj4+PiBodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9hcmNoaXZlcy9kbeKAkWRldmVs
LzIwMjHigJFGZWJydWFyeS9tc2cwMDExNi5odG1sCj4+PiBhbmQgZm9sbG934oCRdXBzLCBmb3Ig
ZXhhbXBsZS4KPj4+Cj4+IEFuZCBpdCdzIGFjdHVhbGx5IHNvbWV0aGluZyB3aGljaCBtaWdodCBo
YXBwZW4gcXVpdGUgZWFzaWx5Lgo+PiBUaGUgc3RvcmFnZSBhcnJheSBjYW4gdW5tYXAgYSBMVU4s
IGRlbGV0ZSBpdCwgY3JlYXRlIGEgbmV3IG9uZSwgYW5kIG1hcAo+PiB0aGF0IG9uZSBpbnRvIHRo
ZSBzYW1lIExVTiBudW1iZXIgdGhhbiB0aGUgb2xkIG9uZS4KPj4gSWYgd2UgZGlkbid0IGRvIEkv
TyBkdXJpbmcgdGhhdCBpbnRlcnZhbCB1cG9uIHRoZSBuZXh0IEkvTyB3ZSB3aWxsIGJlCj4+IGdl
dHRpbmcgdGhlIGRyZWFkZWQgJ1Bvd2Vy4oCRT24vUmVzZXQnIHNlbnNlIGNvZGUuCj4+IF9BbmQg
bm90aGluZyBlbHNlXywgZHVlIHRvIHRoZSBhcmNhbmUgcnVsZXMgZm9yIHNlbnNlIGNvZGUgZ2Vu
ZXJhdGlvbiBpbgo+PiBTQU0uCj4+IEJ1dCB3ZSBlbmQgdXAgd2l0aCBhIGNvbXBsZXRlbHkgZGlm
ZmVyZW50IGRldmljZS4KPj4KPj4gVGhlIG9ubHkgd2F5IG91dCBvZiBpdCBpcyB0byBkbyBhIHJl
c2NhbiBmb3IgZXZlcnkgUE9SIHNlbnNlIGNvZGUsIGFuZAo+PiBkaXNhYmxlIHRoZSBkZXZpY2Ug
ZWcgdmlhIERJRF9OT19DT05ORUNUIHdoZW5ldmVyIHdlIGZpbmQgdGhhdCB0aGUKPj4gaWRlbnRp
ZmljYXRpb24gaGFzIGNoYW5nZWQuIFdlIGFscmVhZHkgaGF2ZSBhIGNvcHkgb2YgdGhlIG9yaWdp
bmFsIFZQRAo+PiBwYWdlIDB4ODMgYXQgaGFuZCwgc28gdGhhdCBzaG91bGQgYmUgcmVhc29uYWJs
eSBlYXN5Lgo+IAo+IEkgZG9uJ3Qga25vdyB0aGUgZGVwdGggb2YgdGhlIFNDU0kgb3IgRkMgcHJv
dG9jb2wsIGJ1dCBzdG9yYWdlIHN5c3RlbXMKPiB0eXBpY2FsbHkgc2lnbmFsIHN1Y2ggZXZlbnRz
LCBtYXliZSBlaXRoZXIgdmlhIHNvbWUgdW5pdCBhdHRlbnRpb24gb3Igc29tZSBGQwo+IGV2ZW50
LiBPbGRlciBrZXJuZWxzIGxvZ2dlZCB0aGF0IHRoZXJlIHdhcyBhIGNoYW5nZSwgYnV0IGEgbWFu
dWFsIFNDU0kgYnVzIHNjYW4KPiBpcyBuZWVkZWQsIHdoaWxlIG5ld2VyIGtlcm5lbHMgZmluZCBu
ZXcgZGV2aWNlcyAiYXV0b21hZ2ljYWxseSIgZm9yIHNvbWUKPiBwcm9kdWN0cy4gVGhlIEhQIEVW
QSA2MDAwIHNlcmllcyB3b3JlZCB0aGF0IHdheSwgYSAzUEFSIFNvdG9yU2VydiA4MDAwIHNlcmll
cwo+IGFsc28gc2VlbXMgdG8gd29yayB0aGF0IHdheSwgYnV0IG5vdCBQdXJlIFN0b3JhZ2UgWDcw
IFIzLiBGT3IgdGhlIGxhdHRlciB5b3UKPiBuZWVkIHNvbWV0aGluZyBsaWtlIGEgRkMgTElQIHRv
IG1ha2UgdGhlIGtlcm5lbCBkZXRlY3QgdGhlIG5ldyBkZXZpY2VzIChMVU5zKS4KPiBJJ20gdW5z
dXJlIHdoZXJlIHRoZSBwcm9ibGVtIGlzLCBidXQgaW4gcHJpbmNpcGxlIHRoZSBrZXJuZWwgY2Fu
IGJlCj4gbm90aWZpZWQuLi4KPiAKTXkgcG9pbnQgd2FzIHRoYXQgd2hpbGUgdGhlcmUgX2lzXyBh
IHVuaXQgYXR0ZW50aW9uIHdpdGggdGhlIHNlbnNlIGNvZGUgCidJTlFVSVJZIERBVEEgQ0hBTkdF
RCcgKGFuZCB0aGF0IGluZGVlZCB3aWxsIGdlbmVyYXRlIGEga2VybmVsIG1lc3NhZ2UpLCAKaXQg
bWlnaHQgYmUgb2JzY3VyZWQgYnkgYSBzdWJzZXF1ZW50IHVuaXQgYXR0ZW50aW9uIHdpdGggdGhl
IHNlbnNlIGNvZGUgCidQb3dlci1Pbi9SZXNldCcsIGFzIHBlciBTQ1NJIHNwZWMgdGhlIGxhdHRl
ciBtaWdodCBjYXVzZSB0aGUgcHJldmlvdXMgCm9uZXMgdG8gX25vdF8gYmVpbmcgc2VudC4KU28g
ZnJvbSB0aGF0IHJlYXNvbmluZyB3ZSB3aWxsIG5lZWQgdG8gcmVzY2FuIHRoZSBkZXZpY2UgdXBv
biAKJ1Bvd2VyLW9uL1Jlc2V0Jy4KQnV0ICdQb3dlci1Pbi9SZXNldCcgaXMgYSBzZW5zZSBjb2Rl
IHdoaWNoIHdlIGFsc28gZ2V0IGR1cmluZyBpbml0aWFsIApkZXZpY2Ugc2Nhbiwgc28gdGhlIHBy
b2JsZW0gaXMgdGhhdCB3ZSB3aWxsIGJlIHRyaWdnZXJpbmcgYSByZXNjYW4gd2hpbGUgCl9kb2lu
Z18gYSByZXNjYW4sIGFuZCBhcyBzdWNoIGl0IHdvdWxkIG5lZWQgc29tZSByZWFsbHkgY2FyZWZ1
bCB0ZXN0aW5nLgoKQXMgZm9yIHRoZSBQdXJlU3RvcmFnZSBiZWhhdmlvdXI6IFRoZSBwcm9ibGVt
IHdpdGggY2hhbmdpbmcgdGhlIExVTiAKbWFwcGluZyBvbiB0aGUgYXJyYXkgaXMgdGhhdCBpdCB3
ZSBtaWdodCBub3QgX2hhdmVfIGEgZGV2aWNlIHRvIHNlbmQgCnVuaXQgYXR0ZW50aW9ucyB0by4K
SWYgdGhlIGFycmF5IGFscmVhZHkgZXhwb3J0cyBMVU5zIHRvIHNvbWUgb3RoZXIgaG9zdHMsIGl0
IGRvZXNuJ3QgbmVlZCAKdG8gcmUtaW5pdGlhbGl6ZSB0aGUgRkMgcG9ydCB3aGVuIHN0YXJ0aW5n
IHRvIGV4cG9ydCBMVU5zIHRvIF90aGlzXyAKaG9zdC4gQW5kIGFzIF90aGlzXyBob3N0IGRvZXNu
J3QgaGF2ZSBhIExVTiBvbiB3aGljaCB1bml0IGF0dGVudGlvbnMgY2FuIApiZSBzZW50LCBfYW5k
XyB0aGUgRkMgcG9ydCBpcyBhbHJlYWR5IHJlZ2lzdGVyZWQsIHRoZXJlIGFyZSBubyBldmVudHMg
CndoYXRzb2V2ZXIgd2hpY2ggd291bGQgY2F1c2UgdGhlIGhvc3QgdG8gaW5pdGlhdGUgYSByZXNj
YW4uClRvIHJlc29sdmUgdGhhdCB0aGUgYXJyYXkgd291bGQgbmVlZCB0byBpbmR1Y2UgZWcgYW4g
UlNDTiwgYnV0IHRoYXQgd2lsbCAKb25seSBiZSB0cmlnZ2VyZWQgaWYgYSBGQyBwb3J0IGlzIChy
ZS0pcmVnaXN0ZXJlZC4KV2hpY2ggaXMgd2hhdCBIUGUgYXJyYXlzIGRvOyBpbml0aWF0ZSBhIGxp
bmstYm91bmNlIG9uIHRoZSBhdHRhY2hlZCAKcG9ydHMsIHdoaWNoIHdpbGwgY2F1c2UgdGhlIGF0
dGFjaGVkIGhvc3RzIHRvIGluaXRpYXRlIGEgcmVzY2FuLgpPZiBjb3Vyc2UsIF9hbGxfIGhvc3Rz
IHdpbGwgbmVlZCB0byByZXNjYW4gKGFuZCB0aGVyZWJ5IGNhdXNpbmcgYW4gCmludGVycnVwdGlv
biBldmVuIG9uIHVucmVsYXRlZCBob3N0cyksIHdoaWNoIGlzIHdoeSB0aGlzIGlzIG5vdCBkb25l
IGJ5IAphbGwgdmVuZG9ycy4KCj4+Cj4+IEkgaGFkIGEgcmF0aGVyIGxlbmd0aHkgZGlzY3Vzc2lv
biB3aXRoIEZyZWQgS25pZ2h0IEAgTmV0QXBwIGFib3V0Cj4+IFBvd2Vy4oCRT24vUmVzZXQgaGFu
ZGxpbmcsIHdoYXQgd2l0aCBoaW0gY29tcGxhaW5pbmcgdGhhdCB3ZSBkb24ndCBoYW5kbGUKPj4g
aXMgY29ycmVjdGx5LiBTbyB0aGlzIHJlYWxseSBpcyBzb21ldGhpbmcgd2Ugc2hvdWxkIGJlIGxv
b2tpbmcgaW50bywKPj4gZXZlbiBpbmRlcGVuZGVudGx5IG9mIG11bHRpcGF0aGluZy4KPj4KPj4g
QnV0IGFjdHVhbGx5IEkgbGlrZSB0aGUgaWRlYSBmcm9tIE1hcnRpbiBQZXRlcnNlbiB0byBleHBv
c2UgdGhlIHBhcnNlZAo+PiBWUEQgaWRlbnRpZmllcnMgdG8gc3lzZnM7IHRoYXQgd291bGQgYWxs
b3cgdXMgdG8gZHJvcCBzZ19pbnEgY29tcGxldGVseQo+PiBmcm9tIHRoZSB1ZGV2IHJ1bGVzLgo+
IAo+IFRhbGtpbmcgb2YgVlBEczogU29tZXdoZXJlIGluIHRoZSBsYXN0IDEyIHllYXJzICh3aXRo
aW4gU0xFUyAxMSl0aGVyZSB3YXMgYQo+IGtlcm5lbCBjaGFuZ2UgcmVnYXJkaW5nIHRyYWlsaW5n
IGJsYW5rcyBpbiBWUEQgZGF0YS4gVGhhdCBjaGFuZ2UgYmxldyB1cAo+IHNldmVyYWwgY29uZmln
dXJhdGlvbnMgYmVpbmcgdW5hYmxlIHRvIHJlLXJlY29nbml6ZSB0aGUgZGV2aWNlcy4gSW4gb25l
IGNhc2UKPiB0aGUgc29mdHdhcmUgZXZlbiBoYWQgYm91bmQgYSBsaWNlbnNlIHRvIGEgc3BlY2lm
aWMgZGV2aWNlIHdpdGggc2VyaWFsIG51bWJlciwKPiBhbmQgdGhhdCBzb2Z0d2FyZSBmb3VuZCAi
bmV3IiBkZXZpY2VzIHdoaWxlIG1pc3NpbmcgdGhlICJvbGQiIG9uZXMuLi4KPiAKVGhhdCdzIHBy
b2JhYmx5IGp1c3QgZm9yIFZQRCBwYWdlIDB4ODAuIFBhZ2UgMHg4MyBoYXMgcHJldHR5IHN0cmlj
dCAKcnVsZXMgb24gaG93IHRoZSBlbnRyaWVzIGFyZSBmb3JtYXR0ZWQsIHNvIGNob3BwaW5nIG9m
ZiB0cmFpbGluZyBibGFua3MgCmlzIG5vdCBlYXNpbHkgZG9uZSB0aGVyZS4KCkNoZWVycywKCkhh
bm5lcwotLSAKRHIuIEhhbm5lcyBSZWluZWNrZSAgICAgICAgICAgICAgICBLZXJuZWwgU3RvcmFn
ZSBBcmNoaXRlY3QKaGFyZUBzdXNlLmRlICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKzQ5
IDkxMSA3NDA1MyA2ODgKU1VTRSBTb2Z0d2FyZSBTb2x1dGlvbnMgR21iSCwgTWF4ZmVsZHN0ci4g
NSwgOTA0MDkgTsO8cm5iZXJnCkhSQiAzNjgwOSAoQUcgTsO8cm5iZXJnKSwgR2VzY2jDpGZ0c2bD
vGhyZXI6IEZlbGl4IEltZW5kw7ZyZmZlcgoKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1k
ZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGlu
Zm8vZG0tZGV2ZWw=

