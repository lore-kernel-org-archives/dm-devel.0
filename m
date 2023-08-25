Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00A82C3DA66
	for <dm-devel@archiver.kernel.org>; Fri, 25 Aug 2023 06:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1692945672;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=nBybB1ybhEnA4aJ/dy3JPplVlhCghUlbhR1y4MdtoeU=;
	b=cmhT7QPtRags/w3dY5v5A/Al97QiYbSbPeQHkdwIhEh3QonX/msHy3i/lDRP9X1DYS1Ecb
	tVtjPaPVuulm6ZPNvOOIsUsZI9C1nNujtDl6miGmIQvsgdVmL6B29g5dNIUxlwm8CzKobf
	JpfhfslHSW2VtLriLcxZU81ZyCKeX9w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-383-04j5iSHsNd2qE6vpJ25bow-1; Fri, 25 Aug 2023 02:41:08 -0400
X-MC-Unique: 04j5iSHsNd2qE6vpJ25bow-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 10F0F1044560;
	Fri, 25 Aug 2023 06:41:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1AAE540C6F4C;
	Fri, 25 Aug 2023 06:41:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AC4E819465A8;
	Fri, 25 Aug 2023 06:41:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 99F261946589
 for <dm-devel@listman.corp.redhat.com>; Fri, 25 Aug 2023 06:41:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5965B2166B27; Fri, 25 Aug 2023 06:41:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 50CF42166B26
 for <dm-devel@redhat.com>; Fri, 25 Aug 2023 06:41:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3446785CBE0
 for <dm-devel@redhat.com>; Fri, 25 Aug 2023 06:41:02 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-113-smP5BETGNDK0Kmap9W3Ltg-1; Fri, 25 Aug 2023 02:40:58 -0400
X-MC-Unique: smP5BETGNDK0Kmap9W3Ltg-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 3FC9C6340B;
 Fri, 25 Aug 2023 06:40:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A578DC433C9;
 Fri, 25 Aug 2023 06:40:56 +0000 (UTC)
Received: by mail-lf1-f54.google.com with SMTP id
 2adb3069b0e04-4ff9b389677so817226e87.3; 
 Thu, 24 Aug 2023 23:40:56 -0700 (PDT)
X-Gm-Message-State: AOJu0YySJXbOkEtNTbuh4NEjZ8cvCzlY9KEZTKdO72Z8rbydFxSMbtcj
 Y8LghkAf6koMo7BBA8GKKtDPkw6wiP1JkQW6kLw=
X-Google-Smtp-Source: AGHT+IGPD2aEMvFaklo3jAklk1fPCfCMIW5CcacHp0PxUv2igIzNHi2IlxZxuK4troY9ylLDd3v70bdKU+nHof0qYUU=
X-Received: by 2002:a05:6512:3b0b:b0:500:a08e:2fd3 with SMTP id
 f11-20020a0565123b0b00b00500a08e2fd3mr3250301lfv.21.1692945654672; Thu, 24
 Aug 2023 23:40:54 -0700 (PDT)
MIME-Version: 1.0
References: <20230825030956.1527023-1-yukuai1@huaweicloud.com>
In-Reply-To: <20230825030956.1527023-1-yukuai1@huaweicloud.com>
From: Song Liu <song@kernel.org>
Date: Thu, 24 Aug 2023 23:40:42 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7dYaJYx8xa-CAG1YSwggZdGRfcQWqTBY0915=_UdL49Q@mail.gmail.com>
Message-ID: <CAPhsuW7dYaJYx8xa-CAG1YSwggZdGRfcQWqTBY0915=_UdL49Q@mail.gmail.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH -next v2 0/7] md: initialize 'active_io'
 while allocating mddev
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
Cc: yi.zhang@huawei.com, yangerkun@huawei.com, snitzer@kernel.org,
 xni@redhat.com, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 dm-devel@redhat.com, yukuai3@huawei.com, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVGh1LCBBdWcgMjQsIDIwMjMgYXQgODoxNOKAr1BNIFl1IEt1YWkgPHl1a3VhaTFAaHVhd2Vp
Y2xvdWQuY29tPiB3cm90ZToKPgo+IEZyb206IFl1IEt1YWkgPHl1a3VhaTNAaHVhd2VpLmNvbT4K
Pgo+IENoYW5nZXMgaW4gdjI6Cj4gIC0gcmViYXNlIGZvciBtZC1uZXh0Owo+ICAtIHVwZGF0ZSBj
b21taXQgbWVzc2FnZSBmb3IgcGF0Y2ggMzsKCkFwcGxpZWQgdjIgdG8gbWQtbmV4dC4gQnV0IHRo
aXMgc2V0IHdvbid0IGdvIGludG8gNi42LgoKVGhhbmtzLApTb25nCgo+Cj4gVGhpcyBpcyB0aGUg
NHRoIHBhdGNoc2V0IHRvIGRvIHNvbWUgcHJlcGFyYXRvcnkgd29yayB0byBzeW5jaHJvbml6ZQo+
IGlvIHdpdGggYXJyYXkgcmVjb25maWd1cmF0aW9uLgo+Cj4gMSkgVGhlIGZpcnN0IHBhdGNoc2V0
IHJlZmFjdG9yICdhY3RpdmVfaW8nLCBtYWtlIHN1cmUgdGhhdCBtZGRldl9zdXNwZW5kKCkKPiB3
aWxsIHdhaXQgZm9yIGlvIHRvIGJlIGRvbmUuIFsxXQo+Cj4gMikgVGhlIHNlY29uZCBwYXRjaHNl
dCByZW1vdmUgJ3F1aWVzY2UnIGNhbGxiYWNrIGZyb20gbWRkZXZfc3VzcGVuZCgpLCBzbwo+IHRo
YXQgbWRkZXZfc3VzcGVuZCgpIGRvZXNuJ3QgcmVseSBvbiAncXVpZXNjZScgY2FsbGJhY2sgaXMg
cmVnaXN0ZXJlZCwKPiBhbmQgY2FuIGJlIHVzZWQgZm9yIGFsbCBwZXJzb25hbGl0ZXM7IFsyXQo+
Cj4gMykgTWFrZSBhcnJheSByZWNvbmZpZ3VyYXRpb24gaW5kZXBlbmRlbnQgZnJvbSBkYWVtb24g
dGhyZWFkLAo+IGFuZCBzeW5jaHJvbml6ZSBpdCB3aXRoIGlvIHdpbGwgYmUgbXVjaCBlYXNpZXIg
YmVjYXVzZSBpbyBtYXkgcmVseSBvbgo+IGRhZW1vbiB0aHJlYWQgdG8gYmUgZG9uZS4KPgo+IDQp
IFRoaXMgcGF0Y2hzZXQgbW92ZSBpbml0aWFsaXphdGlvbiBvZiAnYWN0aXZlX2lvJyBmcm9tIG1k
X3J1bigpIHRvCj4gbWRfYWxsb2MoKSwgc28gdGhhdCBtZGRldl9zdXNwZW5kKCkgd29uJ3QgcmVs
eSBvbiBob2xkaW5nICdyZWNvbmZpZ19tdXRleCcKPiB0byBjaGVjayBpZiAnbWRkZXYtPnBlcnMn
IGlzIHNldCwgYW5kIGl0IGNhbiBiZSBjYWxsZWQgYXQgYW55IHRpbWUgYWZ0ZXIKPiBtZGRldiBp
cyBhbGxvY2F0ZWQuKERvbmUgYnkgcGF0Y2ggMSwgYW5kIG90aGVyIHBhdGNoZXMgYXJlIGNsZWFu
dXApCj4KPiBZdSBLdWFpICg3KToKPiAgIG1kOiBpbml0aWFsaXplICdhY3RpdmVfaW8nIHdoaWxl
IGFsbG9jYXRpbmcgbWRkZXYKPiAgIG1kOiBpbml0aWFsaXplICd3cml0ZXNfcGVuZGluZycgd2hp
bGUgYWxsb2NhdGluZyBtZGRldgo+ICAgbWQ6IGRvbid0IHJlbHkgb24gJ21kZGV2LT5wZXJzJyB0
byBiZSBzZXQgaW4gbWRkZXZfc3VzcGVuZCgpCj4gICBtZC1iaXRtYXA6IHJlbW92ZSB0aGUgY2hl
Y2tpbmcgb2YgJ3BlcnMtPnF1aWVzY2UnIGZyb20KPiAgICAgbG9jYXRpb25fc3RvcmUoKQo+ICAg
bWQtYml0bWFwOiBzdXNwZW5kIGFycmF5IGVhcmxpZXIgaW4gbG9jYXRpb25fc3RvcmUoKQo+ICAg
bWQ6IGRvbid0IGNoZWNrICdtZGRldi0+cGVycycgZnJvbSBzdXNwZW5kX2hpX3N0b3JlKCkKPiAg
IG1kOiBkb24ndCBjaGVjayAnbWRkZXYtPnBlcnMnIGFuZCAncGVycy0+cXVpZXNjZScgZnJvbQo+
ICAgICBzdXNwZW5kX2xvX3N0b3JlKCkKPgo+IFsxXSBodHRwczovL2xvcmUua2VybmVsLm9yZy9h
bGwvMjAyMzA2MjExNjUxMTAuMTQ5ODMxMy0xLXl1a3VhaTFAaHVhd2VpY2xvdWQuY29tLwo+IFsy
XSBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAyMzA2MjgwMTI5MzEuODg5MTEtMi15dWt1
YWkxQGh1YXdlaWNsb3VkLmNvbS8KPgo+IFl1IEt1YWkgKDcpOgo+ICAgbWQ6IGluaXRpYWxpemUg
J2FjdGl2ZV9pbycgd2hpbGUgYWxsb2NhdGluZyBtZGRldgo+ICAgbWQ6IGluaXRpYWxpemUgJ3dy
aXRlc19wZW5kaW5nJyB3aGlsZSBhbGxvY2F0aW5nIG1kZGV2Cj4gICBtZDogZG9uJ3QgcmVseSBv
biAnbWRkZXYtPnBlcnMnIHRvIGJlIHNldCBpbiBtZGRldl9zdXNwZW5kKCkKPiAgIG1kLWJpdG1h
cDogcmVtb3ZlIHRoZSBjaGVja2luZyBvZiAncGVycy0+cXVpZXNjZScgZnJvbQo+ICAgICBsb2Nh
dGlvbl9zdG9yZSgpCj4gICBtZC1iaXRtYXA6IHN1c3BlbmQgYXJyYXkgZWFybGllciBpbiBsb2Nh
dGlvbl9zdG9yZSgpCj4gICBtZDogZG9uJ3QgY2hlY2sgJ21kZGV2LT5wZXJzJyBmcm9tIHN1c3Bl
bmRfaGlfc3RvcmUoKQo+ICAgbWQ6IGRvbid0IGNoZWNrICdtZGRldi0+cGVycycgYW5kICdwZXJz
LT5xdWllc2NlJyBmcm9tCj4gICAgIHN1c3BlbmRfbG9fc3RvcmUoKQo+Cj4gIGRyaXZlcnMvbWQv
ZG0tcmFpZC5jICAgfCAgIDcgKystCj4gIGRyaXZlcnMvbWQvbWQtYml0bWFwLmMgfCAgNDcgKysr
KysrKysrLS0tLS0tLS0tLQo+ICBkcml2ZXJzL21kL21kLmMgICAgICAgIHwgMTAwICsrKysrKysr
KysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tLS0tCj4gIGRyaXZlcnMvbWQvbWQuaCAgICAg
ICAgfCAgIDQgKy0KPiAgZHJpdmVycy9tZC9yYWlkMS5jICAgICB8ICAgMyArLQo+ICBkcml2ZXJz
L21kL3JhaWQxMC5jICAgIHwgICAzIC0tCj4gIGRyaXZlcnMvbWQvcmFpZDUuYyAgICAgfCAgIDMg
LS0KPiAgNyBmaWxlcyBjaGFuZ2VkLCA3OCBpbnNlcnRpb25zKCspLCA4OSBkZWxldGlvbnMoLSkK
Pgo+IC0tCj4gMi4zOS4yCj4KCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRo
YXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2
ZWwK

