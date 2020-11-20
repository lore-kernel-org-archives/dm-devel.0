Return-Path: <SRS0=RcAx=E2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66CFAC5519F
	for <dm-devel@archiver.kernel.org>; Fri, 20 Nov 2020 08:59:13 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A9A722224C
	for <dm-devel@archiver.kernel.org>; Fri, 20 Nov 2020 08:59:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A9A722224C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-420-9UDUoJ6fPaGgVGxM_wNZdw-1; Fri, 20 Nov 2020 03:59:02 -0500
X-MC-Unique: 9UDUoJ6fPaGgVGxM_wNZdw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 06AA3186840A;
	Fri, 20 Nov 2020 08:58:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D94565D9C6;
	Fri, 20 Nov 2020 08:58:53 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 89F0C4BB7B;
	Fri, 20 Nov 2020 08:58:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AK8wprW018348 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 20 Nov 2020 03:58:51 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 68FDF1016D60; Fri, 20 Nov 2020 08:58:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 644FF10EB299
	for <dm-devel@redhat.com>; Fri, 20 Nov 2020 08:58:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 13B6485828C
	for <dm-devel@redhat.com>; Fri, 20 Nov 2020 08:58:49 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-414-lQbchK7fMrKK71yPXTaTLA-1;
	Fri, 20 Nov 2020 03:58:44 -0500
X-MC-Unique: lQbchK7fMrKK71yPXTaTLA-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 5CAD1AC23;
	Fri, 20 Nov 2020 08:58:42 +0000 (UTC)
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20201116145809.410558-1-hch@lst.de>
	<20201116145809.410558-75-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <f6e6b948-44c8-50f0-beea-921eb3a268dd@suse.de>
Date: Fri, 20 Nov 2020 09:58:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201116145809.410558-75-hch@lst.de>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0AK8wprW018348
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
Subject: Re: [dm-devel] [PATCH 74/78] block: merge struct block_device and
 struct hd_struct
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

T24gMTEvMTYvMjAgMzo1OCBQTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4gSW5zdGVhZCBv
ZiBoYXZpbmcgdHdvIHN0cnVjdHVyZXMgdGhhdCByZXByZXNlbnQgZWFjaCBibG9jayBkZXZpY2Ug
d2l0aAo+IGRpZmZlcmVudCBsaWZ0IHRpbWUgcnVsZXMgbWVyZ2VkIHRoZW0gaW50byBhIHNpbmds
ZSBvbmUuICBUaGlzIGFsc28KPiBncmVhdGx5IHNpbXBsaWZpZXMgdGhlIHJlZmVyZW5jZSBjb3Vu
dGluZyBydWxlcywgYXMgd2UgY2FuIHVzZSB0aGUgaW5vZGUKPiByZWZlcmVuY2UgY291bnQgYXMg
dGhlIG1haW4gcmVmZXJlbmNlIGNvdW50IGZvciB0aGUgbmV3IHN0cnVjdAo+IGJsb2NrX2Rldmlj
ZSwgd2l0aCB0aGUgZGV2aWNlIG1vZGVsIHJlZmVyZW5jZSBmcm9udCBlbmRpbmcgaXQgZm9yIGRl
dmljZQo+IG1vZGVsIGludGVyYWN0aW9uLiAgVGhlIHBlcmNwdSByZWZjb3VudCBpbiBzdHJ1Y3Qg
aGRfc3RydWN0IGlzIGVudGlyZWx5Cj4gZ29uZSBnaXZlbiB0aGF0IHN0cnVjdCBibG9ja19kZXZp
Y2UgbXVzdCBiZSBvcGVuZWQgYW5kIHRodXMgdmFsaWQgZm9yCj4gdGhlIGR1cmF0aW9uIG9mIHRo
ZSBJL08uCj4gCj4gU2lnbmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+
Cj4gLS0tCj4gICBibG9jay9iaW8uYyAgICAgICAgICAgICAgICAgICAgICAgIHwgICA2ICstCj4g
ICBibG9jay9ibGstY2dyb3VwLmMgICAgICAgICAgICAgICAgIHwgICA5ICstCj4gICBibG9jay9i
bGstY29yZS5jICAgICAgICAgICAgICAgICAgIHwgIDg1ICsrKysrLS0tLS0KPiAgIGJsb2NrL2Js
ay1mbHVzaC5jICAgICAgICAgICAgICAgICAgfCAgIDIgKy0KPiAgIGJsb2NrL2Jsay1saWIuYyAg
ICAgICAgICAgICAgICAgICAgfCAgIDIgKy0KPiAgIGJsb2NrL2Jsay1tZXJnZS5jICAgICAgICAg
ICAgICAgICAgfCAgIDYgKy0KPiAgIGJsb2NrL2Jsay1tcS5jICAgICAgICAgICAgICAgICAgICAg
fCAgMTEgKy0KPiAgIGJsb2NrL2Jsay1tcS5oICAgICAgICAgICAgICAgICAgICAgfCAgIDUgKy0K
PiAgIGJsb2NrL2Jsay5oICAgICAgICAgICAgICAgICAgICAgICAgfCAgMzggKystLS0KPiAgIGJs
b2NrL2dlbmhkLmMgICAgICAgICAgICAgICAgICAgICAgfCAyNDIgKysrKysrKysrKystLS0tLS0t
LS0tLS0tLS0tLS0KPiAgIGJsb2NrL2lvY3RsLmMgICAgICAgICAgICAgICAgICAgICAgfCAgIDQg
Ky0KPiAgIGJsb2NrL3BhcnRpdGlvbnMvY29yZS5jICAgICAgICAgICAgfCAyMjEgKysrKysrKy0t
LS0tLS0tLS0tLS0tLS0tLS0KPiAgIGRyaXZlcnMvYmxvY2svZHJiZC9kcmJkX3JlY2VpdmVyLmMg
fCAgIDIgKy0KPiAgIGRyaXZlcnMvYmxvY2svZHJiZC9kcmJkX3dvcmtlci5jICAgfCAgIDIgKy0K
PiAgIGRyaXZlcnMvYmxvY2svenJhbS96cmFtX2Rydi5jICAgICAgfCAgIDIgKy0KPiAgIGRyaXZl
cnMvbWQvYmNhY2hlL3JlcXVlc3QuYyAgICAgICAgfCAgIDQgKy0KPiAgIGRyaXZlcnMvbWQvZG0u
YyAgICAgICAgICAgICAgICAgICAgfCAgIDggKy0KPiAgIGRyaXZlcnMvbWQvbWQuYyAgICAgICAg
ICAgICAgICAgICAgfCAgIDQgKy0KPiAgIGRyaXZlcnMvbnZtZS90YXJnZXQvYWRtaW4tY21kLmMg
ICAgfCAgMjAgKy0tCj4gICBkcml2ZXJzL3MzOTAvYmxvY2svZGFzZC5jICAgICAgICAgIHwgICA4
ICstCj4gICBmcy9ibG9ja19kZXYuYyAgICAgICAgICAgICAgICAgICAgIHwgIDY4ICsrKy0tLS0t
Cj4gICBmcy9leHQ0L3N1cGVyLmMgICAgICAgICAgICAgICAgICAgIHwgIDE4ICstLQo+ICAgZnMv
ZXh0NC9zeXNmcy5jICAgICAgICAgICAgICAgICAgICB8ICAxMCArLQo+ICAgZnMvZjJmcy9jaGVj
a3BvaW50LmMgICAgICAgICAgICAgICB8ICAgNSArLQo+ICAgZnMvZjJmcy9mMmZzLmggICAgICAg
ICAgICAgICAgICAgICB8ICAgMiArLQo+ICAgZnMvZjJmcy9zdXBlci5jICAgICAgICAgICAgICAg
ICAgICB8ICAgNiArLQo+ICAgZnMvZjJmcy9zeXNmcy5jICAgICAgICAgICAgICAgICAgICB8ICAg
OSAtLQo+ICAgaW5jbHVkZS9saW51eC9ibGtfdHlwZXMuaCAgICAgICAgICB8ICAyMyArKy0KPiAg
IGluY2x1ZGUvbGludXgvYmxrZGV2LmggICAgICAgICAgICAgfCAgMTMgKy0KPiAgIGluY2x1ZGUv
bGludXgvZ2VuaGQuaCAgICAgICAgICAgICAgfCAgNjcgKystLS0tLS0KPiAgIGluY2x1ZGUvbGlu
dXgvcGFydF9zdGF0LmggICAgICAgICAgfCAgMTcgKy0KPiAgIGluaXQvZG9fbW91bnRzLmMgICAg
ICAgICAgICAgICAgICAgfCAgMjAgKy0tCj4gICBrZXJuZWwvdHJhY2UvYmxrdHJhY2UuYyAgICAg
ICAgICAgIHwgIDU0ICsrLS0tLS0KPiAgIDMzIGZpbGVzIGNoYW5nZWQsIDM1MSBpbnNlcnRpb25z
KCspLCA2NDIgZGVsZXRpb25zKC0pCj4gClJldmlld2VkLWJ5OiBIYW5uZXMgUmVpbmVja2UgPGhh
cmVAc3VzZS5kZT4KCkNoZWVycywKCkhhbm5lcwotLSAKRHIuIEhhbm5lcyBSZWluZWNrZSAgICAg
ICAgICAgICAgICBLZXJuZWwgU3RvcmFnZSBBcmNoaXRlY3QKaGFyZUBzdXNlLmRlICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgKzQ5IDkxMSA3NDA1MyA2ODgKU1VTRSBTb2Z0d2FyZSBTb2x1
dGlvbnMgR21iSCwgTWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJnCkhSQiAzNjgwOSAoQUcg
TsO8cm5iZXJnKSwgR2VzY2jDpGZ0c2bDvGhyZXI6IEZlbGl4IEltZW5kw7ZyZmZlcgoKCi0tCmRt
LWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vd3d3LnJlZGhh
dC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==

