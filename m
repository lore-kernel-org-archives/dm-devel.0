Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794854603;
	b=5LasTmOhxsQ6iHSxaOgOphJjVJ5Zp9sevSN8FhUeriIihwan/1iAekpd7IND3xCrTt8O
	 O+zMJAvXRF5ZSxVWW+SgjWQ3DaOXY4qbuZFBOhaIyl/wctWlDsaX86qCDQbl7baBLKkjZ
	 KFIkyDQoFJzv09UbIp/jbFXHYi83/CJ3uq6uh907OlDcII8YcC+uvfo4P01fxdbAormqj
	 KrWGhFOc46QEYaGRlu7sZuChHXCgQCMBdinzKdfncuKD//EQ6oldOaXxDxEDsjNP+PPOk
	 dg7/kGMV4bgT9+wkax3ikkD1vOH03ut1742xOEXtkRoYPi6Lxxd/A/y4PeOqmu10hrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794854603;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cWv4nCYUyaeSS8o0JAFXzrRg6Il2rZPe/baPeAcjVXI=;
	b=1nWbrn/ysQOC/X6y8yQ9YgAYGe257kdglJo/AcfFqUk8csVNomIT/D4vZ1rRALETDNoK
	 SR1FZhQRPNIUBjXfptq1gH31q22COCYORD+V5rjN8R01n4Y+l9so++CYUuwlrF6VKU+2M
	 0FPzn/JqNQTD9LuaJlWETXBFgoUvnaJuLZyGSlwV2oEBfiQ67IGBZoGaRq0I68Cc+pt0y
	 z6aKPHPcu/MnVQf+YE8cjOjKDOwEBnj3eNBNNTibZtcN/WeNVhPcGghH28oPK4WHNxV5H
	 UVjcca1nx9GBoG/dKkmzEz8PRc3AYP/UnO7ePW3QmRkwOeEyAnWe2EfoXmKGdd/7oYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=AlJkfQTy;
	arc=none smtp.remote-ip=74.125.82.49
Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5B4606A322
	for <dm-devel@lists.linux.dev>; Mon, 16 Nov 2026 18:43:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A5B4606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=AlJkfQTy
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-1a8cc11ac42so3716207c88.0
        for <dm-devel@lists.linux.dev>; Mon, 16 Nov 2026 10:43:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1794854602; x=1795459402; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cWv4nCYUyaeSS8o0JAFXzrRg6Il2rZPe/baPeAcjVXI=;
        b=AlJkfQTyQRXp8C0RIFfv5P6TS/AY7+VyzHSAmp7uMcWI81L0pRQY7JHecv4SQy56w3
         IlzNkv3Ymes0W6lr1Sdrub8mNVJNmjbhIT76Wqi1/5DgyqmNsp+pWH49vHg/+FzEAB27
         Tcp6eeUaPAF/46jfxvxhMP0CBWES6lOIuSyzO8Ap5fWB+uXhwe+g3j8mC56CHhdbA/4e
         8gj2lusHN7Y93PSJ0fiLP7gI2N2m6SlB+HvW1VqVK8x0/Vs5da9Sgj9ihqzjrHWgh6Gf
         DpvER5a7DMPb2LEOcR8t8RAFFzg1VnaqoNd2nfEDfY38coywcaam1kIJjdHHZzGCCUYF
         g8eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794854602; x=1795459402;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cWv4nCYUyaeSS8o0JAFXzrRg6Il2rZPe/baPeAcjVXI=;
        b=jZobzk+mx2/THLA6YhnU0seP6IGNgEpwSd24ArvAfu7VsyHL7bOwRPTza1GvRBGmWD
         ph3CZo9Pd06/BI5wfBoPkiq55FbTH1IHf7c9FOLtAMFVno96jYF2PZqt2nVuMudc/IHU
         YsmdwMQkqNIJKUHFMB6BQvGFjxRoCe9e8C5Iz4YxnMscvhWUGk5n6gzBlBzOZbXm+0sV
         y89MJIM7pXzR6YHP61GUBzSpuZvATZV1uAXpVjBNJn+8wsNYgT+8sff+gc189EaDNrFZ
         QGSkIIRROLQ2wOEGg3PjBAgJavGTovSlx7JT30usnA7Cx0iueT2H5rO8RKfl3JCK3LVn
         feqA==
X-Forwarded-Encrypted: i=1; AL+hErErqOoFDbP4q7JFYRTsG6hwHD9c/hLlKIZaIk2hqZHWYi6mWxMdeunmbT/AhEFzVGOiGcHAuTs/dw==@lists.linux.dev
X-Gm-Message-State: APuU4Z9tYPM10yde4ym+XErcHkU2tCnjDOmJvEvaK0DHTyAQxVrylt23
	TTSWqinsF4An5YFM3lbNX5Kjanjksylp+LYo/Ca8Hwu22bu5VSeMsk86rOmTpUjymK4=
X-Gm-Gg: AYBFou3p+rmw2soba7eAbLbgdL06hpAUDk4uu45UXJlSbBqqRH+rtDPUvefQ/PO06nT
	ODz7mXjQ9JBFazHfl9HPs+ZlaASj+KUI3xo0g41yxBtiXt5CaD6laBHL/O2QFl/in7hgMNzrNSw
	Xc9hcWz1PryOquCoYIsxHzBATK0MqcGk7+X40hLDjqJiLYN2H4hVFCHNoFnuPWYtUF+6Pf4jwrm
	wZF7vEpfsa5BoeqN8noVcNh9cvWNknMFaaMSXMHobJgJZCFhn6H74v6E1VGwO9WtFEVBAVOrVVb
	0snMVUaJLZ13vw5LdfLMRKA6qV27D4Ego2IxoVBXVR7X1sEsK0u4cDazb/pltBRZsBKLQ8UaO7x
	b/E6Bzmwr4qyEAc+kTsQKTlK9zoJYlqjQmH9WsNigwr8DKgOP/JDu+frdOej3N7Ob+GEoQp5UiG
	YinVtdUh9xwOWE8dgS4iebeac2E6aiMVEg/aRFofI+EmjJSE5llkn0xAqpscRvBvNiU/zhC+kLG
	d+0zns0R+ECIJB3HP5L8IpPoawNPmWUk/6nQML/WDSq4EVGdsvTWZaNmde/ETcQqzfXok6PLcaO
	XM1eT2Gfv+TxJFDIJx5MRNesemaUF5qTsD85ZTdyDr1v7vjyaiJIhf0M9t+DIIBX7/xeCv1F3PH
	XdavBbN6fgw1PhSOCmAbKn3t6LljjvYMBq89klgdGEipB8fWMJyaOsuZjrS3rQmMSB4gcRM9hvq
	Q72Cjg84jPg2Gp+vagXo6EMGWA
X-Received: by 2002:a05:701b:465f:20b0:1b5:281e:1702 with SMTP id a92af1059eb24-1b5281e1b1cmr4309897c88.41.1794854601988;
        Mon, 16 Nov 2026 10:43:21 -0800 (PST)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.93])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b50309b27dsm33363040c88.2.2026.11.16.10.43.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 16 Nov 2026 10:43:21 -0800 (PST)
From: Brian Bunker <brian@purestorage.com>
To: Benjamin Marzinski <bmarzins@redhat.com>,
	Martin Wilck <mwilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH v4 1/1] multipathd: recheck WWIDs of re-added paths with the device
Date: Mon, 16 Nov 2026 10:43:08 -0800
Message-ID: <20261116184308.24727-1-brian@purestorage.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <9259d20188a042cb280bad95f8be9783d1b9c1fd.camel@suse.com>
References: <20261111181642.51912-1-brian@purestorage.com> <20261111181642.51912-2-brian@purestorage.com> <179452227264.147392.9708937185980533136.b4-review@b4> <avdQNjzddtu7o18n@redhat.com> <9259d20188a042cb280bad95f8be9783d1b9c1fd.camel@suse.com>
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

Martin, Ben,

Before I post a v5, here is where I stand on the open points, so we can
agree on a direction first.

On Fri, 2026-11-13, Martin Wilck wrote:
> We need to trust udev at some point, don't we?

Yes, and checking once is intentional: the check is meant to catch a
stale or wrong uevent, and the retriggered event carries fresh data.

In the code, uev_update_path() sets needs_reinit in two places: for
INIT_REQUESTED_UDEV, and for a changed udev WWID. I would pass
PATH_ADD_REINIT only from the changed-WWID branch. The retriggered event
then takes the normal path and trusts udev. No new init states or flags
are needed, and a persistently wrong ID_SERIAL can't cause repeated
checks.

> Yet another possibility is to introduce a new mode where we just never
> trust udev.

I would keep that out of this patch. It would add SG_IO calls to every
event, which is the stall risk you raised, and it deserves its own
discussion and data. It could become a value of recheck_wwid later.

> In my mind, a changed WWID followed by a failure to obtain the WWID
> from the device shows that something is really fishy about the path
> in question.

For this patch I side with Ben: if the check fails, trust what udev gave
us. A failed SG_IO on a path suggests the path is unhealthy, and
recheck_wwid will recheck it when it comes back up. Allowing a fallback
to SG_IO in get_uid() when udev fails seems reasonable to me as a
separate change.

> I suppose we could rescan asynchronously in this case.

I support that as a follow-up. On Purity, scan-scsi-target doesn't
refresh VPD for existing devices, so an explicit rescan is the only way
to correct stale sysfs data. I would rather not add it to this patch,
because it touches the regular changed-WWID path in uev_update_path().

So for v5 I plan to:

 - lower the log level of the new message to 2 or 3,
 - set pp->tick = conf->retrigger_delay, as pathinfo() does,
 - limit the check to paths that are up, as Ben suggested,
 - pass PATH_ADD_REINIT only from the changed-WWID branch.

Does that match what you have in mind?

Brian
