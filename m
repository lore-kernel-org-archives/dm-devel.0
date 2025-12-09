Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192861CAA79
	for <dm-devel@lists.linux.dev>; Tue,  9 Dec 2025 12:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765281697; cv=none; b=pK2mb7id/ctp3Nyaav9Q/sMCEkwdiCzRJTmeok9JPOiM1N4xD4IE/bUhcjXhP52TGJgzhcDm20iyRRL8QITGn6ckqLLwcDzIu+KPVpk4BbJQDrdHU0dacehSoW+n+tiKHDz9BrOCmNEfD4WWWVlcMJWRXqUK9oilxSsSbCLwSYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765281697; c=relaxed/simple;
	bh=MtnL0ObfTk8svvNH84VtnvYfupcXVKsw3EItf/Z5+go=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kLW7sWV2MFvWJsWGwCi541hhKjpmK+MrThUcDsa+UVsSZIPzBkzCgycrn3GvYZfj6xGXsFhXe/lINTo8D4cMIvUFZURdEL9eQeIt38mi6LhVqNJjRDHkr8NPFUU2azWckYfR0IvQ8pCM++fxsA3eoB7iTbLoFBKjvP3yeZZU5Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TpT4JBpe; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TpT4JBpe"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4775895d69cso27733145e9.0
        for <dm-devel@lists.linux.dev>; Tue, 09 Dec 2025 04:01:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765281690; x=1765886490; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KakY+e/nMrAmpU1C14UuBfMCpHdyZR0DqM3GPAa5fts=;
        b=TpT4JBpeRJxR6tFY1ZWhQLiD/cNwKSv6eMkPR2h8VmXhXxSwtYTd5cMpv3VIdn3BAz
         VWlmNTNG1IqPRzHPzJgnVPzd179nVF9XwEXmBF8zmpniUdK5a7/UGJjUvh/yWF9CtLmG
         wOZ1unZtxn5JGld/xxOqG4Jjv1ILhAPkd0KQ54JAHfkrv5nL6AlS/VjF+5cy4kashRwZ
         oyJ5gcATlNfwO91WdHLsrcruH5YS8oDsLLqfcg0+LLzM0CNXD2/oqwHs8YSnyGRqV6xH
         hAEOcNxZkyuQ7+igPp77JvrPwb9kukDSoY+1/Yu9o2IB+69UOAhZT2zzbsQTVXg5EwzF
         kc4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765281690; x=1765886490;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KakY+e/nMrAmpU1C14UuBfMCpHdyZR0DqM3GPAa5fts=;
        b=JLnTNzCnwpl/HddxDBz9acIbDlc5rWKrJzEipMpOGoflDhK8RbSkNZ+Z74J+nc7sDQ
         FZ3JLoEvTICFEZlSPe4GeVqmKcSKwA80TWrpnm/uWiUIw0Nxu99Cblq801sUU+p+87aL
         E4IVe4eUmHBCZOTloIPsD6Ua+Oqeyt2ycbKAQkGq0uiTyA2Lj5J3AnfsnNlBt/vCF5Ep
         aCcUskU725uiAQy0+LxHPW1ShJSIL7i10kQHCTaKVLJ/BX2lt+BvXd/UNPktxIP/kRNg
         ZGJLjcQ5Y0aXdlrZ+M4va0NTFcGxU21FjHkra1LxdJsH9KFTcGH4d2ftmq6ZYpddl8FT
         XX9A==
X-Gm-Message-State: AOJu0Ywnng1CGuaii7dqr36HVwwWhzbV5TSqM8I2njKkD00j1riJ/wis
	A2CxrofGGTbyDlrihwgwplologDoBPlHaXYRwXtUJkRXTzeuJiOg4QctbZAQbXpMnTM=
X-Gm-Gg: ASbGncvN4kWf8nbc/egav2ykELtFFolrGZcO8yGsqZKzybNcPFjpAMyIhYPJSjdNFoX
	rOL4tLVRLXbbAW4iX89wnyqIFJAVOvpfKwvSLjPB8OVTGJZDIBGDL84pXRf3HrxkdqiMm8z3af9
	8ABBs/tSV0LBB7EuRJzHOvz7z6hoKUtF8eBo/f88YBlhIpKxjmFbZ44gQstS9smWMvwAM8h0dDs
	p4COg+Hl26PfYsCU/mYG2c+b7DzVBe0Wc32TGFSObzfPWXisiolV5CW01itWVmzaIHL+2sU1pCR
	sOQI7jZuQxY7oE1EtMqU6WugNKdGnC0FAKkRnJRKbpiCu4apkwdRjM0T2l7vpArxmj3t5Cf1pVz
	t2znkQ7ZkgOmlzKVvWfM/7umOmfO0+vHx0U94GjPoTAR8jv+o40L1dwqNOzoEhin9UEEtjWmZbg
	xlbbTKIi5rV/nJJkmr5PT7YQTUgZX5CEjpwaYJpXGdssLIs095G2kMgMfzHpKhV9und+5c/5KTi
	mfK6LpPhMAHzxJwYhofHZmw0aR5sYA/v3ge8qQWAQRCbdE=
X-Google-Smtp-Source: AGHT+IG1fdZ8Yy5eUTSPyy67Gsp3B86xvnvGFmRmd31xymgahyWxu3I2Z2Ufa7lidoZRIQNSezXipQ==
X-Received: by 2002:a05:600c:1c1f:b0:477:8ba7:fe17 with SMTP id 5b1f17b1804b1-47939df2650mr143833385e9.7.1765281689654;
        Tue, 09 Dec 2025 04:01:29 -0800 (PST)
Received: from ?IPv6:2003:de:373a:d100:7c9:709f:eaee:b67f? (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47a7d6fa0f6sm36115095e9.4.2025.12.09.04.01.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 04:01:29 -0800 (PST)
Message-ID: <2f31c96fa6733d4f24315bdf109b649642b26ae1.camel@suse.com>
Subject: Re: [PATCH v2] libmpathpersist: fix code for skipping multipathd
 path registration
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Tue, 09 Dec 2025 13:01:27 +0100
In-Reply-To: <20251208211238.1710326-1-bmarzins@redhat.com>
References: <20251208211238.1710326-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2025-12-08 at 16:12 -0500, Benjamin Marzinski wrote:
> When libmpathpersist notifies multipathd that a key has been
> registered,
> cli_setprstatus() calls pr_register_active_paths() with a flag to let
> it
> know that the paths are likely already registered, and it can skip
> re-registering them, as long as the number of active paths matches
> the
> number of registered keys. This shortcut can fail, causing multipathd
> to
> not register needed paths, if either a path becomes usable and
> another
> becomes unusable while libmpathpersist is running or if there already
> were registered keys for I_T Nexus's that don't correspond to path
> devices.
>=20
> To make this shortcut work in cases like that, this commit adds a new
> multipathd command "setprstatus map <map> pathlist <pathlist>", where
> <pathlist> is a quoted, comma separated list of scsi path devices.
> libmpathpersist will send out the list of paths it registered the key
> on. pr_register_active_paths() will skip calling
> mpath_pr_event_handle()
> for paths on that list.
>=20
> In order to deal with the possiblity of a preempt occuring while
> libmpathpersist was running, the code still needs to check that it
> has
> the expected number of keys.
>=20
> Fixes: f7d6cd17 ("multipathd: Fix race while registering PR key")
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Minor comments below.

Regards,
Martin



> ---
>=20
> Was patch 4/4 of "multipath-tools: Yet Another PR fix"
> Changes in v2 (assuming we agree to use this patch at all):
> added a semi-colon after the "skip" label to make clang happy.
>=20
> =C2=A0libmpathpersist/mpath_persist_int.c |=C2=A0 6 +--
> =C2=A0libmpathpersist/mpath_updatepr.c=C2=A0=C2=A0=C2=A0 | 48 +++++++++++=
++++++-----
> =C2=A0libmpathpersist/mpathpr.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 |=C2=A0 4 +-
> =C2=A0multipathd/callbacks.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 1 +
> =C2=A0multipathd/cli.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 1 +
> =C2=A0multipathd/cli.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 2 +
> =C2=A0multipathd/cli_handlers.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 | 39 ++++++++++++++++--
> =C2=A0multipathd/main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 62 +++++++++=
++++++++++--------
> --
> =C2=A0multipathd/main.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 3 +-
> =C2=A0multipathd/multipathd.8.in=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 |=C2=A0 6 +++
> =C2=A010 files changed, 133 insertions(+), 39 deletions(-)
>=20
> diff --git a/libmpathpersist/mpath_persist_int.c
> b/libmpathpersist/mpath_persist_int.c
> index 91c53419..14f7ba83 100644
> --- a/libmpathpersist/mpath_persist_int.c
> +++ b/libmpathpersist/mpath_persist_int.c
> @@ -1001,12 +1001,12 @@ int do_mpath_persistent_reserve_out(vector
> curmp, vector pathvec, int fd,
> =C2=A0	case MPATH_PROUT_REG_SA:
> =C2=A0	case MPATH_PROUT_REG_IGN_SA:
> =C2=A0		if (unregistering)
> -			update_prflag(mpp->alias, 0);
> +			update_prflag(mpp, 0);
> =C2=A0		else
> -			update_prflag(mpp->alias, 1);
> +			update_prflag(mpp, 1);
> =C2=A0		break;
> =C2=A0	case MPATH_PROUT_CLEAR_SA:
> -		update_prflag(mpp->alias, 0);
> +		update_prflag(mpp, 0);
> =C2=A0		if (mpp->prkey_source =3D=3D PRKEY_SOURCE_FILE)
> =C2=A0			update_prkey(mpp->alias, 0);
> =C2=A0		break;
> diff --git a/libmpathpersist/mpath_updatepr.c
> b/libmpathpersist/mpath_updatepr.c
> index bd8ed2be..bc9c79e2 100644
> --- a/libmpathpersist/mpath_updatepr.c
> +++ b/libmpathpersist/mpath_updatepr.c
> @@ -20,8 +20,9 @@
> =C2=A0#include "uxsock.h"
> =C2=A0#include "mpathpr.h"
> =C2=A0#include "structs.h"
> +#include "strbuf.h"
> =C2=A0
> -static char *do_pr(char *alias, char *str)
> +static char *do_pr(char *alias, const char *str)
> =C2=A0{
> =C2=A0	int fd;
> =C2=A0	char *reply;
> @@ -51,24 +52,27 @@ static char *do_pr(char *alias, char *str)
> =C2=A0	return reply;
> =C2=A0}
> =C2=A0
> -static int do_update_pr(char *alias, char *cmd, char *key)
> +static int do_update_pr(char *alias, char *cmd, const char *data)
> =C2=A0{
> -	char str[256];
> +	STRBUF_ON_STACK(buf);
> =C2=A0	char *reply =3D NULL;
> =C2=A0	int ret =3D -1;
> =C2=A0
> -	if (key)
> -		snprintf(str, sizeof(str), "%s map %s key %s", cmd,
> alias, key);
> +	if (data)
> +		print_strbuf(&buf, "%s map %s %s %s", cmd, alias,
> +			=C2=A0=C2=A0=C2=A0=C2=A0 strcmp(cmd, "setprkey") ? "pathlist" :
> "key",
> +			=C2=A0=C2=A0=C2=A0=C2=A0 data);
> =C2=A0	else
> -		snprintf(str, sizeof(str), "%s map %s", cmd, alias);
> +		print_strbuf(&buf, "%s map %s", cmd, alias);
> =C2=A0
> -	reply =3D do_pr(alias, str);
> +	reply =3D do_pr(alias, get_strbuf_str(&buf));
> =C2=A0	if (reply) {
> =C2=A0		if (strncmp(reply, "ok", 2) =3D=3D 0)
> =C2=A0			ret =3D 0;
> =C2=A0		else
> =C2=A0			ret =3D -1;
> -		condlog(ret ? 0 : 4, "%s: message=3D%s reply=3D%s",
> alias, str, reply);
> +		condlog(ret ? 0 : 4, "%s: message=3D%s reply=3D%s",
> alias,
> +			get_strbuf_str(&buf), reply);
> =C2=A0	}
> =C2=A0
> =C2=A0	free(reply);
> @@ -106,9 +110,31 @@ int get_prhold(char *mapname)
> =C2=A0	return do_get_pr(mapname, "getprhold");
> =C2=A0}
> =C2=A0
> -int update_prflag(char *mapname, int set) {
> -	return do_update_pr(mapname, (set)? "setprstatus" :
> "unsetprstatus",
> -			=C2=A0=C2=A0=C2=A0 NULL);
> +int update_prflag(struct multipath *mpp, int set)
> +{
> +	STRBUF_ON_STACK(buf);
> +	int i, j;
> +	bool first =3D true;
> +	struct pathgroup *pgp =3D NULL;
> +	struct path *pp =3D NULL;
> +
> +	if (!set)
> +		return do_update_pr(mpp->alias, "unsetprstatus",
> NULL);
> +
> +	append_strbuf_str(&buf, "\"");
> +	vector_foreach_slot (mpp->pg, pgp, j) {
> +		vector_foreach_slot (pgp->paths, pp, i) {
> +			if (pp->state =3D=3D PATH_UP || pp->state =3D=3D
> PATH_GHOST) {
> +				if (first) {
> +					append_strbuf_str(&buf, pp-
> >dev);
> +					first =3D false;
> +				} else
> +					print_strbuf(&buf, " %s",
> pp->dev);

Nitpick: in the commit description you said the list was comma-
separated, here it looks like space-separated.

Also, I'd prefer to use pp->dev_t here unless there are good reasons
against that.

> +			}
> +		}
> +	}
> +	append_strbuf_str(&buf, "\"");
> +	return do_update_pr(mpp->alias, "setprstatus",
> get_strbuf_str(&buf));
> =C2=A0}
> =C2=A0
> =C2=A0int update_prhold(char *mapname, bool set)
> diff --git a/libmpathpersist/mpathpr.h b/libmpathpersist/mpathpr.h
> index 99d6b82f..adbfc865 100644
> --- a/libmpathpersist/mpathpr.h
> +++ b/libmpathpersist/mpathpr.h
> @@ -1,12 +1,14 @@
> =C2=A0#ifndef MPATHPR_H_INCLUDED
> =C2=A0#define MPATHPR_H_INCLUDED
> =C2=A0
> +#include "structs.h"
> +
> =C2=A0/*
> =C2=A0 * This header file contains symbols that are only used by
> =C2=A0 * libmpathpersist internally.
> =C2=A0 */
> =C2=A0
> -int update_prflag(char *mapname, int set);
> +int update_prflag(struct multipath *mpp, int set);
> =C2=A0int update_prkey_flags(char *mapname, uint64_t prkey, uint8_t
> sa_flags);
> =C2=A0int get_prflag(char *mapname);
> =C2=A0int get_prhold(char *mapname);
> diff --git a/multipathd/callbacks.c b/multipathd/callbacks.c
> index b6b57f45..1129855b 100644
> --- a/multipathd/callbacks.c
> +++ b/multipathd/callbacks.c
> @@ -59,6 +59,7 @@ void init_handler_callbacks(void)
> =C2=A0	set_unlocked_handler_callback(VRB_SHUTDOWN,
> HANDLER(cli_shutdown));
> =C2=A0	set_handler_callback(VRB_GETPRSTATUS | Q1_MAP,
> HANDLER(cli_getprstatus));
> =C2=A0	set_handler_callback(VRB_SETPRSTATUS | Q1_MAP,
> HANDLER(cli_setprstatus));
> +	set_handler_callback(VRB_SETPRSTATUS | Q1_MAP | Q2_PATHLIST,
> HANDLER(cli_setprstatus_list));
> =C2=A0	set_handler_callback(VRB_UNSETPRSTATUS | Q1_MAP,
> HANDLER(cli_unsetprstatus));
> =C2=A0	set_handler_callback(VRB_FORCEQ | Q1_DAEMON,
> HANDLER(cli_force_no_daemon_q));
> =C2=A0	set_handler_callback(VRB_RESTOREQ | Q1_DAEMON,
> HANDLER(cli_restore_no_daemon_q));
> diff --git a/multipathd/cli.c b/multipathd/cli.c
> index d0e6cebc..0d679c86 100644
> --- a/multipathd/cli.c
> +++ b/multipathd/cli.c
> @@ -227,6 +227,7 @@ load_keys (void)
> =C2=A0	r +=3D add_key(keys, "getprhold", VRB_GETPRHOLD, 0);
> =C2=A0	r +=3D add_key(keys, "setprhold", VRB_SETPRHOLD, 0);
> =C2=A0	r +=3D add_key(keys, "unsetprhold", VRB_UNSETPRHOLD, 0);
> +	r +=3D add_key(keys, "pathlist", KEY_PATHLIST, 1);
> =C2=A0
> =C2=A0	if (r) {
> =C2=A0		free_keys(keys);
> diff --git a/multipathd/cli.h b/multipathd/cli.h
> index 5a943a45..3e607389 100644
> --- a/multipathd/cli.h
> +++ b/multipathd/cli.h
> @@ -62,6 +62,7 @@ enum {
> =C2=A0	KEY_LOCAL		=3D 81,
> =C2=A0	KEY_GROUP		=3D 82,
> =C2=A0	KEY_KEY			=3D 83,
> +	KEY_PATHLIST		=3D 84,
> =C2=A0};
> =C2=A0
> =C2=A0/*
> @@ -94,6 +95,7 @@ enum {
> =C2=A0	Q2_LOCAL		=3D KEY_LOCAL << 16,
> =C2=A0	Q2_GROUP		=3D KEY_GROUP << 16,
> =C2=A0	Q2_KEY			=3D KEY_KEY << 16,
> +	Q2_PATHLIST		=3D KEY_PATHLIST << 16,
> =C2=A0
> =C2=A0	/* byte 3: qualifier 3 */
> =C2=A0	Q3_FMT			=3D KEY_FMT << 24,
> diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> index 2812d01e..5770dcec 100644
> --- a/multipathd/cli_handlers.c
> +++ b/multipathd/cli_handlers.c
> @@ -31,6 +31,7 @@
> =C2=A0#include "foreign.h"
> =C2=A0#include "strbuf.h"
> =C2=A0#include "cli_handlers.h"
> +#include <ctype.h>
> =C2=A0
> =C2=A0static struct path *
> =C2=A0find_path_by_str(const struct vector_s *pathvec, const char *str,
> @@ -1276,8 +1277,8 @@ cli_getprstatus (void * v, struct strbuf
> *reply, void * data)
> =C2=A0	return 0;
> =C2=A0}
> =C2=A0
> -static int
> -cli_setprstatus(void * v, struct strbuf *reply, void * data)
> +static int do_setprstatus(void * v, struct strbuf *reply, void *
> data,
> +			=C2=A0 const struct vector_s *registered_paths)
> =C2=A0{
> =C2=A0	struct multipath * mpp;
> =C2=A0	struct vectors * vecs =3D (struct vectors *)data;
> @@ -1291,7 +1292,7 @@ cli_setprstatus(void * v, struct strbuf *reply,
> void * data)
> =C2=A0
> =C2=A0	if (mpp->prflag !=3D PR_SET) {
> =C2=A0		set_pr(mpp);
> -		pr_register_active_paths(mpp, true);
> +		pr_register_active_paths(mpp, registered_paths);
> =C2=A0		if (mpp->prflag =3D=3D PR_SET)
> =C2=A0			condlog(2, "%s: prflag set", param);
> =C2=A0		else
> @@ -1302,6 +1303,38 @@ cli_setprstatus(void * v, struct strbuf
> *reply, void * data)
> =C2=A0	return 0;
> =C2=A0}
> =C2=A0
> +static int
> +cli_setprstatus(void * v, struct strbuf *reply, void * data)
> +{
> +	return do_setprstatus(v, reply, data, NULL);
> +}
> +
> +static int
> +cli_setprstatus_list(void * v, struct strbuf *reply, void * data)
> +{
> +	int r;
> +	struct vector_s registered_paths =3D { .allocated =3D 0 };
> +	char *ptr =3D get_keyparam(v, KEY_PATHLIST);
> +
> +	while (isspace(*ptr))
> +		ptr++;
> +	while (*ptr) {
> +		if (!vector_alloc_slot(&registered_paths)) {
> +			r =3D -ENOMEM;
> +			goto out;
> +		}
> +		vector_set_slot(&registered_paths, ptr);
> +		while (*ptr && !isspace(*ptr))
> +			ptr++;
> +		while (isspace(*ptr))
> +			*ptr++ =3D '\0';
> +	}
> +	r =3D do_setprstatus(v, reply, data, &registered_paths);
> +out:
> +	vector_reset(&registered_paths);
> +	return r;
> +}
> +
> =C2=A0static int
> =C2=A0cli_unsetprstatus(void * v, struct strbuf *reply, void * data)
> =C2=A0{
> diff --git a/multipathd/main.c b/multipathd/main.c
> index a7650639..f00444b4 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -630,28 +630,50 @@ flush_map_nopaths(struct multipath *mpp, struct
> vectors *vecs) {
> =C2=A0	return true;
> =C2=A0}
> =C2=A0
> -void pr_register_active_paths(struct multipath *mpp, bool
> check_nr_active)
> +/*
> + * If reg_paths in non-NULL, it is a vector of paths that
> libmpathpersist
> + * registered. If the number of registered keys is smaller than the
> number
> + * of registered paths, then likely a preempt that occurred while
> + * libmpathpersist was registering the key. As long as there are
> still some
> + * registered keys, treat the preempt as happening first, and make
> sure to
> + * register keys on all the paths. If the number of registered keys
> is at
> + * least as large as the number of registered paths, then no preempt
> happened,
> + * and multipathd does not need to re-register the paths that
> libmpathpersist
> + * handled
> + */
> +void pr_register_active_paths(struct multipath *mpp,
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 const struct vector_s *reg_paths)
> =C2=A0{
> -	unsigned int i, j, nr_keys =3D 0;
> -	unsigned int nr_active =3D 0;
> +	unsigned int i, j, k, nr_keys =3D 0;
> +	unsigned int wanted_nr =3D VECTOR_SIZE(reg_paths);
> =C2=A0	struct path *pp;
> =C2=A0	struct pathgroup *pgp;
> -
> -	if (check_nr_active) {
> -		nr_active =3D count_active_paths(mpp);
> -		if (!nr_active)
> -			return;
> -	}
> +	char *pathname;
> =C2=A0
> =C2=A0	vector_foreach_slot (mpp->pg, pgp, i) {
> =C2=A0		vector_foreach_slot (pgp->paths, pp, j) {
> =C2=A0			if (mpp->prflag =3D=3D PR_UNSET)
> =C2=A0				return;
> -			if (pp->state =3D=3D PATH_UP || pp->state =3D=3D
> PATH_GHOST) {
> -				nr_keys =3D mpath_pr_event_handle(pp,
> nr_keys, nr_active);
> -				if (check_nr_active && nr_keys =3D=3D
> nr_active)
> -					return;
> +			if (pp->state !=3D PATH_UP && pp->state !=3D
> PATH_GHOST)
> +				continue;
> +			if (wanted_nr && nr_keys) {
> +				vector_foreach_slot(reg_paths,
> pathname, k) {
> +					if (strcmp(pp->dev,
> pathname) =3D=3D 0 ||
> +					=C2=A0=C2=A0=C2=A0 strcmp(pp->dev_t,
> pathname) =3D=3D 0) {

As this command is not likely to be sent by human users, do we need to
accept both dev and dev_t here?

> +						goto skip;
> +					}
> +				}
> +			}
> +			nr_keys =3D mpath_pr_event_handle(pp, nr_keys,
> wanted_nr);
> +			if (nr_keys && nr_keys < wanted_nr) {
> +				/*
> +				 * Incorrect number of registered
> keys. Need
> +				 * to register all devices
> +				 */
> +				wanted_nr =3D 0;
> =C2=A0			}
> +skip:
> +			; /* a statement must follow a label on pre
> C23 clang */
> =C2=A0		}
> =C2=A0	}
> =C2=A0}
> @@ -739,7 +761,7 @@ fail:
> =C2=A0
> =C2=A0	sync_map_state(mpp, false);
> =C2=A0
> -	pr_register_active_paths(mpp, false);
> +	pr_register_active_paths(mpp, NULL);
> =C2=A0
> =C2=A0	if (VECTOR_SIZE(offline_paths) !=3D 0)
> =C2=A0		handle_orphaned_offline_paths(offline_paths);
> @@ -1413,7 +1435,7 @@ rescan:
> =C2=A0
> =C2=A0	if (retries >=3D 0) {
> =C2=A0		if ((mpp->prflag =3D=3D PR_SET && prflag !=3D PR_SET) ||
> start_waiter)
> -			pr_register_active_paths(mpp, false);
> +			pr_register_active_paths(mpp, NULL);
> =C2=A0		condlog(2, "%s [%s]: path added to devmap %s",
> =C2=A0			pp->dev, pp->dev_t, mpp->alias);
> =C2=A0		return 0;
> @@ -2658,7 +2680,7 @@ update_path_state (struct vectors * vecs,
> struct path * pp)
> =C2=A0				"reservation registration", pp-
> >dev);
> =C2=A0			mpath_pr_event_handle(pp, 0, 0);
> =C2=A0			if (pp->mpp->prflag =3D=3D PR_SET && prflag !=3D
> PR_SET)
> -				pr_register_active_paths(pp->mpp,
> false);
> +				pr_register_active_paths(pp->mpp,
> NULL);
> =C2=A0		}
> =C2=A0
> =C2=A0		/*
> @@ -3319,7 +3341,7 @@ configure (struct vectors * vecs, enum
> force_reload_types reload_type)
> =C2=A0	vector_foreach_slot(mpvec, mpp, i){
> =C2=A0		if (remember_wwid(mpp->wwid) =3D=3D 1)
> =C2=A0			trigger_paths_udev_change(mpp, true);
> -		pr_register_active_paths(mpp, false);
> +		pr_register_active_paths(mpp, NULL);
> =C2=A0	}
> =C2=A0
> =C2=A0	/*
> @@ -4370,8 +4392,8 @@ static int update_map_pr(struct multipath *mpp,
> struct path *pp, unsigned int *n
> =C2=A0 *
> =C2=A0 * nr_keys_wanted: Only used if nr_keys_needed is 0, so we don't
> know how
> =C2=A0 * many keys we currently have. If nr_keys_wanted in non-zero and
> the
> - * number of keys found by the initial call to update_map_pr()
> matches it,
> - * exit early, since we have all the keys we are expecting.
> + * number of keys found by the initial call to update_map_pr() is at
> least
> + * as large as it, exit early, since we have all the keys we are
> expecting.
> =C2=A0 *
> =C2=A0 * The function returns the number of keys that are registered or 0
> if
> =C2=A0 * it's unknown.
> @@ -4394,7 +4416,7 @@ mpath_pr_event_handle(struct path *pp, unsigned
> int nr_keys_needed,
> =C2=A0		nr_keys_needed =3D 1;
> =C2=A0		if (update_map_pr(mpp, pp, &nr_keys_needed) !=3D
> MPATH_PR_SUCCESS)
> =C2=A0			return 0;
> -		if (nr_keys_wanted && nr_keys_wanted =3D=3D
> nr_keys_needed)
> +		if (nr_keys_wanted && nr_keys_wanted <=3D
> nr_keys_needed)
> =C2=A0			return nr_keys_needed;
> =C2=A0	}
> =C2=A0
> diff --git a/multipathd/main.h b/multipathd/main.h
> index 6d60ee81..85b533cd 100644
> --- a/multipathd/main.h
> +++ b/multipathd/main.h
> @@ -54,5 +54,6 @@ int resize_map(struct multipath *mpp, unsigned long
> long size,
> =C2=A0	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct vectors *vecs);
> =C2=A0void set_pr(struct multipath *mpp);
> =C2=A0void unset_pr(struct multipath *mpp);
> -void pr_register_active_paths(struct multipath *mpp, bool
> check_active_nr);
> +void pr_register_active_paths(struct multipath *mpp,
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 const struct vector_s
> *registered_paths);
> =C2=A0#endif /* MAIN_H_INCLUDED */
> diff --git a/multipathd/multipathd.8.in b/multipathd/multipathd.8.in
> index 7ffb8d4c..38a243e3 100644
> --- a/multipathd/multipathd.8.in
> +++ b/multipathd/multipathd.8.in
> @@ -348,6 +348,12 @@ Restores configured queue_without_daemon mode.
> =C2=A0Enable persistent reservation management on $map.
> =C2=A0.
> =C2=A0.TP
> +.B setprstatus map|multipath $map pathlist $pathlist
> +Enable persistent reservation management on $map, and notify
> multipathd of
> +the paths that have been registered, so it doesn't attempt to re-
> register
> +them.
> +.
> +.TP
> =C2=A0.B unsetprstatus map|multipath $map
> =C2=A0Disable persistent reservation management on $map.
> =C2=A0.
