Return-Path: <SRS0=+j0W=FL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CFABC4361B
	for <dm-devel@archiver.kernel.org>; Mon,  7 Dec 2020 14:56:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E8CED23601
	for <dm-devel@archiver.kernel.org>; Mon,  7 Dec 2020 14:56:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E8CED23601
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-419-3NHAEJeqN0izVlmrGwWEWQ-1; Mon, 07 Dec 2020 09:56:34 -0500
X-MC-Unique: 3NHAEJeqN0izVlmrGwWEWQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 157EA809DC9;
	Mon,  7 Dec 2020 14:56:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 85DF95DA30;
	Mon,  7 Dec 2020 14:56:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A204E180954D;
	Mon,  7 Dec 2020 14:56:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B7EuNRT019759 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 7 Dec 2020 09:56:23 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8B5C21111436; Mon,  7 Dec 2020 14:56:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 86D651111435
	for <dm-devel@redhat.com>; Mon,  7 Dec 2020 14:56:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3B535802A5D
	for <dm-devel@redhat.com>; Mon,  7 Dec 2020 14:56:21 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-312-8jGXt3JOMkClI2LTDc5hrg-1;
	Mon, 07 Dec 2020 09:56:19 -0500
X-MC-Unique: 8jGXt3JOMkClI2LTDc5hrg-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 7663EAB63;
	Mon,  7 Dec 2020 14:56:17 +0000 (UTC)
To: Christoph Hellwig <hch@lst.de>, SelvaKumar S <selvakuma.s1@samsung.com>
References: <CGME20201204094719epcas5p23b3c41223897de3840f92ae3c229cda5@epcas5p2.samsung.com>
	<20201204094659.12732-1-selvakuma.s1@samsung.com>
	<20201207141123.GC31159@lst.de>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <01fe46ac-16a5-d4db-f23d-07a03d3935f3@suse.de>
Date: Mon, 7 Dec 2020 15:56:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201207141123.GC31159@lst.de>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0B7EuNRT019759
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMTIvNy8yMCAzOjExIFBNLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToKPiBTbywgSSdtIHJl
YWxseSB3b3JyaWVkIGFib3V0Ogo+IAo+ICAgYSkgYSBnb29kIHVzZSBjYXNlLiAgR0MgaW4gZjJm
cyBvciBidHJmcyBzZWVtIGxpa2UgZ29vZCB1c2UgY2FzZXMsIGFzCj4gICAgICBkb2VzIGFjY2Vs
YXRpbmcgZG0ta2NvcHlkLiAgSSBhZ3JlZSB3aXRoIERhbWllbiB0aGF0IGxpZnRpbmcgZG0ta2Nv
cHlkCj4gICAgICB0byBjb21tb24gY29kZSB3b3VsZCBhbHNvIGJlIHJlYWxseSBuaWNlLiAgSSdt
IG5vdCAxMDAlIHN1cmUgaXQgc2hvdWxkCj4gICAgICBiZSBhIHJlcXVpcmVtZW50LCBidXQgaXQg
c3VyZSB3b3VsZCBiZSBuaWNlIHRvIGhhdmUKPiAgICAgIEkgZG9uJ3QgdGhpbmsganVzdCBhZGRp
bmcgYW4gaW9jdGwgaXMgZW5vdWdoIG9mIGEgdXNlIGNhc2UgZm9yIGNvbXBsZXgKPiAgICAgIGtl
cm5lbCBpbmZyYXN0cnVjdHVyZS4KPiAgIGIpIFdlIGhhZCBhIGJ1bmNoIG9mIGRpZmZlcmVudCBh
dHRlbXB0cyBhdCBTQ1NJIFhDT1BZIHN1cHBvcnQgZm9ybSBJSVJDCj4gICAgICBNYXJ0aW4sIEJh
cnQgYW5kIE1pa3VsYXMuICBJIHRoaW5rIHdlIG5lZWQgdG8gcHVsbCB0aGVtIGludG8gdGhpcwo+
ICAgICAgZGlzY3Vzc2lvbiwgYW5kIG1ha2Ugc3VyZSB3aGF0ZXZlciB3ZSBkbyBjb3ZlcnMgdGhl
IFNDU0kgbmVlZHMuCj4gCkFuZCB3ZSBzaG91bGRuJ3QgZm9yZ2V0IHRoYXQgdGhlIG1haW4gaXNz
dWUgd2hpY2gga2lsbGVkIGFsbCBwcmV2aW91cyAKaW1wbGVtZW50YXRpb25zIHdhcyBhIG1pc3Np
bmcgUW9TIGd1YXJhbnRlZS4KSXQncyBuaWNlIHRvIGhhdmUgc2ltcGx5IGNvcHksIGJ1dCBpZiB0
aGUgaW1wbGVtZW50YXRpb24gaXMgX3Nsb3dlcl8gCnRoYW4gZG9pbmcgaXQgYnkgaGFuZCBmcm9t
IHRoZSBPUyB0aGVyZSBpcyB2ZXJ5IGxpdHRsZSBwb2ludCBpbiBldmVuIAphdHRlbXB0aW5nIHRv
IGRvIHNvLgpJIGNhbid0IHNlZSBhbnkgcHJvdmlzaW9ucyBmb3IgdGhhdCBpbiB0aGUgVFBBUiwg
bGVhZGluZyBtZSB0byB0aGUgCmFzc3VtcHRpb24gdGhhdCBOVk1lIHNpbXBsZSBjb3B5IHdpbGwg
c3VmZmVyIGZyb20gdGhlIHNhbWUgaXNzdWUuCgpTbyBpZiB3ZSBjYW4ndCBhZGRyZXNzIHRoaXMg
SSBndWVzcyB0aGlzIGF0dGVtcHQgd2lsbCBmYWlsLCB0b28uCgpDaGVlcnMsCgpIYW5uZXMKLS0g
CkRyLiBIYW5uZXMgUmVpbmVja2UgICAgICAgICAgICAgICAgS2VybmVsIFN0b3JhZ2UgQXJjaGl0
ZWN0CmhhcmVAc3VzZS5kZSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICs0OSA5MTEgNzQw
NTMgNjg4ClNVU0UgU29mdHdhcmUgU29sdXRpb25zIEdtYkgsIE1heGZlbGRzdHIuIDUsIDkwNDA5
IE7DvHJuYmVyZwpIUkIgMzY4MDkgKEFHIE7DvHJuYmVyZyksIEdlc2Now6RmdHNmw7xocmVyOiBG
ZWxpeCBJbWVuZMO2cmZmZXIKCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVk
aGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=

