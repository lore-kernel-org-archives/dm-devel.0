Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16D8330D4C
	for <dm-devel@lists.linux.dev>; Thu, 20 Nov 2025 12:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763640544; cv=none; b=dj+FT+MyvAsWPZzYM92f0wF4UZQeeq50uOWyQagm3HKSVWhI1LV5XQpmwv6IXhgjwBqVofmKPQIpEjwnULzeN32TPIsb3ktBWQZU0wWrlKg5Wc9Jtkm+5HlSb6yL6ot72MCbasPeCu5V613eADdPmfAbxNiDOI6vxqrXeWRMwIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763640544; c=relaxed/simple;
	bh=seHnSyCooazZojpELWr+OQKHQURWhqUl4F7yf606yN4=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b3pNLzkZBoG0+plLvFY8aE+OwNIjS+XB2l+l9naVyMN1xW9l+PhdR9dSwqiZTPS3pvH8r8RHxUzFgJf0DbYi1wqvqjw/wCSjuR/yjDytojFPAzgU9EyLHKVWuL4TYMQhiuJI04r1oigA0ZMUHD1V4mSUeSI1hDJyWBALTQ4c2lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HY7/t1jH; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HY7/t1jH"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-37a48fc491aso6866201fa.1
        for <dm-devel@lists.linux.dev>; Thu, 20 Nov 2025 04:09:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763640541; x=1764245341; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/g8fBDnEE2On46nmgx0El4PG4kANQXkHhXEGlkgHyMQ=;
        b=HY7/t1jHJ/UHs1w6Ic85fOtkXCjQHh23ccINXDy/gKYXf/FzfVByZIeE/4QE9L1sbk
         ZDaXF5TrCL2N4hkrV+jNnNJBQK22X7+y0LOMPHZuwW9xb5P5Wv028Jos8n59bLDCWR6R
         qrugp/5JTfG5KzfupmnL+q4QlLb7btZ1oO9ux1Hr0H/0xIu9BQ3uLpLsDNHcBv/kRuKI
         Z7IYcv6BIB/VqwxqqO4H1ToCNtsWuddc38GSb7RTKSOX3xSK5B5WFuD/z7Wf3zNWAeXM
         JoKEUt3zj5FRk4sfxepgl+kJsdFQAsz7diZ0Dj4p32u4gKX8f/Y3voCmvuq7oBvv8Jfc
         cSrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763640541; x=1764245341;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/g8fBDnEE2On46nmgx0El4PG4kANQXkHhXEGlkgHyMQ=;
        b=MLFpGR2S8yL3ZNu+WudMZOTMCILjoc3Y0bGMKoHA7uceCZl+xsgDNiCTOTofYrdK3q
         QUy+M6imDc9YjzeL2rskzQI3NFYGBikZRNR3HzrHGWQYI8C0/FgD4ooMFrHBiZaN58QX
         M2wOwZFCRZZY7hbl0IP94LFZjteMT0MPr3h92W/4yJCDtxW/x47Jr5Vjzl+YXhrY64qe
         /57slSXlE2kplUAuYRSE8amfTT7ngHEZB4fKt8LYJ6TJo9aZYT33ZOVk8Xnh9nW3LCiO
         9olDW4CS4sJzdxHuiIhCWfeIKwaCi+63On+tmZJFJBB54y5qcMv4xEMPAIQnB++oBZ6l
         4Cag==
X-Forwarded-Encrypted: i=1; AJvYcCVddHOZeZhugn+9iFl8Y09IAaWthOGnTvi8KWDhIhPNIndNZ6fGACNEtOetKPcUiaKPYOkapUJCiA==@lists.linux.dev
X-Gm-Message-State: AOJu0Ywnj0D/MPNVZheJcFWBhUx41vuAeH9Nsu+r1pY5m9sRxiYT1lUU
	VfEE+Aoo+U75XrEYxC5pco+zj5nMqO+ripql8yhhfhnL6zbgtXx+axPd
X-Gm-Gg: ASbGncubzOsX3HuB+9k/MHhhtkpBwfavjd/PDuFGfCFfh1dYYpgO6otW/BbKHpj5RLJ
	lvYNp74Fgi9HfdiUHp3HQdnEeXwPHVg7pZiJMcYsdaMyoPlVn0ysmUJ5r+DTykjXzTP5kLlqiNE
	NMXtR2Uhl1O7/hGnWXb5RSxr0ZCi9r4sjTm6B6qQfLxz5ZWejno3vQ3l8vU6PkEbDPYTW6n3Ec3
	NaMb4F2GQ9AFSU3l4K9hO+vjR9RQGJeCsn/9Yi3qJUXPp/rDXR9Q8k4VdUV77CXNSgemZ14lFuY
	LlTjbZlHEUor8cEqgfAIPcW+cYnpdWLLW4cZ5L00Dkz2LqliCp0uKJQU3VQU1vn0rNwONmnpjwA
	9xD89w9xO9zQ9ifPpDf93E4RVnmKeJ6n3eFsQ61IpJsKI5UiCXtfI85PR06HCHSOaTnuAv66fyZ
	1KtDdL8a/UiaWHRuP7cv0yMqkOCySgTxurpI9TzQGiMqP+vSqacZs=
X-Google-Smtp-Source: AGHT+IH6oLGUmNcb+t1bqpnM0vD2fk9qo9xK+6M/p0pM/CHJg4xnZXTEiSw1dg9aOFH3t89ZrfUkYQ==
X-Received: by 2002:a05:6512:398b:b0:595:83c6:222a with SMTP id 2adb3069b0e04-5969f234ddfmr690540e87.0.1763640540326;
        Thu, 20 Nov 2025 04:09:00 -0800 (PST)
Received: from pc636 (host-90-233-212-127.mobileonline.telia.com. [90.233.212.127])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5969db89319sm649975e87.36.2025.11.20.04.08.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 04:08:59 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Thu, 20 Nov 2025 13:08:57 +0100
To: Christoph Hellwig <hch@lst.de>, Mikulas Patocka <mpatocka@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Alasdair Kergon <agk@redhat.com>, DMML <dm-devel@lists.linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Snitzer <snitzer@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH] dm-ebs: Mark full buffer dirty even on partial
 write
Message-ID: <aR8E2ZZtOi0RZt06@pc636>
References: <20251117105945.10179-1-urezki@gmail.com>
 <fff990bc-6ff9-7b34-8e80-57078de40928@redhat.com>
 <aRxa1wPMsJwBubjx@pc636>
 <73556fc8-5fbf-37cb-26b9-7cdb88f69720@redhat.com>
 <aRx_lCimJco5BPKA@redhat.com>
 <230baa83-cd79-f232-5fb8-1476115e1ae7@redhat.com>
 <20251119054635.GB19993@lst.de>
 <bcd929c2-88b0-36e9-0e22-4bb0293300b5@redhat.com>
 <20251120062146.GA29990@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251120062146.GA29990@lst.de>

On Thu, Nov 20, 2025 at 07:21:46AM +0100, Christoph Hellwig wrote:
> On Wed, Nov 19, 2025 at 06:26:13PM +0100, Mikulas Patocka wrote:
> > 
> > 
> > On Wed, 19 Nov 2025, Christoph Hellwig wrote:
> > 
> > > On Tue, Nov 18, 2025 at 06:21:56PM +0100, Mikulas Patocka wrote:
> > > > OK - I accepted Uladzislau's patch. As logical block size and physical 
> > > > block size seem to be unreliable, it's better to set the size in dm-ebs.
> > > 
> > > logical and physical block size are reliable.  Uladzislau just seems
> > > to have a completely broken device that needs fixing, because it will
> > 
> > He created a qemu-emulated NVMe device with physical and logical block 
> > size 8192 in a virtual machine. And logical block size was reported as 512 
> > in the guest kernel - so it is either a qemu bug or a kernel bug.
> 
> No, that's not the case.  If you use his command line you'll see a qemu
> device with 8192 logical blocks assuming you have support for large
> folios, or a completely unusuable device that claims to have 512
> byte blocks for compatibility, but also a capacity of zero so that no
> one can use it for anything but passthrough.
> 
> > in nvme_update_disk_info there is this piece of code:
> >         if (blk_validate_block_size(bs)) {
> >                 bs = (1 << 9);
> >                 valid = false;
> >         }
> 
> Yes, that's what I mentioned above.  The valid=false sets the capacity
> to zero, so you're not actually going to be able to use this device.
> 
> > So, the valid block size depends on whether CONFIG_TRANSPARENT_HUGEPAGE is 
> > defined, which is quite weird.
> 
> And also the page size, and none of that is too weird.  You need support
> efficiently allocating large order folios to support a
> block size > PAGE_SIZE and currently CONFIG_TRANSPARENT_HUGEPAGE is
> the guard for that.  There was some talk of lifting that, but that
> requires a bit of work.
> 
Could you please check below? Is the last one is correctly reported?
I have enabled the CONFIG_TRANSPARENT_HUGEPAGE option. If i specify,
8192, 8192 first case, reports are what i set. Second variant 512, 8129
shows 512, 512:

CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD=y
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
# CONFIG_TRANSPARENT_HUGEPAGE_NEVER is not set

-device nvme,drive=drv0,serial=foo,logical_block_size=8192,physical_block_size=8192
urezki@pc638:~$ sudo nvme list
Node                  Generic               SN                   Model                                    Namespace Usage                      Format           FW Rev
--------------------- --------------------- -------------------- ---------------------------------------- --------- -------------------------- ---------------- --------
/dev/nvme0n1          /dev/ng0n1            foo                  QEMU NVMe Ctrl                           1           8.49  GB /   8.49  GB      8 KiB +  0 B   10.0.6
urezki@pc638:~$ sudo cat /sys/block/nvme0n1/queue/logical_block_size
8192
urezki@pc638:~$ sudo cat /sys/block/nvme0n1/queue/physical_block_size
8192
urezki@pc638:~$


-device nvme,drive=drv0,serial=foo,logical_block_size=512,physical_block_size=8192
urezki@pc638:~$ sudo nvme list
Node                  Generic               SN                   Model                                    Namespace Usage                      Format           FW Rev
--------------------- --------------------- -------------------- ---------------------------------------- --------- -------------------------- ---------------- --------
/dev/nvme0n1          /dev/ng0n1            foo                  QEMU NVMe Ctrl                           1           8.49  GB /   8.49  GB    512   B +  0 B   10.0.6
urezki@pc638:~$ sudo cat /sys/block/nvme0n1/queue/physical_block_size
512
urezki@pc638:~$ sudo cat /sys/block/nvme0n1/queue/logical_block_size
512
urezki@pc638:~$

Is that what should be reported?

--
Uladzislau Rezki
