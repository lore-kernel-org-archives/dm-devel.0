Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B14DFE936ED
	for <dm-devel@archiver.kernel.org>; Thu,  5 Oct 2023 04:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696478598;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=5DIU/XA4H83M2GY3P7bx1j9F4IRngQ2AgnKvgXf5Tbc=;
	b=VNP0eQwPbEZOyKr4uEYyMNXtZMIdJ9Sz0K/lCXtUN4XnKVd+4eDNV/A6292wK/v08XOzro
	Pd4AlY6c6IrEdctakUjtdwx3OtB4QAMVEG/ZPogVkvDlHNIINlkzZDVAOyCKSGVzizfXRd
	NSPsff1TZI4jFqntp2Ndmmn/SAceV3A=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-255-cwKM4nERNemm7WJegX2o0g-1; Thu, 05 Oct 2023 00:03:15 -0400
X-MC-Unique: cwKM4nERNemm7WJegX2o0g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A09C83C0E668;
	Thu,  5 Oct 2023 04:03:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8FDB4140E950;
	Thu,  5 Oct 2023 04:03:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 37B871946597;
	Thu,  5 Oct 2023 04:03:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E1C98194658F
 for <dm-devel@listman.corp.redhat.com>; Thu,  5 Oct 2023 04:03:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8E2AC40C2017; Thu,  5 Oct 2023 04:03:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8764540C2015
 for <dm-devel@redhat.com>; Thu,  5 Oct 2023 04:03:11 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 67EA2800969
 for <dm-devel@redhat.com>; Thu,  5 Oct 2023 04:03:11 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-345-s0YLJAGDPfmU1iPN4ccKNg-1; Thu,
 05 Oct 2023 00:03:09 -0400
X-MC-Unique: s0YLJAGDPfmU1iPN4ccKNg-1
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
 by ams.source.kernel.org (Postfix) with ESMTP id EE5A2B82257;
 Thu,  5 Oct 2023 03:55:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8366CC433D9;
 Thu,  5 Oct 2023 03:55:37 +0000 (UTC)
Received: by mail-lf1-f45.google.com with SMTP id
 2adb3069b0e04-5041d6d8b10so654721e87.2; 
 Wed, 04 Oct 2023 20:55:37 -0700 (PDT)
X-Gm-Message-State: AOJu0Yz8wIgb03IRDvSEyoILI+aWcxE9sSECkuN03MlBDf3lNczqBNoM
 7VbfhiUXYE4reW1FJYiu0B+yxR6rp+4l+Q11LYc=
X-Google-Smtp-Source: AGHT+IF4f5QmJaGGVsNqoYOF0xWkXAqZSUr24CPLmmG2eoBzxwZx9lS3Df5pF0TkOAs5eR6dHn8LDX9R5GAPIAxf2z8=
X-Received: by 2002:a19:8c0e:0:b0:500:bc14:3e06 with SMTP id
 o14-20020a198c0e000000b00500bc143e06mr3731394lfd.44.1696478135549; Wed, 04
 Oct 2023 20:55:35 -0700 (PDT)
MIME-Version: 1.0
References: <20230928061543.1845742-1-yukuai1@huaweicloud.com>
 <CAPhsuW5cUgqy9fqj+Z4nGPQrAok-eQ=NipNxb0TL_kuCFaPMcw@mail.gmail.com>
 <f59cbb99-33dd-c427-2e43-5a07ab9fbf51@huaweicloud.com>
In-Reply-To: <f59cbb99-33dd-c427-2e43-5a07ab9fbf51@huaweicloud.com>
From: Song Liu <song@kernel.org>
Date: Wed, 4 Oct 2023 20:55:23 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7TRODsR_N95AmXJCZvpTuSKgbOjnYGxMGAWtmt3x9Vkw@mail.gmail.com>
Message-ID: <CAPhsuW7TRODsR_N95AmXJCZvpTuSKgbOjnYGxMGAWtmt3x9Vkw@mail.gmail.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH -next v3 00/25] md: synchronize io with array
 reconfiguration
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
 dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 xni@redhat.com, "yukuai \(C\)" <yukuai3@huawei.com>, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gV2VkLCBPY3QgNCwgMjAyMyBhdCA4OjQy4oCvUE0gWXUgS3VhaSA8eXVrdWFpMUBodWF3ZWlj
bG91ZC5jb20+IHdyb3RlOgo+Cj4gSGksCj4KPiDlnKggMjAyMy8wOS8yOSAzOjE1LCBTb25nIExp
dSDlhpnpgZM6Cj4gPiBIaSBLdWFpLAo+ID4KPiA+IFRoYW5rcyBmb3IgdGhlIHBhdGNoc2V0IQo+
ID4KPiA+IEEgZmV3IGhpZ2ggbGV2ZWwgcXVlc3Rpb25zL3N1Z2dlc3Rpb25zOgo+Cj4gVGhhbmtz
IGEgbG90IGZvciB0aGVzZSEKPiA+Cj4gPiAxLiBUaGlzIGlzIGEgYmlnIGNoYW5nZSB0aGF0IG5l
ZWRzIGEgbG90IG9mIGV4cGxhbmF0aW9uLiBXaGlsZSB5b3UgbWFuYWdlZCB0bwo+ID4ga2VlcCBl
YWNoIHBhdGNoIHJlbGF0aXZlbHkgc21hbGwgKGdyZWF0IGpvYiBidHcpLCBpdCBpcyBub3QgdmVy
eSBjbGVhciB3aHkgd2UKPiA+IG5lZWQgdGhlc2UgY2hhbmdlcy4gU3BlY2lmaWNhbGx5LCB3ZSBh
cmUgYWRkaW5nIGEgbmV3IG11dGV4LCBpdCBpcyB3b3J0aAo+ID4gbWVudGlvbmluZyB3aHkgd2Ug
Y2Fubm90IGFjaGlldmUgdGhlIHNhbWUgZ29hbCB3aXRob3V0IGl0LiBQbGVhc2UgYWRkCj4gPiBt
b3JlIGluZm9ybWF0aW9uIGluIHRoZSBjb3ZlciBsZXR0ZXIuIFdlIHdpbGwgcHV0IHBhcnQgb2Yg
dGhlIGNvdmVyIGxldHRlciBpbgo+ID4gdGhlIG1lcmdlIGNvbW1pdC4KPgo+IFllYWgsIEkgcmVh
bGl6ZSB0aGF0IEkgZXhwbGFpbiB0b28gbGl0dGxlLiBJIHdpbGwgYWRkIGJhY2tncm91bmQgYW5k
Cj4gZGVzaWduLgo+ID4KPiA+IDIuIEluIHRoZSBjb3ZlciBsZXR0ZXIsIHBsZWFzZSBhbHNvIGhp
Z2hsaWdodCB0aGF0IHdlIGFyZSByZW1vdmluZwo+ID4gICBNRF9BTExPV19TQl9VUERBVEUgYW5k
IE1EX1VQREFUSU5HX1NCLiBUaGlzIGlzIGEgYmlnIGltcHJvdmVtZW50Lgo+ID4KPgo+IE9rYXku
Cj4gPiAzLiBQbGVhc2UgcmVhcnJhbmdlIHRoZSBwYXRjaCBzZXQgc28gdGhhdCB0aGUgdHdvICJS
RUFEX09OQ0UvV1JJVEVfT05DRSIKPiA+IHBhdGNoZXMgYXJlIGF0IHRoZSBiZWdpbm5pbmcuCj4K
PiBPa2F5Lgo+ID4KPiA+IDQuIFBsZWFzZSBjb25zaWRlciBtZXJnaW5nIHNvbWUgcGF0Y2hlcy4g
Q3VycmVudCAiYWRkLWFwaSA9PiB1c2UtYXBpID0+Cj4gPiByZW1vdmUtb2xkLWFwaSIgbWFrZXMg
aXQgdHJpY2t5IHRvIGZvbGxvdyB3aGF0IGlzIGJlaW5nIGNoYW5nZWQuIEZvciB0aGlzIHNldCwK
PiA+IEkgZm91bmQgdGhlIGRpZmYgb2YgdGhlIHdob2xlIHNldCBlYXNpZXIgdG8gZm9sbG93IHRo
YW4gc29tZSBvZiB0aGUgYmlnIHBhdGNoZXMuCj4gSSByZWZlciB0byBzb21lIG90aGVyIGJpZyBw
YXRjaHNldCB0byByZXBsYWNlIGFuIG9sZCBhcGksIGZvciBleGFtcGxlOgo+Cj4gaHR0cHM6Ly9s
b3JlLmtlcm5lbC5vcmcvYWxsLzIwMjMwODE4MTIzMjMyLjIyNjktMS1qYWNrQHN1c2UuY3ovCgpZ
ZXMsIHRoaXMgaXMgYSBzYWZlIHdheSB0byByZXBsYWNlIG9sZCBBUElzLiBTaW5jZSB0aGUgc2Nh
bGUgb2YgdGhpcwpwYXRjaHNldCBpcwpzbWFsbGVyLCBJIHdhcyB0aGlua2luZyBpdCBtaWdodCBu
b3QgYmUgbmVjZXNzYXJ5IHRvIGdvIHRoYXQgcGF0aC4gQnV0Ckkgd2lsbCBsZXQKeW91IG1ha2Ug
dGhlIGRlY2lzaW9uLgoKPiBDdXJyZW50bHkgSSBwcmVmZXIgdG8gdXNlIG9uZSBwYXRjaCBmb3Ig
ZWFjaCBmdW5jdGlvbiBwb2ludC4gQW5kIEkgZG8KPiBtZXJnZWQgc29tZSBwYXRjaGVzIGluIHRo
aXMgdmVyc2lvbiwgYW5kIGZvciByZW1haW5pbmcgcGF0Y2hlcywgZG8geW91Cj4gcHJlZmVyIHRv
IHVzZSBvbmUgcGF0Y2ggZm9yIG9uZSBmaWxlIGluc3RlYWQgb2Ygb25lIGZ1bmN0aW9uIHBvaW50
PyhGb3IKPiBleGFtcGxlLCBtZXJnZSBwYXRjaCAxMC0xMiBmb3IgbWQvcmFpZDUtY2FjaGUsIGFu
ZCAxMy0xNiBmb3IgbWQvcmFpZDUpLgoKSSB0aGluayAxMCBzaG91bGQgYmUgYSBzZXBhcmF0ZSBw
YXRjaCwgYW5kIHdlIGNhbiBtZXJnZSAxMSBhbmQgMTIuIFdlIGNhbgptZXJnZSAxMy0xNiwgYW5k
IG1heWJlIGFsc28gNS03IGFuZCAxOC0yMC4KClRoYW5rcywKU29uZwoKLS0KZG0tZGV2ZWwgbWFp
bGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20v
bWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

