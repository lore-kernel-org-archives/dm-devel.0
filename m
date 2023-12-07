Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FDC125CD
	for <dm-devel@lists.linux.dev>; Thu,  7 Dec 2023 06:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="ojwdCR3o"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6ce403523e5so187856b3a.3
        for <dm-devel@lists.linux.dev>; Wed, 06 Dec 2023 22:03:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1701928997; x=1702533797; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Pw2nLSqvqX2XEheC59D1y8xR9yWzVJ975ni9isQco04=;
        b=ojwdCR3oqLJQIS0taAkwQQ7EayxUJNCjfT7Q20GfpEWuXAdu60YeB8h71xH6Bw4kLv
         238cE9H+yBlHk1qCd9MjwYzFd7vYJAUboltHehSf25p3/I4eRBLYI/dKMd+HK5AF7IB6
         ZHGxPzpcWIjewhk0HSdu0aL79vOr/oatoxBaZQCAJnwnZSXfsFOXEjDLJuIm0VaK9OR1
         GGfqLXTYKIVPgLD/rtpqlofI5THlUoyDJfO8Wjs6+glW3WblDT59rnsahIYN9S75l3W4
         XQtpu7KrQlC+D0bYc2vRroWT1SSsmZs0aJQZiehRjsmz/SBkftfTDfuFC2Yw0S92ls+A
         kA+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701928997; x=1702533797;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pw2nLSqvqX2XEheC59D1y8xR9yWzVJ975ni9isQco04=;
        b=r7il8NNB+xzpWga3BcRO1jiBRGcuebIg0MuS8Erp1TxKS7ec4kHTJpZYZ7d0JV5tw/
         UKIedAKObDz+mIN16lNLBjG/sWeK+Jn5PlXDwSjuTVS3Q5EAaLjlOlY+Hwyh1aQkTM/5
         tb8cTk5QLK2NmGkDY8uF9zERnFUPHHuiabDALdMpAnkWetgztpINYtSNHcJp/kXVbX1Z
         89UqPA1J+HaVeL3RiKgh6Slv786rczFSkEcpvAFfOZvRRa1nKkEF12qSNUBui0Hj3UQl
         Vs7AIPl+zVKV0c9p6/J+6+oyEnlOEzGCaBrnoY+u0Yu2Fkn5y2HHBi2d1Q479EbaR3Zp
         fH3g==
X-Gm-Message-State: AOJu0YyZpcS4rQndavxHjgIrViNo9ELUtVoXC0xuwWDoRtdUCfHuuv03
	brpyPt0Nvg16/ZqzNQ6uBh0lYw==
X-Google-Smtp-Source: AGHT+IFgd6UXrTBxn5Iid8zFZidrdE58MM/eMedRH7B3IU8UEspNZeFe4AO8VUuMn1n7T9+bA5Ox3w==
X-Received: by 2002:a05:6a00:2195:b0:6ce:2d6d:24ac with SMTP id h21-20020a056a00219500b006ce2d6d24acmr2087457pfi.20.1701928997517;
        Wed, 06 Dec 2023 22:03:17 -0800 (PST)
Received: from dread.disaster.area (pa49-180-125-5.pa.nsw.optusnet.com.au. [49.180.125.5])
        by smtp.gmail.com with ESMTPSA id g193-20020a636bca000000b005b7dd356f75sm435756pgc.32.2023.12.06.22.03.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Dec 2023 22:03:17 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rB7Te-004xC7-2R;
	Thu, 07 Dec 2023 17:03:14 +1100
Date: Thu, 7 Dec 2023 17:03:14 +1100
From: Dave Chinner <david@fromorbit.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-cachefs@redhat.com, dhowells@redhat.com, gfs2@lists.linux.dev,
	dm-devel@lists.linux.dev, linux-security-module@vger.kernel.org,
	selinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/11] vfs: inode cache conversion to hash-bl
Message-ID: <ZXFgIlVDNqFvEADn@dread.disaster.area>
References: <20231206060629.2827226-1-david@fromorbit.com>
 <20231206060629.2827226-9-david@fromorbit.com>
 <20231207045844.u26r5vn26gtmqwe5@moria.home.lan>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231207045844.u26r5vn26gtmqwe5@moria.home.lan>

On Wed, Dec 06, 2023 at 11:58:44PM -0500, Kent Overstreet wrote:
> On Wed, Dec 06, 2023 at 05:05:37PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Scalability of the global inode_hash_lock really sucks for
> > filesystems that use the vfs inode cache (i.e. everything but XFS).
> 
> Ages ago, we talked about (and I attempted, but ended up swearing at
> inode lifetime rules) - conversion to rhashtable instead, which I still
> believe would be preferable since that code is fully lockless (and
> resizeable, of course). But it turned out to be a much bigger project...

I don't think that the size of the has table is a big issue at the
moment. We already have RCU lookups for the inode cache
(find_inode_rcu() and find_inode_by_ino_rcu()) even before this
patchset, so we don't need rhashtable for that.

We still have to prevent duplicate inodes from being added to the cache
due to racing inserts, so I think we still need some form of
serialisation on the "lookup miss+insert" side. I've not thought
about it further than that - the hash-bl removes the existing
VFS contention points and the limitations move to
filesystem internal algorithms once again.

So until the filesystems can scale to much larger thread counts and
put the pressure back on the VFS inode cache scalability, I
don't see any need to try to do anything more complex or smarter...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
