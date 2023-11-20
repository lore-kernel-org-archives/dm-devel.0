Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E5C6374EE
	for <dm-devel@lists.linux.dev>; Mon, 20 Nov 2023 20:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="gmJeRs7/"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6c39ad730aaso3862588b3a.0
        for <dm-devel@lists.linux.dev>; Mon, 20 Nov 2023 12:33:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1700512435; x=1701117235; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=evAEpm60eEP3dXV5IIqup+kGHQJCYdmk5kN5UrPqUqI=;
        b=gmJeRs7/NPY9u+FpGaU6Y38vKVsRIgsFHCIw+J+MbGxQXj+T4MpkwLLIXlBWu7g3sS
         bwFTe+j5GMiSTsNyj5iBc55Hc0Ji0saTu2O9sF4zGxTbJFwj1cqF7Xz/KcxPXx7esjFL
         Ej3llGZzt4SB7yfUAUAxqwrlaWZhjRG1vhaRsQVkcTVAL4qwztUwg6UUCU8g2aYf3DFX
         U57TYoxAlLDuBsz15aXaFwc+QBJLJx4GbWItbm71X2BiMcwRnfjovwxgMU6cG4cl2zqV
         b/gZ53o2tsky9DE//Bc7cah6mNBmr115ijtR7cOID1Gl7PnvYDzxml6S2MuuA93qM1WF
         7zbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700512435; x=1701117235;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=evAEpm60eEP3dXV5IIqup+kGHQJCYdmk5kN5UrPqUqI=;
        b=HeNsyt60CZh158yP/LWz8QJVmY5LRM0kXyxPBxy6ONpzEZxa0i9b2kobhWZSzdBd61
         thYLZWm4LrWrjnGP9O2VteRyVIqXFq0++LGd9LqcI0K4NcN0kj+w34kBRlvU+qbPNeon
         su7GZw4H2Xf5f0Wun63/eKfYfvcvsLuX5BkMC+Akbih2Y2Qt41bQowe4/6yMuzn70mkA
         2qO26/wmXGIPHChBAJjtR7w7hEj+3BQX3dBu6vxxMx0KBy09efG13YlHaza65yloJ1To
         SLG2/OQV+NfCDn7hMGxUFoQjKBXWqZEM1yVToCnninDPye1m0VK+wx6qI57JQn7JLCTk
         7elg==
X-Gm-Message-State: AOJu0YxbOMC7K+YbJ5WY790WhLuclFmn7zP+UOLzJGZT3tt1Esg/Df3H
	ejhSf8wIggsl4n8aOn1KZfybPA==
X-Google-Smtp-Source: AGHT+IEUIW0UoDRHG7vGbEKmmcfumQAR5wXy6IpLvsSKoDwysXkoX+X9La6bv+9CGvmyGf8BTbi2pQ==
X-Received: by 2002:a05:6a20:c188:b0:187:9392:cfdd with SMTP id bg8-20020a056a20c18800b001879392cfddmr7866906pzb.24.1700512435511;
        Mon, 20 Nov 2023 12:33:55 -0800 (PST)
Received: from dread.disaster.area (pa49-180-125-5.pa.nsw.optusnet.com.au. [49.180.125.5])
        by smtp.gmail.com with ESMTPSA id k81-20020a628454000000b00688965c5227sm6783104pfd.120.2023.11.20.12.33.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Nov 2023 12:33:54 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1r5Axs-00FH1P-0e;
	Tue, 21 Nov 2023 07:33:52 +1100
Date: Tue, 21 Nov 2023 07:33:52 +1100
From: Dave Chinner <david@fromorbit.com>
To: Sarthak Kukreti <sarthakkukreti@chromium.org>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v9 0/3] [PATCH v9 0/3] Introduce provisioning primitives
Message-ID: <ZVvCsPelezZesshx@dread.disaster.area>
References: <20231110010139.3901150-1-sarthakkukreti@chromium.org>
 <ZU7RVKJIzm8ExGGH@dread.disaster.area>
 <CAG9=OMPFEV9He+ggq2mcLULnUZ2jm8fGU=4ca8kBoWtvqYcGVg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG9=OMPFEV9He+ggq2mcLULnUZ2jm8fGU=4ca8kBoWtvqYcGVg@mail.gmail.com>

On Mon, Nov 13, 2023 at 01:26:51PM -0800, Sarthak Kukreti wrote:
> On Fri, Nov 10, 2023 at 4:56 PM Dave Chinner <david@fromorbit.com> wrote:
> >
> > On Thu, Nov 09, 2023 at 05:01:35PM -0800, Sarthak Kukreti wrote:
> > > Hi,
> > >
> > > This patch series is version 9 of the patch series to introduce
> > > block-level provisioning mechanism (original [1]), which is useful for
> > > provisioning space across thinly provisioned storage architectures (loop
> > > devices backed by sparse files, dm-thin devices, virtio-blk). This
> > > series has minimal changes over v8[2], with a couple of patches dropped
> > > (suggested by Dave).
> > >
> > > This patch series is rebased from the linux-dm/dm-6.5-provision-support
> > > [3] on to (a12deb44f973 Merge tag 'input-for-v6.7-rc0' ...). The final
> > > patch in the series is a blktest (suggested by Dave in 4) which was used
> > > to test out the provisioning flow for loop devices on sparse files on an
> > > ext4 filesystem.
> >
> > What happened to the XFS patch I sent to support provisioning for
> > fallocate() operations through XFS?
> >
> Apologies, I missed out on mentioning that the XFS patches work well
> with loop devices.
> 
> I might have misunderstood: were those patches only for sanity testing
> or would you prefer that I send those out as a part of this series? I
> can whip up a quick v10 if so!

I was implying that if you are going to be adding support to random
block devices for people to actually test out, then you should be
adding support to filesystems and writing new -fstests- to ensure
that loop devices are actually provisioning blocks at exactly the
locations that correspond to the physical file extents the
filesystem provisioned, too.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
