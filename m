Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB80337B84
	for <dm-devel@lists.linux.dev>; Thu, 20 Nov 2025 12:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763642439; cv=none; b=fuD4MGXZWGnTxuMM5ECydv35uB0LJOWRcqB0tzuCr0qL7OPH8exLoA+7LNNGUi0Cktb/+iKShVHQOOeiR1ALqqa+GX5JxatHsy5nd8A9M47Jrfx8bZBpFk889i3TUbHROLA8HOzla6B2J7gZglfme5DXWOPILbw1lathpU+COtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763642439; c=relaxed/simple;
	bh=HJ5OfsjGZ9ETLVDt5fQgOFn/ljFMtNgamwgQcYv3XPM=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PQbgJYh71oNIZVJtl0KYzkcoD9pwHH2ebIl41/rLZMxSYVeAqwd6sbYnSXCMR94Wql6/0g6KtQE3Bnd0kTdehUgP+CGtVrKHHhOjYMa56xK2zA+8AS8HTX0xKKg2wajy+zQwLLlG3+FWICabBpvAEN5W3qRC/+2zwrl80PEssgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MphEXE3y; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MphEXE3y"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-37b996f6b28so6693701fa.3
        for <dm-devel@lists.linux.dev>; Thu, 20 Nov 2025 04:40:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763642435; x=1764247235; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Rj43N+4U1YLZGmJlvK9URuZROac32VOsSVNQ3r7b8ZQ=;
        b=MphEXE3y4uQp0nApvhtbY4mO3Agvmu9wTxK6EY9IAshYmw2ihJ2avX6F3gOlTRnddw
         F5IPOlQ0AU/Ewtu6FSqX08eHpQ9Qgmo8tnJMOhh+VHAXff/xsUGdOkVOGvxfVunTzELz
         /0/PVc/6MXfqA3eGQDk8YlvKjaJB43Jw/kLU7dKD+0vnEgZR3jCmxDxmRAFtaw1nfc41
         EZBCB4l3s95Vg1Yzz0ODJMP42+73h7iiMVoTnk+dxtTdvmfFxwACMeCKbRZOaWeJI6pt
         NVBKUlkM5qnWc0IpfAd2PnSZbgbtEk7wUZMEUMHCWWVh82a1xY15U+gW59oTYkzRGnlb
         TgaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763642435; x=1764247235;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rj43N+4U1YLZGmJlvK9URuZROac32VOsSVNQ3r7b8ZQ=;
        b=JP5OwPf3QBX7Teohm1wPyIFti2WebDGaUo7MdPzyFStm6UZjfOLj3T0HTCwIp9D3GP
         XkfolPmqPp8FUAn7FPh/cxJgck84CUoP/WsXSyVSSMtjMhMURAjfnnH0LRnnDzCwWZFM
         35kQ+6KtLujJ68+8Ht4qII4f8W/zTPncsKGxD2wRVQQxH3+hnEmg9b6LmiqpRjL8HE/I
         mDwkd7b7eEnlx/bdh/6P0qIqoDBntdtD7HX5Md6g0IpLKw7eCOpuBAbsnfijQTXKOC+w
         P/N0k1F4vtkyzYfuxNvdZuSDNvzt5gEl+Sh51xoHnKTkWqLLm3jqIjfC2g/+FiKreBVS
         JJUg==
X-Forwarded-Encrypted: i=1; AJvYcCWMNQ0VbnPzcSqOKa2g1fB75Mo1Expoc8IqGfayohzU5G/o4XxuB5XeKHSNY6hLF32jB1hG0A2qBA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yzgv7MM2CI/vvbGS2+4iIqsUvDzo9tgYNWmK2GAvxcS2TRoR7VZ
	s7Ri2l6BelWkiJV+woPPYm8MZi0XemLhk69YF4usghDkuHfCtrSy4faE
X-Gm-Gg: ASbGnctMKn2SnIDdJ1a9zd46VjKM7rCDWJ7NH9wU8LIOEpHL5R2h3+LvE3YhOMHeoY5
	WTOcdN5kuR+crHLMj0aN64xIu0S64h9wHFDpuUKadJKvDUvYy1+inGa1IYFyGo1ToOzd6dg18tp
	fGtXIC+qu8kUX8FIQKII6D1Ecqi7wubH9PT9nw/YiFin0v/scOyVZhbRO2Wztbprgu5kj+ES+15
	5fQWVPBQonKBjPpXhbTFMBS10CzotFFq5XDv7qTJ0DUHuWutPQRoGU3jYuZ07pV3UPB+o8DNkSh
	cQ86/EWGn9HGdxilws2PYjfY+mIo738nmmCyqBoHvjMf5bxMDY0mXtCc5cqihoStPZE2za9QfdO
	zgJMttcTI557T1rDEGPDAsU5msD2Gdio/ytT4uze/q7mqHCrfVZMAHg/XXegg4LyChSne2Ozp5+
	IkLC02Yv2CMW9D0fhilN8FUdDfhLdHpa19eVPelQti
X-Google-Smtp-Source: AGHT+IHBl6BFzjfisuiTZNzkpedRmFFPCvgI3f9anngAJjJ5eJ+Li9Mx8i1lt0x6h8rHLby/oMwb/A==
X-Received: by 2002:a05:6512:3d8b:b0:595:7e96:a709 with SMTP id 2adb3069b0e04-5969e2d29efmr820562e87.10.1763642434649;
        Thu, 20 Nov 2025 04:40:34 -0800 (PST)
Received: from pc636 (host-90-233-212-127.mobileonline.telia.com. [90.233.212.127])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5969db81b1dsm656473e87.23.2025.11.20.04.40.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 04:40:34 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Thu, 20 Nov 2025 13:40:32 +0100
To: Christoph Hellwig <hch@lst.de>, Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Alasdair Kergon <agk@redhat.com>, DMML <dm-devel@lists.linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Snitzer <snitzer@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH] dm-ebs: Mark full buffer dirty even on partial
 write
Message-ID: <aR8MQOFX0pVldcUT@pc636>
References: <20251117105945.10179-1-urezki@gmail.com>
 <fff990bc-6ff9-7b34-8e80-57078de40928@redhat.com>
 <aRxa1wPMsJwBubjx@pc636>
 <73556fc8-5fbf-37cb-26b9-7cdb88f69720@redhat.com>
 <aRx_lCimJco5BPKA@redhat.com>
 <230baa83-cd79-f232-5fb8-1476115e1ae7@redhat.com>
 <20251119054635.GB19993@lst.de>
 <bcd929c2-88b0-36e9-0e22-4bb0293300b5@redhat.com>
 <20251120062146.GA29990@lst.de>
 <aR8E2ZZtOi0RZt06@pc636>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aR8E2ZZtOi0RZt06@pc636>

On Thu, Nov 20, 2025 at 01:08:57PM +0100, Uladzislau Rezki wrote:
> On Thu, Nov 20, 2025 at 07:21:46AM +0100, Christoph Hellwig wrote:
> > On Wed, Nov 19, 2025 at 06:26:13PM +0100, Mikulas Patocka wrote:
> > > 
> > > 
> > > On Wed, 19 Nov 2025, Christoph Hellwig wrote:
> > > 
> > > > On Tue, Nov 18, 2025 at 06:21:56PM +0100, Mikulas Patocka wrote:
> > > > > OK - I accepted Uladzislau's patch. As logical block size and physical 
> > > > > block size seem to be unreliable, it's better to set the size in dm-ebs.
> > > > 
> > > > logical and physical block size are reliable.  Uladzislau just seems
> > > > to have a completely broken device that needs fixing, because it will
> > > 
> > > He created a qemu-emulated NVMe device with physical and logical block 
> > > size 8192 in a virtual machine. And logical block size was reported as 512 
> > > in the guest kernel - so it is either a qemu bug or a kernel bug.
> > 
> > No, that's not the case.  If you use his command line you'll see a qemu
> > device with 8192 logical blocks assuming you have support for large
> > folios, or a completely unusuable device that claims to have 512
> > byte blocks for compatibility, but also a capacity of zero so that no
> > one can use it for anything but passthrough.
> > 
> > > in nvme_update_disk_info there is this piece of code:
> > >         if (blk_validate_block_size(bs)) {
> > >                 bs = (1 << 9);
> > >                 valid = false;
> > >         }
> > 
> > Yes, that's what I mentioned above.  The valid=false sets the capacity
> > to zero, so you're not actually going to be able to use this device.
> > 
> > > So, the valid block size depends on whether CONFIG_TRANSPARENT_HUGEPAGE is 
> > > defined, which is quite weird.
> > 
> > And also the page size, and none of that is too weird.  You need support
> > efficiently allocating large order folios to support a
> > block size > PAGE_SIZE and currently CONFIG_TRANSPARENT_HUGEPAGE is
> > the guard for that.  There was some talk of lifting that, but that
> > requires a bit of work.
> > 
> Could you please check below? Is the last one is correctly reported?
> I have enabled the CONFIG_TRANSPARENT_HUGEPAGE option. If i specify,
> 8192, 8192 first case, reports are what i set. Second variant 512, 8129
> shows 512, 512:
> 
> CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
> CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD=y
> CONFIG_TRANSPARENT_HUGEPAGE=y
> CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
> # CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
> # CONFIG_TRANSPARENT_HUGEPAGE_NEVER is not set
> 
> -device nvme,drive=drv0,serial=foo,logical_block_size=8192,physical_block_size=8192
> urezki@pc638:~$ sudo nvme list
> Node                  Generic               SN                   Model                                    Namespace Usage                      Format           FW Rev
> --------------------- --------------------- -------------------- ---------------------------------------- --------- -------------------------- ---------------- --------
> /dev/nvme0n1          /dev/ng0n1            foo                  QEMU NVMe Ctrl                           1           8.49  GB /   8.49  GB      8 KiB +  0 B   10.0.6
> urezki@pc638:~$ sudo cat /sys/block/nvme0n1/queue/logical_block_size
> 8192
> urezki@pc638:~$ sudo cat /sys/block/nvme0n1/queue/physical_block_size
> 8192
> urezki@pc638:~$
> 
> 
> -device nvme,drive=drv0,serial=foo,logical_block_size=512,physical_block_size=8192
> urezki@pc638:~$ sudo nvme list
> Node                  Generic               SN                   Model                                    Namespace Usage                      Format           FW Rev
> --------------------- --------------------- -------------------- ---------------------------------------- --------- -------------------------- ---------------- --------
> /dev/nvme0n1          /dev/ng0n1            foo                  QEMU NVMe Ctrl                           1           8.49  GB /   8.49  GB    512   B +  0 B   10.0.6
> urezki@pc638:~$ sudo cat /sys/block/nvme0n1/queue/physical_block_size
> 512
> urezki@pc638:~$ sudo cat /sys/block/nvme0n1/queue/logical_block_size
> 512
> urezki@pc638:~$
> 
It might be that qemu changes this, i will check.

Christoph, but i assume it is valid case: logical=512B, physical=8192K.
Could you please confirm?

Thanks!

--
Uladzislau Rezki
