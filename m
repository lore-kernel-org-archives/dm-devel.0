Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB6DDC7EE43
	for <dm-devel@archiver.kernel.org>; Thu, 25 May 2023 07:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684998758;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Ba+CCv9j4B9mpdDc4Rjszu+s5nkzTdIyqByKZ6XEZbg=;
	b=Urue+uHblsdtgK0ZA+iesciT3Kdo2hAV5emcGelSs4swwMdOB0A+TJeAvV8Q9fnMpvV+iA
	7vq/mhtgmKZgBiDRZFNRbQ5gHNbEBOIpQMhdZm79gwI4XOoRFpCGsSyZRovsjxRQi/sNE2
	njgGq7N114q1of6kwqpWd3kI1JvRwtI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-10-neUdz7y6O66Z8vt1yw0IJg-1; Thu, 25 May 2023 03:12:35 -0400
X-MC-Unique: neUdz7y6O66Z8vt1yw0IJg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B2C3E801224;
	Thu, 25 May 2023 07:12:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A29951121315;
	Thu, 25 May 2023 07:12:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 991BA19465A8;
	Thu, 25 May 2023 07:12:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C7B0319465A0
 for <dm-devel@listman.corp.redhat.com>; Wed, 24 May 2023 06:43:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A7B81492B0B; Wed, 24 May 2023 06:43:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A0859492B0A
 for <dm-devel@redhat.com>; Wed, 24 May 2023 06:43:43 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 83015803CB4
 for <dm-devel@redhat.com>; Wed, 24 May 2023 06:43:43 +0000 (UTC)
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-145-22vmto-1OLG8vQTCBpkgCA-1; Wed, 24 May 2023 02:43:41 -0400
X-MC-Unique: 22vmto-1OLG8vQTCBpkgCA-1
Received: by mail-il1-f200.google.com with SMTP id
 e9e14a558f8ab-3382e29ab5bso3150035ab.0
 for <dm-devel@redhat.com>; Tue, 23 May 2023 23:43:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1684910620; x=1687502620;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=mAf4XjOaef4P+4MQgCAxHVADzrgzQEnmBFIEaQXIdMU=;
 b=Cduc9VzGm9gk1c67V6RexXa5cu41J6ODBbTUeauZz3PZoJ9Z8NzMNVLXC47+OyTMLn
 StOiwMX4ngmHURb8TcfBs85qwN42aNwJ0HxTezyLfZrU9TU9eKR0RqC2tSNXlnp3oSTB
 Z2EtLENrc5ewkG0OFObcu+egW1vA7oNvoyWYDmETCrjYqnDPdLxX26gB4xyTvT1yBmbY
 ql1TInh5K8d26O9og54e3gD+S9MBuDuT3TmIIxEu9+rSOKlQOfYoj0hynCWKHTyvwTyy
 cAdq6adpDMRzzZwygWXSPQ3aBgRY540VHFMt3YP6087Qza4EEeLKfhlhicMWDNxTOWEB
 Ko4Q==
X-Gm-Message-State: AC+VfDxJprl+2qxcx5EBKpjkY+t7ksmLZREJ32zANvNAGMCBbZcBj4Gz
 B4AhkuRZ/0whhnShGmxKOz8eBjCzIwjmdLq1zEg7kqNqxAK6q2xb5v07ri5VYAwI2bRA66lTrYU
 cjzwrCYOWesHPVf/ykzfshpCFPEjseNQ=
X-Received: by 2002:a92:d24a:0:b0:334:309a:2492 with SMTP id
 v10-20020a92d24a000000b00334309a2492mr11059502ilg.20.1684910620249; 
 Tue, 23 May 2023 23:43:40 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4gisdUFPTBh/gvzouw9Kn7wkeIB7YdSvtLl57t9HrQvgU2mTukFJo4qMdPjHfxXLpJMrEpeEdKGGs2Hs9o6rw=
X-Received: by 2002:a92:d24a:0:b0:334:309a:2492 with SMTP id
 v10-20020a92d24a000000b00334309a2492mr11059497ilg.20.1684910619996; Tue, 23
 May 2023 23:43:39 -0700 (PDT)
MIME-Version: 1.0
References: <9505927dabc3b6695d62dfe1be371b12f5bdebf7.1684491648.git.durui@linux.alibaba.com>
 <ZGz32yw7ecKhW+lj@redhat.com>
In-Reply-To: <ZGz32yw7ecKhW+lj@redhat.com>
From: Alexander Larsson <alexl@redhat.com>
Date: Wed, 24 May 2023 08:43:29 +0200
Message-ID: <CAL7ro1FPEqXyOuX_WPMYdsT6rW-bD5EU=v=oWKsd6XscykLF6Q@mail.gmail.com>
To: Mike Snitzer <snitzer@kernel.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Thu, 25 May 2023 07:12:27 +0000
Subject: Re: [dm-devel] dm overlaybd: targets mapping OverlayBD image
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
Cc: Du Rui <durui@linux.alibaba.com>, dm-devel@redhat.com,
 linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>,
 Giuseppe Scrivano <gscrivan@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVHVlLCBNYXkgMjMsIDIwMjMgYXQgNzoyOeKAr1BNIE1pa2UgU25pdHplciA8c25pdHplckBr
ZXJuZWwub3JnPiB3cm90ZToKPgo+IE9uIEZyaSwgTWF5IDE5IDIwMjMgYXQgIDY6MjdQIC0wNDAw
LAo+IER1IFJ1aSA8ZHVydWlAbGludXguYWxpYmFiYS5jb20+IHdyb3RlOgo+Cj4gPiBPdmVybGF5
QkQgaXMgYSBub3ZlbCBsYXllcmluZyBibG9jay1sZXZlbCBpbWFnZSBmb3JtYXQsIHdoaWNoIGlz
IGRlc2lnbgo+ID4gZm9yIGNvbnRhaW5lciwgc2VjdXJlIGNvbnRhaW5lciBhbmQgYXBwbGljYWJs
ZSB0byB2aXJ0dWFsIG1hY2hpbmUsCj4gPiBwdWJsaXNoZWQgaW4gVVNFTklYIEFUQyAnMjAKPiA+
IGh0dHBzOi8vd3d3LnVzZW5peC5vcmcvc3lzdGVtL2ZpbGVzL2F0YzIwLWxpLWh1aWJhLnBkZgo+
ID4KPiA+IE92ZXJsYXlCRCBhbHJlYWR5IGhhcyBhIENvbnRhaW5lckQgbm9uLWNvcmUgc3ViLXBy
b2plY3QgaW1wbGVtZW50YXRpb24KPiA+IGluIHVzZXJzcGFjZSwgYXMgYW4gYWNjZWxlcmF0ZWQg
Y29udGFpbmVyIGltYWdlIHNlcnZpY2UKPiA+IGh0dHBzOi8vZ2l0aHViLmNvbS9jb250YWluZXJk
L2FjY2VsZXJhdGVkLWNvbnRhaW5lci1pbWFnZQo+ID4KPiA+IEl0IGNvdWxkIGJlIG11Y2ggbW9y
ZSBlZmZpY2llbnQgd2hlbiBkbyBkZWNvbXByZXNzaW5nIGFuZCBtYXBwaW5nIHdvcmtzCj4gPiBp
biB0aGUga2VybmVsIHdpdGggdGhlIGZyYW1ld29yayBvZiBkZXZpY2UtbWFwcGVyLCBpbiBtYW55
IGNpcmN1bXN0YW5jZXMsCj4gPiBzdWNoIGFzIHNlY3VyZSBjb250YWluZXIgcnVudGltZSwgbW9i
aWxlLWRldmljZXMsIGV0Yy4KPiA+Cj4gPiBUaGlzIHBhdGNoIGNvbnRhaW5zIGEgbW9kdWxlLCBk
bS1vdmVybGF5YmQsIHByb3ZpZGVzIHR3byBraW5kcyBvZiB0YXJnZXRzCj4gPiBkbS16ZmlsZSBh
bmQgZG0tbHNtdCwgdG8gZXhwb3NlIGEgZ3JvdXAgb2YgYmxvY2stZGV2aWNlcyBjb250YWlucwo+
ID4gT3ZlcmxheUJEIGltYWdlIGFzIGEgb3ZlcmxhaWQgcmVhZC1vbmx5IGJsb2NrLWRldmljZS4K
PiA+Cj4gPiBTaWduZWQtb2ZmLWJ5OiBEdSBSdWkgPGR1cnVpQGxpbnV4LmFsaWJhYmEuY29tPgo+
Cj4gPHNuaXAsIG9yaWdpbmFsIHBhdGNoIGhlcmU6IFsxXSA+CgpBIGxvbmcgbG9uZyB0aW1lIGFn
byBJIHdyb3RlIGEgZG9ja2VyIGNvbnRhaW5lciBpbWFnZSBiYXNlZCBvbgpkbS1zbmFwc2hvdCB0
aGF0IGlzIHZhZ3VlbHkgc2ltaWxhciB0byB0aGlzIG9uZS4gSXQgaXMgc3RpbGwKYXZhaWxhYmxl
LCBidXQgbm9ib2R5IHJlYWxseSB1c2VzIGl0LiBJdCBoYXMgc2V2ZXJhbCB3ZWFrbmVzc2VzLiBG
aXJzdApvZiBhbGwgdGhlIGNvbnRhaW5lciBpbWFnZSBpcyBhbiBhY3R1YWwgZmlsZXN5c3RlbSwg
c28geW91IG5lZWQgdG8KcHJlLWFsbG9jYXRlIGEgZml4ZWQgbWF4IHNpemUgZm9yIGltYWdlcyBh
dCBjb25zdHJ1Y3Rpb24gdGltZS4KU2Vjb25kbHksIGFsbCB0aGUgbHZtIHZvbHVtZSBjaGFuZ2Vz
IGFuZCBtb3VudHMgZHVyaW5nIHJ1bnRpbWUgY2F1c2VkCndlaXJkIGJlaGF2aW91ciAoZXNwZWNp
YWxseSBhdCBzY2FsZSkgdGhhdCB3YXMgcGFpbmZ1bCB0byBtYW5hZ2UgKGp1c3QKc2VhcmNoIHRo
ZSBkb2NrZXIgaXNzdWUgdHJhY2tlciBmb3IgZGV2bWFwcGVyIGJhY2tlbmQpLiBJbiB0aGUgZW5k
CmV2ZXJ5b25lIG1vdmVkIHRvIGEgZmlsZXN5c3RlbSBiYXNlZCBpbXBsZW1lbnRhdGlvbiAob3Zl
cmxheWZzIGJhc2VkKS4KCj4gSSBhcHByZWNpYXRlIHRoYXQgdGhpcyB3b3JrIGlzIGJlaW5nIGRv
bmUgd2l0aCBhbiBleWUgdG93YXJkCj4gY29udGFpbmVyZCAiY29tbXVuaXR5IiBhbmQgc3RhbmRh
cmRpemF0aW9uIGJ1dCBiYXNlZCBvbiBteSBsaW1pdGVkCj4gcmVzZWFyY2ggaXQgYXBwZWFycyB0
aGF0IHRoaXMgZm9ybWF0IG9mIE9DSSBpbWFnZSBzdG9yYWdlL3VzZSBpcyBvbmx5Cj4gdXNlZCBi
eSBBbGliYWJhPyAoYnV0IEkgY291bGQgYmUgd3JvbmcuLi4pCj4KPiBCdXQgeW91J2QgZG8gd2Vs
bCB0byBleHBsYWluIHdoeSB0aGUgdXNlcnNwYWNlIHNvbHV0aW9uIGlzbid0Cj4gYWNjZXB0YWJs
ZS4gQXJlIHRoZXJlIHNlY3VyaXR5IGlzc3VlcyB0aGF0IG1vdmluZyB0aGUgaW1wbGVtZW50YXRp
b24KPiB0byBrZXJuZWwgYWRkcmVzc2VzPwo+Cj4gSSBhbHNvIGhhdmUgZG91YnRzIHRoYXQgdGhp
cyBzb2x1dGlvbiBpcyBfYWN0dWFsbHlfIG1vcmUgcGVyZm9ybWFudAo+IHRoYW4gYSBwcm9wZXIg
ZmlsZXN5c3RlbSBiYXNlZCBzb2x1dGlvbiB0aGF0IGFsbG93cyBwYWdlIGNhY2hlIHNoYXJpbmcK
PiBvZiBjb250YWluZXIgaW1hZ2UgZGF0YSBhY3Jvc3MgbXVsdGlwbGUgY29udGFpbmVycy4KClRo
aXMgc29sdXRpb24gZG9lc24ndCBldmVuIGFsbG93IHBhZ2UgY2FjaGUgc2hhcmluZyBiZXR3ZWVu
IHNoYXJlZApsYXllcnMgKGxpa2UgY3VycmVudCBjb250YWluZXJzIGRvKSwgbXVjaCBsZXNzIGJl
dHdlZW4gaW5kZXBlbmRlbnQKbGF5ZXJzLgoKPiBUaGVyZSBpcyBhbiBhY3RpdmUgZGlzY3Vzc2lv
biBhYm91dCwgYW5kIGFjdGl2ZSBkZXZlbG9wbWVudCBlZmZvcnQKPiBmb3IsIHVzaW5nIG92ZXJs
YXlmcyArIGVyb2ZzIGZvciBjb250YWluZXIgaW1hZ2VzLiAgSSdtIHJlbHVjdGFudCB0bwo+IG1l
cmdlIHRoaXMgRE0gYmFzZWQgY29udGFpbmVyIGltYWdlIGFwcHJvYWNoIHdpdGhvdXQgd2lkZXIg
Y29uc2Vuc3VzCj4gZnJvbSBvdGhlciBjb250YWluZXIgc3Rha2Vob2xkZXJzLgo+Cj4gQnV0IHNo
b3J0IG9mIHJlYWNoaW5nIHdpZGVyIGNvbnNlbnN1cyBvbiB0aGUgbmVlZCBmb3IgdGhlc2UgRE0K
PiB0YXJnZXRzOiB0aGVyZSBpcyBub3RoaW5nIHByZXZlbnRpbmcgeW91IGZyb20gY2Fycnlpbmcg
dGhlc2UgY2hhbmdlcwo+IGluIHlvdXIgYWxpYmFiYSBrZXJuZWwuCgpFcm9mcyBhbHJlYWR5IGhh
cyBzb21lIGJsb2NrLWxldmVsIHN1cHBvcnQgZm9yIGNvbnRhaW5lciBpbWFnZXMgKHdpdGgKbnlk
dXMpLCBhbmQgY29tcG9zZWZzIHdvcmtzIHdpdGggY3VycmVudCBpbi1rZXJuZWwgRVJPRlMrb3Zl
cmxheWZzLgpBbmQgdGhpcyBuZXcgYXBwcm9hY2ggZG9lc24ndCBoZWxwIGZvciB0aGUgSU1ITyBj
dXJyZW50IHdlYWsgc3BvdCB3ZQpoYXZlLCB3aGljaCBpcyB1bnByaXZpbGVnZWQgY29udGFpbmVy
IGltYWdlcy4KCkFsc28sIHdoaWxlIE9DSSBhcnRpZmFjdHMgY2FuIGJlIHVzZWQgdG8gc3RvcmUg
YW55IGtpbmQgb2YgaW1hZ2UKZm9ybWF0cyAob3IgYW55IG90aGVyIGtpbmQgb2YgZmlsZSkgSSB0
aGluayBmb3IgYW4gYWN0dWFsIHN0YW5kYXJkaXplZApuZXcgaW1hZ2UgZm9ybWF0IGl0IHdvdWxk
IGJlIGJldHRlciB0byB3b3JrIHdpdGggdGhlIE9DSSBvcmcgdG8gY29tZQp1cCB3aXRoIGEgT0NJ
IHYyIHN0YW5kYXJkIGltYWdlIGZvcm1hdC4KCkJ1dCwgSSBkb24ndCByZWFsbHkgc3BlYWsgZm9y
IHRoZSBibG9jayBsYXllciBkZXZlbG9wZXJzLCBzbyB0YWtlIG15Cm9waW5pb25zIHdpdGggYSBw
aW5jaCBvZiBzYWx0LgoKLS0gCj0tPS09LT0tPS09LT0tPS09LT0tPS09LT0tPS09LT0tPS09LT0t
PS09LT0tPS09LT0tPS09LT0tPS09LT0tPQogQWxleGFuZGVyIExhcnNzb24gICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIFJlZCBIYXQsIEluYwogICAgICAgYWxleGxAcmVkaGF0LmNvbSAg
ICAgICAgIGFsZXhhbmRlci5sYXJzc29uQGdtYWlsLmNvbQoKLS0KZG0tZGV2ZWwgbWFpbGluZyBs
aXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1h
bi9saXN0aW5mby9kbS1kZXZlbAo=

