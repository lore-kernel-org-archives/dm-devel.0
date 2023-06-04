Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF33EC77B73
	for <dm-devel@archiver.kernel.org>; Sun,  4 Jun 2023 18:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685903145;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=2E1H4qjW0dBaclgKyKv+eG1IbB/SrYZe51bQQk4GTPQ=;
	b=i+5ezvsZrFLveqcjqdBMIVhQFns3UDliOMv/gyhZdI9rRfwEy5oK3vqnLH6EJ7PElVvP/a
	VoLvZLCOEBTYChOhJwZihoY5mfuaxYTPn4ixgsc4RSfjDO9hGixycolJXs1IES/NdzbGZB
	1mrf3tN4+n58IdLMwel+ZQ+ar6C60eg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-512-oy6c3l2rN5yHiDT4o5S85Q-1; Sun, 04 Jun 2023 14:25:42 -0400
X-MC-Unique: oy6c3l2rN5yHiDT4o5S85Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8DD6C2A2AD4E;
	Sun,  4 Jun 2023 18:25:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D6A5840CFD46;
	Sun,  4 Jun 2023 18:25:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8B59419465A0;
	Sun,  4 Jun 2023 18:25:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 25ACA1946595
 for <dm-devel@listman.corp.redhat.com>; Sun,  4 Jun 2023 18:25:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D18161410F26; Sun,  4 Jun 2023 18:25:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CA0021410F25
 for <dm-devel@redhat.com>; Sun,  4 Jun 2023 18:25:36 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AF0FD3C10220
 for <dm-devel@redhat.com>; Sun,  4 Jun 2023 18:25:36 +0000 (UTC)
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com
 [209.85.222.172]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-518-A4WEyFKPM8-sjLIhPWFeog-1; Sun, 04 Jun 2023 14:25:33 -0400
X-MC-Unique: A4WEyFKPM8-sjLIhPWFeog-1
Received: by mail-qk1-f172.google.com with SMTP id
 af79cd13be357-75ca95c4272so360241885a.0; 
 Sun, 04 Jun 2023 11:25:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685903132; x=1688495132;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=XoDaxZYrMXoYYBthZoKFtcpdtCIkJoVqe+cep/VE5FA=;
 b=l7yZTrTW9hfGH5mVjnHTWwfYpvu/WHaNkxUB1lcaOTrWn5HT6VaJgomNIkpMbha/EJ
 Vbmtu1TVMtVjo52Z9WI+8vsDlLr9M94BvMpwfevR+yLd4sAqUNk84iDzAhe8RQx79/eT
 KS+wPpFxT87L61sDQNjfacZz3tJ52BkF/XQhS0HbbP4PmUCcziwLA4zvqj2+UpVCMqf8
 2tCz+dR8VML6WRj9YSZpbkUJzlwBsqpEhUUsrw9Y3XHIKERgI+6XkCj5lsrTN3Tytg8E
 k9ZrovhFwt1IipleFU1o1M81uLiPc+aHGIzTKD9XDytqZAFlA4Pu93HCQTgQz/L+Le6w
 ya6g==
X-Gm-Message-State: AC+VfDyQGJ1Qd+i5RxWliYJPBwEclFMKorltMigE4uOkD53EiNzcVOIj
 6Msp/T0vzU0YTMXvVKUXGZFmK04po0euTef5aI8=
X-Google-Smtp-Source: ACHHUZ75hj0npR7Uh2z3sGVtGxoxc23KedhBpuzoaTVP7JzmVvaxeN9sMOGv56XXiOAqq2XhXgpOVrBmK4o+ZK40yd4=
X-Received: by 2002:ac8:5851:0:b0:3f5:3ff4:be07 with SMTP id
 h17-20020ac85851000000b003f53ff4be07mr5004691qth.64.1685903132352; Sun, 04
 Jun 2023 11:25:32 -0700 (PDT)
MIME-Version: 1.0
References: <ZHs2BHGBrJ-YGd-v@debian.me>
 <20230603201525.9409-1-eatnumber1@gmail.com>
 <65b7bc64-4a4b-c056-db65-cd77bcc3d1d9@gmail.com>
In-Reply-To: <65b7bc64-4a4b-c056-db65-cd77bcc3d1d9@gmail.com>
From: Russell Harmon <eatnumber1@gmail.com>
Date: Sun, 4 Jun 2023 11:25:06 -0700
Message-ID: <CA+zrezTegR8jHQA3MNM6WnfFU_RP4=fiCuk6WgwJZsjZ2PYUSw@mail.gmail.com>
To: Bagas Sanjaya <bagasdotme@gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH] Improve the dm-integrity documentation.
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
Cc: dm-devel@redhat.com, mpatocka@redhat.com, snitzer@redhat.com,
 linux-doc@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gU3VuLCBKdW4gNCwgMjAyMyBhdCA3OjA34oCvQU0gQmFnYXMgU2FuamF5YSA8YmFnYXNkb3Rt
ZUBnbWFpbC5jb20+IHdyb3RlOgo+Cj4gT24gNi80LzIzIDAzOjE1LCBSdXNzZWxsIEhhcm1vbiB3
cm90ZToKPiA+IFRoYW5rcyBmb3IgdGFraW5nIGEgbG9vay4gSGVyZSdzIHRoZSBtdWx0aS1wYXRj
aCBzZXJpZXMgcGx1cyB0aGUgY2hhbmdlcwo+ID4geW91IHN1Z2dlc3RlZC4KPiA+Cj4gPgo+Cj4g
VGhpcyBpcyB2MiwgcmlnaHQ/IE5leHQgcmVyb2xsLCByZW1lbWJlciB0byB2ZXJzaW9uIHlvdXIg
cGF0Y2hlcwo+IChwYXNzIC12IHRvIGdpdC1mb3JtYXQtcGF0Y2goMSkpLgoKV2lsbCBkby4KCj4g
QWxzbywgSSBkb24ndCBzZWUgZGVzY3JpcHRpb24gKHRoYXQgd291bGQgYmUgY29tbWl0IG1lc3Nh
Z2UKPiBvbmNlIGFwcGxpZWQgYnkgam9uKSBpbiBhbGwgcGF0Y2hlcyBvbiB0aGlzIHNlcmllcy4g
SSBob3BlIHlvdQo+IGhhdmUgYSB0aW1lIHJlYWRpbmcgRG9jdW1lbnRhdGlvbi9wcm9jZXNzL3N1
Ym1pdHRpbmctcGF0Y2hlcy5yc3QKPiBzbyB0aGF0IHRyaXZpYWwgbWlzdGFrZXMgbGlrZSB0aGlz
IHNob3VsZG4ndCBoYXBwZW4gYWdhaW4uIEluCj4gYW55IGNhc2UsIHdoZW4gcHJlcGFyaW5nIHBh
dGNoIHNlcmllcywgYWx3YXlzIGFkZCBjb3ZlciBsZXR0ZXIKPiBieSBwYXNzaW5nIC0tY292ZXIt
bGV0dGVyIHRvIGdpdC1mb3JtYXQtcGF0Y2goMSkgdGhlbiBlZGl0IHRoZQo+IGdlbmVyYXRlZCB0
ZW1wbGF0ZSAobG9vayBmb3IgMDAwMC0qLWNvdmVyLWxldHRlci5wYXRjaCkuCgpNeSAidGhhbmtz
IGZvciB0YWtpbmcgYSBsb29rIiBlbWFpbCB3YXMgdGhlIGNvdmVyIGxldHRlci4KCkludGVyZXN0
aW5nIHRoYXQgdGhlIGNvbW1pdCBtZXNzYWdlIGRpZG4ndCBnbyB0aHJvdWdoIGluIHRoZSBib2R5
LAp0aGV5J3JlIGVhY2ggb25lIGxpbmUgYW5kIHdlcmUgbW92ZWQgdG8gdGhlIHN1YmplY3QgbGlu
ZS4gSSdsbCB0cnkKYWdhaW4gYW5kIGFkZCBhIGxpdHRsZSBtb3JlIGRlc2NyaXB0aW9uLgoKLS0K
ZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFu
LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

