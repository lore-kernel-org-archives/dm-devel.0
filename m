Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00ECD21CC4E
	for <dm-devel@lists.linux.dev>; Wed,  7 May 2025 07:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746602051; cv=none; b=Fshy06gTCDIJ1ycbA82D5rIA/+zvDGKVGnI4zL+YFu0tAfz7lcClLLm8cL59iA7Ky10zeNopotLTtQjebBESGrbNs1dSodcRfbu9c6bMNexLJQQsiw54Sb5LHYeCCEIkkq0r/dAOU2USnsJcFyCWCwVndqLCZU42cQNkqPmkKuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746602051; c=relaxed/simple;
	bh=+6prQXnJlzMSy6S/LqE+kSEr6Dej45cRQ51kwfFbGic=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=M4U+TbBkSTKhYHmftPCepl/k0j0jfUW6O1NlMfxYa00OBYOMGnize7KwQ8EvhjhVJ2GLcecrQ5p1MGjrPsq6T3Dr3gxblZm/6ER3Lyj2sBsNkWHh6iYcsTD6cOAAEymxPkUqCZYyeNxeAbXOa//VBJnUmdyfsbeIO792nlNjkdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Lp7Dv5xA; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=WJ29weAs; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Lp7Dv5xA";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="WJ29weAs"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C59E01F390;
	Wed,  7 May 2025 07:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1746602047; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+6prQXnJlzMSy6S/LqE+kSEr6Dej45cRQ51kwfFbGic=;
	b=Lp7Dv5xA17z2iQlyhAPbdnwIFPOw3cgvrhm3S+U1/OXukDUQBsycHKj3257/Td0D/tgt70
	4P3YPBFxnlnkq8CAwGc9OIuIHn/I5cYY1FgbeHDhDfHsO0fyJXHkttAAF4ZkqElWZzHFf1
	WqIDI9ZnZAdjHygdkf7bdN/PkOQG21w=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=WJ29weAs
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1746602046; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+6prQXnJlzMSy6S/LqE+kSEr6Dej45cRQ51kwfFbGic=;
	b=WJ29weAsz9ql9qRh7BbUZ6UyigMCvkR0NxiqWK/3cmhm5mhkZefcbvX3rpitD+Jq99BLvp
	XDG+kdrOEH3jrHqvZkzHErdGeS5H33jDRjVQTahGc61FUWPXrEIHDiWP9Wzld4fo3D+NmO
	2FM2FtPePTT7D1+ZK4aWx6T5GGtnLSI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 952C113882;
	Wed,  7 May 2025 07:14:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JiyMIj4IG2i3UQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Wed, 07 May 2025 07:14:06 +0000
Message-ID: <930acf4a9ee6a8703947647b20ad2d0ef5bb3861.camel@suse.com>
Subject: Re: [PATCH 0/6] multipath-tools: static analyzer fixes
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, Xose Vazquez Perez
	 <xose.vazquez@gmail.com>, dm-devel@lists.linux.dev
Date: Wed, 07 May 2025 09:14:05 +0200
In-Reply-To: <aBqMjI8UWOWLlbGh@redhat.com>
References: <20250505163007.59352-1-mwilck@suse.com>
	 <aBqMjI8UWOWLlbGh@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Rspamd-Queue-Id: C59E01F390
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	MID_RHS_MATCH_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[opensvc.com,gmail.com,lists.linux.dev];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCPT_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,fedoraproject.org:url]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -3.01
X-Spam-Flag: NO

On Tue, 2025-05-06 at 18:26 -0400, Benjamin Marzinski wrote:
> On Mon, May 05, 2025 at 06:29:52PM +0200, Martin Wilck wrote:
> > Xose has kindly informed me about the warnings from Fedora's static
> > code analysis tool.
> >=20
> > I'm sending a couple of related fixes here. Most of the warnings
> > appear to be false positives though, see below (a second look by
> > another eye pair would be appreciated).
>=20
> I mostly agree with you, except that I wouldn't call all the errors
> related to VECTOR_SLOT() returning NULL false postitives (so maybe I
> mostly disagree with you. I didn't count). If we are in a
> vector_foreach_slot_*() loop and we are looking at
> VECTOR_SLOT(<vector_we_are_looping_over>, <current_index_value>),
> then I
> agree, we can't see a NULL value. But most, if not all, of the "NULL
> value from a vector" errors that got flagged here were not protected
> by
> the checks in vector_foreach_slot_*().=C2=A0

No not all. I double checked quite a few. Maybe I got too sloppy at
some point and started dismissing these warnings prematurely.

> Now I don't know of any cases
> where we do have NULLs in a vector, but we certainly could. We
> manipulate them all over the code. If we ever call
> vector_alloc_slot()
> and not vector_set_slot() we would have a NULL.

I've been thinking for some time that we should have a single function
vector_alloc_and_set_slot().

> =C2=A0 There's also no check
> to make sure that we don't call vector_set_slot() with a NULL value.
>=20
> We do have checks for NULL values when looping through vectors, and
> we
> even have vector_repack() to get rid of them. So, it's completely
> reasonable that a static analyzer would think that we might have a
> NULL
> value in a vector. And I'm pretty sure that NULL values in a vector
> are
> always a bug.=C2=A0

Right. Then we should add assert() statements rather than NULL checks,
both when adding slots and when reading from vectors.


> They make vector_foreach_slot() unable to access any
> values past them, despite the fact that we can keep adding values to
> the
> vector.
>=20
> Actually, cleaning this up, so that the code keeps us from having
> NULL
> values in vectors as long as we only manipulate them with the
> functions
> in vector.h has been on my todo list for a bit

Does this mean you intend to work on it and send patches?

Regards,
Martin


> . It would take some code
> auditing to make sure that there isn't a case where we do use vectors
> where NULL values are expected. But if there is, I think that should
> use
> a seperate set of functions, to clearly mark it out as special.




>=20
> -Ben
>=20
> >=20
> > Regards
> > Martin
> >=20
> > On Sat, 2025-05-03 at 23:29 +0200, Xose Vazquez Perez wrote:
> > > Findings by static analyzers in Fedora 43 Critical Path Packages:
> > > https://marc.info/?l=3Dfedora-devel-list&m=3D174582743823723
> > >=20
> > > device-mapper-multipath-0.11.1-1.fc43:
> > > https://openscanhub.fedoraproject.org/task/51915/
> > >=20
> > > device-mapper-multipath-0.11.1-1.fc43 List of Findings:
> > > https://openscanhub.fedoraproject.org/task/51915/log/device-mapper-mu=
ltipath-0.11.1-1.fc43/scan-results.html
> >=20
> > I'll leave the shellcheck errors in mpathconf to Ben.
> >=20
> > > Error: GCC_ANALYZER_WARNING (CWE-775): [#def42]
> > > multipath-tools-0.11.1/kpartx/dasd.c:89:24: warning[-Wanalyzer-
> > > fd-leak]: leak of file descriptor =E2=80=98fd_dasd=E2=80=99
> > > multipath-tools-0.11.1/kpartx/dasd.c:69:1: enter_function: entry
> > > to =E2=80=98read_dasd_pt=E2=80=99
> > > ...
> > > multipath-tools-0.11.1/kpartx/dasd.c:134:20: branch_true:
> > > following =E2=80=98true=E2=80=99 branch (when =E2=80=98fd_dasd < 0=E2=
=80=99)...
> > > branch_true: ...to here
> >=20
> > This one looks like a false positive to me. If fd_dasd < 0, it
> > can't be leaked.
> >=20
> > > Error: GCC_ANALYZER_WARNING (CWE-476): [#def45]
> > > multipath-tools-0.11.1/libmpathutil/parser.c:139:29: warning[-
> > > Wanalyzer-null-dereference]: dereference of NULL =E2=80=98keyword=E2=
=80=99
> >=20
> > False positive, too. VECTOR_SLOT won't return NULL here.=20
> > We could add a test to make the compiler happy, but I don't quite
> > see the point.
> >=20
> > > Error: GCC_ANALYZER_WARNING (CWE-457): [#def49]
> > > multipath-tools-0.11.1/libmultipath/alias.c:201:31: warning[-
> > > Wanalyzer-use-of-uninitialized-value]: use of uninitialized value
> > > =E2=80=98bdg=E2=80=99
> >=20
> > False positive. bdg won't be NULL here.
> >=20
> > > Error: GCC_ANALYZER_WARNING (CWE-465): [#def50]
> > > multipath-tools-0.11.1/libmultipath/dmparser.c:31:12: warning[-
> > > Wanalyzer-deref-before-check]: check of =E2=80=98p=E2=80=99 for NULL =
after
> > > already dereferencing it
> >=20
> > False positive. *dst is non-NULL when we call merge_words(). We
> > must double-check
> > after calling realloc().
> > (That said, we should reimplement this using strbuf functions).
> >=20
> > > Error: GCC_ANALYZER_WARNING (CWE-476): [#def51]
> > > multipath-tools-0.11.1/libmultipath/dmparser.c:436:25: warning[-
> > > Wanalyzer-null-dereference]: dereference of NULL =E2=80=98pgp=E2=80=
=99
> >=20
> > False positive. VECTOR_SLOT won't return NULL here. Same for the
> > next 3 errors.
> >=20
> > > Error: GCC_ANALYZER_WARNING (CWE-476): [#def55]
> > > multipath-tools-0.11.1/libmultipath/dmparser.c:501:33: warning[-
> > > Wanalyzer-null-dereference]: dereference of NULL =E2=80=98pp=E2=80=99
> >=20
> > Likewise. Same for the next 2 errors.
> >=20
> > > Error: GCC_ANALYZER_WARNING (CWE-476): [#def58]
> > > multipath-tools-0.11.1/libmultipath/foreign/nvme.c:494:28:
> > > warning[-Wanalyzer-null-dereference]: dereference of NULL =E2=80=98pa=
th=E2=80=99
> >=20
> > The nvme_pathgroup is a member of struct nvme_path.
> > nvme_pg_to_path() doesn't return NULL. Same for the next 2 errors
> > in nvme.c
> >=20
> > > Error: GCC_ANALYZER_WARNING (CWE-476): [#def62]
> > > multipath-tools-0.11.1/libmultipath/pgpolicies.c:191:17:
> > > warning[-Wanalyzer-null-dereference]: dereference of NULL =E2=80=98pp=
1=E2=80=99
> >=20
> > Again, false positives; VECTOR_SLOT() doesn't return NULL here.
> > Same for the next 3 errors.
> >=20
> > > Error: GCC_ANALYZER_WARNING (CWE-401): [#def66]
> > > multipath-tools-0.11.1/libmultipath/print.c:920:16: warning[-
> > > Wanalyzer-malloc-leak]: leak of =E2=80=98alloc_path_layout()=E2=80=99
> >=20
> > False positive. Strange one - gcc doesn't understand its own
> > __attribute__((cleanup))?
> > Or am I blind? Same for the next one.
> >=20
> > > Error: GCC_ANALYZER_WARNING (CWE-126): [#def70]
> > multipath-tools-0.11.1/libmultipath/uevent.c:122:9: warning[-
> > Wanalyzer-out-of-bounds]: stack-based buffer over-read
> >=20
> > This one is somewhat harder because it involves list handling
> > macros, but I believe that our code is correct and that this is a
> > false positive, too.
> >=20
> > > Error: GCC_ANALYZER_WARNING (CWE-775): [#def69]
> > > multipath-tools-0.11.1/libmultipath/sysfs.c:309:22: warning[-
> > > Wanalyzer-fd-leak]: leak of file descriptor =E2=80=98open(&pathbuf, 0=
)=E2=80=99
> >=20
> > Again, false positive; there's a cleanup function for fd.
> >=20
> > > Error: GCC_ANALYZER_WARNING (CWE-775): [#def71]
> > > multipath-tools-0.11.1/libmultipath/valid.c:208:34: warning[-
> > > Wanalyzer-file-leak]: leak of FILE =E2=80=98fopen(&mountinfo, "r")=E2=
=80=99
> >=20
> > False positive, gcc doesn't understand the cleanup_fclose().
> > Same for the next error.
> >=20
> > > Error: GCC_ANALYZER_WARNING (CWE-415): [#def73]
> > > multipath-tools-0.11.1/multipathd/fpin_handlers.c:508:17:
> > > warning[-Wanalyzer-double-free]: double-=E2=80=98free=E2=80=99 of
> > > =E2=80=98els_marginal_list_head.next + -2056=E2=80=99
> >=20
> > I don't see an error in this code. Looks like another false
> > positive to me.
> >=20
> > > Error: GCC_ANALYZER_WARNING: [#def74]
> > > multipath-tools-0.11.1/multipathd/fpin_handlers.c:624:23:
> > > warning[-Wanalyzer-fd-use-without-check]: =E2=80=98read=E2=80=99 on p=
ossibly
> > > invalid file descriptor =E2=80=98fd=E2=80=99
> >=20
> > False positive, too. fd =3D=3D -1 is checked beforehand.
> >=20
> > > Error: GCC_ANALYZER_WARNING (CWE-688): [#def75]
> > > multipath-tools-0.11.1/multipathd/main.c:3286:21: warning[-
> > > Wanalyzer-null-argument]: use of NULL =E2=80=98new=E2=80=99 where non=
-null
> > > expected
> >=20
> > Similar to other false positives above, VECTOR_SLOT() won't return
> > NULL in a=C2=A0 loop like this.
> >=20
> > > Error: GCC_ANALYZER_WARNING (CWE-775): [#def77]
> > > multipath-tools-0.11.1/multipathd/main.c:3973:12: warning[-
> > > Wanalyzer-fd-leak]: leak of file descriptor
> > > =E2=80=98dup2(open("/dev/null", 2), 0)=E2=80=99
> >=20
> > Yet another false positive, the fd is closed in the cleanup
> > handler. Same for the next 3 errors.
> >=20
> > > Error: GCC_ANALYZER_WARNING (CWE-476): [#def81]
> > multipath-tools-0.11.1/multipathd/multipathc.c:97:30: warning[-
> > Wanalyzer-null-dereference]: dereference of NULL =E2=80=98kw=E2=80=99
> >=20
> > Another case of VECTOR_SLOT() false positive. Same for the next
> > error.
> >=20
> > Regards
> > Martin
> >=20
> > Martin Wilck (6):
> > =C2=A0 kpartx_id: fix shellcheck reported errors
> > =C2=A0 kpartx: fix file descriptor leak
> > =C2=A0 libmpathpersist: fix memory leak in mpath_prout_rel()
> > =C2=A0 libmpathutil: silence compiler warning in vector_del_slot()
> > =C2=A0 libmultipath: fix undefined behavior in 31-bit shift
> > =C2=A0 libmultipath: prioritizers/iet: fix possible NULL dereference
> >=20
> > =C2=A0kpartx/kpartx.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | =
14 +++++++-------
> > =C2=A0kpartx/kpartx_id=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 =
8 ++++----
> > =C2=A0libmpathpersist/mpath_persist_int.c | 12 ++++++------
> > =C2=A0libmpathutil/vector.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 16 ++++++++--------
> > =C2=A0libmultipath/nvme/nvme-ioctl.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=
=A0 2 +-
> > =C2=A0libmultipath/prioritizers/iet.c=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 3=
 +++
> > =C2=A06 files changed, 29 insertions(+), 26 deletions(-)
> >=20
> > --=20
> > 2.49.0
