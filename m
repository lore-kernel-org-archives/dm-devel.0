Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2E39C6FA99
	for <dm-devel@archiver.kernel.org>; Fri, 10 Mar 2023 19:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678478154;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=YxSCSAAXBsN4LQEqWW4ZQD0B1aUawq4ksM4LcRgIU8A=;
	b=ZKSuU24H6OixhaWxS+ZwbyvnU7rnZAkTOltK6e1BKDfrfBPiqXP6KzR/agZCc+q0UrCYHE
	iK/zCqFuzjzn0MleCylgqQ1CxXhcK6lPYJ7YTnZRFNBMBjni649uhHGbJi2260jzoaqRgR
	xMiQckh9Xdk9Fff0FuHwpB3j2IIeHu4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-259-KYFgtOjhM3-Mc4S_s64lJg-1; Fri, 10 Mar 2023 14:55:50 -0500
X-MC-Unique: KYFgtOjhM3-Mc4S_s64lJg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D818680D0F0;
	Fri, 10 Mar 2023 19:55:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BA31E140EBF6;
	Fri, 10 Mar 2023 19:55:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7E1E91946A4A;
	Fri, 10 Mar 2023 19:55:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B9A141946587
 for <dm-devel@listman.corp.redhat.com>; Fri, 10 Mar 2023 19:55:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A9B9C2166B2A; Fri, 10 Mar 2023 19:55:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A26AE2166B26
 for <dm-devel@redhat.com>; Fri, 10 Mar 2023 19:55:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7E75738041D9
 for <dm-devel@redhat.com>; Fri, 10 Mar 2023 19:55:43 +0000 (UTC)
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com
 [209.85.214.180]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-427-xpWR04lBPkubdrHmwXYsNw-1; Fri, 10 Mar 2023 14:55:32 -0500
X-MC-Unique: xpWR04lBPkubdrHmwXYsNw-1
Received: by mail-pl1-f180.google.com with SMTP id u5so6791356plq.7
 for <dm-devel@redhat.com>; Fri, 10 Mar 2023 11:55:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1678478131;
 h=to:references:message-id:content-transfer-encoding:cc:date
 :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=FfUi92t91peDQWaio1IWEjphTBklljB6F2Tzv8xAu80=;
 b=0cOF+FNCDIBMbLZeAoTWaeHJJgaG2sGHoPtnraVjXGuXNiXpUHbm934sFJ2dtn0z+d
 xdb72crkRld+gsefIEnZZopU2DpLtyy74XQI5V5RRmZOWguLEq4yaM3c68bqg5InGa0J
 hr2CqzGNMO1h/olg+NAUv2K2iyA74d2NXDDk4diC2ShiovE5wNvU3v4nr3OpE9KipKfa
 avexGVSA+oU+iNpUkzqZxsSvj6M/+xuRk3GQX2Db295RLyGFOYgI5gqDURBlNb9tSsel
 lX4DHPLB2iM0frOUheDZWTixVDynvN3patsB11iKjF3XwePv2vx5KF36FkdDBAOJ61uB
 EvmQ==
X-Gm-Message-State: AO0yUKVmnFnBIsABuqqTto2jRDljhsm6jqyGahUtd+PpP30kXHCe4DLv
 dv8kIOnFhD6Scbwbkm0C6n1SQg==
X-Google-Smtp-Source: AK7set+9eTGgt9DnVbAjOWALQfuqxVYo8aN9Gs0zDinDtfijUDPdmbLp8qPmj2h/n2oTMh5OWriGfQ==
X-Received: by 2002:a17:902:ce92:b0:19c:f8c5:d504 with SMTP id
 f18-20020a170902ce9200b0019cf8c5d504mr7820014plg.59.1678478131350; 
 Fri, 10 Mar 2023 11:55:31 -0800 (PST)
Received: from smtpclient.apple ([2600:1700:6970:bea0:dcda:e506:6dd9:9c4])
 by smtp.gmail.com with ESMTPSA id
 kn13-20020a170903078d00b0019d397b0f18sm349530plb.214.2023.03.10.11.55.30
 (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
 Fri, 10 Mar 2023 11:55:30 -0800 (PST)
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.400.51.1.1\))
From: Brian Bunker <brian@purestorage.com>
In-Reply-To: <14a2e53c90802d36259e024f813a21d081321816.camel@googlemail.com>
Date: Fri, 10 Mar 2023 11:55:19 -0800
Message-Id: <C749E399-67A9-4E89-A81E-D348737AB252@purestorage.com>
References: <1678229374-18788-1-git-send-email-bmarzins@redhat.com>
 <14a2e53c90802d36259e024f813a21d081321816.camel@googlemail.com>
To: mwilck@googlemail.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
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
Cc: device-mapper development <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

PiBPbiBNYXIgOSwgMjAyMywgYXQgMTI6MzggQU0sIG13aWxja0Bnb29nbGVtYWlsLmNvbSB3cm90
ZToKPiAKPiBCcmlhbiwKPiAKPiBjb3VsZCB5b3UgZ2l2ZSB0aGlzIHBhdGNoIHNldCBhIHRlc3Qg
aW4geW91ciBlbnZpcm9ubWVudD8KPiAKPiBPbiBUdWUsIDIwMjMtMDMtMDcgYXQgMTY6NDkgLTA2
MDAsIEJlbmphbWluIE1hcnppbnNraSB3cm90ZToKPj4gVGhpcyBwYXRjaHNldCBpcyBiYXNlZCBv
biBCcmlhbiBCdW5rZXIncyAibGlibXVsdGlwYXRoOiByZXR1cm4KPj4gJ2dob3N0JyBzdGF0ZSB3
aGVuIHBvcnQgaXMgaW4gdHJhbnNpdGlvbiIgcGF0Y2g6Cj4+IAo+PiBodHRwczovL2xpc3RtYW4u
cmVkaGF0LmNvbS9hcmNoaXZlcy9kbS1kZXZlbC8yMDIzLUZlYnJ1YXJ5LzA1MzM0NC5odG1sCj4+
IGh0dHBzOi8vZ2l0aHViLmNvbS9vcGVuc3ZjL211bHRpcGF0aC10b29scy9wdWxsLzYwCj4+IAo+
PiBJbnN0ZWFkIG9mIHNldHRpbmcgdGhlIHN0YXRlIHRvIFBBVEhfR0hPU1QsIGl0IHVzZXMgUEFU
SF9QRU5ESU5HLiBUaGUKPj4gb3RoZXIgdHdvIHBhdGNoZXMgYXJlIHNtYWxsIGNsZWFudXBzIHRv
IHRoZSBUVVIgY2hlY2tlciB0aGF0IEkKPj4gbm90aWNlZAo+PiB3aGlsZSB3cml0aW5nIHRoZSBm
aXJzdCBwYXRjaC4KPj4gCj4+IEJlbmphbWluIE1hcnppbnNraSAoMyk6Cj4+ICAgbGlibXVsdGlw
YXRoOiByZXR1cm4gJ3BlbmRpbmcnIHN0YXRlIHdoZW4gcG9ydCBpcyBpbiB0cmFuc2l0aW9uCj4+
ICAgbGlibXVsdGlwYXRoOiBzZXQgaW5pdCBmYWlsdXJlIG1lc3NhZ2Ugd2hlbiBpbml0IGZhaWxz
Cj4+ICAgbGlibXVsdGlwYXRoOiByZXNldCBucl90aW1lb3V0cyBpZiB3ZSBmcmVlZCB0aGUgY29u
dGV4dAo+PiAKPj4gIGxpYm11bHRpcGF0aC9jaGVja2Vycy90dXIuYyB8IDI0ICsrKysrKysrKysr
KysrKysrKystLS0tLQo+PiAgMSBmaWxlIGNoYW5nZWQsIDE5IGluc2VydGlvbnMoKyksIDUgZGVs
ZXRpb25zKC0pCj4+IAo+IAo+IEknZCBsaWtlIHRvIHdhaXQgZm9yIEJyaWFuJ3MgcmVzdWx0cy4g
RnJvbSBjb2RlIGluc3BlY3Rpb24sIGFuZCB3aXRoCj4gQmVuJ3MgZXhwbGFuYXRpb24gZm9yIHRo
ZSAzLzMgbG9naWMsCj4gCj4gRm9yIHRoZSBzZXQ6Cj4gUmV2aWV3ZWQtYnk6IE1hcnRpbiBXaWxj
ayA8bXdpbGNrQHN1c2UuY29tPgpCZW4gYW5kIE1hcnRpbiwKClRoaXMgd29ya3Mgd2VsbCBmb3Ig
bWUgYWdhaW5zdCBteSBhcnJheS4gQSBjb3VwbGUgb2YgdGhpbmdzIGluIHRoaXMgcGFydAoKQ2Fu
IHlvdSBtYWtlIHRoZSBhYm92ZSBtYXRjaCB5b3VyIGZvcm1hdHRpbmcgc2luY2UgaXQgaXMgYmV0
dGVyOgppZiggYXNjID09IDB4MDQgJiYgYXNjcSA9PSAweDBiKXsKCmlmIChhc2MgPT0gMHgwNCAm
JiBhc2NxID09IDB4MGEpIHsKCkFuZCBJIGRvbuKAmXQgdGhpbmsgeW91IG5lZWQgZWxzZSBpZiBz
aW5jZSB0aGUgbGluZSBhYm92ZSBpdCByZXR1cm5zIGluIGl0cwpjYXNlLCBzbyBlbHNlIGlzIG5v
dCBoaXQgaWYgdGhlIGZpcnN0IGlmIGlzIHRydWU6CgogICAgcmV0dXJuIFBBVEhfR0hPU1Q7Cn0g
ZWxzZSBpZiAoYXNjID09IDB4MDQgJiYgYXNjcSA9PSAweDBhKSB7CgpUaGFua3MsCkJyaWFuCgoK
Ci0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlz
dG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

