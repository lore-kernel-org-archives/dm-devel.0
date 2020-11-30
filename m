Return-Path: <SRS0=s6zu=FE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C740FC63777
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 07:40:05 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2B4EC20709
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 07:40:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2B4EC20709
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-ZIBlIP25MQWgCJlQJz1Arw-1; Mon, 30 Nov 2020 02:40:01 -0500
X-MC-Unique: ZIBlIP25MQWgCJlQJz1Arw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BB7011005D67;
	Mon, 30 Nov 2020 07:39:56 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A05FD5B4A0;
	Mon, 30 Nov 2020 07:39:56 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 773C64E58F;
	Mon, 30 Nov 2020 07:39:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AU7dsfb025854 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 30 Nov 2020 02:39:54 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 57677112C078; Mon, 30 Nov 2020 07:39:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 53FD5112C073
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 07:39:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 069CB8039DD
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 07:39:52 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-117-jbAw4O_QNaCg8gU7FS84pw-1;
	Mon, 30 Nov 2020 02:39:49 -0500
X-MC-Unique: jbAw4O_QNaCg8gU7FS84pw-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 691E2AD45;
	Mon, 30 Nov 2020 07:39:47 +0000 (UTC)
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20201128161510.347752-1-hch@lst.de>
	<20201128161510.347752-31-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <1c42fdb8-9c10-e5fd-e1c8-cfedc3922097@suse.de>
Date: Mon, 30 Nov 2020 08:39:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201128161510.347752-31-hch@lst.de>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0AU7dsfb025854
X-loop: dm-devel@redhat.com
Cc: linux-bcache@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
	Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>,
	linux-mm@kvack.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.com>, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
	linux-mtd@lists.infradead.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [dm-devel] [PATCH 30/45] block: remove the nr_sects field in
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMTEvMjgvMjAgNToxNCBQTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4gTm93IHRoYXQg
dGhlIGhkX3N0cnVjdCBhbHdheXMgaGFzIGEgYmxvY2sgZGV2aWNlIGF0dGFjaGVkIHRvIGl0LCB0
aGVyZSBpcwo+IG5vIG5lZWQgZm9yIGhhdmluZyB0d28gc2l6ZSBmaWVsZCB0aGF0IGp1c3QgZ2V0
IG91dCBvZiBzeW5jLgo+IAo+IEFkZGl0aW9uYWxseSB0aGUgZmllbGQgaW4gaGRfc3RydWN0IGRp
ZCBub3QgdXNlIHByb3BlciBzZXJpYWxpemF0aW9uLAo+IHBvc3NpYmx5IGFsbG93aW5nIGZvciB0
b3JuIHdyaXRlcy4gIEJ5IG9ubHkgdXNpbmcgdGhlIGJsb2NrX2RldmljZSBmaWVsZAo+IHRoaXMg
cHJvYmxlbSBhbHNvIGdldHMgZml4ZWQuCj4gCj4gU2lnbmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhl
bGx3aWcgPGhjaEBsc3QuZGU+Cj4gUmV2aWV3ZWQtYnk6IEdyZWcgS3JvYWgtSGFydG1hbiA8Z3Jl
Z2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+Cj4gQWNrZWQtYnk6IENvbHkgTGkgPGNvbHlsaUBzdXNl
LmRlPgkJCVtiY2FjaGVdCj4gQWNrZWQtYnk6IENoYW8gWXUgPHl1Y2hhbzBAaHVhd2VpLmNvbT4J
CQlbZjJmc10KPiAtLS0KPiAgIGJsb2NrL2Jpby5jICAgICAgICAgICAgICAgICAgICAgICAgfCAg
NCArLQo+ICAgYmxvY2svYmxrLWNvcmUuYyAgICAgICAgICAgICAgICAgICB8ICAyICstCj4gICBi
bG9jay9ibGsuaCAgICAgICAgICAgICAgICAgICAgICAgIHwgNTMgLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLQo+ICAgYmxvY2svZ2VuaGQuYyAgICAgICAgICAgICAgICAgICAgICB8IDU1ICsrKysrKysr
KysrLS0tLS0tLS0tLS0KPiAgIGJsb2NrL3BhcnRpdGlvbnMvY29yZS5jICAgICAgICAgICAgfCAx
NyArKysrLS0tCj4gICBkcml2ZXJzL2Jsb2NrL2xvb3AuYyAgICAgICAgICAgICAgIHwgIDEgLQo+
ICAgZHJpdmVycy9ibG9jay9uYmQuYyAgICAgICAgICAgICAgICB8ICAyICstCj4gICBkcml2ZXJz
L2Jsb2NrL3hlbi1ibGtiYWNrL2NvbW1vbi5oIHwgIDQgKy0KPiAgIGRyaXZlcnMvbWQvYmNhY2hl
L3N1cGVyLmMgICAgICAgICAgfCAgMiArLQo+ICAgZHJpdmVycy9zMzkwL2Jsb2NrL2Rhc2RfaW9j
dGwuYyAgICB8ICA0ICstCj4gICBkcml2ZXJzL3RhcmdldC90YXJnZXRfY29yZV9wc2NzaS5jIHwg
IDUgKy0KPiAgIGZzL2Jsb2NrX2Rldi5jICAgICAgICAgICAgICAgICAgICAgfCA3MyArLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KPiAgIGZzL2YyZnMvc3VwZXIuYyAgICAgICAgICAgICAg
ICAgICAgfCAgMiArLQo+ICAgZnMvcHN0b3JlL2Jsay5jICAgICAgICAgICAgICAgICAgICB8ICAy
ICstCj4gICBpbmNsdWRlL2xpbnV4L2dlbmhkLmggICAgICAgICAgICAgIHwgMjkgKysrLS0tLS0t
LS0tCj4gICBrZXJuZWwvdHJhY2UvYmxrdHJhY2UuYyAgICAgICAgICAgIHwgIDIgKy0KPiAgIDE2
IGZpbGVzIGNoYW5nZWQsIDYxIGluc2VydGlvbnMoKyksIDE5NiBkZWxldGlvbnMoLSkKPiAKUmV2
aWV3ZWQtYnk6IEhhbm5lcyBSZWluZWNrZSA8aGFyZUBzdXNlLmRlPgoKQ2hlZXJzLAoKSGFubmVz
Ci0tIApEci4gSGFubmVzIFJlaW5lY2tlICAgICAgICAgICAgICAgIEtlcm5lbCBTdG9yYWdlIEFy
Y2hpdGVjdApoYXJlQHN1c2UuZGUgICAgICAgICAgICAgICAgICAgICAgICAgICAgICArNDkgOTEx
IDc0MDUzIDY4OApTVVNFIFNvZnR3YXJlIFNvbHV0aW9ucyBHbWJILCBNYXhmZWxkc3RyLiA1LCA5
MDQwOSBOw7xybmJlcmcKSFJCIDM2ODA5IChBRyBOw7xybmJlcmcpLCBHZXNjaMOkZnRzZsO8aHJl
cjogRmVsaXggSW1lbmTDtnJmZmVyCgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVs
QHJlZGhhdC5jb20KaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRl
dmVs

