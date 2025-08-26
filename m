Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A767221F32
	for <dm-devel@lists.linux.dev>; Tue, 26 Aug 2025 06:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756188376; cv=none; b=TeJ2d7cmLlIiEe6uzS83flzZjlePcy3Iph/zJBLFEhX/NC/bUdzTX8AgJmYk352uaTODQheJTJEqUVcE0PxQx/l0n6LpKLo31YS3eG1a8gR8h0HZ9KzU8ItaA7rPxKSSLBVbWSu/1ZcYueQu3lTnOXZ+2e5TKEsws9vbldXpYd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756188376; c=relaxed/simple;
	bh=Bjn3Q5mioR0mKd8cd5K6/uoJo0hdI1E8I96JqvgmV1A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fJGu6cWfSmMjl/LL9C8c9Hf5O7ZYgmiMcf9b+Y01H6nkmY1gLtTnh1onaR6S6Cpa4/X92bhVIDncCR8wYNiMNMLNmX0XPEibIVAua9kAhSjtbZOrYgTn8BEst1wsHhZ+74ChCzqsHaTwP3x2lLD3YXpV3apMEhln0hsZ9izrVgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Mu0TawI9; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=OI1vKBo/; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Mu0TawI9; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=OI1vKBo/; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Mu0TawI9";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="OI1vKBo/";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Mu0TawI9";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="OI1vKBo/"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7A7A0216E2;
	Tue, 26 Aug 2025 06:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1756188371; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mlHDzWHbh5pu28wG1JnUzQl/itHVd3TY536vPNcvyR8=;
	b=Mu0TawI9QS4Pm4ODdJUA+HECDvs7hv41TXh+ugixsvZpd9SNP2sKKM6DTHXzE3ma5VIFjZ
	GLi2eQJI2YCAeXdRVQDHWyYoYG+A5oqxQb3NetYt1m5D8Xf0qGed5WKkY+7JZv3xG4n2zD
	9+lQ+kitLhCFVgE7W9MZbN5LhXqxkVw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1756188371;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mlHDzWHbh5pu28wG1JnUzQl/itHVd3TY536vPNcvyR8=;
	b=OI1vKBo/58c0apsw+npz+qEmEDXDhY1iqA+UZLbVLYeK7ch1eIU3j1GrSXmTV6WzHoMjVM
	ccF/idJlmAPrW3Aw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Mu0TawI9;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="OI1vKBo/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1756188371; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mlHDzWHbh5pu28wG1JnUzQl/itHVd3TY536vPNcvyR8=;
	b=Mu0TawI9QS4Pm4ODdJUA+HECDvs7hv41TXh+ugixsvZpd9SNP2sKKM6DTHXzE3ma5VIFjZ
	GLi2eQJI2YCAeXdRVQDHWyYoYG+A5oqxQb3NetYt1m5D8Xf0qGed5WKkY+7JZv3xG4n2zD
	9+lQ+kitLhCFVgE7W9MZbN5LhXqxkVw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1756188371;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mlHDzWHbh5pu28wG1JnUzQl/itHVd3TY536vPNcvyR8=;
	b=OI1vKBo/58c0apsw+npz+qEmEDXDhY1iqA+UZLbVLYeK7ch1eIU3j1GrSXmTV6WzHoMjVM
	ccF/idJlmAPrW3Aw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4AAF713A5A;
	Tue, 26 Aug 2025 06:06:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Q25MENNOrWh1JQAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 26 Aug 2025 06:06:11 +0000
Message-ID: <75117127-bcb9-4568-aa6b-c4d628388479@suse.de>
Date: Tue, 26 Aug 2025 08:06:10 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/15] Improve mpathpersist's unavailable path handling
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 device-mapper development <dm-devel@lists.linux.dev>,
 Martin Wilck <Martin.Wilck@suse.com>
References: <20250710181100.3997759-1-bmarzins@redhat.com>
 <592b5f59-cc88-4315-8a67-95421cdb3545@suse.de> <aKy_1vEm47lEDEGa@redhat.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <aKy_1vEm47lEDEGa@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_DN_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Queue-Id: 7A7A0216E2
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.51

On 8/25/25 21:56, Benjamin Marzinski wrote:
> On Mon, Aug 25, 2025 at 08:38:38AM +0200, Hannes Reinecke wrote:
>> On 7/10/25 20:10, Benjamin Marzinski wrote:
[ .. ]>>>
>>> This patchset deals with both of these problems. libmpathpersist always
>>> had code to handle releasing a reservation held by an unavailable path,
>>> but the existing method is broken. It relies on poorly supported
>>> optional features of SCSI Persistent Reservations: the READ FULL STATUS
>>> command and specifying Initiator Ports with the REGISTER command
>>> (SIP_C). Also, fixing its current issues would additionally require
>>> supporting the All Target Ports option (ATP_C). This existing workaround
>>> has been redesigned to use the PREEMPT command instead. Key changes
>>> where the path holding the reservation is unavailable were not
>>> previously handled by libmpathpersist. This patchset also handles them
>>> using the PREEMPT command.
>>>
>> I wish we had a testcase for all of that. Persistent reservation
>> handling is tricky at the best of times, but throwing in multipathing
>> it really gets into the arcane knowledge area.
>> Ben, do you have something which we could turn into some blktest
>> scenarios?
> 
> It wouldn't be hard to use the LIO target to setup these scenarios, and
> verify that mpathpersist is handling them. The bigger issue is that I'm
> still occassionally running into new ones. I've got a couple more
> patches to send to deal with them, but what this actually wants (and
> what I plan to write after I think I've handled all the issues) is a
> test that will write to the devices while randomly failing and restoring
> paths and doing various PR commands, both to check that commands succeed
> and fail when expected given the state of the devices when they were
> run, and that we don't end up with active paths that either don't have
> reservations when they should, or do have them when they shouldn't.
> 
> I can look at adding something like that to blktest.
> 
That would be awesome. I am looking into updating/modifying PR handling
in qemu by using the in-kernel generic PR support, but to validate that
testcases would be really helpful.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
