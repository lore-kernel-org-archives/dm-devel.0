Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 526F0C7EE2A
	for <dm-devel@archiver.kernel.org>; Mon,  5 Jun 2023 05:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685941548;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Esfivp6f+6LZFfnlN36P+cFpnfcOKkOI+4sQdruzR4w=;
	b=gyFtKQEuTPls0xSRw+dSNc42vVuQmAwFVKjLkYvi5z1QbWrC5TFEYLFg9KXUo1T2PmRkjT
	tHYOraQ9ngxb+ePhWXUYorx+5G9gOw8ZKpcYbYCzHCFw/WClYIgspp/Iqqqs6L7AayQPpf
	S5DZ0rwy60sBflRDVrAUrIPfNPWGwKs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-303-BV0FdlFfMDGQFcSt9_UNCA-1; Mon, 05 Jun 2023 01:05:45 -0400
X-MC-Unique: BV0FdlFfMDGQFcSt9_UNCA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 845C73802285;
	Mon,  5 Jun 2023 05:05:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 37DDBC154D7;
	Mon,  5 Jun 2023 05:05:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 23D5819465A0;
	Mon,  5 Jun 2023 05:05:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 36E1E1946595
 for <dm-devel@listman.corp.redhat.com>; Mon,  5 Jun 2023 05:05:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1D426C154D9; Mon,  5 Jun 2023 05:05:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1613AC154D7
 for <dm-devel@redhat.com>; Mon,  5 Jun 2023 05:05:42 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EC288185A793
 for <dm-devel@redhat.com>; Mon,  5 Jun 2023 05:05:41 +0000 (UTC)
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com
 [209.85.160.169]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-10-8HofuO3-MUKSw92fHcnU9A-1; Mon, 05 Jun 2023 01:05:38 -0400
X-MC-Unique: 8HofuO3-MUKSw92fHcnU9A-1
Received: by mail-qt1-f169.google.com with SMTP id
 d75a77b69052e-3f6affdb6ddso49646261cf.0; 
 Sun, 04 Jun 2023 22:05:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685941538; x=1688533538;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=q3kCCtU+NI6gwJFuc3XerKWBHFS/pAXCNLdgl7Npq2M=;
 b=YCu37TELb2aqvr/hG9S6GDZzPh8KFCWy6VAAYEa5/D7YS0gh4oMHAk+/bGZ/sho0cB
 5KsnJyPG1Co+pBQEgsA9/+q94R2xeGShl+t8XacdS9yjbAm4aAqVHAc9YalXOqKvR0F4
 nrR9KiixyRnlkIvWBzLABsR333Y/iZmDvA30Mnh8uF8ENigtw/cTsOecA/ScUfA+VEMR
 o0EgzfzeXgYFQtVJtAMTkKwbzYKM8C3hCN2QtiPRn1cuvFAu539NLD92/uSW5iW+sSO9
 UC9I3/VJOMjY9zcAAuEO2YG1Hefj4h6pca8KUqv5ubuaNYb6oFA7SmZr/SzcCoYJJdT+
 tpHg==
X-Gm-Message-State: AC+VfDxu8ev/HIFsie8DmqpaCzDAVT4lpygF+dJCJV5Hu0liXG+cRTTP
 ti2wzr0ZfYe7stS7gQNa5VSq59B7D3RJnXImBxUYaZRiJeamXw==
X-Google-Smtp-Source: ACHHUZ7rNrXYgwmPX2/cv4b/f94Z1wFDGnN8hkperzEHWHpoVXDt4NP1KbgkL8xcJQixRREjc5NR5JG7AQmKhnYkSbM=
X-Received: by 2002:a05:622a:188a:b0:3f4:e0cc:739c with SMTP id
 v10-20020a05622a188a00b003f4e0cc739cmr9197499qtc.27.1685941537433; Sun, 04
 Jun 2023 22:05:37 -0700 (PDT)
MIME-Version: 1.0
References: <CA+zrezTegR8jHQA3MNM6WnfFU_RP4=fiCuk6WgwJZsjZ2PYUSw@mail.gmail.com>
 <20230604190604.4800-1-eatnumber1@gmail.com>
 <20230604190604.4800-4-eatnumber1@gmail.com>
 <ZH1TmkyVJbIlNUEE@debian.me>
In-Reply-To: <ZH1TmkyVJbIlNUEE@debian.me>
From: Russell Harmon <eatnumber1@gmail.com>
Date: Sun, 4 Jun 2023 22:05:10 -0700
Message-ID: <CA+zrezSnteG0k5nAsTj9_Hpqq6pfMxGE3X47pQx4M_MOqTvOvg@mail.gmail.com>
To: Bagas Sanjaya <bagasdotme@gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v3 3/4] Document dm-integrity default values.
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gU3VuLCBKdW4gNCwgMjAyMyBhdCA4OjE24oCvUE0gQmFnYXMgU2FuamF5YSA8YmFnYXNkb3Rt
ZUBnbWFpbC5jb20+IHdyb3RlOgo+Cj4gT24gU3VuLCBKdW4gMDQsIDIwMjMgYXQgMTI6MDY6MDNQ
TSAtMDcwMCwgUnVzc2VsbCBIYXJtb24gd3JvdGU6Cj4gPiBTcGVjaWZpY2FsbHk6Cj4gPiAgIGlu
dGVybGVhdmVfc2VjdG9ycyA9IDMyNzY4Cj4gPiAgIGJ1ZmZlcl9zZWN0b3JzID0gMTI4Cj4gPiAg
IGJsb2NrX3NpemUgPSA1MTIKPiA+ICAgam91cm5hbF93YXRlcm1hcmsgPSA1MAo+ID4gICBjb21t
aXRfdGltZSA9IDEwMDAwCj4KPiBZb3VyIHBhdGNoIGRlc2NyaXB0aW9uIGR1cGxpY2F0ZXMgdGhl
IGRpZmYgY29udGVudCBiZWxvdy4gUGxlYXNlIHdyaXRlCj4gaW4gYSBtb29kIHRoYXQgZXZvY2F0
ZXMgY3VyaW9zaXR5IHRvIHJlYWQgdGhlIGRpZmYgKGFuZCBtYWtlIHN1cmUgaXQgaXMKPiBhbHNv
IGltcGVyYXRpdmUpLgoKSSdtIG5vdCBzdXJlIHdoYXQgdG8gc2F5IGluIHRoZSBjb21taXQgbWVz
c2FnZSB0aGF0IGlzbid0IGFscmVhZHkKY2FwdHVyZWQgaW4gdGhlIGRpZmYgY29udGVudCBhbmQg
dGhlIHN1bW1hcnkgbGluZSBvZiB0aGUgY29tbWl0LiB2Mgp3YXMgc3VjaCBhIHBhdGNoLCBidXQg
eW91IGFza2VkIHRvIGFkZCBzb21lIGNvbnRlbnQgdG8gdGhlIG1lc3NhZ2UuIERvCnlvdSBoYXZl
IGEgc3VnZ2VzdGlvbiBmb3Igd2hhdCB0byBzYXk/Cgp2NCB0aGF0IEknbSBhYm91dCB0byBzZW5k
IHNheXMgIkRvY3VtZW50YXRpb246IGRtLWludGVncml0eTogRG9jdW1lbnQKZGVmYXVsdCB2YWx1
ZXMiIGluIHRoZSBzdW1tYXJ5IGxpbmUgYW5kIGhhcyBubyBvdGhlciBjb250ZW50IGluIHRoZQpj
b21taXQgbWVzc2FnZS4KCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQu
Y29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

