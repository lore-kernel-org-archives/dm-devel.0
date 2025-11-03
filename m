Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6732505A5
	for <dm-devel@lists.linux.dev>; Mon,  3 Nov 2025 07:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762154298; cv=none; b=NQiDE+KbVSTagPeWoY4b96f3MyH5mxYtEpioM4X12GwcsZWFlozcEDllRwodJe5ukTA8oTst6koGYERA8SS3J1L6zFTVqDQ+N/vPOPxNIuQDwpkWUEviQeX8AOfORmxMjUrAHLqLsudZlQMfy2xUNAmUBMeVOVdgWFHvgTtdLPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762154298; c=relaxed/simple;
	bh=mNiBHRHLdMqnvaJIEavpx7C7tTm8CYCoyLazYi6SDLg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Miin4/NlmAYBchrPFNUdMj3NDKtslAt/dCMnHyas0HzrD0egE5Y63nUa0LL6iU84gxPMMo9sE1GtYQhLzEDYyyRQRE4iRmRJKUqiyv5Dcc6Xd7vOsvlQB6wUM8noHCAoZQk69WbfvgINUZ9xDlO6nZeSWJ+KV0mdEOl8pBSFwoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=epwIM93n; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="epwIM93n"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4711b95226dso51053665e9.0
        for <dm-devel@lists.linux.dev>; Sun, 02 Nov 2025 23:18:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762154293; x=1762759093; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fyxHa9/8/Ar3cmThFu6k2oVGwIVFxlREAcZe35Eyfc8=;
        b=epwIM93n2bXg14SetSUwbMqEGpqWeO9/2FD5ePXyXNCKEJArz0eZqyy71FX99S8aP8
         8hyVNrxQKHWre7kPv3FBzcD+42gFgY5B6sX7CwqJucJFMlc4St0wwo3ri2omwnOQWLYD
         iB7dS7zfYqUf2pFGWMJghSCbN48JTjWfzGpZu5Y2ti0nVT3/aVeH5n+Z/j5Hx7jxOoRP
         wZmEGHAlukaWbaNiceJaU8F+ql1F7bdh0W8b5cpeSKOJD4YRhg90EK/YZLXVxTzq7H5W
         9R/N/ICE2WqlqnqsVkBq/18xdNAHgGf89DzE1pNSFyiQVcGcwRsTlmUGw14NxmAoa76L
         F21A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762154293; x=1762759093;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fyxHa9/8/Ar3cmThFu6k2oVGwIVFxlREAcZe35Eyfc8=;
        b=mh8R/wK+CDfFovYR8isWSVupTfB8ZGJB8a5FbCejNgY3DjyvK1MGNOXwFFpvdHLqsj
         rJ+x5ObMGqe89YLLtGRGDqiMJwBtbP12+2eS9sMb1rSBeHSSF44jRZNoE5BrRvNnOmOK
         doSJWOSq4A/rW9y9w1O5zbT8hjwhXHqC2bVLvOnyyz7ChZ8eWACKlFAEyAAq52thw7CZ
         zPCi8bsBiL4CPJImWbA/qP5EioHuS/JjNaBoIJ5hR5p4OI+hdEmZQg6a1KsaRZYiAshS
         r5EsBdAMJauZ2a2q0KCJ7iRjKdDPqpcNqrtOOZ7Ch4DMQXRHgKUrXbYjN4q/PUAiR2tM
         lwMg==
X-Forwarded-Encrypted: i=1; AJvYcCWuRpriU5sn7ZFXWqaQuRsGLF4bss8sL6zYUkt0atW3+XzlilZHw5yVS+407IwqHOTlUlEfqX1E1g==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz6VL9mKoRpEmr3IKN4nsWnvTDGfcN/VQvEpJ23dofJ+m4VqxN/
	ccDXTeRvtmgnPPf9P3VGLWq6HVPXLWNsbGXR2uEawhnf0L0CcZv+PRqksYZCXb1cdDpsTzq+/iq
	mVjVJGwrCMcoLqFVO3NxwNOuXXgXbZ7CW52qmAaIK7g==
X-Gm-Gg: ASbGncvcj1ejL3SEuHt5sBy0FOO3Md3q1I9hYMLT6aYvDwLujJZxfyZiK/7kwhY6ajD
	jt7wBSiXEsZoIUy4J+vk6r8SLaBYf570u619UKGcvdRwElmI/i/+0FKUBBaRSGAvBEsfh018GgV
	bMCrPI8TiJqbTg5d4zB/mmTA/4M1v68wq7K40eWdinHcTBV+UoEzFGILwIe5OUsdpnmaUkEjP2p
	QwiWzAzvFnPBTxQm0sMNP6GzkHFxpgsqBNlDguINjyo+XX+nCSlYqP06RuIUhMIzPdWH73O3vbU
	7jLpF2rTaY7d+i7IcmX9bdPgpAUnzzWF6d3D1x2WPzGR+waSzPcBiAwSCYW0OzpdEbFO
X-Google-Smtp-Source: AGHT+IHqUQu8mdmKFV60YUxpDIMFoEiDUTPxoVdwOa3d9A2KABNI1QO1FJGgMlmc/MHoUnrp0Cz2XrvfjpDIzK4Hz9g=
X-Received: by 2002:a05:600c:620a:b0:471:7a:791a with SMTP id
 5b1f17b1804b1-4773bf42644mr79682075e9.7.1762154292857; Sun, 02 Nov 2025
 23:18:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251031061307.185513-1-dlemoal@kernel.org> <20251031061307.185513-2-dlemoal@kernel.org>
 <55887a39-21ee-4e6c-a6f3-19d75af6395a@acm.org> <bd71691f-e230-42ca-8920-d93bf1ea6371@kernel.org>
In-Reply-To: <bd71691f-e230-42ca-8920-d93bf1ea6371@kernel.org>
From: Daniel Vacek <neelx@suse.com>
Date: Mon, 3 Nov 2025 08:18:00 +0100
X-Gm-Features: AWmQ_bmxLu0zc6F1WlZXfm4Psv5Sxs14UirqMZbxcqRpQmruSk8F7QkSWlVIM64
Message-ID: <CAPjX3FebPLu_P=-BuP63VuaiAnC62rthcQ0vb+J8b-w0OckyqA@mail.gmail.com>
Subject: Re: [PATCH 01/13] block: freeze queue when updating zone resources
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Keith Busch <keith.busch@wdc.com>, 
	Christoph Hellwig <hch@lst.de>, dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, 
	linux-scsi@vger.kernel.org, linux-xfs@vger.kernel.org, 
	Carlos Maiolino <cem@kernel.org>, linux-btrfs@vger.kernel.org, 
	David Sterba <dsterba@suse.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 3 Nov 2025 at 06:55, Damien Le Moal <dlemoal@kernel.org> wrote:
>
> On 11/1/25 02:48, Bart Van Assche wrote:
> > Hi Damien,
> >
> > disk_update_zone_resources() only has a single caller and just below the
> > only call of this function the following code is present:
> >
> >       if (ret) {
> >               unsigned int memflags = blk_mq_freeze_queue(q);
> >
> >               disk_free_zone_resources(disk);
> >               blk_mq_unfreeze_queue(q, memflags);
> >       }
> >
> > Shouldn't this code be moved into disk_update_zone_resources() such that
> > error handling happens without unfreezing and refreezing the request
> > queue?
>
> Check the code again. disk_free_zone_resources() if the report zones callbacks
> return an error, and in that case disk_update_zone_resources() is not called.
> So having this call as it is cover all cases.

I understand Bart's idea was more like below:

> @@ -1568,7 +1572,12 @@ static int disk_update_zone_resources(str
uct gendisk *disk,
>       }
>
>   commit:
> -     return queue_limits_commit_update_frozen(q, &lim);
> +     ret = queue_limits_commit_update(q, &lim);
> +
> +unfreeze:

+       if (ret)
+               disk_free_zone_resources(disk);

> +     blk_mq_unfreeze_queue(q, memflags);
> +
> +     return ret;
>   }
>
>   static int blk_revalidate_conv_zone(struct blk_zone *zone, unsigned int idx,

And then in blk_revalidate_disk_zones() do this:

        if (ret > 0) {
                ret = disk_update_zone_resources(disk, &args);
        } else if (ret) {
                unsigned int memflags;

                pr_warn("%s: failed to revalidate zones\n", disk->disk_name);

               memflags = blk_mq_freeze_queue(q);
               disk_free_zone_resources(disk);
                blk_mq_unfreeze_queue(q, memflags);
        }

The question remains if this looks better?

> --
> Damien Le Moal
> Western Digital Research
>
