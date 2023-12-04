Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331FA26AC9
	for <dm-devel@lists.linux.dev>; Mon,  4 Dec 2023 20:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DMlp2i1G"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a18b0f69b33so884290966b.0
        for <dm-devel@lists.linux.dev>; Mon, 04 Dec 2023 12:44:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1701722640; x=1702327440; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=kGG8s6A9iKci6LOzzEnOhaMZlEZoyIwQK2SulIQHL3Q=;
        b=DMlp2i1GljPcuhzZVeYUKl3UkbQT75a6lrSep4/b/UzPnNtKxKVZZrnyu84OlNIt+7
         z3e5EIeDSil3rWkRHg1re3eG8Ekhi4Z2dR1hNsFLE2x9qQgZw9ddFqhyw6W6Fvwd5cOe
         vKPvAUNL+WDY1sZoyn9CjxBQOfwZ+qENEd78ufKsvgOvMw5dWxpP6bcdeL0Wqo7gLHiA
         rTqx84uH2nRHjd7+irqTsX5+6JjxoGP9fNr5wursGZ2SRtgnA9et8UDwdp/fr/ejgPiV
         CkCI1SUJaQyuFL1mE/27dQt+JSz8iJRSV+5z7Hah2xaUH+jeyJp13ceRTkW3yS/K4SYk
         N3tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701722640; x=1702327440;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kGG8s6A9iKci6LOzzEnOhaMZlEZoyIwQK2SulIQHL3Q=;
        b=m03ez7ykrSB4ZUPt2CGKVoamALJzrghEObPaJJVuApVF/x22n+Wv1c8BLATDSdsYXI
         AxF1pdU5DeCAOX9/iKRJL2O2yET/ff8NE73579W6Rvg9vUCsgJUxE6Ccx2OD3FRAHMoZ
         AGb0fSsN10LNOxpOTK9RKmvvbDOJglI6pUc8hlLVfT2DoVT6956iAgNJieYIea1uwTLM
         C1WLEr9V+gL6GqcUzNajypwaT0E4+UdUfu04EdFjMBseZlUDiBnsEqkFOVwaOcbWCqPG
         HBqvo6yXF/KIFpo3Necc/dOBSM+00OzKYW+nsGzLLy6HIjzV02i+trA10nweB9XZpiQO
         bh/Q==
X-Gm-Message-State: AOJu0YxKlRpd8AK3fTBXsH3kllSSi0TWXlKVT/Du7Mld9QKvjCb1lqJ8
	8dVC11tpaEbckVGOmkY6T/ddRAvTiEcuP9mAitJ37w==
X-Google-Smtp-Source: AGHT+IE26K2AGrOoN43MisaANLSJ9earN650PazZSzYB5M//pOwPsEDsjmZab4Fu2huoSg1eedhWZA==
X-Received: by 2002:a17:906:58:b0:a19:a409:37d3 with SMTP id 24-20020a170906005800b00a19a40937d3mr6141076ejg.44.1701722640345;
        Mon, 04 Dec 2023 12:44:00 -0800 (PST)
Received: from apollon-wifi.fritz.box (dslb-090-186-000-097.090.186.pools.vodafone-ip.de. [90.186.0.97])
        by smtp.gmail.com with ESMTPSA id p14-20020a1709060e8e00b00a0173cfaab6sm5599940ejf.44.2023.12.04.12.43.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Dec 2023 12:44:00 -0800 (PST)
Message-ID: <094991ab4257ab76755d83a8738676f76327d1ec.camel@suse.com>
Subject: Re: [PATCH] multipathd: Make sure to disable queueing if recovery
 has failed.
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper
	development <dm-devel@lists.linux.dev>
Date: Mon, 04 Dec 2023 21:43:58 +0100
In-Reply-To: <ZW4v8bZSDSypdv42@bmarzins-01.fast.rdu2.eng.redhat.com>
References: <20231127215418.271708-1-bmarzins@redhat.com>
	 <23fc863a947a0362e31e4cf685a4cb92f4e9178f.camel@suse.com>
	 <ZW4v8bZSDSypdv42@bmarzins-01.fast.rdu2.eng.redhat.com>
Autocrypt: addr=martin.wilck@suse.com; prefer-encrypt=mutual; keydata=mQINBF3mxsYBEACmOnQxWBCxCkTb3D4N8VAT8yNtIBZrmvomY7RLddBIT1yh2X7roOoJQ5KlmyjMmzrPr111poqmw8v4dUqc1SVqQoKHXv97BzlVIEKC5G2W29gse0oXhx3dhie0Z6ytkHVOY29VLsLhVXEz+p5xL71KYgIy3lmM/NaWvoqwwaXiv1TmLG96Uoitvj1vdXqqTv/R6/MBye+xQUacXpM8FA5k7OpmzCFjl4NVtGmo0VhIfXM/ldmyEJpg8a5LrZ4t5Qi32BWQjUHGmS8OXjUJ/n0QxLkymbcbY1KepP9UnLGPT+TmKJm1QlMDj69+WPKgMsif3iz4hZPoQ0Knp11ThYzBh7+AiRxE9FG2hTtZeKimkpjR12bytF4Y0aIM/HeLMHRvwykJuh5JxT9A68xF7hmqQZ7rsx/GoRBOA792kFgr5KdCZ1YoeVUkrohT1nfh/Y/Xfeq4E69mktE0R0Yxg/4CSiB7sLSzry8dyqk2sbGs+W/Ol7D7VOG45aZ5iTB08R2ji2xKArcH+Dmy48nwqIvdrppZG2tZEe+wtGPTzahE4OJdpZ3vS4ujdChynS47DVWa5JtBxfqopr0rPGoCyxmyvzJzHAUjlp7iSXpDZqfdu7F4HAC13mS41IVk/yHTXE28AKrZ4O+efZ6qgw5zJV9lAbWM7JjfdrTd+ofOc+GurQARAQABtCRNYXJ0aW4gV2lsY2sgPG1hcnRpbi53aWxja0BzdXNlLmNvbT6JAlEEEwEIADsCGwEFCwkIBwIGFQoJCAsCBBYCAwECHgECF4AWIQR1Dq1LLt6xpUXU9fRnxYbmhVaXVAUCXebHhgIZAQAKCRBnxYbmhVaXVJ6+EACa5mbuH1dy2bKldy+bybUe4jFpJxflAPSrdpIlwkIfD/SgQRWUUm+BLLJMGJFS
 KiVC6oAHH6/mo3gdWAqBJ0LAOQDDR2BW31ERYqQQ7m01INQIvMlg+PXQ8HbWd CNF1SOgjxiIs04DlB+u+DD5pgPtxKFN/jaJSx9oZ+GZpSd+eJeull3a+U/1+QpYmLbH34bxYZ16+cXfarkH3QQC65DH/iIZwcpxp+v/zrQVXnsZ81XmmbLD1vMkFCIU0ircIcaJoqloNJOA46P4mj9ETwC5OiSTs7vlyHP4Ni/86kmjmr41d/baY1cAXpAbtOGYd5K72B6qSP5EJI+Ci6rSbWInQaYzKuAOrDDyhW7ODd+hOtBcmUIH5GpKvzRjdfxEP/zlyecBszxycz7lOYNx86QWsyyRWITKzHzhdqKVZ9kvjVozTtcpb1RSqsj43qqMEQjcp1uXhbmwVmbzsWaPqmCx4xsIQoXfIzzffvw+nOiPLkxzGczprwNJasDUM1hcyEPv+5VzZpE4YjlDw/mtTayehb2EGzt2RfZIuPCBr88KlWUh2+nu9RfBJNdJ2vZ13Aun8NbqPKR2vfsE+BUJY14Ak9ZIzcyruHBHQ78dxD0J+HSC1bm9e4UOnW0PBbZwuPTRwyO3aXoExPabGgig6gcY34bsXvW9SDwOu+pzXMnVvbQeTWFydGluIFdpbGNrIDxtd2lsY2tAc3VzZS5jb20+iQJOBBMBCAA4FiEEdQ6tSy7esaVF1PX0Z8WG5oVWl1QFAl3mxz0CGwEFCwkIBwIGFQoJCAsCBBYCAwECHgECF4AACgkQZ8WG5oVWl1TdsA/6A0DZmGwreygUic5csLSLUm2ahdat3rRKfQVdlOdl0aWa/vS90PqpuDNGzXVzS/s4YXRjWesnYEdwQGSc4PnBYCitLKUwenII39RCyZLU3J95luWG2eOagFaerK+HvuNEH6RpYkqPpaDEwpblfi30xNNYLIR4HK0GTYwhbmBTrYgaKATNiplU08ZUvC23s00t2i7SBGmOue/0dIPMhO3EDYPP0RaDnKvH
 AOAywkI1J9Ey0xEslG9AFylOihcdaq9/7MlMWU8oNHK7EVE5OOZ2NiJv1sWSgM 6dvGdfgLeNmsiyHGDtfXYFw32e59ShkxUDc/uLLseISAftDYdPzKXxdkxRfjLkLk24HMP+uEauH0ytdC7P4NJmDHKlKH9da7lA1x94XEsn+ZMiqFvXh4ce2SgqnH7FjctNPamek+3tJIBBoFkMeABDeXnMlmLtTU21qC6lEXMLAmcyIR+eBdivTZyhf7NOE100JQYGdYTKUDITUSXdJ33cgwll4a2kUZK1nA7DGNwDYOoWF4i1cZKRBfMaD/1Pm/Los9ga/B+kfI+fQTam+gdD/crwpsr5wiXcGgggR+FwBsux3/hcoXVbBhCQKeoEE/4ajmAxsNWGZgMvRv6JLJNZ/rBfges5LjvHJY9tOcjlniJAArIfR/LrRRrQhf1zHH/fpql7lIPvBM20HU1hcnRpbiBXaWxjayA8bXdpbGNrQHN1c2UuZGU+iQJOBBMBCAA4FiEEdQ6tSy7esaVF1PX0Z8WG5oVWl1QFAl3mx2UCGwEFCwkIBwIGFQoJCAsCBBYCAwECHgECF4AACgkQZ8WG5oVWl1QWFBAAipbqrpAO+TYm8U8Nz0GpM/Q+nOya2JS2eF8UbkpZcmhC9pObpLd4PsEl6QbmDvbiVhurv5Cp7TVPhl1ap5ir7TFHvErzs4Rxwohof4MSY5SRSbYAaz4e6bMw7GGIOQhtKOXi+zzSqLrCIdTKxfNy3MYZ+Z4xBCGyE2bNExjxpDBjYrjm6ehfo8+TVabBRX+2sJsLugZszQF0tnV4Y8oAA2iePTiwSe9hz45OKEhDyNpfJ1Kg2hUropKEOS7Q+jP6Bw8M3RomQnk37GnU0Wi8wSNiyWYRhossI72Se/w1uRsQuVCT0qSsa9raLekya2rf0bPFmCBPRUP+KUrBq5yY0c6BdY45incUqhLlQo06lf38e6+CyouN0HpQ62CxQQTMxM87
 FRTg6uRUitWtnDLoVY/d9wgzvxBJHW4hIKuv5JNeh7PyFO7vB55DekaoRLKU3MC FWjq3LA0t2FLEVXdF/NcVw1Qn6kIIfbgPYVdBMO1b3ciu+NY6ba8lzqiIIH+Js/+JnAwzLQNLp360Kza7/P7bgd0NxBCbLziay7MVZawRQhCUkUWcqeonGBuSyf0wO3sFlRZm+pv1sg6I6DZCrykSFyABkH7joZg5nUuNuT3/E2Jw9gBqll6OrsgTDzWzofTASYtQIRjqLypeqiz4ADmHy9tyEt1SxVd2C4o1JmY=
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2023-12-04 at 15:00 -0500, Benjamin Marzinski wrote:
> On Mon, Dec 04, 2023 at 03:38:03PM +0100, Martin Wilck wrote:
> > On Mon, 2023-11-27 at 16:54 -0500, Benjamin Marzinski wrote:
> > > If a multipath device has no_path_retry set to a number and has
> > > lost
> > > all
> > > paths, gone into recovery mode, and timed out, it will disable
> > > queue_if_no_paths. After that, if one of those failed paths is
> > > removed,
> > > when the device is reloaded, queue_if_no_paths will be re-
> > > enabled.=A0
> > > When
> > > set_no_path_retry() is then called to update the queueing state,
> > > it
> > > will
> > > not disable queue_if_no_paths, since the device is still in the
> > > recovery
> > > state, so it believes no work needs to be done. The device will
> > > remain
> > > in the recovery state, with retry_ticks at 0, and queueing
> > > enabled,
> > > even though there are no usable paths.
> > >=20
> > > To fix this, in set_no_path_retry(), if no_path_retry is set to a
> > > number
> > > and the device is queueing but it is in recovery mode and out of
> > > retries with no usable paths, manually disable queue_if_no_path.
> > >=20
> > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> >=20
> > Thanks, this makes sense. I am just wondering if this logic should
> > be moved to enter_recovery_mode() / leave_recovery_mode() instead.
> > That pair of functions is also called from
> > update_queue_mode{add,del}_path(), where the same reasoning would
> > apply, afaics. Am I overlooking something?
>=20
> In general, I think it's safe to only do this in set_no_path_retry().
> The functions that call update_queue_mode{add,del}_path() are:
> fail_path()
> reinstate_path()
> update_multipath()
> io_err_stat_handle_pathfail()
>=20
> fail_path() and reinstate_path() will always call the
> update_queue_mode_* function after calling set_no_path_retry(), so
> the
> device will already be in the correct state. update_multipath()
> usually
> will as well (except when it's called by a command line handler), and
> further, it will only call update_queue_mode_del_path() when it is
> actually failing a path, so the multipath device shouldn't already be
> in recovery_mode. The same goes for io_err_stat_handle_pathfail().
>=20
> Also we need to make sure that mpp->features is uptodate before doing
> these checks, so that we know what the current queueing state is.
> io_err_stat_handle_pathfail() doesn't update mpp->features before
> calling update_queue_mode_del_path(), so it could end up doing the
> wrong
> thing.
>=20
> And set_no_path_retry() will be called (after updating mpp->features)
> the next time the path checker completes for a path in the device, so
> devices won't remain in a bad state long, no matter what.
>=20
> What looking at this did make me realize is that
> cli_restore_queueing()
> and cli_restore_all_queueing() don't update the device strings before
> calling set_no_path_retry(). Thinking about this, it seems like they
> should call update_multipath(vecs, mpp->alias, 1) instead, to trigger
> the set_no_path_retry() call after updating mpp->features.
>=20
> I'll send another patch to fix cli_restore_queueing() and
> cli_restore_all_queueing(). If you think it's necessary, I can also
> send
> one to make io_err_stat_handle_pathfail() call update_multipath() and
> then move the code to manually change the queueing state to
> enter_recovery_mode() and leave_recovery_mode(), instead of doing it
> in
> set_no_path_retry().
>=20

Thanks for working out all the different cases. Personally, I would
like to have this logic in one place, if possible. I'll leave it to
your judgement, as you've taken a closer look than myself.

I'm not sure what you mean with "mpp->features is up to date"; are you
considering some entity applying changes to the mpp features without
involving multipathd, e.g. by using direct DM ioctls or dmsetup?

Regards
Martin

> -Ben
>=20
> >=20
> > Regards
> > Martin
> >=20
> > > ---
> > > =A0libmultipath/structs_vec.c | 12 +++++++++++-
> > > =A01 file changed, 11 insertions(+), 1 deletion(-)
> > >=20
> > > diff --git a/libmultipath/structs_vec.c
> > > b/libmultipath/structs_vec.c
> > > index 0e8a46e7..3cb23c73 100644
> > > --- a/libmultipath/structs_vec.c
> > > +++ b/libmultipath/structs_vec.c
> > > @@ -627,8 +627,18 @@ void set_no_path_retry(struct multipath
> > > *mpp)
> > > =A0			=A0=A0=A0 !mpp->in_recovery)
> > > =A0				dm_queue_if_no_path(mpp->alias,
> > > 1);
> > > =A0			leave_recovery_mode(mpp);
> > > -		} else if (pathcount(mpp, PATH_PENDING) =3D=3D 0)
> > > +		} else if (pathcount(mpp, PATH_PENDING) =3D=3D 0) {
> > > +			/*
> > > +			 * If in_recovery is set,
> > > enter_recovery_mode does
> > > +			 * nothing. If the device is already in
> > > recovery
> > > +			 * mode and has already timed out,
> > > manually
> > > call
> > > +			 * dm_queue_if_no_path to stop it from
> > > queueing.
> > > +			 */
> > > +			if ((!mpp->features || is_queueing) &&
> > > +			=A0=A0=A0 mpp->in_recovery && mpp->retry_tick
> > > =3D=3D
> > > 0)
> > > +				dm_queue_if_no_path(mpp->alias,
> > > 0);
> > > =A0			enter_recovery_mode(mpp);
> > > +		}
> > > =A0		break;
> > > =A0	}
> > > =A0}
>=20

