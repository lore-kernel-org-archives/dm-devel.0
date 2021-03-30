Return-Path: <SRS0=BXbM=I4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70424C433DB
	for <dm-devel@archiver.kernel.org>; Tue, 30 Mar 2021 06:27:59 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CC7A561969
	for <dm-devel@archiver.kernel.org>; Tue, 30 Mar 2021 06:27:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CC7A561969
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-563-vyy37AGPMY6Drajct14KGg-1; Tue, 30 Mar 2021 02:27:55 -0400
X-MC-Unique: vyy37AGPMY6Drajct14KGg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E4B441005D64;
	Tue, 30 Mar 2021 06:27:49 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B117D60D79;
	Tue, 30 Mar 2021 06:27:49 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F00281809C83;
	Tue, 30 Mar 2021 06:27:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12U6Rk18007041 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 30 Mar 2021 02:27:46 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id B027D2026D7F; Tue, 30 Mar 2021 06:27:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AB47F2026D64
	for <dm-devel@redhat.com>; Tue, 30 Mar 2021 06:27:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CFE7C811E7A
	for <dm-devel@redhat.com>; Tue, 30 Mar 2021 06:27:43 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-60-PqlzJt7dPOCpjvX3AZgfeg-1;
	Tue, 30 Mar 2021 02:27:41 -0400
X-MC-Unique: PqlzJt7dPOCpjvX3AZgfeg-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 99367AE72;
	Tue, 30 Mar 2021 06:27:39 +0000 (UTC)
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
References: <20210329152622.173035-1-ming.lei@redhat.com>
	<20210329152622.173035-11-ming.lei@redhat.com>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <7c5ffacf-ea76-2eeb-d19e-d8f2c175499a@suse.de>
Date: Tue, 30 Mar 2021 08:27:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210329152622.173035-11-ming.lei@redhat.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 12U6Rk18007041
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, Jeffle Xu <jefflexu@linux.alibaba.com>,
	dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm-devel] [PATCH V4 10/12] block: add queue_to_disk() to get
 gendisk from request_queue
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMy8yOS8yMSA1OjI2IFBNLCBNaW5nIExlaSB3cm90ZToKPiBGcm9tOiBKZWZmbGUgWHUgPGpl
ZmZsZXh1QGxpbnV4LmFsaWJhYmEuY29tPgo+IAo+IFNvbWV0aW1lcyB3ZSBuZWVkIHRvIGdldCB0
aGUgY29ycmVzcG9uZGluZyBnZW5kaXNrIGZyb20gcmVxdWVzdF9xdWV1ZS4KPiAKPiBJdCBpcyBw
cmVmZXJyZWQgdGhhdCBibG9jayBkcml2ZXJzIHN0b3JlIHByaXZhdGUgZGF0YSBpbgo+IGdlbmRp
c2stPnByaXZhdGVfZGF0YSByYXRoZXIgdGhhbiByZXF1ZXN0X3F1ZXVlLT5xdWV1ZWRhdGEsIGUu
Zy4gc2VlOgo+IGNvbW1pdCBjNGE1OWM0ZTVkYjMgKCJkbTogc3RvcCB1c2luZyAtPnF1ZXVlZGF0
YSIpLgo+IAo+IFNvIGlmIG9ubHkgcmVxdWVzdF9xdWV1ZSBpcyBnaXZlbiwgd2UgbmVlZCB0byBn
ZXQgaXRzIGNvcnJlc3BvbmRpbmcKPiBnZW5kaXNrIHRvIGdldCB0aGUgcHJpdmF0ZSBkYXRhIHN0
b3JlZCBpbiB0aGF0IGdlbmRpc2suCj4gCj4gU2lnbmVkLW9mZi1ieTogSmVmZmxlIFh1IDxqZWZm
bGV4dUBsaW51eC5hbGliYWJhLmNvbT4KPiBSZXZpZXdlZC1ieTogTWlrZSBTbml0emVyIDxzbml0
emVyQHJlZGhhdC5jb20+Cj4gLS0tCj4gICBpbmNsdWRlL2xpbnV4L2Jsa2Rldi5oICAgICAgIHwg
MiArKwo+ICAgaW5jbHVkZS90cmFjZS9ldmVudHMva3liZXIuaCB8IDYgKysrLS0tCj4gICAyIGZp
bGVzIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKPiAKUmV2aWV3ZWQt
Ynk6IEhhbm5lcyBSZWluZWNrZSA8aGFyZUBzdXNlLmRlPgoKLi4gYW5kIHlvdSBwcm9iYWJseSBt
aWdodCB3YW50IHRvIGFkZCB5b3VyIHNpZ25lZC1vZmYgdG8gdGhpcyBvbmUsIHRvbyA6LSkKCkNo
ZWVycywKCkhhbm5lcwotLSAKRHIuIEhhbm5lcyBSZWluZWNrZSAgICAgICAgICAgICAgICBLZXJu
ZWwgU3RvcmFnZSBBcmNoaXRlY3QKaGFyZUBzdXNlLmRlICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgKzQ5IDkxMSA3NDA1MyA2ODgKU1VTRSBTb2Z0d2FyZSBTb2x1dGlvbnMgR21iSCwgTWF4
ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJnCkhSQiAzNjgwOSAoQUcgTsO8cm5iZXJnKSwgR2Vz
Y2jDpGZ0c2bDvGhyZXI6IEZlbGl4IEltZW5kw7ZyZmZlcgoKCi0tCmRtLWRldmVsIG1haWxpbmcg
bGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxt
YW4vbGlzdGluZm8vZG0tZGV2ZWw=

