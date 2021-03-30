Return-Path: <SRS0=BXbM=I4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BE56C433C1
	for <dm-devel@archiver.kernel.org>; Tue, 30 Mar 2021 06:17:50 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5C3F36191B
	for <dm-devel@archiver.kernel.org>; Tue, 30 Mar 2021 06:17:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5C3F36191B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-8-v8_Iw5ziOeeNjsl0_SDBqQ-1; Tue, 30 Mar 2021 02:17:46 -0400
X-MC-Unique: v8_Iw5ziOeeNjsl0_SDBqQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B42B181746E;
	Tue, 30 Mar 2021 06:17:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C5A710023B5;
	Tue, 30 Mar 2021 06:17:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 978541809C83;
	Tue, 30 Mar 2021 06:17:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12U6HY3i005278 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 30 Mar 2021 02:17:35 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id CFFF8568E2; Tue, 30 Mar 2021 06:17:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C8E5E568E4
	for <dm-devel@redhat.com>; Tue, 30 Mar 2021 06:17:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7323A85A5B5
	for <dm-devel@redhat.com>; Tue, 30 Mar 2021 06:17:31 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-596-rRaL8XpANqCKbjJlnnArSQ-1;
	Tue, 30 Mar 2021 02:17:27 -0400
X-MC-Unique: rRaL8XpANqCKbjJlnnArSQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 282A2AD6D;
	Tue, 30 Mar 2021 06:17:25 +0000 (UTC)
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
References: <20210329152622.173035-1-ming.lei@redhat.com>
	<20210329152622.173035-4-ming.lei@redhat.com>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <9f485fcf-4846-fd58-86e5-deddfe78635f@suse.de>
Date: Tue, 30 Mar 2021 08:17:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210329152622.173035-4-ming.lei@redhat.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 12U6HY3i005278
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, Jeffle Xu <jefflexu@linux.alibaba.com>,
	dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm-devel] [PATCH V4 03/12] block: create io poll context for
 submission and poll task
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMy8yOS8yMSA1OjI2IFBNLCBNaW5nIExlaSB3cm90ZToKPiBDcmVhdGUgcGVyLXRhc2sgaW8g
cG9sbCBjb250ZXh0IGZvciBib3RoIElPIHN1Ym1pc3Npb24gYW5kIHBvbGwgdGFzawo+IGlmIHRo
ZSBxdWV1ZSBpcyBiaW8gYmFzZWQgYW5kIHN1cHBvcnRzIHBvbGxpbmcuCj4gCj4gVGhpcyBpbyBw
b2xsaW5nIGNvbnRleHQgaW5jbHVkZXMgdHdvIHF1ZXVlczoKPiAKPiAxKSBzdWJtaXNzaW9uIHF1
ZXVlKHNxKSBmb3Igc3RvcmluZyBISVBSSSBiaW8sIHdyaXR0ZW4gYnkgc3VibWlzc2lvbiB0YXNr
Cj4gICAgIGFuZCByZWFkIGJ5IHBvbGwgdGFzay4KPiAyKSBwb2xsaW5nIHF1ZXVlKHBxKSBmb3Ig
aG9sZGluZyBkYXRhIG1vdmVkIGZyb20gc3EsIG9ubHkgdXNlZCBpbiBwb2xsCj4gICAgIGNvbnRl
eHQgZm9yIHJ1bm5pbmcgYmlvIHBvbGxpbmcuCj4gCj4gRm9sbG93aW5nIHBhdGNoZXMgd2lsbCBz
dXBwb3J0IGJpbyBiYXNlZCBpbyBwb2xsaW5nLgo+IAo+IFNpZ25lZC1vZmYtYnk6IE1pbmcgTGVp
IDxtaW5nLmxlaUByZWRoYXQuY29tPgo+IC0tLQo+ICAgYmxvY2svYmxrLWNvcmUuYyAgICAgICAg
ICB8IDc5ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLQo+ICAgYmxvY2sv
YmxrLWlvYy5jICAgICAgICAgICB8ICAxICt3ZWQKPiAgIGJsb2NrL2Jsay1tcS5jICAgICAgICAg
ICAgfCAxNCArKysrKysrCj4gICBibG9jay9ibGsuaCAgICAgICAgICAgICAgIHwgMzggKysrKysr
KysrKysrKysrKysrKwo+ICAgaW5jbHVkZS9saW51eC9pb2NvbnRleHQuaCB8ICAyICsKPiAgIDUg
ZmlsZXMgY2hhbmdlZCwgMTIzIGluc2VydGlvbnMoKyksIDExIGRlbGV0aW9ucygtKQo+IFJldmll
d2VkLWJ5OiBIYW5uZXMgUmVpbmVja2UgPGhhcmVAc3VzZS5kZT4KCkNoZWVycywKCkhhbm5lcwot
LSAKRHIuIEhhbm5lcyBSZWluZWNrZSAgICAgICAgICAgICAgICBLZXJuZWwgU3RvcmFnZSBBcmNo
aXRlY3QKaGFyZUBzdXNlLmRlICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKzQ5IDkxMSA3
NDA1MyA2ODgKU1VTRSBTb2Z0d2FyZSBTb2x1dGlvbnMgR21iSCwgTWF4ZmVsZHN0ci4gNSwgOTA0
MDkgTsO8cm5iZXJnCkhSQiAzNjgwOSAoQUcgTsO8cm5iZXJnKSwgR2VzY2jDpGZ0c2bDvGhyZXI6
IEZlbGl4IEltZW5kw7ZyZmZlcgoKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEBy
ZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0t
ZGV2ZWw=

