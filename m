Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AEB41D88CA
	for <dm-devel@lists.linux.dev>; Tue, 11 Feb 2025 20:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739306892; cv=none; b=QsCPXtPuV8DiN0Hk4Wcaj7s9gq5uJpCpHL367jjVfqDf6+3L2Yz8gSbFtLJZ0A7ayTi1yFjOG96QKQ94CMRfnot5oFFYCfub5lw4BjhKIM04kUrh6txTLHas88oUtKHHCKHIvgRhaWbYWzFlceyQ2fHcQ4yPyGwMh7aaJPPpFm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739306892; c=relaxed/simple;
	bh=yFXyFnIi+52VN+pYxbpLfYVx6cICjiaB+HsAULoXBaI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Wg1YdJPbYheS8fDJgylCbtRkW+dh83Ces9Q+RNU6bHX3JTP38Y6GC/v+/NxuenJZIo7sjQlZol07mJamKReClkD6PZWwtYHTczt9sYfiXBO5J/AXHzwdrmiSkMLuf8R6laWHSiZM/Qr7gLfkJajKe9bMu8dLA0Y948V+w1bIM80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EttDNwcc; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EttDNwcc"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-aaf900cc7fbso986429766b.3
        for <dm-devel@lists.linux.dev>; Tue, 11 Feb 2025 12:48:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1739306888; x=1739911688; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yFXyFnIi+52VN+pYxbpLfYVx6cICjiaB+HsAULoXBaI=;
        b=EttDNwcc8XDe6VlW+4h2S/V5nn4AD+F37+f51mDlgNiCMocmMJkVNMd3XK7mdsi7kn
         rBUoNjTqK79MmyTRddVwUJAprwcYsbE4seX985yuBSR9UfQaJrRv0VTYKN7rDWajgQJI
         ptElRb+COL0TX4FhrfpcncG+yAGuoLWpidQSsdjE0zYuFKD9FoJ40gs+U5Jm0hZhWQ51
         aqDJAXUziSju6gp+ExQAll76xIeiEC3MDMXDq7orBqg+4+fCO2RgL/S1rWX+pULVr3Ux
         oezlc1xic2o90qvzYG/YQNKZVnAaD0NncIq9HClvbILR1yrmZKjcaLg9rmS+kPs6rv/Y
         H1NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739306888; x=1739911688;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yFXyFnIi+52VN+pYxbpLfYVx6cICjiaB+HsAULoXBaI=;
        b=hiX6yUwkcWWFDK9ODpT8v4gCqZEeNyEFF60CtWCRHUnGLFXEy36cEV54IhL3bLfPR4
         +XCOKMD3irqST5Zojs5phYCda1d8cjx9jxzdC+Cn5IGWPYCB7vtGaXBSeEjJ0HYmgs7j
         NJ8VMqLgSc+1OSbkag1MlyHmwGqgyr71ODvtsfP8R7oYB+VHza1w6Tw5QwA3tVJNonzR
         t/4vU0sxHG9opyYcCYHeoGKBwvJlVIH+gsWUIwuY9oqVZ50P/b/2P5GeOXkfYXmmIklL
         FEo5BWt8b6PYVR7wqMjuZbqNaQQpEVjcEJ29gt1xcf5pETAkGCVlWPpJtbMCukd6c2f9
         sw3g==
X-Gm-Message-State: AOJu0YyQghmKtdEEhsFYeHwaiMUiOAaKPbgEo+H4+dUuMbZoVNnxXXi9
	AZ2KGymTyWl5ICe4GNJEsj3xopWPixrpkshF1sMDjylyUzRKfP/qpt2I5RnIZzWKFjj2/eBvpMW
	w
X-Gm-Gg: ASbGncveIVMuQowRiW1/J7LQLjKA5uFDS2LkPTUm0e6fLBCDBW0FDOxwDA1OUlMfL4J
	TTeY7j0Bcj3lMSd2G0Lqw4PJ1JXQ2EJeLPSRMqtSHAsJwPerrl/o6jKPNPD/TsryoJKvDVnvCSv
	W6+OMTBY03mLwXE7E6XMbaew9yVulo80hyHlcT1ekOStd6ZftzRfAwME9Zx/B/azWdPx9ITO8ew
	8LGEr/7Etd7r2SYZepq5T7w/6QQ1H+d5EPM28W0C2FMithQYArcSc0U9Nrfps1G60kvynoxtdBt
	fOY3/xh/xJK7o+nkqRbqeg6UoOlbfPF1dPk+oUXL5pH1cgT2bsxeFpE=
X-Google-Smtp-Source: AGHT+IE3hdKhpUI0Gnd7elIrykn6obGWnvBQGKfQklYmXWnON/yvrRK2IXuB7gQT5P7a7+D0QrIwig==
X-Received: by 2002:a17:907:6d11:b0:ab2:f8e9:5f57 with SMTP id a640c23a62f3a-ab7f33bb639mr31994866b.21.1739306887712;
        Tue, 11 Feb 2025 12:48:07 -0800 (PST)
Received: from apollon.wilcks.net (p5ddd307c.dip0.t-ipconnect.de. [93.221.48.124])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab79a07398esm822976766b.40.2025.02.11.12.48.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2025 12:48:07 -0800 (PST)
Message-ID: <a36ea8de4893538694df9b5bdefe23831ba3759e.camel@suse.com>
Subject: Re: [PATCH] libmultipath: include urcu.h before urcu/atomic.h
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Tue, 11 Feb 2025 21:48:06 +0100
In-Reply-To: <20250211181103.1506768-1-bmarzins@redhat.com>
References: <20250211181103.1506768-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Tue, 2025-02-11 at 13:11 -0500, Benjamin Marzinski wrote:
> urcu/atomic.h requires some header files included by urcu.h. Make
> sure
> to include it first.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>
