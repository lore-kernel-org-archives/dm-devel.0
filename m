Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91F40C4332F
	for <dm-devel@archiver.kernel.org>; Wed, 19 Oct 2022 19:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666208430;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=FzTw3svmeE9u0KNdq0EYRjpAbyEYpSqzk8nfctX/Ihw=;
	b=e0ktHWOmCYuF0syOgmR8KIHo4hkDTNHB4BAsdP2QAcv1jmSAAQfcQ+GBa7IccwBgCXl0l7
	xf0KvrDWFj4RS+9ZtQ4lJurHYByCSQ6PBhwkI2O8lqh1Cn1TagpdGCteuXiSoScA8MoUtr
	yJrAfpJ+PK/K3FtcxGOA+vdPp3uJBLs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-444-zG1K_oqLN9CyslxcYtdEiA-1; Wed, 19 Oct 2022 15:40:28 -0400
X-MC-Unique: zG1K_oqLN9CyslxcYtdEiA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 41018857F8F;
	Wed, 19 Oct 2022 19:40:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id ED264C15BA5;
	Wed, 19 Oct 2022 19:40:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CF9B21946595;
	Wed, 19 Oct 2022 19:40:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9E36B1946587
 for <dm-devel@listman.corp.redhat.com>; Wed, 19 Oct 2022 19:40:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 82FA540E042D; Wed, 19 Oct 2022 19:40:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7BAAE40E0420
 for <dm-devel@redhat.com>; Wed, 19 Oct 2022 19:40:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5C5C91C05B02
 for <dm-devel@redhat.com>; Wed, 19 Oct 2022 19:40:24 +0000 (UTC)
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-118-ZSWNnplqP3WGXrQZYHurqw-1; Wed, 19 Oct 2022 15:40:23 -0400
X-MC-Unique: ZSWNnplqP3WGXrQZYHurqw-1
Received: by mail-qt1-f199.google.com with SMTP id
 br5-20020a05622a1e0500b00394c40fee51so13570280qtb.17
 for <dm-devel@redhat.com>; Wed, 19 Oct 2022 12:40:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=bely4gnlEDOK4q881KwnLtiPxkNABpetcxXnV5hgnJE=;
 b=SduFBxqd/iE8UUXD1L+lJZphpnPiEBbIHNi27ypoBi19hRYpkwYiN3pcMQvxuYD/VK
 m4CMP/tMLN24KAUhQ4D5fUQ1KpY1Lu5nu73sUlXks370u/zoUA9prsQpsUrrdpBDJgkS
 t7XQrBWQ96RRcBFScBuQ3Eja1M1TZGEdwJ5Poy67tPKu2ffJXwgLcd/OnNzQ7rtboWci
 wMhJoWjgkPv1ckfIHxEySirQdlk5DoB6Zzh1aWn3tzo6OuOlyBxeLh0b0vJZ1KZz7Ipb
 i81HR+Ys4JrDcAV8I5Y0wl3fHXeNBZXkOKGmt8d6S8QfuYb1fQk4moZcsEnZORy+bNDH
 jV+Q==
X-Gm-Message-State: ACrzQf0x6VMQ7JeQ6Sgb2NJmwwDTrDEk1obcXb5C+jOdlmbbEceBpK0R
 mbyrxK/9mgUeDcoj/N2bcHV30I2sP0wHI3D52ZsappMV2mBFHd/MOMq1JMfh1mtf/nmgGGwkatt
 r9jgcuyMMy1gazw==
X-Received: by 2002:ae9:efca:0:b0:6ee:b349:fd20 with SMTP id
 d193-20020ae9efca000000b006eeb349fd20mr6868455qkg.772.1666208422241; 
 Wed, 19 Oct 2022 12:40:22 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5XkktMIWZjb6rCFjrKIgnllgL8ct5mbTclSaCLJW6wkZxhIbXaigHjkis/Gfl/jYKd9LvvBQ==
X-Received: by 2002:ae9:efca:0:b0:6ee:b349:fd20 with SMTP id
 d193-20020ae9efca000000b006eeb349fd20mr6868440qkg.772.1666208421982; 
 Wed, 19 Oct 2022 12:40:21 -0700 (PDT)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 f21-20020a05622a105500b0039cc64bcb53sm4681156qte.27.2022.10.19.12.40.20
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 19 Oct 2022 12:40:20 -0700 (PDT)
Date: Wed, 19 Oct 2022 15:40:19 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Luo Meng <luomeng@huaweicloud.com>
Message-ID: <Y1BSo+9D7QP0y/Pi@redhat.com>
References: <20221010143905.240306-1-luomeng@huaweicloud.com>
 <Y02vOFnwZOHPrVY8@redhat.com>
 <bab8c5aa-9b12-b330-9c3b-fdd5ce4cd1b8@huaweicloud.com>
MIME-Version: 1.0
In-Reply-To: <bab8c5aa-9b12-b330-9c3b-fdd5ce4cd1b8@huaweicloud.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] dm: Fix UAF in run_timer_softirq()
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
Cc: snitzer@kernel.org, ejt@redhat.com, dm-devel@redhat.com,
 luomeng12@huawei.com, yukuai3@huawei.com, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVHVlLCBPY3QgMTggMjAyMiBhdCAgNDoxN1AgLTA0MDAsCkx1byBNZW5nIDxsdW9tZW5nQGh1
YXdlaWNsb3VkLmNvbT4gd3JvdGU6Cgo+IAo+IAo+IOWcqCAyMDIyLzEwLzE4IDM6MzgsIE1pa2Ug
U25pdHplciDlhpnpgZM6Cj4gPiBPbiBNb24sIE9jdCAxMCAyMDIyIGF0IDEwOjM5UCAtMDQwMCwK
PiA+IEx1byBNZW5nIDxsdW9tZW5nQGh1YXdlaWNsb3VkLmNvbT4gd3JvdGU6Cj4gPiAKPiA+ID4g
RnJvbTogTHVvIE1lbmcgPGx1b21lbmcxMkBodWF3ZWkuY29tPgo+ID4gPiAKPiA+ID4gV2hlbiBk
bV9yZXN1bWUoKSBhbmQgZG1fZGVzdHJveSgpIGFyZSBjb25jdXJyZW50LCBpdCB3aWxsCj4gPiA+
IGxlYWQgdG8gVUFGLgo+ID4gPiAKPiA+ID4gT25lIG9mIHRoZSBjb25jdXJyZW5jeSBVQUYgY2Fu
IGJlIHNob3duIGFzIGJlbG93Ogo+ID4gPiAKPiA+ID4gICAgICAgICAgdXNlICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIGZyZWUKPiA+ID4gZG9fcmVzdW1lICAgICAgICAgICAgICAg
ICAgICAgICAgICAgfAo+ID4gPiAgICBfX2ZpbmRfZGV2aWNlX2hhc2hfY2VsbCAgICAgICAgICAg
fAo+ID4gPiAgICAgIGRtX2dldCAgICAgICAgICAgICAgICAgICAgICAgICAgfAo+ID4gPiAgICAg
ICAgYXRvbWljX2luYygmbWQtPmhvbGRlcnMpICAgICAgfAo+ID4gPiAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgfCBkbV9kZXN0cm95Cj4gPiA+IAkJCQkgICAgfCAgIF9fZG1f
ZGVzdHJveQo+ID4gPiAJCQkJICAgIHwgICAgIGlmICghZG1fc3VzcGVuZGVkX21kKG1kKSkKPiA+
ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAgIGF0b21pY19yZWFk
KCZtZC0+aG9sZGVycykKPiA+ID4gCQkJCSAgICB8ICAgICBtc2xlZXAoMSkKPiA+ID4gICAgZG1f
cmVzdW1lICAgICAgICAgICAgICAgICAgICAgICAgIHwKPiA+ID4gICAgICBfX2RtX3Jlc3VtZSAg
ICAgICAgICAgICAgICAgICAgIHwKPiA+ID4gICAgICAgIGRtX3RhYmxlX3Jlc3VtZV90YXJnZXRz
ICAgICAgIHwKPiA+ID4gCXBvb2xfcmVzdW1lICAgICAgICAgICAgICAgICB8Cj4gPiA+IAkgIGRv
X3dha2VyICAjYWRkIGRlbGF5IHdvcmsgfAo+ID4gPiAJCQkJICAgIHwgICAgIGRtX3RhYmxlX2Rl
c3Ryb3kKPiA+ID4gCQkJCSAgICB8ICAgICAgIHBvb2xfZHRyCj4gPiA+IAkJCQkgICAgfCAgICAg
ICAgIF9fcG9vbF9kZWMKPiA+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IHwgICAgICAgICAgIF9fcG9vbF9kZXN0cm95Cj4gPiA+ICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICB8ICAgICAgICAgICAgIGRlc3Ryb3lfd29ya3F1ZXVlCj4gPiA+ICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgICAgICAgICAgIGtmcmVlKHBvb2wp
ICMgZnJlZSBwb29sCj4gPiA+IAl0aW1lIG91dAo+ID4gPiBfX2RvX3NvZnRpcnEKPiA+ID4gICAg
cnVuX3RpbWVyX3NvZnRpcnEgIyBwb29sIGhhcyBhbHJlYWR5IGJlZW4gZnJlZWQKPiA+ID4gCj4g
PiA+IFRoaXMgY2FuIGJlIGVhc2lseSByZXByb2R1Y2VkIHVzaW5nOgo+ID4gPiAgICAxLiBjcmVh
dGUgdGhpbi1wb29sCj4gPiA+ICAgIDIuIGRtc2V0dXAgc3VzcGVuZCBwb29sCj4gPiA+ICAgIDMu
IGRtc2V0dXAgcmVzdW1lIHBvb2wKPiA+ID4gICAgNC4gZG1zZXR1cCByZW1vdmVfYWxsICMgQ29u
Y3VycmVudCB3aXRoIDMKPiA+ID4gCj4gPiA+IFRoZSByb290IGNhdXNlIG9mIFVBRiBidWdzIGlz
IHRoYXQgZG1fcmVzdW1lKCkgYWRkcyB0aW1lciBhZnRlcgo+ID4gPiBkbV9kZXN0cm95KCkgc2tp
cHMgY2FuY2VsIHRpbWVyIGJlYXVzZSBvZiBzdXNwZW5kIHN0YXR1cy4gQWZ0ZXIKPiA+ID4gdGlt
ZW91dCwgaXQgd2lsbCBjYWxsIHJ1bl90aW1lcl9zb2Z0aXJxKCksIGhvd2V2ZXIgcG9vbCBoYXMg
YWxyZWFkeQo+ID4gPiBiZWVuIGZyZWVkLiBUaGUgY29uY3VycmVuY3kgVUFGIGJ1ZyB3aWxsIGhh
cHBlbi4KPiA+ID4gCj4gPiA+IFRoZXJlZm9yZSwgY2FuY2VsaW5nIHRpbWVyIGlzIG1vdmVkIGFm
dGVyIG1kLT5ob2xkZXJzIGlzIHplcm8uCj4gPiA+IAo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBMdW8g
TWVuZyA8bHVvbWVuZzEyQGh1YXdlaS5jb20+Cj4gPiA+IC0tLQo+ID4gPiAgIGRyaXZlcnMvbWQv
ZG0uYyB8IDI2ICsrKysrKysrKysrKystLS0tLS0tLS0tLS0tCj4gPiA+ICAgMSBmaWxlIGNoYW5n
ZWQsIDEzIGluc2VydGlvbnMoKyksIDEzIGRlbGV0aW9ucygtKQo+ID4gPiAKPiA+ID4gZGlmZiAt
LWdpdCBhL2RyaXZlcnMvbWQvZG0uYyBiL2RyaXZlcnMvbWQvZG0uYwo+ID4gPiBpbmRleCA2MDU0
OWI2NWM3OTkuLjM3OTUyNTMxMzYyOCAxMDA2NDQKPiA+ID4gLS0tIGEvZHJpdmVycy9tZC9kbS5j
Cj4gPiA+ICsrKyBiL2RyaXZlcnMvbWQvZG0uYwo+ID4gPiBAQCAtMjQyMCw2ICsyNDIwLDE5IEBA
IHN0YXRpYyB2b2lkIF9fZG1fZGVzdHJveShzdHJ1Y3QgbWFwcGVkX2RldmljZSAqbWQsIGJvb2wg
d2FpdCkKPiA+ID4gICAJYmxrX21hcmtfZGlza19kZWFkKG1kLT5kaXNrKTsKPiA+ID4gKwkvKgo+
ID4gPiArCSAqIFJhcmUsIGJ1dCB0aGVyZSBtYXkgYmUgSS9PIHJlcXVlc3RzIHN0aWxsIGdvaW5n
IHRvIGNvbXBsZXRlLAo+ID4gPiArCSAqIGZvciBleGFtcGxlLiAgV2FpdCBmb3IgYWxsIHJlZmVy
ZW5jZXMgdG8gZGlzYXBwZWFyLgo+ID4gPiArCSAqIE5vIG9uZSBzaG91bGQgaW5jcmVtZW50IHRo
ZSByZWZlcmVuY2UgY291bnQgb2YgdGhlIG1hcHBlZF9kZXZpY2UsCj4gPiA+ICsJICogYWZ0ZXIg
dGhlIG1hcHBlZF9kZXZpY2Ugc3RhdGUgYmVjb21lcyBETUZfRlJFRUlORy4KPiA+ID4gKwkgKi8K
PiA+ID4gKwlpZiAod2FpdCkKPiA+ID4gKwkJd2hpbGUgKGF0b21pY19yZWFkKCZtZC0+aG9sZGVy
cykpCj4gPiA+ICsJCQltc2xlZXAoMSk7Cj4gPiA+ICsJZWxzZSBpZiAoYXRvbWljX3JlYWQoJm1k
LT5ob2xkZXJzKSkKPiA+ID4gKwkJRE1XQVJOKCIlczogRm9yY2libHkgcmVtb3ZpbmcgbWFwcGVk
X2RldmljZSBzdGlsbCBpbiB1c2UhICglZCB1c2VycykiLAo+ID4gPiArCQkgICAgICAgZG1fZGV2
aWNlX25hbWUobWQpLCBhdG9taWNfcmVhZCgmbWQtPmhvbGRlcnMpKTsKPiA+ID4gKwo+ID4gPiAg
IAkvKgo+ID4gPiAgIAkgKiBUYWtlIHN1c3BlbmRfbG9jayBzbyB0aGF0IHByZXN1c3BlbmQgYW5k
IHBvc3RzdXNwZW5kIG1ldGhvZHMKPiA+ID4gICAJICogZG8gbm90IHJhY2Ugd2l0aCBpbnRlcm5h
bCBzdXNwZW5kLgo+ID4gPiBAQCAtMjQzNiwxOSArMjQ0OSw2IEBAIHN0YXRpYyB2b2lkIF9fZG1f
ZGVzdHJveShzdHJ1Y3QgbWFwcGVkX2RldmljZSAqbWQsIGJvb2wgd2FpdCkKPiA+ID4gICAJZG1f
cHV0X2xpdmVfdGFibGUobWQsIHNyY3VfaWR4KTsKPiA+ID4gICAJbXV0ZXhfdW5sb2NrKCZtZC0+
c3VzcGVuZF9sb2NrKTsKPiA+ID4gLQkvKgo+ID4gPiAtCSAqIFJhcmUsIGJ1dCB0aGVyZSBtYXkg
YmUgSS9PIHJlcXVlc3RzIHN0aWxsIGdvaW5nIHRvIGNvbXBsZXRlLAo+ID4gPiAtCSAqIGZvciBl
eGFtcGxlLiAgV2FpdCBmb3IgYWxsIHJlZmVyZW5jZXMgdG8gZGlzYXBwZWFyLgo+ID4gPiAtCSAq
IE5vIG9uZSBzaG91bGQgaW5jcmVtZW50IHRoZSByZWZlcmVuY2UgY291bnQgb2YgdGhlIG1hcHBl
ZF9kZXZpY2UsCj4gPiA+IC0JICogYWZ0ZXIgdGhlIG1hcHBlZF9kZXZpY2Ugc3RhdGUgYmVjb21l
cyBETUZfRlJFRUlORy4KPiA+ID4gLQkgKi8KPiA+ID4gLQlpZiAod2FpdCkKPiA+ID4gLQkJd2hp
bGUgKGF0b21pY19yZWFkKCZtZC0+aG9sZGVycykpCj4gPiA+IC0JCQltc2xlZXAoMSk7Cj4gPiA+
IC0JZWxzZSBpZiAoYXRvbWljX3JlYWQoJm1kLT5ob2xkZXJzKSkKPiA+ID4gLQkJRE1XQVJOKCIl
czogRm9yY2libHkgcmVtb3ZpbmcgbWFwcGVkX2RldmljZSBzdGlsbCBpbiB1c2UhICglZCB1c2Vy
cykiLAo+ID4gPiAtCQkgICAgICAgZG1fZGV2aWNlX25hbWUobWQpLCBhdG9taWNfcmVhZCgmbWQt
PmhvbGRlcnMpKTsKPiA+ID4gLQo+ID4gPiAgIAlkbV90YWJsZV9kZXN0cm95KF9fdW5iaW5kKG1k
KSk7Cj4gPiA+ICAgCWZyZWVfZGV2KG1kKTsKPiA+ID4gICB9Cj4gPiA+IC0tIAo+ID4gPiAyLjMx
LjEKPiA+ID4gCj4gPiAKPiA+IFRoYW5rcyBmb3IgdGhlIHJlcG9ydCBidXQgeW91ciBmaXggc2Vl
bXMgd3JvbmcuICBBIHRoaW4tcG9vbCBzcGVjaWZpYwo+ID4gZml4IHNlZW1zIG11Y2ggbW9yZSBh
cHByb3ByaWF0ZS4gIERvZXMgdGhpcyBmaXggdGhlIGlzc3VlPwo+ID4gCj4gPiBkaWZmIC0tZ2l0
IGEvZHJpdmVycy9tZC9kbS10aGluLmMgYi9kcml2ZXJzL21kL2RtLXRoaW4uYwo+ID4gaW5kZXgg
ZTc2Yzk2Yzc2MGE5Li5kYzI3MWMxMDdmYjUgMTAwNjQ0Cj4gPiAtLS0gYS9kcml2ZXJzL21kL2Rt
LXRoaW4uYwo+ID4gKysrIGIvZHJpdmVycy9tZC9kbS10aGluLmMKPiA+IEBAIC0yODg5LDYgKzI4
ODksOCBAQCBzdGF0aWMgdm9pZCBfX3Bvb2xfZGVzdHJveShzdHJ1Y3QgcG9vbCAqcG9vbCkKPiA+
ICAgCWRtX2Jpb19wcmlzb25fZGVzdHJveShwb29sLT5wcmlzb24pOwo+ID4gICAJZG1fa2NvcHlk
X2NsaWVudF9kZXN0cm95KHBvb2wtPmNvcGllcik7Cj4gPiArCWNhbmNlbF9kZWxheWVkX3dvcmtf
c3luYygmcG9vbC0+d2FrZXIpOwo+ID4gKwljYW5jZWxfZGVsYXllZF93b3JrX3N5bmMoJnBvb2wt
Pm5vX3NwYWNlX3RpbWVvdXQpOwo+ID4gICAJaWYgKHBvb2wtPndxKQo+ID4gICAJCWRlc3Ryb3lf
d29ya3F1ZXVlKHBvb2wtPndxKTsKPiA+IAo+IFRoYW5rcyBmb3IgeW91ciByZXBseS4KPiAKPiBI
b3dldmVyIHRoaXMgaXNzdWUgZXhpdHMgbm90IG9ubHkgaW4gdGhpbi1wb29sLCBjYWNoZV90YXJn
ZXQgYWxzbyBoYXMKPiB0aGlzaXNzdXMuICBHZW5lcmljIGZpeCBtYXliZSBtb3JlIGFwcHJvcHJp
YXRlLgoKTm8sIHlvdSd2ZSBwb2ludGVkIG91dCBhIHByb2JsZW0gd2l0aCBkbS10aGlucCBub3Qg
cHJvcGVybHkgdGVhcmluZwpkb3duIGl0cyByZXNvdXJjZXMuIFNhbWUgZm9yIGRtLWNhY2hlLiBT
byBhIGdlbmVyaWMgZml4IGRvZXNuJ3QgbWFrZQpzZW5zZS4gIEFuZCB5b3VyIHBhcnRpY3VsYXIg
Z2VuZXJpYyBmaXggbWVyZWx5IHBhcGVycyBvdmVyIHRoZQpyZXNvdXJjZSBsZWFrLCB3aGlsZSBh
bHNvIGNhdXNpbmcgRE0gY29yZSB0byBubyBsb25nZXIgcHJvcGVybHkgd2FpdApmb3Igb3V0c3Rh
bmRpbmcgSU8gdG8gY29tcGxldGUuCgo+IEFmdGVyIGFkZGluZyBjYW5jZWxfZGVsYXllZF93b3Jr
X3N5bmMoKSBpbiBfX3Bvb2xfZGVzdHJveSgpLCB0aGlzIHdpbGwgbWFrZQo+IGl0IHBvc3NpYmxl
IHRvIGNhbGwgY2FuY2VsX2RlbGF5ZWRfd29ya19zeW5jKCZwb29sLT53YWtlcikgdHdpY2Ugd2hl
biBkbSBpcwo+IG5vdCBzdXNwZW5kLgoKVGhhdCdzIG5vdCBhIHByb2JsZW0sIHRoYXQncyB0aGUg
Y29zdCBvZiBwcm9wZXJseSBhY2NvdW50aW5nIGZvcgpyZXNvdXJjZXMgd2hlcmUgd2UgbXVzdC4K
Ci0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlz
dG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

