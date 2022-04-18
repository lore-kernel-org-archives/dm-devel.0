Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E1ABC433FE
	for <dm-devel@archiver.kernel.org>; Tue, 19 Apr 2022 06:10:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-380-M0vO0suaPbmh3ypk_uXW-w-1; Tue, 19 Apr 2022 02:10:36 -0400
X-MC-Unique: M0vO0suaPbmh3ypk_uXW-w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DB29B8037A4;
	Tue, 19 Apr 2022 06:10:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C6C2240FF412;
	Tue, 19 Apr 2022 06:10:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 69580193F6E7;
	Tue, 19 Apr 2022 06:10:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8AB551947BBB
 for <dm-devel@listman.corp.redhat.com>; Mon, 18 Apr 2022 22:43:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 54121C5097E; Mon, 18 Apr 2022 22:43:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4FE4BC50975
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 22:43:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 34F0B80005D
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 22:43:32 +0000 (UTC)
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com
 [209.85.215.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-75-pYBjgS0qO5eY7RT-AHqgbQ-1; Mon, 18 Apr 2022 18:43:30 -0400
X-MC-Unique: pYBjgS0qO5eY7RT-AHqgbQ-1
Received: by mail-pg1-f175.google.com with SMTP id k29so21425639pgm.12
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 15:43:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=MWGw+I8Rgl/opd43ebHHMAj95ulAD46oHN9fU4DvNpo=;
 b=xO9vNwv7DcbgV5F2FXXxI4nF+iA1P8WfxWdt0t4KYl0sl+TnGVBlwNE146QBaZKzpF
 hyhNKsniqy0Ll+DFkrWI5ACjCEAJxt2JvlgTHS37IxLWcgaIk5emgRR4gJ9DMjEl+SIJ
 CDghoB68wFZovfTpt7BiuuXUo0SlidAeauVl2I2PwNZBnqtg0AlCutE1CfSvqVkCIg/p
 EBbjCS2Sg/zpJnb9UUKSt2oLvnOv7z25lSVDBFKxD5UsjtpE2P8y85P8DJ4+w51TJkou
 nO6taOPLPpkb+9MYHhblt0rz/MyFK6sO3gI5u6XfUTUT7SYj6NiCZLTkkxjTEyq57DoR
 82qA==
X-Gm-Message-State: AOAM530tImhjLRQaBq1sXiW7HQz67Iuks6bTR0ZzYACE36ubuWtD6LUA
 vcpy9lvwbOW7mDcGJarloAT7sQ==
X-Google-Smtp-Source: ABdhPJzCwRyTVg95a0VNni8DDkvimLaSN54/K64RZIVo/TLCFqUrkHEvTzI8UPMiQhfcOb3Sebf+WQ==
X-Received: by 2002:a63:5013:0:b0:399:5816:fd0d with SMTP id
 e19-20020a635013000000b003995816fd0dmr11795301pgb.68.1650321809394; 
 Mon, 18 Apr 2022 15:43:29 -0700 (PDT)
Received: from localhost ([2620:15c:202:201:6b32:a0a5:ec32:c287])
 by smtp.gmail.com with UTF8SMTPSA id
 e13-20020a63370d000000b003810782e0cdsm14078821pga.56.2022.04.18.15.43.28
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 18 Apr 2022 15:43:28 -0700 (PDT)
Date: Mon, 18 Apr 2022 15:43:27 -0700
From: Matthias Kaehlcke <mka@chromium.org>
To: Kees Cook <keescook@chromium.org>
Message-ID: <Yl3pj72hM/Bo+Kf5@google.com>
References: <20220418211559.3832724-1-mka@chromium.org>
 <202204181512.DA0C0C6EBD@keescook>
MIME-Version: 1.0
In-Reply-To: <202204181512.DA0C0C6EBD@keescook>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Mailman-Approved-At: Tue, 19 Apr 2022 06:10:27 +0000
Subject: Re: [dm-devel] [PATCH 0/3] LoadPin: Enable loading from trusted
 dm-verity devices
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
Cc: Douglas Anderson <dianders@chromium.org>, dm-devel@redhat.com,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 James Morris <jmorris@namei.org>, linux-raid@vger.kernel.org,
 Song Liu <song@kernel.org>, linux-security-module@vger.kernel.org,
 Alasdair Kergon <agk@redhat.com>, "Serge E . Hallyn" <serge@hallyn.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Kees,

On Mon, Apr 18, 2022 at 03:14:14PM -0700, Kees Cook wrote:
> [oops, resending to actual CC list]
> 
> On Mon, Apr 18, 2022 at 02:15:56PM -0700, Matthias Kaehlcke wrote:
> > This series extends LoadPin to allow loading of kernel files
> > from trusted dm-verity devices. It adds the concept of
> > trusted verity devices to LoadPin. Userspace can use the
> > new systl file 'loadpin/trusted_verity_root_digests' to
> > provide LoadPin with a list of root digests from dm-verity
> > devices that LoadPin should consider as trusted. When a
> > kernel file is read LoadPin first checks (as usual) whether
> > the file is located on the pinned root, if so the file can
> > be loaded. Otherwise, if the verity extension is enabled,
> > LoadPin determines whether the file is located on a verity
> > backed device and whether the root digest of that device
> > is in the list of trusted digests. The file can be loaded
> > if the verity device has a trusted root digest.
> > 
> > The list of trusted root digests can only be written once
> > (typically at boot time), to limit the possiblity of
> > attackers setting up rogue verity devices and marking them
> > as trusted.


> Thanks for working all this out! Where does the list of trusted
> roothashes come from? I assume some chain of trust exists. Is the list
> maybe already stored on the rootfs?

Yes, at least the content of the list comes from the rootfs. The
userspace part is still TBD (also pending on the evolution of this
patchset), having the list pre-formatted in a single file on the
rootfs should be fine.

> It'd be nice if there was some way to pass the trust chain to LoadPin
> more directly.

I imagine you envision LoadPin reading the file itself, instead of
just processing the content. That should be doable. One option would
be to pass the path of the file with the hashes through the sysctl
file and use kernel_read_file_from_path() to read it if the path is
in the pinned root (or maybe even in any trusted file system ;-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

