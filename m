Return-Path: <SRS0=fKNG=I5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 611C0C433B4
	for <dm-devel@archiver.kernel.org>; Wed, 31 Mar 2021 13:32:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B4DFA61985
	for <dm-devel@archiver.kernel.org>; Wed, 31 Mar 2021 13:32:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B4DFA61985
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-593-_mZNS6QiPG2R2biKob95HQ-1; Wed, 31 Mar 2021 09:32:33 -0400
X-MC-Unique: _mZNS6QiPG2R2biKob95HQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C2BA108BD11;
	Wed, 31 Mar 2021 13:32:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4E30850DD3;
	Wed, 31 Mar 2021 13:32:26 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2562E1809C83;
	Wed, 31 Mar 2021 13:32:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12V7Q6Us025385 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 31 Mar 2021 03:26:06 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 15EC482899; Wed, 31 Mar 2021 07:26:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0F92F176DC
	for <dm-devel@redhat.com>; Wed, 31 Mar 2021 07:26:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5D3A180A1D5
	for <dm-devel@redhat.com>; Wed, 31 Mar 2021 07:26:01 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-48-tm9LoT2lM3aOxQzeCkEQ5w-1;
	Wed, 31 Mar 2021 03:25:59 -0400
X-MC-Unique: tm9LoT2lM3aOxQzeCkEQ5w-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id AE43DAF42;
	Wed, 31 Mar 2021 07:25:57 +0000 (UTC)
To: Erwin van Londen <erwin@erwinvanlonden.net>,
	Muneendra Kumar M <muneendra.kumar@broadcom.com>,
	Benjamin Block <bblock@linux.ibm.com>
References: <5b87a64d88a13eb8b4917a1cc0d35691f9fc8227.camel@erwinvanlonden.net>
	<YFy1Q6nvJEcRzwyl@t480-pf1aa2c2.linux.ibm.com>
	<b3025c4bf84fe357712fa0fe32bfa3e9@mail.gmail.com>
	<2c6ff107ccf5f0589520ef124cd9ecc4cdcc355e.camel@erwinvanlonden.net>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <8966fcda-b1ca-5d50-398a-13195dab3c44@suse.de>
Date: Wed, 31 Mar 2021 09:25:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <2c6ff107ccf5f0589520ef124cd9ecc4cdcc355e.camel@erwinvanlonden.net>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 12V7Q6Us025385
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 31 Mar 2021 09:32:19 -0400
Cc: dm-devel@redhat.com, Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [dm-devel] dm-multipath - IO queue dispatch based on FPIN
 Congestion/Latency notifications.
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

SGkgRXJ3aW4sCgpPbiAzLzMxLzIxIDI6MjIgQU0sIEVyd2luIHZhbiBMb25kZW4gd3JvdGU6Cj4g
SGVsbG8gTXVuZWVuZHJhLCBiZW5qYW1pbiwKPiAKPiBUaGUgZnBpbiBvcHRpb25zIHRoYXQgYXJl
IGRldmVsb3BlZCBkbyBoYXZlIGEgd2hvbGUgcGxldGhvcmEgb2Ygb3B0aW9ucwo+IGFuZCBkbyBu
b3QgbWFpbmx5IHRyaWdnZXIgcGF0aHMgYmVpbmcgaW4gYSBtYXJnaW5hbCBzdGF0ZS4gVGggbXBp
byBsYXllcgo+IGNvdWxkIHV0aWxpc2UgdGhlIHZhcmlvdXMgdHJpZ2dlcnMgbGlrZSBjb25nZXN0
aW9uIGFuZCBsYXRlbmN5IGFuZCBub3QKPiBqdXN0IHVzZSBhIG1hcmdpbmFsIHN0YXRlIGFzIGEg
ZGVjaXNpdmUgcG9pbnQuIElmIGEgcGF0aCBpcyBzb21ld2hhdAo+IGNvbmdlc3RlZCB0aGUgYW1v
dW50IG9mIGlvJ3MgZGlzcGVyc2VkIG92ZXIgdGhlc2UgcGF0aHMgY291bGQganVzdCBiZQo+IHJl
ZHVjZWQgYnkgYSBmbGV4aWJsZSBtYXJnaW4gZGVwZW5kaW5nIG9uIGhvdyBvZnRlbiBhbmQgd2hp
Y2ggZnBpbnMgYXJlCj4gYWN0dWFsbHkgcmVjZWl2ZWQuIElmIGZvciBpbnN0YW5jZSBhbmQgZnBp
biBpcyByZWNpZXZlZCB0aGF0IGFuIHVwc3RyZWFtCj4gcG9ydCBpcyB0aHJvd2luZyBwaHlzaWNh
bCBlcnJvcnMgeW91IG1heSBleGNsdWRlIGlzIGVudGlyZWx5IGZyb20KPiBxdWV1ZWluZyBJTydz
IHRvIGl0LiBJZiBpdCBpcyBhIGxhdGVuY3kgcmVsYXRlZCBwcm9ibGVtIHdoZXJlIGNyZWRpdAo+
IHNob3J0YWdlcyBjb21lIGluIHBsYXkgeW91IG1heSBqdXN0IG5lZWQgdG8gcXVldWUgdmVyeSBz
bWFsbCBJTydzIHRvIGl0Lgo+IFRoZSBzY3NpIENEQiB3aWxsIHRlbGwgdGhlIHNpemUgb2YgdGhl
IElPLiBDb25nZXN0aW9uIG5vdGlmaWNhdGlvbnMgbWF5Cj4ganVzdCBiZSB1c2VkIGZvciBwb3Rl
bnRpYWxseSBhZGRpbmcgYW4gYXJ0aWZpY2lhbMKgIGRlbGF5IHRvIHJlZHVjZSB0aGUKPiB3b3Jr
bG9hZCBvbiB0aGVzZSBwYXRocyBhbmQgc2NoZWR1bGUgdGhlbSBvbiBhbm90aGVyLgo+IApBcyBj
b3JyZWN0bHkgbm90ZWQsIEZQSU5zIGNvbWUgd2l0aCBhIHZhcmlldHkgb2Ygb3B0aW9ucy4KQW5k
IEknbSBub3QgY2VydGFpbiB3ZSBjYW4gZXZlcnl0aGluZyBjb3JyZWN0bHk7IGEgZGVncmFkZWQg
cGF0aCBpcwpzaW1wbGUsIGJ1dCBmb3IgY29uZ2VzdGlvbiB0aGVyZSBpcyBvbmx5IF9zb18gbXVj
aCB3ZSBjYW4gZG8uClRoZSB0eXBpY2FsIGNhdXNlIGZvciBjb25nZXN0aW9uIGlzLCBzYXksIGEg
MzJHIGhvc3QgcG9ydCB0YWxraW5nIHRvIGEKMTZHIChvciBldmVuIDhHKSB0YXJnZXQgcG9ydCBf
YW5kXyBhIDMyRyB0YXJnZXQgcG9ydC4KClNvIHRoZSBob3N0IGNhbm5vdCAndHVuZSBkb3duJyBp
dCdzIGxpbmsgdG8gOEc7IGRvaW5nIHNvIHdvdWxkIGltcGFjdApwZXJmb3JtYW5jZSBvbiB0aGUg
MzJHIHRhcmdldCBwb3J0LgooQW5kIHdlIHdvdWxkIHN1ZmZlciByZXZlcnNlIGNvbmdlc3Rpb24g
d2hlbmV2ZXIgdGhhdCB0YXJnZXQgcG9ydCBzZW5kcwpmcmFtZXMpLgoKQW5kIHRocm90dGxpbmcg
dGhpbmdzIG9uIHRoZSBTQ1NJIGxheWVyIG9ubHkgaGVscHMgX3NvXyBtdWNoLCBhcyB0aGUKcmVh
bCBjb25nZXN0aW9uIGlzIGR1ZSB0byB0aGUgc3BlZWQgd2l0aCB3aGljaCB0aGUgZnJhbWVzIGFy
ZSBzZXF1ZW5jZWQKb250byB0aGUgd2lyZS4gV2hpY2ggaXMgbm90IHNvbWV0aGluZyB3ZSBmcm9t
IHRoZSBPUyBjYW4gY29udHJvbC4KCj5Gcm9tIGFub3RoZXIgUE9WIHRoaXMgaXMgYXJndWFibHkg
YSBmYWJyaWMgbWlzLWRlc2lnbjsgc28gaXQgX2NvdWxkXyBiZQphbGxldmlhdGVkIGJ5IHNlcGFy
YXRpbmcgb3V0IHRoZSBwb3J0cyB3aXRoIGxvd2VyIHNwZWVkcyBpbnRvIGl0cyBvd24Kem9uZSAo
b3IgZXZlbiBvbiBhIHNlcGFyYXRlIFNBTik7IHRoYXQgd291bGQgdHJpdmlhbGx5IG1ha2UgdGhl
CmNvbmdlc3Rpb24gZ28gYXdheS4KCkJ1dCBmb3IgdGhhdCB0aGUgYWRtaW4gZmlyc3Qgc2hvdWxk
IGJlIF9hbGVydGVkXywgYW5kIHRoaXMgcmVhbGx5IGlzIG15CnByaW1hcnkgZ29hbDogaGF2aW5n
IEZQSU5zIHNob3dpbmcgdXAgaW4gdGhlIG1lc3NhZ2UgbG9nLCB0byBhbGVydCB0aGUKYWRtaW4g
dGhhdCBoaXMgZmFicmljIGlzIG5vdCBwZXJmb3JtaW5nIHdlbGwuCgpBIHNlY29uZCBzdGVwIHdp
bGwgYmUgdG8gbWFzc2FnaW5nIEZQSU5zIGludG8gRE0gbXVsdGlwYXRoLCBhbmQgaGF2ZSBpdApp
bmZsdWVuY2luZyB0aGUgcGF0aCBwcmlvcml0eSBvciBwYXRoIHN0YXR1cy4gQnV0IHRoaXMgaXMg
Y3VycmVudGx5CnVuZGVyIGRpc2N1c3Npb24gaG93IGl0IGNvdWxkIGJlIGludGVncmF0ZWQgYmVz
dC4KCj4gTm90IHJlYWxseSBzdXJlIHdoYXQgdGhlIHBvc3NpYmlsaXRpZXMgYXJlIGZyb20gYSBE
TS1NdWx0aXBhdGgKPiB2aWV3cG9pbnQsIGJ1dCBJIGZlZWwgaWYgdGhlIE9TIG9wdGlvbnMgYXJl
IG5vdCBwcm9wZXJseSBhbGlnbmVkIHdpdGgKPiB3aGF0IHRoZSBGQyBwcm90b2NvbCBhbmQgSEJB
IGRyaXZlcnMgYXJlIGFibGUgdG8gcHJvdmlkZSB3ZSBtYXkgbWlzcyBhCj4gZ29vZCBvcHBvcnR1
bml0eSB0byBvcHRpbWl6ZSB0aGUgZGlzcGVyc2lvbiBvZiBJTydzIGFuZCBpbXByb3ZlIG92ZXJh
bGwKPiBwZXJmb3JtYW5jZS7CoAo+IApMb29raW5nIGF0IHRoZSBzaXplIG9mIHRoZSBjb21tYW5k
cyBpcyBvbmUgcG9zc2liaWxpdHksIGJ1dCBhdCB0aGlzIHRpbWUKdGhpcyBwcmVzdW1lcyB0b28g
bXVjaCBvbiBob3cgd2UgX3RoaW5rXyBGUElOcyB3aWxsIGJlIGdlbmVyYXRlZC4KSSdkIHJhdGhl
ciBkbyBzb21lIG1vcmUgdGVzdHMgdG8gZmlndXJlIG91dCB1bmRlciB3aGljaCBjaXJjdW1zdGFu
Y2VzIHdlCmNhbiBleHBlY3Qgd2hpY2ggdHlwZSBvZiBGUElOcywgYW5kIHRoZW4gc3RhcnQgbG9v
a2luZyBmb3Igd2F5cyBvbiBob3cKdG8gaW50ZWdyYXRlIHRoZW0uCgpDaGVlcnMsCgpIYW5uZXMK
LS0gCkRyLiBIYW5uZXMgUmVpbmVja2UJCSAgICAgICAgICAgS2VybmVsIFN0b3JhZ2UgQXJjaGl0
ZWN0CmhhcmVAc3VzZS5kZQkJCSAgICAgICAgICAgICAgICAgICs0OSA5MTEgNzQwNTMgNjg4ClNV
U0UgU29mdHdhcmUgU29sdXRpb25zIEdlcm1hbnkgR21iSCwgTWF4ZmVsZHN0ci4gNSwgOTA0MDkg
TsO8cm5iZXJnCkhSQiAzNjgwOSAoQUcgTsO8cm5iZXJnKSwgR0Y6IEZlbGl4IEltZW5kw7ZyZmZl
cgoKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8v
bGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=

