Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AEC027467D
	for <dm-devel@lists.linux.dev>; Mon, 18 Aug 2025 19:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755546934; cv=none; b=WBxLCI6yplK9hbzlpF3ufLzjsUB47xWt+wuro3YBxzES8GX2J15YGKwcVsm8HgwKjuKOrT5b8PWk+QYzoQEJFyPewcuJsE8yQXqSLuPGmADdHA+1L8N2FhA6vxlGjOqLh9z+dCiOOXFoamW9pZVK143tNAjjWwNa9Z0t60mUa+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755546934; c=relaxed/simple;
	bh=vy+Fefv5RXnll9WB7CFio4GTNTUx7cYOFEB4KgPhMaI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=b1rP0ZcG9XP5nQeLD7eDYVZ6dadbnzh0Vzsd3svToIpHVWhPsOGW8TjJMxZ/oMEjY3aYNEMkrH/dQCGQdFrOvOUe4V7pV9tP/gR+bpGEo2VyrQgbAcl7DBwV1pRlzFPbAYeXuAeJW548clcQkKp0ndZIGpX4i+Bd+doWX4IzYbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QQPe5gB3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QQPe5gB3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755546930;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gDxJ+OBV6n2lHU8elFUtaoKfmidv8wiKGZx7pTpfymw=;
	b=QQPe5gB3Uw728CkClcWRyTLof0D3FnLlMJfASZpB5b7QwKbRqbNjgTP/M5pZTdX8G4GHH+
	88HlxKlspHUITP1YzFeCb2bZUlIpb5A8yhV8agbAQdo4oH+YsBztHYSf26HHo9THuzgmtm
	iTzFjtwEqoJilXiROWV5emRqTeM7/xY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-147-d8FQ8BPLMyKatMdFsUtEJg-1; Mon, 18 Aug 2025 15:55:29 -0400
X-MC-Unique: d8FQ8BPLMyKatMdFsUtEJg-1
X-Mimecast-MFC-AGG-ID: d8FQ8BPLMyKatMdFsUtEJg_1755546928
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b9edf5b346so3504935f8f.3
        for <dm-devel@lists.linux.dev>; Mon, 18 Aug 2025 12:55:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755546927; x=1756151727;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gDxJ+OBV6n2lHU8elFUtaoKfmidv8wiKGZx7pTpfymw=;
        b=qJATfTwsp2es5gJ6vRF9bcUV0xP90kZ1s2Fl4bLMTqjkd5PwOY/Nut9Q7Vt0ToykSs
         eIwlqm9d5gNI/RrsnvomZJlDi0KolqW/9JWA8qCo0eV2u2M5IohyzbmBtAq7Xvl6eS52
         EfuvvCxDbLLYL2G9cknoMgiC8Fk7Ynwlq/ioukhJnkTahlKeK4RXY5RtkNDblvqJOCzh
         tQKgY6TmHrt8FEuIW43EDB72TUjCh+R12jZylZhLhVnGvilocrW3yhLTT7FHEYUJjQga
         Nsyc0RPxuYupbkT/t0Z5g+kTvGO7FP0bpi5jm4tnlUAFtvR0SSSBn+FX6ZW9o2XNPQBj
         xL9w==
X-Gm-Message-State: AOJu0YwCv1BmdBP5f+IPjV+el0kNKgB4rXpJIMldaxmpuCa3kQyTSQxm
	H1h2r2fVS0xTdlMIxHVku4VDdv/rh6Igcm/2Z7ZCwAEakWAiPLAAxtt+Hnj1CU4qjUFQsHnXw6T
	AT5iy30XUHnmIvxBjTrVgWJ6xqjKfVIpW3okoP+fs+SppPSixh53sFiQzYNNn/N/DmFmA
X-Gm-Gg: ASbGncvhwa1HpvBua22TA50Lj4DiIJJrJj/Hkz0k8Jl6LeF97kZl2iOyAs6j4jQETIX
	ar+sDd9nUWA3VxBnANHtud7WJVnCdjTYXC6A8yM//GhAE4cw8PwnFBTUmIIXAmEq6zxAO+1+LI9
	edyB3v9s/umch/4urH7XvEQVPmM5Jcdk/N5dJc+MCRUmCYhyYLeIpaoU55wvbM7dbT3i6bh5AuJ
	sAkMB5vHoHINesN3/ZuH94cmG6byyJiJb5sMapebwfakOt0Nn4X5EENyH+foR655vKGUmqbDzKx
	QchrGHUVo7k81u1UYaUyUv3TPB+Es1XbhNpfyezjQ+0rTFBa6IZ6XogA
X-Received: by 2002:a05:6000:2909:b0:3b7:76e8:ba1e with SMTP id ffacd0b85a97d-3bb6646e1b1mr11015598f8f.11.1755546927519;
        Mon, 18 Aug 2025 12:55:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFAn6MMSBxi/j8FVJH1Jh1H7SBnR4PsVGcn8CfSpJkR13zfkXuLRKbilkdARr5/mjTwOb/KDw==
X-Received: by 2002:a05:6000:2909:b0:3b7:76e8:ba1e with SMTP id ffacd0b85a97d-3bb6646e1b1mr11015584f8f.11.1755546927110;
        Mon, 18 Aug 2025 12:55:27 -0700 (PDT)
Received: from redhat.com (128.19.187.81.in-addr.arpa. [81.187.19.128])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c0777892f8sm662708f8f.53.2025.08.18.12.55.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 12:55:26 -0700 (PDT)
Date: Mon, 18 Aug 2025 20:55:25 +0100
From: "Bryn M. Reeves" <bmr@redhat.com>
To: John Rinehart <johnrichardrinehart@gmail.com>
Cc: dm-devel@lists.linux.dev
Subject: Re: dm-cache-statistics and DMEMIT
Message-ID: <aKOFLeLCn_rJ74gr@redhat.com>
References: <CAGc5Yo9DFwyzNMtv5hochwhpqY3Pv6uqkqshUTOo++LAbs=jgw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAGc5Yo9DFwyzNMtv5hochwhpqY3Pv6uqkqshUTOo++LAbs=jgw@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: BqExinUXQnSHrI5miDEb8T7XO6SCcSjiDN6zVvUow5E_1755546928
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 18, 2025 at 12:05:08PM -0700, John Rinehart wrote:
> I'm using dm-cache in writeback mode and I'm trying to figure out how
> I can see the cache stats in "real-time" (poll every second). Like, I
> want to poll for the values in this data structure:
> https://github.com/torvalds/linux/blob/be48bcf004f9d0c9207ff21d0edb3b42f253829e/drivers/md/dm-cache-target.c#L283-L295.
> 
> But, I'm at a loss for how to do that.

That's the internal data structure that tracks the cache stats: you
could write a bpf or systemtap script to dump the contents periodically
if you really want to get at every field.
 
> There are also these DMEMIT messages that I'm really interested in
> printing to dmesg or subscribing to, or whatever, but I don't know how
> to access them (CONFIG_DM_DEBUG didn't do anything useful - which
> makes sense after reading the source a bit):
> https://github.com/torvalds/linux/blob/be48bcf004f9d0c9207ff21d0edb3b42f253829e/drivers/md/dm-cache-target.c#L3184-L3197.

This is the 'status' handler for the cache target - the DMEMIT() is what
prints the status values for the target in response to the
DM_TABLE_STATUS ioctl. The easiest way to retrieve it is with the
'dmsetup status' command.

I don't have a dm-cache device to hand right now, but here's how it
behaves for a dm-snapshot device and a thin pool. The cache target
follows the same pattern (with the fields described in the comment above
the code you linked to, on line 3134):

  # dmsetup status /dev/mapper/fedora-root--snapset_before
  0 20971520 snapshot 168344/21061632 664

  # dmsetup status /dev/mapper/fedora-pool0-tpool
  0 4194304 thin-pool 815 124/1024 1883/32768 - rw discard_passdown queue_if_no_space - 256

There's a slightly more detailed description of the status fields in the
docs: Documentation/admin-guide/device-mapper/cache.rst (other files in
that directory describe the other DM targets).

Regards,
Bryn.

