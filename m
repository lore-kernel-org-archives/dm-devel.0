Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1272C1A5
	for <dm-devel@lists.linux.dev>; Wed, 27 Mar 2024 07:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711524828; cv=none; b=CX8fjDuTALci0pZsxUkUEnf9iX9CHWy1EBDnL5uaCP7nxL8J/Hqae3cWWYRjDfTfIpoKmwHSDKTIescoCQzZ6BdwnQDDx4/4lzTzDIGE1rmv743vb5VOffBGye6Xn2QPNviiw2tWizh0NjbACH/MWzzNb8vVomii8VeiU0dPfK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711524828; c=relaxed/simple;
	bh=uWZhZCTjCdv9BRCYQRPuFbmFx5dG84ZkNjHyRZXSqbk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a5g3Cu7jk+IhJ+NZjG2YXGYauJ+5pwwAGUJ6W3ZOH/1N9Fk5e5/eekFwUyuN26Prl7SQmKpvMwRi5o6GUeXdk+sXMMfpCTo7MyxGmJBXi2P/YyOrjkWipvF7JFgDgSuLXyxUx8c+9P+lq8vApeOjxJIImvqBp0xdFCS6yAgUgsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=DTn3SWS3; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=tR5/67VI; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=DTn3SWS3; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=tR5/67VI; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="DTn3SWS3";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="tR5/67VI";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="DTn3SWS3";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="tR5/67VI"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CAEA85F9F6;
	Wed, 27 Mar 2024 07:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1711524815; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N1yBeqz2rtXiSTTozIUNCVIH2ZVOt0/ZQZ9ypm9J+oA=;
	b=DTn3SWS3OI5Q20Nrvj/SaLZK3MC5cRstxSgF6SdQvgLgSoMMDUdQp9RV1z7Kb2jCUd7mmB
	1qk/842uWhf8Do+VZqK7su/nJXZReaR6M8L9Hbrr2YK+9cxFUB799NvpioGyksgVCxHi5a
	CPTGWtzs+hJurTPn9lKie//NlMYk3fY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1711524815;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N1yBeqz2rtXiSTTozIUNCVIH2ZVOt0/ZQZ9ypm9J+oA=;
	b=tR5/67VIXalsCiY1I+Om4aexP/A9Wzh6Y9CTQM6PSBTGKVn+IfDjtBDLsJbNmEwiddJNFc
	EE+u7iDKwW3g8dCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1711524815; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N1yBeqz2rtXiSTTozIUNCVIH2ZVOt0/ZQZ9ypm9J+oA=;
	b=DTn3SWS3OI5Q20Nrvj/SaLZK3MC5cRstxSgF6SdQvgLgSoMMDUdQp9RV1z7Kb2jCUd7mmB
	1qk/842uWhf8Do+VZqK7su/nJXZReaR6M8L9Hbrr2YK+9cxFUB799NvpioGyksgVCxHi5a
	CPTGWtzs+hJurTPn9lKie//NlMYk3fY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1711524815;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N1yBeqz2rtXiSTTozIUNCVIH2ZVOt0/ZQZ9ypm9J+oA=;
	b=tR5/67VIXalsCiY1I+Om4aexP/A9Wzh6Y9CTQM6PSBTGKVn+IfDjtBDLsJbNmEwiddJNFc
	EE+u7iDKwW3g8dCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E8C341369F;
	Wed, 27 Mar 2024 07:33:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CGHyNc7LA2ZKewAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 27 Mar 2024 07:33:34 +0000
Message-ID: <e10d2389-dd24-4768-95ed-290d773365f7@suse.de>
Date: Wed, 27 Mar 2024 08:33:33 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 27/28] block: Do not force select mq-deadline with
 CONFIG_BLK_DEV_ZONED
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240325044452.3125418-1-dlemoal@kernel.org>
 <20240325044452.3125418-28-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240325044452.3125418-28-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.58
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.58 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BAYES_HAM(-0.08)[63.11%];
	 MIME_GOOD(-0.10)[text/plain];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 DWL_DNSWL_LOW(-1.00)[suse.de:dkim];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 DKIM_TRACE(0.00)[suse.de:+];
	 MX_GOOD(-0.01)[];
	 RCPT_COUNT_SEVEN(0.00)[8];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[];
	 RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from]
X-Spam-Level: 
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DTn3SWS3;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="tR5/67VI"
X-Rspamd-Queue-Id: CAEA85F9F6

On 3/25/24 05:44, Damien Le Moal wrote:
> Now that zone block device write ordering control does not depend
> anymore on mq-deadline and zone write locking, there is no need to force
> select the mq-deadline scheduler when CONFIG_BLK_DEV_ZONED is enabled.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   block/Kconfig | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/block/Kconfig b/block/Kconfig
> index 9f647149fbee..d47398ae9824 100644
> --- a/block/Kconfig
> +++ b/block/Kconfig
> @@ -100,7 +100,6 @@ config BLK_DEV_WRITE_MOUNTED
>   
>   config BLK_DEV_ZONED
>   	bool "Zoned block device support"
> -	select MQ_IOSCHED_DEADLINE
>   	help
>   	Block layer zoned block device support. This option enables
>   	support for ZAC/ZBC/ZNS host-managed and host-aware zoned block

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

