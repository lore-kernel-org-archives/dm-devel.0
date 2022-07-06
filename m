Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39813C43334
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jul 2022 15:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657120327;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=X9tCWxJs2174ZRY7UH0l4vgENEZWvW6hCngRPq/aBPw=;
	b=c0+vRF9zK44XykwaW3n0VtcbAnUXjI2wmfBphA4luRGf1KMSwGZE/vixfo6tz5LM+X+bjg
	1RTJM+rWSqPN1VAQMhENA8VYuSll//h7y8bMteFvUzRY0nOg8f3dr8shYTo2BanSwdCv+i
	2M8ZuVkvOTRqhvUgImJOModgq5yBiys=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-570-QdUMqmFuO_-Ca7BK05ee8g-1; Wed, 06 Jul 2022 11:12:05 -0400
X-MC-Unique: QdUMqmFuO_-Ca7BK05ee8g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1E0073C0F399;
	Wed,  6 Jul 2022 15:12:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0598040E80E2;
	Wed,  6 Jul 2022 15:12:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BC4CA1947064;
	Wed,  6 Jul 2022 15:12:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B1676194704E
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Jul 2022 15:12:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7B0C9492CA2; Wed,  6 Jul 2022 15:12:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 76D71492C3B
 for <dm-devel@redhat.com>; Wed,  6 Jul 2022 15:12:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5FBAB811E7A
 for <dm-devel@redhat.com>; Wed,  6 Jul 2022 15:12:02 +0000 (UTC)
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com
 [209.85.160.169]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-609-lWf1Pa0rN8mvWf-4r2G3qA-1; Wed, 06 Jul 2022 11:12:01 -0400
X-MC-Unique: lWf1Pa0rN8mvWf-4r2G3qA-1
Received: by mail-qt1-f169.google.com with SMTP id r2so18597274qta.0
 for <dm-devel@redhat.com>; Wed, 06 Jul 2022 08:12:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=u094c1pWAuc2qjFRYuYIiBLyQBzCT6qd8wf4uxXSTSI=;
 b=Ntmvb9RBhYqD9td1uTTwtdfJBKGDq9J4bd9zNp0AlaSSHOtZPh/Tag+KGivlhTOx3r
 9zHMP/zq4l2HmAzKmBe5LSIy9RxI/GNn27uV1k3bRB17iAwjxz8car5o4qUErI2he3dI
 /7TQFDWnrkebxojuBsb7pif3BsDu1gKUji3pg7jCgDUOmhOjrreXskZDTYkUUxxX4YXD
 tlTTH6lO07LLUAzrVyfpmi8lWBamMYdTii0iKGer9D5mLc+nEx+FaDux5N8UJ6YACF+2
 O8/MKMtJSaOsxabfpmeEJFZ6/Ek0mq2MM+gviq6HuyRPkOWvKFkJtnTVaygtnv0NLLXE
 SdMg==
X-Gm-Message-State: AJIora8v6+RQOMmQplYCo+fydyJyCy35ev2/mfZ3ntIsMybZZvdYK3S4
 0aOx2V5tJlNf4jbTmV79TCd107Q=
X-Google-Smtp-Source: AGRyM1tmmHS3hmEoSfozfOq3OFvufYVLm+WLqowCSt0K1ZgT8OE07PhhFHfBTGi7f9mSyqrGwqz2Lg==
X-Received: by 2002:ac8:5985:0:b0:31d:3ea5:12f4 with SMTP id
 e5-20020ac85985000000b0031d3ea512f4mr18144555qte.274.1657120320113; 
 Wed, 06 Jul 2022 08:12:00 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 j4-20020a05620a410400b006a6278a2b31sm20037145qko.75.2022.07.06.08.11.59
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 06 Jul 2022 08:11:59 -0700 (PDT)
Date: Wed, 6 Jul 2022 11:11:58 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Kees Cook <keescook@chromium.org>
Message-ID: <YsWmPt7xwTlvTfAf@redhat.com>
References: <20220627153526.3750341-1-mka@chromium.org>
MIME-Version: 1.0
In-Reply-To: <20220627153526.3750341-1-mka@chromium.org>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v7 0/3] LoadPin: Enable loading from trusted
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
 Douglas Anderson <dianders@chromium.org>, linux-kernel@vger.kernel.org,
 James Morris <jmorris@namei.org>, linux-raid@vger.kernel.org,
 Song Liu <song@kernel.org>, dm-devel@redhat.com,
 Matthias Kaehlcke <mka@chromium.org>, Milan Broz <gmazyland@gmail.com>,
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

On Mon, Jun 27 2022 at 11:35P -0400,
Matthias Kaehlcke <mka@chromium.org> wrote:

> As of now LoadPin restricts loading of kernel files to a single pinned
> filesystem, typically the rootfs. This works for many systems, however it
> can result in a bloated rootfs (and OTA updates) on platforms where
> multiple boards with different hardware configurations use the same rootfs
> image. Especially when 'optional' files are large it may be preferable to
> download/install them only when they are actually needed by a given board.
> Chrome OS uses Downloadable Content (DLC) [1] to deploy certain 'packages'
> at runtime. As an example a DLC package could contain firmware for a
> peripheral that is not present on all boards. DLCs use dm-verity [2] to
> verify the integrity of the DLC content.
> 
> This series extends LoadPin to allow loading of kernel files from trusted
> dm-verity devices. LoadPin maintains a list of root digests of verity
> devices it considers trusted. Userspace can populate this list through an
> ioctl on the new LoadPin securityfs entry 'dm-verity'. The ioctl receives
> a file descriptor of a file with verity digests as parameter. Verity reads
> the digests from this file after confirming that the file is located on the
> pinned root. The digest file must contain one digest per line. The list of
> trusted digests can only be set up once, which is typically done at boot
> time.
> 
> When a kernel file is read LoadPin first checks (as usual) whether the file
> is located on the pinned root, if so the file can be loaded. Otherwise, if
> the verity extension is enabled, LoadPin determines whether the file is
> located on a verity backed device and whether the root digest of that
> device is in the list of trusted digests. The file can be loaded if the
> verity device has a trusted root digest.
> 
> [1] https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/dlcservice/docs/developer.md
> [2] https://www.kernel.org/doc/html/latest/admin-guide/device-mapper/verity.html

Hi Kees,

Please pick this series up, thanks.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

