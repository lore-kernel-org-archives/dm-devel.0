Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60B43A1B2
	for <dm-devel@lists.linux.dev>; Mon, 18 Dec 2023 14:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="C3PoOahg"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-33621d443a7so3122650f8f.3
        for <dm-devel@lists.linux.dev>; Mon, 18 Dec 2023 06:12:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1702908735; x=1703513535; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=O8gCmlzcbD2/4q103gCFplALosI8n4K9e6oXP73DhIk=;
        b=C3PoOahgMbVdlpoFMdZ1zdnhjmw0z/GuVEgetF2Es/JwabBBFgVXnan0t+trcdKAoR
         7YjukoFo2kJfe72Urd8mF21fqbCbrtzUGTT/O0ZBjuRieAkZ7PoZbuNEEEK5z6m6xHl9
         mMn+WIhfCYqSkEqLWkUsMxPzvGagYDdYrnjRzRkieC3KHNpm4oAjCpOHyLgipdXiK0c1
         mjzME7YGAFSajxSUCrHhHSIn6CzsnyPcXRTvJ9/ZJFcHh1n4fLVvbDBmcaR6e/syS5ej
         4AsyoJ2l9SVdtpC0AceRACjJu8FTrpJHSraclmntI+lyWQHEwl26olgG8O5aGFdteAHU
         Dwew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702908735; x=1703513535;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O8gCmlzcbD2/4q103gCFplALosI8n4K9e6oXP73DhIk=;
        b=tiom62A+fn1rLg8fOtasTG+5+HzMQPT+DVxSyw7LbGrK/+83oTLmOwpBMh78ieLa78
         HMz8CWcx21oJe+JZ1Iw4OJirP3wr3o5kzqW7AHxggHXL3nxT+ZKXF72wiTxUfGQTwowJ
         jOeqiNnTt9F2x578irgMAU/kxlqwVBxHWs/lNJPrhJwocbrBOZj7LOAzRBLck17swkGu
         73sT3Xp+Ido4Jvq1OCuXCbnp8jvvuhbJrjOMFYKpylhfFOTPWVvaRFbJSSK/79ZxvXKf
         uqIFB7mEFZttvbluA6COMjbqjnjmgSAIFsoz4xXi6ygs2Af8nRxU7eE2DVafhhVPEA10
         D4+w==
X-Gm-Message-State: AOJu0Yw+sKoVuWJ0u9dZwoVSqJEdvRt0/SORHB6JIFgAraceyLhvPb0f
	1oD2O/Htl7TQ9RpA+qcwTpp3oA==
X-Google-Smtp-Source: AGHT+IGOEHGMqMmTWM8T72NnlHfAh3uz8ZlfmnS2zZQ4z9ULlC0QHtmRoAHmv/QUSlw8dLSeZKxKAA==
X-Received: by 2002:a5d:4d05:0:b0:336:58fb:f458 with SMTP id z5-20020a5d4d05000000b0033658fbf458mr2281309wrt.36.1702908735032;
        Mon, 18 Dec 2023 06:12:15 -0800 (PST)
Received: from apollon.wilcks.net (dslb-090-186-000-097.090.186.pools.vodafone-ip.de. [90.186.0.97])
        by smtp.gmail.com with ESMTPSA id d17-20020adfa411000000b003366dd4f12esm764975wra.112.2023.12.18.06.12.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Dec 2023 06:12:14 -0800 (PST)
Message-ID: <ee4b64bc3f7be41c20b4aeada2e3f9254bb8c05c.camel@suse.com>
Subject: Re: [PATCH v2 5/5] multipathd: force setting dm state when
 disabling/restoring queueing
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper
	development <dm-devel@lists.linux.dev>
Date: Mon, 18 Dec 2023 15:12:13 +0100
In-Reply-To: <ZX0QJIrOQU6RKaAp@bmarzins-01.fast.rdu2.eng.redhat.com>
References: <20231205235704.355125-1-bmarzins@redhat.com>
	 <20231205235704.355125-6-bmarzins@redhat.com>
	 <0e0dcba49d56b71a7584efb2273be1e9d0606af2.camel@suse.com>
	 <ZX0QJIrOQU6RKaAp@bmarzins-01.fast.rdu2.eng.redhat.com>
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

On Fri, 2023-12-15 at 21:49 -0500, Benjamin Marzinski wrote:
> On Thu, Dec 14, 2023 at 05:15:20PM +0100, Martin Wilck wrote:
> > The term "restorequeuing" suggests that it's somehow reset to a
> > previously saved value, which is not the case. We should mention in
> > the
> > man page that "restorequeuing" actually just enables queueing (for
> > maps
> > that are configured to queue). Perhaps we should also add
> > "enablequeueing" as an alias for "restorequeueing".
>=20
> I don't like the name "enablequeueing". "disablequeueing" turns
> queueing
> off regardless of the device's setting. "enablequeueing" sound like
> it
> could turn queueing on regardless of the device's setting. If you'd
> like,
> we could add code to restore queueing to stop queueing if we
> shouldn't
> be, but I'm not sure how that could happen, so it seems unnecessary,
> unless there's some way that this could happen that I'm not thinking
> about. I'm fine with updating the man page to mention that
> "restorequeueing" will just reset no_path_retry to the configured
> setting and reenable queueing if necessary.

Ok, forget about "enablequeueing", then. Let's just make sure the man
page accurately describes what "restorequeuing" does.

> > > @@ -962,10 +955,10 @@ cli_restore_all_queueing(void *v, struct
> > > strbuf
> > > *reply, void *data)
> > > =C2=A0		pthread_cleanup_push(put_multipath_config,
> > > conf);
> > > =C2=A0		select_no_path_retry(conf, mpp);
> > > =C2=A0		pthread_cleanup_pop(1);
> > > -		/* See comment in cli_restore_queueing() */
> > > -		if (mpp->no_path_retry !=3D NO_PATH_RETRY_UNDEF &&
> > > -		=C2=A0=C2=A0=C2=A0 mpp->no_path_retry !=3D NO_PATH_RETRY_FAIL)
> > > -			set_no_path_retry(mpp);
> > > +
> > > +		if (mpp->no_path_retry =3D=3D NO_PATH_RETRY_QUEUE ||
> > > +		=C2=A0=C2=A0=C2=A0 (mpp->no_path_retry > 0 &&
> > > count_active_paths(mpp) > 0))
> > > +			dm_queue_if_no_path(mpp->alias, 1);
> >=20
> > What about the case when there are no active paths, no pending
> > paths,
> > mpp->in_recovery and mpp->retry_tick > 0?
>=20
> I guess I always sort of assumed the the restore queueing commands
> would
> get called after the disablequeueing commands. In that case,
> retry_tick
> can't be greater than 0. But if the plan is to keep mpp->features in
> sync, and we go back to calling set_no_path_retry() here, we still
> won't
> enable queueing it the state you mention.=C2=A0 I would argue that there'=
s
> not much point in doing so. We don't have paths, and we already were
> failing back IO, so anything that was sending IO will already have
> seen
> failures. There doesn't seem much point in turning it back on now.

That makes some sense, yet IMO a user would expect that
"restorequeueing" does just that, whether or not it's reasonable to do
so. If it does not, we  need to document it, I think.

I wonder if we can / should somehow enforce that "restorequeueing" can
only be called on a map on which "disablequeueing" had been called
previously.

> Besides how would we even get into this state? I suppose something
> outside of multipathd could have turned off queueing.
>=20
> I was planning on just going back to set_no_path_retry() if we keep
> mpp->features in sync, unless you object.

No objections.

Regards,
Martin

