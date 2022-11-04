Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF4C3C433FE
	for <dm-devel@archiver.kernel.org>; Fri,  4 Nov 2022 11:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667560236;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=th4ld4P2P1yI3wQZ3CR0HerYbr62p95JAXBoW/P4uh4=;
	b=YsmtXwfCd/HtvQXzfwqdNunwQjBJZhIoK9AvpHm49IxNG/UmTwBylrDk/Tf1UScPR8nLn3
	HLsQ0gO6ni1Ooln2FMqKPqO/yytdcd2zhtR53vtbbMJG3HkvVuiw/OX47riIl8mEViyIso
	t/0gZ+5DyijPtCajq7MNjTUHFiOxZKc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-124-1odfIDPIMl6_9FEME5OHiA-1; Fri, 04 Nov 2022 07:10:33 -0400
X-MC-Unique: 1odfIDPIMl6_9FEME5OHiA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EDD67185A78B;
	Fri,  4 Nov 2022 11:10:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1BAD840C6EE9;
	Fri,  4 Nov 2022 11:10:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D7B101946587;
	Fri,  4 Nov 2022 11:10:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B75FB1946586
 for <dm-devel@listman.corp.redhat.com>; Fri,  4 Nov 2022 11:10:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9BEC249BB60; Fri,  4 Nov 2022 11:10:28 +0000 (UTC)
Received: from [10.43.17.48] (unknown [10.43.17.48])
 by smtp.corp.redhat.com (Postfix) with ESMTP id A403B4A9257;
 Fri,  4 Nov 2022 11:10:27 +0000 (UTC)
Message-ID: <2f0551c6-44f9-0969-cb8f-c12c4fb44eff@redhat.com>
Date: Fri, 4 Nov 2022 12:10:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.0
To: Guoqing Jiang <guoqing.jiang@linux.dev>,
 Heming Zhao <heming.zhao@suse.com>, Mikulas Patocka <mpatocka@redhat.com>,
 Song Liu <song@kernel.org>
References: <alpine.LRH.2.21.2211021214390.25745@file01.intranet.prod.int.rdu2.redhat.com>
 <78646e88-2457-81e1-e3e7-cf66b67ba923@linux.dev>
 <11a466f0-ecfe-c1e2-d967-2d648ce65bcb@suse.com>
 <c31fdd20-c736-5d65-e82e-338e7ed1571c@linux.dev>
From: Zdenek Kabelac <zkabelac@redhat.com>
In-Reply-To: <c31fdd20-c736-5d65-e82e-338e7ed1571c@linux.dev>
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
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

RG5lIDA0LiAxMS4gMjIgdiAyOjIzIEd1b3FpbmcgSmlhbmcgbmFwc2FsKGEpOgo+Cj4KPiBPbiAx
MS8zLzIyIDEwOjQ2IFBNLCBIZW1pbmcgWmhhbyB3cm90ZToKPj4gT24gMTEvMy8yMiAxMTo0NyBB
TSwgR3VvcWluZyBKaWFuZyB3cm90ZToKPj4+IEhpLAo+Pj4KPj4+IE9uIDExLzMvMjIgMTI6Mjcg
QU0sIE1pa3VsYXMgUGF0b2NrYSB3cm90ZToKPj4+PiBIaQo+Pj4+Cj4+Pj4gVGhlcmUncyBhIGNy
YXNoIGluIHRoZSB0ZXN0IHNoZWxsL2x2Y2hhbmdlLXJlYnVpbGQtcmFpZC5zaCB3aGVuIHJ1bm5p
bmcKPj4+PiB0aGUgbHZtIHRlc3RzdWl0ZS4gSXQgY2FuIGJlIHJlcHJvZHVjZWQgYnkgcnVubmlu
ZyAibWFrZSBjaGVja19sb2NhbAo+Pj4+IFQ9c2hlbGwvbHZjaGFuZ2UtcmVidWlsZC1yYWlkLnNo
IiBpbiBhIGxvb3AuCj4+Pgo+Pj4gSSBoYXZlIHByb2JsZW0gdG8gcnVuIHRoZSBjbWQgKG5vdCBz
dXJlIHdoYXQgSSBtaXNzZWQpLCBpdCB3b3VsZCBiZSBiZXR0ZXIgaWYKPj4+IHRoZSByZWxldmFu
dCBjbWRzIGFyZSBleHRyYWN0ZWQgZnJvbSB0aGUgc2NyaXB0IHRoZW4gSSBjYW4gcmVwcm9kdWNl
IGl0IHdpdGgKPj4+IHRob3NlIGNtZHMgZGlyZWN0bHkuCj4+Pgo+Pj4gW3Jvb3RAbG9jYWxob3N0
IGx2bTJdIyBnaXQgbG9nIHwgaGVhZCAtMQo+Pj4gY29tbWl0IDM2YTkyMzkyNmMyYzI3YzFhOGE1
YWMyNjIzODdkMmE0ZDNlNjIwZjgKPj4+IFtyb290QGxvY2FsaG9zdCBsdm0yXSMgbWFrZSBjaGVj
a19sb2NhbCBUPXNoZWxsL2x2Y2hhbmdlLXJlYnVpbGQtcmFpZC5zaAo+Pj4gbWFrZSAtQyBsaWJk
bSBkZXZpY2UtbWFwcGVyCj4+PiBbLi4uXQo+Pj4gbWFrZSAtQyBkYWVtb25zCj4+PiBtYWtlWzFd
OiBOb3RoaW5nIHRvIGJlIGRvbmUgZm9yICdhbGwnLgo+Pj4gbWFrZSAtQyB0ZXN0IGNoZWNrX2xv
Y2FsCj4+PiBWRVJCT1NFPTAgLi9saWIvcnVubmVyIFwKPj4+IMKgwqDCoMKgwqDCoMKgwqAgLS10
ZXN0ZGlyIC4gLS1vdXRkaXIgcmVzdWx0cyBcCj4+PiDCoMKgwqDCoMKgwqDCoMKgIC0tZmxhdm91
cnMgbmRldi12YW5pbGxhIC0tb25seSBzaGVsbC9sdmNoYW5nZS1yZWJ1aWxkLXJhaWQuc2ggCj4+
PiAtLXNraXAgQAo+Pj4gcnVubmluZyAxIHRlc3RzCj4+PiAjIyPCoMKgwqDCoMKgIHJ1bm5pbmc6
IFtuZGV2LXZhbmlsbGFdIHNoZWxsL2x2Y2hhbmdlLXJlYnVpbGQtcmFpZC5zaCAwCj4+PiB8IFsg
MDowMF0gbGliL2luaXR0ZXN0OiBsaW5lIDEzMzogCj4+PiAvdG1wL0xWTVRFU1QzMTc5NDguaUNv
THdtRGhaVy9kZXYvdGVzdG51bGw6IFBlcm1pc3Npb24gZGVuaWVkCj4+PiB8IFsgMDowMF0gRmls
ZXN5c3RlbSBkb2VzIHN1cHBvcnQgZGV2aWNlcyBpbiAKPj4+IC90bXAvTFZNVEVTVDMxNzk0OC5p
Q29Md21EaFpXL2RldiAobW91bnRlZCB3aXRoIG5vZGV2PykKPj4KPj4gSSBkaWRuJ3QgcmVhZCBv
dGhlciBtYWlscyBpbiB0aGlzIHRocmVhZCwgb25seSBmb3IgYWJvdmUgaXNzdWUuCj4+IElmIHlv
dSB1c2Ugb3BlbnN1c2UsIHN5c3RlbWQgc2VydmljZSB0bXAubW91bnQgdXNlcyBub2RldiBvcHRp
b24gdG8gbW91bnQgCj4+IHRtcGZzIG9uIC90bXAuCj4+IEZyb20gbXkgZXhwZXJpZW5jZSwgdGhl
cmUgYXJlIHR3byBtZXRob2RzIHRvIGZpeCh3b3JrIGFyb3VuZCk6Cj4+IDEuIHN5c3RlbWN0bCBk
aXNhYmxlIHRtcC5tb3VudCAmJiBzeXN0ZW1jdGwgbWFzayB0bXAubW91bnQgJiYgcmVib290Cj4+
IDIuIG12IC91c3IvbGliL3N5c3RlbWQvc3lzdGVtL3RtcC5tb3VudCAvcm9vdC8gJiYgcmVib290
Cj4KPiBJIGFtIHVzaW5nIGNlbnRvcyBzaW1pbGFyIHN5c3RlbSwgSSBjYW4gdHJ5IGxlYXAgbGF0
ZXIuIEFwcHJlY2lhdGUgZm9yIHRoZSAKPiB0aXBzLCBIZW1pbmcuCgoKWW91IGNhbiBhbHdheXMg
cmVkaXJlY3QgZGVmYXVsdCAvdG1wIGRpciB0byBzb21lIG90aGVyIHBsYWNlL2ZpbGVzeXN0ZW0g
dGhhdCAKYWxsb3dzIHlvdSB0byBjcmVhdGUgL2RldiBub2Rlcy4gRXZlbnR1YWxseSBmb3IgJ2Jy
YXZlIG1lbifCoCB5b3UgY2FuIGxldCBsdm0yIAp0ZXN0IHN1aXRlIHRvIHBsYXkgZGlyZWN0bHkg
d2l0aCB5b3VyIC9kZXYgZGlyLsKgIE5vcm1hbGx5IG5vdGhpbmcgYmFkIHNob3VsZCAKaGFwcGVu
LCBidXQgd2UgdGVuZCB0byBwcmVmZXIgbW9yZSBjb250cm9sZWQgJy9kZXYnIG1hbmFnZWQgZm9y
IGEgdGVzdC4KCkhlcmUgYXJlIHR3byBlbnZ2YXJzIHRvIHBsYXkgd2l0aDoKCgptYWtlIGNoZWNr
X2xvY2FsIFQ9c2hlbGwvbHZjaGFuZ2UtcmVidWlsZC1yYWlkLnNoIExWTV9URVNUX0RJUj0vbXlo
b21lZnNkaXLCoCAKTFZNX1RFU1RfREVWRElSPS9kZXYKCkxWTV9URVNUX0RJUiBmb3Igc2V0dGlu
ZyBvZiBkaXIgd2hlcmUgdGVzdCBjcmVhdGVzIGFsbCBpdHMgZmlsZXMKCkxWTV9URVNUX0RFVkRJ
UsKgIHlvdSBjYW4gZXhwbGljaXRseSB0ZWxsIHRvIGtlZXAgdXNpbmcgc3lzdGVtJ3MgL2RldsKg
wqAgCihpbnN0ZWFkIG9mIGRpciBjcmVhdGVkIHdpdGhpbiB0bXBkaXIpCgoKUmVnYXJkcwoKClpk
ZW5lawoKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBz
Oi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

