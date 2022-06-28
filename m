Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E497CCA47C
	for <dm-devel@archiver.kernel.org>; Wed, 29 Jun 2022 07:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656487866;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=GDrVmv6Hzk83NPl/HzWElB4YYpl71VZ00Gpwu4LXwMY=;
	b=fgeu6z8OAO10JsXGSanvc8JJ5264txfLnWLV8G3h7EuvIErfeHC0cF6j9KHgvBc7ioK7qZ
	S6G4TR0VbsE6SxVX7W84NIn15NPYCXnJqoPqUQzwNgoBdWigNvQkD/57tuU4pm+ovMspno
	7fWosb1EAy5qmc07HLGUCy46lbWZZf0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-507-MiBE8kurNSG86-OYa2Nycg-1; Wed, 29 Jun 2022 03:31:05 -0400
X-MC-Unique: MiBE8kurNSG86-OYa2Nycg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8025B3C10695;
	Wed, 29 Jun 2022 07:31:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EFFEF41616B;
	Wed, 29 Jun 2022 07:31:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 57D921947061;
	Wed, 29 Jun 2022 07:31:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E13E31947057
 for <dm-devel@listman.corp.redhat.com>; Tue, 28 Jun 2022 14:18:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C2122112131B; Tue, 28 Jun 2022 14:18:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BE6C31121314
 for <dm-devel@redhat.com>; Tue, 28 Jun 2022 14:18:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A425C381079B
 for <dm-devel@redhat.com>; Tue, 28 Jun 2022 14:18:32 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-299--l88RWHoP6GZQmKSwItsDg-1; Tue, 28 Jun 2022 10:18:30 -0400
X-MC-Unique: -l88RWHoP6GZQmKSwItsDg-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 48579B81E3B;
 Tue, 28 Jun 2022 14:18:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B5F2C341C6;
 Tue, 28 Jun 2022 14:18:25 +0000 (UTC)
Date: Tue, 28 Jun 2022 16:18:23 +0200
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
To: Stephen Hemminger <stephen@networkplumber.org>
Message-ID: <20220628141823.GB25163@embeddedor>
References: <20220627180432.GA136081@embeddedor>
 <20220627125343.44e24c41@hermes.local>
MIME-Version: 1.0
In-Reply-To: <20220627125343.44e24c41@hermes.local>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Mailman-Approved-At: Wed, 29 Jun 2022 07:31:01 +0000
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gTW9uLCBKdW4gMjcsIDIwMjIgYXQgMTI6NTM6NDNQTSAtMDcwMCwgU3RlcGhlbiBIZW1taW5n
ZXIgd3JvdGU6Cj4gVGhhbmtzIHRoaXMgZml4ZXMgd2FybmluZyB3aXRoIGdjYy0xMiBpbiBpcHJv
dXRlMi4KPiBJbiBmdW5jdGlvbiDigJh4ZnJtX2FsZ29fcGFyc2XigJksCj4gICAgIGlubGluZWQg
ZnJvbSDigJh4ZnJtX3N0YXRlX21vZGlmeS5jb25zdHByb3DigJkgYXQgeGZybV9zdGF0ZS5jOjU3
Mzo1Ogo+IHhmcm1fc3RhdGUuYzoxNjI6MzI6IHdhcm5pbmc6IHdyaXRpbmcgMSBieXRlIGludG8g
YSByZWdpb24gb2Ygc2l6ZSAwIFstV3N0cmluZ29wLW92ZXJmbG93PV0KPiAgIDE2MiB8ICAgICAg
ICAgICAgICAgICAgICAgICAgIGJ1ZltqXSA9IHZhbDsKPiAgICAgICB8ICAgICAgICAgICAgICAg
ICAgICAgICAgIH5+fn5+fn5efn5+fgoKR3JlYXQhIFRoaXMgZ2l2ZXMgbWUgaG9wZS4gOikKClRo
YW5rcwotLQpHdXN0YXZvCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0
LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs
Cg==

