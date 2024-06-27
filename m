Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A124B139D0A
	for <dm-devel@lists.linux.dev>; Thu, 27 Jun 2024 09:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719480822; cv=none; b=A6V2X4+a/2wVhwZRztwUusxdRFyGMQJE+1TjydfeqIukwBZX/2Al3q6i2HGDveZ+C6WAajlawdnmM3s3V2/ecZSC+y/TkzeF3SxUemYadWYYDUs7tDD6gm/4aWo4yIDS50sBYuWxVXj+SMEBtl/02iMkQ5lAzmTyLjmiC4K2FzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719480822; c=relaxed/simple;
	bh=19mFz68rTZB+1WBWDKV5qg6hqgeIxFJpmZgOv1uUoZA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gDBu3odgpAy5IGyPK2b/vYjtZD/mrlc+hI2bZgzgsBg6IBdJuYH7CFkm/uMdSQkHfGMKS6FvAIB1jV5VIzmT49Zr3N6YQ+nKJgHu+iPb0yXjgj//ckQIlZoRuDbwHuTy1ego2IQ+sDA6bAzVXThCTR20vfK3A3Ex/pYSuNYWrDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=F0M0WIjH; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="F0M0WIjH"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-42138eadf64so65580265e9.3
        for <dm-devel@lists.linux.dev>; Thu, 27 Jun 2024 02:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1719480819; x=1720085619; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=19mFz68rTZB+1WBWDKV5qg6hqgeIxFJpmZgOv1uUoZA=;
        b=F0M0WIjHw5dBm1esKqL/9sZD9j/j5dOEkDWiA+dapMqVvqrQY3PgmPRRjmYOkmf6//
         q8FpOvPOOsRdtmoD903nJzQj98MSJn+0S8y5ctmWdHWAKoCZUT5gYUzUH4IInYB+tQq1
         niPRQrCLVOzp2c8uXI6Aae5jL4ync4N8KOto3pRxp/jGoR0ZaPmdcSw9AGFSxvhpyvmI
         kbmCAmloPkaRp3ghD+tIRneJtGfXKsTJ071EHmjhc4gu7hCmVWJuVld4FtLyMvePZ3Qh
         AC4V76oxf0fpjw0hbHTnPh6v9BTRWy3XSj/FyGJ9xRvUqOxd214CnuNdpy9nWcXwcCxG
         0kfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719480819; x=1720085619;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=19mFz68rTZB+1WBWDKV5qg6hqgeIxFJpmZgOv1uUoZA=;
        b=o7/AloyHVMpLVLk4CMQWeRwsjkh3IGKh3pJi9nx4eGsfrm2PfTU4CxNi+dARgG8rez
         LcimFoEZaGLbwGunLEDPM9s8p5vnJEYaJfBwuY9r/W1+oyoTXyMlakHXnRs6pM7ude3L
         vnMX0uxaKh6c7ykjA22lz7bYexCrtXRJ4cadOiiaoRXd6cb+QM0n0neWe4+vG1/cH+KE
         VB22QqdlNBJaeE4yXnCQqPjLPHlCk5UH1i9P2zpHpbhiGrLySa4d1wl33r2NMHEm0Vxw
         IMWIi+3IFfZhNsg6c0rUpgDbMxK1QFWd8aGZecERl3IpFDyZS5rBWROPk34e42f2xdOK
         AoZw==
X-Gm-Message-State: AOJu0YwEtFuNEmR2ZQEdP+9lrIP8QQqTqnrAd/0o+LZ0r9fhyhyZVWQA
	gX8TSKbb5IGWrMCH3Q9kTpC4UrkSs9b9hYtOH4v/SZ0+oX0jNYEV9+mhWcDl2aQ=
X-Google-Smtp-Source: AGHT+IFpB4060SU2coYvbRAJ7sGoGUb8q4tD4XuOPQenxe3GjBP3xkwav94AsdZ11o7ehL0vZhLCFw==
X-Received: by 2002:a05:600c:35d2:b0:421:eecc:2404 with SMTP id 5b1f17b1804b1-4248cc34aeemr84120065e9.24.1719480818691;
        Thu, 27 Jun 2024 02:33:38 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:e6b3:18ff:fe37:a690? (p200300de37360a00e6b318fffe37a690.dip0.t-ipconnect.de. [2003:de:3736:a00:e6b3:18ff:fe37:a690])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42564bb6caasm17516485e9.33.2024.06.27.02.33.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jun 2024 02:33:38 -0700 (PDT)
Message-ID: <d93d839406d37b958c90d6905c269d4a1c32a012.camel@suse.com>
Subject: Re: [PATCH 7/7] multipathd: make cli_add_map() handle adding maps
 by WWID correctly
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Thu, 27 Jun 2024 11:33:37 +0200
In-Reply-To: <20240605232254.623290-8-bmarzins@redhat.com>
References: <20240605232254.623290-1-bmarzins@redhat.com>
	 <20240605232254.623290-8-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2024-06-05 at 19:22 -0400, Benjamin Marzinski wrote:
>=20
> cli_add_map() runs filter_wwid() on the input param as if it were a
> WWID, but dm_get_major_minor() will never find the multipath device
> if
> the user actually passes in a WWID. To handle this case, call
> get_refwwid() early in the function, and use dm_map_present_by_uuid()
> to
> check if the map exists, and find its alias and minor number.
>=20
> Also, the do/while loop is unnecessarily confusing and only avoids
> one
> repeated function call. Remove it to simplify the cli_add_map().
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Looks good, but it depends on 4/7, which needs some work.

Martin


