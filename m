Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D066FDF5C
	for <dm-devel@lists.linux.dev>; Tue,  2 Apr 2024 01:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712021210; cv=none; b=co0OLfM8lvOAuOIh3QhhPIY7/OY89IGU4ZjyhB4Rc9SjwBCLLBNdFxfiAkJ4SY2YLNNO9v/WiBO7Th4t3N4aV8Z63lQ7MKAAVgGB4fecrfKcK+x6XhBWZEYXx8iXXZeiII6eKPjD12+cY1nyikiUE2wV6Yulcj5aFxb4JqRn0yE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712021210; c=relaxed/simple;
	bh=WqrYHc1OrW927dxpv9fTrIBfKRqR2NBvDdcY6XIS0bs=;
	h=Date:Message-ID:MIME-Version:Content-Type:Content-Disposition:
	 From:To:Cc:Subject:References:In-Reply-To; b=eIAeD+mGQ4Zwpowl1CTZKQc8QeD+3VeJfYrs4wp35txchmVhQQ/mck7iknw4AH+X6i8EOLmoK/6yINGQPWZ5LwsClhPrfzCtZtr6tJGTA3ghQSeGzZ+YAim4NU/eFRgCzdDsdfakqg+hNdGzeXAPfYhw3GLivUfChyUNfSrfbZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=VvaKM7gc; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="VvaKM7gc"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-432ff72d745so6170751cf.1
        for <dm-devel@lists.linux.dev>; Mon, 01 Apr 2024 18:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1712021206; x=1712626006; darn=lists.linux.dev;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-disposition:mime-version:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hRws9YXLN8yb7zuQUc8CIutzWgp4avkTPI09HZCU6cI=;
        b=VvaKM7gcqspPdQXMO/J5ODc9xyXMqyPJxaP1Ti+98WlFC1y0BNjPInnMLY61h9zAB4
         fh67mgnfhqit8fuBN1HrY8bzpoUHeJfAKvhxU5wCeopQ4Q6RnlszKh0lmbFmlUtxCvXj
         TYkrJ94sBgHnwD4bXyzg1clIVyJ9S9T2tv91lPshVI1EsqNsYnbl4ffkCevunFSTZpDZ
         QUPPtGW496glzstqi++rNuBaT10r0o1Kk7p0LU8G+5/Qdw5iRehWCYeHV1akImx4Onau
         3ZdQJBZWPge4uDiRpGethWo6jcTR3YBPsgyIKNm/Efb0/b/m4LLfKtx6obh1pYGxYQwP
         Jrag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712021206; x=1712626006;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-disposition:mime-version:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hRws9YXLN8yb7zuQUc8CIutzWgp4avkTPI09HZCU6cI=;
        b=P/AUmYtURXAeS4qPYCMW/bgN17kbJJD7IaMZNWlockFl7Hf10+07g3CS2k1K0KfN9c
         +OlkV6eehoeuAvWd+FPQt6AT8Pp4AG46b5SnQtKf9tyMkozf3s4iU56TYIcZg+d1tm6o
         e79WJce5lq8Hg+aR1XneWPvY9o5OI1gT6YD/ALJuIDmMyOZMGssZ/bKpCQJ3bb8pdm2k
         ZyC6jcDwtGERb6NPYdqLhE3RH3VfWaZ45wkOBeKQF/CMHSip6YS/cVR5yqgsrjjs87ee
         3i9PP/tn2RI6b2BhwVNPxe8SE+hi/sWsth9F61UadXItjwmdBjM+or12I6dgW5I/+ikB
         WMqw==
X-Forwarded-Encrypted: i=1; AJvYcCXyxOPkJHepq2amdflROWHWyjjVe22ERI873IBTC3rqKzS3rE0gCMCho/X3kZbJW+Qg5GkRp3WvQw6kLJN2AwksvYT3HqI4Uw0=
X-Gm-Message-State: AOJu0Yzf+npu1f07EjNP+Y/TeRcPy2Crcz6Ojr9hmVbmsSSWaFNT2YB8
	XRfYfvKTEKqYgNt0dWmEV4qGmcHcch78AyjSaqZf/XMTCfyyoKt74ibNa9TR1w==
X-Google-Smtp-Source: AGHT+IFZ7SasfMMYh5vB3j/xGXqf/TCs4Bcif8z6dD6zV7+EZAG39P9HJEPaE4K4Urz2UW0TPzSDug==
X-Received: by 2002:a05:622a:4b11:b0:432:de8a:3a8 with SMTP id et17-20020a05622a4b1100b00432de8a03a8mr9661426qtb.18.1712021206548;
        Mon, 01 Apr 2024 18:26:46 -0700 (PDT)
Received: from localhost ([70.22.175.108])
        by smtp.gmail.com with ESMTPSA id fw4-20020a05622a4a8400b00432bcd630c8sm4405470qtb.93.2024.04.01.18.26.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Apr 2024 18:26:46 -0700 (PDT)
Date: Mon, 01 Apr 2024 21:26:45 -0400
Message-ID: <7bc35832c837a23773424bdc2255808b@paul-moore.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0 
Content-Type: text/plain; charset=utf-8 
Content-Disposition: inline 
Content-Transfer-Encoding: 8bit
From: Paul Moore <paul@paul-moore.com>
To: Fan Wu <wufan@linux.microsoft.com>, corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org, axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, eparis@redhat.com
Cc: linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, fsverity@lists.linux.dev, linux-block@vger.kernel.org, dm-devel@lists.linux.dev, audit@vger.kernel.org, linux-kernel@vger.kernel.org, Fan Wu <wufan@linux.microsoft.com>
Subject: Re: [PATCH v16 15/20] security: add security_inode_setintegrity() hook
References: <1711657047-10526-16-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1711657047-10526-16-git-send-email-wufan@linux.microsoft.com>

On Mar 28, 2024 Fan Wu <wufan@linux.microsoft.com> wrote:
> 
> This patch introduces a new hook to save inode's integrity
> data. For example, for fsverity enabled files, LSMs can use this hook to
> save the verified fsverity builtin signature into the inode's security
> blob, and LSMs can make access decisions based on the data inside
> the signature, like the signer certificate.
> 
> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> 
> --
> v1-v14:
>   + Not present
> 
> v15:
>   + Introduced
> 
> v16:
>   + Switch to call_int_hook()
> 
> ---
>  include/linux/lsm_hook_defs.h |  2 ++
>  include/linux/security.h      | 10 ++++++++++
>  security/security.c           | 20 ++++++++++++++++++++
>  3 files changed, 32 insertions(+)
> 
> diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
> index b391a7f13053..6f746dfdb28b 100644
> --- a/include/linux/lsm_hook_defs.h
> +++ b/include/linux/lsm_hook_defs.h
> @@ -1020,6 +1023,13 @@ static inline int security_inode_copy_up(struct dentry *src, struct cred **new)
>  	return 0;
>  }
>  
> +static inline int security_inode_setintegrity(struct inode *inode,
> +					      enum lsm_integrity_type, type,

Another bonus comma ...

> +					      const void *value, size_t size)
> +{
> +	return 0;
> +}
> +

--
paul-moore.com
