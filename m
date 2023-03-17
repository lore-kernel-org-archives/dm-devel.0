Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15A5EC74A5B
	for <dm-devel@archiver.kernel.org>; Fri, 17 Mar 2023 21:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679088576;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6YR/BT8zCoXYKRgunhrw65gQc+Go41l2qpoqvN+OYv8=;
	b=DIfz+eQAmlingp6TEyXkSOPKNxUxKyfUOVRqS4MV+EIWgtU88WdWJmhQ1JWpQ9+lM0Y97A
	Wy7IINwjriaRasaY4/S85DL6xqLSDKpT9+kr1j/hgnhxb7WykFQDlvMQ2ocBVP0W1n314v
	SIlMy23iApZxYGNxjP4T3d0vMxH4SRU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-434-qcjoNG5vNRWHSi5iultEKQ-1; Fri, 17 Mar 2023 17:29:33 -0400
X-MC-Unique: qcjoNG5vNRWHSi5iultEKQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AC436380606C;
	Fri, 17 Mar 2023 21:29:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EC8D0140E960;
	Fri, 17 Mar 2023 21:29:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CCEC01946A46;
	Fri, 17 Mar 2023 21:29:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0F47D19466DF
 for <dm-devel@listman.corp.redhat.com>; Fri, 17 Mar 2023 21:29:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A36CAC15BAD; Fri, 17 Mar 2023 21:29:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9BC23C15BA0
 for <dm-devel@redhat.com>; Fri, 17 Mar 2023 21:29:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7F75B855304
 for <dm-devel@redhat.com>; Fri, 17 Mar 2023 21:29:27 +0000 (UTC)
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com
 [209.85.160.181]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-635-nDiu6hD3MMG_ZfsqrYowng-1; Fri, 17 Mar 2023 17:29:25 -0400
X-MC-Unique: nDiu6hD3MMG_ZfsqrYowng-1
Received: by mail-qt1-f181.google.com with SMTP id fy17so4583180qtb.2
 for <dm-devel@redhat.com>; Fri, 17 Mar 2023 14:29:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679088565;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=74hpKbybG/zGoZI9G2CYpMbOVE4AuEECFGt5DlMCgIs=;
 b=GmZWg6gKK9rALYxO1Ymm1H0hZsWI400oV475/317qQjacUAZV20tGE+XzXjRnIDokd
 cOVZIiYmZ4jO3foyN7q9RN/nBusnhaiJtecJHWmeMNh6swlySZ2Wi6Z1XMq4iRq9sFtn
 vYc834IA5T9WbvMrUcjUsSkj5xz1MFZKqxpUyMTN3/0AWaDWbWwohOhfolDywE1d6wu3
 RXyEoiqw4D95GN0VZA/1rF2Dsqf28yukNWBuFLPTbmBohBckRWHSYcRT4JDWKEhtEUnW
 jOuaYAQhw1g0psMvZ1PomC1rxaYAxcBBdc86AO5GRDHSqrGW4JX7ihMZ57I2v0tB0Ws2
 Ka6w==
X-Gm-Message-State: AO0yUKV+4BxtUhv2vpxWwC/9X4ctkrHuvtkB8XpTUWfKuq2WdfFD+8FU
 Sp35prZq+U1nvi0UcCHj1VH/hY4=
X-Google-Smtp-Source: AK7set9ZLKSM6EiLDPWzjcge7jruT1aFdqM8FlQ+ab7okXXatbx/IBhdTJ9xFEiPkivpMASpdzXRwA==
X-Received: by 2002:ac8:5e51:0:b0:3d6:88a0:7a5 with SMTP id
 i17-20020ac85e51000000b003d688a007a5mr15348985qtx.37.1679088565343; 
 Fri, 17 Mar 2023 14:29:25 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 a72-20020ae9e84b000000b00745a3b63569sm2377074qkg.107.2023.03.17.14.29.24
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 17 Mar 2023 14:29:24 -0700 (PDT)
Date: Fri, 17 Mar 2023 17:29:23 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Michael =?iso-8859-1?Q?Wei=DF?= <michael.weiss@aisec.fraunhofer.de>
Message-ID: <ZBTbsx69kGXiKMIw@redhat.com>
References: <20230301113415.47664-1-michael.weiss@aisec.fraunhofer.de>
 <CAHC9VhQ_zvTqck4A7HvqH2rcwxuato_9nVWMk_Yf=ip3q9omgA@mail.gmail.com>
 <1f58acef-1e93-ed7a-3ad8-dd0927dacddc@aisec.fraunhofer.de>
MIME-Version: 1.0
In-Reply-To: <1f58acef-1e93-ed7a-3ad8-dd0927dacddc@aisec.fraunhofer.de>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] dm verity: log audit events for dm-verity target
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
Cc: Paul Moore <paul@paul-moore.com>, gyroidos@aisec.fraunhofer.de,
 Richard Guy Briggs <rgb@redhat.com>, open list <linux-kernel@vger.kernel.org>,
 Eric Paris <eparis@redhat.com>,
 "open list:AUDIT SUBSYSTEM" <audit@vger.kernel.org>,
 "maintainer:DEVICE-MAPPER \(LVM\)" <dm-devel@redhat.com>,
 Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gRnJpLCBNYXIgMTcgMjAyMyBhdCAgNDowMFAgLTA0MDAsCk1pY2hhZWwgV2Vpw58gPG1pY2hh
ZWwud2Vpc3NAYWlzZWMuZnJhdW5ob2Zlci5kZT4gd3JvdGU6Cgo+IE9uIDAyLjAzLjIzIDAzOjI1
LCBQYXVsIE1vb3JlIHdyb3RlOgo+ID4gT24gV2VkLCBNYXIgMSwgMjAyMyBhdCA2OjM04oCvQU0g
TWljaGFlbCBXZWnDnwo+ID4gPG1pY2hhZWwud2Vpc3NAYWlzZWMuZnJhdW5ob2Zlci5kZT4gd3Jv
dGU6Cj4gPj4KPiA+PiBkbS12ZXJpdHkgc2lnbmFscyBpbnRlZ3JpdHkgdmlvbGF0aW9ucyBieSBy
ZXR1cm5pbmcgSS9PIGVycm9ycwo+ID4+IHRvIHVzZXIgc3BhY2UuIFRvIGlkZW50aWZ5IGludGVn
cml0eSB2aW9sYXRpb25zIGJ5IGEgY29udHJvbGxpbmcKPiA+PiBpbnN0YW5jZSwgdGhlIGtlcm5l
bCBhdWRpdCBzdWJzeXN0ZW0gY2FuIGJlIHVzZWQgdG8gZW1pdCBhdWRpdAo+ID4+IGV2ZW50cyB0
byB1c2VyIHNwYWNlLiBBbmFsb2dvdXMgdG8gZG0taW50ZWdyaXR5LCB3ZSBhbHNvIHVzZSB0aGUK
PiA+PiBkbS1hdWRpdCBzdWJtb2R1bGUgYWxsb3dpbmcgdG8gZW1pdCBhdWRpdCBldmVudHMgb24g
dmVyaWZpY2F0aW9uCj4gPj4gZmFpbHVyZXMgb2YgbWV0YWRhdGEgYW5kIGRhdGEgYmxvY2tzIGFz
IHdlbGwgYXMgaWYgbWF4IGNvcnJ1cHRlZAo+ID4+IGVycm9ycyBhcmUgcmVhY2hlZC4KPiA+Pgo+
ID4+IFRoZSBjb25zdHJ1Y3Rpb24gYW5kIGRlc3RydWN0aW9uIG9mIHZlcml0eSBkZXZpY2UgbWFw
cGluZ3MgYXJlCj4gPj4gYWxzbyByZWxldmFudCBmb3IgYXVkaXRpbmcgYSBzeXN0ZW0uIFRodXMs
IHRob3NlIGV2ZW50cyBhcmUgYWxzbwo+ID4+IGxvZ2dlZCBhcyBhdWRpdCBldmVudHMuCj4gPj4K
PiA+PiBXZSB0ZXN0ZWQgdGhpcyBieSBzdGFydGluZyBhIGNvbnRhaW5lciB3aXRoIHRoZSBjb250
YWluZXIgbWFuYWdlcgo+ID4+IChjbWxkKSBvZiBHeXJvaWRPUyB3aGljaCB1c2VzIGEgZG0tdmVy
aXR5IHByb3RlY3RlZCByb290ZnMgaW1hZ2UKPiA+PiByb290LmltZyBtYXBwZWQgdG8gL2Rldi9t
YXBwZXIvPHV1aWQ+LXJvb3QuIFdlIHRoYW4gbWFuaXB1bGF0ZWQKPiA+PiBvbmUgYmxvY2sgaW4g
dGhlIHVuZGVybHlpbmcgaW1hZ2UgZmlsZSBhbmQgcmVhZGluZyBpdCBmcm9tIHRoZQo+ID4+IHBy
b3RlY3RlZCBtYXBwZXIgZGV2aWNlIGFnYWluIGFuZCBhZ2FpbiB1bnRpbCB3ZSByZWFjaCB0aGUg
bWF4Cj4gPj4gY29ycnVwdGVkIGVycm9ycyBsaWtlIHRoaXM6Cj4gPj4KPiA+PiAgIGRkIGlmPS9k
ZXYvdXJhbmRvbSBvZj1yb290LmltZyBicz01MTIgY291bnQ9MSBzZWVrPTEwMDAKPiA+PiAgIGZv
ciBpIGluIHJhbmdlIHsxLi4xMDF9OyBkbyBcCj4gPj4gICAgIGRkIGlmPS9kZXYvbWFwcGVyLzx1
dWlkPi1yb290IG9mPS9kZXYvbnVsbCBicz00MDk2IFwKPiA+PiAgICAgICAgY291bnQ9MSBza2lw
PTEwMDAgXAo+ID4+ICAgZG9uZQo+ID4+Cj4gPj4gVGhlIHJlc3VsdGluZyBhdWRpdCBsb2cgbG9v
a3MgYXMgZm9sbG93czoKPiA+Pgo+ID4+ICAgdHlwZT1ETV9DVFJMIG1zZz1hdWRpdCgxNjc3NjE4
NzkxLjg3Njo5NjIpOgo+ID4+ICAgICBtb2R1bGU9dmVyaXR5IG9wPWN0ciBwcGlkPTQ4NzYgcGlk
PTI5MTAyIGF1aWQ9MCB1aWQ9MCBnaWQ9MAo+ID4+ICAgICBldWlkPTAgc3VpZD0wIGZzdWlkPTAg
ZWdpZD0wIHNnaWQ9MCBmc2dpZD0wIHR0eT0obm9uZSkgc2VzPTQ0Cj4gPj4gICAgIGNvbW09ImNt
bGQiIGV4ZT0iL3Vzci9zYmluL2NtbC9jbWxkIiBzdWJqPXVuY29uZmluZWQKPiA+PiAgICAgZGV2
PTI1NDozIGVycm9yX21zZz0nc3VjY2VzcycgcmVzPTEKPiA+Pgo+ID4+ICAgdHlwZT1ETV9FVkVO
VCBtc2c9YXVkaXQoMTY3NzYxOTQ2My43ODY6MTA3NCk6IG1vZHVsZT12ZXJpdHkKPiA+PiAgICAg
b3A9dmVyaWZ5LWRhdGEgZGV2PTc6MCBzZWN0b3I9MTAwMCByZXM9MAo+ID4+ICAgLi4uCj4gPj4g
ICB0eXBlPURNX0VWRU5UIG1zZz1hdWRpdCgxNjc3NjE5NTk2LjcyNzoxMTYyKTogbW9kdWxlPXZl
cml0eQo+ID4+ICAgICBvcD12ZXJpZnktZGF0YSBkZXY9NzowIHNlY3Rvcj0xMDAwIHJlcz0wCj4g
Pj4KPiA+PiAgIHR5cGU9RE1fRVZFTlQgbXNnPWF1ZGl0KDE2Nzc2MTk1OTYuNzMxOjExNjMpOiBt
b2R1bGU9dmVyaXR5Cj4gPj4gICAgIG9wPW1heC1jb3JydXB0ZWQtZXJyb3JzIGRldj0yNTQ6MyBz
ZWN0b3I9PyByZXM9MAo+ID4+Cj4gPj4gU2lnbmVkLW9mZi1ieTogTWljaGFlbCBXZWnDnyA8bWlj
aGFlbC53ZWlzc0BhaXNlYy5mcmF1bmhvZmVyLmRlPgo+ID4+IC0tLQo+ID4+ICBkcml2ZXJzL21k
L2RtLXZlcml0eS10YXJnZXQuYyB8IDIwICsrKysrKysrKysrKysrKysrKy0tCj4gPj4gIDEgZmls
ZSBjaGFuZ2VkLCAxOCBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQo+ID4gCj4gPiBUaGlz
IGxvb2tzIHJlYXNvbmFibGUgdG8gbWUgZnJvbSBhbiBhdWRpdCBwZXJzcGVjdGl2ZS4KPiA+IAo+
ID4gQWNrZWQtYnk6IFBhdWwgTW9vcmUgPHBhdWxAcGF1bC1tb29yZS5jb20+Cj4gCj4gSGkgTWlr
ZSwgc2luY2UgUGF1bCBhbHJlYWR5IGdhdmUgaGlzIGFjayBmcm9tIGF1ZGl0IHBlcnNwZWN0aXZl
LAo+IGRvIHlvdSBwaWNrIHRoaXMgdXA/IE9yIGlzIHRoZXJlIGFueXRoaW5nIHdoaWNoIEkgY2Fu
IGltcHJvdmUgZnJvbSBkZXZpY2UKPiBtYXBwZXIgc2lkZT8KCkxvb2tzIGZpbmUsIGJ1dCBJIGhh
dmVuJ3Qgc3RhcnRlZCBhIDYuNCBicmFuY2ggeWV0LiBJJ2xsIHBpY2sgdGhpcyB1cApmcm9tIGRt
LWRldmVsJ3MgcGF0Y2h3b3JrIHdoZW4gSSBkby4KCk1pa2UKCi0tCmRtLWRldmVsIG1haWxpbmcg
bGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxt
YW4vbGlzdGluZm8vZG0tZGV2ZWwK

