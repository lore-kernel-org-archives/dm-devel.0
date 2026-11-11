Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794390480;
	b=cU0ebuA4GH8ULVRBJgp4W47TpPTWkUQX/WTMwH6KI+549Wx/AIQ556X7la8qPr+TqyJ3
	 1UfM2Ipx6hf42XfXi8mKAMsFvKTWowXh08nDyTA7irWWNxiJz6hu3lf7RkiaFumGO20s/
	 A6Lr2QbLLv41YBOetfeu+HU9A/3YWGTp+fS9T2TpqSDCJDHZ8U3nJec8cpnkm8ne+/A44
	 fc4d2w0zWY0S6dXekX1KCOLi/4A5jY18NFVlarAumDA0IkB3NLjcsAWUswZb2JE3+SlaZ
	 kpXqcfgcJv3EDPdujjLIgCZLkGH//dpsnFCRhDQ52fH3kLgunSW0CPMfB1KiFy6/5ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794390480;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Xr+9Ecbsm+vbaizQH7M3bFs5ABTxIw+BtfIU+UNFjy4=;
	b=EWfeKWfQogu1Dw7loUDQMKnhkd8JbOZBZZDAiESLy1xEgxNuQD/4oYuUz9mHF1e+ksbb
	 YAQ8GDIQLeUKK4eN8uREH9kXJYmnbCDJ/ZoX0wTRkGarb795nFZx98Wlp+g8+GViFHRDV
	 HC81o1Dc/onb/NbvOVPgWirEAw5ja8W5HR1mYmTZ0k6hoTLkEhHWBxE8zbwGfWfMQeNdI
	 A9lAd4JG3Sv1vaRPIDkdhDAIiG6czIUFQqqeuHaN3o4VeJxVt2N4eyKVZScoFViFESeGL
	 NWUGLxDQMdQcjwBZ+jcf1oOfaCWKdieNOjndvih+kd9ex/1W2xmdMEBvT0uvekzK+Fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="tyk+0Er/";
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18EE2606A31C
	for <dm-devel@lists.linux.dev>; Wed, 11 Nov 2026 09:47:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 18EE2606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tyk+0Er/
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4b79502c27aso30006965e9.1
        for <dm-devel@lists.linux.dev>; Wed, 11 Nov 2026 01:47:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794390478; x=1794995278; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Xr+9Ecbsm+vbaizQH7M3bFs5ABTxIw+BtfIU+UNFjy4=;
        b=tyk+0Er/+vXd1Xo0qzPO9iT5wSVXV1qMr80roiP4HpADMsKQuFzrfImrjUZ9+gDtZx
         AYtFEOWiEwFhyz2BJtRpzpsyAQSlUbw/KtnSDph08iR6ggMlBz4dPNPt+iZhNaRASJCq
         aGUzZSuk9oRKZ4X4zdvKlv4J40XlI2Fp+nQbuP+Pd2h2hYVGUgjVm3HGxMviMgrm9ZTH
         2x68X/HfG84ecIURBG4AvNdjES/Ainwe+71XvAtIlmroyKBSVXaONmE5fZWyfB7khMJQ
         b97MYriX8m5iId7LnBTfTFVhoNeaStKVVqGzt1u+m+y8/K8tO3Fdt4HadXqylP9FtgtB
         K09Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794390478; x=1794995278;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Xr+9Ecbsm+vbaizQH7M3bFs5ABTxIw+BtfIU+UNFjy4=;
        b=Ravvfz/JIcYjryIiQzKv2bz8glJHlbEM8hrEurN85pvLA5f5MHy1fXvki0ZbYFiJAi
         9tDl9X3CqT3f4XUdeDVYVH3OoFulz9Pm+jmuaVRi8CSjN1iYuWmpsgkXACNAe4cuIqla
         qzx0O5PRSFyoJv1P+5wfWrNu/YnWxAXstnWrw4KuGBNrswGK9vWbe12PpRQFbdaJM6kX
         qvGTNZzLxiBMQfrhU+jlCz2UYTWAjZ+bBV8u+d2zhUvbcCFvPbRksbfA45Lbn0LdNInf
         YXRtBTw9BHN8jyQAyE5kPVbcLpf/BGvsjEo2CRv6HS8ksPm0LAVgoocuoDvkMW2yWsVt
         BPtg==
X-Forwarded-Encrypted: i=1; AL+hErEdZIR2WQJOlZXuc2Uac70wUeQ4FAjOvTq9eDVx9y9zvl8JbqYY5G6lBUgdLBmBP4EZ7VBguGxb+Q==@lists.linux.dev
X-Gm-Message-State: APuU4Z9t4PcfjYHtRH63sRB+A/guiQgAnhyi2dZP1DKEESMAvhb+BHam
	caZy7W/0drvNrnWGo1IOJH9duAGrrTG+E9fcoxVNlvXwdBbL2wVjZS4u
X-Gm-Gg: AYBFou1faH/qbAFXXWrzBYWDRPOQ0u96AZxLmNZ7yH2jQRnTZn05LqpIqpGC2QD8eAB
	b0//PkYapqAcmRixKkGVHeUDVU5/jhUX41PHjPjjmQOu0vCl4TMyqbgpM+krRzeb8wh3LmzLuXI
	RmU3Kt5vutcVq12WfyF2QmIDpxJZSsncuq7vIqwWJa6Ea4kD+5F+iElQ+L8osc0teSstLb3USDr
	kS2IrQFXCty5rCsMRLdHvWD5+ZdmuofWQ49pMrEzeSD/xo/RQnQwYF/GfJSG9GT8DkBsReWj22U
	xpN9Y9tgZ9ZdHrTEb0fZLrdKjWww05ThRu9oDvOvPxBsYsbmkL40023i9AjK56hg5VSf9fd6ECo
	uB0H237J/Y8259Z7TrOJHHf5ZhCwyfCZ3fX2XAqOe3IU5A6OQd0nSS8KwUwAuAW4eDHR0Pf+Lu1
	DwzvsSYBW3a6IYFNjlQdKpuum1gNnqqkpOww8jNfVhAmybHfupLGTuFkCI4yBjMBfaIu4rhowYG
	sIh5GeAuMqzji78FNSCbh7dLXByY+ifqBBgZ7NznxUTALig/65U150GkSQNGf9ftUZ7T8AdjKeQ
	3KqJznAOE2FZR5EJwk7D+DMBVJBi0ok49Utb1Jqxo0p7Jh8feulRKG77Qjw20klwvOnju7WB483
	hzP0rk7pLAcWhhy1Oao+4Zhrxfuj7Z9dUO91IW6Fgr2RdrK6YoVNzllSWIGba1/Idnk/KLgjft5
	2o+qZss9K5aarnqEMG08RFAnKCNX9SMdkawLdTbxJdza3Bz8mcfuNGeA==
X-Received: by 2002:a05:600c:6308:b0:4a7:b304:253e with SMTP id 5b1f17b1804b1-4ba09381867mr34638075e9.22.1794390478233;
        Wed, 11 Nov 2026 01:47:58 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a00-1028-8388-a84e-a1a4-8dbf-7ab8-e5ac.ipv6.o2.cz. [2a00:1028:8388:a84e:a1a4:8dbf:7ab8:e5ac])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ba01fea9eesm203884135e9.11.2026.11.11.01.47.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 11 Nov 2026 01:47:57 -0800 (PST)
From: Josef Schlehofer <pepe.schlehofer@gmail.com>
To: Ignat Korchagin <ignat@linux.win>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH] dm-crypt: defer async write submission to write thread
Date: Wed, 11 Nov 2026 10:47:56 +0100
Message-ID: <20261111094756.20997-1-pepe.schlehofer@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <CAOs+rJWmmUbYqU34Yb4qJvJsZ92=AztNwNsqX+xD8WaH8tVz-w@mail.gmail.com>
References: <20261105072708.30722-1-pepe.schlehofer@gmail.com> <CAOs+rJWmmUbYqU34Yb4qJvJsZ92=AztNwNsqX+xD8WaH8tVz-w@mail.gmail.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, Nov 9, 2026 at 8:51 PM Ignat Korchagin <ignat@linux.win> wrote:
> At the very least I think it may be an unexpected/undesirable setup
> for the user: they enable "no_write_workqueue" expecting a fully
> inline setup, but still get io offloaded. Perhaps in such cases we can
> do a pr_warn_once() to let the user know their setup is impossible?

Now that Damien has confirmed async is fine for zoned devices, I would
like to add this warning as a follow-up patch on top of dm-7.4.

Would a pr_warn_once() in kcryptd_crypt_write_io_submit() be acceptable,
printed when an async completion is sent to the write thread despite
no_write_workqueue? The other option is a warning at table load when
no_write_workqueue is set and the cipher is async. Zoned devices would
not get the warning in either case.

Mikulas, which one would you prefer?

Thanks,
Josef
