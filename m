Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F311DEFEA
	for <dm-devel@lists.linux.dev>; Wed,  4 Sep 2024 16:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725466042; cv=none; b=I2d8UicOqL+kpNoCeqb+xMRtEvVBw1oSUcNWVuz8PMs65w7RiqbCjiDKVxYs9s73gTmjDlcTL7vhKP+7JfQwWu0cm+tKkL0Ph1M4tA2BDHZgWP6iEPKMNdskjOIiyde3Ng/ugQdfpNU6zkenhJYNTv1o+ERQHLXL0k+6g167KjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725466042; c=relaxed/simple;
	bh=dtrRJHYZLwMqsRTa6mZGzaFHmKAHcLR9QImp5TmrJQU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=d3MEMXa99IG1m/geW3Tb/QriganBpbkXTGWMjTGZKGc0hM39h1CBvDxhTx6YAP4bf04/x3cQtyAN9gkcjL3GGlCjVyVWQ/OniE+yLBUq+k/dUKQcM/K/7Hiq8s+kpHIEdDNBvQSU625ynr/WKSLuTE2sIf8dUVsraisZTECaxuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=db6HVPK/; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="db6HVPK/"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5c26b5f1ea6so1165531a12.0
        for <dm-devel@lists.linux.dev>; Wed, 04 Sep 2024 09:07:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1725466038; x=1726070838; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dtrRJHYZLwMqsRTa6mZGzaFHmKAHcLR9QImp5TmrJQU=;
        b=db6HVPK/Qp7K7OEwHiaacydZZ3z48j3bSsakf4btONHSPdNKvJnnZCos2xLEsl/KD2
         KqXb8wvqtDUOEdqVj50rmIdJpH/U44cPmfiWczjGIChe3ahhr3nDpuW9g2Q3dyCvezg7
         kzGWjAWA1+n9YpEcql+iqbFBzcBmfGsh6mf+gYYnGXzB5rqYZ6bBpVUQ8osGNSH4VMnr
         GxUiA8lHjkQKB1rvfAh/bQ2fMN4aEIZ5X+f6C0SYLyAkYVVcZ/vvMs7c2YA4OwOfSOgO
         CshA7zMPCX4kUw8lyJCE9Ryfxb74ZFb23BF0T3bcbFjdMqfQhuOu93Q+B67wGeSgSFUw
         9O0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725466038; x=1726070838;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dtrRJHYZLwMqsRTa6mZGzaFHmKAHcLR9QImp5TmrJQU=;
        b=Ti6bLa6srhGSatfOC+/DIj2ONNar4Gc6ZD/kbMbw2yANiDSg5j3YpelRmDPyvH0Ztq
         XCJBwUenWX2l3HBfs6S0wD9VIxmfEiRHK4dpze34J6b00r4CGguolCtHLq0Ds7mp7Vqa
         1BEHkYA4dq6ZEfqOIRuE7N9AI/Wo/Pm12babxKo88cjf3gkT3wUEgfYo5Sj5tM5gb9CX
         89SpMp2/LMAiZ4FyIp6V3YKvbbWHHycCqRnKmZd+Di4ESdiO/0MpwcEmlvC/wuT22UKD
         yqbFlydjU3QeSiTRYk9rAKpmvXoJ+CoU6ZlPGZdR4GmL1QR5cCPXA9pUme71VZTPt22J
         GPAQ==
X-Gm-Message-State: AOJu0Yyx9j/VJf0oavrZJ75u23pWyEY7iNSwGUSiFS/h6WFeeyyNiFY0
	i6/TnMTw68AHhEdaly533hcaUxgjfgriaq7hRUwvBZkQb/jzihZwrIt18PKCD4mZJO9yh7Wl/m7
	Z
X-Google-Smtp-Source: AGHT+IFglS0/rnm6DUYrFMWZmXLxMEbQ7Abr4VrK3MQzle+FHggfmRCqxO28NcGyYFK/MGELH4xB5g==
X-Received: by 2002:a17:906:f590:b0:a86:8ff6:6d2d with SMTP id a640c23a62f3a-a8a3f246b6cmr231380966b.37.1725466037873;
        Wed, 04 Sep 2024 09:07:17 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8a62036f7esm9411566b.46.2024.09.04.09.07.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2024 09:07:17 -0700 (PDT)
Message-ID: <77cd157ded89092423cca7b9d77e6a058b2389c4.camel@suse.com>
Subject: Re: [PATCH 14/15] multipathd: remove pointless check
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Wed, 04 Sep 2024 18:07:16 +0200
In-Reply-To: <20240828221757.4060548-15-bmarzins@redhat.com>
References: <20240828221757.4060548-1-bmarzins@redhat.com>
	 <20240828221757.4060548-15-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2024-08-28 at 18:17 -0400, Benjamin Marzinski wrote:
> Since we just returned if newstate wasn't PATH_UP or PATH_GHOST, it
> must obviously be PATH_UP or PATH_GHOST at this point in the code. We
> don't even wrap all the code for dealing with a path that just came
> up
> in this if-block, It's only the persistent resrvation code.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

