Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A11CC6FD18
	for <dm-devel@archiver.kernel.org>; Tue, 25 Apr 2023 17:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1682443479;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=M4J4hJjGUUEyNdi7eROoY9t/1mVT/zUjAb9sJ6NuBYM=;
	b=XFLvK1e6bGaU0InTi6PdmqGZ1G0zRrTCYvSL4XafMjVnNiMZ88kwOrqp6Lqh9oQaB/G3qC
	nVR8cjgVxPnyvLUkr6vToKvGP+UfmgVroxF/f0zL465+i52vpR503Iva6mp5hDby2+O1+5
	IGcExVTlDGbPDknfMEAF748UujEgG9o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-263-b7GPcsUaMVKX7suq3MCAAQ-1; Tue, 25 Apr 2023 13:24:36 -0400
X-MC-Unique: b7GPcsUaMVKX7suq3MCAAQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B7BCE185A7A7;
	Tue, 25 Apr 2023 17:24:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 985232166B3A;
	Tue, 25 Apr 2023 17:24:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5A2941946597;
	Tue, 25 Apr 2023 17:24:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B66061946595
 for <dm-devel@listman.corp.redhat.com>; Tue, 25 Apr 2023 17:24:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 977B92027045; Tue, 25 Apr 2023 17:24:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8F18E2027043
 for <dm-devel@redhat.com>; Tue, 25 Apr 2023 17:24:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2380D87A9E3
 for <dm-devel@redhat.com>; Tue, 25 Apr 2023 17:24:15 +0000 (UTC)
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com
 [209.85.219.54]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-154-Ey2PcOZ1NfSazZN7BdtqTQ-1; Tue, 25 Apr 2023 13:24:12 -0400
X-MC-Unique: Ey2PcOZ1NfSazZN7BdtqTQ-1
Received: by mail-qv1-f54.google.com with SMTP id
 6a1803df08f44-5ef8af5d211so47292066d6.3
 for <dm-devel@redhat.com>; Tue, 25 Apr 2023 10:24:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1682443452; x=1685035452;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=aCEA6oTf8PBVVHa1nZnZS/PSju31UM4aZmgUr2cjHOk=;
 b=ftiW0QstgtEAIA3NwZYlR0pZNHRSelHk1nYP8+m3vYeawMbW02vnKq5SD66tNlCM7y
 P8SsWwMLV02CGLhDudGnhEsrswoQOU5FC91Q22F6RnMj3rXbSVJ/gxOpwfwZB8oPp37M
 LhbyAc1zMMaFDiRkUz1sZCtQTyCulvc4Tf/89faMhJInxsL+LgiTYjKayyqi6bMo6eWj
 6wyBo5SWEBK8XXI/ig+Ldoq5wOZGWjjV4KuuH0aMH8uWuoz8QYVrYK3MUwpjAQkSyqGt
 nytDZpd2hsagqdNDmagUnCmkZJ+2QHVqvBA5ypmdaNOO2llNKceY67oyQOtouPO4GWuh
 qo+A==
X-Gm-Message-State: AAQBX9d4EXOOgRPgarNcM+TvLrjD6E45Ytxg47D+MKhJKYjiH3PgGrjW
 CVgFXidZ5qL5GfTrBrFaUGmUuRA=
X-Google-Smtp-Source: AKy350Yb0BPrIXqPDBPPuJ02a5Pv6Q0bGwEEX/y+TVfIyLzYnQz8w0X8y6f6KhPQMlj2FAY2nG+Kyw==
X-Received: by 2002:a05:6214:27c2:b0:5e9:2d8c:9a21 with SMTP id
 ge2-20020a05621427c200b005e92d8c9a21mr32113917qvb.32.1682443452154; 
 Tue, 25 Apr 2023 10:24:12 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 h8-20020a0cfca8000000b005dd8b93459esm4209837qvq.54.2023.04.25.10.24.11
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 25 Apr 2023 10:24:11 -0700 (PDT)
Date: Tue, 25 Apr 2023 13:24:10 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Shin'ichiro Kawasaki <shinichiro@fastmail.com>
Message-ID: <ZEgMuvNCud3fNdl4@redhat.com>
References: <20221230065424.19998-1-yukuai1@huaweicloud.com>
 <20230112010554.qmjuqtjoai3qqaj7@shindev>
 <6ccff2ec-b4bd-a1a6-5340-b9380adc1fff@huaweicloud.com>
 <oklvotdaxnncrugr2v7yqadzyfa5vvzrumrfv46vrzowjw3njo@tlvhd4eo5spl>
MIME-Version: 1.0
In-Reply-To: <oklvotdaxnncrugr2v7yqadzyfa5vvzrumrfv46vrzowjw3njo@tlvhd4eo5spl>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
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
 "yangerkun@huawei.com" <yangerkun@huawei.com>, Joe Thornber <ejt@redhat.com>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 Yu Kuai <yukuai1@huaweicloud.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
 shinichiro.kawasaki@wdc.com, "yukuai \(C\)" <yukuai3@huawei.com>,
 Li Lingfeng <lilingfeng3@huawei.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVHVlLCBBcHIgMjUgMjAyMyBhdCAgODoxNVAgLTA0MDAsClNoaW4naWNoaXJvIEthd2FzYWtp
IDxzaGluaWNoaXJvQGZhc3RtYWlsLmNvbT4gd3JvdGU6Cgo+IE9uIEFwciAyNSwgMjAyMyAvIDE2
OjIyLCBZdSBLdWFpIHdyb3RlOgo+ID4gSGksCj4gPiAKPiA+IOWcqCAyMDIzLzAxLzEyIDk6MDUs
IFNoaW5pY2hpcm8gS2F3YXNha2kg5YaZ6YGTOgo+ID4gPiBIZWxsbyBZdSwgdGhhbmtzIGZvciB0
aGUgcGF0Y2guIEkgdGhpbmsgaXQgaXMgZ29vZCB0byBoYXZlIHRoaXMgdGVzdCBjYXNlIHRvCj4g
PiA+IGF2b2lkIHJlcGVhdGluZyB0aGUgc2FtZSByZWdyZXNzaW9uLiBQbGVhc2UgZmluZCBteSBj
b21tZW50cyBpbiBsaW5lLgo+ID4gPiAKPiA+ID4gQ0MrOiBNaWtlLCBkbS1kZXZlbCwKPiA+ID4g
Cj4gPiA+IE1pa2UsIGNvdWxkIHlvdSB0YWtlIGEgbG9vayBpbiB0aGlzIG5ldyB0ZXN0IGNhc2U/
IEl0IGFkZHMgImRtIiB0ZXN0IGdyb3VwIHRvCj4gPiA+IGJsa3Rlc3RzLiBJZiB5b3UgaGF2ZSB0
aG91Z2h0cyBvbiBob3cgdG8gYWRkIGRldmljZS1tYXBwZXIgcmVsYXRlZCB0ZXN0IGNhc2VzCj4g
PiA+IHRvIGJsa3Rlc3RzLCBwbGVhc2Ugc2hhcmUgKE9yIHdlIG1heSBiZSBhYmxlIHRvIGRpc2N1
c3MgbGF0ZXIgYXQgTFNGIDIwMjMpLgo+ID4gCj4gPiBDYW4gd2UgYWRkICJkbSIgdGVzdCBncm91
cCB0byBibGt0ZXN0cz8gSSdsbCBzZW5kIGEgbmV3IHZlcnNpb24gaWYgd2UKPiA+IGNhbi4KPiAK
PiBJIHN1Z2dlc3QgdG8gd2FpdCBmb3IgTFNGIGRpc2N1c3Npb24gaW4gTWF5LCB3aGljaCBjb3Vs
ZCBiZSBhIGdvb2QgY2hhbmNlIHRvCj4gaGVhciBvcGluaW9ucyBvZiBkbSBleHBlcnRzLiBJIHRo
aW5rIHlvdXIgbmV3IHRlc3QgY2FzZSBpcyB2YWx1YWJsZSwgc28gSU1PIGl0Cj4gc2hvdWxkIGJl
IGFkZGVkIHRvIHRoZSBuZXcgImRtIiBncm91cCwgb3IgYXQgbGVhc3QgdG8gdGhlIGV4aXN0aW5n
ICJibG9jayIKPiBncm91cC4gTGV0J3MgZGVjaWRlIHRoZSB0YXJnZXQgZ3JvdXAgYWZ0ZXIgTFNG
Lgo+IAoKSXQncyBvYnZpb3VzbHkgZmluZSB0byBhZGQgYSBuZXcgImRtIiB0ZXN0IGdyb3VwIHRv
IGJsa3Rlc3RzLgoKQnV0IGp1c3Qgc28gb3RoZXJzIGFyZSBhd2FyZTogbW9yZSBlbGFib3JhdGUg
ZG0gdGVzdGluZyBpcyBjdXJyZW50bHkKc3ByZWFkIGFjcm9zcyBtdWx0aXBsZSB0ZXN0c3VpdGVz
IChlLmcuIGx2bTIsIGNyeXB0c2V0dXAsIG1wdGVzdCwKZGV2aWNlLW1hcHBlci10ZXN0LXN1aXRl
LCBldGMpLgoKVGhlcmUgaXMgbmV3IGVmZm9ydCB0byBwb3J0IGRldmljZS1tYXBwZXItdGVzdC1z
dWl0ZSB0ZXN0cyAod2hpY2ggdXNlCnJ1YnkpIHRvIGEgbmV3IHB5dGhvbiBoYXJuZXNzIGN1cnJl
bnRseSBuYW1lZCAiZG10ZXN0LXB5dGhvbiIsIEpvZQpUaG9ybmJlciBpcyBsZWFkaW5nIHRoaXMg
ZWZmb3J0ICh3aXRoIHRoZSBhc3Npc3RhbmNlIG9mCkNoYXRHUFQuLiBhcHBhcmVudGx5IGl0IGhh
cyBiZWVuIHdvbmRlcmZ1bCBpbiBoZWxwaW5nIEpvZSBnbHVlIHB5dGhvbgpjb2RlIHRvZ2V0aGVy
IHRvIGFjY29tcGxpc2ggYW55dGhpbmcgaGUncyBuZWVkZWQpOgpodHRwczovL2dpdGh1Yi5jb20v
anRob3JuYmVyL2RtdGVzdC1weXRob24KCih3ZSd2ZSBkaXNjdXNzZWQgcmVuYW1pbmcgImRtdGVz
dC1weXRob24iIHRvICJkbXRlc3RzIikKCkkndmUgYWxzbyBkaXNjdXNzZWQgd2l0aCBKb2UgdGhl
IHBsYW4gdG8gd3JhcCB0aGUgb3RoZXIgZGlzcGFyYXRlCnRlc3RzdWl0ZXMgd2l0aCBETSBjb3Zl
cmFnZSBpbiB0ZXJtcyBvZiB0aGUgbmV3IGRtdGVzdC1weXRob24uCmJsa3Rlc3RzIGNhbiBiZSBt
YWRlIHRvIGJlIG9uZSBvZiB0aGUgdGVzdHN1aXRlcyB3ZSBhZGQgc3VwcG9ydCBmb3IKKHNvIHRo
YXQgYWxsIGJsa3Rlc3RzIHJ1biBvbiB2YXJpb3VzIHR5cGVzIG9mIERNIHRhcmdldHMpLgoKUmVh
bGx5IGFsbCB3ZSBuZWVkIGlzIGEgbWVhbnMgdG86CjEpIGxpc3QgYWxsIHRlc3RzIGluIGEgdGVz
dHN1aXRlCjIpIGluaXRpYXRlIHJ1bm5pbmcgZWFjaCB0ZXN0IGluZGl2aWR1YWxseQoKTWlrZQoK
LS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0
bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

