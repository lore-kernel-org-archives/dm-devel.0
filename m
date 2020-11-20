Return-Path: <SRS0=RcAx=E2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F297CC64E69
	for <dm-devel@archiver.kernel.org>; Fri, 20 Nov 2020 07:58:42 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 21AF2222BA
	for <dm-devel@archiver.kernel.org>; Fri, 20 Nov 2020 07:58:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 21AF2222BA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-KUpstHWMMfyc3NXiHw9KdQ-1; Fri, 20 Nov 2020 02:58:36 -0500
X-MC-Unique: KUpstHWMMfyc3NXiHw9KdQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CBB28814413;
	Fri, 20 Nov 2020 07:58:31 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ABCBC60854;
	Fri, 20 Nov 2020 07:58:31 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5B4B71809C9F;
	Fri, 20 Nov 2020 07:58:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AK7wTmZ007725 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 20 Nov 2020 02:58:29 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E858AE778E; Fri, 20 Nov 2020 07:58:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E300BE7790
	for <dm-devel@redhat.com>; Fri, 20 Nov 2020 07:58:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 938D5811E76
	for <dm-devel@redhat.com>; Fri, 20 Nov 2020 07:58:25 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-434-N2tFpV1OP8e0dIdMpuW-CQ-1;
	Fri, 20 Nov 2020 02:58:19 -0500
X-MC-Unique: N2tFpV1OP8e0dIdMpuW-CQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 75B07AC0C;
	Fri, 20 Nov 2020 07:58:17 +0000 (UTC)
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20201116145809.410558-1-hch@lst.de>
	<20201116145809.410558-71-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <c854459e-d124-d0fd-2159-d40ef4d6ca75@suse.de>
Date: Fri, 20 Nov 2020 08:58:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201116145809.410558-71-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0AK7wTmZ007725
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
Subject: Re: [dm-devel] [PATCH 70/78] block: replace bd_mutex with a
	per-gendisk mutex
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMTEvMTYvMjAgMzo1OCBQTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4gYmRfbXV0ZXgg
aXMgcHJpbWFyaWx5IHVzZWQgZm9yIHN5bmNocm9uaXppbmcgdGhlIGJsb2NrIGRldmljZSBvcGVu
IGFuZAo+IHJlbGVhc2UgcGF0aCwgd2hpY2ggcmVjdXJzZXMgZnJvbSBwYXJ0aXRpb25zIHRvIHRo
ZSB3aG9sZSBkaXNrIGRldmljZS4KPiBUaGUgZmFjdCB0aGF0IHdlIGhhdmUgdHdvIGxvY2tzIG1h
a2VzIGxpZmUgdW5uZWNlc3NhcmlseSBjb21wbGV4IGR1ZQo+IHRvIGxvY2sgb3JkZXIgY29uc3Ry
YWlucy4gIFJlcGxhY2UgdGhlIHR3byBsZXZlbHMgb2YgbG9ja2luZyB3aXRoIGEKPiBzaW5nbGUg
bXV0ZXggaW4gdGhlIGdlbmRpc2sgc3RydWN0dXJlLgo+IAo+IFNpZ25lZC1vZmYtYnk6IENocmlz
dG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPgo+IC0tLQo+ICAgYmxvY2svZ2VuaGQuYyAgICAgICAg
ICAgICAgICAgICB8ICA3ICsrLS0KPiAgIGJsb2NrL2lvY3RsLmMgICAgICAgICAgICAgICAgICAg
fCAgNCArLQo+ICAgYmxvY2svcGFydGl0aW9ucy9jb3JlLmMgICAgICAgICB8IDIyICsrKysrLS0t
LS0KPiAgIGRyaXZlcnMvYmxvY2svbG9vcC5jICAgICAgICAgICAgfCAxNCArKystLS0tCj4gICBk
cml2ZXJzL2Jsb2NrL3hlbi1ibGtmcm9udC5jICAgIHwgIDggKystLQo+ICAgZHJpdmVycy9ibG9j
ay96cmFtL3pyYW1fZHJ2LmMgICB8ICA0ICstCj4gICBkcml2ZXJzL2Jsb2NrL3pyYW0venJhbV9k
cnYuaCAgIHwgIDIgKy0KPiAgIGRyaXZlcnMvbWQvbWQuaCAgICAgICAgICAgICAgICAgfCAgNyAr
LS0tCj4gICBkcml2ZXJzL3MzOTAvYmxvY2svZGFzZF9nZW5oZC5jIHwgIDggKystLQo+ICAgZHJp
dmVycy9zY3NpL3NkLmMgICAgICAgICAgICAgICB8ICA0ICstCj4gICBmcy9ibG9ja19kZXYuYyAg
ICAgICAgICAgICAgICAgIHwgNzEgKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tCj4g
ICBmcy9idHJmcy92b2x1bWVzLmMgICAgICAgICAgICAgIHwgIDIgKy0KPiAgIGZzL3N1cGVyLmMg
ICAgICAgICAgICAgICAgICAgICAgfCAgOCArKy0tCj4gICBpbmNsdWRlL2xpbnV4L2Jsa190eXBl
cy5oICAgICAgIHwgIDEgLQo+ICAgaW5jbHVkZS9saW51eC9nZW5oZC5oICAgICAgICAgICB8ICAx
ICsKPiAgIDE1IGZpbGVzIGNoYW5nZWQsIDgwIGluc2VydGlvbnMoKyksIDgzIGRlbGV0aW9ucygt
KQo+IApSZXZpZXdlZC1ieTogSGFubmVzIFJlaW5lY2tlIDxoYXJlQHN1c2UuZGU+CgpDaGVlcnMs
CgpIYW5uZXMKLS0gCkRyLiBIYW5uZXMgUmVpbmVja2UgICAgICAgICAgICAgICAgS2VybmVsIFN0
b3JhZ2UgQXJjaGl0ZWN0CmhhcmVAc3VzZS5kZSAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICs0OSA5MTEgNzQwNTMgNjg4ClNVU0UgU29mdHdhcmUgU29sdXRpb25zIEdtYkgsIE1heGZlbGRz
dHIuIDUsIDkwNDA5IE7DvHJuYmVyZwpIUkIgMzY4MDkgKEFHIE7DvHJuYmVyZyksIEdlc2Now6Rm
dHNmw7xocmVyOiBGZWxpeCBJbWVuZMO2cmZmZXIKCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QK
ZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGlu
Zm8vZG0tZGV2ZWw=

