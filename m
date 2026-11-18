Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041309;
	b=Tc3n+wkjePBJKoFID0sP7fIhCc+qDqbXbtY0b6jUiZ9KOOerTZntp2pV7D3tslNP06Hd
	 F+5e7QXRP1+LFfWX9C/rK1VXS/TqHoBr3ykYD/kPopoNwmnY75Pfhbr3MdJtGDjuWDrl/
	 Bo1MZ+Otgna1viTj4VKQfDQdRW9OvjE7fSH4TC5UYG+Jf1XW6QvUH051+PTsT+y7lX5hO
	 i08MrkAiH5qItaYxlfZfnaiak8768Rfh+Bp+8mpEPW51nManCjVUn+LTWHDrDAUckVbKY
	 Tp6FXWx7PCuATxW2ErCl3CojDcNxI373NC8d9FYIuha9HLOWJroDs9CBJLau88ydt1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041309;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Up7v7Cv7cOXcZcQhblA3mDO0YbIQN9mCvrqNMQVdMP0=;
	b=quGDTFliwLbADmjVcV6QfLYDhd+IobHkxAhWeJeZrZtdD6V9Azm7vIE7OTlBVqD8Pf8D
	 MQP/BjPOvjbQCQU4sKgCWAZEIV7yikpUliYC+prF/e2S9Ql7vVD4SZw3nlF32G8L6WwYw
	 k0zIeF0CdU0tse4LO75gvUi3Kr4FB79AyR06jtn1ZEN2r1lfKdVdYCoQdu5AqYfU0faJ2
	 BsE2XeEZxxu7nJigziIYgg6rao2nXcz/8HB/Hn6Q6/6NGjiQOrPuwBel+ThaCS/m/dYkS
	 AzKlFh5Tpk3jy1kxQSj8fPFy0X0rup3J3Q8GrvncEjB4YilRSQROMoDpF8F7Xbs40jQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=CT5rGIVz;
	arc=none smtp.remote-ip=74.125.82.171
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A139606A320
	for <dm-devel@lists.linux.dev>; Wed, 18 Nov 2026 22:35:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5A139606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=CT5rGIVz
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-382c3c9671fso1920721eec.0
        for <dm-devel@lists.linux.dev>; Wed, 18 Nov 2026 14:35:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1795041307; x=1795646107; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Up7v7Cv7cOXcZcQhblA3mDO0YbIQN9mCvrqNMQVdMP0=;
        b=CT5rGIVzhU8WOPUi1jN0mPkIrOjHlzKln1H8jmnNVIefAADzOqFQenyOSOKalk4Ujs
         gB9XIWTmKT7i+p0+lSMaejWARJiyP7ZpPFsHh5sP8AI+IaBYnMuaFpFEP6qwFUosMXzb
         jgu6uxE0xuzhawN0zKGByuXeHTlT+0FGhJRR3Fbm/8DYuXh1lxj3kJXV/og0XWuzHUZh
         vqnNM44UADnBPKd5ILa01SGnL6t8Dmdlt04P72UvKMLeUukEe/0pPx7rbiSCzIb+C3aL
         CCC1d86N0MY33zHGiBq/OPVKaV/Ekb3Trs0JWCIL0aGAKsVJHDC97P63KnW6oEv9TyGd
         sEtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795041307; x=1795646107;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Up7v7Cv7cOXcZcQhblA3mDO0YbIQN9mCvrqNMQVdMP0=;
        b=bd2v8Np4KqeoC+JGc3XY+zBvgjiqVhF3hU1cZ+RZTcAxZMUEE1c5t/rE4z67cRv3t/
         KpTF0MlXlmVDAq3zovWZM9EHgEAjOnxOkanRx8opaLgUkDBef9/b8VNDf//st9rAy8We
         0cGpSBCDAg4MLeNtgRip8iot0L6Hi+G4VJuCskea9rUW6gpKey2Pw4b6aMuRWERkoBBt
         FokKcqbOm/3ua7LV/NpJt+1cdS2bbPpR0XlfotGQ4qZMERmabZbuVR8gEAp+tzQ+hr5a
         CdIg+gpSbzFhBK4KeNDyDGFG+eJkiRsHa6IzDYJONHWhzalulAdo6hkyn/Igs7q7WtPM
         UzjQ==
X-Forwarded-Encrypted: i=1; AL+hErHp5dHnXtvpRltTl6N6uYHvK9rQFYg33wE2jOdEGOiHfHcbvyeJlbaQRaadtJmaIBcFNTA9dzxefQ==@lists.linux.dev
X-Gm-Message-State: APuU4Z817QjB4eXu30OvMBJbqggvDUny9Fli4B4jvwc8NNHKpyVpPgyO
	PjI0RzzlhgjZAdNnfTSzuG46H+iC7FJravQnNp3AUEzhRLqXnos+yD74XmMI9tTBJQg=
X-Gm-Gg: AZFdTZd05Y1VxJmFoajbH74iwlIGc0QSN2FKAoXf4yzJDvMCI7G4se/86evG+cTMYz9
	NYcl8zWaYaG3HOlCapLIBEDqOw8KBK/VOS/5nfXSkHdhYaKETSXXT6oLY5PP0S9ZarGpM2DyL5Q
	W5Uht4G5PNJnNsX+21OX+G50PZ2k2ZdxJ8dfkxHJcFdT18zldvSklKWEdNyRo83roxeKmcDDTKD
	yKP5mIdoTwp8sVLayIfdBItpY1hvQvwNBIELBgP7YuVw9oxyarhNVHhaKjdpDzpy+jJwBwNmLuR
	wBiOEBEqlxOmAxPC9SwhDL2MSeA6J45msmcN5RQ2ro4rK7tJ7UF2wZqACp1j4jlzygn32MlEGbS
	Puq78+VMm/dIpIJradl+JarTIC3/hI7FOdtH14qn1w1chLVY00hVDrum+NMNr3lRWMWOL6JBlla
	PWzJ7EKExSwLR8MFeSFZwj7ajCNAXYBkeXVyL/195dFCczYvTOQlNX2wRo4YPygzPUopCdpZc0P
	AZewh2fgo3xMsSMfWIuwbWG1WUp+/JEZWQDcAydKZa5ckGq8I8IZgynwAwdIBpkqFuuw1qo1FiC
	qnFDgJGXjULmPXlUQXuS6oe8dB9xNCpGbrdf2gLDcvRIrIDzrWCprALUmAVhtCytib4tLOim6IS
	K+8kRBLVnyKy19521wZORLeL9cz4KkAmYsQRvwuwnOOvM6Z6TAuNNlowOvbR1XmNo+xTC6A3noG
	ykwZkO825cpGN9qzpApKNXeuKu
X-Received: by 2002:a05:693c:88d3:20b0:37e:9a3b:76a3 with SMTP id 5a478bee46e88-3827fa88224mr3648654eec.11.1795041307021;
        Wed, 18 Nov 2026 14:35:07 -0800 (PST)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.93])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-382a172a0a8sm9405866eec.0.2026.11.18.14.35.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 18 Nov 2026 14:35:06 -0800 (PST)
From: Brian Bunker <brian@purestorage.com>
To: Benjamin Marzinski <bmarzins@redhat.com>,
	Martin Wilck <mwilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH v4 1/1] multipathd: recheck WWIDs of re-added paths with the device
Date: Wed, 18 Nov 2026 14:34:49 -0800
Message-ID: <20261118223449.85519-1-brian@purestorage.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <1a6a0493ef4f510a047647db2385cf89f7424b68.camel@suse.com>
References: <20261111181642.51912-1-brian@purestorage.com> <20261111181642.51912-2-brian@purestorage.com> <179452227264.147392.9708937185980533136.b4-review@b4> <avdQNjzddtu7o18n@redhat.com> <9259d20188a042cb280bad95f8be9783d1b9c1fd.camel@suse.com> <avtdexYN1B3pJLmL@redhat.com> <1a6a0493ef4f510a047647db2385cf89f7424b68.camel@suse.com>
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

Martin, Ben,

Thanks, both. Two points before I do a v5.

On Mon, 2026-11-16, Benjamin Marzinski wrote:
> If this code was only run when we got a wwid before and then it
> changed, then requiring a matching WWID from the device seems much
> more reasonable.

Agreed, and that changes my earlier position. With PATH_ADD_REINIT
passed only from the changed-WWID branch, the check only runs when the
path already had a WWID and udev now reports a different one. In that
case, if the device doesn't confirm the new WWID, including when SG_IO
fails, I'd keep the path out and let the checker retrigger, as for a
mismatch.

check_path_wwid_change() returns false both for a match and for an SG_IO
failure, so v5 would need to tell those apart.

> we never reset pp->retriggers once we have a reasonable WWID

On Mon, 2026-11-16, Martin Wilck wrote:
> I don't see an issue with resetting retrigger_tries once the issues
> with path's WWID are sorted out, in both cases.

I'm fine with resetting pp->retriggers once a path has a confirmed WWID,
so that "no WWID from udev" and "WWID didn't match" don't share one
budget for the life of the path. Would you rather have that in this
patch or as a separate one? I lean towards a separate patch, since it
also changes the existing missing-udev handling.

If you're both fine with this, I'll send v5.

Brian
