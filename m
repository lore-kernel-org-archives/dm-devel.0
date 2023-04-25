Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E01C8C77B78
	for <dm-devel@archiver.kernel.org>; Wed, 26 Apr 2023 10:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1682505089;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=hOilbZrQj+9ahjNA6gLPHNYO+uJu4iVxC0KBEnrswpQ=;
	b=KTFn39eX9pHVQAsHc+oURINK1Tegt5pvIvenmDj4Uhnl73pp7SCgcGziKwQytisJCKhQIl
	zB1IZlV4RMttZnNUACxej+a6csMaoRYLUKIa2yEiG5K7ckh0VJpD1ixawjqdFPCxJ2nqK0
	fvHH2jfalrWUB0GF+igtxFI/wWy8VO0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-438-qzNTBp6wN5aibUNVL_G5FQ-1; Wed, 26 Apr 2023 06:31:26 -0400
X-MC-Unique: qzNTBp6wN5aibUNVL_G5FQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6F6A8185A78B;
	Wed, 26 Apr 2023 10:31:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4C34E4C82F;
	Wed, 26 Apr 2023 10:31:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 40B7A1946A41;
	Wed, 26 Apr 2023 10:31:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E80581946595
 for <dm-devel@listman.corp.redhat.com>; Tue, 25 Apr 2023 12:22:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BA778492B10; Tue, 25 Apr 2023 12:22:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B3824492B0F
 for <dm-devel@redhat.com>; Tue, 25 Apr 2023 12:22:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 95B2A185A78B
 for <dm-devel@redhat.com>; Tue, 25 Apr 2023 12:22:27 +0000 (UTC)
Received: from new2-smtp.messagingengine.com (new2-smtp.messagingengine.com
 [66.111.4.224]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-547-nekqYWy6Onuy5gmcbPZ-Hg-1; Tue, 25 Apr 2023 08:22:26 -0400
X-MC-Unique: nekqYWy6Onuy5gmcbPZ-Hg-1
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
 by mailnew.nyi.internal (Postfix) with ESMTP id 8C01D582202;
 Tue, 25 Apr 2023 08:15:23 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
 by compute5.internal (MEProxy); Tue, 25 Apr 2023 08:15:23 -0400
X-ME-Sender: <xms:WsRHZOTqsP9w6nwOp5uem1KMBWLGHej4AgXa7ktNKMEFkaZEr2_sjg>
 <xme:WsRHZDz3gluAmXjJOkm88RXapuOtIepf6dwQ3yejw-pvfO8tlam5QqZxC6fRWhQEF
 bsyY0YNBg-hJwn8Nwg>
X-ME-Received: <xmr:WsRHZL2Ek4valVwcbZKDJjuz0_EV7zndivQDi-G5YAiE_NiY43O3ND7jGpba8QsTEQs8LxSpSoqsHMOex1_1Hg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeduvddghedtucetufdoteggodetrfdotf
 fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
 uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
 cujfgurhepfffhvfevuffkfhggtggugfgjsehtkefstddttdejnecuhfhrohhmpefuhhhi
 nhdkihgthhhirhhoucfmrgifrghsrghkihcuoehshhhinhhitghhihhrohesfhgrshhtmh
 grihhlrdgtohhmqeenucggtffrrghtthgvrhhnpeegteeljefhveejveefhfetueeugfeg
 gfehffevhfduffeuueekleelteejheejteenucevlhhushhtvghrufhiiigvpedtnecurf
 grrhgrmhepmhgrihhlfhhrohhmpehshhhinhhitghhihhrohesfhgrshhtmhgrihhlrdgt
 ohhm
X-ME-Proxy: <xmx:WsRHZKC-MICO0ZfidgTF7yTClqzUuqePLJmtbT42Jg2U0mPitG7_Xw>
 <xmx:WsRHZHiuyBcmsVhTqA_g4H2kQXu9nYJEiFTGvhv8N2GWEdvX0tZoqw>
 <xmx:WsRHZGq1uNSTfLRL--TmEpyCt6jlDpRqZ4H7IVzaP7kU_7Ba7Tvi6g>
 <xmx:W8RHZIUW0dS_i6__ei22xzAY2oR1U4U2B5OR-JaUz4WjWp4NDE3S3w>
Feedback-ID: ie1e949a3:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 25 Apr 2023 08:15:20 -0400 (EDT)
Date: Tue, 25 Apr 2023 21:15:18 +0900
From: Shin'ichiro Kawasaki <shinichiro@fastmail.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <oklvotdaxnncrugr2v7yqadzyfa5vvzrumrfv46vrzowjw3njo@tlvhd4eo5spl>
References: <20221230065424.19998-1-yukuai1@huaweicloud.com>
 <20230112010554.qmjuqtjoai3qqaj7@shindev>
 <6ccff2ec-b4bd-a1a6-5340-b9380adc1fff@huaweicloud.com>
MIME-Version: 1.0
In-Reply-To: <6ccff2ec-b4bd-a1a6-5340-b9380adc1fff@huaweicloud.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Wed, 26 Apr 2023 10:31:22 +0000
Subject: Re: [dm-devel] [PATCH blktests] dm: add a regression test
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
Cc: "hch@infradead.org" <hch@infradead.org>,
 "yi.zhang@huawei.com" <yi.zhang@huawei.com>,
 "yangerkun@huawei.com" <yangerkun@huawei.com>,
 "snitzer@kernel.org" <snitzer@kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>, shinichiro.kawasaki@wdc.com,
 "yukuai \(C\)" <yukuai3@huawei.com>, Li Lingfeng <lilingfeng3@huawei.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: fastmail.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gQXByIDI1LCAyMDIzIC8gMTY6MjIsIFl1IEt1YWkgd3JvdGU6Cj4gSGksCj4gCj4g5ZyoIDIw
MjMvMDEvMTIgOTowNSwgU2hpbmljaGlybyBLYXdhc2FraSDlhpnpgZM6Cj4gPiBIZWxsbyBZdSwg
dGhhbmtzIGZvciB0aGUgcGF0Y2guIEkgdGhpbmsgaXQgaXMgZ29vZCB0byBoYXZlIHRoaXMgdGVz
dCBjYXNlIHRvCj4gPiBhdm9pZCByZXBlYXRpbmcgdGhlIHNhbWUgcmVncmVzc2lvbi4gUGxlYXNl
IGZpbmQgbXkgY29tbWVudHMgaW4gbGluZS4KPiA+IAo+ID4gQ0MrOiBNaWtlLCBkbS1kZXZlbCwK
PiA+IAo+ID4gTWlrZSwgY291bGQgeW91IHRha2UgYSBsb29rIGluIHRoaXMgbmV3IHRlc3QgY2Fz
ZT8gSXQgYWRkcyAiZG0iIHRlc3QgZ3JvdXAgdG8KPiA+IGJsa3Rlc3RzLiBJZiB5b3UgaGF2ZSB0
aG91Z2h0cyBvbiBob3cgdG8gYWRkIGRldmljZS1tYXBwZXIgcmVsYXRlZCB0ZXN0IGNhc2VzCj4g
PiB0byBibGt0ZXN0cywgcGxlYXNlIHNoYXJlIChPciB3ZSBtYXkgYmUgYWJsZSB0byBkaXNjdXNz
IGxhdGVyIGF0IExTRiAyMDIzKS4KPiAKPiBDYW4gd2UgYWRkICJkbSIgdGVzdCBncm91cCB0byBi
bGt0ZXN0cz8gSSdsbCBzZW5kIGEgbmV3IHZlcnNpb24gaWYgd2UKPiBjYW4uCgpJIHN1Z2dlc3Qg
dG8gd2FpdCBmb3IgTFNGIGRpc2N1c3Npb24gaW4gTWF5LCB3aGljaCBjb3VsZCBiZSBhIGdvb2Qg
Y2hhbmNlIHRvCmhlYXIgb3BpbmlvbnMgb2YgZG0gZXhwZXJ0cy4gSSB0aGluayB5b3VyIG5ldyB0
ZXN0IGNhc2UgaXMgdmFsdWFibGUsIHNvIElNTyBpdApzaG91bGQgYmUgYWRkZWQgdG8gdGhlIG5l
dyAiZG0iIGdyb3VwLCBvciBhdCBsZWFzdCB0byB0aGUgZXhpc3RpbmcgImJsb2NrIgpncm91cC4g
TGV0J3MgZGVjaWRlIHRoZSB0YXJnZXQgZ3JvdXAgYWZ0ZXIgTFNGLgoKLS0KZG0tZGV2ZWwgbWFp
bGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20v
bWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

