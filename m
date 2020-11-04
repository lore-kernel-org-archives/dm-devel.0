Return-Path: <SRS0=DU+z=EK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9846EC2D0A3
	for <dm-devel@archiver.kernel.org>; Wed,  4 Nov 2020 14:16:12 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D5C5121734
	for <dm-devel@archiver.kernel.org>; Wed,  4 Nov 2020 14:16:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D5C5121734
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-G4bcBkQ2O3iVvELB67-LYw-1; Wed, 04 Nov 2020 09:16:08 -0500
X-MC-Unique: G4bcBkQ2O3iVvELB67-LYw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 036291099F74;
	Wed,  4 Nov 2020 14:16:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4A80C82CF7;
	Wed,  4 Nov 2020 14:16:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1455C181A86E;
	Wed,  4 Nov 2020 14:16:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A4EBEBY011106 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 4 Nov 2020 09:11:14 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 537232156729; Wed,  4 Nov 2020 14:11:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4DB972156726
	for <dm-devel@redhat.com>; Wed,  4 Nov 2020 14:11:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E81331842085
	for <dm-devel@redhat.com>; Wed,  4 Nov 2020 14:11:10 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-238-yIcxAmvBMLuLqRV0A5f7Yg-1;
	Wed, 04 Nov 2020 09:11:08 -0500
X-MC-Unique: yIcxAmvBMLuLqRV0A5f7Yg-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id BAFC1B227;
	Wed,  4 Nov 2020 14:11:05 +0000 (UTC)
To: Benjamin Marzinski <bmarzins@redhat.com>, Martin Wilck <mwilck@suse.com>
References: <e77c4409175db94f97543991632c323a78ab3ef9.camel@suse.com>
	<20201102224048.GV3384@octiron.msp.redhat.com>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <b0c9073c-1c1e-04d0-7edf-e2d66c0094be@suse.de>
Date: Wed, 4 Nov 2020 15:11:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201102224048.GV3384@octiron.msp.redhat.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0A4EBEBY011106
X-loop: dm-devel@redhat.com
Cc: Hannes Reinecke <hare@suse.com>,
	dm-devel mailing list <dm-devel@redhat.com>
Subject: Re: [dm-devel] Thoughts about multipathd's log thread
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMTEvMi8yMCAxMTo0MCBQTSwgQmVuamFtaW4gTWFyemluc2tpIHdyb3RlOgo+IE9uIE1vbiwg
Tm92IDAyLCAyMDIwIGF0IDAxOjE3OjI4UE0gKzAxMDAsIE1hcnRpbiBXaWxjayB3cm90ZToKPj4g
KHNlbmRpbmcgYWdhaW4sIHdpdGggZG0tZGV2ZWwgb24gY2MuIFNvcnJ5ISkKPj4KPj4gSGkgQmVu
LCBoaSBDaHJpc3RvcGhlLAo+Pgo+PiBBRkFJVSwgdGhlIHB1cnBvc2Ugb2YgdGhlIGxvZyB0aHJl
YWQgaXMgdG8gYXZvaWQgYmxvY2tpbmcgd2hpbGUgd3JpdGluZwo+PiBsb2cgbWVzc2FnZXMgdG8g
dGhlIHN5c2xvZyBzb2NrZXQuIFRoZSB0aHJlYWQgaGFzIGJlZW4gaW4gcGxhY2UgZm9yIGEKPj4g
bG9uZyB0aW1lLiBIb3dldmVyLCB0aGUgbGFyZ2UgbWFqb3JpdHkgb2YgbXVsdGlwYXRoIGluc3Rh
bGxhdGlvbnMgdG9kYXkKPj4gcnVucyBvbiBzeXN0ZW1kLWVuYWJsZWQgc3lzdGVtcywgd2hlcmUg
d2UgZG9uJ3QgdXNlIHRoZSBsb2cgdGhyZWFkLgo+PiBSYXRoZXIsIHdlIHdyaXRlIHRvIHN0ZGVy
ciAod2hpY2ggaXMgYWN0dWFsbHkgYSBqb3VybmFsZCBzb2NrZXQpCj4+IGRpcmVjdGx5Lgo+Pgo+
PiBUaGF0IG1ha2VzIG1lIHdvbmRlcjogaWYgdGhlIHByb2JsZW0gb2YgYmxvY2tpbmcgd2hpbGUg
d3JpdGluZyB0byB0aGUKPj4gbG9nIHNvY2tldCBpcyByZWFsLCBpdCBzaG91bGQgaGFwcGVuIHdp
dGggam91cm5hbGQgYXMgd2VsbCAocG9zc2libHkKPj4gbW9yZSBzbyB0aGFuIHdpdGggc3lzbG9n
ZDsgam91cm5hbGQgZG9lc24ndCBleGFjdGx5IGhhdmUgdGhlIHJlcHV0YXRpb24KPj4gb2YgYmVp
bmcgaGlnaGx5IGVmZmljaWVudCkuIFRodXMsIHdlIHNob3VsZCBiZSB1c2luZyB0aGUgbG9nIHRo
cmVhZAo+PiBhbHNvIGZvciB0aGUgc3lzdGVtZCBjYXNlCj4gCj4gSXQgZG9lcyBzZWVtIHNvcnQg
b2Ygd2FzdGVmdWwgdG8gbWUgdG8gaGF2ZSBhIHRocmVhZCBidWZmZXJpbmcgd3JpdGVzIHRvCj4g
YSBkYWVtb24gdGhhdCBpdHNlbGYgYnVmZmVycyB3cml0ZXMuIElmIGpvdXJuYWxkIGlzIGJsb2Nr
aW5nIGxvZ2dpbmcKPiBwcm9jZXNzZXMgZnJvbSBjb250aW51aW5nLCB0aGF0J3MgYSBiaWcgcHJv
YmxlbSwgYW5kIG5vdCBqdXN0IGZvcgo+IG11bHRpcGF0aC4gT2J2aW91c2x5IG11bHRpcGF0aGQs
IG9yIGF0IHRoZSB2ZXJ5IGxlYXN0LCBwYXRoIGNoZWNraW5nLCBpcwo+IHN1cHBvc2VkIHRvIGNv
bnRpbnVlIHdvcmtpbmcgd2hlbiB0aGVyZSBpcyBubyBhY2Nlc3MgdG8gdGhlIHJvb3QKPiBmaWxl
c3lzdGVtLCB3aGljaCBpcyBhIHN0cmljdGVyIHJlcXVpcmVtZW50IHRoYW4gb3RoZXIgcHJvZ3Jh
bXMgaGF2ZS4KPiBCdXQgSU8gZGVsYXlzIGhhcHBlbiwgYW5kIGpvdXJuYWxkIGJldHRlciBiZSBk
ZWNvdXBsaW5nIHRoZW0gZnJvbSB0aGUKPiBsb2dnaW5nIHByb2Nlc3MuIEkgaGF2ZSBzZWVuIGpv
dXJuYWxkIGRyb3AgbG9nIG1lc3NhZ2VzLCBwcmVzdW1hYmx5Cj4gYmVjYXVzZSBpdCBpc24ndCBq
dXN0IGJsb2NraW5nIGV2ZXJ5dGhpbmcgdGhhdCB3YW50cyB0byBsb2cgdG8gaXQuCj4gCj4+ICAg
T1RPSCwgSSdtIG5vdCBhd2FyZSBvZiBhbnkgYnVnIHJlcG9ydHMKPj4gc2F5aW5nIHRoYXQgbXVs
dGlwYXRoZCB3YXNuJ3QgYWJsZSB0byBoYW5kbGUgZXZlbnRzIGJlY2F1c2Ugb2YgYmxvY2tpbmcK
Pj4gbG9nIGNhbGxzLiBTbyBwZXJoYXBzIHRoZSBpc3N1ZSBpcyByYXRoZXIgdGhlb3JldGljYWw/
IEluIHRoYXQgY2FzZSwgd2UKPj4gY291bGQgZG8gYXdheSB3aXRoIGFsbCB0aGUgY29tcGxleGl0
eSB0aGUgbG9nIHRocmVhZCBpbnZvbHZlcy4KPj4KPj4gV2hhdCBkbyB5b3UgdGhpbms/Cj4gCj4g
SSBkbyBiZWxpZXZlIHRoYXQgc3lzbG9nIGlzIGFsbG93ZWQgdG8gYmxvY2sgdGhlIGNhbGxlciwg
YnV0IEkgYWdyZWUKPiB0aGF0IHdlJ3ZlIG1vc3RseSBtb3ZlZCBvbiB0byBhIHN5c3RlbWQgd29y
bGQgd2hlcmUgbXVsdGlwYXRoZCBpcwo+IHdyaXRpbmcgdG8gc3RkZXJyLiBSZW1vdmluZyB0aGlz
IHdpbGwgbWFrZSBtdWx0aXBhdGhkIHJ1biBhIHJlYWwgcmlzayBvZgo+IGhhbmdpbmcgb24gbG9n
Z2luZyB3aGVuIG5vdCBydW4gdGhyb3VnaCBzeXN0ZW1kLiBJIGp1c3QgZG9uJ3Qga25vdyBob3cK
PiBsaWtlbHkgdGhhdCBzY2VuYXJpbyBpcyBhbnltb3JlLgo+IApXZWxsIC4uLiBpc24ndCB0aGF0
IHdoYXQgdGhlIG9wdGlvbiAnLWQnIGlzIGZvcj8KTmFtZWx5IF9ub3RfIHN0YXJ0aW5nIHRoZSBs
b2cgdGhyZWFkIHdoZW4gcnVubmluZyB1bmRlciBzeXN0ZW1kPwoKQ2hlZXJzLAoKSGFubmVzCi0t
IApEci4gSGFubmVzIFJlaW5lY2tlICAgICAgICAgICAgICAgIEtlcm5lbCBTdG9yYWdlIEFyY2hp
dGVjdApoYXJlQHN1c2UuZGUgICAgICAgICAgICAgICAgICAgICAgICAgICAgICArNDkgOTExIDc0
MDUzIDY4OApTVVNFIFNvZnR3YXJlIFNvbHV0aW9ucyBHbWJILCBNYXhmZWxkc3RyLiA1LCA5MDQw
OSBOw7xybmJlcmcKSFJCIDM2ODA5IChBRyBOw7xybmJlcmcpLCBHZXNjaMOkZnRzZsO8aHJlcjog
RmVsaXggSW1lbmTDtnJmZmVyCgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJl
ZGhhdC5jb20KaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs

