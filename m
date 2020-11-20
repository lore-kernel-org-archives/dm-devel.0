Return-Path: <SRS0=RcAx=E2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0D2FC5519F
	for <dm-devel@archiver.kernel.org>; Fri, 20 Nov 2020 07:55:52 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 20AED222BA
	for <dm-devel@archiver.kernel.org>; Fri, 20 Nov 2020 07:55:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 20AED222BA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-531-_crNXmaGMPOe-3AYUEjyuA-1; Fri, 20 Nov 2020 02:55:48 -0500
X-MC-Unique: _crNXmaGMPOe-3AYUEjyuA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0E0671842159;
	Fri, 20 Nov 2020 07:55:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B9CB15C233;
	Fri, 20 Nov 2020 07:55:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 819C61809C9F;
	Fri, 20 Nov 2020 07:55:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AK7teTQ007462 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 20 Nov 2020 02:55:41 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id CFB202026D11; Fri, 20 Nov 2020 07:55:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CA9B52026D48
	for <dm-devel@redhat.com>; Fri, 20 Nov 2020 07:55:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3EA2F811E78
	for <dm-devel@redhat.com>; Fri, 20 Nov 2020 07:55:36 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-492-3nrseLe7Nwq3xQgY8jbuHQ-1;
	Fri, 20 Nov 2020 02:55:31 -0500
X-MC-Unique: 3nrseLe7Nwq3xQgY8jbuHQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 9D32FAC23;
	Fri, 20 Nov 2020 07:55:29 +0000 (UTC)
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20201116145809.410558-1-hch@lst.de>
	<20201116145809.410558-70-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <f776dc43-0917-5d09-52a6-0d5e57914dd5@suse.de>
Date: Fri, 20 Nov 2020 08:55:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201116145809.410558-70-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0AK7teTQ007462
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
Subject: Re: [dm-devel] [PATCH 69/78] block: remove the nr_sects field in
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMTEvMTYvMjAgMzo1OCBQTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4gTm93IHRoYXQg
dGhlIGhkX3N0cnVjdCBhbHdheXMgaGFzIGEgYmxvY2sgZGV2aWNlIGF0dGFjaGVkIHRvIGl0LCB0
aGVyZSBpcwo+IG5vIG5lZWQgZm9yIGhhdmluZyB0d28gc2l6ZSBmaWVsZCB0aGF0IGp1c3QgZ2V0
IG91dCBvZiBzeW5jLgo+IAo+IEFkZGl0aW9uYWwgdGhlIGZpZWxkIGluIGhkX3N0cnVjdCBkaWQg
bm90IHVzZSBwcm9wZXIgc2VyaWFsaXppYXRpb24sCj4gcG9zc2libHkgYWxsb3dpbmcgZm9yIHRv
cm4gd3JpdGVzLiAgQnkgb25seSB1c2luZyB0aGUgYmxvY2tfZGV2aWNlIGZpZWxkCj4gdGhpcyBw
cm9ibGVtIGFsc28gZ2V0cyBmaXhlZC4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVs
bHdpZyA8aGNoQGxzdC5kZT4KPiAtLS0KPiAgIGJsb2NrL2Jpby5jICAgICAgICAgICAgICAgICAg
ICAgICAgfCAgMiArLQo+ICAgYmxvY2svYmxrLWNvcmUuYyAgICAgICAgICAgICAgICAgICB8ICAy
ICstCj4gICBibG9jay9ibGsuaCAgICAgICAgICAgICAgICAgICAgICAgIHwgNTMgLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLQo+ICAgYmxvY2svZ2VuaGQuYyAgICAgICAgICAgICAgICAgICAgICB8IDM0
ICsrKysrKystLS0tLS0tCj4gICBibG9jay9wYXJ0aXRpb25zL2NvcmUuYyAgICAgICAgICAgIHwg
MTcgKysrKy0tLQo+ICAgZHJpdmVycy9ibG9jay9sb29wLmMgICAgICAgICAgICAgICB8ICAxIC0K
PiAgIGRyaXZlcnMvYmxvY2svbmJkLmMgICAgICAgICAgICAgICAgfCAgMiArLQo+ICAgZHJpdmVy
cy9ibG9jay94ZW4tYmxrYmFjay9jb21tb24uaCB8ICA0ICstCj4gICBkcml2ZXJzL21kL2JjYWNo
ZS9zdXBlci5jICAgICAgICAgIHwgIDIgKy0KPiAgIGRyaXZlcnMvczM5MC9ibG9jay9kYXNkX2lv
Y3RsLmMgICAgfCAgNCArLQo+ICAgZHJpdmVycy90YXJnZXQvdGFyZ2V0X2NvcmVfcHNjc2kuYyB8
ICA3ICstLQo+ICAgZnMvYmxvY2tfZGV2LmMgICAgICAgICAgICAgICAgICAgICB8IDczICstLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQo+ICAgZnMvZjJmcy9zdXBlci5jICAgICAgICAgICAg
ICAgICAgICB8ICAyICstCj4gICBmcy9wc3RvcmUvYmxrLmMgICAgICAgICAgICAgICAgICAgIHwg
IDIgKy0KPiAgIGluY2x1ZGUvbGludXgvZ2VuaGQuaCAgICAgICAgICAgICAgfCAyOSArKystLS0t
LS0tLS0KPiAgIGtlcm5lbC90cmFjZS9ibGt0cmFjZS5jICAgICAgICAgICAgfCAgMiArLQo+ICAg
MTYgZmlsZXMgY2hhbmdlZCwgNDcgaW5zZXJ0aW9ucygrKSwgMTg5IGRlbGV0aW9ucygtKQo+IApS
ZXZpZXdlZC1ieTogSGFubmVzIFJlaW5lY2tlIDxoYXJlQHN1c2UuZGU+CgpDaGVlcnMsCgpIYW5u
ZXMKLS0gCkRyLiBIYW5uZXMgUmVpbmVja2UgICAgICAgICAgICAgICAgS2VybmVsIFN0b3JhZ2Ug
QXJjaGl0ZWN0CmhhcmVAc3VzZS5kZSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICs0OSA5
MTEgNzQwNTMgNjg4ClNVU0UgU29mdHdhcmUgU29sdXRpb25zIEdtYkgsIE1heGZlbGRzdHIuIDUs
IDkwNDA5IE7DvHJuYmVyZwpIUkIgMzY4MDkgKEFHIE7DvHJuYmVyZyksIEdlc2Now6RmdHNmw7xo
cmVyOiBGZWxpeCBJbWVuZMO2cmZmZXIKCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2
ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0t
ZGV2ZWw=

