Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D5E3126B8
	for <dm-devel@lists.linux.dev>; Thu, 11 Dec 2025 16:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765471811; cv=none; b=ZjV6E0AfK2AzgFhW0v3rum08HVmKZUJJISkIP0GmDl8447kUTQzaMryLw1FwAkSUwiSim2FmCmSfkCG+TVsTf+wBpN3oaTZxuDLLp61XfFlDWVOPix7Qz5QG4fZQ0w7NqfmH8AdFTc9dRmMNvoSlKCKUH2xwmpKaVMAnIp3vDKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765471811; c=relaxed/simple;
	bh=hh2Eq4xtoglhfGeE+Ts2/QWV6Q4lFav84ZWVjDBrdFw=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=uAg2EikZTvLjqxtRa5/CAsydeFopIrDA/FgPGteMGMiQqQX6wyLM5hnaD9cV7yLFH8UtYUWaQOx+WkLcceATiAU/+Bhr3ePBHG1IBcoOefc7EkCCyzAQMi46CPh75r9UYASHlRfT2bzdgi3ssXsku2LkCVLFgq+BtssbTkDpiaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=f8tlSSNC; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="f8tlSSNC"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2958db8ae4fso3162085ad.2
        for <dm-devel@lists.linux.dev>; Thu, 11 Dec 2025 08:50:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1765471808; x=1766076608; darn=lists.linux.dev;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WnQASF6y2M0oPtXph4fczeBceJWE5kIvQ8IATHAkab8=;
        b=f8tlSSNCZ9QnSr0+kLQTknaPADx7iAWJfwRExyu8LkTm/VJh72Ea17vPtnJgCP+3Vc
         RJ9n1NbdWwah/gz3ctUGG2dOucVty2GeeEum3l8CD4oXMhLF3lsXJcBiG3Wl8mnuJKE3
         nQ5pk8aVNJ8xXpDNK7oZ1dCTUNYH4yAN1Uvr6MJT4uRn2253hAOSPe9LAZL5hhDbr6V8
         NWzuZQlDPoWqmgBNplvpQoHZFIgopkia5zSEWG/o0evEYLb5vaabBPZqcvVd3qsZohos
         rVoCabZnSVWNt+XJbulp9QY1+1yuNoNCZvvvUxqG8khd5vc5UkPX6rMVLppPEzugXS4a
         HmHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765471808; x=1766076608;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WnQASF6y2M0oPtXph4fczeBceJWE5kIvQ8IATHAkab8=;
        b=PcqjNZC3KPNq8NFNi93P0wkPRSFVNAkMafGOhQ0/JerT1nY4JbnxgBMiQ7Sfx/ibAC
         IFDS4p8KTivknPxijUqqFsVn7UNkyQExDXaGgIEV8AODKDBeFhn/JJVEfETrP0OxmjYG
         /dAZIABQaz0kY+BcpmJxXJBdUaW22fUvfkiQWed6xeA1xkIAIwh7pu18T74Irgh7DWwh
         uhBJ1Lox3AvUHKIDh5m9h2KgUDW6x7eWvWcIlICeuPou3H4AdfLMsiNR7cdPr3PkP2KA
         51pKZtm68L+tsQjdXCHV+mORYB1LklNz8IkcZ5gR/K3M17AK7mXPZwI91ohkxzApF1BT
         l8yg==
X-Gm-Message-State: AOJu0YxVDhCYrvF4G9/djD6IhQ/Am6Ug2E+GAslbFRTvCiZYh0DYpGY7
	wMvQ6rle+J+ZJ56wPCej5b9m47Fot4pqEnSSCenfp9tQW2WG7mMjdqhisIRv2LnNvug=
X-Gm-Gg: AY/fxX5IPjWHMR1KghCPgYn+nfLPtNqpqd+xxEcfDa40Uzveu14r3VLk1ABlPwtF3fZ
	RBPXlcKQ+Gf77UekyUj5FKMtqLbQreMBNie0xBdtfnedFMaPiwIe3nD4ST2reCtC8SLXsnVYeNB
	Vu0AytOGnalFOszpnEWB2DbJLN+rT3UCHHyH4NrJIG9MLuS9+ByVt3yDwJYIdyaaVuB7usntKpf
	h3t7xFOjPtx8yzPzeyUWYmH9zSGLLJaKrm1lPg6E8WR/3oMogd8L3PIQKNgWuWAbiGNk2F9AaLv
	//PjbT08q7AM2ecUCJeyCSBYC+sAn4/hZ0OsLHfD2C8ZaqVQgAPs5Nj4ASvJ7XxjMzPBBLWuU1T
	obNWP7CNtNdeYVXM4qiyeT5GRYqgnHuztxyzxCYCv/Mdhjrds57iED7aF+Ag1CNmdT8ZckjkKV0
	W1gNUQKu82ftVXXw1LmTX0/dNQmD5X4zc71vMskv5Z3rsiyEVSt7qYyVA7CUnCJMLASjM4M1yUZ
	rZH7iA255823sgtaA==
X-Google-Smtp-Source: AGHT+IHy0ZjFBHj7Yl7HI7lhe4DyJyuHjR5lWcyl7r9/jFrA8RhPD4BoDhXc7YrXlAkmzzEIe84EOQ==
X-Received: by 2002:a05:7301:4244:b0:2a4:3593:ddf4 with SMTP id 5a478bee46e88-2ac05626495mr2872928eec.33.1765471807699;
        Thu, 11 Dec 2025 08:50:07 -0800 (PST)
Received: from smtpclient.apple ([136.226.79.78])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ac190d3d14sm6777313eec.2.2025.12.11.08.50.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Dec 2025 08:50:06 -0800 (PST)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.200.81.1.6\))
Subject: Re: [PATCH v4] mulitpath-tools Add purge capability to
 multipath-tools
From: Brian Bunker <brian@purestorage.com>
In-Reply-To: <aToWKsaA0hdePsoJ@redhat.com>
Date: Thu, 11 Dec 2025 08:49:54 -0800
Cc: dm-devel@lists.linux.dev,
 mwilck@suse.com,
 Krishna Kant <krishna.kant@purestorage.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <88DF0A70-E860-4D42-9CED-2731496C7B90@purestorage.com>
References: <20251209174342.86044-1-brian@purestorage.com>
 <aToWKsaA0hdePsoJ@redhat.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
X-Mailer: Apple Mail (2.3864.200.81.1.6)


>=20
> On Dec 10, 2025, at 4:54=E2=80=AFPM, Benjamin Marzinski =
<bmarzins@redhat.com> wrote:
>=20
> On Tue, Dec 09, 2025 at 09:43:42AM -0800, Brian Bunker wrote:
>> In the Linux kernel when volumes are disconnected, they are left =
behind
>> to be re-enabled when the connection comes back. There are many cases
>> where this behavior is not desirable.
>>=20
>> The goal is to have paths appear when volumes are connected. This is
>> handled by target initiated rescans and posting of unit attentions.
>> Secondarily when volumes are disconnected at the target, paths should
>> be removed.
>>=20
>> This was discussed here in a kernel patch:
>> https://marc.info/?l=3Dlinux-scsi&m=3D164426722617834&w=3D2
>>=20
>> It was suggested there that userspace would be more advantageous in
>> handling the device removal.
>>=20
>> An option was added to multipath-tools to purge devices that are
>> disconnected at the target. A purge thread was implemented to handle
>> the device removal when the path returns sense data (0x5/0x25/0x0) =
from
>> the path checker. The option, purge_disconnected, is by default off =
but
>> can be turned on by setting it to true.
>>=20
>> When enabled multipathd will log:
>> Dec  4 16:25:54 init110-14 multipathd[1024]: sdmp: purging =
disconnected
>> path
>> ...
>> Dec  4 16:25:54 init110-14 multipathd[1024]: /dev/sdmp: triggered
>> removal
>>=20
>> Signed-off-by: Brian Bunker <brian@purestorage.com>
>> Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
>> ---
>=20
> FYI, when Martin asked "No v1->v2 changelog?" in his reply to your v2
> patch, he was wondering if you could include a short description of =
the
> changes between the previous version of the patch and that one. These
> often go in the cover letter, but if you don't send multiples patches
> with a 0/X cover letter, you can include a changelog after the --- =
line
> above (right where this comment is). Text between the three-dash line
> and the start of the diffs doesn't get included in the commit message,
> so it's useful for things like changelogs and diffstats.
>=20
> See =
https://lore.kernel.org/dm-devel/2f31c96fa6733d4f24315bdf109b649642b26ae1.=
camel@suse.com/T/#mbe572fdeb938d408533eca3bfd22bf8101c95467
>=20
> for an example.

Thanks.
>=20
>> libmultipath/checkers.c       |   2 +
>> libmultipath/checkers.h       |   2 +
>> libmultipath/checkers/tur.c   |  10 ++
>> libmultipath/config.c         |   2 +
>> libmultipath/config.h         |   3 +
>> libmultipath/configure.c      |   1 +
>> libmultipath/defaults.h       |   1 +
>> libmultipath/dict.c           |  14 ++
>> libmultipath/discovery.c      |   3 +-
>> libmultipath/io_err_stat.c    |   1 +
>> libmultipath/print.c          |   2 +
>> libmultipath/propsel.c        |  16 +++
>> libmultipath/propsel.h        |   1 +
>> libmultipath/structs.h        |   8 ++
>> libmultipath/sysfs.c          |   2 +-
>> multipath/multipath.conf.5.in |  22 +++
>> multipathd/main.c             | 243 =
+++++++++++++++++++++++++++++++++-
>> 17 files changed, 325 insertions(+), 8 deletions(-)
>>=20
>> diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
>> index e2eda58d..bb6ad1ee 100644
>> --- a/libmultipath/checkers.c
>> +++ b/libmultipath/checkers.c
>> @@ -43,6 +43,7 @@ static const char =
*checker_state_names[PATH_MAX_STATE] =3D {
>> [PATH_TIMEOUT] =3D "timeout",
>> [PATH_REMOVED] =3D "removed",
>> [PATH_DELAYED] =3D "delayed",
>> + [PATH_DISCONNECTED] =3D "disconnected",
>> };
>>=20
>> static LIST_HEAD(checkers);
>> @@ -363,6 +364,7 @@ static const char =
*generic_msg[CHECKER_GENERIC_MSGTABLE_SIZE] =3D {
>> [CHECKER_MSGID_DOWN] =3D " reports path is down",
>> [CHECKER_MSGID_GHOST] =3D " reports path is ghost",
>> [CHECKER_MSGID_UNSUPPORTED] =3D " doesn't support this device",
>> + [CHECKER_MSGID_DISCONNECTED] =3D " no access to this device",
>> };
>>=20
>> const char *checker_message(const struct checker *c)
>> diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
>> index da91f499..903c3ebe 100644
>> --- a/libmultipath/checkers.h
>> +++ b/libmultipath/checkers.h
>> @@ -78,6 +78,7 @@ enum path_check_state {
>> PATH_TIMEOUT,
>> PATH_REMOVED,
>> PATH_DELAYED,
>> + PATH_DISCONNECTED,
>> PATH_MAX_STATE
>> };
>>=20
>> @@ -113,6 +114,7 @@ enum {
>> CHECKER_MSGID_DOWN,
>> CHECKER_MSGID_GHOST,
>> CHECKER_MSGID_UNSUPPORTED,
>> + CHECKER_MSGID_DISCONNECTED,
>> CHECKER_GENERIC_MSGTABLE_SIZE,
>> CHECKER_FIRST_MSGID =3D 100, /* lowest msgid for checkers */
>> CHECKER_MSGTABLE_SIZE =3D 100, /* max msg table size for checkers */
>> diff --git a/libmultipath/checkers/tur.c =
b/libmultipath/checkers/tur.c
>> index 0010acf8..1bb9a992 100644
>> --- a/libmultipath/checkers/tur.c
>> +++ b/libmultipath/checkers/tur.c
>> @@ -199,6 +199,16 @@ retry:
>> return PATH_PENDING;
>> }
>> }
>> + else if (key =3D=3D 0x5) {
>> + /* Illegal request */
>> + if (asc =3D=3D 0x25 && ascq =3D=3D 0x00) {
>> + /*
>> +  * LOGICAL UNIT NOT SUPPORTED
>> +  */
>> + *msgid =3D CHECKER_MSGID_DISCONNECTED;
>> + return PATH_DISCONNECTED;
>> + }
>> + }
>> *msgid =3D CHECKER_MSGID_DOWN;
>> return PATH_DOWN;
>> }
>> diff --git a/libmultipath/config.c b/libmultipath/config.c
>> index 8b424d18..2c66a788 100644
>> --- a/libmultipath/config.c
>> +++ b/libmultipath/config.c
>> @@ -470,6 +470,7 @@ merge_hwe (struct hwentry * dst, struct hwentry * =
src)
>> merge_num(marginal_path_err_rate_threshold);
>> merge_num(marginal_path_err_recheck_gap_time);
>> merge_num(marginal_path_double_failed_time);
>> + merge_num(purge_disconnected);
>>=20
>> snprintf(id, sizeof(id), "%s/%s", dst->vendor, dst->product);
>> reconcile_features_with_options(id, &dst->features,
>> @@ -517,6 +518,7 @@ merge_mpe(struct mpentry *dst, struct mpentry =
*src)
>> merge_num(skip_kpartx);
>> merge_num(max_sectors_kb);
>> merge_num(ghost_delay);
>> + merge_num(purge_disconnected);
>> merge_num(uid);
>> merge_num(gid);
>> merge_num(mode);
>> diff --git a/libmultipath/config.h b/libmultipath/config.h
>> index 5b4ebf8c..618fa572 100644
>> --- a/libmultipath/config.h
>> +++ b/libmultipath/config.h
>> @@ -88,6 +88,7 @@ struct hwentry {
>> int marginal_path_err_rate_threshold;
>> int marginal_path_err_recheck_gap_time;
>> int marginal_path_double_failed_time;
>> + int purge_disconnected;
>> int skip_kpartx;
>> int max_sectors_kb;
>> int ghost_delay;
>> @@ -130,6 +131,7 @@ struct mpentry {
>> int marginal_path_err_rate_threshold;
>> int marginal_path_err_recheck_gap_time;
>> int marginal_path_double_failed_time;
>> + int purge_disconnected;
>> int skip_kpartx;
>> int max_sectors_kb;
>> int ghost_delay;
>> @@ -188,6 +190,7 @@ struct config {
>> int marginal_path_err_rate_threshold;
>> int marginal_path_err_recheck_gap_time;
>> int marginal_path_double_failed_time;
>> + int purge_disconnected;
>> int uxsock_timeout;
>> int strict_timing;
>> int retrigger_tries;
>> diff --git a/libmultipath/configure.c b/libmultipath/configure.c
>> index baa13573..e4431d2f 100644
>> --- a/libmultipath/configure.c
>> +++ b/libmultipath/configure.c
>> @@ -355,6 +355,7 @@ int setup_map(struct multipath *mpp, char =
**params, struct vectors *vecs)
>> select_max_sectors_kb(conf, mpp);
>> select_ghost_delay(conf, mpp);
>> select_flush_on_last_del(conf, mpp);
>> + select_purge_disconnected(conf, mpp);
>>=20
>> sysfs_set_scsi_tmo(conf, mpp);
>> marginal_pathgroups =3D conf->marginal_pathgroups;
>> diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
>> index 134b690a..d80dd7d4 100644
>> --- a/libmultipath/defaults.h
>> +++ b/libmultipath/defaults.h
>> @@ -58,6 +58,7 @@
>> #define DEFAULT_ALL_TG_PT ALL_TG_PT_OFF
>> #define DEFAULT_RECHECK_WWID RECHECK_WWID_OFF
>> #define DEFAULT_AUTO_RESIZE AUTO_RESIZE_NEVER
>> +#define DEFAULT_PURGE_DISCONNECTED PURGE_DISCONNECTED_OFF
>> /* Enable no foreign libraries by default */
>> #define DEFAULT_ENABLE_FOREIGN "NONE"
>>=20
>> diff --git a/libmultipath/dict.c b/libmultipath/dict.c
>> index a06a6138..504b28b5 100644
>> --- a/libmultipath/dict.c
>> +++ b/libmultipath/dict.c
>> @@ -941,6 +941,16 @@ declare_hw_snprint(skip_kpartx, =
print_yes_no_undef)
>> declare_mp_handler(skip_kpartx, set_yes_no_undef)
>> declare_mp_snprint(skip_kpartx, print_yes_no_undef)
>>=20
>> +declare_def_handler(purge_disconnected, set_yes_no_undef)
>> +declare_def_snprint_defint(purge_disconnected, print_yes_no_undef,
>> + DEFAULT_PURGE_DISCONNECTED)
>> +declare_ovr_handler(purge_disconnected, set_yes_no_undef)
>> +declare_ovr_snprint(purge_disconnected, print_yes_no_undef)
>> +declare_hw_handler(purge_disconnected, set_yes_no_undef)
>> +declare_hw_snprint(purge_disconnected, print_yes_no_undef)
>> +declare_mp_handler(purge_disconnected, set_yes_no_undef)
>> +declare_mp_snprint(purge_disconnected, print_yes_no_undef)
>> +
>> declare_def_range_handler(remove_retries, 0, INT_MAX)
>> declare_def_snprint(remove_retries, print_int)
>>=20
>> @@ -2227,6 +2237,7 @@ init_keywords(vector keywords)
>> install_keyword("retrigger_delay", &def_retrigger_delay_handler, =
&snprint_def_retrigger_delay);
>> install_keyword("missing_uev_wait_timeout", =
&def_uev_wait_timeout_handler, &snprint_def_uev_wait_timeout);
>> install_keyword("skip_kpartx", &def_skip_kpartx_handler, =
&snprint_def_skip_kpartx);
>> + install_keyword("purge_disconnected", =
&def_purge_disconnected_handler, &snprint_def_purge_disconnected);
>> install_keyword("disable_changed_wwids", =
&deprecated_disable_changed_wwids_handler, &snprint_deprecated);
>> install_keyword("remove_retries", &def_remove_retries_handler, =
&snprint_def_remove_retries);
>> install_keyword("max_sectors_kb", &def_max_sectors_kb_handler, =
&snprint_def_max_sectors_kb);
>> @@ -2310,6 +2321,7 @@ init_keywords(vector keywords)
>> install_keyword("marginal_path_err_recheck_gap_time", =
&hw_marginal_path_err_recheck_gap_time_handler, =
&snprint_hw_marginal_path_err_recheck_gap_time);
>> install_keyword("marginal_path_double_failed_time", =
&hw_marginal_path_double_failed_time_handler, =
&snprint_hw_marginal_path_double_failed_time);
>> install_keyword("skip_kpartx", &hw_skip_kpartx_handler, =
&snprint_hw_skip_kpartx);
>> + install_keyword("purge_disconnected", =
&hw_purge_disconnected_handler, &snprint_hw_purge_disconnected);
>> install_keyword("max_sectors_kb", &hw_max_sectors_kb_handler, =
&snprint_hw_max_sectors_kb);
>> install_keyword("ghost_delay", &hw_ghost_delay_handler, =
&snprint_hw_ghost_delay);
>> install_keyword("all_tg_pt", &hw_all_tg_pt_handler, =
&snprint_hw_all_tg_pt);
>> @@ -2355,6 +2367,7 @@ init_keywords(vector keywords)
>> install_keyword("marginal_path_double_failed_time", =
&ovr_marginal_path_double_failed_time_handler, =
&snprint_ovr_marginal_path_double_failed_time);
>>=20
>> install_keyword("skip_kpartx", &ovr_skip_kpartx_handler, =
&snprint_ovr_skip_kpartx);
>> + install_keyword("purge_disconnected", =
&ovr_purge_disconnected_handler, &snprint_ovr_purge_disconnected);
>> install_keyword("max_sectors_kb", &ovr_max_sectors_kb_handler, =
&snprint_ovr_max_sectors_kb);
>> install_keyword("ghost_delay", &ovr_ghost_delay_handler, =
&snprint_ovr_ghost_delay);
>> install_keyword("all_tg_pt", &ovr_all_tg_pt_handler, =
&snprint_ovr_all_tg_pt);
>> @@ -2400,6 +2413,7 @@ init_keywords(vector keywords)
>> install_keyword("marginal_path_err_recheck_gap_time", =
&mp_marginal_path_err_recheck_gap_time_handler, =
&snprint_mp_marginal_path_err_recheck_gap_time);
>> install_keyword("marginal_path_double_failed_time", =
&mp_marginal_path_double_failed_time_handler, =
&snprint_mp_marginal_path_double_failed_time);
>> install_keyword("skip_kpartx", &mp_skip_kpartx_handler, =
&snprint_mp_skip_kpartx);
>> + install_keyword("purge_disconnected", =
&mp_purge_disconnected_handler, &snprint_mp_purge_disconnected);
>> install_keyword("max_sectors_kb", &mp_max_sectors_kb_handler, =
&snprint_mp_max_sectors_kb);
>> install_keyword("ghost_delay", &mp_ghost_delay_handler, =
&snprint_mp_ghost_delay);
>> install_sublevel_end();
>> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
>> index 31db8758..46274f3f 100644
>> --- a/libmultipath/discovery.c
>> +++ b/libmultipath/discovery.c
>> @@ -2482,7 +2482,8 @@ int pathinfo(struct path *pp, struct config =
*conf, int mask)
>>     pp->state =3D=3D PATH_UNCHECKED ||
>>     pp->state =3D=3D PATH_WILD)
>> pp->chkrstate =3D pp->state =3D newstate;
>> - if (pp->state =3D=3D PATH_TIMEOUT)
>> + if (pp->state =3D=3D PATH_TIMEOUT ||
>> +     pp->state =3D=3D PATH_DISCONNECTED)
>> pp->state =3D PATH_DOWN;
>> if (pp->state =3D=3D PATH_UP && !pp->size) {
>> condlog(3, "%s: device size is 0, "
>> diff --git a/libmultipath/io_err_stat.c b/libmultipath/io_err_stat.c
>> index 64054c18..acb087b7 100644
>> --- a/libmultipath/io_err_stat.c
>> +++ b/libmultipath/io_err_stat.c
>> @@ -397,6 +397,7 @@ static void account_async_io_state(struct =
io_err_stat_path *pp, int rc)
>> switch (rc) {
>> case PATH_DOWN:
>> case PATH_TIMEOUT:
>> + case PATH_DISCONNECTED:
>> pp->io_err_nr++;
>> break;
>> case PATH_UNCHECKED:
>> diff --git a/libmultipath/print.c b/libmultipath/print.c
>> index 0d44a5a9..8b09b174 100644
>> --- a/libmultipath/print.c
>> +++ b/libmultipath/print.c
>> @@ -541,6 +541,8 @@ snprint_chk_state (struct strbuf *buff, const =
struct path * pp)
>> return append_strbuf_str(buff, "i/o timeout");
>> case PATH_DELAYED:
>> return append_strbuf_str(buff, "delayed");
>> + case PATH_DISCONNECTED:
>> + return append_strbuf_str(buff, "disconnected");
>> default:
>> return append_strbuf_str(buff, "undef");
>> }
>> diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
>> index 4c0fbcf3..9a17f1ed 100644
>> --- a/libmultipath/propsel.c
>> +++ b/libmultipath/propsel.c
>> @@ -1371,6 +1371,22 @@ out:
>> return 0;
>> }
>>=20
>> +int select_purge_disconnected (struct config *conf, struct multipath =
* mp)
>> +{
>> + const char *origin;
>> +
>> + mp_set_mpe(purge_disconnected);
>> + mp_set_ovr(purge_disconnected);
>> + mp_set_hwe(purge_disconnected);
>> + mp_set_conf(purge_disconnected);
>> + mp_set_default(purge_disconnected, DEFAULT_PURGE_DISCONNECTED);
>> +out:
>> + condlog(3, "%s: purge_disconnected =3D %s %s", mp->alias,
>> + (mp->purge_disconnected =3D=3D PURGE_DISCONNECTED_ON)? "yes" : =
"no",
>> + origin);
>> + return 0;
>> +}
>> +
>> int select_max_sectors_kb(struct config *conf, struct multipath * mp)
>> {
>> const char *origin;
>> diff --git a/libmultipath/propsel.h b/libmultipath/propsel.h
>> index 55930050..c6c937c3 100644
>> --- a/libmultipath/propsel.h
>> +++ b/libmultipath/propsel.h
>> @@ -39,6 +39,7 @@ int select_marginal_path_err_rate_threshold(struct =
config *conf, struct multipat
>> int select_marginal_path_err_recheck_gap_time(struct config *conf, =
struct multipath *mp);
>> int select_marginal_path_double_failed_time(struct config *conf, =
struct multipath *mp);
>> int select_ghost_delay(struct config *conf, struct multipath * mp);
>> +int select_purge_disconnected (struct config *conf, struct multipath =
* mp);
>> void reconcile_features_with_options(const char *id, char **features,
>>      int* no_path_retry,
>>      int *retain_hwhandler);
>> diff --git a/libmultipath/structs.h b/libmultipath/structs.h
>> index 9247e74f..2ccdf945 100644
>> --- a/libmultipath/structs.h
>> +++ b/libmultipath/structs.h
>> @@ -186,6 +186,12 @@ enum auto_resize_state {
>> AUTO_RESIZE_GROW_SHRINK,
>> };
>>=20
>> +enum purge_disconnected_states {
>> + PURGE_DISCONNECTED_UNDEF =3D YNU_UNDEF,
>> + PURGE_DISCONNECTED_OFF =3D YNU_NO,
>> + PURGE_DISCONNECTED_ON =3D YNU_YES,
>> +};
>> +
>> #define PROTOCOL_UNSET -1
>>=20
>> enum scsi_protocol {
>> @@ -382,6 +388,7 @@ struct path {
>> int dmstate;
>> int chkrstate;
>> int oldstate;
>> + bool purge_path;
>> int failcount;
>> int priority;
>> int pgindex;
>> @@ -483,6 +490,7 @@ struct multipath {
>> int ghost_delay;
>> int ghost_delay_tick;
>> int queue_mode;
>> + int purge_disconnected;
>> unsigned int sync_tick;
>> int checker_count;
>> enum prio_update_type prio_update;
>> diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
>> index af27d107..538800d8 100644
>> --- a/libmultipath/sysfs.c
>> +++ b/libmultipath/sysfs.c
>> @@ -134,7 +134,7 @@ ssize_t sysfs_attr_set_value(struct udev_device =
*dev, const char *attr_name,
>> size =3D write(fd, value, value_len);
>> if (size < 0) {
>> size =3D -errno;
>> - condlog(3, "%s: write to %s failed: %s", __func__,=20
>> + condlog(3, "%s: write to %s failed: %s", __func__,
>> devpath, strerror(errno));
>> } else if (size < (ssize_t)value_len)
>> condlog(3, "%s: underflow writing %zu bytes to %s. Wrote %zd bytes",
>> diff --git a/multipath/multipath.conf.5.in =
b/multipath/multipath.conf.5.in
>> index 3c9ae097..84cd1a0a 100644
>> --- a/multipath/multipath.conf.5.in
>> +++ b/multipath/multipath.conf.5.in
>> @@ -1306,6 +1306,22 @@ The default is: \fBno\fR
>> .
>> .
>> .TP
>> +.B purge_disconnected
>> +If set to
>> +.I yes
>> +, multipathd will automatically remove devices that are in a =
disconnected state.
>> +A path is considered disconnected when the TUR (Test Unit Ready) =
path checker
>> +receives the SCSI sense code "LOGICAL UNIT NOT SUPPORTED" (sense key =
0x5,
>> +ASC/ASCQ 0x25/0x00). This typically indicates that the LUN has been =
unmapped
>> +or is no longer presented by the storage array. This option helps =
clean up
>> +stale device entries that would otherwise remain in the system.
>> +.RS
>> +.TP
>> +The default is: \fBno\fR
>> +.RE
>> +.
>> +.
>> +.TP
>> .B disable_changed_wwids
>> (Deprecated) This option is not supported anymore, and will be =
ignored.
>> .RE
>> @@ -1602,6 +1618,8 @@ section:
>> .TP
>> .B skip_kpartx
>> .TP
>> +.B purge_disconnected
>> +.TP
>> .B max_sectors_kb
>> .TP
>> .B ghost_delay
>> @@ -1797,6 +1815,8 @@ section:
>> .TP
>> .B skip_kpartx
>> .TP
>> +.B purge_disconnected
>> +.TP
>> .B max_sectors_kb
>> .TP
>> .B ghost_delay
>> @@ -1881,6 +1901,8 @@ the values are taken from the \fIdevices\fR or =
\fIdefaults\fR sections:
>> .TP
>> .B skip_kpartx
>> .TP
>> +.B purge_disconnected
>> +.TP
>> .B max_sectors_kb
>> .TP
>> .B ghost_delay
>> diff --git a/multipathd/main.c b/multipathd/main.c
>> index d11a8576..ce5040e0 100644
>> --- a/multipathd/main.c
>> +++ b/multipathd/main.c
>> @@ -137,11 +137,14 @@ static enum force_reload_types =
reconfigure_pending =3D FORCE_RELOAD_NONE;
>> pid_t daemon_pid;
>> static pthread_mutex_t config_lock =3D PTHREAD_MUTEX_INITIALIZER;
>> static pthread_cond_t config_cond;
>> -static pthread_t check_thr, uevent_thr, uxlsnr_thr, uevq_thr, =
dmevent_thr,
>> - fpin_thr, fpin_consumer_thr;
>> -static bool check_thr_started, uevent_thr_started, =
uxlsnr_thr_started,
>> - uevq_thr_started, dmevent_thr_started, fpin_thr_started,
>> - fpin_consumer_thr_started;
>> +static pthread_mutex_t purge_mutex =3D PTHREAD_MUTEX_INITIALIZER;
>> +static pthread_cond_t purge_cond =3D PTHREAD_COND_INITIALIZER;
>> +int devices_to_purge =3D 0;
>> +static pthread_t check_thr, purge_thr, uevent_thr, uxlsnr_thr, =
uevq_thr,
>> + dmevent_thr, fpin_thr, fpin_consumer_thr;
>> +static bool check_thr_started, purge_thr_started, =
uevent_thr_started,
>> + uxlsnr_thr_started, uevq_thr_started, dmevent_thr_started,
>> + fpin_thr_started, fpin_consumer_thr_started;
>> static int pid_fd =3D -1;
>>=20
>> static inline enum daemon_status get_running_state(bool =
*pending_reconfig)
>> @@ -1089,6 +1092,99 @@ check_path_wwid_change(struct path *pp)
>> return false;
>> }
>>=20
>> +/*
>> + * Information needed to delete a path via sysfs, copied while =
holding the lock
>> + * so that the actual sysfs write can be done without holding =
vecs->lock.
>> + *
>> + * The duplicated fd prevents the kernel from reusing the device =
name/H:C:T:L
>> + * even if the device is removed and a new one appears.
>> + */
>> +struct purge_path_info {
>> + struct udev_device *udev;  /* Reference to udev device (refcounted) =
*/
>> + int fd;                    /* Duplicated fd to prevent device reuse =
*/
>> +};
>> +
>> +/*
>> + * Attempt to delete a path by writing to the SCSI device's sysfs =
delete attribute.
>> + * This triggers kernel-level device removal. The actual cleanup of =
the path structure
>> + * from pathvec happens later when a uevent arrives (handled by =
uev_remove_path).
>> + *
>> + * This function does NOT require vecs->lock to be held, as it =
operates on copied data.
>> + * This function may block while writing to sysfs, which is why it's =
called without
>> + * holding any locks.
>> + */
>=20
> nitpick: Could you please wrap these comments to 80 characters. The
> multipath code isn't super standardized, but all things being equal,
> it's nice to keep the lines to 80 characters.
>=20
> If you'd like to make sure your patch is formatted in the way that we
> are slowly nudging the codebase towards, you can run "git =
clang-format"
> on your commit. It will clean up those comments and make some other
> small formating changes.

I have made these changes. I think we usually shoot for 100 so there
were definitely a few places I ran over.
>=20
>=20
>> +static void
>> +delete_path_sysfs(struct purge_path_info *info)
>> +{
>> + struct udev_device *ud;
>> + const char *devname;
>> +
>> + if (!info->udev)
>> + return;
>> +
>> + devname =3D udev_device_get_devnode(info->udev);
>> + ud =3D udev_device_get_parent_with_subsystem_devtype(info->udev,
>> + "scsi", "scsi_device");
>> +
>> + if (!ud) {
>> + condlog(3, "%s: no SCSI parent device found", devname);
>> + return;
>> + }
>> +
>> + if (sysfs_attr_set_value(ud, "delete", "1", strlen("1")) < 0)
>=20
> Could you use "purge" instead of "delete" or "removal" just to make
> the log message more obvious when it appears.

Yes I have made these changes.
>=20
>> + condlog(3, "%s: failed to delete", devname);
>> + else
>> + condlog(2, "%s: triggered removal", devname);
>> +}
>> +
>> +/*
>> + * Prepare purge info for a path while holding vecs->lock.
>> + * Takes a reference on the udev device and duplicates the fd if =
available.
>> + * The duplicated fd prevents the kernel from reusing the device, =
but if
>> + * we can't get one (device already disconnected), we proceed anyway =
since
>> + * reuse is unlikely in that case.
>> + * Returns true if info was successfully prepared, false otherwise.
>> + */
>> +static bool
>> +prepare_purge_path_info(struct path *pp, struct purge_path_info =
*info)
>> +{
>> + if (!pp->udev || !pp->mpp)
>> + return false;
>> +
>> + info->udev =3D udev_device_ref(pp->udev);
>> + if (!info->udev)
>> + return false;
>> +
>> + /* Try to dup the fd if available, but don't fail if we can't */
>> + if (pp->fd >=3D 0) {
>> + info->fd =3D dup(pp->fd);
>> + if (info->fd < 0)
>> + condlog(4, "%s: failed to dup fd: %s (proceeding anyway)",
>> + pp->dev, strerror(errno));
>> + }
>=20
> Is dup() really failing here for you? I though that as long as pp->fd
> was a real file descriptor and the process hadn't reached it's limit =
of
> open file descriptors, dup() wouldn't fail unless you had some real =
bad
> kernel memory problems. If you really are seeing failures duping the =
fd
> of a disconnected SCSI device, that would be interesting. If you're =
not
> actually seeing dup fail here with your disconnected paths, I think I
> would rather call dup() failing an error, and return false.

No. This was based on my best guess of what the failure case would
be. I have changed this too.
>=20
>> +
>> + return true;
>> +}
>> +
>> +/*
>> + * Clean up purge info after use.
>> + * This must be usable as a pthread cleanup handler.
>> + */
>> +static void
>> +cleanup_purge_path_info(void *arg)
>> +{
>> + struct purge_path_info *info =3D arg;
>> +
>> + if (info->fd >=3D 0) {
>> + close(info->fd);
>> + info->fd =3D -1;
>> + }
>> + if (info->udev) {
>> + udev_device_unref(info->udev);
>> + info->udev =3D NULL;
>> + }
>> +}
>> +
>> /*
>>  * uev_add_path can call uev_update_path, and uev_update_path can =
call
>>  * uev_add_path
>> @@ -2031,6 +2127,8 @@ reinstate_path (struct path * pp)
>> condlog(0, "%s: reinstate failed", pp->dev_t);
>> else {
>> condlog(2, "%s: reinstated", pp->dev_t);
>> + if (pp->purge_path)
>> + pp->purge_path =3D false;
>> update_queue_mode_add_path(pp->mpp);
>> }
>> }
>> @@ -2474,6 +2572,20 @@ get_new_state(struct path *pp)
>> if (newstate =3D=3D PATH_REMOVED)
>> newstate =3D PATH_DOWN;
>>=20
>> + /*
>> +  * For PATH_DISOCONNECTED mark the path as OK to purge if that is
>> +  * enabled. Whether or not purge is enabled mark the path as down.
>> +  */
>> + if (newstate =3D=3D PATH_DISCONNECTED) {
>> + if (pp->mpp->purge_disconnected =3D=3D PURGE_DISCONNECTED_ON &&
>> +     !pp->purge_path) {
>> + condlog(2, "%s: mark (%s) path for purge",
>> + pp->dev, checker_state_name(newstate));
>> + pp->purge_path =3D true;
>> + }
>> + newstate =3D PATH_DOWN;
>> + }
>> +
>=20
> There are a number of cases where we do not immediately reinstate =
paths
> that are usable. But we should cancel any pending purges as soon as we
> notice that the path is not longer disconnected, instead of in
> reinstate_path().
>=20
> Here's another thought. If a path ever goes into PATH_DISCONNECTED, we
> probably want to force a wwid recheck if it ever comes back, even if =
we
> don't purge it.  Possibly we could rename pp->purge_path to
> pp->disconnected, and make it an enum with values like
>=20
> NOT_DICONNECTED
> DISCONNECTED_NO_PURGE
> DISCONNECTED_NEEDS_PURGE

I like this idea. I have added the enum. It makes the decisions about
what to do when things fail easy to distinguish between the original
state and some step in the purge process.
>=20
> That way, even if mpp->purge_disconnected is not set, we could still
> flag the path as disconnected. In the code to check
> if we should call check_path_wwid_change() in update_path_state(),
> we could then have the first part of that check be
>=20
> if ((pp->recheck_wwid =3D=3D RECHECK_WWID_ON ||
>     pp->disconnected !=3D NOT_DICONNECTED) && ...
>=20
> so that we enforce a wwid_recheck of a path that was disconnected.  =
For
> this to work, the above code would set paths in PATH_DISCONNECTED
> to DISCONNECTED_NEEDS_PURGE or DISCONNECTED_NO_PURGE depending on
> pp->mpp->purge_disconnected. If the path wasn't in PATH_DISCONNECTED,
> but pp->disconnected was set to DISCONNECTED_NEEDS_PURGE, it would
> change pp->disconnected to DISCONNECTED_NO_PURGE, so that that path
> wouldn't get purged.
>=20
> Paths in DISCONNECTED_NO_PURGE would get changed back to =
NOT_DICONNECTED
> once check_path_wwid_change() was called on them (that call would need
> to be broken out of the large if statement in update_path_state)
>=20
> Thoughts? That can also go in as a later patch.

I am not sure that recheck_wwid comes into play with what I am doing.
Not that it doesn=E2=80=99t still happen. It still does. With the =
disconnected state
not affecting the path state, I don=E2=80=99t think any extra logic is =
required. The
disconnected state puts the path state to PATH_DOWN. There aren=E2=80=99t
any extra situations are there where recheck_wwid is needed except
after coming out of PATH_DOWN right? It happens with or without=20
disconnected in play, doesn=E2=80=99t it? Am I missing something?

I will add the recheck_wwid in the reinstate_path case though if that
is a place PATH_DOWN could return to PATH_UP.
>=20
>> if (newstate =3D=3D PATH_WILD || newstate =3D=3D PATH_UNCHECKED) {
>> condlog(2, "%s: unusable path (%s) - checker failed",
>> pp->dev, checker_state_name(newstate));
>> @@ -3022,6 +3134,21 @@ update_paths(struct vectors *vecs, int =
*num_paths_p, time_t start_secs)
>> return CHECKER_FINISHED;
>> }
>>=20
>> +/*
>> + * Check if there are paths marked for purging.
>> + */
>> +static bool
>> +has_paths_to_purge(struct vectors *vecs)
>> +{
>> + int i;
>> + struct path *pp;
>> +
>> + vector_foreach_slot(vecs->pathvec, pp, i)
>> + if (pp->purge_path)
>> + return true;
>> + return false;
>> +}
>> +
>> static void enable_pathgroups(struct multipath *mpp)
>> {
>> struct pathgroup *pgp;
>> @@ -3125,6 +3252,7 @@ checkerloop (void *ap)
>> int num_paths =3D 0, strict_timing;
>> unsigned int ticks =3D 0;
>> enum checker_state checker_state =3D CHECKER_STARTING;
>> + bool devs_to_purge =3D false;
>>=20
>> if (set_config_state(DAEMON_RUNNING) !=3D DAEMON_RUNNING)
>> /* daemon shutdown */
>> @@ -3168,8 +3296,10 @@ checkerloop (void *ap)
>> if (checker_state =3D=3D CHECKER_UPDATING_PATHS)
>> checker_state =3D update_paths(vecs, &num_paths,
>>      start_time.tv_sec);
>> - if (checker_state =3D=3D CHECKER_FINISHED)
>> + if (checker_state =3D=3D CHECKER_FINISHED) {
>> + devs_to_purge =3D has_paths_to_purge(vecs);
>> checker_finished(vecs, ticks);
>> + }
>> lock_cleanup_pop(vecs->lock);
>> }
>>=20
>> @@ -3192,6 +3322,13 @@ checkerloop (void *ap)
>> (long)diff_time.tv_sec);
>> }
>>=20
>> + if (devs_to_purge) {
>> + pthread_mutex_lock(&purge_mutex);
>> + devices_to_purge =3D 1;
>> + pthread_cond_signal(&purge_cond);
>> + pthread_mutex_unlock(&purge_mutex);
>> + }
>> +
>> if (foreign_tick =3D=3D 0) {
>> conf =3D get_multipath_config();
>> foreign_tick =3D conf->max_checkint;
>> @@ -3229,6 +3366,91 @@ checkerloop (void *ap)
>> return NULL;
>> }
>>=20
>> +/*
>> + * Purge thread: removes disconnected paths by writing to sysfs.
>> + *
>> + * This thread is signaled by the checker thread when paths marked =
with
>> + * purge_path=3Dtrue are detected. It attempts to delete these paths =
by
>> + * writing "1" to their SCSI device's sysfs "delete" attribute.
>> + *
>> + * The actual cleanup of path structures from pathvec happens =
asynchronously
>> + * when the kernel sends a remove uevent (handled by =
uev_remove_path).
>> + *
>> + * To avoid holding vecs->lock for extended periods and starving =
other threads,
>> + * this function processes one path at a time: lock -> find one path =
-> clear flag ->
>> + * unlock -> delete -> repeat. If no paths need purging, it waits =
for a signal.
>> + */
>> +static void *
>> +purgeloop (void *ap)
>> +{
>> + struct vectors *vecs;
>> + unsigned int i;
>> + struct path *pp;
>> + vecs =3D (struct vectors *)ap;
>> +
>> + pthread_cleanup_push(rcu_unregister, NULL);
>> + rcu_register_thread();
>> + mlockall(MCL_CURRENT | MCL_FUTURE);
>> +
>> + while (1) {
>> + struct purge_path_info purge_info =3D { .udev =3D NULL, .fd =3D -1 =
};
>> + bool found =3D false;
>> +
>> + /*
>> +  * Lock and search for one path that needs purging.
>> +  * Copy the necessary info while holding the lock, then
>> +  * release the lock before doing any blocking sysfs operations.
>> +  */
>> + pthread_cleanup_push(cleanup_lock, &vecs->lock);
>> + lock(&vecs->lock);
>> + pthread_testcancel();
>> +
>> + vector_foreach_slot (vecs->pathvec, pp, i) {
>> + if (!pp->purge_path)
>> + continue;
>> +
>> + /* Found a path to purge */
>> + if (prepare_purge_path_info(pp, &purge_info)) {
>> + pp->purge_path =3D false;
>> + found =3D true;
>> + condlog(2, "%s: purging disconnected path", pp->dev);
>> + } else {
>> + condlog(3, "%s: failed to prepare purge info", pp->dev);
>> + }
>> + break;
>=20
> If you fail to prepare the purge_info, you should keep looking through
> the pathvec instead of exitting early. Otherwise you will end up =
waiting
> to be signalled from the checkerloop, even if there are other purgable
> paths in the pathvec.
>=20
> Also, if you fail prepare_purge_path_info(), it seems pretty unlikely
> that it will succeed next time, unless something changes. You might as
> well clear pp->purge_path even on the failures, so you don't retry =
that
> path until the next checker cycle re-adds it.

Yes you are correct. A failure case would be caught in a loop. The
enum you suggested earlier helps with this kind of case.
>=20
>> + }
>> +
>> + lock_cleanup_pop(vecs->lock);
>> +
>> + /*
>> +  * Now we've released the lock. Do the sysfs operation
>> +  * without holding vecs->lock. This may block.
>> +  * Use pthread_cleanup_push to ensure purge_info is cleaned up
>> +  * even if the thread is cancelled.
>> +  */
>> + pthread_cleanup_push(cleanup_purge_path_info, &purge_info);
>=20
> I think this is probably safe, but it's safer to move this
> pthread_cleanup_push() to before you push the vecs->lock cleanup
> handler. There's no harm if it triggers before you set the purge_info,
> and it makes sure that there aren't gaps where the thread could be
> cancelled after you set the purge_info.
>=20
> -Ben

I moved it up. Thanks.

>=20
>> + if (found)
>> + delete_path_sysfs(&purge_info);
>> + pthread_cleanup_pop(1);
>> +
>> + /*
>> +  * If we didn't find a path to purge, wait for signal.
>> +  */
>> + if (!found) {
>> + pthread_mutex_lock(&purge_mutex);
>> + while (!devices_to_purge) {
>> + condlog(4, "purgeloop waiting for work");
>> + pthread_cond_wait(&purge_cond, &purge_mutex);
>> + }
>> + devices_to_purge =3D 0;
>> + pthread_mutex_unlock(&purge_mutex);
>> + }
>> + }
>> +
>> + pthread_cleanup_pop(1);
>> + return NULL;
>> +}
>> +
>> static int
>> configure (struct vectors * vecs, enum force_reload_types =
reload_type)
>> {
>> @@ -3669,6 +3891,8 @@ static void cleanup_threads(void)
>>=20
>> if (check_thr_started)
>> pthread_cancel(check_thr);
>> + if (purge_thr_started)
>> + pthread_cancel(purge_thr);
>> if (uevent_thr_started)
>> pthread_cancel(uevent_thr);
>> if (uxlsnr_thr_started)
>> @@ -3685,6 +3909,8 @@ static void cleanup_threads(void)
>>=20
>> if (check_thr_started)
>> pthread_join(check_thr, NULL);
>> + if (purge_thr_started)
>> + pthread_join(purge_thr, NULL);
>> if (uevent_thr_started)
>> pthread_join(uevent_thr, NULL);
>> if (uxlsnr_thr_started)
>> @@ -3937,6 +4163,11 @@ child (__attribute__((unused)) void *param)
>> goto failed;
>> } else
>> check_thr_started =3D true;
>> + if ((rc =3D pthread_create(&purge_thr, &misc_attr, purgeloop, =
vecs))) {
>> + condlog(0,"failed to create purge loop thread: %d", rc);
>> + goto failed;
>> + } else
>> + purge_thr_started =3D true;
>> if ((rc =3D pthread_create(&uevq_thr, &misc_attr, uevqloop, vecs))) {
>> condlog(0, "failed to create uevent dispatcher: %d", rc);
>> goto failed;
>> --=20
>> 2.52.0
I will create a v5 version if you are happy with my responses. I think =
the
only one to get clarity on is the recheck_wwid piece.


