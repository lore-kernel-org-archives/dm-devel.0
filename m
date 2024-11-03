Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0EA33FE
	for <dm-devel@lists.linux.dev>; Sun,  3 Nov 2024 20:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730664662; cv=none; b=Dt51rd5SVBf4mRjdmfy7gnOsJ6720BXtbKXrgtEHKwt4qv+EGcCY75l3vb/R/GKC50c8JGbFT4flQpPJQ0BAFO9MQjvZiWwPfWBvduV1dtrfto8dvzFzeneKWqJIXCHoW8S+EhZMSfFPph/B44iK5iY7v49tSEUthzI0GYWLriQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730664662; c=relaxed/simple;
	bh=w/BryI4+MVL1NVp2rh+Cmghh+gp83gH5XW6gg9TQaZE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=n7nK2kZbOpyYRY2+I1aznsnOEhkpaZocp8vDzwH7q0jfiBePhAOrk1U0ADw5mLZR4M4g7Q3Izmkz2aqgYsDgN7EGKhIccA2WJjYE7wODyzSljUfLcbzDIz9vPk6E0sprK0j1xfmmsnWRo2ZzCYZl0DghCrI53T1NHN4cxtVDg6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=JSPIaRce; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="JSPIaRce"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5ceca7df7f0so1485744a12.1
        for <dm-devel@lists.linux.dev>; Sun, 03 Nov 2024 12:10:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1730664656; x=1731269456; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=w/BryI4+MVL1NVp2rh+Cmghh+gp83gH5XW6gg9TQaZE=;
        b=JSPIaRceTZx5jPg9AnF49upnNqW+ixYO7Nld5a8mz0H2NktA4LnegDGGfL1v8uS1LY
         /Sw2V66IXh0n52aVVNaF7ND3rAm6cloRL86CilONtLM2EL028hanRDxAKK40JG7PWZXA
         ZjuB5X9pF4YXtm0HIIr4yFoQib9ievxjwDHLAd2Bc5sizMJtBOvfVXIsXU3f32utq5GY
         c2u/as5QJoyMPpUojDUwqjjkjuJtwNW9bp/bnrRNvS/w2IiLgCiiXDGCB2wj1OsyNOOl
         y3MJmFXq+tggNSRNIkinJlP/EOUF7plJxV8IzCiczDj7gQVOKvq88rzry+dcViyjSA9q
         d9EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730664656; x=1731269456;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=w/BryI4+MVL1NVp2rh+Cmghh+gp83gH5XW6gg9TQaZE=;
        b=fkXPdwkqCO3BW4L/zdgi6+GjrIIWq9DcPfTeIqRWPHigDEecdY1Lm5NKj4oTWFIDpO
         Tx9/1sb1va13L6y5WRX6bOxzCZWoHJrNLmjpK1yUPcy856i9yWEeTArarTiY+TN7sMCT
         fesndA8tWcWxY/1VfFC+hiZ00sY8EhlMXISapnPVVNKppV5UpZyHoG2z9yuKxESRyirj
         JvzNzpL7mkC6NdmRDTbq5GmT/q+ZoGQE8vGlS6IOcfuNsR4+p+xNo/5U5779VPxZ4ycZ
         nIrgH3Vxd8etoklcH4LId34b6F8OgDyru9pWr/eP2Sa98EoRlClj0m77mxx6BIkgIVww
         3imw==
X-Gm-Message-State: AOJu0YzIPzwTZ6j7eKznsM09CeCTjiN1O9+ebBzCsfJ0OiAxNSjKxqDY
	8EpqTPW2BRTkV2vJbmMdnUs0TFtUJNXJaH/bj9SMYTFKd0BarpGcGBsQV9jicDM=
X-Google-Smtp-Source: AGHT+IEYophnNkply+RJKKXAYFIRx7iIc4YZGs7rREZ5bpI0vFsE8gu0DyvAgUInExCyWvOpst0Y3g==
X-Received: by 2002:a17:907:6e9e:b0:a99:46dd:f397 with SMTP id a640c23a62f3a-a9e65806d1emr1036693766b.64.1730664655396;
        Sun, 03 Nov 2024 12:10:55 -0800 (PST)
Received: from ?IPv6:2003:de:3746:4600:ac00:378:25cc:9f2c? (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9e5664d165sm459884366b.185.2024.11.03.12.10.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Nov 2024 12:10:55 -0800 (PST)
Message-ID: <429462155eb7634defa25ea2999af85dcd120675.camel@suse.com>
Subject: Re: [PATCH v5 10/23] multipathd: split check_path into two functions
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Sun, 03 Nov 2024 21:10:53 +0100
In-Reply-To: <20241015032835.2693247-11-bmarzins@redhat.com>
References: <20241015032835.2693247-1-bmarzins@redhat.com>
	 <20241015032835.2693247-11-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2024-10-14 at 23:28 -0400, Benjamin Marzinski wrote:
> Split out the code that updates a path's state and sets up the next
> check time into its own function, update_path().
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

