Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56C32C690
	for <dm-devel@lists.linux.dev>; Mon, 15 Jan 2024 12:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="AiC2eclF";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="AiC2eclF"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CF3861F84E;
	Mon, 15 Jan 2024 12:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1705320417; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1deGzQdiTeLc6zboKIO0k0Hw7NJy+Om9ig7jAudHEXI=;
	b=AiC2eclFDZjqVOSoZoSPHC1zMvkhEa3jN86DGe/MG0QrEXEOh3U7xX/uWSfGnhvD3od2ty
	vLiCKM5A4D5ch/lPf9ioatDNkDBOoFxCCF5oEno86+GR5Ik7GEQW87LPNtxNJ5dJI4/ck5
	9ihhIF3OYy7PbykjmHMhV3q3Jx9lkx4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1705320417; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1deGzQdiTeLc6zboKIO0k0Hw7NJy+Om9ig7jAudHEXI=;
	b=AiC2eclFDZjqVOSoZoSPHC1zMvkhEa3jN86DGe/MG0QrEXEOh3U7xX/uWSfGnhvD3od2ty
	vLiCKM5A4D5ch/lPf9ioatDNkDBOoFxCCF5oEno86+GR5Ik7GEQW87LPNtxNJ5dJI4/ck5
	9ihhIF3OYy7PbykjmHMhV3q3Jx9lkx4=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AAA6213712;
	Mon, 15 Jan 2024 12:06:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7K3EJ+EfpWWsRwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Mon, 15 Jan 2024 12:06:57 +0000
Message-ID: <78376127ecf7f0dfa0a7097c52952ecc841d18a0.camel@suse.com>
Subject: Re: Multipath bootup failure
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Mon, 15 Jan 2024 13:06:56 +0100
In-Reply-To: <ZaHer1amGhviRscA@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <ZaHer1amGhviRscA@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
Autocrypt: addr=mwilck@suse.com; prefer-encrypt=mutual;
 keydata=mQINBF3mxsYBEACmOnQxWBCxCkTb3D4N8VAT8yNtIBZrmvomY7RLddBIT1yh2X7roOoJQ5KlmyjMmzrPr111poqmw8v4dUqc1SVqQoKHXv97BzlVIEKC5G2W29gse0oXhx3dhie0Z6ytkHVOY29VLsLhVXEz+p5xL71KYgIy3lmM/NaWvoqwwaXiv1TmLG96Uoitvj1vdXqqTv/R6/MBye+xQUacXpM8FA5k7OpmzCFjl4NVtGmo0VhIfXM/ldmyEJpg8a5LrZ4t5Qi32BWQjUHGmS8OXjUJ/n0QxLkymbcbY1KepP9UnLGPT+TmKJm1QlMDj69+WPKgMsif3iz4hZPoQ0Knp11ThYzBh7+AiRxE9FG2hTtZeKimkpjR12bytF4Y0aIM/HeLMHRvwykJuh5JxT9A68xF7hmqQZ7rsx/GoRBOA792kFgr5KdCZ1YoeVUkrohT1nfh/Y/Xfeq4E69mktE0R0Yxg/4CSiB7sLSzry8dyqk2sbGs+W/Ol7D7VOG45aZ5iTB08R2ji2xKArcH+Dmy48nwqIvdrppZG2tZEe+wtGPTzahE4OJdpZ3vS4ujdChynS47DVWa5JtBxfqopr0rPGoCyxmyvzJzHAUjlp7iSXpDZqfdu7F4HAC13mS41IVk/yHTXE28AKrZ4O+efZ6qgw5zJV9lAbWM7JjfdrTd+ofOc+GurQARAQABtCRNYXJ0aW4gV2lsY2sgPG1hcnRpbi53aWxja0BzdXNlLmNvbT6JAlEEEwEIADsCGwEFCwkIBwIGFQoJCAsCBBYCAwECHgECF4AWIQR1Dq1LLt6xpUXU9fRnxYbmhVaXVAUCXebHhgIZAQAKCRBnxYbmhVaXVJ6+EACa5mbuH1dy2bKldy+bybUe4jFpJxflAPSrdpIlwkIfD/SgQRWUUm+BLLJMGJFSKiVC6oAHH6/mo3gdWAqBJ0LAOQDDR2BW31ERYqQQ7m01INQIvMlg+PXQ8HbWd
	CNF1SOgjxiIs04DlB+u+DD5pgPtxKFN/jaJSx9oZ+GZpSd+eJeull3a+U/1+QpYmLbH34bxYZ16+cXfarkH3QQC65DH/iIZwcpxp+v/zrQVXnsZ81XmmbLD1vMkFCIU0ircIcaJoqloNJOA46P4mj9ETwC5OiSTs7vlyHP4Ni/86kmjmr41d/baY1cAXpAbtOGYd5K72B6qSP5EJI+Ci6rSbWInQaYzKuAOrDDyhW7ODd+hOtBcmUIH5GpKvzRjdfxEP/zlyecBszxycz7lOYNx86QWsyyRWITKzHzhdqKVZ9kvjVozTtcpb1RSqsj43qqMEQjcp1uXhbmwVmbzsWaPqmCx4xsIQoXfIzzffvw+nOiPLkxzGczprwNJasDUM1hcyEPv+5VzZpE4YjlDw/mtTayehb2EGzt2RfZIuPCBr88KlWUh2+nu9RfBJNdJ2vZ13Aun8NbqPKR2vfsE+BUJY14Ak9ZIzcyruHBHQ78dxD0J+HSC1bm9e4UOnW0PBbZwuPTRwyO3aXoExPabGgig6gcY34bsXvW9SDwOu+pzXMnVvbQeTWFydGluIFdpbGNrIDxtd2lsY2tAc3VzZS5jb20+iQJOBBMBCAA4FiEEdQ6tSy7esaVF1PX0Z8WG5oVWl1QFAl3mxz0CGwEFCwkIBwIGFQoJCAsCBBYCAwECHgECF4AACgkQZ8WG5oVWl1TdsA/6A0DZmGwreygUic5csLSLUm2ahdat3rRKfQVdlOdl0aWa/vS90PqpuDNGzXVzS/s4YXRjWesnYEdwQGSc4PnBYCitLKUwenII39RCyZLU3J95luWG2eOagFaerK+HvuNEH6RpYkqPpaDEwpblfi30xNNYLIR4HK0GTYwhbmBTrYgaKATNiplU08ZUvC23s00t2i7SBGmOue/0dIPMhO3EDYPP0RaDnKvHAOAywkI1J9Ey0xEslG9AFylOihcdaq9/7MlMWU8oNHK7EVE5OOZ2NiJv1sWSgM
	6dvGdfgLeNmsiyHGDtfXYFw32e59ShkxUDc/uLLseISAftDYdPzKXxdkxRfjLkLk24HMP+uEauH0ytdC7P4NJmDHKlKH9da7lA1x94XEsn+ZMiqFvXh4ce2SgqnH7FjctNPamek+3tJIBBoFkMeABDeXnMlmLtTU21qC6lEXMLAmcyIR+eBdivTZyhf7NOE100JQYGdYTKUDITUSXdJ33cgwll4a2kUZK1nA7DGNwDYOoWF4i1cZKRBfMaD/1Pm/Los9ga/B+kfI+fQTam+gdD/crwpsr5wiXcGgggR+FwBsux3/hcoXVbBhCQKeoEE/4ajmAxsNWGZgMvRv6JLJNZ/rBfges5LjvHJY9tOcjlniJAArIfR/LrRRrQhf1zHH/fpql7lIPvBM20HU1hcnRpbiBXaWxjayA8bXdpbGNrQHN1c2UuZGU+iQJOBBMBCAA4FiEEdQ6tSy7esaVF1PX0Z8WG5oVWl1QFAl3mx2UCGwEFCwkIBwIGFQoJCAsCBBYCAwECHgECF4AACgkQZ8WG5oVWl1QWFBAAipbqrpAO+TYm8U8Nz0GpM/Q+nOya2JS2eF8UbkpZcmhC9pObpLd4PsEl6QbmDvbiVhurv5Cp7TVPhl1ap5ir7TFHvErzs4Rxwohof4MSY5SRSbYAaz4e6bMw7GGIOQhtKOXi+zzSqLrCIdTKxfNy3MYZ+Z4xBCGyE2bNExjxpDBjYrjm6ehfo8+TVabBRX+2sJsLugZszQF0tnV4Y8oAA2iePTiwSe9hz45OKEhDyNpfJ1Kg2hUropKEOS7Q+jP6Bw8M3RomQnk37GnU0Wi8wSNiyWYRhossI72Se/w1uRsQuVCT0qSsa9raLekya2rf0bPFmCBPRUP+KUrBq5yY0c6BdY45incUqhLlQo06lf38e6+CyouN0HpQ62CxQQTMxM87FRTg6uRUitWtnDLoVY/d9wgzvxBJHW4hIKuv5JNeh7PyFO7vB55DekaoRLKU3MC
	FWjq3LA0t2FLEVXdF/NcVw1Qn6kIIfbgPYVdBMO1b3ciu+NY6ba8lzqiIIH+Js/+JnAwzLQNLp360Kza7/P7bgd0NxBCbLziay7MVZawRQhCUkUWcqeonGBuSyf0wO3sFlRZm+pv1sg6I6DZCrykSFyABkH7joZg5nUuNuT3/E2Jw9gBqll6OrsgTDzWzofTASYtQIRjqLypeqiz4ADmHy9tyEt1SxVd2C4o1JmY=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Authentication-Results: smtp-out2.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 BAYES_HAM(-3.00)[100.00%];
	 FROM_HAS_DN(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 MIME_GOOD(-0.10)[text/plain];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.com:s=susede1];
	 TO_DN_ALL(0.00)[];
	 RCPT_COUNT_TWO(0.00)[2];
	 NEURAL_HAM_SHORT(-0.20)[-0.997];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
X-Spam-Flag: NO

On Fri, 2024-01-12 at 19:51 -0500, Benjamin Marzinski wrote:
> Booting a machine with a multipathed kpartx root device fails for me
> using the fedora rawhide multipath packages, which are based on the
> 0.9.7 release. Using LVM on top works. The issue is that when the
> root
> device is directly on a partition, dracut finds it on one of the path
> devices, and starts using that. If multipathd isn't running when the
> uevent for that path device is processed, it won't be claimed by
> multipath (starting in 0.9.7), since there is no multipathd.socket in
> the initramfs and no systemd_service_enabled().=C2=A0 Afterwards,
> multipathd
> creates a multipath device on top of the device, claims it, and
> removes
> the partitions. If this happens while dracut is attempting to mount
> the
> root device, the boot fails. In practice, it usually failed for me.
>=20
> Reverting 6fad1464 ("libmpathutil: remove systemd_service_enabled()")
> resolves the problem. When I tried to add=20
>=20
> Before=3Ddracut-pre-mount.service
>=20
> to dracut's version of multipathd.service instead, it works over 95%
> of
> the time, but it still occasionally fails. The issue is that even
> though
> multipathd will creates the multipath device before before signaling
> that it has started up, meaning that dracut won't start working
> towards
> mounting the root device until after the multipath device exists,
> dracut
> won't know to not use the underlying device partition until it
> processes
> the uevents that get triggered by multipathd creating the device. And
> it
> won't be able to use the kpartx device until in processes the uevents
> that get triggered by kpartx running when processing the multipath
> device uevents. Depending on how quickly dracut processes these
> events
> relative to the rest of the bootup work, it can still hang. I've
> tested
> adding
>=20
> Before=3Dsystemd-udev-trigger.service
>=20
> to multipathd.sevice with no failures so far.=C2=A0 This requires fixing
> multipathd-configure.service, so that there aren't any dependency
> conflicts, but that should happen anyway.=C2=A0 I need to talk to the
> CoreOS
> people who added this, but I think the only necessary dependency for
> multipathd-configure.service to come after is

Disclaimer: I have no experience with multipathd-configure.service.

>=20
> After=3Ddracut-cmdline.service
>=20
> With this, I think that multipathd should always be running before
> device uevents get processed, but perhaps it needs to be before
> systemd-udevd.service instead.

Yes indeed. I thought this was already the case with the "recent"
changes made to dracut's multipath module:

297525c fix(multipath): remove dependency on multipathd.socket
6246da4 fix(multipathd.service): drop dependencies on iscsi and iscsid
a247d2b fix(multipathd.service): adapt to upstream multipath-tools unit fil=
e
371b338 fix(multipathd.service): remove dependency on systemd-udev-settle

Basically multipathd.service should have (almost) no "After=3D"
dependencies, making it start very early during boot, and definitely
before=C2=A0systemd-udev-trigger.service.=C2=A0Actually, it should start up=
 after
systemd-udev-socket.service, but before systemd-udevd.service. This way
we'd ensure that we don't miss any uevents.

I don't quite understand why this wasn't the=C2=A0case for you. Was it
caused by multipathd.configure.service and its dependencies?

(Note also my pending dracut PR
https://github.com/dracutdevs/dracut/pull/2563#issuecomment-1823525208
where I'm trying to get rid of the dracut-specific multipathd.service
file).

> If it's not possible to guarantee that multipathd has started before
> we
> process uevents so that we always claim the path devices as soon as
> they
> appear, then to close this race window, we need to either wait after
> multipathd starts for all the uevents to settle (and I don't think we
> want to get back into the business of relying on udev-settle), or to
> go
> back to some method of making multipath able to claim devices before
> multipathd starts.=20

I don't think this will be necessary. We just need to get the
dependencies right. Your example shows, though, that it might be
sufficient to just add another service (here I suspect multipathd-
configure.service) to mess up the deps. We can consider adding an
explicit

Before=3Dsystemd-udevd.service

to our unit file. This way it'd be guaranteed that we start up before
udevd, and if some other unit got it wrong, systemd should report a
dependency cycle.

Regards
Martin


