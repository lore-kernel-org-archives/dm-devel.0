Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794168330;
	b=X4R6lJ+h8qxjGhrJHTV6odkmaSDPRSXzPOpCTdHc961zDrjPNo/5SfhK+LGpa1bUCbuk
	 afnqtXZqPDxztZYz1PtHdFMs3sJvj6/50kyGV74oU673qaSMy6sQVlfo1hnvP+ifXLSGG
	 xK37aAuNaXnAwct6lwNAAnrjCbykUCL/gbQ3pTPI60BoTl00rrGG0aq103x7Sj3Kx4T+z
	 73UZkbRsx4sAzPalp1P6sMjqqg23cz3ryxNyjBOmbDDZqo2BTJoKG9AGJScSUX7akfxqA
	 6RcFaW31O/LVgPNQiRzu5tUVs2ksFn0AdIMvjg9SUD6kRgh508UGPDL4HvOJQrmrkrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794168330;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=NsI7ZZLkYjCZutUVEg7TJNtNpCk2xGDMbVs7o+8cm3Y=;
	b=NqrOEwYrof+ymx4q1ndSkZj0tGLSu6PZMmsH9Wp7bnBLXhhRTu1kgJSfNyTrqvF0qfq7
	 D+VqepLbaSF56sEyhy1/W9o2+pxM6f5YQccP8G+mUKI2acuRGn1PCWxTOND0fRueMYRlJ
	 GHcAd5a1+dQycynYiIxIggpIlX8X/R8a9rdJRPTq635EoepW3z/OJ5gMR/wAZnU9mAmAB
	 B0lm84XCmtzDEZJBiWG+FW3WYJ911FqnZ5TIinUyVY8hwrZpkZ/56THTlh4MkXkN3wvsQ
	 Plk54O2ZUkSRj2R0LvrdrXMBwwYlEXwZE7UypppU1SrGSKj5oM2EY2yI+HsQ+UN4YvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="ZpVOXa7/";
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52563606A323
	for <dm-devel@lists.linux.dev>; Sun,  8 Nov 2026 20:05:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 52563606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZpVOXa7/
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a35ac4475dso1318935e9.2
        for <dm-devel@lists.linux.dev>; Sun, 08 Nov 2026 12:05:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794168329; x=1794773129; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NsI7ZZLkYjCZutUVEg7TJNtNpCk2xGDMbVs7o+8cm3Y=;
        b=ZpVOXa7/Fhnumr2tBcIUy/OamRHq+llX8Z1JcVJkOxPb6RCt6QrRS4Qj99L6tRnlqz
         3GkEp1ytFAImoFVULTp7DU+17XBCaByRZ3uEZDTZojlM0OPviIqCzF/fO6Jxu5aBN+kL
         fNlq0YBu50ViJvpSDnTBHHharyIGvyLaOwVrKjM9NIRK7g3/RURJpApvtBAKh1bjbnrr
         KyR3jjCPpNw7e7+dAxZsi4iuh5nMUSBQKJ7kAX3zbTadWBAjIhGp9+cNqJOPJ8IrURV4
         VUATsmXkEV53XLUANxay7nitkFABH6pRambiV7Rn5CZpiSXCAMvOrwh509Zu/ihrgmCk
         p8BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794168329; x=1794773129;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NsI7ZZLkYjCZutUVEg7TJNtNpCk2xGDMbVs7o+8cm3Y=;
        b=wRzFSKLnnv6Bmk9PXXIExqYWlCBqTBuzY3G3/BZLTPoPKUfhXTO1qeCDkTC9/BHDPc
         9cri9npGbzkbnStyylDLIQ/uMmTH2fcXCGCIu3MpIeDEDWnaDbesZMQXOty3imAHg1D2
         xm/qfof9ruawnckm21Nr0JTPXy86K/2WkqiEY3oSZIbpgcCzVDSFRTJDhifFDBxWrU7H
         FAJG9itpuIRPFWfIR3rJB839dzkc7j3YeNs2g96mUJldEbWPmNNmz116sGK+9yvsfwab
         olQieZKDJbpD2t+HHSuhPu+imaZ3OHoBeKVBQoxWAU2qGbRdBtfYZFjd4feUR5Kcjxok
         2XXg==
X-Forwarded-Encrypted: i=1; AL+hErH4Bk7l+0IZp55vTptQ6iNfaC39x7/g4igW+aAPJ85a8kjainQcNLyAz736X10sjeN2+ZOQHSOmqg==@lists.linux.dev
X-Gm-Message-State: APuU4Z83Y8Gzn6cLApNRP2v9k6U9OQDFlMKy0IOGrNgKooI4Lhp5qash
	fQwafFctLPDynnX5dJnetFOwqyhYwbqyxdS9nMt0RwKwjU4vTGw92HT2
X-Gm-Gg: AYBFou0BzaAabi2FUb43Of3MbKvD6p1OFa0VisRfZiA/ZvLc/YwcWu+caBrP2FeTBaS
	k63NjIhc6Rn/axVa/BiD/8Tuwea+YevqDcF8A2oPf7kDUQKFJIYS72YVolPu5xe9uatZOJMi/e6
	E7qdnFzbysi/Hu7OUxWDub82HXMVvOe/9YrGycv25eVjmOHjlqNP30cef7U9/GxJflTigLlcRIL
	qCnpBohLRR9Z1NlmmDBkWuk1ZTAYsAyvD2DVKZ+ZYco5vrieOJNAlUb5m5pHBx7PLFAnpzl72LQ
	pkv8FHsc/H4X8b7BZmJz4YppoeMLH1bg70kvIA7t5nYBZbKORYbQHHx0uy1a2zgW7yj2uXHsfra
	eaE3eByZ85CCh2sFO/dYmSPve/MVeGeak47n3dEBXupvIxC2dQluwqs1yL9zcLLlgwEKifbq2Gw
	anc0Q2hCuvcD5SoLp1ALiuUXHuUurISQs1sJGN/9lBq45KxfoutTVlhzZb84nefS3NUhXbc29Pw
	R4mSxqIRA0Aw73jFuZpAsnylu/YeQzV1oSl+CblEhJaQEg4Syz9ua/fGTXpiHnD65J7Emwg++ce
	IMRRdoSYUXdCA0HkjMHNsD7QehqwJ+ANbxpq0/Xgeh7D1oqcnLBYc32I6BQBkH2iYycPlq4b6JT
	a5SKITT1fdg==
X-Received: by 2002:a05:600c:1c0c:b0:49f:ce78:3562 with SMTP id 5b1f17b1804b1-4b963c69d23mr43591205e9.19.1794168328561;
        Sun, 08 Nov 2026 12:05:28 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49597186ec5sm5768522f8f.33.2026.11.08.12.05.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 12:05:28 -0800 (PST)
Date: Sun, 8 Nov 2026 20:05:26 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Hannes Reinecke <hare@suse.de>, Jarkko Sakkinen <jarkko@kernel.org>,
 David Howells <dhowells@redhat.com>, bpf@vger.kernel.org,
 dm-devel@lists.linux.dev, fsverity@lists.linux.dev,
 keyrings@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-security-module@vger.kernel.org, Alasdair Kergon <agk@redhat.com>,
 Alexei Starovoitov <ast@kernel.org>, Alex Shi <alexs@kernel.org>, Andrew
 Morton <akpm@linux-foundation.org>, Andrii Nakryiko <andrii@kernel.org>,
 Benjamin Marzinski <bmarzins@redhat.com>, Daniel Borkmann
 <daniel@iogearbox.net>, Dongliang Mu <dzm91@hust.edu.cn>, Eduard Zingerman
 <eddyz87@gmail.com>, Emil Tsalapatis <emil@etsalapatis.com>, Ihor Solodrai
 <ihor.solodrai@linux.dev>, James Morris <jmorris@namei.org>, Jiri Olsa
 <jolsa@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Kumar Kartikeya
 Dwivedi <memxor@gmail.com>, Martin KaFai Lau <martin.lau@linux.dev>, Mike
 Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, Paul
 Moore <paul@paul-moore.com>, Randy Dunlap <rdunlap@infradead.org>, "Serge
 E. Hallyn" <serge@hallyn.com>, Shuah Khan <skhan@linuxfoundation.org>, Song
 Liu <song@kernel.org>, "Theodore Y. Ts'o" <tytso@mit.edu>, Yanteng Si
 <si.yanteng@linux.dev>, Yonghong Song <yonghong.song@linux.dev>, Linus
 Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v5 2/3] KEYS: Replace assoc_array with rhashtable
Message-ID: <20261108200526.43579e2a@pumpkin>
In-Reply-To: <20261106090516.GA1973@sol>
References: <20261105031401.956609-1-jarkko@kernel.org>
	<20261105031401.956609-3-jarkko@kernel.org>
	<27015846-0161-4700-b810-4643e1f7b63a@suse.de>
	<20261106090516.GA1973@sol>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 6 Nov 2026 01:05:16 -0800
Eric Biggers <ebiggers@kernel.org> wrote:

> Side note: fips=1 actually has little do with security, and in some
> cases it actually decreases security.  See for example
> https://lore.kernel.org/linux-crypto/20261026183332.11402-1-ebiggers@kernel.org/
> where I'm fixing a vulnerability caused by fips=1.

Then there is the 'fips compliant' server we used for routing 911 calls between
TDM and VoIP.
Any kind of PCIe error gets routed out the the motherboard management module
which then proceeds to inform the kernel with an NMI.
At which point Linux crashes.
The NMI is too late to stop the kernel having to handle the ~0 from a read.
And even happens when there is no driver using that device.

David
