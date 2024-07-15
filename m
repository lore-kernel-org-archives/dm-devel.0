Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B7DF9EC
	for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 15:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721057980; cv=none; b=iA5YzGqKeecmDN25G+1yfRiAw0KEbfCfJ3EAocwxs+0XyMZI0fSc4kuTNqWHbH6q05LZzi0OoUR5CPZp36zxLvgKQiaGreQYGJN9aityBzltmkDOSuksNB8izrOZN0LKy0dAmqasCg0N2yT0IGONq0XPjkCFVjrM/gPF7jPHz0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721057980; c=relaxed/simple;
	bh=sZrGP6YLVr1xKKu+v39CrmSYBT+mErFb87JCWk4MBMg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hEFke6Vd8ZrLEAb1/a/TkaKrVIdZl5UE9vE0O5uulVF+y5JEBoCuIuqdFRrAXlXOzK1EG3eEm5McpRzijtqifUBUVLW8B3novfDWzedh3WB5vNTInUnctujF4z8Gt2z3iNKtOnp6CP+OL32a7TQpauRlw05r7c5O3+J042ntykc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=W5GGg/Mi; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="W5GGg/Mi"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2eede876fbfso26376421fa.1
        for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 08:39:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1721057976; x=1721662776; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=sZrGP6YLVr1xKKu+v39CrmSYBT+mErFb87JCWk4MBMg=;
        b=W5GGg/Mi3iCQ7UmXw+h2NVHAhKguNZEgNUIAqbkvz42pycYufoNQFjzHEpNFufkZ3v
         NTkHDTs6DCkO3rPUEC9ZttLrNXebIjo6lBekPdjPAxO6o6pNiIhqeU2mV8oh+7nuRB1h
         p2STDk5Kbg+G6TK1hhA5qi9Fo29J12mBdoUKhGHpNjWEKwitNT6lqCgATXN+qt7GNPy6
         lGZj1yJlN1IZA3H+whkFbi1vqanNdTusksWqzJ82Y0Ut4WKEiE7JKQD1DwEC8GqV4n0f
         AUVNG4DvOTgGWwO2rcHQ2JXwz4WkEywyXs0TCy74pYGSFxtfflc/ItANuN9wteinBpnN
         SzEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721057976; x=1721662776;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sZrGP6YLVr1xKKu+v39CrmSYBT+mErFb87JCWk4MBMg=;
        b=Ky83AMCIN5w7bxQ7qayY0NzMuKiqmrKGZI8BpAoW2w00hrEfd7zumHdZRIm4oT+4tZ
         0CI34b7r15NUDi2Gw4mz3lS5QB98F0BaTmrOSwIFRVs0fgMYFnBsmC8ze1SYsqlkfacm
         I+rc5/S4QSJSBx/2OuVb9yfq9N++srrZqaLLqFpqna1cM/pTD7K+ROrKBjtTXLanD5NK
         2WEK7ckIFLI+a9H7tkgsbhBxB77VdvblzLI+q9XmoHdixT5671hOH8ca+X023tms3hzo
         CZRxxrtyFx/xXnXoAhXcA0KPG6wjI90BEDWMgsqCuY4jWD1oILXsPAqq9pj+Af8DIdSA
         1omA==
X-Gm-Message-State: AOJu0Yz3okWqnYjG/kwb0rZoO7BLIXNuHabM6xyTAhOMimpwaenxX9lf
	8fwinzAKRmHrWuEJ1K10y3SvbB1qrh2KmbhMKd+k6KfdWXJmBydRBWj2MJqSAbnMbxn7Ja2fm0K
	9
X-Google-Smtp-Source: AGHT+IEkgS/v2iGBGdPVsFWjrH8s8huxWxIozokPQNyEa45oGRoZue/+sBJKirfaaeOeqVn6wIJqbQ==
X-Received: by 2002:a05:651c:1198:b0:2ee:8839:8fbe with SMTP id 38308e7fff4ca-2eef2d7b326mr1875091fa.1.1721057975898;
        Mon, 15 Jul 2024 08:39:35 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-59b268a29b9sm3473943a12.61.2024.07.15.08.39.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jul 2024 08:39:35 -0700 (PDT)
Message-ID: <48a0f31b91ae3430d343a309ac794c00d7b9aa1b.camel@suse.com>
Subject: Re: [PATCH 08/22] multipathd: check paths immediately after failing
 udev initialization
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Mon, 15 Jul 2024 17:39:34 +0200
In-Reply-To: <20240713060506.2015463-9-bmarzins@redhat.com>
References: <20240713060506.2015463-1-bmarzins@redhat.com>
	 <20240713060506.2015463-9-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Sat, 2024-07-13 at 02:04 -0400, Benjamin Marzinski wrote:
> When handle_uninitialized_path() moves a path from INIT_MISSING_UDEV
> to
> INIT_FAILED, it has already waited for conf->retrigger_delay seconds.
> It
> might as well check the path state now, instead of waiting for the
> next
> iteration.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>

