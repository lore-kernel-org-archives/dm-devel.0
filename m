Return-Path: <SRS0=zCJ6=KS=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2BCAC47080
	for <dm-devel@archiver.kernel.org>; Sun, 23 May 2021 08:10:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4DCBB6127A
	for <dm-devel@archiver.kernel.org>; Sun, 23 May 2021 08:10:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4DCBB6127A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-86-0EWBIvTpOCiIai1rcqyUOg-1; Sun, 23 May 2021 04:10:50 -0400
X-MC-Unique: 0EWBIvTpOCiIai1rcqyUOg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2C7CE802939;
	Sun, 23 May 2021 08:10:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DE54D9CA0;
	Sun, 23 May 2021 08:10:46 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 77D1F1801029;
	Sun, 23 May 2021 08:10:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14N8AiJI029060 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 23 May 2021 04:10:44 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 0A4DC200BA94; Sun, 23 May 2021 08:10:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 055FA200D8C5
	for <dm-devel@redhat.com>; Sun, 23 May 2021 08:10:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 67EE8101A531
	for <dm-devel@redhat.com>; Sun, 23 May 2021 08:10:40 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-486-srLtSU_0M8elOzVqKFFQzA-1;
	Sun, 23 May 2021 04:10:38 -0400
X-MC-Unique: srLtSU_0M8elOzVqKFFQzA-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 6FA31AB6D;
	Sun, 23 May 2021 08:10:36 +0000 (UTC)
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>, Jim Paris <jim@jtan.com>,
	Philip Kelleher <pjk1939@linux.ibm.com>,
	Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
	Matias Bjorling <mb@lightnvm.io>, Coly Li <colyli@suse.de>,
	Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>,
	Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>, 
	Ulf Hansson <ulf.hansson@linaro.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>
References: <20210521055116.1053587-1-hch@lst.de>
	<20210521055116.1053587-14-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <de3b0976-1299-17d8-240a-2ecd8b9fbc2d@suse.de>
Date: Sun, 23 May 2021 10:10:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210521055116.1053587-14-hch@lst.de>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14N8AiJI029060
X-loop: dm-devel@redhat.com
Cc: linux-xtensa@linux-xtensa.org, linux-m68k@vger.kernel.org,
	linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-s390@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-bcache@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	drbd-dev@tron.linbit.com, linuxppc-dev@lists.ozlabs.org
Subject: Re: [dm-devel] [PATCH 13/26] dm: convert to
	blk_alloc_disk/blk_cleanup_disk
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gNS8yMS8yMSA3OjUxIEFNLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToKPiBDb252ZXJ0IHRo
ZSBkbSBkcml2ZXIgdG8gdXNlIHRoZSBibGtfYWxsb2NfZGlzayBhbmQgYmxrX2NsZWFudXBfZGlz
awo+IGhlbHBlcnMgdG8gc2ltcGxpZnkgZ2VuZGlzayBhbmQgcmVxdWVzdF9xdWV1ZSBhbGxvY2F0
aW9uLgo+IAo+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPgo+
IC0tLQo+ICAgZHJpdmVycy9tZC9kbS5jIHwgMTYgKysrKysrKy0tLS0tLS0tLQo+ICAgMSBmaWxl
IGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKSwgOSBkZWxldGlvbnMoLSkKPiAKPiBkaWZmIC0tZ2l0
IGEvZHJpdmVycy9tZC9kbS5jIGIvZHJpdmVycy9tZC9kbS5jCj4gaW5kZXggY2EyYWVkZDhlZTdk
Li4zYzdjMmQyNTcwMTggMTAwNjQ0Cj4gLS0tIGEvZHJpdmVycy9tZC9kbS5jCj4gKysrIGIvZHJp
dmVycy9tZC9kbS5jCj4gQEAgLTE4MDEsMTMgKzE4MDEsMTMgQEAgc3RhdGljIHZvaWQgY2xlYW51
cF9tYXBwZWRfZGV2aWNlKHN0cnVjdCBtYXBwZWRfZGV2aWNlICptZCkKPiAgIAkJbWQtPmRpc2st
PnByaXZhdGVfZGF0YSA9IE5VTEw7Cj4gICAJCXNwaW5fdW5sb2NrKCZfbWlub3JfbG9jayk7Cj4g
ICAJCWRlbF9nZW5kaXNrKG1kLT5kaXNrKTsKPiAtCQlwdXRfZGlzayhtZC0+ZGlzayk7Cj4gICAJ
fQo+ICAgCj4gLQlpZiAobWQtPnF1ZXVlKSB7Cj4gKwlpZiAobWQtPnF1ZXVlKQo+ICAgCQlkbV9x
dWV1ZV9kZXN0cm95X2tleXNsb3RfbWFuYWdlcihtZC0+cXVldWUpOwo+IC0JCWJsa19jbGVhbnVw
X3F1ZXVlKG1kLT5xdWV1ZSk7Cj4gLQl9Cj4gKwo+ICsJaWYgKG1kLT5kaXNrKQo+ICsJCWJsa19j
bGVhbnVwX2Rpc2sobWQtPmRpc2spOwo+ICAgCj4gICAJY2xlYW51cF9zcmN1X3N0cnVjdCgmbWQt
PmlvX2JhcnJpZXIpOwo+ICAgCgpDYW4ndCB0aGVzZSBjb25kaXRpb25hbHMgYmUgbWVyZ2VkIGlu
dG8gYSBzaW5nbGUgJ2lmIChtZC0+ZGlzayknPwpFZyBsaWtlOgoKCWlmIChtZC0+ZGlzaykgewoJ
CXNwaW5fbG9jaygmX21pbm9yX2xvY2spOwoJCW1kLT5kaXNrLT5wcml2YXRlX2RhdGEgPSBOVUxM
OwoJCXNwaW5fdW5sb2NrKCZfbWlub3JfbG9jayk7CgkJZGVsX2dlbmRpc2sobWQtPmRpc2spOwoJ
CWRtX3F1ZXVlX2Rlc3Ryb3lfa2V5c2xvdF9tYW5hZ2VyKG1kLT5xdWV1ZSk7CgkJYmxrX2NsZWFu
dXBfZGlzayhtZC0+cXVldWUpOwoJfQoKV2UncmUgbm93IGFsd2F5cyBhbGxvY2F0aW5nICdtZC0+
ZGlzaycgYW5kICdtZC0+cXVldWUnIHRvZ2V0aGVyLApzbyBob3cgY2FuIHdlIGVuZCB1cCBpbiBh
IHNpdHVhdGlvbiB3aGVyZSBvbmUgaXMgc2V0IHdpdGhvdXQgdGhlIG90aGVyPwoKPiBAQCAtMTg2
OSwxMyArMTg2OSwxMCBAQCBzdGF0aWMgc3RydWN0IG1hcHBlZF9kZXZpY2UgKmFsbG9jX2Rldihp
bnQgbWlub3IpCj4gICAJICogZXN0YWJsaXNoZWQuIElmIHJlcXVlc3QtYmFzZWQgdGFibGUgaXMg
bG9hZGVkOiBibGstbXEgd2lsbAo+ICAgCSAqIG92ZXJyaWRlIGFjY29yZGluZ2x5Lgo+ICAgCSAq
Lwo+IC0JbWQtPnF1ZXVlID0gYmxrX2FsbG9jX3F1ZXVlKG51bWFfbm9kZV9pZCk7Cj4gLQlpZiAo
IW1kLT5xdWV1ZSkKPiAtCQlnb3RvIGJhZDsKPiAtCj4gLQltZC0+ZGlzayA9IGFsbG9jX2Rpc2tf
bm9kZSgxLCBtZC0+bnVtYV9ub2RlX2lkKTsKPiArCW1kLT5kaXNrID0gYmxrX2FsbG9jX2Rpc2so
bWQtPm51bWFfbm9kZV9pZCk7Cj4gICAJaWYgKCFtZC0+ZGlzaykKPiAgIAkJZ290byBiYWQ7Cj4g
KwltZC0+cXVldWUgPSBtZC0+ZGlzay0+cXVldWU7Cj4gICAKPiAgIAlpbml0X3dhaXRxdWV1ZV9o
ZWFkKCZtZC0+d2FpdCk7Cj4gICAJSU5JVF9XT1JLKCZtZC0+d29yaywgZG1fd3Ffd29yayk7Cj4g
QEAgLTE4ODgsNiArMTg4NSw3IEBAIHN0YXRpYyBzdHJ1Y3QgbWFwcGVkX2RldmljZSAqYWxsb2Nf
ZGV2KGludCBtaW5vcikKPiAgIAo+ICAgCW1kLT5kaXNrLT5tYWpvciA9IF9tYWpvcjsKPiAgIAlt
ZC0+ZGlzay0+Zmlyc3RfbWlub3IgPSBtaW5vcjsKPiArCW1kLT5kaXNrLT5taW5vcnMgPSAxOwo+
ICAgCW1kLT5kaXNrLT5mb3BzID0gJmRtX2Jsa19kb3BzOwo+ICAgCW1kLT5kaXNrLT5xdWV1ZSA9
IG1kLT5xdWV1ZTsKPiAgIAltZC0+ZGlzay0+cHJpdmF0ZV9kYXRhID0gbWQ7Cj4gCkNoZWVycywK
Ckhhbm5lcwotLSAKRHIuIEhhbm5lcyBSZWluZWNrZSAgICAgICAgICAgICAgICBLZXJuZWwgU3Rv
cmFnZSBBcmNoaXRlY3QKaGFyZUBzdXNlLmRlICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
KzQ5IDkxMSA3NDA1MyA2ODgKU1VTRSBTb2Z0d2FyZSBTb2x1dGlvbnMgR21iSCwgTWF4ZmVsZHN0
ci4gNSwgOTA0MDkgTsO8cm5iZXJnCkhSQiAzNjgwOSAoQUcgTsO8cm5iZXJnKSwgR2VzY2jDpGZ0
c2bDvGhyZXI6IEZlbGl4IEltZW5kw7ZyZmZlcgoKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApk
bS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlz
dGluZm8vZG0tZGV2ZWw=

