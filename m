Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795448194;
	b=SD8knyNrhV4p+alBkQyxScJnaj60Vr0Gq0TJs3fUdfielOQ0ohnq+K9N+jVZuEkar887
	 iK6tDN1SyM5FPT5Rpvuzlr9h8l3mJAo1e0Hxiir5uvCOAM4wkPzQxayvIf9KBQhLVxcHy
	 mMoN45VwRvB4nRWuHyu095536aDkwe4UDOjwl4o9lWG99qAMwCUX/8OlFLQp8+FCFZcLY
	 GLYna8fRfg+Ztg557IcDe/LLqn5Msrt+gX9dcku6g4rtloj3icC7eLH+qsXIhWRG7EIwX
	 ZyvW+pzQ6b03O0YpweTaEqzm1KJUkLEjvJ6/r0P8tX1ZOk8iwVNqKcAg3rILdQqJ4tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795448194;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Date:From:To:cc:Subject:
	 In-Reply-To:Message-ID:References:MIME-Version:X-Scanned-By:
	 X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:
	 Content-Type;
	bh=1XFcPod1FFohR6V4AAF/gEfpUeCtMF7v05o2OAE5Wyo=;
	b=voI8lQQx+Y1VcD2FDOV1UE34MMhxeMQiC5GjRWPzmbL3N5n9kSPJzewd1/sPUvoVwV64
	 2v5M+DPGIn0FPF13TTMDgH+eN7WsMk/IncikRnrkKvMAjkIwVKIdZBv1ScAx2zQmlq/5g
	 f4Mbkr+ugw3wtAzOvdHGZy2w8z2qAOtSt8n9oP/2+G0zUbdZKp535mvZ3vIW1Qcnsxl1s
	 5qP9KVLnxYwYitFIJ+3tQk39FPtvHxVpRv0mfjkJ6+rMp3F+lx35eOxf5b/rGRsaTFOFX
	 xCuZD+9Cvk1YHn0THqQTtoyTqdtIHcUCF6arCiYPOej/bgOwdoeKC4KGIWjlpaqo2hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b="Y1u0/pF7";
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1BB606A31A
	for <dm-devel@lists.linux.dev>; Mon, 23 Nov 2026 15:36:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1F1BB606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Y1u0/pF7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795448193;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1XFcPod1FFohR6V4AAF/gEfpUeCtMF7v05o2OAE5Wyo=;
	b=Y1u0/pF724pxAPiy77Z8bjuKm2Ll/m9rbHsTiAouxFt1ruaOpGD8ceABrKRZ8dXJzTfgeE
	68TnH/s5kjgGmeU8F9OGRj9pyTztowyzIff4icS36izhV6QNHrcYZwtXneWQVIVzJ4RATF
	dWl7pel5JjqAOnQx5E94ufANJEbmhN4=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-659-t5uJ-he9OR607hSFGokdKg-1; Mon,
 23 Nov 2026 15:36:29 +0000
X-MC-Unique: t5uJ-he9OR607hSFGokdKg-1
X-Mimecast-MFC-AGG-ID: t5uJ-he9OR607hSFGokdKg_1795448187
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9C9E21801319;
	Mon, 23 Nov 2026 15:36:26 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ECEA53001DA7;
	Mon, 23 Nov 2026 15:36:22 +0000 (UTC)
Date: Mon, 23 Nov 2026 16:36:20 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Yongpeng Yang <yangyongpeng.storage@gmail.com>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    Dave Chinner <david@fromorbit.com>
cc: agk@redhat.com, snitzer@kernel.org, bmarzins@redhat.com, 
    zkabelac@redhat.com, okozina@redhat.com, dm-devel@lists.linux.dev, 
    linux-mm@kvack.org
Subject: Re: [PATCH 2/4] dm-bufio: allow exposing a client in sysfs under a
 caller-chosen kobject
In-Reply-To: <20261119162819.1627180-1-yangyongpeng.storage@gmail.com>
Message-ID: <5e21caf9-5aaf-8007-0e71-598d7828697e@redhat.com>
References: <2033a6a7-b8c4-99cc-f351-e83579a238ec@redhat.com> <20261119162819.1627180-1-yangyongpeng.storage@gmail.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1VxBvZS3gWRDHVSzZtAX4zwtBEPAs41VD2gWzPkyaps_1795448187
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Fri, 20 Nov 2026, Yongpeng Yang wrote:

> On Thu, Nov 19, 2026, Mikulas Patocka wrote:
> > Is the kernel dropping dm-bufio buffers too aggressively? Or is it not
> > dropping them so that they consume too much memory?
> 
> Both, and the tension is why one global value cannot work. Our hash
> areas run from 0.x MB to 40+ MB: the 256 KiB default makes large devices
> re-read evicted hash blocks, while a uniformly large value makes every
> cold, idle device hold memory forever -- and most verity devices are
> cold most of the time, which is what small-memory systems complain about.

What about improving the shrinker memory management?

The problem with shrinkers is that the generic memory management code 
doesn't know how old are objects in the registered shrinkers. So, it may 
ask the shrinkers that have only recently used objects to free memory.

Maybe we could add an upcall that returns the last used time of the oldest 
object in a given shrinker, select the shrinker with the oldest object and 
shrink from it? Would this be feasible?

> > Could it be fixed through other means that are more general? (for
> > example, having a global dm-bufio shrinker and dropping buffers from
> > the client that has the longest unused buffer)
> 
> A global LRU shrinker would tell hot from cold given time, but:
> 
> - Our userspace already knows which device will be used and when, so
>   it does not need the heuristic, it can drop exactly that device's
>   hash blocks, precisely and immediately.

Please, show some numbers - how much does this patchset improve Android 
boot time (if you are prefetching blocks that will be needed at boot) or 
application load time?

Would prefetching with the readahead() syscall be better? (it would 
prefetch data down to the page cache, so I presume it would be more 
efficient)

Back in the era of mechanical disks, there used to be a daemon that 
prefetched blocks to improve boot time. With SSDs, the idea was abandoned 
because it didn't provide any advantage. Are you implementing something 
like this?

> - On low-memory devices we need the memory back quickly, not when
>   pressure finally ages the buffers out.

I don't see how shrinking bufio should be different from shrinking page 
cache, inodes, dentries or other kernel objects.

Maybe you need to tune /proc/sys/vm/min_free_kbytes if the kernel is not 
shrinking memory fast enough.

> - Verity, thin and cache clients share one pool with very different
>   access patterns; a single LRU lets them fight for it, while
>   per-client floors keep the shares apart.
> 
> Thanks for the review,
> Yongpeng

Mikulas

