Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D56BDC7EE2A
	for <dm-devel@archiver.kernel.org>; Mon,  5 Jun 2023 05:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685941346;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=9pvVu9otfcm+9B/BPFVK2IYfQG0N0R1KmS24CmcpjJU=;
	b=gpMu/M8qA5hgpfBibqfxxMD6aghMbYnN2+l968klXmSo2aKFsEz1U9QIBguoCTliS8f1mR
	SD+2Tl559e8IeOIn85iPPlM3GDFiUMPYMt6Uir0k1z1zN25pLnEyvMi8whaXkphOry5o9p
	KQzavsLlnQ9jPSHO60qVUGrEoZz5fGU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-588-o6xndfagPGy0uoDwJfCQeA-1; Mon, 05 Jun 2023 01:02:23 -0400
X-MC-Unique: o6xndfagPGy0uoDwJfCQeA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E10363C0BE23;
	Mon,  5 Jun 2023 05:02:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CEDB2492B00;
	Mon,  5 Jun 2023 05:02:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 96CC319465A0;
	Mon,  5 Jun 2023 05:02:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 820541946595
 for <dm-devel@listman.corp.redhat.com>; Mon,  5 Jun 2023 05:02:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6B2D62166B27; Mon,  5 Jun 2023 05:02:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 62B872166B25
 for <dm-devel@redhat.com>; Mon,  5 Jun 2023 05:02:20 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4241B3802277
 for <dm-devel@redhat.com>; Mon,  5 Jun 2023 05:02:20 +0000 (UTC)
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com
 [209.85.160.173]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-443-eM4-zG3GN8SO2_NJFEXT4Q-1; Mon, 05 Jun 2023 01:02:18 -0400
X-MC-Unique: eM4-zG3GN8SO2_NJFEXT4Q-1
Received: by mail-qt1-f173.google.com with SMTP id
 d75a77b69052e-3f7f864525fso49530701cf.1; 
 Sun, 04 Jun 2023 22:02:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685941338; x=1688533338;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=kQqq0ZkiTjUo34FFESouqLsW9G1Vf1I+EZhrNacdQcU=;
 b=Y+MZwyaJz4DYTJ5Bhw0+x56aiR4UdMliSgHM8ki4TwInQWehUGasItg6wK4edgJt0d
 vAft7R1YSuMx1aNtnUVQt2LxQWNArblB7d3oWQ1S2GU5jY7dSuFgt7Y1aQRZdxKDW51W
 mX4viHJGQ6+S9aO+gA5Cx8kjqqnIUTMlx4HGGc0kXtpOSum9iOt1REpS4JWqmNalx8sT
 D8V+hZTZ3L+UkpAcjZkqUifkWZYs5zapeS++CIsSdAKxHn28vWUBqkMO+N0Pq6ydyyuf
 q/gAwh2Kz979TOh/QHgqPWtfagRNxBagIHoKL9Sw2wbqS1nXNn25TanBssQtPOBNlvHJ
 l8hg==
X-Gm-Message-State: AC+VfDxmbyw60wbGLx2zpD16YJ9v/MSyYv+SDNYj15FQ0jjlKKZBqqof
 J8QUTTNhMJz+pCPh7lbyn55t62WYaVC3ErFGKSk=
X-Google-Smtp-Source: ACHHUZ7Ceo1/xs3hPrnnIfWJcNj1nUgBI/Xg2njUUBGMLjaIlpJLXok1imeJGC7i9moZ8RgEJyd+i0v7dDrwNcl4LUc=
X-Received: by 2002:a05:622a:307:b0:3f4:f199:d98a with SMTP id
 q7-20020a05622a030700b003f4f199d98amr7948724qtw.24.1685941337799; Sun, 04 Jun
 2023 22:02:17 -0700 (PDT)
MIME-Version: 1.0
References: <CA+zrezTegR8jHQA3MNM6WnfFU_RP4=fiCuk6WgwJZsjZ2PYUSw@mail.gmail.com>
 <20230604190604.4800-1-eatnumber1@gmail.com>
 <20230604190604.4800-3-eatnumber1@gmail.com>
 <ZH1RjWUfq3Af4fiB@debian.me>
In-Reply-To: <ZH1RjWUfq3Af4fiB@debian.me>
From: Russell Harmon <eatnumber1@gmail.com>
Date: Sun, 4 Jun 2023 22:01:51 -0700
Message-ID: <CA+zrezRfP-X4uaY06zDyT=G+KGSLx6wjBL8ZuoSwP6709ad-OQ@mail.gmail.com>
To: Bagas Sanjaya <bagasdotme@gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH v3 2/4] Documents the meaning of "buffer" in
 dm-integrity.
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gU3VuLCBKdW4gNCwgMjAyMyBhdCA4OjA44oCvUE0gQmFnYXMgU2FuamF5YSA8YmFnYXNkb3Rt
ZUBnbWFpbC5jb20+IHdyb3RlOgo+Cj4gT24gU3VuLCBKdW4gMDQsIDIwMjMgYXQgMTI6MDY6MDJQ
TSAtMDcwMCwgUnVzc2VsbCBIYXJtb24gd3JvdGU6Cj4gPiAiQnVmZmVycyIgYXJlIGJ1ZmZlcnMg
b2YgdGhlIG1ldGFkYXRhL2NoZWNrc3VtIGFyZWEgb2YgZG0taW50ZWdyaXR5Lgo+ID4gVGhleSBh
cmUgYWx3YXlzIGF0IG1vc3QgYXMgbGFyZ2UgYXMgYSBzaW5nbGUgbWV0YWRhdGEgYXJlYSBvbi1k
aXNrLCBidXQKPiA+IG1heSBiZSBzbWFsbGVyLgo+Cj4gSGV5LCBJIGZvcmdvdCB0byBtZW50aW9u
IGJlbG93Lgo+Cj4gV2hlcmUgaXMgdGhlIHN1YmplY3QgcHJlZml4PyBUaGUgcGF0Y2ggdGl0bGUg
c2hvdWxkIGhhdmUgYmVlbiAiRG9jdW1lbnRhdGlvbjogZG0taW50ZWdyaXR5OiBEb2N1bWVudAo+
IGJ1ZmZlcnMiLgoKQWggSSBtaXNzZWQgdGhhdCBpbiB0aGUgZG9jcy4gSSdsbCBzZW5kIGEgdjQg
d2l0aCBpdCBpbmNsdWRlZC4KCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRo
YXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2
ZWwK

