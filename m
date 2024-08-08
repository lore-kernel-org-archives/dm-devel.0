Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5173D189B92
	for <dm-devel@lists.linux.dev>; Thu,  8 Aug 2024 08:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723107325; cv=none; b=fCyPWL3pIdbO8XMxFZcVNW3ec00NASY2m+a7sFn6AZEyvjdNNTkhb5Wj86szFzXQQbrpw+cOD45fv07e03nqCkmK4kuqoitG9cDeUZO6rZPbGuaZYdmMeR3wLlIKLJoIdtahax8AS0HEsd9lBU16hy81XAYLgGzEjnWXdKEhzPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723107325; c=relaxed/simple;
	bh=BNCYt3tRe1M6th7XJo+mEvTIcvdCn2ArvEgfVCO0HhY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OA4sb9ouoKVF8lPaUxM9H0DuaLKuUYJGVaZKFf7Ak7gkuzvlVvNDmJEjzyUMmXXJe/c9M5difH4MkWKwYtHoi2mSjlWwMSU57SDA3/+rmj5bS5Oq8Jxrgc9cOboM2XnRy9j+vwJaUiwEHOCg8uSreXXQtPgcZ35EOSU9hLbAXmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=I309KzU4; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="I309KzU4"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5ba43b433beso731419a12.1
        for <dm-devel@lists.linux.dev>; Thu, 08 Aug 2024 01:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723107321; x=1723712121; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vEF5aPcVPmEO4SwaR5wpuhcLn9rHYs23mHV2Fi8pmYk=;
        b=I309KzU4k/2h5lDaQh/X2iCNyBtKPxpS+/EymRiFGmLK2YwXbGRrkwQYzhB7yE1NNk
         /MnUmifuB8Q9AG7tgScP7vrOzkKugbF1bZ+nf9kBI1C8/hUG4xPSK6DSWiuiLu6HuEkb
         nl8UTjrVQcXnUkN9VyCb8TCakMyl0eBRPz/Ykj6eMjtGDjapr8jPRVIF08+ISUyUoh9g
         5TtGxBUO90wgNTFLSndmpGAm31UnitC+10VUiOo0WCk4LvbFehdG/lh47qZwiZZClVv8
         dyP0/pTX/TxROKbHNPeUhyQFF7cJIYD2LA7nyjiM7lNYHd2/ximW0okCzw93ZkHO3FTs
         WMDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723107321; x=1723712121;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vEF5aPcVPmEO4SwaR5wpuhcLn9rHYs23mHV2Fi8pmYk=;
        b=fvh1hGHOLSY+nKuEg93eYnA6iFM0wVQxFQN6IOsZmA2S35V4lBGBYV1MhRYq6B0MLV
         ijCl7coXxBHGWxEvgK8SaozOPE9yKbCYqzlz4c69ZbD9y1GO7f6lZ8PTz9El7x1ww4IA
         z45LgXRO2XMW/tEgsdHZQFSMUUqwdk2sbEhmEFOh7oMwffZOZc694IGdR9yPHu6UPuBN
         K1EQ3M61+7qAbx+ZcxVFzc9ZgoANJI2B/PPznui9xDeh5oyARiRW0HCXFx+jV3JG2u2u
         uYVh9JuTKVubSCcc2CRUcrwYOOkLkLsAa5reQE6noJTCgg5Tl8smo/KFfuSSAJMl2cYJ
         v2jg==
X-Gm-Message-State: AOJu0YwLtRbpeknByJ45oJEzlWNSOhWrVmGsYXCZhlU3z+V/FxatEsA/
	gAJqE3xnS+6uHvFcRTpID20XublaYSgZh5FMrGVqzxNGsj8vaTZJ/wTGDoQC4Ys=
X-Google-Smtp-Source: AGHT+IFQtbwdQ1nM+ZJPxBr4vTU1Vcpy2S0gKbhuHgsyFn1Wqqs/cnpZPcUHuxPCr1QtqRD4AohHzg==
X-Received: by 2002:a05:6402:3489:b0:58b:2d93:ad83 with SMTP id 4fb4d7f45d1cf-5bbb2236e62mr957029a12.21.1723107321107;
        Thu, 08 Aug 2024 01:55:21 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5bbb2d34895sm416313a12.62.2024.08.08.01.55.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Aug 2024 01:55:20 -0700 (PDT)
Message-ID: <c57cc983f1e226b284a67a9e801c97602fed0783.camel@suse.com>
Subject: Re: [PATCH v2] libmultipath: fix ontap prioritizer snprintf limits
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Thu, 08 Aug 2024 10:55:19 +0200
In-Reply-To: <20240807225910.3266004-1-bmarzins@redhat.com>
References: <20240807225910.3266004-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2024-08-07 at 18:59 -0400, Benjamin Marzinski wrote:
> The ontap prioritizer functions dump_cdb() and process_sg_error()
> both
> incorrectly set the snprintf() limits larger than the available
> space.
> Instead of multiplying the number of elements to print by the size of
> an
> element to calculate the limit, they multiplied the number of
> elements
> to print by the maximum number of elements that the buffer could
> hold.
>=20
> Fix this by making these functions use strbufs instead.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>=20
> changes in v2:
> Use strbufs as suggested by Martin Wilck.
>=20
> =C2=A0libmultipath/prioritizers/ontap.c | 28 +++++++++++++++-------------
> =C2=A01 file changed, 15 insertions(+), 13 deletions(-)
>=20
> diff --git a/libmultipath/prioritizers/ontap.c
> b/libmultipath/prioritizers/ontap.c
> index 117886ea..b508371d 100644
> --- a/libmultipath/prioritizers/ontap.c
> +++ b/libmultipath/prioritizers/ontap.c
> @@ -23,6 +23,7 @@
> =C2=A0#include "prio.h"
> =C2=A0#include "structs.h"
> =C2=A0#include "unaligned.h"
> +#include "strbuf.h"
> =C2=A0
> =C2=A0#define INQUIRY_CMD	0x12
> =C2=A0#define INQUIRY_CMDLEN	6
> @@ -35,32 +36,33 @@
> =C2=A0static void dump_cdb(unsigned char *cdb, int size)
> =C2=A0{
> =C2=A0	int i;
> -	char buf[10*5+1];
> -	char * p =3D &buf[0];
> +	STRBUF_ON_STACK(buf);
> =C2=A0
> -	condlog(0, "- SCSI CDB: ");
> -	for (i=3D0; i<size; i++) {
> -		p +=3D snprintf(p, 10*(size-i), "0x%02x ", cdb[i]);
> +	for (i =3D 0; i < size; i++) {
> +		if (print_strbuf(&buf, "0x%02x ", cdb[i]) < 0) {
> +			condlog(0, "ontap prio: failed to dump SCSI
> CDB");

If print_strbuf() fails (very probably because it failed to allocate
memory), condlog() is unlikely to succeed, either. I thought we agreed
that trying to spit out error messages in this situation makes little
sense.

Anyway, I guess the condlog call doesn't actually hurt, so:

Reviewed-by: Martin Wilck <mwilck@suse.com>

(If you consent, I'll edit the commit and remove the condlog call).

Regards,
Martin

