Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073F918C33B
	for <dm-devel@lists.linux.dev>; Thu,  7 Nov 2024 18:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731002538; cv=none; b=BrC+/x7XsAUqgtTgTARGKf1Y8egYq93IMNAiaZmkGNA3IrIpUbeLsJgMgLIWewhnR76/0bDRjzil+hm+IgN6vjcUD7t92LHHIeEoW6TkMFv5Ih7EniZTyfyz2uMXZPhCAmyDMo7T5NemeX93QGvCvMl+OTBV3Y6GxUZsgARImYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731002538; c=relaxed/simple;
	bh=ZUpk0sbstx5wVrcDvquVoZlsweFTBk1kZWVgQ4NImWw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KoRNfpMF+Lx9XoEn/aJaZNhcD4+4QnMbqU4XnaWEE0anQZ+yrYeaiB/eer0acZTSftM29wGXFTh56a4x7MqCpHPNWIRclyNJjeLlsMuFyZQERYqidJQX3LeQfqJGYkE3aMvQT9naRIr/VLr0aLqHJhcRzM4NOTlyI85tActU39o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DgyEhOMv; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DgyEhOMv"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a9eb68e0bd1so172748766b.3
        for <dm-devel@lists.linux.dev>; Thu, 07 Nov 2024 10:02:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1731002534; x=1731607334; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6D9PAG//3b6wkF8EQS12BM5O+W8k41tgPmKvbRdF3Dc=;
        b=DgyEhOMvhhG4h+w6DiafQPzsdD4quxRN3viZZq11CLkehZ20qK2358USEppMn7fa+e
         DKmCO9vsuVRxzINwjSajM31vhOQVaR9waPfuXugtb34aiZ0kqwQ+jnDDi483YcDXJvmU
         mgKx7AzIsS/Q6NzY8g8G2d4vndRlQxtt5AfKI0vw0GvLGt79ZdRQths4Rf4XHGC1BUGX
         KI4QLy0P03dDMZ/WtXrfZzsTtYweHiHl73AzZlktBIxwN2+B6jL3blBXJdObWmcX+ata
         IWv88f4fa2ffpXcrmWLU+a7aODm/hhaCN+X2dTghlaRU6hB4fGXmg94gQDMwAWbz6kMy
         Ocog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731002534; x=1731607334;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6D9PAG//3b6wkF8EQS12BM5O+W8k41tgPmKvbRdF3Dc=;
        b=CmIQw8ANRgws756ZjGJ8UVZQSPtUsv2A8MtIU1ZNWtRFVEAyf3ajey4e9o1hSZbLCF
         Lz0ZaqTf82XSH43zdS7WwkEnO+32H9J+UybolCvRL5umkOzx5lnwCipv/l7iapkS9QBy
         czu3SsI4cmDTvKJ91vrUC1oBpzFTSxxSx2EtNfBEzIxMajErNMsIR+RNH/T8PN2p64HG
         B3yWeZdI0MlwuKFW6+E6F64PlxsSQO2BvCK5sSzUagXvkjEpj2zZ7pTRxDKKVgxifLU/
         1BhoiM+3rmJaV0mgxL7L0X7pyBdUqeSknljNs75p3W+EsxPPVhR9Bodah6Kg1N9gBp51
         x97A==
X-Forwarded-Encrypted: i=1; AJvYcCUapI+oVEcOk6ImSdqnpBxUtwksbvfrzaEbZ3uZBDpqO6WcsnNbGImcwqM8H8PHvYqWIPu9qk7xKw==@lists.linux.dev
X-Gm-Message-State: AOJu0YyJ6KgbdmzeIjcGF3YCHftlSsUx64kKOHnDpHV1BKpRmexEgOga
	K9PgUdUkuJnV7RfJPHaPoEPvvbZ+DlsyqaDHaj5GpX6qAeUR72tZG1aoONd2sCx2BHQV+hwJt5Q
	U
X-Google-Smtp-Source: AGHT+IH0qn8lAAKYKOH82WCmJzMNYiDHVL88gO7/9PP2THCSRtto2OIFDHimql43lyKUzgsmn+bCvw==
X-Received: by 2002:a17:907:7292:b0:a7a:9144:e23a with SMTP id a640c23a62f3a-a9e655b9304mr2336272366b.43.1731002533712;
        Thu, 07 Nov 2024 10:02:13 -0800 (PST)
Received: from ?IPv6:2003:de:3746:4600:ac00:378:25cc:9f2c? (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9ee0ad2dddsm126748466b.90.2024.11.07.10.02.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2024 10:02:13 -0800 (PST)
Message-ID: <692cb30cad72ed8165b8efd0751c8c5cb1f03993.camel@suse.com>
Subject: Re: [PATCH 0/8] multipath fixes to tableless device handling
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper
 development <dm-devel@lists.linux.dev>
Date: Thu, 07 Nov 2024 19:02:11 +0100
In-Reply-To: <Zyz8SFDAkIggpuND@redhat.com>
References: <20241031183301.391416-1-bmarzins@redhat.com>
	 <268bc68ab339ff6d6546f836329ee673fe734458.camel@suse.com>
	 <bc44c44523af9f1014c6e96842371bce422f18a7.camel@suse.com>
	 <Zyz8SFDAkIggpuND@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Thu, 2024-11-07 at 12:43 -0500, Benjamin Marzinski wrote:
> On Thu, Nov 07, 2024 at 01:20:09PM +0100, Martin Wilck wrote:
> >=20
> > Thinking about it, I believe we should actually accept devices that
> > have an mpath UUID and an empty table, and add them to our mpvec.
> > We
> > should treat them like devices that have a multipath target but no
> > path
> > devices. If any matching paths become available, the map will be
> > reloaded and the issue will be fixed. IMO, this is less prone to
> > race
> > conditions than trying to delete and re-add the devices.
>=20
> I'm not sure off the top of my head how easy it will be to handle
> devices with no dm table at all, but I'll take a look into this.

I tried this on a system with 0.9.9 yesterday. 0.9.9 will not add the
map into the mpvec. But in coalesce_paths(), it will just reload the
map:

multipathd[3198]: 360014053cdf4a9b80de42ab96c74f4ef: set ACT_CREATE (map do=
es not exist)
multipathd[3198]: 360014053cdf4a9b80de42ab96c74f4ef: map already present
multipathd[3198]: 360014053cdf4a9b80de42ab96c74f4ef: reload [0 41943040 mul=
tipath 1 queue_if_no_path 1 alua 2 1 service-time 0 1 1 8:16 1 serv>

Note that it first says "map does not exist", and then sees it present (wit=
h no table).
The reload works without issues though, if the map is empty.

If, on the contrary, the map is not empty but contains another incompatible=
 target
(I tried this with a trivial linear mapping), the reload operation will fai=
l:

multipathd[1347]: 360014053cdf4a9b80de42ab96c74f4ef: set ACT_CREATE (map do=
es not exist)
multipathd[1347]: 360014053cdf4a9b80de42ab96c74f4ef: map already present
multipathd[1347]: 360014053cdf4a9b80de42ab96c74f4ef: reload [0 41943040 mul=
tipath 1 queue_if_no_path 1 alua 2 1 service-time 0 1 1 8:16 1 serv>
kernel: device-mapper: ioctl: can't change device type (old=3D1 vs new=3D2)=
 after initial table load.
multipathd[1347]: libdevmapper: ioctl/libdm-iface.c(1998): device-mapper: r=
eload ioctl on 360014053cdf4a9b80de42ab96c74f4ef  failed: Invalid argument
multipathd[1347]: dm_addmap: libdm task=3D1 error: Invalid argument
multipathd[1347]: 360014053cdf4a9b80de42ab96c74f4ef: domap (0) failure for =
create/reload map
multipathd[1347]: 360014053cdf4a9b80de42ab96c74f4ef: removing map

Regards
Martin

