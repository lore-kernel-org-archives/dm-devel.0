Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285C69475
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 13:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747057580; cv=none; b=f0o+oIx4eY2BQU7WjCD5YxpVG7KiWc+2YYodntb++IR7dvFOGO04zvbsVfyQBmk8zumCZ7Oc7tXmgJkNiMO0R1718u7+TTHvxRcIzTgYUNH5ZDcqSpg7zUkCtrAUBqZ7D+c1Qji43bgwzafPM8wgybNS8lDNHF49Ia5mE6yYWmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747057580; c=relaxed/simple;
	bh=S3vdn7L5S6SPD/rZyZJ5bYNPICWxvSGryBhKvA6XtNo=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=QEi7jA0cp5xEiKOoVpA/bXpmcnPRmSTzV6mJLAA5M3ypRtsysSwjYwpkXZ8zxKX132NHAZc9hdrLrBAgF+ij2F4JSOBUS72etL8sT/QibSohJAmUk0qRs/d1thOwexbpVumJp2Ns40CK4/wnGmhkWb137gFyZnANKKaufdWjEx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GRKBKgVf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GRKBKgVf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747057576;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6Q4vZQjuJqJokWhgIQZZUGV+LeF/CF+vN6EkzqG+T0Y=;
	b=GRKBKgVf3axGkhdgcXdGeSEk9REQ/+drlaIY4nAQcKf1jX85KJD5IxR6g6DyZYtMPcUZk+
	qxabqoVK31uPtgxFg9POIS5GLAMUgTfszv76tyCRYzVL29byQt4uozNq8T2EHh6OhDxb/g
	nZnXf7nBzpZFa0/WG6e+aBaUPVM5OxI=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-630-S3OV2PxyPHuLia8MSaP0TA-1; Mon,
 12 May 2025 09:46:13 -0400
X-MC-Unique: S3OV2PxyPHuLia8MSaP0TA-1
X-Mimecast-MFC-AGG-ID: S3OV2PxyPHuLia8MSaP0TA_1747057572
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 323FD1800873;
	Mon, 12 May 2025 13:46:12 +0000 (UTC)
Received: from [10.22.80.45] (unknown [10.22.80.45])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D83EE18003FC;
	Mon, 12 May 2025 13:46:09 +0000 (UTC)
Date: Mon, 12 May 2025 15:46:06 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Martin Wilck <mwilck@suse.com>
cc: Kevin Wolf <kwolf@redhat.com>, dm-devel@lists.linux.dev, hreitz@redhat.com, 
    snitzer@kernel.org, bmarzins@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] dm mpath: Interface for explicit probing of active
 paths
In-Reply-To: <47dd225b433b0df585a25084a2e793344eeda239.camel@suse.com>
Message-ID: <8e009e40-a1d2-5eea-3930-f81446b16722@redhat.com>
References: <20250429165018.112999-1-kwolf@redhat.com> <47dd225b433b0df585a25084a2e793344eeda239.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463811712-608219467-1747057571=:2446783"
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811712-608219467-1747057571=:2446783
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

Hi


On Thu, 8 May 2025, Martin Wilck wrote:

> Hello Kevin,
> 
> [I'm sorry for the previous email. It seems that I clicked "send" in
> the wrong window].
> 
> On Tue, 2025-04-29 at 18:50 +0200, Kevin Wolf wrote:
> > Multipath cannot directly provide failover for ioctls in the kernel
> > because it doesn't know what each ioctl means and which result could
> > indicate a path error. Userspace generally knows what the ioctl it
> > issued means and if it might be a path error, but neither does it
> > know
> > which path the ioctl took nor does it necessarily have the privileges
> > to
> > fail a path using the control device.
> 
> Thanks for this effort.
> 
> I have some remarks about your approach. The most important one is that
> the DM_MPATH_PROBE_PATHS_CMD ioctl appears to be a dangerous command.
> It sends IO to possibly broken paths and waits for it to complete. In
> the common error case of a device not responding, this might cause the
> code to hang for a long time in the kernel ioctl code path, in
> uninterruptible sleep (note that these probing commands will be queued

Normal reads and writes would also hang in an uninterruptible sleep if a 
path stops responding.

> after other possibly hanging IO). In the past we have put a lot of
> effort into other code paths in multipath-tools and elsewhere to avoid
> this kind of hang to the extent possible. It seems to me that your set
> re-introduces this risk.
> 
> Apart from that, minor observations are that in patch 2/2 you don't
> check whether the map is in queueing state, and I don't quite
> understand why you only check paths in the map's active path group
> without attempting a PG failover in the case where all paths in the
> current PG fail.
> 
> I am wondering whether the DM_MPATH_PROBE_PATHS_CMD ioctl is necessary
> at all. Rather than triggering explicit path probing, you could have
> dm-mpath "handle" IO errors by failing the active path for "path
> errors". That would be similar to my patch set from 2021 [1], but it
> would avoid the extra IO and thus the additional risk of hanging in the
> kernel.

What exactly do you mean? You say "you could have dm-mpath 'handle' IO 
errors by failing the active path for "path errors".

Christoph doesn't want dm-mpath can't look at the error code - so dm-mpath 
doesn't know if path error occured or not. qemu could look at the error 
code, but qemu doesn't know which path did the SG_IO go through - so it 
can't instruct qemu to fail that path.

One of the possibility that we discussed was to add a path-id to SG_IO, so 
that dm-mpath would mark which path did the SG_IO go through and qemu 
could instruct dm-mpath to fail that path. But we rejected it as being 
more complicated than the current approach.

> Contrary to my set, you wouldn't attempt retries in the kernel, but
> leave this part to qemu instead, like in the current set. That would
> avoid Christoph's main criticism that "Failing over SG_IO does not make
> sense" [2].
> 
> Doing the failover in qemu has the general disadvantage that qemu has
> no notion about the number of available and/or healthy paths; it can
> thus only guess the reasonable number of retries for any given I/O. But
> that's unavoidable, given that the idea to do kernel-level failover on
> SG_IO is rejected.
> 
> Please let me know your thoughts.
> 
> Best Regards
> Martin
> 
> [1] https://lore.kernel.org/all/20210628151558.2289-1-mwilck@suse.com/
> [2] https://lore.kernel.org/all/20210701075629.GA25768@lst.de/

Mikulas
---1463811712-608219467-1747057571=:2446783--

