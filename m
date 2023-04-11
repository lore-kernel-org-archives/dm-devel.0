Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9015C76196
	for <dm-devel@archiver.kernel.org>; Tue, 11 Apr 2023 23:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681254496;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=eOAh/TP+OqgWlSOxgo5JghOo55K/8N0xlmGaBsfNtV0=;
	b=UptUd6j7U4ghMABNhH3SgdnDDJT/1J2tVnqA9bWGAiTOGB/hvmseL4C872+27ImhCWjBXE
	HRw3yn6LyDlIeFM7spe0ozdVrpvBDPsvu0ZzsPiBbqBddcafVpJYWaVBeaaq0l481Oqmmg
	NRuyNclNaqSE6rHr/4kUkD7i6nldqm0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586-wxoCkQDwM9mN8s4awnNj3Q-1; Tue, 11 Apr 2023 19:08:15 -0400
X-MC-Unique: wxoCkQDwM9mN8s4awnNj3Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A45228996F0;
	Tue, 11 Apr 2023 23:08:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 338BD202701E;
	Tue, 11 Apr 2023 23:08:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CA2601946A41;
	Tue, 11 Apr 2023 23:08:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5064319466DF
 for <dm-devel@listman.corp.redhat.com>; Tue, 11 Apr 2023 23:08:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3180E14171D5; Tue, 11 Apr 2023 23:08:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2971E1402403
 for <dm-devel@redhat.com>; Tue, 11 Apr 2023 23:08:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EE4A129AA2CA
 for <dm-devel@redhat.com>; Tue, 11 Apr 2023 23:08:10 +0000 (UTC)
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com
 [209.85.219.170]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-450-0KbdKHtAO0yO9mu5wW3yfQ-1; Tue, 11 Apr 2023 19:08:09 -0400
X-MC-Unique: 0KbdKHtAO0yO9mu5wW3yfQ-1
Received: by mail-yb1-f170.google.com with SMTP id h198so16452358ybg.12
 for <dm-devel@redhat.com>; Tue, 11 Apr 2023 16:08:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1681254489; x=1683846489;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=eIyxfCRdtVW6DZEqESNyM82Zcjpw6q1yxE2SLi7Q/10=;
 b=Kh+05GBjh9Vo1FlQgLPhpvXncEWGf2nVS8aDARwaL3glb+KtRnTGhlXEOodQzMRZAQ
 4Bf1VVXwjblhP+j6C66KEcbzVCrjvjjqcFP7hNkJeHogqQ3z17BtuEyAQBAlyTkhtwWq
 N1KSNqTFHo9JdAC3KdmzlM+Xt+BoLzIEmPsP0/xQdLLq3OF1S/JjqqcEqZDkf1XE1fyy
 rGze/VV3YSXF9Ii+CZ5vtsa97IjmfQnL9eVkDMZeRG8IPRdk2BeqMXHhRwbRFqFc/KRu
 4fuW47Fu/ipGhgWR7uK0K6au+zAXpGvVkMGNEfhHIx1tpoT//bGiUGVtaDAAMDpwLAwO
 YdBg==
X-Gm-Message-State: AAQBX9dsiVoksrND8WxvE3ywVbGS8M3Fk0c32tJU9fUTz1TXe2j+Kb+z
 tmm7EGg31jWvJHTFb6M9RBefAuiHdS5RS9C24eZ+
X-Google-Smtp-Source: AKy350YGpKFShus1wXg4P7JDpOEQwCA2ZUIAFxOOzluNG03DhrMlLa19ZC7t5ZHiN0J6rZ9Xc6wbx1W+NEq2mwRq1zY=
X-Received: by 2002:a25:d702:0:b0:b68:7a4a:5258 with SMTP id
 o2-20020a25d702000000b00b687a4a5258mr377571ybg.3.1681254488697; Tue, 11 Apr
 2023 16:08:08 -0700 (PDT)
MIME-Version: 1.0
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-8-git-send-email-wufan@linux.microsoft.com>
 <3723852.kQq0lBPeGt@x2>
 <CAHC9VhRqMrTuvVtwzJoK2U=6O1QuaQ8ceA6+qm=6ib0TOUEeSw@mail.gmail.com>
 <20230316225340.GB22567@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
In-Reply-To: <20230316225340.GB22567@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 11 Apr 2023 19:07:57 -0400
Message-ID: <CAHC9VhQxxrDnzJmUitMid3fk-VwNRU3NWoqjpj1=rhrtpoE=7w@mail.gmail.com>
To: Fan Wu <wufan@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
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
 linux-audit@redhat.com, linux-block@vger.kernel.org, eparis@redhat.com,
 linux-fscrypt@vger.kernel.org, Steve Grubb <sgrubb@redhat.com>,
 linux-integrity@vger.kernel.org, agk@redhat.com, serge@hallyn.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: paul-moore.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVGh1LCBNYXIgMTYsIDIwMjMgYXQgNjo1M+KAr1BNIEZhbiBXdSA8d3VmYW5AbGludXgubWlj
cm9zb2Z0LmNvbT4gd3JvdGU6Cj4gT24gVGh1LCBNYXIgMDIsIDIwMjMgYXQgMDI6MDU6MzNQTSAt
MDUwMCwgUGF1bCBNb29yZSB3cm90ZToKPiA+IE9uIFR1ZSwgSmFuIDMxLCAyMDIzIGF0IDEyOjEx
Pz8/UE0gU3RldmUgR3J1YmIgPHNncnViYkByZWRoYXQuY29tPiB3cm90ZToKPiA+ID4KPiA+ID4g
SGVsbG8sCj4gPiA+Cj4gPiA+IE9uIE1vbmRheSwgSmFudWFyeSAzMCwgMjAyMyA1OjU3OjIyIFBN
IEVTVCBGYW4gV3Ugd3JvdGU6Cj4gPiA+ID4gRnJvbTogRGV2ZW4gQm93ZXJzIDxkZXZlbi5kZXNh
aUBsaW51eC5taWNyb3NvZnQuY29tPgo+ID4gPiA+Cj4gPiA+ID4gVXNlcnMgb2YgSVBFIHJlcXVp
cmUgYSB3YXkgdG8gaWRlbnRpZnkgd2hlbiBhbmQgd2h5IGFuIG9wZXJhdGlvbiBmYWlscywKPiA+
ID4gPiBhbGxvd2luZyB0aGVtIHRvIGJvdGggcmVzcG9uZCB0byB2aW9sYXRpb25zIG9mIHBvbGlj
eSBhbmQgYmUgbm90aWZpZWQKPiA+ID4gPiBvZiBwb3RlbnRpYWxseSBtYWxpY2lvdXMgYWN0aW9u
cyBvbiB0aGVpciBzeXN0ZW5zIHdpdGggcmVzcGVjdCB0byBJUEUKPiA+ID4gPiBpdHNlbGYuCj4g
PiA+ID4KPiA+ID4gPiBUaGUgbmV3IDE0MjAgYXVkaXQsIEFVRElUX0lQRV9BQ0NFU1MgaW5kaWNh
dGVzIHRoZSByZXN1bHQgb2YgYSBwb2xpY3kKPiA+ID4gPiBldmF1bGF0aW9uIG9mIGEgcmVzb3Vy
Y2UuIFRoZSBvdGhlciB0d28gZXZlbnRzLCBBVURJVF9NQUNfUE9MSUNZX0xPQUQsCj4gPiA+ID4g
YW5kIEFVRElUX01BQ19DT05GSUdfQ0hBTkdFIHJlcHJlc2VudCBhIG5ldyBwb2xpY3kgd2FzIGxv
YWRlZCBpbnRvIHRoZQo+ID4gPiA+IGtlcm5lbCBhbmQgdGhlIGN1cnJlbnRseSBhY3RpdmUgcG9s
aWN5IGNoYW5nZWQsIHJlc3BlY3RpdmVseS4KPiA+ID4KPiA+ID4gVHlwaWNhbGx5IHdoZW4geW91
IHJldXNlIGFuIGV4aXN0aW5nIHJlY29yZCB0eXBlLCBpdCBpcyBleHBlY3RlZCB0byBtYWludGFp
bgo+ID4gPiB0aGUgc2FtZSBmaWVsZHMgaW4gdGhlIHNhbWUgb3JkZXIuIEFsc28sIGl0IGlzIGV4
cGVjdCB0aGF0IGZpZWxkcyB0aGF0IGFyZQo+ID4gPiBjb21tb24gYWNyb3NzIGRpZmVyZW50IHJl
Y29yZHMgaGF2ZSB0aGUgc2FtZSBtZWFuaW5nLiBUbyBhaWQgaW4gdGhpcywgd2UgaGF2ZQo+ID4g
PiBhIGZpZWxkIGRpY3Rpb25hcnkgaGVyZToKPiA+ID4KPiA+ID4gaHR0cHM6Ly9naXRodWIuY29t
L2xpbnV4LWF1ZGl0L2F1ZGl0LWRvY3VtZW50YXRpb24vYmxvYi9tYWluL3NwZWNzL2ZpZWxkcy8K
PiA+ID4gZmllbGQtZGljdGlvbmFyeS5jc3YKPiA+ID4KPiA+ID4gRm9yIGV4YW1wbGUsIGRldiBp
cyBleHBlY3RlZCB0byBiZSAyIGhleCBudW1iZXJzIHNlcGFyYXRlZCBieSBhIGNvbG9uIHdoaWNo
Cj4gPiA+IGFyZSB0aGUgZGV2aWNlIG1ham9yIGFuZCBtaW5vciBudW1iZXJzLiBCdXQgZG93biBh
IGNvdXBsZSBsaW5lcyBmcm9tIGhlcmUsIHdlCj4gPiA+IGZpbmQgZGV2PSJ0bXBmcyIuIEJ1dCBp
c24ndCB0aGF0IGEgZmlsZXN5c3RlbSB0eXBlPwo+ID4KPiA+IFdoYXQgU3RldmUgc2FpZC4KPiA+
Cj4gPiBJJ2xsIGFsc28gYWRkIGFuIGFkbWluaXN0cmF0aXZlIG5vdGUsIHdlIGp1c3QgbW92ZWQg
dXBzdHJlYW0gTGludXgKPiA+IGF1ZGl0IGRldmVsb3BtZW50IHRvIGEgbmV3IG1haWxpbmcgbGlz
dCwgYXVkaXRAdmdlci5rZXJuZWwub3JnLCBwbGVhc2UKPiA+IHVzZSB0aGF0IGluIGZ1dHVyZSBw
YXRjaCBzdWJtaXNzaW9ucy4gIEFzIGEgcG9zaXRpdmUsIGl0J3MgYSBmdWxseQo+ID4gb3BlbiBs
aXN0IHNvIHlvdSB3b24ndCBydW4gaW50byBtb2RlcmF0aW9uIGRlbGF5cy9ub3RpZmljYXRpb25z
L2V0Yy4KPiA+Cj4gVGhhbmtzIGZvciB0aGUgaW5mbywgSSB3aWxsIHVwZGF0ZSB0aGUgYWRkcmVz
cy4KPgo+ID4gPiA+IFRoaXMgcGF0Y2ggYWxzbyBhZGRzIHN1cHBvcnQgZm9yIHN1Y2Nlc3MgYXVk
aXRpbmcsIGFsbG93aW5nIHVzZXJzIHRvCj4gPiA+ID4gaWRlbnRpZnkgaG93IGEgcmVzb3VyY2Ug
cGFzc2VkIHBvbGljeS4gSXQgaXMgcmVjb21tZW5kZWQgdG8gdXNlIHRoaXMKPiA+ID4gPiBvcHRp
b24gd2l0aCBjYXV0aW9uLCBhcyBpdCBpcyBxdWl0ZSBub2lzeS4KPiA+ID4gPgo+ID4gPiA+IFRo
aXMgcGF0Y2ggYWRkcyB0aGUgZm9sbG93aW5nIGF1ZGl0IHJlY29yZHM6Cj4gPiA+ID4KPiA+ID4g
PiAgIGF1ZGl0OiBBVURJVDE0MjAgcGF0aD0iL3RtcC90bXB3eG1hbTM2Ni9kZW55L2Jpbi9oZWxs
byIgZGV2PSJ0bXBmcyIKPiA+ID4gPiAgICAgaW5vPTcyIHJ1bGU9IkRFRkFVTFQgb3A9RVhFQ1VU
RSBhY3Rpb249REVOWSIKPiA+ID4KPiA+ID4gRG8gd2UgcmVhbGx5IG5lZWQgdG8gbG9nIHRoZSB3
aG9sZSBydWxlPwo+ID4KPiA+IEZhbiwgd291bGQgaXQgYmUgcmVhc29uYWJsZSB0byBsaXN0IHRo
ZSBwcm9wZXJ0aWVzIHdoaWNoIGNhdXNlZCB0aGUKPiA+IGFjY2VzcyBkZW5pYWw/ICBUaGF0IHNl
ZW1zIGxpa2UgaXQgbWlnaHQgYmUgbW9yZSBoZWxwZnVsIHRoYW4gdGhlCj4gPiBzcGVjaWZpYyBy
dWxlLCBvciBhbSBJIG1pc3Npbmcgc29tZXRoaW5nPwo+Cj4gQXVkaXQgdGhlIHdob2xlIHJ1bGUg
Y2FuIGxldCB0aGUgdXNlciBmaW5kIHRoZSByZWFzb24gb2YgYSBwb2xpY3kgZGVjaXNpb24uCj4g
V2UgbmVlZCB0aGUgd2hvbGUgcnVsZSBiZWNhdXNlIGFuIGFsbG93L2Jsb2NrIGlzIG5vdCBjYXVz
ZWQgYnkgYSBzcGVjaWZpYwo+IHByb3BlcnR5LCBidXQgdGhlIGNvbWJpbmF0aW9uIG9mIGFsbCBw
cm9wZXJ0eSBjb25kaXRpb25zIGluIGEgcnVsZS4KCk9rYXksIHRoYXQncyBhIHJlYXNvbmFibGUg
YXJndW1lbnQgZm9yIGxvZ2dpbmcgdGhlIHJ1bGUgYWxvbmcgd2l0aCB0aGUKZGVjaXNpb24uICBJ
IHRoaW5rIGl0IGhlbHBzIHRoYXQgdGhlIElQRSBwb2xpY3kgcnVsZXMgYXJlIG5vdApwYXJ0aWN1
bGFybHkgbG9uZy4KCj4gV2UgY291bGQgYWxzbyBhZGQgYSB2ZXJib3NlIHN3aXRjaCBzdWNoIHRo
YXQgd2Ugb25seSBhdWRpdAo+IHRoZSB3aG9sZSBydWxlIHdoZW4gYSB1c2VyIHR1cm5lZCB0aGUg
dmVyYm9zZSBzd2l0Y2ggb24uCgpJJ20gbm90IHN1cmUgdGhhdCdzIG5lY2Vzc2FyeSwgYW5kIGhv
bmVzdGx5IGl0IG1pZ2h0IGJlIGFubm95aW5nIGFzIHdlCndvdWxkIHN0aWxsIG5lZWQgdG8gb3V0
cHV0IGEgJ3J1bGU9Ij8iJyBmaWVsZCBpbiB0aGUgYXVkaXQgcmVjb3JkIGFzCml0IGlzIGNvbnNp
ZGVyZWQgZ29vZCBwcmFjdGljZSB0byBub3QgaGF2ZSBmaWVsZHMgbWFnaWNhbGx5IGFwcGVhciBh
bmQKZGlzYXBwZWFyIGZyb20gdGhlIHJlY29yZCBmb3JtYXQuICBIb3dldmVyLCBpZiB0aGVyZSBh
cmUgY29uY2VybnMKYWJvdXQgcmVjb3JkIHNpemVzLCB0aGF0IGNvdWxkIGJlIGEgcG90ZW50aWFs
IG1pdGlnYXRpb24uCgotLSAKcGF1bC1tb29yZS5jb20KCi0tCmRtLWRldmVsIG1haWxpbmcgbGlz
dApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4v
bGlzdGluZm8vZG0tZGV2ZWwK

