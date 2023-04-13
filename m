Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43270C77B61
	for <dm-devel@archiver.kernel.org>; Thu, 13 Apr 2023 18:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681411532;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=xsB6RR+D2MkBNA0Anboyue64rDdTlnuVhGfqt4RCzo0=;
	b=a9gdhEOMif9Q25rTFFOShlCnco/JUfIJtOvHMx5laGPbpGs6m+9rrymztPk12YU7WtEzrA
	foIrQPJ1m3uofJ1KGAL88eXr28ipJQM69A/dbfw2aLNMppzIUrvEUm+nHqiod19zeerj2k
	zSVpk+nRHcJLIwiOxM13N2RsSCe+Yk0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-179-pgflAMAoME2deiI3DIelxg-1; Thu, 13 Apr 2023 14:45:29 -0400
X-MC-Unique: pgflAMAoME2deiI3DIelxg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4AA8B101A54F;
	Thu, 13 Apr 2023 18:45:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 732B740C6E70;
	Thu, 13 Apr 2023 18:45:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5E81C19465B7;
	Thu, 13 Apr 2023 18:45:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 419DB19465B6
 for <dm-devel@listman.corp.redhat.com>; Thu, 13 Apr 2023 18:45:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2F749C16028; Thu, 13 Apr 2023 18:45:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 26EB4C158BB
 for <dm-devel@redhat.com>; Thu, 13 Apr 2023 18:45:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0265185A5A3
 for <dm-devel@redhat.com>; Thu, 13 Apr 2023 18:45:23 +0000 (UTC)
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com
 [209.85.128.176]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-632-3RntfMNCOf6XrIgYz8SRpw-1; Thu, 13 Apr 2023 14:45:18 -0400
X-MC-Unique: 3RntfMNCOf6XrIgYz8SRpw-1
Received: by mail-yw1-f176.google.com with SMTP id
 00721157ae682-54f21cdfadbso248971987b3.7
 for <dm-devel@redhat.com>; Thu, 13 Apr 2023 11:45:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1681411518; x=1684003518;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=MGVZNEf7lrdlhRrTeBd55Bww7LzB9MuzQSkzPr2CJBo=;
 b=hkqfhDYodIW+IoN7ytIg/Tn+0BCIoPCI9zc1UgYk8k3z2l4FXluD9pEYnhBKyFwHz4
 aIm52LisQSxQwoyXX28aVzW42JFXGJTuZxrEl/+EN/NX4gkI7Z4nRdpRc8Ok5emG0xwC
 UJSPfLDAheJDU7XX6tytCAyr+NAQk5xxoqyQvDFX/Qvsxvqvhm7HvwkYDACSBWkcwFNV
 udeDTJQJ+rNmtixJNXK7hwouQVHpPgr2CJCpKDJFTiybYfjjqKrNeo+pFAwVHdkL6cLb
 cocOeUh/W9Lb6dC/hhipqtFkast3lmcXUSpslIczFKm7SFFeU1gQSa8xsbr1m/pCUfqC
 NpwQ==
X-Gm-Message-State: AAQBX9cl/gESI8QgE7xXCQmyzLdC/Dp9zeS0vZEikYe/yGh+kqraIi/O
 /HJvB6PUfmUE0Muso0zDMovzCtpQCWi55U5njRmL
X-Google-Smtp-Source: AKy350ZSG4ZQ++QqMTXNV8xFD2qqYaKbcU1NDBLoxRwPk1AbUSa/40FcxEeI1OBDZ0AsmT83U2FNdY17CZtIHnOARvk=
X-Received: by 2002:a81:ad0e:0:b0:545:6106:5334 with SMTP id
 l14-20020a81ad0e000000b0054561065334mr2002041ywh.8.1681411517875; Thu, 13 Apr
 2023 11:45:17 -0700 (PDT)
MIME-Version: 1.0
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-6-git-send-email-wufan@linux.microsoft.com>
 <CAHC9VhRa+NwKzLfQBmHfMgUp6_d5soQG7JBq-Vn=MUeUAt4tuQ@mail.gmail.com>
 <20230410191035.GB18827@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <CAHC9VhQDvWDshaZvJrHmjcwyHFxv9oYTN9bn0xiTtFZQRp+GPg@mail.gmail.com>
 <20230412233606.GA16658@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
In-Reply-To: <20230412233606.GA16658@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
From: Paul Moore <paul@paul-moore.com>
Date: Thu, 13 Apr 2023 14:45:07 -0400
Message-ID: <CAHC9VhTs3Njfg=1baQ6=58rPLBmyB3cW0R-MfAaEcRF-jAaYBw@mail.gmail.com>
To: Fan Wu <wufan@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [RFC PATCH v9 05/16] ipe: add userspace interface
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
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, tytso@mit.edu,
 dm-devel@redhat.com, corbet@lwn.net, roberto.sassu@huawei.com,
 Deven Bowers <deven.desai@linux.microsoft.com>, linux-doc@vger.kernel.org,
 snitzer@kernel.org, jmorris@namei.org, zohar@linux.ibm.com,
 linux-kernel@vger.kernel.org, ebiggers@kernel.org,
 linux-security-module@vger.kernel.org, linux-audit@redhat.com,
 eparis@redhat.com, linux-fscrypt@vger.kernel.org,
 linux-integrity@vger.kernel.org, agk@redhat.com, serge@hallyn.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: paul-moore.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gV2VkLCBBcHIgMTIsIDIwMjMgYXQgNzozNuKAr1BNIEZhbiBXdSA8d3VmYW5AbGludXgubWlj
cm9zb2Z0LmNvbT4gd3JvdGU6Cj4gT24gVHVlLCBBcHIgMTEsIDIwMjMgYXQgMDU6NDU6NDFQTSAt
MDQwMCwgUGF1bCBNb29yZSB3cm90ZToKPiA+IE9uIE1vbiwgQXByIDEwLCAyMDIzIGF0IDM6MTA/
Pz9QTSBGYW4gV3UgPHd1ZmFuQGxpbnV4Lm1pY3Jvc29mdC5jb20+IHdyb3RlOgo+ID4gPiBPbiBU
aHUsIE1hciAwMiwgMjAyMyBhdCAwMjowNDo0MlBNIC0wNTAwLCBQYXVsIE1vb3JlIHdyb3RlOgo+
ID4gPiA+IE9uIE1vbiwgSmFuIDMwLCAyMDIzIGF0IDU6NTg/Pz9QTSBGYW4gV3UgPHd1ZmFuQGxp
bnV4Lm1pY3Jvc29mdC5jb20+IHdyb3RlOgoKLi4uCgo+ID4gSSBndWVzcyB0aGlzIGRvZXMgbWFr
ZSBtZSB3b25kZXIgYWJvdXQga2VlcGluZyBhIG5vbi1hY3RpdmUgcG9saWN5Cj4gPiBsb2FkZWQg
aW4gdGhlIGtlcm5lbCwgd2hhdCBwdXJwb3NlIGRvZXMgdGhhdCBzZXJ2ZT8KPiA+Cj4KPiBUaGUg
bm9uLWFjdGl2ZSBwb2xpY3kgZG9lc24ndCBzZXJ2ZSBhbnl0aGluZyB1bmxlc3MgaXQgaXMgYWN0
aXZhdGVkLiBVc2VyIGNhbgo+IGV2ZW4gZGVsZXRlIGEgcG9saWN5IGlmIHRoYXQgaXMgbm8gbG9u
Z2VyIG5lZWRlZC4gTm9uLWFjdGl2ZSBpcyBqdXN0IHRoZSBkZWZhdWx0Cj4gc3RhdGUgd2hlbiBh
IG5ldyBwb2xpY3kgaXMgbG9hZGVkLgo+Cj4gSWYgSVBFIHN1cHBvcnRzIG5hbWVzcGFjZSwgdGhl
cmUgaXMgYW5vdGhlciB1c2UgY2FzZSB3aGVyZSBkaWZmZXJlbnQgY29udGFpbmVycwo+IGNhbiBz
ZWxlY3QgZGlmZmVyZW50IHBvbGljaWVzIGFzIHRoZSBhY3RpdmUgcG9saWN5IGZyb20gYW1vbmcg
bXVsdGlwbGUgbG9hZGVkCj4gcG9saWNpZXMuIERldmVuIGhhcyBwcmVzZW50ZWQgYSBkZW1vIG9m
IHRoaXMgZHVyaW5nIExTUyAyMDIxLiBCdXQgdGhpcyBnb2VzCj4gYmV5b25kIHRoZSBzY29wZSBv
ZiB0aGlzIHZlcnNpb24uCgpEbyB5b3UgcGxhbiB0byBhZGQgbmFtZXNwYWNlIHN1cHBvcnQgYXQg
c29tZSBwb2ludCBpbiB0aGUKbm90LXRvby1kaXN0YW50IGZ1dHVyZT8gIElmIHNvLCBJJ20gb2th
eSB3aXRoIGtlZXBpbmcgc3VwcG9ydCBmb3IKbXVsdGlwbGUgcG9saWNpZXMsIGJ1dCBpZiB5b3Ug
dGhpbmsgeW91J3JlIG9ubHkgZ29pbmcgdG8gc3VwcG9ydCBvbmUKYWN0aXZlIHBvbGljeSBhdCBh
IHRpbWUsIGl0IG1pZ2h0IGJlIGJldHRlciB0byByZW1vdmUgc3VwcG9ydCBmb3IKbXVsdGlwbGUg
KGluYWN0aXZlKSBwb2xpY2llcy4KCi0tIApwYXVsLW1vb3JlLmNvbQoKLS0KZG0tZGV2ZWwgbWFp
bGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20v
bWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

