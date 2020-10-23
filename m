Return-Path: <SRS0=KxaR=D6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58335C388F9
	for <dm-devel@archiver.kernel.org>; Fri, 23 Oct 2020 10:31:34 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9BF9920EDD
	for <dm-devel@archiver.kernel.org>; Fri, 23 Oct 2020 10:31:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9BF9920EDD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-eCxLL7OaMq-aPLV5fOHrVw-1; Fri, 23 Oct 2020 06:31:30 -0400
X-MC-Unique: eCxLL7OaMq-aPLV5fOHrVw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B89E11868408;
	Fri, 23 Oct 2020 10:31:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8A28D5B4A2;
	Fri, 23 Oct 2020 10:31:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 08774180B657;
	Fri, 23 Oct 2020 10:31:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09NAVGhq013433 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 23 Oct 2020 06:31:17 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D177E110F0CD; Fri, 23 Oct 2020 10:31:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CC5DA110F0CB
	for <dm-devel@redhat.com>; Fri, 23 Oct 2020 10:31:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 15216858287
	for <dm-devel@redhat.com>; Fri, 23 Oct 2020 10:31:12 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-292-jmeZCHwkN8iU55tahrZm9g-1;
	Fri, 23 Oct 2020 06:31:09 -0400
X-MC-Unique: jmeZCHwkN8iU55tahrZm9g-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id A0192ABD1;
	Fri, 23 Oct 2020 10:31:07 +0000 (UTC)
To: "hch@infradead.org" <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>
References: <1603271049-20681-1-git-send-email-sergei.shtepa@veeam.com>
	<71926887-5707-04a5-78a2-ffa2ee32bd68@suse.de>
	<20201021141044.GF20749@veeam.com>
	<ca8eaa40-b422-2272-1fd9-1d0a354c42bf@suse.de>
	<20201022094402.GA21466@veeam.com>
	<BL0PR04MB6514AC1B1FF313E6A14D122CE71D0@BL0PR04MB6514.namprd04.prod.outlook.com>
	<20201022135213.GB21466@veeam.com> <20201022151418.GR9832@magnolia>
	<CAMM=eLfO_L-ZzcGmpPpHroznnSOq_KEWignFoM09h7Am9yE83g@mail.gmail.com>
	<20201023091346.GA25115@infradead.org>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <d50062cd-929d-c8ff-5851-4e1d517dc4cb@suse.de>
Date: Fri, 23 Oct 2020 12:31:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201023091346.GA25115@infradead.org>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 09NAVGhq013433
X-loop: dm-devel@redhat.com
Cc: "jack@suse.cz" <jack@suse.cz>,
	"gustavo@embeddedor.com" <gustavo@embeddedor.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	device-mapper development <dm-devel@redhat.com>,
	"pavel@ucw.cz" <pavel@ucw.cz>, "steve@sk2.org" <steve@sk2.org>,
	"osandov@fb.com" <osandov@fb.com>, Alasdair G Kergon <agk@redhat.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	"len.brown@intel.com" <len.brown@intel.com>,
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
	"ming.lei@redhat.com" <ming.lei@redhat.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	Sergei Shtepa <sergei.shtepa@veeam.com>,
	"koct9i@gmail.com" <koct9i@gmail.com>, "axboe@kernel.dk" <axboe@kernel.dk>,
	Damien Le Moal <Damien.LeMoal@wdc.com>,
	Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
	"rjw@rjwysocki.net" <rjw@rjwysocki.net>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"tj@kernel.org" <tj@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [dm-devel] [PATCH 0/2] block layer filter and block device
	snapshot module
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMTAvMjMvMjAgMTE6MTMgQU0sIGhjaEBpbmZyYWRlYWQub3JnIHdyb3RlOgo+IE9uIFRodSwg
T2N0IDIyLCAyMDIwIGF0IDAxOjU0OjE2UE0gLTA0MDAsIE1pa2UgU25pdHplciB3cm90ZToKPj4g
T24gVGh1LCBPY3QgMjIsIDIwMjAgYXQgMTE6MTQgQU0gRGFycmljayBKLiBXb25nCj4+PiBTdHVw
aWQgcXVlc3Rpb246IFdoeSBkb24ndCB5b3UgY2hhbmdlIHRoZSBibG9jayBsYXllciB0byBtYWtl
IGl0Cj4+PiBwb3NzaWJsZSB0byBpbnNlcnQgZGV2aWNlIG1hcHBlciBkZXZpY2VzIGFmdGVyIHRo
ZSBibG9ja2RldiBoYXMgYmVlbiBzZXQKPj4+IHVwPwo+Pgo+PiBOb3QgYSBzdHVwaWQgcXVlc3Rp
b24uICBEZWZpbml0ZWx5IHNvbWV0aGluZyB0aGF0IHVzIERNIGRldmVsb3BlcnMKPj4gaGF2ZSB3
YW50ZWQgdG8gZG8gZm9yIGEgd2hpbGUuICBEZXZpbCBpcyBpbiB0aGUgZGV0YWlscyBidXQgaXQg
aXMgdGhlCj4+IHJpZ2h0IHdheSBmb3J3YXJkLgo+Pgo+IAo+IFllcywgSSB0aGluayB0aGF0IGlz
IHRoZSByaWdodCB0aGluZyB0byBkby4gIEFuZCBJIGRvbid0IHRoaW5rIGl0IHNob3VsZAo+IGJl
IGFsbCB0aGF0IGhhcmQuICBBbGwgd2UnZCBuZWVkIGluIHRoZSBJL08gcGF0aCBpcyBzb21ldGhp
bmcgbGlrZSB0aGUKPiBwc2V1ZG8tcGF0Y2ggYmVsb3csIHdoaWNoIHdpbGwgYWxsb3cgdGhlIGlu
dGVycG9zZXIgZHJpdmVyIHRvIHJlc3VibWl0Cj4gYmlvcyB1c2luZyBzdWJtaXRfYmlvX25vYWNj
dCBhcyBsb25nIGFzIHRoZSBkcml2ZXIgc2V0cyBCSU9fSU5URVJQT1NFRC4KPiAKPiBkaWZmIC0t
Z2l0IGEvYmxvY2svYmxrLWNvcmUuYyBiL2Jsb2NrL2Jsay1jb3JlLmMKPiBpbmRleCBhYzAwZDJm
YTRlYjQ4ZC4uM2Y2ZjFlYjU2NWUwYTggMTAwNjQ0Cj4gLS0tIGEvYmxvY2svYmxrLWNvcmUuYwo+
ICsrKyBiL2Jsb2NrL2Jsay1jb3JlLmMKPiBAQCAtMTA1MSw2ICsxMDUxLDkgQEAgYmxrX3FjX3Qg
c3VibWl0X2Jpb19ub2FjY3Qoc3RydWN0IGJpbyAqYmlvKQo+ICAgCQlyZXR1cm4gQkxLX1FDX1Rf
Tk9ORTsKPiAgIAl9Cj4gICAKPiArCWlmIChibGtfaGFzX2ludGVycG9zZXIoYmlvLT5iaV9kaXNr
KSAmJgo+ICsJICAgICEoYmlvLT5iaV9mbGFncyAmIEJJT19JTlRFUlBPU0VEKSkKPiArCQlyZXR1
cm4gX19zdWJtaXRfYmlvX2ludGVycG9zZWQoYmlvKTsKPiAgIAlpZiAoIWJpby0+YmlfZGlzay0+
Zm9wcy0+c3VibWl0X2JpbykKPiAgIAkJcmV0dXJuIF9fc3VibWl0X2Jpb19ub2FjY3RfbXEoYmlv
KTsKPiAgIAlyZXR1cm4gX19zdWJtaXRfYmlvX25vYWNjdChiaW8pOwo+IApNeSB0aG91Z2h0cyB3
ZW50IG1vcmUgaW50byB0aGUgZGlyZWN0aW9uIG9mIGhvb2tpbmcgaW50byAtPnN1Ym1pdF9iaW8s
IApzZWVpbmcgdGhhdCBpdCdzIGEgTlVMTCBwb2ludGVyIGZvciBtb3N0IChhbGw/KSBibG9jayBk
cml2ZXJzLgoKQnV0IHN1cmUsIEknbGwgY2hlY2sgaG93IHRoZSBpbnRlcnBvc2VyIGFwcHJvYWNo
IHdvdWxkIHR1cm4gb3V0LgoKQ2hlZXJzLAoKSGFubmVzCi0tIApEci4gSGFubmVzIFJlaW5lY2tl
ICAgICAgICAgICAgICAgIEtlcm5lbCBTdG9yYWdlIEFyY2hpdGVjdApoYXJlQHN1c2UuZGUgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICArNDkgOTExIDc0MDUzIDY4OApTVVNFIFNvZnR3YXJl
IFNvbHV0aW9ucyBHbWJILCBNYXhmZWxkc3RyLiA1LCA5MDQwOSBOw7xybmJlcmcKSFJCIDM2ODA5
IChBRyBOw7xybmJlcmcpLCBHZXNjaMOkZnRzZsO8aHJlcjogRmVsaXggSW1lbmTDtnJmZmVyCgoK
LS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly93d3cu
cmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs

