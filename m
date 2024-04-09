Received: from mail.schwermer.no (mail.schwermer.no [49.12.228.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3FF1509B4
	for <dm-devel@lists.linux.dev>; Tue,  9 Apr 2024 16:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.12.228.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712680403; cv=none; b=lyyItuSKaWlIzSLwbrjc+gVoraI1r3Shpgrc0ElJVKmkC8ZxucksWIYOhYxbMWPX0ii9muj5Nn27nvcCmtlnRVh7nGII0pVXJqT0BgLqGYjheDIUc5JRpo3vPmjQIMs3cBh3i5TxIPtXSWAl8vQ1MGyLNqiv2nT42NPvfS09jk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712680403; c=relaxed/simple;
	bh=QfAgEop55zMod9u7xSvLllHAxP+biw+1OxjL9XYJE5s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MwcjBvzELIzmChgJIVmxQHdSpLpW+AlixzIoyKSl6gmD88ChR8BbsTFwGi3DAUjyqPG27on6aw8GFjruCToEPx5YiZaAshVGycdctjmlFj21ddvVomO+toudfT7diLchnbXNK1DyzKNAcOnX01Nb4o+80d5Xn9vFAdLcOAHAYMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=schwermer.no; spf=pass smtp.mailfrom=schwermer.no; dkim=pass (2048-bit key) header.d=schwermer.no header.i=@schwermer.no header.b=SrP1/Fdr; arc=none smtp.client-ip=49.12.228.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=schwermer.no
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=schwermer.no
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=schwermer.no header.i=@schwermer.no header.b="SrP1/Fdr"
X-Virus-Scanned: Yes
Message-ID: <e746b8b5-c04c-4982-b4bc-0fa240742755@schwermer.no>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=schwermer.no; s=mail;
	t=1712680396; bh=QfAgEop55zMod9u7xSvLllHAxP+biw+1OxjL9XYJE5s=;
	h=Subject:To:Cc:References:From:In-Reply-To;
	b=SrP1/FdroJRgsXpjaIHfevbJIDRVvx0IDKg2Bpd5CYZFs+GErTA1gGKjTdpfZTRHi
	 0L6/ZgBWk/K4lzPG0UK6pCkYdfsVSPkOFyfl4D1WraDJ0kA4Q8A5jdlJzdttQp/GVU
	 PAsG2A5XgrVWHQc+F5sp5UeJVoDUjeFrnuA3rG6tB8xnTHUGKEhu38zuFftm0KLelG
	 JnLdGG8TcAoFpRO7WIHUt7aW8j39tf21e7ijxeyHacl4m+LUfYd1KQmW1WK52u/zOu
	 71YZjT4EgWA9hsayIZP5K4pSz8sTYiQ31Gu1IgmPr4MfdfaS/qBQHpEer1hzic+VZo
	 ANpotrvU095hw==
Date: Tue, 9 Apr 2024 18:33:14 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: dm-init/dm-verity: Data device lookup failed
To: Christoph Hellwig <hch@lst.de>
Cc: dm-devel@lists.linux.dev
References: <b5c5cd56-b9dd-4368-a8e1-b9e0a07b79b4@schwermer.no>
 <20240409142323.GA22617@lst.de>
Content-Language: en-US
From: Sven <dm-devel@schwermer.no>
In-Reply-To: <20240409142323.GA22617@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

With the following patch

diff --git a/block/early-lookup.c b/block/early-lookup.c
index 3effbd0d35e9..9e5b11270f8e 100644
--- a/block/early-lookup.c
+++ b/block/early-lookup.c
@@ -138,6 +138,7 @@ static dev_t __init blk_lookup_devt(const char 
*name, int partno)
  			/* We need to return the right devno, even
  			 * if the partition doesn't exist yet.
  			 */
+			pr_err("%s: %s:%d doesn't exist yet\n", __func__, name, partno);
  			devt = MKDEV(MAJOR(dev->devt),
  				     MINOR(dev->devt) + partno);
  		} else {
@@ -165,8 +166,10 @@ static int __init devt_from_devname(const char 
*name, dev_t *devt)
  	}

  	*devt = blk_lookup_devt(s, 0);
-	if (*devt)
+	if (*devt) {
+		pr_err("%s: %s found\n", __func__, name);
  		return 0;
+	}

  	/*
  	 * Try non-existent, but valid partition, which may only exist after
@@ -181,16 +184,20 @@ static int __init devt_from_devname(const char 
*name, dev_t *devt)
  	part = simple_strtoul(p, NULL, 10);
  	*p = '\0';
  	*devt = blk_lookup_devt(s, part);
-	if (*devt)
+	if (*devt) {
+		pr_err("%s: %s:%d found without #\n", __func__, name, part);
  		return 0;
+	}

  	/* try disk name without p<part number> */
  	if (p < s + 2 || !isdigit(p[-2]) || p[-1] != 'p')
  		return -ENODEV;
  	p[-1] = '\0';
  	*devt = blk_lookup_devt(s, part);
-	if (*devt)
+	if (*devt) {
+		pr_err("%s: %s:%d found without p#\n", __func__, name, part);
  		return 0;
+	}
  	return -ENODEV;
  }

diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
index 32d49100dff5..9110cce01bee 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -375,6 +375,7 @@ static int mmc_blk_open(struct gendisk *disk, 
blk_mode_t mode)
  	}
  	mutex_unlock(&block_mutex);

+	pr_err("%s: ret=%d\n", __func__, ret);
  	return ret;
  }

I end up with the following messages:

mmc_blk_open: ret=0
blk_lookup_devt: mmcblk0:2 doesn't exist yet
devt_from_devname: mmcblk0p2:2 found without p#
blk_lookup_devt: mmcblk0:2 doesn't exist yet
devt_from_devname: mmcblk0p2:2 found without p#
device-mapper: table: 254:0: verity: Data device lookup failed (-ENXIO)
device-mapper: ioctl: error adding target to table

It seems like mmc_blk_open is not to blame.

Sven

On 4/9/24 4:23 PM, Christoph Hellwig wrote:
> On Tue, Apr 09, 2024 at 01:33:13PM +0200, Sven wrote:
>> Hi,
>>
>> I'm using dm-init to set up a dm-verity rootfs, i.e. my kernel command line
>> includes:
>>
>> root=/dev/dm-0
>> dm-mod.waitfor=/dev/mmcblk0p3
>> dm-mod.create="rootfs,,0,ro,0 614400 verity 1 /dev/mmcblk0p3 /dev/mmcblk0p3
>> 1024 4096 307200 76801 sha256 HASH HASH"
>>
>> Occasionally, my device refuses to boot with the following errors:
>>
>> device-mapper: table: 254:0: verity: Data device lookup failed (-ENXIO)
>> device-mapper: ioctl: error adding target to table
>>
>> There appears to be a race condition somewhere. This problem started to
>> appear when updating from kernel version 5.15.148 to 6.6.22. Looking at the
>> changes between the versions, this patch seems relevant:
>> https://lore.kernel.org/all/20230531125535.676098-19-hch@lst.de/
>>
>> It appears that early_lookup_bdev in dm_init_init would succeed even if the
>> partition block device is not there yet but the parent block device is.
>> Could that explain why the subsequent device lookup for the partition
>> fails?
> 
> -ENXIO isn't really an error that should come from the early block
> device lookup.  On the other hand mmc_blk_open can return -ENXIO
> and block device open return values end up here.  Can you throw
> a printk or trace probe of your choice into mmc_blk_open to see if
> that's the culprit?
> 
