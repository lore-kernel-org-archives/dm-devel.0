Return-Path: <SRS0=s6zu=FE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15711C63777
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 07:56:13 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6800920719
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 07:56:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6800920719
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-562-10nhh_3IMLucc4VGzlPuvg-1; Mon, 30 Nov 2020 02:56:09 -0500
X-MC-Unique: 10nhh_3IMLucc4VGzlPuvg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 68DCB8030A1;
	Mon, 30 Nov 2020 07:56:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4251F60862;
	Mon, 30 Nov 2020 07:56:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 16C06180954D;
	Mon, 30 Nov 2020 07:56:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AU7u2r5027527 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 30 Nov 2020 02:56:03 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 76B40112C07B; Mon, 30 Nov 2020 07:56:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 72D86112C073
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 07:56:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 26993800969
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 07:56:00 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-442-YvOP80uoMC-XkCjPCXHVig-1;
	Mon, 30 Nov 2020 02:55:57 -0500
X-MC-Unique: YvOP80uoMC-XkCjPCXHVig-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id CF14DAD09;
	Mon, 30 Nov 2020 07:55:55 +0000 (UTC)
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20201129181926.897775-1-hch@lst.de>
	<20201129181926.897775-2-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <d28dc6f5-bae1-ddfa-8874-9c22235a69f3@suse.de>
Date: Mon, 30 Nov 2020 08:55:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201129181926.897775-2-hch@lst.de>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0AU7u2r5027527
X-loop: dm-devel@redhat.com
Cc: Sagi Grimberg <sagi@grimberg.me>, Mike Snitzer <snitzer@redhat.com>,
	Oleksii Kurochko <olkuroch@cisco.com>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	linux-nvme@lists.infradead.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 1/4] block: add a hard-readonly flag to
	struct gendisk
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMTEvMjkvMjAgNzoxOSBQTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4gQ29tbWl0IDIw
YmQxZDAyNmFhYyAoInNjc2k6IHNkOiBLZWVwIGRpc2sgcmVhZC1vbmx5IHdoZW4gcmUtcmVhZGlu
Zwo+IHBhcnRpdGlvbiIpIGFkZHJlc3NlZCBhIGxvbmctc3RhbmRpbmcgcHJvYmxlbSB3aXRoIHVz
ZXIgcmVhZC1vbmx5Cj4gcG9saWN5IGJlaW5nIG92ZXJyaWRkZW4gYXMgYSByZXN1bHQgb2YgYSBk
ZXZpY2UtaW5pdGlhdGVkIHJldmFsaWRhdGUuCj4gVGhlIGNvbW1pdCBoYXMgc2luY2UgYmVlbiBy
ZXZlcnRlZCBkdWUgdG8gYSByZWdyZXNzaW9uIHRoYXQgbGVmdCBzb21lCj4gVVNCIGRldmljZXMg
cmVhZC1vbmx5IGluZGVmaW5pdGVseS4KPiAKPiBUbyBmaXggdGhlIHVuZGVybHlpbmcgcHJvYmxl
bXMgd2l0aCByZXZhbGlkYXRlIHdlIG5lZWQgdG8ga2VlcCB0cmFjawo+IG9mIGhhcmR3YXJlIHN0
YXRlIGFuZCB1c2VyIHBvbGljeSBzZXBhcmF0ZWx5Lgo+IAo+IFRoZSBnZW5kaXNrIGhhcyBiZWVu
IHVwZGF0ZWQgdG8gcmVmbGVjdCB0aGUgY3VycmVudCBoYXJkd2FyZSBzdGF0ZSBzZXQKPiBieSB0
aGUgZGV2aWNlIGRyaXZlci4gVGhpcyBpcyBkb25lIHRvIGFsbG93IHJldHVybmluZyB0aGUgZGV2
aWNlIHRvCj4gdGhlIGhhcmR3YXJlIHN0YXRlIG9uY2UgdGhlIHVzZXIgY2xlYXJzIHRoZSBCTEtS
T1NFVCBmbGFnLgo+IAo+IFRoZSByZXN1bHRpbmcgc2VtYW50aWNzIGFyZSBhcyBmb2xsb3dzOgo+
IAo+ICAgLSBJZiBCTEtST1NFVCBpcyB1c2VkIHRvIHNldCBhIHdob2xlLWRpc2sgZGV2aWNlIHJl
YWQtb25seSwgYW55Cj4gICAgIHBhcnRpdGlvbnMgd2lsbCBlbmQgdXAgaW4gYSByZWFkLW9ubHkg
c3RhdGUgdW50aWwgdGhlIHVzZXIKPiAgICAgZXhwbGljaXRseSBjbGVhcnMgdGhlIGZsYWcuCj4g
Cj4gICAtIElmIEJMS1JPU0VUIHNldHMgYSBnaXZlbiBwYXJ0aXRpb24gcmVhZC1vbmx5LCB0aGF0
IHBhcnRpdGlvbiB3aWxsCj4gICAgIHJlbWFpbiByZWFkLW9ubHkgZXZlbiBpZiB0aGUgdW5kZXJs
eWluZyBzdG9yYWdlIHN0YWNrIGluaXRpYXRlcyBhCj4gICAgIHJldmFsaWRhdGUuIEhvd2V2ZXIs
IHRoZSBCTEtSUlBBUlQgaW9jdGwgd2lsbCBjYXVzZSB0aGUgcGFydGl0aW9uCj4gICAgIHRhYmxl
IHRvIGJlIGRyb3BwZWQgYW5kIGFueSB1c2VyIHBvbGljeSBvbiBwYXJ0aXRpb25zIHdpbGwgYmUg
bG9zdC4KPiAKPiAgIC0gSWYgQkxLUk9TRVQgaGFzIG5vdCBiZWVuIHNldCwgYm90aCB0aGUgd2hv
bGUgZGlzayBkZXZpY2UgYW5kIGFueQo+ICAgICBwYXJ0aXRpb25zIHdpbGwgcmVmbGVjdCB0aGUg
Y3VycmVudCB3cml0ZS1wcm90ZWN0IHN0YXRlIG9mIHRoZQo+ICAgICB1bmRlcmx5aW5nIGRldmlj
ZS4KPiAKPiBCYXNlZCBvbiBhIHBhdGNoIGZyb20gTWFydGluIEsuIFBldGVyc2VuIDxtYXJ0aW4u
cGV0ZXJzZW5Ab3JhY2xlLmNvbT4uCj4gCj4gUmVwb3J0ZWQtYnk6IE9sZWtzaWkgS3Vyb2Noa28g
PG9sa3Vyb2NoQGNpc2NvLmNvbT4KPiBCdWd6aWxsYTogaHR0cHM6Ly9idWd6aWxsYS5rZXJuZWwu
b3JnL3Nob3dfYnVnLmNnaT9pZD0yMDEyMjEKPiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVs
bHdpZyA8aGNoQGxzdC5kZT4KPiAtLS0KPiAgIGJsb2NrL2Jsay1jb3JlLmMgICAgICAgIHwgIDIg
Ky0KPiAgIGJsb2NrL2dlbmhkLmMgICAgICAgICAgIHwgMzQgKysrKysrKysrKysrKysrKysrKy0t
LS0tLS0tLS0tLS0tLQo+ICAgYmxvY2svcGFydGl0aW9ucy9jb3JlLmMgfCAgMyArLS0KPiAgIGlu
Y2x1ZGUvbGludXgvZ2VuaGQuaCAgIHwgIDYgKysrKy0tCj4gICA0IGZpbGVzIGNoYW5nZWQsIDI1
IGluc2VydGlvbnMoKyksIDIwIGRlbGV0aW9ucygtKQo+IApSZXZpZXdlZC1ieTogSGFubmVzIFJl
aW5lY2tlIDxoYXJlQHN1c2UuZGU+CgpDaGVlcnMsCgpIYW5uZXMKLS0gCkRyLiBIYW5uZXMgUmVp
bmVja2UgICAgICAgICAgICAgICAgS2VybmVsIFN0b3JhZ2UgQXJjaGl0ZWN0CmhhcmVAc3VzZS5k
ZSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICs0OSA5MTEgNzQwNTMgNjg4ClNVU0UgU29m
dHdhcmUgU29sdXRpb25zIEdtYkgsIE1heGZlbGRzdHIuIDUsIDkwNDA5IE7DvHJuYmVyZwpIUkIg
MzY4MDkgKEFHIE7DvHJuYmVyZyksIEdlc2Now6RmdHNmw7xocmVyOiBGZWxpeCBJbWVuZMO2cmZm
ZXIKCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczov
L3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=

