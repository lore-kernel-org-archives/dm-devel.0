Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9955BC6FA89
	for <dm-devel@archiver.kernel.org>; Thu, 15 Sep 2022 18:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663265886;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=VEVQfiUz3dqyrm2V+0zwBNXivcvpdFDxF5g12vZja8A=;
	b=YlNUN+q57Fm0/3gmOk+nn1iPc1mZ7bDSSXO5ZdCl1rpwMtAvyR0G68NsudQnpMXzftkcYQ
	y2cWeo2A+i79K4EUV27BRqEmKiIv0w450gBUtbRkaIFPITo5rkrJYmFReSU4MiXVGKf7J7
	oEKQrPIyp7WTZRh2FDTvbgrr3XUY8YI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-388-He3v64sMNHmvQMZ2FSJCvQ-1; Thu, 15 Sep 2022 14:18:02 -0400
X-MC-Unique: He3v64sMNHmvQMZ2FSJCvQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1E8AE29324AD;
	Thu, 15 Sep 2022 18:18:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EA949492B04;
	Thu, 15 Sep 2022 18:17:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CA5291946587;
	Thu, 15 Sep 2022 18:17:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 08BF91946586
 for <dm-devel@listman.corp.redhat.com>; Thu, 15 Sep 2022 18:17:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C319410EB8; Thu, 15 Sep 2022 18:17:57 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A62F818ECC;
 Thu, 15 Sep 2022 18:17:56 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 28FIHtB5022202;
 Thu, 15 Sep 2022 13:17:55 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 28FIHs7p022201;
 Thu, 15 Sep 2022 13:17:54 -0500
Date: Thu, 15 Sep 2022 13:17:54 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Wu Guanghao <wuguanghao3@huawei.com>
Message-ID: <20220915181754.GA23693@octiron.msp.redhat.com>
References: <1660769316-5302-1-git-send-email-bmarzins@redhat.com>
 <44f7c759-943d-23c9-bcd0-b20b0457e329@huawei.com>
MIME-Version: 1.0
In-Reply-To: <44f7c759-943d-23c9-bcd0-b20b0457e329@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH V2 0/6] allowing path checking to be
 interrupted.
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
Cc: linfeilong <linfeilong@huawei.com>, lixiaokeng <lixiaokeng@huawei.com>,
 device-mapper development <dm-devel@redhat.com>,
 Martin Wilck <Martin.Wilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVGh1LCBTZXAgMTUsIDIwMjIgYXQgMDI6NTY6MzZQTSArMDgwMCwgV3UgR3VhbmdoYW8gd3Jv
dGU6Cj4gU29ycnkgZm9yIHRoZSBsYXRlIGZlZWRiYWNrLgo+IAo+IFRoZSB2ZXJzaW9uIHdlIGFy
ZSBjdXJyZW50bHkgdGVzdGluZyBpcyAwLjguNCwgc28gd2Ugb25seSBtZXJnZSB0aGUKPiBmaXJz
dCAzIHBhdGNoZXMgaW4gdGhpcyBzZXJpZXMgb2YgcGF0Y2hlcy4gVGhlbiBhZnRlciB0aGUgYWN0
dWFsIHRlc3QsCj4gaXQgd2FzIGZvdW5kIHRoYXQgdGhlIGVmZmVjdCBpbXByb3ZlbWVudCBpcyBu
b3QgdmVyeSBvYnZpb3VzLgo+IAo+IFRlc3QgZW52aXJvbm1lbnQ6IDEwMDAgbXVsdGlwYXRoIGRl
dmljZXMsIDE2IHBhdGhzIHBlciBkZXZpY2UKPiBUZXN0IGNvbW1hbmQ6ICBBZ2dyZWdhdGUgbXVs
dGlwYXRoIGRldmljZXMgdXNpbmcgbXVsdGlwYXRoZCBhZGQgcGF0aAo+IFRpbWUgY29uc3VtaW5n
IO+8iHRpbWUgZm9yIDE2IHBhdGhzIHRvIGFnZ3JlZ2F0ZSAxIG11bHRpcGF0aCBkZXZpY2UpOgo+
IDEuIE9yaWdpbmFsOgo+IAk8IDRzOiAgIDc2LjklOwo+IAk0c34xMHM6IDE4LjQlOwo+IAk+MTBz
OgkgNC43JTsKPiAyLiBBZnRlciB1c2luZyB0aGUgcGF0Y2hlczoKPiAJPCA0czoJNzkuMSU7Cj4g
CTRzfjEwczogMTguMiU7Cj4gCT4xMHM6CSAyLjclOwo+IAo+ID5Gcm9tIHRoZSByZXN1bHRzLCB0
aGUgdGltZS1jb25zdW1pbmcgaW1wcm92ZW1lbnQgb2YgdGhlIHBhdGNoIGlzIG5vdCBvYnZpb3Vz
LAo+IHNvIHdlIG1hZGUgYSBmZXcgY2hhbmdlcyB0byB0aGUgcGF0Y2ggYW5kIGl0IHdvcmtlZCBh
cyBleHBlY3RlZC4gVGhlIG1vZGlmaWNhdGlvbgo+IG9mIHRoZSBwYXRjaCBpcyBhcyBmb2xsb3dz
Ogo+IAo+IFBhdGhzX2NoZWNrZWQgaXMgY2hhbmdlZCB0byBjb25maWd1cmFibGUsIGN1cnJlbnQg
c2V0dGluZyBuID0gMi4KPiBSZW1vdmVkIGp1ZGdtZW50IG9uIGRpZmZfdGltZS4KPiBTbGVlcCBj
aGFuZ2UgZnJvbSAxMHVzIHRvIDVtcwoKSSB3b3JyeSB0aGF0IHRoaXMgaXMgZ2l2aW5nIHRvbyBt
dWNoIGRlZmVyZW5jZSB0byB0aGUgdWV2ZW50cy4gSWYgdGhlcmUKaXMgYSB1ZXZlbnQgc3Rvcm0s
IGNoZWNraW5nIHdpbGwgc3RvcCBmb3IgNW1zIGV2ZXJ5IDIgcGF0aHMgY2hlY2tlZC4gSSdtCndv
cnJpZWQgdGhhdCB0aGlzIHdpbGwgbWFrZSBpdCB0YWtlIHNpZ25pZmljYW50bHkgbG9uZ2VyIGZv
ciB0aGUgdGhlCnBhdGggY2hlY2tlciB0byBjb21wbGV0ZSBhIGN5Y2xlLiAgTWFraW5nIHBhdGhz
X2NoZWNrZWQgY29uZmlndXJhYmxlLCBzbwp0aGF0IHRoaXMgZG9lc24ndCB0cmlnZ2VyIHRvbyBv
ZnRlbiBkb2VzIGhlbHAgdG8gYXZvaWQgdGhlIGlzc3VlIHRoYXQKY2hlY2tpbmcgdGhlIHRpbWUg
ZnJvbSBjaGtfc3RhcnRfdGltZSB3YXMgZGVhbGluZyB3aXRoLCBhbmQgbWFrZXMgdGhlCm1lY2hh
bmljcyBvZiB0aGlzIHNpbXBsZXIuICBCdXQgNW1zIHNlZW1zIGxpa2UgYSBsb25nIHRpbWUgdG8g
aGF2ZSB0bwp3YWl0LCBqdXN0IHRvIG1ha2Ugc3VyZSB0aGF0IGFub3RoZXIgcHJvY2VzcyBoYWQg
dGhlIHRpbWUgdG8gZ3JhYiB0aGUKdmVjcyBsb2NrLiAgUGVyaGFwcyBpdCB3b3VsZCBiZSBiZXR0
ZXIgdG8gc2xlZXAgZm9yIGEgc2hvcnRlciBsZW5ndGggb2YKdGltZSwgYnV0IGluIGEgbG9vcCwg
d2hlcmUgd2UgY2FuIGNoZWNrIHRvIHNlZSBpZiBwcm9ncmVzcyBoYXMgYmVlbgptYWRlLCBwZXJo
YXBzIGJ5IGNoZWNraW5nIHNvbWUgY291bnRlciBvZiBldmVudHMgYW5kIHVzZXIgY29tbWFuZHMK
c2VydmljZWQuIFRoaXMgd2F5LCB3ZSBhcmVuJ3Qgc2xlZXBpbmcgdG9vIGxvbmcgZm9yIG5vIGdv
b2QgcmVhc29uLgoKPiBpZiAoKytwYXRoc19jaGVja2VkICUgbiA9PSAwICYmCj4gCWxvY2tfaGFz
X3dhaXRlcnMoJnZlY3MtPmxvY2spKSB7Cj4gCQlnZXRfbW9ub3RvbmljX3RpbWUoJmVuZF90aW1l
KTsKPiAJCXRpbWVzcGVjc3ViKCZlbmRfdGltZSwgJmNoa19zdGFydF90aW1lLAo+IAkJCSAgICAm
ZGlmZl90aW1lKTsKPiAJCWlmIChkaWZmX3RpbWUudHZfc2VjID4gMCkgLy8gRGVsZXRlIHRoZSBj
b2RlLCBnb3RvIGRpcmVjdGx5Cj4gCQkJZ290byB1bmxvY2s7Cj4gfQo+IAo+IGlmIChjaGVja2Vy
X3N0YXRlICE9IENIRUNLRVJfRklOSVNIRUQpIHsKPiAJLyogWWllbGQgdG8gd2FpdGVycyAqLwo+
IAkvL3N0cnVjdCB0aW1lc3BlYyB3YWl0ID0geyAudHZfbnNlYyA9IDEwMDAwLCB9Owo+IAkvL25h
bm9zbGVlcCgmd2FpdCwgTlVMTCk7Cj4gCXVzbGVlcCg1MDAwKTsgIC8vIHNsZWVwIGNoYW5nZSBm
cm9tIDEwdXMgdG8gNW1zCj4gfQo+IAo+IFRpbWUgY29uc3VtaW5n77yIQWZ0ZXIgbWFraW5nIHRo
ZSBhYm92ZSBjaGFuZ2VzIHRvIHRoZSBwYXRjaO+8iToKPiA8IDRzOiA5OS41JTsKPiA9IDRzOiAw
LjUlOwo+ID4gNHM6IDAlOwoKU2luY2UgSSBiZWxpZXZlIHRoYXQgdGhpcyBpcyBsaWtlbHkgY2F1
c2luZyBhIHJlYWwgaW1wYWN0IG9uIHRoZSBjaGVja2VyCnNwZWVkLCBJJ20gbm90IHN1cmUgdGhh
dCB3ZSdyZSBsb29raW5nIGZvciByZXN1bHRzIGxpa2UgdGhpcy4gQXJlIHlvdQpzZWVpbmcgVGhh
dCAicGF0aCBjaGVja2VycyB0b29rIGxvbmdlciB0aGFuIC4uLiIgbWVzc2FnZT8gSG93IGxvbmcg
ZG9lcwppdCBzYXkgdGhlIGNoZWNrZXIgaXMgdGFraW5nIChhbmQgd2hhdCBkbyB5b3UgaGF2ZSBt
YXhfcG9sbGluZ19pbnRlcnZhbApzZXQgdG8pPwoKLUJlbgoKPiDlnKggMjAyMi84LzE4IDQ6NDgs
IEJlbmphbWluIE1hcnppbnNraSDlhpnpgZM6Cj4gPiBXaGVuIHRoZXJlIGFyZSBhIGh1Z2UgbnVt
YmVyIG9mIHBhdGhzICg+IDEwMDAwKSBUaGUgYW1vdW50IG9mIHRpbWUgdGhhdAo+ID4gdGhlIGNo
ZWNrZXJsb29wIGNhbiBob2xkIHRoZSB2ZWNzIGxvY2sgZm9yIHdoaWxlIGNoZWNraW5nIHRoZSBw
YXRocyBjYW4KPiA+IGdldCB0byBiZSBsYXJnZSBlbm91Z2ggdGhhdCBpdCBzdGFydmVzIG90aGVy
IHZlY3MgbG9jayB1c2Vycy4gIElmIHBhdGgKPiA+IGNoZWNraW5nIHRha2VzIGxvbmcgZW5vdWdo
LCBpdCdzIHBvc3NpYmxlIHRoYXQgdXhsc25yIHRocmVhZHMgd2lsbCBuZXZlcgo+ID4gcnVuLiBU
byBkZWFsIHdpdGggdGhpcywgdGhpcyBwYXRjaHNldCBtYWtlcyBpdCBwb3NzaWJsZSB0byBkcm9w
IHRoZSB2ZWNzCj4gPiBsb2NrIHdoaWxlIGNoZWNraW5nIHRoZSBwYXRocywgYW5kIHRoZW4gcmVh
Y3F1aXJlIGl0IGFuZCBjb250aW51ZSB3aXRoCj4gPiB0aGUgbmV4dCBwYXRoIHRvIGNoZWNrLgo+
ID4gCj4gPiBNeSBjaG9pY2Ugb2Ygb25seSBjaGVja2luZyBpZiB0aGVyZSBhcmUgd2FpdGVycyBl
dmVyeSAxMjggcGF0aHMgY2hlY2tlZAo+ID4gYW5kIG9ubHkgaW50ZXJydXB0aW5nIGlmIHBhdGgg
Y2hlY2tpbmcgaGFzIHRha2VuIG1vcmUgdGhhbiBhIHNlY29uZCBhcmUKPiA+IGFyYml0cmFyeS4g
SSBkaWRuJ3Qgd2FudCB0byBzbG93IGRvd24gcGF0aCBjaGVja2luZyBpbiB0aGUgY29tbW9uIGNh
c2UKPiA+IHdoZXJlIHRoaXMgaXNuJ3QgYW4gaXNzdWUsIGFuZCBJIHdhbnRlZCB0byBhdm9pZCBw
YXRoIGNoZWNraW5nIGdldHRpbmcKPiA+IHN0YXJ2ZWQgYnkgb3RoZXIgdmVjcy0+bG9jayB1c2Vy
cy4gSGF2aW5nIHRoZSBjaGVja2VybG9vcCB3YWl0IGZvciAxMDAwMAo+ID4gbnNlYyB3YXMgYmFz
ZWQgb24gbXkgb3duIHRlc3Rpbmcgd2l0aCBhIHNldHVwIHVzaW5nIDRLIG11bHRpcGF0aCBkZXZp
ZXMKPiA+IHdpdGggNCBwYXRocyBlYWNoLiBUaGlzIHdhcyBhbG1vc3QgYWx3YXlzIGxvbmcgZW5v
dWdoIGZvciB0aGUgdWV2ZW50IG9yCj4gPiB1eGxzbnIgY2xpZW50IHRvIGdyYWIgdGhlIHZlY3Mg
bG9jaywgYnV0IEknbSBub3Qgc3VyZSBob3cgZGVwZW5kZW50IHRoaXMKPiA+IGlzIG9uIGRldGFp
bHMgb2YgdGhlIHN5c3RlbS4gRm9yIGluc3RhbmNlIHdpdGggbXkgc2V0dXAgaW4gbmV2ZXIgdG9v
awo+ID4gbW9yZSB0aGFuIDIwIHNlY29uZHMgdG8gY2hlY2sgdGhlIHBhdGhzLiBhbmQgdXN1YWxs
eSwgYSBsb29waW5nIHRocm91Z2gKPiA+IGFsbCB0aGUgcGF0aHMgdG9vayB3ZWxsIHVuZGVyIDEw
IHNlY29uZHMsIG1vc3Qgb2Z0ZW4gdW5kZXIgNS4gSSB3b3VsZAo+ID4gb25seSBvY2Nhc2lvbmFs
bHkgcnVuIGludG8gc2l0dWF0aW9ucyB3aGVyZSBhIHV4bHNuciBjbGllbnQgd291bGQgdGltZQo+
ID4gb3V0Lgo+ID4gCj4gPiBWMiBDaGFuZ2VzOgo+ID4gMDAwMzogU3dpdGNoZWQgdG8gYSBzaW1w
bGVyIG1ldGhvZCBvZiBkZXRlcm1pbmluZyB0aGUgcGF0aCB0byBjb250aW51ZQo+ID4gICAgICAg
Y2hlY2tpbmcgYXQsIGFzIHN1Z2dlc3RlZCBieSBNYXJ0aW4gV2lsY2suIEFsc28gZml4ZWQgYSBi
dWcgd2hlbgo+ID4gICAgICAgdGhlIHByZXZpb3VzIGluZGV4IHdhcyBsYXJnZXIgdGhhbiB0aGUg
Y3VycmVudCB2ZWN0b3Igc2l6ZS4KPiA+IAo+ID4gQmVuamFtaW4gTWFyemluc2tpICg2KToKPiA+
ICAgbXVsdGlwYXRoZDogVXNlIHJlZ3VsYXIgcHRocmVhZF9tdXRleF90IGZvciB3YWl0ZXJfbG9j
awo+ID4gICBtdWx0aXBhdGhkOiB0cmFjayB3YWl0ZXJzIGZvciBtdXRleF9sb2NrCj4gPiAgIG11
bHRpcGF0aGQ6IE9jY2FzaW9uYWxseSBhbGxvdyB3YWl0ZXJzIHRvIGludGVycnVwdCBjaGVja2lu
ZyBwYXRocwo+ID4gICBtdWx0aXBhdGhkOiBhbGxvdyB1eGxzbnIgY2xpZW50cyB0byBpbnRlcnJ1
cHQgY2hlY2tpbmcgcGF0aHMKPiA+ICAgbXVsdGlwYXRoZDogZml4IHV4bHNuciB0aW1lb3V0Cj4g
PiAgIG11bHRpcGF0aGQ6IERvbid0IGNoZWNrIGlmIHRpbWVzcGVjLnR2X3NlYyBpcyB6ZXJvCj4g
PiAKPiA+ICBsaWJtdWx0aXBhdGgvbG9jay5oICAgIHwgIDE2ICsrKysrCj4gPiAgbGlibXVsdGlw
YXRoL3N0cnVjdHMuaCB8ICAgMSArCj4gPiAgbXVsdGlwYXRoZC9tYWluLmMgICAgICB8IDE0NyAr
KysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLQo+ID4gIG11bHRpcGF0aGQv
dXhsc25yLmMgICAgfCAgMjMgKysrKystLQo+ID4gIG11bHRpcGF0aGQvdXhsc25yLmggICAgfCAg
IDEgKwo+ID4gIG11bHRpcGF0aGQvd2FpdGVyLmMgICAgfCAgMTQgKystLQo+ID4gIDYgZmlsZXMg
Y2hhbmdlZCwgMTM2IGluc2VydGlvbnMoKyksIDY2IGRlbGV0aW9ucygtKQo+ID4gCi0tCmRtLWRl
dmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRo
YXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

