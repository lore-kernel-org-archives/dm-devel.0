Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902DE239E84
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 15:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747063136; cv=none; b=J6KAFEtn2h9U9KyisIZrP6jn0xPUwciEC9dAQOB1UveEVJw74717Vep2GWac/fsVt7Mof0AjI97VTTjEi691t6KjLNADgYkHgZl2HeAf19zZLnMkOtnDq1YtL69toyrGt02Dswoiq8V9vCl4HXwiU+xIYaUIHR4SyHcIYJH3E20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747063136; c=relaxed/simple;
	bh=2IdpfLGKdEoZhwnQatAbCZnirWhv+nx6cgCI9SW6Ar4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oxMW6GKyi0DQZn9P8hI9mdjOXziM4gKqFhz16cwQgWn7A1kUlb1vKHfyBOCpunGx7Tej6up/Es4iQA+kZy6kIrhZqUA5qBLbwpKsFwJxVjsjdP1OwTq4703QYbWvNburlfRFY9ItCGdAae3yyRdCh1LCqKvFR8krBpb0ojrKETo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iRmR1vHP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iRmR1vHP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747063133;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=055Mhxm3Vj10tzsgUUAv0QLPQcIdcHHdPWPHZyA4HeM=;
	b=iRmR1vHPSdf0cDPG67yO5vOpPcA9Owy7FwUf4+Mm8pg87cmPybMEw1SASUw9gVzYu6p6W2
	IriKLf9bPCXDSWz9dEiVYEFZ86w8YJlc7lfFjF2wR/jDTwUFxPr2N1Y2K4W3DqBcMA0j6j
	EcbsUAiv+AQe49nbagAjOrzuaIi2W88=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-327-mJRrA0M2N6qmC_tbDPCx3g-1; Mon,
 12 May 2025 11:18:50 -0400
X-MC-Unique: mJRrA0M2N6qmC_tbDPCx3g-1
X-Mimecast-MFC-AGG-ID: mJRrA0M2N6qmC_tbDPCx3g_1747063129
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BA5C81955BCD;
	Mon, 12 May 2025 15:18:48 +0000 (UTC)
Received: from redhat.com (unknown [10.45.226.40])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 534E01940EB0;
	Mon, 12 May 2025 15:18:46 +0000 (UTC)
Date: Mon, 12 May 2025 17:18:43 +0200
From: Kevin Wolf <kwolf@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@lists.linux.dev, hreitz@redhat.com, mpatocka@redhat.com,
	snitzer@kernel.org, bmarzins@redhat.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] dm mpath: Interface for explicit probing of active
 paths
Message-ID: <aCIRUwt5BueQmlMZ@redhat.com>
References: <20250429165018.112999-1-kwolf@redhat.com>
 <47dd225b433b0df585a25084a2e793344eeda239.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47dd225b433b0df585a25084a2e793344eeda239.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Am 08.05.2025 um 15:51 hat Martin Wilck geschrieben:
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
> after other possibly hanging IO). In the past we have put a lot of
> effort into other code paths in multipath-tools and elsewhere to avoid
> this kind of hang to the extent possible. It seems to me that your set
> re-introduces this risk.

That's a fair point. I don't expect this code to be fully final, another
thing that isn't really optimal (as mentioned in the comment message) is
that we're not probing paths in parallel, potentially adding up timeouts
from multiple paths.

I don't think this is a problem of the interface, though, but we can
improve the implementation keeping the same interface.

Maybe I'm missing something, but I think the reason why it has to be
uninterruptible is just that submit_bio_wait() has the completion on the
stack? So I suppose we could just kmalloc() some state, submit all the
bios, let the completion callback free it, and then we can just stop
waiting early (i.e. wait_for_completion_interruptible/killable) and let
the requests complete on their own in the background.

Would this address your concerns or is there another part to it?

> Apart from that, minor observations are that in patch 2/2 you don't
> check whether the map is in queueing state, and I don't quite
> understand why you only check paths in the map's active path group
> without attempting a PG failover in the case where all paths in the
> current PG fail.

Ben already fixed up the missing check.

Not attempting PG failover was also his suggestion, on the basis that it
would be additional work for no real benefit when you can only submit
requests for the current PG anyway. If userspace retries the SG_IO, it
will already pick a different PG, so having the kernel do the same
doesn't really improve anything.

> I am wondering whether the DM_MPATH_PROBE_PATHS_CMD ioctl is necessary
> at all. Rather than triggering explicit path probing, you could have
> dm-mpath "handle" IO errors by failing the active path for "path
> errors". That would be similar to my patch set from 2021 [1], but it
> would avoid the extra IO and thus the additional risk of hanging in the
> kernel.
> 
> Contrary to my set, you wouldn't attempt retries in the kernel, but
> leave this part to qemu instead, like in the current set. That would
> avoid Christoph's main criticism that "Failing over SG_IO does not make
> sense" [2].

Maybe I misunderstood, but my understanding from the feedback you got
back then was that no SCSI-specific code was wanted in device mapper.
This is why we kept interpreting the status codes in userspace.

While discussing the approaches with Mikuláš and Ben, one option that
was briefly discussed was a pair of ioctls: One that wraps ioctls and
returns which path the ioctl took, and another one to fail that path if
inspection of the result in userspace comes to the conclusion that it's
a path error. I didn't think this could be implemented without also
allowing an unprivileged process to DoS the device by just failing all
paths even if they are still good, so we didn't continue there.

Anyway, if it actually were acceptable for the kernel to check SG_IO
results for path errors and fail the path while still returning the
result unchanged, then that would work for us for the specific case, of
course. But I don't expect this really addresses Christoph's concerns.
If you think it does, is there another reason why you didn't try this
before?

(And it wouldn't be generic, so would we potentially have to repeat the
exercise for other ioctls in the future?)

> Doing the failover in qemu has the general disadvantage that qemu has
> no notion about the number of available and/or healthy paths; it can
> thus only guess the reasonable number of retries for any given I/O. But
> that's unavoidable, given that the idea to do kernel-level failover on
> SG_IO is rejected.

Yes, it's a bit unfortunate, but we have to work with what we have. QEMU
doesn't even necessarily know that it's dealing with a multipath device,
so it just has to blindly try the ioctl and see if it works.

Kevin

