Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F272241E2
	for <dm-devel@lists.linux.dev>; Thu, 18 Jan 2024 13:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705584491; cv=none; b=XUwAvltKN0XFc89k8EbNuuckFPgRJYLMiBAAEOFUQOp1URq5rvaEfx/U0Ns4h6XVYG2BhAPk8mqsg2LrHkmuzN2DADBBC3XA3W/dWtJ5Ivuzh60vPBJrKoBS1ZOYTDIq56WrBxVMsUT+zuGj+oVz0vloMIGYY+buA4D8rJgwEjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705584491; c=relaxed/simple;
	bh=kK7PE40FceCdTgjIuc1NGYNPf1HM1qmeUPR0YI0PltY=;
	h=DKIM-Signature:Received:X-MC-Unique:Received:Received:Received:
	 Received:Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type:X-Scanned-By; b=OnQY2itKoMM13qrlJWQ0Z0haIaDcr/BCHc0vC+yOpxtz9bwCH9SRp0c6WjbdszPwbxNSTjWRcGmukZpT3Tl9NIdyw94XEsaMuTyrYJm0zcczWSHu/eTZTcV4jM2wI4DYTKmxR5mYz2O1mIsInz0OgasXeWARstE+DkRlN8BE80Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZGfEx8e1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZGfEx8e1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705584489;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HEm4a6vU1GC+OWwb+yDzZFLzVdYMSnx0xFZ7llLeV04=;
	b=ZGfEx8e117B90T4RLsEvEHuisvo6rAC3BDoVHPeN0yI1nNqTmYKsxI44twJCEUMHGPHCim
	9KZq9D78dO/OQah1AcNcGm3SbRBocDUxdVqS87dut4NQddS7GLsSj1t7pQ92uCLFhrgraC
	Tznc4VcYywo6ogEGIiuEUZzh2GVpMC8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-443-eTlbCYs4P4WGXX1OlmeJHQ-1; Thu,
 18 Jan 2024 08:28:05 -0500
X-MC-Unique: eTlbCYs4P4WGXX1OlmeJHQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5B57A28B6A19;
	Thu, 18 Jan 2024 13:28:05 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 36731C15587;
	Thu, 18 Jan 2024 13:28:05 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 2494130C1B8F; Thu, 18 Jan 2024 13:28:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 1F8C73FFC5;
	Thu, 18 Jan 2024 14:28:05 +0100 (CET)
Date: Thu, 18 Jan 2024 14:28:05 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
cc: Song Liu <song@kernel.org>, David Jeffery <djeffery@redhat.com>, 
    Li Nan <linan122@huawei.com>, dm-devel@lists.linux.dev, 
    linux-raid@vger.kernel.org, Mike Snitzer <msnitzer@redhat.com>, 
    Heinz Mauelshagen <heinzm@redhat.com>, 
    Benjamin Marzinski <bmarzins@redhat.com>, 
    "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH 2/7] md: fix a race condition when stopping the sync
 thread
In-Reply-To: <4af9fe2b-7f5a-59d6-0b5e-762ecae1b007@huaweicloud.com>
Message-ID: <21bafddb-63f6-82f0-40bf-b91fcb6260fc@redhat.com>
References: <e5e8afe2-e9a8-49a2-5ab0-958d4065c55e@redhat.com> <8fb335e-6d2c-dbb5-d7-ded8db5145a@redhat.com> <dcf29bba-4762-84ad-f60e-3607cf6779f9@huaweicloud.com> <66fda537-9d25-77e7-754f-2627e35fb8a4@redhat.com>
 <4af9fe2b-7f5a-59d6-0b5e-762ecae1b007@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="185210117-1955194028-1705584485=:1585108"
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--185210117-1955194028-1705584485=:1585108
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 8BIT



On Thu, 18 Jan 2024, Yu Kuai wrote:

> Hi,
> 
> 在 2024/01/18 21:07, Mikulas Patocka 写道:
> > 
> > 
> > On Thu, 18 Jan 2024, Yu Kuai wrote:
> > 
> >> Hi,
> >>
> >> 在 2024/01/18 2:18, Mikulas Patocka 写道:
> >>> Note that md_wakeup_thread_directly is racy - it will do nothing if the
> >>> thread is already running or it may cause spurious wake-up if the thread
> >>> is blocked in another subsystem.
> >>
> >> No, as the comment said, md_wakeup_thread_directly() is just to prevent
> >> that md_wakeup_thread() can't wake up md_do_sync() if it's waiting for
> >> metadata update.
> > 
> > Yes - but what happens if you wake up the thread just a few instructions
> > before it is going to sleep for metadata update? wake_up_process does
> > nothing on a running process and the thread proceeds with waiting. This is
> > what I thought could happen when I was making the patch.
> 
> Please notice that in the orginal code md_wakeup_thread_directly() is
> used for sync_thread, and md_wakeup_thread() should be used for
> *mddev->thread* (mddev_unlock always do that) to clear
> MD_RECOVERY_RUNNING.
> 
> By the way, the root cause that MD_RECOVERY_RUNNING is not cleared is
> that mddev_suspend() never stop sync_thread at all, while
> md_check_recovery() won't do anything when mddev is suspended.
> 
> Before:
> 1. suspend
> 2. call md_reap_sync_thread() directly to unregister sync_thread
>     -> notice that this is not safe.
> 3. resume
> 
> Now:
> 1. suspend
> 2. call stop_sync_thread() to unregister sync_thread interrupt
> md_do_sync() and wait for md_check_recovery() to clear
> MD_RECOVERY_RUNNING.
>    -> which will never happen now;
> 3. resume
> 
> I fixed this locally and the test integrity-caching.sh passed in my VM.
> 
> Thanks,
> Kuai

OK, Thanks.

Mikulas
--185210117-1955194028-1705584485=:1585108--

