Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A7A1C678DB
	for <dm-devel@archiver.kernel.org>; Sat,  4 Mar 2023 20:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677963000;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=kZoCw6sSUX4hd2nLXzcrh+ppOt5DaIh+8a5pmoRr92c=;
	b=cY5jrlQl3HId7s1D2kAgutDy+C8lLfCH4MYdTpVW31qHmxJbb/qOgx3m3iU0G78nqXY3S3
	o6+rtaOyRFwoL398182EOfSPoZBkLTFT2QcnsTHrRBpBGicBp7CoyF2UuOvjFzzhn7N6Wi
	+VdReMeRysvxJH5t+99sonts0i8Q3U8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-85-m-HzLcoXOpObfOp2iN8ZFQ-1; Sat, 04 Mar 2023 15:49:56 -0500
X-MC-Unique: m-HzLcoXOpObfOp2iN8ZFQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E7523833941;
	Sat,  4 Mar 2023 20:49:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EC822140EBF6;
	Sat,  4 Mar 2023 20:49:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B6CB619466DF;
	Sat,  4 Mar 2023 20:49:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B84501946594
 for <dm-devel@listman.corp.redhat.com>; Sat,  4 Mar 2023 20:49:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B4BA91410DDA; Sat,  4 Mar 2023 20:49:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id ACC8C140EBF6
 for <dm-devel@redhat.com>; Sat,  4 Mar 2023 20:49:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8A2641C0512C
 for <dm-devel@redhat.com>; Sat,  4 Mar 2023 20:49:19 +0000 (UTC)
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com
 [209.85.210.171]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-266-k8R_BOQzP8auKnvd1v1xzQ-1; Sat, 04 Mar 2023 15:49:17 -0500
X-MC-Unique: k8R_BOQzP8auKnvd1v1xzQ-1
Received: by mail-pf1-f171.google.com with SMTP id ce7so3527105pfb.9
 for <dm-devel@redhat.com>; Sat, 04 Mar 2023 12:49:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1677962956;
 h=to:references:message-id:content-transfer-encoding:cc:date
 :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=COslvQmZ+Oi0XkbuOJkEmAH9cvXR+u6uA2frelMF+/o=;
 b=EZRoHutKYT1GRwWd7DUHl0Sh0NjMZHj9b12VC3KUTcb9kC3IH1xceH0/OSVLfjOteZ
 rzIQcFh4Th4K211g9XP04zQRJBf82ojSdJyRYnzgBTjOrUWq1EIatZsfMTSBcK+xTglT
 gxzAcEiozX+N8hvkKZQXZMIwt7eARdIrgig5Twi17LfASFfdeWsszKEh/BVZ5bsRN9lI
 J2tbUvSMEEIcUdAYGkxkn/2THdAhZZg7eTro/HuNn5pCFFgSeICHgf1EGCzWurLYL9E3
 V7UO3QMUEymUao/grc1yoM3aWxW+j+9QlJmDzVP5UjmLb+KtvQ3cbIXI1HJjq02UTQMF
 OECg==
X-Gm-Message-State: AO0yUKUjqgxgUV4qu0/Qkzrpz32KHrEn7WE6qEqwIigJm+fB4tKb/dyo
 weqwD+17WWxdc0INX9g98KxXYEMQ8+EjDRSHIuQ=
X-Google-Smtp-Source: AK7set/X5ytKTX55FzfC2cdFaRMM4rceQqeTqALPaffMdah1mA4A4H6yU1LZuEiRiwAfKmmGcAVilw==
X-Received: by 2002:aa7:8f24:0:b0:5db:4373:c3c0 with SMTP id
 y4-20020aa78f24000000b005db4373c3c0mr6279212pfr.26.1677962956063; 
 Sat, 04 Mar 2023 12:49:16 -0800 (PST)
Received: from smtpclient.apple ([2600:1700:6970:bea0:7809:e180:8652:7f5d])
 by smtp.gmail.com with ESMTPSA id
 m19-20020aa79013000000b005d62cd8a3c9sm3622929pfo.71.2023.03.04.12.49.14
 (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
 Sat, 04 Mar 2023 12:49:14 -0800 (PST)
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.400.51.1.1\))
From: Brian Bunker <brian@purestorage.com>
In-Reply-To: <fb99dac64dd41a6a44b3c7ce065608b45ff467c4.camel@suse.com>
Date: Sat, 4 Mar 2023 12:49:03 -0800
Message-Id: <C9BF0F84-BA7F-432C-A9A7-DC77DFE856CA@purestorage.com>
References: <CAHZQxyJH1etLR5gHuWk4c6-ieioqA4GrJ173B60bnTppke58dw@mail.gmail.com>
 <4bc4be79c2d00cc959932ec935179a46be4b2fbc.camel@suse.com>
 <5A7BD289-0205-42FF-84CD-7C218511A280@purestorage.com>
 <fb99dac64dd41a6a44b3c7ce065608b45ff467c4.camel@suse.com>
To: Martin Wilck <mwilck@suse.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH] [PATCH] libmultipath: return 'ghost' state
 when port is in transition
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
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gTWFyIDMsIDIwMjMsIGF0IDEyOjQxIFBNLCBNYXJ0aW4gV2lsY2sgPG13aWxja0BzdXNlLmNv
bT4gd3JvdGU6Cj4gCj4gT24gRnJpLCAyMDIzLTAzLTAzIGF0IDA5OjE4IC0wODAwLCBCcmlhbiBC
dW5rZXIgd3JvdGU6Cj4+PiAKPj4gSGVsbG8gTWFydGluLCAKPj4gCj4+IERvZXNu4oCZdCAic29t
ZXRoaW5nIGluIGJldHdlZW4gZmFpbGVkIGFuZCB1cOKAnSBzZW1hbnRpY3MgZGVzY3JpYmUgQUxV
QQo+PiBzdGF0ZSB0cmFuc2l0aW9uaW5nIHByZXR0eSB3ZWxsPwo+IAo+IHRyYW5zaXRpb25pbmcg
LSB5ZXMuIHN0YW5kYnkgLSA/Pwo+IAo+IE1hcnRpbgo+IApUaGUgY2hlY2tpbmcgZm9yIHN0YW5k
YnkgaXMgMTQgeWVhcnMgb2xkLCBhbmQgc2F5cyB0aGF0IFRVUiByZXR1cm5zCmEgdW5pdCBhdHRl
bnRpb24gd2hlbiB0aGUgcGF0aCBpcyBpbiBzdGFuZGJ5LiBJIGFtIG5vdCBzdXJlIHdoeSB0aGF0
CndvdWxkbuKAmXQgYmUgaGFuZGxlZCBieSB0aGlzIGNvZGUgYWJvdmU6IEkgd291bGQgdGhpbmsg
dGhlcmUgc2hvdWxkIGJlCmp1c3Qgb25lIHVuaXQgYXR0ZW50aW9uIGZvciBlYWNoIElfVF9MIHdo
ZW4gYW4gQUxVQSBzdGF0ZSBjaGFuZ2UKaGFwcGVucy5Ob3Qgc3VyZSBob3cgaXQgZXhjZWVkcyB0
aGUgcmV0cnkgY291bnQuCgppZiAoa2V5ID09IDB4NikgewogICAgLyogVW5pdCBBdHRlbnRpb24s
IHJldHJ5ICovCiAgICBpZiAo4oCUcmV0cnlfdHVyKQogICAgICAgIGdvdG8gcmV0cnk7Cn0KCkZy
b20gbXkgcGVyc3BlY3RpdmUgZmFpbGluZyBhIHBhdGggZm9yIEFMVUEgc3RhdGUgc3RhbmRieSBp
cyByZWFzb25hYmxlCnNpbmNlIGl0IGlzIG5vdCBhbiBhY3RpdmUgc3RhdGUuCgotLQpkbS1kZXZl
bCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0
LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

