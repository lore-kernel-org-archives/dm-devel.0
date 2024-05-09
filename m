Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D9314B95C
	for <dm-devel@lists.linux.dev>; Thu,  9 May 2024 14:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715264696; cv=none; b=ZPv5zFdYlsBszFTNh/wW9Y1wtQmPOl3zHwMuag5PZT0KYdwQgcYMdpaHQBZzq4V8Hvzq+gZtI7ZAK3Cka4wENqcac/HRUC4vbsvBNfgVLevJb9EIbZNa2t3lOMXi9m5sDNyrCLbB4Kd5zQLbR0lBc27HTN6FoA9mPX2Qrw+1XzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715264696; c=relaxed/simple;
	bh=Fh6Gp8KCO5posqyeaV7qi4GXAWQ5LfRgpWLUsR1gkxU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eToB+sRg2go+mzD6UqAKb7YYYsjYDZKx7Dh2s4v9p8PZ8UtUIBGnTDawEDN5GDBKCtH1ojMVemk5pEEA4LkpJlyoZz7uJWUCpp9+Ob4GIEZFX8HkvBlnrQPGuxfH38Zpy7x8+iArZ2dF6y/n/euGPqV/e1nLZ9U87JkO362h65E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=snitzer.net; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=snitzer.net
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-69b7d2de292so4309486d6.2
        for <dm-devel@lists.linux.dev>; Thu, 09 May 2024 07:24:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715264694; x=1715869494;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OYoYKkdbfRSKqt/bnbJ4410nX8EskydVEumvwaRPd1c=;
        b=GnbvgrRV2leIJLGqgpbuMEnNL2M3XHHnOg0H/cXEYr87DisqaID/VFjpgQsHm0Yj4N
         Uh1DMupnZeu51vGLIpDj0nEIDWQNjb6XqR16l6CGHWz8StGFFc4/ZYkWCwSYlZTC3ZNF
         qmrczdxHLHm4vKhpYvuZaP+WxoWKMeuJSUN4VUx3MmUPfYIVnf7iFX6ujsC1/FRQI1jx
         rbOM1gQ3mYVxLUMb1e6kA1PxG+eJPM+HGyX8NCNYPhP8rP4zviYFwOKZNV6m7+7uQpLg
         D53fXDqKxwxQb382wvlGXL88c9LHWWl5BkaE1+T3j4D708VAGc92TRmJs1VUOU2JjzkV
         T1dQ==
X-Forwarded-Encrypted: i=1; AJvYcCWzSqr4l5+tZI25DGg7zp9Yy+sYmrwHmy6Ru3UyFa37Pqb+i20KpInCFQzWNe1vnP7Tw2D1EVMdjfpFRTAY8VCsY87BJxP5j30=
X-Gm-Message-State: AOJu0YxF5VBo5kb+WQl5b/BxxRgAnF06QZ4nDIYfyXX40EF7K58I0pPl
	qfj5pODiaRu+HSBWnsQdAcjTXob/UIZgjnls40a7Utap5vT4b7LY6uH+11gxpt0=
X-Google-Smtp-Source: AGHT+IFWAlECgA5m9go9TiTlAjrA5s3PgnnUjbQHGKH4r8Y2O5p2sRo5EcePeMKkDU9SUvpkrI0XPA==
X-Received: by 2002:a05:6214:c47:b0:6a0:d312:2c75 with SMTP id 6a1803df08f44-6a15157df9amr51985726d6.64.1715264694122;
        Thu, 09 May 2024 07:24:54 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6a1624fb686sm5341936d6.124.2024.05.09.07.24.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 May 2024 07:24:53 -0700 (PDT)
Date: Thu, 9 May 2024 10:24:52 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Heinz Mauelshagen <mauelshagen@redhat.com>,
	dm-devel@lists.linux.dev, Joel Colledge <joel.colledge@linbit.com>
Subject: Re: [PATCH 0/3] dm-delay synchronization cleanup
Message-ID: <ZjzctGe27JkXsANR@redhat.com>
References: <20240507211626.26706-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240507211626.26706-1-bmarzins@redhat.com>

On Tue, May 07, 2024 at 05:16:22PM -0400, Benjamin Marzinski wrote:
> This patchset fixes a possible crash in delay_dtr() caused by the
> delay_timer queueing work on a destroyed workqueue. It also cuts down
> on the amount of locking and waiting the dm-delay does.
> 
> Benjamin Marzinski (3):
>   dm-delay: fix workqueue delay_timer race
>   dm-delay: change locking to avoid contention
>   dm-delay: remove timer_lock
> 
>  drivers/md/dm-delay.c | 52 +++++++++++++++++++++++--------------------
>  1 file changed, 28 insertions(+), 24 deletions(-)
> 
> -- 
> 2.45.0
> 
> 

Hey Ben,

I just staged 5 dm-delay patches in dm-6.10. 1 from Joel and 4 from
you.  Please confirm this is what you expected and looks good:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-6.10

Thanks,
Mike
