Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793953296;
	b=3lcouvL391yQbERVtWP4TpPpTLj6KbtGhAsErHApq+HydETwZM2ANIIM9RSp0mkKUZqF
	 Xko3ILQsPbbW1qDebzMo9mhL8ZmqSFd+KGgEQJm30qO+HadMNUbpvPUhUW4L7xhW8SAVH
	 HglS4at7UZi4zbdB6oNCfVOMh2dLmHisrnJzSc1zZPXmS+hJpk3qm5E8MxrcX6YmE+Ecx
	 DkIm/j726o718grlw91CRl8mn1L7BJIZkwpJZoH1z6Ukk++ZZ9sfVyyHHYhWwR2fLDrLl
	 6pGubHKiNZA81sb6/wncj83FWxscZoxxv4clCz4g5HtgbXHWpYIHJDAUFyMGlI18evA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793953296;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Rspamd-Queue-Id:X-Spam-Level:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:
	 X-Spam-Score;
	bh=Z2Ju1cQkbqfSchQm4ea439mNBOoXAWoCo7WUPi9dWQU=;
	b=KFspOqPpuzGBfRylNqbynlo2Stg+UkePNF9LyhqUW8dmcdXOn7sLt+jBPO6m98Qdb2hh
	 7vL7iJmprU81Ur7Tckqrc0xQYUeXCR1PoCihjd3XxbqvoL3+ENDEZGh25u3iJyVEjXoeH
	 Ft6WuBVNldrTZMLT/G+VVzQZZIwa8hNEkQln7Ocj20hbz9ZtEuZ+Wncl2dNdRgl37HzjQ
	 nznm9eUjHDbqaEqRDvU0Vn9B7d54Fe+3w4sTcLVYBqyWy9f0n6h2lkTouZyMPU0CSAThj
	 cgNC8Qj3aoRypCTA7YXfDGTUDgklRz21bfQaVB6i4t+0Hagi6kG7olG7d9c9DuEcp/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=V4e5eAoA;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b="3u/TIF1Q";
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=U40lI6F8;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=epjkPEdS;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 241A4606A332;
	Fri,  6 Nov 2026 08:21:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 241A4606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=V4e5eAoA;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=3u/TIF1Q;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=U40lI6F8;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=epjkPEdS
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EE3591FB93;
	Fri,  6 Nov 2026 08:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793953294; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z2Ju1cQkbqfSchQm4ea439mNBOoXAWoCo7WUPi9dWQU=;
	b=V4e5eAoAEcrMVPiURQAjginCIXmCcDDV6As0NtqHDwA3yiK2awePWJ2CRTFLJBufcxbk6v
	SWzt9hdEwkjKuP0L4WA90U3T9tQf68Bif5DvttfMuIsjdaMyfpNdO3eEvnGgn2x/tpalY5
	np0yi/68rs46xpFXejPNMswmeEoi0D8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793953294;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z2Ju1cQkbqfSchQm4ea439mNBOoXAWoCo7WUPi9dWQU=;
	b=3u/TIF1Qfg3BoZVshE9rOBJ2ON+ybz08g6+kZZxQqx99cgMBDykCtrbAARoGIZzGPl9BCj
	e0CXdI0JHfJE23Aw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=U40lI6F8;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=epjkPEdS
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793953293; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z2Ju1cQkbqfSchQm4ea439mNBOoXAWoCo7WUPi9dWQU=;
	b=U40lI6F8wEBaSZ2brkRKY7emrMDprR6jHx07Go8XDqIDYEHXrXq5EDXDND/575qJEzvkT6
	B7BU9RQ0+et4qoMWcBW52+8AzfnQB3J76HxGc1jcVyTFa6gmjl+GjTNgwNvyK9olKYpZZ6
	rFi5WEZILTdEJxtTuHKBKgVltpgX+Mo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793953293;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z2Ju1cQkbqfSchQm4ea439mNBOoXAWoCo7WUPi9dWQU=;
	b=epjkPEdSL4wtMOZoeFcoy1kEE4pRVcMJ3AYKhXn+8eoImry0vFoijUAhqv85m3cIcLDM0g
	mWN/aMxISNozc8DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F035D132C9;
	Fri,  6 Nov 2026 08:21:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JRMLKwyO7WqXcQAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 06 Nov 2026 08:21:32 +0000
Message-ID: <27015846-0161-4700-b810-4643e1f7b63a@suse.de>
Date: Fri, 6 Nov 2026 09:21:32 +0100
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
Subject: Re: [PATCH v5 2/3] KEYS: Replace assoc_array with rhashtable
To: Jarkko Sakkinen <jarkko@kernel.org>, David Howells <dhowells@redhat.com>
Cc: bpf@vger.kernel.org, dm-devel@lists.linux.dev, fsverity@lists.linux.dev,
 keyrings@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-security-module@vger.kernel.org, Alasdair Kergon <agk@redhat.com>,
 Alexei Starovoitov <ast@kernel.org>, Alex Shi <alexs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Andrii Nakryiko <andrii@kernel.org>, Benjamin Marzinski
 <bmarzins@redhat.com>, Daniel Borkmann <daniel@iogearbox.net>,
 Dongliang Mu <dzm91@hust.edu.cn>, Eduard Zingerman <eddyz87@gmail.com>,
 Emil Tsalapatis <emil@etsalapatis.com>, Eric Biggers <ebiggers@kernel.org>,
 Ihor Solodrai <ihor.solodrai@linux.dev>, James Morris <jmorris@namei.org>,
 Jiri Olsa <jolsa@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Martin KaFai Lau <martin.lau@linux.dev>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>, Paul Moore <paul@paul-moore.com>,
 Randy Dunlap <rdunlap@infradead.org>, "Serge E. Hallyn" <serge@hallyn.com>,
 Shuah Khan <skhan@linuxfoundation.org>, Song Liu <song@kernel.org>,
 "Theodore Y. Ts'o" <tytso@mit.edu>, Yanteng Si <si.yanteng@linux.dev>,
 Yonghong Song <yonghong.song@linux.dev>,
 Linus Torvalds <torvalds@linux-foundation.org>
References: <20261105031401.956609-1-jarkko@kernel.org>
 <20261105031401.956609-3-jarkko@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20261105031401.956609-3-jarkko@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EE3591FB93
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
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[38];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[vger.kernel.org,lists.linux.dev,redhat.com,kernel.org,linux-foundation.org,iogearbox.net,hust.edu.cn,gmail.com,etsalapatis.com,linux.dev,namei.org,lwn.net,paul-moore.com,infradead.org,hallyn.com,linuxfoundation.org,mit.edu];
	DKIM_TRACE(0.00)[suse.de:+];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	R_RATELIMIT(0.00)[to_ip_from(RL3deh5x9onbckmuwxjk3fsykq)];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -13.50

On 11/5/26 4:14 AM, Jarkko Sakkinen wrote:
> The keyrings subsystem is the sole user of assoc_array. It has over 1700
> lines of code, no test suite, and a long history of bugs, with LLMs now
> finding more.
> 
> This unfortunate outcome has evolved over time by large from the shortage
> of in-kernel callers, time bandwidth and 3rd party contributors.
> 
> What the keyrings needs is just a generic key-value store, which performs
> well with sparse key sets.
> 
> Replace struct assoc_array in struct key with struct keyring_index:
> 
> - keyring_index: holds an rhashtable for direct lookups, an RCU-protected
>    list of keyring_link entries for stable walks, the active link count, and
>    an rcu_work item for deferred teardown.
> - keyring_link: links a key into a keyring's hash table and list, caching
>    its 32-bit SipHash digest rehashed with jhash by rhashtable.
> 
> Correspondingly, struct assoc_array_edit is replaced by struct keyring_edit
> for delivering transient state across link operations.
> 
> Other behavioral changes:
> 
> - KEYCTL_READ and sibling-keyring searches follow list order instead of
>    hash order: keyrings are prepended, other keys are appended, and
>    replacing a matching key retains its position.
> - key_unlink(), keyring_clear(), keyring_revoke(), and keyring_gc() no
>    longer allocate memory.
> - keyring_index_free() uses queue_rcu_work() instead of call_rcu() because
>    rhashtable_destroy() may sleep.
> 
> Suggested-by: Eric Biggers <ebiggers@kernel.org>
> Co-developed-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> ---
>   include/keys/keyring-type.h |   1 -
>   include/linux/key-type.h    |   1 -
>   include/linux/key.h         |  28 +-
>   security/keys/Kconfig       |   1 -
>   security/keys/internal.h    |  14 +-
>   security/keys/key.c         |  22 +-
>   security/keys/keyring.c     | 986 ++++++++++++++++--------------------
>   security/keys/request_key.c |   8 +-
>   8 files changed, 465 insertions(+), 596 deletions(-)
> 
While I am pretty much in favour with this approach, is there a specific
reason why siphash has been chosen?
Would there be a chance to make this configurable?
I do see slight complications when running in secure environments
(ie FIPS-certified environments) where most of the hash functions
might not be available ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
