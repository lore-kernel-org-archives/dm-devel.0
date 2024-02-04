Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9EDEA92E
	for <dm-devel@lists.linux.dev>; Sun,  4 Feb 2024 02:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707013218; cv=none; b=U1k2zQFrT9MIwdQALSZauiUIqXCzeRcqzpgNNyaGTt0gsOjN9ZcYdVwRQ8FIuOvJE2PT5mc8gReNROn3JuYYMOq5Cuk14t7cYJBBm1dZjNt7PdgojzkPzvKetx0PnKe5A42qgrULMlQlZsSh2UK+4kHA6Pxc67uhaR9Ahjhy5Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707013218; c=relaxed/simple;
	bh=RNZszhUT+/uT5RZG8XHRUQyhEcAG02BRiswwS8Rwglg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aIvFjrAzFLjOauLWRcCeCbt7w+itngStma4iYvP8iVXp1+YdutyWA4q6edTwmPRwlkfJnqeJZrGSMQFnsHVA5zQ+mRjFGi0K3aTuJBhSa8rnRvcx9kG0ziGiezybzdofrRw6J4LaHQ0bUa+cK87mDtDwsEvhlP0gtpvImrQCdn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lcMPC9NU; arc=none smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lcMPC9NU"
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-59a802ab9fdso1359004eaf.1
        for <dm-devel@lists.linux.dev>; Sat, 03 Feb 2024 18:20:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707013216; x=1707618016; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RNZszhUT+/uT5RZG8XHRUQyhEcAG02BRiswwS8Rwglg=;
        b=lcMPC9NURZzKF/D0Nj9O+TGcMC2DeXPAZJ2S8EVbccbXoko+i0gH/zLxBdqosWcVfA
         C43kvJHch0g8tMs54uOLn9o2TYoaBwzILmCShxCesRj0FDVpq+y1PdyxjOybNEAqcvFl
         1EbFwX910W3jL6T2CevzNfrwJ695FwkwdftH3yKCGpyf5j2cQ3jSV781n7rgt6M7PX1B
         A9NW+vH0S8pyh29PnH/w91Lpv3bnehWCWrmdR+h28lW/MrYRW+nZjww8RvG7TdWmYLxC
         z/jMlle+t67AAh5ujUGhHSc+lkSnyv3z7gLfioaPYOQxW7RtSFAigcZUZq1V7lTNOoC/
         fsEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707013216; x=1707618016;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RNZszhUT+/uT5RZG8XHRUQyhEcAG02BRiswwS8Rwglg=;
        b=O+OoZcMPujo7o4J5ssqm3azVqwFrrnOYfPuMYY4ut+9uQUVlCMGcEeCpk82ymXXj0J
         9KqIELdovout33NIh/E8H8jtKYoEjBpSs1qpm/hwOg/ngVJ0PAnPU+925tzPR7GE6OQx
         1TUkFDpNmxui0dkWu2Lfm/rMukjNyOSslp5YEq3tToVQ3sTPpnZsw5ptzPVMEpVrGLnN
         fTbH1dq5z9nJP2rTlrPWIsxA/aJ3Y83fIuL7kSrXJIIDCQOp46H99NOyHYly+1SIFmqC
         3PuYm6bPlxQk4eCj00X2+OOsGhO4q6s0DGlbW8Pu0XXS4JDs1JIcAiMm6uW857vCcWLw
         +SQg==
X-Gm-Message-State: AOJu0YzuBvZ3wAvVkY5E0n5aXKTd6bJM+j/QSIl67wRsg3uC+wio2w6M
	DGKvyN7+2ZfLxMTNcCWp+gvSlOr1TAjDzrrst8XbzrFIhGvotaOnPUIeMnVRCMeSWwTpD6CT8Kp
	GBDRrnw7o14T55R/2tb1RMKlptEc=
X-Google-Smtp-Source: AGHT+IE6uaJ4j4gXd0PdBc9PG5H9mjDej9XZyb/pAfNrHduzabrLT5oY7pCGhTfjHAPn8Fph8jQ1h05Sj4tEV2i8Lr8=
X-Received: by 2002:a05:6358:71d:b0:178:a197:15e with SMTP id
 e29-20020a056358071d00b00178a197015emr6990879rwj.32.1707013215695; Sat, 03
 Feb 2024 18:20:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240130091300.2968534-1-tj@kernel.org> <20240130091300.2968534-4-tj@kernel.org>
 <ZbxCHZzA6Uiw2Eq_@slm.duckdns.org>
In-Reply-To: <ZbxCHZzA6Uiw2Eq_@slm.duckdns.org>
From: Lai Jiangshan <jiangshanlai@gmail.com>
Date: Sun, 4 Feb 2024 10:20:04 +0800
Message-ID: <CAJhGHyBUGmarSSuGpiBOWvVZ4RW5f7_rb2uJZ7_gZCGBp+rpDg@mail.gmail.com>
Subject: Re: [PATCH v2 3/8] workqueue: Implement BH workqueues to eventually
 replace tasklets
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mpatocka@redhat.com, 
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev, msnitzer@redhat.com, 
	ignat@cloudflare.com, damien.lemoal@wdc.com, bob.liu@oracle.com, 
	houtao1@huawei.com, peterz@infradead.org, mingo@kernel.org, 
	netdev@vger.kernel.org, allen.lkml@gmail.com, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 2, 2024 at 9:15=E2=80=AFAM Tejun Heo <tj@kernel.org> wrote:

Hello, Tejun

Reviewed-by: Lai Jiangshan <jiangshanlai@gmail.com>

Thanks
Lai
