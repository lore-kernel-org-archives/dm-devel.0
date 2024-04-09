Received: from mail.schwermer.no (mail.schwermer.no [49.12.228.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54BF212E1DD
	for <dm-devel@lists.linux.dev>; Tue,  9 Apr 2024 11:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.12.228.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712662399; cv=none; b=IMoBBpVlmkguOkrcJpRW+mNa4hD3c/mgRJ+mdkWnwa4JX19FYMbRltouTAhc0xpZ+q8/ZvX1Qn5zgM+R8LRP7UsNNsA6ZJGgEvNF64sE79C0m2rFwcPdEHsDIfU3om4m28eoo1HBrbETDGuNovACP4S93gLG5DkcsHFZhk+lZyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712662399; c=relaxed/simple;
	bh=dFweYkfqsY6Sr2WpR72t4e7CT/ReIKiIXHH6/2i4DQg=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=jEQ6/nCW+OGO+pbh1BMIlSTZ9d33PvbfQUCDmYLI6GJ4epUmW0O0NFM0cbR+KZQ4XktKW2DTExTrLiNcv39X+yHthC/HQxHVgpcaRkQWVWf2J9JdNjIet2OJfIc4dHqTYZ7Baq4YX0J0A/7tLTUO0M8TchWsPyOz9UaW+IHkzsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=schwermer.no; spf=pass smtp.mailfrom=schwermer.no; dkim=pass (2048-bit key) header.d=schwermer.no header.i=@schwermer.no header.b=+GTlNrtB; arc=none smtp.client-ip=49.12.228.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=schwermer.no
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=schwermer.no
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=schwermer.no header.i=@schwermer.no header.b="+GTlNrtB"
X-Virus-Scanned: Yes
Message-ID: <b5c5cd56-b9dd-4368-a8e1-b9e0a07b79b4@schwermer.no>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=schwermer.no; s=mail;
	t=1712662394; bh=dFweYkfqsY6Sr2WpR72t4e7CT/ReIKiIXHH6/2i4DQg=;
	h=From:Subject:To:Cc;
	b=+GTlNrtBXFRwsezL5xIZ5gaB8p9mr10u7lhSqXTTWtleDCw11zSe90N4kr0ExlXGa
	 tf1ZJx/AgaRAY4JTJp0zc3HB9SWLWGTcVkhu5lsBaG/RpKqF911RQCmHhhWr1scZ9d
	 m78W+wZxd1gSpojD111j79m5LI5gCmLKsRxom7X4H0fQrsb/H+Ocm480H/NfyozKcm
	 JEpjx32jiQUD5Tm3iqVLtAhnrc2s0ewSpw6p0oPsKW/sXKeVpib8bEh1hKzVribyq1
	 /Zd74eGJ0dDEz49thAeXsp9bPHWMK4wGg00MBHj+YSLBpT1us7KmNQ4WSWg6amzw0/
	 VvrulnNTKO8Vw==
Date: Tue, 9 Apr 2024 13:33:13 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Language: en-US
From: Sven <dm-devel@schwermer.no>
Subject: dm-init/dm-verity: Data device lookup failed
To: dm-devel@lists.linux.dev
Cc: Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I'm using dm-init to set up a dm-verity rootfs, i.e. my kernel command 
line includes:

root=/dev/dm-0
dm-mod.waitfor=/dev/mmcblk0p3
dm-mod.create="rootfs,,0,ro,0 614400 verity 1 /dev/mmcblk0p3 
/dev/mmcblk0p3 1024 4096 307200 76801 sha256 HASH HASH"

Occasionally, my device refuses to boot with the following errors:

device-mapper: table: 254:0: verity: Data device lookup failed (-ENXIO)
device-mapper: ioctl: error adding target to table

There appears to be a race condition somewhere. This problem started to 
appear when updating from kernel version 5.15.148 to 6.6.22. Looking at 
the changes between the versions, this patch seems relevant: 
https://lore.kernel.org/all/20230531125535.676098-19-hch@lst.de/

It appears that early_lookup_bdev in dm_init_init would succeed even if 
the partition block device is not there yet but the parent block device 
is. Could that explain why the subsequent device lookup for the 
partition fails?

Best regards,
Sven
