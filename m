Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC66B241FB
	for <dm-devel@lists.linux.dev>; Thu, 18 Jan 2024 13:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705584246; cv=none; b=FePcp1d4CgezAQViyCrP+kLbOsd1Gojk2nq5/FTubAahycFykowN7NeeBoq0NV9eGGrR4UzTyuaC3C+05GhVb7g+n6kSN+f+C2PJWSYq8nmSM8/eXwayID+YLyfb6O6psJ6LHSiXEx6kjkx8jQpOUn8U622YH0cN1MSzqCQwJRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705584246; c=relaxed/simple;
	bh=gddmONiHDrmylTDFx/15jk5JKkWuj/iBxYqvF6L3SqA=;
	h=DKIM-Signature:Received:X-MC-Unique:Received:Received:Received:
	 Received:Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type:Content-ID:X-Scanned-By; b=M9uizyUQV6jzVUexsrC//gijULlXBhLFyjNkUyFHrEjulo/LK2zLQtxr1ZR3eEgZAIoE66umSa0LYqPjXLt8hCFDukinNPhOT43og8odr8ww4wDnUo8Z7yDhwEHVGC8YEo39PBK9esW9oygYYbIXJC30m1y/Hk979WcD0LWjQyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N2QKgpwW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N2QKgpwW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705584243;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aZuf72OEHV8SZWA55hgJtknA+93XwjjenVVLg0Sj2hM=;
	b=N2QKgpwWqKpfd0I9R7M43xzfdHTEl6p4c2pP3Y8gwl/HxjUX5bkPG+09uPzcM1K6CmpZlu
	ilDMNWn8gXGH4iRcC7LMOhzwAithyPEicmLLr9fcz8Povu806oDfV0V5ICiY3ryWKfraJK
	P5ahR5DMTscyWpm3PXqES/GE3fz4yCY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-27-TF0IiOXKN2a03fX9vXzMmQ-1; Thu, 18 Jan 2024 08:23:59 -0500
X-MC-Unique: TF0IiOXKN2a03fX9vXzMmQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 30FD485A58A;
	Thu, 18 Jan 2024 13:23:59 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 27C1940C95AD;
	Thu, 18 Jan 2024 13:23:59 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id F3C8C30C1B8F; Thu, 18 Jan 2024 13:23:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id F07573FFC5;
	Thu, 18 Jan 2024 14:23:58 +0100 (CET)
Date: Thu, 18 Jan 2024 14:23:58 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Song Liu <song@kernel.org>
cc: Yu Kuai <yukuai3@huawei.com>, David Jeffery <djeffery@redhat.com>, 
    Li Nan <linan122@huawei.com>, dm-devel@lists.linux.dev, 
    linux-raid@vger.kernel.org, Mike Snitzer <msnitzer@redhat.com>, 
    Heinz Mauelshagen <heinzm@redhat.com>, 
    Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 3/7] md: test for MD_RECOVERY_DONE in stop_sync_thread
In-Reply-To: <CAPhsuW483DSEvgoT0c-Mo1gdpVKRRLkTxu+kuxYG6k-zew+FFA@mail.gmail.com>
Message-ID: <82e9b11f-e28-683-782d-aa5b8c62ff1a@redhat.com>
References: <e5e8afe2-e9a8-49a2-5ab0-958d4065c55e@redhat.com> <9801e40-8ac7-e225-6a71-309dcf9dc9aa@redhat.com> <CAPhsuW483DSEvgoT0c-Mo1gdpVKRRLkTxu+kuxYG6k-zew+FFA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="185210117-182897230-1705583836=:1547117"
Content-ID: <e9ddd0d-bc1-a9cd-a51b-4e8b467dc4@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--185210117-182897230-1705583836=:1547117
Content-Type: text/plain; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <17ed0fb-1b8a-54f6-a96-cd82f79325e1@redhat.com>



On Wed, 17 Jan 2024, Song Liu wrote:

> On Wed, Jan 17, 2024 at 10:19 AM Mikulas Patocka <mpatocka@redhat.com> wrote:
> >
> > stop_sync_thread sets MD_RECOVERY_INTR and then waits for
> > MD_RECOVERY_RUNNING to be cleared. However, md_do_sync will not clear
> > MD_RECOVERY_RUNNING when exiting, it will set MD_RECOVERY_DONE instead.
> >
> > So, we must wait for MD_RECOVERY_DONE to be set as well.
> >
> > This patch fixes a deadlock in the LVM2 test shell/integrity-caching.sh.
> 
> I am not able to reproduce the issue on 6.7 kernel with
> shell/integrity-caching.sh.
> I got:
> 
> VERBOSE=0 ./lib/runner \
>         --testdir . --outdir results \
>         --flavours ndev-vanilla --only shell/integrity-caching.sh --skip @
> running 1 tests
> ###       passed: [ndev-vanilla] shell/integrity-caching.sh  4:24.225
> 
> ### 1 tests: 1 passed, 0 skipped, 0 timed out, 0 warned, 0 failed   in  4:24.453
> make[1]: Leaving directory '/root/lvm2/test'
> 
> Do you see the issue every time with shell/integrity-caching.sh?

Hmm, that's strange - I get a hang with this stacktrace sometimes 
instantly, sometimes in 30 seconds. I test it on the current kernel from 
Linus' git - 052d534373b7ed33712a63d5e17b2b6cdbce84fd.

Mikulas

> Thanks,
> Song
> 
> >
> > sysrq: Show Blocked State
> > task:lvm             state:D stack:0     pid:11422  tgid:11422 ppid:1374   flags:0x00004002
> > Call Trace:
> >  <TASK>
> >  __schedule+0x228/0x570
> >  schedule+0x29/0xa0
> >  schedule_timeout+0x6a/0xd0
> >  ? timer_shutdown_sync+0x10/0x10
> >  stop_sync_thread+0x141/0x180 [md_mod]
> >  ? housekeeping_test_cpu+0x30/0x30
> >  __md_stop_writes+0x10/0xd0 [md_mod]
> >  md_stop+0x9/0x20 [md_mod]
> >  raid_dtr+0x1e/0x60 [dm_raid]
> >  dm_table_destroy+0x53/0x110 [dm_mod]
> >  __dm_destroy+0x10b/0x1e0 [dm_mod]
> >  ? table_clear+0xa0/0xa0 [dm_mod]
> >  dev_remove+0xd4/0x110 [dm_mod]
> >  ctl_ioctl+0x2e1/0x570 [dm_mod]
> >  dm_ctl_ioctl+0x5/0x10 [dm_mod]
> >  __x64_sys_ioctl+0x85/0xa0
> >  do_syscall_64+0x5d/0x1a0
> >  entry_SYSCALL_64_after_hwframe+0x46/0x4e
> >
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > Cc: stable@vger.kernel.org      # v6.7
> > Fixes: 130443d60b1b ("md: refactor idle/frozen_sync_thread() to fix deadlock")
> >
> > ---
> >  drivers/md/md.c |    4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > Index: linux-2.6/drivers/md/md.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/md/md.c
> > +++ linux-2.6/drivers/md/md.c
> > @@ -4881,7 +4881,8 @@ static void stop_sync_thread(struct mdde
> >         if (check_seq)
> >                 sync_seq = atomic_read(&mddev->sync_seq);
> >
> > -       if (!test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
> > +       if (!test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
> > +           test_bit(MD_RECOVERY_DONE, &mddev->recovery)) {
> >                 if (!locked)
> >                         mddev_unlock(mddev);
> >                 return;
> > @@ -4901,6 +4902,7 @@ retry:
> >
> >         if (!wait_event_timeout(resync_wait,
> >                    !test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
> > +                  test_bit(MD_RECOVERY_DONE, &mddev->recovery) ||
> >                    (check_seq && sync_seq != atomic_read(&mddev->sync_seq)),
> >                    HZ / 10))
> >                 goto retry;
> >
> 
--185210117-182897230-1705583836=:1547117--

