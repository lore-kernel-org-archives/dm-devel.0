Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 814B5C433FE
	for <dm-devel@archiver.kernel.org>; Fri, 30 Sep 2022 07:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1664521906;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=D4Kmc6gKpYqTOPZdYBPohSzYGO3IydwVaxeGX7NYj28=;
	b=S2+dMPYIopxRFWCLn2zCMrmgtEfMIUkOa/Da7yCO6cjMMbpV8JkCxyteN8lerfJAsbrctM
	EE+nQ/7ecgZ5W1NrHP+DiJicLc4T7EDbsJ4FRxA7L1wcMjSQukZ93SZfknQ/81gpusE3dc
	PaqHIe17JPrH34b+A74OsIh85gX228c=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-593-_Duj7d6oOzeJo3wt5ZAttQ-1; Fri, 30 Sep 2022 03:11:42 -0400
X-MC-Unique: _Duj7d6oOzeJo3wt5ZAttQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C1E7529324B6;
	Fri, 30 Sep 2022 07:11:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A9BDC4B4019;
	Fri, 30 Sep 2022 07:11:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 812E41946A79;
	Fri, 30 Sep 2022 07:11:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A296A1946A4E
 for <dm-devel@listman.corp.redhat.com>; Fri, 30 Sep 2022 00:57:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 57A39492B06; Fri, 30 Sep 2022 00:57:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4F9D5492B04
 for <dm-devel@redhat.com>; Fri, 30 Sep 2022 00:57:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2B5A6101AA5B
 for <dm-devel@redhat.com>; Fri, 30 Sep 2022 00:57:52 +0000 (UTC)
Received: from esa12.hc1455-7.c3s2.iphmx.com (esa12.hc1455-7.c3s2.iphmx.com
 [139.138.37.100]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-418-JZ2sphH8Nt2tMIJsQRbnGA-1; Thu, 29 Sep 2022 20:57:50 -0400
X-MC-Unique: JZ2sphH8Nt2tMIJsQRbnGA-1
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="70026171"
X-IronPort-AV: E=Sophos;i="5.93,357,1654527600"; d="scan'208";a="70026171"
Received: from unknown (HELO oym-r4.gw.nic.fujitsu.com) ([210.162.30.92])
 by esa12.hc1455-7.c3s2.iphmx.com with ESMTP; 30 Sep 2022 09:56:44 +0900
Received: from oym-m3.gw.nic.fujitsu.com (oym-nat-oym-m3.gw.nic.fujitsu.com
 [192.168.87.60])
 by oym-r4.gw.nic.fujitsu.com (Postfix) with ESMTP id 96B85DA68D;
 Fri, 30 Sep 2022 09:56:43 +0900 (JST)
Received: from m3002.s.css.fujitsu.com (msm3.b.css.fujitsu.com
 [10.128.233.104])
 by oym-m3.gw.nic.fujitsu.com (Postfix) with ESMTP id B64D7D949A;
 Fri, 30 Sep 2022 09:56:42 +0900 (JST)
Received: from [10.8.170.187] (unknown [10.8.170.187])
 by m3002.s.css.fujitsu.com (Postfix) with ESMTP id 2A30C202614A;
 Fri, 30 Sep 2022 09:56:42 +0900 (JST)
Message-ID: <1444b9b5-363a-163c-0513-55d1ea951799@fujitsu.com>
Date: Fri, 30 Sep 2022 09:56:41 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
From: =?UTF-8?B?R290b3UsIFlhc3Vub3JpL+S6lOWztiDlurfmloc=?= <y-goto@fujitsu.com>
To: =?UTF-8?B?WWFuZywgWGlhby/mnagg5pmT?= <yangx.jy@fujitsu.com>,
 "Darrick J. Wong" <djwong@kernel.org>, Brian Foster <bfoster@redhat.com>,
 "hch@infradead.org" <hch@infradead.org>
References: <Ytl7yJJL1fdC006S@magnolia>
 <7fde89dc-2e8f-967b-d342-eb334e80255c@fujitsu.com>
 <YuNn9NkUFofmrXRG@magnolia>
 <0ea1cbe1-79d7-c22b-58bf-5860a961b680@fujitsu.com>
 <YusYDMXLYxzqMENY@magnolia>
 <dd363bd8-2dbd-5d9c-0406-380b60c5f510@fujitsu.com> <Yxs5Jb7Yt2c6R6eW@bfoster>
 <7fdc9e88-f255-6edb-7964-a5a82e9b1292@fujitsu.com>
 <76ea04b4-bad7-8cb3-d2c6-4ad49def4e05@fujitsu.com> <YyHKUhOgHdTKPQXL@bfoster>
 <YyIBMJzmbZsUBHpy@magnolia>
 <a6e7f4eb-0664-bbe8-98d2-f8386b226113@fujitsu.com>
 <e3d51a6b-12e9-2a19-1280-5fd9dd64117c@fujitsu.com>
 <deb54a77-90d3-df44-1880-61cce6e3f670@fujitsu.com>
In-Reply-To: <deb54a77-90d3-df44-1880-61cce6e3f670@fujitsu.com>
X-TM-AS-GCONF: 00
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Fri, 30 Sep 2022 07:11:37 +0000
Subject: Re: [dm-devel] [PATCH] xfs: fail dax mount if reflink is enabled on
 a partition
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
Cc: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, toshi.kani@hpe.com,
 dm-devel@redhat.com, "david@fromorbit.com" <david@fromorbit.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 =?UTF-8?B?UnVhbiwgU2hpeWFuZy/pmK4g5LiW6Ziz?= <ruansy.fnst@fujitsu.com>,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 Jeff Moyer <jmoyer@redhat.com>, zwisler@kernel.org,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

SGVsbG8gZXZlcnlvbmUsCgpPbiAyMDIyLzA5LzIwIDExOjM4LCBZYW5nLCBYaWFvL+adqCDmmZMg
d3JvdGU6Cj4gSGkgRGFycmljaywgQnJpYW4gYW5kIENocmlzdG9waAo+IAo+IFBpbmcuIEkgaG9w
ZSB0byBnZXQgeW91ciBmZWVkYmFjay4KPiAKPiAxKSBJIGhhdmUgY29uZmlybWVkIHRoYXQgdGhl
IGZvbGxvd2luZyBwYXRjaCBzZXQgZGlkIG5vdCBjaGFuZ2UgdGhlIHRlc3QgCj4gcmVzdWx0IG9m
IGdlbmVyaWMvNDcwIHdpdGggdGhpbi12b2x1bWUuIEJlc2lkZXMsIEkgZGlkbid0IHNlZSBhbnkg
Cj4gZmFpbHVyZSB3aGVuIHJ1bm5pbmcgZ2VuZXJpYy80NzAgYmFzZWQgb24gbm9ybWFsIFBNRU0g
ZGV2aWNlIGluc3RhZWQgb2YgCj4gdGhpbi12b2x1bWUuCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5v
cmcvbGludXgteGZzLzIwMjExMTI5MTAyMjAzLjIyNDM1MDktMS1oY2hAbHN0LmRlLwo+IAo+IDIp
IEkgY2FuIHJlcHJvZHVjZSB0aGUgZmFpbHVyZSBvZiBnZW5lcmljLzQ4MiB3aXRob3V0IHRoaW4t
dm9sdW1lLgo+IAo+IDMpIElzIGl0IG5lY2Vzc2FyeSB0byBtYWtlIHRoaW4tdm9sdW1lIHN1cHBv
cnQgREFYLiBJcyB0aGVyZSBhbnkgdXNlIAo+IGNhc2UgZm9yIHRoZSByZXF1aXJlbWVudD8KCgpU
aG91Z2ggSSBhc2tlZCBvdGhlciBwbGFjZSgqKSwgSSByZWFsbHkgd2FudCB0byBrbm93IHRoZSB1
c2VjYXNlIG9mCmRtLXRoaW4tdm9sdW1lIHdpdGggREFYIGFuZCByZWZsaW5rLgoKCkluIG15IHVu
ZGVyc3RhbmRpbmcsIGRtLXRoaW4tdm9sdW1lIHNlZW1zIHRvIHByb3ZpZGUgc2ltaWxhciBmZWF0
dXJlIApsaWtlIHJlZmxpbmsgb2YgeGZzLiBCb3RoIGZlYXR1cmUgcHJvdmlkZSBDT1cgdXBkYXRl
IHRvIHJlZHVjZSB1c2FnZSBvZgppdHMgcmVnaW9uLCBhbmQgc25hcHNob3QgZmVhdHVyZSwgcmln
aHQ/CgpJIGZvdW5kIHRoYXQgZG9ja2VyIHNlZW1zIHRvIHNlbGVjdCBvbmUgb2YgdGhlbSAob3Ig
b3RoZXIgZmVhdHVyZSB3aGljaCAKc3VwcG9ydHMgQ09XKS4gVGhlbiB1c2VyIGRvbid0IG5lZWQg
dG8gdXNlIHRoaW4tdm9sdW1lIGFuZCByZWZsaW5rIGF0IApzYW1lIHRpbWUuCgpEYXRhYmFzZSB3
aGljaCB1c2VzIEZTLURBWCBtYXkgd2FudCB0byB1c2Ugc25hcHNob3QgZm9yIGl0cyBkYXRhIG9m
IApGUy1EQVgsIGl0cyB1c2VyIHNlZW1zIHRvIGJlIHNhdGlzZmllZCB3aXRoIHJlZmxpbmsgb3Ig
dGhpbi12b2x1bWUuCgpTbyBJIGNvdWxkIG5vdCBmaW5kIG9uIHdoYXQgdXNlLWNhc2UgdXNlciB3
b3VsZCBsaWtlIHRvIHVzZSAKZG0tdGhpbi12b2x1bWUgYW5kIHJlZmxpbmsgYXQgc2FtZSB0aW1l
LgoKVGhlIG9ubHkgcG9zc2liaWxpdHkgaXMgdGhhdCB0aGUgdXNlciBoYXMgbWlzdGFrZW5seSBj
b25maWd1cmVkIApkbS10aGlucG9vbCBhbmQgcmVmbGluayB0byBiZSB1c2VkIGF0IHRoZSBzYW1l
IHRpbWUsIGJ1dCBpZiB0aGF0IGlzIHRoZSAKY2FzZSwgaXQgc2VlbXMgdG8gYmUgYmV0dGVyIGZv
ciB0aGUgdXNlciB0byBkaXNhYmxlIG9uZSBvciB0aGUgb3RoZXIuCgpJIHJlYWxseSB3YW5kZXIg
d2h5IGRtLXRoaW4tdm9sdW1lIG11c3QgYmUgdXNlZCB3aXRoIHJlZmxpayBhbmQgRlMtREFYLgoK
SWYgbXkgdW5kZXJzdGFuZGluZyBpcyBzb21ldGhpbmcgd3JvbmcsIHBsZWFzZSBjb3JyZWN0IG1l
LgoKKCopaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsL1RZV1BSMDFNQjEwMDgyNThGNDc0Q0Ey
Mjk1QjRDRDNEOUI5MDU0OUBUWVdQUjAxTUIxMDA4Mi5qcG5wcmQwMS5wcm9kLm91dGxvb2suY29t
LwoKVGhhbmtzLAotLS0KWWFzdW5vcmkgR290bwoKCj4gCj4gQmVzdCBSZWdhcmRzLAo+IFhpYW8g
WWFuZwo+IAo+IE9uIDIwMjIvOS8xNiAxMDowNCwgWWFuZywgWGlhby/mnagg5pmTIHdyb3RlOgo+
PiBPbiAyMDIyLzkvMTUgMTg6MTQsIFlhbmcsIFhpYW8v5p2oIOaZkyB3cm90ZToKPj4+IE9uIDIw
MjIvOS8xNSAwOjI4LCBEYXJyaWNrIEouIFdvbmcgd3JvdGU6Cj4+Pj4gT24gV2VkLCBTZXAgMTQs
IDIwMjIgYXQgMDg6MzQ6MjZBTSAtMDQwMCwgQnJpYW4gRm9zdGVyIHdyb3RlOgo+Pj4+PiBPbiBX
ZWQsIFNlcCAxNCwgMjAyMiBhdCAwNTozODowMlBNICswODAwLCBZYW5nLCBYaWFvL+adqCDmmZMg
d3JvdGU6Cj4+Pj4+PiBPbiAyMDIyLzkvMTQgMTQ6NDQsIFlhbmcsIFhpYW8v5p2oIOaZkyB3cm90
ZToKPj4+Pj4+PiBPbiAyMDIyLzkvOSAyMTowMSwgQnJpYW4gRm9zdGVyIHdyb3RlOgo+Pj4+Pj4+
PiBZZXMuLiBJIGRvbid0IHJlY2FsbCBhbGwgdGhlIGludGVybmFscyBvZiB0aGUgdG9vbHMgYW5k
IHRlc3QsIAo+Pj4+Pj4+PiBidXQgSUlSQwo+Pj4+Pj4+PiBpdCByZWxpZWQgb24gZGlzY2FyZCB0
byBwZXJmb3JtIHplcm9pbmcgYmV0d2VlbiBjaGVja3BvaW50cyBvciAKPj4+Pj4+Pj4gc29tZSBz
dWNoCj4+Pj4+Pj4+IGFuZCBhdm9pZCBzcHVyaW91cyBmYWlsdXJlcy4gVGhlIHB1cnBvc2Ugb2Yg
cnVubmluZyBvbiBkbS10aGluIHdhcwo+Pj4+Pj4+PiBtZXJlbHkgdG8gcHJvdmlkZSByZWxpYWJs
ZSBkaXNjYXJkIHplcm9pbmcgYmVoYXZpb3Igb24gdGhlIAo+Pj4+Pj4+PiB0YXJnZXQgZGV2aWNl
Cj4+Pj4+Pj4+IGFuZCB0aHVzIHRvIGFsbG93IHRoZSB0ZXN0IHRvIHJ1biByZWxpYWJseS4KPj4+
Pj4+PiBIaSBCcmlhbiwKPj4+Pj4+Pgo+Pj4+Pj4+IEFzIGZhciBhcyBJIGtub3csIGdlbmVyaWMv
NDcwIHdhcyBvcmlnaW5hbCBkZXNpZ25lZCB0byB2ZXJpZnkKPj4+Pj4+PiBtbWFwKE1BUF9TWU5D
KSBvbiB0aGUgZG0tbG9nLXdyaXRlcyBkZXZpY2UgZW5hYmxpbmcgREFYLiBEdWUgdG8gdGhlCj4+
Pj4+Pj4gcmVhc29uLCB3ZSBuZWVkIHRvIGVuc3VyZSB0aGF0IGFsbCB1bmRlcmx5aW5nIGRldmlj
ZXMgdW5kZXIKPj4+Pj4+PiBkbS1sb2ctd3JpdGVzIGRldmljZSBzdXBwb3J0IERBWC4gSG93ZXZl
ciBkbS10aGluIGRldmljZSBuZXZlciAKPj4+Pj4+PiBzdXBwb3J0cwo+Pj4+Pj4+IERBWCBzbwo+
Pj4+Pj4+IHJ1bm5pbmcgZ2VuZXJpYy80NzAgd2l0aCBkbS10aGluIGRldmljZSBhbHdheXMgcmV0
dXJucyAibm90IHJ1biIuCj4+Pj4+Pj4KPj4+Pj4+PiBQbGVhc2Ugc2VlIHRoZSBkaWZmZXJlbmNl
IGJldHdlZW4gb2xkIGFuZCBuZXcgbG9naWM6Cj4+Pj4+Pj4KPj4+Pj4+PiDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIG9sZCBsb2dpY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIG5ldyBsb2dpYwo+Pj4+Pj4+IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQo+Pj4+Pj4+IGxvZy13cml0ZXMg
ZGV2aWNlKERBWCnCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBsb2ctd3JpdGVzIGRl
dmljZShEQVgpCj4+Pj4+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgfAo+Pj4+Pj4+IFBNRU0wKERBWCkgKyBQTUVNMShEQVgpwqDCoMKgwqDCoMKgIFRo
aW4gZGV2aWNlKG5vbi1EQVgpICsgUE1FTTEoREFYKQo+Pj4+Pj4+IMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIHwKPj4+Pj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIFBNRU0wKERB
WCkKPj4+Pj4+PiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0KPj4+Pj4+Pgo+Pj4+Pj4+IFdlIHRoaW5rIGRtLXRoaW4gZGV2aWNl
IGlzIG5vdCBhIGdvb2Qgc29sdXRpb24gZm9yIGdlbmVyaWMvNDcwLCAKPj4+Pj4+PiBpcyB0aGVy
ZQo+Pj4+Pj4+IGFueSBvdGhlciBzb2x1dGlvbiB0byBzdXBwb3J0IGJvdGggZGlzY2FyZCB6ZXJv
IGFuZCBEQVg/Cj4+Pj4+Pgo+Pj4+Pj4gSGkgQnJpYW4sCj4+Pj4+Pgo+Pj4+Pj4gSSBoYXZlIHNl
bnQgYSBwYXRjaFsxXSB0byByZXZlcnQgeW91ciBmaXggYmVjYXVzZSBJIHRoaW5rIGl0J3Mgbm90
IAo+Pj4+Pj4gZ29vZCBmb3IKPj4+Pj4+IGdlbmVyaWMvNDcwIHRvIHVzZSB0aGluIHZvbHVtZSBh
cyBteSByZXZlcnQgcGF0Y2hbMV0gZGVzY3JpYmVzOgo+Pj4+Pj4gWzFdIAo+Pj4+Pj4gaHR0cHM6
Ly9sb3JlLmtlcm5lbC5vcmcvZnN0ZXN0cy8yMDIyMDkxNDA5MDYyNS4zMjIwNy0xLXlhbmd4Lmp5
QGZ1aml0c3UuY29tL1QvI3UgCj4+Pj4+Pgo+Pj4+Pj4KPj4+Pj4KPj4+Pj4gSSB0aGluayB0aGUg
aGlzdG9yeSBoZXJlIGlzIHRoYXQgZ2VuZXJpYy80ODIgd2FzIGNoYW5nZWQgb3ZlciBmaXJzdCBp
bgo+Pj4+PiBjb21taXQgNjVjYzlhMjM1OTE5ICgiZ2VuZXJpYy80ODI6IHVzZSB0aGluIHZvbHVt
ZSBhcyBkYXRhIAo+Pj4+PiBkZXZpY2UiKSwgYW5kCj4+Pj4+IHRoZW4gc29tZXRpbWUgbGF0ZXIg
d2UgcmVhbGl6ZWQgZ2VuZXJpYy80NTUsNDU3LDQ3MCBoYWQgdGhlIHNhbWUgCj4+Pj4+IGdlbmVy
YWwKPj4+Pj4gZmxhdyBhbmQgd2VyZSBzd2l0Y2hlZCBvdmVyLiBUaGUgZG0vZGF4IGNvbXBhdGli
aWxpdHkgdGhpbmcgd2FzIAo+Pj4+PiBwcm9iYWJseQo+Pj4+PiBqdXN0IGFuIG92ZXJzaWdodCwg
YnV0IEkgYW0gYSBsaXR0bGUgY3VyaW91cyBhYm91dCB0aGF0IGJlY2F1c2UgaXQgCj4+Pj4+IHNo
b3VsZAo+Pj4+Cj4+Pj4gSXQncyBub3QgYW4gb3ZlcnNpZ2h0IC0tIGl0IHVzZWQgdG8gd29yayAo
YWxiZWl0IHdpdGggRVhQRVJJTUVOVEFMCj4+Pj4gdGFncyksIGFuZCBub3cgd2UndmUgYnJva2Vu
IGl0IG9uIGZzZGF4IGFzIHRoZSBwbWVtL2Jsb2NrZGV2IGRpdm9yY2UKPj4+PiBwcm9ncmVzc2Vz
Lgo+Pj4gSGkKPj4+Cj4+PiBEbyB5b3UgbWVhbiB0aGF0IHRoZSBmb2xsb3dpbmcgcGF0Y2ggc2V0
IGNoYW5nZWQgdGhlIHRlc3QgcmVzdWx0IG9mIAo+Pj4gZ2VuZXJpYy80NzAgd2l0aCB0aGluLXZv
bHVtZT8gKHBhc3MgPT4gbm90IHJ1bi9mYWlsdXJlKQo+Pj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5v
cmcvbGludXgteGZzLzIwMjExMTI5MTAyMjAzLjIyNDM1MDktMS1oY2hAbHN0LmRlLwo+Pj4KPj4+
Pgo+Pj4+PiBoYXZlIGJlZW4gb2J2aW91cyB0aGF0IHRoZSBjaGFuZ2UgY2F1c2VkIHRoZSB0ZXN0
IHRvIG5vIGxvbmdlciBydW4uIAo+Pj4+PiBEaWQKPj4+Pj4gc29tZXRoaW5nIGNoYW5nZSBhZnRl
ciB0aGF0IHRvIHRyaWdnZXIgdGhhdCBjaGFuZ2UgaW4gYmVoYXZpb3I/Cj4+Pj4+Cj4+Pj4+PiBX
aXRoIHRoZSByZXZlcnQsIGdlbmVyaWMvNDcwIGNhbiBhbHdheXMgcnVuIHN1Y2Nlc3NmdWxseSBv
biBteSAKPj4+Pj4+IGVudmlyb25tZW50Cj4+Pj4+PiBzbyBJIHdvbmRlciBob3cgdG8gcmVwcm9k
dWNlIHRoZSBvdXQtb2Ytb3JkZXIgcmVwbGF5IGlzc3VlIG9uIFhGUyB2NQo+Pj4+Pj4gZmlsZXN5
c3RlbT8KPj4+Pj4+Cj4+Pj4+Cj4+Pj4+IEkgZG9uJ3QgcXVpdGUgcmVjYWxsIHRoZSBjaGFyYWN0
ZXJpc3RpY3Mgb2YgdGhlIGZhaWx1cmVzIGJleW9uZCAKPj4+Pj4gdGhhdCB3ZQo+Pj4+PiB3ZXJl
IHNlZWluZyBzcHVyaW91cyB0ZXN0IGZhaWx1cmVzIHdpdGggZ2VuZXJpYy80ODIgdGhhdCB3ZXJl
IGR1ZSB0bwo+Pj4+PiBlc3NlbnRpYWxseSBwdXR0aW5nIHRoZSBmcy9sb2cgYmFjayBpbiB0aW1l
IGluIGEgd2F5IHRoYXQgd2Fzbid0IHF1aXRlCj4+Pj4+IGFjY3VyYXRlIGR1ZSB0byB0aGUgY2xl
YXJpbmcgYnkgdGhlIGxvZ3dyaXRlcyB0b29sIG5vdCB0YWtpbmcgCj4+Pj4+IHBsYWNlLiBJZgo+
Pj4+PiB5b3Ugd2FudGVkIHRvIHJlcHJvZHVjZSBpbiBvcmRlciB0byByZXZpc2l0IHRoYXQsIHBl
cmhhcHMgc3RhcnQgd2l0aAo+Pj4+PiBnZW5lcmljLzQ4MiBhbmQgbGV0IGl0IHJ1biBpbiBhIGxv
b3AgZm9yIGEgd2hpbGUgYW5kIHNlZSBpZiBpdAo+Pj4+PiBldmVudHVhbGx5IHRyaWdnZXJzIGEg
ZmFpbHVyZS9jb3JydXB0aW9uLi4/Cj4+Pj4+Cj4+Pj4+PiBQUzogSSB3YW50IHRvIHJlcHJvZHVj
ZSB0aGUgaXNzdWUgYW5kIHRyeSB0byBmaW5kIGEgYmV0dGVyIAo+Pj4+Pj4gc29sdXRpb24gdG8g
Zml4Cj4+Pj4+PiBpdC4KPj4+Pj4+Cj4+Pj4+Cj4+Pj4+IEl0J3MgYmVlbiBhIHdoaWxlIHNpbmNl
IEkgbG9va2VkIGF0IGFueSBvZiB0aGlzIHRvb2xpbmcgdG8gCj4+Pj4+IHNlbWktZ3JvayBob3cK
Pj4+Pj4gaXQgd29ya3MuCj4+Pj4KPj4+PiBJIC90aGluay8gdGhpcyB3YXMgdGhlIGNydXggb2Yg
dGhlIHByb2JsZW0sIGJhY2sgaW4gMjAxOT8KPj4+PiBodHRwczovL2xvcmUua2VybmVsLm9yZy9m
c3Rlc3RzLzIwMTkwMjI3MDYxNTI5LkdGMTY0MzZAZGFzdGFyZC8KPj4+Cj4+PiBBZ3JlZWQuCj4+
Pgo+Pj4+Cj4+Pj4+IFBlcmhhcHMgaXQgY291bGQgbGVhcm4gdG8gcmVseSBvbiBzb21ldGhpbmcg
bW9yZSBleHBsaWNpdCBsaWtlCj4+Pj4+IHplcm8gcmFuZ2UgKGluc3RlYWQgb2YgZGlzY2FyZD8p
IG9yIGZhbGwgYmFjayB0byBtYW51YWwgemVyb2luZz8KPj4+Pgo+Pj4+IEFGQUlDVCBzcmMvbG9n
LXdyaXRlcy8gYWN0dWFsbHkgL2Nhbi8gZG8gemVyb2luZywgYnV0IChhKSBpdCBwcm9iYWJseQo+
Pj4+IG91Z2h0IHRvIGJlIGFkYXB0ZWQgdG8gY2FsbCBCTEtaRVJPT1VUIGFuZCAoYikgaW4gdGhl
IHdvcnN0IGNhc2UgaXQKPj4+PiB3cml0ZXMgemVyb2VzIHRvIHRoZSBlbnRpcmUgZGV2aWNlLCB3
aGljaCBpcy9jYW4gYmUgc2xvdy4KPj4+Pgo+Pj4+IEZvciBhIChjcmFzcykgZXhhbXBsZSwgb25l
IG9mIG15IGNsb3VkeSB0ZXN0IFZNcyB1c2VzIDM0R0IgcGFydGl0aW9ucywKPj4+PiBhbmQgZm9y
IGNvc3Qgb3B0aW1pemF0aW9uIHB1cnBvc2VzIHdlJ3JlIG9ubHkgInBheWluZyIgZm9yIHRoZSBj
aGVhcGVzdAo+Pj4+IHRpZXIuwqAgV2VpcmRseSB0aGF0IG1hcHMgdG8gYW4gdXBwZXIgbGltaXQg
b2YgNjUwMCB3cml0ZSBpb3BzIGFuZAo+Pj4+IDQ4TUIvcyghKSBidXQgdGhhdCB3b3VsZCB0YWtl
IGFib3V0IDIwIG1pbnV0ZXMgdG8gemVybyB0aGUgZW50aXJlCj4+Pj4gZGV2aWNlIGlmIHRoZSBk
bS10aGluIGhhY2sgd2Fzbid0IGluIHBsYWNlLsKgIEZydXN0cmF0aW5nbHksIGl0IGRvZXNuJ3QK
Pj4+PiBzdXBwb3J0IGRpc2NhcmQgb3Igd3JpdGUtemVyb2VzLgo+Pj4KPj4+IERvIHlvdSBtZWFu
IHRoYXQgZGlzY2FyZCB6ZXJvKEJMS0RJU0NBUkQpIGlzIGZhc3RlciB0aGFuIGJvdGggZmlsbCAK
Pj4+IHplcm8oQkxLWkVST09VVCkgYW5kIHdyaXRlIHplcm8gb24gdXNlciBzcGFjZT8KPj4KPj4g
SGkgRGFycmljaywgQnJpYW4gYW5kIENocmlzdG9waAo+Pgo+PiBBY2NvcmRpbmcgdG8gdGhlIGRp
c2N1c3Npb24gYWJvdXQgZ2VuZXJpYy80NzAuIEkgd29uZGVyIGlmIGl0IGlzIAo+PiBuZWNlc3Nh
cnkgdG8gbWFrZSB0aGluLXBvb2wgc3VwcG9ydCBEQVguIElzIHRoZXJlIGFueSB1c2UgY2FzZSBm
b3IgdGhlIAo+PiByZXF1aXJlbWVudD8KPj4KPj4gQmVzdCBSZWdhcmRzLAo+PiBYaWFvIFlhbmcK
Pj4+Cj4+PiBCZXN0IFJlZ2FyZHMsCj4+PiBYaWFvIFlhbmcKPj4+Pgo+Pj4+PiBJZiB0aGUKPj4+
Pj4gZXZlbnR1YWwgc29sdXRpb24gaXMgc2ltcGxlIGFuZCBsb3cgZW5vdWdoIG92ZXJoZWFkLCBp
dCBtaWdodCBtYWtlIAo+Pj4+PiBzb21lCj4+Pj4+IHNlbnNlIHRvIHJlcGxhY2UgdGhlIGRtdGhp
biBoYWNrIGFjcm9zcyB0aGUgc2V0IG9mIHRlc3RzIG1lbnRpb25lZAo+Pj4+PiBhYm92ZS4KPj4+
Pgo+Pj4+IFRoYXQgc2FpZCwgZm9yIGEgKnBtZW0qIHRlc3QgeW91J2QgZXhwZWN0IGl0IHRvIGJl
IGZhc3RlciB0aGFuIHRoYXQuLi4KPj4+Pgo+Pj4+IC0tRAo+Pj4+Cj4+Pj4+IEJyaWFuCj4+Pj4+
Cj4+Pj4+PiBCZXN0IFJlZ2FyZHMsCj4+Pj4+PiBYaWFvIFlhbmcKPj4+Pj4+Cj4+Pj4+Pj4KPj4+
Pj4+PiBCVFcsIG9ubHkgbG9nLXdyaXRlcywgc3RyaXBlIGFuZCBsaW5lYXIgc3VwcG9ydCBEQVgg
Zm9yIG5vdy4KPj4+Pj4+Cj4+Pj4+CgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxA
cmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2Rt
LWRldmVsCg==

