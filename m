Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794418992;
	b=hZ+AQiN71RANVzOohTLxoCL6d9ckGMO4nxwVJakwmd/1tOR0QBUg2N5zVCi8bpRvFlqY
	 lAxLVXAG6l7yZpDmR9aqsSBLOcEbMV7pg31zSeXJOXXL2aG3/iFSyG0JqpC6XFv7/rWfW
	 Md+1WhwUKaQZ6HFSiMnMzDIYZke08B8et4XokIXvOXL5BAHW/iXjgS+YS8Mxg2dbkWypY
	 hF9dCxizDTIxnpfQSXpiyD73u3JJnAyI4KQSHROjc2QPLva94Kbnt3ZTP/6O57FI51ssp
	 vUx6AFgeELxV8rYrmuXlBo6uh8oxIBR9I5F+ZxC4Sk2fsFq2DSF2XICuetDe9OraAfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794418992;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gbXqsW48tIYerukGalV9MzvxcoHEzxq/w8YvU37UBzI=;
	b=NWr4bSAj1thVKiJg0PfuI8gV5vv9nMOEqb5j2AU/y3OCXQmbsXjsZJWNpb8vvJyfW+bG
	 4lVw2yIorOe4QYUVEqZdKw2eQy5uzPXLQ4JNm4VpyxpNnMmhM7xSBdLpXMfOsj+yL4np6
	 9caUuN1TtzqnFeBfTeZ90+yq/WvsMHw/+Kc7PypOFA4y4mb3x9EM17PfhSJLtTuDwlbL5
	 E5g5u7O5lc1+acm7ez/e63pG/K3KZcjQC6VGfzFc4ylSz36R7sQ4KrP7PNNQXPVuxTHnc
	 hG5Nb0z1PphK+hNUt8hV9gSXUel8iyi6tWHwOFCjNXNVJsCF1NehRyfI1d6fkc0VG3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=cLuhPqxW;
	arc=none smtp.remote-ip=74.125.82.180
Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8E3606A321
	for <dm-devel@lists.linux.dev>; Wed, 11 Nov 2026 17:43:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5A8E3606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=cLuhPqxW
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-372bdb942dbso4386187eec.1
        for <dm-devel@lists.linux.dev>; Wed, 11 Nov 2026 09:43:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1794418990; x=1795023790; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gbXqsW48tIYerukGalV9MzvxcoHEzxq/w8YvU37UBzI=;
        b=cLuhPqxWQoJhSoub/NIyeDZCps3BT0YBy02dUqo1L0RC61BtfUfg9A+bX7lkUW2BYv
         U61wixWeV5HEmgowQz2L2BDt8qIU2GTOPdTkCvMzPcRwNLEgYd7qfW1Me8yNvaU8yupp
         f+E49FQ4zG+8lQcE1kMIFRNMc9ww7I053dc0qBSopg442/FojSZ88Bgu6eyKT+SoqUXU
         FUpBz/a6gyG812RWuIbUKIc8x/gMH/QJFvyQ8Pixdtic8eMWBjzixkRiod+Qzjuat1st
         9WT0ZTHUB6YK9Hu5HsqEkzAqctRPmiQiknI7I5Ds2IiOxcSrxENDnYMz8fNUHGrbOS40
         XS2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794418990; x=1795023790;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gbXqsW48tIYerukGalV9MzvxcoHEzxq/w8YvU37UBzI=;
        b=ms+VWw/8ebJ9HISVBSHpFkOjTfN7dMv76wzfOyKUqlQkFZcyaNslBV6a+qETq3fMqu
         xJ+GxNCP+uB6Pgkc4UTsPTr8JApymGx7yaoQlYtI3oY48aUT8SwTIijEzzg+9ydnSZp7
         Px+05UmdZizs3HfL8TdiHR6lWtgmRGtc86CsRnCmhf51+nGmNAIL5OOPH/3azKHH2+9e
         R9KarP5d3cRkRu1xSwMEgN+05jnAY7aM4oykAKOcHJrFdRFwrccM563vLLK51Jwe/OIj
         uMfqhPv9Z9CFWgd1q0vaJ7VJ2fZXW127vaYP64WlEIYOU7E8gjzzDZXTnxvrMiShRfp2
         L7DA==
X-Forwarded-Encrypted: i=1; AL+hErGNVBOYhC3IRvH8CMBrR+iv9Pa/XNHouNslI64ENysBcJ+pFDkWGNyXZNuvpSByLHaxdRyIlZo+PQ==@lists.linux.dev
X-Gm-Message-State: APuU4Z+ysu69nq529ClJYg36rVqzfoGPeuUrRDxbs6Z5wNw6hrHd/pvh
	bCrDqPPtNdiJpD2r31ZkbcTd8Gv9s15vCqxVdeNhmOH7WHJk5oJLnZTZZ840/EAYYHLFp5vmTh4
	3a40cmow=
X-Gm-Gg: AYBFou3Nu4uaR3A6cFqW5onBXAzkM+AcJIl3VPQA9L8Ai9//OTophvqfX1iN/HS3OkX
	rmoATK9DM0BPjrQNVTdkpitnB5xg4turUWHXyC6DeWRO13B7wZtmvlqCCcdChTMSXhdQvEUOsuy
	6L8xNzi4c5qIq7PwrmnlWfkp2jug4gniEhDe1YRaaCW8hLUngm/otHXIWMUQ01XmwrwDFpU6c41
	yW3afMfGThoLOAfRKXPQNes5CzERIRxGr2RnREwMfOQz9FA/DKsae1wN31YmCqc/02R7qFmJExk
	uUjHmczoLwG+zJyFuL3GzD4yycF96FS1zUMteYocGanLD3OVm+Ocji04ZwqRsWVrB2H+F52ZX0B
	4nEcnjK3iJCUcKjdF5psaHmFfGoKj4tf0YGXKMbCARrZc2tIuxgncYppQmfN6ZzXKidflnLxo4C
	/LOuu4dCkBHayNiF+RLi+VlqKQWgA3skPkmZftvTI8ZSKOflx1x7r8yQhEl2wVMecYbIm0KCPnZ
	/w/PWTyZxc1c/vQ3ojMk36V/cV9LViX8Sj0tsm2JxAN9B93xI1SCk1oVLrvTpqbclHpRHWvVRbl
	sNWHXK2GrhqXUlCD1Y7H+GQDllzt4hrUS5Qa9QlSjOEpuKbdOXF4H3n8u+rx2mv7eVZTWQ1QjUz
	7czlwx0fmqvFxNR196ZCM0qL548JdSuZ/NMp+MF7UqXoyJ99Odnhfhh3Z9mQdBgNhSKuRA/uz40
	StaWwLjutpTjEBXfZ2hoqCQx3jsg==
X-Received: by 2002:a05:7301:1a0b:b0:372:598d:c0bb with SMTP id 5a478bee46e88-37685b814c9mr3356698eec.13.1794418989970;
        Wed, 11 Nov 2026 09:43:09 -0800 (PST)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.93])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37520bf3e18sm35859070eec.16.2026.11.11.09.43.08
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 11 Nov 2026 09:43:09 -0800 (PST)
From: Brian Bunker <brian@purestorage.com>
To: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH v3 0/1] multipathd: check re-added paths' WWIDs against sysfs
Date: Wed, 11 Nov 2026 09:42:59 -0800
Message-ID: <20261111174259.41911-1-brian@purestorage.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <214d18ebabeca8318352dfa5456bc5b37cdefdeb.camel@suse.com>
References: <214d18ebabeca8318352dfa5456bc5b37cdefdeb.camel@suse.com>
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

On Tue, 2026-11-10, Martin Wilck wrote:
> I am confused. Does this really fix the problem in your use case?
>
> You reported that the udev-derived WWID was false in some uevents, and
> you said that, as the test was running under RHEL9, udev had obtained
> the WWID from scsi_id, which uses SG_IO. While my previous argument
> that SG_IO can block is valid, it's clear that *if* SG_IO works, it's a
> better approximation for the REAL device WWID than the kernel's cached
> value in sysfs, which might be stale.

You're right. v3 would have caught our case only because the cached
page happened to still hold the value from the original scan. That's
luck, not a design. v4 goes back to SG_IO.

> "Elsewhere in the udev path" makes little sense to me. As we discussed,
> udev on RHEL9 uses a VPD 83 INQUIRY, sent by scsi_id via SG_IO. The
> WWID that multipathd reads from the uevent represents (part of) what
> the storage had sent to scsi_id. If multipathd uses SG_IO and obtains a
> different value, then either the storage must have answered one of the
> two INQUIRYs wrongly, or something must have changed in the meantime.

Agreed, and I'll drop that wording. I don't know where the wrong WWID
came from. For one change event on sdq (LUN 8), udev's ID_SERIAL was
the WWID of a different LUN (LUN 6). The logs show no SCSI device
removed or added, and the array's LUN map did not change. That leaves
the INQUIRY exchange itself: either the array answered for the wrong
LUN while it was promoting its SAN layer (it became primary about
450 ms before that event), or something on the initiator side did. We
have no packet capture, no udev event dump and no copy of the kernel's
cached page 0x83 from that moment, so I can't tell which.

The event itself was most likely one of the synthetic change events
our test tool generated: it opened the sd devices read-write, and
udev's "watch" turns each close into a change event, which reruns
scsi_id. In that hour there were about 3,600 such events on this path,
roughly one per second, and this is the only one we know returned the
wrong WWID. The kernel logged no ALUA unit attention for the path at
that time, so I don't think the failover generated the event. The
failover is why that one INQUIRY could have gone wrong. We have no log
that ties the event to a particular open/close, so that is inference.

> IMO, if we can't trust the reply of the storage array, all bets are
> off. Why would the reply that multipathd obtains directly be more
> trustworthy than what scsi_id had got?

It isn't more trustworthy, it's newer. The sequence on the host was:

  09:26:34.808  udev change event for sdq; ID_SERIAL is verify1's
                WWID
  09:26:34.833  uev_update_path() sees the change and calls
                ev_remove_path(); the reload of verify3's map then
                blocks in the resume until in-flight I/O drains
  09:26:39.221  the reload completes; sdq is freed
  09:26:39.235  uev_update_path() calls uev_add_path() with the same
                uevent, and sdq goes into verify1's map
  09:26:39.379  next change event for sdq; ID_SERIAL is verify3's
                WWID again

So the add acted on an answer that was 4.4 seconds old. An INQUIRY at
the time of the add would have reflected what the device said then,
and the one 140 ms later was correct. The check doesn't help against
storage that keeps giving the wrong answer. It stops multipathd from
moving a path into another LUN's map on an old answer.

> One possible case for a WWID change is that a
> a Linux SCSI disk is removed, and another disk is added later, taking
> over the previous device's dev_t.
[...]
> This sounds as if the WWID of sdq was that of "verify3", then
> "verify1", and then "verify3" again.

That's what happened, and it wasn't a remove and add. The kernel log
shows no SCSI device removed or added in that window, and sdq stayed
2:0:0:8 (65:0) throughout. Only that one udev event carried the wrong
WWID.

> Question about your test: Apparently the problem is reproducible,
> otherwise you wouldn't be able to verify your patch. But you said "we
> have no packet capture".

I should have been clearer: we've seen it once. We haven't reproduced
it. We've been running a v1-style patch on our test initiators since,
and it hasn't recurred, but at this rate that doesn't tell us much.
We've also changed our test tool to open the devices read-only, which
removes the flood of change events that made the window likely in the
first place. I'd like to get a capture, but I can't promise we'll
reproduce it.

> With this in mind, I suggest that you go back to v2 and SG_IO.
[...]
> I further suggest that you make this code
> path conditional on "recheck_wwid".

Will do; Ben suggested the same. v4 does the SG_IO check only on
PATH_ADD_REINIT, only when recheck_wwid is set, and drops the
uev_update_path() check from v2.

> In the long run, we may want to redesign our WWID detection. We do have
> a general framework for asynchronous jobs now. Thus we actually could
> run asynchronous VPD inquries.

That sounds like the right direction, and I'd be glad to help with it.

Brian
