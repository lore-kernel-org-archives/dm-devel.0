Return-Path: <SRS0=owAl=EM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D45CC55ABD
	for <dm-devel@archiver.kernel.org>; Fri,  6 Nov 2020 01:05:55 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7C1252083B
	for <dm-devel@archiver.kernel.org>; Fri,  6 Nov 2020 01:05:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7C1252083B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-KqvSNcZSP6uKYh8XSX6agQ-1; Thu, 05 Nov 2020 20:05:51 -0500
X-MC-Unique: KqvSNcZSP6uKYh8XSX6agQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CC0B5805EF6;
	Fri,  6 Nov 2020 01:05:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AB1DC5B4C6;
	Fri,  6 Nov 2020 01:05:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C1699922E2;
	Fri,  6 Nov 2020 01:05:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A615hjt025997 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 5 Nov 2020 20:05:43 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id AE2A7207ABFC; Fri,  6 Nov 2020 01:05:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A8B4A2093CE3
	for <dm-devel@redhat.com>; Fri,  6 Nov 2020 01:05:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7D31C802D3D
	for <dm-devel@redhat.com>; Fri,  6 Nov 2020 01:05:41 +0000 (UTC)
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com
	[209.85.208.180]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-139-hbg165zPM9-ZEFAYL3i8lg-1; Thu, 05 Nov 2020 20:05:39 -0500
X-MC-Unique: hbg165zPM9-ZEFAYL3i8lg-1
Received: by mail-lj1-f180.google.com with SMTP id v18so1734219ljc.3
	for <dm-devel@redhat.com>; Thu, 05 Nov 2020 17:05:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc:content-transfer-encoding;
	bh=QUtUN9ch5Ywr+ak548yx4A85QWfe9zWlSITtypuRTf0=;
	b=f/uQa1+ncpLBvIWxmz73rA89HFw2GNCpT1pYIuNV5yE4ONvSk8QyKt4muKgSZh81e4
	Iyhhaq/ITbNFR7dkdVmcFo63z2nR7ASRmsAZgvdBfnC/Pf8rm1aIaqY5rAwBo7RTNpTa
	sMeww+X5j6tbyFVIvziYjAs/ACm7gJzwXFgOAeWLSf4i8s0jW7403GceQHAjgUckkCnf
	jPQ0F3CHuiDR09+UzeU+36YFyHJxt6ZNih+/fzvnDhzWoWCl35AdghJmB+P/IlK2iElm
	PirunAAZnQLGcaMlyE64w/kwZXxQ6zdYVzexbLgk3Zyh/TI3cBkFqpTphPELJ8x1l+d6
	FYwQ==
X-Gm-Message-State: AOAM533zEsD+Vp/PskKmAvRX2eQQONTGIUN8tu2eHlXYad6cAzaBrAo0
	iuNC3WB247fAWGdqlK/a3oDEHq32AVYy8NtL1+qWCUvll/0=
X-Google-Smtp-Source: ABdhPJw/FQ9/GH+iCRmMsq3P/NFi69VHW/avTWQNvIkFeh/kIBIxev743TKGItPI7P5mWi0qbyQmdqO5MOITOezKDT8=
X-Received: by 2002:a05:651c:104a:: with SMTP id
	x10mr1722960ljm.113.1604624737795; 
	Thu, 05 Nov 2020 17:05:37 -0800 (PST)
MIME-Version: 1.0
References: <83E54997-B7F0-4A47-94B0-54BA6EE7FE37@purestorage.com>
In-Reply-To: <83E54997-B7F0-4A47-94B0-54BA6EE7FE37@purestorage.com>
From: Roger Heflin <rogerheflin@gmail.com>
Date: Thu, 5 Nov 2020 19:05:26 -0600
Message-ID: <CAAMCDeckiKm0ed8dQGy84vaa-sWmYsyLdFJ5_Qf1xUEeVv+ZYw@mail.gmail.com>
To: Brian Bunker <brian@purestorage.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0A615hjt025997
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>
Subject: Re: [dm-devel] A device existing in two different multpath devices
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

WW91IG1pZ2h0IHRyeSBsaW1pdGVkIHVkZXYncyBjaGlsZHJlbiB0byBzYXkgNCByYXRoZXIgdGhh
biB0aGUKZGVmYXVsdCwgdGhlIGRlZmF1bHQgc2VlbXMgdG8gYmUgYmFzZWQgb24gc29tZSAlIG9m
IHRvdGFsIGNwdXMgKGl0CnNlZW1zIHRvIGNoYW5nZSBiYXNlZCBvbiB0aGUgdWRldiB2ZXJzaW9u
KSwgc28gaWYgdGhlIGNwdSBjb3VudHMgYXJlCmxhcmdlIHRoZW4gdGhlcmUgY2FuIGJlIGEgbGFy
Z2UgbnVtYmVyIG9mIGNoaWxkcmVuIHF1aWNrbHkgY3JlYXRlZC4gIEkKaGF2ZSBzZWVuIHRoZSB1
ZGV2IGNoaWxkcmVuIGlzc3VlIG9uIG1hY2hpbmVzIHRoYXQgaGF2ZSBhcm91bmQgNzAtMTAwCmNw
dXMgb3IgbW9yZSBhbmQgaHVnZSBudW1iZXJzIG9mIGx1bnMgKDEwMC0xMDAwJ3MpLCBidXQgaXQg
YWxzbyBzZWVtcwp0byBnZXQgbXVjaCB3b3JzZSBhdCBhIHNwZWNpZmljIE9TIHVwZGF0ZSAobm8g
aWRlYSB3aGljaCBvbmUgdGhhdAp3YXMpLiAgICBJdCBzcGF3bnMgdGhlIHByb2Nlc3NlcyBzbyBm
YXN0IHRoYXQgdGhlIG1hY2hpbmUgdXNlcwpleGNlc3NpdmUgY3B1IGJvdGggdXNlciBhbmQgc3lz
dGVtIHRpbWUsIGFuZCBkZXBlbmRpbmcgb24geW91ciBzY3NpCmxheWVyIHRpbWVvdXRzIHRoZSBy
ZXN1bHRpbmcgc3lzdGVtIHRpbWUgbWF5IGJlIHNpZ25pZmljYW50IGVub3VnaCB0bwpjYXVzZSBz
Y3NpIGxheWVyIGNvbW1hbmRzIHRvIHRpbWVvdXQuCgpJIGhhdmUgc2VlbiBsYXJnZXIgbWFjaGlu
ZXMgd2l0aCBhIGxvdCBvZiBsdW5zIGNyZWF0ZSBzbyBtYW55IGNoaWxkcmVuCnRoYXQgdGhlIG1h
Y2hpbmUgdGFrZXMgZXhjZXNzaXZlIHRpbWUgKHN5dGVtZCB0aW1lcyBvdXQgYW5kIGZhaWxzIHRv
CmZpbmQgVkcvTFYncyBpbiA5MCBzZWNvbmRzIGFuZCBnb2VzIHRvIGVtZXJnZW5jeSBtb2RlLCBh
bmQgYnkgdGhlIHRpbWUKd2UgZ2V0IHRvIHRoZSBwcm9tcHQgZXZlcnl0aGluZyBpcyBmaW5lKS4g
IFdlIGZpbmQgd2hlbiB0aGlzIGhhcHBlbnMKdGhhdCB1ZGV2IGNvbGxlY3RlZCBsaWtlIDgwKyBt
aW51dGVzIG9mIGNwdSB0aW1lIGluIDkwIHNlY29uZHMgaXQKdGFrZXMgdG8gYm9vdC4gICBUdXJu
aW5nIHRoZSBjaGlsZHJlbiBkb3duIGFjdHVhbGx5IHJlc3VsdGVkIGluIG11Y2gKZmFzdGVyIGFu
ZCBjb25zaXN0ZW50IGJvb3RzLiAgIEkgaGF2ZSBub3Qgbm90aWNlZCBhIHVkZXYgcHJvY2Vzcwpn
ZXR0aW5nIGFuIGVycm9yIG9yIGNhdXNpbmcgc29tZXRoaW5nIGxpa2UgeW91IGFyZSBzZWVpbmcs
IGJ1dCBpZgplbm91Z2ggcHJvY2VzcyBnZXRzIHNwYXduZWQgY2F1c2luZyBleGNlc3NpdmUgc3lz
dGVtIHRpbWUgaXQgY291bGQKY2F1c2UgdGltZW91dHMgaW4gdGhlIGtlcm5lbCBzdWJzeXN0ZW1z
IHRoYXQgaGF2ZSB0aW1lb3V0cy4KCnBzIGF4dXd3UyB8IGdyZXAgLWkgdWRldgp3aWxsIHNob3cg
eW91IHRoZSB0b3RhbCB0aW1lIHVkZXYgYW5kIGFsbCBvZiBpdHMgZXhpdGVkIGNoaWxkcmVuCmNv
bGxlY3RlZCBkdXJpbmcgYm9vdC4gIElmIHRoZSBudW1iZXIgaXMgbGFyZ2UgaW4gdGhlIHNob3J0
IHRpbWUgaXQKdGFrZSB0byBib290IHRoZXJlIGlzIG1hc3NpdmUgY29udGVudGlvbi4KCk9uIFdl
ZCwgTm92IDQsIDIwMjAgYXQgODozMyBQTSBCcmlhbiBCdW5rZXIgPGJyaWFuQHB1cmVzdG9yYWdl
LmNvbT4gd3JvdGU6Cj4KPiBIZWxsbyBhbGwsCj4KPiBXZSBoYXZlIHJ1biBpbnRvIHNpdHVhdGlv
bnMgaW50ZXJuYWxseSB3aGVyZSB3ZSBlbmQgdXAgd2l0aCBTQ1NJIGRldmljZXMgZW5kaW5nIHVw
IGluIHR3byBtdWx0aXBhdGggZGV2aWNlczoKPgo+IDM2MjRhOTM3MGMwNzg3NzEwMmIxNDM2OTkw
MDAxMWZkMSBkbS05IFBVUkUgICAgLEZsYXNoQXJyYXkKPiBzaXplPTUwMEcgZmVhdHVyZXM9JzAn
IGh3aGFuZGxlcj0nMSBhbHVhJyB3cD1ydwo+IGAtKy0gcG9saWN5PSdzZXJ2aWNlLXRpbWUgMCcg
cHJpbz01MCBzdGF0dXM9YWN0aXZlCj4gICB8LSAwOjA6MDo2ICBzZGVnIDEyODoxMjggYWN0aXZl
IHJlYWR5IHJ1bm5pbmcKPiAgIHwtIDA6MDoxOjYgIHNkZXEgMTI5OjMyICBhY3RpdmUgcmVhZHkg
cnVubmluZwo+ICAgfC0gMDowOjI6NiAgc2RmYSAxMjk6MTkyIGFjdGl2ZSByZWFkeSBydW5uaW5n
Cj4gICB8LSA3OjA6MDo2ICBzZHggIDY1OjExMiAgYWN0aXZlIHJlYWR5IHJ1bm5pbmcKPiAgIHwt
IDc6MDoxOjYgIHNkYWggNjY6MTYgICBhY3RpdmUgcmVhZHkgcnVubmluZwo+ICAgfC0gNzowOjI6
NiAgc2RjaSA2OTo5NiAgIGFjdGl2ZSByZWFkeSBydW5uaW5nCj4gICB8LSA3OjA6Mzo2ICBzZG4g
IDg6MjA4ICAgYWN0aXZlIHJlYWR5IHJ1bm5pbmcKPiAgIHwtIDg6MDowOjYgIHNkYmIgNjc6ODAg
ICBhY3RpdmUgcmVhZHkgcnVubmluZwo+ICAgfC0gODowOjE6NiAgc2RidCA2ODoxMTIgIGFjdGl2
ZSByZWFkeSBydW5uaW5nCj4gICB8LSA4OjA6Mjo2ICBzZGN4IDcwOjgwICAgYWN0aXZlIHJlYWR5
IHJ1bm5pbmcKPiAgIHwtIDg6MDozOjYgIHNkYXIgNjY6MTc2ICBhY3RpdmUgcmVhZHkgcnVubmlu
Zwo+ICAgfC0gOTowOjA6NiAgc2RkaiA3MToxNiAgIGFjdGl2ZSByZWFkeSBydW5uaW5nCj4gICB8
LSA5OjA6MTo2ICBzZGNxIDY5OjIyNCAgYWN0aXZlIHJlYWR5IHJ1bm5pbmcKPiAgIHwtIDk6MDoy
OjYgIHNkZHQgNzE6MTc2ICBhY3RpdmUgcmVhZHkgcnVubmluZwo+ICAgfC0gOTowOjM6NiAgc2Ri
byA2ODozMiAgIGFjdGl2ZSByZWFkeSBydW5uaW5nCj4gICBgLSAwOjA6Mzo2ICBzZGcgIDg6OTYg
ICAgYWN0aXZlIHJlYWR5IHJ1bm5pbmcKPgo+IEFuZCB0aGlzIG9uZToKPiBTUFVSRV9GbGFzaEFy
cmF5X0MwNzg3NzEwMkIxNDM2OTkwMDAxMUZEMSBkbS0xMyBQVVJFICAgICxGbGFzaEFycmF5Cj4g
c2l6ZT01MDBHIGZlYXR1cmVzPScwJyBod2hhbmRsZXI9JzEgYWx1YScgd3A9cncKPiBgLSstIHBv
bGljeT0nc2VydmljZS10aW1lIDAnIHByaW89NTAgc3RhdHVzPWFjdGl2ZQo+ICAgYC0gMDowOjM6
NiAgc2RnICA4Ojk2ICAgIGFjdGl2ZSByZWFkeSBydW5uaW5nCj4KPiBXaGF0IHRoaXMgY29tZXMg
ZG93biB0byBzZWVtcyB0byBsaWUgd2l0aCB0aGUgc2NzaV9pZCBhcHBsaWNhdGlvbiBpbmNsdWRl
ZCBpbmNsdWRlZCB3aXRoIHVkZXYuIFRoaXMgcnVucyBvdXQgb2YgYSB1ZGV2IHJ1bGUgd2hlbiBT
Q1NJIGRldmljZXMgYXJlIGRpc2NvdmVyZWQuIFdoYXQgaGFwcGVucyBzZWVtcyB0byBiZSBhIGZh
aWx1cmUgaW4gcGFnZSAweDgzIElOUVVJUlkgaW4gZ2V0dGluZyB0aGUgc2VyaWFsIG51bWJlciBv
ZiB0aGUgZGV2aWNlIHRvIHVzZSBpbiBtdWx0aXBhdGguCj4KPiBXaGVuIHBhZ2UgMHg4MyBJTlFV
SVJZIGZhaWxzLCBpbnN0ZWFkIG9mIGdldHRpbmcgdGhlIGV4cGVjdGVkIDM2MjRhOTM3MGMwNzg3
NzEwMmIxNDM2OTkwMDAxMWZkMSBpdCBmYWxscyBiYWNrIHRvIGEgcGFnZSAweDgwIElOUVVJUlkg
d2hlcmUgaXQgc3RpdGNoZXMgdG9nZXRoZXIg4oCZU+KAmSArIHZlbmRvciBuYW1lICsgbW9kZWwg
bmFtZSArIExVTiBzZXJpYWwgbnVtYmVyIGFuZCB3ZSBlbmQgdXAgd2l0aCB0aGlzIFNQVVJFX0Zs
YXNoQXJyYXlfQzA3ODc3MTAyQjE0MzY5OTAwMDExRkQxLgo+Cj4gQSBxdWljayBsb29rIHNob3dz
IHRoYXQgdGhlIExVTiBzZXJpYWwgbnVtYmVyIGluIGJvdGggY2FzZXMgaXMgdGhlIHNhbWUsIEMw
Nzg3NzEwMkIxNDM2OTkwMDAxMUZEMS4gV2UgZW5kIHVwIHdpdGggdHdvIG11bHRpcGF0aCBkZXZp
Y2VzIHNpbmNlIHRoZSBuYW1lIG11bHRpcGF0aCB1c2VzIGlzIG5vdCB0aGUgc2FtZS4gSSBjYW4g
Y3JlYXRlIHRoZSBzaXR1YXRpb24gbWFudWFsbHkgYnkgcmVzY2FubmluZyBhdCBqdXN0IHRoZSBy
aWdodCB0aW1lIGZvcmNpbmcgdGhlIHBhZ2UgMHg4MyBJTlFVSVJZIHRvIGZhaWwgd2hlbiBtYW51
YWxseSBydW5uaW5nIHNjc2lfaWQuIEkgYXNzdW1lIHRoYXQgdGhpcyBpcyB3aGF0IGhhcHBlbnMg
YXMgdGhlIGRldmljZXMgYXJyaXZlIGFuZCB0aGUgdWRldiBydWxlIHJ1bnMgYmFzZWQgb24gdGhl
IG5hbWUuIEkgYW0gbm90IGV4YWN0bHkgc3VyZSB3aGVyZSBpbiB0aGUgY2hhaW4gdG8gYmxhbWUg
Zm9yIHRoZSBjcmVhdGlvbiBvZiB0aGUgdHdvIG11bHRpcGF0aCBkZXZpY2VzLiBJIGFtIG5vdCBz
dXJlIHRoYXQgbXVsdGlwYXRoIGlzIG5vdCBqdXN0IHRoZSB2aWN0aW0gb2YgdWRldiwgYnV0IEkg
ZXhwZWN0IHRoYXQgdGhpcyBiZWhhdmlvciBpcyBub3Qgd2hhdCBtdWx0aXBhdGggd291bGQgZXZl
ciB3YW50IHRvIGRvIHNpbmNlIGl0IGlzIGEgY2VydGFpbiBjb3JydXB0aW9uIHdoZW4gaXQgaGFw
cGVucy4KPgo+IEFueSBpZGVhcyBvciBpbnNpZ2h0IG9uIHdoYXQgY291bGQga2VlcCB1cyBvdXQg
b2YgdGhpcyBzaXR1YXRpb24gd291bGQgYmUgYXBwcmVjaWF0ZWQuCj4KPiBUaGFua3MsCj4gQnJp
YW4KPgo+IEJyaWFuIEJ1bmtlcgo+IFNXIEVuZwo+IGJyaWFuQHB1cmVzdG9yYWdlLmNvbQo+Cj4K
Pgo+Cj4gLS0KPiBkbS1kZXZlbCBtYWlsaW5nIGxpc3QKPiBkbS1kZXZlbEByZWRoYXQuY29tCj4g
aHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCgoKLS0KZG0t
ZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly93d3cucmVkaGF0
LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs

