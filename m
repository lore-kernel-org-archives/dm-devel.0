Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 477C8C05051
	for <dm-devel@archiver.kernel.org>; Tue,  8 Aug 2023 06:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691477628;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=OjgtiLwMmxs84ujZ3gHoqFr65Ajd7vhZMy+oILONfL4=;
	b=FNCcLYD1H95GgEeBDkxBF9ucvSFdFd8Qw6kRLdOjLK2KdlM+knkP7G8gY7SSax+fOIzijw
	K9xo/vFIQG5VG7bSm9/rxZAhLKCRLXzBm4wI0fYKlF9qQDIhzAsyDEIxtlLNX2rDZ5QdRo
	pSn4BM1oeyCwqf748HH/2z0JZI61/Lo=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-277-ed9gve-YNKST0O2Smp7qdQ-1; Tue, 08 Aug 2023 02:53:44 -0400
X-MC-Unique: ed9gve-YNKST0O2Smp7qdQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F21A32806066;
	Tue,  8 Aug 2023 06:53:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DDAB34EA5A;
	Tue,  8 Aug 2023 06:53:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E32F41947234;
	Tue,  8 Aug 2023 06:53:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5F0821946586
 for <dm-devel@listman.corp.redhat.com>; Mon,  7 Aug 2023 14:14:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 770B92026D76; Mon,  7 Aug 2023 14:14:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6F2772026D68
 for <dm-devel@redhat.com>; Mon,  7 Aug 2023 14:14:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4FCDB101A59A
 for <dm-devel@redhat.com>; Mon,  7 Aug 2023 14:14:57 +0000 (UTC)
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com
 [209.85.208.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-197-18zctPO9OBubUA5XDcETOA-1; Mon, 07 Aug 2023 10:14:55 -0400
X-MC-Unique: 18zctPO9OBubUA5XDcETOA-1
Received: by mail-lj1-f175.google.com with SMTP id
 38308e7fff4ca-2b9db1de50cso69908901fa.3
 for <dm-devel@redhat.com>; Mon, 07 Aug 2023 07:14:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1691417694; x=1692022494;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=miXhKIkPE3lmozcU/B+jO2gbohIQfxtvXQrL6JQrLaA=;
 b=T8gthU6de2qtZssUD0Bjxmlu46+AQ0OSB0B1N3+jcV3b8SlOlIuVV/j2g7ysooYF8K
 7MMfjcRFOzGJ3LjUk4f0llzc/K/kKFMZKwV0FWmMBYndQIQhWTjHVYQXZXsKexx8R3EQ
 tu7/EI+CqczuUn3uB3i4N1p/sROcZdySwf5fgkw6X/kJYpsnU8wzd8Mf0qWfCRwSvq8l
 eZsztRLKBqLZEZP5qRaCd84U8+PUxEXlfhzS5wWtAGMtSCxZ0UG1M7KTXDoA69dwrlhi
 oaUhmWwn0H3WYXDiv+HylYV5MujUdMD8pp4UK/xIZipmKNbM0ILLTWKV+pVkJTX3iHu1
 evgw==
X-Gm-Message-State: AOJu0YyEQN2ZAVoE91s9pX/RjWbAf9D4aINBzih0oUq0wLaowjcrbiY6
 KKxnodVvFI4kPwtn2ecb087xTgl9umavNUojalzSBA==
X-Google-Smtp-Source: AGHT+IEUzxQ8uhfef4Gwj5w4R2S1a/fG2YmFdaAnrERcAODuTjnUg5MW8ffcyCI3WwFTK01hsv/WyE2OTkrmMwFZBOU=
X-Received: by 2002:a2e:9254:0:b0:2b6:dfef:d526 with SMTP id
 v20-20020a2e9254000000b002b6dfefd526mr6547671ljg.11.1691417693488; Mon, 07
 Aug 2023 07:14:53 -0700 (PDT)
MIME-Version: 1.0
References: <20230807110936.21819-1-zhengqi.arch@bytedance.com>
 <20230807110936.21819-20-zhengqi.arch@bytedance.com>
In-Reply-To: <20230807110936.21819-20-zhengqi.arch@bytedance.com>
From: Joel Fernandes <joel@joelfernandes.org>
Date: Mon, 7 Aug 2023 10:14:48 -0400
Message-ID: <CAEXW_YQHGBE2kKupLf12BGOEU5GnQsBUtVQcyMnzxUZ4y48QFA@mail.gmail.com>
To: Qi Zheng <zhengqi.arch@bytedance.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Tue, 08 Aug 2023 06:53:24 +0000
Subject: Re: [dm-devel] [PATCH v4 19/48] rcu: dynamically allocate the
 rcu-kfree shrinker
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: joelfernandes.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gTW9uLCBBdWcgNywgMjAyMyBhdCA3OjE34oCvQU0gUWkgWmhlbmcgPHpoZW5ncWkuYXJjaEBi
eXRlZGFuY2UuY29tPiB3cm90ZToKPgo+IFVzZSBuZXcgQVBJcyB0byBkeW5hbWljYWxseSBhbGxv
Y2F0ZSB0aGUgcmN1LWtmcmVlIHNocmlua2VyLgo+Cj4gU2lnbmVkLW9mZi1ieTogUWkgWmhlbmcg
PHpoZW5ncWkuYXJjaEBieXRlZGFuY2UuY29tPgoKRm9yIFJDVToKUmV2aWV3ZWQtYnk6IEpvZWwg
RmVybmFuZGVzIChHb29nbGUpIDxqb2VsQGpvZWxmZXJuYW5kZXMub3JnPgoKdGhhbmtzLAoKLSBK
b2VsCgoKPiAtLS0KPiAga2VybmVsL3JjdS90cmVlLmMgfCAyMiArKysrKysrKysrKysrLS0tLS0t
LS0tCj4gIDEgZmlsZSBjaGFuZ2VkLCAxMyBpbnNlcnRpb25zKCspLCA5IGRlbGV0aW9ucygtKQo+
Cj4gZGlmZiAtLWdpdCBhL2tlcm5lbC9yY3UvdHJlZS5jIGIva2VybmVsL3JjdS90cmVlLmMKPiBp
bmRleCA3Yzc5NDgwYmZhYTAuLjNiMjBmYzQ2YzUxNCAxMDA2NDQKPiAtLS0gYS9rZXJuZWwvcmN1
L3RyZWUuYwo+ICsrKyBiL2tlcm5lbC9yY3UvdHJlZS5jCj4gQEAgLTM0NDksMTMgKzM0NDksNiBA
QCBrZnJlZV9yY3Vfc2hyaW5rX3NjYW4oc3RydWN0IHNocmlua2VyICpzaHJpbmssIHN0cnVjdCBz
aHJpbmtfY29udHJvbCAqc2MpCj4gICAgICAgICByZXR1cm4gZnJlZWQgPT0gMCA/IFNIUklOS19T
VE9QIDogZnJlZWQ7Cj4gIH0KPgo+IC1zdGF0aWMgc3RydWN0IHNocmlua2VyIGtmcmVlX3JjdV9z
aHJpbmtlciA9IHsKPiAtICAgICAgIC5jb3VudF9vYmplY3RzID0ga2ZyZWVfcmN1X3Nocmlua19j
b3VudCwKPiAtICAgICAgIC5zY2FuX29iamVjdHMgPSBrZnJlZV9yY3Vfc2hyaW5rX3NjYW4sCj4g
LSAgICAgICAuYmF0Y2ggPSAwLAo+IC0gICAgICAgLnNlZWtzID0gREVGQVVMVF9TRUVLUywKPiAt
fTsKPiAtCj4gIHZvaWQgX19pbml0IGtmcmVlX3JjdV9zY2hlZHVsZXJfcnVubmluZyh2b2lkKQo+
ICB7Cj4gICAgICAgICBpbnQgY3B1Owo+IEBAIC00OTMxLDYgKzQ5MjQsNyBAQCBzdGF0aWMgdm9p
ZCBfX2luaXQga2ZyZWVfcmN1X2JhdGNoX2luaXQodm9pZCkKPiAgewo+ICAgICAgICAgaW50IGNw
dTsKPiAgICAgICAgIGludCBpLCBqOwo+ICsgICAgICAgc3RydWN0IHNocmlua2VyICprZnJlZV9y
Y3Vfc2hyaW5rZXI7Cj4KPiAgICAgICAgIC8qIENsYW1wIGl0IHRvIFswOjEwMF0gc2Vjb25kcyBp
bnRlcnZhbC4gKi8KPiAgICAgICAgIGlmIChyY3VfZGVsYXlfcGFnZV9jYWNoZV9maWxsX21zZWMg
PCAwIHx8Cj4gQEAgLTQ5NjIsOCArNDk1NiwxOCBAQCBzdGF0aWMgdm9pZCBfX2luaXQga2ZyZWVf
cmN1X2JhdGNoX2luaXQodm9pZCkKPiAgICAgICAgICAgICAgICAgSU5JVF9ERUxBWUVEX1dPUkso
JmtyY3AtPnBhZ2VfY2FjaGVfd29yaywgZmlsbF9wYWdlX2NhY2hlX2Z1bmMpOwo+ICAgICAgICAg
ICAgICAgICBrcmNwLT5pbml0aWFsaXplZCA9IHRydWU7Cj4gICAgICAgICB9Cj4gLSAgICAgICBp
ZiAocmVnaXN0ZXJfc2hyaW5rZXIoJmtmcmVlX3JjdV9zaHJpbmtlciwgInJjdS1rZnJlZSIpKQo+
IC0gICAgICAgICAgICAgICBwcl9lcnIoIkZhaWxlZCB0byByZWdpc3RlciBrZnJlZV9yY3UoKSBz
aHJpbmtlciFcbiIpOwo+ICsKPiArICAgICAgIGtmcmVlX3JjdV9zaHJpbmtlciA9IHNocmlua2Vy
X2FsbG9jKDAsICJyY3Uta2ZyZWUiKTsKPiArICAgICAgIGlmICgha2ZyZWVfcmN1X3Nocmlua2Vy
KSB7Cj4gKyAgICAgICAgICAgICAgIHByX2VycigiRmFpbGVkIHRvIGFsbG9jYXRlIGtmcmVlX3Jj
dSgpIHNocmlua2VyIVxuIik7Cj4gKyAgICAgICAgICAgICAgIHJldHVybjsKPiArICAgICAgIH0K
PiArCj4gKyAgICAgICBrZnJlZV9yY3Vfc2hyaW5rZXItPmNvdW50X29iamVjdHMgPSBrZnJlZV9y
Y3Vfc2hyaW5rX2NvdW50Owo+ICsgICAgICAga2ZyZWVfcmN1X3Nocmlua2VyLT5zY2FuX29iamVj
dHMgPSBrZnJlZV9yY3Vfc2hyaW5rX3NjYW47Cj4gKyAgICAgICBrZnJlZV9yY3Vfc2hyaW5rZXIt
PnNlZWtzID0gREVGQVVMVF9TRUVLUzsKPiArCj4gKyAgICAgICBzaHJpbmtlcl9yZWdpc3Rlcihr
ZnJlZV9yY3Vfc2hyaW5rZXIpOwo+ICB9Cj4KPiAgdm9pZCBfX2luaXQgcmN1X2luaXQodm9pZCkK
PiAtLQo+IDIuMzAuMgo+CgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0
LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs
Cg==

