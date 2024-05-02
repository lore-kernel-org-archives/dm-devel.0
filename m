Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 213F539AF9
	for <dm-devel@lists.linux.dev>; Thu,  2 May 2024 15:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714665150; cv=none; b=qjUBGBEfjSU1nAJZqLc50/3UbRrmTDGJ/5/J4tZ+t8SZTyolCfCKtKbX1UhFM8uVJ6UTkpD5SCtrcyK2VLySfXgVSJlXcCHeztK08FbNBNzNUL+d/wkB94WEusTZpiEIMEXL4BamfOD/AzcwHPbLMaoYdEgXmPxhLfH4znaiRTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714665150; c=relaxed/simple;
	bh=fW2t4cgBZA+e4gidFOrwLlB0VRfqQTwzVDc7LT4/3K0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uIhag3mbhOo+cr8lE4EaWg12SfIMv4tUNr3GrlpLzurWgGutPbYc5cBHSYBaXIunc908rXmHMeCLxXq3sILrd9HGnjhJ43sxm+ymRcnneCqu5qiF/wpOrBGWsKMcvPlW7cPjBippv23KzoBJl4uyXOIHW0UvCYrZZ529TXLVcFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=A+9QvCQ0; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="A+9QvCQ0"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a55911bff66so1038568366b.0
        for <dm-devel@lists.linux.dev>; Thu, 02 May 2024 08:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1714665146; x=1715269946; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fW2t4cgBZA+e4gidFOrwLlB0VRfqQTwzVDc7LT4/3K0=;
        b=A+9QvCQ0eqeKzy12W8LamUt9FwRUQ+klaPEMLSXooO/z0NgNd0RbdRWFEtBsU6unz1
         HmmUq25ArQJmSsAChdvWofGGvAik5sC//tw6Gm4meRwZzt0bxLsxkaKTZYKxe1Y/ZCby
         JeYdqgZqq95CRfPcIF4GNrXRDALNxBGjNVycJfiMWmZ0cYK8+pDQJUk0DSw0ugUlnZHT
         t1an3U6duBE+ww/Z+Lsz036zY7N6AoDDUrJ5ksF5B9OPZy4yfXxn9XAr0lOVtxnqanUu
         cSqAb5A5D5SOikNpMiOFg41PktL4n5s9q8fFgqFRrjuaQ2JrWtIIqO0Ictm36VHAAuV8
         z9Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714665146; x=1715269946;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fW2t4cgBZA+e4gidFOrwLlB0VRfqQTwzVDc7LT4/3K0=;
        b=vinWxX/J+TOZq6pj3Kjk1gRYeoNLJNdpasAUo079fwhtPHPPbWIFnDWo3a/PbovNXs
         e17fvbwHRuNcp7+744xWScAvQ3sWRXNe+6w19oCoj2/l2oyjD0zn4J9rkBT6G14DeNr+
         covUlfCcewUmRO41DUDDlVfkz0/pro79EVheVD6f2kaH9IfpyhwqKLpt90njuHyBzRgY
         NujsW/1Qwc4Q7HPP/oO8LxKWdJgA7rfbNSs1Kij2DqESMPo3iFvtRJKrcGsJo3kg9R7a
         kEZexsh+mmAiAf8GwdGxCMCRKkMoBZKmArhEZIoqflU4UcAxxBcaeSYwIJ9Ztg9rM5fF
         rWeQ==
X-Gm-Message-State: AOJu0YwBy/hc2E6hntJiXz9waifCHCSJmcwEAMt7HwRGQaG99wF4aqwC
	ZIiCwd3CO1Hj0FR1dbKXd/KgS+6pTPzoThPl8dlN7F9hq9cnlADrgHLqEHWEmXo=
X-Google-Smtp-Source: AGHT+IE7iJmtlUETxL38lL3cn6c2CoX7ykjiAct5m4Olvu+R61wNKV9nXUcxhO/D6GrULpgb6cRNtg==
X-Received: by 2002:a17:906:1694:b0:a55:8f2a:950d with SMTP id s20-20020a170906169400b00a558f2a950dmr3939198ejd.16.1714665146533;
        Thu, 02 May 2024 08:52:26 -0700 (PDT)
Received: from ?IPv6:2003:de:373e:dc00:b298:a6be:282c:8242? (p200300de373edc00b298a6be282c8242.dip0.t-ipconnect.de. [2003:de:373e:dc00:b298:a6be:282c:8242])
        by smtp.gmail.com with ESMTPSA id p25-20020a1709061b5900b00a54c12de34dsm685158ejg.188.2024.05.02.08.52.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 May 2024 08:52:26 -0700 (PDT)
Message-ID: <bebad0cd71b1d979e9db514a2172d1e4a22eb969.camel@suse.com>
Subject: Re: [PATCH v2 5/5] libmultipath: fix deferred_remove function
 arguments
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Thu, 02 May 2024 17:52:25 +0200
In-Reply-To: <20240425233517.2125142-6-bmarzins@redhat.com>
References: <20240425233517.2125142-1-bmarzins@redhat.com>
	 <20240425233517.2125142-6-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.0 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Thu, 2024-04-25 at 19:35 -0400, Benjamin Marzinski wrote:
> Aside from one version of dm_flush_map_nopaths(), all the callers of
> _dm_flush_map() and dm_simplecmd() set deferred_remove to 0. But
> these
> functions, as well as some helper functions they called, all treated
> the
> deferred_remove argument as an enum deferred_remove_states, and
> called
> do_deferred() to see if the remove should be deferred. To simplify
> the
> code, make these functions treat deferred_remove as a boolean value
> signifying whether a remove is deferred, and make
> dm_flush_map_nopaths()
> do the work of checking if the remove should be deferred.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

While correct in general, this patch doesn't make me quite happy yet.
The argument type of _dm_flush_map() and elsewhere should at least be
changed to "bool" to express the semantics more clearly.

But I have something more intrusive in mind. I'll post a patch on top
of your series.

Thus:

Reviewed-by: Martin Wilck <mwilck@suse.com>

