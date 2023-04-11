Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0A50C76196
	for <dm-devel@archiver.kernel.org>; Tue, 11 Apr 2023 23:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681255335;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=z1z7z5qUlsvetWXLORFkfVxufDbTICCsAk1ojqWFgoI=;
	b=NvOHI5z3FfgOReK1vif3CfPEIJf0U+8gdCdFenO97vCQatjZQw2id5dyLFEmqehStGOusT
	0c4o0EwVtj5Zub0/aOE5d5l/89bSGKa36ffwrTKIqxbtJSVqDjmoWxBTjxs2VYec47WyX3
	yurY55n9GsCcgAqShHNp2cDakARqkA8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-508-KTZPYqq1MLy7prxfV2-Erw-1; Tue, 11 Apr 2023 19:22:12 -0400
X-MC-Unique: KTZPYqq1MLy7prxfV2-Erw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 62DC085A588;
	Tue, 11 Apr 2023 23:22:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 04CC4C15BB8;
	Tue, 11 Apr 2023 23:22:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C448F1946A41;
	Tue, 11 Apr 2023 23:22:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F1A4C19466DF
 for <dm-devel@listman.corp.redhat.com>; Tue, 11 Apr 2023 23:22:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E201A47CE1; Tue, 11 Apr 2023 23:22:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DA02C47CDC
 for <dm-devel@redhat.com>; Tue, 11 Apr 2023 23:22:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BB468811E7C
 for <dm-devel@redhat.com>; Tue, 11 Apr 2023 23:22:07 +0000 (UTC)
Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com
 [209.85.219.177]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-662-qQipAZJiMkiCjHc-BOLAkg-1; Tue, 11 Apr 2023 19:22:04 -0400
X-MC-Unique: qQipAZJiMkiCjHc-BOLAkg-1
Received: by mail-yb1-f177.google.com with SMTP id u13so10099833ybu.5
 for <dm-devel@redhat.com>; Tue, 11 Apr 2023 16:22:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1681255323; x=1683847323;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=mjieG96zBNQQG2PDV49OxJZ6+3G2K7bw1ZbVf6U1lzk=;
 b=wuQy3mGDCpCld906tZ8HcxO/TIHdlT7NOFU3wOWV8swAiD+7PCzMMh1nTkx6GU4dYC
 b9El4pgsGMyfof2gQqFwZ8DZlvGD6vJBp7F1QiOM6KksFbJiRdVymuMPxopSACNV5jnN
 VuY+2pS/Pk+BYMsI54CloKJvCEBJYEHsgD68PzTvnQIP9TDI30YgNozH/kRaPZhSlAu/
 c0Dy8xdDZ3CYAsQGDgwGUHNirhdkm+VlHG5fB+q+CmMxYG4tbCDGHqyPZdDVagE+TYsF
 +E082OGIx48Pm1frxx9hzHrQozkPmyO6o7TulO/MaT940bUQkyRvVaubn+JR38C5/fkK
 /X5g==
X-Gm-Message-State: AAQBX9fsidbUk9zcwncRAQxI59v6tDRm9fZwSrDzoXeUPq8u0J6gErDt
 oZ84V0HG6m1IQpXwec1DLwETdqWeTRf9qnZpew6u
X-Google-Smtp-Source: AKy350Y8Rhd9rHz1qCSxaAF3gL9UQq1FI0yq/mFrHh6N2pKJ6DGoHbpLYYEOHTWZcax61zY11aqLEAa5SLJ9oKG9DsM=
X-Received: by 2002:a25:cace:0:b0:b8f:2f68:93b0 with SMTP id
 a197-20020a25cace000000b00b8f2f6893b0mr1197248ybg.3.1681255323520; Tue, 11
 Apr 2023 16:22:03 -0700 (PDT)
MIME-Version: 1.0
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-8-git-send-email-wufan@linux.microsoft.com>
 <3723852.kQq0lBPeGt@x2>
 <CAHC9VhRqMrTuvVtwzJoK2U=6O1QuaQ8ceA6+qm=6ib0TOUEeSw@mail.gmail.com>
In-Reply-To: <CAHC9VhRqMrTuvVtwzJoK2U=6O1QuaQ8ceA6+qm=6ib0TOUEeSw@mail.gmail.com>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 11 Apr 2023 19:21:52 -0400
Message-ID: <CAHC9VhSt1TzpkqGKGXy-4RDBqSQ5+1D9D2JwN1Rw-5G=b=uy3g@mail.gmail.com>
To: Steve Grubb <sgrubb@redhat.com>, linux-audit@redhat.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [RFC PATCH v9 07/16] uapi|audit|ipe: add ipe
 auditing support
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
Cc: axboe@kernel.dk, linux-security-module@vger.kernel.org, tytso@mit.edu,
 corbet@lwn.net, roberto.sassu@huawei.com,
 Deven Bowers <deven.desai@linux.microsoft.com>, linux-doc@vger.kernel.org,
 snitzer@kernel.org, jmorris@namei.org, zohar@linux.ibm.com,
 linux-kernel@vger.kernel.org, ebiggers@kernel.org, dm-devel@redhat.com,
 Fan Wu <wufan@linux.microsoft.com>, linux-block@vger.kernel.org,
 eparis@redhat.com, linux-fscrypt@vger.kernel.org,
 linux-integrity@vger.kernel.org, agk@redhat.com, serge@hallyn.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: paul-moore.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVGh1LCBNYXIgMiwgMjAyMyBhdCAyOjA14oCvUE0gUGF1bCBNb29yZSA8cGF1bEBwYXVsLW1v
b3JlLmNvbT4gd3JvdGU6Cj4gT24gVHVlLCBKYW4gMzEsIDIwMjMgYXQgMTI6MTHigK9QTSBTdGV2
ZSBHcnViYiA8c2dydWJiQHJlZGhhdC5jb20+IHdyb3RlOgo+ID4gT24gTW9uZGF5LCBKYW51YXJ5
IDMwLCAyMDIzIDU6NTc6MjIgUE0gRVNUIEZhbiBXdSB3cm90ZToKCi4uLgoKPiA+ID4gICBhdWRp
dDogTUFDX1BPTElDWV9MT0FEIHBvbGljeV9uYW1lPSJkbXZlcml0eV9yb290aGFzaCIKPiA+ID4g
ICAgIHBvbGljeV92ZXJzaW9uPTAuMC4wIHNoYTI1Nj1EQzY3QUMxOUUwNTg5NEVGQjMxNzBBOEU1
NURFNTI5Nzk0RTI0OEMyCj4gPiA+ICAgICBhdWlkPTQyOTQ5NjcyOTUgc2VzPTQyOTQ5NjcyOTUg
bHNtPWlwZSByZXM9MQo+ID4KPiA+IFRoZSBNQUNfUE9MSUNZX0xPQUQgcmVjb3JkIHR5cGUgc2lt
cGx5IHN0YXRlcyB0aGUgbHNtIHRoYXQgaGFkIGl0J3MgcG9saWN5Cj4gPiBsb2FkZWQuIFRoZXJl
IGlzbid0IG5hbWUsIHZlcnNpb24sIGFuZCBoYXNoIGluZm9ybWF0aW9uLiBJJ2QgcHJlZmVyIHRv
IHNlZQo+ID4gYWxsIHVzZXJzIG9mIHRoaXMgcmVjb3JkIHR5cGUgZGVjaWRlIGlmIGl0IHNob3Vs
ZCBiZSBleHRlbmRlZCBiZWNhdXNlIHRoZXkKPiA+IGFsc28gaGF2ZSB0aGF0IGluZm9ybWF0aW9u
IGF2YWlsYWJsZSB0byByZWNvcmQuCj4KPiBOb3QgYWxsIExTTXMgd2hpY2ggbG9hZCBwb2xpY3kg
aGF2ZSB0aGF0IGluZm9ybWF0aW9uOyBhcyBhbiBleGFtcGxlLAo+IFNFTGludXggZG9lc24ndCBo
YXZlIHRoZSBjb25jZXB0IG9mIGEgcG9saWN5IG5hbWUgb3IgdmVyc2lvbi4gIFRoZQo+IFNFTGlu
dXggcG9saWN5IHZlcnNpb24geW91IG1pZ2h0IHNlZSBpbiB0aGUga2VybmVsIHNvdXJjZXMgcmVm
ZXJzIHRvCj4gdGhlIHBvbGljeSBmb3JtYXQgdmVyc2lvbiBhbmQgaGFzIG5vIGJlYXJpbmcgb24g
dGhlIGFjdHVhbCBwb2xpY3kKPiBjb250ZW50IGJleW9uZCB0aGF0IGRpY3RhdGVkIGJ5IHRoZSBm
b3JtYXQuCj4KPiBJZiBhZGRpdGlvbmFsIGluZm9ybWF0aW9uIGlzIHJlcXVpcmVkIGJ5IElQRSwg
cGVyaGFwcyBhbiBhdXhpbGlhcnkgSVBFCj4gcG9saWN5IGxvYWQgcmVjb3JkIGNvdWxkIGJlIGNy
ZWF0ZWQgd2l0aCB0aG9zZSBhZGRpdGlvbmFsIGZpZWxkcy4KClRoZSBpc3N1ZSBvZiBwb2xpY3kg
bG9hZCBhdWRpdCByZWNvcmRzIGNhbWUgdXAgaW4gYW4gb2ZmbGluZQpkaXNjdXNzaW9uIHdpdGgg
RmFuIHRvZGF5IGFuZCBJIHRoaW5rIGl0J3Mgd29ydGggdGFsa2luZyBhYm91dCB0aGlzIGEKYml0
IG1vcmUgdG8gcmVhY2ggc29tZSBjb25zZW5zdXMuCgpDdXJyZW50bHkgb25seSBTRUxpbnV4IGdl
bmVyYXRlcyBNQUNfUE9MSUNZX0xPQUQgcmVjb3JkcywgYW5kIGl0CmNvbnRhaW5zIGFsbCBvZiB0
aGUgaW5mb3JtYXRpb24gdGhhdCBpcyBwcmVzZW50IGluIHRoZSBJUEUgZXhhbXBsZQphYm92ZSB3
aXRoIHRoZSBleGNlcHRpb24gb2YgdGhlICdwb2xpY3lfbmFtZScsICdwb2xpY3lfdmVyc2lvbics
IGFuZAp0aGUgcG9saWN5IGRpZ2VzdC4gIEkgcGVyc29uYWxseSBkb24ndCBoYXZlIGEgcHJvYmxl
bSBleHRlbmRpbmcgdGhlCk1BQ19QT0xJQ1lfTE9BRCByZWNvcmQgd2l0aCB0aGVzZSBmaWVsZHMs
IGFuZCBsZWF2aW5nIHRoZW0gdW51c2VkLyI/IgppbiB0aGUgU0VMaW51eCBnZW5lcmF0ZWQgcmVj
b3Jkcy4gIEl0J3MgcG9zc2libGUgd2UgbWF5IGV2ZW4gd2FudCB0bwp1c2UgdGhlIHBvbGljeSBk
aWdlc3QgZmllbGQgYXQgc29tZSBwb2ludCwgYXMgaXQgd291bGQgYmUgbmljZSB0byBiZQphYmxl
IHRvIGhhdmUgc29tZSBwb2xpY3kgImtleSIgd2l0aGluIFNFTGludXggdGhhdCBjb3VsZCBiZSB1
c2VkIHRvCmhlbHAgaWRlbnRpZnkgdGhlIGxvYWRlZCBwb2xpY3kuCgpUaGUgb25seSBjYXRjaCBp
cyB0aGF0IHdlIG1heSB3YW50IHRvIGZpbmQgYSBiZXR0ZXIgZmllbGQgbmFtZSB0aGFuCmp1c3Qg
J3NoYTI1NicsIGluIHRoZSBjb250ZXh0IG9mIHRoZSBNQUNfUE9MSUNZX0xPQUQgcmVjb3JkIGl0
IHNlZW1zCmVhc2lseSB1bmRlcnN0b29kLCBidXQgaW4gdGhlIGxhcmdlciBjb250ZXh0IG9mIGEg
ZnVsbCBhdWRpdCBzdHJlYW0gaXQKbWlnaHQgYmUgdG9vIGFtYmlndW91cy4gIFdlIHdvdWxkIGFs
c28gbmVlZCB0byBkZWNpZGUgaWYgd2Ugd2FudGVkIHRvCmVuY29kZSB0aGUgZGlnZXN0IGFsZ29y
aXRobSBpbiB0aGUgZmllbGQgbmFtZSwgdGhlIGZpZWxkIHZhbHVlLCBvcgpoYXZlIGl0IGFzIGEg
c2VwYXJhdGUgZmllbGQuICBJIG1pZ2h0IGxlYW4gdG93YXJkcyBlbmNvZGluZyBpdCBpbiB0aGUK
ZmllbGQgdmFsdWUgbGlrZSB0aGlzOgoKICBwb2xpY3lfZGlnZXN0PXNoYTI1NjpYWFhYWAoKLi4u
IGhvd2V2ZXIgdGhhdCBpcyBzb21ldGhpbmcgdGhhdCB3b3VsZCBuZWVkIHNvbWUgZGlzY3Vzc2lv
biBmcm9tIHRoZQpvdGhlciBmb2xrcyBvbiB0aGUgVG8vQ0MgbGluZS4KCi0tIApwYXVsLW1vb3Jl
LmNvbQoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6
Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

