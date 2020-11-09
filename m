Return-Path: <SRS0=SKY2=EP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAB30C2D0A3
	for <dm-devel@archiver.kernel.org>; Mon,  9 Nov 2020 08:07:27 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 48CF02084C
	for <dm-devel@archiver.kernel.org>; Mon,  9 Nov 2020 08:07:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 48CF02084C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-28-gbGC2kjVMsO8BMASUC8CMA-1; Mon, 09 Nov 2020 03:07:24 -0500
X-MC-Unique: gbGC2kjVMsO8BMASUC8CMA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4435487950F;
	Mon,  9 Nov 2020 08:07:20 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 027D9619C4;
	Mon,  9 Nov 2020 08:07:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C5197CF63;
	Mon,  9 Nov 2020 08:07:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A97sA6p013618 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 9 Nov 2020 02:54:11 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D1B181111437; Mon,  9 Nov 2020 07:54:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CD5631111436
	for <dm-devel@redhat.com>; Mon,  9 Nov 2020 07:54:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 65E551021F85
	for <dm-devel@redhat.com>; Mon,  9 Nov 2020 07:54:08 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-274-SbZecy2sPoy1JJ2vsU7_bg-1;
	Mon, 09 Nov 2020 02:54:02 -0500
X-MC-Unique: SbZecy2sPoy1JJ2vsU7_bg-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id E44CAABAE;
	Mon,  9 Nov 2020 07:53:59 +0000 (UTC)
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20201106190337.1973127-1-hch@lst.de>
	<20201106190337.1973127-4-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <1d06cdfa-a904-30be-f3ec-08ae2fa85cbd@suse.de>
Date: Mon, 9 Nov 2020 08:53:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201106190337.1973127-4-hch@lst.de>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0A97sA6p013618
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 09 Nov 2020 03:07:00 -0500
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMTEvNi8yMCA4OjAzIFBNLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToKPiBUaGVyZSBpcyBu
byBnb29kIHJlYXNvbiB0byBjYWxsIHJldmFsaWRhdGVfZGlza19zaXplIHNlcGFyYXRlbHkuCj4g
Cj4gU2lnbmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+Cj4gLS0tCj4g
ICBkcml2ZXJzL252bWUvaG9zdC9jb3JlLmMgfCA1ICstLS0tCj4gICAxIGZpbGUgY2hhbmdlZCwg
MSBpbnNlcnRpb24oKyksIDQgZGVsZXRpb25zKC0pCj4gCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bnZtZS9ob3N0L2NvcmUuYyBiL2RyaXZlcnMvbnZtZS9ob3N0L2NvcmUuYwo+IGluZGV4IDM3NjA5
NmJmYzU0YTgzLi40ZTg2YzlhYWZkODhhNyAxMDA2NDQKPiAtLS0gYS9kcml2ZXJzL252bWUvaG9z
dC9jb3JlLmMKPiArKysgYi9kcml2ZXJzL252bWUvaG9zdC9jb3JlLmMKPiBAQCAtMjA1Myw3ICsy
MDUzLDcgQEAgc3RhdGljIHZvaWQgbnZtZV91cGRhdGVfZGlza19pbmZvKHN0cnVjdCBnZW5kaXNr
ICpkaXNrLAo+ICAgCQkJY2FwYWNpdHkgPSAwOwo+ICAgCX0KPiAgIAo+IC0Jc2V0X2NhcGFjaXR5
X3JldmFsaWRhdGVfYW5kX25vdGlmeShkaXNrLCBjYXBhY2l0eSwgZmFsc2UpOwo+ICsJc2V0X2Nh
cGFjaXR5X3JldmFsaWRhdGVfYW5kX25vdGlmeShkaXNrLCBjYXBhY2l0eSwgdHJ1ZSk7Cj4gICAK
PiAgIAludm1lX2NvbmZpZ19kaXNjYXJkKGRpc2ssIG5zKTsKPiAgIAludm1lX2NvbmZpZ193cml0
ZV96ZXJvZXMoZGlzaywgbnMpOwo+IEBAIC0yMTM2LDcgKzIxMzYsNiBAQCBzdGF0aWMgaW50IG52
bWVfdXBkYXRlX25zX2luZm8oc3RydWN0IG52bWVfbnMgKm5zLCBzdHJ1Y3QgbnZtZV9pZF9ucyAq
aWQpCj4gICAJCWJsa19zdGFja19saW1pdHMoJm5zLT5oZWFkLT5kaXNrLT5xdWV1ZS0+bGltaXRz
LAo+ICAgCQkJCSAmbnMtPnF1ZXVlLT5saW1pdHMsIDApOwo+ICAgCQlibGtfcXVldWVfdXBkYXRl
X3JlYWRhaGVhZChucy0+aGVhZC0+ZGlzay0+cXVldWUpOwo+IC0JCW52bWVfdXBkYXRlX2JkZXZf
c2l6ZShucy0+aGVhZC0+ZGlzayk7Cj4gICAJCWJsa19tcV91bmZyZWV6ZV9xdWV1ZShucy0+aGVh
ZC0+ZGlzay0+cXVldWUpOwo+ICAgCX0KPiAgICNlbmRpZgoKSG9sZCBvbi4KVGhpcywgYXQgdGhl
IHZlcnkgbGVhc3QsIHNob3VsZCBiZSBhIHNlcGFyYXRlIHBhdGNoLgpXaXRoIHRoaXMgeW91IGFy
ZSBjaGFuZ2luZyB0aGUgYmVoYXZpb3VyIG9mIG52bWUgbXVsdGlwYXRoLgoKT3JpZ2luYWxseSBu
dm1lIG11bHRpcGF0aCB3b3VsZCB1cGRhdGUvY2hhbmdlIHRoZSBzaXplIG9mIHRoZSBtdWx0aXBh
dGggCmRldmljZSBhY2NvcmRpbmcgdG8gdGhlIHVuZGVybHlpbmcgcGF0aCBkZXZpY2VzLgpXaXRo
IHRoaXMgcGF0Y2ggdGhlIHNpemUgb2YgdGhlIG11bHRpcGF0aCBkZXZpY2Ugd2lsbCBfbm90XyBj
aGFuZ2UgaWYgCnRoZXJlIGlzIGEgY2hhbmdlIG9uIHRoZSB1bmRlcmx5aW5nIGRldmljZXMuCgpX
aGlsZSBwZXJzb25hbGx5IEkgd291bGQgX2xvdmVfIHRvIGhhdmUgdGhpcyBwYXRjaCwgd2Ugc2hv
dWxkIGF0IGxlYXN0IApkb2N1bWVudCB0aGlzIGJ5IG1ha2luZyBpdCBhIHNlcGFyYXRlIHBhdGNo
LgpBbmQgd2UgcG9zc2libHkgc2hvdWxkIGNoZWNrIGlmIGJvdGggc2l6ZXMgYXJlIHRoZSBzYW1l
LCBhbmQgdGhpbmsgb2YgCndoYXQgd2Ugc2hvdWxkIGJlIGRvaW5nIGlmIHRoZXkgYXJlIG5vdC4K
CkNoZWVycywKCkhhbm5lcwotLSAKRHIuIEhhbm5lcyBSZWluZWNrZSAgICAgICAgICAgICAgICBL
ZXJuZWwgU3RvcmFnZSBBcmNoaXRlY3QKaGFyZUBzdXNlLmRlICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgKzQ5IDkxMSA3NDA1MyA2ODgKU1VTRSBTb2Z0d2FyZSBTb2x1dGlvbnMgR21iSCwg
TWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJnCkhSQiAzNjgwOSAoQUcgTsO8cm5iZXJnKSwg
R2VzY2jDpGZ0c2bDvGhyZXI6IEZlbGl4IEltZW5kw7ZyZmZlcgoKCi0tCmRtLWRldmVsIG1haWxp
bmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1h
bi9saXN0aW5mby9kbS1kZXZlbA==

