Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4DAB23CE
	for <dm-devel@lists.linux.dev>; Mon, 25 Aug 2025 06:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756104297; cv=none; b=tepqEyTCbY2mKwTOyoYG0HH4ybAE18WlqK3UP83r6pL84Dl8PDf2fVm/RDY5QArRLBkTGQNRzRpx3cjPupjeUDyf32jI8sjl5+/0VTCGahFFUoNNoBWkjuVXmULpLxLDhkx6Iy5IzmwNcbbjsoTNBr/0kvgq0ficWIB9qtBOlyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756104297; c=relaxed/simple;
	bh=7QnCCgVncqsLEqm/9MK0FvOhj3qgsLUpUdgJ37P2JWE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mdaGOezI3enq09LNhMvl7dqmbpIMsqAQ4JGEYfYjou02whktjzS9PLGvaruEkYsvKsyg9JTYAi23wwO2ODqbwDZzfiAyJiv+bUoo/ft5GZwO9PgUvcqTYsN8w7AlRdDeCIiYPch9uF038SL3ONS2hh9gJPnsVpYUDBt+DNMgCB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ab97OOdq; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=aUsivKBC; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ab97OOdq; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=aUsivKBC; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ab97OOdq";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="aUsivKBC";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ab97OOdq";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="aUsivKBC"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 072121F74B;
	Mon, 25 Aug 2025 06:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1756103919; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=25ZwrS3JbvWRa8tCl4Tcthb45ur84qKw1slhT7636wM=;
	b=ab97OOdqCaHhbH6kaHzM0P0TstcjwERUY2r2chCtDX7gS7sfniHO1lM70wtfzmmaOFF9Ig
	Nd79gMHvII8DbcSq6E1Cqwl5k81ShSKhuTB8s0oV0Jgpi8ZmVS2YaQv8rwsf+iwxg996O/
	pL29Ow4RJJUzwiRv56tFO1ZSwEZxqA4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1756103919;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=25ZwrS3JbvWRa8tCl4Tcthb45ur84qKw1slhT7636wM=;
	b=aUsivKBCw20V9ri6L0cQON05FRd8V6dvL9ivTXqgYA1tH81O3JVhV3GzIZSL26fdwPkgy7
	BRPNhfKdentQ+LAA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ab97OOdq;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=aUsivKBC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1756103919; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=25ZwrS3JbvWRa8tCl4Tcthb45ur84qKw1slhT7636wM=;
	b=ab97OOdqCaHhbH6kaHzM0P0TstcjwERUY2r2chCtDX7gS7sfniHO1lM70wtfzmmaOFF9Ig
	Nd79gMHvII8DbcSq6E1Cqwl5k81ShSKhuTB8s0oV0Jgpi8ZmVS2YaQv8rwsf+iwxg996O/
	pL29Ow4RJJUzwiRv56tFO1ZSwEZxqA4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1756103919;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=25ZwrS3JbvWRa8tCl4Tcthb45ur84qKw1slhT7636wM=;
	b=aUsivKBCw20V9ri6L0cQON05FRd8V6dvL9ivTXqgYA1tH81O3JVhV3GzIZSL26fdwPkgy7
	BRPNhfKdentQ+LAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BB127136DB;
	Mon, 25 Aug 2025 06:38:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id I8eFK+4ErGhwIwAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 25 Aug 2025 06:38:38 +0000
Message-ID: <592b5f59-cc88-4315-8a67-95421cdb3545@suse.de>
Date: Mon, 25 Aug 2025 08:38:38 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/15] Improve mpathpersist's unavailable path handling
To: Benjamin Marzinski <bmarzins@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
 Martin Wilck <Martin.Wilck@suse.com>
References: <20250710181100.3997759-1-bmarzins@redhat.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250710181100.3997759-1-bmarzins@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 072121F74B
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_DN_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.de:email]
X-Spam-Score: -4.51

On 7/10/25 20:10, Benjamin Marzinski wrote:
> A problem that mpathpersist has with making SCSI Persistent Resevations
> to a multipath device work like they do to individual SCSI devices is
> that some of the paths to a multipath device might be down or missing
> when the mpathpersist commands are run. Multipath handles registering a
> new key pretty well. If paths are unavailable at the time of the
> command, the key is registered when they later become available.  But if
> the multipath device is also holding a reservation on one of its paths,
> things get trickier.
> 
> If a persistent reservation is being held by an unsuable path of a
> multipath device (the path can either be down or completely removed),
> libmpathpersist can't change it just by forwarding the regular
> persistent reservation commands. This can cause problems both for the
> RELEASE command and the REGISTER and REGISTER AND IGNORE commands if
> they are used to change from one key to another. If the path holding the
> reservation is unavailable, the reservation won't be released or have
> its key changed, as expected. I wish the problem of having a reservation
> key changed while it is holding the reservation was simply a theoretical
> one, but there are enterprise users of multipath that need this
> capability.
> 
> This patchset deals with both of these problems. libmpathpersist always
> had code to handle releasing a reservation held by an unavailable path,
> but the existing method is broken. It relies on poorly supported
> optional features of SCSI Persistent Reservations: the READ FULL STATUS
> command and specifying Initiator Ports with the REGISTER command
> (SIP_C). Also, fixing its current issues would additionally require
> supporting the All Target Ports option (ATP_C). This existing workaround
> has been redesigned to use the PREEMPT command instead. Key changes
> where the path holding the reservation is unavailable were not
> previously handled by libmpathpersist. This patchset also handles them
> using the PREEMPT command.
> 
I wish we had a testcase for all of that. Persistent reservation
handling is tricky at the best of times, but throwing in multipathing
it really gets into the arcane knowledge area.
Ben, do you have something which we could turn into some blktest
scenarios?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
