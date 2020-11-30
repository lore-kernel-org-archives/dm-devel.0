Return-Path: <SRS0=s6zu=FE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C94DC5519F
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 07:39:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C5D3120709
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 07:39:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C5D3120709
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-449-pXcQV1qXMHKG1E-j-gAjDg-1; Mon, 30 Nov 2020 02:39:47 -0500
X-MC-Unique: pXcQV1qXMHKG1E-j-gAjDg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9A648802B42;
	Mon, 30 Nov 2020 07:39:42 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 508675D6AB;
	Mon, 30 Nov 2020 07:39:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2646E4A7C7;
	Mon, 30 Nov 2020 07:39:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AU7bGBi025507 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 30 Nov 2020 02:37:16 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1136A20296A8; Mon, 30 Nov 2020 07:37:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0A233200A4F0
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 07:37:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C263A103B80A
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 07:37:09 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-329-MjEl8dPUNlSwu6tizzasTA-1;
	Mon, 30 Nov 2020 02:37:04 -0500
X-MC-Unique: MjEl8dPUNlSwu6tizzasTA-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 107DDACC0;
	Mon, 30 Nov 2020 07:37:03 +0000 (UTC)
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20201128161510.347752-1-hch@lst.de>
	<20201128161510.347752-27-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <4b0799bd-ef77-5068-6957-04061b3f61ee@suse.de>
Date: Mon, 30 Nov 2020 08:37:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201128161510.347752-27-hch@lst.de>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0AU7bGBi025507
X-loop: dm-devel@redhat.com
Cc: linux-bcache@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Mike Snitzer <snitzer@redhat.com>, linux-mm@kvack.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.com>, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
	linux-mtd@lists.infradead.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [dm-devel] [PATCH 26/45] block: remove ->bd_contains
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

T24gMTEvMjgvMjAgNToxNCBQTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4gTm93IHRoYXQg
ZWFjaCBoZF9zdHJ1Y3QgaGFzIGEgcmVmZXJlbmNlIHRvIHRoZSBjb3JyZXNwb25kaW5nCj4gYmxv
Y2tfZGV2aWNlLCB0aGVyZSBpcyBubyBuZWVkIGZvciB0aGUgYmRfY29udGFpbnMgcG9pbnRlci4g
IEFkZAo+IGEgYmRldl93aG9sZSgpIGhlbHBlciB0byBsb29rIHVwIHRoZSB3aG9sZSBkZXZpY2Ug
YmxvY2tfZGV2aWNlCj4gc3RydXR1cmUgaW5zdGVhZC4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBDaHJp
c3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4KPiBSZXZpZXdlZC1ieTogR3JlZyBLcm9haC1IYXJ0
bWFuIDxncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZz4KPiBSZXZpZXdlZC1ieTogSmFuIEthcmEg
PGphY2tAc3VzZS5jej4KPiBBY2tlZC1ieTogVGVqdW4gSGVvIDx0akBrZXJuZWwub3JnPgo+IC0t
LQo+ICAgZHJpdmVycy9ibG9jay9sb29wLmMgICAgICB8ICAyICstCj4gICBkcml2ZXJzL3Njc2kv
c2NzaWNhbS5jICAgIHwgIDIgKy0KPiAgIGZzL2Jsb2NrX2Rldi5jICAgICAgICAgICAgfCAyMiAr
KysrKysrKy0tLS0tLS0tLS0tLS0tCj4gICBpbmNsdWRlL2xpbnV4L2Jsa190eXBlcy5oIHwgIDQg
KysrLQo+ICAgNCBmaWxlcyBjaGFuZ2VkLCAxMyBpbnNlcnRpb25zKCspLCAxNyBkZWxldGlvbnMo
LSkKPiAKUmV2aWV3ZWQtYnk6IEhhbm5lcyBSZWluZWNrZSA8aGFyZUBzdXNlLmRlPgoKQ2hlZXJz
LAoKSGFubmVzCi0tIApEci4gSGFubmVzIFJlaW5lY2tlICAgICAgICAgICAgICAgIEtlcm5lbCBT
dG9yYWdlIEFyY2hpdGVjdApoYXJlQHN1c2UuZGUgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICArNDkgOTExIDc0MDUzIDY4OApTVVNFIFNvZnR3YXJlIFNvbHV0aW9ucyBHbWJILCBNYXhmZWxk
c3RyLiA1LCA5MDQwOSBOw7xybmJlcmcKSFJCIDM2ODA5IChBRyBOw7xybmJlcmcpLCBHZXNjaMOk
ZnRzZsO8aHJlcjogRmVsaXggSW1lbmTDtnJmZmVyCgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0
CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3Rp
bmZvL2RtLWRldmVs

