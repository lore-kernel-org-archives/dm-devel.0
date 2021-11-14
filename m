Return-Path: <SRS0=nAAI=QB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F3CDC433F5
	for <dm-devel@archiver.kernel.org>; Sun, 14 Nov 2021 11:56:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9A47F61037
	for <dm-devel@archiver.kernel.org>; Sun, 14 Nov 2021 11:56:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9A47F61037
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-QpKTIJ0BOPO1idVSYNouAQ-1; Sun, 14 Nov 2021 06:56:43 -0500
X-MC-Unique: QpKTIJ0BOPO1idVSYNouAQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A0C5015720;
	Sun, 14 Nov 2021 11:56:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 36ADF1972E;
	Sun, 14 Nov 2021 11:56:35 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0F75618199EE;
	Sun, 14 Nov 2021 11:56:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AEBuSQu023335 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 14 Nov 2021 06:56:28 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7AB9D2166B26; Sun, 14 Nov 2021 11:56:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 741442166B25
	for <dm-devel@redhat.com>; Sun, 14 Nov 2021 11:56:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 82805185A7B2
	for <dm-devel@redhat.com>; Sun, 14 Nov 2021 11:56:25 +0000 (UTC)
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com
	[209.85.221.45]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-241-B467rOVZOTCbhVKyI88C7A-1; Sun, 14 Nov 2021 06:56:19 -0500
X-MC-Unique: B467rOVZOTCbhVKyI88C7A-1
Received: by mail-wr1-f45.google.com with SMTP id d24so24700676wra.0;
	Sun, 14 Nov 2021 03:56:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-transfer-encoding
	:content-language;
	bh=AtQhNoyjCFpYPcpmWyRcg/wLivuXU8loMJvqzh584tE=;
	b=G9ohzON0SdUaio3/+EjpjZCEy5xUql3eLRdBb1/85LQa4PALi6CmPM0mE29rIJ7zYQ
	DJ2paEfAe9Ti0JDNhDiATgxUBnxUlSukHIy4AOtRrU2F6BQdJQ9BIfvJrQrTxMvD7egU
	BtFTmjseMEcF3H76Fhoe0/GU49lmi1VKjSuZUJ5kOA2C8CU0o6VPaiFuoq/TlU7817CH
	Tvz+KCHJl6Is8wSCZGoOKQnv5M2k6SR/WqRnZVjgM+r62USEWrKwu4xPw9i1hVSr0Epw
	8/iFcUZYqfPFKieZTIB5vETw0MiufpWMAGw2r01CByJa7bWc0tQxhm2H7lXaOtN1ePJo
	7Cdg==
X-Gm-Message-State: AOAM533vsUmC03zFRKwVWpn7FfBmSUwhPR76Ad+4fjZXSGvQJx7fY5Jj
	8//58j2EFNNN2MXg2V3Uh5BK8agqJzOFVGPJ
X-Google-Smtp-Source: ABdhPJzEb5CZdnJzAHl5DpgbiijdugoPRTSLDUYq7uPC9Vycajfh9Aztj6yuBx2MWL+n7OjF4/6aEg==
X-Received: by 2002:a5d:464c:: with SMTP id j12mr36298601wrs.150.1636890977699;
	Sun, 14 Nov 2021 03:56:17 -0800 (PST)
Received: from [10.53.134.167] ([193.169.71.150])
	by smtp.gmail.com with ESMTPSA id
	h17sm11069785wrp.34.2021.11.14.03.56.16
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Sun, 14 Nov 2021 03:56:17 -0800 (PST)
To: Milan Broz <gmazyland@gmail.com>, dm-devel@redhat.com
References: <CAFpOueRBb9y_Fgb3-c6_eFTKZR9DoAXZmxqqx0UH1Yb2rbV0RQ@mail.gmail.com>
	<da6989dc-1fab-cbd0-4ea9-1b60ea9de964@gmail.com>
From: Itai Handler <itai.handler@gmail.com>
Message-ID: <c93ae166-faf8-f00f-7e63-b852a224310c@gmail.com>
Date: Sun, 14 Nov 2021 13:56:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <da6989dc-1fab-cbd0-4ea9-1b60ea9de964@gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Mikulas Patocka <mpatocka@redhat.com>, agk@redhat.com, snitzer@redhat.com
Subject: Re: [dm-devel] [RFC PATCH 1/1] dm crypt: change maximum sector size
 to PAGE_SIZE
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMTEvMTEvMjAyMSAxNTowNywgTWlsYW4gQnJveiB3cm90ZToKPiBPbiAxMC8xMS8yMDIxIDE4
OjQzLCBJdGFpIEhhbmRsZXIgd3JvdGU6Cj4+IE1heGltdW0gc2VjdG9yIHNpemUgb2YgZG0tY3J5
cHQgaXMgY3VycmVudGx5IGxpbWl0ZWQgdG8gNDA5NiBieXRlcy4KPj4KPj4gT24gc3lzdGVtcyB3
aGVyZSBQQUdFX1NJWkUgaXMgbGFyZ2VyIHRoYW4gNDA5NiBieXRlcywgdXNpbmcgbGFyZ2VyCj4+
IHNlY3RvcnMgY2FuIGJlIGJlbmVmaWNpYWwgZm9yIHBlcmZvcm1hbmNlIHJlYXNvbnMuCj4KPiBU
aGUgbGltaXQgdG8gNDA5NiB3YXMgc2V0IGJlY2F1c2UgdGhpcyBpcyB0aGUgc21hbGxlc3QgcG9z
c2libGUKPiBwYWdlIHNpemUgdGhhdCBhbGwgcGxhdGZvcm0gc3VwcG9ydHMuCj4KPiBJZiB5b3Ug
YWxsb3cgYSBoaWdoZXIgc2l6ZSBoZXJlLCB0aGUgZGV2aWNlIGNhbm5vdCBiZSBhY3RpdmF0ZWQg
b24gYSAKPiBwbGF0Zm9ybQo+IHdpdGggdGhlIHNtYWxsZXIgcGFnZSBzaXplLiAoRW5jcnlwdGVk
IHNlY3RvciBzaXplIGJlY29tZXMKPiBhdG9taWMgc2VjdG9yIHNpemUgZm9yIGFsbCB1cHBlciBs
YXllcnMgLSBhcyB5b3UgbWVudGlvbiBiZWxvdywgbm90Cj4gYWxsIGZzIHN1cHBvcnQgYmlnZ2Vy
IHNlY3RvcnMuKQo+Cj4gRm9yIExVS1MsIHRoaXMgaXMgbm90IGFjY2VwdGFibGUgLSB0aGUgZm9y
bWF0IGlzIHBvcnRhYmxlIGJ5IGRlZmluaXRpb24uCj4KPiBGb3Igc3BlY2lmaWMgZG0tY3J5cHQg
ZGV2aWNlLCBJIGFtIG5vdCBzdXJlLiBJIHdvdWxkIGJldHRlciBrZXB0Cj4gdGhlIDQwOTYgcGFn
ZSBzaXplIGxpbWl0IGhlcmUuCgpJIGNvbnNpZGVyZWQgb25seSBwbGFpbiBkbS1jcnlwdCBzaW5j
ZSBJIGFtIHVuZmFtaWxpYXIgd2l0aCBMVUtTLgpEb2VzIExVS1MgYXNzdW1lIHRoYXQgZG0tY3J5
cHQgc2VjdG9yIHNpemUgaXMgbGltaXRlZCB0byA0Sz8KSWYgc28sIG1heWJlIEknbGwgYmUgYWJs
ZSB0byBhbHNvIHBhdGNoIExVS1MgcmVnYXJkaW5nIHRoaXMgaXNzdWUuCgo+Cj4gSXQgYWxzbyBk
ZXBlbmRzIG9uIGNyeXB0byBBUEkgZHJpdmVyIGhlcmUgKHBlcmZvcm1hbmNlIGlzIHVzdWFsbHkg
Cj4gb3B0aW1pemVkIHRvIDRrKS4KPiBXaGF0IGNpcGhlciBhbmQgZW5jcnlwdGlvbiBtb2RlIGRp
ZCB5b3UgdXNlIGZvciB0ZXN0PwoKVGhlIGNpcGhlciBJIHVzZWQgZm9yIHRoZSB0ZXN0IGlzIG5v
dCBwdWJsaWNseSBhdmFpbGFibGUgYnV0IEkgY2FuIHNheSAKdGhhdCBpdCdzIHBlcmZvcm1hbmNl
CmlzIG5vdCBvcHRpbWl6ZWQgdG8gNGsgYmxvY2tzLgpJIGJlbGlldmUgdGhhdCB0aGlzIHJlc3Vs
dHMgZnJvbSB0aGUgaGlnaCBvdmVyaGVhZCBvZiBzZXR0aW5nIHVwIERNQSAKdHJhbnNmZXJzLiAo
bXkKY2lwaGVyIHVzZXMgRE1BIHRvIHRyYW5zZmVyIGRhdGEgYmV0d2VlbiBtZW1vcnkgYW5kIHBy
b2dyYW1tYWJsZSBsb2dpYykuClRoZXJlIGFyZSBtYW55IGFkZGl0aW9uYWwgY2lwaGVycyB0aGF0
IHVzZSBETUEgaW4gdGhlIHRyZWUsIGJ1dCBJIGNhbm5vdCAKcnVuIGFueQpiZW5jaG1hcmsgd2l0
aCB0aGVtIGF0IHRoZSBtb21lbnQuCgpJIGhhdmUgcGVyZm9ybWVkIHNvbWUgYWRkaXRpb25hbCBi
ZW5jaG1hcmtzIHVzaW5nIHRoZSBBUk0gQ3J5cHRvZ3JhcGhpYyAKRXh0ZW5zaW9ucwpDUFUgY2lw
aGVycyBhbmQgc2F3IHRoYXQgaW5jcmVhc2luZyBibG9jayBzaXplIGJleW9uZCA0SyBkb2VzIGlu
Y3JlYXNlIApwZXJmb3JtYW5jZSwKYWxiZWl0IHRoZSBwZXJmb3JtYW5jZSBpbXByb3ZlbWVudCBp
c24ndCBhcyBsYXJnZSBhcyBJJ3ZlIHNlZW4gd2hlbiAKdXNpbmcgbXkgY2lwaGVyLgoKRm9sbG93
aW5nIGFyZSAidGNyeXB0IG1vZGU9NjAwIHNlYz01IG51bV9tYj01MTIiIHJlc3VsdHMgZm9yIHh0
cy1hZXMtY2UgCmRlY3J5cHRpb24KKEFSTSBDUFUgQ3J5cHRvZ3JhcGhpYyBFeHRlbnNpb25zIGNp
cGhlcik6CiDCoCB0ZXN0aW5nIHNwZWVkIG9mIG11bHRpYnVmZmVyIHh0cyhhZXMpICh4dHMtYWVz
LWNlKSBkZWNyeXB0aW9uCiDCoCAuLi4KIMKgIHRyY3lwdDogdGVzdCA1ICgyNTYgYml0IGtleSwg
NDA5NiBieXRlIGJsb2Nrcyk6IDgwMTc5MiBvcGVyYXRpb25zIGluIAo1IHNlY29uZHMgKDMyODQx
NDAwMzIgYnl0ZXMpCiDCoCAuLi4KIMKgIHRyY3lwdDogdGVzdCA5ICgyNTYgYml0IGtleSwgNjU1
MzYgYnl0ZSBibG9ja3MpOiA2MzQ4OCBvcGVyYXRpb25zIGluIAo1IHNlY29uZHMgKDQxNjA3NDk1
NjggYnl0ZXMpCgpUaGF0IHRyYW5zbGF0ZXMgdG86CiDCoCA2NTcgTUIvcyBmb3IgNEsgYnl0ZSBi
bG9ja3MuCiDCoCA4MzIgTUIvcyBmb3IgNjRLIGJsb2Nrcy4KClRoYXQgbWVhbnMgdGhhdCB0aGVy
ZSBpcyBhYm91dCAyNyBwZXJjZW50cyBpbXByb3ZlbWVudCB3aGVuIAp0cmFuc2l0aW9uaW5nIHRv
IDY0SyBzZWN0b3JzLApmb3IgdGhlIGNpcGhlciBhbG9uZSAob25seSB0Y3J5cHQgYmVuY2htYXJr
KS4KClRoaXMgYmVuY2htYXJrIGhhZCBiZWVuIHBlcmZvcm1lZCBvbiBhbiBBUk0gQ29ydGV4IEE1
MyBDUFUuCihOb3RlIHRoYXQgaW4gYWxsIG9mIG15IGJlbmNobWFya3MgUEFHRV9TSVpFPTY0Syku
Cgo+IEhvdyB0aGUgbnVtYmVyIGxvb2tzIGZvciByYW5kb20gYWNjZXNzPyBMaW5lYXIgdGVzdCBp
cyB1c3VhbGx5IAo+IG1pc2xlYWRpbmcuCj4gSSBleHBlY3QgdGhlcmUgd2lsbCBiZSBiaWcgcGVy
Zm9ybWFuY2UgcHJvYmxlbSBpZiB5b3Ugd3JpdGUgc21hbGwgZGF0YSAKPiBjaHVua3MsCj4gd3Jp
dGVzIGFuZCBlbmNyeXB0aW9uIHdpbGwgYmUgYW1wbGlmaWVkIHRvIGZ1bGwgYmlnIHNlY3RvcnMg
aGVyZS4uLikKSSB1bmRlcnN0YW5kIHlvdXIgY29uY2Vybi4KSG93ZXZlciBteSBwYXRjaCBkb2Vz
IG5vdCBmb3JjZSBhbnlvbmUgdG8gdXNlIGxhcmdlIHNlY3RvcnMgLSBpdCBvbmx5IApvcGVucyB1
cCB0aGlzCnBvc3NpYmlsaXR5IGZvciB0aG9zZSBpbnRlcmVzdGVkIGluIHRoYXQgb3B0aW9uLgpU
aGlzIGlzIHNpbWlsYXJseSB0byB0aGUgb3B0aW9uIHRvIGZvcm1hdCBhbiBleHQ0IGZpbGVzeXN0
ZW0gd2l0aCA2NEsgCnNlY3RvcnMuCkJ5IHRoZSB3YXk6IHdoZW4geW91IGRvIHRoYXQsIHlvdSBn
ZXQgYSB3YXJuaW5nIHNheWluZyB0aGF0IHRoZSBmaWxlc3lzdGVtCndpbGwgbm90IGJlIHVzYWJs
ZSBvbiBtb3N0IHN5c3RlbXMuCgpTb21ldGltZSB1c2VycyBuZWVkIHRvIHN0b3JlIG1vc3RseSBs
YXJnZSBmaWxlcyBvbiBhIGZpbGVzeXN0ZW0sIGZvciAKZXhhbXBsZSBmb3IKYmFja3VwIG9yIGZv
ciB2aWRlbyBmaWxlcy4KSSB0aGluayB0aGF0IGluIHRoZXNlIGNhc2VzIHJhbmRvbSBhY2Nlc3Mg
dGltZSBpcyBub3Qgc28gaW1wb3J0YW50LgpTb21lIHVzZXJzIG1heSBhbHNvIGJlIGFibGUgdG8g
cmVzZXJ2ZSBhIGRlZGljYXRlZCBwYXJ0aXRpb24gZm9yIHN0b3JpbmcgCnN1Y2gKbGFyZ2UgZmls
ZXMuCgo+Cj4gKFRlY2huaWNhbCBkZXRhaWw6IHN1Y2ggcGF0IE1VU1QgaW5jcmVhc2UgZG0tY3J5
cHQgbWlub3IgdmVyc2lvbi4pClRoYW5rcyBmb3IgcG9pbnRpbmcgdGhhdCBvdXQuIEkgYmVsaWV2
ZSB0aGF0IEkgY2FuIHByZXBhcmUgYSB2MiBwYXRjaCAKdGhhdCB3aWxsCmFkZHJlc3MgdGhhdCBp
c3N1ZS4KPgo+IE1pbGFuCj4KPj4KPj4gVGhpcyBwYXRjaCBjaGFuZ2VzIG1heGltdW0gc2VjdG9y
IHNpemUgZnJvbSA0MDk2IGJ5dGVzIHRvIFBBR0VfU0laRSwKPj4gYW5kIGluIGFkZGl0aW9uIGl0
IGNoYW5nZXMgdGhlIHR5cGUgb2Ygc2VjdG9yX3NpemUgaW4KPj4gc3RydWN0IGNyeXB0X2NvbmZp
ZyBmcm9tICd1bnNpZ25lZCBzaG9ydCBpbnQnIHRvICd1bnNpZ25lZCBpbnQnLCBpbgo+PiBvcmRl
ciB0byBiZSBhYmxlIHRvIHJlcHJlc2VudCBsYXJnZXIgdmFsdWVzLgo+Pgo+PiBPbiBhIHByb3Rv
dHlwZSBzeXN0ZW0gd2hpY2ggaGFzIFBBR0VfU0laRSBvZiA2NTUzNiBieXRlcywgSSBzYXcgYWJv
dXQKPj4geDIgcGVyZm9ybWFuY2UgaW1wcm92ZW1lbnQgaW4gc2VxdWVudGlhbCByZWFkIHRocm91
Z2hwdXQgYmVuY2htYXJrCj4+IHdoaWxlIHVzaW5nIG9ubHkgYWJvdXQgaGFsZiBvZiB0aGUgQ1BV
IHVzYWdlLCBhZnRlciBzaW1wbHkgaW5jcmVhc2luZwo+PiBzZWN0b3Igc2l6ZSBmcm9tIDQwOTYg
dG8gNjU1MzYgYnl0ZXMuCj4+IEkgdXNlZCBleHQ0IGZpbGVzeXN0ZW0gZm9yIHRoYXQgYmVuY2ht
YXJrLCB3aGljaCBzdXBwb3J0cyA2NEtpQgo+PiBzZWN0b3JzLgo+Pgo+PiBOb3RlOiBBIHNtYWxs
IGNoYW5nZSBzaG91bGQgYmUgbWFkZSBpbiBjcnlwdHNldHVwIGluIG9yZGVyIHRvIGFkZAo+PiBz
dXBwb3J0IGZvciBzZWN0b3JzIGxhcmdlciB0aGFuIDQwOTYgYnl0ZXMuCj4+Cj4+IFNpZ25lZC1v
ZmYtYnk6IEl0YWkgSGFuZGxlciA8aXRhaS5oYW5kbGVyQGdtYWlsLmNvbT4KPj4gLS0tCj4+IMKg
IGRyaXZlcnMvbWQvZG0tY3J5cHQuYyB8IDYgKysrLS0tCj4+IMKgIDEgZmlsZSBjaGFuZ2VkLCAz
IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCj4+Cj4+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L21kL2RtLWNyeXB0LmMgYi9kcml2ZXJzL21kL2RtLWNyeXB0LmMKPj4gaW5kZXggOTE2YjdkYTE2
ZGUyLi43OGMyMzk0NDNiZDUgMTAwNjQ0Cj4+IC0tLSBhL2RyaXZlcnMvbWQvZG0tY3J5cHQuYwo+
PiArKysgYi9kcml2ZXJzL21kL2RtLWNyeXB0LmMKPj4gQEAgLTE2OCw3ICsxNjgsNyBAQCBzdHJ1
Y3QgY3J5cHRfY29uZmlnIHsKPj4gwqDCoMKgwqDCoMKgwqDCoCB9IGl2X2dlbl9wcml2YXRlOwo+
PiDCoMKgwqDCoMKgwqDCoMKgIHU2NCBpdl9vZmZzZXQ7Cj4+IMKgwqDCoMKgwqDCoMKgwqAgdW5z
aWduZWQgaW50IGl2X3NpemU7Cj4+IC3CoMKgwqDCoMKgwqAgdW5zaWduZWQgc2hvcnQgaW50IHNl
Y3Rvcl9zaXplOwo+PiArwqDCoMKgwqDCoMKgIHVuc2lnbmVkIGludCBzZWN0b3Jfc2l6ZTsKPj4g
wqDCoMKgwqDCoMKgwqDCoCB1bnNpZ25lZCBjaGFyIHNlY3Rvcl9zaGlmdDsKPj4KPj4gwqDCoMKg
wqDCoMKgwqDCoCB1bmlvbiB7Cj4+IEBAIC0zMTE1LDkgKzMxMTUsOSBAQCBzdGF0aWMgaW50IGNy
eXB0X2N0cl9vcHRpb25hbChzdHJ1Y3QgZG1fdGFyZ2V0Cj4+ICp0aSwgdW5zaWduZWQgaW50IGFy
Z2MsIGNoYXIgKiphcgo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgY2MtPmNpcGhlcl9hdXRoID0ga3N0cmR1cChzdmFsLCBHRlBfS0VSTkVMKTsKPj4g
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlmICghY2Mt
PmNpcGhlcl9hdXRoKQo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiAtRU5PTUVNOwo+PiAtwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCB9IGVsc2UgaWYgKHNzY2FuZihvcHRfc3RyaW5nLCAic2VjdG9yX3Np
emU6JWh1JWMiLAo+PiAmY2MtPnNlY3Rvcl9zaXplLCAmZHVtbXkpID09IDEpIHsKPj4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfSBlbHNlIGlmIChzc2NhbmYob3B0X3N0cmluZywgInNl
Y3Rvcl9zaXplOiV1JWMiLAo+PiAmY2MtPnNlY3Rvcl9zaXplLCAmZHVtbXkpID09IDEpIHsKPj4g
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlmIChjYy0+
c2VjdG9yX3NpemUgPCAoMSA8PCBTRUNUT1JfU0hJRlQpIHx8Cj4+IC3CoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGNjLT5zZWN0b3Jfc2l6ZSA+IDQw
OTYgfHwKPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgY2MtPnNlY3Rvcl9zaXplID4gUEFHRV9TSVpFIHx8Cj4+IMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIChjYy0+c2VjdG9yX3NpemUg
JiAoY2MtPnNlY3Rvcl9zaXplIC0gCj4+IDEpKSkgewo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHRpLT5lcnJvciA9ICJJ
bnZhbGlkIGZlYXR1cmUgdmFsdWUgZm9yCj4+IHNlY3Rvcl9zaXplIjsKPj4gwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1
cm4gLUVJTlZBTDsKPj4KPgpJIGFwcHJlY2lhdGUgeW91ciB2YWx1YWJsZSBjb21tZW50cy4KCkl0
YWkKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8v
bGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=

