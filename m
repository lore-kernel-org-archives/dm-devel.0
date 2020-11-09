Return-Path: <SRS0=xkgx=EQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BC8FC55ABD
	for <dm-devel@archiver.kernel.org>; Tue, 10 Nov 2020 07:55:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 76F0C20870
	for <dm-devel@archiver.kernel.org>; Tue, 10 Nov 2020 07:55:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 76F0C20870
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-382-GaYCyLWWMZuG1OOb3sdzLw-1; Tue, 10 Nov 2020 02:55:15 -0500
X-MC-Unique: GaYCyLWWMZuG1OOb3sdzLw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C61F056C91;
	Tue, 10 Nov 2020 07:55:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A583E75136;
	Tue, 10 Nov 2020 07:55:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6308F180B658;
	Tue, 10 Nov 2020 07:55:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A99PVlL027052 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 9 Nov 2020 04:25:32 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D77A75D220; Mon,  9 Nov 2020 09:25:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D218D5D227
	for <dm-devel@redhat.com>; Mon,  9 Nov 2020 09:25:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EA6A390E423
	for <dm-devel@redhat.com>; Mon,  9 Nov 2020 09:25:28 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-449-gtOR4N4bM5yfy9c0vr4LAA-1;
	Mon, 09 Nov 2020 04:25:26 -0500
X-MC-Unique: gtOR4N4bM5yfy9c0vr4LAA-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id CA23CABCC;
	Mon,  9 Nov 2020 09:25:23 +0000 (UTC)
To: Christoph Hellwig <hch@lst.de>
References: <20201106190337.1973127-1-hch@lst.de>
	<20201106190337.1973127-4-hch@lst.de>
	<1d06cdfa-a904-30be-f3ec-08ae2fa85cbd@suse.de>
	<20201109085340.GB27483@lst.de>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <e79f9a96-ef53-d6ea-f6e7-e141bdd2e2d2@suse.de>
Date: Mon, 9 Nov 2020 10:25:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201109085340.GB27483@lst.de>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0A99PVlL027052
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMTEvOS8yMCA5OjUzIEFNLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToKPiBPbiBNb24sIE5v
diAwOSwgMjAyMCBhdCAwODo1Mzo1OEFNICswMTAwLCBIYW5uZXMgUmVpbmVja2Ugd3JvdGU6Cj4+
PiBpbmRleCAzNzYwOTZiZmM1NGE4My4uNGU4NmM5YWFmZDg4YTcgMTAwNjQ0Cj4+PiAtLS0gYS9k
cml2ZXJzL252bWUvaG9zdC9jb3JlLmMKPj4+ICsrKyBiL2RyaXZlcnMvbnZtZS9ob3N0L2NvcmUu
Ywo+Pj4gQEAgLTIwNTMsNyArMjA1Myw3IEBAIHN0YXRpYyB2b2lkIG52bWVfdXBkYXRlX2Rpc2tf
aW5mbyhzdHJ1Y3QgZ2VuZGlzayAqZGlzaywKPj4+ICAgIAkJCWNhcGFjaXR5ID0gMDsKWyAuLiBd
Cj4+IE9yaWdpbmFsbHkgbnZtZSBtdWx0aXBhdGggd291bGQgdXBkYXRlL2NoYW5nZSB0aGUgc2l6
ZSBvZiB0aGUgbXVsdGlwYXRoCj4+IGRldmljZSBhY2NvcmRpbmcgdG8gdGhlIHVuZGVybHlpbmcg
cGF0aCBkZXZpY2VzLgo+PiBXaXRoIHRoaXMgcGF0Y2ggdGhlIHNpemUgb2YgdGhlIG11bHRpcGF0
aCBkZXZpY2Ugd2lsbCBfbm90XyBjaGFuZ2UgaWYgdGhlcmUKPj4gaXMgYSBjaGFuZ2Ugb24gdGhl
IHVuZGVybHlpbmcgZGV2aWNlcy4KPiAKPiBZZXMsIGl0IHdpbGwuICBUYWtlIGEgY2xvc2UgbG9v
ayBhdCBudm1lX3VwZGF0ZV9kaXNrX2luZm8gYW5kIGhvdyBpdCBpcwo+IGNhbGxlZC4KPiAKT2th
eSwgdGhlbjogV2hhdCB3b3VsZCBiZSB0aGUgY29ycmVjdCB3YXkgb2YgaGFuZGxpbmcgYSBzaXpl
IHVwZGF0ZSBmb3IgCk5WTWUgbXVsdGlwYXRoPwpBc3N1bWluZyB3ZSdyZSBnZXR0aW5nIGFuIEFF
TiBmb3IgZWFjaCBwYXRoIHNpZ25hbGxpbmcgdGhlIHNpemUgY2hhbmdlCihvciBhIGNvbnRyb2xs
ZXIgcmVzZXQgbGVhZGluZyB0byBhIHNpemUgY2hhbmdlKS4KU28gaWYgd2UncmUgdXBkYXRpbmcg
dGhlIHNpemUgb2YgdGhlIG11bHRpcGF0aCBkZXZpY2UgdG9nZXRoZXIgd2l0aCB0aGUgCnBhdGgg
ZGV2aWNlIGF0IHRoZSBmaXJzdCBBRU4vcmVzZXQgd2UnbGwgZW5kIHVwIHdpdGggdGhlIG90aGVy
IHBhdGhzIApoYXZpbmcgYSBkaWZmZXJlbnQgc2l6ZSB0aGFuIHRoZSBtdWx0aXBhdGggZGV2aWNl
IChhbmQgdGhlIHBhdGggd2UndmUgCmp1c3QgYmVlbiB1cGRhdGluZykuCi0gRG8gd2UgY2FyZSwg
b3IgY3Jvc3MgZmluZ2VycyBhbmQgaG9wZSBmb3IgdGhlIGJlc3Q/Ci0gU2hvdWxkbid0IHdlIGRl
dGVjdCB0aGUgY2FzZSB3aGVyZSB3ZSB3b24ndCBnZXQgYSBzaXplIHVwZGF0ZSBmb3IgdGhlIApv
dGhlciBwYXRocywgb3IsIGluZGVlZCwgd2UgaGF2ZSBhIGdlbnVpbmUgZGV2aWNlIHNpemUgbWlz
bWF0Y2ggZHVlIHRvIGEgCm1pc2NvbmZpZ3VyYXRpb24gb24gdGhlIHRhcmdldD8KCklFIHNob3Vs
ZG4ndCB3ZSBoYXZlIGEgZmxhZyAnc2l6ZSB1cGRhdGUgcGVuZGluZycgZm9yIHRoZSBvdGhlciBw
YXRocywsIAp0byB0YWtlIHRoZW0gb3V0IG91ZiB1c2UgdGVtcG9yYXJpbHkgdW50aWwgdGhlIG90
aGVyIEFFTnMvcmVzZXRzIGhhdmUgCmJlZW4gcHJvY2Vzc2VkPwoKQ2hlZXJzLAoKSGFubmVzCi0t
IApEci4gSGFubmVzIFJlaW5lY2tlICAgICAgICAgICAgICAgIEtlcm5lbCBTdG9yYWdlIEFyY2hp
dGVjdApoYXJlQHN1c2UuZGUgICAgICAgICAgICAgICAgICAgICAgICAgICAgICArNDkgOTExIDc0
MDUzIDY4OApTVVNFIFNvZnR3YXJlIFNvbHV0aW9ucyBHbWJILCBNYXhmZWxkc3RyLiA1LCA5MDQw
OSBOw7xybmJlcmcKSFJCIDM2ODA5IChBRyBOw7xybmJlcmcpLCBHZXNjaMOkZnRzZsO8aHJlcjog
RmVsaXggSW1lbmTDtnJmZmVyCgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJl
ZGhhdC5jb20KaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs

