Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=38.49.217.67
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793615597;
	b=ij0BqB0lQet5UqsMXy/d4f1qMkgH0E5/Cp5iACJ3IRDE45WXVbZPaUE41b4yw5iv8jsK
	 5nUWpZShIybldgzZv7XRs6pSwrlH6OJkrdTvBYXBEdKgIy410P7eP9oT/VVpn2pyEdxZl
	 YD5HU8ZFXI+/GUhr0YbBu2PY/EDkN08tkymsxLeCNW8aloQo/OZEz7a4QqUf+7SSQhkMh
	 jG6bNLJ8YPbmNdONx2NpOJMSdW1zU84I6J5OYr0LtiygC2Vj+qzU4tmUiERb82o+LoNpc
	 1bBvF7jmm2mIzESPiiPtkbqN1FBO7hXjrhb4HDqei01zrP7jXFSbefiV8yDhLBfUQuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793615597;
	h=DMARC-Filter:Received:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=7GHnp0Ln26pXroB5EN9akN6HJtbdI7mGZ+evFoOBpkw=;
	b=zLTHcjq1WMQy3jwRkOr6rFSGcYMjboUqf4JDXK/G2C0xnBpOgFrMzARQ5MCAGG/y+k0u
	 hNxagXPHA+Drc1VWmc0iBzpA2jP3S3e/zqppwDeoM2DfH5TPEXljfau0ZyfW4DLSLe9JJ
	 oes07i9A+BljcQDQfvZPXrI61pNbXziK30Epl/kfCQL/waPQQoRFfPYE20yueogmZbIiX
	 mDa6v8JJ5LfD3PwRIEF4kLSfjvlTyX4XbicZ5hS2Fa132wu6oNhxftUakPPgAt1tZY9R9
	 fPYAC6YPac4SE5yH3lq38EGBsVQks+9dYWy05rH7+8fwQv3px+j9nsL8GkFskQdpvgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=stuffedcow.net;
	spf=pass smtp.mailfrom=stuffedcow.net;
	arc=none smtp.remote-ip=38.49.217.67
Received: from mail.stuffedcow.net (mail.stuffedcow.net [38.49.217.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15411606A326
	for <dm-devel@lists.linux.dev>; Mon,  2 Nov 2026 10:33:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 15411606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stuffedcow.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stuffedcow.net
Received: from [192.168.1.227] (henry2.or.stuffedcow.lan [192.168.1.227])
	by mail.stuffedcow.net (Postfix) with ESMTPS id 27E101E0E9D;
	Mon, 02 Nov 2026 05:33:09 -0500 (EST)
Message-ID: <3bcb6abf-3e9a-48b8-b945-3c382225777f@stuffedcow.net>
Date: Mon, 2 Nov 2026 03:33:08 -0700
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] dm-writecache: Add evict_clean_blocks option to allow
 read hits on clean blocks
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev
References: <20260907214648.3691695-1-henry@stuffedcow.net>
 <20260907214648.3691695-3-henry@stuffedcow.net>
 <925889dd-c3ed-db47-48bb-a0b347752c09@redhat.com>
 <7e9b1afd-2249-4303-81c5-758f26e8f83e@stuffedcow.net>
 <a628dc70-e9de-a638-5207-37afd0a00493@redhat.com>
Content-Language: en-US
From: Henry Wong <henry@stuffedcow.net>
Autocrypt: addr=henry@stuffedcow.net; keydata=
 xsDiBDyw+LERBADQGmfmlRCtvrFCJqoIixgXdxK6I1g8RjRE3Vf/MCnvlOZn889OEMPNA48o
 LewyFZU3f+NNlFzpQqYepTk0GGYsxPQhnVfZ0qzF6bOyrQkFIbhhpvCvftHt1K1QcIhCZ6Sb
 q9s92ZXfFkCGdJLN783BzYwtNDy/x3gGZ2pHKkWPXwCgjml41RYFFyyEifqpacf4s8crmtsD
 /3ka3LPq5NB5oT5cD4NYse2rHHaGP9BODtqZhs+W9DuIU78HqDvlNo+b/hG5QX7UK4j2at1B
 vtFdyiGw9zjxPd32NU9KUtUhbtI5ac2AoCKlBPRfA003L2J81zXGjCj9HO7aP4iiZdwn8ges
 mGtxkiigal1m7d24tP1NrmP2xoPMA/9iQDVchzhmQBcjqoOCXK5cARY470l5CJFiqq+sN2TP
 NgO+VDu5/cguBaUHkMve9dRFSwTyVXpeofKU5GbITytMkoaGdo/rc6GCjpkC+7UCQsVevtRp
 Oc/TmBX/NDg+SdFHLxGcajXnclDTId0LYFZ32PyroWl5fk6l23StYkIxd80hSGVucnkgV29u
 ZyA8aGVucnlAc3R1ZmZlZGNvdy5uZXQ+wmAEExECACAFAkRRoTYCGyMGCwkIBwMCBBUCCAME
 FgIDAQIeAQIXgAAKCRDggFhX/oERHltuAJwJ2llnZZ+jzQpppde81UAhXTJsGgCfexR/Htt9
 Fyp7tbBLkRAhfnM/VrHOwM0EPLD4tRAGALY8zOpJVbbMzhkwk7pRlieMzG4ZLHhE0UPGTFEZ
 9K4llYBC7lj523eAbTKyB8MUpMtX4Q6MNZV0rs4E1ByEPitHp8PhXwj0Gwd3gdf5qLW5Ggup
 RY+iPLufFNxPkDjrQJSMjq+nj+6ZATKA2LVYn0iv9m+/gF3mKty2qhJdpFbuXcTNAoSw6l1c
 P5J4br1zxO7++8hUNTAD0mIbdK5cP7gEzHcCHvHGi0j80xeYYFNvu/FVmArLmbZPmQUY/XAf
 IwADBgYApsh7FdCJqDiHmGwODsY0qpy9Wur3zC/KQXKPuuQ36aPE73f6sJRQDkCzv1bU2Hc6
 k/Pwb6mGThE5A5NG+Ft2Flwbmwb9yOo6tP4YDzq5c6jbjjb4ymA67RWLeRGrmsAbHqDrmfu1
 6+FkBlCk6mBzXM+qSVo0H3PNN+90v/I/Tsen4gWDoD1PIvuo4DuT+l+cWDY4HJUAir/ZYVUP
 RMU1yRspuvIzOaWukpfYjavPGPsDpzDQkX5Ioz3ROd6GHgivwkYEGBECAAYFAjyw+LUACgkQ
 4IBYV/6BER4rhQCfQEzoel5eixQGxa6O+fvhQyxR7McAmgOiYl7s1Y1u3Wld/L2J7WQHTuLi
In-Reply-To: <a628dc70-e9de-a638-5207-37afd0a00493@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/2/26 06:03, Mikulas Patocka wrote:
>
> On Mon, 21 Sep 2026, Henry Wong wrote:
>
>> Hi Mikulas,
>>
>> I understand that the original motivation for dm-writecache is for use as a
>> write buffer to absorb write bursts quickly onto non-volatile storage, and I
>> think there was an implicit assumption that the size of the dm-writecache
>> doesn't tend exceed the page cache size. In this scenario, recently-written
>> data will indeed still be in the page cache and there isn't a need for
>> dm-writecache to serve reads.
>>
>> My use case is a system with small RAM (~32 GB) with huge dm-writecache
>> (~1TB). Here, "recently-written" means within the last few days, and the
>> writecache is so big that "recently-written" data won't fit in the page cache.
>> It's intended to target the usage pattern of "New data is written to disk,
>> manipulated a few times over a few days, and then archived". A huge
>> dm-writecache basically lets me keep the last few days of work cached.
>>
>> It's possible to achieve this effect by setting the watermark levels high and
>> keeping the cache dirty. But keeping the cache dirty for multiple days
>> increases the risk of data loss, and setting the watermark levels high reduces
>> the ability to absorb a large write burst if it happens. Having a "clean"
>> state allows cleaning the cache quickly while still having the "last 3 days of
>> work are probably cached" behaviour.
> Hi
>
> I started to test and review your patch and it crashes immediatelly in the
> persistent-memory mode.
>
> [  755.171158] kernel BUG at drivers/md/dm-writecache.c:2138!
> BUG_ON(g->state != WC_VALID_DIRTY)
>
>
> Also, there's a minor bug - these two lines should be added to
> writecache_status, so that the arg counter is consistent with the number
> of args.
>                  if (!wc->evict_clean_blocks)
>                          extra_args += 2;
>
>
>
> Please, test and fix the pmem mode:
>
> download the current device mapper tree from:
>
> git clone git://git.kernel.org:/pub/scm/linux/kernel/git/device-mapper/linux-dm.git
> git checkout remotes/origin/for-next
>
> (note that this repository contains important fixes for the dm-writecache
> persistent memory mode, persistent memory mode doesn't work in the
> upstream kernel).
>
> enable the persistent memory mode in the kernel config:
> In Device drivers, select
> 	NVDIMM (Non-Volatile Memory Device) Support
> 	DAX: direct access to differentiated memory
> In Processor type and features, select
> 	Support non-standard NVDIMMs and ADR protected memory
>
> Add the argument "memmap" to the kernel command line, for example
> "memmap=1G!4G" - this creates an emulated persistent memory device with
> the size "1GiB" at address "4GiB" (you must have more than 5GiB of
> memory). This persistent memory device will obviously lose data on power
> failure, but it's good for testing if you don't have real persistent
> memory.
>
> After reboot, you should see a device /dev/pmem0 that should have 1GiB
> size.
>
> Download the "fsx" filesystem stress-testing tool.
>
> Try these commands, they trigger the BUG:
> # modprobe brd rd_size=524288
> # dmsetup create lin1 <<EOF
> 0 1048576 linear /dev/ram0 0
> 1048576 1048576 linear /dev/ram1 0
> 2097152 1048576 linear /dev/ram2 0
> EOF
> # dd if=/dev/zero of=/dev/pmem0 bs=4k count=1 oflag=direct
> # dmsetup create wb --table "0 3145728 writecache p /dev/mapper/lin1 /dev/pmem0 1024 0"
> # mkfs.ext4 -b 1024 -E orphan_file_size=524288 /dev/mapper/wb
> # sleep 1
> # dmsetup remove wb
> # dmsetup create wb --table "0 3145728 writecache p /dev/mapper/lin1 /dev/pmem0 1024 4 autocommit_time 2 evict_clean_blocks 0"
> # fsck.ext4 -fn -C0 /dev/mapper/wb
> # mount -t ext4 /dev/mapper/wb /mnt/test
> # truncate -s 1400001536 /mnt/test/file
> # fsx -Z -r 1024 -w 1024 -R -W -l 1400001536 -L /mnt/test/file
>
> Mikulas
>

Hi Mikulas,

Thanks for the detailed instructions on how to test with persistent 
memory mode. I think I managed to get the linux-dm/for-next kernel built 
and using writecache in pmem mode.

Agreed that missing the "extra_args += 2" is a bug. Will fix in the next 
version of the patch.

Was there any significance in using a dm-linear device of three ramdisks 
as the origin volume? I think I built `brd` not as a module, so couldn't 
create ramdisks with rd_size=524288. I just used an image file and 
losetup to create a /dev/loop0 as the origin volume, thinking there's no 
relevant difference...

I haven't been able to reproduce the "BUG at 
drivers/md/dm-writecache.c:2138" despite letting fsx run for hours... I 
changed the testing method slightly: I used /dev/loop0 instead of three 
ramdisks, and 8 GiB of fake-pmem instead of 1GiB. Is there something 
significant I'm missing about the about test? (For example, is this only 
triggered for certain relative sizes of the origin device, cache size, 
and fsx's test file size?)


