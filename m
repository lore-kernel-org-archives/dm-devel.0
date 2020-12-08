Return-Path: <SRS0=ZVdP=FM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA6FDC433FE
	for <dm-devel@archiver.kernel.org>; Tue,  8 Dec 2020 06:45:01 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1752523A6C
	for <dm-devel@archiver.kernel.org>; Tue,  8 Dec 2020 06:45:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1752523A6C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-21-LyHqTvbBMCO3qhJxc1kakQ-1; Tue, 08 Dec 2020 01:44:54 -0500
X-MC-Unique: LyHqTvbBMCO3qhJxc1kakQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F443801B19;
	Tue,  8 Dec 2020 06:44:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 855325C1A1;
	Tue,  8 Dec 2020 06:44:47 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4276F4A7C6;
	Tue,  8 Dec 2020 06:44:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B86ifgE010204 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 8 Dec 2020 01:44:41 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id AD4B7110F728; Tue,  8 Dec 2020 06:44:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A8DE3110F72A
	for <dm-devel@redhat.com>; Tue,  8 Dec 2020 06:44:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2F8E6185A794
	for <dm-devel@redhat.com>; Tue,  8 Dec 2020 06:44:39 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-501-BA_a-6hNN4u58LYHe7Gxlw-1;
	Tue, 08 Dec 2020 01:44:32 -0500
X-MC-Unique: BA_a-6hNN4u58LYHe7Gxlw-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id D9B2FAB63;
	Tue,  8 Dec 2020 06:44:30 +0000 (UTC)
To: dgilbert@interlog.com, Christoph Hellwig <hch@lst.de>,
	SelvaKumar S <selvakuma.s1@samsung.com>
References: <CGME20201204094719epcas5p23b3c41223897de3840f92ae3c229cda5@epcas5p2.samsung.com>
	<20201204094659.12732-1-selvakuma.s1@samsung.com>
	<20201207141123.GC31159@lst.de>
	<01fe46ac-16a5-d4db-f23d-07a03d3935f3@suse.de>
	<194d7813-8c8c-85c8-e0c8-94aaab7c291e@interlog.com>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <9b2f5ab2-3358-fcce-678f-982ef79c9252@suse.de>
Date: Tue, 8 Dec 2020 07:44:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <194d7813-8c8c-85c8-e0c8-94aaab7c291e@interlog.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0B86ifgE010204
X-loop: dm-devel@redhat.com
Cc: axboe@kernel.dk, damien.lemoal@wdc.com, sagi@grimberg.me,
	snitzer@redhat.com, selvajove@gmail.com,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Mikulas Patocka <mpatocka@redhat.com>, joshi.k@samsung.com,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	kbusch@kernel.org, javier.gonz@samsung.com,
	linux-scsi@vger.kernel.org, nj.shetty@samsung.com,
	Bart Van Assche <bvanassche@acm.org>
Subject: Re: [dm-devel] [RFC PATCH v2 0/2] add simple copy support
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
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMTIvNy8yMCAxMToxMiBQTSwgRG91Z2xhcyBHaWxiZXJ0IHdyb3RlOgo+IE9uIDIwMjAtMTIt
MDcgOTo1NiBhLm0uLCBIYW5uZXMgUmVpbmVja2Ugd3JvdGU6Cj4+IE9uIDEyLzcvMjAgMzoxMSBQ
TSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4+PiBTbywgSSdtIHJlYWxseSB3b3JyaWVkIGFi
b3V0Ogo+Pj4KPj4+IMKgIGEpIGEgZ29vZCB1c2UgY2FzZS7CoCBHQyBpbiBmMmZzIG9yIGJ0cmZz
IHNlZW0gbGlrZSBnb29kIHVzZSBjYXNlcywgYXMKPj4+IMKgwqDCoMKgIGRvZXMgYWNjZWxhdGlu
ZyBkbS1rY29weWQuwqAgSSBhZ3JlZSB3aXRoIERhbWllbiB0aGF0IGxpZnRpbmcgCj4+PiBkbS1r
Y29weWQKPj4+IMKgwqDCoMKgIHRvIGNvbW1vbiBjb2RlIHdvdWxkIGFsc28gYmUgcmVhbGx5IG5p
Y2UuwqAgSSdtIG5vdCAxMDAlIHN1cmUgaXQgCj4+PiBzaG91bGQKPj4+IMKgwqDCoMKgIGJlIGEg
cmVxdWlyZW1lbnQsIGJ1dCBpdCBzdXJlIHdvdWxkIGJlIG5pY2UgdG8gaGF2ZQo+Pj4gwqDCoMKg
wqAgSSBkb24ndCB0aGluayBqdXN0IGFkZGluZyBhbiBpb2N0bCBpcyBlbm91Z2ggb2YgYSB1c2Ug
Y2FzZSBmb3IgCj4+PiBjb21wbGV4Cj4+PiDCoMKgwqDCoCBrZXJuZWwgaW5mcmFzdHJ1Y3R1cmUu
Cj4+PiDCoCBiKSBXZSBoYWQgYSBidW5jaCBvZiBkaWZmZXJlbnQgYXR0ZW1wdHMgYXQgU0NTSSBY
Q09QWSBzdXBwb3J0IGZvcm0gCj4+PiBJSVJDCj4+PiDCoMKgwqDCoCBNYXJ0aW4sIEJhcnQgYW5k
IE1pa3VsYXMuwqAgSSB0aGluayB3ZSBuZWVkIHRvIHB1bGwgdGhlbSBpbnRvIHRoaXMKPj4+IMKg
wqDCoMKgIGRpc2N1c3Npb24sIGFuZCBtYWtlIHN1cmUgd2hhdGV2ZXIgd2UgZG8gY292ZXJzIHRo
ZSBTQ1NJIG5lZWRzLgo+Pj4KPj4gQW5kIHdlIHNob3VsZG4ndCBmb3JnZXQgdGhhdCB0aGUgbWFp
biBpc3N1ZSB3aGljaCBraWxsZWQgYWxsIHByZXZpb3VzIAo+PiBpbXBsZW1lbnRhdGlvbnMgd2Fz
IGEgbWlzc2luZyBRb1MgZ3VhcmFudGVlLgo+PiBJdCdzIG5pY2UgdG8gaGF2ZSBzaW1wbHkgY29w
eSwgYnV0IGlmIHRoZSBpbXBsZW1lbnRhdGlvbiBpcyBfc2xvd2VyXyAKPj4gdGhhbiBkb2luZyBp
dCBieSBoYW5kIGZyb20gdGhlIE9TIHRoZXJlIGlzIHZlcnkgbGl0dGxlIHBvaW50IGluIGV2ZW4g
Cj4+IGF0dGVtcHRpbmcgdG8gZG8gc28uCj4+IEkgY2FuJ3Qgc2VlIGFueSBwcm92aXNpb25zIGZv
ciB0aGF0IGluIHRoZSBUUEFSLCBsZWFkaW5nIG1lIHRvIHRoZSAKPj4gYXNzdW1wdGlvbiB0aGF0
IE5WTWUgc2ltcGxlIGNvcHkgd2lsbCBzdWZmZXIgZnJvbSB0aGUgc2FtZSBpc3N1ZS4KPj4KPj4g
U28gaWYgd2UgY2FuJ3QgYWRkcmVzcyB0aGlzIEkgZ3Vlc3MgdGhpcyBhdHRlbXB0IHdpbGwgZmFp
bCwgdG9vLgo+IAo+IEkgaGF2ZSBiZWVuIGRvaW5nIHF1aXRlIGEgbG90IG9mIHdvcmsgYW5kIHRl
c3RpbmcgaW4gbXkgc2cgZHJpdmVyIHJld3JpdGUKPiBpbiB0aGUgY29weSBhbmQgY29tcGFyZSBh
cmVhLiBUaGUgYmFzZWxpbmVzIGZvciBwZXJmb3JtYW5jZSBhcmUgZGQgYW5kCj4gaW9fdXJpbmct
Y3AgKGluIGxpYnVyaW5nKS4gVGhlcmUgYXJlIGxvdHMgb2Ygd2F5cyB0byBpbXByb3ZlIG9uIHRo
ZW0uIEhlcmUKPiBhcmUgc29tZToKPiAgwqDCoCAtIHRoZSB1c2VyIGRhdGEgbmVlZCBuZXZlciBw
YXNzIHRocm91Z2ggdGhlIHVzZXIgc3BhY2UgKGNvdWxkCj4gIMKgwqDCoMKgIG1tYXAgaXQgb3V0
IGR1cmluZyB0aGUgUkVBRCBpZiB0aGVyZSBpcyBhIGdvb2QgcmVhc29uKS4gT25seSB0aGUKPiAg
wqDCoMKgwqAgbWV0YWRhdGEgKGUuZy4gTlZNZSBvciBTQ1NJIGNvbW1hbmRzKSBuZWVkcyB0byBj
b21lIGZyb20gdGhlIHVzZXIKPiAgwqDCoMKgwqAgc3BhY2UgYW5kIGVycm9ycywgaWYgYW55LCBy
ZXBvcnRlZCBiYWNrIHRvIHRoZSB1c2VyIHNwYWNlLgo+ICDCoMKgIC0gYnJlYWsgYSBsYXJnZSBj
b3B5IChvciBjb21wYXJlKSBpbnRvIHNlZ21lbnRzLCB3aXRoIGVhY2ggc2VnbWVudAo+ICDCoMKg
wqDCoCBhICJjb21mb3J0YWJsZSIgc2l6ZSBmb3IgdGhlIE9TIHRvIGhhbmRsZSwgc2F5IDI1NiBL
Qgo+ICDCoMKgIC0gdGhlcmUgaXMgb25lIGNvbnN0cmFpbnQ6IHRoZSBSRUFEIGluIGVhY2ggc2Vn
bWVudCBtdXN0IGNvbXBsZXRlCj4gIMKgwqDCoMKgIGJlZm9yZSBpdHMgcGFpcmVkIFdSSVRFIGNh
biBjb21tZW5jZQo+ICDCoMKgwqDCoCAtIGV4dHJhIGNvbnN0cmFpbnQgZm9yIHNvbWUgem9uZWQg
ZGlza3M6IFdSSVRFcyBtdXN0IGJlCj4gIMKgwqDCoMKgwqDCoCBpc3N1ZWQgaW4gb3JkZXIgKGFz
c3VtaW5nIHRoZXkgYXJlIGFwcGxpZWQgaW4gdGhhdCBvcmRlciwgaWYKPiAgwqDCoMKgwqDCoMKg
IG5vdCwgbmVlZCB0byB3YWl0IHVudGlsIGVhY2ggV1JJVEUgY29tcGxldGVzKQo+ICDCoMKgIC0g
YXJyYW5nZSBmb3IgUkVBRCBXUklURSBwYWlyIGluIGVhY2ggc2VnbWVudCB0byBzaGFyZSB0aGUg
c2FtZSBiaW8KPiAgwqDCoCAtIGhhdmUgbXVsdGlwbGUgc2xvdHMgZWFjaCBob2xkaW5nIGEgc2Vn
bWVudCAoaS5lLiBhIGJpbyBhbmQKPiAgwqDCoMKgwqAgbWV0YWRhdGEgdG8gcHJvY2VzcyBhIFJF
QUQtV1JJVEUgcGFpcikKPiAgwqDCoCAtIHJlLXVzZSBlYWNoIHNsb3QncyBiaW8gZm9yIHRoZSBm
b2xsb3dpbmcgUkVBRC1XUklURSBwYWlyCj4gIMKgwqAgLSBpc3N1ZSB0aGUgUkVBRHMgaW4gZWFj
aCBzbG90IGFzeW5jaHJvbm91c2x5IGFuZCBkbyBhbiBpbnRlcmxlYXZlZAo+ICDCoMKgwqDCoCAo
aW8pcG9sbCBmb3IgY29tcGxldGlvbi4gVGhlbiBpc3N1ZSB0aGUgcGFpcmVkIFdSSVRFCj4gIMKg
wqDCoMKgIGFzeW5jaHJvbm91c2x5Cj4gIMKgwqAgLSB0aGUgYWJvdmUgInNsb3QiIGFsZ29yaXRo
bSBydW5zIGluIG9uZSB0aHJlYWQsIHNvIHRoZXJlIGNhbiBiZQo+ICDCoMKgwqDCoCBtdWx0aXBs
ZSB0aHJlYWRzIGRvaW5nIHRoZSBzYW1lIGFsZ29yaXRobS4gU2VnbWVudCBtYW5hZ2VyIG5lZWRz
Cj4gIMKgwqDCoMKgIHRvIGJlIGxvY2tlZCAob3IgdXNlIGFuIGF0b21pY3MpIHNvIHRoYXQgZWFj
aCBzZWdtZW50IChpZGVudGlmaWVkCj4gIMKgwqDCoMKgIGJ5IGl0cyBzdGFydGluZyBMQkFzKSBp
cyBpc3N1ZWQgb25jZSBhbmQgb25seSBvbmNlIHdoZW4gdGhlCj4gIMKgwqDCoMKgIG5leHQgdGhy
ZWFkIHdhbnRzIGEgc2VnbWVudCB0byBjb3B5Cj4gCj4gUnVubmluZyBtdWx0aXBsZSB0aHJlYWRz
IGdpdmVzIGRpbWluaXNoaW5nIG9yIGV2ZW4gd29yc2VuaW5nIHJldHVybnMuCj4gUnVudGltZSBt
ZXRyaWNzIG9uIGxvY2sgY29udGVudGlvbiBhbmQgc3RvcmFnZSBidXMgY2FwYWNpdHkgbWF5IGhl
bHAKPiBjaG9vc2luZyB0aGUgbnVtYmVyIG9mIHRocmVhZHMuIEEgc2ltcGxlciBhcHByb2FjaCBt
aWdodCBiZSBhZGQgbW9yZQo+IHRocmVhZHMgdW50aWwgdGhlIGNvbWJpbmVkIHRocm91Z2hwdXQg
aW5jcmVhc2UgaXMgbGVzcyB0aGFuIDEwJSBzYXkuCj4gCj4gCj4gVGhlICdjb21wYXJlJyB0aGF0
IEkgbWVudGlvbiBpcyBiYXNlZCBvbiB0aGUgU0NTSSBWRVJJRlkoQllUQ0hLPTEpIGNvbW1hbmQK
PiAob3IgTlZNZSBOVk0gQ29tcGFyZSBjb21tYW5kKS4gVXNpbmcgZGQgbG9naWMsIGEgZGlzayB0
byBkaXNrIGNvbXBhcmUgY2FuCj4gYmUgaW1wbGVtZW50ZWQgd2l0aCBub3QgbXVjaCBtb3JlIHdv
cmsgdGhhbiBjaGFuZ2luZyB0aGUgV1JJVEUgdG8gYSBWRVJJRlkKPiBjb21tYW5kLiBUaGlzIGlz
IGEgZGlmZmVyZW50IGFwcHJvYWNoIHRvIHRoZSBMaW51eCBjbXAgdXRpbGl0eSB3aGljaAo+IFJF
QURzIGluIGJvdGggc2lkZXMgYW5kIGRvZXMgYSBtZW1jbXAoKSB0eXBlIG9wZXJhdGlvbi4gVXNp
bmcgcmFtZGlza3MKPiAoZnJvbSB0aGUgc2NzaV9kZWJ1ZyBkcml2ZXIpIHRoZSBjb21wYXJlIG9w
ZXJhdGlvbiAobWF4IH4gMTAgR0Ivcykgd2FzCj4gYWN0dWFsbHkgZmFzdGVyIHRoYW4gdGhlIGNv
cHkgKG1heCB+IDcgR0IvcykuIEkgcHV0IHRoaXMgZG93biB0byBXUklURQo+IG9wZXJhdGlvbnMg
dGFraW5nIGEgd3JpdGUgbG9jayBvdmVyIHRoZSBzdG9yZSB3aGlsZSB0aGUgVkVSSUZZIG9ubHkK
PiBuZWVkcyBhIHJlYWQgbG9jayBzbyBtYW55IFZFUklGWSBvcGVyYXRpb25zIGNhbiBjby1leGlz
dCBvbiB0aGUgc2FtZQo+IHN0b3JlLiBVbmZvcnR1bmF0ZWx5IG9uIHJlYWwgU0FTIGFuZCBOVk1l
IFNTRHMgdGhhdCBJIHRlc3RlZCB0aGUKPiBwZXJmb3JtYW5jZSBvZiB0aGUgVkVSSUZZIGFuZCBO
Vk0gQ29tcGFyZSBjb21tYW5kcyBpcyB1bmRlcndoZWxtaW5nLgo+IEZvciBjb21wYXJpc29uLCB1
c2luZyBzY3NpX2RlYnVnIHJhbWRpc2tzLCBkZCBjb3B5IHRocm91Z2hwdXQgd2FzCj4gPCAxIEdC
L3MgYW5kIGlvX3VyaW5nLWNwIHdhcyBhcm91bmQgMi0zIEdCL3MuIFRoZSBzeXN0ZW0gd2FzIFJ5
emVuCj4gMzYwMCBiYXNlZC4KPiAKV2hpY2ggaXMgcHJlY2lzZWx5IG15IGNvbmNlcm4uClNpbXBs
ZSBjb3B5IG1pZ2h0IGJlIGVmZmljaWVudCBmb3Igb25lIHBhcnRpY3VsYXIgaW1wbGVtZW50YXRp
b24sIGJ1dCBpdCAKbWlnaHQgYmUgY29tcGxldGVseSBvZmYgdGhlIGJvYXJkIGZvciBvdGhlcnMu
CkJ1dCBib3RoIHdpbGwgYmUgY2xhaW1pbmcgdG8gc3VwcG9ydCBpdCwgYW5kIHVzIGhhdmluZyBu
byBpZGVhIHdoZXRoZXIgCmNob29zaW5nIHNpbXBsZSBjb3B5IHdpbGwgc3BlZWQgdXAgbWF0dGVy
cyBvciBub3QuCldpdGhvdXQgaGF2aW5nIGEgcHJvZ3JhbW1hdGljIHdheSB0byBmaWd1cmUgb3V0
IHRoZSBzcGVlZCBvZiB0aGUgCmltcGxlbWVudGF0aW9uIHdlIGhhdmUgdG8gZGV0ZWN0IHRoZSBw
ZXJmb3JtYW5jZSBvdXJzZWx2ZXMsIGxpa2UgdGhlIApiZW5jaG1hcmtpbmcgbG9vcCBSQUlENSBk
b2VzLgpJIHdhcyBob3BpbmcgdG8gYXZvaWQgdGhhdCwgYW5kIGp1c3QgYXNrIHRoZSBkZXZpY2Uv
Y29udHJvbGxlcjsgYnV0IHRoYXQgCnR1cm5lZCBvdXQgdG8gYmUgaW4gdmFpbi4KCkNoZWVycywK
Ckhhbm5lcwotLSAKRHIuIEhhbm5lcyBSZWluZWNrZSAgICAgICAgICAgICAgICBLZXJuZWwgU3Rv
cmFnZSBBcmNoaXRlY3QKaGFyZUBzdXNlLmRlICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
KzQ5IDkxMSA3NDA1MyA2ODgKU1VTRSBTb2Z0d2FyZSBTb2x1dGlvbnMgR21iSCwgTWF4ZmVsZHN0
ci4gNSwgOTA0MDkgTsO8cm5iZXJnCkhSQiAzNjgwOSAoQUcgTsO8cm5iZXJnKSwgR2VzY2jDpGZ0
c2bDvGhyZXI6IEZlbGl4IEltZW5kw7ZyZmZlcgoKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApk
bS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5m
by9kbS1kZXZlbA==

