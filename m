Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF97CCCA47E
	for <dm-devel@archiver.kernel.org>; Tue, 28 Jun 2022 06:38:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-434-hZ1mUpgcOb6UNS4H79CcYw-1; Tue, 28 Jun 2022 02:38:06 -0400
X-MC-Unique: hZ1mUpgcOb6UNS4H79CcYw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6C2F6805F4C;
	Tue, 28 Jun 2022 06:38:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 038901121314;
	Tue, 28 Jun 2022 06:38:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C5568194704D;
	Tue, 28 Jun 2022 06:38:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E9FE519466DF
 for <dm-devel@listman.corp.redhat.com>; Mon, 27 Jun 2022 19:53:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DE09318EA8; Mon, 27 Jun 2022 19:53:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D95A418EAF
 for <dm-devel@redhat.com>; Mon, 27 Jun 2022 19:53:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B13B4398CA61
 for <dm-devel@redhat.com>; Mon, 27 Jun 2022 19:53:50 +0000 (UTC)
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com
 [209.85.215.174]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-OAcjOwEWNpO8KFqgtAAvwg-1; Mon, 27 Jun 2022 15:53:48 -0400
X-MC-Unique: OAcjOwEWNpO8KFqgtAAvwg-1
Received: by mail-pg1-f174.google.com with SMTP id s206so1054307pgs.3
 for <dm-devel@redhat.com>; Mon, 27 Jun 2022 12:53:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=k/l4LcE4w+6LYrCo6/Ek+44r04gbnpHm9yyPA0qKR6A=;
 b=Ch5JRb8o537gHpy1UZsXiEXA9U4yxjs6nlAb57w9vxxlU0n6MnTOUAC7/Qxqdfjequ
 ShLRGamrm1xy1ZW9B0q+KbJi6kKg8PyankHwdYdKCwESVl60plWRoiZe3Hb8rt5pZ0wL
 F1uR2hdmGw9FHviHmGdYh4U9mDtBBLf66CK8NoAdmFId39yBztD2x1JhKYN+8pB8LVIP
 apqG/zoLEoNP2d8QzsYpy5n8M1SEDfxGxHPnQyfdOFVoPMkLzVxf2CNaOxH0QPHX3Vzf
 pvEUy6BRhF1/q8RpBrhD1EHfc+3XwE4KT6oBLos6fV6JKq+YQfvZeasoxVt2LQ5ithWf
 ivSQ==
X-Gm-Message-State: AJIora/KMfRix/XcmTe+eEcrXW2ygwv/7He/U3QTriQHxsIPVNnqRYaK
 P4Ul60JxQWMIb57JudDUVXUaqw==
X-Google-Smtp-Source: AGRyM1ssDeW6Ux1oaY9ixgaaapzXMFszbxcRVeOWaHAYiiaVMZ4HUYtPzqxXzR6I8+fqeJNf8u9hpg==
X-Received: by 2002:a63:7a5d:0:b0:40c:fcbe:4799 with SMTP id
 j29-20020a637a5d000000b0040cfcbe4799mr14428539pgn.297.1656359626928; 
 Mon, 27 Jun 2022 12:53:46 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
 by smtp.gmail.com with ESMTPSA id
 c16-20020a056a00009000b0051c1b445094sm7821510pfj.7.2022.06.27.12.53.45
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 27 Jun 2022 12:53:46 -0700 (PDT)
Date: Mon, 27 Jun 2022 12:53:43 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Message-ID: <20220627125343.44e24c41@hermes.local>
In-Reply-To: <20220627180432.GA136081@embeddedor>
References: <20220627180432.GA136081@embeddedor>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Mailman-Approved-At: Tue, 28 Jun 2022 06:38:00 +0000
Subject: Re: [dm-devel] [PATCH][next] treewide: uapi: Replace zero-length
 arrays with flexible-array members
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
Cc: nvdimm@lists.linux.dev, alsa-devel@alsa-project.org, kvm@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 dm-devel@redhat.com, target-devel@vger.kernel.org,
 linux-mtd@lists.infradead.org, linux-hardening@vger.kernel.org,
 linux1394-devel@lists.sourceforge.net,
 linux-stm32@st-md-mailman.stormreply.com, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org, x86@kernel.org,
 kasan-dev@googlegroups.com, lvs-devel@vger.kernel.org, coreteam@netfilter.org,
 v9fs-developer@lists.sourceforge.net, Kees Cook <keescook@chromium.org>,
 intel-gfx@lists.freedesktop.org, linux-can@vger.kernel.org,
 linux-raid@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
 virtualization@lists.linux-foundation.org, io-uring@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
 linux-usb@vger.kernel.org, linux-mmc@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-sctp@vger.kernel.org, netfilter-devel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gTW9uLCAyNyBKdW4gMjAyMiAyMDowNDozMiArMDIwMAoiR3VzdGF2byBBLiBSLiBTaWx2YSIg
PGd1c3Rhdm9hcnNAa2VybmVsLm9yZz4gd3JvdGU6Cgo+IFRoZXJlIGlzIGEgcmVndWxhciBuZWVk
IGluIHRoZSBrZXJuZWwgdG8gcHJvdmlkZSBhIHdheSB0byBkZWNsYXJlCj4gaGF2aW5nIGEgZHlu
YW1pY2FsbHkgc2l6ZWQgc2V0IG9mIHRyYWlsaW5nIGVsZW1lbnRzIGluIGEgc3RydWN0dXJlLgo+
IEtlcm5lbCBjb2RlIHNob3VsZCBhbHdheXMgdXNlIOKAnGZsZXhpYmxlIGFycmF5IG1lbWJlcnPi
gJ1bMV0gZm9yIHRoZXNlCj4gY2FzZXMuIFRoZSBvbGRlciBzdHlsZSBvZiBvbmUtZWxlbWVudCBv
ciB6ZXJvLWxlbmd0aCBhcnJheXMgc2hvdWxkCj4gbm8gbG9uZ2VyIGJlIHVzZWRbMl0uCj4gCj4g
VGhpcyBjb2RlIHdhcyB0cmFuc2Zvcm1lZCB3aXRoIHRoZSBoZWxwIG9mIENvY2NpbmVsbGU6Cj4g
KGxpbnV4LTUuMTktcmMyJCBzcGF0Y2ggLS1qb2JzICQoZ2V0Y29uZiBfTlBST0NFU1NPUlNfT05M
TikgLS1zcC1maWxlIHNjcmlwdC5jb2NjaSAtLWluY2x1ZGUtaGVhZGVycyAtLWRpciAuID4gb3V0
cHV0LnBhdGNoKQo+IAo+IEBACj4gaWRlbnRpZmllciBTLCBtZW1iZXIsIGFycmF5Owo+IHR5cGUg
VDEsIFQyOwo+IEBACj4gCj4gc3RydWN0IFMgewo+ICAgLi4uCj4gICBUMSBtZW1iZXI7Cj4gICBU
MiBhcnJheVsKPiAtIDAKPiAgIF07Cj4gfTsKPiAKPiAtZnN0cmljdC1mbGV4LWFycmF5cz0zIGlz
IGNvbWluZyBhbmQgd2UgbmVlZCB0byBsYW5kIHRoZXNlIGNoYW5nZXMKPiB0byBwcmV2ZW50IGlz
c3VlcyBsaWtlIHRoZXNlIGluIHRoZSBzaG9ydCBmdXR1cmU6Cj4gCj4gLi4vZnMvbWluaXgvZGly
LmM6MzM3OjM6IHdhcm5pbmc6ICdzdHJjcHknIHdpbGwgYWx3YXlzIG92ZXJmbG93OyBkZXN0aW5h
dGlvbiBidWZmZXIgaGFzIHNpemUgMCwKPiBidXQgdGhlIHNvdXJjZSBzdHJpbmcgaGFzIGxlbmd0
aCAyIChpbmNsdWRpbmcgTlVMIGJ5dGUpIFstV2ZvcnRpZnktc291cmNlXQo+IAkJc3RyY3B5KGRl
My0+bmFtZSwgIi4iKTsKPiAJCV4KPiAKPiBTaW5jZSB0aGVzZSBhcmUgYWxsIFswXSB0byBbXSBj
aGFuZ2VzLCB0aGUgcmlzayB0byBVQVBJIGlzIG5lYXJseSB6ZXJvLiBJZgo+IHRoaXMgYnJlYWtz
IGFueXRoaW5nLCB3ZSBjYW4gdXNlIGEgdW5pb24gd2l0aCBhIG5ldyBtZW1iZXIgbmFtZS4KPiAK
PiBbMV0gaHR0cHM6Ly9lbi53aWtpcGVkaWEub3JnL3dpa2kvRmxleGlibGVfYXJyYXlfbWVtYmVy
Cj4gWzJdIGh0dHBzOi8vd3d3Lmtlcm5lbC5vcmcvZG9jL2h0bWwvdjUuMTYvcHJvY2Vzcy9kZXBy
ZWNhdGVkLmh0bWwjemVyby1sZW5ndGgtYW5kLW9uZS1lbGVtZW50LWFycmF5cwo+IAo+IExpbms6
IGh0dHBzOi8vZ2l0aHViLmNvbS9LU1BQL2xpbnV4L2lzc3Vlcy83OAo+IEJ1aWxkLXRlc3RlZC1i
eTogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC82MmI2NzVlYy53S1g2QU9aNmNiRTcxdnRG
JTI1bGtwQGludGVsLmNvbS8KPiBTaWduZWQtb2ZmLWJ5OiBHdXN0YXZvIEEuIFIuIFNpbHZhIDxn
dXN0YXZvYXJzQGtlcm5lbC5vcmc+CgpUaGFua3MgdGhpcyBmaXhlcyB3YXJuaW5nIHdpdGggZ2Nj
LTEyIGluIGlwcm91dGUyLgpJbiBmdW5jdGlvbiDigJh4ZnJtX2FsZ29fcGFyc2XigJksCiAgICBp
bmxpbmVkIGZyb20g4oCYeGZybV9zdGF0ZV9tb2RpZnkuY29uc3Rwcm9w4oCZIGF0IHhmcm1fc3Rh
dGUuYzo1NzM6NToKeGZybV9zdGF0ZS5jOjE2MjozMjogd2FybmluZzogd3JpdGluZyAxIGJ5dGUg
aW50byBhIHJlZ2lvbiBvZiBzaXplIDAgWy1Xc3RyaW5nb3Atb3ZlcmZsb3c9XQogIDE2MiB8ICAg
ICAgICAgICAgICAgICAgICAgICAgIGJ1ZltqXSA9IHZhbDsKICAgICAgfCAgICAgICAgICAgICAg
ICAgICAgICAgICB+fn5+fn5+Xn5+fn4KCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZl
bEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8v
ZG0tZGV2ZWwK

