Return-Path: <SRS0=jAWR=FP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86F6DC4361B
	for <dm-devel@archiver.kernel.org>; Fri, 11 Dec 2020 16:56:34 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BC81E23EB1
	for <dm-devel@archiver.kernel.org>; Fri, 11 Dec 2020 16:56:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BC81E23EB1
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-P1ZcgnMpN4S_DotVQy5rSA-1; Fri, 11 Dec 2020 11:56:28 -0500
X-MC-Unique: P1ZcgnMpN4S_DotVQy5rSA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 96447801817;
	Fri, 11 Dec 2020 16:56:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0F0A25F708;
	Fri, 11 Dec 2020 16:56:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F1D095002C;
	Fri, 11 Dec 2020 16:56:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BBGuIvR020537 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 11 Dec 2020 11:56:18 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E49B7F1C91; Fri, 11 Dec 2020 16:56:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DEFF1EC4AA
	for <dm-devel@redhat.com>; Fri, 11 Dec 2020 16:56:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7F0C88007DF
	for <dm-devel@redhat.com>; Fri, 11 Dec 2020 16:56:15 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-127-0A0dGRyKPe2F30bEh5RxVQ-1;
	Fri, 11 Dec 2020 11:56:11 -0500
X-MC-Unique: 0A0dGRyKPe2F30bEh5RxVQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 4547BB066;
	Fri, 11 Dec 2020 16:56:09 +0000 (UTC)
To: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>,
	Sergei Shtepa <sergei.shtepa@veeam.com>, hch@lst.de
References: <1607518911-30692-1-git-send-email-sergei.shtepa@veeam.com>
	<20201209135148.GA32720@redhat.com> <20201210145814.GA31521@veeam.com>
	<20201210163222.GB10239@redhat.com> <20201211163049.GC16168@redhat.com>
	<1ee7652e-b77f-6fa4-634c-ff6639037321@kernel.dk>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <208edf35-ecdc-2d73-4c48-0424943a78c0@suse.de>
Date: Fri, 11 Dec 2020 17:56:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <1ee7652e-b77f-6fa4-634c-ff6639037321@kernel.dk>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0BBGuIvR020537
X-loop: dm-devel@redhat.com
Cc: "steve@sk2.org" <steve@sk2.org>,
	"johannes.thumshirn@wdc.com" <johannes.thumshirn@wdc.com>,
	Pavel Tide <Pavel.TIde@veeam.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"ming.lei@redhat.com" <ming.lei@redhat.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	dm-devel@redhat.com, "koct9i@gmail.com" <koct9i@gmail.com>
Subject: Re: [dm-devel] [PATCH 0/3] block: blk_interposer - Block Layer
	Interposer
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

T24gMTIvMTEvMjAgNTozMyBQTSwgSmVucyBBeGJvZSB3cm90ZToKPiBPbiAxMi8xMS8yMCA5OjMw
IEFNLCBNaWtlIFNuaXR6ZXIgd3JvdGU6Cj4+IFdoaWxlIEkgc3RpbGwgdGhpbmsgdGhlcmUgbmVl
ZHMgdG8gYmUgYSBwcm9wZXIgX3Vwc3RyZWFtXyBjb25zdW1lciBvZgo+PiBibGtfaW50ZXJwb3Nl
ciBhcyBhIGNvbmRpdGlvbiBvZiBpdCBnb2luZyBpbi4uIEknbGwgbGV0IG90aGVycyBtYWtlIHRo
ZQo+PiBjYWxsLgo+IAo+IFRoYXQncyBhbiB1bmVxdWl2b2NhbCBydWxlLgo+IAo+PiBBcyBzdWNo
LCBJJ2xsIGRlZmVyIHRvIEplbnMsIENocmlzdG9waCBhbmQgb3RoZXJzIG9uIHdoZXRoZXIgeW91
cgo+PiBtaW5pbWFsaXN0IGJsa19pbnRlcnBvc2VyIGhvb2sgaXMgYWNjZXB0YWJsZSBpbiB0aGUg
bmVhci10ZXJtLgo+IAo+IEkgZG9uJ3QgdGhpbmsgc28sIHdlIGRvbid0IGRvIHNob3J0IHRlcm0g
YmFuZGFpZHMganVzdCB0byBwbGFuIG9uCj4gcmlwcGluZyB0aGF0IG91dCB3aGVuIHRoZSByZWFs
IGZ1bmN0aW9uYWxpdHkgaXMgdGhlcmUuIElNSE8sIHRoZSBkbQo+IGFwcHJvYWNoIGlzIHRoZSB3
YXkgdG8gZ28gLSBpdCBwcm92aWRlcyBleGFjdGx5IHRoZSBmdW5jdGlvbmFsaXR5IHRoYXQKPiBp
cyBuZWVkZWQgaW4gYW4gYXBwcm9wcmlhdGUgd2F5LCBpbnN0ZWFkIG9mIGhhY2tpbmcgc29tZSAi
aW50ZXJwb3NlciIKPiBpbnRvIHRoZSBjb3JlIGJsb2NrIGxheWVyLgo+IApXaGljaCBpcyBteSBw
bGFuLCB0b28uCgpJJ2xsIGJlIHdvcmtpbmcgd2l0aCB0aGUgVmVlYW0gZm9sa3MgdG8gcHJlc2Vu
dCBhIGpvaW50IHBhdGNoc2V0IAooaW5jbHVkaW5nIHRoZSBETSBiaXRzKSBmb3IgdGhlIG5leHQg
cm91bmQuCgpDaGVlcnMsCgpIYW5uZXMKLS0gCkRyLiBIYW5uZXMgUmVpbmVja2UgICAgICAgICAg
ICAgICAgS2VybmVsIFN0b3JhZ2UgQXJjaGl0ZWN0CmhhcmVAc3VzZS5kZSAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICs0OSA5MTEgNzQwNTMgNjg4ClNVU0UgU29mdHdhcmUgU29sdXRpb25z
IEdtYkgsIE1heGZlbGRzdHIuIDUsIDkwNDA5IE7DvHJuYmVyZwpIUkIgMzY4MDkgKEFHIE7DvHJu
YmVyZyksIEdlc2Now6RmdHNmw7xocmVyOiBGZWxpeCBJbWVuZMO2cmZmZXIKCgotLQpkbS1kZXZl
bCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29t
L21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=

