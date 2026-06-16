Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2431448BD32;
	Tue, 16 Jun 2026 23:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781653540; cv=none; b=a5ZysrmEjuEdGyoCocK/tRYm+v79eC0SmxPc7ZCDzhvbHgmGEQkBQFlTYFuat7p3vfrGWg56JoyHUm0Q8+/wnuL8O6BxHM5sXqQTwJzGrUgisQhQRIiXOYNUDDgfwlCnI2dqMaiGyAhxmCiNvQaCbMZJlUNfho23TOM2MQLBEKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781653540; c=relaxed/simple;
	bh=4W0kj9q1+ZZ9SJxcjdL4YAdBVZGusE15YeYXfZvhk9s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ELa25FcDGqb76FPW8XCf9Fx9+E8K/S9EmJr5VKH8ZZElEKvpogNW3/DJ2rdtzN2w7kdrALXafEBUfwK+nyNOKj8ct3Ci8Raj2zCYL/efkPR/3cwm9Ic/tN3TKoeaVXYomL5S1l30yrz8sFvLzTk9HEYhbftQ0L34qaHOwvIFUlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RxFlMR3m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RxFlMR3m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 871F41F000E9;
	Tue, 16 Jun 2026 23:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781653538;
	bh=bZ7Qvkm5oKinSynwphDyQ4nsJDZpLdZ9HGv2CKAr68Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RxFlMR3mfJ0JRHAWQhnXUBbCt4oTSZVklYYJr7n9GcSidRNoL8fnL6O7ujUY7ZVFc
	 MJvOJo64HKxk24HlDxQS6ichemTNlPUwDvHX/ozBxIEqM6jSN8Z3+ltIfxLeXBFi9t
	 rq3xtavZ/QzSD/T3b3owp+vV1h7Mc4EuIEwGU/B1hECzaJ8FyCF5xUrmNNIXQ8o1vK
	 JmHFquFqWyUBtr0XFrprh1633iPg2mdQHxEjx6YJYeObCqjJ1wb3wUXVolIsMq/Krj
	 1uUAsthELnKEIfLkRXXiqx+e5UXY/e1UPmTIU06MCIiGUjt86Q2fEybbvwQcJSBXsB
	 UKdHKIjyxkAGw==
Date: Tue, 16 Jun 2026 17:45:37 -0600
From: Keith Busch <kbusch@kernel.org>
To: "Dr. David Alan Gilbert" <linux@treblig.org>
Cc: Keith Busch <kbusch@meta.com>, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org, mpatocka@redhat.com,
	Vjaceslavs Klimovs <vklimovs@gmail.com>
Subject: Re: [PATCH 2/2] dm-raid1: don't fail the mirror for invalid I/O
 errors
Message-ID: <ajHgIWdT0QmeF_t4@kbusch-mbp>
References: <20260616150554.1686662-1-kbusch@meta.com>
 <20260616150554.1686662-2-kbusch@meta.com>
 <ajGN1OKun3qyvqMc@gallifrey>
 <ajGacnaCZ6v6VE1B@kbusch-mbp>
 <ajGtbuJ2kXo1GZ1d@gallifrey>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajGtbuJ2kXo1GZ1d@gallifrey>

On Tue, Jun 16, 2026 at 08:09:18PM +0000, Dr. David Alan Gilbert wrote:
> Interesting; I've got your:
>   dm-raid1: don't fail the mirror for invalid I/O errors
>   For DM_IO_BIO requests, do_region() built each destination bio by walking..
> ontop of e21ee273e6fa3879aec9a27251cfce98156e07c4 which is just before 7.1
>   I've not your https://lore.kernel.org/linux-block/20260612223205.465913-1-kbusch@meta.com/
> 
> root@dalek:/home/dg# lvcreate  --mirrors 1 -L 1G main /dev/sda2 /dev/sdb2
> root@dalek:/home/dg# mkfs.ext4 /dev/mapper/main-lvol0
> root@dalek:/home/dg# mount /dev/mapper/main-lvol0 /mnt/tmp/
> root@dalek:/home/dg# chmod a+rwx /mnt/tmp
> 
> dg@dalek:~$ dd if=/dev/zero of=/mnt/tmp/testfile bs=1024k count=1
> 
> my two tests are separate tests:

Goodness, I'm struggling here. Unpatched, I have no problem recreating
the issues you've described, but everything I've tried with the
proposals included gets the expected results. I'm running out of ideas
on replicating your results with hardware I have, but it's getting late,
so I'll try to have new ideas tomorrow.
