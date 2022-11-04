Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B0E7C433FE
	for <dm-devel@archiver.kernel.org>; Fri,  4 Nov 2022 01:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667525035;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=OSsqH/BXPPDOoo2UXUtyl2uDlCKWdRBxZAQ8BG6EU10=;
	b=OIR8rWn7E2aae4zUKLtB+Yp1sRVj8/xr6xOrbCBFaKtNi/SeBYc8fJjjOEA5KMqXXhhF0D
	KDjkS0uOV69ZLm3J3nSlf22IuAdgvYUaOcgB5fWfHPf5Oz1YdKCHISW3P8cgVyd8WT7vOg
	2fEbkgUa3ye+M1Ujn7tCwalwIkvThv8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-608-szGTURbNM9y9M-p79BbpHA-1; Thu, 03 Nov 2022 21:23:52 -0400
X-MC-Unique: szGTURbNM9y9M-p79BbpHA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B80B7101A52A;
	Fri,  4 Nov 2022 01:23:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B91F340C6EE9;
	Fri,  4 Nov 2022 01:23:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 905701946597;
	Fri,  4 Nov 2022 01:23:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D51041946594
 for <dm-devel@listman.corp.redhat.com>; Fri,  4 Nov 2022 01:23:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B87E8401D45; Fri,  4 Nov 2022 01:23:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AF99D49BB60
 for <dm-devel@redhat.com>; Fri,  4 Nov 2022 01:23:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8FD7B185A78B
 for <dm-devel@redhat.com>; Fri,  4 Nov 2022 01:23:47 +0000 (UTC)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-613-X5evJaJlOIG7UFg2iVxNPw-1; Thu,
 03 Nov 2022 21:23:45 -0400
X-MC-Unique: X5evJaJlOIG7UFg2iVxNPw-1
To: Heming Zhao <heming.zhao@suse.com>, Mikulas Patocka
 <mpatocka@redhat.com>, Song Liu <song@kernel.org>
References: <alpine.LRH.2.21.2211021214390.25745@file01.intranet.prod.int.rdu2.redhat.com>
 <78646e88-2457-81e1-e3e7-cf66b67ba923@linux.dev>
 <11a466f0-ecfe-c1e2-d967-2d648ce65bcb@suse.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <c31fdd20-c736-5d65-e82e-338e7ed1571c@linux.dev>
Date: Fri, 4 Nov 2022 09:23:40 +0800
MIME-Version: 1.0
In-Reply-To: <11a466f0-ecfe-c1e2-d967-2d648ce65bcb@suse.com>
X-Migadu-Flow: FLOW_OUT
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] A crash caused by the commit
 0dd84b319352bb8ba64752d4e45396d8b13e6018
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
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com,
 Zdenek Kabelac <zkabelac@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

CgpPbiAxMS8zLzIyIDEwOjQ2IFBNLCBIZW1pbmcgWmhhbyB3cm90ZToKPiBPbiAxMS8zLzIyIDEx
OjQ3IEFNLCBHdW9xaW5nIEppYW5nIHdyb3RlOgo+PiBIaSwKPj4KPj4gT24gMTEvMy8yMiAxMjoy
NyBBTSwgTWlrdWxhcyBQYXRvY2thIHdyb3RlOgo+Pj4gSGkKPj4+Cj4+PiBUaGVyZSdzIGEgY3Jh
c2ggaW4gdGhlIHRlc3Qgc2hlbGwvbHZjaGFuZ2UtcmVidWlsZC1yYWlkLnNoIHdoZW4gcnVubmlu
Zwo+Pj4gdGhlIGx2bSB0ZXN0c3VpdGUuIEl0IGNhbiBiZSByZXByb2R1Y2VkIGJ5IHJ1bm5pbmcg
Im1ha2UgY2hlY2tfbG9jYWwKPj4+IFQ9c2hlbGwvbHZjaGFuZ2UtcmVidWlsZC1yYWlkLnNoIiBp
biBhIGxvb3AuCj4+Cj4+IEkgaGF2ZSBwcm9ibGVtIHRvIHJ1biB0aGUgY21kIChub3Qgc3VyZSB3
aGF0IEkgbWlzc2VkKSwgaXQgd291bGQgYmUgCj4+IGJldHRlciBpZgo+PiB0aGUgcmVsZXZhbnQg
Y21kcyBhcmUgZXh0cmFjdGVkIGZyb20gdGhlIHNjcmlwdCB0aGVuIEkgY2FuIHJlcHJvZHVjZSAK
Pj4gaXQgd2l0aAo+PiB0aG9zZSBjbWRzIGRpcmVjdGx5Lgo+Pgo+PiBbcm9vdEBsb2NhbGhvc3Qg
bHZtMl0jIGdpdCBsb2cgfCBoZWFkIC0xCj4+IGNvbW1pdCAzNmE5MjM5MjZjMmMyN2MxYThhNWFj
MjYyMzg3ZDJhNGQzZTYyMGY4Cj4+IFtyb290QGxvY2FsaG9zdCBsdm0yXSMgbWFrZSBjaGVja19s
b2NhbCBUPXNoZWxsL2x2Y2hhbmdlLXJlYnVpbGQtcmFpZC5zaAo+PiBtYWtlIC1DIGxpYmRtIGRl
dmljZS1tYXBwZXIKPj4gWy4uLl0KPj4gbWFrZSAtQyBkYWVtb25zCj4+IG1ha2VbMV06IE5vdGhp
bmcgdG8gYmUgZG9uZSBmb3IgJ2FsbCcuCj4+IG1ha2UgLUMgdGVzdCBjaGVja19sb2NhbAo+PiBW
RVJCT1NFPTAgLi9saWIvcnVubmVyIFwKPj4gwqDCoMKgwqDCoMKgwqDCoCAtLXRlc3RkaXIgLiAt
LW91dGRpciByZXN1bHRzIFwKPj4gwqDCoMKgwqDCoMKgwqDCoCAtLWZsYXZvdXJzIG5kZXYtdmFu
aWxsYSAtLW9ubHkgCj4+IHNoZWxsL2x2Y2hhbmdlLXJlYnVpbGQtcmFpZC5zaCAtLXNraXAgQAo+
PiBydW5uaW5nIDEgdGVzdHMKPj4gIyMjwqDCoMKgwqDCoCBydW5uaW5nOiBbbmRldi12YW5pbGxh
XSBzaGVsbC9sdmNoYW5nZS1yZWJ1aWxkLXJhaWQuc2ggMAo+PiB8IFsgMDowMF0gbGliL2luaXR0
ZXN0OiBsaW5lIDEzMzogCj4+IC90bXAvTFZNVEVTVDMxNzk0OC5pQ29Md21EaFpXL2Rldi90ZXN0
bnVsbDogUGVybWlzc2lvbiBkZW5pZWQKPj4gfCBbIDA6MDBdIEZpbGVzeXN0ZW0gZG9lcyBzdXBw
b3J0IGRldmljZXMgaW4gCj4+IC90bXAvTFZNVEVTVDMxNzk0OC5pQ29Md21EaFpXL2RldiAobW91
bnRlZCB3aXRoIG5vZGV2PykKPgo+IEkgZGlkbid0IHJlYWQgb3RoZXIgbWFpbHMgaW4gdGhpcyB0
aHJlYWQsIG9ubHkgZm9yIGFib3ZlIGlzc3VlLgo+IElmIHlvdSB1c2Ugb3BlbnN1c2UsIHN5c3Rl
bWQgc2VydmljZSB0bXAubW91bnQgdXNlcyBub2RldiBvcHRpb24gdG8gCj4gbW91bnQgdG1wZnMg
b24gL3RtcC4KPiBGcm9tIG15IGV4cGVyaWVuY2UsIHRoZXJlIGFyZSB0d28gbWV0aG9kcyB0byBm
aXgod29yayBhcm91bmQpOgo+IDEuIHN5c3RlbWN0bCBkaXNhYmxlIHRtcC5tb3VudCAmJiBzeXN0
ZW1jdGwgbWFzayB0bXAubW91bnQgJiYgcmVib290Cj4gMi4gbXYgL3Vzci9saWIvc3lzdGVtZC9z
eXN0ZW0vdG1wLm1vdW50IC9yb290LyAmJiByZWJvb3QKCkkgYW0gdXNpbmcgY2VudG9zIHNpbWls
YXIgc3lzdGVtLCBJIGNhbiB0cnkgbGVhcCBsYXRlci4gQXBwcmVjaWF0ZSBmb3IgCnRoZSB0aXBz
LCBIZW1pbmcuCgpUaGFua3MsCkd1b3FpbmcKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1k
ZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGlu
Zm8vZG0tZGV2ZWwK

