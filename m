Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34892C001B0
	for <dm-devel@archiver.kernel.org>; Mon, 24 Jul 2023 18:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690221840;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=JztED9T5Ry1dC38Q6iwpU6ex9Y2xDdMvcWYZS+MJgsU=;
	b=hglVC7ivcqJ0Xu2uV75kCxGLAU8sKlsY18WzNuWlCttYzLHuX6AXHWGclrnBdglkfvh8kJ
	dJZctgn2IjeMqA2doQeuoZx8pTsW9WLp/TkRsWyk+7HQqTrraAel9ZFvGxrHa4oThNyGJh
	nwUGlScjgYQVKiwcuYrMLlSlqDUQL5Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-606-nZ7KAsrqNO2pLw7CXngAtA-1; Mon, 24 Jul 2023 14:03:58 -0400
X-MC-Unique: nZ7KAsrqNO2pLw7CXngAtA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 201D5857FF8;
	Mon, 24 Jul 2023 18:03:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6FC691454142;
	Mon, 24 Jul 2023 18:03:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F05A619465B1;
	Mon, 24 Jul 2023 18:03:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CB7EF1946589
 for <dm-devel@listman.corp.redhat.com>; Mon, 24 Jul 2023 18:03:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5893F4087C7B; Mon, 24 Jul 2023 18:03:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 50A8640C6CCC
 for <dm-devel@redhat.com>; Mon, 24 Jul 2023 18:03:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 25F371C07544
 for <dm-devel@redhat.com>; Mon, 24 Jul 2023 18:03:51 +0000 (UTC)
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-148-dWL7coI7Pk23k-HbcWNUaA-1; Mon, 24 Jul 2023 14:03:49 -0400
X-MC-Unique: dWL7coI7Pk23k-HbcWNUaA-1
Received: by mail-qv1-f72.google.com with SMTP id
 6a1803df08f44-63d062fc6f8so9650666d6.3
 for <dm-devel@redhat.com>; Mon, 24 Jul 2023 11:03:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1690221828; x=1690826628;
 h=content-transfer-encoding:mime-version:user-agent:message-id
 :in-reply-to:date:references:subject:cc:to:from:x-gm-message-state
 :from:to:cc:subject:date:message-id:reply-to;
 bh=h1iA/74VQWfwLwNThFZsLp7nijUvl29CDijMQU67cx0=;
 b=brqZ1bVx3E5pYKPvCUONulnOAUtzcC/dx59z6/ofYpQE+5N/rPQ4YHqcQxD5Rj11aP
 Nx/46+pnl9Akt7OJsefm/DYIn3hjCVds6QAUIyF8WYec635sLsu/AnDa2Dzzv3Jwu1If
 PyxDCl76Ovwwn1EUzLRzcuZ3tddGzH2TEIXV7xd2QH4A9GyQlCAWuj0Eh6WjmoKZSF5z
 OqLx62DMkAUA3+x+X/ferzKo50hmakMvM1162zk8dtVdsZJiu4zNXE5CLnOGo76Dd8U2
 nZj4kQ79aNPB84JbofZtioxUzEasVtDXTO6yo4G4TGC6mAcglhSlEjM/YZr1TsNCzXYl
 L9nw==
X-Gm-Message-State: ABy/qLb8O+bwSuJSRad6Hy3peOZSz2NkcyaaGO4zKU90l2far+hgXjzz
 m0dSWv0sAcCLWRyv79u1IRmOYgNY0M2ZUwz4NCzWZRZKD/Pc5xh2u+nRRzL64SUoatcnuP07OtY
 yWhVxpCMiiGtJrnUQU8T2bQLLpA==
X-Received: by 2002:a0c:c541:0:b0:63c:7459:b24c with SMTP id
 y1-20020a0cc541000000b0063c7459b24cmr486061qvi.1.1690221827705; 
 Mon, 24 Jul 2023 11:03:47 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGDoVlS3FFXlpjdmnCPWfX8LPgwXcskuVzu4G58Z3n/2etCM1/Y+5M6HfC8yhSVC2CdnaBipg==
X-Received: by 2002:a0c:c541:0:b0:63c:7459:b24c with SMTP id
 y1-20020a0cc541000000b0063c7459b24cmr486039qvi.1.1690221827407; 
 Mon, 24 Jul 2023 11:03:47 -0700 (PDT)
Received: from crash (c-24-218-80-208.hsd1.ma.comcast.net. [24.218.80.208])
 by smtp.gmail.com with ESMTPSA id
 f8-20020ac84708000000b00403ff38d855sm3500178qtp.4.2023.07.24.11.03.46
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 24 Jul 2023 11:03:46 -0700 (PDT)
From: Ken Raeburn <raeburn@redhat.com>
To: Mike Snitzer <snitzer@kernel.org>
References: <20230523214539.226387-1-corwin@redhat.com>
 <ZLa086NuWiMkJKJE@redhat.com>
Date: Mon, 24 Jul 2023 14:03:45 -0400
In-Reply-To: <ZLa086NuWiMkJKJE@redhat.com> (Mike Snitzer's message of "Tue, 18
 Jul 2023 11:51:15 -0400")
Message-ID: <87mszl9ofy.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [vdo-devel] [PATCH v2 00/39] Add the dm-vdo
 deduplication and compression device mapper target.
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
Cc: linux-block@vger.kernel.org, vdo-devel@redhat.com, dm-devel@redhat.com,
 ebiggers@kernel.org, tj@kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

CihBcG9sb2dpZXMgZm9yIHRoZSByZS1zZW5kIC4uLiBJIG5lZ2xlY3RlZCB0byB0dXJuIG9mIEhU
TUwgYW5kIHNvCmxpbnV4LWJsb2NrIGJvdW5jZWQgdGhlIGVtYWlsIGFzIHNwYW0uKQoKT24gVHVl
LCBKdWwgMTgsIDIwMjMgYXQgMTE6NTHigK9BTSBNaWtlIFNuaXR6ZXIgPHNuaXR6ZXJAa2VybmVs
Lm9yZz4gd3JvdGU6CgogQnV0IHRoZSBsb25nLXN0YW5kaW5nIGRlcGVuZGVuY3kgb24gVkRPJ3Mg
d29yay1xdWV1ZSBkYXRhCiBzdHJ1Y3QgaXMgc3RpbGwgbGluZ2VyaW5nIChkcml2ZXJzL21kL2Rt
LXZkby93b3JrLXF1ZXVlLmMpLiBBdCBhCiBtaW5pbXVtIHdlIG5lZWQgdG8gd29yayB0b3dhcmQg
cGlubmluZyBkb3duIF9leGFjdGx5XyB3aHkgdGhhdCBpcywgYW5kCiBJIHRoaW5rIHRoZSBiZXN0
IHdheSB0byBhbnN3ZXIgdGhhdCBpcyBieSBzaW1wbHkgY29udmVydGluZyB0aGUgVkRPCiBjb2Rl
IG92ZXIgdG8gdXNpbmcgTGludXgncyB3b3JrcXVldWVzLiAgSWYgZG9pbmcgc28gY2F1c2VzIHNl
cmlvdXMKIGluaGVyZW50IHBlcmZvcm1hbmNlIChvciBmdW5jdGlvbmFsaXR5KSBsb3NzIHRoZW4g
d2UgbmVlZCB0bwogdW5kZXJzdGFuZCB3aHkgLS0gYW5kIGZpeCBMaW51eCdzIHdvcmtxdWV1ZSBj
b2RlIGFjY29yZGluZ2x5LiAoSSd2ZQogY2MnZCBUZWp1biBzbyBoZSBpcyBhd2FyZSkuCgpXZSB0
cmllZCB0aGlzIGV4cGVyaW1lbnQgYW5kIGRpZCBpbmRlZWQgc2VlIHNvbWUgc2lnbmlmaWNhbnQK
cGVyZm9ybWFuY2UgZGlmZmVyZW5jZXMuIE5lYXJseSBhIDd4IHNsb3dkb3duIGluIHNvbWUgY2Fz
ZXMuCgpWRE8gY2FuIGJlIHByZXR0eSBDUFUtaW50ZW5zaXZlLiBJbiBhZGRpdGlvbiB0byBoYXNo
aW5nIGFuZApjb21wcmVzc2lvbiwgaXQgc2NhbnMgc29tZSBiaWcgaW4tbWVtb3J5IGRhdGEgc3Ry
dWN0dXJlcyBhcyBwYXJ0IG9mCnRoZSBkZWR1cGxpY2F0aW9uIHByb2Nlc3MuIFNvbWUgZGF0YSBz
dHJ1Y3R1cmVzIGFyZSBzcGxpdCBhY3Jvc3Mgb25lCm9yIG1vcmUgInpvbmVzIiB0byBlbmFibGUg
Y29uY3VycmVuY3kgKHVzdWFsbHkgc3BsaXQgYmFzZWQgb24gYml0cyBvZgphbiBhZGRyZXNzIG9y
IHNvbWV0aGluZyBsaWtlIHRoYXQpLCBidXQgc29tZSBhcmUgbm90LCBhbmQgYSBjb3VwbGUgb2YK
dGhvc2UgdGhyZWFkcyBjYW4gc29tZXRpbWVzIGV4Y2VlZCA1MCUgQ1BVIHV0aWxpemF0aW9uLCBl
dmVuIDkwJQpkZXBlbmRpbmcgb24gdGhlIHN5c3RlbSBhbmQgdGVzdCBkYXRhIGNvbmZpZ3VyYXRp
b24uIChVc3VhbGx5IHRoaXMgaXMKd2hpbGUgcHVzaGluZyBvdmVyIDFHQi9zIHRocm91Z2ggdGhl
IGRlZHVwbGljYXRpb24gYW5kIGNvbXByZXNzaW9uCnByb2Nlc3Npbmcgb24gYSBzeXN0ZW0gd2l0
aCBmYXN0IHN0b3JhZ2UuIE9uIGEgc2xvdyBWTSB3aXRoIHNwaW5uaW5nCnN0b3JhZ2UsIHRoZSBD
UFUgbG9hZCBpcyBtdWNoIHNtYWxsZXIuKQoKV2UgdXNlIGEgc29ydCBvZiBtZXNzYWdlLXBhc3Np
bmcgYXJyYW5nZW1lbnQgd2hlcmUgYSB3b3JrZXIgdGhyZWFkIGlzCnJlc3BvbnNpYmxlIGZvciB1
cGRhdGluZyBjZXJ0YWluIGRhdGEgc3RydWN0dXJlcyBhcyBuZWVkZWQgZm9yIHRoZQpJL09zIGlu
IHByb2dyZXNzLCByYXRoZXIgdGhhbiBoYXZpbmcgdGhlIHByb2Nlc3Npbmcgb2YgZWFjaCBJL08K
Y29udGVuZCBmb3IgbG9ja3Mgb24gdGhlIGRhdGEgc3RydWN0dXJlcy4gSXQgZ2l2ZXMgdXMgc29t
ZSBnb29kCnRocm91Z2hwdXQgdW5kZXIgbG9hZCBidXQgaXQgZG9lcyBtZWFuIHVwd2FyZHMgb2Yg
YSBkb3plbiBoYW5kb2ZmcyBwZXIKNGtCIHdyaXRlLCBkZXBlbmRpbmcgb24gY29tcHJlc3NpYmls
aXR5LCB3aGV0aGVyIHRoZSBibG9jayBpcyBhCmR1cGxpY2F0ZSwgYW5kIHZhcmlvdXMgb3RoZXIg
ZmFjdG9ycy4gU28gcHJvY2Vzc2luZyAxIEdCL3MgbWVhbnMKaGFuZGxpbmcgb3ZlciAzTSBtZXNz
YWdlcyBwZXIgc2Vjb25kLCB0aG91Z2ggZWFjaCBzdGVwIG9mIHByb2Nlc3NpbmcKaXMgZ2VuZXJh
bGx5IGxpZ2h0d2VpZ2h0LiBGb3Igb3VyIGRlZGljYXRlZCB3b3JrZXIgdGhyZWFkcywgaXQncyBu
b3QKdW51c3VhbCBmb3IgYSB0aHJlYWQgdG8gd2FrZSB1cCBhbmQgcHJvY2VzcyBhIGZldyB0ZW5z
IG9yIGV2ZW4KaHVuZHJlZHMgb2YgdXBkYXRlcyB0byBpdHMgZGF0YSBzdHJ1Y3R1cmVzIChsaWtl
bHkgYmVuZWZpdGluZyBmcm9tIENQVQpjYWNoaW5nIG9mIHRoZSBkYXRhIHN0cnVjdHVyZXMpIGJl
Zm9yZSBydW5uaW5nIG91dCBvZiBhdmFpbGFibGUgd29yawphbmQgZ29pbmcgYmFjayB0byBzbGVl
cC4KClRoZSBleHBlcmltZW50IEkgcmFuIHdhcyB0byBjcmVhdGUgYW4gb3JkZXJlZCB3b3JrcXVl
dWUgaW5zdGVhZCBvZgplYWNoIGRlZGljYXRlZCB0aHJlYWQgd2hlcmUgd2UgbmVlZCBzZXJpYWxp
emF0aW9uLCBhbmQgdW5vcmRlcmVkCndvcmtxdWV1ZXMgd2hlbiBjb25jdXJyZW5jeSBpcyBhbGxv
d2VkLiBPbiBvdXIgc2xvd2VyIHRlc3Qgc3lzdGVtcyAoPgoxMHkgb2xkIFN1cGVybWljcm8gWGVv
biBFNS0xNjUwIHYyLCBSQUlELTAgc3RvcmFnZSB1c2luZyBTU0RzIG9yCkhERHMpLCB0aGUgc2xv
d2Rvd24gd2FzIGxlc3Mgc2lnbmlmaWNhbnQgKHVuZGVyIDJ4KSwgYnV0IG9uIG91ciBmYXN0ZXIK
c3lzdGVtICg0LTU/IHllYXIgb2xkIFN1cGVybWljcm8gMTAyOVAtV1RSLCAyeCBYZW9uIEdvbGQg
NjEyOCA9IDEyCmNvcmVzLCBOVk1lIHN0b3JhZ2UpIHdlIGdvdCBuZWFybHkgYSA3eCBzbG93ZG93
biBvdmVyYWxsLiBJIGhhdmVuJ3QKeWV0IGR1ZyBkZWVwbHkgaW50byBfd2h5XyB0aGUga2VybmVs
IHdvcmsgcXVldWVzIGFyZSBzbG93ZXIgaW4gdGhpcwpzb3J0IG9mIHNldHVwLiBJIGRpZCBydW4g
InBlcmYgdG9wIiBicmllZmx5IGR1cmluZyBvbmUgdGVzdCB3aXRoCmtlcm5lbCB3b3JrIHF1ZXVl
cywgYW5kIHRoZSBsYXJnZXN0IHNpbmdsZSB1c2Ugb2YgQ1BVIGN5Y2xlcyB3YXMgaW4Kc3BpbiBs
b2NrIGFjcXVpc2l0aW9uLCBidXQgSSBkaWRuJ3QgZ2V0IGNhbGwgZ3JhcGhzLgoKKFRoaXMgd2Fz
IHdpdGggRmVkb3JhIDM3IDYuMi4xMi0yMDAgYW5kIDYuMi4xNS0yMDAga2VybmVscywgd2l0aG91
dAp0aGUgbGF0ZXN0IHN1Ym1pc3Npb25zIGZyb20gVGVqdW4sIHdoaWNoIGxvb2sgaW50ZXJlc3Rp
bmcuIFRob3VnaCBJCnN1c3BlY3Qgd2UgY2FyZSBtb3JlIGFib3V0IGNhY2hlIGxvY2FsaXR5IGZv
ciBzb21lIG9mIG91cgp0aHJlYWQtc3BlY2lmaWMgZGF0YSBzdHJ1Y3R1cmVzIHRoYW4gZm9yIGFj
Y2Vzc2luZyB0aGUgSS9PCnN0cnVjdHVyZXMuKQoKS2VuCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxp
c3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFu
L2xpc3RpbmZvL2RtLWRldmVsCg==

