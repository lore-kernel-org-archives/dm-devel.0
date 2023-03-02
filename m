Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33DC7C7EE23
	for <dm-devel@archiver.kernel.org>; Thu,  2 Mar 2023 02:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677723974;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6XeiFofwkGCO+nPNB8eDdgiLmuhbttFzcDOGeBR3XIc=;
	b=ZOPbqkFZlf+6I5vPo8juXwHL9VKapenGemrl/NWmV7uWohjOIQEdd28WIjA4ra2CGXwB8k
	8tdqtbXSX0ORK7DgHFKj2l+VVnxZ6C5tA05Urd24M54sIY/dBSDf4GO3v1UcOnoNbBpClI
	/1VyfMXTu6FC2MQ/g3ZzrGlSQVRWSSM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-324-wsBMP0roNQqWR9OkUX6ebA-1; Wed, 01 Mar 2023 21:26:10 -0500
X-MC-Unique: wsBMP0roNQqWR9OkUX6ebA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C21951C17433;
	Thu,  2 Mar 2023 02:26:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 670F12166B2B;
	Thu,  2 Mar 2023 02:26:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 40A6119452CD;
	Thu,  2 Mar 2023 02:26:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A1B3B19472FC
 for <dm-devel@listman.corp.redhat.com>; Thu,  2 Mar 2023 02:26:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 83A2F2026D68; Thu,  2 Mar 2023 02:26:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7B7E72026D4B
 for <dm-devel@redhat.com>; Thu,  2 Mar 2023 02:26:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5C2F6101AA63
 for <dm-devel@redhat.com>; Thu,  2 Mar 2023 02:26:06 +0000 (UTC)
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com
 [209.85.214.179]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-371-Y9d7jd4GMX6FBq4xJhU2rQ-1; Wed, 01 Mar 2023 21:26:04 -0500
X-MC-Unique: Y9d7jd4GMX6FBq4xJhU2rQ-1
Received: by mail-pl1-f179.google.com with SMTP id h8so12786692plf.10
 for <dm-devel@redhat.com>; Wed, 01 Mar 2023 18:26:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1677723964;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=5kZhp2tKo46U38ss1g+Tr12yiIRs24hB+InVptDfZko=;
 b=dvLVGQ2+NB2+NIFad7how9WmjS4He94p7kAKfKza1fAh0JDfCHiQhA5AfCs+NGZKHM
 QWESw0xKNPMX4XRLKsyy854Rhw4iw7jZu26aDIuuGK+tn2W0nsFoJ+wuIRwVuOSFjOOJ
 peGo81P97EugH+fza1W5H4mLaSYEe1ESvM/xNFHLIw+xwsjhJwJj9vChz7ofYEW/UK+B
 Mu7gwpZIvAaGIysz7T8A3BTTWQHXnUuUTuAlIRXPe096oBBgxKt2Xg0kk1RYKUCSl90l
 oTFnrRUTSZHyYax54eSW75Ui65Iwq6wTV5golFMbBlvJb3ZjykMtKIlL5gCqhoiYCg1d
 IxKg==
X-Gm-Message-State: AO0yUKVCI4yfqn62ISW/Zltia8TseHXxr4QAL6nHutJUxuf3LCLaRFJI
 8ydRF5w7alVJsczoAoNBuDHAOvfK6mX20FRJXunn
X-Google-Smtp-Source: AK7set9WUw3+7nNvCV3Bh3Gll8iuNqsjHAmQe9Tu1euD/45Z6kjZ9of1ysLgcadbAHHlepgnWkqpZweQJ53NX5QDgk0=
X-Received: by 2002:a17:903:2587:b0:19a:80b9:78ce with SMTP id
 jb7-20020a170903258700b0019a80b978cemr250097plb.0.1677723963655; Wed, 01 Mar
 2023 18:26:03 -0800 (PST)
MIME-Version: 1.0
References: <20230301113415.47664-1-michael.weiss@aisec.fraunhofer.de>
In-Reply-To: <20230301113415.47664-1-michael.weiss@aisec.fraunhofer.de>
From: Paul Moore <paul@paul-moore.com>
Date: Wed, 1 Mar 2023 21:25:52 -0500
Message-ID: <CAHC9VhQ_zvTqck4A7HvqH2rcwxuato_9nVWMk_Yf=ip3q9omgA@mail.gmail.com>
To: =?UTF-8?Q?Michael_Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH] dm verity: log audit events for dm-verity
 target
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
Cc: gyroidos@aisec.fraunhofer.de, Richard Guy Briggs <rgb@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 Eric Paris <eparis@redhat.com>,
 "open list:AUDIT SUBSYSTEM" <audit@vger.kernel.org>,
 "maintainer:DEVICE-MAPPER \(LVM\)" <dm-devel@redhat.com>,
 Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gV2VkLCBNYXIgMSwgMjAyMyBhdCA2OjM04oCvQU0gTWljaGFlbCBXZWnDnwo8bWljaGFlbC53
ZWlzc0BhaXNlYy5mcmF1bmhvZmVyLmRlPiB3cm90ZToKPgo+IGRtLXZlcml0eSBzaWduYWxzIGlu
dGVncml0eSB2aW9sYXRpb25zIGJ5IHJldHVybmluZyBJL08gZXJyb3JzCj4gdG8gdXNlciBzcGFj
ZS4gVG8gaWRlbnRpZnkgaW50ZWdyaXR5IHZpb2xhdGlvbnMgYnkgYSBjb250cm9sbGluZwo+IGlu
c3RhbmNlLCB0aGUga2VybmVsIGF1ZGl0IHN1YnN5c3RlbSBjYW4gYmUgdXNlZCB0byBlbWl0IGF1
ZGl0Cj4gZXZlbnRzIHRvIHVzZXIgc3BhY2UuIEFuYWxvZ291cyB0byBkbS1pbnRlZ3JpdHksIHdl
IGFsc28gdXNlIHRoZQo+IGRtLWF1ZGl0IHN1Ym1vZHVsZSBhbGxvd2luZyB0byBlbWl0IGF1ZGl0
IGV2ZW50cyBvbiB2ZXJpZmljYXRpb24KPiBmYWlsdXJlcyBvZiBtZXRhZGF0YSBhbmQgZGF0YSBi
bG9ja3MgYXMgd2VsbCBhcyBpZiBtYXggY29ycnVwdGVkCj4gZXJyb3JzIGFyZSByZWFjaGVkLgo+
Cj4gVGhlIGNvbnN0cnVjdGlvbiBhbmQgZGVzdHJ1Y3Rpb24gb2YgdmVyaXR5IGRldmljZSBtYXBw
aW5ncyBhcmUKPiBhbHNvIHJlbGV2YW50IGZvciBhdWRpdGluZyBhIHN5c3RlbS4gVGh1cywgdGhv
c2UgZXZlbnRzIGFyZSBhbHNvCj4gbG9nZ2VkIGFzIGF1ZGl0IGV2ZW50cy4KPgo+IFdlIHRlc3Rl
ZCB0aGlzIGJ5IHN0YXJ0aW5nIGEgY29udGFpbmVyIHdpdGggdGhlIGNvbnRhaW5lciBtYW5hZ2Vy
Cj4gKGNtbGQpIG9mIEd5cm9pZE9TIHdoaWNoIHVzZXMgYSBkbS12ZXJpdHkgcHJvdGVjdGVkIHJv
b3RmcyBpbWFnZQo+IHJvb3QuaW1nIG1hcHBlZCB0byAvZGV2L21hcHBlci88dXVpZD4tcm9vdC4g
V2UgdGhhbiBtYW5pcHVsYXRlZAo+IG9uZSBibG9jayBpbiB0aGUgdW5kZXJseWluZyBpbWFnZSBm
aWxlIGFuZCByZWFkaW5nIGl0IGZyb20gdGhlCj4gcHJvdGVjdGVkIG1hcHBlciBkZXZpY2UgYWdh
aW4gYW5kIGFnYWluIHVudGlsIHdlIHJlYWNoIHRoZSBtYXgKPiBjb3JydXB0ZWQgZXJyb3JzIGxp
a2UgdGhpczoKPgo+ICAgZGQgaWY9L2Rldi91cmFuZG9tIG9mPXJvb3QuaW1nIGJzPTUxMiBjb3Vu
dD0xIHNlZWs9MTAwMAo+ICAgZm9yIGkgaW4gcmFuZ2UgezEuLjEwMX07IGRvIFwKPiAgICAgZGQg
aWY9L2Rldi9tYXBwZXIvPHV1aWQ+LXJvb3Qgb2Y9L2Rldi9udWxsIGJzPTQwOTYgXAo+ICAgICAg
ICBjb3VudD0xIHNraXA9MTAwMCBcCj4gICBkb25lCj4KPiBUaGUgcmVzdWx0aW5nIGF1ZGl0IGxv
ZyBsb29rcyBhcyBmb2xsb3dzOgo+Cj4gICB0eXBlPURNX0NUUkwgbXNnPWF1ZGl0KDE2Nzc2MTg3
OTEuODc2Ojk2Mik6Cj4gICAgIG1vZHVsZT12ZXJpdHkgb3A9Y3RyIHBwaWQ9NDg3NiBwaWQ9Mjkx
MDIgYXVpZD0wIHVpZD0wIGdpZD0wCj4gICAgIGV1aWQ9MCBzdWlkPTAgZnN1aWQ9MCBlZ2lkPTAg
c2dpZD0wIGZzZ2lkPTAgdHR5PShub25lKSBzZXM9NDQKPiAgICAgY29tbT0iY21sZCIgZXhlPSIv
dXNyL3NiaW4vY21sL2NtbGQiIHN1Ymo9dW5jb25maW5lZAo+ICAgICBkZXY9MjU0OjMgZXJyb3Jf
bXNnPSdzdWNjZXNzJyByZXM9MQo+Cj4gICB0eXBlPURNX0VWRU5UIG1zZz1hdWRpdCgxNjc3NjE5
NDYzLjc4NjoxMDc0KTogbW9kdWxlPXZlcml0eQo+ICAgICBvcD12ZXJpZnktZGF0YSBkZXY9Nzow
IHNlY3Rvcj0xMDAwIHJlcz0wCj4gICAuLi4KPiAgIHR5cGU9RE1fRVZFTlQgbXNnPWF1ZGl0KDE2
Nzc2MTk1OTYuNzI3OjExNjIpOiBtb2R1bGU9dmVyaXR5Cj4gICAgIG9wPXZlcmlmeS1kYXRhIGRl
dj03OjAgc2VjdG9yPTEwMDAgcmVzPTAKPgo+ICAgdHlwZT1ETV9FVkVOVCBtc2c9YXVkaXQoMTY3
NzYxOTU5Ni43MzE6MTE2Myk6IG1vZHVsZT12ZXJpdHkKPiAgICAgb3A9bWF4LWNvcnJ1cHRlZC1l
cnJvcnMgZGV2PTI1NDozIHNlY3Rvcj0/IHJlcz0wCj4KPiBTaWduZWQtb2ZmLWJ5OiBNaWNoYWVs
IFdlacOfIDxtaWNoYWVsLndlaXNzQGFpc2VjLmZyYXVuaG9mZXIuZGU+Cj4gLS0tCj4gIGRyaXZl
cnMvbWQvZG0tdmVyaXR5LXRhcmdldC5jIHwgMjAgKysrKysrKysrKysrKysrKysrLS0KPiAgMSBm
aWxlIGNoYW5nZWQsIDE4IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgpUaGlzIGxvb2tz
IHJlYXNvbmFibGUgdG8gbWUgZnJvbSBhbiBhdWRpdCBwZXJzcGVjdGl2ZS4KCkFja2VkLWJ5OiBQ
YXVsIE1vb3JlIDxwYXVsQHBhdWwtbW9vcmUuY29tPgoKPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9t
ZC9kbS12ZXJpdHktdGFyZ2V0LmMgYi9kcml2ZXJzL21kL2RtLXZlcml0eS10YXJnZXQuYwo+IGlu
ZGV4IGFkZTgzZWYzYjQzOS4uOGJlZWI0ZWE2NmQxIDEwMDY0NAo+IC0tLSBhL2RyaXZlcnMvbWQv
ZG0tdmVyaXR5LXRhcmdldC5jCj4gKysrIGIvZHJpdmVycy9tZC9kbS12ZXJpdHktdGFyZ2V0LmMK
PiBAQCAtMTYsNiArMTYsNyBAQAo+ICAjaW5jbHVkZSAiZG0tdmVyaXR5LmgiCj4gICNpbmNsdWRl
ICJkbS12ZXJpdHktZmVjLmgiCj4gICNpbmNsdWRlICJkbS12ZXJpdHktdmVyaWZ5LXNpZy5oIgo+
ICsjaW5jbHVkZSAiZG0tYXVkaXQuaCIKPiAgI2luY2x1ZGUgPGxpbnV4L21vZHVsZS5oPgo+ICAj
aW5jbHVkZSA8bGludXgvcmVib290Lmg+Cj4gICNpbmNsdWRlIDxsaW51eC9zY2F0dGVybGlzdC5o
Pgo+IEBAIC0yNDgsOCArMjQ5LDEwIEBAIHN0YXRpYyBpbnQgdmVyaXR5X2hhbmRsZV9lcnIoc3Ry
dWN0IGRtX3Zlcml0eSAqdiwgZW51bSB2ZXJpdHlfYmxvY2tfdHlwZSB0eXBlLAo+ICAgICAgICAg
RE1FUlJfTElNSVQoIiVzOiAlcyBibG9jayAlbGx1IGlzIGNvcnJ1cHRlZCIsIHYtPmRhdGFfZGV2
LT5uYW1lLAo+ICAgICAgICAgICAgICAgICAgICAgdHlwZV9zdHIsIGJsb2NrKTsKPgo+IC0gICAg
ICAgaWYgKHYtPmNvcnJ1cHRlZF9lcnJzID09IERNX1ZFUklUWV9NQVhfQ09SUlVQVEVEX0VSUlMp
Cj4gKyAgICAgICBpZiAodi0+Y29ycnVwdGVkX2VycnMgPT0gRE1fVkVSSVRZX01BWF9DT1JSVVBU
RURfRVJSUykgewo+ICAgICAgICAgICAgICAgICBETUVSUigiJXM6IHJlYWNoZWQgbWF4aW11bSBl
cnJvcnMiLCB2LT5kYXRhX2Rldi0+bmFtZSk7Cj4gKyAgICAgICAgICAgICAgIGRtX2F1ZGl0X2xv
Z190YXJnZXQoRE1fTVNHX1BSRUZJWCwgIm1heC1jb3JydXB0ZWQtZXJyb3JzIiwgdi0+dGksIDAp
Owo+ICsgICAgICAgfQo+Cj4gICAgICAgICBzbnByaW50Zih2ZXJpdHlfZW52LCBETV9WRVJJVFlf
RU5WX0xFTkdUSCwgIiVzPSVkLCVsbHUiLAo+ICAgICAgICAgICAgICAgICBETV9WRVJJVFlfRU5W
X1ZBUl9OQU1FLCB0eXBlLCBibG9jayk7Cj4gQEAgLTM0MCw2ICszNDMsMTEgQEAgc3RhdGljIGlu
dCB2ZXJpdHlfdmVyaWZ5X2xldmVsKHN0cnVjdCBkbV92ZXJpdHkgKnYsIHN0cnVjdCBkbV92ZXJp
dHlfaW8gKmlvLAo+ICAgICAgICAgICAgICAgICBlbHNlIGlmICh2ZXJpdHlfaGFuZGxlX2Vycih2
LAo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBETV9WRVJJVFlf
QkxPQ0tfVFlQRV9NRVRBREFUQSwKPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgaGFzaF9ibG9jaykpIHsKPiArICAgICAgICAgICAgICAgICAgICAgICBzdHJ1Y3Qg
YmlvICpiaW8gPQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZG1fYmlvX2Zyb21f
cGVyX2Jpb19kYXRhKGlvLAo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIHYtPnRpLT5wZXJfaW9fZGF0YV9zaXplKTsKPiArICAgICAgICAg
ICAgICAgICAgICAgICBkbV9hdWRpdF9sb2dfYmlvKERNX01TR19QUkVGSVgsICJ2ZXJpZnktbWV0
YWRhdGEiLCBiaW8sCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBi
bG9jaywgMCk7Cj4gICAgICAgICAgICAgICAgICAgICAgICAgciA9IC1FSU87Cj4gICAgICAgICAg
ICAgICAgICAgICAgICAgZ290byByZWxlYXNlX3JldF9yOwo+ICAgICAgICAgICAgICAgICB9Cj4g
QEAgLTU5MCw4ICs1OTgsMTEgQEAgc3RhdGljIGludCB2ZXJpdHlfdmVyaWZ5X2lvKHN0cnVjdCBk
bV92ZXJpdHlfaW8gKmlvKQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJu
IC1FSU87Cj4gICAgICAgICAgICAgICAgICAgICAgICAgfQo+ICAgICAgICAgICAgICAgICAgICAg
ICAgIGlmICh2ZXJpdHlfaGFuZGxlX2Vycih2LCBETV9WRVJJVFlfQkxPQ0tfVFlQRV9EQVRBLAo+
IC0gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBjdXJfYmxvY2sp
KQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBjdXJfYmxv
Y2spKSB7Cj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBkbV9hdWRpdF9sb2dfYmlv
KERNX01TR19QUkVGSVgsICJ2ZXJpZnktZGF0YSIsCj4gKyAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIGJpbywgY3VyX2Jsb2NrLCAwKTsKPiAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIHJldHVybiAtRUlPOwo+ICsgICAgICAgICAgICAgICAgICAg
ICAgIH0KPiAgICAgICAgICAgICAgICAgfQo+ICAgICAgICAgfQo+Cj4gQEAgLTk3NSw2ICs5ODYs
OCBAQCBzdGF0aWMgdm9pZCB2ZXJpdHlfZHRyKHN0cnVjdCBkbV90YXJnZXQgKnRpKQo+ICAgICAg
ICAgICAgICAgICBzdGF0aWNfYnJhbmNoX2RlYygmdXNlX3Rhc2tsZXRfZW5hYmxlZCk7Cj4KPiAg
ICAgICAgIGtmcmVlKHYpOwo+ICsKPiArICAgICAgIGRtX2F1ZGl0X2xvZ19kdHIoRE1fTVNHX1BS
RUZJWCwgdGksIDEpOwo+ICB9Cj4KPiAgc3RhdGljIGludCB2ZXJpdHlfYWxsb2NfbW9zdF9vbmNl
KHN0cnVjdCBkbV92ZXJpdHkgKnYpCj4gQEAgLTE0MjksMTEgKzE0NDIsMTQgQEAgc3RhdGljIGlu
dCB2ZXJpdHlfY3RyKHN0cnVjdCBkbV90YXJnZXQgKnRpLCB1bnNpZ25lZCBpbnQgYXJnYywgY2hh
ciAqKmFyZ3YpCj4KPiAgICAgICAgIHZlcml0eV92ZXJpZnlfc2lnX29wdHNfY2xlYW51cCgmdmVy
aWZ5X2FyZ3MpOwo+Cj4gKyAgICAgICBkbV9hdWRpdF9sb2dfY3RyKERNX01TR19QUkVGSVgsIHRp
LCAxKTsKPiArCj4gICAgICAgICByZXR1cm4gMDsKPgo+ICBiYWQ6Cj4KPiAgICAgICAgIHZlcml0
eV92ZXJpZnlfc2lnX29wdHNfY2xlYW51cCgmdmVyaWZ5X2FyZ3MpOwo+ICsgICAgICAgZG1fYXVk
aXRfbG9nX2N0cihETV9NU0dfUFJFRklYLCB0aSwgMCk7Cj4gICAgICAgICB2ZXJpdHlfZHRyKHRp
KTsKPgo+ICAgICAgICAgcmV0dXJuIHI7Cj4gLS0KPiAyLjMwLjIKCi0tIApwYXVsLW1vb3JlLmNv
bQoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9s
aXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

