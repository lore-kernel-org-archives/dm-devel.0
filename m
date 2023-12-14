Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAEBB5EE86
	for <dm-devel@lists.linux.dev>; Thu, 14 Dec 2023 16:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Yw/of51f"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-40c60dfa5bfso11352025e9.0
        for <dm-devel@lists.linux.dev>; Thu, 14 Dec 2023 08:21:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1702570918; x=1703175718; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7d2zVhbFPt78BW1tI02E0KGpxRCa4QZqOk/AVjM5Cl4=;
        b=Yw/of51fyaR7EzggFNnl2yx/oUts51TztgNkBn48omS93ON1noJL8FmfEgb5WtVKCu
         WlJ5PDC52YpdR7dDUifpszJhenDKfgJXrWhzSKSJdNWGbkjh7M/cVEanUSeFaMSvXtor
         4OAdEYS1lEoei6mbVuE8jmEqaKgFhIWK5upS3fJ7PpE2a+C8uMO+f1IXpiUjSX5CNonu
         1qJHKs5NQUC74tOl9xooYhY+tphOpQmDL3pqtQKOTZSamE7P1eJMajpsRZLuRDV1hxB+
         42ArLeJw0Q0AOOvnYipjAAEp9FT1iOZVWpZ1hJEK0jxT0jnyFG4FypvcsE0+23hwrnen
         iaAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702570918; x=1703175718;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7d2zVhbFPt78BW1tI02E0KGpxRCa4QZqOk/AVjM5Cl4=;
        b=Eo9QiBc8pDiyM2QOK7vOg7+9Q8Z0tTiIdNwYMSPnkL4ZamtFMErBfLQ4GtsKTDA2PE
         6GQLxGOAqufnTvLfKyxdpUkG/9AfhPWWerz6DhA57hjGRUrYFLF0afpZDtlyfIdKIqfU
         gJKHIKGt39pbaS7/01ABUDooeb1Zf313deXmFlaTYpnpKQ/hhFePxskkCmVAtcNJ3R1v
         0oS5OrmjJ1ge44Veynm84d/YOn09ZBONXbLTf88s9vU8jDZUTdBaRO/92tOALkm9mw5f
         NVcJtJ8hnu8f2GZJiWFhTkE7viUL+Xm8T72y6w2B8YrimMgzzOimQ4q3dJ5k3KVGYA2x
         Wb2A==
X-Gm-Message-State: AOJu0YzCsBw9BxJf3YeSGuJCfEO09nSEtyBhLhwFIxjAkfOobAO/qFtw
	uNvwAGLaEI9g4KUCIcOVE+aXnw==
X-Google-Smtp-Source: AGHT+IG17BxQB+nlf/kzSoVnazrDvySKUwCIsN0NF15r3FOHUDwry2q/q6SKGTQvu+84FTMO2d3ILw==
X-Received: by 2002:a05:600c:4f8d:b0:40c:55c4:45f5 with SMTP id n13-20020a05600c4f8d00b0040c55c445f5mr2347834wmq.132.1702570918157;
        Thu, 14 Dec 2023 08:21:58 -0800 (PST)
Received: from apollon.wilcks.net (dslb-090-186-000-097.090.186.pools.vodafone-ip.de. [90.186.0.97])
        by smtp.gmail.com with ESMTPSA id z20-20020a05600c0a1400b004064e3b94afsm27955081wmp.4.2023.12.14.08.21.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Dec 2023 08:21:57 -0800 (PST)
Message-ID: <f3da4bff62bb1764ff9d36066b6790ae680a7e7b.camel@suse.com>
Subject: Re: [PATCH 01/16] multipathd: remove nopath flushing code from
 flush_map()
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Thu, 14 Dec 2023 17:21:56 +0100
In-Reply-To: <20231212235320.440336-2-bmarzins@redhat.com>
References: <20231212235320.440336-1-bmarzins@redhat.com>
	 <20231212235320.440336-2-bmarzins@redhat.com>
Autocrypt: addr=martin.wilck@suse.com; prefer-encrypt=mutual; keydata=mQINBF3mxsYBEACmOnQxWBCxCkTb3D4N8VAT8yNtIBZrmvomY7RLddBIT1yh2X7roOoJQ5KlmyjMmzrPr111poqmw8v4dUqc1SVqQoKHXv97BzlVIEKC5G2W29gse0oXhx3dhie0Z6ytkHVOY29VLsLhVXEz+p5xL71KYgIy3lmM/NaWvoqwwaXiv1TmLG96Uoitvj1vdXqqTv/R6/MBye+xQUacXpM8FA5k7OpmzCFjl4NVtGmo0VhIfXM/ldmyEJpg8a5LrZ4t5Qi32BWQjUHGmS8OXjUJ/n0QxLkymbcbY1KepP9UnLGPT+TmKJm1QlMDj69+WPKgMsif3iz4hZPoQ0Knp11ThYzBh7+AiRxE9FG2hTtZeKimkpjR12bytF4Y0aIM/HeLMHRvwykJuh5JxT9A68xF7hmqQZ7rsx/GoRBOA792kFgr5KdCZ1YoeVUkrohT1nfh/Y/Xfeq4E69mktE0R0Yxg/4CSiB7sLSzry8dyqk2sbGs+W/Ol7D7VOG45aZ5iTB08R2ji2xKArcH+Dmy48nwqIvdrppZG2tZEe+wtGPTzahE4OJdpZ3vS4ujdChynS47DVWa5JtBxfqopr0rPGoCyxmyvzJzHAUjlp7iSXpDZqfdu7F4HAC13mS41IVk/yHTXE28AKrZ4O+efZ6qgw5zJV9lAbWM7JjfdrTd+ofOc+GurQARAQABtCRNYXJ0aW4gV2lsY2sgPG1hcnRpbi53aWxja0BzdXNlLmNvbT6JAlEEEwEIADsCGwEFCwkIBwIGFQoJCAsCBBYCAwECHgECF4AWIQR1Dq1LLt6xpUXU9fRnxYbmhVaXVAUCXebHhgIZAQAKCRBnxYbmhVaXVJ6+EACa5mbuH1dy2bKldy+bybUe4jFpJxflAPSrdpIlwkIfD/SgQRWUUm+BLLJMGJFS
 KiVC6oAHH6/mo3gdWAqBJ0LAOQDDR2BW31ERYqQQ7m01INQIvMlg+PXQ8HbWd CNF1SOgjxiIs04DlB+u+DD5pgPtxKFN/jaJSx9oZ+GZpSd+eJeull3a+U/1+QpYmLbH34bxYZ16+cXfarkH3QQC65DH/iIZwcpxp+v/zrQVXnsZ81XmmbLD1vMkFCIU0ircIcaJoqloNJOA46P4mj9ETwC5OiSTs7vlyHP4Ni/86kmjmr41d/baY1cAXpAbtOGYd5K72B6qSP5EJI+Ci6rSbWInQaYzKuAOrDDyhW7ODd+hOtBcmUIH5GpKvzRjdfxEP/zlyecBszxycz7lOYNx86QWsyyRWITKzHzhdqKVZ9kvjVozTtcpb1RSqsj43qqMEQjcp1uXhbmwVmbzsWaPqmCx4xsIQoXfIzzffvw+nOiPLkxzGczprwNJasDUM1hcyEPv+5VzZpE4YjlDw/mtTayehb2EGzt2RfZIuPCBr88KlWUh2+nu9RfBJNdJ2vZ13Aun8NbqPKR2vfsE+BUJY14Ak9ZIzcyruHBHQ78dxD0J+HSC1bm9e4UOnW0PBbZwuPTRwyO3aXoExPabGgig6gcY34bsXvW9SDwOu+pzXMnVvbQeTWFydGluIFdpbGNrIDxtd2lsY2tAc3VzZS5jb20+iQJOBBMBCAA4FiEEdQ6tSy7esaVF1PX0Z8WG5oVWl1QFAl3mxz0CGwEFCwkIBwIGFQoJCAsCBBYCAwECHgECF4AACgkQZ8WG5oVWl1TdsA/6A0DZmGwreygUic5csLSLUm2ahdat3rRKfQVdlOdl0aWa/vS90PqpuDNGzXVzS/s4YXRjWesnYEdwQGSc4PnBYCitLKUwenII39RCyZLU3J95luWG2eOagFaerK+HvuNEH6RpYkqPpaDEwpblfi30xNNYLIR4HK0GTYwhbmBTrYgaKATNiplU08ZUvC23s00t2i7SBGmOue/0dIPMhO3EDYPP0RaDnKvH
 AOAywkI1J9Ey0xEslG9AFylOihcdaq9/7MlMWU8oNHK7EVE5OOZ2NiJv1sWSgM 6dvGdfgLeNmsiyHGDtfXYFw32e59ShkxUDc/uLLseISAftDYdPzKXxdkxRfjLkLk24HMP+uEauH0ytdC7P4NJmDHKlKH9da7lA1x94XEsn+ZMiqFvXh4ce2SgqnH7FjctNPamek+3tJIBBoFkMeABDeXnMlmLtTU21qC6lEXMLAmcyIR+eBdivTZyhf7NOE100JQYGdYTKUDITUSXdJ33cgwll4a2kUZK1nA7DGNwDYOoWF4i1cZKRBfMaD/1Pm/Los9ga/B+kfI+fQTam+gdD/crwpsr5wiXcGgggR+FwBsux3/hcoXVbBhCQKeoEE/4ajmAxsNWGZgMvRv6JLJNZ/rBfges5LjvHJY9tOcjlniJAArIfR/LrRRrQhf1zHH/fpql7lIPvBM20HU1hcnRpbiBXaWxjayA8bXdpbGNrQHN1c2UuZGU+iQJOBBMBCAA4FiEEdQ6tSy7esaVF1PX0Z8WG5oVWl1QFAl3mx2UCGwEFCwkIBwIGFQoJCAsCBBYCAwECHgECF4AACgkQZ8WG5oVWl1QWFBAAipbqrpAO+TYm8U8Nz0GpM/Q+nOya2JS2eF8UbkpZcmhC9pObpLd4PsEl6QbmDvbiVhurv5Cp7TVPhl1ap5ir7TFHvErzs4Rxwohof4MSY5SRSbYAaz4e6bMw7GGIOQhtKOXi+zzSqLrCIdTKxfNy3MYZ+Z4xBCGyE2bNExjxpDBjYrjm6ehfo8+TVabBRX+2sJsLugZszQF0tnV4Y8oAA2iePTiwSe9hz45OKEhDyNpfJ1Kg2hUropKEOS7Q+jP6Bw8M3RomQnk37GnU0Wi8wSNiyWYRhossI72Se/w1uRsQuVCT0qSsa9raLekya2rf0bPFmCBPRUP+KUrBq5yY0c6BdY45incUqhLlQo06lf38e6+CyouN0HpQ62CxQQTMxM87
 FRTg6uRUitWtnDLoVY/d9wgzvxBJHW4hIKuv5JNeh7PyFO7vB55DekaoRLKU3MC FWjq3LA0t2FLEVXdF/NcVw1Qn6kIIfbgPYVdBMO1b3ciu+NY6ba8lzqiIIH+Js/+JnAwzLQNLp360Kza7/P7bgd0NxBCbLziay7MVZawRQhCUkUWcqeonGBuSyf0wO3sFlRZm+pv1sg6I6DZCrykSFyABkH7joZg5nUuNuT3/E2Jw9gBqll6OrsgTDzWzofTASYtQIRjqLypeqiz4ADmHy9tyEt1SxVd2C4o1JmY=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Tue, 2023-12-12 at 18:53 -0500, Benjamin Marzinski wrote:
> Instead of flush_map() handling both user requested flushes and
> automatic flushes when the last path has been deleted, make
> flush_map_nopaths() handle the automatic flushes itself, since a
> later
> patch will change the behavior of flush_map().
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>


