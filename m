Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922EE71B3A
	for <dm-devel@lists.linux.dev>; Mon, 15 Apr 2024 13:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713189393; cv=none; b=XQTTFQZPHQrDxR/lWsIM7nfKAOqYlKzxrCzIQHVONem/+C+FhGhEm717VNJ43DHyJndBHBCrXG9/4bPD79Mm1536TNz6/Q5vyiToOWBO+72r+DiIna739l3Yy1Ab/NNRhyRRL5Fiw7oZsnEQhlHs4VVXj2Kf207/15ZCxr6NpPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713189393; c=relaxed/simple;
	bh=+VVV7sQD/TURqBaQ3o4+GnmR1SYFSqIiY2IQytgOeyg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uZRWc4x4pLgCY5UCb+igQnmGzOsFvRmQ+tfU45WvOqflv54fRpoHyEPA4RwN90/yE9C39n1mT9Z1JvdP/x3KwgsheaLMVVLpU5/dk7ymqdkMb/AjYGElPsP7DMSugZs3Cg2cBSmjQLH+GlIXzgan1lxVObGFo35BIk5n+k9exHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=snitzer.net; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=snitzer.net
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-78d677dca70so245502885a.0
        for <dm-devel@lists.linux.dev>; Mon, 15 Apr 2024 06:56:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713189390; x=1713794190;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A8W/huyXe05bmHkZ7p3zhmV/PsnRvwctPQtMd0KsVdw=;
        b=oPSSglJrHp8FQveqsEexpU+fakNGM55hMRR+cuiyrsSANZx1t17xxpir62pwrHcL5g
         MSIVBquY0KCyrb1sgUmoM+VnhLw1Z0tkaQ96tGlrAqZzGFYNUHle1YsuVfesHDG2LpsU
         MXuacaVEAQLWKfZcx1NzlSmIEQzr53u3diwbumNlnG/p66mHm4ax4mEf4pzGCT3zH9nw
         isLCLpxczD+7zsfy+TtJscNj+Mga4iVOQAyW7ygmS6h8r1NhjDqLgzE3MHom9NIRVWXi
         w+gBckcl0NFEg/7N8k6NQCGsnKMJCLC6qswTJRPthU7giGcCUnD4I+u7V2xu9Za60l+i
         qzMw==
X-Forwarded-Encrypted: i=1; AJvYcCXjv3j4wyh2CXV2c3bOKGcgRFdOvvKsU3V3SJ+FbXg98HTguliR5OVN2g18w0PW5CcNLHd8/71WLDNL3CpTw3lMEOiP5l0MWE4=
X-Gm-Message-State: AOJu0Yyg6tAbTdJ5uvTvVpSucY14g/OPf1Qa5JJllLMA/A8FkWCUihsg
	nZ98Ew2n1C2AgywmZmC1kaUp9g4XaDDsD8XFLzGTURgtaoed3VzuDqH2qt2I7jE=
X-Google-Smtp-Source: AGHT+IGyhwxIGf0/tZcTU4Qo6zY7NFezwol5Iq8ThT/YVXI3g8yDqaQ6a06haDbA8lDnpkm4O991xA==
X-Received: by 2002:ae9:f718:0:b0:78d:5f83:4f77 with SMTP id s24-20020ae9f718000000b0078d5f834f77mr10863669qkg.37.1713189390431;
        Mon, 15 Apr 2024 06:56:30 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id x10-20020ae9e90a000000b0078d6d22a0c3sm6383346qkf.90.2024.04.15.06.56.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Apr 2024 06:56:29 -0700 (PDT)
Date: Mon, 15 Apr 2024 09:56:28 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Christian Brauner <brauner@kernel.org>
Cc: Ming Lei <ming.lei@redhat.com>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev, Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH v2 04/34] md: port block device access to file
Message-ID: <Zh0yDCvqO8rXcXpz@redhat.com>
References: <20240123-vfs-bdev-file-v2-0-adbd023e19cc@kernel.org>
 <20240123-vfs-bdev-file-v2-4-adbd023e19cc@kernel.org>
 <Zhzyu6pQYkSNgvuh@fedora>
 <20240415-haufen-demolieren-8c6da8159586@brauner>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240415-haufen-demolieren-8c6da8159586@brauner>

On Mon, Apr 15 2024 at  8:35P -0400,
Christian Brauner <brauner@kernel.org> wrote:

> On Mon, Apr 15, 2024 at 05:26:19PM +0800, Ming Lei wrote:
> > Hello,
> > 
> > On Tue, Jan 23, 2024 at 02:26:21PM +0100, Christian Brauner wrote:
> > > Signed-off-by: Christian Brauner <brauner@kernel.org>
> > > ---
> > >  drivers/md/dm.c               | 23 +++++++++++++----------
> > >  drivers/md/md.c               | 12 ++++++------
> > >  drivers/md/md.h               |  2 +-
> > >  include/linux/device-mapper.h |  2 +-
> > >  4 files changed, 21 insertions(+), 18 deletions(-)
> > > 
> > > diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> > > index 8dcabf84d866..87de5b5682ad 100644
> > > --- a/drivers/md/dm.c
> > > +++ b/drivers/md/dm.c
> > 
> > ...
> > 
> > > @@ -775,7 +778,7 @@ static void close_table_device(struct table_device *td, struct mapped_device *md
> > >  {
> > >  	if (md->disk->slave_dir)
> > >  		bd_unlink_disk_holder(td->dm_dev.bdev, md->disk);
> > > -	bdev_release(td->dm_dev.bdev_handle);
> > > +	fput(td->dm_dev.bdev_file);
> > 
> > The above change caused regression on 'dmsetup remove_all'.
> > 
> > blkdev_release() is delayed because of fput(), so dm_lock_for_deletion
> > returns -EBUSY, then this dm disk is skipped in remove_all().
> > 
> > Force to mark DMF_DEFERRED_REMOVE might solve it, but need our device
> > mapper guys to check if it is safe.
> > 
> > Or other better solution?
> 
> Yeah, I think there is. You can just switch all fput() instances in
> device mapper to bdev_fput() which is mainline now. This will yield the
> device and make it able to be reclaimed. Should be as simple as the
> patch below. Could you test this and send a patch based on this (I'm on
> a prolonged vacation so I don't have time right now.):
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 56aa2a8b9d71..0f681a1e70af 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -765,7 +765,7 @@ static struct table_device *open_table_device(struct mapped_device *md,
>         return td;
> 
>  out_blkdev_put:
> -       fput(bdev_file);
> +       bdev_fput(bdev_file);
>  out_free_td:
>         kfree(td);
>         return ERR_PTR(r);
> @@ -778,7 +778,7 @@ static void close_table_device(struct table_device *td, struct mapped_device *md
>  {
>         if (md->disk->slave_dir)
>                 bd_unlink_disk_holder(td->dm_dev.bdev, md->disk);
> -       fput(td->dm_dev.bdev_file);
> +       bdev_fput(td->dm_dev.bdev_file);
>         put_dax(td->dm_dev.dax_dev);
>         list_del(&td->list);
>         kfree(td);
> 
> 

Thanks. I'll work with Ming and others to take care of it. Have a great vacation!
