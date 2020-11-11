Return-Path: <SRS0=f+1/=ER=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72D8FC388F9
	for <dm-devel@archiver.kernel.org>; Wed, 11 Nov 2020 18:45:50 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9AB9920659
	for <dm-devel@archiver.kernel.org>; Wed, 11 Nov 2020 18:45:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9AB9920659
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-455-czgb4D9cNwyC-u71rwQy-A-1; Wed, 11 Nov 2020 13:45:46 -0500
X-MC-Unique: czgb4D9cNwyC-u71rwQy-A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D7F3010866B5;
	Wed, 11 Nov 2020 18:45:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B4EAC46;
	Wed, 11 Nov 2020 18:45:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8D57758103;
	Wed, 11 Nov 2020 18:45:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0ABDxnck011826 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 11 Nov 2020 08:59:50 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D2B83202278F; Wed, 11 Nov 2020 13:59:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CDD9A2022792
	for <dm-devel@redhat.com>; Wed, 11 Nov 2020 13:59:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 542791823601
	for <dm-devel@redhat.com>; Wed, 11 Nov 2020 13:59:46 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-137-yp_rcQrcNVixPYH6YPe_Zg-1;
	Wed, 11 Nov 2020 08:59:40 -0500
X-MC-Unique: yp_rcQrcNVixPYH6YPe_Zg-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 8ABF3ABD6;
	Wed, 11 Nov 2020 13:59:37 +0000 (UTC)
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20201111082658.3401686-1-hch@lst.de>
	<20201111082658.3401686-16-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <878d9852-4b8d-c5a7-36d4-0fda80fd74c4@suse.de>
Date: Wed, 11 Nov 2020 14:59:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201111082658.3401686-16-hch@lst.de>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0ABDxnck011826
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 11 Nov 2020 13:39:49 -0500
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
Subject: Re: [dm-devel] [PATCH 15/24] nvme: use set_capacity_and_notify in
 nvme_set_queue_dying
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

T24gMTEvMTEvMjAgOToyNiBBTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4gVXNlIHRoZSBi
bG9jayBsYXllciBoZWxwZXIgdG8gdXBkYXRlIGJvdGggdGhlIGRpc2sgYW5kIGJsb2NrIGRldmlj
ZQo+IHNpemVzLiAgQ29udHJhcnkgdG8gdGhlIG5hbWUgbm8gbm90aWZpY2F0aW9uIGlzIHNlbnQg
aW4gdGhpcyBjYXNlLAo+IGFzIGEgc2l6ZSAwIGlzIHNwZWNpYWwgY2FzZWQuCj4gCj4gU2lnbmVk
LW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+Cj4gLS0tCj4gICBkcml2ZXJz
L252bWUvaG9zdC9jb3JlLmMgfCAxMyArLS0tLS0tLS0tLS0tCj4gICAxIGZpbGUgY2hhbmdlZCwg
MSBpbnNlcnRpb24oKyksIDEyIGRlbGV0aW9ucygtKQo+IApSZXZpZXdlZC1ieTogSGFubmVzIFJl
aW5lY2tlIDxoYXJlQHN1c2UuZGU+CgpDaGVlcnMsCgpIYW5uZXMKLS0gCkRyLiBIYW5uZXMgUmVp
bmVja2UgICAgICAgICAgICAgICAgS2VybmVsIFN0b3JhZ2UgQXJjaGl0ZWN0CmhhcmVAc3VzZS5k
ZSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICs0OSA5MTEgNzQwNTMgNjg4ClNVU0UgU29m
dHdhcmUgU29sdXRpb25zIEdtYkgsIE1heGZlbGRzdHIuIDUsIDkwNDA5IE7DvHJuYmVyZwpIUkIg
MzY4MDkgKEFHIE7DvHJuYmVyZyksIEdlc2Now6RmdHNmw7xocmVyOiBGZWxpeCBJbWVuZMO2cmZm
ZXIKCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczov
L3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=

