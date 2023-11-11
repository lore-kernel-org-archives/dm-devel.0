Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B751E1861
	for <dm-devel@lists.linux.dev>; Sat, 11 Nov 2023 00:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="3gCw5FRR"
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-586753b0ab0so1374889eaf.0
        for <dm-devel@lists.linux.dev>; Fri, 10 Nov 2023 16:56:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1699664216; x=1700269016; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0WJjV0M8MGipSibP/l63xjUDxPGkLG8AjMcqPGszYTU=;
        b=3gCw5FRR1Nqbio7C4pVjRmV1UZqJhyQNVenWbv8yU+I0I/J1cCUP7gKqyMYKktj4lI
         Tr+twC+VwQsznAXM1c/3S7mCE0/0ffRePyZxyOC2eKPdhvbsdZy/6FPHHV12bcT71T8D
         xWe1fiQJ/OJjVbYg7oojOgU4v543yozE0d+orj7riJAbKNgQ+srBKnnPW0OWoHlghP+9
         pRrbmLvuuG33O9kO9ck4EsbI7d4JUgoTY6lFt4mOlbamS1nqt1XETNnN/4xu3twZSIvJ
         4GhJtvXNpAmYO10HI3a2aqD26MbL7i8bFZ8l37fUp6KDVej3NEQ4RvOhzCEXgVA1Jh9T
         Ds2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699664216; x=1700269016;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0WJjV0M8MGipSibP/l63xjUDxPGkLG8AjMcqPGszYTU=;
        b=dgI+oILu7MvyuK7UzKCMCa/ZZrUxaFhoQpki8esE/wo9sWi4Ylii3NqKWfl4tdDCKp
         EfDOoXzQAji+Fuij1GSyiErUYIjRxCFiUYxQlrUUID93GFNKfuFO7hFrtvvGTimFC8O7
         rXr3a1zP5kigG85tIR19JHtI6P068MA/6QnCGTCH3o/6BC2VCWl//vxIJaz68pVyjfGC
         W1fUjQVv+Q13p/QejJUy95IJUrxQhU2+qxtTUqgNXilY0nmRSIVUlByAfqFiM1jAWQex
         EG5GJmNOi2WBXkLm7WNubzNhc8ZyhY3EoDjEe3hR8ILOLjOssTsYK49qaGdUr1Ajb7bL
         57tQ==
X-Gm-Message-State: AOJu0YzlsbLX6aXiw48x9/wUrMHHMeIj1I8o27sRBtBQsdmc78Y7gcIu
	bv3yc/nxvYWMFKU5Ta0R7yCDIQ==
X-Google-Smtp-Source: AGHT+IGX3k4QQhob2VPoP+c6SxcbxGB2OaDpjeV49tKk6N1SJY4rWQ5U6++lwQ6APk6XaIzKjwMPLA==
X-Received: by 2002:a05:6358:e9c5:b0:16b:c414:ae2 with SMTP id hc5-20020a056358e9c500b0016bc4140ae2mr660358rwb.8.1699664216492;
        Fri, 10 Nov 2023 16:56:56 -0800 (PST)
Received: from dread.disaster.area (pa49-180-125-5.pa.nsw.optusnet.com.au. [49.180.125.5])
        by smtp.gmail.com with ESMTPSA id w12-20020a63f50c000000b005b8ebef9fa0sm295729pgh.83.2023.11.10.16.56.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Nov 2023 16:56:55 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1r1cIu-00Ays6-25;
	Sat, 11 Nov 2023 11:56:52 +1100
Date: Sat, 11 Nov 2023 11:56:52 +1100
From: Dave Chinner <david@fromorbit.com>
To: Sarthak Kukreti <sarthakkukreti@chromium.org>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v9 0/3] [PATCH v9 0/3] Introduce provisioning primitives
Message-ID: <ZU7RVKJIzm8ExGGH@dread.disaster.area>
References: <20231110010139.3901150-1-sarthakkukreti@chromium.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231110010139.3901150-1-sarthakkukreti@chromium.org>

On Thu, Nov 09, 2023 at 05:01:35PM -0800, Sarthak Kukreti wrote:
> Hi,
> 
> This patch series is version 9 of the patch series to introduce
> block-level provisioning mechanism (original [1]), which is useful for
> provisioning space across thinly provisioned storage architectures (loop
> devices backed by sparse files, dm-thin devices, virtio-blk). This
> series has minimal changes over v8[2], with a couple of patches dropped
> (suggested by Dave).
> 
> This patch series is rebased from the linux-dm/dm-6.5-provision-support
> [3] on to (a12deb44f973 Merge tag 'input-for-v6.7-rc0' ...). The final 
> patch in the series is a blktest (suggested by Dave in 4) which was used
> to test out the provisioning flow for loop devices on sparse files on an
> ext4 filesystem.

What happened to the XFS patch I sent to support provisioning for
fallocate() operations through XFS?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
