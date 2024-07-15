Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12607D53C
	for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 15:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721058681; cv=none; b=c+UvwAtifWb0/miuE6USKdCAHX4dZYtfy0+//iL9MvqtmiorU+/sWJHo/lwONMBDmLTVklnQgllCfCKsCatTQK3pdlePEPSh+17u2shX4RIWOO0YiipCF1pcB8T/xBPto/5Ns1OKVsnlSXJEIgVS8sJzBBB5OrTCmpY6+tuJkRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721058681; c=relaxed/simple;
	bh=Ew+HxX6EbeNPlx2huNsGvvtu0QPYLy7n5AvxQnuKfas=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rvbuNHRBEEzbMD0o77aJwDN1d1GapIeCxO2xb1tcXFGwDY2iUEEwmqWV4DTQIHTRjDFSXKKc8VEBMRz/jZhU8ikF6w2rVoSw7iNC3pO5gp1wexuWPkCDwjdAjFydugfLB2vnU/KI76pDGwxh0SWMiI/dwYIIvlutGhpjbF2Rk14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=A5AzZupl; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="A5AzZupl"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-58b447c513aso4936129a12.2
        for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 08:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1721058677; x=1721663477; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Ew+HxX6EbeNPlx2huNsGvvtu0QPYLy7n5AvxQnuKfas=;
        b=A5AzZuplRH7ivGZW+POsixPjwKnhHtr/XrEpZbH+XImj4RF7byasW+MnyWFRtHQktx
         n4qYj8h6JcQsXgwU0XZtYl52czLnXGjn6/x7Fsjphb+t0GFHu1miEJcdd5V0QKStEwLB
         g+ZxvWm+rNhlXRVQM6tJpzJcQ3yITbpefDTDTD4K/SyNlGIO6dSfD+nb3KqR6TmvaYnA
         SzqmX67pctdhbWLCimMkr9mKO1Q5XKj/2vK3a3iO3tbfaT05gv5EIiMSAWKti/04qB5o
         fdNvzETJlQmcLQrgfs3erS5bz4z+EEoJPompVwnhmQDuFQ+6DN6tnGO5u/r+ri5C4xHV
         eaOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721058677; x=1721663477;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ew+HxX6EbeNPlx2huNsGvvtu0QPYLy7n5AvxQnuKfas=;
        b=t9eghTCsbCPq73E6pSBwpSzI2zVl7Toi3W6poi96FJcljvJrIq6V9c1xik5qkawTqY
         03gIIQYXY12DFTdj8rMlb7Gv1TLaWB+y8QAeufsoMZKTeWha4DCvsqpTuR/jtfSFMmKp
         sMu7myCSoGybCQYmMff7YaApJBuPIX03VZFzTkHH/DtydmrhfIOD3b3tMy9V/xEr/OMO
         BDG+jKtERs/SYoh/wJu53Y9J5We5Mw82LJ2GYy0YstowTlv6xRNaQz1aFRKld6g1jjKM
         Q6X0UWL/891c8bFh5mv+X+1zj8n8mQctssMzbL2lagGo21WCMmuLfv3vnyCnvJ0VAD0c
         Jv9w==
X-Gm-Message-State: AOJu0YwuP810kF2A+yRVOG1OJgVpErRFSPMEzvClN2kwRQwlbdpZSf3w
	KHklfWWB/0ebgd3wA8zOXmYKBUWmThE8UEOiFFBv2xzSMM8Ds6xaMsc/cFvZMTAe2DV6262nvTh
	4
X-Google-Smtp-Source: AGHT+IF5Z2Slz4BomBPhm1VkVV5GG/itTieRnUZNOxY/mu97yBTw11mI3VkW3x1+yZa8aKnDsRd38A==
X-Received: by 2002:a50:8d18:0:b0:59c:50c3:b061 with SMTP id 4fb4d7f45d1cf-59e9d085508mr160750a12.11.1721058676040;
        Mon, 15 Jul 2024 08:51:16 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-59b26f61fcasm3522433a12.86.2024.07.15.08.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jul 2024 08:51:15 -0700 (PDT)
Message-ID: <90514c6a67d1d6459e7a46d4f383983e822b7644.camel@suse.com>
Subject: Re: [PATCH 01/22] libmultipath: rename dm_map_present_by_wwid() and
 add outputs
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Mon, 15 Jul 2024 17:51:14 +0200
In-Reply-To: <f615dfb9053183adfe81279a77283203ca2663e9.camel@suse.com>
References: <20240713060506.2015463-1-bmarzins@redhat.com>
	 <20240713060506.2015463-2-bmarzins@redhat.com>
	 <f615dfb9053183adfe81279a77283203ca2663e9.camel@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2024-07-15 at 12:53 +0200, Martin Wilck wrote:
> Hi Ben,
>=20
> On Sat, 2024-07-13 at 02:04 -0400, Benjamin Marzinski wrote:
> > add arguments to dm_map_present_by_wwid() to allow optionally
> > fetching
> > the device name and minor number for the devices found by WWID.=C2=A0
> > These
> > will be used by a later patch. Since it can now also be used to get
> > the
> > name and minor number of a device from its WWID, rename it to
> > dm_find_map_by_wwid()
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
>=20
> Is this supposed to apply over my v1 patchseries? That patch series
> needed major amends, and I'm getting merge conflicts trying to apply
> it
> on v2. I can untangle that, but it'd be easier to figure out if we'd
> setted on a final reviewed version of my patch set.

Never mind, my email filter seems to have swallowed part of the series.
The full series applies cleanly to my v2 tree.

Martin


