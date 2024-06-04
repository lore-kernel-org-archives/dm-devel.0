Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA8E145B15
	for <dm-devel@lists.linux.dev>; Tue,  4 Jun 2024 16:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717516977; cv=none; b=sIJkxNfsz4uP8voBHxqd7dm2wGM82RWzCyfVYbwcUzLRCugES8Hx+zmjL/yWsLt7UdoDAB/S7zXVLYnUdz3v1Bpb4dUBU95o/mt4N4OhfZdZljS8rMLog4gW4CZUL24W2Bg3J8QGW5QH6Fa/DBeIQPu3AEs19yDThMOzzM4fXo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717516977; c=relaxed/simple;
	bh=QMUQ5DjGWbWAqfqZyA3ZNWiAoAFfuN8t0qgOk8Z67bA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=u8mkZ4lp+WAJYc3yF6OGv5Z3ZQ3YBxhU5nYnNCujeRa11Tp4OFbxHf3+kTime9V8xlpUyxTuyVw/2YerECXX83UxlboAH7a3GLMnQFMIo8X8LHvVYsCh41z8gQbBcPSz8i5JxZOzyTEOijcPUQ8uxFFnYxFfxLD/yAGajcONjdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DUWutxH8; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DUWutxH8"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-57a20ccafc6so5332202a12.2
        for <dm-devel@lists.linux.dev>; Tue, 04 Jun 2024 09:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1717516973; x=1718121773; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QMUQ5DjGWbWAqfqZyA3ZNWiAoAFfuN8t0qgOk8Z67bA=;
        b=DUWutxH8N/Cah1Jr7UBlepKymJR2yMUc9JVpo8/hc8BHeNZfo+i+AjJZa65t7U0r3j
         zWsqBLRlApZydw0ChlfH4WPea1+PH1b54jlVYSLjm9Osl/XJe5vso7keOiqp0L+S4C/R
         d1QlHa14WnVcWQ8XtN3POqez83MvKYNsyfAMYHVulnlaBMP6wRvt6AbaAJ2C9mx9Yy9E
         aEhEiVVn/yMjU2aZvLd5MqRolXUr9CVEv1txwAU9WQPTONNOfmkP8Zcoj+285X6Q87Kk
         agE3z0EoNjZYVvUBZWTdG0ofENBgh3bfIoouJ0AUiBdKUKnoZVlTNX3X8jI7DV7kNgI6
         9UgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717516973; x=1718121773;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QMUQ5DjGWbWAqfqZyA3ZNWiAoAFfuN8t0qgOk8Z67bA=;
        b=loTB+W99VjexYXgyLVGtGaP7YT4CeZIF1RZMDeUSS2meFlE2PjAZjnL8nSZP88yvBB
         V2oBN0VKQH5yJ04wG44HOE0FS2aeSNkuVLr+Xtsh1LmZJZXNk9Z17cLMmismU6HtOf4m
         zlA32PZRjYB5iri2Bj1obbY/0xcnvu0iqxT7IYEuOdu5wMt3+9YiEetlPHHxfz76JnTr
         OXaSf48Xl70dxCkFkK8MhppTOr+PI8TDVfxqtRyNt1zq27/X7J8duKenM+WLhraks7H3
         nUNmTJY3fLGDAGMkAJttYm9W90L+mq1eunrK4slkH5eHiysZc7LfE2ks/h2pKowvt0Jo
         rk/w==
X-Gm-Message-State: AOJu0YxcV0HY3JAJc5ihgUfaFmrt8zX9aIZRs5GltDBmsYpdM/IvdZmQ
	PTjdN5dcNyWNaH5kIV9sRR/SxzpG2hrEHyHLM6wEf1EQNg1b2nxI8RKVNc62EzI=
X-Google-Smtp-Source: AGHT+IHFENoDlAtiDmIZdllFx5XuChWbZHRDCLC85Np6zYyJrFdpVI+Xow3Aw1dzzzsU7CrFR4S3vQ==
X-Received: by 2002:a50:9552:0:b0:57a:23eb:13b3 with SMTP id 4fb4d7f45d1cf-57a8b6a82a5mr48979a12.12.1717516973346;
        Tue, 04 Jun 2024 09:02:53 -0700 (PDT)
Received: from ?IPv6:2003:de:371a:a400:e6fd:936f:426b:4ff8? (p200300de371aa400e6fd936f426b4ff8.dip0.t-ipconnect.de. [2003:de:371a:a400:e6fd:936f:426b:4ff8])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57a6b6d0741sm2900227a12.73.2024.06.04.09.02.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jun 2024 09:02:53 -0700 (PDT)
Message-ID: <9105734e868f4079eb91ed35c69530233acc5309.camel@suse.com>
Subject: Re: [PATCH v2 7/7] multipath-tools man pages: Add format wildcard
 descriptions
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>, Nitin Yewale
	 <nyewale@redhat.com>
Date: Tue, 04 Jun 2024 18:02:52 +0200
In-Reply-To: <d1b9f76356c8608a5be1b06812061e6ea6c3a449.camel@suse.com>
References: <20240530165500.397009-1-bmarzins@redhat.com>
	 <20240530165500.397009-8-bmarzins@redhat.com>
	 <d1b9f76356c8608a5be1b06812061e6ea6c3a449.camel@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Tue, 2024-06-04 at 17:46 +0200, Martin Wilck wrote:
> On Thu, 2024-05-30 at 12:55 -0400, Benjamin Marzinski wrote:
> > Suggested-by: Nitin Yewale <nyewale@redhat.com>
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
>=20
> Reviewed-by: Martin Wilck <mwilck@suse.com>
>=20

Our spell checker found some minor mistakes, which I will just fix.
