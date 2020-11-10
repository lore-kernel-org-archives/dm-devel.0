Return-Path: <SRS0=xkgx=EQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B54ACC388F7
	for <dm-devel@archiver.kernel.org>; Tue, 10 Nov 2020 07:55:42 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0FC652080A
	for <dm-devel@archiver.kernel.org>; Tue, 10 Nov 2020 07:55:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0FC652080A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-BJrzftqINbOzxOBCcTymJA-1; Tue, 10 Nov 2020 02:55:38 -0500
X-MC-Unique: BJrzftqINbOzxOBCcTymJA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 60D1A1087D66;
	Tue, 10 Nov 2020 07:55:34 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4506E5B4CE;
	Tue, 10 Nov 2020 07:55:34 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1CA9258112;
	Tue, 10 Nov 2020 07:55:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AA70dSE019237 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 10 Nov 2020 02:00:40 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 57B552156A36; Tue, 10 Nov 2020 07:00:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 525B32156A3D
	for <dm-devel@redhat.com>; Tue, 10 Nov 2020 07:00:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 27732185A78B
	for <dm-devel@redhat.com>; Tue, 10 Nov 2020 07:00:37 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-17-quoLTdFKO_mHaAXzVhRW8w-1;
	Tue, 10 Nov 2020 02:00:31 -0500
X-MC-Unique: quoLTdFKO_mHaAXzVhRW8w-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 4ADE6ABCC;
	Tue, 10 Nov 2020 07:00:29 +0000 (UTC)
To: Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>
References: <20201106190337.1973127-1-hch@lst.de>
	<20201106190337.1973127-4-hch@lst.de>
	<1d06cdfa-a904-30be-f3ec-08ae2fa85cbd@suse.de>
	<20201109085340.GB27483@lst.de>
	<e79f9a96-ef53-d6ea-f6e7-e141bdd2e2d2@suse.de>
	<d28042e3-3123-5dfc-d0a2-aab0012150c8@grimberg.me>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <c883475d-c154-a123-521e-4723b87534cd@suse.de>
Date: Tue, 10 Nov 2020 08:00:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <d28042e3-3123-5dfc-d0a2-aab0012150c8@grimberg.me>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0AA70dSE019237
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 10 Nov 2020 02:55:04 -0500
Cc: Justin Sanders <justin@coraid.com>, Mike Snitzer <snitzer@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>, linux-nvme@lists.infradead.org,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	linux-scsi@vger.kernel.org, xen-devel@lists.xenproject.org,
	Ilya Dryomov <idryomov@gmail.com>, Jack Wang <jinpu.wang@cloud.ionos.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Josef Bacik <josef@toxicpanda.com>, nbd@other.debian.org,
	linux-raid@vger.kernel.org,
	Stefan Hajnoczi <stefanha@redhat.com>, drbd-dev@tron.linbit.com,
	ceph-devel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Minchan Kim <minchan@kernel.org>, linux-fsdevel@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?Q?Roger_Pau_Monn=c3=a9?= <roger.pau@citrix.com>
Subject: Re: [dm-devel] [PATCH 03/24] nvme: let
 set_capacity_revalidate_and_notify update the bdev size
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

T24gMTEvMTAvMjAgMTI6MjggQU0sIFNhZ2kgR3JpbWJlcmcgd3JvdGU6Cj4gCj4+IFsgLi4gXQo+
Pj4+IE9yaWdpbmFsbHkgbnZtZSBtdWx0aXBhdGggd291bGQgdXBkYXRlL2NoYW5nZSB0aGUgc2l6
ZSBvZiB0aGUgbXVsdGlwYXRoCj4+Pj4gZGV2aWNlIGFjY29yZGluZyB0byB0aGUgdW5kZXJseWlu
ZyBwYXRoIGRldmljZXMuCj4+Pj4gV2l0aCB0aGlzIHBhdGNoIHRoZSBzaXplIG9mIHRoZSBtdWx0
aXBhdGggZGV2aWNlIHdpbGwgX25vdF8gY2hhbmdlIAo+Pj4+IGlmIHRoZXJlCj4+Pj4gaXMgYSBj
aGFuZ2Ugb24gdGhlIHVuZGVybHlpbmcgZGV2aWNlcy4KPj4+Cj4+PiBZZXMsIGl0IHdpbGwuwqAg
VGFrZSBhIGNsb3NlIGxvb2sgYXQgbnZtZV91cGRhdGVfZGlza19pbmZvIGFuZCBob3cgaXQgaXMK
Pj4+IGNhbGxlZC4KPj4+Cj4+IE9rYXksIHRoZW46IFdoYXQgd291bGQgYmUgdGhlIGNvcnJlY3Qg
d2F5IG9mIGhhbmRsaW5nIGEgc2l6ZSB1cGRhdGUgCj4+IGZvciBOVk1lIG11bHRpcGF0aD8KPj4g
QXNzdW1pbmcgd2UncmUgZ2V0dGluZyBhbiBBRU4gZm9yIGVhY2ggcGF0aCBzaWduYWxsaW5nIHRo
ZSBzaXplIGNoYW5nZQo+PiAob3IgYSBjb250cm9sbGVyIHJlc2V0IGxlYWRpbmcgdG8gYSBzaXpl
IGNoYW5nZSkuCj4+IFNvIGlmIHdlJ3JlIHVwZGF0aW5nIHRoZSBzaXplIG9mIHRoZSBtdWx0aXBh
dGggZGV2aWNlIHRvZ2V0aGVyIHdpdGggCj4+IHRoZSBwYXRoIGRldmljZSBhdCB0aGUgZmlyc3Qg
QUVOL3Jlc2V0IHdlJ2xsIGVuZCB1cCB3aXRoIHRoZSBvdGhlciAKPj4gcGF0aHMgaGF2aW5nIGEg
ZGlmZmVyZW50IHNpemUgdGhhbiB0aGUgbXVsdGlwYXRoIGRldmljZSAoYW5kIHRoZSBwYXRoIAo+
PiB3ZSd2ZSBqdXN0IGJlZW4gdXBkYXRpbmcpLgo+PiAtIERvIHdlIGNhcmUsIG9yIGNyb3NzIGZp
bmdlcnMgYW5kIGhvcGUgZm9yIHRoZSBiZXN0Pwo+PiAtIFNob3VsZG4ndCB3ZSBkZXRlY3QgdGhl
IGNhc2Ugd2hlcmUgd2Ugd29uJ3QgZ2V0IGEgc2l6ZSB1cGRhdGUgZm9yIAo+PiB0aGUgb3RoZXIg
cGF0aHMsIG9yLCBpbmRlZWQsIHdlIGhhdmUgYSBnZW51aW5lIGRldmljZSBzaXplIG1pc21hdGNo
IAo+PiBkdWUgdG8gYSBtaXNjb25maWd1cmF0aW9uIG9uIHRoZSB0YXJnZXQ/Cj4+Cj4+IElFIHNo
b3VsZG4ndCB3ZSBoYXZlIGEgZmxhZyAnc2l6ZSB1cGRhdGUgcGVuZGluZycgZm9yIHRoZSBvdGhl
ciAKPj4gcGF0aHMsLCB0byB0YWtlIHRoZW0gb3V0IG91ZiB1c2UgdGVtcG9yYXJpbHkgdW50aWwg
dGhlIG90aGVyIAo+PiBBRU5zL3Jlc2V0cyBoYXZlIGJlZW4gcHJvY2Vzc2VkPwo+IAo+IHRoZSBt
cGF0aCBkZXZpY2Ugd2lsbCB0YWtlIHRoZSBtaW5pbXVtIHNpemUgZnJvbSBhbGwgdGhlIHBhdGhz
LCB0aGF0IGlzCj4gd2hhdCBibGtfc3RhY2tfbGltaXRzIGRvZXMuIFdoZW4gdGhlIEFFTiBmb3Ig
YWxsIHRoZSBwYXRocyB3aWxsIGFycml2ZQo+IHRoZSBtcGF0aCBzaXplIHdpbGwgdXBkYXRlLgo+
IApCdXQgdGhhdCdzIHByZWNpc2VseSBteSBwb2ludDsgdGhlcmUgd29uJ3QgYmUgYW4gQUVOIGZv
ciBfYWxsXyBwYXRocywgCmJ1dCByYXRoZXIgb25lIEFFTiBwZXIgcGF0aC4gV2hpY2ggd2lsbCBi
ZSBwcm9jZXNzZWQgc2VwYXJhdGVseSwgbGVhZGluZyAKdG8gdGhlIGlzc3VlIGRlc2NyaWJlZCBh
Ym92ZS4KCj4gTm90IHN1cmUgaG93IHRoaXMgaXMgZGlmZmVyZW50IHRoYW4gd2hhdCB3ZSBoYXZl
IHRvZGF5Li4uCgpPaCwgdGhhdCBpcyBhIHByb2JsZW0gZXZlbiB0b2RheS4KU28gd2Ugc2hvdWxk
IHByb2JhYmx5IG1vdmUgaXQgdG8gYSBkaWZmZXJlbnQgdGhyZWFkLi4uCgpDaGVlcnMsCgpIYW5u
ZXMKLS0gCkRyLiBIYW5uZXMgUmVpbmVja2UgICAgICAgICAgICAgICAgS2VybmVsIFN0b3JhZ2Ug
QXJjaGl0ZWN0CmhhcmVAc3VzZS5kZSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICs0OSA5
MTEgNzQwNTMgNjg4ClNVU0UgU29mdHdhcmUgU29sdXRpb25zIEdtYkgsIE1heGZlbGRzdHIuIDUs
IDkwNDA5IE7DvHJuYmVyZwpIUkIgMzY4MDkgKEFHIE7DvHJuYmVyZyksIEdlc2Now6RmdHNmw7xo
cmVyOiBGZWxpeCBJbWVuZMO2cmZmZXIKCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2
ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0t
ZGV2ZWw=

