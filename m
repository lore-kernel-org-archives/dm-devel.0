Received: from mail.schwermer.no (mail.schwermer.no [49.12.228.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2573286AC
	for <dm-devel@lists.linux.dev>; Fri, 12 Apr 2024 09:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.12.228.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712913221; cv=none; b=lffDHhhp34zwoiWTDS1cxauVO5Yr5EAP6pE2nawdMADjcbD+A3a1OwgxzH0VT+B290F2GlsnAxmwE1qfDoqGWiCLxSD89xODcUH3mzEia/hPxJLAVyN6UA5pLi8v633VD0nXoWHKM20ADfaZ9FthIrBTV4qQutSWo04SQM3jVGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712913221; c=relaxed/simple;
	bh=uySwppyPv+454vocW4sVxWntAp5CvM0RjGduy5Dcj2Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sqlGucw/YDl7NuKs8KU6Vh9ecqgiBWzB0hs1seg/JN52aHa4XktnSySNNLBINLenI54sPdZ8AXWQa2XksMDryPr9gcC7PZ+CXg7jKy+X3jI1ZodJ02mfC+MbOBXtq0v3m9oP5o+6sUGSRu2vTgeWBT5nzEo+uQMX9orXStOvpnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=schwermer.no; spf=pass smtp.mailfrom=schwermer.no; dkim=pass (2048-bit key) header.d=schwermer.no header.i=@schwermer.no header.b=706kQmkM; arc=none smtp.client-ip=49.12.228.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=schwermer.no
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=schwermer.no
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=schwermer.no header.i=@schwermer.no header.b="706kQmkM"
X-Virus-Scanned: Yes
Message-ID: <ba299ab0-9b70-469f-8c1b-bf88465df63f@schwermer.no>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=schwermer.no; s=mail;
	t=1712913208; bh=uySwppyPv+454vocW4sVxWntAp5CvM0RjGduy5Dcj2Y=;
	h=Subject:To:Cc:References:From:In-Reply-To;
	b=706kQmkMIC4G5uJnVbUnWSqzEl0vqVu4nFcK1xFto9jsxy5xdB2pq81OvCu0x1OND
	 WIQF1Hb5MOTHCv0fN524oNBktHVztwLKUkNV4ZCQWIhUprAbE3KoxJJO7EG3IMvSb6
	 gYSd1QpoeqKMKebxs6Q5giyPhF1k/g2YVzc3OUcmEBGaxu8FODXicPipxkYguY/CiY
	 AEmhBKD+JaZW+oNGC4d91wVteZZHlFXTwFUhglk3ToWihxSaU7P8VmkKhmrjkq5mFz
	 KIBbK6ua6hWr9CLq6KEr1FgcxcRMh5Kxzh7qyghkeOeocLhK8Whvfn6iaaBam61xjT
	 kB09TlDOjJshQ==
Date: Fri, 12 Apr 2024 11:13:27 +0200
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

Hi again,

I have found out some more about this issue:

When dm-init succeeds in finding /dev/mmcblk0p3, it actually only finds 
/dev/mmcblk0 and NOT the partition block device (see behavior in 
devt_from_devname).

Subsequently, when dm-verity looks up the data device (/dev/mmcblk0p3) 
via dm_get_device, the following call stack is executed:

dm_get_device
  dm_get_table_device
   open_table_device
    blkdev_get_by_dev
     blkdev_get_no_open

blkdev_get_no_open actually returns -ENXIO because the partition device 
is not available yet. That error then propagates back.

A naive fix that works for me follows:

diff --git a/drivers/md/dm-init.c b/drivers/md/dm-init.c
index 2a71bcdba92d1..1e0867e5e9d95 100644
--- a/drivers/md/dm-init.c
+++ b/drivers/md/dm-init.c
@@ -294,10 +294,14 @@ static int __init dm_init_init(void)
  	for (i = 0; i < ARRAY_SIZE(waitfor); i++) {
  		if (waitfor[i]) {
  			dev_t dev;
+			struct block_device *bdev;

  			DMINFO("waiting for device %s ...", waitfor[i]);
  			while (early_lookup_bdev(waitfor[i], &dev))
  				fsleep(5000);
+			while (!(bdev = blkdev_get_no_open(dev)))
+				fsleep(5000);
+			blkdev_put_no_open(bdev);
  		}
  	}

This is probably not ideal but I lack knowledge in the dm world to come 
up with a better fix. Suggestions welcome.

Best regards,
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
