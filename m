Return-Path: <SRS0=VSmt=FT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA35CC4361B
	for <dm-devel@archiver.kernel.org>; Tue, 15 Dec 2020 07:41:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2737E222B3
	for <dm-devel@archiver.kernel.org>; Tue, 15 Dec 2020 07:41:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2737E222B3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-182-ATX63DG0PduuSRSyGpMC2Q-1; Tue, 15 Dec 2020 02:41:30 -0500
X-MC-Unique: ATX63DG0PduuSRSyGpMC2Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2249B1015C82;
	Tue, 15 Dec 2020 07:41:25 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 52C1E71CB5;
	Tue, 15 Dec 2020 07:41:23 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 93A044BB7B;
	Tue, 15 Dec 2020 07:41:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BF7fHNw026552 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 15 Dec 2020 02:41:17 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 948BA2166B2B; Tue, 15 Dec 2020 07:41:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8F7822166B27
	for <dm-devel@redhat.com>; Tue, 15 Dec 2020 07:41:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5E415101A567
	for <dm-devel@redhat.com>; Tue, 15 Dec 2020 07:41:15 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-235-zmAccwhEP4i6x0VXyho9Vg-1;
	Tue, 15 Dec 2020 02:41:10 -0500
X-MC-Unique: zmAccwhEP4i6x0VXyho9Vg-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id BA42AAD0E;
	Tue, 15 Dec 2020 07:41:08 +0000 (UTC)
To: Bob Liu <bob.liu@oracle.com>, Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@redhat.com>,
	Sergei Shtepa <sergei.shtepa@veeam.com>, hch@lst.de
References: <1607518911-30692-1-git-send-email-sergei.shtepa@veeam.com>
	<20201209135148.GA32720@redhat.com> <20201210145814.GA31521@veeam.com>
	<20201210163222.GB10239@redhat.com> <20201211163049.GC16168@redhat.com>
	<1ee7652e-b77f-6fa4-634c-ff6639037321@kernel.dk>
	<208edf35-ecdc-2d73-4c48-0424943a78c0@suse.de>
	<cdc3c792-17ac-de61-12ae-74691769fc3c@oracle.com>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <299962c3-c52b-a580-5b1f-a21b9021f9e6@suse.de>
Date: Tue, 15 Dec 2020 08:41:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <cdc3c792-17ac-de61-12ae-74691769fc3c@oracle.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0BF7fHNw026552
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

T24gMTIvMTUvMjAgNzo1MSBBTSwgQm9iIExpdSB3cm90ZToKPiBIaSBGb2xrcywKPiAKPiBPbiAx
Mi8xMi8yMCAxMjo1NiBBTSwgSGFubmVzIFJlaW5lY2tlIHdyb3RlOgo+PiBPbiAxMi8xMS8yMCA1
OjMzIFBNLCBKZW5zIEF4Ym9lIHdyb3RlOgo+Pj4gT24gMTIvMTEvMjAgOTozMCBBTSwgTWlrZSBT
bml0emVyIHdyb3RlOgo+Pj4+IFdoaWxlIEkgc3RpbGwgdGhpbmsgdGhlcmUgbmVlZHMgdG8gYmUg
YSBwcm9wZXIgX3Vwc3RyZWFtXyBjb25zdW1lciBvZgo+Pj4+IGJsa19pbnRlcnBvc2VyIGFzIGEg
Y29uZGl0aW9uIG9mIGl0IGdvaW5nIGluLi4gSSdsbCBsZXQgb3RoZXJzIG1ha2UgdGhlCj4+Pj4g
Y2FsbC4KPj4+Cj4+PiBUaGF0J3MgYW4gdW5lcXVpdm9jYWwgcnVsZS4KPj4+Cj4+Pj4gQXMgc3Vj
aCwgSSdsbCBkZWZlciB0byBKZW5zLCBDaHJpc3RvcGggYW5kIG90aGVycyBvbiB3aGV0aGVyIHlv
dXIKPj4+PiBtaW5pbWFsaXN0IGJsa19pbnRlcnBvc2VyIGhvb2sgaXMgYWNjZXB0YWJsZSBpbiB0
aGUgbmVhci10ZXJtLgo+Pj4KPj4+IEkgZG9uJ3QgdGhpbmsgc28sIHdlIGRvbid0IGRvIHNob3J0
IHRlcm0gYmFuZGFpZHMganVzdCB0byBwbGFuIG9uCj4+PiByaXBwaW5nIHRoYXQgb3V0IHdoZW4g
dGhlIHJlYWwgZnVuY3Rpb25hbGl0eSBpcyB0aGVyZS4gSU1ITywgdGhlIGRtCj4+PiBhcHByb2Fj
aCBpcyB0aGUgd2F5IHRvIGdvIC0gaXQgcHJvdmlkZXMgZXhhY3RseSB0aGUgZnVuY3Rpb25hbGl0
eSB0aGF0Cj4+PiBpcyBuZWVkZWQgaW4gYW4gYXBwcm9wcmlhdGUgd2F5LCBpbnN0ZWFkIG9mIGhh
Y2tpbmcgc29tZSAiaW50ZXJwb3NlciIKPj4+IGludG8gdGhlIGNvcmUgYmxvY2sgbGF5ZXIuCj4+
Pgo+PiBXaGljaCBpcyBteSBwbGFuLCB0b28uCj4+Cj4+IEknbGwgYmUgd29ya2luZyB3aXRoIHRo
ZSBWZWVhbSBmb2xrcyB0byBwcmVzZW50IGEgam9pbnQgcGF0Y2hzZXQgKGluY2x1ZGluZyB0aGUg
RE0gYml0cykgZm9yIHRoZSBuZXh0IHJvdW5kLgo+Pgo+IAo+IEJlc2lkZXMgdGhlIGRtIGFwcHJv
YWNoLCBkbyB5b3UgdGhpbmsgVmVlYW0ncyBvcmlnaW5hbCByZXF1aXJlbWVudCBpcyBhIGdvb2QK
PiB1c2UgY2FzZSBvZiAiYmxvY2svYnBmOiBhZGQgZUJQRiBiYXNlZCBibG9jayBsYXllciBJTyBm
aWx0ZXJpbmciPwo+IGh0dHBzOi8vbHduLm5ldC9tbC9icGYvMjAyMDA4MTIxNjMzMDUuNTQ1NDQ3
LTEtbGVhaC5ydW1hbmNpa0BnbWFpbC5jb20vCj4gClRoYXQgd291bGQgYWN0dWFsbHkgYSByZWFs
bHkgY29vbCB1c2UtY2FzZS4KWW91IGNvdWxkIGFsc28gY29uc2lkZXIgYSBYRFAtbGlrZSBmdW5j
dGlvbmFsaXR5IGZvciBlQlBGLCB0byBtb3ZlIAppbmRpdmlkdWFsIHJlcXVlc3RzIGZyb20gb25l
IHF1ZXVlIHRvIHRoZSBvdGhlcjsgRE0gb24gc3Rlcm9pZHMgOi0pCgpTaG91bGQgSSB0cnkgdG8g
aW5jbHVkZSB0aGF0IHBhdGNoc2V0PwoKQ2hlZXJzLAoKSGFubmVzCi0tIApEci4gSGFubmVzIFJl
aW5lY2tlICAgICAgICAgICAgICAgIEtlcm5lbCBTdG9yYWdlIEFyY2hpdGVjdApoYXJlQHN1c2Uu
ZGUgICAgICAgICAgICAgICAgICAgICAgICAgICAgICArNDkgOTExIDc0MDUzIDY4OApTVVNFIFNv
ZnR3YXJlIFNvbHV0aW9ucyBHbWJILCBNYXhmZWxkc3RyLiA1LCA5MDQwOSBOw7xybmJlcmcKSFJC
IDM2ODA5IChBRyBOw7xybmJlcmcpLCBHZXNjaMOkZnRzZsO8aHJlcjogRmVsaXggSW1lbmTDtnJm
ZmVyCgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6
Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs

