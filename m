Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E684734D
	for <dm-devel@lists.linux.dev>; Fri,  6 Oct 2023 23:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D1t2D/2U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696635823;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HlwHNITOeyhTiIfwGg6zzOIFNO4WlzZOEiOcJeTtgV4=;
	b=D1t2D/2U4P3vptdqO968lbPbgGvgysBqVME7SPmsqGq98vP+Udpx343BkR44E6uFeeUjdO
	Es+0FE6pkg8KCQFrfusmCgN8eQyrGxF+8DQjO8+JrBWEdXUjWolznJMmf5XVY1fYCYFzfp
	Utuy/8K7grj5yqJUzgVC8nKqNd8ZcjQ=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-505-uKCIGSVjOIqNeggJ4rObUA-1; Fri, 06 Oct 2023 19:43:41 -0400
X-MC-Unique: uKCIGSVjOIqNeggJ4rObUA-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-66ac99ce80eso26720956d6.1
        for <dm-devel@lists.linux.dev>; Fri, 06 Oct 2023 16:43:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696635820; x=1697240620;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HlwHNITOeyhTiIfwGg6zzOIFNO4WlzZOEiOcJeTtgV4=;
        b=W9MDSPV64eVjXv9ML1gRT25G0SCZMk68bojtF0oJQCMLMncv6hn85ghLTkk7Ewoa/m
         LknX/56YpquEXi+OS8HktgTcPGOvAi1n9H9mxPXdybik2lzvQQH6qY8YDD8LnAtvkbv0
         rWVVIqLCmcgCvkEcirJnsJBWOF9ASVErgBEoxYu27DRkC/ePoB9CeNXowG1u6Qj8CZI7
         osMlXCKLmHY1r6IQcHX39e5I4/QZF0xnhl2jIa9awLy0IgJy/WaEctoVGJ8UupOMhiQr
         B9y1PFFx7TjcRHPMx9jikf8AIUlACQtUQSX9JUDjDB8qZOyWSGHmO4MN5tOaJtq1uEN2
         Z1yg==
X-Gm-Message-State: AOJu0YwVLke4dtv7yqc9TVZvWKE8cOtX4YLFzWEshPsWzjRI+EgW00PV
	HRcI6mrENkgNTqONvgxfHmx8byHVYaJzxGFH5ylBXFmQYnqvxSf2uc4Rbzl2+khTftiXPHm0N69
	hr6ymtEvamqPseGFnoeT+59hFTiF/ZssxEsMZsJ6gqDjhLlrh0A4eaa1iJHFcy4260cMng2kgLp
	lDLA==
X-Received: by 2002:a05:620a:228e:b0:773:ea6e:e8a4 with SMTP id o14-20020a05620a228e00b00773ea6ee8a4mr8440358qkh.44.1696635820580;
        Fri, 06 Oct 2023 16:43:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG4gzH2TPvyNcUvOjuDxlIdo1L8JJifogtDlsA+sNUIPiFL4/LYJNsEJnSuMBgeBk9HMf9ryA==
X-Received: by 2002:a05:620a:228e:b0:773:ea6e:e8a4 with SMTP id o14-20020a05620a228e00b00773ea6ee8a4mr8440349qkh.44.1696635820272;
        Fri, 06 Oct 2023 16:43:40 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id s17-20020a05620a031100b00767177a5bebsm1652831qkm.56.2023.10.06.16.43.39
        for <dm-devel@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Oct 2023 16:43:39 -0700 (PDT)
Date: Fri, 6 Oct 2023 19:43:38 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: dm-devel@lists.linux.dev
Subject: Re: dm-devel has migrated to lists.linux.dev
Message-ID: <ZSCbqvX0f9LOXByf@redhat.com>
References: <ZSCYSO8wlg4keAmY@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <ZSCYSO8wlg4keAmY@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 06 2023 at  7:29P -0400,
Mike Snitzer <snitzer@kernel.org> wrote:

> Hi,
> 
> As a dm-devel@redhat.com subscriber, you have been silently subscribed
> to the new mailing list: dm-devel@lists.linux.dev.
> 
> Effective immediately, all dm-devel email should be addressed to:
> dm-devel@lists.linux.dev
> 
> (I say this but my "git pull" request that I just sent to Linus, to
> update the MAINTAINERS file accordingly, cc'd dm-devel@redhat.com --
> dm-devel@redhat.com will still function as it has, but nobody should
> use it moving forward).
> 
> If you do send email to dm-devel@redhat.com you will get this
> auto-response: 
> 
>   As of 2023.10.06: dm-devel@redhat.com has migrated to
>   dm-devel@lists.linux.dev
> 
>   If you were a dm-devel@redhat.com subscriber you have been silently
>   subscribed to dm-devel@lists.linux.dev
> 
>   NOTE: If you were a dm-devel@redhat.com subscriber but you disabled
>   mail delivery: then you must subscribe to dm-devel@lists.linux.dev.
>   To do so please send email to: dm-devel+subscribe@lists.linux.dev
> 
>   To unsubscribe from dm-devel@lists.linux.dev please send email to:
>   dm-devel+unsubscribe@lists.linux.dev


Additional useful info:

Please be sure to update any dm-devel mail filter you may have to look
for this in mail headers:
List-Id: <dm-devel.lists.linux.dev>

Also, we will be backfilling "[dm-devel]" prefix for all list messages.

The dm-devel list archive is now here:
https://lore.kernel.org/dm-devel/

Please let me know if you have any questions or concerns.

Thanks,
Mike

