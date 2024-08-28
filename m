Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DFE3165EE4
	for <dm-devel@lists.linux.dev>; Wed, 28 Aug 2024 09:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724836868; cv=none; b=qIULvIEMn0C0d2hKn9VNVtAElGj2Q9dTI8b9hRUC86CW0J7XVOOgKBvHJdle3NpWGzEGzncLa5g2gtty/TkJN2fTW0pHhMfXSvQ6XT2umrE9aerdHmVBHv4gq2KETnpQdSyudy6nskioMIwC7N9UiUez4VF0zYhnAkLcyCMVL6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724836868; c=relaxed/simple;
	bh=UrqnM+AHnstZJU9eY/MTnoTwWl9K3urYI1BT6ShVZuA=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=AK5owOPYN6RQKOn9CzRnfCCWvcOerAgx5c6UwjnHgmesL0yc/eZMocgkEoOeWiyCOxMeSDZhzn1jmaOws7TusGU3sA8C+VQwN0K2wFEQ4eGCG/CEsg1Rci7Hb9JzKEm0RcwKeJbXNskhiWOIKmts7492rsP0qOHUvi/ryvgh1MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lo3MLc8l; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lo3MLc8l"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5bed0a2ae0fso8072815a12.1
        for <dm-devel@lists.linux.dev>; Wed, 28 Aug 2024 02:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724836864; x=1725441664; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5jxn5P8l1/bQbTPnHdWPNbFkGUkycrLbC1p5s9NgMbw=;
        b=lo3MLc8lOdAqA7GJ9f3ZMnma1oMZkEixw4DY/I0fmHHnmpgwKObM0jneFilvcF17aT
         wAF0UNMBkIYa+kns/jV38djaHPf7V/5hh0AW/y5anVnKCTcax7mV7sj8y40ESXsjPPps
         gvTk7Qs8N6lIDppBbQTxiIP6Z7QGGC9j/WSWUzeOoTnbOJvM1EAC4wxHTUsWCkJrXMsA
         t5bgzGtLjWA2M8yvRl18hPeqo628ROw/wtfquIXQ5E+jQMR54bydwsP1Xu1ciOrpsxE6
         IMGv9pzpon9woJV2RykHAHzud64j3PpR8wFCj1pFE6mQiO4on8AGAfbvt8hNqpaTHdip
         pUgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724836864; x=1725441664;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5jxn5P8l1/bQbTPnHdWPNbFkGUkycrLbC1p5s9NgMbw=;
        b=D777qeBeF6IEmHo5XPc5lcXW1Bbd9IpkvBl+ve8Rc4xwS+QlbbIoREFeu7h1zbx4fm
         YYAoMjNrKtvbBeSgzu/BtZt+nB5hl3FViGZWQYNWfg0Yu8X6BxDavidLidvaXLo9fOmF
         tjLThJWA7b6Tmj5k1zahief9wbdZaOl25lT9/N4sGm5rGusWS5TNLdnYJtUd1mqBFO5c
         szRl/tPPkqFxsKFqIK0RizGp5powQBoZI4YdL7oBRUrvGGUYviX68EQYZyz9Qddp5uA4
         OVsEWJ3IpAPl8R858SkF3t6MqWkr0U2KZz1z2Wvy/hLippEvFABYk2rqmzzVQD8dofBZ
         gphg==
X-Forwarded-Encrypted: i=1; AJvYcCX659AxRTBpgulr7g7k8FcP3pdkM4+Hak36TUpAMWQsZCCILo7MmwKa73xNsN4X2NcFxG5w3BNbQQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw7Wwu9xgdvwBsl2UjoDrLd7FyjIyOdAOCyqFFpd79SY/xY7iMw
	HThPuwhmerX+4EkfL8/uxYJC5FprP5wPQb6TY1SQFvKLlmibBd+p
X-Google-Smtp-Source: AGHT+IFX9edtfB2lZC+bNMQXKDg1hJnrIRnOMUI9Hn/nkayYjmtSrf0WjcmoPlZTTPAVPWwSKvGxDw==
X-Received: by 2002:a05:6402:354c:b0:5c0:adad:98a2 with SMTP id 4fb4d7f45d1cf-5c0adad99f5mr5855755a12.1.1724836864230;
        Wed, 28 Aug 2024 02:21:04 -0700 (PDT)
Received: from [10.0.0.100] (093105062173.zamosc.vectranet.pl. [93.105.62.173])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c0bb1e51c8sm2006209a12.34.2024.08.28.02.21.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Aug 2024 02:21:03 -0700 (PDT)
Message-ID: <0a02f887-aa70-4c7a-be58-3920596c175e@gmail.com>
Date: Wed, 28 Aug 2024 11:21:02 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: =?UTF-8?Q?=C5=81ukasz_Patron?= <priv.luk@gmail.com>
Subject: Re: [PATCH] dm: Implement set_read_only
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20240821213048.726082-1-priv.luk@gmail.com>
 <da447e8f-0068-d847-b712-47081fa9f2e7@redhat.com>
Content-Language: en-US
In-Reply-To: <da447e8f-0068-d847-b712-47081fa9f2e7@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi

 >I'd like to ask why is this patch needed? Why do you want to set read-only
 >status using this ioctl instead of using the existing table flag?

I basically just wanted to be able to use `blockdev --setrw {}` on
Android for a block device that had its table mapped as read only. I
believe that used to work on 5.10 or so, but not anymore.

 >If this is needed, we need to add another flag that is being set by
 >dm_blk_set_read_only, so that dm_blk_set_read_only and dm_resume won't
 >step over each other's changes.

The following diff should address that, however I noticed that
set_disk_ro() itself, triggers an uevent message that makes upstream
lvm2/udev/10-dm.rules.in <http://10-dm.rules.in> disable a dm device, so 
not sure if this is
good to have, after all.

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -412,6 +412,19 @@ static int dm_blk_getgeo(struct block_device *bdev, struct hd_geometry *geo)
  
  static int dm_blk_set_read_only(struct block_device *bdev, bool ro)
  {
+	struct mapped_device *md = bdev->bd_disk->private_data;
+	int srcu_idx;
+	struct dm_table *table;
+
+	table = dm_get_live_table(md, &srcu_idx);
+	if (table) {
+		if (ro)
+			table->mode &= ~BLK_OPEN_WRITE;
+		else
+			table->mode = ~BLK_OPEN_WRITE;
+	}
+	dm_put_live_table(md, srcu_idx);
+
  	set_disk_ro(bdev->bd_disk, ro);
  	return 0;
  }


On Tue, Aug 27, 2024 at 7:52 PM Mikulas Patocka <mpatocka@redhat.com> wrote:



    On Wed, 21 Aug 2024, Łukasz Patron wrote:

     > This lets us change the read-only flag for device mapper block
    devices
     > via the BLKROSET ioctl.
     >
     > Signed-off-by: Łukasz Patron <priv.luk@gmail.com>
     > ---
     >  drivers/md/dm.c | 7 +++++++
     >  1 file changed, 7 insertions(+)
     >
     > diff --git a/drivers/md/dm.c b/drivers/md/dm.c
     > index 87bb90303435..538a93e596d7 100644
     > --- a/drivers/md/dm.c
     > +++ b/drivers/md/dm.c
     > @@ -410,6 +410,12 @@ static int dm_blk_getgeo(struct block_device
    *bdev, struct hd_geometry *geo)
     >       return dm_get_geometry(md, geo);
     >  }
     >
     > +static int dm_blk_set_read_only(struct block_device *bdev, bool ro)
     > +{
     > +     set_disk_ro(bdev->bd_disk, ro);
     > +     return 0;
     > +}
     > +
     >  static int dm_prepare_ioctl(struct mapped_device *md, int *srcu_idx,
     >                           struct block_device **bdev)
     >  {
     > @@ -3666,6 +3672,7 @@ static const struct block_device_operations
    dm_blk_dops = {
     >       .release = dm_blk_close,
     >       .ioctl = dm_blk_ioctl,
     >       .getgeo = dm_blk_getgeo,
     > +     .set_read_only = dm_blk_set_read_only,
     >       .report_zones = dm_blk_report_zones,
     >       .pr_ops = &dm_pr_ops,
     >       .owner = THIS_MODULE
     > --
     > 2.46.0

    Hi

    Device mapper already calls set_disk_ro in the do_resume function.
    So, the
    problem here is that the value set using set_read_only will be
    overwritten
    as soon as a new table will be loaded.

    I'd like to ask why is this patch needed? Why do you want to set
    read-only
    status using this ioctl instead of using the existing table flag?

    If this is needed, we need to add another flag that is being set by
    dm_blk_set_read_only, so that dm_blk_set_read_only and dm_resume won't
    step over each other's changes.

    Mikulas

