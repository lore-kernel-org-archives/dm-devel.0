Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D260C63708
	for <dm-devel@archiver.kernel.org>; Wed,  7 Dec 2022 13:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670420245;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=aRxHuAxqQQyT3eLU9dCCDHRaWgUew1YQcIg7c2HIyQQ=;
	b=TknJ7GD2WiHAgGgJRwh3i94ZzgbXDZB+wvnrTp/F4vG1t4257gKvQeq6IAbFSzKO9kC0BX
	4/kPqsYJ3iMR5RM5Kf/EfGA84rw+ymjn20A1eqBj1g6+eX0YHRBMhpCClMOljMZLUK42M7
	EDlIjPdOWknbA2AB0/BafTYgj+bSLPI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-452-6f9ii39_Pa-GKwzNvU_GNQ-1; Wed, 07 Dec 2022 08:37:23 -0500
X-MC-Unique: 6f9ii39_Pa-GKwzNvU_GNQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4920A857FAB;
	Wed,  7 Dec 2022 13:37:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EEFCE4A927B;
	Wed,  7 Dec 2022 13:37:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 846FA1946A68;
	Wed,  7 Dec 2022 13:37:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 00E591946586
 for <dm-devel@listman.corp.redhat.com>; Tue,  6 Dec 2022 19:31:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C34481410DD9; Tue,  6 Dec 2022 19:31:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BB467140EBF5
 for <dm-devel@redhat.com>; Tue,  6 Dec 2022 19:31:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 859D038343C0
 for <dm-devel@redhat.com>; Tue,  6 Dec 2022 19:31:33 +0000 (UTC)
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-564-XcS2PB8_NpiVQwxqMtJoTA-1; Tue,
 06 Dec 2022 14:31:30 -0500
X-MC-Unique: XcS2PB8_NpiVQwxqMtJoTA-1
Received: from [192.168.0.2] (ip5f5aeffe.dynamic.kabel-deutschland.de
 [95.90.239.254])
 (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested) (Authenticated sender: pmenzel)
 by mx.molgen.mpg.de (Postfix) with ESMTPSA id EAFA660027FC0;
 Tue,  6 Dec 2022 20:31:27 +0100 (CET)
Message-ID: <b28ab260-7a5a-4801-4d33-80c66ae25f89@molgen.mpg.de>
Date: Tue, 6 Dec 2022 20:31:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
To: Gulam Mohamed <gulam.mohamed@oracle.com>
References: <20221206181536.13333-1-gulam.mohamed@oracle.com>
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20221206181536.13333-1-gulam.mohamed@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Wed, 07 Dec 2022 13:37:16 +0000
Subject: Re: [dm-devel] [RFC] block: Change the granularity of io ticks from
 ms to ns
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, song@kernel.org,
 dm-devel@redhat.com, ira.weiny@intel.com, agk@redhat.com,
 drbd-dev@lists.linbit.com, dave.jiang@intel.com, minchan@kernel.org,
 vishal.l.verma@intel.com, konrad.wilk@oracle.com, kent.overstreet@gmail.com,
 ngupta@vflare.org, kch@nvidia.com, senozhatsky@chromium.org,
 snitzer@kernel.org, colyli@suse.de, linux-block@vger.kernel.org,
 linux-bcache@vger.kernel.org, dan.j.williams@intel.com, axboe@kernel.dk,
 linux-raid@vger.kernel.org, martin.petersen@oracle.com,
 philipp.reisner@linbit.com, junxiao.bi@oracle.com,
 christoph.boehmwalder@linbit.com, lars.ellenberg@linbit.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

RGVhciBHdWxhbSwKCgpUaGFuayB5b3UgZm9yIHRoZSBwYXRjaC4KCkFtIDA2LjEyLjIyIHVtIDE5
OjE1IHNjaHJpZWIgR3VsYW0gTW9oYW1lZDoKPiBVc2Uga3RpbWUgdG8gY2hhbmdlIHRoZSBncmFu
dWxhcml0eSBvZiBJTyBhY2NvdW50aW5nIGluIGJsb2NrIGxheWVyIGZyb20KPiBtaWxsaS1zZWNv
bmRzIHRvIG5hbm8tc2Vjb25kcyB0byBnZXQgdGhlIHByb3BlciBsYXRlbmN5IHZhbHVlcyBmb3Ig
dGhlCj4gZGV2aWNlcyB3aG9zZSBsYXRlbmN5IGlzIGluIG1pY3JvLXNlY29uZHMuIEFmdGVyIGNo
YW5naW5nIHRoZSBncmFudWxhcml0eQo+IHRvIG5hbm8tc2Vjb25kcyB0aGUgaW9zdGF0IGNvbW1h
bmQsIHdoaWNoIHdhcyBzaG93aW5nIGluY29ycmVjdCB2YWx1ZXMgZm9yCj4gJXV0aWwsIGlzIG5v
dyBzaG93aW5nIGNvcnJlY3QgdmFsdWVzLgo+IAo+IFdlIGRpZCBub3Qgd29yayBvbiB0aGUgcGF0
Y2ggdG8gZHJvcCB0aGUgbG9naWMgZm9yCj4gU1RBVF9QUkVDSVNFX1RJTUVTVEFNUFMgeWV0LiBX
aWxsIGRvIGl0IGlmIHRoaXMgcGF0Y2ggaXMgb2suCj4gCj4gVGhlIGlvc3RhdCBjb21tYW5kIHdh
cyBydW4gYWZ0ZXIgc3RhcnRpbmcgdGhlIGZpbyB3aXRoIGZvbGxvd2luZyBjb21tYW5kCj4gb24g
YW4gTlZNRSBkaXNrLiBGb3IgdGhlIHNhbWUgZmlvIGNvbW1hbmQsIHRoZSBpb3N0YXQgJXV0aWwg
d2FzIHNob3dpbmcKPiB+MTAwJSBmb3IgdGhlIGRpc2tzIHdob3NlIGxhdGVuY2llcyBhcmUgaW4g
dGhlIHJhbmdlIG9mIG1pY3Jvc2Vjb25kcy4KPiBXaXRoIHRoZSBrZXJuZWwgY2hhbmdlcyAoZ3Jh
bnVsYXJpdHkgdG8gbmFuby1zZWNvbmRzKSwgdGhlICV1dGlsIHdhcwo+IHNob3dpbmcgY29ycmVj
dCB2YWx1ZXMuIEZvbGxvd2luZyBhcmUgdGhlIGRldGFpbHMgb2YgdGhlIHRlc3QgYW5kIHRoZWly
Cj4gb3V0cHV0Ogo+IAo+IGZpbyBjb21tYW5kCj4gLS0tLS0tLS0tLS0KPiBbZ2xvYmFsXQo+IGJz
PTEyOEsKPiBpb2RlcHRoPTEKPiBkaXJlY3Q9MQo+IGlvZW5naW5lPWxpYmFpbwo+IGdyb3VwX3Jl
cG9ydGluZwo+IHRpbWVfYmFzZWQKPiBydW50aW1lPTkwCj4gdGhpbmt0aW1lPTFtcwo+IG51bWpv
YnM9MQo+IG5hbWU9cmF3LXdyaXRlCj4gcnc9cmFuZHJ3Cj4gaWdub3JlX2Vycm9yPUVJTzpFSU8K
PiBbam9iMV0KPiBmaWxlbmFtZT0vZGV2L252bWUwbjEKPiAKPiBDb3JyZWN0IHZhbHVlcyBhZnRl
ciBrZXJuZWwgY2hhbmdlczoKPiA9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0K
PiBpb3N0YXQgb3V0cHV0Cj4gLS0tLS0tLS0tLS0tLQo+IGlvc3RhdCAtZCAvZGV2L252bWUwbjEg
LXggMQo+IAo+IERldmljZSAgICAgICAgICAgIHJfYXdhaXQgd19hd2FpdCBhcXUtc3ogcmFyZXEt
c3ogd2FyZXEtc3ogIHN2Y3RtICAldXRpbAo+IG52bWUwbjEgICAgICAgICAgICAgIDAuMDggICAg
MC4wNSAgIDAuMDYgICAxMjguMDAgICAxMjguMDAgICAwLjA3ICAgNi41MAo+IAo+IERldmljZSAg
ICAgICAgICAgIHJfYXdhaXQgd19hd2FpdCBhcXUtc3ogcmFyZXEtc3ogd2FyZXEtc3ogIHN2Y3Rt
ICAldXRpbAo+IG52bWUwbjEgICAgICAgICAgICAgIDAuMDggICAgMC4wNiAgIDAuMDYgICAxMjgu
MDAgICAxMjguMDAgICAwLjA3ICAgNi4zMAo+IAo+IERldmljZSAgICAgICAgICAgIHJfYXdhaXQg
d19hd2FpdCBhcXUtc3ogcmFyZXEtc3ogd2FyZXEtc3ogIHN2Y3RtICAldXRpbAo+IG52bWUwbjEg
ICAgICAgICAgICAgIDAuMDYgICAgMC4wNSAgIDAuMDYgICAxMjguMDAgICAxMjguMDAgICAwLjA2
ICAgNS43MAo+IAo+ICBGcm9tIGZpbwo+IC0tLS0tLS0tCj4gUmVhZCBMYXRlbmN5OiBjbGF0ICh1
c2VjKTogbWluPTMyLCBtYXg9MjMzNSwgYXZnPTc5LjU0LCBzdGRldj0yOS45NQo+IFdyaXRlIExh
dGVuY3k6IGNsYXQgKHVzZWMpOiBtaW49MzgsIG1heD0xMzAsIGF2Zz01Ny43Niwgc3RkZXY9IDMu
MjUKPiAKPiBWYWx1ZXMgYmVmb3JlIGtlcm5lbCBjaGFuZ2VzCj4gPT09PT09PT09PT09PT09PT09
PT09PT09PT09PQo+IGlvc3RhdCBvdXRwdXQKPiAtLS0tLS0tLS0tLS0tCj4gCj4gaW9zdGF0IC1k
IC9kZXYvbnZtZTBuMSAteCAxCj4gCj4gRGV2aWNlICAgICAgICAgICAgcl9hd2FpdCB3X2F3YWl0
IGFxdS1zeiByYXJlcS1zeiB3YXJlcS1zeiAgc3ZjdG0gICV1dGlsCj4gbnZtZTBuMSAgICAgICAg
ICAgICAgMC4wOCAgICAwLjA2ICAgMC4wNiAgIDEyOC4wMCAgIDEyOC4wMCAgIDEuMDcgIDk3Ljcw
Cj4gCj4gRGV2aWNlICAgICAgICAgICAgcl9hd2FpdCB3X2F3YWl0IGFxdS1zeiByYXJlcS1zeiB3
YXJlcS1zeiAgc3ZjdG0gICV1dGlsCj4gbnZtZTBuMSAgICAgICAgICAgICAgMC4wOCAgICAwLjA2
ICAgMC4wNiAgIDEyOC4wMCAgIDEyOC4wMCAgIDEuMDggIDk4LjgwCj4gCj4gRGV2aWNlICAgICAg
ICAgICAgcl9hd2FpdCB3X2F3YWl0IGFxdS1zeiByYXJlcS1zeiB3YXJlcS1zeiAgc3ZjdG0gICV1
dGlsCj4gbnZtZTBuMSAgICAgICAgICAgICAgMC4wOCAgICAwLjA1ICAgMC4wNiAgIDEyOC4wMCAg
IDEyOC4wMCAgIDEuMDYgIDk3LjIwCj4gCj4gIEZyb20gZmlvCj4gLS0tLS0tLS0KPiBSZWFkIExh
dGVuY3k6IGNsYXQgKHVzZWMpOiBtaW49MzMsIG1heD00NjgsIGF2Zz03OS41Niwgc3RkZXY9Mjgu
MDQKPiBXcml0ZSBMYXRlbmN5OiBjbGF0ICh1c2VjKTogbWluPTksIG1heD0xMzksIGF2Zz01Ny4x
MCwgc3RkZXY9IDMuNzkKCknigJlkIG9yZGVyIHRoZSBudW1iZXJzIGJlZm9yZSB0aGUgY2hhbmdl
IGZpcnN0LCBidXQgaXTigJlzIG5vdCBpbXBvcnRhbnQuCgo+IFNpZ25lZC1vZmYtYnk6IEp1bnhp
YW8gQmkgPGp1bnhpYW8uYmlAb3JhY2xlLmNvbT4KPiBTaWduZWQtb2ZmLWJ5OiBHdWxhbSBNb2hh
bWVkIDxndWxhbS5tb2hhbWVkQG9yYWNsZS5jb20+CgooSWYgSnVueGlhbyBpcyB0aGUgcGF0Y2gg
YXV0aG9yLCB0aGF0IG5hbWUgc2hvdWxkIGJlIGRvY3VtZW50ZWQgYXMgdGhlIApwYXRjaCBhdXRo
b3IuKQoKPiAtLS0KPiAgIGJsb2NrL2Jsay1jb3JlLmMgICAgICAgICAgICAgICAgICB8IDI2ICsr
KysrKysrKysrKystLS0tLS0tLS0tLS0tCj4gICBibG9jay9ibGstbXEuYyAgICAgICAgICAgICAg
ICAgICAgfCAgNCArKy0tCj4gICBibG9jay9ibGsuaCAgICAgICAgICAgICAgICAgICAgICAgfCAg
MiArLQo+ICAgYmxvY2svZ2VuaGQuYyAgICAgICAgICAgICAgICAgICAgIHwgIDggKysrKy0tLS0K
PiAgIGRyaXZlcnMvYmxvY2svZHJiZC9kcmJkX2RlYnVnZnMuYyB8ICA0ICsrLS0KPiAgIGRyaXZl
cnMvYmxvY2svZHJiZC9kcmJkX2ludC5oICAgICB8ICAyICstCj4gICBkcml2ZXJzL2Jsb2NrL3py
YW0venJhbV9kcnYuYyAgICAgfCAgNCArKy0tCj4gICBkcml2ZXJzL21kL2JjYWNoZS9yZXF1ZXN0
LmMgICAgICAgfCAxMCArKysrKy0tLS0tCj4gICBkcml2ZXJzL21kL2RtLWNvcmUuaCAgICAgICAg
ICAgICAgfCAgMiArLQo+ICAgZHJpdmVycy9tZC9kbS5jICAgICAgICAgICAgICAgICAgIHwgIDgg
KysrKy0tLS0KPiAgIGRyaXZlcnMvbWQvbWQuaCAgICAgICAgICAgICAgICAgICB8ICAyICstCj4g
ICBkcml2ZXJzL21kL3JhaWQxLmggICAgICAgICAgICAgICAgfCAgMiArLQo+ICAgZHJpdmVycy9t
ZC9yYWlkMTAuaCAgICAgICAgICAgICAgIHwgIDIgKy0KPiAgIGRyaXZlcnMvbWQvcmFpZDUuYyAg
ICAgICAgICAgICAgICB8ICAyICstCj4gICBkcml2ZXJzL252ZGltbS9idHQuYyAgICAgICAgICAg
ICAgfCAgMiArLQo+ICAgZHJpdmVycy9udmRpbW0vcG1lbS5jICAgICAgICAgICAgIHwgIDIgKy0K
PiAgIGluY2x1ZGUvbGludXgvYmxrX3R5cGVzLmggICAgICAgICB8ICAyICstCj4gICBpbmNsdWRl
L2xpbnV4L2Jsa2Rldi5oICAgICAgICAgICAgfCAxNCArKysrKysrLS0tLS0tLQo+ICAgaW5jbHVk
ZS9saW51eC9wYXJ0X3N0YXQuaCAgICAgICAgIHwgIDIgKy0KPiAgIDE5IGZpbGVzIGNoYW5nZWQs
IDUwIGluc2VydGlvbnMoKyksIDUwIGRlbGV0aW9ucygtKQo+IAo+IGRpZmYgLS1naXQgYS9ibG9j
ay9ibGstY29yZS5jIGIvYmxvY2svYmxrLWNvcmUuYwo+IGluZGV4IDU0ODc5MTJiZWZlOC4uMDY5
YzI5ZGFkM2U3IDEwMDY0NAo+IC0tLSBhL2Jsb2NrL2Jsay1jb3JlLmMKPiArKysgYi9ibG9jay9i
bGstY29yZS5jCj4gQEAgLTkxMiwxMiArOTEyLDEyIEBAIGludCBpb2NiX2Jpb19pb3BvbGwoc3Ry
dWN0IGtpb2NiICpraW9jYiwgc3RydWN0IGlvX2NvbXBfYmF0Y2ggKmlvYiwKPiAgIH0KPiAgIEVY
UE9SVF9TWU1CT0xfR1BMKGlvY2JfYmlvX2lvcG9sbCk7Cj4gICAKPiAtdm9pZCB1cGRhdGVfaW9f
dGlja3Moc3RydWN0IGJsb2NrX2RldmljZSAqcGFydCwgdW5zaWduZWQgbG9uZyBub3csIGJvb2wg
ZW5kKQo+ICt2b2lkIHVwZGF0ZV9pb190aWNrcyhzdHJ1Y3QgYmxvY2tfZGV2aWNlICpwYXJ0LCB1
NjQgbm93LCBib29sIGVuZCkKPiAgIHsKPiAtCXVuc2lnbmVkIGxvbmcgc3RhbXA7Cj4gKwl1NjQg
c3RhbXA7CgpEaWQgeW91IGNoZWNrIHRoZSBjb2RlIHNpemUgZGlmZmVyZW5jZSB3aXRoIGBzY3Jp
cHRzL2Jsb2F0LW8tbWV0ZXJgPwoKSW5zdGVhZCBvZiB0aGUgZml4ZWQtc2l6ZSB0eXBlLCBJ4oCZ
ZCB1c2UgYHVuc2lnbmVkIGxvbmcgbG9uZ2AgdG8gZW5zdXJlIAp0aGUgbWluaW11bSBzaXplIGlz
IDY0LWJpdC4KCj4gICBhZ2FpbjoKPiAgIAlzdGFtcCA9IFJFQURfT05DRShwYXJ0LT5iZF9zdGFt
cCk7Cj4gLQlpZiAodW5saWtlbHkodGltZV9hZnRlcihub3csIHN0YW1wKSkpIHsKPiArCWlmICh1
bmxpa2VseSh0aW1lX2FmdGVyNjQobm93LCBzdGFtcCkpKSB7CgpObyBpZGVhLCBpZiBpdOKAmXMg
cG9zc2libGUgd2l0aCBgdGltZV9hZnRlcjY0KClgIHRob3VnaCwgYXMgdGhhdCB1c2VzIApgX191
NjRgLgoKW+KApl0KCgpLaW5kIHJlZ2FyZHMsCgpQYXVsCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxp
c3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFu
L2xpc3RpbmZvL2RtLWRldmVsCg==

