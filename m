Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793970137;
	b=lVIr3/cGiymf036dh3U8HC+YqGKhXoCRfvFY5ZZizYHE4g979qB9CviycnMN7yYqZZ1D
	 xN6j95GnvocWgDW7oJl8EC9X83Ken9mCktI5GD64Os4vcpEjS/CJSG+DpxtSpJsomNjVN
	 WBfhX0X7jzcB6yOg0pGbEBosPjFjViBX/2QfqVoHv8+US7shqHKvGlaGtSN85ILWDZkPe
	 JMgTF+odyp4Fz1FYoDxF2bHOemdCEcdyTGtqe7ThoHCW88QmP3KyX3RwBdm/kqqmWHAca
	 rFqvq4Wqj2v549dmbxm+mBRVR2bWC3ytUK7pH2e6/5t23VcBQSoGtmNCkK8SK/erxEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793970137;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Spam-Flag:X-Spam-Level:
	 X-Spamd-Result:X-Spam-Score;
	bh=bbUQdEPswgOtS328uqlCGgh3E/GKlV/1cyChz7WH/NU=;
	b=kV/7FQ/mD5Nd4z8FHLnLSxZQuhsoKmoToP69U55HWRC75Wi6oYfByXbIa+3EdePH6zZA
	 58CxSpUeMRoSy4E7OgctSSBde4RHHSi9p/D36qunbZOnjOgT2nepxXgyVXsc9jUpwCh1F
	 cO8ccCsseoRgG6FNLw3WRX0JxZxY85tgQi2iBpalK4ljQDsvRb36jEuVJPPU5wTuKduMd
	 cbiKcIRW0Bm8n6pNzoI7tnavgM6MEuV7C/RNNVpXbCquMd+F2due/v3/RDMuHEzWvwbep
	 Jx8OqXFwoXMCsLYTkoptFIrtcPS2k+dkXXG0Amk/1ExJZhXxoMcfKu0idw8u94f/FuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=SkSGo6sR;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=HWSD5i96;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=SkSGo6sR;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=HWSD5i96;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB56606A330;
	Fri,  6 Nov 2026 13:02:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4AB56606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=SkSGo6sR;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=HWSD5i96;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=SkSGo6sR;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=HWSD5i96
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9E3DA1F7A1;
	Fri,  6 Nov 2026 13:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793970133; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bbUQdEPswgOtS328uqlCGgh3E/GKlV/1cyChz7WH/NU=;
	b=SkSGo6sRLpvA2K/beezCVpf5lh166bkmRSUVzATxIn9mGrRmG2+OpOcl3z0xEiMvAZ1ru9
	0nHHx9LXL41lEUxYRCsEAmo38XIvIXp6BBrRCBeDbrTdAKeB/Ta9XE3OaKlKFCma7npfcR
	imDrYFmF2PCA7Vp6HKz4bsF6S/Sq6A8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793970133;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bbUQdEPswgOtS328uqlCGgh3E/GKlV/1cyChz7WH/NU=;
	b=HWSD5i96OeE8X0hkp6yGWu2eYrss726NPemdGJ029xnxhTprH/7+6wjQApNyquRVkIVqnZ
	QU8dyGmc82rmdODQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793970133; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bbUQdEPswgOtS328uqlCGgh3E/GKlV/1cyChz7WH/NU=;
	b=SkSGo6sRLpvA2K/beezCVpf5lh166bkmRSUVzATxIn9mGrRmG2+OpOcl3z0xEiMvAZ1ru9
	0nHHx9LXL41lEUxYRCsEAmo38XIvIXp6BBrRCBeDbrTdAKeB/Ta9XE3OaKlKFCma7npfcR
	imDrYFmF2PCA7Vp6HKz4bsF6S/Sq6A8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793970133;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bbUQdEPswgOtS328uqlCGgh3E/GKlV/1cyChz7WH/NU=;
	b=HWSD5i96OeE8X0hkp6yGWu2eYrss726NPemdGJ029xnxhTprH/7+6wjQApNyquRVkIVqnZ
	QU8dyGmc82rmdODQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4F6AF132C9;
	Fri,  6 Nov 2026 13:02:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id xGnEK9PP7WolGQAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 06 Nov 2026 13:02:11 +0000
Message-ID: <93e6b4e6-43c3-462d-b57c-26676aec85ec@suse.de>
Date: Fri, 6 Nov 2026 14:02:11 +0100
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
To: Eric Biggers <ebiggers@kernel.org>
Cc: Jarkko Sakkinen <jarkko@kernel.org>, David Howells <dhowells@redhat.com>,
 bpf@vger.kernel.org, dm-devel@lists.linux.dev, fsverity@lists.linux.dev,
 keyrings@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-security-module@vger.kernel.org, Alasdair Kergon <agk@redhat.com>,
 Alexei Starovoitov <ast@kernel.org>, Alex Shi <alexs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Andrii Nakryiko <andrii@kernel.org>, Benjamin Marzinski
 <bmarzins@redhat.com>, Daniel Borkmann <daniel@iogearbox.net>,
 Dongliang Mu <dzm91@hust.edu.cn>, Eduard Zingerman <eddyz87@gmail.com>,
 Emil Tsalapatis <emil@etsalapatis.com>,
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
 <27015846-0161-4700-b810-4643e1f7b63a@suse.de> <20261106090516.GA1973@sol>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20261106090516.GA1973@sol>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-13.29 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[38];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,redhat.com,vger.kernel.org,lists.linux.dev,linux-foundation.org,iogearbox.net,hust.edu.cn,gmail.com,etsalapatis.com,linux.dev,namei.org,lwn.net,paul-moore.com,infradead.org,hallyn.com,linuxfoundation.org,mit.edu];
	R_RATELIMIT(0.00)[to_ip_from(RLa6okkzyh9jmtq4tcjsqmu7hd)];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -13.29

On 11/6/26 10:05 AM, Eric Biggers wrote:
> On Fri, Nov 06, 2026 at 09:21:32AM +0100, Hannes Reinecke wrote:
>> While I am pretty much in favour with this approach, is there a specific
>> reason why siphash has been chosen?
> 
> SipHash is the preferred choice for secure hash tables.  It is secure,
> performs well on short inputs, and doesn't require special instructions.
> See Documentation/security/siphash.rst
> 
>> Would there be a chance to make this configurable?
>> I do see slight complications when running in secure environments
>> (ie FIPS-certified environments) where most of the hash functions
>> might not be available ...
> 
> SipHash support is available even when the kernel is booted with fips=1,
> so there's no issue there.  It's already widely used in the kernel for
> hash tables, and that hasn't blocked FIPS certifications either.
> 
Ah, right. Thanks for the information. Just wanted to cross-check here.

> Side note: fips=1 actually has little do with security, and in some
> cases it actually decreases security.  See for example
> https://lore.kernel.org/linux-crypto/20261026183332.11402-1-ebiggers@kernel.org/
> where I'm fixing a vulnerability caused by fips=1.
> 
Oh, I am fully aware. FIPS is more a rubber-stamp than anything else.
Unfortunately, a pretty powerful one.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
