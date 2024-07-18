Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7879169D31
	for <dm-devel@lists.linux.dev>; Thu, 18 Jul 2024 20:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721333221; cv=none; b=pP1r+LCam+oUUfFHMCT98cWHuL+hlYOAIrR0mXjm17q0NimYSpHzASLW1DNH6XUM+SImq6pl02YTSnanjjuZVH4RbyAEY/cR4Wv6btM5E4hqMN/orLUbZlUJ3x4m7fd+aDFCHqbyFJtBpTkLqge+AuWti04T8k66sQHqrCSQid4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721333221; c=relaxed/simple;
	bh=EEXMfa3XhpuHZMmzjWfK/9O2TCzd+awk90Ad49ONCfc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=E2tXTh6qHCkdKZACX51E2nnE7Jd5l0kMLQmIt9f98/v7dok+p61BN8hKgMVhhWBWtqaAojrXbsQ1BHd9MslukWFWqLJr+wn1RusMOmr8BA+gHEcv6w3do7m8A3B1MlAm4wvOP9cqzl91uLT0inOJvBIPCeFWnVsoqC6Rl5ZuxcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QcZnx91q; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QcZnx91q"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a79f9a72a99so425967266b.0
        for <dm-devel@lists.linux.dev>; Thu, 18 Jul 2024 13:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1721333218; x=1721938018; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=EEXMfa3XhpuHZMmzjWfK/9O2TCzd+awk90Ad49ONCfc=;
        b=QcZnx91qtp4asxH8RVb61FQ+Jm3o9+vyB6yYd/FKD7l4AXZzOo2KCgJCLFeA18K8i/
         z3vWj/ctKmzFf+pLk6pct35EMLUWzs2KOl2pJziheY2SKWhb6512ynyucLSvvJzoOZz6
         MawcWRjnDa3IXXuBe/znZLDM8besK7dOag07KFjER41V4Q9mXGRpainTH3eOOb8Bj+K9
         pwFlsPAs8T48jGBFB0UaEHdene8a2+6p0jT1AqFvxg4/zqT5E408gi5FMaT8ZPqlzjFw
         Xy0kdWj/FrcUicC+9mZdzdQ1Z21FUDOQUIyV3u1Mh5gKqLodg4AZfGb0OZv8qZ5XTPxp
         KYUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721333218; x=1721938018;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EEXMfa3XhpuHZMmzjWfK/9O2TCzd+awk90Ad49ONCfc=;
        b=qmVXK4JBQ8/fibhjcWDrewgs38BKNfTX6e+f3Znb9mU5Gskaj7q4MdgKVhTTY1UgP4
         UNw3f4zApxg9rr+kpSkama7xSS5cw4Ca+vOzgdja29kNbld23GjX5ffj7UhzvIGPqNN2
         f3nQrrp+f2ENZaegVvA2uvLUdh6YU0Zgh7prVsSQqKKI8W4EtT31yMqzXwVTZBg3FsiI
         3BxZLvMw4iVDZul/s+e5PTjEpt4kNrDP0SvhOyNth1SVTlhPvxfOuRtoA5kCKW5NyuoE
         PtWDIaTW54kIQuNlsdUYzf+/HAUNT6og9BrlKA+KAPs9aB2cxHg9jEOCwNT93YGd2UXz
         zNGQ==
X-Gm-Message-State: AOJu0YwtUE1Kq1inTH8v+vfwbCgPc5pzqWLLUe8gq9R+m2FCVd8hxERx
	CaH1UTu2mq2+BBPj9OMAReWhtvQ1/l9Qc9RLqnwvRdnPXAC3gJN0EVA2BMZ8j5g=
X-Google-Smtp-Source: AGHT+IH77IKqtLCdyhokHXGRgSeGaqflYW5xSi/pgjocHLoCwi7FBXVUyI9KIziyTI+9fCaE4zwoCA==
X-Received: by 2002:a17:906:684d:b0:a77:c051:36a9 with SMTP id a640c23a62f3a-a7a0f137975mr406423866b.9.1721333217561;
        Thu, 18 Jul 2024 13:06:57 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a79bc7f21a4sm599087166b.113.2024.07.18.13.06.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jul 2024 13:06:57 -0700 (PDT)
Message-ID: <443d6a0ad7ac4b895f6e4b0405672029cea03c51.camel@suse.com>
Subject: Re: [PATCH v2 11/20] multipathd: resync map after setup_map in
 ev_remove_path
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Thu, 18 Jul 2024 22:06:56 +0200
In-Reply-To: <20240717181106.2173527-12-bmarzins@redhat.com>
References: <20240717181106.2173527-1-bmarzins@redhat.com>
	 <20240717181106.2173527-12-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2024-07-17 at 14:10 -0400, Benjamin Marzinski wrote:
> In ev_remove_path() it was possible to exit after calling setup_map()
> without resyncing the mpp state with the kernel. This meant that the
> mpp state in multipathd might not match with the kernel state at all.
>=20
> It's safe to exit before calling setup_map() if either wait_for_udev
> or need_do_map is set.=C2=A0

Nit: I think you mean "need_do_map is not set" here. At least that's
what you've coded.

Just for clarification.

Martin

