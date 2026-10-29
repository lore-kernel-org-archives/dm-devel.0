Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793296660;
	b=iXHCgsMdHPMfetVBnL7WYxCg2fWv9A0wgIxRJLD1gSCsXBRVY2JoMnqilibKAP7da9pY
	 5x7B7S3In5pLB78Gh4PzyPvVASYe45OSNdLt9PzUu+OU4xUSCeRcleEIvIQSvcDF3W2rC
	 lNtGp9av8rfVcdIfqETCLkg/RvaYuge7vTwteUyodegvU/fqRWmXCOFx0VcMD72w/hdZk
	 wSrFHXO+EOFQEwsQzDJ3G/BI300dGl2qNsVgmOYMx22MC9CrPsnbfDFbssDavU/5KiMG9
	 zZIfwaYFEc2aZADS9rZEXDa1FAzYPKjsa3qf5aDbeCybaiR2zyLkWrdl1HVBzewNJtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793296660;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=RDJdPxkSxNirgIJ7pZ00HxW5AOOLDCt4ppaJGPipTXs=;
	b=PPasfTSuknotpJ7HHHcuM421xeKXMl2pHV3SrhJTDifQ/gZSgL5TL6+hIjgiyHICQKck
	 uK+fOKTcyPtKVY34pK4uTrSo0+TyaAHkO7VsJAZcqgWzshbbMnOqnfRfi7iiCkqIs8Usv
	 olfxMeSUJAp1YOTrBRLaTqyeNxuaIC2aCIZCUqRj/FrNTO9bg1HKQpJDb+c4d9IoVQZiy
	 qIdiD9qXgkTdrJ4Esw+aFZ8cOZO16XZDrgnf4lW7gdz2sk/qns4dpqsDrQZgCreVoKKAW
	 tkgWlv1F4KeQxhqZZMbN0a4QXAWcWfX8JZuWRmZM/KoUrLLArH6RunrREyIOJlW/80A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=McBKbpT7;
	arc=none smtp.remote-ip=74.125.82.49
Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4FB606A31A
	for <dm-devel@lists.linux.dev>; Thu, 29 Oct 2026 17:57:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8D4FB606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=McBKbpT7
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-15ea896ddc8so3632507c88.0
        for <dm-devel@lists.linux.dev>; Thu, 29 Oct 2026 10:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1793296659; x=1793901459; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=RDJdPxkSxNirgIJ7pZ00HxW5AOOLDCt4ppaJGPipTXs=;
        b=McBKbpT7LBURKbMhCFCcTMWNgWQibJzFnwYVyVDmiqZ8bbWep9MukOO0xdQ1aQydFZ
         lP5zyN48n36vUpIOHwGBMecTIWeViTKvooil5uV9Az5KiLhHfUlCQsoHf1SH8vh5/u4Z
         Dt6zcDQlXZMFYehVHh4oSZirVeqYlviV4s5iXzvDmGD3+/f05F8BnUPOnNkxSXMmo96d
         vKM7i/O4+nXO6RS42I9x+HtWoErR4JgvuBmncMX8C0BKrS9C1dK7dxAD3avhB604w8vi
         kwgN7C96ge8WPueEjPpDx5u0k4Yy3nA+5UGB/B7vd252977LgFbJkmfXg+blmpO44YQZ
         CAVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793296659; x=1793901459;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RDJdPxkSxNirgIJ7pZ00HxW5AOOLDCt4ppaJGPipTXs=;
        b=tnQx7NYzX7ns1KCfE1osX8oEgO5YBP1dH8woXQu5M1xcdt2UPWAnRwBSv6c9itoUC5
         Es5buYp+5tFRRnB88TRlEtcp090bJ1Ed7mL0VsMRn2+S30dBUaSV36MoG9R6DU+futB0
         pKo5YtiQEf+JLRBx1dePTkDIubUiydrEzEUpJbOGrbkgxby3cJcqFRUsGu0DwfgneZ8N
         9e5hOofHaAHFd8RrL/as5KDCT+gqdo/4CBd6Mw7dqVU36rQyQY2VXISS55adxTWIZpjW
         1tu0qY7Cm9HR7r0jBkfoC5M8LkpVDrLNbuoG/B8deH+FXt1GAXRiafIOQidS5NdZzH45
         35SA==
X-Gm-Message-State: AFq9FYLuXJ0GHGbyIaV+mbGOj2dkvgElyvmL5JA6yS2vHcRqQSVlvQPL
	6ahu4q5JL3wVJVlBJA39DijXgCl1TQnNkod/hWSxUF1ioNpqYJd6oiB+YzG1TDHueBv6mPoOMsN
	FaooGLN3r3xzRBNjAA7sj1xJWC58f4UuSgJrXsvrayXdCLHFeeUbE7ZCeb8sJZxmbpWbhUT8XpB
	ampmDEDNnGl2111eRRvCw0Vi2ZziStnZBsOCC7PkzxmmsJs6g=
X-Gm-Gg: AYBFou1mrRZ1hUNPBkHeendT+pSX5XOw3KGYQV6NRaf1YL2Gi4XtwZMweOXb1nHNQiM
	c55ONUBYPIkGZ90IiE/NTFJZVpUaq8PEEbEeUYs9gypIvxAKqAO2QRxpfdfR4I6wKZ5IeByKBLX
	XqzTuBly1pZrjUnHH/P10oazvhiSHGtc466sZTr4Hi/VcEB9PAZaIB4A3ztu5mtFhz+UgEfqmlH
	UBH2CvHgXoJFCI5PeI312/hFV2Sgi6khmfQxbj4dLyAGSsPL0EldPPdQLloLhI0JgQn0kpoLWR3
	nZUfArozygbAKJTkO4Bsz/iiOnYKhlMnLjr9pOlTj4yr007HODntrY2pLflc1p+kDCPhthdYb9e
	KOV/0qYOjvzHdikarycZPPuI/b6r27SIrtLGkn6LMU7hszBkAaSDwcPQEctbEkTF1CCGTjvn8Ht
	g3We/wZ/eDm5a+Wc4ylzqUl3x19d9x48JUMCTuu1dMJZIorEsSF3yYICNMDenN0NZaBbxv/jh/1
	zqR0EvWtITZ1YwtUS1o0G+NOqFUyMG41A8Ot2VVe6pZcTrzsx8PYnjR3nj6wIQoiyxHK103j6b/
	rP3ArBYtb+eLQXkQva9CAelt+WfBn8z6D4i2qpy03mxAazG/3WQgplyQLzleSb4Fv5Pxv+LzCzE
	ZsYE/PFPbMG81dp83POSuuA5iNhgIeJxA1xh6DFLrxPNU+LsW1W+l8YQWmazwFI3WRGXfOQIfZC
	wcnJDWZcDO4nwYhFouypY/lnfL
X-Received: by 2002:a05:7022:b0c8:b0:195:9228:50a0 with SMTP id a92af1059eb24-1a6d0b62961mr7859794c88.42.1793296658207;
        Thu, 29 Oct 2026 10:57:38 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.93])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac13ef1932sm327878c88.2.2026.10.29.10.57.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 29 Oct 2026 10:57:37 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: dm-devel@lists.linux.dev
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
	Martin Wilck <mwilck@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Brian Bunker <brian@purestorage.com>
Subject: [PATCH v1 0/1] multipathd: don't trust udev WWIDs when moving paths between maps
Date: Thu, 29 Oct 2026 10:57:26 -0700
Message-ID: <20261029175727.25457-1-brian@purestorage.com>
X-Mailer: git-send-email 2.56.0
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

During an array controller failover on an iSCSI host, multipathd
briefly put a path to one LUN into the map of another LUN, and I/O
meant for the first LUN landed on the second. The host ran RHEL 9
device-mapper-multipath 0.8.7, but the code involved is essentially
unchanged in master.

What happened:

1. A change uevent for sdq (verify3) carried verify1's WWID. The next
   uevent 4.5 s later carried the correct one. We don't know whether
   the array answered the INQUIRY (VPD 0x83, run by scsi_id) wrongly
   during the takeover or the bad value arose elsewhere in the udev
   path; we have no packet capture.

2. uev_update_path() acted on the uevent WWID without asking the
   device and removed sdq from verify3's map. That reload blocked for
   4.4 s behind I/O stuck in the failover.

3. uev_update_path() then called uev_add_path() with the same, now
   stale, uevent. ev_add_path() put sdq into verify1's map, where it
   stayed for about 170 ms. Test tool records show a write meant for
   verify1 landing on verify3, and a verify1 read returning verify3's
   data.

recheck_wwid was off, but would not have helped: it is only consulted
when the checker sees a failed path come back and on "multipathd add
path", never for uevents.

The patch reads VPD 0x83 over SG_IO in uev_update_path() and again in
ev_add_path(), for paths where can_recheck_wwid() is true. If the
device still reports the cached WWID, the udev value is ignored. If
the device doesn't confirm the WWID a path is being added with, the
path is left out of the map and udev is retriggered.

Open points:

- If the SG_IO read fails, the add proceeds as before. Refusing the
  add would be stricter; opinions welcome.

- The checks depend on can_recheck_wwid(), not on the recheck_wwid
  option, because a mismatch at add time means data corruption and
  recheck_wwid is off by default.

- "multipathd reconfigure" builds maps through configure(), not
  ev_add_path(), so it isn't covered.

Brian Bunker (1):
  multipathd: verify udev WWIDs with the device before moving paths

 multipathd/main.c | 57 ++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 52 insertions(+), 5 deletions(-)

-- 
2.56.0

