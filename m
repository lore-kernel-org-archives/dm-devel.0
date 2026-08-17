Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912B81EFF93
	for <dm-devel@lists.linux.dev>; Mon, 17 Aug 2026 15:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979472; cv=none; b=TfCLwxWuQDRKhAjA9hxpKqIbG/D1C53AkThRuGt2Z0I9ncZ/iGH6cG3r9jSPYbPdq9u6dDHTIW6SKaxmPQYLzTey+YyjaTqnVpxiew5WnG2chmSkRi2DRW84qigPJrWGW3vcqkX/AWFu+lCqsgEo8GG+iKEMeF9/M5ThzL3u1Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979472; c=relaxed/simple;
	bh=lC44h358KKqPJKcEW3VOdtRy6RI6E4uSmjn2mHmMWRg=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=PD79GkchZcECONmMjJhQQHuy81/ECWq901C0F0NBiF2QSQyoPU8IKH4Vw3+5sp0Z1aCHgwMjkFTZoiX/up7W1/swPUOcVvQW3LrU3psINHwqhp4MMmrF+t9RCN2kByDHUVlhCcQ+qGxdHuA42qfiwJmwNsdogGBtBePa4EWtM60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gRFFQHTn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gRFFQHTn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786979470;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3j7GjjnJLm+3yZe3wo74OslhkRrLShj4w0FFB1aqxs8=;
	b=gRFFQHTn6RmcPyYbyFSSd51MQDvjqyMb2Eango31i9k8sn50zPgzIxXfxbeei7DOgX3CzP
	xlyQLZcseAeWAkI3njJmiindGWpd0BFNqTQL8omVGjYV6lTf+KdY27VFoP6U2H6NGcS+wT
	aHy5soLPGgwRhWVMfIGMZ83/VPdqZMY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-624-YzY2jE9tPkeVtdkJdfGHcQ-1; Mon,
 17 Aug 2026 11:11:00 -0400
X-MC-Unique: YzY2jE9tPkeVtdkJdfGHcQ-1
X-Mimecast-MFC-AGG-ID: YzY2jE9tPkeVtdkJdfGHcQ_1786979459
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C674E180034F;
	Mon, 17 Aug 2026 15:10:58 +0000 (UTC)
Received: from [10.44.48.124] (unknown [10.44.48.124])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 89B541953944;
	Mon, 17 Aug 2026 15:10:56 +0000 (UTC)
Date: Mon, 17 Aug 2026 17:10:53 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Yu Junzhe <junzheyu1@gmail.com>
cc: Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, Alasdair Kergon <agk@redhat.com>, 
    dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [BUG] dm-integrity: mode R resume NULL deref when DIRTY_BITMAP
 is set
In-Reply-To: <20260817100605.292-1-junzheyu1@gmail.com>
Message-ID: <1b21bd73-5585-11c9-ad26-d206de6503d0@redhat.com>
References: <20260817100605.292-1-junzheyu1@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: oGQWH_dxHtkpCrt2qkT-SclPp6L5cWGKWgfctVcoXqg_1786979459
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Mon, 17 Aug 2026, Yu Junzhe wrote:

> Hello,
> 
> I am reporting a null-pointer dereference in dm-integrity resume: recovery
> mode R skips journal allocation, but dm_integrity_resume() still issues
> journal I/O when the on-disk superblock has SB_FLAG_DIRTY_BITMAP.
> 
> Summary
> =======
> 
> create_journal() runs only when mode != 'R', so ic->journal stays NULL.
> Resume treats DIRTY_BITMAP as "journal pages hold a bitmap" and calls
> rw_journal_sectors() before any journal/mode check:
> 
>   if (ic->sb->flags & cpu_to_le32(SB_FLAG_DIRTY_BITMAP)) {
>       rw_journal_sectors(ic, REQ_OP_READ, ...);  /* uses ic->journal[] */
> 
> rw_journal_sectors() then passes that NULL page list into dm_io():
> 
>   io_req.mem.type = DM_IO_PAGE_LIST;
>   io_req.mem.ptr.pl = &ic->journal[pl_index];  /* NULL in mode R */
> 
> list_get_page() does *p = pl->page with pl == NULL (KASAN range [0x8-0xf]).
> 
> DIRTY_BITMAP is set while bitmap mode (B) is active and is cleared on a
> clean postsuspend. It remains on disk after an unclean stop of mode B
> (crash / power loss). Reloading that device in recovery mode R is a
> documented recovery path and hits this bug.
> 
> Affected
> ========
> 
> - Confirmed on Linux 6.6.144 (da47cbc254661aa66d61ef061485a7080305c4be),
>   KASAN guest
> - Still present on torvalds/linux master as of 2026-08-17: resume still
>   calls rw_journal_sectors() under DIRTY_BITMAP with no journal / mode-R
>   guard
> - Files: drivers/md/dm-integrity.c
> - Config: CONFIG_DM=y, CONFIG_DM_INTEGRITY=y (KASAN for the report)
> 
> Crash excerpt (from minimized PoC)
> ==================================
> 
> KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
> CPU: 0 PID: 234 Comm: repro Not tainted 6.6.144 #15
> RIP: 0010:list_get_page+0x7e/0x150
> Call Trace:
>  <TASK>
>   dispatch_io
>   sync_io
>   dm_io
>   rw_journal_sectors
>   dm_integrity_resume
>   dm_table_resume_targets
>   __dm_resume
>   dm_resume
>   dev_suspend
>   ctl_ioctl
>   dm_ctl_ioctl
>   __x64_sys_ioctl
>  </TASK>
> Kernel panic - not syncing: Fatal exception
> 
> Full oops and a self-contained Docker/QEMU reproducer (poc.c + KASAN
> guest) are available on request.
> 
> I am happy to test patches or send the reproducer package.
> 
> Thanks,
> Yu Junzhe
> FuzzAnything <fuzzanything@gmail.com>

Hi

Does this patch fix it?

Mikulas


dm-integrity: fix NULL pointer dereference when the 'R' flag is used

If the dm-integrity device has the SB_FLAG_DIRTY_BITMAP flag set and the
user activates the device in the 'R' mode, a crash in dm_integrity_resume
happens because the function attempts to read the journal containing the
bitmap.

This patch makes dm-integrity skip any writes to the device in
dm_integrity_resume if the device is activated in the 'R' mode.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-integrity.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2026-08-10 14:00:08.000000000 +0200
+++ linux-2.6/drivers/md/dm-integrity.c	2026-08-17 17:01:02.000000000 +0200
@@ -3875,6 +3875,10 @@ static void dm_integrity_resume(struct d
 	r = sync_rw_sb(ic, REQ_OP_READ);
 	if (r)
 		dm_integrity_io_error(ic, "reading superblock", r);
+
+	if (ic->mode == 'R')
+		goto skip_writes;
+
 	if ((ic->sb->flags & flags) != flags) {
 		ic->sb->flags |= flags;
 		r = sync_rw_sb(ic, REQ_OP_WRITE | REQ_FUA);
@@ -3984,6 +3988,7 @@ static void dm_integrity_resume(struct d
 		}
 	}
 
+skip_writes:
 	ic->reboot_notifier.notifier_call = dm_integrity_reboot;
 	ic->reboot_notifier.next = NULL;
 	ic->reboot_notifier.priority = INT_MAX - 1;	/* be notified after md and before hardware drivers */

