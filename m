Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C968C001E0
	for <dm-devel@archiver.kernel.org>; Mon, 14 Aug 2023 17:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1692032552;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=9janqwPTrZa254PkyMFCXBeoR3JPmeoacnSpNEATYf0=;
	b=TXDq/79489VZxOEjXaRWAnYactQg9nzid9E3GVSnmmsRHzSSMvFnoVlmD/V5il9jpE291b
	bZEZLKASlpMFkTug1CxKMvjk82Drlxn3u91wq/Rl9Ij+EUWELI3UKXkQsQMAqRKO6D6YLJ
	r5xhUZrvbFnGUHaUaxue1hRxsx60L6I=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-649-p0wS9aPbOs-0hbnCCQulUA-1; Mon, 14 Aug 2023 13:02:29 -0400
X-MC-Unique: p0wS9aPbOs-0hbnCCQulUA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D06021C06915;
	Mon, 14 Aug 2023 17:02:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7D54E492C13;
	Mon, 14 Aug 2023 17:02:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 357C41946587;
	Mon, 14 Aug 2023 17:02:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E34321946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 14 Aug 2023 17:02:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3F2EB403163; Mon, 14 Aug 2023 17:02:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 36C7D403169
 for <dm-devel@redhat.com>; Mon, 14 Aug 2023 17:02:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 15D0528088A2
 for <dm-devel@redhat.com>; Mon, 14 Aug 2023 17:02:07 +0000 (UTC)
Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com
 [209.85.219.182]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-658-ftimK84XN7Oi2_m0T_ii1A-1; Mon, 14 Aug 2023 13:02:05 -0400
X-MC-Unique: ftimK84XN7Oi2_m0T_ii1A-1
Received: by mail-yb1-f182.google.com with SMTP id
 3f1490d57ef6-d3563cb41e9so3235326276.0; 
 Mon, 14 Aug 2023 10:02:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1692032524; x=1692637324;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=KoOgtExPknyCjaZt6yFcpJm1OTXC8gB2XRIzfWFG1zw=;
 b=I11mRYFcSuXcKfB3q7Odloc5KaFXAdqSn8KyY6YTI2w+5MA0VTyclAbB+ygSEqGf9Z
 N2kDJBk7arnqDZuIdxvUu4EG/dULf/7NiCGHQYnflchYKa5x6tfq5hoSER9sKVOC3Ipa
 Si7lAW57Evg4YxVSJNdKEuCHwds5SWwiprAAW7fXlzK0RhS2a5sgYqy40f3Jd00dFQvc
 G2siHfIgKab/uKN6Zg72VCTbwv3ixAtmU83Odykm33hUjjURIiQmkjadrTkfE73fJKSj
 q8MG8HKVOo58h6apYZSq81KkSloEapLSt4iKqAzagApvZwRtxZ4kJ3tCgtDgYIFlqI67
 iXEg==
X-Gm-Message-State: AOJu0YxtznFtsIPYlYI3dU+v2Ww5sCSh+3KAyfVwF8BFBNn4n38IfNc4
 PWdMdU6L7N3t4LuybWklbTYmiwx4zWHGBBAF8jc=
X-Google-Smtp-Source: AGHT+IG4bEDG0zFs6h8QgX1qJybvmoa2ss9LjkCZgljhQecK4wSD5P/FZmnDf7b05hg7BMMrprZPOZB2OS6moqWhAGI=
X-Received: by 2002:a25:2386:0:b0:d15:f337:938b with SMTP id
 j128-20020a252386000000b00d15f337938bmr8112041ybj.8.1692032524122; Mon, 14
 Aug 2023 10:02:04 -0700 (PDT)
MIME-Version: 1.0
References: <20230811105300.15889-1-nj.shetty@samsung.com>
 <CGME20230811105659epcas5p1982eeaeb580c4cb9b23a29270945be08@epcas5p1.samsung.com>
 <20230811105300.15889-4-nj.shetty@samsung.com>
 <0899ddc3-d9c1-3d9a-3649-2b1add9b2a7f@acm.org>
In-Reply-To: <0899ddc3-d9c1-3d9a-3649-2b1add9b2a7f@acm.org>
From: Nitesh Shetty <nitheshshetty@gmail.com>
Date: Mon, 14 Aug 2023 22:31:53 +0530
Message-ID: <CAOSviJ2+tUZ=jiOnPSi8=mOzjANwvuNXAkAG6f3ADGi=M=F5PQ@mail.gmail.com>
To: Bart Van Assche <bvanassche@acm.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v14 03/11] block: add copy offload support
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
Cc: linux-doc@vger.kernel.org, linux-nvme@lists.infradead.org,
 dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>,
 Alasdair Kergon <agk@redhat.com>, Sagi Grimberg <sagi@grimberg.me>,
 Jonathan Corbet <corbet@lwn.net>, gost.dev@samsung.com,
 Nitesh Shetty <nj.shetty@samsung.com>, Chaitanya Kulkarni <kch@nvidia.com>,
 Anuj Gupta <anuj20.g@samsung.com>, Mike Snitzer <snitzer@kernel.org>,
 linux-block@vger.kernel.org, dlemoal@kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>, Keith Busch <kbusch@kernel.org>,
 Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
 martin.petersen@oracle.com, linux-kernel@vger.kernel.org, mcgrof@kernel.org,
 linux-fsdevel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gU2F0LCBBdWcgMTIsIDIwMjMgYXQgMzoxMOKAr0FNIEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFz
c2NoZUBhY20ub3JnPiB3cm90ZToKPgo+IE9uIDgvMTEvMjMgMDM6NTIsIE5pdGVzaCBTaGV0dHkg
d3JvdGU6Cj4gPiArICogRGVzY3JpcHRpb246Cj4gPiArICogICBDb3B5IHNvdXJjZSBvZmZzZXQg
dG8gZGVzdGluYXRpb24gb2Zmc2V0IHdpdGhpbiBibG9jayBkZXZpY2UsIHVzaW5nCj4gPiArICog
ICBkZXZpY2UncyBuYXRpdmUgY29weSBvZmZsb2FkIGZlYXR1cmUuCj4KPiBPZmZsb2FkaW5nIHRo
ZSBjb3B5IG9wZXJhdGlvbiBpcyBub3QgZ3VhcmFudGVlZCBzbyBJIHRoaW5rIHRoYXQgbmVlZHMg
dG8KPiBiZSByZWZsZWN0ZWQgaW4gdGhlIGFib3ZlIGNvbW1lbnQuCj4KQWNrZWQuCj4gPiArICog
ICBXZSBwZXJmb3JtIGNvcHkgb3BlcmF0aW9uIGJ5IHNlbmRpbmcgMiBiaW8ncy4KPiA+ICsgKiAg
IDEuIFdlIHRha2UgYSBwbHVnIGFuZCBzZW5kIGEgUkVRX09QX0NPUFlfU1JDIGJpbyBhbG9uZyB3
aXRoIHNvdXJjZQo+ID4gKyAqICAgc2VjdG9yIGFuZCBsZW5ndGguIE9uY2UgdGhpcyBiaW8gcmVh
Y2hlcyByZXF1ZXN0IGxheWVyLCB3ZSBmb3JtIGEKPiA+ICsgKiAgIHJlcXVlc3QgYW5kIHdhaXQg
Zm9yIGRzdCBiaW8gdG8gYXJyaXZlLgo+Cj4gV2hhdCB3aWxsIGhhcHBlbiBpZiB0aGUgcXVldWUg
ZGVwdGggb2YgdGhlIHJlcXVlc3QgcXVldWUgYXQgdGhlIGJvdHRvbQo+IGlzIG9uZT8KPgpGb3Ig
YW55IHJlYXNvbiBpZiBhIHJlcXVlc3QgcmVhY2hlcyB0aGUgZHJpdmVyIHdpdGggb25seSBvbmUg
b2YgdGhlIHNyYy9kc3QgYmlvLApjb3B5IHdpbGwgZmFpbC4gVGhpcyBkZXNpZ24gcmVxdWlyZXMg
b25seSBvbmUgcmVxdWVzdCB0byBkbyBhIGNvcHksCnNvIGl0IHNob3VsZCB3b3JrIGZpbmUuCgo+
ID4gKyAgICAgICAgICAgICBibGtfc3RhcnRfcGx1ZygmcGx1Zyk7Cj4gPiArICAgICAgICAgICAg
IGRzdF9iaW8gPSBibGtfbmV4dF9iaW8oc3JjX2JpbywgYmRldiwgMCwgUkVRX09QX0NPUFlfRFNU
LCBnZnApOwo+Cj4gYmxrX25leHRfYmlvKCkgY2FuIHJldHVybiBOVUxMIHNvIGl0cyByZXR1cm4g
dmFsdWUgc2hvdWxkIGJlIGNoZWNrZWQuCj4KQWNrZWQuCgpUaGFuayB5b3UsCk5pdGVzaCBTaGV0
dHkKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8v
bGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

