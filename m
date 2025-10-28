Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFAB71E3DF2
	for <dm-devel@lists.linux.dev>; Tue, 28 Oct 2025 13:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761657502; cv=none; b=h1kVGN0W8wH5A2xxxmMqU1DvFEhr8deHHTOubrErpjLm0UhRdENUeRIlYgHmsHvb98JhKv0wPujTnqY7Sz6QLIsWDFFrlVyeeGn0hAn4mQoMdVamJ23kpmlRlyslpImcQQ4ME9lPrGDuqCrXGSI+Kzw2RLXugAuMYKxn5Hn8v9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761657502; c=relaxed/simple;
	bh=fiLWZK6ImQVCW9629k9PoFbTy4/Jk9SIirXQPkk2UZQ=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=thI9ih10Q7rgIuoaAy7pkCfvii5WZ3QSnnciqouFewTiwWYVQ8bDj9Syme599HMvzNWWUmv5Ob3ztyGzsg+ek/fBETteGs7+Df+UKmKw8Dwc8jwT7AueYe3boM14GAIawEPWE8Y9JJ1WRbDa99VkG4IlVCxeiJat8rO2M/Rl2NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W9wVQR8z; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W9wVQR8z"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-37902f130e1so20224501fa.1
        for <dm-devel@lists.linux.dev>; Tue, 28 Oct 2025 06:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761657499; x=1762262299; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TqhalhS8wH7ktHtboyTNLZoKooOIXtABZeKACOZEvrg=;
        b=W9wVQR8zQz6+fdcBIiFUdPXs83BImJzU8kUKLVlgh0WCWiIfSBu8kDA2my/TuyhXCx
         ylylKzFQW3FDi53L598YkCPDzFkd4g3r0JmekNYVvxjN+b9FmzZ/kb+UXK+cddF9laRa
         uxlSh00TxkoKgxc8m4yMCoT2tRjPN7JEV+ymIlwIY0nfooYBHH4vs2O5Ia5BCZIKK3vj
         4f+NaSNqZeE1HF6ZIQ5Box0BmlOWSJw6EjXIC+XPuMdgxYwjjaWEmvO3CGiL1LC3IeNI
         yG0A50pigSUW7oD2jvNp6+88QGH6UP8/RShHkLa3cihXnzLNvguHgotG2cCO856Sg0yY
         NbBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761657499; x=1762262299;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TqhalhS8wH7ktHtboyTNLZoKooOIXtABZeKACOZEvrg=;
        b=ECJcUiBryMWDNulYEzUBb543/hhYExJlJRItp/wqJxDWxlsPgCotczve7mCds7DMI/
         qfEgsarHzUrRh12+PGLxnTi2auozK5LkYpvwc+6BTi+Db0+4orh6BHYeL5TkzioPHao+
         3iuOju9FF7lKYve2kMgTunZjyhcAAezNlTRKdK5gxrn7KMY/5AekwdaYwHKi1jZlv4h/
         GQhEIqBf3MZWfLX7DoX71p7UTqkIPteQxV2SXxOVWZYVzumgU1Hbg+AsxbXkQtz/s9ln
         K38vIdkNoWixcoULgFJyPK+q6jl9IIjE9y+Xt0RhamxmOjg72CyUXGhGvJ0JjL1Dga6J
         fmhA==
X-Forwarded-Encrypted: i=1; AJvYcCWPQkIGr85TDHdUixfbHi67ObjRgy54muksqmTGUVG055/5cNvi39LOtXNmY0N2tTXSoD3Bj0t24A==@lists.linux.dev
X-Gm-Message-State: AOJu0YyVNMdJTu4DgUDPcS6qox9XQFlpAL7ADPOyOz5sKE+bPyaZmask
	eGi21srraU2wLIzXDah6aRgadhIQu6XJX+gKvYBaiyviBimlzQ3rr0q8
X-Gm-Gg: ASbGncstK9jytsi5vMTOFHmJaGc4dMX0KKRTX5gaex4bIvfuF6b1GaKm9fzq1nTuOhD
	Aq4OK2aiLFtYpG5uFiouhSwNfDN9RaZE9lXJoRIQ/YQ66nhqV+6vK3B34uWqNkzePWvgye607cv
	hiaygdEPT0vP+9EJrkpNGHfdUfglrIsiGpSTXhEDoyVnKerih/O3DEjDM/QnQ/L6glcv3cFQ6zz
	Fn4ITkZ2MjupSUC0Vr80/4iQRzkFuO+0HWVVSwO7F+oLInZHBcAl2WYMgPW1N66KFTonpQANA/j
	C9NaDsT6Za2jPQdt/ERxPkBoDPa9LpRxTI82dbrjq325qenP+wDFXecDCuNABjFKo5W9hvg2j9f
	92dpRPzcDO+ZE6xF+1JiHKCKi1ZzRuROgqtTTF2mB7oo=
X-Google-Smtp-Source: AGHT+IFH42jTuKwp0a5o9y/IlF7jThN+9qfutPbd8sJT3wsJFSPYJU9S3gA+Z0OKXiwtbIQO2EAhtw==
X-Received: by 2002:a05:6512:31d0:b0:592:fc21:bbfc with SMTP id 2adb3069b0e04-5930e9dd0a7mr1227732e87.44.1761657498708;
        Tue, 28 Oct 2025 06:18:18 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59301f55739sm3048909e87.49.2025.10.28.06.18.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Oct 2025 06:18:18 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Tue, 28 Oct 2025 14:18:16 +0100
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon <agk@redhat.com>,
	DMML <dm-devel@lists.linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dm-bufio: align write boundary on bdev_logical_block_size
Message-ID: <aQDCmAPfpIGZiceo@milan>
References: <20251020123350.2671495-1-urezki@gmail.com>
 <cdb598ce-88ec-0c3c-8e4b-b557093bea92@redhat.com>
 <aQCDLBie3fGwMDW2@milan>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQCDLBie3fGwMDW2@milan>

On Tue, Oct 28, 2025 at 09:47:40AM +0100, Uladzislau Rezki wrote:
> Hello!
> 
> Sorry i have missed you email for unknown reason to me. It is
> probably because you answered to email with different subject
> i sent initially.
> 
> > 
> > On Mon, 20 Oct 2025, Uladzislau Rezki (Sony) wrote:
> > 
> > > When performing a read-modify-write(RMW) operation, any modification
> > > to a buffered block must cause the entire buffer to be marked dirty.
> > > 
> > > Marking only a subrange as dirty is incorrect because the underlying
> > > device block size(ubs) defines the minimum read/write granularity. A
> > > lower device can perform I/O only on regions which are fully aligned
> > > and sized to ubs.
> > 
> > Hi
> > 
> > I think it would be better to fix this in dm-bufio, so that other dm-bufio 
> > users would also benefit from the fix. Please try this patch - does it fix 
> > it?
> > 
> If it solves what i describe i do not mind :)
> 
> > 
> > 
> > From: Mikulas Patocka <mpatocka@redhat.com>
> > 
> > There may be devices with logical block size larger than 4k. Fix
> > dm-bufio, so that it will align I/O on logical block size. This commit
> > fixes I/O errors on the dm-ebs target on the top of emulated nvme device
> > with 8k logical block size created with qemu parameters:
> > 
> > -device nvme,drive=drv0,serial=foo,logical_block_size=8192,physical_block_size=8192
> > 
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > Cc: stable@vger.kernel.org
> > 
> > ---
> >  drivers/md/dm-bufio.c |    9 +++++----
> >  1 file changed, 5 insertions(+), 4 deletions(-)
> > 
> > Index: linux-2.6/drivers/md/dm-bufio.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/md/dm-bufio.c	2025-10-13 21:42:47.000000000 +0200
> > +++ linux-2.6/drivers/md/dm-bufio.c	2025-10-20 14:40:32.000000000 +0200
> > @@ -1374,7 +1374,7 @@ static void submit_io(struct dm_buffer *
> >  {
> >  	unsigned int n_sectors;
> >  	sector_t sector;
> > -	unsigned int offset, end;
> > +	unsigned int offset, end, align;
> >  
> >  	b->end_io = end_io;
> >  
> > @@ -1388,9 +1388,10 @@ static void submit_io(struct dm_buffer *
> >  			b->c->write_callback(b);
> >  		offset = b->write_start;
> >  		end = b->write_end;
> > -		offset &= -DM_BUFIO_WRITE_ALIGN;
> > -		end += DM_BUFIO_WRITE_ALIGN - 1;
> > -		end &= -DM_BUFIO_WRITE_ALIGN;
> > +		align = max(DM_BUFIO_WRITE_ALIGN, bdev_logical_block_size(b->c->bdev));
>
Should it be physical_block_size of device? It is a min_io the device
can perform. The point is, a user sets "ubs" size which should correspond
to the smallest I/O the device can write, i.e. physically.

--
Uladzislau Rezki
