Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D8A1E5B9B
	for <dm-devel@lists.linux.dev>; Wed, 12 Mar 2025 20:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741810224; cv=none; b=tkkYYKKO8B/2vNrmjy5Tp7g1DIkokoBD9rbODdrnbFx+n36Wi5vDnP9kxFP1kiABkJfbgbXs8Lsuug54g2DqVDmUGzQ/wxS65CMAyDFYxF/d+zp2lvVPjFGSEknlFTTqycgxgmW31kb++2zFZ3h/6iu0Q4KZ53wbtr+o0fYY+ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741810224; c=relaxed/simple;
	bh=jjWsRKIE0Q5nEUMfdlYZU0+Sc6c0zuNXs34I97L3aQU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CjRIWORzVOGqIv6UC4ame1ATPqs3GEO5h8XBUEbVyZIRIieIfboWRCcrNUSmjcxl07e7ufuxRuASQDsxNR8Gw+mggtNJZzLMgZWmuPdoxni9iPJsuCLc5Xp6M2kGjm6/S7AWUY2nFBMjY05/vTnQUj0cnMTYUNdleh9vx+7Vu4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=I929ey5X; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="I929ey5X"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-38f2f391864so126045f8f.3
        for <dm-devel@lists.linux.dev>; Wed, 12 Mar 2025 13:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1741810220; x=1742415020; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jjWsRKIE0Q5nEUMfdlYZU0+Sc6c0zuNXs34I97L3aQU=;
        b=I929ey5X7tjw/OYheHdi+FQN8+Jd/DCtaMagni6QmDla+s7sKJzYykyInFodbSXQkr
         E2XvaQ/RrEqqlsKAAkIov5N6+4ciBNfJDT/wtAq9GsxXiOLtYmdJ039nJnjhzmZoWz7q
         vbEhet5aUwsbEkiy6+Qt4f9ZP70KBSZe9PRymqudia8z8h/8ty/9jYHCX5ns6ES86giQ
         eh6rZqsLJ6h8guFttAJhj387mVyp2Pn7BoyQIG3A0dER6iZmVCfCo8paF5wtWO20QEbM
         i7nA1AnErRv0TH2ZjNF+66iAI7nowkk878/3wuctWMUR2aCPPHSJ4HvS2sHnpptJbA2h
         72kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741810220; x=1742415020;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jjWsRKIE0Q5nEUMfdlYZU0+Sc6c0zuNXs34I97L3aQU=;
        b=l908S8/sARMa9QPdHZhDbvr/bcdzdvotAaDKVLL/Ge+RdmHx9x7ZcT1alH/Cx33bhb
         V9zlNFDkCxvJf5PAyhKl/FTnnVmHC5BZ6er21cEhFOP9QDUcURHhV2ViXz/CKrFQfQgl
         FZYRGLgS4pbIWF79f1dHZYvUOhh/0l07egLHXUtmVhQGeKBo6RMWu81gkj4t1JFODF3e
         YcgmrrYoU59DuFSsB0wQjz+bDIBdM0dz82bkSUCmYYnZscq54mWmWJQgOCUqp1y0xR+O
         zd/z4Q0KViNAimds3K5mzPnromjOj/hD5aF3OP5c0YVne3bSIqGux7icKbkN+tOLvgDM
         ACSg==
X-Gm-Message-State: AOJu0Yyjb1vO2vvuQwukOQNgz7oYZPzASezS4w5PW8+xMNK8ktCI1oAW
	/pl62r4DPInGJpPl5aPLITmgtc35XtFqOoiN75KxUZlLZha1F4uPm6G7zw8HulE=
X-Gm-Gg: ASbGncu6foGczUNAlNgFCeJhBlixj4BWNhsf5Zvo5scX/7FKNKtD4NE0M+vbcJrGTx9
	+cMfSe8iCQJ2WKfLbFAnJmV2oP4G8DiAqc6n8ElCFcenr3F8eaWn0s39RfVLrm29rKAwpW24c8j
	wUvr3pOFMxgKrLHIHfsDP9vRhUzSlYIWGmtwh62RLq0Jw562C2u/2tXp/iSD4kzl64w9axb6rZ2
	pYb8qb4zrGOCzH7B7V22PnO0dVcyJMIKO2OqfT0Hmtm4Y0FPh4+9A+PwGwo2LKtWV8CtaX9fqRW
	85U2XF8hIGvf1o7rGAHbjvwf/L4Akgr/r/IRFNxBXyB8vvPDwNxq679SDTrHo21SJNW34zL0R/t
	8VVdgv2+F/8Axs+gBG0HjvLD47NlscQztZCK1JOEjimfqNkUbOaof4HTJ/KYWwJz1ssH/s93Fdz
	ubcM0=
X-Google-Smtp-Source: AGHT+IHc5LHLxYCcuik5nJk4YLIjXCIVdUvhEIOp0dPWBUnEmvKdLLpKahaTx1lbt9r/EWl2SnyNbg==
X-Received: by 2002:a5d:59ae:0:b0:390:f5e3:e833 with SMTP id ffacd0b85a97d-39132d379e9mr17629599f8f.23.1741810219508;
        Wed, 12 Mar 2025 13:10:19 -0700 (PDT)
Received: from ?IPv6:2003:de:3744:d600:a441:a57b:4aaa:2b39? (p200300de3744d600a441a57b4aaa2b39.dip0.t-ipconnect.de. [2003:de:3744:d600:a441:a57b:4aaa:2b39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d0a78f1bbsm30486185e9.31.2025.03.12.13.10.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Mar 2025 13:10:19 -0700 (PDT)
Message-ID: <366bca7ffa6bd77945c713ac37833d273da411a3.camel@suse.com>
Subject: Re: [PATCH 1/2] multipath: clean up find_multipaths documentation
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Wed, 12 Mar 2025 21:10:18 +0100
In-Reply-To: <20250307001034.3141833-1-bmarzins@redhat.com>
References: <20250307001034.3141833-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Thu, 2025-03-06 at 19:10 -0500, Benjamin Marzinski wrote:
> The preferred term is "on" instead of "yes".
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

> ---
> =C2=A0multipath/multipath.conf.5.in | 2 +-
> =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/multipath/multipath.conf.5.in
> b/multipath/multipath.conf.5.in
> index 0c1eff40..bdb6b605 100644
> --- a/multipath/multipath.conf.5.in
> +++ b/multipath/multipath.conf.5.in
> @@ -1214,7 +1214,7 @@ Both multipathd and multipath treat every non-
> blacklisted device as multipath
> =C2=A0device path.
> =C2=A0.TP
> =C2=A0.I smart
> -This differs from \fIfind_multipaths yes\fR only in
> +This differs from \fIfind_multipaths on\fR only in
> =C2=A0the way it treats new devices for which only one path has been
> =C2=A0detected yet. When such a device is first encountered in udev rules=
,
> it is
> =C2=A0treated as a multipath device. multipathd waits whether additional
> paths with

