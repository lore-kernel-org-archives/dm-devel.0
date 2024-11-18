Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35AB9150981
	for <dm-devel@lists.linux.dev>; Mon, 18 Nov 2024 21:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731966861; cv=none; b=bbAzOsR6ImruUk/pEBvFPPVqDhnLDsByaD4fCyMTeGx1fTqeNdSEg/fV3zDOoBQvQLUOHk70w+qpY2yjg629h1RPwPvk6vj9HLlFmMg5IPdVnQ21a2Kc5spkDcna3w0MEP4UU812iz6/duoWjkLPT4uqLXYybzRWc2XkVxUixOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731966861; c=relaxed/simple;
	bh=GH7HNAuf+PdY7xrhVdBxBmK3NME4WJylXv4OpU58B5E=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ftXkWhaClqNJPAHLPFSp138Sg/jbk2IDU6uTW8ZUH5vZJzweDLa6AFJUsgHSWmsUDgMdrezkUpceqRZ4gJ4GHY3OfgQbsZCsMDXkqz2wM/Gpzobw0OBXXLAWpDyeIYpGXIBnSh3ukxweZqCm2iQhT5f2sYk0oUMJ+ci31Uc9KPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=TNNv4cyT; arc=none smtp.client-ip=209.85.161.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="TNNv4cyT"
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-5ee58c5c2e3so1603119eaf.2
        for <dm-devel@lists.linux.dev>; Mon, 18 Nov 2024 13:54:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731966857; x=1732571657; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p18Ou65sSW7nZEBgBZ8V2Ng+FEYRVPVefFIAS08hir4=;
        b=TNNv4cyTEf/JqdBza14YT6fMjkRK8uUS6T6rwdPY06YYpthtZGkTPZYZWrrk+qFcoV
         YqLIfY2P9fgqkCSXeCSp2SkFlq7Zh1EGvZuNWinJJ7sya1Dqy7UBNBLrhC7JGtH23NK5
         1aQiz/0hv7eDAN+T1+NzTWYePUH5VlOvN6c1GeUdnEEWppXdb6L8B9a7Q2eIVgpugDjr
         0XH3ZF3bui0/ZpItU3OnAngx03J9q7qCPFN8aDycPkCh0Z3PQWcCnc2Riya22hcJxmtI
         8Oggf8H7i7XLR/e9WL9YAX5LLzVNxD82OHSVRQi9p+Y4+CrnuJYDeoaULt1IdiVribYC
         N90A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731966857; x=1732571657;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p18Ou65sSW7nZEBgBZ8V2Ng+FEYRVPVefFIAS08hir4=;
        b=FRtTjzh+UXQ8OeW3RYDwgmyfRIJTKFpmf7RA/aR3hCyADP07HmsGO28smUbPqSR62b
         VBN5DnJ87ToL/aLxEgyZHBUrFi9j9rFmFQ+zIBUxLZuGmioUDEVdlnoSMDahPVvrVUeF
         Z8jy5W9K7H4fGldKhRFzj6tDjHNN9nHYAPaNfh5jI5RfWJ6LLs7TAD5A8DdOvYj3xBBQ
         +Xjrj5RFW+EPmzbQL0vpVnQ30EXQk8Yuf72WOAYsehGZsb8fbkxqnWTdY5vZ7WYwwIbp
         hYvd6FPKpMS44H0WeigX9NnYPgvKa6LGoI4jvE49L0hG4TQMzEmpKM377aTf+DqehyZK
         t0Yg==
X-Gm-Message-State: AOJu0YwWN33tHLL+7LyYPA0en2Wlj1F6ADI7glQKCRqw7EYzEhtHgBDz
	eMyDByemwoKWdWMQVrpnNw6NwZvqlu8iM4DwM2I3GSCC6oERelGrHtqj5iuSnepV7dqpEby1jSs
	lAWE=
X-Google-Smtp-Source: AGHT+IGWCGPZXazVsmOYV6Lyd3HrTZGGG9lvfgUhdSO/ZdxZR+CiOfiMpkwTCklRca0zaIYE/TotEA==
X-Received: by 2002:a05:6820:2d43:b0:5ee:dc92:ffb4 with SMTP id 006d021491bc7-5eedc93055amr270745eaf.5.1731966856837;
        Mon, 18 Nov 2024 13:54:16 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-71a780fed32sm3007781a34.26.2024.11.18.13.54.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2024 13:54:15 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: dap581 <dap581@protonmail.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev, Milan Broz <gmazyland@gmail.com>, 
 Christoph Hellwig <hch@lst.de>, Bart Van Assche <bvanassche@acm.org>, 
 Damien Le Moal <dlemoal@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <3dc0014b-9690-dc38-81c9-4a316a2d4fb2@redhat.com>
References: <sL6OHvHA2vueSjCGptT5XUvM5jjGMf3xGWrAW6npODvitd85paTESdsxpbircJbDh9VVyBNDNiqOcU39-LM7WwuldK5Tk4UkRSZjsycWdpo=@protonmail.com>
 <1426ad71-79b4-4062-b2bf-84278be66a5d@redhat.com>
 <3dc0014b-9690-dc38-81c9-4a316a2d4fb2@redhat.com>
Subject: Re: [PATCH] blk-settings: round down io_opt to physical_block_size
Message-Id: <173196685541.27078.10116047267109203022.b4-ty@kernel.dk>
Date: Mon, 18 Nov 2024 14:54:15 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-86319


On Mon, 18 Nov 2024 15:52:50 +0100, Mikulas Patocka wrote:
> On Mon, 18 Nov 2024, Mikulas Patocka wrote:
> 
> > On Sat, 16 Nov 2024, dap581 wrote:
> >
> > > Hello,
> > > Starting with kernel 6.11.x series up to current 6.12-rc7
> > > when I unlock my encrypted hdd (storage, not root) with cryptsetup:
> > >
> > > cryptsetup luksOpen /dev/sda1 hdd5 -d keyfile_hdd5
> > >
> > > it triggers an alignment inconsistency:
> > > In dmesg log, I read:
> > > ----
> > > [  105.841278] device-mapper: table: 254:1: adding target device sda1 caused an alignment inconsistency: physical_block_size=4096, logical_block_size=512, alignment_offset=0, start=16777216
> > > [  105.841292] device-mapper: table: 254:1: adding target device sda1 caused an alignment inconsistency: physical_block_size=4096, logical_block_size=512, alignment_offset=0, start=16777216
> > > [  105.841601] device-mapper: table: 254:1: adding target device sda1 caused an alignment inconsistency: physical_block_size=4096, logical_block_size=512, alignment_offset=0, start=16777216
> > > [  105.841607] device-mapper: table: 254:1: adding target device sda1 caused an alignment inconsistency: physical_block_size=4096, logical_block_size=512, alignment_offset=0, start=16777216
> > > ----
> 
> [...]

Applied, thanks!

[1/1] blk-settings: round down io_opt to physical_block_size
      commit: df199821cd4bf0c77c4fc4ca2fa978cedf5c8bcf

Best regards,
-- 
Jens Axboe



