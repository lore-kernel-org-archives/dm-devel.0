Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E5E1E535
	for <dm-devel@lists.linux.dev>; Mon, 15 Apr 2024 16:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713198162; cv=none; b=GIInFbO4etORpswTPMpdl7cVlDPywVQYCFG1tzHgPgaLhyhFErIRGVamArG/90YFDmduo+VU0+Dw4pr01PbqL87I06b8f2S/WViXyByL58Uwt/sNyKdhoBV4mW1BgTmITRyRw0nfM1Zm8JoB5sTFUBkMGF+HE9TFkRLelm1fA4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713198162; c=relaxed/simple;
	bh=EUlXy7Fh5i8h5SER+37o/HeuER5g36qmREkM/a/xz+M=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ZP19zbkz3xdlZAR9xtcj5h9Jq1Ki+xuCvtzT8TMQDgSd3pVf10mNNfU59rFghAGd/x01PVmGAwans9YP6gDuHYkbiyxuESMuvnQQesYOZ4C2ozT5ZEVZdPPeMhcxtD7vBEvNgQ9PFFGcQjML7vSQj6RzXKFEdtvUbV3H7RWqrxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dqofwslT; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dqofwslT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=XlQpLTsHUmN/qIBB66kQipCBSEHdAtdb82ub+5eu+tk=; b=dqofwslTJVLpnFLfpGv7vQgZkX
	pnHTGDVygOhcIAYqVY45mU+wYgrmNAMZtb03Qm4+V184wSRH93QXf/mxrT6PfDQfaogOxC56dQ3f7
	cRm+YugWj7Eaa6U68rNK+JTMpE+SzyOEQNAwDarggfWdah9Bz6CVCVEXR+Ic0nbutsD7JBFmemD+v
	p3SosJ8rdCoWa5si+aZ52L/qij3dnhuHcW/YkZVedmgi9Pmd1dPRc9VI0mZr+M5PjwoOcZ6WTiDZD
	/H4aISAXYWvOK//Re+bf82Yu2qSZcPi+latErhikkPS+mduoiZ+QLZJmg8sHWTBxx8svBj86jS5oF
	ONwuUzWQ==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rwP6N-0000000G3ez-0giA
	for dm-devel@lists.linux.dev;
	Mon, 15 Apr 2024 16:22:39 +0000
Date: Mon, 15 Apr 2024 17:22:39 +0100
From: Matthew Wilcox <willy@infradead.org>
To: dm-devel@lists.linux.dev
Subject: next-20240412 warning in dm-bio-prison-v1.c
Message-ID: <Zh1UT__gACBnpfSd@casper.infradead.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Just got this splat running generic/347 with XFS on top.

------------[ cut here ]------------
WARNING: CPU: 0 PID: 1188676 at drivers/md/dm-bio-prison-v1.c:128 dm_cell_key_has_valid_range+0x3e/0x50
Modules linked in: crct10dif_generic crct10dif_common [last unloaded: crc_t10dif]
CPU: 0 PID: 1188676 Comm: kworker/u64:3 Not tainted 6.9.0-rc3-next-20240412-ktest-00036-g89ba24a9aade-dirty #13
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Workqueue: dm-thin do_worker
RIP: 0010:dm_cell_key_has_valid_range+0x3e/0x50
Code: e5 48 89 c1 48 29 d1 48 81 f9 00 04 00 00 77 1a 48 83 e8 01 48 c1 ea 0a b9 01 00 00 00 48 c1 e8 0a 48 39 c2 75 0c 89 c8 5d c3 <0f> 0b 31 c9 5d 89 c8 c3 0f 0b 31 c9 eb ee 0f 1f 40 00 f3 0f 1e fa
RSP: 0018:ffff888102453d28 EFLAGS: 00010206
RAX: 0000000000000fff RBX: 0000000000000000 RCX: 0000000000000fff
RDX: 0000000000000000 RSI: 0000000000000fff RDI: ffff888102453d40
RBP: ffff888102453d28 R08: ffff88810f897d00 R09: ff6d6867732c6c63
R10: 0000000000000018 R11: fefefefefefefeff R12: ffff88810f897c80
R13: ffff88813e0280b8 R14: 0000000000000fff R15: ffff88813e0280b8
FS:  0000000000000000(0000) GS:ffff888179600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f9e1e6f27d0 CR3: 000000000202a000 CR4: 0000000000750eb0
PKRU: 55555554
Call Trace:
 <TASK>
 ? show_regs+0x64/0x70
 ? __warn+0x88/0x120
 ? dm_cell_key_has_valid_range+0x3e/0x50
 ? report_bug+0x15d/0x180
 ? handle_bug+0x3e/0x70
 ? exc_invalid_op+0x1c/0x70
 ? asm_exc_invalid_op+0x1f/0x30
 ? dm_cell_key_has_valid_range+0x3e/0x50
 process_discard_bio+0xa7/0x180
 do_worker+0x81d/0xb90
 process_one_work+0x135/0x2e0
 worker_thread+0x2e8/0x420
 ? flush_delayed_work+0x50/0x50
 kthread+0xd5/0x100
 ? kthread_park+0xa0/0xa0
 ret_from_fork+0x3a/0x60
 ? kthread_park+0xa0/0xa0
 ret_from_fork_asm+0x11/0x20
 </TASK>
---[ end trace 0000000000000000 ]---

Hope that's useful.
