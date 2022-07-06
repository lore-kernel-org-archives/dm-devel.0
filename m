Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1EB6C43334
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jul 2022 15:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657120134;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=81ExhsxUbKfwvxFsnUHuVhBXueZz8YdIJzDmgt/wu8c=;
	b=JJGOAgQNJCmR4Sg5E1HIv2pLQGDdeFrWwTpDKqCdf/VF0G0JWOOevfbxlH3i3a5lKLhmBP
	/j3jhuk/V4ygv1vzs9mu7aKCu698i+scMdISzTZBNUJpvzFYzcCvANlK8p7oXBENPxzwJx
	+X9u+5IZdtXjJkmoH1kDYgH2Cw/FOS8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-209-u8fuQ49CNveKNH_-nr6EGg-1; Wed, 06 Jul 2022 11:08:51 -0400
X-MC-Unique: u8fuQ49CNveKNH_-nr6EGg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A578D9693A1;
	Wed,  6 Jul 2022 15:08:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 558ED40E80E0;
	Wed,  6 Jul 2022 15:08:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2C57D1947063;
	Wed,  6 Jul 2022 15:08:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 88BD4194704E
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Jul 2022 15:08:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 47EB3400DB35; Wed,  6 Jul 2022 15:08:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 44237404754D
 for <dm-devel@redhat.com>; Wed,  6 Jul 2022 15:08:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2C0E280D3FE
 for <dm-devel@redhat.com>; Wed,  6 Jul 2022 15:08:24 +0000 (UTC)
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com
 [209.85.160.173]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-196-n6uFjP04NqqN54L7_pUiJw-1; Wed, 06 Jul 2022 11:08:16 -0400
X-MC-Unique: n6uFjP04NqqN54L7_pUiJw-1
Received: by mail-qt1-f173.google.com with SMTP id ay10so18588883qtb.1
 for <dm-devel@redhat.com>; Wed, 06 Jul 2022 08:08:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=ScRkAz/VqtB+AtxqVIwVUVdF/rIZB4AANK+myVEOT60=;
 b=o36nw7zvQIep9MbetbfFMKVAzCPK9bBQWI2VVmU7g5BWZb0kQxpDtLvdhcgOAf7d+R
 MYF04WcbdUvQ1Ir9wboxwqmPQdHWvIc+OPy+RW+ll4QGDH5lii6g8/XVF2uo2u/tOSrB
 v4Azq34Akm2qWYHHZHZt2PqBLh5CNqTG35P1FJoZH+HDjYZ0u1POZ/vdhsYLKjF7CFD7
 PTW9z965gSdILuafy4CRqd7EelLex6aszQVCL+mCkVKWEmAzwA+Bdbc0OGd/7me2sSc0
 Tui9ss0vTAbtTOmhQZeteU7uKZGswC4uUM3zcS1O3DiMyNdaMOppLTB/erUHm2YngrKB
 pa2w==
X-Gm-Message-State: AJIora9/vAX9RrXf4bj9SgPx67eecMo0Yz8jnIaJ1p1f05mpM991h9Jf
 JNmSoQjHHfi4IUgCy0urxezhR/k=
X-Google-Smtp-Source: AGRyM1vURiVQNneit1uIOq0gI+2o4Q1iXAOnL3S780GQ4xr/mr7+VNJ3IiJ/UQzyRS8zDfx/h2ANCg==
X-Received: by 2002:a05:622a:196:b0:319:83f5:7a2c with SMTP id
 s22-20020a05622a019600b0031983f57a2cmr33294199qtw.0.1657120090010; 
 Wed, 06 Jul 2022 08:08:10 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 l26-20020ac848da000000b003177969a48fsm24329478qtr.21.2022.07.06.08.08.09
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 06 Jul 2022 08:08:09 -0700 (PDT)
Date: Wed, 6 Jul 2022 11:08:08 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Matthias Kaehlcke <mka@chromium.org>
Message-ID: <YsWlWIbzJtUQUaWy@redhat.com>
References: <20220627153526.3750341-1-mka@chromium.org>
 <20220627083512.v7.2.I01c67af41d2f6525c6d023101671d7339a9bc8b5@changeid>
MIME-Version: 1.0
In-Reply-To: <20220627083512.v7.2.I01c67af41d2f6525c6d023101671d7339a9bc8b5@changeid>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v7 2/3] LoadPin: Enable loading from trusted
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
Cc: linux-security-module@vger.kernel.org,
 Douglas Anderson <dianders@chromium.org>, Kees Cook <keescook@chromium.org>,
 linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
 linux-raid@vger.kernel.org, Song Liu <song@kernel.org>, dm-devel@redhat.com,
 Milan Broz <gmazyland@gmail.com>, Alasdair Kergon <agk@redhat.com>,
 "Serge E . Hallyn" <serge@hallyn.com>
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

On Mon, Jun 27 2022 at 11:35P -0400,
Matthias Kaehlcke <mka@chromium.org> wrote:

> Extend LoadPin to allow loading of kernel files from trusted dm-verity [1]
> devices.
> 
> This change adds the concept of trusted verity devices to LoadPin. LoadPin
> maintains a list of root digests of verity devices it considers trusted.
> Userspace can populate this list through an ioctl on the new LoadPin
> securityfs entry 'dm-verity'. The ioctl receives a file descriptor of
> a file with verity digests as parameter. Verity reads the digests from
> this file after confirming that the file is located on the pinned root.
> The digest file must contain one digest per line. The list of trusted
> digests can only be set up once, which is typically done at boot time.
> 
> When a kernel file is read LoadPin first checks (as usual) whether the file
> is located on the pinned root, if so the file can be loaded. Otherwise, if
> the verity extension is enabled, LoadPin determines whether the file is
> located on a verity backed device and whether the root digest of that
> device is in the list of trusted digests. The file can be loaded if the
> verity device has a trusted root digest.
> 
> Background:
> 
> As of now LoadPin restricts loading of kernel files to a single pinned
> filesystem, typically the rootfs. This works for many systems, however it
> can result in a bloated rootfs (and OTA updates) on platforms where
> multiple boards with different hardware configurations use the same rootfs
> image. Especially when 'optional' files are large it may be preferable to
> download/install them only when they are actually needed by a given board.
> Chrome OS uses Downloadable Content (DLC) [2] to deploy certain 'packages'
> at runtime. As an example a DLC package could contain firmware for a
> peripheral that is not present on all boards. DLCs use dm-verity to verify
> the integrity of the DLC content.
> 
> [1] https://www.kernel.org/doc/html/latest/admin-guide/device-mapper/verity.html
> [2] https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/dlcservice/docs/developer.md
> 
> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> Acked-by: Kees Cook <keescook@chromium.org>

Acked-by: Mike Snitzer <snitzer@kernel.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

