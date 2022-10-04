Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FA40C433F5
	for <dm-devel@archiver.kernel.org>; Tue,  4 Oct 2022 05:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1664862000;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ONxU7XbTB+YY8WA3eGc3qxiYVSLq2ftLpC1BBO06KV8=;
	b=gKKgJYL+4+rgEqpSt6xIL2p2Ezpp/XsLyNwwb/TmxCjQwM0PXcRVXeDNNj3BHXylEX8Cnh
	XqbkXST8RdRLHj/m3niwke5893JhWLrWEAZh0R3QrSOOVfLuCoojs1sefw14iUT7jiLqao
	UzrSizsZzf5uT95ONhbqzqZD99EZ8ZA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-86-_chSEp4lPZaye7Re537O5Q-1; Tue, 04 Oct 2022 01:39:59 -0400
X-MC-Unique: _chSEp4lPZaye7Re537O5Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DD3611C09C8B;
	Tue,  4 Oct 2022 05:39:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B6B3540C6EC2;
	Tue,  4 Oct 2022 05:39:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6690D19465A2;
	Tue,  4 Oct 2022 05:39:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1062F1946588
 for <dm-devel@listman.corp.redhat.com>; Tue,  4 Oct 2022 04:14:00 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E17AE1400C38; Tue,  4 Oct 2022 04:13:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D9F06140EBF5
 for <dm-devel@redhat.com>; Tue,  4 Oct 2022 04:13:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6D458862FDC
 for <dm-devel@redhat.com>; Tue,  4 Oct 2022 04:13:59 +0000 (UTC)
Received: from esa1.hc1455-7.c3s2.iphmx.com (esa1.hc1455-7.c3s2.iphmx.com
 [207.54.90.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-604-sHA1bdNXPqq86fr3NYgzUw-1; Tue, 04 Oct 2022 00:13:58 -0400
X-MC-Unique: sHA1bdNXPqq86fr3NYgzUw-1
X-IronPort-AV: E=McAfee;i="6500,9779,10489"; a="90969650"
X-IronPort-AV: E=Sophos;i="5.93,367,1654527600"; d="scan'208";a="90969650"
Received: from unknown (HELO yto-r2.gw.nic.fujitsu.com) ([218.44.52.218])
 by esa1.hc1455-7.c3s2.iphmx.com with ESMTP; 04 Oct 2022 13:12:52 +0900
Received: from yto-m3.gw.nic.fujitsu.com (yto-nat-yto-m3.gw.nic.fujitsu.com
 [192.168.83.66])
 by yto-r2.gw.nic.fujitsu.com (Postfix) with ESMTP id 15234D624E;
 Tue,  4 Oct 2022 13:12:51 +0900 (JST)
Received: from m3003.s.css.fujitsu.com (m3003.s.css.fujitsu.com
 [10.128.233.114])
 by yto-m3.gw.nic.fujitsu.com (Postfix) with ESMTP id 52892D21AD;
 Tue,  4 Oct 2022 13:12:50 +0900 (JST)
Received: from [10.14.75.87] (unknown [10.14.75.87])
 by m3003.s.css.fujitsu.com (Postfix) with ESMTP id 8CF0F2005AD8;
 Tue,  4 Oct 2022 13:12:47 +0900 (JST)
Message-ID: <f196bcab-6aa2-6313-8a7c-f8ab409621b7@fujitsu.com>
Date: Mon, 3 Oct 2022 21:12:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
To: "Darrick J. Wong" <djwong@kernel.org>
References: <dd363bd8-2dbd-5d9c-0406-380b60c5f510@fujitsu.com>
 <Yxs5Jb7Yt2c6R6eW@bfoster> <7fdc9e88-f255-6edb-7964-a5a82e9b1292@fujitsu.com>
 <76ea04b4-bad7-8cb3-d2c6-4ad49def4e05@fujitsu.com> <YyHKUhOgHdTKPQXL@bfoster>
 <YyIBMJzmbZsUBHpy@magnolia>
 <a6e7f4eb-0664-bbe8-98d2-f8386b226113@fujitsu.com>
 <e3d51a6b-12e9-2a19-1280-5fd9dd64117c@fujitsu.com>
 <deb54a77-90d3-df44-1880-61cce6e3f670@fujitsu.com>
 <1444b9b5-363a-163c-0513-55d1ea951799@fujitsu.com>
 <Yzt6eWLuX/RTjmjj@magnolia>
From: =?UTF-8?B?R290b3UsIFlhc3Vub3JpL+S6lOWztiDlurfmloc=?= <y-goto@fujitsu.com>
In-Reply-To: <Yzt6eWLuX/RTjmjj@magnolia>
X-TM-AS-GCONF: 00
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Tue, 04 Oct 2022 05:39:53 +0000
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
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, toshi.kani@hpe.com,
 dm-devel@redhat.com, "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 Brian Foster <bfoster@redhat.com>,
 =?UTF-8?B?WWFuZywgWGlhby/mnagg5pmT?= <yangx.jy@fujitsu.com>,
 "david@fromorbit.com" <david@fromorbit.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 =?UTF-8?B?UnVhbiwgU2hpeWFuZy/pmK4g5LiW6Ziz?= <ruansy.fnst@fujitsu.com>,
 "hch@infradead.org" <hch@infradead.org>, Jeff Moyer <jmoyer@redhat.com>,
 zwisler@kernel.org,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMjAyMi8xMC8wMyAxNzoxMiwgRGFycmljayBKLiBXb25nIHdyb3RlOgo+IE9uIEZyaSwgU2Vw
IDMwLCAyMDIyIGF0IDA5OjU2OjQxQU0gKzA5MDAsIEdvdG91LCBZYXN1bm9yaS/kupTls7Yg5bq3
5paHIHdyb3RlOgo+PiBIZWxsbyBldmVyeW9uZSwKPj4KPj4gT24gMjAyMi8wOS8yMCAxMTozOCwg
WWFuZywgWGlhby/mnagg5pmTIHdyb3RlOgo+Pj4gSGkgRGFycmljaywgQnJpYW4gYW5kIENocmlz
dG9waAo+Pj4KPj4+IFBpbmcuIEkgaG9wZSB0byBnZXQgeW91ciBmZWVkYmFjay4KPj4+Cj4+PiAx
KSBJIGhhdmUgY29uZmlybWVkIHRoYXQgdGhlIGZvbGxvd2luZyBwYXRjaCBzZXQgZGlkIG5vdCBj
aGFuZ2UgdGhlIHRlc3QKPj4+IHJlc3VsdCBvZiBnZW5lcmljLzQ3MCB3aXRoIHRoaW4tdm9sdW1l
LiBCZXNpZGVzLCBJIGRpZG4ndCBzZWUgYW55Cj4+PiBmYWlsdXJlIHdoZW4gcnVubmluZyBnZW5l
cmljLzQ3MCBiYXNlZCBvbiBub3JtYWwgUE1FTSBkZXZpY2UgaW5zdGFlZCBvZgo+Pj4gdGhpbi12
b2x1bWUuCj4+PiBodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC14ZnMvMjAyMTExMjkxMDIy
MDMuMjI0MzUwOS0xLWhjaEBsc3QuZGUvCj4+Pgo+Pj4gMikgSSBjYW4gcmVwcm9kdWNlIHRoZSBm
YWlsdXJlIG9mIGdlbmVyaWMvNDgyIHdpdGhvdXQgdGhpbi12b2x1bWUuCj4+Pgo+Pj4gMykgSXMg
aXQgbmVjZXNzYXJ5IHRvIG1ha2UgdGhpbi12b2x1bWUgc3VwcG9ydCBEQVguIElzIHRoZXJlIGFu
eSB1c2UKPj4+IGNhc2UgZm9yIHRoZSByZXF1aXJlbWVudD8KPj4KPj4KPj4gVGhvdWdoIEkgYXNr
ZWQgb3RoZXIgcGxhY2UoKiksIEkgcmVhbGx5IHdhbnQgdG8ga25vdyB0aGUgdXNlY2FzZSBvZgo+
PiBkbS10aGluLXZvbHVtZSB3aXRoIERBWCBhbmQgcmVmbGluay4KPj4KPj4KPj4gSW4gbXkgdW5k
ZXJzdGFuZGluZywgZG0tdGhpbi12b2x1bWUgc2VlbXMgdG8gcHJvdmlkZSBzaW1pbGFyIGZlYXR1
cmUgbGlrZQo+PiByZWZsaW5rIG9mIHhmcy4gQm90aCBmZWF0dXJlIHByb3ZpZGUgQ09XIHVwZGF0
ZSB0byByZWR1Y2UgdXNhZ2Ugb2YKPj4gaXRzIHJlZ2lvbiwgYW5kIHNuYXBzaG90IGZlYXR1cmUs
IHJpZ2h0Pwo+Pgo+PiBJIGZvdW5kIHRoYXQgZG9ja2VyIHNlZW1zIHRvIHNlbGVjdCBvbmUgb2Yg
dGhlbSAob3Igb3RoZXIgZmVhdHVyZSB3aGljaAo+PiBzdXBwb3J0cyBDT1cpLiBUaGVuIHVzZXIg
ZG9uJ3QgbmVlZCB0byB1c2UgdGhpbi12b2x1bWUgYW5kIHJlZmxpbmsgYXQgc2FtZQo+PiB0aW1l
Lgo+Pgo+PiBEYXRhYmFzZSB3aGljaCB1c2VzIEZTLURBWCBtYXkgd2FudCB0byB1c2Ugc25hcHNo
b3QgZm9yIGl0cyBkYXRhIG9mIEZTLURBWCwKPj4gaXRzIHVzZXIgc2VlbXMgdG8gYmUgc2F0aXNm
aWVkIHdpdGggcmVmbGluayBvciB0aGluLXZvbHVtZS4KPj4KPj4gU28gSSBjb3VsZCBub3QgZmlu
ZCBvbiB3aGF0IHVzZS1jYXNlIHVzZXIgd291bGQgbGlrZSB0byB1c2UgZG0tdGhpbi12b2x1bWUK
Pj4gYW5kIHJlZmxpbmsgYXQgc2FtZSB0aW1lLgo+Pgo+PiBUaGUgb25seSBwb3NzaWJpbGl0eSBp
cyB0aGF0IHRoZSB1c2VyIGhhcyBtaXN0YWtlbmx5IGNvbmZpZ3VyZWQgZG0tdGhpbnBvb2wKPj4g
YW5kIHJlZmxpbmsgdG8gYmUgdXNlZCBhdCB0aGUgc2FtZSB0aW1lLCBidXQgaWYgdGhhdCBpcyB0
aGUgY2FzZSwgaXQgc2VlbXMKPj4gdG8gYmUgYmV0dGVyIGZvciB0aGUgdXNlciB0byBkaXNhYmxl
IG9uZSBvciB0aGUgb3RoZXIuCj4+Cj4+IEkgcmVhbGx5IHdhbmRlciB3aHkgZG0tdGhpbi12b2x1
bWUgbXVzdCBiZSB1c2VkIHdpdGggcmVmbGlrIGFuZCBGUy1EQVguCj4gCj4gVGhlcmUgaXNuJ3Qg
YSBoYXJkIHJlcXVpcmVtZW50IGJldHdlZW4gZnNkYXggYW5kIGRtLXRoaW5wLiAgVGhlIC90ZXN0
Lwo+IG5lZWRzIGRtLWxvZ3dyaXRlcyB0byBjaGVjayB0aGF0IHdyaXRlIHBhZ2UgZmF1bHRzIG9u
IGEgTUFQX1NZTkMKPiBtbWFwcGluZyBhcmUgcGVyc2lzdGVkIGRpcmVjdGx5IHRvIGRpc2suICBk
bS1sb2d3cml0ZXMgcmVxdWlyZXMgYSBmYXN0Cj4gd2F5IHRvIHplcm8gYW4gZW50aXJlIGRldmlj
ZSBmb3IgY29ycmVjdCBvcGVyYXRpb24gb2YgdGhlIHJlcGxheSBzdGVwLAo+IGFuZCB0aGlucCBp
cyB0aGUgb25seSB3YXkgdG8gZ3VhcmFudGVlIHRoYXQuCgpUaGFuayB5b3UgZm9yIHlvdXIgYW5z
d2VyLiBCdXQgSSBzdGlsbCBmZWVsIHNvbWV0aGluZyBpcyBzdHJhbmdlLgpUaG91Z2ggZG0tdGhp
bnAgbWF5IGJlIGdvb2Qgd2F5IHRvIGV4ZWN1dGUgdGhlIHRlc3QgY29ycmVjdGx5LApJIHN1cHBv
c2UgaXQgc2VlbXMgdG8gYmUgbGlrZWx5IGEga2luZCBvZiB3b3JrYXJvdW5kIHRvIHBhc3MgdGhl
IHRlc3QsCml0IG1heSBub3QgYmUgcmVhbGx5IHJlcXVpcmVkIGZvciBhY3R1YWwgdXNlcnMuCgpD
b3VsZCB5b3UgdGVsbCBtZSB3aHkgcGFzc2luZyB0ZXN0IGJ5IHdvcmthcm91bmQgaXMgc28gbmVj
ZXNzYXJ5PwoKVGhhbmtzLAoKCj4gCj4gLS1ECj4gCj4+IElmIG15IHVuZGVyc3RhbmRpbmcgaXMg
c29tZXRoaW5nIHdyb25nLCBwbGVhc2UgY29ycmVjdCBtZS4KPj4KPj4gKCopaHR0cHM6Ly9sb3Jl
Lmtlcm5lbC5vcmcvYWxsL1RZV1BSMDFNQjEwMDgyNThGNDc0Q0EyMjk1QjRDRDNEOUI5MDU0OUBU
WVdQUjAxTUIxMDA4Mi5qcG5wcmQwMS5wcm9kLm91dGxvb2suY29tLwoKLS0KZG0tZGV2ZWwgbWFp
bGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20v
bWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

