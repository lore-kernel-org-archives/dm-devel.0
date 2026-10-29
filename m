Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793317976;
	b=HSUt9M+3c4VJrxe80F5qO8FdqFn+Yv/xsgq1B2zHa2C55yvR/TMCkABfe9amRKYNylQ1
	 f4zRBv1tx+3qs9B3QB+IDVH8dLldFOxc9VYSTs/lEpWOod+OFAZrhiIiSc7M6MZqCI41M
	 Uxe8YidfSYDROPN0AOS0YkZtLkp912pCNZ0bTtZgIuppblS+iYWIb/QORjq8h1cIpSyBB
	 J+nm3jWYo+tM0Htlz05riUQf/xR3yzUak4OVEtQbZkjU4aL7kOJCG4RFjm6/l4kLlQeqr
	 kK/4VAV1JoLTVns/cAXAh57NuXrqa38x3iMphNbEwwz0KtPCfC4fondYCHT9HXppSTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793317976;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=4cbV7oecPRtSH0xS4TaYfYsnWn7bMQoohgR9cVgnPgo=;
	b=zyCX3P693pKnx4QwEChAXGBL5VPAlRx+/FBYkcfTRyhwuqQ2TbDeEDv1vFPVJaETG6b5
	 iMMJWO1P0UM36igGPbJ00wUxBtKR0hVmuyDXX5t/ph19dHxNInG/rMwyo4/3ogiExCoqv
	 xUAEBqsCsIhzl4g9B5+mJcitlj6L9taNhcTaAIZS9oYgHDJ7MehL7ZOV7penJovyCLkEl
	 YwaM7p5+xOvjfILIgyTYMiJ+7IkWdVaIZ7XAP1eKQA3KjkKMJP1HljZ7R9NqarFLavgvT
	 cDc4CfXfjaEq1pgmivI9e9nC7TeVWAWB++3VM9h9n2s+9Q2n0+Dpa7kGE5iwJzzhBYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=dKHcQp8+;
	arc=none smtp.remote-ip=74.125.82.176
Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70920606A323
	for <dm-devel@lists.linux.dev>; Thu, 29 Oct 2026 23:52:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 70920606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=dKHcQp8+
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-35cd4e8bdbdso268888eec.1
        for <dm-devel@lists.linux.dev>; Thu, 29 Oct 2026 16:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1793317975; x=1793922775; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4cbV7oecPRtSH0xS4TaYfYsnWn7bMQoohgR9cVgnPgo=;
        b=dKHcQp8+8+dVljZ04/EPq4owyhiOzU821nsB8g4K38A0vACAbyADL/TQVbPSfh/5u0
         CJ6obmLevpicciHZiEc6SF2V2vHt8T5SeCXW1DddSxBuGKcwghZkwwmNECZYoc5sZZ4b
         diQcmnWGJQR4diB4YKUpsSfLb6q7UsVAjjDrGZAmCbFs5C/nnFIYFCmnueCvgsa4PD2o
         zNen2pmYOUVTOUnJQXbTrA6ncR0Dp2N45t2e0k+Uch5N+KgWD7q+MZ8yMS/FH7C6P4yS
         XVIH2Ns6zVs3bNtjbn1OVaJo5r7MiWCYDT+WtZlPMJdtk5BoONCmZEQC/ZwBGUxUN9v4
         rr3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793317975; x=1793922775;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4cbV7oecPRtSH0xS4TaYfYsnWn7bMQoohgR9cVgnPgo=;
        b=0wNANeB51qDX3Kw1CWiGLy7iWLX7rZnBfPoIFhXBcm/AW2xsDb6khLDpHK06wbcy4w
         D/DownzbbGxFIh5CdaD2p9rnEfIT9B2WZNif3aL9QJJQouQLShwZGXlJ2L3yDZAwa8sq
         cvSQD7ESsREc1c9RdZe15ZX84I3cftEPw1M5azaTeb5jB8z1dZymdlCkzz/wFHakyKIB
         o+n72WKCNYxNhngPBbnB43EqM1GPaXzCeSRq8p6Vz6+qBzVYi1dO39R8XhZo5JWArrps
         D56GDknVwU0/zLGDJbIVe0b9/ivmMyWG3N6M/gwBJvV+EDQSJwy5FKXKjMJj2lbH7boB
         R2ag==
X-Gm-Message-State: AFq9FYIx54G2ZtAx5Q/TAICmFEDShBzgG+TpZbrHJMXkYc5z57f2rIgc
	W+rzuiodzst7CCnI69rwgiFPI0Q0a8clKRkhUAgmqaku7VbXMxGqFNswaoCQ5ZW1FbPZ7V9OvxP
	40TwVOHu/yVmFF7majjfCxrSu8guU1THbN30l4bzTq3/R8IR46QU7oHEY7pSTadeRGH7kGCr2Up
	FYtXrEhWvOPdl5OYArjXIV5djqCwE3h42IRuPnAYPFWdOoEVk=
X-Gm-Gg: AYBFou2vQ++vKFvFg+sLOFKZ6r8foezhtU/CmT+Fv9KQTGklCnYNuQAaI+t/FvhhwqK
	7dhN9PUMq2RYaRtr4jKzwpbPUTNfToBLwgY+g4TmTK65ztuGS5TCLfwyaHEI6gKB/p4dMkdDZlJ
	TLVLHWJKFQJ7Y8TF8v1MSY7RkT2aJLxJrNIdcrORjD8hCYfVN0e6paPWOrJh0PhQhJFPRTL/6Ic
	/RQwTjffDI4lD7YcxD2PuwcFNPRtXogQCApJLaSg15bwNvLo9SfVRDrpKscRLNbt6PWWG+EtM9j
	31XldeRb2oIsuuu7ExZSJmwR/uaidX9QL4Rq8H0bnzgw9MDbLJCirr/dWlhZyEP0siZnaOW0Agy
	6JbfZYFjOd/aO401k0inEnbk69nFIlNifJWTcsEgI0K3ywmixeMeV/leaFkyErRlge6VBpOH+lB
	yUsrt0Q+dwbsL6EBn6U5+LNptUkwEBRZvyhqlYk92ONZUwPI5X5K51UtD2gD32dqSRSyy0KEgZc
	ICikcg3O175JoI66vXxWW4xDqEsJ6alzdnpxjwiFV6qYogubEdqyrvrCd9CdJGaAZksZWwGnvDH
	QoBbE6/ITp+IsgPTfc/RGZyxeuJe5rEVKPi+laEH4u1hdco1pUniJjxIfIW6Z3iJ0KnkXI3lNdG
	bzz5oKDQ+LxSbbxPyTF5G4s9AoM2do+90GMSurKLIAWTDYPx3lfZs/yCLxhkRclc8MMqQeOaq6C
	9FA0qDvovk2tMKVtoVUUfvA8Qq
X-Received: by 2002:a05:693c:87c9:10b0:360:e2e6:f849 with SMTP id 5a478bee46e88-36a4241985bmr1219504eec.28.1793317974075;
        Thu, 29 Oct 2026 16:52:54 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.93])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a426681aesm2269132eec.1.2026.10.29.16.52.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 29 Oct 2026 16:52:53 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: dm-devel@lists.linux.dev
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
	Martin Wilck <mwilck@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Brian Bunker <brian@purestorage.com>
Subject: [PATCH v2 0/1] multipathd: verify udev WWIDs with the device before moving paths
Date: Thu, 29 Oct 2026 16:52:40 -0700
Message-ID: <20261029235241.97614-1-brian@purestorage.com>
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
unchanged in master. See the v1 cover letter for the full sequence.

Changes in v2, after Ben's review:

- ev_add_path() no longer double-checks the WWID on every add. Ben
  was concerned about adding a check to perfectly normal adds, since
  a SCSI device can report several identifiers in VPD 0x83 and
  multipath's SG_IO code has to pick the same one udev does.

  The need_do_map argument of uev_add_path() and ev_add_path() is now
  enum path_add_mode, with a new PATH_ADD_REINIT value. It behaves
  like PATH_ADD_MAP, and is passed only when a path is re-added from
  uev_update_path(): after udev reported a changed WWID, or after
  udev data was missing at first. Only then is the WWID checked
  against the device. Ordinary adds never run the SG_IO check.

- The uev_update_path() check is unchanged. It only runs when the
  WWID from udev differs from the cached one, and falls back to the
  old behavior if the device doesn't confirm the cached WWID.

About how likely this is: we hit it because a test tool was opening
and closing the sd devices read-write many times a second, and with
udev's "watch" rule every close generates a change uevent that runs
scsi_id against the device. That is far more udev traffic than a
normal host generates, so we expect the window to be rare in practice.
We don't know why the bad WWID was reported; the array may have
answered the INQUIRY wrongly during the takeover, or the bad value may
have arisen elsewhere in the udev path. What the patch does is stop
multipathd from acting on a changed WWID without confirming it, since
the result of acting on a wrong one is data going to the wrong LUN.

Open points, as in v1:

- If the SG_IO read fails, behavior is unchanged. Refusing the add in
  that case would be stricter; opinions welcome.

- "multipathd reconfigure" builds maps through configure(), not
  ev_add_path(), so it isn't covered.

Brian Bunker (1):
  multipathd: verify udev WWIDs with the device before moving paths

 multipathd/cli_handlers.c |  2 +-
 multipathd/main.c         | 79 +++++++++++++++++++++++++++++++--------
 multipathd/main.h         | 12 +++++-
 3 files changed, 76 insertions(+), 17 deletions(-)

-- 
2.56.0

