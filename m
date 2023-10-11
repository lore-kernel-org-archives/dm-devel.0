Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C82212E5B
	for <dm-devel@lists.linux.dev>; Wed, 11 Oct 2023 20:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4195fddd6d7so1641681cf.0
        for <dm-devel@lists.linux.dev>; Wed, 11 Oct 2023 13:08:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697054926; x=1697659726;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qr5cbNwBGUq44Qqcf2T1WRmi92vamYaT6CHTdHN7dtY=;
        b=uRLx2OjecQJyxqcqGwk4/Qm0qd1VZOCqtzaNBaPQNWq+DDRuvT89C1kE8PD6vBPEvn
         MLgV401dxNiBSMrcI840mydpGeveR3pw9DMFZBQAgjWHwC+G/54QZ3MYcaUuqXVbT/89
         MThAig0fbp/0ND3lXVLuGVeYvLxb3HV+NSf4ryUGnvGh8xCmV84Hup/MdHhtoUdvIXCx
         M3xnUEmAd/a46mJOtBrOVF4utxVZ38TvE2nzgA6Q6r8RnFknOsE3eiIq36zoToG807pb
         VXW9V+h64aghmjV89d22d5dWNI7KcV5e2c6FpiJ/Ui20Q+ha/HN8YLsnKXNrq/sqqabY
         a8MA==
X-Gm-Message-State: AOJu0Yz8Fu8nAK5lqxHMedfnVWyKCRBgfNFQDIt/AdtF27HtUhhorUuj
	fRd8gjs3gJ11zU50cWSVM1Dv
X-Google-Smtp-Source: AGHT+IHdmgsMz/kSaGYQ3enaEG0UlUB1TMJ4kWFbdXvuCf8XNYV7sXBzYCp2H1qgLa0frrw4YuNuoA==
X-Received: by 2002:ac8:7f44:0:b0:407:b2db:135f with SMTP id g4-20020ac87f44000000b00407b2db135fmr29793847qtk.17.1697054926249;
        Wed, 11 Oct 2023 13:08:46 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id z3-20020ac87ca3000000b004181b41e793sm5632459qtv.50.2023.10.11.13.08.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Oct 2023 13:08:45 -0700 (PDT)
Date: Wed, 11 Oct 2023 16:08:44 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc: dm-devel@lists.linux.dev
Subject: Re: dm-devel has migrated to lists.linux.dev
Message-ID: <ZScAzBNqchk6MUKo@redhat.com>
References: <ZSCYSO8wlg4keAmY@redhat.com>
 <ZSCbqvX0f9LOXByf@redhat.com>
 <ZSbsdlfRAoUj8Jzb@redhat.com>
 <20231011-undoing-revision-89cb41@meerkat>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231011-undoing-revision-89cb41@meerkat>

On Wed, Oct 11 2023 at  2:52P -0400,
Konstantin Ryabitsev <konstantin@linuxfoundation.org> wrote:

> On Wed, Oct 11, 2023 at 02:41:58PM -0400, Mike Snitzer wrote:
> > [this is also test, to see if new list allows old list to email it]
> 
> It does, but I don't recommend doing this, because the messages forwarded this
> way will arrive with broken DKIM signatures (redhat.com signs the List-ID
> header, which we must modify).
> 
> So, even though the message sent to the old address will make it to the new
> list and to the archive, it will likely be rejected by many subscribers.
> 
> I recommend doing this just for a week or two and then just doing a hard
> bounce without a forward.

Agreed, this is purely to ease subscribers into the new list. Hard
bounce without forward in ~2 weeks is the plan.

Thanks,
Mike
