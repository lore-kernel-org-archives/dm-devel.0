Return-Path: <SRS0=6Nrr=JT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED9ACC433ED
	for <dm-devel@archiver.kernel.org>; Thu, 22 Apr 2021 13:19:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2506361435
	for <dm-devel@archiver.kernel.org>; Thu, 22 Apr 2021 13:19:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2506361435
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-580-lDoRAnEFOR2lVqBAD3I7xA-1; Thu, 22 Apr 2021 09:19:10 -0400
X-MC-Unique: lDoRAnEFOR2lVqBAD3I7xA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF0491028D12;
	Thu, 22 Apr 2021 13:18:37 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0439417C0B;
	Thu, 22 Apr 2021 13:18:37 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 49B721806D0F;
	Thu, 22 Apr 2021 13:18:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13MDIYsV025618 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 22 Apr 2021 09:18:34 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 0BEA0107132; Thu, 22 Apr 2021 13:18:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 07A809E7B
	for <dm-devel@redhat.com>; Thu, 22 Apr 2021 13:18:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 19D58104F0A9
	for <dm-devel@redhat.com>; Thu, 22 Apr 2021 13:18:31 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-375-65P42awLPYOOVOsak4lMqw-1;
	Thu, 22 Apr 2021 09:18:26 -0400
X-MC-Unique: 65P42awLPYOOVOsak4lMqw-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 1A754B133;
	Thu, 22 Apr 2021 13:18:25 +0000 (UTC)
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
References: <20210422122038.2192933-1-ming.lei@redhat.com>
	<20210422122038.2192933-3-ming.lei@redhat.com>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <2ae12dc1-804f-59f9-6837-3508d6176804@suse.de>
Date: Thu, 22 Apr 2021 15:18:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210422122038.2192933-3-ming.lei@redhat.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 13MDIYsV025618
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, Jeffle Xu <jefflexu@linux.alibaba.com>,
	dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>,
	Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm-devel] [PATCH V6 02/12] block: define 'struct bvec_iter' as
	packed
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
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

T24gNC8yMi8yMSAyOjIwIFBNLCBNaW5nIExlaSB3cm90ZToKPiAnc3RydWN0IGJ2ZWNfaXRlcicg
aXMgZW1iZWRkZWQgaW50byAnc3RydWN0IGJpbycsIGRlZmluZSBpdCBhcyBwYWNrZWQKPiBzbyB0
aGF0IHdlIGNhbiBnZXQgb25lIGV4dHJhIDRieXRlcyBmb3Igb3RoZXIgdXNlcyB3aXRob3V0IGV4
cGFuZGluZwo+IGJpby4KPiAKPiAnc3RydWN0IGJ2ZWNfaXRlcicgaXMgb2Z0ZW4gYWxsb2NhdGVk
IG9uIHN0YWNrLCBzbyBtYWtpbmcgaXQgcGFja2VkCj4gZG9lc24ndCBhZmZlY3QgcGVyZm9ybWFu
Y2UuIEFsc28gSSBoYXZlIHJ1biBpb191cmluZyBvbiBib3RoCj4gbnZtZS9udWxsX2JsaywgYW5k
IG5vdCBvYnNlcnZlIHBlcmZvcm1hbmNlIGVmZmVjdCBpbiB0aGlzIHdheS4KPiAKPiBTdWdnZXN0
ZWQtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPgo+IFNpZ25lZC1vZmYtYnk6IE1p
bmcgTGVpIDxtaW5nLmxlaUByZWRoYXQuY29tPgo+IC0tLQo+ICAgaW5jbHVkZS9saW51eC9idmVj
LmggfCAyICstCj4gICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24o
LSkKPiAKPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9idmVjLmggYi9pbmNsdWRlL2xpbnV4
L2J2ZWMuaAo+IGluZGV4IGZmODMyZTY5OGVmYi4uYTBjNGY0MWRmYzgzIDEwMDY0NAo+IC0tLSBh
L2luY2x1ZGUvbGludXgvYnZlYy5oCj4gKysrIGIvaW5jbHVkZS9saW51eC9idmVjLmgKPiBAQCAt
NDMsNyArNDMsNyBAQCBzdHJ1Y3QgYnZlY19pdGVyIHsKPiAgIAo+ICAgCXVuc2lnbmVkIGludCAg
ICAgICAgICAgIGJpX2J2ZWNfZG9uZTsJLyogbnVtYmVyIG9mIGJ5dGVzIGNvbXBsZXRlZCBpbgo+
ICAgCQkJCQkJICAgY3VycmVudCBidmVjICovCj4gLX07Cj4gK30gX19wYWNrZWQ7Cj4gICAKPiAg
IHN0cnVjdCBidmVjX2l0ZXJfYWxsIHsKPiAgIAlzdHJ1Y3QgYmlvX3ZlYwlidjsKPiAKUmV2aWV3
ZWQtYnk6IEhhbm5lcyBSZWluZWNrZSA8aGFyZUBzdXNlLmRlPgoKQ2hlZXJzLAoKSGFubmVzCi0t
IApEci4gSGFubmVzIFJlaW5lY2tlICAgICAgICAgICAgICAgIEtlcm5lbCBTdG9yYWdlIEFyY2hp
dGVjdApoYXJlQHN1c2UuZGUgICAgICAgICAgICAgICAgICAgICAgICAgICAgICArNDkgOTExIDc0
MDUzIDY4OApTVVNFIFNvZnR3YXJlIFNvbHV0aW9ucyBHbWJILCBNYXhmZWxkc3RyLiA1LCA5MDQw
OSBOw7xybmJlcmcKSFJCIDM2ODA5IChBRyBOw7xybmJlcmcpLCBHZXNjaMOkZnRzZsO8aHJlcjog
RmVsaXggSW1lbmTDtnJmZmVyCgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJl
ZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1k
ZXZlbA==

