Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE9C35C69F
	for <dm-devel@lists.linux.dev>; Fri, 24 Jul 2026 04:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784866586; cv=none; b=e+zudxQnosmyDBv7iPgSETtGg9hhcPYwwTihcbpMxFL8PbUH/g8NBrsAfPX4DUJHeUVX2qq+magEY3+Fxst3TLUwenvuDvZNUQJukhcJr+0lialeB7TvdCBq0kX3ekxslOR+ftaV4KEKFuGyDIhWgPl//wnekK3li6bxGu0alic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784866586; c=relaxed/simple;
	bh=D8nsJm6OgKCvo7xqHdQY9wPmVPfsoKAXxMMIwjv8Bmw=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To; b=kP5axy7eDsu5OZzi0/wpNtJrFxx+HzWJF5sk1pI2EqhnU5uOSYQ6gujcyDN6ibrEmDlldlGvLjIQ+7KmVtmICEPFmmr8qpM1D659NT2O6HNzAAjY4KMxfE/o817YW11kg7orh4LRP6i/5kAbrU4ACLQGHqfPb/CgTUBeVa91t7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RVLLK2iW; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RVLLK2iW"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2ccae46de39so18055ad.3
        for <dm-devel@lists.linux.dev>; Thu, 23 Jul 2026 21:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784866572; x=1785471372; darn=lists.linux.dev;
        h=in-reply-to:from:content-language:references:cc:to:subject
         :user-agent:mime-version:date:message-id:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=s5kn9KtHFPPj32yH+JbPhxfy5+S45WvNPYXOXrfI6TQ=;
        b=RVLLK2iWKB/QZSDapzHdvuvl35SazJvcnGlp52eO9Piwk3f+qwUIGDmyYbKIBxS9Pp
         FFWbta3iUpv8NbFt8AJ3L6iNHgFh+SqxXgnXl1G8JtmqvHBqrCKz0xeXwa/tQUjvbjWl
         aEY35iJKUuhrCrBq7QEyFlm5lYz+ngt1myaoXZ1srf4iwe6YSviMBl05W2gf/Qsy2aQr
         s3eP1DisLFYlu95scYg1o5E/5ey1WXgXnpRtg3TxpTqoCslXywFvTQSLd0npXmH1Gp2Y
         qSsgXU1B+7R50c2PckU+Sf28CtwkQDtwq0p21dbzxR7tQVnhf3yJ88ybCZJztQnLa3GR
         6IyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784866572; x=1785471372;
        h=in-reply-to:from:content-language:references:cc:to:subject
         :user-agent:mime-version:date:message-id:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=s5kn9KtHFPPj32yH+JbPhxfy5+S45WvNPYXOXrfI6TQ=;
        b=Fvhmx6WxuWKujlu55rEDg+nskuTAWwzeB1l5CTBC8UQzJHuyTTa4cI6LV0YdaJjbky
         vJefJBCOUM/kLgBBq4PafEstTK8SU68vWC1bKHXW1rska84a1TcxVqSXo6844y2SoF3L
         bQEFyDPGWnHHuT88rIOfU1uwBgolvGbv5r8Tynmu19nC1SEYLTPJ05eB43qZrAi3HnX1
         gRM3E207huwxqDgDPgA89l+P4+YVIC6QldNdYYwYGc3DyDbKCmn+bjI6N301Uols860X
         Eyfwq4xpZH7LHrOVhThUPaWRQ3CNRkYoYMa25yKzIOeVOj2ZUfY42lHCfSJXyBoNOCQ0
         B6jQ==
X-Forwarded-Encrypted: i=1; AHgh+RrMdcywHtmrhxYCA/yQccx0orzXk8j/jfdzQf9Qs/9cRF4526WaMcSKJymTpBbSWc6aexGbmZXlxQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YzYSGttLMOea6q0Hw2GMiAxYbzNQaFVMB9pmRnyuSDwZTsMDNPS
	aQ1cBqaq5HnBsaUOUJUfJ9mS+rhW4xjZt6IG13ZlKzrxmST/EBBczpkZ
X-Gm-Gg: AR+sD10dzH6ktRA1ZtS+Od5tn90ZpKndAKBTjvDO/cv2Vbu8aNtuNFTGy98STIwsfOb
	Hg7fha3u1y+GU5hQdcBrnHqnV3Brxw60SEJiD2svvgi96qboqEu6P3Q2Y6XNC1JQXQTMJzZVZbw
	xeB7AtzTqJmsUbhZDqvsUAAJPOaD/5UfkkwFuz8xKSQVsmwpBjIBxVfzl4+j/9YbvdPFWDr3cBE
	vqfxxJJG1AL8ZDgmg5MywxaxwAfD6o4OOD0fIm/j0tbuU4ziyImL8SQvOT03j3/mGpbyNVhKbEi
	/fl1esteYLeCKsXEMv4rC98ZBLmskozNNMXyIZM2013AtzO6hdI3glKgKZaanlWjrlvN6rgEWUc
	gHfmm2Ur8kpmZI5aOS5W3Z78Bv6tmnxbBvsTRT1rDrcTRlEZTDXSV6LW7N/d4CTA7PpI9pJMzt8
	zOhKwGwQ/flP7B0vXT
X-Received: by 2002:a17:903:2f44:b0:2cf:7dfa:7f56 with SMTP id d9443c01a7336-2cfbc9ff7ffmr21322805ad.2.1784866571463;
        Thu, 23 Jul 2026 21:16:11 -0700 (PDT)
Received: from [10.70.111.138] ([202.189.104.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf8efd7157sm44135835ad.18.2026.07.23.21.16.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2026 21:16:10 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------OD38yxW8i2BIPWzedjSF73z0"
Message-ID: <fdd054ac-d073-42c6-a19d-493acc934a29@gmail.com>
Date: Fri, 24 Jul 2026 12:16:07 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] dm: dm_setup_md_queue UAF walking table_devices without
 lock
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <snitzer@kernel.org>,
 Benjamin Marzinski <bmarzins@redhat.com>, Alasdair Kergon <agk@redhat.com>,
 dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <5947c25a-0a1e-4bb2-ad3e-8e4d9ecbd8c2@gmail.com>
 <2f28baa4-d328-1a06-8a86-a7814cb2955b@redhat.com>
Content-Language: en-US
From: Junzhe Yu <junzheyu1@gmail.com>
In-Reply-To: <2f28baa4-d328-1a06-8a86-a7814cb2955b@redhat.com>

This is a multi-part message in MIME format.
--------------OD38yxW8i2BIPWzedjSF73z0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Mikulas,

Thanks for the suggested fix. We verified it on Linux 6.6.144 with KASAN
against our minimized PoC (concurrent DM_TABLE_LOAD racing
dm_setup_md_queue's unlocked table_devices walk).

Results:
   - unpatched: KASAN slab-use-after-free in dm_setup_md_queue (often with
     a follow-on fault around bd_link_disk_holder)
   - with your change (extend table_devices_lock over the list walk):
     no KASAN UAF for a 5-minute PoC window

Self-contained test package (patch + poc.c + A/B scripts + captured logs):

   dm-setup-md-queue-patch-test.tar.gz

Re-run with Docker (see README.md inside the tarball):

   docker build -t dm-setup-md-queue-patch-test -f Dockerfile .
   mkdir -p artifacts
   docker run --rm --privileged --device=/dev/kvm --network=host \
     -v "$PWD/artifacts:/artifacts" -e OUTPUT_DIR=/artifacts \
     dm-setup-md-queue-patch-test

Happy to test follow-ups if needed.

Thanks,
Junzhe

On 7/24/2026 4:23 AM, Mikulas Patocka wrote:
>
> On Sat, 18 Jul 2026, Junzhe Yu wrote:
>
>> Hello,
>>
>> I am reporting a KASAN slab use-after-free in the device-mapper core in
>> dm_setup_md_queue().
>>
>> Summary
>> =======
>>
>> dm_setup_md_queue() walks md->table_devices without holding
>> md->table_devices_lock while a concurrent failed DM_TABLE_LOAD frees a
>> table_device via dm_table_destroy() -> close_table_device(). The crash
>> shows as a KASAN UAF on the list walk, and often a follow-on page fault
>> in bd_link_disk_holder().
> Hi
>
> Does this patch fix it?
>
> Mikulas
>
>
>
> dm: fix race when loading and unloading a table
>
> If the userspace calls two concurrent table load ioctls and one of them
> succeeds and the other fails, there is a race condition because
> dm_setup_md_queue walks &md->table_devices without any lock. If the walk
> races with dm_table_destroy -> free_devices -> dm_put_table_device, there
> is access to invalid memory.
>
> Fix this race by extending the lock over the list walk.
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org
>
> ---
>   drivers/md/dm.c |   12 ++++++++----
>   1 file changed, 8 insertions(+), 4 deletions(-)
>
> Index: linux-2.6/drivers/md/dm.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm.c	2026-07-23 14:13:37.000000000 +0200
> +++ linux-2.6/drivers/md/dm.c	2026-07-23 18:43:19.000000000 +0200
> @@ -2630,9 +2630,10 @@ int dm_setup_md_queue(struct mapped_devi
>   	 */
>   	mutex_lock(&md->table_devices_lock);
>   	r = add_disk(md->disk);
> -	mutex_unlock(&md->table_devices_lock);
> -	if (r)
> +	if (r) {
> +		mutex_unlock(&md->table_devices_lock);
>   		return r;
> +	}
>   
>   	/*
>   	 * Register the holder relationship for devices added before the disk
> @@ -2643,18 +2644,21 @@ int dm_setup_md_queue(struct mapped_devi
>   		if (r)
>   			goto out_undo_holders;
>   	}
> +	mutex_unlock(&md->table_devices_lock);
>   
>   	r = dm_sysfs_init(md);
>   	if (r)
> -		goto out_undo_holders;
> +		goto lock_out_undo_holders;
>   
>   	md->type = type;
> +
>   	return 0;
>   
> +lock_out_undo_holders:
> +	mutex_lock(&md->table_devices_lock);
>   out_undo_holders:
>   	list_for_each_entry_continue_reverse(td, &md->table_devices, list)
>   		bd_unlink_disk_holder(td->dm_dev.bdev, md->disk);
> -	mutex_lock(&md->table_devices_lock);
>   	del_gendisk(md->disk);
>   	mutex_unlock(&md->table_devices_lock);
>   	return r;
>
--------------OD38yxW8i2BIPWzedjSF73z0
Content-Type: application/x-gzip; name="dm-setup-md-queue-patch-test.tar.gz"
Content-Disposition: attachment;
 filename="dm-setup-md-queue-patch-test.tar.gz"
Content-Transfer-Encoding: base64

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
+QDwAAA=

--------------OD38yxW8i2BIPWzedjSF73z0--
