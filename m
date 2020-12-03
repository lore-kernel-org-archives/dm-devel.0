Return-Path: <SRS0=8v/u=FH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46B47C63777
	for <dm-devel@archiver.kernel.org>; Thu,  3 Dec 2020 12:49:32 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6B09F20709
	for <dm-devel@archiver.kernel.org>; Thu,  3 Dec 2020 12:49:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6B09F20709
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29-ztc8bKuQPeGGPFnMZqJCew-1; Thu, 03 Dec 2020 07:49:28 -0500
X-MC-Unique: ztc8bKuQPeGGPFnMZqJCew-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C60FDCC62B;
	Thu,  3 Dec 2020 12:49:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C3C219C44;
	Thu,  3 Dec 2020 12:49:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6BD841809C9F;
	Thu,  3 Dec 2020 12:49:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B3CnJtO005204 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Dec 2020 07:49:20 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id CBE682166B2C; Thu,  3 Dec 2020 12:49:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C758D2166B27
	for <dm-devel@redhat.com>; Thu,  3 Dec 2020 12:49:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 71B238007D9
	for <dm-devel@redhat.com>; Thu,  3 Dec 2020 12:49:17 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-552-a5oqaWEaPH-Ci2vtOWDBuQ-1;
	Thu, 03 Dec 2020 07:49:15 -0500
X-MC-Unique: a5oqaWEaPH-Ci2vtOWDBuQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 1CA8AAC2E;
	Thu,  3 Dec 2020 12:49:14 +0000 (UTC)
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20201130175854.982460-1-hch@lst.de>
	<20201130175854.982460-5-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <f9919068-f7a4-cd36-46db-bf6ac1cc80a7@suse.de>
Date: Thu, 3 Dec 2020 13:49:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201130175854.982460-5-hch@lst.de>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0B3CnJtO005204
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
	dm-devel@redhat.com, linux-s390@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 4/5] block: remove the request_queue argument
 to the block_bio_remap tracepoint
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMTEvMzAvMjAgNjo1OCBQTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4gVGhlIHJlcXVl
c3RfcXVldWUgY2FuIHRyaXZpYWxseSBiZSBkZXJpdmVkIGZyb20gdGhlIGJpby4KPiAKPiBTaWdu
ZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4KPiAtLS0KPiAgIGJsb2Nr
L2Jsay1jb3JlLmMgICAgICAgICAgICAgIHwgIDIgKy0KPiAgIGRyaXZlcnMvbWQvZG0uYyAgICAg
ICAgICAgICAgIHwgIDMgKy0tCj4gICBkcml2ZXJzL21kL21kLWxpbmVhci5jICAgICAgICB8ICAz
ICstLQo+ICAgZHJpdmVycy9tZC9tZC5jICAgICAgICAgICAgICAgfCAgNSArKy0tLQo+ICAgZHJp
dmVycy9tZC9yYWlkMC5jICAgICAgICAgICAgfCAgNCArKy0tCj4gICBkcml2ZXJzL21kL3JhaWQx
LmMgICAgICAgICAgICB8ICA3ICsrKy0tLS0KPiAgIGRyaXZlcnMvbWQvcmFpZDEwLmMgICAgICAg
ICAgIHwgIDYgKystLS0tCj4gICBkcml2ZXJzL21kL3JhaWQ1LmMgICAgICAgICAgICB8IDE1ICsr
KysrKystLS0tLS0tLQo+ICAgZHJpdmVycy9udm1lL2hvc3QvbXVsdGlwYXRoLmMgfCAgMyArLS0K
PiAgIGluY2x1ZGUvdHJhY2UvZXZlbnRzL2Jsb2NrLmggIHwgIDggKysrLS0tLS0KPiAgIGtlcm5l
bC90cmFjZS9ibGt0cmFjZS5jICAgICAgIHwgMTQgKysrKystLS0tLS0tLS0KPiAgIDExIGZpbGVz
IGNoYW5nZWQsIDI4IGluc2VydGlvbnMoKyksIDQyIGRlbGV0aW9ucygtKQo+IApSZXZpZXdlZC1i
eTogSGFubmVzIFJlaW5lY2tlIDxoYXJlQHN1c2UuZGU+CgpDaGVlcnMsCgpIYW5uZXMKLS0gCkRy
LiBIYW5uZXMgUmVpbmVja2UgICAgICAgICAgICAgICAgS2VybmVsIFN0b3JhZ2UgQXJjaGl0ZWN0
CmhhcmVAc3VzZS5kZSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICs0OSA5MTEgNzQwNTMg
Njg4ClNVU0UgU29mdHdhcmUgU29sdXRpb25zIEdtYkgsIE1heGZlbGRzdHIuIDUsIDkwNDA5IE7D
vHJuYmVyZwpIUkIgMzY4MDkgKEFHIE7DvHJuYmVyZyksIEdlc2Now6RmdHNmw7xocmVyOiBGZWxp
eCBJbWVuZMO2cmZmZXIKCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0
LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=

