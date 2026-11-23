Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795455344;
	b=xkcr7xJ5QqbAeR/Gzaakqmr9V8z1Cm5im0o+gX16NVYZrQbSsewznD2Sh6/9Qe/6Zwks
	 5JQfqXQTyYac5GQ22vgI7RQZIvrW5Gd/9WNc4m+0ZNmhog2ijqoMaUS5LAiL+087UceKn
	 JFPAnjDM9CknznopMezbc8MneMbaznvoLlZFyVYQev1pLruNrHr4rzZPS+rQNcfv6hd1+
	 YP0UK2TLmy7b6f4GU2izefKtUaYmT5O+ZzTkPB2JFMiZSCYgZzCcMU5rPby1DDwnwqpZu
	 YVDzb3VVbrxd4KRNjcnVROZQY/x/BBUREm4ZwALsISijyyC5o2AdIeWb8vJIfJJGdSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795455344;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=CSdAMO/F6Uhfc8gHubM/Y9lU7GHm+p6Sd5ESGwCiJQM=;
	b=Bsb0DBfRc6hDTDwX+4O2ZtSCY2+UnUfDxcUf9MVvbBWomdDBOH/T5ag/Yeue1eSDiHNH
	 A/CVts8NjrlAPVu6mAPz+jQZCYggBsib0gXmIsJ/3xqxd5MzmovmG51sX+Bf8pZ07KjJ4
	 xNWUDVpv4c8N8bwEHcjf+C/NE0PGCgA+b8DNb7VpNWrmiOpAn6zz+vyRcCBD+D8IkwkaZ
	 DsAWEoDbTPGV3SBVircvt+ybmQDJzvtXCIlWSBhgyBIRQ6xcNziF1X5TPboEpBtaWmL62
	 6BpWwzgUCcSb2k1WF7Ou3Favf0/IbVsixBwB0+4QI5Uomwlw/jpDJ2fBrpwTY+YXrzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=euMu9Vuj;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89860606A31A
	for <dm-devel@lists.linux.dev>; Mon, 23 Nov 2026 17:35:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 89860606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=euMu9Vuj
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4bb609d9bf4so8027065e9.3
        for <dm-devel@lists.linux.dev>; Mon, 23 Nov 2026 09:35:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795455343; x=1796060143; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CSdAMO/F6Uhfc8gHubM/Y9lU7GHm+p6Sd5ESGwCiJQM=;
        b=euMu9Vuj3oltuWf+Mv69RljjIlbpL4/46Q3Dy0OYE67m6bZAbghVEFnIxkyyRTGCUl
         b47a0KLsAdguk5pTiGlrXvH8lypIReIvhwf2EoUOKSObePdsgKAy/IWDl6f+9eing2UO
         w9SSbmlh5ax3XnJON7QvYaR5PZtemFntU8ycDcc4UUrBoatxgAFRmvj0TsveTYPPoEtW
         f4EAqQ+fztop4LpneZNJ0edJ8hqw2yBl8iOi/kXqMAczvJaZNtCr+6jdC1dGD3dVbFMl
         k7+YK94P9KQTBYM74l7ZgpA8GOdOeFO/EDncWoe43B7He/nPo6PwMH0Kzs5k8hUfHjZ/
         CU3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795455343; x=1796060143;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CSdAMO/F6Uhfc8gHubM/Y9lU7GHm+p6Sd5ESGwCiJQM=;
        b=o3ZPk8w3ne7iIXf+5pohJ2QbE217jRJwfk825zhBo3uSPOUxX8otRwNdLiXCje4hzR
         /1D5ikaWAKN+xWaNCMm4tkOktV04Q+BUxwBYZqq2QKCnWt9uiVbagubsLqK60AIDgeEh
         6jNWxy10HlDJi3AKkt3/YsCruAGbWSWztB+v50H1d/pJbjGVTLeaMwTEYLU/A+qJFVcS
         pgQEnJ0LRuaqTSxoOy0gK/Z5m32e84hQqb74ETLOTGwuBdRVN2Zeegpcvi0pcBaz1eqh
         xjAP97kdPRHAnIAGPBYt+uKeZsiUnm8uCgkJCeKzSgWLQDLT+xg97z3zI+ymL81Db7lw
         K5uA==
X-Forwarded-Encrypted: i=1; AL+hErEh9HfdfhCY/r9fStTzOWjym0mvZyFTwGuEMssqnLL8DdbV96Kobt+90mRsKNVE3z/qo3AmdecZdw==@lists.linux.dev
X-Gm-Message-State: APuU4Z/gvoVZkn6uBwNYnqYXyqgjhOMsCnvEnpz6rAANVwlJHRayzFB7
	3T74yt9MLkU4kRGMHDfaPZTfOwXOvHYcuM+hnOxa9FfpSUmYwgAJoaw=
X-Gm-Gg: AZFdTZdzQEdbuhCzbsmcDqZR/I65bWyPQt+/vEcMGmax8YrED8gTYO8Pu3QyrPTm8ch
	Qkpl9lmiL2y0oCXXnRcjlNJC5WUek8xZb+hC6VN60oxOIA67p4rbniWfRgJKx2GvSZ6AHsTExEt
	EvXI1qzypbYKQ1amVTJcgyptpBAtbo7HsreOyQ/HT/60Ht1ZHt2hAv6ccAH0GYdsBaTO2w00Q5Q
	HuRdTDiBaJFeoRCcvO9vDU+fK2GbEN3+hFjyN4bhqQHP4sFJaWCeXme5BaoEeK7nk0OS+uAhnpv
	GTE7SXJ9HEaiyxa2ZOL7xzBE3kEO6fdZOQKDaX9nppR4Zz0EqbrDvF3+4zHZfCYpoiNrU2DKMCS
	WQ9pjTFTL95kZHZBQW3Z+tEft4LZGsplLaCFR828xCGlUPex9K/+zy5JV6vAmtt60IfEXLw1vtR
	owYyPbKnqa/liXKtguiPJdFUYHQQR8hkCWOEhhp1tsAaoIxO02vrjrzX+Z0V0wWqco6dXKJjQdq
	IQOVm5kL3IJhxPQmfO94IqX8W0bcMQbcUaen4hPLbiFTDo73+MLI+asv1UV9TUpNs4sQqPN98rs
	b68GnyUZBab/QXyQw90O9+lph3eRjnzOMoiiPBY/0Z3WLX1gyDNMjgCxGhFP/vpeEzGe
X-Received: by 2002:a05:600c:154c:b0:4ad:5ec2:d3b3 with SMTP id 5b1f17b1804b1-4bb887f43d8mr244407285e9.1.1795455342776;
        Mon, 23 Nov 2026 09:35:42 -0800 (PST)
Received: from localhost (86.red-88-28-10.dynamicip.rima-tde.net. [88.28.10.86])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb853a1e8bsm312041255e9.9.2026.11.23.09.35.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2026 09:35:42 -0800 (PST)
Message-ID: <2b68bb74-e322-4c7a-a1dd-0d7e0a46dc3e@gmail.com>
Date: Mon, 23 Nov 2026 18:35:41 +0100
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Subject: Re: [PATCH RESEND 03/13] multipath-tools: hwtable: add FUJITSU
 ETERNUS VX710/VX740
To: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>,
 DM_DEVEL-ML <dm-devel@lists.linux.dev>
References: <20261113125549.504780-1-xose.vazquez@gmail.com>
 <20261113125549.504780-4-xose.vazquez@gmail.com>
 <16d621bce8b1e5f027f07a8b235be0d1f6f05796.camel@suse.com>
 <64b6d939-f527-417c-b5f8-c804e02846fe@gmail.com>
 <accb92fd1fb9bf941c28ad8bc4427807740558f7.camel@suse.com>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <accb92fd1fb9bf941c28ad8bc4427807740558f7.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/23/26 6:18 PM, Martin Wilck wrote:

> Gemini told me that the VX 700 uses DataCore SANsymphony-V as its
> storage virtualization engine, which does support ALUA. No clue,
> perhaps Gemini is wrong.
> 
> It doesn't hurt much, anyway. If the system does support ALUA,
> multipath will use it.

The PR says it was targeted at vmware virtualization:
https://info-archives-global-fujitsu.translate.goog/jp/news/2012/05/9-2.html?_x_tr_sl=auto&_x_tr_tl=en&_x_tr_hl=en&_x_tr_pto=wapp

And the vmware compatibility guide lists its "SATP plugin" as
VMW_SATP_DEFAULT_AA (rather than VMW_SATP_ALUA):
https://compatibilityguide.broadcom.com/detail?program=san&productId=20745&persona=live&column=partnerName&order=asc&partnerName=%5BFujitsu%5D&activePage=1&activeDelta=300&redirectFrom=ETERNUS%20VX740

