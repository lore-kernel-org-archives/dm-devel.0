Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B1A18C2E
	for <dm-devel@lists.linux.dev>; Fri, 27 Oct 2023 19:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-586b512ba0aso997355eaf.3
        for <dm-devel@lists.linux.dev>; Fri, 27 Oct 2023 12:08:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698433683; x=1699038483;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AODBYyJkdLsvQfVlwLuqvAqHENuQtQJnPPiweOqa5Dk=;
        b=s6VatDNULldNaJrZOY+qjMPtLTt+HalDnD/+u8iY166wPU0Wre4ht/IVa7fHK16ku6
         da+Ob0bIpKgDxs9q6nLorZ6LWKsRjOGCzmzqW3gND3pOQJXDSWprvE4PwWegyarXPZN8
         AM/JC6urRZe4pLUpFsWTkZ/tkf63f3saBr9lNjw2+VHeXNrR8DbYPWTTOTqJjj7TKDv5
         ETxwPBHU22LZfzZKLMmiw4LSyTJ7Umgr7vGmMPv0ckck3KBkxtrQq0JvfaFTvJgKgkvk
         O4+cGfkuSWl+MNJDm4IWyGBj06n+50okS+eq/Tr3uBhdWXb3PNh93UPFPgZyd+2zYcfB
         Ejgw==
X-Gm-Message-State: AOJu0Yw6RjCO65oC/YdRN/da6wJS6jQhWD9LtjckTeKYS3P7pcRlQsEN
	JayKWyn4uTxorDRGfzdcj6a1
X-Google-Smtp-Source: AGHT+IFBsZR8ptdIt0Hnn5Da3CQPRIEi81XaBDCkeHX6RcnYLqPRh3WOZ53cmYrEimnyCMEQXN+/Zw==
X-Received: by 2002:a05:6358:90a:b0:169:58fd:2f7b with SMTP id r10-20020a056358090a00b0016958fd2f7bmr596152rwi.6.1698433683486;
        Fri, 27 Oct 2023 12:08:03 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id c16-20020a0cd610000000b00655e2005350sm852048qvj.9.2023.10.27.12.08.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Oct 2023 12:08:03 -0700 (PDT)
Date: Fri, 27 Oct 2023 15:08:01 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: dm-devel@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>
Subject: Re: [PATCH v3] dm: error: Add support for zoned block devices
Message-ID: <ZTwKkV9aphjYBfIj@redhat.com>
References: <20231026051205.95209-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231026051205.95209-1-dlemoal@kernel.org>

On Thu, Oct 26 2023 at  1:12P -0400,
Damien Le Moal <dlemoal@kernel.org> wrote:

> dm-error is used in several test cases in the xfstests test suite to
> check the handling of IO errors in file systems. However, with several
> file systems getting native support for zoned block devices (e.g. btrfs
> and f2fs), dm-error lack of zoned block device support creates problems
> as the file system attempt executing zone commands (e.g. a zone append
> operation) against a dm-error non-zoned block device, which causes
> various issues in the block layer (e.g. WARN_ON triggers).
> 
> This patch adds supports for zoned block devices to dm-error, allowing
> an md device table containing an error target to be exposed as a zoned
> block device (if all targets have a compatible zoned model support and
> mapping). This is done as follows:
> 1) Allow passing 2 arguments to an error target, similarly to dm-linear:
>    a backing device and a start sector. These arguments are optional and
>    dm-error retains its characteristics if the arguments are not
>    specified.
> 2) Implement the iterate_devices method so that dm-core can normally
>    check the zone support and restrictions (e.g. zone alignment of the
>    targets). When the backing device arguments are not specified, the
>    iterate_devices method never calls the fn() argument.
> When no backing device is specified, as before, we assume that the DM
> device is not zoned. When the backing devie arguments are specified, the
> zoned model of the DM device will depend on the backing device type:
>  - If the backing device is zoned and its model and mapping is
>    compatible with other targets of the device, the resulting device
>    will be zoned, with the dm-error mapped portion always returning
>    errors (similarly to the default non-zoned case).
>  - If the backing devie is not zoned, then the DM device will not be
>    either.
> 
> This zone support for dm-error requires the definition of a functional
> report_zones operation so that dm_revalidate_zones() can operate
> correctly and resources for emulating zone append operations
> initialized. This is necessary for cases where dm-error is used to
> partially map a device and have an overall correct handling of zone
> append. This means that dm-error does not fail report zones operations.
> 
> Two changes that are not obvious are included to avoid issues:
> 1) dm_table_supports_zoned_model() is changed to directly check if
>    the backing device of a wildcard target (= dm-error target) is zoned.
>    Otherwise, when the invalid setup of dm-error being set without a
>    backing device (non zoned case) and combined with zoned targets
>    cannot be cought.
> 2) dm_table_supports_dax() is modified to return false if the wildcard
>    target is found. Otherwise, when dm-error is set without a backing
>    device, we end up with a NULL pointer dereference in
>    set_dax_synchronous dax_dev is NULL. This is consistent with the
>    current behavior because dm_table_supports_dax() always returned fals
>    for targets that do not define the iterate_devices method.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

I've picked this up.  But fixed various typos and such in the commit header.

Also some typos in code comments and bumped the target version to 1.7.

Please see: https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-6.7&id=c85b4fb8b8edbd915283f6ab3537f2c3b95e7c85

Thanks,
Mike
