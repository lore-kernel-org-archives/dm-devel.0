Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D2C7868F
	for <dm-devel@lists.linux.dev>; Tue, 20 Feb 2024 18:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708453144; cv=none; b=RYt4VAl+LfdAdtusDlNzSuHgo5liRzOsBfiqa3oGTrwcTodlJ+hhDkGB9iFfYHx0MD6udnbOzbLcvgGSQ6D7+bshsFhoDf7BtKFvw+ft/gvakQZygItt9rQR6EebyHSqzEs21qCQudkOQdbCHUtE+y/gFLVy8Bs1LQ94jpiYjSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708453144; c=relaxed/simple;
	bh=PvYo74uoWhD41ohw8yNS2GUG6/U1gKH18FXvHsCmIKg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MDwwHqpY31H+L84jHn1xz9mp88oOiyDlgXI1IzCYYgFYe7aa6mEMANg+TS36rIZ8VVwfmW4njB3ukqudXY/7w8AC54UQQTGaLUXjCRgwhYBDnYuez5rRCsw9VyatyA90+qth2nMCcjnV3MW6tGZg3wg3PhPYA67PvvGCO4yehI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gtSfOvRw; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gtSfOvRw"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6e4841ce028so449435b3a.0
        for <dm-devel@lists.linux.dev>; Tue, 20 Feb 2024 10:19:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708453142; x=1709057942; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qFTpHAv0pmcOCj6fTcaqcOduTWlWxRQydUJGeHzrVhA=;
        b=gtSfOvRwob8sPf3DgBT53MEDtTQkrqF9mhL0g9QO0+ovFhrY1Kco9ikDt1FdUal2xE
         kR15o1PrBjvRnKBBeB1tGPFQ1/bs0cbVCT0+jLw/i4z0rbmWI5/nDNeNuMusYzQfcalg
         rnvcI0yS1dU85CHugRpBSKtfa9V8Oel7JpcrTO/MRlmYiNuFdbQmAx3QOCZzpGesFUc/
         hmkyEOhpDtgoXJoix74jZ2x7PbShib5yyBuxJLyn+BsSvtVyM61qVGPoc6L97W1OZ7EN
         Tl70Flxo4RDRI/41TBA5tPwP5o8R78bph9aKKuCU+k2WBZeVGj6y0qiOJEgv49kRzQkk
         7JaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708453142; x=1709057942;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qFTpHAv0pmcOCj6fTcaqcOduTWlWxRQydUJGeHzrVhA=;
        b=TGeOE/dEUgQkOLClgRJBobaPqr1BO5JTV1iphl5JNg8D3ZQs0FitqG6NfVkKfwBqZt
         rjWQ0Tx0+VxquzZLOFEhLWcgxyfCKchzFElFM/5bPigQyPhOeqJ/I4Q3sQrjJUG97A/9
         m8l5o1cxtDuq2or6V8rg1Vf6oeT3tmBdQlIRlx1QRZfhZwa91KIpL0fbv/azoTSfa0zI
         wdnrupw7WHB76a45yDRedPuqdZkTCjR8dk/fJWoU0TorwFemMcln/A6hKSh8exh/uq+o
         jRv7p+A9kvVTNCynCDdo6EnS/Qs4GAaIBvGQlkYLIRGTi8Z3fBdcXQtHABq/jGrOGXlZ
         Uh9A==
X-Forwarded-Encrypted: i=1; AJvYcCUvcQsxEMUsIz1dZPl3vyqIvwwM0R41ctXQ02VkQzOYNh64ABqOT0wYLolry7cswepF96s9fYreq4OaMhZw/uLnRqR5rH8p55Q=
X-Gm-Message-State: AOJu0YzGYuawDSPfr5OHcCDg7UJmMPP+x8m1a6OoSqo0p6PXEY9ViyFS
	rjNrkp4hrJB3Jagsa3lqn36l3mErQI0ahiauTt7koEPMQsJnGIL0
X-Google-Smtp-Source: AGHT+IHctzEbCJ0zIC/W29fqRusdFNSQJRt7P7ntp+/eb2LVdwQ/FleSZOrJXKKIk+UeThHSav1Bbg==
X-Received: by 2002:a05:6a20:c890:b0:19b:a07a:344d with SMTP id hb16-20020a056a20c89000b0019ba07a344dmr15658884pzb.7.1708453142076;
        Tue, 20 Feb 2024 10:19:02 -0800 (PST)
Received: from localhost (dhcp-141-239-158-86.hawaiiantel.net. [141.239.158.86])
        by smtp.gmail.com with ESMTPSA id r8-20020a62e408000000b006e3a4766c7esm5984542pfh.68.2024.02.20.10.19.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Feb 2024 10:19:01 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date: Tue, 20 Feb 2024 08:19:00 -1000
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mpatocka@redhat.com, linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev, msnitzer@redhat.com, ignat@cloudflare.com,
	damien.lemoal@wdc.com, bob.liu@oracle.com, houtao1@huawei.com,
	peterz@infradead.org, mingo@kernel.org, netdev@vger.kernel.org,
	allen.lkml@gmail.com, kernel-team@meta.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
	mchehab@kernel.org
Subject: Re: [PATCH 5/8] usb: core: hcd: Convert from tasklet to BH workqueue
Message-ID: <ZdTtFFRC7dmiS2wL@slm.duckdns.org>
References: <20240130091300.2968534-1-tj@kernel.org>
 <20240130091300.2968534-6-tj@kernel.org>
 <bckroyio6l2nt54refuord4pm6mqylt3adx6z2bg6iczxkbnyk@bb5447rqahj5>
 <CAHk-=whqae-+7Q7wbtnEj7YmR8vsx6skTj6j-srV2Fz7cBZ2ag@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whqae-+7Q7wbtnEj7YmR8vsx6skTj6j-srV2Fz7cBZ2ag@mail.gmail.com>

Hello,

On Tue, Feb 20, 2024 at 09:55:30AM -0800, Linus Torvalds wrote:
>    git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git
> refs/heads/for-6.9-bh-conversions
> 
> although it's possible that Tejun has a newer version in some other
> branch. Tejun - maybe point Mauro at something he can try out if you
> have updated the conversion since?

Just pushed out the following branch for testing.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-6.9-bh-conversions-test

It's the same branch but combined with the current linus#master to avoid the
rc1 wonkiness.

Thanks.

-- 
tejun
