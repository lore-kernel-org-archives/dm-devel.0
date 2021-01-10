Return-Path: <SRS0=l7Hk=GN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9768C433DB
	for <dm-devel@archiver.kernel.org>; Sun, 10 Jan 2021 15:01:10 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3705F229EF
	for <dm-devel@archiver.kernel.org>; Sun, 10 Jan 2021 15:01:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3705F229EF
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-523-udgEYVUnMyeJJ0r6ZSg1bQ-1; Sun, 10 Jan 2021 10:01:07 -0500
X-MC-Unique: udgEYVUnMyeJJ0r6ZSg1bQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 36E47180DE0B;
	Sun, 10 Jan 2021 15:01:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0E00560C61;
	Sun, 10 Jan 2021 15:01:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4EA934A7C6;
	Sun, 10 Jan 2021 15:01:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10AF0vXG015811 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 10 Jan 2021 10:00:57 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 243CA2166B28; Sun, 10 Jan 2021 15:00:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1EDBB2166B27
	for <dm-devel@redhat.com>; Sun, 10 Jan 2021 15:00:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4E612858EEC
	for <dm-devel@redhat.com>; Sun, 10 Jan 2021 15:00:53 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-99-voBFClaGM4auroiOmS7Ekw-1;
	Sun, 10 Jan 2021 10:00:50 -0500
X-MC-Unique: voBFClaGM4auroiOmS7Ekw-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 54306AAF1;
	Sun, 10 Jan 2021 15:00:49 +0000 (UTC)
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20210109104254.1077093-1-hch@lst.de>
	<20210109104254.1077093-5-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <81a37585-bf6e-9ab5-993e-e9a0881ce996@suse.de>
Date: Sun, 10 Jan 2021 16:00:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20210109104254.1077093-5-hch@lst.de>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 10AF0vXG015811
X-loop: dm-devel@redhat.com
Cc: Sagi Grimberg <sagi@grimberg.me>, Mike Snitzer <snitzer@redhat.com>,
	Oleksii Kurochko <olkuroch@cisco.com>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	linux-nvme@lists.infradead.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 4/6] block: propagate BLKROSET on the whole
 device to all partitions
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMS85LzIxIDExOjQyIEFNLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToKPiBDaGFuZ2UgdGhl
IHBvbGljeSBzbyB0aGF0IGEgQkxLUk9TRVQgb24gdGhlIHdob2xlIGRldmljZSBhbHNvIGFmZmVj
dHMKPiBwYXJ0aXRpb25zLiAgVG8gcXVvdGUgTWFydGluIEsuIFBldGVyc2VuOgo+IAo+IEl0J3Mg
dmVyeSBjb21tb24gZm9yIGRhdGFiYXNlIGZvbGtzIHRvIHR3aWRkbGUgdGhlIHJlYWQtb25seSBz
dGF0ZSBvZgo+IGJsb2NrIGRldmljZXMgYW5kIHBhcnRpdGlvbnMuIEkga25vdyB0aGF0IG91ciB1
c2VycyB3aWxsIGZpbmQgaXQgdmVyeQo+IGNvdW50ZXItaW50dWl0aXZlIHRoYXQgc2V0dGluZyAv
ZGV2L3NkYSByZWFkLW9ubHkgd29uJ3QgcHJldmVudCB3cml0ZXMKPiB0byAvZGV2L3NkYTEuCj4g
Cj4gVGhlIGV4aXN0aW5nIGJlaGF2aW9yIGlzIGluY29uc2lzdGVudCBpbiB0aGUgc2Vuc2UgdGhh
dCBkb2luZzoKPiAKPiAgICAjIGJsb2NrZGV2IC0tc2V0cm8gL2Rldi9zZGEKPiAgICAjIGVjaG8g
Zm9vID4gL2Rldi9zZGExCj4gCj4gcGVybWl0cyB3cml0ZXMuIEJ1dDoKPiAKPiAgICAjIGJsb2Nr
ZGV2IC0tc2V0cm8gL2Rldi9zZGEKPiAgICA8c29tZXRoaW5nIHRyaWdnZXJzIHJldmFsaWRhdGU+
Cj4gICAgIyBlY2hvIGZvbyA+IC9kZXYvc2RhMQo+IAo+IGRvZXNuJ3QuCj4gCj4gQW5kIGEgc3Vi
c2VxdWVudDoKPiAKPiAgICAjIGJsb2NrZGV2IC0tc2V0cncgL2Rldi9zZGEKPiAgICAjIGVjaG8g
Zm9vID4gL2Rldi9zZGExCj4gCj4gZG9lc24ndCB3b3JrIGVpdGhlciBzaW5jZSBzZGExJ3MgcmVh
ZC1vbmx5IHBvbGljeSBoYXMgYmVlbiBpbmhlcml0ZWQKPiBmcm9tIHRoZSB3aG9sZS1kaXNrIGRl
dmljZS4KPiAKPiBZb3UgbmVlZCB0byBkbzoKPiAKPiAgICAjIGJsb2NrZGV2IC0tcmVyZWFkcHQK
PiAKPiBhZnRlciBzZXR0aW5nIHRoZSB3aG9sZS1kaXNrIGRldmljZSBydyB0byBlZmZlY3R1YXRl
IHRoZSBzYW1lIGNoYW5nZSBvbgo+IHRoZSBwYXJ0aXRpb25zLCBvdGhlcndpc2UgdGhleSBhcmUg
c3R1Y2sgYmVpbmcgcmVhZC1vbmx5IGluZGVmaW5pdGVseS4KPiAKPiBIb3dldmVyLCBzZXR0aW5n
IHRoZSByZWFkLW9ubHkgcG9saWN5IG9uIGEgcGFydGl0aW9uIGRvZXMgKm5vdCogcmVxdWlyZQo+
IHRoZSByZXZhbGlkYXRlIHN0ZXAuIEFzIGEgbWF0dGVyIG9mIGZhY3QsIGRvaW5nIHRoZSByZXZh
bGlkYXRlIHdpbGwgYmxvdwo+IGF3YXkgdGhlIHBvbGljeSBzZXR0aW5nIHlvdSBqdXN0IG1hZGUu
Cj4gCj4gU28gdGhlIHVzZXIgbmVlZHMgdG8gdGFrZSBkaWZmZXJlbnQgYWN0aW9ucyBkZXBlbmRp
bmcgb24gd2hldGhlciB0aGV5Cj4gYXJlIHRyeWluZyB0byByZWFkLXByb3RlY3QgYSB3aG9sZS1k
aXNrIGRldmljZSBvciBhIHBhcnRpdGlvbi4gRGVzcGl0ZQo+IHVzaW5nIHRoZSBzYW1lIGlvY3Rs
LiBUaGF0IGlzIHJlYWxseSBjb25mdXNpbmcuCj4gCj4gSSBoYXZlIGxvc3QgY291bnQgaG93IG1h
bnkgdGltZXMgb3VyIGN1c3RvbWVycyBoYXZlIGhhZCBkYXRhIGNsb2JiZXJlZAo+IGJlY2F1c2Ug
b2YgYW1iaWd1aXR5IG9mIHRoZSBleGlzdGluZyB3aG9sZS1kaXNrIGRldmljZSBwb2xpY3kuIFRo
ZQo+IGN1cnJlbnQgYmVoYXZpb3IgdmlvbGF0ZXMgdGhlIHByaW5jaXBsZSBvZiBsZWFzdCBzdXJw
cmlzZSBieSBsZXR0aW5nIHRoZQo+IHVzZXIgdGhpbmsgdGhleSB3cml0ZSBwcm90ZWN0ZWQgdGhl
IHdob2xlIGRpc2sgd2hlbiB0aGV5IGFjdHVhbGx5Cj4gZGlkbid0Lgo+IAo+IFN1Z2dlc3RlZC1i
eTogTWFydGluIEsuIFBldGVyc2VuIDxtYXJ0aW4ucGV0ZXJzZW5Ab3JhY2xlLmNvbT4KPiBTaWdu
ZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4KPiBSZXZpZXdlZC1ieTog
TWFydGluIEsuIFBldGVyc2VuIDxtYXJ0aW4ucGV0ZXJzZW5Ab3JhY2xlLmNvbT4KPiAtLS0KPiAg
IGJsb2NrL2dlbmhkLmMgfCAzICstLQo+ICAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCsp
LCAyIGRlbGV0aW9ucygtKQo+IApSZXZpZXdlZC1ieTogSGFubmVzIFJlaW5lY2tlIDxoYXJlQHN1
c2UuZGU+CgpDaGVlcnMsCgpIYW5uZXMKLS0gCkRyLiBIYW5uZXMgUmVpbmVja2UgICAgICAgICAg
ICAgICAgS2VybmVsIFN0b3JhZ2UgQXJjaGl0ZWN0CmhhcmVAc3VzZS5kZSAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICs0OSA5MTEgNzQwNTMgNjg4ClNVU0UgU29mdHdhcmUgU29sdXRpb25z
IEdtYkgsIE1heGZlbGRzdHIuIDUsIDkwNDA5IE7DvHJuYmVyZwpIUkIgMzY4MDkgKEFHIE7DvHJu
YmVyZyksIEdlc2Now6RmdHNmw7xocmVyOiBGZWxpeCBJbWVuZMO2cmZmZXIKCgotLQpkbS1kZXZl
bCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29t
L21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=

