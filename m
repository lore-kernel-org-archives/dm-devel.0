Return-Path: <SRS0=qgMK=F2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1491AC433DB
	for <dm-devel@archiver.kernel.org>; Tue, 22 Dec 2020 17:24:35 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6D02622D73
	for <dm-devel@archiver.kernel.org>; Tue, 22 Dec 2020 17:24:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6D02622D73
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-TdUTF2cXMFWGRTY4TtAX4w-1; Tue, 22 Dec 2020 12:24:29 -0500
X-MC-Unique: TdUTF2cXMFWGRTY4TtAX4w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DB21E107ACF9;
	Tue, 22 Dec 2020 17:24:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C423D5F708;
	Tue, 22 Dec 2020 17:24:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DE9BC4BB7B;
	Tue, 22 Dec 2020 17:24:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BMHOH5S007837 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 22 Dec 2020 12:24:18 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C2F10112D174; Tue, 22 Dec 2020 17:24:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BF2BF112D173
	for <dm-devel@redhat.com>; Tue, 22 Dec 2020 17:24:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5CACA800B3B
	for <dm-devel@redhat.com>; Tue, 22 Dec 2020 17:24:15 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-256-nU4hRR2QMNS34wi76koeSg-1;
	Tue, 22 Dec 2020 12:24:13 -0500
X-MC-Unique: nU4hRR2QMNS34wi76koeSg-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 84A8AB285;
	Tue, 22 Dec 2020 17:24:11 +0000 (UTC)
To: Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>,
	linux-block@vger.kernel.org, dm-devel@redhat.com
References: <20201222095056.7a5ac0a0@canb.auug.org.au>
	<20201222131528.GA29822@lst.de> <20201222145327.GC12885@redhat.com>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <288d1c58-c0e2-9d6f-4816-48c66536fe8b@suse.de>
Date: Tue, 22 Dec 2020 18:24:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201222145327.GC12885@redhat.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0BMHOH5S007837
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Stephen Rothwell <sfr@canb.auug.org.au>,
	Linux Next Mailing List <linux-next@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] DM's filesystem lookup in dm_get_dev_t() [was: Re:
 linux-next: manual merge of the device-mapper tree with Linus' tree]
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

T24gMTIvMjIvMjAgMzo1MyBQTSwgTWlrZSBTbml0emVyIHdyb3RlOgo+IFthZGRlZCBsaW51eC1i
bG9jayBhbmQgZG0tZGV2ZWwsIGlmIHNvbWVvbmUgcmVwbGllcyB0byB0aGlzIGVtYWlsIHRvCj4g
Y29udGludWUgInByb3BlciBkaXNjdXNzaW9uIiBfcGxlYXNlXyBhdCBsZWFzdCBkcm9wIHNmciBh
bmQgbGludXgtbmV4dAo+IGZyb20gQ2NdCj4gCj4gT24gVHVlLCBEZWMgMjIgMjAyMCBhdCAgODox
NWFtIC0wNTAwLAo+IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPiB3cm90ZToKPiAKPj4g
TWlrZSwgSGFubmVzLAo+Pgo+PiBJIHRoaW5rIHRoaXMgcGF0Y2ggaXMgcmF0aGVyIGhhcm1mdWwu
ICBXaHkgZG9lcyBkZXZpY2UgbWFwcGVyIGV2ZW4KPj4gbWl4IGZpbGUgc3lzdGVtIHBhdGggd2l0
aCBhIGRldl90IGFuZCBhbGwgdGhlIG90aGVyIHdlaXJkIGZvcm1zCj4+IHBhcnNlZCBieSBuYW1l
X3RvX2Rldl90LCB3aGljaCB3YXMgc3VwcG9zZWQgdG8gYmUgYmUgZm9yIHRoZSBlYXJseQo+PiBp
bml0IGNvZGUgd2hlcmUgbm8gZmlsZSBzeXN0ZW0gaXMgYXZhaWxhYmxlLgo+IAo+IE9LLCBJJ2xs
IG5lZWQgdG8gcmV2aXNpdCAodW5sZXNzIHNvbWVvbmUgYmVhdHMgbWUgdG8gaXQpIGJlY2F1c2Ug
dGhpcwo+IGNvdWxkJ3ZlIGVhc2lseSBiZWVuIGEgYmxpbmQtc3BvdCBmb3IgbWUgd2hlbiB0aGUg
ZG0taW5pdCBjb2RlIHdlbnQgaW4uCj4gQW55IGRtLWluaXQgc3BlY2lmaWMgZW5hYmxpbmcgaW50
ZXJmYWNlIHNob3VsZG4ndCBiZSB1c2VkIGJ5IG1vcmUKPiB0cmFkaXRpb25hbCBETSBpbnRlcmZh
Y2VzLiAgU28gSGFubmVzJyBjaGFuZ2UgbWlnaHQgYmUgdHJlYXRpbmcgc3ltcHRvbQo+IHJhdGhl
ciB0aGFuIHRoZSBjb3JlIHByb2JsZW0gKHdoaWNoIHdvdWxkIGJlIGJldHRlciB0cmVhdGVkIGJ5
IGZhY3RvcmluZwo+IG91dCBkbS1pbml0IHJlcXVpcmVtZW50cyBmb3IgYSBuYW1lX3RvX2Rldl90
KCktbGlrZSBpbnRlcmZhY2U/KS4KPiAKPiBETSBoYXMgc3VwcG9ydGVkIHBhc3NpbmcgbWFqOm1p
biBhbmQgYmxvY2tkZXYgbmFtZXMgb24gRE0gdGFibGUgbGluZXMKPiBmb3JldmVyLi4uIHNvIHdl
J2xsIG5lZWQgdG8gYmUgdmVyeSBzcGVjaWZpYyBhYm91dCB3aGVyZS93aHkgdGhpbmdzCj4gcmVn
cmVzc2VkLgo+IAoKT2suIFRoZSBwcm9ibGVtIGZyb20gbXkgcGVyc3BlY3RpdmUgaXMgdGhhdCBk
ZXZpY2UtbWFwcGVyIG5lZWRzIHRvCmEpIGVuc3VyZSB0aGF0IHRoZSBhcmJpdHJhcnkgc3RyaW5n
IHBhc3NlZCBpbiB3aXRoIHRoZSB0YWJsZSBkZWZpbml0aW9uIApyZWZlcnMgdG8gYSB2YWxpZCBi
bG9jayBkZXZpY2UKYW5kCmIpIHRoZSBibG9jayBkZXZpY2UgY2FuIGJlIG9wZW5lZCB3aXRoIE9f
RVhDTCwgc28gdGhhdCBkZXZpY2UtbWFwcGVyIGNhbiAKdGhlbiB1c2UgaXQuCgpPcmlnaW5hbGx5
IChpZSBwcmlvciB0byBjb21taXQgNjQ0YmRhNmYzNDYwKSBkbV9nZXRfZGV2aWNlKCkganVzdCAK
Y29udmVydGVkIHRoZSBzdHJpbmcgdG8gYSAnZGV2X3QnIHJlcHJlc2VudGF0aW9uLCBhbmQgdGhl
biB0aGUgYmxvY2sgCmRldmljZSBpdHNlbGYgd2FzIGNoZWNrZWQgYW5kIG9wZW5lZCBpbiBkbV9n
ZXRfdGFibGVfZGV2aWNlKCkuCidsb29rdXBfYmRldicgd2FzIGp1c3QgYmVpbmcgdXNlZCB0byBj
b252ZXJ0IHRoZSBwYXRoIGlmIHRoZSBzdHJpbmcgd2FzIApub3QgaW4gdGhlIGNhbm9uaWNhbCBt
YWpvcjptaW5vciBmb3JtYXQsIGFzIHRoZW4gaXQgd2FzIGFzc3VtZWQgdGhhdCBpdCAKcmVmZXJy
ZWQgdG8gYSBibG9jayBkZXZpY2Ugbm9kZSwgYW5kIHRoZW4gbG9va3VwX2JkZXYga2luZGEgbWFr
ZXMgc2Vuc2UuCgpIb3dldmVyLCBsb29rdXBfYmRldigpIG5vdyBhbHdheXMgcmVjdXJzZXMgaW50
byB0aGUgZmlsZXN5c3RlbSwgY2F1c2luZyAKbXVsdGlwYXRoIHRvIHN0YWxsIGluIGFuIGFsbC1w
YXRocy1kb3duIHNjZW5hcmlvLgoKU28sIHRoZSByZWFsIGlzc3VlIGlzIHRoZSB0YWJsZSBkZWZp
bml0b247IGFzIGl0IGFsc28gYWNjZXB0cyBhIGRldmljZSAKdG8gYmUgc3BlY2lmaWVkIGJ5IHRo
ZSBibG9jayBkZXZpY2UgX25vZGVfIG5hbWUsIHdlIG5lZWQgdG8gaGF2ZSBhIHdheSAKb2YgY29u
dmVydGluZyB0aGF0IGludG8gYSBkZXZfdC4KCklmIGxvb2t1cF9iZGV2KCkgaXMgdGhlIHdyb25n
IGludGVyZmFjZSBmb3IgdGhhdCwgYnkgYWxsIG1lYW5zLCBwbGVhc2UsIApkbyB0ZWxsIG1lLiBJ
J2QgYmUgaGFwcHkgdG8gZHJhZnQgdXAgYSBwYXRjaC4KCkFsdGVybmF0aXZlbHksIGlmIE1pa2Ug
c2F5cyB0aGF0IG9ubHkgbWFqb3I6bWlub3IgaXMgdGhlIHZhbGlkIGZvcm1hdCAKZm9yIGEgdGFi
bGUgZGVmaW5pdGlvbiB3ZSBjYW4ga2lsbCB0aGF0IGNvZGUgY29tcGxldGVseS4gQnV0IGNsZWFy
bHkgX0lfIApjYW5ub3QgbWFrZSB0aGUgY2FsbCBoZXJlLgoKQ2hlZXJzLAoKSGFubmVzCi0tIApE
ci4gSGFubmVzIFJlaW5lY2tlICAgICAgICAgICAgICAgIEtlcm5lbCBTdG9yYWdlIEFyY2hpdGVj
dApoYXJlQHN1c2UuZGUgICAgICAgICAgICAgICAgICAgICAgICAgICAgICArNDkgOTExIDc0MDUz
IDY4OApTVVNFIFNvZnR3YXJlIFNvbHV0aW9ucyBHbWJILCBNYXhmZWxkc3RyLiA1LCA5MDQwOSBO
w7xybmJlcmcKSFJCIDM2ODA5IChBRyBOw7xybmJlcmcpLCBHZXNjaMOkZnRzZsO8aHJlcjogRmVs
aXggSW1lbmTDtnJmZmVyCgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhh
dC5jb20KaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs

