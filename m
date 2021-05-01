Return-Path: <SRS0=QF+r=J4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3FF6C433ED
	for <dm-devel@archiver.kernel.org>; Sat,  1 May 2021 11:58:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 315AF61409
	for <dm-devel@archiver.kernel.org>; Sat,  1 May 2021 11:58:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 315AF61409
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-396-F93kpwgyNzCjn3UQ6KiGnw-1; Sat, 01 May 2021 07:58:18 -0400
X-MC-Unique: F93kpwgyNzCjn3UQ6KiGnw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DC66B501FA;
	Sat,  1 May 2021 11:58:13 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 051BE18AD4;
	Sat,  1 May 2021 11:58:13 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2AE3F55341;
	Sat,  1 May 2021 11:58:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 141Bw8u2016904 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 1 May 2021 07:58:08 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 1C9941054F93; Sat,  1 May 2021 11:58:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1797410547BE
	for <dm-devel@redhat.com>; Sat,  1 May 2021 11:58:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 39702858F0D
	for <dm-devel@redhat.com>; Sat,  1 May 2021 11:58:05 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-587-_UPAfmccOAO8Idw5QxUzqQ-1;
	Sat, 01 May 2021 07:58:03 -0400
X-MC-Unique: _UPAfmccOAO8Idw5QxUzqQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 9486AB1B1;
	Sat,  1 May 2021 11:58:01 +0000 (UTC)
To: Laurence Oberman <loberman@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	Christoph Hellwig <hch@lst.de>
References: <20210416235329.49234-1-snitzer@redhat.com>
	<20210420093720.GA28874@lst.de> <20210420143852.GB14523@redhat.com>
	<6a22337b0d15830d9117640bd227711ba8c8aef8.camel@redhat.com>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <f2df22ef-583e-1d80-6ea7-2edfe61b9b53@suse.de>
Date: Sat, 1 May 2021 13:58:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <6a22337b0d15830d9117640bd227711ba8c8aef8.camel@redhat.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 141Bw8u2016904
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, linux-nvme@lists.infradead.org
Subject: Re: [dm-devel] [PATCH v3 0/4] nvme: improve error handling and
 ana_state to work well with dm-multipath
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gNC8yMC8yMSA1OjQ2IFBNLCBMYXVyZW5jZSBPYmVybWFuIHdyb3RlOgpbIC4uIF0KPiAKPiBM
ZXQgbWUgYWRkIHNvbWUgcmVhc29ucyB3aHkgYXMgcHJpbWFyaWx5IGEgc3VwcG9ydCBwZXJzb24g
dGhhdCB0aGlzIGlzCj4gaW1wb3J0YW50IGFuZCB0cnkgYXZvaWQgYW5vdGhlciBjb21iYXRpdmUg
c2l0dWF0aW9uLgo+IAo+IEN1c3RvbWVycyBkZXBlbmQgb24gbWFuYWdpbmcgZGV2aWNlLW1hcHBl
ci1tdWx0aXBhdGggdGhlIHdheSBpdCBpcyBub3cKPiBldmVuIHdpdGggdGhlIGFkdmVudCBvZiBu
dm1lLW92ZXItRi9DLiBZZWFycyBvZiBhZG1pbmlzdHJhdGlvbiBhbmQKPiBtYW5hZ2VtZW50IGZv
ciBtdWx0aXBsZSBFbnRlcnByaXNlIE8vUyB2ZW5kb3IgY3VzdG9tZXJzIChTdXNlL1JlZCBIYXQs
Cj4gT3JhY2xlKSBhbGwgZGVwZW5kIG9uIG1hbmFnaW5nIG11bHRpcGF0aCBhY2Nlc3MgaW4gYSB0
cmFuc3BhcmVudCB3YXkuCj4gCj4gSSByZXNwZWN0IGV2ZXJ5Ym9keSdzIHBvaW50IG9mIHZpZXcg
aGVyZSBidXQgbmF0aXZlIGRvZXMgY2hhbmdlIGxvZwo+IGFsZXJ0aW5nIGFuZCByZWNvdmVyeSBh
bmQgdGhhdCBpcyB3aGF0IHdpbGwgdGFrZSB0aW1lIGZvciBjdXN0b21lcnMgdG8KPiBhZG9wdC4K
PiAKPiBJdCBpcyBnb2luZyB0byB0YWtlIHRpbWUgZm9yIEVudGVycHJpc2UgY3VzdG9tZXJzIHRv
IHRyYW5zaXRpb24gc28gYWxsCj4gd2Ugd2FudCBpcyBhbiBvcHRpb24gZm9yIHRoZW0uIEF0IHNv
bWUgcG9pbnQgdGhleSB3aWxsIG1vdmUgdG8gbmF0aXZlCj4gYnV0IHdlIGFsd2F5cyBsaWtlIHRv
IGtlZXAgaW4gc3RlcCB3aXRoIHVwc3RyZWFtIGFzIG11Y2ggYXMgcG9zc2libGUuCj4gCj4gT2Yg
Y291cnNlIHdlIGNvdWxkIGxpdmUgd2l0aCBSSEVMLW9ubHkgZm9yIHdoaWxlIGJ1dCB0aGF0IGRl
ZmVhdHMgb3VyCj4gaW50ZW50aW9uIHRvIGJlIGFzIGNsb3NlIHRvIHVwc3RyZWFtIGFzIHBvc3Np
YmxlLgo+IAo+IElmIHdlIGNvdWxkIGhhdmUgdGhpcyBhY2NlcHRlZCB1cHN0cmVhbSBmb3Igbm93
IHBlcmhhcHMgd2hlbiBjdXN0b21lcnMKPiBhcmUgcmVhZHkgdG8gbW92ZSB0byBuYXRpdmUgb25s
eSB3ZSBjb3VsZCBwaGFzZSB0aGlzIG91dC4KPiAKPiBBbnkgdGVjaG5pY2FsIHJlYXNvbiB3aHkg
dGhpcyB3b3VsZCBub3QgZmx5IGlzIG9mIGNvdXJzZSBpbXBvcnRhbnQgdG8KPiBjb25zaWRlciBi
dXQgcGVyaGFwcyBmb3Igbm93IHdlIGhhdmUgYSBwYXJhbGxlbCBvcHRpb24gdW50aWwgd2UgZG9u
dC4KPiAKQ3VyaW91c2x5LCB3ZSAoYXMgaW4gd2UgYXMgU0xFUyBkZXZlbG9wZXJzKSBoYXZlIGZv
dW5kIGp1c3QgdGhlIG9wcG9zaXRlLgpOVk1lIGlzIGEgbmV3IHRlY2hub2xvZ3ksIGFuZCBvdXQg
b2YgbmVjZXNzaXR5IHRoZXJlIHdpbGwgbm90IGJlIGFueSAKZXhpc3RpbmcgaW5zdGFsbGF0aW9u
cyB3aGVyZSB3ZSBoYXZlIHRvIGJlIGNvbXBhdGlibGUgd2l0aC4KV2UgaGF2ZSBzd2l0Y2hlZCB0
byBuYXRpdmUgTlZNZSBtdWx0aXBhdGhpbmcgd2l0aCBTTEUxNSwgYW5kIGRlY2lkZWQgdG8gCmVk
dWNhdGUgY3VzdG9tZXJzIHRoYXQgTlZNZSBpcyBhIGRpZmZlcmVudCBjb25jZXB0IHRoYW4gU0NT
SSwgYW5kIG9uZSAKc2hvdWxkbid0IHRyeSB0cmVhdCBib3RoIHRoZSBzYW1lIHdheS4gVGhpcyB3
YXMgaGVscGVkIGJ5IHRoZSBmYWN0IHRoZSAKU0xFMTUgaXMgYSBuZXcgcmVsZWFzZSwgc28gY3Vz
dG9tZXJzIHdlcmUgYWNjdXN0b21lZCB0byBoYXZpbmcgdG8gY2hhbmdlIApiaXRzIGFuZCBwaWVj
ZXMgaW4gdGhlaXIgaW5mcmFzdHJ1Y3R1cmUgdG8gc3VwcG9ydCBuZXcgcmVsZWFzZXMuCgpPdmVy
YWxsIGl0IHdvcmtlZCByZWFzb25hYmx5IHdlbGw7IHdlIHN1cmUgZm91bmQgcGxlbnR5IG9mIGJ1
Z3MsIGJ1dCAKdGhhdCB3YXMga2luZCBvZiBleHBlY3RlZCwgYW5kIGZvciBiYWQgb3Igd29yc2Ug
bmVhcmx5IGFsbCBvZiB0aGVtIAp0dXJuZWQgb3V0IHRvIGJlIHVwc3RyZWFtIGlzc3Vlcy4gV2hp
Y2ggd2FzIGdvb2QgZm9yIHVzIChub3RoaW5nIGJlYXRzIApiZWluZyBhYmxlIHRvIGJsYW1lIHRo
aW5ncyBvbiB1cHN0cmVhbSwgaWYgb25lIGlzIGNhcmVmdWwgdG8gbm90IGxpbmdlciAKdG9vIG11
Y2ggb24gdGhlIGZhY3QgdGhhdCBvbmUgaXMgcGFydCBvZiB1cHN0cmVhbSk7IGFuZCB1cHN0cmVh
bSB0aGVzZSAKdGhpbmdzIHdpbGwgbmVlZCB0byBiZSBmaXhlZCBhbnl3YXkuClNvIHdlIGhhZCBh
IGJpdCBvZiBhIG1peGVkIGV4cGVyaWVuY2UsIGJ1dCBjdXN0b21lcnMgc2VlbWVkIHRvIGJlIGhh
cHB5IAplbm91Z2ggd2l0aCB0aGlzIHN0ZXAuCgpTb3JyeSBhYm91dCB0aGF0IDotKQoKQ2hlZXJz
LAoKSGFubmVzCi0tIApEci4gSGFubmVzIFJlaW5lY2tlICAgICAgICAgICAgICAgIEtlcm5lbCBT
dG9yYWdlIEFyY2hpdGVjdApoYXJlQHN1c2UuZGUgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICArNDkgOTExIDc0MDUzIDY4OApTVVNFIFNvZnR3YXJlIFNvbHV0aW9ucyBHbWJILCBNYXhmZWxk
c3RyLiA1LCA5MDQwOSBOw7xybmJlcmcKSFJCIDM2ODA5IChBRyBOw7xybmJlcmcpLCBHZXNjaMOk
ZnRzZsO8aHJlcjogRmVsaXggSW1lbmTDtnJmZmVyCgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0
CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9s
aXN0aW5mby9kbS1kZXZlbA==

