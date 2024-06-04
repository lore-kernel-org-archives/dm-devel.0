Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9998D13D27F
	for <dm-devel@lists.linux.dev>; Tue,  4 Jun 2024 15:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717515967; cv=none; b=SPYf5hzaKV5lvWsqXEpGuL9Oz9gxZ+E0l4pNCuhVwQxbJVZbsZKlLEgUViui21lY6F7M893PQbzziwIAhHs0/t0DBrQmzOQw3ci3LUX8V5GNeoixV/JN3AyWy6HEY6aVnTXv4hoRkHVw2HuxzsMi0cXLz4Zf0JdsMZltaMWsXh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717515967; c=relaxed/simple;
	bh=E1Wz7zgHTZrfhROy1/GiV+PiCCUY4QDCcYESGsp9o1A=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=n7zjeTYkkrb1dm9NXAn+2PtWLxzjhIhSKhr7ciXs4Fbz/wfCWMAgbsE5eJ9TDF40uXyhyqVItvynG1XYvK1fhgJZE2uGngwONYpUOeJNMAZR0cYXJIUsghiBb+vBXIwTLRhY97EE7Ap7AYpOE6MFxYEqdl5zBNbLWILTAsc0Xcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Vr0Tyn3q; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Vr0Tyn3q"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a68fc86acfaso398171866b.1
        for <dm-devel@lists.linux.dev>; Tue, 04 Jun 2024 08:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1717515964; x=1718120764; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=E1Wz7zgHTZrfhROy1/GiV+PiCCUY4QDCcYESGsp9o1A=;
        b=Vr0Tyn3qhOCgT/nhhzbwtycQg07Jk0CAdY3dCoYPjlXPrIJwxNrqJQ7TT69L8Dr1tG
         Ey5EqhoM0gnj8P6swKPnnpCYjYlJEPB0MFvzG8E+kP8CIR9bVS5G2DiUKRRE0cgOX/Rg
         Hd4ew6ICOc86AxPUQCoII9/6yxO1uF2i7us7WfBDk1bb+Q42VHnFOzZocVuAsaMXK0kZ
         QAnc4eUBUFI5ZKAa/s0Ge+Xiu0yRhrhlVOG36gNQJIXOJdKoSXbmT3ShzB7A7dCQAlaU
         AgKD0cDrlHYd0xSIDoiE+vSCs9hsxaYp/ckRH+ew1JCx34UeIwywK/WAtOohMAT4ADeA
         9vbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717515964; x=1718120764;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=E1Wz7zgHTZrfhROy1/GiV+PiCCUY4QDCcYESGsp9o1A=;
        b=mjyJmCq8ajEN7WcX+WyG0M8tq/8N7x9GUjYnEcHNwkN5QQGuPJCLANFCmkNE4ttd0Y
         XczRR2JsBElgc7zHx97Hm+guI5Mn8kx8yJAJevnpP+Eui3OTL8UGZa3fV8X3o7VtMRhj
         1XyZhMqlV5wBjp7Ss4+SZ50+yOSVfPMrNV5D5uAdUCpUsYKKKHBN8trkPQvCETjsTGPi
         4MaNT9mqRa0FLfmXOTdpgtZUINz9dw04MgExZMuqoTzs9EIoGuRmEXofaacHEsqbHiK7
         Bq4xdreBj7gPqpl/AxSONCCLnwSbzhv9cuCWV6MU0+AG5iTIZTG6zVR/twzWOu2C4bwr
         +NAQ==
X-Gm-Message-State: AOJu0YxhnoC70N6ERO6N9G+/4xMDC0Smgqob+D28WMDq1T7MlcKSLlNe
	9HVVbVh9rCTy5WXaRv2TERR2HViAU5C2nvAGZrJY28c9gQ3Fy0ce/RXYU92wzFjIc+rt4bjp9d8
	G
X-Google-Smtp-Source: AGHT+IH/zROZExH8Z5/XBeTzAgAkkEfrCf38gNK0KQy454qLCP94CjT+6z7IuBBq7I3jgj+2+wGdag==
X-Received: by 2002:a17:906:c24f:b0:a68:be46:742f with SMTP id a640c23a62f3a-a695414047emr237057166b.3.1717515963899;
        Tue, 04 Jun 2024 08:46:03 -0700 (PDT)
Received: from ?IPv6:2003:de:371a:a400:e6fd:936f:426b:4ff8? (p200300de371aa400e6fd936f426b4ff8.dip0.t-ipconnect.de. [2003:de:371a:a400:e6fd:936f:426b:4ff8])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a691bde21e2sm255794066b.104.2024.06.04.08.46.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jun 2024 08:46:03 -0700 (PDT)
Message-ID: <b68a41f94b532c356eba5928f224c6db2b8cdb09.camel@suse.com>
Subject: Re: [PATCH v2 3/7] libmultipath: print all values in
 snprint_failback
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>, Nitin Yewale
	 <nyewale@redhat.com>
Date: Tue, 04 Jun 2024 17:46:02 +0200
In-Reply-To: <20240530165500.397009-4-bmarzins@redhat.com>
References: <20240530165500.397009-1-bmarzins@redhat.com>
	 <20240530165500.397009-4-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Thu, 2024-05-30 at 12:54 -0400, Benjamin Marzinski wrote:
> Add the missing output for manual failback and print the defferral
> time
> for deferred failbacks, if one isn't currently in progress.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

