Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CD9034DCE7
	for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 17:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765993619; cv=none; b=DDz+BGweO4pc2ahPKn6FMbs+eOQb2ONDCoDvUj1KhqQhJTVCWu3MDpjKLCZeEeXHDjgSKoQw7Lu345U3l9iTDeunCMve262JV1WYcZgDct0Bd/LOiWqEj9+e3yY6sHjLu9cFZIrJWLY9ybo8iMt7z89sAJ2UX2NFFYERSeJajqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765993619; c=relaxed/simple;
	bh=10PuJbD/hlVV3R05X/vtkSu59Oxt70T0gJP4xgHSrvY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ALpJvrViEJT5rvJfD6ZzY+379FSVn96HQ0CYLFnXu+7HnWVSMlicTP0zYYfggRb0YkQstVQCJmONEX1SNJQuaMeIfvHjPQv+xFUQcKqZp5XzmgttEXgHQzfJvZm/3DAJ3CxHCBrH5M1u1ZqokSNsJJyydVcAOBlbjOk9EtwxC1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wBPm9/NZ; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wBPm9/NZ"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2a0d06cfa93so1265ad.1
        for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 09:46:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765993617; x=1766598417; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=26JasJmptoj2sQia7hYhyQLiuzOJ/Yi+MG8nG8/oJQY=;
        b=wBPm9/NZm3+v2AmiZi/0z9cuTAfomXBTAs4F3ymq9cJOVJuLjbq9fIcJVRhciHLxjv
         ARUWHiG+VoK3V1aQdGTb4eE65st90j9dDmxu4WebB5WkYM8L0hJ8nuuO8X0qdUJI+cgy
         HxcDI7ot1S2YVJ5dvoW6UD19actd9D3l8kQsorZWlVywIjMNC8zTeqj8IxQbbatl0Zas
         HAMjoy9CZqll4NioHkwtc/DadM9Ct7pUwlKpx6Vh3VCh0S54xp967oYcz0h70pOiU1uC
         dgcuDkRIR18MKolPT7TlAuR4pD9T2eOqQKxMtxyjgHB3Yigg/7ATjWRiElLy037Ac01l
         jX8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765993617; x=1766598417;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=26JasJmptoj2sQia7hYhyQLiuzOJ/Yi+MG8nG8/oJQY=;
        b=anD+DEjFySDJCnewVwZrgt5EHAW5Cq1t0WFA50wAbEbey+9roG+iPGFRHAwdZfdryH
         +QhjS1cs9cEE0lz1RKHXSNbaI/yGR42zkllyFNnevJab2JhftcyA6EaOL32thLd7yfDw
         vq/4gdnPs+xOaOPMcxNzCK8uRD1nO0QNSWg5TpDrOYR2WrqWB4xebTgv2C9ogv4P2bKJ
         vYyrr91YjTUS5dr+YkSgwA45VfQX1EE23CkADP5qhcakuG2G/RmNi+hawvumIfFvFNUQ
         Gufiz/fOF2hNk4of/uYbA+IP2zZsZsqjf5zXIy4forGc8Y3SV0wAH4QjcbvdQx9MjntH
         FuCg==
X-Gm-Message-State: AOJu0Yyg2LVu+wazZWLg6VsSlS12CBJDPkgBrtU4jij6WJip9lOQmwZC
	GTp35rmAV7xx8he6p7FH2r/xDVdCUXALII7WOd7ZSdZt/dC0rv+HbhWcqEZWSsbBCA==
X-Gm-Gg: AY/fxX4Xx5yRe0NiuLAZYpm/i5mmqGw2gcSHfNb6xYyHrBk9+GJmuF72D+0KgYtJcbg
	rp7UqFTqX/JySPw3BRG7IKEDyToglUAxJ2/+3hsHT4B4v8wfhROdzVFavDz4vhKbsoqMvuwtRLq
	Lbev4jOhqEEgz/so7ez9ZaczZ/YYQfJhAsmS6EfWar6bCceeHbv8bMO7dKYVej/n0VmVi+qbtEn
	yjaliPJLTLJ44JxrCA9B70Qmo9CcCOffM6AuhtYwvvW8I5ywzHZMBAbi4G8fUhRTl9PRhthb5LF
	PdOR63AiZCB2tEc5wXAAML49w9BW7qZjCAXXfZUxl/MeIfZJDew/3V/upDUEf4a0VwL6Iw5fp40
	Dg8erwjjQc2fcrEi8tB1eaIrqkCKTFrhiwCUqxSx8KJcZu0mjv2VvJxZNsF+iqLCl1YycZL7XQ1
	Fhltr2Quz7IjzcKO8BQAC3LS6DlMkgpwyf982aEZhPr+BCNzpH+mU69JU=
X-Google-Smtp-Source: AGHT+IHcr1+PzgxX2lZMgAjv5am5n1vT4C3/GWc0GVjNxHzpwJACFGX6B/dWHcbHZndpxOfN+c8Www==
X-Received: by 2002:a17:903:124d:b0:2a0:7fac:c031 with SMTP id d9443c01a7336-2a15f2d2f83mr2997765ad.14.1765993617109;
        Wed, 17 Dec 2025 09:46:57 -0800 (PST)
Received: from google.com (99.181.125.34.bc.googleusercontent.com. [34.125.181.99])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7fe14568fbbsm67114b3a.54.2025.12.17.09.46.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 09:46:56 -0800 (PST)
Date: Wed, 17 Dec 2025 17:46:51 +0000
From: Sami Tolvanen <samitolvanen@google.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: dm-devel@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Eran Messeri <eranm@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] dm-verity: remove unnecessary condition for
 verity_fec_finish_io()
Message-ID: <20251217174651.GC2944334@google.com>
References: <20251216230614.51779-1-ebiggers@kernel.org>
 <20251216230614.51779-4-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216230614.51779-4-ebiggers@kernel.org>

On Tue, Dec 16, 2025 at 03:06:10PM -0800, Eric Biggers wrote:
> Make verity_finish_io() call verity_fec_finish_io() unconditionally,
> instead of skipping it when 'in_bh' is true.
> 
> Although FEC can't have been done when 'in_bh' is true,
> verity_fec_finish_io() is a no-op when FEC wasn't done.  An earlier
> change also made verity_fec_finish_io() very lightweight when FEC wasn't
> done.  So it should just be called unconditionally.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Reviewed-by: Sami Tolvanen <samitolvanen@google.com>

Sami
