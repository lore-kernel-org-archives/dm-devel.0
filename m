Return-Path: <SRS0=RcAx=E2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9A74C5519F
	for <dm-devel@archiver.kernel.org>; Fri, 20 Nov 2020 07:50:53 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1073B222BA
	for <dm-devel@archiver.kernel.org>; Fri, 20 Nov 2020 07:50:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1073B222BA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-508-c_f0jnMtM2q-A14qWXsBUQ-1; Fri, 20 Nov 2020 02:50:49 -0500
X-MC-Unique: c_f0jnMtM2q-A14qWXsBUQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7718E835B62;
	Fri, 20 Nov 2020 07:50:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 26B0063B8C;
	Fri, 20 Nov 2020 07:50:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9E6104BB7B;
	Fri, 20 Nov 2020 07:50:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AK7ohXL006907 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 20 Nov 2020 02:50:43 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id EFBCB2166B2B; Fri, 20 Nov 2020 07:50:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EAB822166B28
	for <dm-devel@redhat.com>; Fri, 20 Nov 2020 07:50:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DEC45800B3B
	for <dm-devel@redhat.com>; Fri, 20 Nov 2020 07:50:39 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-585-hvU_l0UGPQCK0LejpGNM8Q-1;
	Fri, 20 Nov 2020 02:50:33 -0500
X-MC-Unique: hvU_l0UGPQCK0LejpGNM8Q-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 55C9CAC23;
	Fri, 20 Nov 2020 07:50:31 +0000 (UTC)
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20201116145809.410558-1-hch@lst.de>
	<20201116145809.410558-67-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <23914ef5-5245-b468-4168-bc1584e979d2@suse.de>
Date: Fri, 20 Nov 2020 08:50:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201116145809.410558-67-hch@lst.de>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0AK7ohXL006907
X-loop: dm-devel@redhat.com
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
	ceph-devel@vger.kernel.org, linux-block@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Minchan Kim <minchan@kernel.org>, linux-fsdevel@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?Q?Roger_Pau_Monn=c3=a9?= <roger.pau@citrix.com>
Subject: Re: [dm-devel] [PATCH 66/78] block: keep a block_device reference
 for each hd_struct
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

T24gMTEvMTYvMjAgMzo1NyBQTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4gVG8gc2ltcGxp
ZnkgYmxvY2sgZGV2aWNlIGxvb2t1cCBhbmQgYSBmZXcgb3RoZXIgdXBjb21kaW4gYXJlYXMsIG1h
a2Ugc3VyZQo+IHRoYXQgd2UgYWx3YXlzIGhhdmUgYSBzdHJ1Y3QgYmxvY2tfZGV2aWNlIGF2YWls
YWJsZSBmb3IgZWFjaCBkaXNrIGFuZAo+IGVhY2ggcGFydGl0aW9uLiAgVGhlIG9ubHkgZG93bnNp
ZGUgb2YgdGhpcyBpcyB0aGF0IGVhY2ggZGV2aWNlIGFuZAo+IHBhcnRpdGlvbiB1c2VzIGEgbGl0
dGxlIG1vcmUgbWVtb3JpZXMuICBUaGUgdXBzaWRlIHdpbGwgYmUgdGhhdCBhIGxvdCBvZgo+IGNv
ZGUgY2FuIGJlIHNpbXBsaWZpZWQuCj4gCj4gV2l0aCB0aGF0IGFsbCB3ZSBuZWVkIHRvIGxvb2sg
dXAgdGhlIGJsb2NrIGRldmljZSBpcyB0byBsb29rdXAgdGhlIGlub2RlCj4gYW5kIGRvIGEgZmV3
IHNhbml0eSBjaGVja3Mgb24gdGhlIGdlbmRpc2ssIGluc3RlYWQgb2YgdGhlIHNlcGFyYXRlIGxv
b2t1cAo+IGZvciB0aGUgZ2VuZGlzay4KPiAKPiBBcyBwYXJ0IG9mIHRoZSBjaGFuZ2Ugc3dpdGNo
IGJkZ2V0KCkgdG8gb25seSBmaW5kIGV4aXN0aW5nIGJsb2NrIGRldmljZXMsCj4gZ2l2ZW4gdGhh
dCB3ZSBrbm93IHRoYXQgdGhlIGJsb2NrX2RldmljZSBzdHJ1Y3R1cmUgbXVzdCBiZSBhbGxvY2F0
ZWQgYXQKPiBwcm9iZSAvIHBhcnRpdGlvbiBzY2FuIHRpbWUuCj4gCj4gYmxrLWNncm91cCBuZWVk
ZWQgYSBiaXQgb2YgYSBzcGVjaWFsIHRyZWF0bWVudCBhcyB0aGUgb25seSBwbGFjZSB0aGF0Cj4g
d2FudGVkIHRvIGxvb2t1cCBhIGdlbmRpc2sgb3V0c2lkZSBvZiB0aGUgbm9ybWFsIGJsa2Rldl9n
ZXQgcGF0aC4gIEl0IGlzCj4gc3dpdGNoZWQgdG8gbG9va3VwIHVzaW5nIHRoZSBibG9jayBkZXZp
Y2UgaGFzaCBub3cgdGhhdCB0aGlzIGlzIHRoZQo+IHByaW1hcnkgbG9va3VwIHBhdGguCj4gCj4g
U2lnbmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+Cj4gLS0tCj4gICBi
bG9jay9ibGstY2dyb3VwLmMgICAgICAgICB8ICA0MiArKysrLS0tLS0KPiAgIGJsb2NrL2Jsay1p
b2Nvc3QuYyAgICAgICAgIHwgIDM2ICsrKy0tLS0KPiAgIGJsb2NrL2Jsay5oICAgICAgICAgICAg
ICAgIHwgICAxIC0KPiAgIGJsb2NrL2dlbmhkLmMgICAgICAgICAgICAgIHwgMTg4ICsrKy0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KPiAgIGJsb2NrL3BhcnRpdGlvbnMvY29yZS5j
ICAgIHwgIDI4ICsrKy0tLQo+ICAgZnMvYmxvY2tfZGV2LmMgICAgICAgICAgICAgfCAxMzMgKysr
KysrKysrKysrKysrLS0tLS0tLS0tLS0KPiAgIGluY2x1ZGUvbGludXgvYmxrLWNncm91cC5oIHwg
ICA0ICstCj4gICBpbmNsdWRlL2xpbnV4L2Jsa2Rldi5oICAgICB8ICAgMyArCj4gICBpbmNsdWRl
L2xpbnV4L2dlbmhkLmggICAgICB8ICAgNCArLQo+ICAgOSBmaWxlcyBjaGFuZ2VkLCAxNTMgaW5z
ZXJ0aW9ucygrKSwgMjg2IGRlbGV0aW9ucygtKQo+IApSZXZpZXdlZC1ieTogSGFubmVzIFJlaW5l
Y2tlIDxoYXJlQHN1c2UuZGU+CgpDaGVlcnMsCgpIYW5uZXMKLS0gCkRyLiBIYW5uZXMgUmVpbmVj
a2UgICAgICAgICAgICAgICAgS2VybmVsIFN0b3JhZ2UgQXJjaGl0ZWN0CmhhcmVAc3VzZS5kZSAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICs0OSA5MTEgNzQwNTMgNjg4ClNVU0UgU29mdHdh
cmUgU29sdXRpb25zIEdtYkgsIE1heGZlbGRzdHIuIDUsIDkwNDA5IE7DvHJuYmVyZwpIUkIgMzY4
MDkgKEFHIE7DvHJuYmVyZyksIEdlc2Now6RmdHNmw7xocmVyOiBGZWxpeCBJbWVuZMO2cmZmZXIK
CgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3
dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=

