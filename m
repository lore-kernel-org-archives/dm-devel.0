Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794599049;
	b=OmfrJzZO+l2ZZzFmV5AjOLjbblaSA+3Hwsh79Qlvqi5vKqJvawIgEwOpIzOa74d6ubQ3
	 E7vPlkeF1NTnzNICQjcFGpLfGR5ycFeK89xT2CJJpqEst2oZXRhkn0VycXgV6GiufHoEd
	 fBGoA3r1ZvTgb027/UH2tz8qUJHBXoiZOL5Fb9g756o40nKKAGHpOzRchj1e+72kx8Ygv
	 8UR+FapnguCyui0diU1hniaDny66tFpxLtOP/naX0DWIb9KNv+CFRf54X2CM5eMeahm6A
	 MjxGpFXuaGVWEcCANr347F9lBuEylrOEDTC0YlNwvs++cr4AbWl2pGaQePUF/8roN7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794599049;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SnQv0wT/YSXc//9mt04CK8TaQ8ILgFdc1l0sc1Ox+dU=;
	b=R7Q5ReE4GBglGbP2E5mZKZ5hjdC/X7FMtNBbh5sYmVHA49qW0WpvE/37pMKvJnQPBQL9
	 VWPyWsgP0Qd+J+5nUs7pJhK/wbFBT4bvjx78oCqsxboXwlLXQ7BalD6xSnGfGtF+hdchf
	 OBmubIJut8qKHXZV6uCj6rJb3vcmGR/ak8UqBzf/RGGXBdZYAPZt/435pf6tDPLMptrwL
	 9hkcoKDrtQDsO1pe7SnKmWZ4hkQdkXE7vFZnnJsPbRMT8lPNrHsm7KXK9qU0Oa4yUMha7
	 eIQ9eFBReYTu/MJmKtlD6JH1p/7g6Mg5DaRGUpdOJpyKrkKcaUwfXsKkwSOv3gSi+xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b="ED/XJKPx";
	arc=none smtp.remote-ip=74.125.82.48
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185EF606A887
	for <dm-devel@lists.linux.dev>; Fri, 13 Nov 2026 19:44:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 185EF606A887
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=ED/XJKPx
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-1a2af4c8d00so2772136c88.0
        for <dm-devel@lists.linux.dev>; Fri, 13 Nov 2026 11:44:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1794599047; x=1795203847; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SnQv0wT/YSXc//9mt04CK8TaQ8ILgFdc1l0sc1Ox+dU=;
        b=ED/XJKPxt8J6HLlcHxvsJISatJPAJdVleJguHhuwS5uMKP7RG0Z2+A2o2puWtcWyK6
         PG6T+MuRpNKtbtxoNul0kbIIf0HWE7lAXS2AgHjWmDlQg9AHHoVaX6buuVzS2iFPXlJt
         q0OuBbg+6a2jk8z/Sln+ff3pL0LynT0wmHSoAeXusKkgWWqkr1rj5fmkqBuUcnGF9Wrn
         zBhpnTo7Z3o+R8ZUZSmvjYLOoXNzgXr6oh/xVergH/CA/KFyR9sL37EtrWDL/+SqF8I8
         oNthJ8+YbX+6NwGoDPjmDUPz76T4BHqVMBN1DxNdrjNWAUzi6mLZ1e+5foCsXTQXNait
         e3Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794599047; x=1795203847;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SnQv0wT/YSXc//9mt04CK8TaQ8ILgFdc1l0sc1Ox+dU=;
        b=10K9ZXWrg7AJSZI5sBk8jEnYIfVhDnuho5gdv5CQ/Zzptd46C5gk0GxzZJADhMFby6
         iokT69cJM50xqtyF8l4ryg2gyCBnSf7gk/eqt9j4+ZENSA/EnrgJgyfwizXNMnmjnyZf
         Oh7fHasJJ3spqF0pH8QBkQi2/s7HimxYa0tysQ4+glxI3zet+stD5K1qOKS/4Xr7uZjU
         qc6gfBqHN6h85gKOxUh9WPGXFTVLz3wJi3+qGhWAeMZXbt/LGulg/w2Y6HG0bTYCBuQq
         kOolFkNx6YG+4BlOghoRI6tn7YwADeIc+nX9cSgqfa7IAMecYpun6LWWkhBnODi3Nt4Y
         FnoA==
X-Forwarded-Encrypted: i=1; AL+hErGkKfM32vhAtK5vppa8ypDgeGbumvQltXDezXq/kSBfH5x/sSVE4RBc2zT6aVTJa71PnidpVlZHeA==@lists.linux.dev
X-Gm-Message-State: APuU4Z839t6LAYFtrwGdNyEA/0f66OwFXPdm67C52aF0xCSZncaBZzly
	itfVxZm2AhmyAT2TWkkeJYkILZAR9EdoyJ3cMW0ZhjprVKIgud0lwpvZ2svzggSf23M=
X-Gm-Gg: AYBFou3rwGNmKv9epFeg/qzgYwBaek7fLe5LkLe4ja5GIEGPVstXkMTqJF6VF0eS0+r
	o0dFY2EsE2xXZr7ZD5m596gDr90nOM3qcTJX8hUXgo4sgVOLB5dBgW4IbYVvWb7zGyUy9MArg4/
	/nWhnACSOXfOyf7xBWSYZDaxTNU4wcOGLd4Hz/kALX+dU61q3a+zoHcVdYY9hJ6gU6VyJdb1a+I
	DXpUHcDe4P4SD4S36OsXyzPJPDsRty4yNrc/I2BE/de5ZDRHoIvUoWY0vNCytNJntW+kRO8kRn5
	6ha+LekdbsStij9I51h6x8Q4LtRq85IaFU6rWfX+6ScOyMtzYvppSj+UoC8Kqygg7/x0ui8VjYK
	2zedwmhXadVB1bX7Ritsmn+PbXXi0lyQg04vtbkT5sp9CTtgRaUeC7x56qD2AjP7CGKfMTd05+M
	D7yxdZYxypQKNsDGL9TyksOHg/Jaa8eN8jcy1q+0vbpPNb/kYPVZ/BdzOMmi2+/sBoBFARm6H7r
	UkJIxw2fWyvPahjhj0nvB1zlZW9vSSih/HOnJx22kZ6OW/x2VzHd7iTQ4HDiVkq+z90HAfqyLzm
	ND5oVjp6RrBLJC6RD+IW4F42n/BZf99qOWmtkGnwST5a4/oxx1X9TTfLegEehXPs1OAfXQ2ZCob
	B08d9seA1ZDQ7pLMiT6rmy0LjFVtpaJaJZSUThF1dWR+86EQTyeaGh46kNXBCNWUZOyMaCjzg0V
	m2JmxvnDzuVx5Q+lLgnSIIuJan
X-Received: by 2002:a05:7022:5f07:b0:1a1:47b2:5512 with SMTP id a92af1059eb24-1b50311cf08mr2666685c88.26.1794599046954;
        Fri, 13 Nov 2026 11:44:06 -0800 (PST)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.93])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b50316e195sm10872003c88.8.2026.11.13.11.44.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 13 Nov 2026 11:44:06 -0800 (PST)
From: Brian Bunker <brian@purestorage.com>
To: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
	Hannes Reinecke <hare@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	dm-devel@lists.linux.dev
Subject: Re: udev / multipath-tools: WWID determination with SG_IO vs. sysfs
Date: Fri, 13 Nov 2026 11:43:57 -0800
Message-ID: <20261113194358.35028-1-brian@purestorage.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <83f73b9cb1506eb80220759e3e0aae18648f80c4.camel@suse.com>
References: <20261109185556.27139-1-brian@purestorage.com> <214d18ebabeca8318352dfa5456bc5b37cdefdeb.camel@suse.com> <20261111174259.41911-1-brian@purestorage.com> <cad66f75079fe0a89150e304d753527f140c67d9.camel@suse.com> <20261111230535.12947-1-brian@purestorage.com> <83f73b9cb1506eb80220759e3e0aae18648f80c4.camel@suse.com>
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

Martin, Ben, Hannes,

Thanks for digging into this. Some target-side data from FlashArray
(Purity) on the unit attention question, inline below.

On Thu, 2026-11-12, Martin Wilck wrote:
> The kernel does *not* rescan devices on receiving a UA with ASC/ASCQ
> 3f/0e ("REPORT LUNS data has changed"). AFAIU, it isn't well defined
> what condition a given storage array actually establishes when a LUN
> mapping changes. 3f/03 and 3f/0e are both possible, as is 29/xx "Power
> on or device reset occured". 3f/0e may actually be received on a
> different LUN than the one that had actually changed.

Purity sends 3f/0e (REPORTED LUNS DATA HAS CHANGED) on any ACL change
for a host, whether a volume is added or removed. It does not use 3f/03
for this.

This UA behaves differently from most others. It is path-scoped (I-T),
not I-T-L. The first LUN to receive a command on a path gets it, and it
is then cleared for that path. The LUN that receives it is never the
LUN that changed:

 - A LUN being added doesn't exist yet on the initiator, so it can't
   receive the UA.
 - A LUN being removed has lost its permissions, so it is unreachable
   on that path and no UA is presented on it.

The UA is therefore always seen on some other, unrelated LUN. A LUN
whose mapping changed can never expect to receive one for itself.

The kernel emits the uevent (SDEV_UA=REPORTED_LUNS_DATA_HAS_CHANGED)
but does not rescan. Pure's best practices recommend installing the
libstorage-mgmt package on hosts. It ships a udev rule (scsi-ua.rules)
that runs scan-scsi-target on that event:

  ACTION=="change", SUBSYSTEM=="scsi", ENV{SDEV_UA}=="REPORTED_LUNS_DATA_HAS_CHANGED", RUN+="scan-scsi-target $env{DEVPATH}"

The scan runs per path and adds devices for any new LUNs, and multipath
assembles them into a map. This gives automatic volume discovery, so
admins don't have to rescan every connected host after a connect. Hosts
without the package don't get this behavior.

> So, of 3f/0e or 29/xx occurs, the VPD data may be stale. And of course
> also if the LUN mapping changes without any event occuring, as
> discussed in the past in the context of the "recheck_wwid" option. Only
> actively writing to the "rescan" sysfs attribute would fix this.

Reusing a LUN number for a different volume is fine when cleanup of the
previous volume is complete. The old devices are gone, so the new
connect is an ordinary add. Purity sends 3f/0e, the rule rescans each
path, and new devices and a new map are created. Nothing stale is
revived.

The problem case is user error: reusing the LUN number before that
cleanup has finished. Cleanup is asynchronous, and the array can't wait
on it. The sequence is:

 1. Volume A is disconnected from a LUN.
 2. Before the host has removed the old devices, volume B is connected
    at the same LUN number.
 3. The array sends 3f/0e as usual, and the rescan runs. The sd devices
    for that H:C:T:L still exist, so there is nothing to add.
 4. The previously disconnected paths come back, now serving volume B,
    under a map built for volume A.

The UA and the rescan don't help here, and no per-LUN 3f/03 is sent for
those paths. That is the PURE-503945 case. It is the "something changed
behind the initiator's back" scenario, and recheck_wwid detects it.
purge_disconnected is meant to remove the stale paths before this can
happen.

> Thinking about this, it might make sense to switch from sysfs to SG_IO
> in udev rules if we observe a 3f/0e or 29/xx UA.

 - On Purity, sysfs VPD can be stale for these resurrected paths. The
   kernel refresh depends on 3f/03, which isn't sent.
 - Using SG_IO after a 3f/0e or 29/xx UA is reasonable. On Purity it
   would trigger on a path-level event that lands on an unrelated LUN.
   So udev or multipathd can't rely on the event arriving on the LUN
   that changed.
 - That favors verifying the WWID with SG_IO when a path is re-added,
   as the patch does, rather than trusting sysfs or waiting for a
   per-LUN signal. recheck_wwid is a safety net for an operator mistake
   that the array can't prevent. It isn't compensating for a normal
   discovery gap, so the extra SG_IO is only exercised in the error
   case.

> Brian's patch would add more such ioctls and thus increase the
> likelihood of observing a stall. To be observed.

On stalls, I'm not aware of Purity stalling INQUIRY or VPD requests on
healthy paths.

On Thu, 2026-11-12, Benjamin Marzinski wrote:
> Since recheck_wwid is set, we could just limit this new
> check_path_wwid_change() check in ev_add_path() to paths that are up.

That works for me. The resurrected paths described above answer again,
so they are up when the check runs. Paths that aren't up yet are
covered by recheck_wwid once they come up.

Brian
