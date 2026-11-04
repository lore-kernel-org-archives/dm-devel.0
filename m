Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793778668;
	b=VgK+/GTv3ORejk7bExGALo/yza/OZG7oeZW4uWyPKRH48IaD6ksdW6QXFQrbvxJ5McM9
	 lh7Pm+NVrnmloDfRAAdYZ3m9WxzUmJu1yFjLB4eu8UG18S1NUP5VaLdYoKdgN7TqK5JN5
	 Y7tz4JvlgdMJSBIR+U68nFxQOBWf845Tb8SkxBa9B9gZixOJ5BEDiV3WGiHfWOxaSiEBf
	 OLKLhV3ShVD7+nE6Bu2du2UvznM+WZ4dvHqJ8K7w/YhcocPlTeZz7FptO/Vimj6+VkwWS
	 uOJIpOh+YnJW0A64QtE9zGTZZ4sb6WI4MrjEmT0e72DxzsRw+IgmR9UPkJjPcYaq4Dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793778668;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Rspamd-Queue-Id:X-Spam-Level:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:
	 X-Spam-Score;
	bh=+yif7O5YY/m9GKJ68FZTSi2nNVGcJFnRiA7uZiA3GN4=;
	b=eDBb1TgNAM3LAC1eerbQOtTq2OdCTxXPkXCy3txu4ZnSyufRHZM82CZWuNMzJBOXqOTE
	 tIOyJuoP4rx2hTIngyH+hPA0+q35wXCH2zucumUi0KJVB1FO3Eh1PvtUYyTolSNv5mo7j
	 nSgZGzKjO9d8DqaSaRKCBzrYb/uFOq6E7IeOmGEXNlcE/GvysYhMTa8GnezVBV0Q37SUR
	 cJ1rM/sBI5g39kSDMhoYnt5mFdJVWjwBjB7KEcuJ+l7Rz0x2t21TcyToJboVEQkh0vdkA
	 kNXP4nLk158ct6HbE+QBHNAQdEvESghuls+USmLTtVgwpFJVrOX3AcU20gET71DxFug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b="f8O2/PZj";
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=HxhrYFLj;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b="f8O2/PZj";
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=HxhrYFLj;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF4FA606A338
	for <dm-devel@lists.linux.dev>; Wed,  4 Nov 2026 07:51:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AF4FA606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=f8O2/PZj;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=HxhrYFLj;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=f8O2/PZj;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=HxhrYFLj
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F33671F7BA;
	Wed,  4 Nov 2026 07:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793778666; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+yif7O5YY/m9GKJ68FZTSi2nNVGcJFnRiA7uZiA3GN4=;
	b=f8O2/PZjPnLDjawnjI48LiJhxcIkZL0jNU+akd5GdNsu+WGFvioVugjLVrVoHIuCIzyHo6
	m5iQAetT0rTd7ft72JsFQv/IPtnTKueN97RbZ8NzDD196dtwnll0qwokw4DOj/hn7UcmUV
	gOnamleAJbEzUTK7cQD7TcdbX0ofnaw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793778666;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+yif7O5YY/m9GKJ68FZTSi2nNVGcJFnRiA7uZiA3GN4=;
	b=HxhrYFLjTaFnjsjmSrsnR1AUJTVkukbYKlEnrIVAkj51fHnv+N0M3OWebVX5Rg5hoLicRe
	H7vzjnlUkdSh0/BQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="f8O2/PZj";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=HxhrYFLj
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793778666; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+yif7O5YY/m9GKJ68FZTSi2nNVGcJFnRiA7uZiA3GN4=;
	b=f8O2/PZjPnLDjawnjI48LiJhxcIkZL0jNU+akd5GdNsu+WGFvioVugjLVrVoHIuCIzyHo6
	m5iQAetT0rTd7ft72JsFQv/IPtnTKueN97RbZ8NzDD196dtwnll0qwokw4DOj/hn7UcmUV
	gOnamleAJbEzUTK7cQD7TcdbX0ofnaw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793778666;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+yif7O5YY/m9GKJ68FZTSi2nNVGcJFnRiA7uZiA3GN4=;
	b=HxhrYFLjTaFnjsjmSrsnR1AUJTVkukbYKlEnrIVAkj51fHnv+N0M3OWebVX5Rg5hoLicRe
	H7vzjnlUkdSh0/BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8008A134A5;
	Wed,  4 Nov 2026 07:51:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id W64/Dunj6moxUQAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 04 Nov 2026 07:51:05 +0000
Message-ID: <371f34b6-0142-4aa6-a422-89d935523b5c@suse.de>
Date: Wed, 4 Nov 2026 08:51:04 +0100
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/2] dm zoned: back off when reclaim cannot make
 progress
To: Kyrylo Biryuk <illofspeed@gmail.com>, dm-devel@lists.linux.dev
Cc: mpatocka@redhat.com, snitzer@kernel.org, agk@redhat.com,
 bmarzins@redhat.com, dlemoal@kernel.org, hare@kernel.org,
 linux-kernel@vger.kernel.org
References: <20261103220438.510609-1-illofspeed@gmail.com>
 <20261103220438.510609-2-illofspeed@gmail.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20261103220438.510609-2-illofspeed@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F33671F7BA
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-13.50 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	XM_UA_NO_VERSION(0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_TO(0.00)[gmail.com,lists.linux.dev];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_TRACE(0.00)[suse.de:+];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -13.50

On 11/3/26 11:04 PM, Kyrylo Biryuk wrote:
> When a reclaim pass cannot make progress, dmz_reclaim_work() still ends
> with dmz_schedule_reclaim(). If the target is idle, dmz_should_reclaim()
> keeps returning true, the work is queued again with no delay and the
> worker spins on the same failing pass. This patch handles two such
> cases:
> 
>    - dmz_do_reclaim() fails with -ENOSPC because no free zone is
>      available to copy the data into, for example on a target without
>      cache zones that has no free sequential zone left. The next patch
>      also makes this the expected result when an idle target with cache
>      zones has random zones but no free sequential zone.
>    - dmz_do_reclaim() finds no zone it can lock for reclaim and returns
>      -EBUSY. Since commit 90a9b8693f1b ("dm zoned: reclaim random zones
>      when idle"), dmz_should_reclaim() returns true on an idle target
>      whenever the total number of random (and cache) zones is non-zero,
>      whether or not any of them holds data. Each pass then also runs
>      dmz_check_dev(), which checks every device for media events (a TEST
>      UNIT READY on SCSI disks).
> 
> The -EBUSY loop lasts as long as the target stays idle; it ends when a
> pass finishes while the target is busy and has enough free zones. On
> three 27 TB host-managed SATA drives used as md RAID5 members (7.2.10
> with the module built out of tree, all random zones free, target idle
> for 300 seconds, kprobes attached, two other drives on the controller
> being zero-filled), each member's SCSI device counted about 108,000
> requests per second with the stock module and the system used about
> 915 s of CPU time, against about 46 s with this series. libata completes
> TEST UNIT READY in software, so these counters do not measure commands
> sent to the drives; the cost is CPU time.
> 
> When a pass fails with -ENOSPC or -EBUSY, retrying at once is unlikely
> to make progress: re-arm the idle poll instead, so that reclaim is
> retried after DMZ_IDLE_PERIOD unless a zone allocation or a "reclaim"
> message queues it earlier. On a busy target, zone allocations can
> restart reclaim immediately when free space is low enough to require
> reclaim. Re-arming also keeps the poll running after a complete idle
> drain. The poll can still stop after a pass that ends while reclaim is
> not needed; that is unchanged.
> 
> Skip the device check for these two results: they normally mean that
> there is no zone to copy into or no zone to reclaim, not that a device
> failed, and the I/O paths check the devices themselves. Use
> queue_delayed_work() so that work an allocation has already queued is
> not postponed.
> 
> A pass that fails with an I/O error, for example on an unreadable block
> of a device that stays online, is still retried at once while the
> target is idle; this patch does not change that.
> 
> Tested on 7.4-rc1 with this patch and the next one, on three emulated
> host-managed drives (scsi_debug, 1 GiB, 32 MiB zones) each under
> dm-zoned as md RAID5 members, all random zones free and the target idle
> for 300 seconds. With the stock module each member's SCSI device counted
> about 70.2 million requests and the reclaim workers used 726 s of CPU.
> With this series: 75 requests per member, 30 passes per worker (one per
> DMZ_IDLE_PERIOD) and 0.08 s of CPU. Data written during the tests read
> back with matching checksums, and no kernel warnings were logged.
> 
> Fixes: 3b1a94c88b79 ("dm zoned: drive-managed zoned block device target")
> Fixes: 90a9b8693f1b ("dm zoned: reclaim random zones when idle")
> Cc: stable@vger.kernel.org
> Signed-off-by: Kyrylo Biryuk <illofspeed@gmail.com>
> ---
>   drivers/md/dm-zoned-reclaim.c | 10 ++++++++++
>   1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
> index c041413c729..077a8a50197 100644
> --- a/drivers/md/dm-zoned-reclaim.c
> +++ b/drivers/md/dm-zoned-reclaim.c
> @@ -537,6 +537,16 @@ static void dmz_reclaim_work(struct work_struct *work)
>   		dmz_nr_rnd_zones(zmd, zrc->dev_idx));
>   
>   	ret = dmz_do_reclaim(zrc);
> +	if (ret == -ENOSPC || ret == -EBUSY) {
> +		/*
> +		 * No zone to copy into (-ENOSPC) or no zone to reclaim
> +		 * (-EBUSY): retrying at once cannot make progress and would
> +		 * spin. Poll again after the idle period instead, without
> +		 * postponing work that an allocation has already queued.
> +		 */
> +		queue_delayed_work(zrc->wq, &zrc->work, DMZ_IDLE_PERIOD);
> +		return;
> +	}
>   	if (ret && ret != -EINTR) {
>   		if (!dmz_check_dev(zmd))
>   			return;

Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
