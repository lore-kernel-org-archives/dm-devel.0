Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 333CAC433EF
	for <dm-devel@archiver.kernel.org>; Wed, 29 Jun 2022 07:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656487871;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=PkKWJpwVZzaZSmI5tVOa26mODLrqDVxEKPpvggryJJU=;
	b=DuxlbaZU9705OBFyiIV3Yoes5tXhY3Fjo/Uu6T7hC7Q5vrfGpo3gX4YJrlJHXOO9fXiH2f
	vVQricgeaeW9tvzM0uUjnqgYWF4u+BWsUyZCoVbHWJXt3RnJDQNdciC4iEGC/OsdD5elD6
	/E/nJeYVVRHgQQrTfeSjudHwQ7A9iNI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-157-s-d9xuE3OZyyjw6uviGE8Q-1; Wed, 29 Jun 2022 03:31:07 -0400
X-MC-Unique: s-d9xuE3OZyyjw6uviGE8Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C5FDD1C006D2;
	Wed, 29 Jun 2022 07:31:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B36A2112131B;
	Wed, 29 Jun 2022 07:31:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id ECEB0194707C;
	Wed, 29 Jun 2022 07:31:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B8A001947056
 for <dm-devel@listman.corp.redhat.com>; Tue, 28 Jun 2022 18:44:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A63C39D63; Tue, 28 Jun 2022 18:44:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A1EC918EAA
 for <dm-devel@redhat.com>; Tue, 28 Jun 2022 18:44:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 832513C11C60
 for <dm-devel@redhat.com>; Tue, 28 Jun 2022 18:44:08 +0000 (UTC)
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com
 [209.85.219.50]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-622-kH3J2foXNQWwAmM7EfwMgw-1; Tue, 28 Jun 2022 14:44:06 -0400
X-MC-Unique: kH3J2foXNQWwAmM7EfwMgw-1
Received: by mail-qv1-f50.google.com with SMTP id cs6so21374085qvb.6
 for <dm-devel@redhat.com>; Tue, 28 Jun 2022 11:44:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=srd0vxfduo9pXREXizXvQ1Gwi/kEACFP1rdXcY0Aglg=;
 b=Tz/E60yI/0VMBOEvNOy2faXb8U1ZP3zJUGI9Ceb9mgMq+mlVIK8h3QmYD7L3M4ssvt
 S3KkQGCYAjfAfKq+27HgO0UXougmMb5uzqSX0/9w3C7Euw0CPqeTb8rn/EsbhflAoRRv
 WC9Y9Bc5kBHG2i7KyaMMozO+P3ciG6DAo12vTjQGxr7ENLJbKms39tJC7CaahDYOsUD/
 Hhd19ew0xaRD1kaWuGDPZCMR6QHhCU6JUthpuPxjuwPRWksXB0qvqFPrKDSBXGjX/PMg
 esI/juZXJ80d0TONwkK+19dP2iWxDxOpILK0QM+ivZy9XxfTVk4MmXlDGJDTcEdUddm5
 zlMA==
X-Gm-Message-State: AJIora9ePWpif57FKsAVAjSpmBY7F2KoEECiXTV5RRP6I+GAc4qjifkD
 nQLWplaRjA6Gp9jmROyQGwuotA==
X-Google-Smtp-Source: AGRyM1uBRJ6m7mmrK5Ju1JW1doBHC+UzIgAGX/xwYqaVx3XSmh4juFCDP3TjiYp7BZ5iZ3elpoeXxg==
X-Received: by 2002:a05:622a:7:b0:31b:74bd:1597 with SMTP id
 x7-20020a05622a000700b0031b74bd1597mr6494688qtw.677.1656441846052; 
 Tue, 28 Jun 2022 11:44:06 -0700 (PDT)
Received: from ziepe.ca
 (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net.
 [142.162.113.129]) by smtp.gmail.com with ESMTPSA id
 h9-20020ac85149000000b003050bd1f7c9sm9708477qtn.76.2022.06.28.11.44.04
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 28 Jun 2022 11:44:05 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94) (envelope-from <jgg@ziepe.ca>)
 id 1o6GBw-0035y2-Fs; Tue, 28 Jun 2022 15:44:04 -0300
Date: Tue, 28 Jun 2022 15:44:04 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Kees Cook <keescook@chromium.org>
Message-ID: <20220628184404.GS23621@ziepe.ca>
References: <20220627180432.GA136081@embeddedor>
 <6bc1e94c-ce1d-a074-7d0c-8dbe6ce22637@iogearbox.net>
 <20220628004052.GM23621@ziepe.ca> <202206281009.4332AA33@keescook>
MIME-Version: 1.0
In-Reply-To: <202206281009.4332AA33@keescook>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
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
 dri-devel@lists.freedesktop.org, "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 dm-devel@redhat.com, target-devel@vger.kernel.org,
 linux-mtd@lists.infradead.org, linux-hardening@vger.kernel.org,
 linux1394-devel@lists.sourceforge.net,
 linux-stm32@st-md-mailman.stormreply.com, linux-s390@vger.kernel.org,
 Daniel Borkmann <daniel@iogearbox.net>, linux-rdma@vger.kernel.org,
 x86@kernel.org, kasan-dev@googlegroups.com, lvs-devel@vger.kernel.org,
 coreteam@netfilter.org, v9fs-developer@lists.sourceforge.net,
 linux-mips@vger.kernel.org, intel-gfx@lists.freedesktop.org,
 linux-can@vger.kernel.org, linux-raid@vger.kernel.org,
 linux-m68k@lists.linux-m68k.org, virtualization@lists.linux-foundation.org,
 io-uring@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-scsi@vger.kernel.org, netdev@vger.kernel.org, linux-usb@vger.kernel.org,
 linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-sctp@vger.kernel.org,
 netfilter-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 bpf@vger.kernel.org, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jun 28, 2022 at 10:54:58AM -0700, Kees Cook wrote:

 
> which must also be assuming it's a header. So probably better to just
> drop the driver_data field? I don't see anything using it (that I can
> find) besides as a sanity-check that the field exists and is at the end
> of the struct.

The field is guaranteeing alignment of the following structure. IIRC
there are a few cases that we don't have a u64 already to force this.

Jason

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

