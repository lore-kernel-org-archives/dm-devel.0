Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DAEA29CEB
	for <dm-devel@lists.linux.dev>; Sat, 19 Jul 2025 14:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752935811; cv=none; b=GGxhOcA010Gn8Nv0vk0BEoWPoNDcwwoq/+/rTb8Pv+VkeHZRFZ5nrXbsyiyUyYL6CBlcne9YeEif91RWYnUc2A59Sh8KGBlEhJQQOHa3uXVs/lu4G9wUyhQcqua/GlJV+6yx/6M5TKX9aYBuYA6c7vhuUBA/GMOGO8jGNuHi4Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752935811; c=relaxed/simple;
	bh=6EftFzR8mv63ZwUuId8lMgNI0GfiUzD2Ngd/42JHCYI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=odk3F7Fv2OnnHGfcdMxpWzbGkE4KtKsqa02ZeIIVPTgELwy+e7i8dudwu90u4pbzxcIw56Sf4CCgQ5ZbxQbQMivL0rPiAxj3yki1prTvAOTDrwn27lLiOaifONAzrgOIuArc0M1rHwZp5Pc7ZaGq5IxJwKsWOi/j5P7J2ntCDFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H2lTTgnz; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H2lTTgnz"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3a577f164c8so409374f8f.2
        for <dm-devel@lists.linux.dev>; Sat, 19 Jul 2025 07:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752935808; x=1753540608; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3KQGDQ0mzAW72Re+ftr2/lqtpu8Hq5HL1DX+i3NPovc=;
        b=H2lTTgnzBzJI+0aOlfJgCBkoN//KVEjw3M6J7Q+Evc1L2FCod58N9nAxf5W/e5zxVZ
         qK4W/7GJyLdYk2nff6LFu/xrc5k5FOoo7kOe82+wJYYuOhDMi0pMtyl7FNYG2HjcZRz2
         DUhCVhzz04yG2IfKbDcA5mU807ZU8iX23+vHrKyiOKC1tKomo71NbqrqYOjkHw5d7jWh
         tEStSyTMMugwjZB/sIiln+j+ImC5w5i0jXERYYvp8O6hxfx4uOB/r9wVWB/eWohUW7KK
         oVvEiDFSnSmvjwqLYrDYKnUWmRCaevCza/fomOnYpAM1QyO7FPmNoaD9QAzYNt9tdnVN
         Zx0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752935808; x=1753540608;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3KQGDQ0mzAW72Re+ftr2/lqtpu8Hq5HL1DX+i3NPovc=;
        b=s1TCgu7qf170gBUfNyqcJmV3Mmqhm/sPqn4G9rdyYPCvkU4Wyjo9KK4B3ZpiNd+RBE
         mc4t48tKP60XMOFdB2UGOTBi5PMyci2dFIRFlGgCOOwEVCbEiJepUUA2JNevrhYKI+CS
         niB0Y4YK8s5vpRboLnx6LyuXItqaDI5nok8tKyNF7Zaeg8pmu9XvLHIX3nywkEgesENL
         tX67x1RcNMAEXq6szOP7sKmCknUMY7eo4ZfTkQw5XcWwtEgUIrzJewTGRjtvLAAYFbD8
         a/GcJyzxQ+YX2lz9re837rOi3AIIS9itekOI658dpnNR76BcO7Q7rd8T7RqLTtlpstsD
         8rWg==
X-Forwarded-Encrypted: i=1; AJvYcCXUitTAoL9J5pprpsjAnQ6hXIKcw5ETF44Ao3AEVLaQ11jsDSzhZmqGWP4qH34HaFinJAZHDlUM5g==@lists.linux.dev
X-Gm-Message-State: AOJu0YzVeY+8gBghVhmsMge/lN27EpA2/NUZx7+lF5FRFavDWs2isnBb
	tikhnrHgYHMFgpGZpu75Ayxxn9QJUu/fFIQ7iAHB2G3+zplUXmABxPM=
X-Gm-Gg: ASbGncuAc1zXRb7BHJSUplRM7tjxYCuwTiUNGvOUyhmJpJgyNyDXhKX9JS71Wv6z+fh
	VbOmn/rccYe55+789vfZGNqC8JbMz+BkRCfsCRo51Uj06IvUYnpSMn+oBRCqo9mNy/EnwcJvHpw
	w7+dz6urmWoR9CnMQDb7P076FDaAFoO0CuYaBnoiWU4I4qzfBe9wouioWTRZmDtu4xLRLUfGXTw
	4kZ7K5eBe473WNNeL1ncwIkFC7JMoUJ+IBoMAuIOVn88YQxagqsh2XCNV6ZlvVJmDGELIqFa8/g
	0+tURWzVhkDMKVG3/wz995Qal/BS6+BuIMJIBZZ8cDhPDswb9EDLsuQo76E96F0+dVjA0XQ2z/z
	WqDdn2Kq1ugqMJq/V8e9Gzc5579b9OzEBquUD1OLAKFwfQ2tVf4ANgIbrZ/EkgVgm2A==
X-Google-Smtp-Source: AGHT+IFLFXo4Q/VrKZHu47y9kKGPD6FvwmjjdCqypg1CAGHXTL4ZGn3tsWivRPCkbMGCnkr5y2mc+g==
X-Received: by 2002:a5d:6507:0:b0:3a6:d256:c5db with SMTP id ffacd0b85a97d-3b60dd879damr4504292f8f.13.1752935807464;
        Sat, 19 Jul 2025 07:36:47 -0700 (PDT)
Received: from localhost (179.red-80-39-133.dynamicip.rima-tde.net. [80.39.133.179])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b61ca5c8dfsm4904575f8f.82.2025.07.19.07.36.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Jul 2025 07:36:47 -0700 (PDT)
Message-ID: <be0ea1f8-cb4e-4a2d-9902-163d7e6a5863@gmail.com>
Date: Sat, 19 Jul 2025 16:36:45 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH] multipath-tools: fix default blacklist of s390 devices
To: Martin Wilck <mwilck@suse.com>, Stefan Haberland <sth@linux.ibm.com>
Cc: Nigel Hislop <hislop_nigel@emc.com>,
 Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Hannes Reinecke <hare@suse.de>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>,
 S390-ML <linux-s390@vger.kernel.org>, DM-DEVEL-ML
 <dm-devel@lists.linux.dev>, Nigel Hislop <hislop_nigel@dell.com>
References: <20250712201454.215404-1-xose.vazquez@gmail.com>
 <76bde3f1-0f06-46fc-8e0a-729e6629024c@gmail.com>
 <d5e08375-211d-405b-9a00-f44c857cedac@linux.ibm.com>
 <2c83b76c-46cc-4632-a930-d023c7d3d7b0@gmail.com>
 <cc3cf74ef6c394b371f4ce0e0dfe09f783403617.camel@suse.com>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <cc3cf74ef6c394b371f4ce0e0dfe09f783403617.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/19/25 2:34 PM, Martin Wilck wrote:

> On Fri, 2025-07-18 at 22:54 +0200, Xose Vazquez Perez wrote:

>> On 7/14/25 2:38 PM, Stefan Haberland wrote:
>>
>>>> Is PAV really supported on FBA devices ???
>>>> And other than 3390 and 3380(3390 model 2/3 in track-
>>>> compatibility mode) ECKD types ?

>>> Currently there is no support in the driver for PAV with FBA
>>> devices.
>>> But the devices itself are capable of PAV.

>> If there is no PAV support for FBA devices on Linux, and it looks
>> like it won't be
>> implemented even in the distant future. The detection code, and the
>> device, could
>> be deleted from multipath-tools:

> I agree. @Stefan, it would be appreciated if you or someone from your
> group could send a patch.

Something like (untested!):

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 31db8758..4fc0c496 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1677,11 +1677,9 @@ ccw_sysfs_pathinfo (struct path *pp, const struct vector_s *hwtable)
  	if (sysfs_get_devtype(parent, attr_buff, FILE_NAME_SIZE) <= 0)
  		return PATHINFO_FAILED;

-	if (!strncmp(attr_buff, "3370", 4)) {
-		sprintf(pp->product_id,"S/390 DASD FBA");
-	} else if (!strncmp(attr_buff, "9336", 4)) {
-		sprintf(pp->product_id,"S/390 DASD FBA");
-	} else {
+	// PAV is only supported on ECKD devices.
+	// Defined in drivers/s390/block/dasd_eckd.c
+	if (!strncmp(attr_buff, "3390", 4) || !strncmp(attr_buff, "3380", 4)) {
  		sprintf(pp->product_id,"S/390 DASD ECKD");
  	}

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 4ca4245c..8e052147 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -674,7 +674,8 @@ static struct hwentry default_hw[] = {
  		.no_path_retry = NO_PATH_RETRY_QUEUE,
  	},
  	{
-		/* PAV DASD ECKD */
+		// PAV DASD ECKD
+		// "ECKD devices" enumerated in: libmultipath/discovery.c
  		.vendor        = "IBM",
  		.product       = "S/390 DASD ECKD",
  		.bl_product    = "S/390 DASD ECKD",
@@ -683,16 +684,6 @@ static struct hwentry default_hw[] = {
  		.pgpolicy      = MULTIBUS,
  		.checker_name  = DIRECTIO,
  	},
-	{
-		/* PAV DASD FBA */
-		.vendor        = "IBM",
-		.product       = "S/390 DASD FBA",
-		.bl_product    = "S/390 DASD FBA",
-		.uid_attribute = "ID_UID",
-		.no_path_retry = NO_PATH_RETRY_QUEUE,
-		.pgpolicy      = MULTIBUS,
-		.checker_name  = DIRECTIO,
-	},
  	{
  		/* Power RAID */
  		.vendor        = "IBM",

