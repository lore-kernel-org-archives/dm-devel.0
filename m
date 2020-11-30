Return-Path: <SRS0=s6zu=FE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BEE9C5519F
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 07:08:58 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C34BA206CA
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 07:08:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C34BA206CA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-80-PMH4QqcWMc-Pb768Wbajzw-1; Mon, 30 Nov 2020 02:08:51 -0500
X-MC-Unique: PMH4QqcWMc-Pb768Wbajzw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BCEA210054FF;
	Mon, 30 Nov 2020 07:08:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A030B5C1BB;
	Mon, 30 Nov 2020 07:08:47 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6E4F74A7C7;
	Mon, 30 Nov 2020 07:08:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AU78jGe021510 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 30 Nov 2020 02:08:45 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 69F9D2166B2B; Mon, 30 Nov 2020 07:08:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 651712166B2A
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 07:08:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3946F811E84
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 07:08:43 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-432-ktlrILFENBCKwe0A7SojDw-1;
	Mon, 30 Nov 2020 02:08:38 -0500
X-MC-Unique: ktlrILFENBCKwe0A7SojDw-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 205A9AC55;
	Mon, 30 Nov 2020 07:08:37 +0000 (UTC)
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20201128161510.347752-1-hch@lst.de>
	<20201128161510.347752-9-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <8e58e368-5772-6d97-06d0-f58346cc1865@suse.de>
Date: Mon, 30 Nov 2020 08:08:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201128161510.347752-9-hch@lst.de>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0AU78jGe021510
X-loop: dm-devel@redhat.com
Cc: linux-bcache@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Mike Snitzer <snitzer@redhat.com>, linux-mm@kvack.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.com>, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
	linux-mtd@lists.infradead.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [dm-devel] [PATCH 08/45] dm: simplify flush_bio initialization
 in __send_empty_flush
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMTEvMjgvMjAgNToxNCBQTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4gV2UgZG9uJ3Qg
cmVhbGx5IG5lZWQgdGhlIHN0cnVjdCBibG9ja19kZXZpY2UgdG8gaW5pdGlhbGl6ZSBhIGJpby4g
IFNvCj4gc3dpdGNoIGZyb20gdXNpbmcgYmlvX3NldF9kZXYgdG8gbWFudWFsbHkgc2V0dGluZyB1
cCBiaV9kaXNrIChiaV9wYXJ0bm8KPiB3aWxsIGFsd2F5cyBiZSB6ZXJvIGFuZCBoYXMgYmVlbiBj
bGVhcmVkIGJ5IGJpb19pbml0IGFscmVhZHkpLgo+IAo+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9w
aCBIZWxsd2lnIDxoY2hAbHN0LmRlPgo+IEFja2VkLWJ5OiBNaWtlIFNuaXR6ZXIgPHNuaXR6ZXJA
cmVkaGF0LmNvbT4KPiAtLS0KPiAgIGRyaXZlcnMvbWQvZG0uYyB8IDEyICsrKy0tLS0tLS0tLQo+
ICAgMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgOSBkZWxldGlvbnMoLSkKPiAKPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9kbS5jIGIvZHJpdmVycy9tZC9kbS5jCj4gaW5kZXggNTA1
NDFkMzM2YzcxOWIuLmFiMGE4MzM1ZjA5OGQ5IDEwMDY0NAo+IC0tLSBhL2RyaXZlcnMvbWQvZG0u
Ywo+ICsrKyBiL2RyaXZlcnMvbWQvZG0uYwo+IEBAIC0xNDIyLDE4ICsxNDIyLDEyIEBAIHN0YXRp
YyBpbnQgX19zZW5kX2VtcHR5X2ZsdXNoKHN0cnVjdCBjbG9uZV9pbmZvICpjaSkKPiAgIAkgKi8K
PiAgIAliaW9faW5pdCgmZmx1c2hfYmlvLCBOVUxMLCAwKTsKPiAgIAlmbHVzaF9iaW8uYmlfb3Bm
ID0gUkVRX09QX1dSSVRFIHwgUkVRX1BSRUZMVVNIIHwgUkVRX1NZTkM7Cj4gKwlmbHVzaF9iaW8u
YmlfZGlzayA9IGNpLT5pby0+bWQtPmRpc2s7Cj4gKwliaW9fYXNzb2NpYXRlX2Jsa2coJmZsdXNo
X2Jpbyk7Cj4gKwo+ICAgCWNpLT5iaW8gPSAmZmx1c2hfYmlvOwo+ICAgCWNpLT5zZWN0b3JfY291
bnQgPSAwOwo+ICAgCj4gLQkvKgo+IC0JICogRW1wdHkgZmx1c2ggdXNlcyBhIHN0YXRpY2FsbHkg
aW5pdGlhbGl6ZWQgYmlvLCBhcyB0aGUgYmFzZSBmb3IKPiAtCSAqIGNsb25pbmcuICBIb3dldmVy
LCBibGtnIGFzc29jaWF0aW9uIHJlcXVpcmVzIHRoYXQgYSBiZGV2IGlzCj4gLQkgKiBhc3NvY2lh
dGVkIHdpdGggYSBnZW5kaXNrLCB3aGljaCBkb2Vzbid0IGhhcHBlbiB1bnRpbCB0aGUgYmRldiBp
cwo+IC0JICogb3BlbmVkLiAgU28sIGJsa2cgYXNzb2NpYXRpb24gaXMgZG9uZSBhdCBpc3N1ZSB0
aW1lIG9mIHRoZSBmbHVzaAo+IC0JICogcmF0aGVyIHRoYW4gd2hlbiB0aGUgZGV2aWNlIGlzIGNy
ZWF0ZWQgaW4gYWxsb2NfZGV2KCkuCj4gLQkgKi8KPiAtCWJpb19zZXRfZGV2KGNpLT5iaW8sIGNp
LT5pby0+bWQtPmJkZXYpOwo+IC0KPiAgIAlCVUdfT04oYmlvX2hhc19kYXRhKGNpLT5iaW8pKTsK
PiAgIAl3aGlsZSAoKHRpID0gZG1fdGFibGVfZ2V0X3RhcmdldChjaS0+bWFwLCB0YXJnZXRfbnIr
KykpKQo+ICAgCQlfX3NlbmRfZHVwbGljYXRlX2Jpb3MoY2ksIHRpLCB0aS0+bnVtX2ZsdXNoX2Jp
b3MsIE5VTEwpOwo+IApSZXZpZXdlZC1ieTogSGFubmVzIFJlaW5lY2tlIDxoYXJlQHN1c2UuZGU+
CgpDaGVlcnMsCgpIYW5uZXMKLS0gCkRyLiBIYW5uZXMgUmVpbmVja2UgICAgICAgICAgICAgICAg
S2VybmVsIFN0b3JhZ2UgQXJjaGl0ZWN0CmhhcmVAc3VzZS5kZSAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICs0OSA5MTEgNzQwNTMgNjg4ClNVU0UgU29mdHdhcmUgU29sdXRpb25zIEdtYkgs
IE1heGZlbGRzdHIuIDUsIDkwNDA5IE7DvHJuYmVyZwpIUkIgMzY4MDkgKEFHIE7DvHJuYmVyZyks
IEdlc2Now6RmdHNmw7xocmVyOiBGZWxpeCBJbWVuZMO2cmZmZXIKCgotLQpkbS1kZXZlbCBtYWls
aW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxt
YW4vbGlzdGluZm8vZG0tZGV2ZWw=

