Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11591C43334
	for <dm-devel@archiver.kernel.org>; Tue, 28 Jun 2022 07:27:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-9-K2Qxt9-cOIyDIp3ny_csSA-1; Tue, 28 Jun 2022 03:27:44 -0400
X-MC-Unique: K2Qxt9-cOIyDIp3ny_csSA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 66BAF802C17;
	Tue, 28 Jun 2022 07:27:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1318D18EAA;
	Tue, 28 Jun 2022 07:27:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BF05F194704D;
	Tue, 28 Jun 2022 07:27:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 50F56194704D
 for <dm-devel@listman.corp.redhat.com>; Tue, 28 Jun 2022 07:27:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 30B0D492CA4; Tue, 28 Jun 2022 07:27:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2CA46492C3B
 for <dm-devel@redhat.com>; Tue, 28 Jun 2022 07:27:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1400D811E7A
 for <dm-devel@redhat.com>; Tue, 28 Jun 2022 07:27:40 +0000 (UTC)
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com
 [209.85.219.44]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-619-2bNAAdWeOLe2CdVIFaIvZw-1; Tue, 28 Jun 2022 03:27:38 -0400
X-MC-Unique: 2bNAAdWeOLe2CdVIFaIvZw-1
Received: by mail-qv1-f44.google.com with SMTP id i17so18728498qvo.13
 for <dm-devel@redhat.com>; Tue, 28 Jun 2022 00:27:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc:content-transfer-encoding;
 bh=hwgLtruPC06mcRCnQAsf+kJqHCP1mf00hTNnpiQ34M0=;
 b=OHOhwftnmSO+WdZFDOqcho76utpWNZRYuWoZ0Gjfwaca5sqHJHYkzpdeyNCYsDj90i
 BRmcxqfLmdwlR4hshZPxIDCBeHk8kkFc5WN8zEAIjx+8VaaVv4FPBZKxHz7XLbUSEKWX
 4rFOvNQSLLRIpS3X8I/fXQffozi1ZeqrI+dRSDKgIccVFC6k6Z/wxMiz83bbzFQFU/A7
 5vgvhVyCivek40g3KK6o43KvJmGHYNwmTBPCmVeaEg8jgJ9w2zmuAX9aGQ/NvtpEqYno
 KCinx/SSbT/04aFdqKhRtBE8empciHgwvDMohI8vAPkCATpS1QRTrB5ihOBIEOZXynNv
 XZxQ==
X-Gm-Message-State: AJIora8TMP9y+XwQGi+7j+V9KZPDW5Ibg8fWyKj0E2bSEZiO+0GhgwOw
 WaNmEp9KUMlFgwlTUpIyH2PTfkT/Fa0oB99L
X-Google-Smtp-Source: AGRyM1sqAoNEKLxLMygjcE4y83dLsZostehO348m2YbPVRkKUrNFbLsylbn4g1Vwkn0gx7qDq8g7ZQ==
X-Received: by 2002:ac8:5803:0:b0:305:2f14:269a with SMTP id
 g3-20020ac85803000000b003052f14269amr12345564qtg.290.1656401255912; 
 Tue, 28 Jun 2022 00:27:35 -0700 (PDT)
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com.
 [209.85.128.169]) by smtp.gmail.com with ESMTPSA id
 he18-20020a05622a601200b00317c38c8606sm3111221qtb.20.2022.06.28.00.27.33
 for <dm-devel@redhat.com>
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 28 Jun 2022 00:27:34 -0700 (PDT)
Received: by mail-yw1-f169.google.com with SMTP id
 00721157ae682-31bf327d4b5so18159367b3.13
 for <dm-devel@redhat.com>; Tue, 28 Jun 2022 00:27:33 -0700 (PDT)
X-Received: by 2002:a81:a092:0:b0:318:5c89:a935 with SMTP id
 x140-20020a81a092000000b003185c89a935mr20762801ywg.383.1656401253054; Tue, 28
 Jun 2022 00:27:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220627180432.GA136081@embeddedor>
In-Reply-To: <20220627180432.GA136081@embeddedor>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 28 Jun 2022 09:27:21 +0200
X-Gmail-Original-Message-ID: <CAMuHMdU27TG_rpd=WTRPRcY22A4j4aN-6d_8OmK2aNpX06G3ig@mail.gmail.com>
Message-ID: <CAMuHMdU27TG_rpd=WTRPRcY22A4j4aN-6d_8OmK2aNpX06G3ig@mail.gmail.com>
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
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
Cc: nvdimm@lists.linux.dev,
 ALSA Development Mailing List <alsa-devel@alsa-project.org>,
 KVM list <kvm@vger.kernel.org>,
 DRI Development <dri-devel@lists.freedesktop.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, dm-devel@redhat.com,
 target-devel <target-devel@vger.kernel.org>,
 MTD Maling List <linux-mtd@lists.infradead.org>,
 linux-hardening@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-s390 <linux-s390@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>,
 linux-rdma <linux-rdma@vger.kernel.org>,
 the arch/x86 maintainers <x86@kernel.org>,
 kasan-dev <kasan-dev@googlegroups.com>, lvs-devel@vger.kernel.org,
 coreteam@netfilter.org, V9FS Developers <v9fs-developer@lists.sourceforge.net>,
 Kees Cook <keescook@chromium.org>,
 Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
 linux-can@vger.kernel.org, linux-raid@vger.kernel.org,
 linux-m68k <linux-m68k@lists.linux-m68k.org>,
 virtualization@lists.linux-foundation.org, io-uring@vger.kernel.org,
 Linux ARM <linux-arm-kernel@lists.infradead.org>,
 netdev <netdev@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>,
 Linux MMC List <linux-mmc@vger.kernel.org>,
 "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
 linux-perf-users@vger.kernel.org, linux-sctp@vger.kernel.org,
 NetFilter <netfilter-devel@vger.kernel.org>,
 Linux FS Devel <linux-fsdevel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

SGkgR3VzdGF2bywKClRoYW5rcyBmb3IgeW91ciBwYXRjaCEKCk9uIE1vbiwgSnVuIDI3LCAyMDIy
IGF0IDg6MDQgUE0gR3VzdGF2byBBLiBSLiBTaWx2YQo8Z3VzdGF2b2Fyc0BrZXJuZWwub3JnPiB3
cm90ZToKPiBUaGVyZSBpcyBhIHJlZ3VsYXIgbmVlZCBpbiB0aGUga2VybmVsIHRvIHByb3ZpZGUg
YSB3YXkgdG8gZGVjbGFyZQo+IGhhdmluZyBhIGR5bmFtaWNhbGx5IHNpemVkIHNldCBvZiB0cmFp
bGluZyBlbGVtZW50cyBpbiBhIHN0cnVjdHVyZS4KPiBLZXJuZWwgY29kZSBzaG91bGQgYWx3YXlz
IHVzZSDigJxmbGV4aWJsZSBhcnJheSBtZW1iZXJz4oCdWzFdIGZvciB0aGVzZQo+IGNhc2VzLiBU
aGUgb2xkZXIgc3R5bGUgb2Ygb25lLWVsZW1lbnQgb3IgemVyby1sZW5ndGggYXJyYXlzIHNob3Vs
ZAo+IG5vIGxvbmdlciBiZSB1c2VkWzJdLgoKVGhlc2UgcnVsZXMgYXBwbHkgdG8gdGhlIGtlcm5l
bCwgYnV0IHVhcGkgaXMgbm90IGNvbnNpZGVyZWQgcGFydCBvZiB0aGUKa2VybmVsLCBzbyBkaWZm
ZXJlbnQgcnVsZXMgYXBwbHkuICBVYXBpIGhlYWRlciBmaWxlcyBzaG91bGQgd29yayB3aXRoCndo
YXRldmVyIGNvbXBpbGVyIHRoYXQgY2FuIGJlIHVzZWQgZm9yIGNvbXBpbGluZyB1c2Vyc3BhY2Uu
CgpHcntvZXRqZSxlZXRpbmd9cywKCiAgICAgICAgICAgICAgICAgICAgICAgIEdlZXJ0CgotLQpH
ZWVydCBVeXR0ZXJob2V2ZW4gLS0gVGhlcmUncyBsb3RzIG9mIExpbnV4IGJleW9uZCBpYTMyIC0t
IGdlZXJ0QGxpbnV4LW02OGsub3JnCgpJbiBwZXJzb25hbCBjb252ZXJzYXRpb25zIHdpdGggdGVj
aG5pY2FsIHBlb3BsZSwgSSBjYWxsIG15c2VsZiBhIGhhY2tlci4gQnV0CndoZW4gSSdtIHRhbGtp
bmcgdG8gam91cm5hbGlzdHMgSSBqdXN0IHNheSAicHJvZ3JhbW1lciIgb3Igc29tZXRoaW5nIGxp
a2UgdGhhdC4KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAtLSBMaW51cyBUb3J2YWxk
cwoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9s
aXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

