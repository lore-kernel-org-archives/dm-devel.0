Return-Path: <SRS0=5DIA=HG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03FD6C433E0
	for <dm-devel@archiver.kernel.org>; Thu,  4 Feb 2021 14:56:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7885564DE7
	for <dm-devel@archiver.kernel.org>; Thu,  4 Feb 2021 14:56:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7885564DE7
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-251-hd880yOHPMyPwvljPZ08iw-1; Thu, 04 Feb 2021 09:56:33 -0500
X-MC-Unique: hd880yOHPMyPwvljPZ08iw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 34DB8100C619;
	Thu,  4 Feb 2021 14:56:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 658715C290;
	Thu,  4 Feb 2021 14:56:26 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DA5344EE76;
	Thu,  4 Feb 2021 14:56:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 114EuLa1004172 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Feb 2021 09:56:21 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5EC3A2026D48; Thu,  4 Feb 2021 14:56:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 575412026D13
	for <dm-devel@redhat.com>; Thu,  4 Feb 2021 14:56:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 007C4858F0E
	for <dm-devel@redhat.com>; Thu,  4 Feb 2021 14:56:19 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-538-iVgW-29LPOG6_nOVPHRAXg-1;
	Thu, 04 Feb 2021 09:56:16 -0500
X-MC-Unique: iVgW-29LPOG6_nOVPHRAXg-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 73009ACB7;
	Thu,  4 Feb 2021 14:56:15 +0000 (UTC)
Message-ID: <d8e5a777991a31200e6aa85870b5b38b586bc765.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: lixiaokeng <lixiaokeng@huawei.com>, Benjamin Marzinski
	<bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>,
	dm-devel mailing list <dm-devel@redhat.com>
Date: Thu, 04 Feb 2021 15:56:14 +0100
In-Reply-To: <342183ae-ead1-a13f-9384-459d09c04e6c@huawei.com>
References: <063bbeeb-15aa-f7c0-b881-7526c3a2720c@huawei.com>
	<f86753b17cc7e85e7e0f7e711adec349323a7c5a.camel@suse.com>
	<d8ba8118-ce98-249a-cafd-021f0c1831a5@huawei.com>
	<f1961d4104b14c80183b161a53262e1766e0df70.camel@suse.com>
	<c52487a2-5c15-977c-704b-7cad5f6e275e@huawei.com>
	<cd3cae852bffc2d4a9be2e7f4334eb346cfaae8d.camel@suse.com>
	<ef4f29d8-a20b-2b4d-97ab-a83fb4bca5ac@huawei.com>
	<5440d76a18994a7a214321c30fe8a1e99c0a3988.camel@suse.com>
	<342183ae-ead1-a13f-9384-459d09c04e6c@huawei.com>
User-Agent: Evolution 3.38.2
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 114EuLa1004172
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>,
	"liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>, lihaotian9@huawei.com
Subject: Re: [dm-devel] [QUESTION]: multipath device with wrong path lead to
 metadata err
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVGh1LCAyMDIxLTAyLTA0IGF0IDE5OjI1ICswODAwLCBsaXhpYW9rZW5nIHdyb3RlOgo+IAo+
IEhpIE1hcnRpbiwKPiAKPiBPbiAyMDIxLzEvMjcgNzoxMSwgTWFydGluIFdpbGNrIHdyb3RlOgo+
ID4gU28gd2UgY2FuIG9ubHkgY29uY2x1ZGUgdGhhdCAoaWYgdGhlcmUncyBubyBrZXJuZWwgcmVm
Y291bnRpbmcgYnVnLAo+ID4gd2hpY2ggSSBkb3VidCkgZWl0aGVyIG9ycGhhbl9wYXRoKCktPnVu
aW5pdGlhbGl6ZV9wYXRoKCkgaGFkIGJlZW4KPiA+IGNhbGxlZCAoY2xvc2luZyB0aGUgZmQpLMKg
IG9yIHRoYXQgb3BlbmluZyB0aGUgc2QgZGV2aWNlIGhhZCBmYWlsZWQKPiA+IGluCj4gPiB0aGUg
Zmlyc3QgcGxhY2UgKGluIHdoaWNoIGNhc2UgdGhlIHBhdGggV1dJRCBzaG91bGQgaGF2ZSBiZWVu
Cj4gPiBudWxsZWQgaW4KPiA+IHBhdGhpbmZvKCkuIEluIGJvdGggY2FzZXMgaXQgbWFrZXMgbGl0
dGxlIHNlbnNlIHRoYXQgdGhlIHBhdGgKPiA+IHNob3VsZAo+ID4gc3RpbGwgYmUgcGFydCBvZiBh
IHN0cnVjdCBtdWx0aXBhdGguIAo+IAo+IEkgaGF2ZSBhbiBpZGVhLgo+IAo+IElmIHBwLT5mZCA8
IDAgKCJDb3VsZG4ndCBvcGVuIGRldmljZSBub2RlIiksIHBhdGhpbmZvKCkgcmV0dXJucwo+IFBB
VEhJTkZPX0ZBSUxFRC4gRG9uJ3QgY2xvc2UocHAtPmZkKSBpbiBvcnBoYW5fcGF0aCgpLiBJdCBt
YXkgc29sdmUKPiB0aGUKPiBwcm9ibGVtIChkZXZpY2Ugd2l0aCB3cm9uZyBwYXRoKS4gSSB3aWxs
IHRha2Ugc29tZSB0aW1lIHRvIHRlc3QgaXQuCgpEbyB5b3UgaGF2ZSBldmlkZW5jZSB0aGF0IHRo
ZSBmZCBoYWQgYmVlbiBjbG9zZWQgaW4geW91ciBlcnJvciBjYXNlPwpUaGUgcGF0aCBpbiBxdWVz
dGlvbiB3YXNuJ3Qgb3JwaGFuZWQsIGlmIEkgdW5kZXJzdG9vZCBjb3JyZWN0bHkuIFlvdQpzYWlk
IGl0IHdhcyBzdGlsbCBtZW1iZXIgb2YgYSBtYXAuIEluIHRoYXQgY2FzZSwgdGhlIGZkICptdXN0
KiBiZSBvcGVuLgoKPiBIb3dldmVyLCBJIGRvbuKAmXQga25vdyBpZiB0aGVyZSBhcmUgcG90ZW50
aWFsIHJpc2tzLiBEbyB5b3UgaGF2ZQo+IHN1Z2dlc3Rpb25zIGFib3V0IHRoaXM/CgpPdGhlciB0
aGFuIHJlc291cmNlIHVzYWdlIC4uLiB1c2VycyBtaWdodCBiZSBpcnJpdGF0ZWQgYmVjYXVzZSBp
ZiB3ZSBkbwp0aGlzIGFuZCBhIGRldmljZSBpcyByZW1vdmUgYW5kIHJlYXBwZWFycywgaXQgd2ls
bCAqYWx3YXlzKiBoYXZlIGEKZGlmZmVyZW50IGRldmljZSBub2RlIGF0dGFjaGVkLiBCdXQgdGhl
IGRldmljZSBub2RlcyBhcmUgcmFuZG9tIHRvZGF5LAphbnl3YXkuwqBJZiB3ZSBtaXNzZWQgYSBk
ZWxldGUgZXZlbnQsIHdlIG1pZ2h0IGtlZXAgdGhpcyBmZCBvcGVuCmZvcmV2ZXIsIGJlY2F1c2Ug
YSByZS1hZGRlZCBwYXRoIHdvdWxkIG5ldmVyIGdldCB0aGUgc2FtZSBzeXNmcyBwYXRoCmFnYWlu
OyBub3Qgc3VyZSBpZiB0aGF0IG1pZ2h0IGh1cnQgaW4gc29tZSBzY2VuYXJpb3MuIFdlIHNob3Vs
ZG4ndCBtaXNzCmRlbGV0ZSBldmVudHMgYW55d2F5LCBvZiBjb3Vyc2UuCgpTbyBubywgYXQgbGVh
c3Qgb2ZmIHRoZSB0byBvZiBteSBoZWFkLCBJIGNhbid0IHRoaW5rIG9mIGFueXRoaW5nCnNlcmlv
dXMuIEZhbW91cyBsYXN0IHdvcmRzIDstKQoKV2UgbXVzdCBtYWtlIHN1cmUgdG8gY2xvc2UgdGhl
IGZkIGluIHRoZSBmcmVlX3BhdGgoKSBjb2RlIHBhdGgsIG9mCmNvdXJzZS4KCkJ0dywgSSBqdXN0
IGRvdWJsZS1jaGVja2VkIHRoYXQgdGhlIGtlcm5lbCByZWFsbHkgYmVoYXZlcyBhcyBJIHRob3Vn
aHQuCllvdSBjYW4gcnVuIGUuZy4gaW4gcHl0aG9uOgoKPj4+IGltcG9ydCBvcwo+Pj4gZj1vcy5v
cGVuKCIvZGV2L3NkaCIsIG9zLk9fUkRXUnxvcy5PX0VYQ0wpCgpUaGlzIHdpbGwga2VlcCBhbiBm
ZCB0byB0aGUgZGV2aWNlIG9wZW4uIE5vdyBpZiB5b3UgZGVsZXRlIHRoZSBkZXZpY2UKYW5kIHJl
LWFkZCBpdCBieSBzY2FubmluZyB0aGUgc2NzaSBob3N0LCBpdCB3aWxsIGdldCBhIG5ldyBkZXZp
Y2UgSUQuCgplY2hvIDEgPi9zeXMvYmxvY2svc2RoL2RldmljZS9kZWxldGUgCmVjaG8gLSAtIC0g
Pi9zeXMvY2xhc3Mvc2NzaV9ob3N0L2hvc3QyL3NjYW4KCklmIHlvdSBjbG9zZSB0aGUgZmQgaW4g
cHl0aG9uIGFuZCByZXBlYXQgdGhlIGRlbGV0ZS9yZS1hZGQgKGFuZCBub3RoaW5nCmVsc2UgaGFw
cGVuZWQgaW4gdGhlIG1lYW50aW1lKSwgaXQgd2lsbCBiZWNvbWUgInNkaCIgYWdhaW4uCgpDaGVl
cnMsCk1hcnRpbgoKCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNv
bQpodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=

