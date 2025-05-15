Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F332918F3
	for <dm-devel@lists.linux.dev>; Thu, 15 May 2025 10:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747306280; cv=none; b=ZqY/Bv4nNswAGd864KtxrqCRz3EFcmsL/C+CmxzPGry5t6Is7Qw5bNWSkCgFglpeauYh42aob/6haUxgORtcyHkFxLcMIQ7a5ahLXaHsjQvSNYyDMG8Qm2ow8zDC8r4K0gqfgs4azInihWpaxHCkV2Zg1av/g31zvwOW9mvkv1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747306280; c=relaxed/simple;
	bh=AnnU3LMpl5hAn3J5YKjudejZV9W0hvWD+BxGwylCrSY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kkewkJeQVsQMH6O6Ggh7X1/on4iYHElhWwTSwHyHTCQrsFtPHVTPuS8MRBvPEgSJnnMv0u8lnG6CqJhVB4bGTMHxVDUWCYjO+d9uy0ylqtcnHN65eitUYysu05vuaFH4Eb8HCsTiHPK6KqHSAmjG3VG2PR7bkF6WRjKHzKqum5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S1ZXJC8j; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S1ZXJC8j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747306277;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AnnU3LMpl5hAn3J5YKjudejZV9W0hvWD+BxGwylCrSY=;
	b=S1ZXJC8j4ZYMEATj6EwztLELr4LKay5f6Tt1wMg4fUIR2DKyiboi3Krp7MTEuD19Douej2
	aCOXVJhwslonQe7/GpjEAwoSO8rKnP6L7KGU1folXpvKEmSGyk4nuI3Mxy5azY5CvO0mRK
	MBBwOlFMohuLKh44JHGnSx4cfcAbLg4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-220-NLDrxIztMgqKIvPvVdfZNQ-1; Thu, 15 May 2025 06:51:15 -0400
X-MC-Unique: NLDrxIztMgqKIvPvVdfZNQ-1
X-Mimecast-MFC-AGG-ID: NLDrxIztMgqKIvPvVdfZNQ_1747306275
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a0b7cd223fso469044f8f.2
        for <dm-devel@lists.linux.dev>; Thu, 15 May 2025 03:51:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747306275; x=1747911075;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AnnU3LMpl5hAn3J5YKjudejZV9W0hvWD+BxGwylCrSY=;
        b=N8kiZ4kEucUCyhiSTgCWbnDGf4lgZzxiIty1X12jBaU1M7BWRlkOi1nyJUfngzYYBb
         vPqoNunmpYWDViOqO53cn9PMy1BXnAvuXOP2CBTz+/o8AXl4zbEMk4cZK/Tdxa/wlv+5
         Z0igfdpXF+UDVxXZRgdZl6ZRx93ymCvme1LmPqVQ9Qq8hQndwNvyBTn8WMNAwE7iyw+Z
         9erJJyDtVcjkQNzoa0yikkO7Vyt1OkHL+Tw97tH+K7bC1lyGSdfzJktqM2lQ/kYapTJQ
         XG0ow9tLc7DXjBFKOqmsQb8Uo8WuJHMW5B/XIEsdIt3/gKhwXY569gWR4gfSSYabh4WF
         Mk3w==
X-Forwarded-Encrypted: i=1; AJvYcCUa9whxCa+3pfN5ILDpV2R4FMvUtrJD2qk33Ho53Dq3wIqRWdO3JMIhksXQwMq1Xk4TjPsEjg9UGA==@lists.linux.dev
X-Gm-Message-State: AOJu0YxjxPOZQA6EzbpmMIp5aaiuUYA9fexcRhaY29HN9J2qfjI1qN0L
	TXFUntR8eLXwqASRO8W9LJ+Vpb3a/dMrB9/C3t3ahA02YMTW9o0CT5qVofLR/as/G9X5OQIvMlF
	rp/kl9DWHUiX8IpbLEsOA9NFnRRgMbkoCFDcHbu7ApISzE8tajZ4AITBpHCz8S/eEPYoKCCvwER
	dlQ7pt3cG5u9toPnXkHYhcc8N9cu4rTN4=
X-Gm-Gg: ASbGncuhsgw/tZ18cphk2zh7EHG2jbaKeLNz8Sttmz0kxqrEeiaDn3ioJ5EZqNEjtX1
	b7Lb0qJStzbI1uWmnWVoddrR4DlyteiKTv3hO9ym3B7QOxa6m5Ou3u+Ch4VmpQfacb3rhgQ==
X-Received: by 2002:a5d:4e8a:0:b0:3a3:592d:21b6 with SMTP id ffacd0b85a97d-3a3592d2310mr955265f8f.15.1747306274688;
        Thu, 15 May 2025 03:51:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG2JuuaqLPcVrNMU2tKqzE3FnfEFbJyyrBqjO7QtZCsTyzkpYvx/DeqzxIsGQwmYUSuVIl1ksSfIrz86qaed68=
X-Received: by 2002:a5d:4e8a:0:b0:3a3:592d:21b6 with SMTP id
 ffacd0b85a97d-3a3592d2310mr955248f8f.15.1747306274267; Thu, 15 May 2025
 03:51:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250429165018.112999-1-kwolf@redhat.com> <47dd225b433b0df585a25084a2e793344eeda239.camel@suse.com>
 <aCIRUwt5BueQmlMZ@redhat.com> <aCLe5UT2kfzI96TQ@infradead.org>
 <aCMQ5S-gI6vZJxmq@redhat.com> <aCQiz88HksKg791Z@infradead.org>
 <aCTDiHMuMncwdp_X@redhat.com> <50beb356b4dc000446fd186ab754c87f386eaeae.camel@suse.com>
 <CABgObfaEiMN=YANk02EWini+jAXU1MxSvo8_jYWaMiu3ds7hgQ@mail.gmail.com> <2f0fc8ef7d04c590893bd6d54a6c0c842c4b21d7.camel@suse.com>
In-Reply-To: <2f0fc8ef7d04c590893bd6d54a6c0c842c4b21d7.camel@suse.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 15 May 2025 12:51:00 +0200
X-Gm-Features: AX0GCFvGwWrUeVYJp0osm4NobblV0XdonG1jUigrUVjlVR-98uQyDG2aNENpGNw
Message-ID: <CABgObfZVbKcAua_=+C_0eC5Ec2ZDY4Bsz_b1memF1KifVGhoQw@mail.gmail.com>
Subject: Re: [PATCH 0/2] dm mpath: Interface for explicit probing of active paths
To: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christoph Hellwig <hch@infradead.org>, 
	Kevin Wolf <kwolf@redhat.com>, dm-devel@lists.linux.dev, 
	Hanna Czenczek <hreitz@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, snitzer@kernel.org, 
	"Kernel Mailing List, Linux" <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: WIxO4Iss3s4cqfoflZeLW-eqr4bwjCV3Levbqya3gLY_1747306275
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 15, 2025 at 12:34=E2=80=AFPM Martin Wilck <mwilck@suse.com> wro=
te:
> On Thu, 2025-05-15 at 04:53 +0200, Paolo Bonzini wrote:
> > Il mer 14 mag 2025, 13:37 Martin Wilck <mwilck@suse.com> ha scritto:
> > Yes, as usual things are a bit more complicated. First, a handful of
> > commands are special (REQUEST SENSE would be for HBAs that don't use
> > auto sense, but that is fortunately not something you encounter).
> > Second, there's already a filter in the kernel in
> > drivers/scsi/scsi_ioctl.c for commands that are allowed without
> > CAP_SYS_RAWIO. QEMU is subject to that so the commands you'll see are
> > mostly I/O, INQUIRY, TUR, MODE SENSE/SELECT and that's it.
>
> Thanks for mentioning this. However, I suppose that depends on the
> permissions with which the qemu process is started, no? Wouldn't
> qemu need CAP_SYS_RAWIO for PCI passthrough as well?

Generally you want to assume that the VM is hostile and run QEMU with
as few privileges as possible (not just capabilities, but also in
separate namespaces and with restrictions from device cgroups,
SELinux, etc.). PCI passthrough is not an issue, it only needs access
to the VFIO inodes and you can do it by setting the appropriate file
permissions without extra capabilities. The actual privileged part is
binding the device to VFIO, which is done outside QEMU anyway.

> I admit that I'm confused by the many indirections in qemu's scsi-block
> code flow. AFAICS qemu forwards everything except PRIN/PROUT to the
> kernel block device in "scsi-block" mode. Correct me if I'm wrong.

Yes, that's correct. The code for PRIN/PROUT calls out to a separate
privileged process (in scsi/qemu-pr-helper.c if you're curious) which
is aware of multipath and can be extended if needed.

> Anwyway, let's not forget that we're talking about the kernel here.
> While qemu is the main target application for this feature is created,
> any application can use it, and it may or may not run with
> CAP_SYS_RAWIO.

Yes, but once you have CAP_SYS_RAWIO all bets for sanity are off... it
even lets you do SG_IO on partitions.

> > .Of the ones that aren't simple I/O, mode parameters and TUR are the
> > important cases. A TUR failure would be handled by the ioctl that
> > Kevin proposed here by forcing a path switch. Mode parameters might
> > not be shared(*) and would need to be sent down all the paths in that
> > case; that can be fixed in userspace if necessary.
>
> Passing TUR from a multipath device to a random member doesn't make
> much sense to me. qemu would need to implement some logic to determine
> whether the map has any usable paths.

As long as one path replies to a TUR and the host is able to
(eventually, somehow) steer I/O transparently to that path, that
should be good enough. If the one path that the kernel tries is down,
QEMU can probe which paths are up and retry. That seems consistent
with what you want from TUR but maybe I'm missing something.

> > Yes, the kernel filter is a PITA in the normal single path case but
> > here it helps not doing something overly wrong.
>
> This seems coincidental to me. Filtering by permissions and filtering
> for commands that make sense on multipath devices are orthogonal
> problems.

I agree (it helps, it doesn't solve the problem), however there is a
large overlap between the two.

Paolo

