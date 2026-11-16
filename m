Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794854352;
	b=MhVi78KFbwjVPyk/TA8UYHpYLFneOzHCub9j8Jl9FESxbaQRGDFmz5JPKwO+QywyP8AE
	 k4xkkQNvNKN/eYc1V07M/D86nCGEimJ+v5JGjqbrNwUDwPmsrEFgDbxirm7Fwf9UpAfUy
	 MOhOEOUFDcS/GzzPNCCUmi6gF43sPuFLs+wlJ6Y3cQRdQ0iELe61zDW5Sm29UqI+lE/zI
	 AtiCPdIi0bFne6MepcgoAkjllnV24z4M/pnKpO4VIIZw7HO2z9/hsZZMRFntmtf7lJiOX
	 kwdtQIxlPdwn6FgFaoO25T6HipK+6kxkcDR7nDdCBI1eD2L4wersGxu3DT8bLyTT3qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794854352;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yuRmKUvGxV3vOzcT4dxq5oZeZCOOsvqx7IOQhNi6+g4=;
	b=kVjNUnl2BsVrR+uDUFm6fY1raCfCEOlVdJ8fC1NvQL8U4ly4yLBQ7SjKEhH7KyyDkIIB
	 zAwRWPV0AE1xxsX0nP0FBADT7tvVcypCd9g9lUrHkidmQolOUcyqfkpjPdgv4Gvhk3mRm
	 Gz5GsECocbwVFQpxlvdHelegrltEDJhlbHPS1hdWVMMWvVdlCBMjKl21RhbMI/axfeKiC
	 K21l3LJH5puqK+sovZloSS8pOmKw3b8VhzHTix/AO+iGyyiXW11MS9tb/wIZKg4IR93UY
	 w2PCMC0i57uqz1EtLPruYecDHXOiEcuKI7uTE/I0heqY3PZ2DKwmcoLtj3tW+1ovBdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=GAZuDeVW;
	arc=none smtp.remote-ip=74.125.82.179
Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5E0606A334
	for <dm-devel@lists.linux.dev>; Mon, 16 Nov 2026 18:39:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0D5E0606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=GAZuDeVW
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-3704d30b84fso4498173eec.1
        for <dm-devel@lists.linux.dev>; Mon, 16 Nov 2026 10:39:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1794854351; x=1795459151; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yuRmKUvGxV3vOzcT4dxq5oZeZCOOsvqx7IOQhNi6+g4=;
        b=GAZuDeVWpgmHU6c1Ge57kxXQgBNSamDtH3HFC+XcELk0SkGFjK69iD4P2JbK4Gq9t9
         unkBfSOOn8dyhN1NpwrNhKQLA6vQmU69o76NxZhKp3KMH5xLeP8F3JmCHY4Lx2rJSHq3
         gzwxQhIbOTU5Vs3mh5v/zxBjOyGIhPQDrzV1L8WzKXbFS8IKC3qNbwserQEFAypYsOEv
         nJePiMqrxf8w86MPrqSI6LR39XB7UJNGwjwO+jVr8tHDQehyuHg6PiaxAexbMsWHdCUa
         WRM2rBlrtvACQQe4Hxe+0NJhqprkYb4PCmmdsAqwWqojc1Lgil8FlAk9jvjDmPi8xOg9
         W+SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794854351; x=1795459151;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=yuRmKUvGxV3vOzcT4dxq5oZeZCOOsvqx7IOQhNi6+g4=;
        b=jFV0ZtkifilcBnCZEKeXiksjHXqwqZUni1UMTLla7i+S47olJXHE8Zx6TeyM6u8gUT
         smGHdbFCgXVf7MX/mfeATZq+t9tZVTu7jTJYAvCZmbmZe/uSCSo/NxgbUovMmWvv1PNl
         v0x6mdwJoQYhG2JRvDq3b8cGLxf16Kwtqu72+dnAYTDgZin0ou6G7TQ5X70HFsPB6Xvb
         2t7VxTasrMRKaAe+UujzWQr96w8AjS3LF0A3/aDSJylLdkQAjuBun+qfC8HPFy4ztBYv
         GHhc0Z0dfl91p5NSWTIrUAkibAhg5OR3SVdiYAJEyhvZzyXEVAyIKUvmCFoC3G71d/yi
         4KVA==
X-Forwarded-Encrypted: i=1; AL+hErHHzvjm5iKgFN8bcpuLtr1XqNqCqMsvyJ1qNNHRB6g6dCM17hiPkP91l6zDrAeJ5ulIdQsavnvq9g==@lists.linux.dev
X-Gm-Message-State: APuU4Z+5mmaiS7fDCDCld6RMWGIvaq6lgOmaAe6vExIOHyjJN5xA6LZ3
	hFNcPqynXw9sTRFY7nXb1Rky3jTNsRpCIRAUgwiQpeQ+78HdTdyzIj0MUi9qjpD3YME=
X-Gm-Gg: AZFdTZexAEVPi9qE/xevFhl6gcrt5ZEo9yPxe2UZIrxGj06DIXKBXriDzSvtGeBztfg
	kiLnMqKxtc7mWg6YWDjdMYU10zFWxBoNW5VsDQ/BI+k1OO32B6WHKDE/BdgHTIMjSJrkxPGOUlt
	aB94Gu1lgEqmJdXPT9Ebx0dOw4ADxBbgxw0MYRNNUBVNZHYBxuZ5u7jgHeV5p+l7MjOgtRzEOfP
	UOFqHKy9xZbTvFRheMJsWV0wSK6MVw38yFRDXntBCLksQ20ZKbMu8AC4FZM1C9ScUzjrq+y0Myp
	h3fzYn7ChT4cpeqHHltUERl5Q5dxc97HFsqhZOlFoh6M9Y+QK6rA6y36tkxEnrUdDkMqAUbOT9w
	IWwHQ7mlWYhtW59UzPvK59USTuk6ltDdCOjr8tCIZzXZ3Weczu1CXtrKOEEF9jpURmXfKYyrmIC
	7NDnTPEYREc2F05fn8dgMkEZlTIrwVLKhcBGvNY4+CUonKnj5HnCel4HDZjV5xliiYmmV9YzQQ6
	h6JeDYLqQG8oZs0lDA6nrpICBeAHNSrXIQyxkPL/4UAuFvue2LmdZ/vgs/+WfhnqQJRP3qvm6Ki
	7kOqeBasgN4hu1Er06n69nHvjo66fim76icR7G6vF5xY0Xzs+qaY7d8kEK7ki3fjzVZyr42v10Y
	vMnNLIawyq+4dnirw8nc51DJTe3hM1uXyx8jaWG9eMv2AKvR3AQJpQFHCU33WQIIYxZMh9RwdvZ
	ll1NokI7AdQp3OMSur7IXK03c0
X-Received: by 2002:a05:7300:fd12:b0:369:a162:af96 with SMTP id 5a478bee46e88-379673164cbmr17370303eec.17.1794854350888;
        Mon, 16 Nov 2026 10:39:10 -0800 (PST)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.93])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37956bad134sm44004057eec.27.2026.11.16.10.39.09
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 16 Nov 2026 10:39:10 -0800 (PST)
From: Brian Bunker <brian@purestorage.com>
To: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
	Hannes Reinecke <hare@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	dm-devel@lists.linux.dev
Subject: Re: udev / multipath-tools: WWID determination with SG_IO vs. sysfs
Date: Mon, 16 Nov 2026 10:39:00 -0800
Message-ID: <20261116183901.23474-1-brian@purestorage.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <e246cb25f06744a1610ee1d78e033d6ecb17a31d.camel@suse.com>
References: <20261109185556.27139-1-brian@purestorage.com> <214d18ebabeca8318352dfa5456bc5b37cdefdeb.camel@suse.com> <20261111174259.41911-1-brian@purestorage.com> <cad66f75079fe0a89150e304d753527f140c67d9.camel@suse.com> <20261111230535.12947-1-brian@purestorage.com> <83f73b9cb1506eb80220759e3e0aae18648f80c4.camel@suse.com> <20261113194358.35028-1-brian@purestorage.com> <e246cb25f06744a1610ee1d78e033d6ecb17a31d.camel@suse.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 2026-11-13, Martin Wilck wrote:
>> 3. The array sends 3f/0e as usual, and the rescan runs. The sd
>>    devices for that H:C:T:L still exist, so there is nothing to add.
>
> Why does this happen after 2.)? Wouldn't the array send 3f/0e
> immediately after 1.)? If your "purge" functionality was active in
> multipathd, and/or if the libstoragemgmt udev rules were enabled, the
> SCSI device would be deleted.

Yes, the array sends 3f/0e after 1 as well. My sequence was wrong to
show it only after 2.

That UA doesn't lead to cleanup, though. The libstorage-mgmt rule only
adds devices for new LUNs and never removes any, so after step 1 the
SCSI device is still there.

Purge is driven by the checker. It acts only when a checker run
observes the disconnected state. If volume B is connected at the same
LUN number before the next checker run, the checker never sees the LUN
gone. It sees a healthy path that now reports a different WWID. The
array can't prevent that, because the host-side cleanup is asynchronous
and tied to checker intervals.

I agree that it is a user mistake. Within that window, comparing the
WWID against the device is the only check, and that is what
recheck_wwid does.

> 1) writing to "rescan" updates the sysfs VPDs, but generates no
> uevent;
> 2) writing to /sys/host/scsi_host/host$X/scan (this is what
> "scan-scsi-target" does) neither updates VPDs nor generates uevents;
[...]

That matches what we see: the UA-triggered scan adds devices but
doesn't refresh VPD for existing ones. For a reused LUN number, sysfs
VPD stays stale until something rescans that device. Fixing 1) and 2)
would help the udev side. Until then, SG_IO is the reliable check in
multipathd.

> While you can speak for Purity only ;-) I suppose most storage arrays
> would try to respond to INQUIRY quickly. But other things can happen.
> Queues may be full, network timeouts may occur, and fabrics may be
> overloaded.

Agreed, and that is why I'm happy with Ben's suggestion to run the check
only on paths that are up.

Brian
