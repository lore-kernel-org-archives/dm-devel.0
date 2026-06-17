Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ADEF2BEFFF;
	Wed, 17 Jun 2026 16:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781714679; cv=none; b=TIdoAIosvijLoOVasbEe2hf2qwElIWiFA6NnhhkYJUdi3cbuPmOm+UEnftHQ/nkakNhDnOCj89pkBzlwCmjzb+4KWiUQZWvi15kzC2co1GuDhqpELZV3EUEP//6EpETJWW9XzOJIk0jXRN2GtMLs4IMKx+sn2lg5V4Mzft8lJJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781714679; c=relaxed/simple;
	bh=23slo3+jYn23JUU92FQshvIbabry57pSqwwH5dD2Nq0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i3jhNacCOFu0cS/zLV23QxPUjV6TMPYgbDhLopWf5dIOwwR/YwWt58ZXHhwuBFg//oqzqZXZA0u7odr8ifsU0y0ZTBuZgez7NxEP+mM4vSv3PvT1Y3GmN+u99l4N7lq+F3ryTWQmXX0a75PAesQxM9ICKVSf537M+JOg4Siy+Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=XIretMzu; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="XIretMzu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=LQVhCUyZrwz9FtB0KzHZCIJCcdl/BBMAsNz3RhHuHOc=; b=XIretMzujLjQJxVT
	JcgVxVZHqxMdrie9dZ/eQlsx1le7t/114aVH3BB9HbEnnsWuH4LOVIDkZEkktRJrS85wAyt8M6v0z
	mvfskGSXUf/34KyukahbdwkIufRd5/mQjeb9IAbxzxr+p/3NIY3L9xW+K2DTiq25j4B9WGt6nBtUP
	8fxnGmpOsf3KzWwZNV6AoLPGp/a8fys6DYk20Vg/aCOhcPoZnfN1tgSgUNmQZ6cFP3nIAWd28WcZ/
	NujlLmLyuCs/iYMNVVZ9NHYkkP+veLrg9QGYpcj3byRwSeUkJHS5fhXAjD6z0jrZfBRQKNdw51nI6
	3WKqodYMMUFNQVeidQ==;
Received: from dg by mx.treblig.org with local (Exim 4.98.2)
	(envelope-from <dg@treblig.org>)
	id 1wZtNT-00000008MZ9-0TSg;
	Wed, 17 Jun 2026 16:44:35 +0000
Date: Wed, 17 Jun 2026 16:44:35 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Keith Busch <kbusch@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org, mpatocka@redhat.com,
	Vjaceslavs Klimovs <vklimovs@gmail.com>
Subject: Re: [PATCH 2/2] dm-raid1: don't fail the mirror for invalid I/O
 errors
Message-ID: <ajLO80kZmFnyR2mH@gallifrey>
References: <20260616150554.1686662-1-kbusch@meta.com>
 <20260616150554.1686662-2-kbusch@meta.com>
 <ajGN1OKun3qyvqMc@gallifrey>
 <ajGacnaCZ6v6VE1B@kbusch-mbp>
 <ajGtbuJ2kXo1GZ1d@gallifrey>
 <ajK4YacvP7eQ-S2o@kbusch-mbp>
 <ajK-Y7uoK0QT5PVl@gallifrey>
 <ajLJiOwim7qBp_0P@kbusch-mbp>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <ajLJiOwim7qBp_0P@kbusch-mbp>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.12.88+deb13-amd64 (x86_64)
X-Uptime: 16:42:00 up 32 days, 19:54,  2 users,  load average: 0.00, 0.02,
 0.00
User-Agent: Mutt/2.2.13 (2024-03-09)

* Keith Busch (kbusch@kernel.org) wrote:
> On Wed, Jun 17, 2026 at 03:33:55PM +0000, Dr. David Alan Gilbert wrote:
> > * Keith Busch (kbusch@kernel.org) wrote:
> > > On Tue, Jun 16, 2026 at 08:09:18PM +0000, Dr. David Alan Gilbert wrote:
> > > > root@dalek:/home/dg# lvcreate  --mirrors 1 -L 1G main /dev/sda2 /dev/sdb2
> > > 
> > > So this is a subtle difference from your original report which ran
> > > lvcreate a little differently:
> > > 
> > >   # lvcreate --type mirror --mirrors 1 -L 1G main /dev/sda2 /dev/sdb2
> > > 
> > > This patch series address problems with the original report with the
> > > "--type mirror" parameter, which uses dm-raid1.c instead of md/raid1.c.
> > 
> > Ah OK.
> > (I think I think I did say that somewhere, hmm ajFK5NXkxd6jU5zu@gallifrey ? )
> 
> I see. This will fix that setup:

And it does;
dg@dalek:~$ ./dbf
pread of 4096 said: -1 (Invalid argument)
dg@dalek:~$ ./dbf-write 
pwrite of 4096 said: -1 (Invalid argument)
dg@dalek:~$ ./dbf-joint 
pread of 4096 said: -1 (Invalid argument)
pwrite of 4096 said: -1 (Invalid argument)

and the log is clean.

Tested-by: Dr. David Alan Gilbert <linux@treblig.org>

(It's a bit scary you're having to go around quite
a few places and make similar fixes; I assume there
are others that do similar things).

Thanks again,

Dave

> 
> ---
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 5b9368bd9e700..17a5f0d98aacc 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -322,7 +322,9 @@ static void call_bio_endio(struct r1bio *r1_bio)
>  {
>  	struct bio *bio = r1_bio->master_bio;
>  
> -	if (!test_bit(R1BIO_Uptodate, &r1_bio->state))
> +	if (test_bit(R1BIO_Invalid, &r1_bio->state))
> +		bio->bi_status = BLK_STS_INVAL;
> +	else if (!test_bit(R1BIO_Uptodate, &r1_bio->state))
>  		bio->bi_status = BLK_STS_IOERR;
>  
>  	bio_endio(bio);
> @@ -403,6 +405,8 @@ static void raid1_end_read_request(struct bio *bio)
>  		;
>  	} else if (!raid1_should_handle_error(bio)) {
>  		uptodate = 1;
> +		if (bio->bi_status == BLK_STS_INVAL)
> +			set_bit(R1BIO_Invalid, &r1_bio->state);
>  	} else {
>  		/* If all other devices have failed, we want to return
>  		 * the error upwards rather than fail the last device.
> @@ -519,6 +523,14 @@ static void raid1_end_write_request(struct bio *bio)
>  		 */
>  		r1_bio->bios[mirror] = NULL;
>  		to_put = bio;
> +		/*
> +		 * An invalid I/O (e.g. a misaligned bio rejected by the lower
> +		 * device) was ignored above rather than faulting the device.
> +		 * It is not a successful write, though, so report the error to
> +		 * the caller instead of completing the master bio as uptodate.
> +		 */
> +		if (bio->bi_status == BLK_STS_INVAL)
> +			set_bit(R1BIO_Invalid, &r1_bio->state);
>  		/*
>  		 * Do not set R1BIO_Uptodate if the current device is
>  		 * rebuilding or Faulty. This is because we cannot use
> diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
> index c98d43a7ae993..21e837db5b25e 100644
> --- a/drivers/md/raid1.h
> +++ b/drivers/md/raid1.h
> @@ -184,6 +184,12 @@ enum r1bio_state {
>  	R1BIO_MadeGood,
>  	R1BIO_WriteError,
>  	R1BIO_FailFast,
> +/* An invalid I/O (e.g. a bio rejected by the lower device because it does
> + * not meet that device's dma_alignment) is not a device failure.  Report
> + * the error to the caller without faulting the device or retrying, and do
> + * not complete a write as if it had succeeded.
> + */
> +	R1BIO_Invalid,
>  };
>  
>  static inline int sector_to_idx(sector_t sector)
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index cee5a253a281d..3cee9612be26d 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -323,7 +323,9 @@ static void raid_end_bio_io(struct r10bio *r10_bio)
>  	struct r10conf *conf = r10_bio->mddev->private;
>  
>  	if (!test_and_set_bit(R10BIO_Returned, &r10_bio->state)) {
> -		if (!test_bit(R10BIO_Uptodate, &r10_bio->state))
> +		if (test_bit(R10BIO_Invalid, &r10_bio->state))
> +			bio->bi_status = BLK_STS_INVAL;
> +		else if (!test_bit(R10BIO_Uptodate, &r10_bio->state))
>  			bio->bi_status = BLK_STS_IOERR;
>  		bio_endio(bio);
>  	}
> @@ -403,6 +405,8 @@ static void raid10_end_read_request(struct bio *bio)
>  		set_bit(R10BIO_Uptodate, &r10_bio->state);
>  	} else if (!raid1_should_handle_error(bio)) {
>  		uptodate = 1;
> +		if (bio->bi_status == BLK_STS_INVAL)
> +			set_bit(R10BIO_Invalid, &r10_bio->state);
>  	} else {
>  		/* If all other devices that store this block have
>  		 * failed, we want to return the error upwards rather
> @@ -523,6 +527,8 @@ static void raid10_end_write_request(struct bio *bio)
>  		 * before rdev->recovery_offset, but for simplicity we don't
>  		 * check this here.
>  		 */
> +		if (bio->bi_status == BLK_STS_INVAL)
> +			set_bit(R10BIO_Invalid, &r10_bio->state);
>  		if (test_bit(In_sync, &rdev->flags) &&
>  		    !test_bit(Faulty, &rdev->flags))
>  			set_bit(R10BIO_Uptodate, &r10_bio->state);
> diff --git a/drivers/md/raid10.h b/drivers/md/raid10.h
> index ec79d87fb92f6..a1adad3acafe1 100644
> --- a/drivers/md/raid10.h
> +++ b/drivers/md/raid10.h
> @@ -175,5 +175,11 @@ enum r10bio_state {
>  /* failfast devices did receive failfast requests. */
>  	R10BIO_FailFast,
>  	R10BIO_Discard,
> +/* An invalid I/O (e.g. a bio rejected by the lower device because it does not
> + * meet that device's queue_limits) is not a device failure. Report the error
> + * to the caller without faulting the device or retrying, and do not complete a
> + * write as if it had succeeded.
> + */
> +	R10BIO_Invalid,
>  };
>  #endif
> --
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
