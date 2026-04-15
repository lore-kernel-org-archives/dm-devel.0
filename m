Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8161F1A6811
	for <dm-devel@lists.linux.dev>; Wed, 15 Apr 2026 10:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776247298; cv=none; b=Tl/IHgWGMnKYOHmC84P85FPsRc/L/jk5obiGodEiNplWuH4gh8WZgaSdwpPMrloVlWbtMeCxlHVMovYgoAbSIaT1twtr1u0AK4JdwPQiQtZ43M7mbW/3plESB5HWb5tOsR9v/iySbFj9noKRGYQ2etw1hXAeK/uDZHCf5FS/zZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776247298; c=relaxed/simple;
	bh=4FLdKzyNcG0wRe2Ejo89iOr/eZq4Im1//PVyJ7kUXLs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qnVDcedo5eQ78OR+WFeZaasSLPERsFtZuXfNmm7n6i0Kv66XrIAMPBk17rGX9t4+a+ieWdZ2JyL1hWxoSsoRD64uVCDaf1KOqg5NGxmmTb9lmSM/68+NL3JMeYXtSyq5gX7ogcZSAxW4q8WWdDQCcRRu2Pxdql4GqoRn67pbo6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LkV3mEo7; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LkV3mEo7"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-482f454be5bso69307235e9.0
        for <dm-devel@lists.linux.dev>; Wed, 15 Apr 2026 03:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776247295; x=1776852095; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4FLdKzyNcG0wRe2Ejo89iOr/eZq4Im1//PVyJ7kUXLs=;
        b=LkV3mEo7/3LkfCyzwocIMpkryofzo+kT4eDjBtnhKrg4FdvqRHq4Io9I20TFVxC/Ig
         kfRGfXOnVQLg0NfoksmPmQchPCoifPOeVE4GuPDxbA3p/HPHNFg++t/PgS3Eo/OtOPbS
         2G9SBCoa7Pr/P8sq7KEmUmQsuL0hoSYbp6PhCosHOB7g3s2zGugGKdtXufxo7oTpfsT+
         kL61VaJB9RfCT6uSCoDAWgd9OdJSmlj3mPXiOf4kidVJXWfn3NRp56JZX+cLHyO6CvjI
         +6R9ZSTejkkhRUuqo5+ZXGCUxcYUufPkV3RnztkVvvVIrPPilTpyVzM/+f2IM+LcF1TX
         7Sbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776247295; x=1776852095;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4FLdKzyNcG0wRe2Ejo89iOr/eZq4Im1//PVyJ7kUXLs=;
        b=gqzV27rfbxstJvQ7WZM64BS0TtsJPeuCR+72gzpynUFqJF4dGHAlkSuEr7IR0e2tga
         XsdWq7DePKi6TGBzrSWWga/1DDCc7Z+CiRcz9qhTLBrgD8CoUq2HmcTlYTlHh7s33gap
         JSFA3BGqmHYYmkqcfrLVgAWLJ/LZknh1r0f4+Bf2ZCIUqt2rOLR3S84Xg2Zi0EQB6Pt7
         7jTe8QDV0TPTBfhjAtaDcVlKWdroPo4C9dHgD4dVgCe3QKViGw/2XI3yumSMPa7bisdT
         XiuDxE1AIhmbGx8rghXq63DbYOPOKlyA97E7MJB5BsPLNk/y+0xIs7OLvH2u4W9NHvzS
         djnQ==
X-Gm-Message-State: AOJu0YwnL3ksA6MRKWosXv7DwjGKO84q8vrpmM6FjltCc3SXSO6PajQb
	vUBQPATzJnxvIa68hwsToponFuyyFk0YrKWPrf8vCwBRFCYxCOSi+7gVYm24GxkXDkI=
X-Gm-Gg: AeBDieupHlfQdmD1omR4SW5KRYndIe1cjHtU56eCAxnrHgP5u3AGRtt7M8JWhywTskU
	/9PaK8Ec5Skse0yQBDvHCEO4nhy++CCif40dw/kNpvXtUwvTbAkHg6ai+nikaN95nwBFo3WNT+i
	1g6A24OuogS5ZiBVTfSG+P6DfFkFCrM4sfx075CdM/WppAO2YVdIGiZY4A3jvskskSwfZJLwUVZ
	xIOPFAaV2FDOcx/xNrbIG6VgYIeCtAs+5W0VzjmFt1ugf3lO/m4ugB3zbH02MKPhHvmEiZ5ZfJG
	JYErGwWyee+CS/kKJJK5ytd4eFYElcIVkTGSXuxKAxe0Pphsfr2mI+XU/Jn1ti73hzjVrFO6g+t
	wyVxbIdFi/fNEMY7tk4KByV1iOwrMuUF/52GGoR8bvrsN7pw4JdjaHP0vUSg1IwvgdDhkcseMWJ
	ePu6MkKYh2tI6va0AhB4MWLVsDWO2x/YXpZ7DWbgp0qUHAqhBi1NxVKDDHJD+fS4+kkCUJvSWz9
	zl65x7VF/4Uw/6GhbO4WhixIhMPApnOrfelv+wDL2p8Xia/F8rcmaV8ZBpqP7yRxeBrMw==
X-Received: by 2002:a05:600c:4d8a:b0:488:c21a:4754 with SMTP id 5b1f17b1804b1-488cd6aa93emr225700555e9.18.1776247294467;
        Wed, 15 Apr 2026 03:01:34 -0700 (PDT)
Received: from ?IPv6:2003:de:374a:600:5c73:df0a:ad60:5173? (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43ead3dfff3sm3424285f8f.26.2026.04.15.03.01.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 03:01:33 -0700 (PDT)
Message-ID: <e93679dac9405a24454606d3654f62ac79732fcb.camel@suse.com>
Subject: Re: [PATCH v2] libmultipath: Handle SCSI-2 style vpd page 0x83
 descriptors
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Wed, 15 Apr 2026 12:01:33 +0200
In-Reply-To: <20260413223835.1914294-1-bmarzins@redhat.com>
References: <20260413223835.1914294-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.0 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2026-04-13 at 18:38 -0400, Benjamin Marzinski wrote:
> Some older SCSI devices return a SCSI-2 style vpd page 0x83, instead
> of
> a SPC-2/3 format one. The SCSI-2 page 83 format returns an IEEE WWN
> in
> binary encoded hexi-decimal in the 16 bytes following the initial
> 4-byte page 83 reply header.
>=20
> Check the 7th byte of the vpd page 83 buffer to determine whether
> this
> is a SCSI-2 or SPC-2/3 confomant one. Byte 7 is the 3rd byte of first
> Identification descriptor in a SPC-2/3 confromant vpd page 83. This
> is a
> reserved field, and is guaranteed to be 0. If it is not zero, then it
> is
> likely the 3rd byte of a SCSI-2 Identifier (The first 3 bytes of the
> ID
> are the Organizationally Unique Identifier). Both the sg_inq and
> scsi_id
> commands handle vpd page 83 this way. To make sure that the WWID
> which
> multipath reads directly from the device matches, it should handle
> this
> format as well.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

