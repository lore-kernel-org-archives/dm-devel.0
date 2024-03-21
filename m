Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB78C53E12
	for <dm-devel@lists.linux.dev>; Thu, 21 Mar 2024 09:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711012637; cv=none; b=ZjI0QIP6Ja+QRiW8h3pT0NKolZumL5cVg/ZA55qo9IyLASJ1VcjT0zVrvTVko0x654RuUc7ZuhvGNITGzhv9OUwD3R1+Di7DdP+S2Wu0UqLSfZeReyTqH/D6nil7p+R5+TB8BNRxOKyDMSO+FsRIYSmT21EEZVEvI4XHYFEpS/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711012637; c=relaxed/simple;
	bh=A2dUqi23mhrFRKH247nVj2PIyrePzIhEEJwoCB2FG6Q=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=smblH+1R8UeZk7Z8hAXqv+B6hUyxIx5DT3zUS+M1GDRCEQLqbOWFvIEdIKGMKqq4G+4q/GByQ8alzVa1FTe8Zy8UzhY1Q7z/j46MFhl0pQY0MHns6XX6oecrpo8IV4tegmBzXEUcI9UHc6oXog94nWU7G4wCBvDUeZW/oqERKBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hxvCRGYn; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hxvCRGYn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711012636; x=1742548636;
  h=message-id:date:mime-version:from:subject:to:cc:
   content-transfer-encoding;
  bh=A2dUqi23mhrFRKH247nVj2PIyrePzIhEEJwoCB2FG6Q=;
  b=hxvCRGYn8X7Cjr/JUfdW6A2g5L55AIUA3zcQ3eAOMdK/tofZXIaCtSFY
   GmNYD9zZtGueLbcHH+YthBFP2EKM7fOejxIm2Q+Q879i+7JW2eS+0RfBg
   xkK+RXgWJiTHVLex5RoXmzaAoQZZFKGWPuRMxkZNA7LfH8tqBYX2KbEbH
   71pYQ3YzIZUfOZU0ubzXDxJ9tfF3RPMeI7anOb3PRbKMoIQNBUUbtvl2o
   o6kAMOcEd5hKwygWGE0ngxlXFCYpTKHM5os8wKhiTWzWrwOfZyR34OoXZ
   8PYuvtDU/JJzBaKorst6ABJzPBPVZ3iZTqPJ0osoGEhCc/Z2JeTuRrUPV
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11019"; a="23484682"
X-IronPort-AV: E=Sophos;i="6.07,142,1708416000"; 
   d="scan'208";a="23484682"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 02:17:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,142,1708416000"; 
   d="scan'208";a="19083261"
Received: from mkusiak-mobl1.ger.corp.intel.com (HELO [10.246.34.229]) ([10.246.34.229])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 02:17:14 -0700
Message-ID: <35e0eae0-7fb0-4029-8445-997e22c21482@linux.intel.com>
Date: Thu, 21 Mar 2024 10:17:12 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: pl, en-US
From: Mateusz Kusiak <mateusz.kusiak@linux.intel.com>
Subject: regression: mdadm detects dm-device as partition
To: DM-devel-linux <dm-devel@lists.linux.dev>
Cc: linux-raid@vger.kernel.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello,
We discovered an issue when trying to create imsm container with mdadm on dm-device.

The scenario is as follows:

1. Create dm device
# echo -e '0 195312 linear /dev/nvme2n1 0' | dmsetup create nvme2n1DM

2. Create IMSM container.
# dmdev=$(readlink -f /dev/mapper/nvme2n1DM)
# export IMSM_DEVNAME_AS_SERIAL=1 IMSM_NO_PLATFORM=1; mdadm --create /dev/md/container 
--metadata=imsm --raid-disks=1 $dmdev --force

Result:

Error message is displayed
# mdadm: imsm: /dev/dm-0 is a partition, cannot be used in IMSM

Mdadm's function for checking "if partition" looks like so.

int test_partition(int fd)
{
     /* Check if fd is a whole-disk or a partition.
      * BLKPG will return EINVAL on a partition, and BLKPG_DEL_PARTITION
      * will return ENXIO on an invalid partition number.
      */
     struct blkpg_ioctl_arg a;
     struct blkpg_partition p;
     a.op = BLKPG_DEL_PARTITION;
     a.data = (void*)&p;
     a.datalen = sizeof(p);
     a.flags = 0;
     memset(a.data, 0, a.datalen);
     p.pno = 1<<30;
     if (ioctl(fd, BLKPG, &a) == 0)
         /* Very unlikely, but not a partition */
         return 0;
     if (errno == ENXIO || errno == ENOTTY)
         /* not a partition */
         return 0;

     return 1;
}

I plugged in with debugger and established that when ioctl is run on dm-device errno is EINVAL, as 
if it was a partition.

The issue is reproducible only with newer kernels which leads me te believe there is a regression in 
device mapper. This code has been working stable for last 10+ years, which is another reason. I 
tested this on RHEL 8.9 with inbox 5.14 kernel and 6.5.7-1 I happen to have installed. The issue 
reproduced only on 6.5.7-1 kernel. I also observed same regression on stock Ubuntu 24.04 with inbox 
6.6.0 kernel.

Can you please point me to when it was introduced and are there any plans for fixing it?

Thanks,
Mateusz
