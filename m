Return-Path: <SRS0=2hlQ=FB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86EFCC2D0E4
	for <dm-devel@archiver.kernel.org>; Fri, 27 Nov 2020 10:37:34 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CFF45208CA
	for <dm-devel@archiver.kernel.org>; Fri, 27 Nov 2020 10:37:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CFF45208CA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-588-KlKzpL2NNUi1IzKbb31hqQ-1; Fri, 27 Nov 2020 05:37:30 -0500
X-MC-Unique: KlKzpL2NNUi1IzKbb31hqQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B5A1D184215C;
	Fri, 27 Nov 2020 10:37:26 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 93D841001281;
	Fri, 27 Nov 2020 10:37:26 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 687AD180954D;
	Fri, 27 Nov 2020 10:37:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0ARAbO9S002179 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 27 Nov 2020 05:37:25 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C9A1E2166B2A; Fri, 27 Nov 2020 10:37:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C4F2B2166B28
	for <dm-devel@redhat.com>; Fri, 27 Nov 2020 10:37:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8DA70800B3A
	for <dm-devel@redhat.com>; Fri, 27 Nov 2020 10:37:21 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-81-30GG38x_P5yR6gVrVPULZw-1;
	Fri, 27 Nov 2020 05:37:16 -0500
X-MC-Unique: 30GG38x_P5yR6gVrVPULZw-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 7E166AF38;
	Fri, 27 Nov 2020 10:37:14 +0000 (UTC)
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20201126130422.92945-1-hch@lst.de>
	<20201126130422.92945-12-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <af25c440-de15-3ba0-9f29-df708106c7d3@suse.de>
Date: Fri, 27 Nov 2020 11:37:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201126130422.92945-12-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0ARAbO9S002179
X-loop: dm-devel@redhat.com
Cc: linux-bcache@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Mike Snitzer <snitzer@redhat.com>, linux-mm@kvack.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.com>, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
	linux-mtd@lists.infradead.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [dm-devel] [PATCH 11/44] block: remove a superflous check in
	blkpg_do_ioctl
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMTEvMjYvMjAgMjowMyBQTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4gc2VjdG9yX3Qg
aXMgbm93IGFsd2F5cyBhIHU2NCwgc28gdGhpcyBjaGVjayBpcyBub3QgbmVlZGVkLgo+IAo+IFNp
Z25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPgo+IEFja2VkLWJ5OiBU
ZWp1biBIZW8gPHRqQGtlcm5lbC5vcmc+Cj4gUmV2aWV3ZWQtYnk6IEphbiBLYXJhIDxqYWNrQHN1
c2UuY3o+Cj4gLS0tCj4gICBibG9jay9pb2N0bC5jIHwgOSAtLS0tLS0tLS0KPiAgIDEgZmlsZSBj
aGFuZ2VkLCA5IGRlbGV0aW9ucygtKQo+IAo+IGRpZmYgLS1naXQgYS9ibG9jay9pb2N0bC5jIGIv
YmxvY2svaW9jdGwuYwo+IGluZGV4IDZiNzg1MTgxMzQ0ZmUxLi4wYzA5YmI3YTZmZjM1ZiAxMDA2
NDQKPiAtLS0gYS9ibG9jay9pb2N0bC5jCj4gKysrIGIvYmxvY2svaW9jdGwuYwo+IEBAIC0zNSwx
NSArMzUsNiBAQCBzdGF0aWMgaW50IGJsa3BnX2RvX2lvY3RsKHN0cnVjdCBibG9ja19kZXZpY2Ug
KmJkZXYsCj4gICAJc3RhcnQgPSBwLnN0YXJ0ID4+IFNFQ1RPUl9TSElGVDsKPiAgIAlsZW5ndGgg
PSBwLmxlbmd0aCA+PiBTRUNUT1JfU0hJRlQ7Cj4gICAKPiAtCS8qIGNoZWNrIGZvciBmaXQgaW4g
YSBoZF9zdHJ1Y3QgKi8KPiAtCWlmIChzaXplb2Yoc2VjdG9yX3QpIDwgc2l6ZW9mKGxvbmcgbG9u
ZykpIHsKPiAtCQlsb25nIHBzdGFydCA9IHN0YXJ0LCBwbGVuZ3RoID0gbGVuZ3RoOwo+IC0KPiAt
CQlpZiAocHN0YXJ0ICE9IHN0YXJ0IHx8IHBsZW5ndGggIT0gbGVuZ3RoIHx8IHBzdGFydCA8IDAg
fHwKPiAtCQkgICAgcGxlbmd0aCA8IDAgfHwgcC5wbm8gPiA2NTUzNSkKPiAtCQkJcmV0dXJuIC1F
SU5WQUw7Cj4gLQl9Cj4gLQo+ICAgCXN3aXRjaCAob3ApIHsKPiAgIAljYXNlIEJMS1BHX0FERF9Q
QVJUSVRJT046Cj4gICAJCS8qIGNoZWNrIGlmIHBhcnRpdGlvbiBpcyBhbGlnbmVkIHRvIGJsb2Nr
c2l6ZSAqLwo+IApSZXZpZXdlZC1ieTogSGFubmVzIFJlaW5lY2tlIDxoYXJlQHN1c2UuZGU+CgpD
aGVlcnMsCgpIYW5uZXMKLS0gCkRyLiBIYW5uZXMgUmVpbmVja2UgICAgICAgICAgICAgICAgS2Vy
bmVsIFN0b3JhZ2UgQXJjaGl0ZWN0CmhhcmVAc3VzZS5kZSAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICs0OSA5MTEgNzQwNTMgNjg4ClNVU0UgU29mdHdhcmUgU29sdXRpb25zIEdtYkgsIE1h
eGZlbGRzdHIuIDUsIDkwNDA5IE7DvHJuYmVyZwpIUkIgMzY4MDkgKEFHIE7DvHJuYmVyZyksIEdl
c2Now6RmdHNmw7xocmVyOiBGZWxpeCBJbWVuZMO2cmZmZXIKCgotLQpkbS1kZXZlbCBtYWlsaW5n
IGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4v
bGlzdGluZm8vZG0tZGV2ZWw=

