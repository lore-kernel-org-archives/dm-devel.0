Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C44320E
	for <dm-devel@lists.linux.dev>; Thu,  2 May 2024 06:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714630181; cv=none; b=mSmRUF4+huK4GqgdHGZ5KKvcP307sRWXz8Fn7IyDGIiJ2OYmQWjZf9tSq8j67rq8fUdv2GkaeKbnsLX7Ub8NiY0LA7bOasJnOoH/nVajUC734H2z8CFnTFj+6g18fjmhbSz3GnoQkQ9iOrTCv1lHmlqFaW3BtEjxW5S8kRLCGFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714630181; c=relaxed/simple;
	bh=fpfShQXJ40pm+qriStynSWpVs7uewn+tf7VvsMRGY/E=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=p/CqYsrIpuSvCvcvHPXiI9XCA0sSozWfXHjdKDu5gAVuksLwbbFnr1eWSuC5oiibSddufjGmyg4ax3Vb7b0byABGmTYqYL0/oeqi1+e9EDT20XCukHMBi3bINib5cUcG746gG1RkGAgcaif6cBlpsvGldv37yEfY3CAaWO/ZPrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=FjX9u51a; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=yokoIx7i; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=FjX9u51a; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=yokoIx7i; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="FjX9u51a";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="yokoIx7i";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="FjX9u51a";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="yokoIx7i"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4068B1FBA0;
	Thu,  2 May 2024 06:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1714630178; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Vf/1VrRxXN4RjOYW6VNcy8fjdHpK1GmeU9mzi8q4TBw=;
	b=FjX9u51aqgSB/p6la2q9JNqzismSW56L0sLJ9R9ii/JfBbZKPN8p5dOgR2ZRyCYuMNrvgD
	1Kv164UZ3r/sFVJoaXGyTC4pay3kXXeN6RVmAr2O3nJJMvIya4/DVHENu5d2nPjJiA9TcP
	TDxXu/mILmVpdpLl94CtTfKMN9YnOlM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1714630178;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Vf/1VrRxXN4RjOYW6VNcy8fjdHpK1GmeU9mzi8q4TBw=;
	b=yokoIx7iIlqd/5HIHI7Bh4GqpjBdTg1W7VTx2D3Y2T3ryp37QWffaAjw4uAxDWJT4btEyP
	hLBIHlBaZxiQKTCw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1714630178; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Vf/1VrRxXN4RjOYW6VNcy8fjdHpK1GmeU9mzi8q4TBw=;
	b=FjX9u51aqgSB/p6la2q9JNqzismSW56L0sLJ9R9ii/JfBbZKPN8p5dOgR2ZRyCYuMNrvgD
	1Kv164UZ3r/sFVJoaXGyTC4pay3kXXeN6RVmAr2O3nJJMvIya4/DVHENu5d2nPjJiA9TcP
	TDxXu/mILmVpdpLl94CtTfKMN9YnOlM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1714630178;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Vf/1VrRxXN4RjOYW6VNcy8fjdHpK1GmeU9mzi8q4TBw=;
	b=yokoIx7iIlqd/5HIHI7Bh4GqpjBdTg1W7VTx2D3Y2T3ryp37QWffaAjw4uAxDWJT4btEyP
	hLBIHlBaZxiQKTCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EBF6D13957;
	Thu,  2 May 2024 06:09:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FjnQNyEuM2ZMNgAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 02 May 2024 06:09:37 +0000
Message-ID: <751efc92-2081-41c0-8007-c73f51fcf87e@suse.de>
Date: Thu, 2 May 2024 08:09:36 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/14] block: Do not remove zone write plugs still in
 use
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@redhat.com>
References: <20240501110907.96950-1-dlemoal@kernel.org>
 <20240501110907.96950-8-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240501110907.96950-8-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -4.29
X-Spam-Level: 
X-Spamd-Result: default: False [-4.29 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]

On 5/1/24 13:09, Damien Le Moal wrote:
> Large write BIOs that span a zone boundary are split in
> blk_mq_submit_bio() before being passed to blk_zone_plug_bio() for zone
> write plugging. Such split BIO will be chained with one fragment
> targeting one zone and the remainder of the BIO targeting the next
> zone. The two BIOs can be executed in parallel, without a predetermine
> order relative to eachother and their completion may be reversed: the

each other

> remainder first completing and the first fragment then completing. In
> such case, bio_endio() will not immediately execute
> blk_zone_write_plug_bio_endio() for the parent BIO (the remainder of the
> split BIO) as the BIOs are chained. blk_zone_write_plug_bio_endio() for
> the parent BIO will be executed only once the first fragment completes.
> 
> In the case of a device with small zones and very large BIOs, uch

such

> completion pattern can lead to disk_should_remove_zone_wplug() to return
> true for the zone of the parent BIO when the parent BIO request
> completes and blk_zone_write_plug_complete_request() is executed. This
> triggers the removal of the zone write plug from the hash table using
> disk_remove_zone_wplug(). With the zone write plug of the parent BIO
> missing, the call to disk_get_zone_wplug() in
> blk_zone_write_plug_bio_endio() returns NULL and triggers a warning.
> 
> This patterns can be recreated fairly easily using a scsi_debug device
> with small zone and btrfs. E.g.
> 
> modprobe scsi_debug delay=0 dev_size_mb=1024 sector_size=4096 \
> 	zbc=host-managed zone_cap_mb=3 zone_nr_conv=0 zone_size_mb=4
> mkfs.btrfs -f -O zoned /dev/sda
> mount -t btrfs /dev/sda /mnt
> fio --name=wrtest --rw=randwrite --direct=1 --ioengine=libaio \
> 	--bs=4k --iodepth=16 --size=1M --directory=/mnt --time_based \
> 	--runtime=10
> umount /dev/sda
> 
> Will result in the warning:
> 
> [   29.035538] WARNING: CPU: 3 PID: 37 at block/blk-zoned.c:1207 blk_zone_write_plug_bio_endio+0xee/0x1e0
> ...
> [   29.058682] Call Trace:
> [   29.059095]  <TASK>
> [   29.059473]  ? __warn+0x80/0x120
> [   29.059983]  ? blk_zone_write_plug_bio_endio+0xee/0x1e0
> [   29.060728]  ? report_bug+0x160/0x190
> [   29.061283]  ? handle_bug+0x36/0x70
> [   29.061830]  ? exc_invalid_op+0x17/0x60
> [   29.062399]  ? asm_exc_invalid_op+0x1a/0x20
> [   29.063025]  ? blk_zone_write_plug_bio_endio+0xee/0x1e0
> [   29.063760]  bio_endio+0xb7/0x150
> [   29.064280]  btrfs_clone_write_end_io+0x2b/0x60 [btrfs]
> [   29.065049]  blk_update_request+0x17c/0x500
> [   29.065666]  scsi_end_request+0x27/0x1a0 [scsi_mod]
> [   29.066356]  scsi_io_completion+0x5b/0x690 [scsi_mod]
> [   29.067077]  blk_complete_reqs+0x3a/0x50
> [   29.067692]  __do_softirq+0xcf/0x2b3
> [   29.068248]  ? sort_range+0x20/0x20
> [   29.068791]  run_ksoftirqd+0x1c/0x30
> [   29.069339]  smpboot_thread_fn+0xcc/0x1b0
> [   29.069936]  kthread+0xcf/0x100
> [   29.070438]  ? kthread_complete_and_exit+0x20/0x20
> [   29.071314]  ret_from_fork+0x31/0x50
> [   29.071873]  ? kthread_complete_and_exit+0x20/0x20
> [   29.072563]  ret_from_fork_asm+0x11/0x20
> [   29.073146]  </TASK>
> 
> either when fio executes or when unmount is executed.
> 
> Fix this by modifying disk_should_remove_zone_wplug() to check that the
> reference count to a zone write plug is not larger than 2, that is, that
> the only references left on the zone are the caller held reference
> (blk_zone_write_plug_complete_request()) and the initial extra reference
> for the zone write plug taken when it was initialized (and that is
> dropped when the zone write plug is removed from the hash table).
> 
> To be consistent with this change, make sure to drop the request or BIO
> held reference to the zone write plug before calling
> disk_zone_wplug_unplug_bio(). All references are also dropped using
> disk_put_zone_wplug() instead of atomic_dec() to ensure that the zone
> write plug is freed if it needs to be.
> 
> Comments are also improved to clarify zone write plugs reference
> handling.
> 
> Reported-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> Fixes: dd291d77cc90 ("block: Introduce zone write plugging")
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   block/blk-zoned.c | 39 +++++++++++++++++++++++++++++++--------
>   1 file changed, 31 insertions(+), 8 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

