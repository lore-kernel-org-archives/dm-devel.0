Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496982EBB96
	for <dm-devel@lists.linux.dev>; Wed, 29 Oct 2025 13:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761743198; cv=none; b=NfSbCn4z4JopskW+xZb+ObnB7hmlA7Lnma6PaoPjov3qj6+d4+4j2vQtQPk1IKydCS/D+uPBd9nqljK71mjY01/GNB0MsL2igGdXTzQ8kZyqwHRzC6Nt+cdmal+kLg1/SdbzZX04thN7+lTFa4RAGDwt7ICQknVSGscQAdd3T+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761743198; c=relaxed/simple;
	bh=RsaO7VAXwouvy9HZ/OEuTxB0IDJRQxCRWcTIffwfEE4=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZYUZzSgb1zy7C62YcERBBiTxtYIGJPlVECbtZ/8TlE2HUTrPuoHL08RuBq3dTEpUxxPc7hGddaiNJLfj9OsoKKV82b/UQbzPIm0zN1X0QEZmcagGNcNCBECi8Pu34elrQnhAfzC/5U/fZyQcTVIpbIlRBKikxOaQqkT8ZE9hpiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dZH37Gcc; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dZH37Gcc"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-375eff817a3so76109411fa.1
        for <dm-devel@lists.linux.dev>; Wed, 29 Oct 2025 06:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761743194; x=1762347994; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=b7OF/YjgS2U029gez5iQZAa3hsUdBSYG5emzqmsuSEY=;
        b=dZH37GccnqkFCTySSrL9/hReXvzxnnH7hyDd6+PeWUuaPS2hOiQlZPhUSERvNxIcUY
         EO2+mi412PhXLL8cJL5FQ/Fnibb9PYU+d1RwnWm0ztvLc66VyDtn4pPU+aZk7E+iJlS0
         Rqt694QoatUo3ug+nwyxLDAIljYQfAnGz8wWAlygKHz7aTr7Be4qkancirVx55TDcn19
         uv7viiULZA1/le5wWmkU7yvgy4X06Tls/yz3sevQ9K6LV4aDatbuvnq8ZoiuHfVaNcEC
         pjX84ZRN8N16OqHzi8YwewSApN/0i1BDccoEgnSVxu7lYHUOtXJvcwKjMA3sqbP2VRyT
         JQ3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761743194; x=1762347994;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b7OF/YjgS2U029gez5iQZAa3hsUdBSYG5emzqmsuSEY=;
        b=WfHkjSQLIav17n4DzZfziBwsE6OPscxH5q5bMk6b18Cl4fQ9yF6BJVGxO+zrVeFY2S
         ZlWdblZTN06BpwJoxk3FrYALP8yABOZKnI8CvOjx8R4uggjdBJoMvhy30qA3Cz+GEM0T
         f4mmwVLj+MaMirt2ne6pqu8l90CQ3ZX+kUsD25bTFjLfMtFKqXkiRf0FIKLehaiYjJgm
         a6T/NZn4oM6+S/KsCBgnRBka/EUXBam1V6iBu6Fo1pK5H7vUneVv0Hi1xuh0YCaiiTWf
         9JLKOhi6o3hz0O8MnVJ41espm7O/j8AqZXeS/G9QJU2KZK8r1KAXcHJ8fCPSt7J4GpEv
         hlvw==
X-Forwarded-Encrypted: i=1; AJvYcCUECzw70bZ3SW23h/xGVD7Jv2XjO6PfI2UfcnGROk+n4eRq4r8UhQrRi6T5sI5SJRChevBWxwWGKg==@lists.linux.dev
X-Gm-Message-State: AOJu0YzLdpf1Cbmhw8NZSHaQy42odErnwFwoBFWXlId2utV2VSjqW+//
	9bxYMnTcvvbRa4n167juXrl9vtIeaO5ofoEsD+QyiZ6GMRhh116RZg8D
X-Gm-Gg: ASbGncufvHUiWoACD3dXlNrx2Z8x3FDTO9XmMvkjiohgKevcYjKgJMYSuassAyKjlG5
	ipkHU3XMp0IGewsTkR09B+KsfwCRFaPLIMDlvEmRtRuV0uHR9hQgE7My5kzhyJwyUey9iE0xjRX
	GoixhiVRCQ2tmliUdOpuZ6Q0ZBHTuCQJ6s0TQ4bTZLe1lblcjgOUNUP7eXK1OzeWHuLX46/V6m7
	R9JIe+/jKs40uO8eIi6btJ3W/W9krYAbNi+T04+kwdKRg8Yr8j8fL2nnBvb1KdA8dLJ5h2Wq/ui
	+PECB/CsM652uhPE4nxIESQrktYGWbcZcrWRNdSRnKooN8cMii2jySA6rJxsfHg9sMaDLlm73HU
	KpKvIgDH1LF5R+THstPU3bx1jWs+eV+TtyFcCHZJ8iZIidiDykhokz573BticZJIpO3PwzS5abT
	dZ4RF5vWHnSpHNw5cXDr0lAwMCiW4FXA==
X-Google-Smtp-Source: AGHT+IHn+iYM86fiNMcTAPtAf73qE9hUkHMk/9Lv5hKb1jLvbDo9mpK9c5Zeb2tsc98bHx7EZd3nVg==
X-Received: by 2002:a05:6512:baa:b0:592:f359:ff2b with SMTP id 2adb3069b0e04-594128c0913mr894714e87.41.1761743193988;
        Wed, 29 Oct 2025 06:06:33 -0700 (PDT)
Received: from pc636 (host-90-233-197-228.mobileonline.telia.com. [90.233.197.228])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59306b2de0fsm3024869e87.7.2025.10.29.06.06.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 06:06:33 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Wed, 29 Oct 2025 14:06:31 +0100
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Uladzislau Rezki <urezki@gmail.com>, Alasdair Kergon <agk@redhat.com>,
	DMML <dm-devel@lists.linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dm-bufio: align write boundary on bdev_logical_block_size
Message-ID: <aQIRV51yLQzOwJvB@pc636>
References: <20251020123350.2671495-1-urezki@gmail.com>
 <cdb598ce-88ec-0c3c-8e4b-b557093bea92@redhat.com>
 <aQCDLBie3fGwMDW2@milan>
 <aQDCmAPfpIGZiceo@milan>
 <b791d8e8-5e30-b50c-04ca-e823c0a06747@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b791d8e8-5e30-b50c-04ca-e823c0a06747@redhat.com>

On Wed, Oct 29, 2025 at 11:24:25AM +0100, Mikulas Patocka wrote:
> 
> 
> On Tue, 28 Oct 2025, Uladzislau Rezki wrote:
> 
> > On Tue, Oct 28, 2025 at 09:47:40AM +0100, Uladzislau Rezki wrote:
> > > Hello!
> > > 
> > > Sorry i have missed you email for unknown reason to me. It is
> > > probably because you answered to email with different subject
> > > i sent initially.
> > > 
> > > > 
> > > > On Mon, 20 Oct 2025, Uladzislau Rezki (Sony) wrote:
> > > > 
> > > > > When performing a read-modify-write(RMW) operation, any modification
> > > > > to a buffered block must cause the entire buffer to be marked dirty.
> > > > > 
> > > > > Marking only a subrange as dirty is incorrect because the underlying
> > > > > device block size(ubs) defines the minimum read/write granularity. A
> > > > > lower device can perform I/O only on regions which are fully aligned
> > > > > and sized to ubs.
> > > > 
> > > > Hi
> > > > 
> > > > I think it would be better to fix this in dm-bufio, so that other dm-bufio 
> > > > users would also benefit from the fix. Please try this patch - does it fix 
> > > > it?
> > > > 
> > > If it solves what i describe i do not mind :)
> > > 
> > > > 
> > > > 
> > > > From: Mikulas Patocka <mpatocka@redhat.com>
> > > > 
> > > > There may be devices with logical block size larger than 4k. Fix
> > > > dm-bufio, so that it will align I/O on logical block size. This commit
> > > > fixes I/O errors on the dm-ebs target on the top of emulated nvme device
> > > > with 8k logical block size created with qemu parameters:
> > > > 
> > > > -device nvme,drive=drv0,serial=foo,logical_block_size=8192,physical_block_size=8192
> > > > 
> > > > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > > > Cc: stable@vger.kernel.org
> > > > 
> > > > ---
> > > >  drivers/md/dm-bufio.c |    9 +++++----
> > > >  1 file changed, 5 insertions(+), 4 deletions(-)
> > > > 
> > > > Index: linux-2.6/drivers/md/dm-bufio.c
> > > > ===================================================================
> > > > --- linux-2.6.orig/drivers/md/dm-bufio.c	2025-10-13 21:42:47.000000000 +0200
> > > > +++ linux-2.6/drivers/md/dm-bufio.c	2025-10-20 14:40:32.000000000 +0200
> > > > @@ -1374,7 +1374,7 @@ static void submit_io(struct dm_buffer *
> > > >  {
> > > >  	unsigned int n_sectors;
> > > >  	sector_t sector;
> > > > -	unsigned int offset, end;
> > > > +	unsigned int offset, end, align;
> > > >  
> > > >  	b->end_io = end_io;
> > > >  
> > > > @@ -1388,9 +1388,10 @@ static void submit_io(struct dm_buffer *
> > > >  			b->c->write_callback(b);
> > > >  		offset = b->write_start;
> > > >  		end = b->write_end;
> > > > -		offset &= -DM_BUFIO_WRITE_ALIGN;
> > > > -		end += DM_BUFIO_WRITE_ALIGN - 1;
> > > > -		end &= -DM_BUFIO_WRITE_ALIGN;
> > > > +		align = max(DM_BUFIO_WRITE_ALIGN, bdev_logical_block_size(b->c->bdev));
> > >
> > Should it be physical_block_size of device? It is a min_io the device
> > can perform. The point is, a user sets "ubs" size which should correspond
> > to the smallest I/O the device can write, i.e. physically.
> 
> physical_block_size is unreliable - some SSDs report physical block size 
> 512 bytes, some 4k. Regardless of what they report, all current SSDs have 
> 4k sector size internally and they do slow read-modify-write cycle on 
> requests that are not aligned on 4k boundary.
> 
I see. Some NVMEs have buggy firmwares therefore we have a lot of quicks
flags. I agree there is mess there.
 
The change does not help my project and case. I posted the patch to fix
the dm-ebs as the code offloads partial size instead of ubs size, what
actually a user asking for. When a target is created, the physical_block_size
corresponds to ubs.
 
I really appreciate if you take the fix i posted. Your patch can be
sent out separately.
 
Does it work for you?
 
Thank you!
 
--
Uladzislau Rezki

