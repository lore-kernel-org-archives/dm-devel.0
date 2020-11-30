Return-Path: <SRS0=s6zu=FE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C8E2C64E8A
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 07:56:12 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B1FAC20709
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 07:56:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B1FAC20709
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-2-7qCNE7VhO8OPaJnK2izBMA-1; Mon, 30 Nov 2020 02:55:02 -0500
X-MC-Unique: 7qCNE7VhO8OPaJnK2izBMA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 52AC7185E4B2;
	Mon, 30 Nov 2020 07:54:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 38F7560C62;
	Mon, 30 Nov 2020 07:54:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 118A74EBC6;
	Mon, 30 Nov 2020 07:54:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AU7pVwG027033 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 30 Nov 2020 02:51:32 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D8CC420296A8; Mon, 30 Nov 2020 07:51:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D28B02026D49
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 07:51:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 63C9D811E76
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 07:51:29 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-187-Q4YRsjV0OgetO1IFt1_Llg-1;
	Mon, 30 Nov 2020 02:51:26 -0500
X-MC-Unique: Q4YRsjV0OgetO1IFt1_Llg-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 06B55AC55;
	Mon, 30 Nov 2020 07:51:25 +0000 (UTC)
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20201128161510.347752-1-hch@lst.de>
	<20201128161510.347752-45-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <75432706-8726-2c86-a080-40c45e6144c3@suse.de>
Date: Mon, 30 Nov 2020 08:51:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201128161510.347752-45-hch@lst.de>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0AU7pVwG027033
X-loop: dm-devel@redhat.com
Cc: linux-bcache@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Mike Snitzer <snitzer@redhat.com>, linux-mm@kvack.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.com>, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
	linux-mtd@lists.infradead.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [dm-devel] [PATCH 44/45] block: merge struct block_device and
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMTEvMjgvMjAgNToxNSBQTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4gSW5zdGVhZCBv
ZiBoYXZpbmcgdHdvIHN0cnVjdHVyZXMgdGhhdCByZXByZXNlbnQgZWFjaCBibG9jayBkZXZpY2Ug
d2l0aAo+IGRpZmZlcmVudCBsaWZlIHRpbWUgcnVsZXMsIG1lcmdlIHRoZW0gaW50byBhIHNpbmds
ZSBvbmUuICBUaGlzIGFsc28KPiBncmVhdGx5IHNpbXBsaWZpZXMgdGhlIHJlZmVyZW5jZSBjb3Vu
dGluZyBydWxlcywgYXMgd2UgY2FuIHVzZSB0aGUgaW5vZGUKPiByZWZlcmVuY2UgY291bnQgYXMg
dGhlIG1haW4gcmVmZXJlbmNlIGNvdW50IGZvciB0aGUgbmV3IHN0cnVjdAo+IGJsb2NrX2Rldmlj
ZSwgd2l0aCB0aGUgZGV2aWNlIG1vZGVsIHJlZmVyZW5jZSBmcm9udCBlbmRpbmcgaXQgZm9yIGRl
dmljZQo+IG1vZGVsIGludGVyYWN0aW9uLgo+IAo+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBI
ZWxsd2lnIDxoY2hAbHN0LmRlPgo+IC0tLQo+ICAgYmxvY2svYmxrLWNncm91cC5jICAgICAgICB8
ICAgOSArKy0KPiAgIGJsb2NrL2Jsay5oICAgICAgICAgICAgICAgfCAgIDIgKy0KPiAgIGJsb2Nr
L2dlbmhkLmMgICAgICAgICAgICAgfCAgODkgKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tLS0K
PiAgIGJsb2NrL3BhcnRpdGlvbnMvY29yZS5jICAgfCAxMTYgKysrKysrKysrKysrKysrLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0KPiAgIGZzL2Jsb2NrX2Rldi5jICAgICAgICAgICAgfCAgIDkgLS0t
Cj4gICBpbmNsdWRlL2xpbnV4L2Jsa190eXBlcy5oIHwgICA4ICsrLQo+ICAgaW5jbHVkZS9saW51
eC9ibGtkZXYuaCAgICB8ICAgMSAtCj4gICBpbmNsdWRlL2xpbnV4L2dlbmhkLmggICAgIHwgIDQw
ICsrKy0tLS0tLS0tLS0KPiAgIGluaXQvZG9fbW91bnRzLmMgICAgICAgICAgfCAgMjEgKysrKy0t
LQo+ICAga2VybmVsL3RyYWNlL2Jsa3RyYWNlLmMgICB8ICA0MyArKystLS0tLS0tLS0tLQo+ICAg
MTAgZmlsZXMgY2hhbmdlZCwgMTA4IGluc2VydGlvbnMoKyksIDIzMCBkZWxldGlvbnMoLSkKPiAK
UmV2aWV3ZWQtYnk6IEhhbm5lcyBSZWluZWNrZSA8aGFyZUBzdXNlLmRlPgoKQ2hlZXJzLAoKSGFu
bmVzCi0tIApEci4gSGFubmVzIFJlaW5lY2tlICAgICAgICAgICAgICAgIEtlcm5lbCBTdG9yYWdl
IEFyY2hpdGVjdApoYXJlQHN1c2UuZGUgICAgICAgICAgICAgICAgICAgICAgICAgICAgICArNDkg
OTExIDc0MDUzIDY4OApTVVNFIFNvZnR3YXJlIFNvbHV0aW9ucyBHbWJILCBNYXhmZWxkc3RyLiA1
LCA5MDQwOSBOw7xybmJlcmcKSFJCIDM2ODA5IChBRyBOw7xybmJlcmcpLCBHZXNjaMOkZnRzZsO8
aHJlcjogRmVsaXggSW1lbmTDtnJmZmVyCgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRl
dmVsQHJlZGhhdC5jb20KaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2Rt
LWRldmVs

