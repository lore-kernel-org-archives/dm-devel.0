Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6943522C6CD
	for <dm-devel@lists.linux.dev>; Fri,  6 Dec 2024 23:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733526934; cv=none; b=nCfrFYB1UgJRrEFk/Ihpd8obIVj5MB5OoQ1qJXsG6tAENBSGmesGwDUcy8Rko1Hb3uMFMafUUTej4sdKDMEwujSQa7iwTlreJL7VlFSASgGTsnsQ8/weTeqrgpzTPPl/R8OYrWQWG3iqbqvjDdX1SycNdUaD4YSP99yG36nz3Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733526934; c=relaxed/simple;
	bh=uJxpTnD6zEeYNBgUqvJgN5wxfR3rO7XcH+lb9QikHno=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Uu/GCJLCv1+5DB9QulqZGizeLTdO046mmqEkedvp+svvy5HqsPrnBJ5lA33DMwZc5Zy6SeRI5Us9B/KTXnwUZWERZHSCut3Jvw9RYUPY9oXKZu8+n9OQvahSxCIIJTuOi2sEpsD4iMxoKZF8UPw3wEWuf1CoTS4QWTwEFI/O48E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=U7/7PEfq; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="U7/7PEfq"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5d0ac27b412so3110084a12.1
        for <dm-devel@lists.linux.dev>; Fri, 06 Dec 2024 15:15:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1733526931; x=1734131731; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uJxpTnD6zEeYNBgUqvJgN5wxfR3rO7XcH+lb9QikHno=;
        b=U7/7PEfqM9tj05k7Aokl8T/SpHMGThJfFe9XXmcU9A9LUBaOFYubOS5C+65TYW2Q4F
         CCXHCRZZF1mT0yKNgw3+O8sqJGiIfF6r9cOnnLG7CfdMC0tdEzALyRVC0BqITp9uEocl
         cKlNo8r588t7IQNKZedlD+Jq9mypjB6gji0cyBX2En9bRYCxO3Lpyvfyz3QjbZRYmYtN
         eX2EoTpEDo4VPeIlZ8tS2Bzbg4IUo4CPBm+2RMhvHa9R9HAKhb1hVGATavvF49/TJv7/
         V/t6JqNSslaoBB6tncV83WYaS8cyHKJWyVZDcJTkm7ETCnNLvTj9ct3QxhgL2I0SBvTE
         KUcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733526931; x=1734131731;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uJxpTnD6zEeYNBgUqvJgN5wxfR3rO7XcH+lb9QikHno=;
        b=MqR3GeSTgvhIccQ1QXOJwXfiJpudsX58/sUxT6JM6SpzP14krI+5FgfFf+j2SnR1C+
         eUAgDNCWFj1Kd3TSgn19L8nKdTGCPqJZJ+RhX+CEZDayP5RwsYpLjsvSOAJZirushe1Q
         /DFWnZEycZwrmqqhxNH3GtqGmtplHEQnzV4rJ4V0TYZL83PdkQf8fAAS9WJT8zQz7xps
         /83vXbu2v95DnOPkEfPCJk9FOCwfThLjQP1rCS2OGWImVi7m4uxiBZsBqPlYTuSkrgcf
         dIAGpPPzcppa2F1S/rcAKt8qn7ToTyd0S5cY1/4PZjrFopNPgNipOF6jZa2S0/Aiug8W
         cIyg==
X-Gm-Message-State: AOJu0YwgUtnjq0rMfwsU7cOEMZDA2myFRPTsAtKxtKV4GQrpqj5q9w71
	BMPy+hw7rUaafruNvFCkLYPLxFJxMHWMLRml3XrSVQr8Nsy+dgLIWs0ivNBVUWA=
X-Gm-Gg: ASbGncvB9IWU+4FIat+/+F0qX43qTVonPzWx1TivWsVuV4qsQMsouS0wGI+yIS3U7zm
	FjUTQDr+7OC0L0sVJNU7wFYWsSpz/6oNt8VerZFZKVfqaBkpaSbNRiQVHTPEWP6orAbmr2DEPtM
	1uANAJHvGrcK8iWHUOsZonF+1Ye1qIY8FRWMCUyUcZnAD8ncJh4nAc8+nr74w4N0N1c0NslrrnZ
	gx+e9Mgs44CAxdGG7IbjRHp7ZHEAiwzilEnxuCAG1r26ov1mdnuYC+ZkY0Xx0dNiK1xDU02WbR/
	lAuTTApNfK04EddMw2Y0+L3nfz0dGbAjYkh9HuC6sjolqJhcvhg1IGZZmQICjTbr5cufQwSxdVl
	YWYpmTw==
X-Google-Smtp-Source: AGHT+IGR1+2MCQHfdKC9S1wYeaGJ1SQpppavqxFkaTZbS6dC+IWa6p1qfb79mufoSO71bDa2g1GuoQ==
X-Received: by 2002:a05:6402:42c2:b0:5d0:bbfd:f3e4 with SMTP id 4fb4d7f45d1cf-5d3be6d3514mr5118220a12.20.1733526930398;
        Fri, 06 Dec 2024 15:15:30 -0800 (PST)
Received: from ?IPv6:2003:de:3746:4600:ac00:378:25cc:9f2c? (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d3d00a0370sm1049263a12.6.2024.12.06.15.15.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Dec 2024 15:15:30 -0800 (PST)
Message-ID: <d8a879d57bc92f635b8e2dd5b7fe2329f91c0bed.camel@suse.com>
Subject: Re: [PATCH 2/3] multipathd: reload maps in checkerloop() if
 necessary.
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Sat, 07 Dec 2024 00:15:28 +0100
In-Reply-To: <20241205035638.1218953-3-bmarzins@redhat.com>
References: <20241205035638.1218953-1-bmarzins@redhat.com>
	 <20241205035638.1218953-3-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2024-12-04 at 22:56 -0500, Benjamin Marzinski wrote:
> update_pathvec_from_dm() may set mpp->need_reload if it finds
> inconsistent settings. In this case, the map should be reloaded, but
> so
> far we don't do this reliably. Add a call to reload_and_sync_map()
> when updating the maps at the end of a loop in checkerloop().
>=20
> Suggested-by: Martin Wilck <mwilck@suse.com>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

(I'll send a couple of patches on top of yours)

