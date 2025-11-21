Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D09930C613
	for <dm-devel@lists.linux.dev>; Fri, 21 Nov 2025 22:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763764557; cv=none; b=rD23Wn4JclivZR7m9mrFLK2XWs4vHLnBv1F8AQ4bBP5iEJOhm4FBZ33y0K1tsvrVdYP8kWVZeJ9PMOX8GwyyrUxp7Q0sNqYIlouSfclAxFrC2oxya5t7A6uCr6lZzwkT3ORTjn8+EnUQoiTGmXnnGhaMNdmr1bUXriaOojhj9Eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763764557; c=relaxed/simple;
	bh=kuRhChYHeFoUNqmk9r8x5oKD6MW0CTrPpfM46dF+WN8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ONBT0d5dML68NsDGxaQblmutNaPLBIai+V7nehge07A79PYCYhHRJcj6Bb+ApDrirseHOv/ZJEAw8w+6rgBrE4wGBWMfaVBst5BROUdaNCQoEmmR3GvaxEN1cDC1zlPhRsnWyIsdNAjdkl4nWxCjnA23wTqM0w6KBLDRKwPOYss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=KfKRopWo; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="KfKRopWo"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-378e8d10494so32059331fa.2
        for <dm-devel@lists.linux.dev>; Fri, 21 Nov 2025 14:35:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1763764536; x=1764369336; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=paXF5CYK+4N3h1HLiiOq0aksrxrcqWX4xy2ENYsPH34=;
        b=KfKRopWohRDd/k6iM5DisF7kU1asNbia2gsrlY/rVAHF+YIPOyopwjZGovHGHj9zuE
         dPppaAZbJZGaFay/eOHun4XLKZoVmoWnHqPTVMSATbj7RYDCrIyF1WdEHop9uX3SIeEK
         2I0fzNkxhhw1eKNFbLCzwweFr/7OgzmHck3GwmwJOa/Bt4GYwpbf440XQOc8DyYN/NTy
         jWXUZyPcJiia2pm8s3HO6BOi0MaNXF3sLImRDYoA/9n1Oc/D8VZDwlh5ifhyVlf7xnYc
         veevaMilamSdZ5D3lsluOpXHU+kbSKdTbCqjpm8SEeQSS1w5m2JKqRUZ9zf0lokmW4AY
         pDZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763764536; x=1764369336;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=paXF5CYK+4N3h1HLiiOq0aksrxrcqWX4xy2ENYsPH34=;
        b=VcxrdQ5oKvgq/tJAJAPPqADFE16vM8T+KKjpn2gFAAnt72ZbAg68HwQI4REaoByAmA
         5KLMPWLQtflwuKVX0r43+oASsYXnNqJpeq58li1KKFUOR/qGKJK0wkRtQQn+WdbVe/9y
         jF/k881n1twj+sI2bF42xJtDz6UPZ6ODHMY+Met4J8KbUeci/ewWbR78rFqsSoIbylaq
         Se662jMRoOp83pYewxCZTMp9Q96P3JsjSLiO8cCSFI8E8GEvYPjYVXKMPWONgJ2ZmRWN
         NjpSDV4UPmZCF1rhGqiJDo9nq0xk8ciV7lxyFFqp1kAds6macFdatHhO9lVhcZTx/QIk
         IqUw==
X-Gm-Message-State: AOJu0YwnQzT+OqnIN8iZNJCIxoJxbjCKk5b8cwmk+uIHL0U7RVMnetgD
	sdbmSOb43DxuoVTTuejPSPWYolR/NT1VjUfnCXDuzYADr36xEq7uiec2AuxBp3zOrvYm8YmTP0M
	p+MqilKKcFLMFk74GmwCyK47kxg3bUGBuL2ORsRDHMA==
X-Gm-Gg: ASbGncuu/xpdc8eUDj2XpkihIX0oOUeoa5B8OZWZVpsYLgoGXQH4WK7QRH7jrFVMIhg
	ZzReUASJuEOkg06wngpzDdrsTD8Hdqeki641jEDZ1hvXHhVtQp/iK6dz8g2EjlxjfCcdmCRuGCq
	wTaKeOfQZjHCxbYzHxhNJ0PaBvlr8Vzjai6TrG3gjTI9N2m6B8Rvgx+ydQlHOzRJ8oa+IELTGmv
	BMfIi6RHljJ6wwbLYaHkPgjQuektFxrEC59otJMVs+efP9wK3PYfDFf3kxEpeVc/nfKJdHyytRs
	UgIgQpY4R4TaPpmntHI84+EKAFXhKf1XhGbF3pKF8v/Vl93lnIvl
X-Google-Smtp-Source: AGHT+IEl86erbfALvGKMliXu6qcwhNIFsvksDNG20sczqCS44YkJ3+KcaX10QS9ttWOTScaVGHJViVXr/C9bER/Xe/Y=
X-Received: by 2002:a2e:9d4f:0:b0:37a:3650:a9e3 with SMTP id
 38308e7fff4ca-37cd924b4f8mr6828121fa.35.1763764535332; Fri, 21 Nov 2025
 14:35:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251113184317.55038-1-brian@purestorage.com> <aSC4YOZjDiIZadJ4@redhat.com>
In-Reply-To: <aSC4YOZjDiIZadJ4@redhat.com>
From: Brian Bunker <brian@purestorage.com>
Date: Fri, 21 Nov 2025 14:35:23 -0800
X-Gm-Features: AWmQ_bnL5nmA6CCBwQ4S2gWQqG94rTWmcP1huIXHT4hbCr1nEMW2gzX8SE_KldM
Message-ID: <CAHZQxyLJMZ6VpFFj1D8TLECBrQ7_digxT1BS1Dk68LNqTzV5EQ@mail.gmail.com>
Subject: Re: [PATCH] Add purge capability to multipath-tools
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev, Krishna Kant <krishna.kant@purestorage.com>, 
	Martin Wilck <martin.wilck@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 21, 2025 at 11:07=E2=80=AFAM Benjamin Marzinski <bmarzins@redha=
t.com> wrote:
>
> On Thu, Nov 13, 2025 at 10:43:17AM -0800, Brian Bunker wrote:
> > In the Linux kernel when volumes are disconnected, they are left behind
> > to be re-enabled when the connection comes back. There are many cases
> > where this behavior is not desirable.
> >
> > The goal is to have paths appear when volumes are connected. This is
> > handled by target initiated rescans and posting of unit attentions.
> > Secondarily when volumes are disconnected at the target, paths should
> > be removed.
> >
> > This was discussed here in a kernel patch:
> > https://marc.info/?l=3Dlinux-scsi&m=3D164426722617834&w=3D2
> >
> > It was suggested there that userspace would be more advantageous in
> > handling the device removal.
> >
> > An option was added to multipath-tools to purge devices that are
> > disconnected at the target. A purge thread was implemented to handle
> > the device removal when the path returns sense data (0x5/0x25/0x0) from
> > the path checker. The option, purge_disconnected, is by default off but
> > can be turned on by setting it to true.
> >
> > When enabled multipathd will log:
> > Nov 11 18:43:24 init539-33 multipathd[52046]: sdc: mark (disconnected)
> > path for purge
> > ...
> > Nov 13 09:54:17 init539-33 multipathd[69140]: purged 8 paths, 0 failed,
> > 0 pending in 0.125017 secs
>
> I think this is an o.k. idea. I think that the most common case I see of
> a device getting disconnected while multipathed, is when someone is
> reamapping the LUN. They could just be growing the LUN, in which case
> removing the path isn't great. But far too often, users are remapping
> the LUN to completely different storage.
>
> However, if recheck_wwid is set, multipathd will catch this when the
> path is restored. So, my only reservation with adding this, is that
> recheck_wwid should solve the problematic issue (LUNs getting remapped
> to completely different storage) just as well, while not removing paths
> from devices that are just growing the LUN (assuming that doesn't cause
> the array to change the LUN's wwid).  On the other hand, it's an
> optional parameter, and it will cause the path to disappear much sooner
> than recheck_wwid will, so overall, I fine with adding it.

The reconnecting of another volume using the same LUN number of
a previously connected volume is only one of the things we are
wanting to prevent. We want to use multipath-tools as the facility to
remove disconnected devices to solve that problem as well as other
issues around volume mobility between arrays. There are issues
where a volume can move between arrays. The relative target
port information can be different for the same array if it takes
a migration path from A -> B -> C -> A. The device path at A
at the start if resurrected at the end will cause an error. What we
hope is to get the always purge disconnected devices so there
are no opportunities to resurrect an old path. The recheck_wwid
solves one but not all, but this I think eliminates the need for
recheck_wwid at all.

>
> I do have some specific issues with the patch below.
>
> > Signed-off-by: Brian Bunker <brian@purestorage.com>
> > Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
> > ---
> >  libmultipath/checkers.c       |   2 +
> >  libmultipath/checkers.h       |   2 +
> >  libmultipath/checkers/tur.c   |  12 ++
> >  libmultipath/config.c         |   2 +
> >  libmultipath/config.h         |   3 +
> >  libmultipath/configure.c      |   1 +
> >  libmultipath/defaults.h       |   1 +
> >  libmultipath/dict.c           |  14 +++
> >  libmultipath/io_err_stat.c    |   1 +
> >  libmultipath/print.c          |   2 +
> >  libmultipath/propsel.c        |  16 +++
> >  libmultipath/propsel.h        |   1 +
> >  libmultipath/structs.h        |   9 ++
> >  multipath/multipath.conf.5.in |  21 ++++
> >  multipathd/main.c             | 229 +++++++++++++++++++++++++++++++++-
> >  15 files changed, 310 insertions(+), 6 deletions(-)
> >
> > diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
> > index e2eda58d..bb6ad1ee 100644
> > --- a/libmultipath/checkers.c
> > +++ b/libmultipath/checkers.c
> > @@ -43,6 +43,7 @@ static const char *checker_state_names[PATH_MAX_STATE=
] =3D {
> >       [PATH_TIMEOUT] =3D "timeout",
> >       [PATH_REMOVED] =3D "removed",
> >       [PATH_DELAYED] =3D "delayed",
> > +     [PATH_DISCONNECTED] =3D "disconnected",
> >  };
> >
> >  static LIST_HEAD(checkers);
> > @@ -363,6 +364,7 @@ static const char *generic_msg[CHECKER_GENERIC_MSGT=
ABLE_SIZE] =3D {
> >       [CHECKER_MSGID_DOWN] =3D " reports path is down",
> >       [CHECKER_MSGID_GHOST] =3D " reports path is ghost",
> >       [CHECKER_MSGID_UNSUPPORTED] =3D " doesn't support this device",
> > +     [CHECKER_MSGID_DISCONNECTED] =3D " no access to this device",
> >  };
> >
> >  const char *checker_message(const struct checker *c)
> > diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
> > index da91f499..903c3ebe 100644
> > --- a/libmultipath/checkers.h
> > +++ b/libmultipath/checkers.h
> > @@ -78,6 +78,7 @@ enum path_check_state {
> >       PATH_TIMEOUT,
> >       PATH_REMOVED,
> >       PATH_DELAYED,
> > +     PATH_DISCONNECTED,
> >       PATH_MAX_STATE
> >  };
> >
> > @@ -113,6 +114,7 @@ enum {
> >       CHECKER_MSGID_DOWN,
> >       CHECKER_MSGID_GHOST,
> >       CHECKER_MSGID_UNSUPPORTED,
> > +     CHECKER_MSGID_DISCONNECTED,
> >       CHECKER_GENERIC_MSGTABLE_SIZE,
> >       CHECKER_FIRST_MSGID =3D 100,      /* lowest msgid for checkers */
> >       CHECKER_MSGTABLE_SIZE =3D 100,    /* max msg table size for check=
ers */
> > diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
> > index 0010acf8..1bf2ca97 100644
> > --- a/libmultipath/checkers/tur.c
> > +++ b/libmultipath/checkers/tur.c
> > @@ -34,6 +34,7 @@ enum {
> >       MSG_TUR_TIMEOUT,
> >       MSG_TUR_FAILED,
> >       MSG_TUR_TRANSITIONING,
> > +     MSG_TUR_DISCONNECTED,
> >  };
> >
>
> you already added a generic message for the PATH_DISCONNECTED state, so
> we don't need a TUR checker specific one as well.

OK I wasn't exactly sure of what was required and just tried to follow the =
code
that was there as best I could. I probably made mistakes like this one.

>
> >  #define IDX_(x) (MSG_ ## x - CHECKER_FIRST_MSGID)
> > @@ -42,6 +43,7 @@ const char *libcheck_msgtable[] =3D {
> >       [IDX_(TUR_TIMEOUT)] =3D " timed out",
> >       [IDX_(TUR_FAILED)] =3D " failed to initialize",
> >       [IDX_(TUR_TRANSITIONING)] =3D " reports path is transitioning",
> > +     [IDX_(TUR_DISCONNECTED)] =3D " no access to this device",
> >       NULL,
> >  };
> >
> > @@ -199,6 +201,16 @@ retry:
> >                               return PATH_PENDING;
> >                       }
> >               }
> > +             else if (key =3D=3D 0x5) {
> > +                     /* Illegal request */
> > +                     if (asc =3D=3D 0x25 && ascq =3D=3D 0x00) {
> > +                             /*
> > +                              * LOGICAL UNIT NOT SUPPORTED
> > +                              */
> > +                             *msgid =3D MSG_TUR_DISCONNECTED;
>
> This should just used CHECKER_MSGID_DISCONNECTED
>
> > +                             return PATH_DISCONNECTED;
> > +                     }
> > +             }
> >               *msgid =3D CHECKER_MSGID_DOWN;
> >               return PATH_DOWN;
> >       }
> > diff --git a/libmultipath/config.c b/libmultipath/config.c
> > index 8b424d18..2c66a788 100644
> > --- a/libmultipath/config.c
> > +++ b/libmultipath/config.c
> > @@ -470,6 +470,7 @@ merge_hwe (struct hwentry * dst, struct hwentry * s=
rc)
> >       merge_num(marginal_path_err_rate_threshold);
> >       merge_num(marginal_path_err_recheck_gap_time);
> >       merge_num(marginal_path_double_failed_time);
> > +     merge_num(purge_disconnected);
> >
> >       snprintf(id, sizeof(id), "%s/%s", dst->vendor, dst->product);
> >       reconcile_features_with_options(id, &dst->features,
> > @@ -517,6 +518,7 @@ merge_mpe(struct mpentry *dst, struct mpentry *src)
> >       merge_num(skip_kpartx);
> >       merge_num(max_sectors_kb);
> >       merge_num(ghost_delay);
> > +     merge_num(purge_disconnected);
>
> I can definitely see the reason why you might want to set this option on
> a per-array-type basis. Not all scsi arrays return the status you would
> expect. I'm not sure that setting this on a per-multipath-device basis
> makes much sense. Maybe you have a good reason for doing this? I realize
> that some of the other options in the multipaths section don't make
> tons of sense to set per-multipath-device, so possibly you just thought
> that doing this was necessary.

I didn't know where the option would provide the most benefit to be
honest. A global parameter works for my case but I wasn't sure a
greater granularity would never be useful.

>
> >       merge_num(uid);
> >       merge_num(gid);
> >       merge_num(mode);
> > diff --git a/libmultipath/config.h b/libmultipath/config.h
> > index 5b4ebf8c..618fa572 100644
> > --- a/libmultipath/config.h
> > +++ b/libmultipath/config.h
> > @@ -88,6 +88,7 @@ struct hwentry {
> >       int marginal_path_err_rate_threshold;
> >       int marginal_path_err_recheck_gap_time;
> >       int marginal_path_double_failed_time;
> > +     int purge_disconnected;
> >       int skip_kpartx;
> >       int max_sectors_kb;
> >       int ghost_delay;
> > @@ -130,6 +131,7 @@ struct mpentry {
> >       int marginal_path_err_rate_threshold;
> >       int marginal_path_err_recheck_gap_time;
> >       int marginal_path_double_failed_time;
> > +     int purge_disconnected;
>
> same issue as above.
>
> >       int skip_kpartx;
> >       int max_sectors_kb;
> >       int ghost_delay;
> > @@ -188,6 +190,7 @@ struct config {
> >       int marginal_path_err_rate_threshold;
> >       int marginal_path_err_recheck_gap_time;
> >       int marginal_path_double_failed_time;
> > +     int purge_disconnected;
> >       int uxsock_timeout;
> >       int strict_timing;
> >       int retrigger_tries;
> > diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> > index baa13573..e4431d2f 100644
> > --- a/libmultipath/configure.c
> > +++ b/libmultipath/configure.c
> > @@ -355,6 +355,7 @@ int setup_map(struct multipath *mpp, char **params,=
 struct vectors *vecs)
> >       select_max_sectors_kb(conf, mpp);
> >       select_ghost_delay(conf, mpp);
> >       select_flush_on_last_del(conf, mpp);
> > +     select_purge_disconnected(conf, mpp);
> >
> >       sysfs_set_scsi_tmo(conf, mpp);
> >       marginal_pathgroups =3D conf->marginal_pathgroups;
> > diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
> > index 134b690a..d80dd7d4 100644
> > --- a/libmultipath/defaults.h
> > +++ b/libmultipath/defaults.h
> > @@ -58,6 +58,7 @@
> >  #define DEFAULT_ALL_TG_PT ALL_TG_PT_OFF
> >  #define DEFAULT_RECHECK_WWID RECHECK_WWID_OFF
> >  #define DEFAULT_AUTO_RESIZE AUTO_RESIZE_NEVER
> > +#define DEFAULT_PURGE_DISCONNECTED PURGE_DISCONNECTED_OFF
> >  /* Enable no foreign libraries by default */
> >  #define DEFAULT_ENABLE_FOREIGN "NONE"
> >
> > diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> > index a06a6138..504b28b5 100644
> > --- a/libmultipath/dict.c
> > +++ b/libmultipath/dict.c
> > @@ -941,6 +941,16 @@ declare_hw_snprint(skip_kpartx, print_yes_no_undef=
)
> >  declare_mp_handler(skip_kpartx, set_yes_no_undef)
> >  declare_mp_snprint(skip_kpartx, print_yes_no_undef)
> >
> > +declare_def_handler(purge_disconnected, set_yes_no_undef)
> > +declare_def_snprint_defint(purge_disconnected, print_yes_no_undef,
> > +     DEFAULT_PURGE_DISCONNECTED)
> > +declare_ovr_handler(purge_disconnected, set_yes_no_undef)
> > +declare_ovr_snprint(purge_disconnected, print_yes_no_undef)
> > +declare_hw_handler(purge_disconnected, set_yes_no_undef)
> > +declare_hw_snprint(purge_disconnected, print_yes_no_undef)
> > +declare_mp_handler(purge_disconnected, set_yes_no_undef)
> > +declare_mp_snprint(purge_disconnected, print_yes_no_undef)
>
> Same issue as above (for the declare_mp_* macros)
>
> > +
> >  declare_def_range_handler(remove_retries, 0, INT_MAX)
> >  declare_def_snprint(remove_retries, print_int)
> >
> > @@ -2227,6 +2237,7 @@ init_keywords(vector keywords)
> >       install_keyword("retrigger_delay", &def_retrigger_delay_handler, =
&snprint_def_retrigger_delay);
> >       install_keyword("missing_uev_wait_timeout", &def_uev_wait_timeout=
_handler, &snprint_def_uev_wait_timeout);
> >       install_keyword("skip_kpartx", &def_skip_kpartx_handler, &snprint=
_def_skip_kpartx);
> > +     install_keyword("purge_disconnected", &def_purge_disconnected_han=
dler, &snprint_def_purge_disconnected);
> >       install_keyword("disable_changed_wwids", &deprecated_disable_chan=
ged_wwids_handler, &snprint_deprecated);
> >       install_keyword("remove_retries", &def_remove_retries_handler, &s=
nprint_def_remove_retries);
> >       install_keyword("max_sectors_kb", &def_max_sectors_kb_handler, &s=
nprint_def_max_sectors_kb);
> > @@ -2310,6 +2321,7 @@ init_keywords(vector keywords)
> >       install_keyword("marginal_path_err_recheck_gap_time", &hw_margina=
l_path_err_recheck_gap_time_handler, &snprint_hw_marginal_path_err_recheck_=
gap_time);
> >       install_keyword("marginal_path_double_failed_time", &hw_marginal_=
path_double_failed_time_handler, &snprint_hw_marginal_path_double_failed_ti=
me);
> >       install_keyword("skip_kpartx", &hw_skip_kpartx_handler, &snprint_=
hw_skip_kpartx);
> > +     install_keyword("purge_disconnected", &hw_purge_disconnected_hand=
ler, &snprint_hw_purge_disconnected);
> >       install_keyword("max_sectors_kb", &hw_max_sectors_kb_handler, &sn=
print_hw_max_sectors_kb);
> >       install_keyword("ghost_delay", &hw_ghost_delay_handler, &snprint_=
hw_ghost_delay);
> >       install_keyword("all_tg_pt", &hw_all_tg_pt_handler, &snprint_hw_a=
ll_tg_pt);
> > @@ -2355,6 +2367,7 @@ init_keywords(vector keywords)
> >       install_keyword("marginal_path_double_failed_time", &ovr_marginal=
_path_double_failed_time_handler, &snprint_ovr_marginal_path_double_failed_=
time);
> >
> >       install_keyword("skip_kpartx", &ovr_skip_kpartx_handler, &snprint=
_ovr_skip_kpartx);
> > +     install_keyword("purge_disconnected", &ovr_purge_disconnected_han=
dler, &snprint_ovr_purge_disconnected);
> >       install_keyword("max_sectors_kb", &ovr_max_sectors_kb_handler, &s=
nprint_ovr_max_sectors_kb);
> >       install_keyword("ghost_delay", &ovr_ghost_delay_handler, &snprint=
_ovr_ghost_delay);
> >       install_keyword("all_tg_pt", &ovr_all_tg_pt_handler, &snprint_ovr=
_all_tg_pt);
> > @@ -2400,6 +2413,7 @@ init_keywords(vector keywords)
> >       install_keyword("marginal_path_err_recheck_gap_time", &mp_margina=
l_path_err_recheck_gap_time_handler, &snprint_mp_marginal_path_err_recheck_=
gap_time);
> >       install_keyword("marginal_path_double_failed_time", &mp_marginal_=
path_double_failed_time_handler, &snprint_mp_marginal_path_double_failed_ti=
me);
> >       install_keyword("skip_kpartx", &mp_skip_kpartx_handler, &snprint_=
mp_skip_kpartx);
> > +     install_keyword("purge_disconnected", &mp_purge_disconnected_hand=
ler, &snprint_mp_purge_disconnected);
>
> same issue as above
>
> >       install_keyword("max_sectors_kb", &mp_max_sectors_kb_handler, &sn=
print_mp_max_sectors_kb);
> >       install_keyword("ghost_delay", &mp_ghost_delay_handler, &snprint_=
mp_ghost_delay);
> >       install_sublevel_end();
> > diff --git a/libmultipath/io_err_stat.c b/libmultipath/io_err_stat.c
> > index 64054c18..acb087b7 100644
> > --- a/libmultipath/io_err_stat.c
> > +++ b/libmultipath/io_err_stat.c
> > @@ -397,6 +397,7 @@ static void account_async_io_state(struct io_err_st=
at_path *pp, int rc)
> >       switch (rc) {
> >       case PATH_DOWN:
> >       case PATH_TIMEOUT:
> > +     case PATH_DISCONNECTED:
> >               pp->io_err_nr++;
> >               break;
> >       case PATH_UNCHECKED:
> > diff --git a/libmultipath/print.c b/libmultipath/print.c
> > index 0d44a5a9..8b09b174 100644
> > --- a/libmultipath/print.c
> > +++ b/libmultipath/print.c
> > @@ -541,6 +541,8 @@ snprint_chk_state (struct strbuf *buff, const struc=
t path * pp)
> >               return append_strbuf_str(buff, "i/o timeout");
> >       case PATH_DELAYED:
> >               return append_strbuf_str(buff, "delayed");
> > +     case PATH_DISCONNECTED:
> > +             return append_strbuf_str(buff, "disconnected");
> >       default:
> >               return append_strbuf_str(buff, "undef");
> >       }
> > diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> > index 4c0fbcf3..9a17f1ed 100644
> > --- a/libmultipath/propsel.c
> > +++ b/libmultipath/propsel.c
> > @@ -1371,6 +1371,22 @@ out:
> >       return 0;
> >  }
> >
> > +int select_purge_disconnected (struct config *conf, struct multipath *=
 mp)
> > +{
> > +     const char *origin;
> > +
> > +     mp_set_mpe(purge_disconnected);
>
> Same issue as above
>
> > +     mp_set_ovr(purge_disconnected);
> > +     mp_set_hwe(purge_disconnected);
> > +     mp_set_conf(purge_disconnected);
> > +     mp_set_default(purge_disconnected, DEFAULT_PURGE_DISCONNECTED);
> > +out:
> > +     condlog(3, "%s: purge_disconnected =3D %s %s", mp->alias,
> > +             (mp->purge_disconnected =3D=3D PURGE_DISCONNECTED_ON)? "y=
es" : "no",
> > +             origin);
> > +     return 0;
> > +}
> > +
> >  int select_max_sectors_kb(struct config *conf, struct multipath * mp)
> >  {
> >       const char *origin;
> > diff --git a/libmultipath/propsel.h b/libmultipath/propsel.h
> > index 55930050..c6c937c3 100644
> > --- a/libmultipath/propsel.h
> > +++ b/libmultipath/propsel.h
> > @@ -39,6 +39,7 @@ int select_marginal_path_err_rate_threshold(struct co=
nfig *conf, struct multipat
> >  int select_marginal_path_err_recheck_gap_time(struct config *conf, str=
uct multipath *mp);
> >  int select_marginal_path_double_failed_time(struct config *conf, struc=
t multipath *mp);
> >  int select_ghost_delay(struct config *conf, struct multipath * mp);
> > +int select_purge_disconnected (struct config *conf, struct multipath *=
 mp);
> >  void reconcile_features_with_options(const char *id, char **features,
> >                                    int* no_path_retry,
> >                                    int *retain_hwhandler);
> > diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> > index 9247e74f..bca01f41 100644
> > --- a/libmultipath/structs.h
> > +++ b/libmultipath/structs.h
> > @@ -186,6 +186,12 @@ enum auto_resize_state {
> >       AUTO_RESIZE_GROW_SHRINK,
> >  };
> >
> > +enum purge_disconnected_states {
> > +     PURGE_DISCONNECTED_UNDEF =3D YNU_UNDEF,
> > +     PURGE_DISCONNECTED_OFF =3D YNU_NO,
> > +     PURGE_DISCONNECTED_ON =3D YNU_YES,
> > +};
> > +
> >  #define PROTOCOL_UNSET -1
> >
> >  enum scsi_protocol {
> > @@ -382,6 +388,8 @@ struct path {
> >       int dmstate;
> >       int chkrstate;
> >       int oldstate;
> > +     bool purge_path;
> > +     int purge_retries;  /* number of purge attempts for this path */
> >       int failcount;
> >       int priority;
> >       int pgindex;
> > @@ -483,6 +491,7 @@ struct multipath {
> >       int ghost_delay;
> >       int ghost_delay_tick;
> >       int queue_mode;
> > +     int purge_disconnected;
> >       unsigned int sync_tick;
> >       int checker_count;
> >       enum prio_update_type prio_update;
> > diff --git a/multipath/multipath.conf.5.in b/multipath/multipath.conf.5=
.in
> > index 3c9ae097..1f806da8 100644
> > --- a/multipath/multipath.conf.5.in
> > +++ b/multipath/multipath.conf.5.in
> > @@ -1306,6 +1306,21 @@ The default is: \fBno\fR
> >  .
> >  .
> >  .TP
> > +.B purge_disconnected
> > +If set to
> > +.I yes
> > +, multipathd will automatically remove paths that are in the disconnec=
ted state
> > +by writing to the SCSI device's sysfs delete attribute. This triggers =
kernel-level
> > +device removal. Paths are retried multiple times before being forcibly=
 cleaned up
> > +if the kernel removal fails. This option is useful for cleaning up sta=
le paths
> > +from storage arrays that have been disconnected or removed.
> > +.RS
> > +.TP
> > +The default is: \fBno\fR
> > +.RE
> > +.
> > +.
> > +.TP
> >  .B disable_changed_wwids
> >  (Deprecated) This option is not supported anymore, and will be ignored=
.
> >  .RE
> > @@ -1602,6 +1617,8 @@ section:
> >  .TP
> >  .B skip_kpartx
> >  .TP
> > +.B purge_disconnected
> > +.TP
>
> same issue as above
>
> >  .B max_sectors_kb
> >  .TP
> >  .B ghost_delay
> > @@ -1797,6 +1814,8 @@ section:
> >  .TP
> >  .B skip_kpartx
> >  .TP
> > +.B purge_disconnected
> > +.TP
> >  .B max_sectors_kb
> >  .TP
> >  .B ghost_delay
> > @@ -1881,6 +1900,8 @@ the values are taken from the \fIdevices\fR or \f=
Idefaults\fR sections:
> >  .TP
> >  .B skip_kpartx
> >  .TP
> > +.B purge_disconnected
> > +.TP
> >  .B max_sectors_kb
> >  .TP
> >  .B ghost_delay
> > diff --git a/multipathd/main.c b/multipathd/main.c
> > index d11a8576..a07021c4 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -137,11 +137,14 @@ static enum force_reload_types reconfigure_pendin=
g =3D FORCE_RELOAD_NONE;
>
> I'm not sure that we need a whole new thread for this. Writing to the
> sysfs file should be something that we can do directly in get_new_state.
> I get that we might not want to keep writing to the sysfs file every
> time we check the path (5 seconds by default). How does this sound:
>
> In the path struct, store a purge_retry_tick. In get_new_state(), if the
> state comes back as PATH_DISCONNECTED and purging is enabled, you can
> use the purge_retry_tick to make sure that you only call delete_path()
> every 10 checks or so.
>
> Even if purging isn't enabled, it might be smart to track when a path
> returns PATH_DISCONNECTED, and when that path comes back up again,
> check for a wwid change, even if recheck_wwids isn't set.
>
> I'm also not sure we need the code to forceably remove the path. If
> the path was removed, and we just didn't have a uevent, or it the path
> stopped being a scsi device (I'm not sure how that works), multipathd
> already has code to ignore devices with no sysfs entries. It still
> wouldn't be deleted without the uevent, but we won't keep trying to send
> it delete messages.
>
> And I'm not sure we need to worry about the other case you mentioned,
> where the sysfs interface doesn't exist. Are there SCSI devices where
> the delete sysfs attribute doesn't exist?  That attribute has been
> around for a while.
>
> Or is there an actual case you ran into, that I'm just overlooking,
> where the device needed to be forceably deleted.

I included the other case for why we want to forcibly remove the
device above. It relates to volume mobility where different arrays
provides paths to a device at various points in the migration.

I added the purge thread because I didn't want to starve the
checker thread at a large disconnect volume scale. I noticed
that the number of devices if I purged inline with the check that
it didn't scale linearly after a point and seemed to be significantly
starving the checker thread. Doing the purge in another thread
seemed to relieve that pressure.

>
> If you'd like, I could write a patch with these changes for you to try
> out. Otherwise, you're welcome to revise this and repost. I would also
> like to hear Martin Wilck's opinion on this idea (Cc'ed). For future
> patches, you should Cc both of us.
>
> Thanks.
> -Ben

I definitely am open to any changes and things to optimize this idea.
I definitely want to stick to the actual purging of the sd device however.

Thanks,
Brian

>
> >  pid_t daemon_pid;
> >  static pthread_mutex_t config_lock =3D PTHREAD_MUTEX_INITIALIZER;
> >  static pthread_cond_t config_cond;
> > -static pthread_t check_thr, uevent_thr, uxlsnr_thr, uevq_thr, dmevent_=
thr,
> > -     fpin_thr, fpin_consumer_thr;
> > -static bool check_thr_started, uevent_thr_started, uxlsnr_thr_started,
> > -     uevq_thr_started, dmevent_thr_started, fpin_thr_started,
> > -     fpin_consumer_thr_started;
> > +static pthread_mutex_t purge_mutex =3D PTHREAD_MUTEX_INITIALIZER;
> > +static pthread_cond_t purge_cond =3D PTHREAD_COND_INITIALIZER;
> > +int devices_to_purge =3D 0;
> > +static pthread_t check_thr, purge_thr, uevent_thr, uxlsnr_thr, uevq_th=
r,
> > +     dmevent_thr, fpin_thr, fpin_consumer_thr;
> > +static bool check_thr_started, purge_thr_started, uevent_thr_started,
> > +     uxlsnr_thr_started, uevq_thr_started, dmevent_thr_started,
> > +     fpin_thr_started, fpin_consumer_thr_started;
> >  static int pid_fd =3D -1;
> >
> >  static inline enum daemon_status get_running_state(bool *pending_recon=
fig)
> > @@ -1089,6 +1092,34 @@ check_path_wwid_change(struct path *pp)
> >       return false;
> >  }
> >
> > +/*
> > + * Attempt to delete a path by writing to the SCSI device's sysfs dele=
te attribute.
> > + * This triggers kernel-level device removal. The actual cleanup of th=
e path structure
> > + * from pathvec happens later when a uevent arrives (handled by uev_re=
move_path).
> > + *
> > + * Returns:
> > + *   true  - sysfs write succeeded, uevent expected
> > + *   false - sysfs write failed or device not found
> > + */
> > +static bool
> > +delete_path(struct path * pp)
> > +{
> > +     struct udev_device *ud =3D udev_device_get_parent_with_subsystem_=
devtype(pp->udev,
> > +             "scsi", "scsi_device");
> > +
> > +     if (ud) {
> > +             if (sysfs_attr_set_value(ud, "delete", "1", strlen("1")) =
< 0) {
> > +                     condlog(1, "failed to remove path %s from %s",
> > +                             pp->dev_t, pp->mpp->alias);
> > +                     return false;
> > +             }
> > +             condlog(2, "removed path %s from %s", pp->dev_t, pp->mpp-=
>alias);
> > +             pp->purge_path =3D false;
> > +             return true;
> > +     }
> > +     return false;
> > +}
> > +
> >  /*
> >   * uev_add_path can call uev_update_path, and uev_update_path can call
> >   * uev_add_path
> > @@ -2031,6 +2062,10 @@ reinstate_path (struct path * pp)
> >               condlog(0, "%s: reinstate failed", pp->dev_t);
> >       else {
> >               condlog(2, "%s: reinstated", pp->dev_t);
> > +             if (pp->purge_path) {
> > +                     pp->purge_path =3D false;
> > +                     pp->purge_retries =3D 0;
> > +             }
> >               update_queue_mode_add_path(pp->mpp);
> >       }
> >  }
> > @@ -2474,6 +2509,20 @@ get_new_state(struct path *pp)
> >       if (newstate =3D=3D PATH_REMOVED)
> >               newstate =3D PATH_DOWN;
> >
> > +     /*
> > +      * For PATH_DISOCONNECTED mark the path as OK to purge if that is
> > +      * enabled. Whether or not purge is enabled mark the path as down=
.
> > +      */
> > +     if (newstate =3D=3D PATH_DISCONNECTED) {
> > +             if (pp->mpp->purge_disconnected =3D=3D PURGE_DISCONNECTED=
_ON &&
> > +                 !pp->purge_path) {
> > +                     condlog(2, "%s: mark (%s) path for purge",
> > +                             pp->dev, checker_state_name(newstate));
> > +                     pp->purge_path =3D true;
> > +             }
> > +             newstate =3D PATH_DOWN;
>
> If the goal is to treat PATH_DISCONNECTED as PATH_DOWN aside from the
> purging code, then you need to handle get_state() returning
> PATH_DISCONNECTED in pathinfo() as well. Probably, it should just set
> the state to PATH_DOWN, like it does for PATH_TIMEOUT.
>
> > +     }
> > +
> >       if (newstate =3D=3D PATH_WILD || newstate =3D=3D PATH_UNCHECKED) =
{
> >               condlog(2, "%s: unusable path (%s) - checker failed",
> >                       pp->dev, checker_state_name(newstate));
> > @@ -3022,6 +3071,25 @@ update_paths(struct vectors *vecs, int *num_path=
s_p, time_t start_secs)
> >       return CHECKER_FINISHED;
> >  }
> >
> > +/*
> > + * Check if there are newly marked paths to purge.
> > + * Only returns true for paths with purge_path=3Dtrue and purge_retrie=
s=3D0,
> > + * which indicates they were just marked for purging and haven't been
> > + * attempted yet. This prevents signaling the purge thread unnecessari=
ly
> > + * for paths that are already being retried.
> > + */
> > +static bool
> > +has_paths_to_purge(struct vectors *vecs)
> > +{
> > +     int i;
> > +     struct path *pp;
> > +
> > +     vector_foreach_slot(vecs->pathvec, pp, i)
> > +             if (pp->purge_path && pp->purge_retries =3D=3D 0)
> > +                     return true;
> > +     return false;
> > +}
> > +
> >  static void enable_pathgroups(struct multipath *mpp)
> >  {
> >       struct pathgroup *pgp;
> > @@ -3125,6 +3193,7 @@ checkerloop (void *ap)
> >               int num_paths =3D 0, strict_timing;
> >               unsigned int ticks =3D 0;
> >               enum checker_state checker_state =3D CHECKER_STARTING;
> > +             bool devs_to_purge =3D false;
> >
> >               if (set_config_state(DAEMON_RUNNING) !=3D DAEMON_RUNNING)
> >                       /* daemon shutdown */
> > @@ -3168,8 +3237,10 @@ checkerloop (void *ap)
> >                       if (checker_state =3D=3D CHECKER_UPDATING_PATHS)
> >                               checker_state =3D update_paths(vecs, &num=
_paths,
> >                                                            start_time.t=
v_sec);
> > -                     if (checker_state =3D=3D CHECKER_FINISHED)
> > +                     if (checker_state =3D=3D CHECKER_FINISHED) {
> > +                             devs_to_purge =3D has_paths_to_purge(vecs=
);
> >                               checker_finished(vecs, ticks);
> > +                     }
> >                       lock_cleanup_pop(vecs->lock);
> >               }
> >
> > @@ -3192,6 +3263,13 @@ checkerloop (void *ap)
> >                                       (long)diff_time.tv_sec);
> >               }
> >
> > +             if (devs_to_purge) {
> > +                     pthread_mutex_lock(&purge_mutex);
> > +                     devices_to_purge =3D 1;
> > +                     pthread_cond_signal(&purge_cond);
> > +                     pthread_mutex_unlock(&purge_mutex);
> > +             }
> > +
> >               if (foreign_tick =3D=3D 0) {
> >                       conf =3D get_multipath_config();
> >                       foreign_tick =3D conf->max_checkint;
> > @@ -3229,6 +3307,136 @@ checkerloop (void *ap)
> >       return NULL;
> >  }
> >
> > +/*
> > + * Purge thread: removes disconnected paths by writing to sysfs.
> > + *
> > + * This thread is signaled by the checker thread when paths marked wit=
h
> > + * purge_path=3Dtrue are detected. It attempts to delete these paths b=
y
> > + * writing "1" to their SCSI device's sysfs "delete" attribute.
> > + *
> > + * The actual cleanup of path structures from pathvec happens asynchro=
nously
> > + * when the kernel sends a remove uevent (handled by uev_remove_path).
> > + * If the uevent doesn't arrive or the sysfs write fails, paths will b=
e
> > + * retried on subsequent purge cycles with a timeout mechanism.
> > + */
> > +#define PURGE_TIMEOUT_CYCLES 10  /* ~50 seconds at 5 second check inte=
rvals */
> > +
> > +static void *
> > +purgeloop (void *ap)
> > +{
> > +     struct vectors *vecs;
> > +     struct timespec diff_time, end_time, start_time;
> > +     unsigned int i;
> > +     struct path *pp;
> > +     vecs =3D (struct vectors *)ap;
> > +
> > +     pthread_cleanup_push(rcu_unregister, NULL);
> > +     rcu_register_thread();
> > +     mlockall(MCL_CURRENT | MCL_FUTURE);
> > +
> > +     while (1) {
> > +             int devices_purged =3D 0;
> > +             int devices_failed =3D 0;
> > +             int devices_pending =3D 0;
> > +
> > +             pthread_mutex_lock(&purge_mutex);
> > +             while (!devices_to_purge) {
> > +                     condlog(3, "waiting on devices to purge");
> > +                     pthread_cond_wait(&purge_cond, &purge_mutex);
> > +             }
> > +             /* Reset flag before releasing mutex to avoid race condit=
ion */
> > +             devices_to_purge =3D 0;
> > +             pthread_mutex_unlock(&purge_mutex);
> > +
> > +             condlog(3, "devices available for purge");
> > +             get_monotonic_time(&start_time);
> > +             pthread_cleanup_push(cleanup_lock, &vecs->lock);
> > +             lock(&vecs->lock);
> > +             pthread_testcancel();
> > +
> > +             /*
> > +              * Iterate through all paths and attempt to purge those m=
arked.
> > +              * Use purge_retries as a timeout counter for failed purg=
e attempts.
> > +              */
> > +             vector_foreach_slot (vecs->pathvec, pp, i) {
> > +                     if (!pp->purge_path)
> > +                             continue;
> > +
> > +                     /* Increment timeout counter for this purge attem=
pt */
> > +                     pp->purge_retries++;
> > +
> > +                     if (delete_path(pp)) {
> > +                             /* Success: sysfs write succeeded, uevent=
 expected */
> > +                             devices_purged++;
> > +                             pp->purge_retries =3D 0;
> > +                     } else if (pp->purge_retries >=3D PURGE_TIMEOUT_C=
YCLES) {
> > +                             /*
> > +                              * Timeout: path couldn't be deleted afte=
r multiple attempts.
> > +                              * This can happen if:
> > +                              * - The device is no longer a SCSI devic=
e
> > +                              * - The sysfs interface is unavailable
> > +                              * - The device was already removed but n=
o uevent arrived
> > +                              *
> > +                              * Force cleanup by removing from pathvec=
 and freeing.
> > +                              */
> > +                             condlog(1, "%s: purge timeout after %d at=
tempts, forcing cleanup",
> > +                                     pp->dev, pp->purge_retries);
> > +                             vector_del_slot(vecs->pathvec, i);
> > +                             i--;  /* Adjust iterator after deletion *=
/
> > +                             free_path(pp);
> > +                             devices_failed++;
> > +                     } else {
> > +                             /* Retry on next purge cycle */
> > +                             devices_pending++;
> > +                     }
> > +             }
> > +
> > +             lock_cleanup_pop(vecs->lock);
> > +
> > +             diff_time.tv_nsec =3D 0;
> > +             if (start_time.tv_sec) {
> > +                     get_monotonic_time(&end_time);
> > +                     timespecsub(&end_time, &start_time, &diff_time);
> > +                     if (devices_purged > 0 || devices_failed > 0) {
> > +                             condlog(2, "purged %d path%s, %d failed, =
%d pending in %ld.%06lu secs",
> > +                                     devices_purged, devices_purged > =
1 ? "s" : "",
> > +                                     devices_failed, devices_pending,
> > +                                     (long)diff_time.tv_sec,
> > +                                     diff_time.tv_nsec / 1000);
> > +                     }
> > +             }
> > +
> > +             /*
> > +              * If there are still paths pending purge, sleep for the =
checker
> > +              * cycle interval before retrying. This prevents spinning=
 and
> > +              * ensures the ~5 second retry interval mentioned in PURG=
E_TIMEOUT_CYCLES.
> > +              * We sleep outside the mutex to allow the checker thread=
 to signal
> > +              * us if new paths are marked for purge.
> > +              */
> > +             if (devices_pending > 0) {
> > +                     struct timespec wait_time;
> > +                     struct config *conf;
> > +
> > +                     conf =3D get_multipath_config();
> > +                     wait_time.tv_sec =3D conf->checkint;
> > +                     wait_time.tv_nsec =3D 0;
> > +                     put_multipath_config(conf);
> > +
> > +                     condlog(3, "sleeping %ld seconds before purge ret=
ry",
> > +                             (long)wait_time.tv_sec);
> > +                     nanosleep(&wait_time, NULL);
> > +
> > +                     /* Signal ourselves to process the pending paths =
*/
> > +                     pthread_mutex_lock(&purge_mutex);
> > +                     devices_to_purge =3D 1;
> > +                     pthread_mutex_unlock(&purge_mutex);
> > +             }
> > +     }
> > +
> > +     pthread_cleanup_pop(1);
> > +     return NULL;
> > +}
> > +
> >  static int
> >  configure (struct vectors * vecs, enum force_reload_types reload_type)
> >  {
> > @@ -3669,6 +3877,8 @@ static void cleanup_threads(void)
> >
> >       if (check_thr_started)
> >               pthread_cancel(check_thr);
> > +     if (purge_thr_started)
> > +             pthread_cancel(purge_thr);
> >       if (uevent_thr_started)
> >               pthread_cancel(uevent_thr);
> >       if (uxlsnr_thr_started)
> > @@ -3685,6 +3895,8 @@ static void cleanup_threads(void)
> >
> >       if (check_thr_started)
> >               pthread_join(check_thr, NULL);
> > +     if (purge_thr_started)
> > +             pthread_join(purge_thr, NULL);
> >       if (uevent_thr_started)
> >               pthread_join(uevent_thr, NULL);
> >       if (uxlsnr_thr_started)
> > @@ -3937,6 +4149,11 @@ child (__attribute__((unused)) void *param)
> >               goto failed;
> >       } else
> >               check_thr_started =3D true;
> > +     if ((rc =3D pthread_create(&purge_thr, &misc_attr, purgeloop, vec=
s))) {
> > +             condlog(0,"failed to create purge loop thread: %d", rc);
> > +             goto failed;
> > +     } else
> > +             purge_thr_started =3D true;
> >       if ((rc =3D pthread_create(&uevq_thr, &misc_attr, uevqloop, vecs)=
)) {
> >               condlog(0, "failed to create uevent dispatcher: %d", rc);
> >               goto failed;
> > --
> > 2.51.0
> >
>


--=20
Brian Bunker
PURE Storage, Inc.
brian@purestorage.com
