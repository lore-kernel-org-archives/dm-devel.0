Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826B453A7
	for <dm-devel@lists.linux.dev>; Fri, 10 Oct 2025 00:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760056785; cv=none; b=lbKaI1+sNWWKZXOpte8aJYVfRm9+6rf/+nBdGg0p0Ktdl4PYus8H9pVUeapZoaoUd/EdTcR84XSqgy9DMyNTCP6S+k9aFSFVBNym1rWYZwFvKIHuxTjluoxs/HMw87DYufAyDZh9yY5aomgRCIXUpgj1fkQK9ZnNhYQCiTpv/4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760056785; c=relaxed/simple;
	bh=epacj6aKs+5PtWKm4XZ10BX+XGQk9N7DSXmKbFHLrZM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RjDEkrPjtUFt1fl4/k0g3M2rMD/KJ5Wi8PZgIc2wjADQ8fVHSylDxBBfTbKJmGos4b28JGrEf46JCIpGupaZoXdqnO0H+HerDlPIBcE/anhlP8cdK4nX/430WQSBKvYfZxFxrwWntpGPC/k5bLfLV8L8/cLByB+EolGXY9iyhiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gxHudtDa; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gxHudtDa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760056782;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qOZL046Blo3kEtnXR5GG66Ol5QYGrAEgmB+JhvM7L6I=;
	b=gxHudtDa4fkeQdsxbDMS954SNbpsrGlsS1ikYNfICsfH+CkQvHtomRIsSM0SvoKx/dRyNl
	dbIFObDHGcHktYVNT+n7nfVcQcOvLHYJwwdK113AEBs0w43/DEUR4l5mNM3b3Zya6AIBlM
	3nsOmaFRVdgI7MAzDG+1qT54sNRLsk0=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-629-BqcHMXKKPgGo1k3ctagMJQ-1; Thu,
 09 Oct 2025 20:39:38 -0400
X-MC-Unique: BqcHMXKKPgGo1k3ctagMJQ-1
X-Mimecast-MFC-AGG-ID: BqcHMXKKPgGo1k3ctagMJQ_1760056777
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6F79919560AE;
	Fri, 10 Oct 2025 00:39:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D51841955F22;
	Fri, 10 Oct 2025 00:39:36 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 59A0dZqC2933052
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 9 Oct 2025 20:39:35 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 59A0dZEF2933051;
	Thu, 9 Oct 2025 20:39:35 -0400
Date: Thu, 9 Oct 2025 20:39:35 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Martin Wilck <mwilck@suse.com>, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org
Subject: Re: [PATCH] dm: Fix deadlock when reloading a multipath table
Message-ID: <aOhVx3J2ahZQuS28@redhat.com>
References: <20251009030431.2895495-1-bmarzins@redhat.com>
 <ed792d72a1ca47937631af6e12098d9a20626bcf.camel@suse.com>
 <033ca444-4c68-4a4f-bc2b-32232e80e848@acm.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <033ca444-4c68-4a4f-bc2b-32232e80e848@acm.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Thu, Oct 09, 2025 at 04:29:21PM -0700, Bart Van Assche wrote:
> On 10/9/25 2:57 AM, Martin Wilck wrote:
> > In general, I'm wondering whether we need a more generic solution to
> > this problem. Therefore I've added linux-block to cc.
> > 
> > The way I see it, if a device has queued IO without any means to
> > perform the IO, it can't be frozen. We'd either need to fail all queued
> > IO in this case, or refuse attempts to freeze the queue.
> 
> If a device has queued I/O and the I/O can't make progress then it isn't
> necessary to call blk_mq_freeze_queue(), isn't it? See also "[PATCH 0/3] Fix
> a deadlock related to modifying queue attributes"
> (https://lore.kernel.org/linux-block/20250702182430.3764163-1-bvanassche@acm.org/).
> 
> BTW, that patch series is not upstream. I apply it manually every time
> before I run blktests.

Timing out the queue freeze looks like a good solution to me.

Also, looking at that thread, I should point out that bio-based
multipath does not suffer from this, since it doesn't queue requests. It
queues bios. The reason you still got the hang with your blktests patch
is that it didn't actually configure bio-based multipath ("queue_mode"
is not a valid multipath.conf option). That would look something like
this:

===================
diff --git a/common/multipath-over-rdma b/common/multipath-over-rdma
index e157e0a..1084f80 100644
--- a/common/multipath-over-rdma
+++ b/common/multipath-over-rdma
@@ -267,9 +267,7 @@ mpath_has_stale_dev() {
 # Check whether multipath definition $1 includes the queue_if_no_path keyword.
 is_qinp_def() {
 	case "$1" in
-		*" 3 queue_if_no_path queue_mode mq "*)
-			return 0;;
-		*" 1 queue_if_no_path "*)
+		*" queue_if_no_path "*)
 			return 0;;
 		*)
 			return 1;;
diff --git a/tests/srp/multipath.conf b/tests/srp/multipath.conf
index e0da32e..aad8e56 100644
--- a/tests/srp/multipath.conf
+++ b/tests/srp/multipath.conf
@@ -9,6 +9,7 @@ devices {
 		product		".*"
 		no_path_retry	queue
 		path_checker	tur
+		features "2 queue_mode bio"
 	}
 }
 blacklist {
==================

But you are correct that unless we can get bio-based multipath to
something like performance parity with request-based multipath,
customers aren't interested it in.

-Ben

> 
> Bart.

