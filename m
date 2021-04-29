Return-Path: <SRS0=KYOW=J2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 714E8C433ED
	for <dm-devel@archiver.kernel.org>; Thu, 29 Apr 2021 23:33:29 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BE5C961460
	for <dm-devel@archiver.kernel.org>; Thu, 29 Apr 2021 23:33:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BE5C961460
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=erwinvanlonden.net
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-CGFhxbIuMe-YFuUm1l3rbg-1; Thu, 29 Apr 2021 19:33:25 -0400
X-MC-Unique: CGFhxbIuMe-YFuUm1l3rbg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C2D76501E7;
	Thu, 29 Apr 2021 23:33:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5AD565D9C6;
	Thu, 29 Apr 2021 23:33:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CEBB244A68;
	Thu, 29 Apr 2021 23:33:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13TNWi5v024444 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 29 Apr 2021 19:32:44 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id A7F1F1054FAB; Thu, 29 Apr 2021 23:32:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A36D01054FB5
	for <dm-devel@redhat.com>; Thu, 29 Apr 2021 23:32:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0467F858F0D
	for <dm-devel@redhat.com>; Thu, 29 Apr 2021 23:32:39 +0000 (UTC)
Received: from gateway20.websitewelcome.com (gateway20.websitewelcome.com
	[192.185.47.18]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-211-TyVv5wmEPr2iea9lrNWecw-1; Thu, 29 Apr 2021 19:32:36 -0400
X-MC-Unique: TyVv5wmEPr2iea9lrNWecw-1
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
	by gateway20.websitewelcome.com (Postfix) with ESMTP id 561E0400FBEB1
	for <dm-devel@redhat.com>; Thu, 29 Apr 2021 18:21:06 -0500 (CDT)
Received: from just2098.justhost.com ([173.254.31.45]) by cmsmtp with SMTP
	id cG94lZhBIL7DmcG94lZUA0; Thu, 29 Apr 2021 18:32:34 -0500
X-Authority-Reason: nr=8
Received: from 116-240-66-4.sta.dodo.net.au ([116.240.66.4]:32928
	helo=[192.168.1.104])
	by just2098.justhost.com with esmtpsa (TLS1.2) tls
	TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
	(envelope-from <erwin@erwinvanlonden.net>)
	id 1lcG93-000Art-Fh; Thu, 29 Apr 2021 17:32:34 -0600
Message-ID: <d26cbf916bbff974cda28536b128129ea3a0f13b.camel@erwinvanlonden.net>
From: Erwin van Londen <erwin@erwinvanlonden.net>
To: Martin Wilck <martin.wilck@suse.com>, "hare@suse.de" <hare@suse.de>,
	"Ulrich.Windl@rz.uni-regensburg.de" <Ulrich.Windl@rz.uni-regensburg.de>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
In-Reply-To: <643e5f7eb3e2d48517a3288c07af001b30e22075.camel@suse.com>
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
	<ff5b30ca02ecfad00097ad5f8b84d053514fb61c.camel@erwinvanlonden.net>
	<643e5f7eb3e2d48517a3288c07af001b30e22075.camel@suse.com>
Date: Fri, 30 Apr 2021 00:47:57 +1000
MIME-Version: 1.0
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33)
X-AntiAbuse: This header was added to track abuse,
	please include it with any abuse report
X-AntiAbuse: Primary Hostname - just2098.justhost.com
X-AntiAbuse: Original Domain - redhat.com
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - erwinvanlonden.net
X-BWhitelist: no
X-Source-IP: 116.240.66.4
X-Source-L: No
X-Exim-ID: 1lcG93-000Art-Fh
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 116-240-66-4.sta.dodo.net.au ([192.168.1.104])
	[116.240.66.4]:32928
X-Source-Auth: erwin@erwinvanlonden.net
X-Email-Count: 4
X-Source-Cap: aGl0YWNoaTE7aGl0YWNoaTE7anVzdDIwOTguanVzdGhvc3QuY29t
X-Local-Domain: yes
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 13TNWi5v024444
X-loop: dm-devel@redhat.com
Cc: Hannes Reinecke <hare@suse.com>, "systemd-devel@lists.freedesktop.org"
	<systemd-devel@lists.freedesktop.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"dgilbert@interlog.com" <dgilbert@interlog.com>,
	"jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>,
	"hch@lst.de" <hch@lst.de>
Subject: Re: [dm-devel] RFC: one more time: SCSI device identification
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

CgpPbiBXZWQsIDIwMjEtMDQtMjggYXQgMDY6MzQgKzAwMDAsIE1hcnRpbiBXaWxjayB3cm90ZToK
PiBPbiBXZWQsIDIwMjEtMDQtMjggYXQgMTE6MDEgKzEwMDAsIEVyd2luIHZhbiBMb25kZW4gd3Jv
dGU6Cj4gPiAKPiA+IFRoZSB3YXkgb3V0IG9mIHRoaXMgaXMgdG8gY2h1Y2sgdGhlIGFycmF5IGlu
IHRoZSBiaW4uIEFzIEkgbWVudGlvbmVkCj4gPiBpbiBvbmUgb2YgbXkgb3RoZXIgZW1haWxzIHdo
ZW4gYSBzY2VuYXJpbyBoYXBwZW5zIGFzIHlvdSBkZXNjcmliZWQKPiA+IGFib3ZlIGFuZCB0aGUg
YXJyYXkgZG9lcyBub3QgaW5mb3JtIHRoZSBpbml0aWF0b3IgaXQgZ29lcyBhZ2FpbnN0IHRoZQo+
ID4gU0FNLTUgc3RhbmRhcmQuCj4gPiAKPiA+IFRoYXQgc3RhbmRhcmQgc2hvd3M6Cj4gPiA1LjE0
IFVuaXQgYXR0ZW50aW9uIGNvbmRpdGlvbnMKPiA+IDUuMTQuMSBVbml0IGF0dGVudGlvbiBjb25k
aXRpb25zIHRoYXQgYXJlIG5vdCBjb2FsZXNjZWQKPiA+IEVhY2ggbG9naWNhbCB1bml0IHNoYWxs
IGVzdGFibGlzaCBhIHVuaXQgYXR0ZW50aW9uIGNvbmRpdGlvbiB3aGVuZXZlcgo+ID4gb25lIG9m
IHRoZSBmb2xsb3dpbmcgZXZlbnRzIG9jY3VyczoKPiA+IMKgwqDCoMKgwqDCoMKgwqBhKSBhIHBv
d2VyIG9uIChzZWUgNi4zLjEpLCBoYXJkIHJlc2V0IChzZWUgNi4zLjIpLCBsb2dpY2FsCj4gPiB1
bml0IHJlc2V0IChzZWUgNi4zLjMpLCBJX1QgbmV4dXMgbG9zcyAoc2VlIDYuMy40KSwgb3IgcG93
ZXIgbG9zcwo+ID4gZXhwZWN0ZWQgKHNlZSA2LjMuNSkgb2NjdXJzOwo+ID4gwqDCoMKgwqDCoMKg
wqDCoGIpIGNvbW1hbmRzIHJlY2VpdmVkIG9uIHRoaXMgSV9UIG5leHVzIGhhdmUgYmVlbiBjbGVh
cmVkIGJ5Cj4gPiBhIGNvbW1hbmQgb3IgYSB0YXNrIG1hbmFnZW1lbnQgZnVuY3Rpb24gYXNzb2Np
YXRlZCB3aXRoIGFub3RoZXIgSV9UCj4gPiBuZXh1cyBhbmQgdGhlIFRBUyBiaXQgd2FzIHNldCB0
byB6ZXJvIGluIHRoZSBDb250cm9sIG1vZGUgcGFnZQo+ID4gYXNzb2NpYXRlZCB3aXRoIHRoaXMg
SV9UIG5leHVzIChzZWUgNS42KTsKPiA+IMKgwqDCoMKgwqDCoMKgwqBjKSB0aGUgcG9ydGlvbiBv
ZiB0aGUgbG9naWNhbCB1bml0IGludmVudG9yeSB0aGF0IGNvbnNpc3RzCj4gPiBvZiBhZG1pbmlz
dHJhdGl2ZSBsb2dpY2FsIHVuaXRzIGFuZCBoaWVyYXJjaGljYWwgbG9naWNhbCB1bml0cyBoYXMK
PiA+IGJlZW4gY2hhbmdlZCAoc2VlIDQuNi4xOC4xKTsgb3IKPiA+IMKgwqDCoMKgwqDCoMKgwqBk
KSBhbnkgb3RoZXIgZXZlbnQgcmVxdWlyaW5nIHRoZSBhdHRlbnRpb24gb2YgdGhlIFNDU0kKPiA+
IGluaXRpYXRvciBkZXZpY2UuCj4gPiAKPiA+IEVzcGVjaWFsbHkgdGhlIElfVCBuZXh1cyBsb3Nz
IHVuZGVyIGEgaXMgYW4gaW1wb3J0YW50IHRyaWdnZXIuCj4gPiAKPiA+IC0tLQo+ID4gNi4zLjQg
SV9UIG5leHVzIGxvc3MKPiA+IEFuIElfVCBuZXh1cyBsb3NzIGlzIGEgU0NTSSBkZXZpY2UgY29u
ZGl0aW9uIHJlc3VsdGluZyBmcm9tOgo+ID4gCj4gPiDCoGEpIGEgaGFyZCByZXNldCBjb25kaXRp
b24gKHNlZSA2LjMuMik7Cj4gPiDCoGIpIGFuIElfVCBuZXh1cyBsb3NzIGV2ZW50IChlLmcuLCBs
b2dvdXQpIGluZGljYXRlZCBieSBhIE5leHVzIExvc3MKPiA+IGV2ZW50IG5vdGlmaWNhdGlvbiAo
c2VlIDYuNCk7Cj4gPiDCoGMpIGluZGljYXRpb24gdGhhdCBhbiBJX1QgTkVYVVMgUkVTRVQgdGFz
ayBtYW5hZ2VtZW50IHJlcXVlc3QgKHNlZQo+ID4gNy42KSBoYXMgYmVlbiBwcm9jZXNzZWQ7IG9y
Cj4gPiDCoGQpIGFuIGluZGljYXRpb24gdGhhdCBhIFJFTU9WRSBJX1QgTkVYVVMgY29tbWFuZCAo
c2VlIFNQQy00KSBoYXMKPiA+IGJlZW4gcHJvY2Vzc2VkLgo+ID4gQW4gSV9UIG5leHVzIGxvc3Mg
ZXZlbnQgaXMgYW4gaW5kaWNhdGlvbiBmcm9tIHRoZSBTQ1NJIHRyYW5zcG9ydAo+ID4gcHJvdG9j
b2wgdG8gdGhlIFNBTCB0aGF0IGFuIElfVCBuZXh1cyBubwo+ID4gbG9uZ2VyIGV4aXN0cy4gU0NT
SSB0cmFuc3BvcnQgcHJvdG9jb2xzIG1heSBkZWZpbmUgSV9UIG5leHVzIGxvc3MKPiA+IGV2ZW50
cy4KPiA+IAo+ID4gRWFjaCBTQ1NJIHRyYW5zcG9ydCBwcm90b2NvbCBzdGFuZGFyZCB0aGF0IGRl
ZmluZXMgSV9UIG5leHVzIGxvc3MKPiA+IGV2ZW50cyBzaG91bGQgc3BlY2lmeSB3aGVuIHRob3Nl
IGV2ZW50cwo+ID4gcmVzdWx0IGluIHRoZSBkZWxpdmVyeSBvZiBhIE5leHVzIExvc3MgZXZlbnQg
bm90aWZpY2F0aW9uIHRvIHRoZSBTQUwuCj4gPiAKPiA+IFRoZSBJX1QgbmV4dXMgbG9zcyBjb25k
aXRpb24gYXBwbGllcyB0byBib3RoIFNDU0kgaW5pdGlhdG9yIGRldmljZXMKPiA+IGFuZCBTQ1NJ
IHRhcmdldCBkZXZpY2VzLgo+ID4gCj4gPiBJZiBhIFNDU0kgdGFyZ2V0IHBvcnQgZGV0ZWN0cyBh
biBJX1QgbmV4dXMgbG9zcywgdGhlbiBhIE5leHVzIExvc3MKPiA+IGV2ZW50IG5vdGlmaWNhdGlv
biBzaGFsbCBiZSBkZWxpdmVyZWQgdG8KPiA+IGVhY2ggbG9naWNhbCB1bml0IHRvIHdoaWNoIHRo
ZSBJX1QgbmV4dXMgaGFzIGFjY2Vzcy4KPiA+IAo+ID4gSW4gcmVzcG9uc2UgdG8gYW4gSV9UIG5l
eHVzIGxvc3MgY29uZGl0aW9uIGEgbG9naWNhbCB1bml0IHNoYWxsIHRha2UKPiA+IHRoZSBmb2xs
b3dpbmcgYWN0aW9uczoKPiA+IGEpIGFib3J0IGFsbCBjb21tYW5kcyByZWNlaXZlZCBvbiB0aGUg
SV9UIG5leHVzIGFzIGRlc2NyaWJlZCBpbiA1LjY7Cj4gPiBiKSBhYm9ydCBhbGwgYmFja2dyb3Vu
ZCB0aGlyZC1wYXJ0eSBjb3B5IG9wZXJhdGlvbnMgKHNlZSBTUEMtNCkgdGhhdAo+ID4gYXJlIHVz
aW5nIHRoZSBJX1QgbmV4dXM7Cj4gPiBjKSB0ZXJtaW5hdGUgYWxsIHRhc2sgbWFuYWdlbWVudCBm
dW5jdGlvbnMgcmVjZWl2ZWQgb24gdGhlIElfVCBuZXh1czsKPiA+IGQpIGNsZWFyIGFsbCBBQ0Eg
Y29uZGl0aW9ucyAoc2VlIDUuOS41KSBhc3NvY2lhdGVkIHdpdGggdGhlIElfVAo+ID4gbmV4dXM7
Cj4gPiBlKSBlc3RhYmxpc2ggYSB1bml0IGF0dGVudGlvbiBjb25kaXRpb24gZm9yIHRoZSBTQ1NJ
IGluaXRpYXRvciBwb3J0Cj4gPiBhc3NvY2lhdGVkIHdpdGggdGhlIElfVCBuZXh1cyAoc2VlIDUu
MTQKPiA+IGFuZCA2LjIpOyBhbmQKPiA+IGYpIHBlcmZvcm0gYW55IGFkZGl0aW9uYWwgZnVuY3Rp
b25zIHJlcXVpcmVkIGJ5IHRoZSBhcHBsaWNhYmxlCj4gPiBjb21tYW5kIHN0YW5kYXJkcy4KPiA+
IC0tLQo+ID4gCj4gPiBUaGlzIGRvZXMgYWxzbyBtZWFuIHRoYXQgYW55IHVuZGVybHlpbmcgdHJh
bnNwb3J0IHByb3RvY29sIGlzc3Vlcwo+ID4gbGlrZSBvbiBGQyBvciBUQ1AgZm9yIGlTQ1NJIHdp
bGwgdmVyeSBvZnRlbiB0cmlnZ2VyIGFib3J0ZWQgY29tbWFuZHMKPiA+IG9yIFVBJ3MgYXMgd2Vs
bCB3aGljaCB3aWxsIGJlIHBpY2tlZCB1cCBieSB0aGUga2VybmVsL3Jlc3BlY3RlZAo+ID4gZHJp
dmVycy4KPiAKPiBUaGFua3MgYSBsb3QuIEknbSBub3QgcXVpdGUgY2VydGFpbiB3aGljaCBvZiB0
aGVzZSBwYXJhZ3JhcGhzIHdvdWxkCj4gYXBwbHkgdG8gdGhlIHNpdHVhdGlvbiBJIGhhZCBpbiBt
aW5kIChhZG1pbmlzdHJhdG9yIHJlbWFwcGluZyBhbgo+IGV4aXN0aW5nIExVTiBvbiBhIHN0b3Jh
Z2UgYXJyYXkgdG8gYSBkaWZmZXJlbnQgdm9sdW1lKS4gVGhhdCBzY2VuYXJpbwo+IHdvdWxkbid0
IG5lY2Vzc2FyaWx5IGludm9sdmUgdHJhbnNwb3J0LWxldmVsIGVycm9ycywgb3IgYW4gSV9UIG5l
eHVzCj4gbG9zcy4gNS4xNC4xIGMpIG9yIGQpIG1pZ2h0IGFwcGx5LCBpcyB0aGF0IHdoYXQgeW91
IG1lYW50PwoKSSB3YXMgaW5kZWVkIG1vc3RseSByZWZlcnJpbmcgdG86CgogCWMpIHRoZSBwb3J0
aW9uIG9mIHRoZSBsb2dpY2FsIHVuaXQgaW52ZW50b3J5IHRoYXQgY29uc2lzdHMKIG9mIGFkbWlu
aXN0cmF0aXZlIGxvZ2ljYWwgdW5pdHMgYW5kIGhpZXJhcmNoaWNhbCBsb2dpY2FsIHVuaXRzIGhh
cwogYmVlbiBjaGFuZ2VkIChzZWUgNC42LjE4LjEpOyBvcgogCWQpIGFueSBvdGhlciBldmVudCBy
ZXF1aXJpbmcgdGhlIGF0dGVudGlvbiBvZiB0aGUgU0NTSQogaW5pdGlhdG9yIGRldmljZS4KClRo
ZSBJVCBuZXh1cyBzdGF0dXMgaXRzZWxmIG1pZ2h0IG5vdCBoYXZlIGNoYW5nZWQgYnV0IGlmIGFu
IGFic3RyYWN0aW9uCmxheWVyIHJlcHJlc2VudGluZyBhIHRvdGFsbHkgZGlmZmVyZW50IHNldCBv
ZiBkYXRhIHRoYXQgd291bGQgbW9zdApkZWZpbml0ZWx5IGZhbGwgdW5kZXIgZC4gSSB0aGluayBz
d2FwcGluZyBiZXR3ZWVuIGEgdm9sdW1lIGFuZCBvbmUgb2YKaXRzIHNuYXBzaG90cyBhbHNvIGZh
bGxzIHVuZGVyIHRoaXMgCgoKPiAKPiBSZWdhcmRzCj4gTWFydGluCj4gCgoKLS0KZG0tZGV2ZWwg
bWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5j
b20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==

