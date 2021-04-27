Return-Path: <SRS0=s6iH=JY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 810CFC433B4
	for <dm-devel@archiver.kernel.org>; Tue, 27 Apr 2021 10:57:17 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 35427613BF
	for <dm-devel@archiver.kernel.org>; Tue, 27 Apr 2021 10:57:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 35427613BF
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=rz.uni-regensburg.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203-KUCaKCjyPjO6KmVBPwSB4g-1; Tue, 27 Apr 2021 06:57:12 -0400
X-MC-Unique: KUCaKCjyPjO6KmVBPwSB4g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 857C61898296;
	Tue, 27 Apr 2021 10:57:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 421816A8EA;
	Tue, 27 Apr 2021 10:57:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 777CA1806D1B;
	Tue, 27 Apr 2021 10:57:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13RAqgA0007419 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 27 Apr 2021 06:52:42 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 8084851E1; Tue, 27 Apr 2021 10:52:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7AE354404A
	for <dm-devel@redhat.com>; Tue, 27 Apr 2021 10:52:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2FD02857A86
	for <dm-devel@redhat.com>; Tue, 27 Apr 2021 10:52:40 +0000 (UTC)
Received: from mx3.uni-regensburg.de (mx3.uni-regensburg.de
	[194.94.157.148]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-278-lEIJlAM9NnuusqKSWmZRyg-1; Tue, 27 Apr 2021 06:52:37 -0400
X-MC-Unique: lEIJlAM9NnuusqKSWmZRyg-1
Received: from mx3.uni-regensburg.de (localhost [127.0.0.1])
	by localhost (Postfix) with SMTP id 71932600004D
	for <dm-devel@redhat.com>; Tue, 27 Apr 2021 12:52:35 +0200 (CEST)
Received: from gwsmtp.uni-regensburg.de (gwsmtp1.uni-regensburg.de
	[132.199.5.51])
	by mx3.uni-regensburg.de (Postfix) with ESMTP id 49E1C600005E
	for <dm-devel@redhat.com>; Tue, 27 Apr 2021 12:52:34 +0200 (CEST)
Received: from uni-regensburg-smtp1-MTA by gwsmtp.uni-regensburg.de
	with Novell_GroupWise; Tue, 27 Apr 2021 12:52:34 +0200
Message-Id: <6087ECF1020000A100040C7F@gwsmtp.uni-regensburg.de>
Date: Tue, 27 Apr 2021 12:52:33 +0200
From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To: <erwin@erwinvanlonden.net>, <martin.petersen@oracle.com>,
	<martin.wilck@suse.com>, <hare@suse.de>
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
In-Reply-To: <2a6903e4-ff2b-67d5-e772-6971db8448fb@suse.de>
Mime-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 13RAqgA0007419
X-loop: dm-devel@redhat.com
Cc: hare@suse.com, "systemd-devel@lists.freedesktop.org"
	<systemd-devel@lists.freedesktop.org>,
	linux-scsi@vger.kernel.org, dm-devel@redhat.com,
	dgilbert@interlog.com, jejb@linux.vnet.ibm.com, hch@lst.de
Subject: [dm-devel] Antw: [EXT] Re: RFC: one more time: SCSI device
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
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

Pj4+IEhhbm5lcyBSZWluZWNrZSA8aGFyZUBzdXNlLmRlPiBzY2hyaWViIGFtIDI3LjA0LjIwMjEg
dW0gMTA6MjEgaW4gTmFjaHJpY2h0CjwyYTY5MDNlNC1mZjJiLTY3ZDUtZTc3Mi02OTcxZGI4NDQ4
ZmJAc3VzZS5kZT46Cj4gT24gNC8yNy8yMSAxMDoxMCBBTSwgTWFydGluIFdpbGNrIHdyb3RlOgo+
PiBPbiBUdWUsIDIwMjHigJEwNOKAkTI3IGF0IDEzOjQ4ICsxMDAwLCBFcndpbiB2YW4gTG9uZGVu
IHdyb3RlOgo+Pj4+Cj4+Pj4gV3J0IDEpLCB3ZSBjYW4gb25seSBob3BlIHRoYXQgaXQncyB0aGUg
Y2FzZS4gQnV0IDIpIGFuZCAzKSBuZWVkIHdvcmssCj4+Pj4gYWZhaWNzLgo+Pj4+Cj4+PiBJbiBt
eSB2aWV3IHRoZSBXV0lEIHNob3VsZCBuZXZlciBjaGFuZ2UuIAo+PiAKPj4gSW4gYW4gaWRlYWwg
d29ybGQsIHBlcmhhcHMgbm90LiBCdXQgaW4gdGhlIGRt4oCRbXVsdGlwYXRoIHJlYWxtLCB3ZSBr
bm93Cj4+IHRoYXQgV1dJRCBjaGFuZ2VzIGNhbiBoYXBwZW4gd2l0aCBjZXJ0YWluIHN0b3JhZ2Ug
YXJyYXlzLiBTZWUgCj4+IGh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL2FyY2hpdmVzL2Rt4oCR
ZGV2ZWwvMjAyMeKAkUZlYnJ1YXJ5L21zZzAwMTE2Lmh0bWwgCj4+IGFuZCBmb2xsb3figJF1cHMs
IGZvciBleGFtcGxlLgo+PiAKPiBBbmQgaXQncyBhY3R1YWxseSBzb21ldGhpbmcgd2hpY2ggbWln
aHQgaGFwcGVuIHF1aXRlIGVhc2lseS4KPiBUaGUgc3RvcmFnZSBhcnJheSBjYW4gdW5tYXAgYSBM
VU4sIGRlbGV0ZSBpdCwgY3JlYXRlIGEgbmV3IG9uZSwgYW5kIG1hcAo+IHRoYXQgb25lIGludG8g
dGhlIHNhbWUgTFVOIG51bWJlciB0aGFuIHRoZSBvbGQgb25lLgo+IElmIHdlIGRpZG4ndCBkbyBJ
L08gZHVyaW5nIHRoYXQgaW50ZXJ2YWwgdXBvbiB0aGUgbmV4dCBJL08gd2Ugd2lsbCBiZQo+IGdl
dHRpbmcgdGhlIGRyZWFkZWQgJ1Bvd2Vy4oCRT24vUmVzZXQnIHNlbnNlIGNvZGUuCj4gX0FuZCBu
b3RoaW5nIGVsc2VfLCBkdWUgdG8gdGhlIGFyY2FuZSBydWxlcyBmb3Igc2Vuc2UgY29kZSBnZW5l
cmF0aW9uIGluCj4gU0FNLgo+IEJ1dCB3ZSBlbmQgdXAgd2l0aCBhIGNvbXBsZXRlbHkgZGlmZmVy
ZW50IGRldmljZS4KPiAKPiBUaGUgb25seSB3YXkgb3V0IG9mIGl0IGlzIHRvIGRvIGEgcmVzY2Fu
IGZvciBldmVyeSBQT1Igc2Vuc2UgY29kZSwgYW5kCj4gZGlzYWJsZSB0aGUgZGV2aWNlIGVnIHZp
YSBESURfTk9fQ09OTkVDVCB3aGVuZXZlciB3ZSBmaW5kIHRoYXQgdGhlCj4gaWRlbnRpZmljYXRp
b24gaGFzIGNoYW5nZWQuIFdlIGFscmVhZHkgaGF2ZSBhIGNvcHkgb2YgdGhlIG9yaWdpbmFsIFZQ
RAo+IHBhZ2UgMHg4MyBhdCBoYW5kLCBzbyB0aGF0IHNob3VsZCBiZSByZWFzb25hYmx5IGVhc3ku
CgpJIGRvbid0IGtub3cgdGhlIGRlcHRoIG9mIHRoZSBTQ1NJIG9yIEZDIHByb3RvY29sLCBidXQg
c3RvcmFnZSBzeXN0ZW1zCnR5cGljYWxseSBzaWduYWwgc3VjaCBldmVudHMsIG1heWJlIGVpdGhl
ciB2aWEgc29tZSB1bml0IGF0dGVudGlvbiBvciBzb21lIEZDCmV2ZW50LiBPbGRlciBrZXJuZWxz
IGxvZ2dlZCB0aGF0IHRoZXJlIHdhcyBhIGNoYW5nZSwgYnV0IGEgbWFudWFsIFNDU0kgYnVzIHNj
YW4KaXMgbmVlZGVkLCB3aGlsZSBuZXdlciBrZXJuZWxzIGZpbmQgbmV3IGRldmljZXMgImF1dG9t
YWdpY2FsbHkiIGZvciBzb21lCnByb2R1Y3RzLiBUaGUgSFAgRVZBIDYwMDAgc2VyaWVzIHdvcmVk
IHRoYXQgd2F5LCBhIDNQQVIgU290b3JTZXJ2IDgwMDAgc2VyaWVzCmFsc28gc2VlbXMgdG8gd29y
ayB0aGF0IHdheSwgYnV0IG5vdCBQdXJlIFN0b3JhZ2UgWDcwIFIzLiBGT3IgdGhlIGxhdHRlciB5
b3UKbmVlZCBzb21ldGhpbmcgbGlrZSBhIEZDIExJUCB0byBtYWtlIHRoZSBrZXJuZWwgZGV0ZWN0
IHRoZSBuZXcgZGV2aWNlcyAoTFVOcykuCkknbSB1bnN1cmUgd2hlcmUgdGhlIHByb2JsZW0gaXMs
IGJ1dCBpbiBwcmluY2lwbGUgdGhlIGtlcm5lbCBjYW4gYmUKbm90aWZpZWQuLi4KCj4gCj4gSSBo
YWQgYSByYXRoZXIgbGVuZ3RoeSBkaXNjdXNzaW9uIHdpdGggRnJlZCBLbmlnaHQgQCBOZXRBcHAg
YWJvdXQKPiBQb3dlcuKAkU9uL1Jlc2V0IGhhbmRsaW5nLCB3aGF0IHdpdGggaGltIGNvbXBsYWlu
aW5nIHRoYXQgd2UgZG9uJ3QgaGFuZGxlCj4gaXMgY29ycmVjdGx5LiBTbyB0aGlzIHJlYWxseSBp
cyBzb21ldGhpbmcgd2Ugc2hvdWxkIGJlIGxvb2tpbmcgaW50bywKPiBldmVuIGluZGVwZW5kZW50
bHkgb2YgbXVsdGlwYXRoaW5nLgo+IAo+IEJ1dCBhY3R1YWxseSBJIGxpa2UgdGhlIGlkZWEgZnJv
bSBNYXJ0aW4gUGV0ZXJzZW4gdG8gZXhwb3NlIHRoZSBwYXJzZWQKPiBWUEQgaWRlbnRpZmllcnMg
dG8gc3lzZnM7IHRoYXQgd291bGQgYWxsb3cgdXMgdG8gZHJvcCBzZ19pbnEgY29tcGxldGVseQo+
IGZyb20gdGhlIHVkZXYgcnVsZXMuCgpUYWxraW5nIG9mIFZQRHM6IFNvbWV3aGVyZSBpbiB0aGUg
bGFzdCAxMiB5ZWFycyAod2l0aGluIFNMRVMgMTEpdGhlcmUgd2FzIGEKa2VybmVsIGNoYW5nZSBy
ZWdhcmRpbmcgdHJhaWxpbmcgYmxhbmtzIGluIFZQRCBkYXRhLiBUaGF0IGNoYW5nZSBibGV3IHVw
CnNldmVyYWwgY29uZmlndXJhdGlvbnMgYmVpbmcgdW5hYmxlIHRvIHJlLXJlY29nbml6ZSB0aGUg
ZGV2aWNlcy4gSW4gb25lIGNhc2UKdGhlIHNvZnR3YXJlIGV2ZW4gaGFkIGJvdW5kIGEgbGljZW5z
ZSB0byBhIHNwZWNpZmljIGRldmljZSB3aXRoIHNlcmlhbCBudW1iZXIsCmFuZCB0aGF0IHNvZnR3
YXJlIGZvdW5kICJuZXciIGRldmljZXMgd2hpbGUgbWlzc2luZyB0aGUgIm9sZCIgb25lcy4uLgoK
UmVnYXJkcywKVWxyaWNoCgo+IAo+IENoZWVycywKPiAKPiBIYW5uZXMKPiDigJHigJEgCj4gRHIu
IEhhbm5lcyBSZWluZWNrZQkJICAgICAgICBLZXJuZWwgU3RvcmFnZSBBcmNoaXRlY3QKPiBoYXJl
QHN1c2UuZGUJCQkgICAgICAgICAgICAgICArNDkgOTExIDc0MDUzIDY4OAo+IFNVU0UgU29mdHdh
cmUgU29sdXRpb25zIEdlcm1hbnkgR21iSCwgOTA0MDkgTsO8cm5iZXJnCj4gR0Y6IEYuIEltZW5k
w7ZyZmZlciwgSFJCIDM2ODA5IChBRyBOw7xybmJlcmcpCgoKCgotLQpkbS1kZXZlbCBtYWlsaW5n
IGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWls
bWFuL2xpc3RpbmZvL2RtLWRldmVs

