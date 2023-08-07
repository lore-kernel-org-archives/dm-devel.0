Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C8D9C04FDF
	for <dm-devel@archiver.kernel.org>; Tue,  8 Aug 2023 06:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691477623;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=t282ME7iqur4fRq9R1zvDEOsGGvIg1AVwAUlnU1NfVg=;
	b=QOvxg9DnD9JSaADTPhx3IemvBHr9gTT1CK+ehSrspvPPrigZugx2dVoPUk1e/9wJ5svdEK
	DukQgJAwf2SO/zIXzfrGg5Ls4iQJhIDztXzSPZamzjVww76M4Geeza/nyNNd4JD9uT1KAY
	Akw2xdjCD6qNK9nX+Mb7qnm4M25uFgg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-280-Zac8kCWHO3GYgoklhyxu_A-1; Tue, 08 Aug 2023 02:53:37 -0400
X-MC-Unique: Zac8kCWHO3GYgoklhyxu_A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DECE3800159;
	Tue,  8 Aug 2023 06:53:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C27ED40D2842;
	Tue,  8 Aug 2023 06:53:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5B1CD194723A;
	Tue,  8 Aug 2023 06:53:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 81A931946586
 for <dm-devel@listman.corp.redhat.com>; Mon,  7 Aug 2023 14:16:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 952094021B9; Mon,  7 Aug 2023 14:16:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8CE9C4021AD
 for <dm-devel@redhat.com>; Mon,  7 Aug 2023 14:16:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 71A441C3A06B
 for <dm-devel@redhat.com>; Mon,  7 Aug 2023 14:16:13 +0000 (UTC)
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com
 [209.85.208.171]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-373-muvakltLNA-QNCfgo2xrUg-1; Mon, 07 Aug 2023 10:16:11 -0400
X-MC-Unique: muvakltLNA-QNCfgo2xrUg-1
Received: by mail-lj1-f171.google.com with SMTP id
 38308e7fff4ca-2b9ba3d6157so73207481fa.3
 for <dm-devel@redhat.com>; Mon, 07 Aug 2023 07:16:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1691417769; x=1692022569;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=mVE/GJTe1IuiufpABjiYZn1olHI1ifx/I1TivYEBHQg=;
 b=RU0j8eY2ccJ58RAsnpZxE+xF/oCNizyewqWV5NHhzc+W59P8FsQfXYMlJcZTH0ubnT
 OqVQVPOzzR/CkktNDXTFsK+P9FMdB/l4+NLIpeNbLTCbJy2wTdgWhwj9FMtm7obHbI0O
 r9j+VLslt2fBWqrT77zqrdtfwCOVVVzShfR+xIxmXThbuddzahT8TOUW5grhuL2mWGkq
 qZBGaOVj1qQRPf6mrVZn84Advc54Enmvsf03nVZ0HYebJSPxGoK3yUPtRUyIQZIRo+VE
 2u/KGBhMHhXG1ZgmsehaTATG+S/yFmt4Cqb1gePzvnpBR7uInpfdvfxE1sk9bUoHFags
 shHg==
X-Gm-Message-State: AOJu0Yzqk1ESYjIj5qYzAOBIq6Nf37BSOmunjVkoOzUxCxiymYL+tbJx
 Mtt2RtAeNF4qZCkkxymRJdh242BKk8y+Z2uuHuAvYA==
X-Google-Smtp-Source: AGHT+IGOrJUhdG+ahMA8bObfIwJouhmkY47ZzUfvTwinDgzhZuBpH+4Q7OaueJuZRAHK8xn8XVlTzjWWvAUYbt+ovvQ=
X-Received: by 2002:a2e:b166:0:b0:2b9:dd3b:cf43 with SMTP id
 a6-20020a2eb166000000b002b9dd3bcf43mr6572529ljm.13.1691417768626; Mon, 07 Aug
 2023 07:16:08 -0700 (PDT)
MIME-Version: 1.0
References: <20230807110936.21819-1-zhengqi.arch@bytedance.com>
 <20230807110936.21819-19-zhengqi.arch@bytedance.com>
In-Reply-To: <20230807110936.21819-19-zhengqi.arch@bytedance.com>
From: Joel Fernandes <joel@joelfernandes.org>
Date: Mon, 7 Aug 2023 10:16:03 -0400
Message-ID: <CAEXW_YTKHUeZHWtzeSG5Tt7MscNKjVTScBWkVDkC4Orisa7w=Q@mail.gmail.com>
To: Qi Zheng <zhengqi.arch@bytedance.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Tue, 08 Aug 2023 06:53:24 +0000
Subject: Re: [dm-devel] [PATCH v4 18/48] rcu: dynamically allocate the
 rcu-lazy shrinker
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
Cc: kvm@vger.kernel.org, djwong@kernel.org, roman.gushchin@linux.dev,
 david@fromorbit.com, dri-devel@lists.freedesktop.org,
 virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
 dm-devel@redhat.com, linux-mtd@lists.infradead.org, cel@kernel.org,
 x86@kernel.org, steven.price@arm.com, cluster-devel@redhat.com,
 simon.horman@corigine.com, xen-devel@lists.xenproject.org,
 linux-ext4@vger.kernel.org, paulmck@kernel.org, linux-arm-msm@vger.kernel.org,
 linux-nfs@vger.kernel.org, rcu@vger.kernel.org, linux-bcache@vger.kernel.org,
 dlemoal@kernel.org, yujie.liu@intel.com, vbabka@suse.cz,
 linux-raid@vger.kernel.org, brauner@kernel.org, tytso@mit.edu,
 gregkh@linuxfoundation.org, muchun.song@linux.dev,
 linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-xfs@vger.kernel.org, senozhatsky@chromium.org, netdev@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
 linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org, tkhai@ya.ru
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: joelfernandes.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gTW9uLCBBdWcgNywgMjAyMyBhdCA3OjM24oCvQU0gUWkgWmhlbmcgPHpoZW5ncWkuYXJjaEBi
eXRlZGFuY2UuY29tPiB3cm90ZToKPgo+IFVzZSBuZXcgQVBJcyB0byBkeW5hbWljYWxseSBhbGxv
Y2F0ZSB0aGUgcmN1LWxhenkgc2hyaW5rZXIuCj4KPiBTaWduZWQtb2ZmLWJ5OiBRaSBaaGVuZyA8
emhlbmdxaS5hcmNoQGJ5dGVkYW5jZS5jb20+CgpGb3IgUkNVOgpSZXZpZXdlZC1ieTogSm9lbCBG
ZXJuYW5kZXMgKEdvb2dsZSkgPGpvZWxAam9lbGZlcm5hbmRlcy5vcmc+Cgp0aGFua3MsCgotIEpv
ZWwKCgo+IC0tLQo+ICBrZXJuZWwvcmN1L3RyZWVfbm9jYi5oIHwgMjAgKysrKysrKysrKystLS0t
LS0tLS0KPiAgMSBmaWxlIGNoYW5nZWQsIDExIGluc2VydGlvbnMoKyksIDkgZGVsZXRpb25zKC0p
Cj4KPiBkaWZmIC0tZ2l0IGEva2VybmVsL3JjdS90cmVlX25vY2IuaCBiL2tlcm5lbC9yY3UvdHJl
ZV9ub2NiLmgKPiBpbmRleCA1NTk4MjEyZDFmMjcuLmUxYzU5YzMzNzM4YSAxMDA2NDQKPiAtLS0g
YS9rZXJuZWwvcmN1L3RyZWVfbm9jYi5oCj4gKysrIGIva2VybmVsL3JjdS90cmVlX25vY2IuaAo+
IEBAIC0xMzk2LDEzICsxMzk2LDYgQEAgbGF6eV9yY3Vfc2hyaW5rX3NjYW4oc3RydWN0IHNocmlu
a2VyICpzaHJpbmssIHN0cnVjdCBzaHJpbmtfY29udHJvbCAqc2MpCj4KPiAgICAgICAgIHJldHVy
biBjb3VudCA/IGNvdW50IDogU0hSSU5LX1NUT1A7Cj4gIH0KPiAtCj4gLXN0YXRpYyBzdHJ1Y3Qg
c2hyaW5rZXIgbGF6eV9yY3Vfc2hyaW5rZXIgPSB7Cj4gLSAgICAgICAuY291bnRfb2JqZWN0cyA9
IGxhenlfcmN1X3Nocmlua19jb3VudCwKPiAtICAgICAgIC5zY2FuX29iamVjdHMgPSBsYXp5X3Jj
dV9zaHJpbmtfc2NhbiwKPiAtICAgICAgIC5iYXRjaCA9IDAsCj4gLSAgICAgICAuc2Vla3MgPSBE
RUZBVUxUX1NFRUtTLAo+IC19Owo+ICAjZW5kaWYgLy8gI2lmZGVmIENPTkZJR19SQ1VfTEFaWQo+
Cj4gIHZvaWQgX19pbml0IHJjdV9pbml0X25vaHoodm9pZCkKPiBAQCAtMTQxMCw2ICsxNDAzLDcg
QEAgdm9pZCBfX2luaXQgcmN1X2luaXRfbm9oeih2b2lkKQo+ICAgICAgICAgaW50IGNwdTsKPiAg
ICAgICAgIHN0cnVjdCByY3VfZGF0YSAqcmRwOwo+ICAgICAgICAgY29uc3Qgc3RydWN0IGNwdW1h
c2sgKmNwdW1hc2sgPSBOVUxMOwo+ICsgICAgICAgc3RydWN0IHNocmlua2VyICogX19tYXliZV91
bnVzZWQgbGF6eV9yY3Vfc2hyaW5rZXI7Cj4KPiAgI2lmIGRlZmluZWQoQ09ORklHX05PX0haX0ZV
TEwpCj4gICAgICAgICBpZiAodGlja19ub2h6X2Z1bGxfcnVubmluZyAmJiAhY3B1bWFza19lbXB0
eSh0aWNrX25vaHpfZnVsbF9tYXNrKSkKPiBAQCAtMTQzNiw4ICsxNDMwLDE2IEBAIHZvaWQgX19p
bml0IHJjdV9pbml0X25vaHoodm9pZCkKPiAgICAgICAgICAgICAgICAgcmV0dXJuOwo+Cj4gICNp
ZmRlZiBDT05GSUdfUkNVX0xBWlkKPiAtICAgICAgIGlmIChyZWdpc3Rlcl9zaHJpbmtlcigmbGF6
eV9yY3Vfc2hyaW5rZXIsICJyY3UtbGF6eSIpKQo+IC0gICAgICAgICAgICAgICBwcl9lcnIoIkZh
aWxlZCB0byByZWdpc3RlciBsYXp5X3JjdSBzaHJpbmtlciFcbiIpOwo+ICsgICAgICAgbGF6eV9y
Y3Vfc2hyaW5rZXIgPSBzaHJpbmtlcl9hbGxvYygwLCAicmN1LWxhenkiKTsKPiArICAgICAgIGlm
ICghbGF6eV9yY3Vfc2hyaW5rZXIpIHsKPiArICAgICAgICAgICAgICAgcHJfZXJyKCJGYWlsZWQg
dG8gYWxsb2NhdGUgbGF6eV9yY3Ugc2hyaW5rZXIhXG4iKTsKPiArICAgICAgIH0gZWxzZSB7Cj4g
KyAgICAgICAgICAgICAgIGxhenlfcmN1X3Nocmlua2VyLT5jb3VudF9vYmplY3RzID0gbGF6eV9y
Y3Vfc2hyaW5rX2NvdW50Owo+ICsgICAgICAgICAgICAgICBsYXp5X3JjdV9zaHJpbmtlci0+c2Nh
bl9vYmplY3RzID0gbGF6eV9yY3Vfc2hyaW5rX3NjYW47Cj4gKyAgICAgICAgICAgICAgIGxhenlf
cmN1X3Nocmlua2VyLT5zZWVrcyA9IERFRkFVTFRfU0VFS1M7Cj4gKwo+ICsgICAgICAgICAgICAg
ICBzaHJpbmtlcl9yZWdpc3RlcihsYXp5X3JjdV9zaHJpbmtlcik7Cj4gKyAgICAgICB9Cj4gICNl
bmRpZiAvLyAjaWZkZWYgQ09ORklHX1JDVV9MQVpZCj4KPiAgICAgICAgIGlmICghY3B1bWFza19z
dWJzZXQocmN1X25vY2JfbWFzaywgY3B1X3Bvc3NpYmxlX21hc2spKSB7Cj4gLS0KPiAyLjMwLjIK
PgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9s
aXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

