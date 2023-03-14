Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 056B0C6FD1F
	for <dm-devel@archiver.kernel.org>; Tue, 14 Mar 2023 20:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678826727;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=5qgEtqYj+3pWn2900gqj5IcCbRIwv1x4t09pP4trHTc=;
	b=UqNMuJJ8tap6BlqiDR1tl3z7LqdB2TSsOqgs3Sk8cWlxpcKdOwvNItUg9SKXzqN9YTM51d
	AFHzAUiHVcMLDLa9xIpoV9h3QBqny2aD8q2T3qFTLENYvxz3mVMd08Afpp0zGi+JqxgGDR
	dcfxXB9HBS8lamno+vP0a67ry8SovS4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-130-VViGxW57M6CQ8dJVSEP5vA-1; Tue, 14 Mar 2023 16:45:24 -0400
X-MC-Unique: VViGxW57M6CQ8dJVSEP5vA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 111F22806041;
	Tue, 14 Mar 2023 20:45:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 13B54C164E7;
	Tue, 14 Mar 2023 20:45:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CE3B819465A2;
	Tue, 14 Mar 2023 20:45:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EF63619465A0
 for <dm-devel@listman.corp.redhat.com>; Tue, 14 Mar 2023 20:45:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DE66751FF; Tue, 14 Mar 2023 20:45:14 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C09A543FBD;
 Tue, 14 Mar 2023 20:45:14 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 32EKjDn8002635;
 Tue, 14 Mar 2023 15:45:13 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 32EKjCCM002634;
 Tue, 14 Mar 2023 15:45:12 -0500
Date: Tue, 14 Mar 2023 15:45:12 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Brian Bunker <brian@purestorage.com>
Message-ID: <20230314204512.GB19878@octiron.msp.redhat.com>
References: <1678229374-18788-1-git-send-email-bmarzins@redhat.com>
 <14a2e53c90802d36259e024f813a21d081321816.camel@googlemail.com>
 <C749E399-67A9-4E89-A81E-D348737AB252@purestorage.com>
MIME-Version: 1.0
In-Reply-To: <C749E399-67A9-4E89-A81E-D348737AB252@purestorage.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH 0/3] handle transitioning devices in TUR
 checker
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
Cc: device-mapper development <dm-devel@redhat.com>, mwilck@googlemail.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gRnJpLCBNYXIgMTAsIDIwMjMgYXQgMTE6NTU6MTlBTSAtMDgwMCwgQnJpYW4gQnVua2VyIHdy
b3RlOgo+ID4gT24gTWFyIDksIDIwMjMsIGF0IDEyOjM4IEFNLCBtd2lsY2tAZ29vZ2xlbWFpbC5j
b20gd3JvdGU6Cj4gPiAKPiA+IEJyaWFuLAo+ID4gCj4gPiBjb3VsZCB5b3UgZ2l2ZSB0aGlzIHBh
dGNoIHNldCBhIHRlc3QgaW4geW91ciBlbnZpcm9ubWVudD8KPiA+IAo+ID4gT24gVHVlLCAyMDIz
LTAzLTA3IGF0IDE2OjQ5IC0wNjAwLCBCZW5qYW1pbiBNYXJ6aW5za2kgd3JvdGU6Cj4gPj4gVGhp
cyBwYXRjaHNldCBpcyBiYXNlZCBvbiBCcmlhbiBCdW5rZXIncyAibGlibXVsdGlwYXRoOiByZXR1
cm4KPiA+PiAnZ2hvc3QnIHN0YXRlIHdoZW4gcG9ydCBpcyBpbiB0cmFuc2l0aW9uIiBwYXRjaDoK
PiA+PiAKPiA+PiBodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9hcmNoaXZlcy9kbS1kZXZlbC8y
MDIzLUZlYnJ1YXJ5LzA1MzM0NC5odG1sCj4gPj4gaHR0cHM6Ly9naXRodWIuY29tL29wZW5zdmMv
bXVsdGlwYXRoLXRvb2xzL3B1bGwvNjAKPiA+PiAKPiA+PiBJbnN0ZWFkIG9mIHNldHRpbmcgdGhl
IHN0YXRlIHRvIFBBVEhfR0hPU1QsIGl0IHVzZXMgUEFUSF9QRU5ESU5HLiBUaGUKPiA+PiBvdGhl
ciB0d28gcGF0Y2hlcyBhcmUgc21hbGwgY2xlYW51cHMgdG8gdGhlIFRVUiBjaGVja2VyIHRoYXQg
SQo+ID4+IG5vdGljZWQKPiA+PiB3aGlsZSB3cml0aW5nIHRoZSBmaXJzdCBwYXRjaC4KPiA+PiAK
PiA+PiBCZW5qYW1pbiBNYXJ6aW5za2kgKDMpOgo+ID4+ICAgbGlibXVsdGlwYXRoOiByZXR1cm4g
J3BlbmRpbmcnIHN0YXRlIHdoZW4gcG9ydCBpcyBpbiB0cmFuc2l0aW9uCj4gPj4gICBsaWJtdWx0
aXBhdGg6IHNldCBpbml0IGZhaWx1cmUgbWVzc2FnZSB3aGVuIGluaXQgZmFpbHMKPiA+PiAgIGxp
Ym11bHRpcGF0aDogcmVzZXQgbnJfdGltZW91dHMgaWYgd2UgZnJlZWQgdGhlIGNvbnRleHQKPiA+
PiAKPiA+PiAgbGlibXVsdGlwYXRoL2NoZWNrZXJzL3R1ci5jIHwgMjQgKysrKysrKysrKysrKysr
KysrKy0tLS0tCj4gPj4gIDEgZmlsZSBjaGFuZ2VkLCAxOSBpbnNlcnRpb25zKCspLCA1IGRlbGV0
aW9ucygtKQo+ID4+IAo+ID4gCj4gPiBJJ2QgbGlrZSB0byB3YWl0IGZvciBCcmlhbidzIHJlc3Vs
dHMuIEZyb20gY29kZSBpbnNwZWN0aW9uLCBhbmQgd2l0aAo+ID4gQmVuJ3MgZXhwbGFuYXRpb24g
Zm9yIHRoZSAzLzMgbG9naWMsCj4gPiAKPiA+IEZvciB0aGUgc2V0Ogo+ID4gUmV2aWV3ZWQtYnk6
IE1hcnRpbiBXaWxjayA8bXdpbGNrQHN1c2UuY29tPgo+IEJlbiBhbmQgTWFydGluLAo+IAo+IFRo
aXMgd29ya3Mgd2VsbCBmb3IgbWUgYWdhaW5zdCBteSBhcnJheS4gQSBjb3VwbGUgb2YgdGhpbmdz
IGluIHRoaXMgcGFydAo+IAo+IENhbiB5b3UgbWFrZSB0aGUgYWJvdmUgbWF0Y2ggeW91ciBmb3Jt
YXR0aW5nIHNpbmNlIGl0IGlzIGJldHRlcjoKPiBpZiggYXNjID09IDB4MDQgJiYgYXNjcSA9PSAw
eDBiKXsKPiAKPiBpZiAoYXNjID09IDB4MDQgJiYgYXNjcSA9PSAweDBhKSB7Cj4gCj4gQW5kIEkg
ZG9u4oCZdCB0aGluayB5b3UgbmVlZCBlbHNlIGlmIHNpbmNlIHRoZSBsaW5lIGFib3ZlIGl0IHJl
dHVybnMgaW4gaXRzCj4gY2FzZSwgc28gZWxzZSBpcyBub3QgaGl0IGlmIHRoZSBmaXJzdCBpZiBp
cyB0cnVlOgo+IAo+ICAgICByZXR1cm4gUEFUSF9HSE9TVDsKPiB9IGVsc2UgaWYgKGFzYyA9PSAw
eDA0ICYmIGFzY3EgPT0gMHgwYSkgewo+IAoKU3VyZS4KCi1CZW4KCj4gVGhhbmtzLAo+IEJyaWFu
Cj4gCj4gCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBz
Oi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

