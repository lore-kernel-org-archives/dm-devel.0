Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 122FFC001DC
	for <dm-devel@archiver.kernel.org>; Wed, 26 Jul 2023 16:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690390504;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=CLPXYOuK3y/6aaf02SmwnT+OS0r3wYAbzIqE2Ugrpcc=;
	b=b7zEGTHw9FmajTd+jx5DpO1DT1H4tNE+JxL6BSn4MES8L0snR8gQPsGI77FvR4Aiw4fiqT
	Hpj3y7Z0GkFR7Keh6GvWk/bEvB7zwh7DAKZ1mwxHNvPMvs7HlsT1cLvoA6lNXmUn/n8Ii5
	P01Anpd0Tm9H2tJX9y5ampYYLdIz5N4=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-677-2y-AZp04PaeBIthKTVLovA-1; Wed, 26 Jul 2023 12:55:00 -0400
X-MC-Unique: 2y-AZp04PaeBIthKTVLovA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2D23A1C05AAA;
	Wed, 26 Jul 2023 16:54:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 89FCD4094DC0;
	Wed, 26 Jul 2023 16:54:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4E7921946A6E;
	Wed, 26 Jul 2023 16:54:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 594ED1946A6C
 for <dm-devel@listman.corp.redhat.com>; Wed, 26 Jul 2023 15:30:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 361852166B27; Wed, 26 Jul 2023 15:30:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2D6002166B26
 for <dm-devel@redhat.com>; Wed, 26 Jul 2023 15:30:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0220338117EB
 for <dm-devel@redhat.com>; Wed, 26 Jul 2023 15:30:09 +0000 (UTC)
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com
 [209.85.128.181]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-349-gitNYrPyM26gTBS1GPYvaw-1; Wed, 26 Jul 2023 11:30:04 -0400
X-MC-Unique: gitNYrPyM26gTBS1GPYvaw-1
Received: by mail-yw1-f181.google.com with SMTP id
 00721157ae682-583b3aa4f41so53890887b3.2; 
 Wed, 26 Jul 2023 08:30:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1690385403; x=1690990203;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=Lrg+45f8OyZpsYrZsCtiNxFu62qT5zsFL2TVU9KzV9Y=;
 b=TAbZJVcQjlO4qpYfq/tk3KmyeUCGEQk5vcTpeQ+5ZmILs1Cy5yRSEBid3e8XbCEkGY
 cbRHPhP9G767YRymGIkLE2mPo5XwRFwYceCw3B97B9T0AseS2z6F4z2M9Xm+DZuwHJ64
 9x/g9J4Ml13bf2XNo4d5c9EsEWIwxDPIwpSLF0biuQPcgHcJUtGN76sEjjy5RjLS7m0I
 oSiviEyj9YNMNs22Nm/h1l0cHyoKx4rQdmjz0WUJhGejsgxP1nsEwk3OuBCp1z/mUN3d
 PbPlynzgoPBlycY1mJNNuTGlnjNsQRUTXFErln3btFwF1VIPCjbWF0uZL9QQ88lbKrAe
 MmEQ==
X-Gm-Message-State: ABy/qLZCNJQFPypZxmYNxq7GLpk+QXEML7DtN69vJr+vbmJRwL9R+Hri
 I0P5BozNtc96fQD5wj6HwxKvU2eRR3etHQSXUsahJ17watP6W+J2J0w=
X-Google-Smtp-Source: APBJJlH9c/Cm1Gn1k/bqGcIifEtT5WA6JYO4NWDRh17eGkNuN//LPGYMjb5PrsKWtVwk5jtZLub4b2CzwC+F8JFg/Zw=
X-Received: by 2002:a81:a151:0:b0:584:5e7e:40c1 with SMTP id
 y78-20020a81a151000000b005845e7e40c1mr533351ywg.28.1690385402927; Wed, 26 Jul
 2023 08:30:02 -0700 (PDT)
MIME-Version: 1.0
References: <4919.1690365747@warthog.procyon.org.uk>
In-Reply-To: <4919.1690365747@warthog.procyon.org.uk>
From: Ming Lei <tom.leiming@gmail.com>
Date: Wed, 26 Jul 2023 23:29:51 +0800
Message-ID: <CACVXFVM8rcGJu-f+6zOgY8t4KPPR0J=giYD5dnCLL8_XVo234w@mail.gmail.com>
To: David Howells <dhowells@redhat.com>,
 linux-block <linux-block@vger.kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] Processes hung in "D" state in ext4, mm,
 md and dmcrypt
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
Cc: Theodore Ts'o <tytso@mit.edu>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
 linux-raid@vger.kernel.org, Song Liu <song@kernel.org>, dm-devel@redhat.com,
 Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gV2VkLCBKdWwgMjYsIDIwMjMgYXQgNjowMuKAr1BNIERhdmlkIEhvd2VsbHMgPGRob3dlbGxz
QHJlZGhhdC5jb20+IHdyb3RlOgo+Cj4gSGksCj4KPiBXaXRoIDYuNS1yYzIgKDYuNS4wLTAucmMy
LjIwMjMwNzIxZ2l0ZjdlM2ExYmFmZGVhLjIwLmZjMzkueDg2XzY0KSwgSSdtIHNlZWluZwo+IGEg
YnVuY2ggb2YgcHJvY2Vzc2VzIGdldHRpbmcgc3R1Y2sgaW4gdGhlIEQgc3RhdGUgb24gbXkgZGVz
a3RvcCBhZnRlciBhIGZldwo+IGhvdXJzIG9mIHJlYWRpbmcgZW1haWwgYW5kIGNvbXBpbGluZyBz
dHVmZi4gIEl0J3MgaGFwcGVuZWQgZXZlcnkgZGF5IHRoaXMgd2Vlawo+IHNvIGZhciBhbmQgSSBt
YW5hZ2VkIHRvIGdyYWIgc3RhY2sgdHJhY2VzIG9mIHRoZSBzdHVjayBwcm9jZXNzZXMgdGhpcyBt
b3JuaW5nCj4gKHNlZSBhdHRhY2hlZCkuCj4KPiBUaGVyZSBhcmUgdHdvIGJsb2NrZGV2cyBpbnZv
bHZlZCBiZWxvdywgL2Rldi9tZDIgYW5kIC9kZXYvbWQzLiAgbWQzIGlzIGEgcmFpZDEKPiBhcnJh
eSB3aXRoIHR3byBwYXJ0aXRpb25zIHdpdGggYW4gZXh0NCBwYXJ0aXRpb24gb24gaXQuICBtZDIg
aXMgc2ltaWxhciBidXQKPiBpdCdzIGRtLWNyeXB0ZWQgYW5kIGV4dDQgaXMgb24gdG9wIG9mIHRo
YXQuCj4KLi4uCgo+ID09PTExNzU0Nz09PQo+ICAgICBQSUQgVFRZICAgICAgU1RBVCAgIFRJTUUg
Q09NTUFORAo+ICAxMTc1NDcgPyAgICAgICAgRCAgICAgIDU6MTIgW2t3b3JrZXIvdTE2OjgrZmx1
c2gtOTozXQo+IFs8MD5dIGJsa19tcV9nZXRfdGFnKzB4MTFlLzB4MmIwCj4gWzwwPl0gX19ibGtf
bXFfYWxsb2NfcmVxdWVzdHMrMHgxYmMvMHgzNTAKPiBbPDA+XSBibGtfbXFfc3VibWl0X2Jpbysw
eDJjNy8weDY4MAo+IFs8MD5dIF9fc3VibWl0X2JpbysweDhiLzB4MTcwCj4gWzwwPl0gc3VibWl0
X2Jpb19ub2FjY3Rfbm9jaGVjaysweDE1OS8weDM3MAo+IFs8MD5dIF9fYmxvY2tfd3JpdGVfZnVs
bF9mb2xpbysweDFlMS8weDQwMAo+IFs8MD5dIHdyaXRlcGFnZV9jYisweDFhLzB4NzAKPiBbPDA+
XSB3cml0ZV9jYWNoZV9wYWdlcysweDE0NC8weDNiMAo+IFs8MD5dIGRvX3dyaXRlcGFnZXMrMHgx
NjQvMHgxZTAKPiBbPDA+XSBfX3dyaXRlYmFja19zaW5nbGVfaW5vZGUrMHgzZC8weDM2MAo+IFs8
MD5dIHdyaXRlYmFja19zYl9pbm9kZXMrMHgxZWQvMHg0YjAKPiBbPDA+XSBfX3dyaXRlYmFja19p
bm9kZXNfd2IrMHg0Yy8weGYwCj4gWzwwPl0gd2Jfd3JpdGViYWNrKzB4Mjk4LzB4MzEwCj4gWzww
Pl0gd2Jfd29ya2ZuKzB4MzViLzB4NTEwCj4gWzwwPl0gcHJvY2Vzc19vbmVfd29yaysweDFkZS8w
eDNmMAo+IFs8MD5dIHdvcmtlcl90aHJlYWQrMHg1MS8weDM5MAo+IFs8MD5dIGt0aHJlYWQrMHhl
NS8weDEyMAo+IFs8MD5dIHJldF9mcm9tX2ZvcmsrMHgzMS8weDUwCj4gWzwwPl0gcmV0X2Zyb21f
Zm9ya19hc20rMHgxYi8weDMwCgpCVFcsIC1yYzMgZml4ZXMgb25lIHNpbWlsYXIgaXNzdWUgb24g
dGhlIGFib3ZlIGNvZGUgcGF0aCwgc28gcGxlYXNlIHRyeSAtcmMzLgoKMTA2Mzk3Mzc2YzAzIHNi
aXRtYXA6IGZpeCBiYXRjaGluZyB3YWtldXAKClRoYW5rcywKTWluZyBMZWkKCi0tCmRtLWRldmVs
IG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQu
Y29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

