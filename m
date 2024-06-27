Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 909032E3F2
	for <dm-devel@lists.linux.dev>; Thu, 27 Jun 2024 09:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719480727; cv=none; b=oo0mzM3qHQKqlyOPiIIpFJZpjtICEbCHjg3VHzGNjqrcOc66edJnzDeLG8k2QYheKVr5W1EO0gTPY8FOcQcVzFPk/3WqT5jMuCCqgoFdScGdLILrBnfpdQYYnC/uumbZ/DI7rmzWMIzOzWYtayg7ve9QzkGZiI7IZJhly6b2ijM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719480727; c=relaxed/simple;
	bh=TwucnY/pDNlhn7W5cAt+1NQxpPxEkkdVw49onneSAXg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qXDndpZgQVFAWPO5N3u6pgMK6lYeGDJe0T4Z7KdFTbdIWppp/9nxcTwjqIdmAvDf524TYwlSaZWp6kusKz0m2jTNgNna1HR3Mj156nAYgOzA7SRH3MTiAUxu6utJwISmZHd2nWtK+sMJCyDQ6hxvf81iyVQnZIf+NwcGcRbDqh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QU6ViEZi; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QU6ViEZi"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-42564a0d3ceso3323455e9.0
        for <dm-devel@lists.linux.dev>; Thu, 27 Jun 2024 02:32:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1719480724; x=1720085524; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=TwucnY/pDNlhn7W5cAt+1NQxpPxEkkdVw49onneSAXg=;
        b=QU6ViEZiqupoFI7amXepLjbnOCv3UpbMveX3JZFCVsAksfrweO+Y0APOyZfsYmuBxQ
         caAINi4OOsyUV7HW26+fTyUD1t8lMkisc/0rx3tf0iyMezMEJ70Wq4tN5zMtqlX2D/3i
         Dzy0pm3yjLTuXGN8zTj1eCSnZfbxRWWH71VwPZPDV1jR6cgW50gDl/dOdn6L21cTLUal
         mQOmvSVZoidKW0WfXjz/iEQLkBzadSNgPtMnRvMQVKT+UQPOSkWkLMNQsvssWIqkPZNV
         i+F0+iwvOhCqzJKS+uk7OKNQywqKbVTm7XFZXWAaSU2dczKOhs1p96BHZOKkVaEWAZWM
         hwgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719480724; x=1720085524;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TwucnY/pDNlhn7W5cAt+1NQxpPxEkkdVw49onneSAXg=;
        b=pdF+RXVcbqwWz8Byu1d7qbpR3cNy7UCOPxG5lV7pv1CFFJvN0GMCh0L75wEwUliV3v
         JmjfO7fXMRErcnTYW49dW7xSNuy8tF35VvVRoRzyGS2yp5dcHugPobJdxMZ2xcB2BuvI
         /948zsNUT+skMUJZMep+F34Cab5ebFx+s0RYhq+Sa97uik0eKQdaVeXfJVLOhA+Vthop
         Cg/pQSmeSvxRFu87Wk44RyQsmiXPZamMOkKQJYGOhI1+eaUUHaF4cbuv1OniktnaZ8oj
         X1ZPoBtcQe67zDswEAMFR/pBPp2tQw2Pyk7Wz0F60wNqmfnJUlcbvTld9UW1tl9p35Gj
         +tDw==
X-Gm-Message-State: AOJu0YzYjbI9+kCEBrJ5gbqSWln5sHvCcSUaYhuU108MLUd+dvrWGekv
	koWgRa/k62dWCqtKTkfr1Lmpu8+WT1uptAI7blos75JeKolWnzcg33WMR0uXAIY=
X-Google-Smtp-Source: AGHT+IHTJ49PM8fHD/sF6cqK/CFHe4WXmc6Sw82KanRn2NhKDW1N/lxUu5yfrTkrfbIncQwwL35V5Q==
X-Received: by 2002:a5d:6812:0:b0:35f:48e:fe59 with SMTP id ffacd0b85a97d-366e96576a4mr7708955f8f.66.1719480723718;
        Thu, 27 Jun 2024 02:32:03 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:e6b3:18ff:fe37:a690? (p200300de37360a00e6b318fffe37a690.dip0.t-ipconnect.de. [2003:de:3736:a00:e6b3:18ff:fe37:a690])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3674357c025sm1243680f8f.22.2024.06.27.02.32.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jun 2024 02:32:03 -0700 (PDT)
Message-ID: <36b3dcc270b37bdc0fcd92a52696cd7a144cd7fb.camel@suse.com>
Subject: Re: [PATCH 5/7] multipath-tools: Makefile.inc: compile with
 -fexceptions
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Thu, 27 Jun 2024 11:32:02 +0200
In-Reply-To: <20240605232254.623290-6-bmarzins@redhat.com>
References: <20240605232254.623290-1-bmarzins@redhat.com>
	 <20240605232254.623290-6-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2024-06-05 at 19:22 -0400, Benjamin Marzinski wrote:
> multipath is not currently running the cleanup_functions from
> __attribute__((cleanup(cleanup_function))) when threads are
> cancelled.
> To do this, it needs to be compiled with -fexceptions
>=20
> https://gcc.gnu.org/onlinedocs/gcc-14.1.0/gcc/Common-Variable-Attributes.=
html#index-cleanup-variable-attribute
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

