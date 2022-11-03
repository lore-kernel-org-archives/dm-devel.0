Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD759C43217
	for <dm-devel@archiver.kernel.org>; Thu,  3 Nov 2022 07:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667460870;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=iMXSJ3aHb0FLF1vck5qb+PYlEoFIsRMomfjyUA9T0vA=;
	b=Jv/G+3F/AIspilK82d/YS3YSjSi8dxu2y96oe95CWB0r6uASjkink8MsOMkPgaSZuLj2ob
	PEdQnhVEwv9bjEc+b6QCuDskTRzdokrGbG3Juq3OYVwotw8NE+ER6FSt4PPJTo0X61/col
	9/0koVLjd5uKFC+FTTJokv/fdHC1BCY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-605-WanikVsJN322B-_RVPWb-A-1; Thu, 03 Nov 2022 03:34:28 -0400
X-MC-Unique: WanikVsJN322B-_RVPWb-A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7FEB538164D8;
	Thu,  3 Nov 2022 07:34:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D5D9E40C6EC3;
	Thu,  3 Nov 2022 07:34:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1652A19465A4;
	Thu,  3 Nov 2022 07:34:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 95C8D1946594
 for <dm-devel@listman.corp.redhat.com>; Thu,  3 Nov 2022 07:34:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 358BB40C2140; Thu,  3 Nov 2022 07:34:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2E6C640C83AD
 for <dm-devel@redhat.com>; Thu,  3 Nov 2022 07:34:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 13013857FAB
 for <dm-devel@redhat.com>; Thu,  3 Nov 2022 07:34:20 +0000 (UTC)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-621-RCtgCM7vMzmmZYEr4RzeWA-1; Thu,
 03 Nov 2022 03:34:18 -0400
X-MC-Unique: RCtgCM7vMzmmZYEr4RzeWA-1
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Guoqing Jiang <guoqing.jiang@linux.dev>
To: Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>
References: <alpine.LRH.2.21.2211021214390.25745@file01.intranet.prod.int.rdu2.redhat.com>
 <78646e88-2457-81e1-e3e7-cf66b67ba923@linux.dev>
Message-ID: <ba8e67d8-b18b-13ba-2883-6ca6c6520ef2@linux.dev>
Date: Thu, 3 Nov 2022 15:28:55 +0800
MIME-Version: 1.0
In-Reply-To: <78646e88-2457-81e1-e3e7-cf66b67ba923@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
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

CgpPbiAxMS8zLzIyIDExOjQ3IEFNLCBHdW9xaW5nIEppYW5nIHdyb3RlOgo+PiBbwqDCoCA3OC40
OTE0MjldIDxUQVNLPgo+PiBbwqDCoCA3OC40OTE2NDBdwqAgY2xvbmVfZW5kaW8rMHhmNC8weDFj
MCBbZG1fbW9kXQo+PiBbwqDCoCA3OC40OTIwNzJdwqAgY2xvbmVfZW5kaW8rMHhmNC8weDFjMCBb
ZG1fbW9kXQo+Cj4gVGhlIGNsb25lX2VuZGlvIGJlbG9uZ3MgdG8gImNsb25lIiB0YXJnZXRfdHlw
ZS4KCkhtbSwgY291bGQgYmUgdGhlICJjbG9uZV9lbmRpbyIgZnJvbSBkbS5jIGluc3RlYWQgb2Yg
ZG0tY2xvbmUtdGFyZ2V0LmMuCgo+Cj4+IFvCoMKgIDc4LjQ5MjUwNV0gX19zdWJtaXRfYmlvKzB4
NzYvMHgxMjAKPj4gW8KgwqAgNzguNDkyODU5XcKgIHN1Ym1pdF9iaW9fbm9hY2N0X25vY2hlY2sr
MHhiNi8weDJhMAo+PiBbwqDCoCA3OC40OTMzMjVdwqAgZmx1c2hfZXhwaXJlZF9iaW9zKzB4Mjgv
MHgyZiBbZG1fZGVsYXldCj4KPiBUaGlzIGlzICJkZWxheSIgdGFyZ2V0X3R5cGUuIENvdWxkIHlv
dSBzaGVkIGxpZ2h0IG9uIGhvdyB0aGUgdHdvIHRhcmdldHMKPiBjb25uZWN0IHdpdGggZG0tcmFp
ZD8gQW5kIEkgaGF2ZSBzaGFsbG93IGtub3dsZWRnZSBhYm91dCBkbSAuLi4KPgo+PiBbwqDCoCA3
OC40OTM4MDhdIHByb2Nlc3Nfb25lX3dvcmsrMHgxYjQvMHgzMDAKPj4gW8KgwqAgNzguNDk0MjEx
XcKgIHdvcmtlcl90aHJlYWQrMHg0NS8weDNlMAo+PiBbwqDCoCA3OC40OTQ1NzBdwqAgPyByZXNj
dWVyX3RocmVhZCsweDM4MC8weDM4MAo+PiBbwqDCoCA3OC40OTQ5NTddwqAga3RocmVhZCsweGMy
LzB4MTAwCj4+IFvCoMKgIDc4LjQ5NTI3OV3CoCA/IGt0aHJlYWRfY29tcGxldGVfYW5kX2V4aXQr
MHgyMC8weDIwCj4+IFvCoMKgIDc4LjQ5NTc0M13CoCByZXRfZnJvbV9mb3JrKzB4MWYvMHgzMAo+
PiBbwqDCoCA3OC40OTYwOTZdwqAgPC9UQVNLPgo+PiBbwqDCoCA3OC40OTYzMjZdIE1vZHVsZXMg
bGlua2VkIGluOiBicmQgZG1fZGVsYXkgZG1fcmFpZCBkbV9tb2QgCj4+IGFmX3BhY2tldCB1dmVz
YWZiIGNmYmZpbGxyZWN0IGNmYmltZ2JsdCBjbiBjZmJjb3B5YXJlYSBmYiBmb250IGZiZGV2IAo+
PiB0dW4gYXV0b2ZzNCBiaW5mbXRfbWlzYyBjb25maWdmcyBpcHY2IHZpcnRpb19ybmcgdmlydGlv
X2JhbGxvb24gCj4+IHJuZ19jb3JlIHZpcnRpb19uZXQgcGNzcGtyIG5ldF9mYWlsb3ZlciBmYWls
b3ZlciBxZW11X2Z3X2NmZyBidXR0b24gCj4+IG1vdXNlZGV2IHJhaWQxMCByYWlkNDU2IGxpYmNy
YzMyYyBhc3luY19yYWlkNl9yZWNvdiBhc3luY19tZW1jcHkgCj4+IGFzeW5jX3BxIHJhaWQ2X3Bx
IGFzeW5jX3hvciB4b3IgYXN5bmNfdHggcmFpZDEgcmFpZDAgbWRfbW9kIHNkX21vZCAKPj4gdDEw
X3BpIGNyYzY0X3JvY2tzb2Z0IGNyYzY0IHZpcnRpb19zY3NpIHNjc2lfbW9kIGV2ZGV2IHBzbW91
c2UgYnNnIAo+PiBzY3NpX2NvbW1vbiBbbGFzdCB1bmxvYWRlZDogYnJkXQo+PiBbwqDCoCA3OC41
MDA0MjVdIENSMjogMDAwMDAwMDAwMDAwMDAwMAo+PiBbwqDCoCA3OC41MDA3NTJdIC0tLVsgZW5k
IHRyYWNlIDAwMDAwMDAwMDAwMDAwMDAgXS0tLQo+PiBbwqDCoCA3OC41MDEyMTRdIFJJUDogMDAx
MDptZW1wb29sX2ZyZWUrMHg0Ny8weDgwCj4KPiBCVFcsIGlzIHRoZSBtZW1wb29sX2ZyZWUgZnJv
bSBlbmRpbyAtPiBkZWNfY291bnQgLT4gY29tcGxldGVfaW8/CgpJIGd1ZXNzIGl0IGlzICJtZW1w
b29sX2ZyZWUoaW8sICZpby0+Y2xpZW50LT5wb29sKSIsIGFuZCB0aGUgcG9vbCBpcyAKZnJlZWQg
YnkKZG1faW9fY2xpZW50X2Rlc3Ryb3ksIGFuZCBzZWVtcyBkbS1yYWlkIGlzIG5vdCByZXNwb25z
aWJsZSBmb3IgZWl0aGVyIGNyZWF0ZQpwb29sIG9yIGRlc3Ryb3kgcG9vbC4KCj4gQW5kIGlvIHdo
aWNoIGNhdXNlZCB0aGUgY3Jhc2ggaXMgZnJvbSBkbV9pbyAtPiBhc3luY19pbyAvIHN5bmNfaW8K
PiDCoC0+IGRpc3BhdGNoX2lvLCBzZWVtcyBkbS1yYWlkMSBjYW4gY2FsbCBpdCBpbnN0ZWFkIG9m
IGRtLXJhaWQsIHNvIEkKPiBzdXBwb3NlIHRoZSBpbyBpcyBmb3IgbWlycm9yIGltYWdlLiAKClRo
ZSBpbyBzaG91bGQgYmUgZnJvbSBhbm90aGVyIHBhdGggKGRtX3N1Ym1pdF9iaW8gLT4gCmRtX3Nw
bGl0X2FuZF9wcm9jZXNzX2JpbwotPiBfX3NwbGl0X2FuZF9wcm9jZXNzX2JpbyAtPiBfX21hcF9i
aW8gd2hpY2ggc2V0cyAiYmlfZW5kX2lvID0gCmNsb25lX2VuZGlvIikuCgpNeSBndWVzcyBpcywg
dGhlcmUgaXMgcmFjeSBjb25kaXRpb24gYmV0d2VlbiAibHZjaGFuZ2UgLS1yZWJ1aWxkIiBhbmQg
CnJhaWRfZHRyIHNpbmNlCml0IHdhcyByZXByb2R1Y2VkIGJ5IHJ1bm5pbmcgY21kIGluIGxvb3Au
CgpBbnl3YXksIHdlIGNhbiByZXZlcnQgdGhlIG1lbnRpb25lZCBjb21taXQgYW5kIGdvIGJhY2sg
dG8gTmVpbCdzIApzb2x1dGlvbiBbMV0sCmJ1dCBJJ2QgbGlrZSB0byByZXByb2R1Y2UgaXQgYW5k
IGxlYXJuIERNIGEgYml0LgoKWzFdLiAKaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtcmFp
ZC9hNjY1N2UwOC1iNmE3LTM1OGItMmQyYS0wYWMzN2Q0OWQyM2FAbGludXguZGV2L1QvI205NWFj
MjI1Y2FiNzQwOWY2NmMyOTU3NzI0ODNkMDkxMDg0YTZkNDcwCgpUaGFua3MsCkd1b3FpbmcKCi0t
CmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1h
bi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

