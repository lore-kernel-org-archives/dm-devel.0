Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24C0AC4332F
	for <dm-devel@archiver.kernel.org>; Mon,  7 Nov 2022 01:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667785987;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=X9rKuEmfUmevHEddNmvrYVUp6TtggNViWDpQB7EYg2Y=;
	b=BSeb19JcsXmXwP5RIzIFDu7MQXPLHVaPkt1rXj+U3+YZPZ0VyXodUEbn4wTbFQq2gTb8oR
	f0g27SqCySOPaRz/5fd6oasbSKJHG96WhfGgpEz5d/tZRVlacWjiPTYPu7GT8+eVwcHeCW
	0Qf2Gn8TNa2TJSlC8dMzW62KDxAw6ZA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-13-t6gpY53ePZucKmxwDYj4Fg-1; Sun, 06 Nov 2022 20:53:03 -0500
X-MC-Unique: t6gpY53ePZucKmxwDYj4Fg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C9989185A78F;
	Mon,  7 Nov 2022 01:53:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B0A6047505F;
	Mon,  7 Nov 2022 01:52:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 971121946588;
	Mon,  7 Nov 2022 01:52:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A4E641946587
 for <dm-devel@listman.corp.redhat.com>; Mon,  7 Nov 2022 01:52:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C2661C15BB3; Mon,  7 Nov 2022 01:52:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BB2D7C15BA4
 for <dm-devel@redhat.com>; Mon,  7 Nov 2022 01:52:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A1040101A56C
 for <dm-devel@redhat.com>; Mon,  7 Nov 2022 01:52:52 +0000 (UTC)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-210-oU3QDI2-M0-dt0slpn5PTw-1; Sun,
 06 Nov 2022 20:52:50 -0500
X-MC-Unique: oU3QDI2-M0-dt0slpn5PTw-1
To: Zdenek Kabelac <zkabelac@redhat.com>, Heming Zhao <heming.zhao@suse.com>, 
 Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>
References: <alpine.LRH.2.21.2211021214390.25745@file01.intranet.prod.int.rdu2.redhat.com>
 <78646e88-2457-81e1-e3e7-cf66b67ba923@linux.dev>
 <11a466f0-ecfe-c1e2-d967-2d648ce65bcb@suse.com>
 <c31fdd20-c736-5d65-e82e-338e7ed1571c@linux.dev>
 <2f0551c6-44f9-0969-cb8f-c12c4fb44eff@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <57672478-63f3-d214-a2fc-ef06c4200e90@linux.dev>
Date: Mon, 7 Nov 2022 09:52:45 +0800
MIME-Version: 1.0
In-Reply-To: <2f0551c6-44f9-0969-cb8f-c12c4fb44eff@redhat.com>
X-Migadu-Flow: FLOW_OUT
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

CgpPbiAxMS80LzIyIDc6MTAgUE0sIFpkZW5layBLYWJlbGFjIHdyb3RlOgo+IERuZSAwNC4gMTEu
IDIyIHYgMjoyMyBHdW9xaW5nIEppYW5nIG5hcHNhbChhKToKPj4KPj4KPj4gT24gMTEvMy8yMiAx
MDo0NiBQTSwgSGVtaW5nIFpoYW8gd3JvdGU6Cj4+PiBPbiAxMS8zLzIyIDExOjQ3IEFNLCBHdW9x
aW5nIEppYW5nIHdyb3RlOgo+Pj4+IEhpLAo+Pj4+Cj4+Pj4gT24gMTEvMy8yMiAxMjoyNyBBTSwg
TWlrdWxhcyBQYXRvY2thIHdyb3RlOgo+Pj4+PiBIaQo+Pj4+Pgo+Pj4+PiBUaGVyZSdzIGEgY3Jh
c2ggaW4gdGhlIHRlc3Qgc2hlbGwvbHZjaGFuZ2UtcmVidWlsZC1yYWlkLnNoIHdoZW4gCj4+Pj4+
IHJ1bm5pbmcKPj4+Pj4gdGhlIGx2bSB0ZXN0c3VpdGUuIEl0IGNhbiBiZSByZXByb2R1Y2VkIGJ5
IHJ1bm5pbmcgIm1ha2UgY2hlY2tfbG9jYWwKPj4+Pj4gVD1zaGVsbC9sdmNoYW5nZS1yZWJ1aWxk
LXJhaWQuc2giIGluIGEgbG9vcC4KPj4+Pgo+Pj4+IEkgaGF2ZSBwcm9ibGVtIHRvIHJ1biB0aGUg
Y21kIChub3Qgc3VyZSB3aGF0IEkgbWlzc2VkKSwgaXQgd291bGQgYmUgCj4+Pj4gYmV0dGVyIGlm
Cj4+Pj4gdGhlIHJlbGV2YW50IGNtZHMgYXJlIGV4dHJhY3RlZCBmcm9tIHRoZSBzY3JpcHQgdGhl
biBJIGNhbiAKPj4+PiByZXByb2R1Y2UgaXQgd2l0aAo+Pj4+IHRob3NlIGNtZHMgZGlyZWN0bHku
Cj4+Pj4KPj4+PiBbcm9vdEBsb2NhbGhvc3QgbHZtMl0jIGdpdCBsb2cgfCBoZWFkIC0xCj4+Pj4g
Y29tbWl0IDM2YTkyMzkyNmMyYzI3YzFhOGE1YWMyNjIzODdkMmE0ZDNlNjIwZjgKPj4+PiBbcm9v
dEBsb2NhbGhvc3QgbHZtMl0jIG1ha2UgY2hlY2tfbG9jYWwgCj4+Pj4gVD1zaGVsbC9sdmNoYW5n
ZS1yZWJ1aWxkLXJhaWQuc2gKPj4+PiBtYWtlIC1DIGxpYmRtIGRldmljZS1tYXBwZXIKPj4+PiBb
Li4uXQo+Pj4+IG1ha2UgLUMgZGFlbW9ucwo+Pj4+IG1ha2VbMV06IE5vdGhpbmcgdG8gYmUgZG9u
ZSBmb3IgJ2FsbCcuCj4+Pj4gbWFrZSAtQyB0ZXN0IGNoZWNrX2xvY2FsCj4+Pj4gVkVSQk9TRT0w
IC4vbGliL3J1bm5lciBcCj4+Pj4gwqDCoMKgwqDCoMKgwqDCoCAtLXRlc3RkaXIgLiAtLW91dGRp
ciByZXN1bHRzIFwKPj4+PiDCoMKgwqDCoMKgwqDCoMKgIC0tZmxhdm91cnMgbmRldi12YW5pbGxh
IC0tb25seSAKPj4+PiBzaGVsbC9sdmNoYW5nZS1yZWJ1aWxkLXJhaWQuc2ggLS1za2lwIEAKPj4+
PiBydW5uaW5nIDEgdGVzdHMKPj4+PiAjIyPCoMKgwqDCoMKgIHJ1bm5pbmc6IFtuZGV2LXZhbmls
bGFdIHNoZWxsL2x2Y2hhbmdlLXJlYnVpbGQtcmFpZC5zaCAwCj4+Pj4gfCBbIDA6MDBdIGxpYi9p
bml0dGVzdDogbGluZSAxMzM6IAo+Pj4+IC90bXAvTFZNVEVTVDMxNzk0OC5pQ29Md21EaFpXL2Rl
di90ZXN0bnVsbDogUGVybWlzc2lvbiBkZW5pZWQKPj4+PiB8IFsgMDowMF0gRmlsZXN5c3RlbSBk
b2VzIHN1cHBvcnQgZGV2aWNlcyBpbiAKPj4+PiAvdG1wL0xWTVRFU1QzMTc5NDguaUNvTHdtRGha
Vy9kZXYgKG1vdW50ZWQgd2l0aCBub2Rldj8pCj4+Pgo+Pj4gSSBkaWRuJ3QgcmVhZCBvdGhlciBt
YWlscyBpbiB0aGlzIHRocmVhZCwgb25seSBmb3IgYWJvdmUgaXNzdWUuCj4+PiBJZiB5b3UgdXNl
IG9wZW5zdXNlLCBzeXN0ZW1kIHNlcnZpY2UgdG1wLm1vdW50IHVzZXMgbm9kZXYgb3B0aW9uIHRv
IAo+Pj4gbW91bnQgdG1wZnMgb24gL3RtcC4KPj4+IEZyb20gbXkgZXhwZXJpZW5jZSwgdGhlcmUg
YXJlIHR3byBtZXRob2RzIHRvIGZpeCh3b3JrIGFyb3VuZCk6Cj4+PiAxLiBzeXN0ZW1jdGwgZGlz
YWJsZSB0bXAubW91bnQgJiYgc3lzdGVtY3RsIG1hc2sgdG1wLm1vdW50ICYmIHJlYm9vdAo+Pj4g
Mi4gbXYgL3Vzci9saWIvc3lzdGVtZC9zeXN0ZW0vdG1wLm1vdW50IC9yb290LyAmJiByZWJvb3QK
Pj4KPj4gSSBhbSB1c2luZyBjZW50b3Mgc2ltaWxhciBzeXN0ZW0sIEkgY2FuIHRyeSBsZWFwIGxh
dGVyLiBBcHByZWNpYXRlIAo+PiBmb3IgdGhlIHRpcHMsIEhlbWluZy4KPgo+Cj4gWW91IGNhbiBh
bHdheXMgcmVkaXJlY3QgZGVmYXVsdCAvdG1wIGRpciB0byBzb21lIG90aGVyIAo+IHBsYWNlL2Zp
bGVzeXN0ZW0gdGhhdCBhbGxvd3MgeW91IHRvIGNyZWF0ZSAvZGV2IG5vZGVzLiBFdmVudHVhbGx5
IGZvciAKPiAnYnJhdmUgbWVuJ8KgIHlvdSBjYW4gbGV0IGx2bTIgdGVzdCBzdWl0ZSB0byBwbGF5
IGRpcmVjdGx5IHdpdGggeW91ciAKPiAvZGV2IGRpci7CoCBOb3JtYWxseSBub3RoaW5nIGJhZCBz
aG91bGQgaGFwcGVuLCBidXQgd2UgdGVuZCB0byBwcmVmZXIgCj4gbW9yZSBjb250cm9sZWQgJy9k
ZXYnIG1hbmFnZWQgZm9yIGEgdGVzdC4KPgo+IEhlcmUgYXJlIHR3byBlbnZ2YXJzIHRvIHBsYXkg
d2l0aDoKPgo+Cj4gbWFrZSBjaGVja19sb2NhbCBUPXNoZWxsL2x2Y2hhbmdlLXJlYnVpbGQtcmFp
ZC5zaCAKPiBMVk1fVEVTVF9ESVI9L215aG9tZWZzZGlywqAgTFZNX1RFU1RfREVWRElSPS9kZXYK
Pgo+IExWTV9URVNUX0RJUiBmb3Igc2V0dGluZyBvZiBkaXIgd2hlcmUgdGVzdCBjcmVhdGVzIGFs
bCBpdHMgZmlsZXMKPgo+IExWTV9URVNUX0RFVkRJUsKgIHlvdSBjYW4gZXhwbGljaXRseSB0ZWxs
IHRvIGtlZXAgdXNpbmcgc3lzdGVtJ3MgL2RldsKgwqAgCj4gKGluc3RlYWQgb2YgZGlyIGNyZWF0
ZWQgd2l0aGluIHRtcGRpcikKClRoYW5rIHlvdSEgVGhpcyB3b3JrcyBmb3IgbWUuCgpbcm9vdEBs
b2NhbGhvc3QgbHZtMl0jIG1ha2UgY2hlY2tfbG9jYWwgVD1zaGVsbC9sdmNoYW5nZS1yZWJ1aWxk
LXJhaWQuc2ggCkxWTV9URVNUX0RJUj0vcm9vdC90ZXN0IExWTV9URVNUX0RFVkRJUj0vZGV2Cm1h
a2UgLUMgbGliZG0gZGV2aWNlLW1hcHBlcgptYWtlWzFdOiBOb3RoaW5nIHRvIGJlIGRvbmUgZm9y
ICdkZXZpY2UtbWFwcGVyJy4KClsuLi4gXQoKbWFrZSAtQyB0ZXN0IGNoZWNrX2xvY2FsClZFUkJP
U0U9MCAuL2xpYi9ydW5uZXIgXAogwqDCoMKgwqDCoMKgwqAgLS10ZXN0ZGlyIC4gLS1vdXRkaXIg
cmVzdWx0cyBcCiDCoMKgwqDCoMKgwqDCoCAtLWZsYXZvdXJzIG5kZXYtdmFuaWxsYSAtLW9ubHkg
c2hlbGwvbHZjaGFuZ2UtcmVidWlsZC1yYWlkLnNoIAotLXNraXAgQApydW5uaW5nIDEgdGVzdHMK
IyMjwqDCoMKgwqDCoMKgIHBhc3NlZDogW25kZXYtdmFuaWxsYV0gc2hlbGwvbHZjaGFuZ2UtcmVi
dWlsZC1yYWlkLnNoIDIwCgojIyMgMSB0ZXN0czogMSBwYXNzZWQsIDAgc2tpcHBlZCwgMCB0aW1l
ZCBvdXQsIDAgd2FybmVkLCAwIGZhaWxlZAoKVGhhbmtzLApHdW9xaW5nCgotLQpkbS1kZXZlbCBt
YWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNv
bS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

