Return-Path: <SRS0=s6zu=FE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECB3BC63777
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 07:32:17 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4500520731
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 07:32:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4500520731
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-93-uN0mEiQGPeSPo5P1MIMVqg-1; Mon, 30 Nov 2020 02:32:13 -0500
X-MC-Unique: uN0mEiQGPeSPo5P1MIMVqg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DC71E1074641;
	Mon, 30 Nov 2020 07:32:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BB12C5D6AB;
	Mon, 30 Nov 2020 07:32:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8FE884E58E;
	Mon, 30 Nov 2020 07:32:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AU7W5Cq024559 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 30 Nov 2020 02:32:06 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C1AFE2166B2B; Mon, 30 Nov 2020 07:32:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BD1EC2166B2A
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 07:32:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 96240103B80B
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 07:32:03 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-59-XdYJPlFhNOO8AYiKXIdE5w-1;
	Mon, 30 Nov 2020 02:31:58 -0500
X-MC-Unique: XdYJPlFhNOO8AYiKXIdE5w-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id D91FAAC8F;
	Mon, 30 Nov 2020 07:31:56 +0000 (UTC)
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20201128161510.347752-1-hch@lst.de>
	<20201128161510.347752-25-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <7ad63383-5f07-3fd2-d39b-b0db7905d094@suse.de>
Date: Mon, 30 Nov 2020 08:31:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201128161510.347752-25-hch@lst.de>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0AU7W5Cq024559
X-loop: dm-devel@redhat.com
Cc: linux-bcache@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Mike Snitzer <snitzer@redhat.com>, linux-mm@kvack.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.com>, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
	linux-mtd@lists.infradead.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [dm-devel] [PATCH 24/45] block: remove i_bdev
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

T24gMTEvMjgvMjAgNToxNCBQTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4gU3dpdGNoIHRo
ZSBibG9jayBkZXZpY2UgbG9va3VwIGludGVyZmFjZXMgdG8gZGlyZWN0bHkgd29yayB3aXRoIGEg
ZGV2X3QKPiBzbyB0aGF0IHN0cnVjdCBibG9ja19kZXZpY2UgcmVmZXJlbmNlcyBhcmUgb25seSBh
Y3F1aXJlZCBieSB0aGUKPiBibGtkZXZfZ2V0IHZhcmlhbnRzIChhbmQgdGhlIGJsay1jZ3JvdXAg
c3BlY2lhbCBjYXNlKS4gIFRoaXMgbWVhbnMgdGhhdAo+IHdlIG5vdyBkb24ndCBuZWVkIGFuIGV4
dHJhIHJlZmVyZW5jZSBpbiB0aGUgaW5vZGUgYW5kIGNhbiBnZW5lcmFsbHkKPiBzaW1wbGlmeSBo
YW5kbGluZyBvZiBzdHJ1Y3QgYmxvY2tfZGV2aWNlIHRvIGtlZXAgdGhlIGxvb2t1cHMgY29udGFp
bmVkCj4gaW4gdGhlIGNvcmUgYmxvY2sgbGF5ZXIgY29kZS4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBD
aHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4KPiBSZXZpZXdlZC1ieTogSmFuIEthcmEgPGph
Y2tAc3VzZS5jej4KPiBBY2tlZC1ieTogVGVqdW4gSGVvIDx0akBrZXJuZWwub3JnPgo+IEFja2Vk
LWJ5OiBDb2x5IExpIDxjb2x5bGlAc3VzZS5kZT4JCVtiY2FjaGVdCj4gLS0tCj4gICBibG9jay9p
b2N0bC5jICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgMyArLQo+ICAgZHJpdmVy
cy9ibG9jay9sb29wLmMgICAgICAgICAgICAgICAgICAgICAgICAgfCAgIDggKy0KPiAgIGRyaXZl
cnMvbWQvYmNhY2hlL3N1cGVyLmMgICAgICAgICAgICAgICAgICAgIHwgIDIwICstCj4gICBkcml2
ZXJzL21kL2RtLXRhYmxlLmMgICAgICAgICAgICAgICAgICAgICAgICB8ICAgOSArLQo+ICAgZHJp
dmVycy9tdGQvbXRkc3VwZXIuYyAgICAgICAgICAgICAgICAgICAgICAgfCAgMTcgKy0KPiAgIGRy
aXZlcnMvdGFyZ2V0L3RhcmdldF9jb3JlX2ZpbGUuYyAgICAgICAgICAgIHwgICA2ICstCj4gICBk
cml2ZXJzL3VzYi9nYWRnZXQvZnVuY3Rpb24vc3RvcmFnZV9jb21tb24uYyB8ICAgOCArLQo+ICAg
ZnMvYmxvY2tfZGV2LmMgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAxOTYgKysrKyst
LS0tLS0tLS0tLS0tLQo+ICAgZnMvYnRyZnMvdm9sdW1lcy5jICAgICAgICAgICAgICAgICAgICAg
ICAgICAgfCAgMTMgKy0KPiAgIGZzL2lub2RlLmMgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIHwgICAzIC0KPiAgIGZzL2ludGVybmFsLmggICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIHwgICA3ICstCj4gICBmcy9pb191cmluZy5jICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICB8ICAxMCArLQo+ICAgZnMvcGlwZS5jICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgfCAgIDUgKy0KPiAgIGZzL3F1b3RhL3F1b3RhLmMgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIHwgIDE5ICstCj4gICBmcy9zdGF0ZnMuYyAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICB8ICAgMiArLQo+ICAgZnMvc3VwZXIuYyAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgfCAgNDQgKystLS0KPiAgIGluY2x1ZGUvbGludXgvYmxrZGV2LmggICAgICAg
ICAgICAgICAgICAgICAgIHwgICAyICstCj4gICBpbmNsdWRlL2xpbnV4L2ZzLmggICAgICAgICAg
ICAgICAgICAgICAgICAgICB8ICAgMSAtCj4gICAxOCBmaWxlcyBjaGFuZ2VkLCAxMjEgaW5zZXJ0
aW9ucygrKSwgMjUyIGRlbGV0aW9ucygtKQo+IApSZXZpZXdlZC1ieTogSGFubmVzIFJlaW5lY2tl
IDxoYXJlQHN1c2UuZGU+CgpDaGVlcnMsCgpIYW5uZXMKLS0gCkRyLiBIYW5uZXMgUmVpbmVja2Ug
ICAgICAgICAgICAgICAgS2VybmVsIFN0b3JhZ2UgQXJjaGl0ZWN0CmhhcmVAc3VzZS5kZSAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICs0OSA5MTEgNzQwNTMgNjg4ClNVU0UgU29mdHdhcmUg
U29sdXRpb25zIEdtYkgsIE1heGZlbGRzdHIuIDUsIDkwNDA5IE7DvHJuYmVyZwpIUkIgMzY4MDkg
KEFHIE7DvHJuYmVyZyksIEdlc2Now6RmdHNmw7xocmVyOiBGZWxpeCBJbWVuZMO2cmZmZXIKCgot
LQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5y
ZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=

