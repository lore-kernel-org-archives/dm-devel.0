Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF951862A
	for <dm-devel@lists.linux.dev>; Tue,  3 Mar 2026 07:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772522213; cv=none; b=ott/OR1WNN9xzjFR6DhEZ1U3fYIJzvPOj2k3Oo5ioZwWCy9gGlH4t5+posZsPdTLJi216FoQ0WzUrQ62f/WsFqWb2ruogd8I9EFPUYfB0rnSB7snJFsX52FMuzNndMunROUGd/dQU0eypAQjcPAl72Gy7jAW0L8vj5c9UlY1iJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772522213; c=relaxed/simple;
	bh=/Qfj9Rfe9VHa6B3SdwOqVDt88Ex5URZd6iDmMVRAVRs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fPapgrojQPza7HSu/9iKtLoMQHpPxRssRtHgUdl6sQxZT1YcHVuTEKg37hyjEMS7iPfc5NEof3UjjRDiaCjlAgcmPfG3Wa/yCkdmOTS/1eprvT9i6Lpt72FyvXTK+dmzOATyedKI3k/g3G603HG7vbYQxsHFbr/mgI1le4Zz5Rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=a/Sv1+az; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="a/Sv1+az"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4836d4c26d3so39705825e9.2
        for <dm-devel@lists.linux.dev>; Mon, 02 Mar 2026 23:16:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772522211; x=1773127011; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ubymJC3yMVrWaVX4434QCzD6ml7X+t88qVksAj99ZwM=;
        b=a/Sv1+azyRza27pJQ2aEBqpTCYS0LrLQ7RniUYPzpafIjghYgvxgd4MhomDToUqsBX
         b3dmPIM5IRrV1BtJqTIhZXNDvZKNfblNxj1/oKd12isCBhrnPGAmPgRckUQdvtHlNT5j
         EV/9S/6Ke88ilsp/u46knxBGMIo/pF7kFE3iy3W3qyp/Kh6ssJDlDOVibF3y0oTu46Uv
         En2Gn9WivWMAyVMAoviKqM8p3KbmqQNw89O0LEu9cVzFj8xQI6sJmLtvb6Zdn9+h925I
         1MJ8GuH7PapjhrnRG8TDM5hCXlMmihbKpm4jv5eF9QvgOM5fB+t/B/fJQ2/WmdqM80R0
         4VBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772522211; x=1773127011;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ubymJC3yMVrWaVX4434QCzD6ml7X+t88qVksAj99ZwM=;
        b=lfLVwoQSnXiB5bjjWHJC7LtfAHnp6IEp24HXFouf84iFKrckcyWpdG9XQw8JTjTTPZ
         Obpo+IzhPrLAop8GzKohj09hCfR8SLUxEvY0G/GvZfrdsn7P1mKXdUcxSW8NvDqFYEcR
         TTBVhKKt4nDw1aSdEFTEzG5XrrJGLe/QO9LL9c61YDEilvw+zARlUJwMk2nUkwJU/H5z
         O0SnTotri0XQohrxzLlM7vI7WFkHId5JGd8H7NMylqaSiWH7XCARqXq3WRUFiFKaExsx
         wYWqcY7CVsCE5CjhWWDPq5WP5WJuIYwWvk0wkeqzXcmAznv2oc1kHOWWPYg4TL1fYMp7
         XDvA==
X-Forwarded-Encrypted: i=1; AJvYcCUGRTN+/Ub4Au3g9ubYgIozc4dpgtFGxEyYgV091rMBA2k7Kob1TJHTBdLUQTmGxQ1O5Lu+fMO2/g==@lists.linux.dev
X-Gm-Message-State: AOJu0YyYUFcu8F/buTUV4KmRXZjOBBEuRuikLvE5V/vWelHgM/f9Td2M
	zqqom21zHj4Ok4aR97x1rDBSoM59N/9nNKeN4do7NIhMhOZGV1J+fZ3fZy4JGHgOaI0=
X-Gm-Gg: ATEYQzwBfoSDavdHOPwdNFfMdWcQTX8D2SECLEqPZ3j2eC3gc1nwsQJLBJl6c4HaNs2
	/hccEhChhUfeqgqVIrk/+o0X7++ivDBD1BNhSkQ4P37M+bAtRb+xyAFnHVKSDKN3nOYaMvoxkH/
	svCtdJ9643VDC7kLeDiEfo56f8p43mq8ke3EQCA0N7nkz56VKewYadBLTkWzKzu2RKiGSW/ted3
	2O0c5/wmv61mZQhsBWJzpY8RmdM27cOdD3ECciWck6m8k5bqOtD2fekjkkafONNBneyOJq76yLa
	8jXLRsQtMVj6OtqIeyPzD+j3GnqlYh0v2rUeugS6E/sjUwytMxrQbwRLAdTwwpK6RJqQivQCsbD
	bf9rlRnz9yC6dJylA6z4Cmq3rLRbGoSpWUrjwQRP4uPRfmU535lm7l4mPkOUiUqT62WMoiZkGaZ
	CFBcn8QBSUz/0PLNKlJEK1BVR3kRAbbihMjSnWFWOOoG67LrsDcwQd6jrwHYyrgjvpqA==
X-Received: by 2002:a05:600c:3108:b0:483:709e:f238 with SMTP id 5b1f17b1804b1-483c9c1d177mr268411375e9.29.1772522210626;
        Mon, 02 Mar 2026 23:16:50 -0800 (PST)
Received: from [192.168.178.47] (aftr-82-135-83-117.dynamic.mnet-online.de. [82.135.83.117])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-485125bbb48sm16093555e9.0.2026.03.02.23.16.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2026 23:16:50 -0800 (PST)
Message-ID: <9881a867-244c-4ae5-852a-3332b7eb0614@suse.com>
Date: Tue, 3 Mar 2026 08:16:49 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/24] scsi-multipath: introduce scsi_mpath_device_class
To: John Garry <john.g.garry@oracle.com>, hch@lst.de, kbusch@kernel.org,
 sagi@grimberg.me, axboe@fb.com, martin.petersen@oracle.com,
 james.bottomley@hansenpartnership.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
 linux-scsi@vger.kernel.org, michael.christie@oracle.com, snitzer@kernel.org,
 bmarzins@redhat.com, dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
 <20260225153627.1032500-5-john.g.garry@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260225153627.1032500-5-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/25/26 16:36, John Garry wrote:
> Introduce a new class for multipathed devices, scsi_mpath_device_class.
> 
> The purpose of this class is for managing the scsi_mpath_head.dev member.
> 
> The naming for the scsi_device structure is in form H:C:I:L,
> where H is host, C is channel, I is ID, and L is lun.
> 
> However, for a multipathed scsi_device, all the naming members may be
> different between member scsi_device's. As such, just use a simple
> single-number naming index for each scsi_mpath_head.
> 
> The sysfs device folder will have links to the scsi_device's so, it will
> be possible to lookup the member scsi_device's.
> 
> An example sysfs entry is as follows:
> # ls -l /sys/class/scsi_mpath_device/0/
> total 0
> drwxr-xr-x    2 root     root             0 Feb 24 11:56 power
> lrwxrwxrwx    1 root     root             0 Feb 24 11:56 subsystem -> ../../../../class/scsi_mpath_device
> -rw-r--r--    1 root     root          4096 Feb 24 11:55 uevent
> -r--r--r--    1 root     root          4096 Feb 24 11:56 wwid
> # cat /sys/class/scsi_mpath_device/0/wwid
> naa.600140505200a986f0043c9afa1fd077
> 
Ah, here it is.
So you can ignore my comments from the previous patch.
(and you might think of merging this and the previous patch).

But device naming is still dodgy. A plain number has so many ways of
being misinterpreted.
Wouldn't it be better to name it 'mpathX' ?

And, of course: how can we get the topology?
Do we get a list of the underlying scsi devices from sysfs?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
