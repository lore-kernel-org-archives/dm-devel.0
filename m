Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD362C433EF
	for <dm-devel@archiver.kernel.org>; Sun,  1 May 2022 06:22:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-342-UpnF9HuzOJu1neHKviko9Q-1; Sun, 01 May 2022 02:22:09 -0400
X-MC-Unique: UpnF9HuzOJu1neHKviko9Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 624CF8002B2;
	Sun,  1 May 2022 06:22:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 55B5740CFD01;
	Sun,  1 May 2022 06:22:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DF7A3194705E;
	Sun,  1 May 2022 06:22:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 84DB1194705D
 for <dm-devel@listman.corp.redhat.com>; Sun,  1 May 2022 06:22:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6AB2C2024CB9; Sun,  1 May 2022 06:22:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6628B200B664
 for <dm-devel@redhat.com>; Sun,  1 May 2022 06:21:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 849A9801210
 for <dm-devel@redhat.com>; Sun,  1 May 2022 06:21:58 +0000 (UTC)
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com
 [209.85.216.52]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-288-ZyjFNJW_Oke1efJPHIJ9eA-1; Sun, 01 May 2022 02:21:57 -0400
X-MC-Unique: ZyjFNJW_Oke1efJPHIJ9eA-1
Received: by mail-pj1-f52.google.com with SMTP id o69so9003762pjo.3
 for <dm-devel@redhat.com>; Sat, 30 Apr 2022 23:21:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=SKTKYlNwPBswI7KvwVvUGgGSktP9nkI84ndIRwt7nQ0=;
 b=lNH5Vl88utaJ+M+orkxJ5+92K0Zh4EDsmah8gZgUISVaxAZT8CnvlotWWc94f/ZYcp
 c/0vIMZnhs91VUZpdhvJXJIhhuk84YsLnLIjkneJbs5UeW35SRa+yThz77uZhm/IMtHQ
 7Uuqpo/lz8qa/OX9PmfjMvrXEhoCWrLH2Gh0R0AEayrS8e1l2AGBGhjvx2yeqSrGB6ut
 XjHLiqNb6gbNYh6xsCJAf8DJQXEgMJ7oTQUxRnI59O5XCkJbVebly1fH1p89PAkKC8bK
 chVXw+ctfFMbC+0HFvZDWjK1fvqHlKC4UUFAr0EKpLMr1TzYHWmeNsivw2/KdpFwjtoR
 pDbw==
X-Gm-Message-State: AOAM530aRdck4ncSmMfiplYmpRwGAr7M5DwrZunN35T+1T1m5pYSfHjf
 sttj+CLkLp7turZfq/K4bhtvdQ==
X-Google-Smtp-Source: ABdhPJz+jfrVtgiEdIHSI8aK+wUVMyDTcGdWEOLCrg/rORW+7ZJJmVsK5AsizYEC9lrxUsWwCp9rcg==
X-Received: by 2002:a17:902:f684:b0:15e:8c4a:c54b with SMTP id
 l4-20020a170902f68400b0015e8c4ac54bmr6278847plg.21.1651386115938; 
 Sat, 30 Apr 2022 23:21:55 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
 by smtp.gmail.com with ESMTPSA id
 c12-20020a65618c000000b003c14af5061asm9085007pgv.50.2022.04.30.23.21.55
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 30 Apr 2022 23:21:55 -0700 (PDT)
Date: Sat, 30 Apr 2022 23:21:54 -0700
From: Kees Cook <keescook@chromium.org>
To: Matthias Kaehlcke <mka@chromium.org>
Message-ID: <202204302316.AF04961@keescook>
References: <20220426213110.3572568-1-mka@chromium.org>
 <20220426143059.v2.2.I01c67af41d2f6525c6d023101671d7339a9bc8b5@changeid>
MIME-Version: 1.0
In-Reply-To: <20220426143059.v2.2.I01c67af41d2f6525c6d023101671d7339a9bc8b5@changeid>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH v2 2/3] LoadPin: Enable loading from trusted
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Apr 26, 2022 at 02:31:09PM -0700, Matthias Kaehlcke wrote:
> I'm still doubting what would be the best way to configure
> the list of trusted digests. The approach in v2 of writing
> a path through sysctl is flexible, but it also feels a bit
> odd. I did some experiments with passing a file descriptor
> through sysctl, but it's also odd and has its own issues.
> Passing the list through a kernel parameter seems hacky.
> A Kconfig string would work, but can be have issues when
> the same config is used for different platforms, where
> some may have trusted digests and others not.

I prefer the idea of passing an fd, since that can just use LoadPin
itself to verify the origin of the fd.

I also agree, though, that it's weird as a sysctl. Possible thoughts:

- make it a new ioctl on /dev/mapper/control (seems reasonable given
  that it's specifically about dm devices).
- have LoadPin grow a securityfs node, maybe something like
  /sys/kernel/security/loadpin/dm-verify and do the ioctl there (seems
  reasonable given that it's specifically about LoadPin, but is perhaps
  more overhead to built the securityfs).

-- 
Kees Cook

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

