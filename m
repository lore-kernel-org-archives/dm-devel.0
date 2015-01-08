From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 3/6] libmultipath: add overrides section to
	multipath.conf
Date: Fri, 9 Jan 2015 00:06:29 +0100
Message-ID: <CABr-GndVm5ct_E7UoF86no5b36k8MpLU4KD5pYtO=h1NiT4LGQ@mail.gmail.com>
References: <1416377859-15073-1-git-send-email-bmarzins@redhat.com>
	<1416377859-15073-4-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5220622642520428565=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1416377859-15073-4-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============5220622642520428565==
Content-Type: multipart/alternative; boundary=001a11c373662472d0050c2c1742

--001a11c373662472d0050c2c1742
Content-Type: text/plain; charset=UTF-8

I have no strong opinion on this one : I feel like the complexity of the
parameter inheritance system is already quite complicated ... but this
addition of a new layer would likely and safely be ignored by users who
don't need it. Those who need it are surely ready to pay the price.

Does someone have objection to my applying this patch ?

Best regards,
Christophe



On Wed, Nov 19, 2014 at 7:17 AM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> Sometimes users want to be able to set a configuration value for all their
> devices (for instance, they may want all devices to set no_path_retry to
> fail). The builtin device configurations make this tricky, since users need
> to change each device configuration individually. To avoid that, this patch
> adds a new section to multipath.conf, "overrides".  This section has all of
> the attributes that are in both the devices and defaults section.
> Attributes set in the overrides section have a higher priority that those
> in the devices section. With this section added, the multipath
> configuration order now goes:
>
> multipaths > overrides > devices > defaults
>
> I also made want_user_friendly_names print out where the configuration came
> from, and I made made select_hwhandler and select_selector always strdup
> the string, instead of only on the defaults.  Since multipathd will update
> the device strings from the kernel anyway, the old way just added
> complexity without saving any memory.
>
> To store the overrides configuration, I used a hwentry structure. We may
> want to make a new overrides structure, so that we set any of the defaults
> values in overrides.  That way, users could skip using defaults and just
> use overrides if they wanted. However, this would take some additional
> changes to make sure that all the defaults options can undefined, which
> they can't currently be.
>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/config.c      |  1 +
>  libmultipath/config.h      |  1 +
>  libmultipath/dict.c        | 98
> ++++++++++++++++++++++++++++++++++++++++++++++
>  libmultipath/print.c       | 30 ++++++++++++++
>  libmultipath/print.h       |  1 +
>  libmultipath/propsel.c     | 55 +++++++++++++++++++++-----
>  libmultipath/structs.c     |  9 +----
>  multipath.conf.annotated   | 18 ++++++++-
>  multipath.conf.defaults    |  2 +
>  multipath.conf.synthetic   |  3 ++
>  multipath/main.c           |  6 +++
>  multipath/multipath.conf.5 | 57 +++++++++++++++++++++++++++
>  multipathd/cli_handlers.c  | 10 +++++
>  13 files changed, 273 insertions(+), 18 deletions(-)
>
> diff --git a/libmultipath/config.c b/libmultipath/config.c
> index bfd8ee8..7f7bd5a 100644
> --- a/libmultipath/config.c
> +++ b/libmultipath/config.c
> @@ -523,6 +523,7 @@ free_config (struct config * conf)
>
>         free_mptable(conf->mptable);
>         free_hwtable(conf->hwtable);
> +       free_hwe(conf->overrides);
>         free_keywords(conf->keywords);
>         FREE(conf);
>  }
> diff --git a/libmultipath/config.h b/libmultipath/config.h
> index c57ab31..ef1d7c3 100644
> --- a/libmultipath/config.h
> +++ b/libmultipath/config.h
> @@ -145,6 +145,7 @@ struct config {
>         vector keywords;
>         vector mptable;
>         vector hwtable;
> +       struct hwentry *overrides;
>
>         vector blist_devnode;
>         vector blist_wwid;
> diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> index 98cbe48..737c9b0 100644
> --- a/libmultipath/dict.c
> +++ b/libmultipath/dict.c
> @@ -181,6 +181,22 @@ snprint_hw_ ## option (char * buff, int len, void *
> data)          \
>         return function (buff, len, &hwe->option);                      \
>  }
>
> +#define declare_ovr_handler(option, function)                          \
> +static int                                                             \
> +ovr_ ## option ## _handler (vector strvec)                             \
> +{                                                                      \
> +       if (!conf->overrides)                                           \
> +               return 1;                                               \
> +       return function (strvec, &conf->overrides->option);             \
> +}
> +
> +#define declare_ovr_snprint(option, function)                          \
> +static int                                                             \
> +snprint_ovr_ ## option (char * buff, int len, void * data)             \
> +{                                                                      \
> +       return function (buff, len, &conf->overrides->option);          \
> +}
> +
>  #define declare_mp_handler(option, function)                           \
>  static int                                                             \
>  mp_ ## option ## _handler (vector strvec)                              \
> @@ -218,21 +234,29 @@ declare_def_handler(selector, set_str)
>  declare_def_snprint_defstr(selector, print_str, DEFAULT_SELECTOR)
>  declare_hw_handler(selector, set_str)
>  declare_hw_snprint(selector, print_str)
> +declare_ovr_handler(selector, set_str)
> +declare_ovr_snprint(selector, print_str)
>  declare_mp_handler(selector, set_str)
>  declare_mp_snprint(selector, print_str)
>
>  declare_def_handler(uid_attribute, set_str)
>  declare_def_snprint_defstr(uid_attribute, print_str,
> DEFAULT_UID_ATTRIBUTE)
> +declare_ovr_handler(uid_attribute, set_str)
> +declare_ovr_snprint(uid_attribute, print_str)
>  declare_hw_handler(uid_attribute, set_str)
>  declare_hw_snprint(uid_attribute, print_str)
>
>  declare_def_handler(getuid, set_str)
>  declare_def_snprint(getuid, print_str)
> +declare_ovr_handler(getuid, set_str)
> +declare_ovr_snprint(getuid, print_str)
>  declare_hw_handler(getuid, set_str)
>  declare_hw_snprint(getuid, print_str)
>
>  declare_def_handler(prio_name, set_str)
>  declare_def_snprint_defstr(prio_name, print_str, DEFAULT_PRIO)
> +declare_ovr_handler(prio_name, set_str)
> +declare_ovr_snprint(prio_name, print_str)
>  declare_hw_handler(prio_name, set_str)
>  declare_hw_snprint(prio_name, print_str)
>  declare_mp_handler(prio_name, set_str)
> @@ -240,11 +264,15 @@ declare_mp_snprint(prio_name, print_str)
>
>  declare_def_handler(alias_prefix, set_str)
>  declare_def_snprint_defstr(alias_prefix, print_str, DEFAULT_ALIAS_PREFIX)
> +declare_ovr_handler(alias_prefix, set_str)
> +declare_ovr_snprint(alias_prefix, print_str)
>  declare_hw_handler(alias_prefix, set_str)
>  declare_hw_snprint(alias_prefix, print_str)
>
>  declare_def_handler(prio_args, set_str)
>  declare_def_snprint_defstr(prio_args, print_str, DEFAULT_PRIO_ARGS)
> +declare_ovr_handler(prio_args, set_str)
> +declare_ovr_snprint(prio_args, print_str)
>  declare_hw_handler(prio_args, set_str)
>  declare_hw_snprint(prio_args, print_str)
>  declare_mp_handler(prio_args, set_str)
> @@ -252,6 +280,8 @@ declare_mp_snprint(prio_args, print_str)
>
>  declare_def_handler(features, set_str)
>  declare_def_snprint_defstr(features, print_str, DEFAULT_FEATURES)
> +declare_ovr_handler(features, set_str)
> +declare_ovr_snprint(features, print_str)
>  declare_hw_handler(features, set_str)
>  declare_hw_snprint(features, print_str)
>  declare_mp_handler(features, set_str)
> @@ -259,11 +289,15 @@ declare_mp_snprint(features, print_str)
>
>  declare_def_handler(checker_name, set_str)
>  declare_def_snprint_defstr(checker_name, print_str, DEFAULT_CHECKER)
> +declare_ovr_handler(checker_name, set_str)
> +declare_ovr_snprint(checker_name, print_str)
>  declare_hw_handler(checker_name, set_str)
>  declare_hw_snprint(checker_name, print_str)
>
>  declare_def_handler(minio, set_int)
>  declare_def_snprint_defint(minio, print_int, DEFAULT_MINIO)
> +declare_ovr_handler(minio, set_int)
> +declare_ovr_snprint(minio, print_nonzero)
>  declare_hw_handler(minio, set_int)
>  declare_hw_snprint(minio, print_nonzero)
>  declare_mp_handler(minio, set_int)
> @@ -271,6 +305,8 @@ declare_mp_snprint(minio, print_nonzero)
>
>  declare_def_handler(minio_rq, set_int)
>  declare_def_snprint_defint(minio_rq, print_int, DEFAULT_MINIO_RQ)
> +declare_ovr_handler(minio_rq, set_int)
> +declare_ovr_snprint(minio_rq, print_nonzero)
>  declare_hw_handler(minio_rq, set_int)
>  declare_hw_snprint(minio_rq, print_nonzero)
>  declare_mp_handler(minio_rq, set_int)
> @@ -296,6 +332,8 @@ declare_def_snprint(checker_timeout, print_nonzero)
>
>  declare_def_handler(flush_on_last_del, set_yes_no_undef)
>  declare_def_snprint_defint(flush_on_last_del, print_yes_no_undef, YNU_NO)
> +declare_ovr_handler(flush_on_last_del, set_yes_no_undef)
> +declare_ovr_snprint(flush_on_last_del, print_yes_no_undef)
>  declare_hw_handler(flush_on_last_del, set_yes_no_undef)
>  declare_hw_snprint(flush_on_last_del, print_yes_no_undef)
>  declare_mp_handler(flush_on_last_del, set_yes_no_undef)
> @@ -303,6 +341,8 @@ declare_mp_snprint(flush_on_last_del,
> print_yes_no_undef)
>
>  declare_def_handler(user_friendly_names, set_yes_no_undef)
>  declare_def_snprint_defint(user_friendly_names, print_yes_no_undef,
> YNU_NO)
> +declare_ovr_handler(user_friendly_names, set_yes_no_undef)
> +declare_ovr_snprint(user_friendly_names, print_yes_no_undef)
>  declare_hw_handler(user_friendly_names, set_yes_no_undef)
>  declare_hw_snprint(user_friendly_names, print_yes_no_undef)
>  declare_mp_handler(user_friendly_names, set_yes_no_undef)
> @@ -316,11 +356,15 @@ declare_def_snprint(wwids_file, print_str)
>
>  declare_def_handler(retain_hwhandler, set_yes_no_undef)
>  declare_def_snprint_defint(retain_hwhandler, print_yes_no_undef, YNU_NO)
> +declare_ovr_handler(retain_hwhandler, set_yes_no_undef)
> +declare_ovr_snprint(retain_hwhandler, print_yes_no_undef)
>  declare_hw_handler(retain_hwhandler, set_yes_no_undef)
>  declare_hw_snprint(retain_hwhandler, print_yes_no_undef)
>
>  declare_def_handler(detect_prio, set_yes_no_undef)
>  declare_def_snprint_defint(detect_prio, print_yes_no_undef, YNU_NO)
> +declare_ovr_handler(detect_prio, set_yes_no_undef)
> +declare_ovr_snprint(detect_prio, print_yes_no_undef)
>  declare_hw_handler(detect_prio, set_yes_no_undef)
>  declare_hw_snprint(detect_prio, print_yes_no_undef)
>
> @@ -512,6 +556,8 @@ print_fast_io_fail(char * buff, int len, void *ptr)
>
>  declare_def_handler(fast_io_fail, set_fast_io_fail)
>  declare_def_snprint(fast_io_fail, print_fast_io_fail)
> +declare_ovr_handler(fast_io_fail, set_fast_io_fail)
> +declare_ovr_snprint(fast_io_fail, print_fast_io_fail)
>  declare_hw_handler(fast_io_fail, set_fast_io_fail)
>  declare_hw_snprint(fast_io_fail, print_fast_io_fail)
>
> @@ -548,6 +594,8 @@ print_dev_loss(char * buff, int len, void *ptr)
>
>  declare_def_handler(dev_loss, set_dev_loss)
>  declare_def_snprint(dev_loss, print_dev_loss)
> +declare_ovr_handler(dev_loss, set_dev_loss)
> +declare_ovr_snprint(dev_loss, print_dev_loss)
>  declare_hw_handler(dev_loss, set_dev_loss)
>  declare_hw_snprint(dev_loss, print_dev_loss)
>
> @@ -583,6 +631,8 @@ print_pgpolicy(char * buff, int len, void *ptr)
>
>  declare_def_handler(pgpolicy, set_pgpolicy)
>  declare_def_snprint_defint(pgpolicy, print_pgpolicy, DEFAULT_PGPOLICY)
> +declare_ovr_handler(pgpolicy, set_pgpolicy)
> +declare_ovr_snprint(pgpolicy, print_pgpolicy)
>  declare_hw_handler(pgpolicy, set_pgpolicy)
>  declare_hw_snprint(pgpolicy, print_pgpolicy)
>  declare_mp_handler(pgpolicy, set_pgpolicy)
> @@ -700,6 +750,8 @@ print_rr_weight (char * buff, int len, void *ptr)
>
>  declare_def_handler(rr_weight, set_rr_weight)
>  declare_def_snprint_defint(rr_weight, print_rr_weight, RR_WEIGHT_NONE)
> +declare_ovr_handler(rr_weight, set_rr_weight)
> +declare_ovr_snprint(rr_weight, print_rr_weight)
>  declare_hw_handler(rr_weight, set_rr_weight)
>  declare_hw_snprint(rr_weight, print_rr_weight)
>  declare_mp_handler(rr_weight, set_rr_weight)
> @@ -748,6 +800,8 @@ print_pgfailback (char * buff, int len, void *ptr)
>
>  declare_def_handler(pgfailback, set_pgfailback)
>  declare_def_snprint_defint(pgfailback, print_pgfailback, DEFAULT_FAILBACK)
> +declare_ovr_handler(pgfailback, set_pgfailback)
> +declare_ovr_snprint(pgfailback, print_pgfailback)
>  declare_hw_handler(pgfailback, set_pgfailback)
>  declare_hw_snprint(pgfailback, print_pgfailback)
>  declare_mp_handler(pgfailback, set_pgfailback)
> @@ -793,6 +847,8 @@ print_no_path_retry(char * buff, int len, void *ptr)
>
>  declare_def_handler(no_path_retry, set_no_path_retry)
>  declare_def_snprint(no_path_retry, print_no_path_retry)
> +declare_ovr_handler(no_path_retry, set_no_path_retry)
> +declare_ovr_snprint(no_path_retry, print_no_path_retry)
>  declare_hw_handler(no_path_retry, set_no_path_retry)
>  declare_hw_snprint(no_path_retry, print_no_path_retry)
>  declare_mp_handler(no_path_retry, set_no_path_retry)
> @@ -1061,6 +1117,25 @@ declare_hw_handler(hwhandler, set_str)
>  declare_hw_snprint(hwhandler, print_str)
>
>  /*
> + * overrides handlers
> + */
> +static int
> +overrides_handler(vector strvec)
> +{
> +       struct hwentry * overrides;
> +
> +       overrides = alloc_hwe();
> +
> +       if (!overrides)
> +               return 1;
> +
> +       conf->overrides = overrides;
> +       return 0;
> +}
> +
> +
> +
> +/*
>   * multipaths block handlers
>   */
>  static int
> @@ -1236,6 +1311,29 @@ init_keywords(void)
>         install_keyword("detect_prio", &hw_detect_prio_handler,
> &snprint_hw_detect_prio);
>         install_sublevel_end();
>
> +       install_keyword_root("overrides", &overrides_handler);
> +       install_keyword("path_grouping_policy", &ovr_pgpolicy_handler,
> &snprint_ovr_pgpolicy);
> +       install_keyword("uid_attribute", &ovr_uid_attribute_handler,
> &snprint_ovr_uid_attribute);
> +       install_keyword("getuid_callout", &ovr_getuid_handler,
> &snprint_ovr_getuid);
> +       install_keyword("path_selector", &ovr_selector_handler,
> &snprint_ovr_selector);
> +       install_keyword("path_checker", &ovr_checker_name_handler,
> &snprint_ovr_checker_name);
> +       install_keyword("checker", &ovr_checker_name_handler, NULL);
> +       install_keyword("alias_prefix", &ovr_alias_prefix_handler,
> &snprint_ovr_alias_prefix);
> +       install_keyword("features", &ovr_features_handler,
> &snprint_ovr_features);
> +       install_keyword("prio", &ovr_prio_name_handler,
> &snprint_ovr_prio_name);
> +       install_keyword("prio_args", &ovr_prio_args_handler,
> &snprint_ovr_prio_args);
> +       install_keyword("failback", &ovr_pgfailback_handler,
> &snprint_ovr_pgfailback);
> +       install_keyword("rr_weight", &ovr_rr_weight_handler,
> &snprint_ovr_rr_weight);
> +       install_keyword("no_path_retry", &ovr_no_path_retry_handler,
> &snprint_ovr_no_path_retry);
> +       install_keyword("rr_min_io", &ovr_minio_handler,
> &snprint_ovr_minio);
> +       install_keyword("rr_min_io_rq", &ovr_minio_rq_handler,
> &snprint_ovr_minio_rq);
> +       install_keyword("flush_on_last_del",
> &ovr_flush_on_last_del_handler, &snprint_ovr_flush_on_last_del);
> +       install_keyword("fast_io_fail_tmo", &ovr_fast_io_fail_handler,
> &snprint_ovr_fast_io_fail);
> +       install_keyword("dev_loss_tmo", &ovr_dev_loss_handler,
> &snprint_ovr_dev_loss);
> +       install_keyword("user_friendly_names",
> &ovr_user_friendly_names_handler, &snprint_ovr_user_friendly_names);
> +       install_keyword("retain_attached_hw_handler",
> &ovr_retain_hwhandler_handler, &snprint_ovr_retain_hwhandler);
> +       install_keyword("detect_prio", &ovr_detect_prio_handler,
> &snprint_ovr_detect_prio);
> +
>         install_keyword_root("multipaths", &multipaths_handler);
>         install_keyword_multi("multipath", &multipath_handler, NULL);
>         install_sublevel();
> diff --git a/libmultipath/print.c b/libmultipath/print.c
> index 383eae4..ade3841 100644
> --- a/libmultipath/print.c
> +++ b/libmultipath/print.c
> @@ -1080,6 +1080,36 @@ snprint_mptable (char * buff, int len, vector
> mptable)
>  }
>
>  extern int
> +snprint_overrides (char * buff, int len, struct hwentry *overrides)
> +{
> +       int fwd = 0;
> +       int i;
> +       struct keyword *rootkw;
> +       struct keyword *kw;
> +
> +       rootkw = find_keyword(NULL, "overrides");
> +       if (!rootkw)
> +               return 0;
> +
> +       fwd += snprintf(buff + fwd, len - fwd, "overrides {\n");
> +       if (fwd > len)
> +               return len;
> +       if (!overrides)
> +               goto out;
> +       iterate_sub_keywords(rootkw, kw, i) {
> +               fwd += snprint_keyword(buff + fwd, len - fwd, "\t%k %v\n",
> +                                      kw, NULL);
> +               if (fwd > len)
> +                       return len;
> +       }
> +out:
> +       fwd += snprintf(buff + fwd, len - fwd, "}\n");
> +       if (fwd > len)
> +               return len;
> +       return fwd;
> +}
> +
> +extern int
>  snprint_defaults (char * buff, int len)
>  {
>         int fwd = 0;
> diff --git a/libmultipath/print.h b/libmultipath/print.h
> index aef182b..a3c3319 100644
> --- a/libmultipath/print.h
> +++ b/libmultipath/print.h
> @@ -50,6 +50,7 @@ int snprint_status (char *, int, struct vectors *);
>  int snprint_devices (char *, int, struct vectors *);
>  int snprint_hwtable (char *, int, vector);
>  int snprint_mptable (char *, int, vector);
> +int snprint_overrides (char *, int, struct hwentry *);
>
>  void print_multipath_topology (struct multipath * mpp, int verbosity);
>  void print_path (struct path * pp, char * style);
> diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> index f2ab7d2..440802c 100644
> --- a/libmultipath/propsel.c
> +++ b/libmultipath/propsel.c
> @@ -48,6 +48,8 @@ do {
>               \
>  do_set(var, mp->mpe, mp->var, "(LUN setting)")
>  #define mp_set_hwe(var)
>       \
>  do_set(var, mp->hwe, mp->var, "(controller setting)")
> +#define mp_set_ovr(var)
>       \
> +do_set(var, conf->overrides, mp->var, "(overrides setting)")
>  #define mp_set_conf(var)                                               \
>  do_set(var, conf, mp->var, "(config file default)")
>  #define mp_set_default(var, value)                                     \
> @@ -59,6 +61,8 @@ do_set(var, mpe, pp->var, "(LUN setting)")
>  do_set(var, pp->hwe, pp->var, "(controller setting)")
>  #define pp_set_conf(var)                                               \
>  do_set(var, conf, pp->var, "(config file default)")
> +#define pp_set_ovr(var)
>       \
> +do_set(var, conf->overrides, pp->var, "(overrides setting)")
>  #define pp_set_default(var, value)                                     \
>  do_default(pp->var, value)
>
> @@ -130,6 +134,7 @@ select_rr_weight (struct multipath * mp)
>         char *origin, buff[13];
>
>         mp_set_mpe(rr_weight);
> +       mp_set_ovr(rr_weight);
>         mp_set_hwe(rr_weight);
>         mp_set_conf(rr_weight);
>         mp_set_default(rr_weight, RR_WEIGHT_NONE);
> @@ -145,6 +150,7 @@ select_pgfailback (struct multipath * mp)
>         char *origin, buff[13];
>
>         mp_set_mpe(pgfailback);
> +       mp_set_ovr(pgfailback);
>         mp_set_hwe(pgfailback);
>         mp_set_conf(pgfailback);
>         mp_set_default(pgfailback, DEFAULT_FAILBACK);
> @@ -165,6 +171,7 @@ select_pgpolicy (struct multipath * mp)
>                 goto out;
>         }
>         mp_set_mpe(pgpolicy);
> +       mp_set_ovr(pgpolicy);
>         mp_set_hwe(pgpolicy);
>         mp_set_conf(pgpolicy);
>         mp_set_default(pgpolicy, DEFAULT_PGPOLICY);
> @@ -181,10 +188,12 @@ select_selector (struct multipath * mp)
>         char *origin;
>
>         mp_set_mpe(selector);
> +       mp_set_ovr(selector);
>         mp_set_hwe(selector);
>         mp_set_conf(selector);
> -       mp_set_default(selector, set_default(DEFAULT_SELECTOR));
> +       mp_set_default(selector, DEFAULT_SELECTOR);
>  out:
> +       mp->selector = STRDUP(mp->selector);
>         condlog(3, "%s: path_selector = \"%s\" %s", mp->alias,
> mp->selector,
>                 origin);
>         return 0;
> @@ -195,6 +204,7 @@ select_alias_prefix (struct multipath * mp)
>  {
>         char *origin;
>
> +       mp_set_ovr(alias_prefix);
>         mp_set_hwe(alias_prefix);
>         mp_set_conf(alias_prefix);
>         mp_set_default(alias_prefix, DEFAULT_ALIAS_PREFIX);
> @@ -206,19 +216,30 @@ out:
>  static int
>  want_user_friendly_names(struct multipath * mp)
>  {
> -       if (mp->mpe &&
> -           mp->mpe->user_friendly_names != USER_FRIENDLY_NAMES_UNDEF)
> -               return (mp->mpe->user_friendly_names ==
> USER_FRIENDLY_NAMES_ON);
> -       if (mp->hwe &&
> -           mp->hwe->user_friendly_names != USER_FRIENDLY_NAMES_UNDEF)
> -               return (mp->hwe->user_friendly_names ==
> USER_FRIENDLY_NAMES_ON);
> -       return (conf->user_friendly_names  == USER_FRIENDLY_NAMES_ON);
> +
> +       char *origin;
> +       int user_friendly_names;
> +
> +       do_set(user_friendly_names, mp->mpe, user_friendly_names,
> +              "(LUN setting)");
> +       do_set(user_friendly_names, conf->overrides, user_friendly_names,
> +              "(overrides setting)");
> +       do_set(user_friendly_names, mp->hwe, user_friendly_names,
> +              "(controller setting)");
> +       do_set(user_friendly_names, conf, user_friendly_names,
> +              "(config file setting)");
> +       do_default(user_friendly_names, USER_FRIENDLY_NAMES_OFF);
> +out:
> +       condlog(3, "%s: user_friendly_names = %s %s", mp->wwid,
> +               (user_friendly_names == USER_FRIENDLY_NAMES_ON)? "yes" :
> "no",
> +               origin);
> +       return (user_friendly_names == USER_FRIENDLY_NAMES_ON);
>  }
>
>  extern int
>  select_alias (struct multipath * mp)
>  {
> -       char *origin;
> +       char *origin = NULL;
>
>         if (mp->mpe && mp->mpe->alias) {
>                 mp->alias = STRDUP(mp->mpe->alias);
> @@ -261,6 +282,7 @@ select_features (struct multipath * mp)
>         char *origin;
>
>         mp_set_mpe(features);
> +       mp_set_ovr(features);
>         mp_set_hwe(features);
>         mp_set_conf(features);
>         mp_set_default(features, DEFAULT_FEATURES);
> @@ -287,8 +309,9 @@ select_hwhandler (struct multipath * mp)
>
>         mp_set_hwe(hwhandler);
>         mp_set_conf(hwhandler);
> -       mp_set_default(hwhandler, set_default(DEFAULT_HWHANDLER));
> +       mp_set_default(hwhandler, DEFAULT_HWHANDLER);
>  out:
> +       mp->hwhandler = STRDUP(mp->hwhandler);
>         condlog(3, "%s: hardware_handler = \"%s\" %s", mp->alias,
> mp->hwhandler,
>                 origin);
>         return 0;
> @@ -300,6 +323,7 @@ select_checker(struct path *pp)
>         char *origin, *checker_name;
>         struct checker * c = &pp->checker;
>
> +       do_set(checker_name, conf->overrides, checker_name, "(overrides
> setting)");
>         do_set(checker_name, pp->hwe, checker_name, "(controller
> setting)");
>         do_set(checker_name, conf, checker_name, "(config file setting)");
>         do_default(checker_name, DEFAULT_CHECKER);
> @@ -327,6 +351,8 @@ select_getuid (struct path * pp)
>  {
>         char *origin;
>
> +       pp_set_ovr(uid_attribute);
> +       pp_set_ovr(getuid);
>         pp_set_hwe(uid_attribute);
>         pp_set_hwe(getuid);
>         pp_set_conf(uid_attribute);
> @@ -383,6 +409,7 @@ select_prio (struct path * pp)
>         }
>         mpe = find_mpe(pp->wwid);
>         set_prio(mpe, "(LUN setting)");
> +       set_prio(conf->overrides, "(overrides setting)");
>         set_prio(pp->hwe, "controller setting)");
>         set_prio(conf, "(config file default)");
>         prio_get(p, DEFAULT_PRIO, DEFAULT_PRIO_ARGS);
> @@ -405,6 +432,7 @@ select_no_path_retry(struct multipath *mp)
>                 return 0;
>         }
>         mp_set_mpe(no_path_retry);
> +       mp_set_ovr(no_path_retry);
>         mp_set_hwe(no_path_retry);
>         mp_set_conf(no_path_retry);
>  out:
> @@ -427,6 +455,7 @@ select_minio_rq (struct multipath * mp)
>         char *origin;
>
>         do_set(minio_rq, mp->mpe, mp->minio, "(LUN setting)");
> +       do_set(minio_rq, conf->overrides, mp->minio, "(overrides
> setting)");
>         do_set(minio_rq, mp->hwe, mp->minio, "(controller setting)");
>         do_set(minio_rq, conf, mp->minio, "(config file setting)");
>         do_default(mp->minio, DEFAULT_MINIO_RQ);
> @@ -441,6 +470,7 @@ select_minio_bio (struct multipath * mp)
>         char *origin;
>
>         mp_set_mpe(minio);
> +       mp_set_ovr(minio);
>         mp_set_hwe(minio);
>         mp_set_conf(minio);
>         mp_set_default(minio, DEFAULT_MINIO);
> @@ -465,6 +495,7 @@ select_fast_io_fail(struct multipath *mp)
>  {
>         char *origin, buff[12];
>
> +       mp_set_ovr(fast_io_fail);
>         mp_set_hwe(fast_io_fail);
>         mp_set_conf(fast_io_fail);
>         mp_set_default(fast_io_fail, DEFAULT_FAST_IO_FAIL);
> @@ -479,6 +510,7 @@ select_dev_loss(struct multipath *mp)
>  {
>         char *origin, buff[12];
>
> +       mp_set_ovr(dev_loss);
>         mp_set_hwe(dev_loss);
>         mp_set_conf(dev_loss);
>         mp->dev_loss = 0;
> @@ -497,6 +529,7 @@ select_flush_on_last_del(struct multipath *mp)
>         if (mp->flush_on_last_del == FLUSH_IN_PROGRESS)
>                 return 0;
>         mp_set_mpe(flush_on_last_del);
> +       mp_set_ovr(flush_on_last_del);
>         mp_set_hwe(flush_on_last_del);
>         mp_set_conf(flush_on_last_del);
>         mp_set_default(flush_on_last_del, FLUSH_DISABLED);
> @@ -532,6 +565,7 @@ select_retain_hwhandler (struct multipath * mp)
>                 origin = "(requires kernel version >= 1.5.0)";
>                 goto out;
>         }
> +       mp_set_ovr(retain_hwhandler);
>         mp_set_hwe(retain_hwhandler);
>         mp_set_conf(retain_hwhandler);
>         mp_set_default(retain_hwhandler, DEFAULT_RETAIN_HWHANDLER);
> @@ -547,6 +581,7 @@ select_detect_prio (struct path * pp)
>  {
>         char *origin;
>
> +       pp_set_ovr(detect_prio);
>         pp_set_hwe(detect_prio);
>         pp_set_conf(detect_prio);
>         pp_set_default(detect_prio, DEFAULT_DETECT_PRIO);
> diff --git a/libmultipath/structs.c b/libmultipath/structs.c
> index 30d247d..0538327 100644
> --- a/libmultipath/structs.c
> +++ b/libmultipath/structs.c
> @@ -206,10 +206,7 @@ free_multipath_attributes (struct multipath * mpp)
>         if (!mpp)
>                 return;
>
> -       if (mpp->selector &&
> -           mpp->selector != conf->selector &&
> -           (!mpp->mpe || (mpp->mpe && mpp->selector !=
> mpp->mpe->selector)) &&
> -           (!mpp->hwe || (mpp->hwe && mpp->selector !=
> mpp->hwe->selector))) {
> +       if (mpp->selector) {
>                 FREE(mpp->selector);
>                 mpp->selector = NULL;
>         }
> @@ -219,9 +216,7 @@ free_multipath_attributes (struct multipath * mpp)
>                 mpp->features = NULL;
>         }
>
> -       if (mpp->hwhandler &&
> -           mpp->hwhandler != conf->hwhandler &&
> -           (!mpp->hwe || (mpp->hwe && mpp->hwhandler !=
> mpp->hwe->hwhandler))) {
> +       if (mpp->hwhandler) {
>                 FREE(mpp->hwhandler);
>                 mpp->hwhandler = NULL;
>         }
> diff --git a/multipath.conf.annotated b/multipath.conf.annotated
> index 0af1d4c..71afc0a 100644
> --- a/multipath.conf.annotated
> +++ b/multipath.conf.annotated
> @@ -485,7 +485,8 @@
>  ## scope : multipath & multipathd
>  ## desc  : list of per storage controller settings
>  ##       overrides default settings (device_maps block)
> -##         overriden by per multipath settings (multipaths block)
> +##        overriden by per multipath settings (multipaths block)
> +##       and the overrides settings (overrides block)
>  ##
>  #devices {
>  #      #
> @@ -651,3 +652,18 @@
>  #              rr_weight               priorities
>  #      }
>  #}
> +#
> +##
> +## name  : devices
> +## scope : multipath & multipathd
> +## desc  : list of settings to override all hadware settings for all
> devices
> +##       overrides default settings (device_maps block)
> +##       and per device type settings (devices block)
> +##        overriden by per multipath settings (multipaths block)
> +##
> +#      attributes and values are identical to the device block
> +#
> +#overrides {
> +#      dev_loss_tmo            60
> +#      no_path_retry           fail
> +#}
> diff --git a/multipath.conf.defaults b/multipath.conf.defaults
> index 654be97..1c65e02 100644
> --- a/multipath.conf.defaults
> +++ b/multipath.conf.defaults
> @@ -912,3 +912,5 @@
>  #}
>  #multipaths {
>  #}
> +#overrides {
> +#}
> diff --git a/multipath.conf.synthetic b/multipath.conf.synthetic
> index bda1b75..f7b9b8a 100644
> --- a/multipath.conf.synthetic
> +++ b/multipath.conf.synthetic
> @@ -72,3 +72,6 @@
>  #              path_grouping_policy    multibus
>  #      }
>  #}
> +#overrides {
> +#      no_path_retry                   fail
> +#}
> diff --git a/multipath/main.c b/multipath/main.c
> index fd6262f..ea453b4 100644
> --- a/multipath/main.c
> +++ b/multipath/main.c
> @@ -405,6 +405,12 @@ dump_config (void)
>                         reply = REALLOC(reply, maxlen *= 2);
>                         continue;
>                 }
> +               c += snprint_overrides(c, reply + maxlen - c,
> conf->overrides);
> +               again = ((c - reply) == maxlen);
> +               if (again) {
> +                       reply = REALLOC(reply, maxlen *= 2);
> +                       continue;
> +               }
>                 c += snprint_mptable(c, reply + maxlen - c, conf->mptable);
>                 again = ((c - reply) == maxlen);
>                 if (again)
> diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> index cadb34d..b823990 100644
> --- a/multipath/multipath.conf.5
> +++ b/multipath/multipath.conf.5
> @@ -61,6 +61,10 @@ the udev attribute given by the
>  .TP
>  .B devices
>  This section defines the device-specific settings.
> +.TP
> +.B overrides
> +This section defines values for attributes that should override the
> +device-specific settings for all devices.
>  .RE
>  .LP
>  .SH "defaults section"
> @@ -629,6 +633,59 @@ section:
>  .RE
>  .PD
>  .LP
> +.SH "overrides section"
> +The overrides section recognizes the following optional attributes; if
> not set
> +the values are taken from the
> +.I devices
> +or
> +.I defaults
> +sections:
> +.sp 1
> +.PD .1v
> +.RS
> +.TP 18
> +.B path_grouping_policy
> +.TP
> +.B uid_attribute
> +.TP
> +.B getuid_callout
> +.TP
> +.B path_selector
> +.TP
> +.B path_checker
> +.TP
> +.B alias_prefix
> +.TP
> +.B features
> +.TP
> +.B prio
> +.TP
> +.B prio_args
> +.TP
> +.B failback
> +.TP
> +.B rr_weight
> +.TP
> +.B no_path_retry
> +.TP
> +.B rr_min_io
> +.TP
> +.B rr_min_io_rq
> +.TP
> +.B flush_on_last_del
> +.TP
> +.B fast_io_fail_tmo
> +.TP
> +.B dev_loss_tmo
> +.TP
> +.B user_friendly_names
> +.TP
> +.B retain_attached_hw_handler
> +.TP
> +.B detect_prio
> +.RE
> +.PD
> +.LP
>  .SH "KNOWN ISSUES"
>  The usage of
>  .B queue_if_no_path
> diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> index b086340..0ce1408 100644
> --- a/multipathd/cli_handlers.c
> +++ b/multipathd/cli_handlers.c
> @@ -190,6 +190,16 @@ show_config (char ** r, int * len)
>                         maxlen *= 2;
>                         continue;
>                 }
> +               c += snprint_overrides(c, reply + maxlen - c,
> conf->overrides);
> +               again = ((c - reply) == maxlen);
> +               if (again) {
> +                       reply = REALLOC(reply, maxlen * 2);
> +                       if (!reply)
> +                               return 1;
> +                       memset(reply + maxlen, 0, maxlen);
> +                       maxlen *= 2;
> +                       continue;
> +               }
>                 c += snprint_mptable(c, reply + maxlen - c, conf->mptable);
>                 again = ((c - reply) == maxlen);
>                 REALLOC_REPLY(reply, again, maxlen);
> --
> 1.8.3.1
>
>

--001a11c373662472d0050c2c1742
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I have no strong opinion on this one : I feel like the com=
plexity of the parameter inheritance system is already quite complicated ..=
. but this addition of a new layer would likely and safely be ignored by us=
ers who don&#39;t need it. Those who need it are surely ready to pay the pr=
ice.<div><br></div><div>Does someone have objection to my applying this pat=
ch ?</div><div><br></div><div>Best regards,</div><div>Christophe</div><div>=
<br></div><div><br></div></div><div class=3D"gmail_extra"><br><div class=3D=
"gmail_quote">On Wed, Nov 19, 2014 at 7:17 AM, Benjamin Marzinski <span dir=
=3D"ltr">&lt;<a href=3D"mailto:bmarzins@redhat.com" target=3D"_blank">bmarz=
ins@redhat.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" s=
tyle=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">Some=
times users want to be able to set a configuration value for all their<br>
devices (for instance, they may want all devices to set no_path_retry to<br=
>
fail). The builtin device configurations make this tricky, since users need=
<br>
to change each device configuration individually. To avoid that, this patch=
<br>
adds a new section to multipath.conf, &quot;overrides&quot;.=C2=A0 This sec=
tion has all of<br>
the attributes that are in both the devices and defaults section.<br>
Attributes set in the overrides section have a higher priority that those<b=
r>
in the devices section. With this section added, the multipath<br>
configuration order now goes:<br>
<br>
multipaths &gt; overrides &gt; devices &gt; defaults<br>
<br>
I also made want_user_friendly_names print out where the configuration came=
<br>
from, and I made made select_hwhandler and select_selector always strdup<br=
>
the string, instead of only on the defaults.=C2=A0 Since multipathd will up=
date<br>
the device strings from the kernel anyway, the old way just added<br>
complexity without saving any memory.<br>
<br>
To store the overrides configuration, I used a hwentry structure. We may<br=
>
want to make a new overrides structure, so that we set any of the defaults<=
br>
values in overrides.=C2=A0 That way, users could skip using defaults and ju=
st<br>
use overrides if they wanted. However, this would take some additional<br>
changes to make sure that all the defaults options can undefined, which<br>
they can&#39;t currently be.<br>
<br>
Signed-off-by: Benjamin Marzinski &lt;<a href=3D"mailto:bmarzins@redhat.com=
">bmarzins@redhat.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/config.c=C2=A0 =C2=A0 =C2=A0 |=C2=A0 1 +<br>
=C2=A0libmultipath/config.h=C2=A0 =C2=A0 =C2=A0 |=C2=A0 1 +<br>
=C2=A0libmultipath/dict.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 | 98 +++++++++++++++++=
+++++++++++++++++++++++++++++<br>
=C2=A0libmultipath/print.c=C2=A0 =C2=A0 =C2=A0 =C2=A0| 30 ++++++++++++++<br=
>
=C2=A0libmultipath/print.h=C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 1 +<br>
=C2=A0libmultipath/propsel.c=C2=A0 =C2=A0 =C2=A0| 55 +++++++++++++++++++++-=
----<br>
=C2=A0libmultipath/structs.c=C2=A0 =C2=A0 =C2=A0|=C2=A0 9 +----<br>
=C2=A0multipath.conf.annotated=C2=A0 =C2=A0| 18 ++++++++-<br>
=C2=A0multipath.conf.defaults=C2=A0 =C2=A0 |=C2=A0 2 +<br>
=C2=A0multipath.conf.synthetic=C2=A0 =C2=A0|=C2=A0 3 ++<br>
=C2=A0multipath/main.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 6 ++=
+<br>
=C2=A0multipath/multipath.conf.5 | 57 +++++++++++++++++++++++++++<br>
=C2=A0multipathd/cli_handlers.c=C2=A0 | 10 +++++<br>
=C2=A013 files changed, 273 insertions(+), 18 deletions(-)<br>
<br>
diff --git a/libmultipath/config.c b/libmultipath/config.c<br>
index bfd8ee8..7f7bd5a 100644<br>
--- a/libmultipath/config.c<br>
+++ b/libmultipath/config.c<br>
@@ -523,6 +523,7 @@ free_config (struct config * conf)<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 free_mptable(conf-&gt;mptable);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 free_hwtable(conf-&gt;hwtable);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0free_hwe(conf-&gt;overrides);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 free_keywords(conf-&gt;keywords);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 FREE(conf);<br>
=C2=A0}<br>
diff --git a/libmultipath/config.h b/libmultipath/config.h<br>
index c57ab31..ef1d7c3 100644<br>
--- a/libmultipath/config.h<br>
+++ b/libmultipath/config.h<br>
@@ -145,6 +145,7 @@ struct config {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 vector keywords;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 vector mptable;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 vector hwtable;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct hwentry *overrides;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 vector blist_devnode;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 vector blist_wwid;<br>
diff --git a/libmultipath/dict.c b/libmultipath/dict.c<br>
index 98cbe48..737c9b0 100644<br>
--- a/libmultipath/dict.c<br>
+++ b/libmultipath/dict.c<br>
@@ -181,6 +181,22 @@ snprint_hw_ ## option (char * buff, int len, void * da=
ta)=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 \<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return function (buff, len, &amp;hwe-&gt;option=
);=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 \<br>
=C2=A0}<br>
<br>
+#define declare_ovr_handler(option, function)=C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 \<br>
+static int=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0\<br>
+ovr_ ## option ## _handler (vector strvec)=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0\<=
br>
+{=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 \<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!conf-&gt;overrides)=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0\<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 1;=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0\<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return function (strvec, &amp;conf-&gt;override=
s-&gt;option);=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0\<br>
+}<br>
+<br>
+#define declare_ovr_snprint(option, function)=C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 \<br>
+static int=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0\<br>
+snprint_ovr_ ## option (char * buff, int len, void * data)=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0\<br>
+{=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 \<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return function (buff, len, &amp;conf-&gt;overr=
ides-&gt;option);=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 \<br>
+}<br>
+<br>
=C2=A0#define declare_mp_handler(option, function)=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0\<=
br>
=C2=A0static int=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0\<br>
=C2=A0mp_ ## option ## _handler (vector strvec)=C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 \<br>
@@ -218,21 +234,29 @@ declare_def_handler(selector, set_str)<br>
=C2=A0declare_def_snprint_defstr(selector, print_str, DEFAULT_SELECTOR)<br>
=C2=A0declare_hw_handler(selector, set_str)<br>
=C2=A0declare_hw_snprint(selector, print_str)<br>
+declare_ovr_handler(selector, set_str)<br>
+declare_ovr_snprint(selector, print_str)<br>
=C2=A0declare_mp_handler(selector, set_str)<br>
=C2=A0declare_mp_snprint(selector, print_str)<br>
<br>
=C2=A0declare_def_handler(uid_attribute, set_str)<br>
=C2=A0declare_def_snprint_defstr(uid_attribute, print_str, DEFAULT_UID_ATTR=
IBUTE)<br>
+declare_ovr_handler(uid_attribute, set_str)<br>
+declare_ovr_snprint(uid_attribute, print_str)<br>
=C2=A0declare_hw_handler(uid_attribute, set_str)<br>
=C2=A0declare_hw_snprint(uid_attribute, print_str)<br>
<br>
=C2=A0declare_def_handler(getuid, set_str)<br>
=C2=A0declare_def_snprint(getuid, print_str)<br>
+declare_ovr_handler(getuid, set_str)<br>
+declare_ovr_snprint(getuid, print_str)<br>
=C2=A0declare_hw_handler(getuid, set_str)<br>
=C2=A0declare_hw_snprint(getuid, print_str)<br>
<br>
=C2=A0declare_def_handler(prio_name, set_str)<br>
=C2=A0declare_def_snprint_defstr(prio_name, print_str, DEFAULT_PRIO)<br>
+declare_ovr_handler(prio_name, set_str)<br>
+declare_ovr_snprint(prio_name, print_str)<br>
=C2=A0declare_hw_handler(prio_name, set_str)<br>
=C2=A0declare_hw_snprint(prio_name, print_str)<br>
=C2=A0declare_mp_handler(prio_name, set_str)<br>
@@ -240,11 +264,15 @@ declare_mp_snprint(prio_name, print_str)<br>
<br>
=C2=A0declare_def_handler(alias_prefix, set_str)<br>
=C2=A0declare_def_snprint_defstr(alias_prefix, print_str, DEFAULT_ALIAS_PRE=
FIX)<br>
+declare_ovr_handler(alias_prefix, set_str)<br>
+declare_ovr_snprint(alias_prefix, print_str)<br>
=C2=A0declare_hw_handler(alias_prefix, set_str)<br>
=C2=A0declare_hw_snprint(alias_prefix, print_str)<br>
<br>
=C2=A0declare_def_handler(prio_args, set_str)<br>
=C2=A0declare_def_snprint_defstr(prio_args, print_str, DEFAULT_PRIO_ARGS)<b=
r>
+declare_ovr_handler(prio_args, set_str)<br>
+declare_ovr_snprint(prio_args, print_str)<br>
=C2=A0declare_hw_handler(prio_args, set_str)<br>
=C2=A0declare_hw_snprint(prio_args, print_str)<br>
=C2=A0declare_mp_handler(prio_args, set_str)<br>
@@ -252,6 +280,8 @@ declare_mp_snprint(prio_args, print_str)<br>
<br>
=C2=A0declare_def_handler(features, set_str)<br>
=C2=A0declare_def_snprint_defstr(features, print_str, DEFAULT_FEATURES)<br>
+declare_ovr_handler(features, set_str)<br>
+declare_ovr_snprint(features, print_str)<br>
=C2=A0declare_hw_handler(features, set_str)<br>
=C2=A0declare_hw_snprint(features, print_str)<br>
=C2=A0declare_mp_handler(features, set_str)<br>
@@ -259,11 +289,15 @@ declare_mp_snprint(features, print_str)<br>
<br>
=C2=A0declare_def_handler(checker_name, set_str)<br>
=C2=A0declare_def_snprint_defstr(checker_name, print_str, DEFAULT_CHECKER)<=
br>
+declare_ovr_handler(checker_name, set_str)<br>
+declare_ovr_snprint(checker_name, print_str)<br>
=C2=A0declare_hw_handler(checker_name, set_str)<br>
=C2=A0declare_hw_snprint(checker_name, print_str)<br>
<br>
=C2=A0declare_def_handler(minio, set_int)<br>
=C2=A0declare_def_snprint_defint(minio, print_int, DEFAULT_MINIO)<br>
+declare_ovr_handler(minio, set_int)<br>
+declare_ovr_snprint(minio, print_nonzero)<br>
=C2=A0declare_hw_handler(minio, set_int)<br>
=C2=A0declare_hw_snprint(minio, print_nonzero)<br>
=C2=A0declare_mp_handler(minio, set_int)<br>
@@ -271,6 +305,8 @@ declare_mp_snprint(minio, print_nonzero)<br>
<br>
=C2=A0declare_def_handler(minio_rq, set_int)<br>
=C2=A0declare_def_snprint_defint(minio_rq, print_int, DEFAULT_MINIO_RQ)<br>
+declare_ovr_handler(minio_rq, set_int)<br>
+declare_ovr_snprint(minio_rq, print_nonzero)<br>
=C2=A0declare_hw_handler(minio_rq, set_int)<br>
=C2=A0declare_hw_snprint(minio_rq, print_nonzero)<br>
=C2=A0declare_mp_handler(minio_rq, set_int)<br>
@@ -296,6 +332,8 @@ declare_def_snprint(checker_timeout, print_nonzero)<br>
<br>
=C2=A0declare_def_handler(flush_on_last_del, set_yes_no_undef)<br>
=C2=A0declare_def_snprint_defint(flush_on_last_del, print_yes_no_undef, YNU=
_NO)<br>
+declare_ovr_handler(flush_on_last_del, set_yes_no_undef)<br>
+declare_ovr_snprint(flush_on_last_del, print_yes_no_undef)<br>
=C2=A0declare_hw_handler(flush_on_last_del, set_yes_no_undef)<br>
=C2=A0declare_hw_snprint(flush_on_last_del, print_yes_no_undef)<br>
=C2=A0declare_mp_handler(flush_on_last_del, set_yes_no_undef)<br>
@@ -303,6 +341,8 @@ declare_mp_snprint(flush_on_last_del, print_yes_no_unde=
f)<br>
<br>
=C2=A0declare_def_handler(user_friendly_names, set_yes_no_undef)<br>
=C2=A0declare_def_snprint_defint(user_friendly_names, print_yes_no_undef, Y=
NU_NO)<br>
+declare_ovr_handler(user_friendly_names, set_yes_no_undef)<br>
+declare_ovr_snprint(user_friendly_names, print_yes_no_undef)<br>
=C2=A0declare_hw_handler(user_friendly_names, set_yes_no_undef)<br>
=C2=A0declare_hw_snprint(user_friendly_names, print_yes_no_undef)<br>
=C2=A0declare_mp_handler(user_friendly_names, set_yes_no_undef)<br>
@@ -316,11 +356,15 @@ declare_def_snprint(wwids_file, print_str)<br>
<br>
=C2=A0declare_def_handler(retain_hwhandler, set_yes_no_undef)<br>
=C2=A0declare_def_snprint_defint(retain_hwhandler, print_yes_no_undef, YNU_=
NO)<br>
+declare_ovr_handler(retain_hwhandler, set_yes_no_undef)<br>
+declare_ovr_snprint(retain_hwhandler, print_yes_no_undef)<br>
=C2=A0declare_hw_handler(retain_hwhandler, set_yes_no_undef)<br>
=C2=A0declare_hw_snprint(retain_hwhandler, print_yes_no_undef)<br>
<br>
=C2=A0declare_def_handler(detect_prio, set_yes_no_undef)<br>
=C2=A0declare_def_snprint_defint(detect_prio, print_yes_no_undef, YNU_NO)<b=
r>
+declare_ovr_handler(detect_prio, set_yes_no_undef)<br>
+declare_ovr_snprint(detect_prio, print_yes_no_undef)<br>
=C2=A0declare_hw_handler(detect_prio, set_yes_no_undef)<br>
=C2=A0declare_hw_snprint(detect_prio, print_yes_no_undef)<br>
<br>
@@ -512,6 +556,8 @@ print_fast_io_fail(char * buff, int len, void *ptr)<br>
<br>
=C2=A0declare_def_handler(fast_io_fail, set_fast_io_fail)<br>
=C2=A0declare_def_snprint(fast_io_fail, print_fast_io_fail)<br>
+declare_ovr_handler(fast_io_fail, set_fast_io_fail)<br>
+declare_ovr_snprint(fast_io_fail, print_fast_io_fail)<br>
=C2=A0declare_hw_handler(fast_io_fail, set_fast_io_fail)<br>
=C2=A0declare_hw_snprint(fast_io_fail, print_fast_io_fail)<br>
<br>
@@ -548,6 +594,8 @@ print_dev_loss(char * buff, int len, void *ptr)<br>
<br>
=C2=A0declare_def_handler(dev_loss, set_dev_loss)<br>
=C2=A0declare_def_snprint(dev_loss, print_dev_loss)<br>
+declare_ovr_handler(dev_loss, set_dev_loss)<br>
+declare_ovr_snprint(dev_loss, print_dev_loss)<br>
=C2=A0declare_hw_handler(dev_loss, set_dev_loss)<br>
=C2=A0declare_hw_snprint(dev_loss, print_dev_loss)<br>
<br>
@@ -583,6 +631,8 @@ print_pgpolicy(char * buff, int len, void *ptr)<br>
<br>
=C2=A0declare_def_handler(pgpolicy, set_pgpolicy)<br>
=C2=A0declare_def_snprint_defint(pgpolicy, print_pgpolicy, DEFAULT_PGPOLICY=
)<br>
+declare_ovr_handler(pgpolicy, set_pgpolicy)<br>
+declare_ovr_snprint(pgpolicy, print_pgpolicy)<br>
=C2=A0declare_hw_handler(pgpolicy, set_pgpolicy)<br>
=C2=A0declare_hw_snprint(pgpolicy, print_pgpolicy)<br>
=C2=A0declare_mp_handler(pgpolicy, set_pgpolicy)<br>
@@ -700,6 +750,8 @@ print_rr_weight (char * buff, int len, void *ptr)<br>
<br>
=C2=A0declare_def_handler(rr_weight, set_rr_weight)<br>
=C2=A0declare_def_snprint_defint(rr_weight, print_rr_weight, RR_WEIGHT_NONE=
)<br>
+declare_ovr_handler(rr_weight, set_rr_weight)<br>
+declare_ovr_snprint(rr_weight, print_rr_weight)<br>
=C2=A0declare_hw_handler(rr_weight, set_rr_weight)<br>
=C2=A0declare_hw_snprint(rr_weight, print_rr_weight)<br>
=C2=A0declare_mp_handler(rr_weight, set_rr_weight)<br>
@@ -748,6 +800,8 @@ print_pgfailback (char * buff, int len, void *ptr)<br>
<br>
=C2=A0declare_def_handler(pgfailback, set_pgfailback)<br>
=C2=A0declare_def_snprint_defint(pgfailback, print_pgfailback, DEFAULT_FAIL=
BACK)<br>
+declare_ovr_handler(pgfailback, set_pgfailback)<br>
+declare_ovr_snprint(pgfailback, print_pgfailback)<br>
=C2=A0declare_hw_handler(pgfailback, set_pgfailback)<br>
=C2=A0declare_hw_snprint(pgfailback, print_pgfailback)<br>
=C2=A0declare_mp_handler(pgfailback, set_pgfailback)<br>
@@ -793,6 +847,8 @@ print_no_path_retry(char * buff, int len, void *ptr)<br=
>
<br>
=C2=A0declare_def_handler(no_path_retry, set_no_path_retry)<br>
=C2=A0declare_def_snprint(no_path_retry, print_no_path_retry)<br>
+declare_ovr_handler(no_path_retry, set_no_path_retry)<br>
+declare_ovr_snprint(no_path_retry, print_no_path_retry)<br>
=C2=A0declare_hw_handler(no_path_retry, set_no_path_retry)<br>
=C2=A0declare_hw_snprint(no_path_retry, print_no_path_retry)<br>
=C2=A0declare_mp_handler(no_path_retry, set_no_path_retry)<br>
@@ -1061,6 +1117,25 @@ declare_hw_handler(hwhandler, set_str)<br>
=C2=A0declare_hw_snprint(hwhandler, print_str)<br>
<br>
=C2=A0/*<br>
+ * overrides handlers<br>
+ */<br>
+static int<br>
+overrides_handler(vector strvec)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct hwentry * overrides;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0overrides =3D alloc_hwe();<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!overrides)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 1;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0conf-&gt;overrides =3D overrides;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
+}<br>
+<br>
+<br>
+<br>
+/*<br>
=C2=A0 * multipaths block handlers<br>
=C2=A0 */<br>
=C2=A0static int<br>
@@ -1236,6 +1311,29 @@ init_keywords(void)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword(&quot;detect_prio&quot;, &amp;h=
w_detect_prio_handler, &amp;snprint_hw_detect_prio);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_sublevel_end();<br>
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0install_keyword_root(&quot;overrides&quot;, &am=
p;overrides_handler);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0install_keyword(&quot;path_grouping_policy&quot=
;, &amp;ovr_pgpolicy_handler, &amp;snprint_ovr_pgpolicy);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0install_keyword(&quot;uid_attribute&quot;, &amp=
;ovr_uid_attribute_handler, &amp;snprint_ovr_uid_attribute);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0install_keyword(&quot;getuid_callout&quot;, &am=
p;ovr_getuid_handler, &amp;snprint_ovr_getuid);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0install_keyword(&quot;path_selector&quot;, &amp=
;ovr_selector_handler, &amp;snprint_ovr_selector);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0install_keyword(&quot;path_checker&quot;, &amp;=
ovr_checker_name_handler, &amp;snprint_ovr_checker_name);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0install_keyword(&quot;checker&quot;, &amp;ovr_c=
hecker_name_handler, NULL);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0install_keyword(&quot;alias_prefix&quot;, &amp;=
ovr_alias_prefix_handler, &amp;snprint_ovr_alias_prefix);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0install_keyword(&quot;features&quot;, &amp;ovr_=
features_handler, &amp;snprint_ovr_features);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0install_keyword(&quot;prio&quot;, &amp;ovr_prio=
_name_handler, &amp;snprint_ovr_prio_name);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0install_keyword(&quot;prio_args&quot;, &amp;ovr=
_prio_args_handler, &amp;snprint_ovr_prio_args);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0install_keyword(&quot;failback&quot;, &amp;ovr_=
pgfailback_handler, &amp;snprint_ovr_pgfailback);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0install_keyword(&quot;rr_weight&quot;, &amp;ovr=
_rr_weight_handler, &amp;snprint_ovr_rr_weight);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0install_keyword(&quot;no_path_retry&quot;, &amp=
;ovr_no_path_retry_handler, &amp;snprint_ovr_no_path_retry);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0install_keyword(&quot;rr_min_io&quot;, &amp;ovr=
_minio_handler, &amp;snprint_ovr_minio);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0install_keyword(&quot;rr_min_io_rq&quot;, &amp;=
ovr_minio_rq_handler, &amp;snprint_ovr_minio_rq);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0install_keyword(&quot;flush_on_last_del&quot;, =
&amp;ovr_flush_on_last_del_handler, &amp;snprint_ovr_flush_on_last_del);<br=
>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0install_keyword(&quot;fast_io_fail_tmo&quot;, &=
amp;ovr_fast_io_fail_handler, &amp;snprint_ovr_fast_io_fail);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0install_keyword(&quot;dev_loss_tmo&quot;, &amp;=
ovr_dev_loss_handler, &amp;snprint_ovr_dev_loss);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0install_keyword(&quot;user_friendly_names&quot;=
, &amp;ovr_user_friendly_names_handler, &amp;snprint_ovr_user_friendly_name=
s);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0install_keyword(&quot;retain_attached_hw_handle=
r&quot;, &amp;ovr_retain_hwhandler_handler, &amp;snprint_ovr_retain_hwhandl=
er);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0install_keyword(&quot;detect_prio&quot;, &amp;o=
vr_detect_prio_handler, &amp;snprint_ovr_detect_prio);<br>
+<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword_root(&quot;multipaths&quot;, &a=
mp;multipaths_handler);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword_multi(&quot;multipath&quot;, &a=
mp;multipath_handler, NULL);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_sublevel();<br>
diff --git a/libmultipath/print.c b/libmultipath/print.c<br>
index 383eae4..ade3841 100644<br>
--- a/libmultipath/print.c<br>
+++ b/libmultipath/print.c<br>
@@ -1080,6 +1080,36 @@ snprint_mptable (char * buff, int len, vector mptabl=
e)<br>
=C2=A0}<br>
<br>
=C2=A0extern int<br>
+snprint_overrides (char * buff, int len, struct hwentry *overrides)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0int fwd =3D 0;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0int i;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct keyword *rootkw;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct keyword *kw;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0rootkw =3D find_keyword(NULL, &quot;overrides&q=
uot;);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!rootkw)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0fwd +=3D snprintf(buff + fwd, len - fwd, &quot;=
overrides {\n&quot;);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (fwd &gt; len)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return len;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!overrides)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0iterate_sub_keywords(rootkw, kw, i) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fwd +=3D snprint_ke=
yword(buff + fwd, len - fwd, &quot;\t%k %v\n&quot;,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 kw, NULL);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (fwd &gt; len)<b=
r>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0return len;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+out:<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0fwd +=3D snprintf(buff + fwd, len - fwd, &quot;=
}\n&quot;);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (fwd &gt; len)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return len;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return fwd;<br>
+}<br>
+<br>
+extern int<br>
=C2=A0snprint_defaults (char * buff, int len)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int fwd =3D 0;<br>
diff --git a/libmultipath/print.h b/libmultipath/print.h<br>
index aef182b..a3c3319 100644<br>
--- a/libmultipath/print.h<br>
+++ b/libmultipath/print.h<br>
@@ -50,6 +50,7 @@ int snprint_status (char *, int, struct vectors *);<br>
=C2=A0int snprint_devices (char *, int, struct vectors *);<br>
=C2=A0int snprint_hwtable (char *, int, vector);<br>
=C2=A0int snprint_mptable (char *, int, vector);<br>
+int snprint_overrides (char *, int, struct hwentry *);<br>
<br>
=C2=A0void print_multipath_topology (struct multipath * mpp, int verbosity)=
;<br>
=C2=A0void print_path (struct path * pp, char * style);<br>
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c<br>
index f2ab7d2..440802c 100644<br>
--- a/libmultipath/propsel.c<br>
+++ b/libmultipath/propsel.c<br>
@@ -48,6 +48,8 @@ do {=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 \<br>
=C2=A0do_set(var, mp-&gt;mpe, mp-&gt;var, &quot;(LUN setting)&quot;)<br>
=C2=A0#define mp_set_hwe(var)=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 \<br>
=C2=A0do_set(var, mp-&gt;hwe, mp-&gt;var, &quot;(controller setting)&quot;)=
<br>
+#define mp_set_ovr(var)=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 \=
<br>
+do_set(var, conf-&gt;overrides, mp-&gt;var, &quot;(overrides setting)&quot=
;)<br>
=C2=A0#define mp_set_conf(var)=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0\<br>
=C2=A0do_set(var, conf, mp-&gt;var, &quot;(config file default)&quot;)<br>
=C2=A0#define mp_set_default(var, value)=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0\<br>
@@ -59,6 +61,8 @@ do_set(var, mpe, pp-&gt;var, &quot;(LUN setting)&quot;)<b=
r>
=C2=A0do_set(var, pp-&gt;hwe, pp-&gt;var, &quot;(controller setting)&quot;)=
<br>
=C2=A0#define pp_set_conf(var)=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0\<br>
=C2=A0do_set(var, conf, pp-&gt;var, &quot;(config file default)&quot;)<br>
+#define pp_set_ovr(var)=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 \=
<br>
+do_set(var, conf-&gt;overrides, pp-&gt;var, &quot;(overrides setting)&quot=
;)<br>
=C2=A0#define pp_set_default(var, value)=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0\<br>
=C2=A0do_default(pp-&gt;var, value)<br>
<br>
@@ -130,6 +134,7 @@ select_rr_weight (struct multipath * mp)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *origin, buff[13];<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_mpe(rr_weight);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0mp_set_ovr(rr_weight);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_hwe(rr_weight);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_conf(rr_weight);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_default(rr_weight, RR_WEIGHT_NONE);<br>
@@ -145,6 +150,7 @@ select_pgfailback (struct multipath * mp)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *origin, buff[13];<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_mpe(pgfailback);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0mp_set_ovr(pgfailback);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_hwe(pgfailback);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_conf(pgfailback);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_default(pgfailback, DEFAULT_FAILBACK);<b=
r>
@@ -165,6 +171,7 @@ select_pgpolicy (struct multipath * mp)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_mpe(pgpolicy);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0mp_set_ovr(pgpolicy);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_hwe(pgpolicy);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_conf(pgpolicy);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_default(pgpolicy, DEFAULT_PGPOLICY);<br>
@@ -181,10 +188,12 @@ select_selector (struct multipath * mp)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *origin;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_mpe(selector);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0mp_set_ovr(selector);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_hwe(selector);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_conf(selector);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0mp_set_default(selector, set_default(DEFAULT_SE=
LECTOR));<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0mp_set_default(selector, DEFAULT_SELECTOR);<br>
=C2=A0out:<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0mp-&gt;selector =3D STRDUP(mp-&gt;selector);<br=
>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 condlog(3, &quot;%s: path_selector =3D \&quot;%=
s\&quot; %s&quot;, mp-&gt;alias, mp-&gt;selector,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 origin);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
@@ -195,6 +204,7 @@ select_alias_prefix (struct multipath * mp)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *origin;<br>
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0mp_set_ovr(alias_prefix);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_hwe(alias_prefix);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_conf(alias_prefix);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_default(alias_prefix, DEFAULT_ALIAS_PREF=
IX);<br>
@@ -206,19 +216,30 @@ out:<br>
=C2=A0static int<br>
=C2=A0want_user_friendly_names(struct multipath * mp)<br>
=C2=A0{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (mp-&gt;mpe &amp;&amp;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mp-&gt;mpe-&gt;user_friendly_name=
s !=3D USER_FRIENDLY_NAMES_UNDEF)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return (mp-&gt;mpe-=
&gt;user_friendly_names =3D=3D USER_FRIENDLY_NAMES_ON);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (mp-&gt;hwe &amp;&amp;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mp-&gt;hwe-&gt;user_friendly_name=
s !=3D USER_FRIENDLY_NAMES_UNDEF)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return (mp-&gt;hwe-=
&gt;user_friendly_names =3D=3D USER_FRIENDLY_NAMES_ON);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0return (conf-&gt;user_friendly_names=C2=A0 =3D=
=3D USER_FRIENDLY_NAMES_ON);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0char *origin;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0int user_friendly_names;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0do_set(user_friendly_names, mp-&gt;mpe, user_fr=
iendly_names,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot;(LUN setting)&quot;=
);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0do_set(user_friendly_names, conf-&gt;overrides,=
 user_friendly_names,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot;(overrides setting)=
&quot;);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0do_set(user_friendly_names, mp-&gt;hwe, user_fr=
iendly_names,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot;(controller setting=
)&quot;);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0do_set(user_friendly_names, conf, user_friendly=
_names,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot;(config file settin=
g)&quot;);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0do_default(user_friendly_names, USER_FRIENDLY_N=
AMES_OFF);<br>
+out:<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(3, &quot;%s: user_friendly_names =3D %s=
 %s&quot;, mp-&gt;wwid,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(user_friendly_name=
s =3D=3D USER_FRIENDLY_NAMES_ON)? &quot;yes&quot; : &quot;no&quot;,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0origin);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return (user_friendly_names =3D=3D USER_FRIENDL=
Y_NAMES_ON);<br>
=C2=A0}<br>
<br>
=C2=A0extern int<br>
=C2=A0select_alias (struct multipath * mp)<br>
=C2=A0{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0char *origin;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0char *origin =3D NULL;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (mp-&gt;mpe &amp;&amp; mp-&gt;mpe-&gt;alias)=
 {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mp-&gt;alias =3D ST=
RDUP(mp-&gt;mpe-&gt;alias);<br>
@@ -261,6 +282,7 @@ select_features (struct multipath * mp)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *origin;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_mpe(features);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0mp_set_ovr(features);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_hwe(features);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_conf(features);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_default(features, DEFAULT_FEATURES);<br>
@@ -287,8 +309,9 @@ select_hwhandler (struct multipath * mp)<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_hwe(hwhandler);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_conf(hwhandler);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0mp_set_default(hwhandler, set_default(DEFAULT_H=
WHANDLER));<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0mp_set_default(hwhandler, DEFAULT_HWHANDLER);<b=
r>
=C2=A0out:<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0mp-&gt;hwhandler =3D STRDUP(mp-&gt;hwhandler);<=
br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 condlog(3, &quot;%s: hardware_handler =3D \&quo=
t;%s\&quot; %s&quot;, mp-&gt;alias, mp-&gt;hwhandler,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 origin);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
@@ -300,6 +323,7 @@ select_checker(struct path *pp)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *origin, *checker_name;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct checker * c =3D &amp;pp-&gt;checker;<br>
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0do_set(checker_name, conf-&gt;overrides, checke=
r_name, &quot;(overrides setting)&quot;);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 do_set(checker_name, pp-&gt;hwe, checker_name, =
&quot;(controller setting)&quot;);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 do_set(checker_name, conf, checker_name, &quot;=
(config file setting)&quot;);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 do_default(checker_name, DEFAULT_CHECKER);<br>
@@ -327,6 +351,8 @@ select_getuid (struct path * pp)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *origin;<br>
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0pp_set_ovr(uid_attribute);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0pp_set_ovr(getuid);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 pp_set_hwe(uid_attribute);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 pp_set_hwe(getuid);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 pp_set_conf(uid_attribute);<br>
@@ -383,6 +409,7 @@ select_prio (struct path * pp)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mpe =3D find_mpe(pp-&gt;wwid);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 set_prio(mpe, &quot;(LUN setting)&quot;);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0set_prio(conf-&gt;overrides, &quot;(overrides s=
etting)&quot;);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 set_prio(pp-&gt;hwe, &quot;controller setting)&=
quot;);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 set_prio(conf, &quot;(config file default)&quot=
;);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 prio_get(p, DEFAULT_PRIO, DEFAULT_PRIO_ARGS);<b=
r>
@@ -405,6 +432,7 @@ select_no_path_retry(struct multipath *mp)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_mpe(no_path_retry);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0mp_set_ovr(no_path_retry);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_hwe(no_path_retry);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_conf(no_path_retry);<br>
=C2=A0out:<br>
@@ -427,6 +455,7 @@ select_minio_rq (struct multipath * mp)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *origin;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 do_set(minio_rq, mp-&gt;mpe, mp-&gt;minio, &quo=
t;(LUN setting)&quot;);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0do_set(minio_rq, conf-&gt;overrides, mp-&gt;min=
io, &quot;(overrides setting)&quot;);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 do_set(minio_rq, mp-&gt;hwe, mp-&gt;minio, &quo=
t;(controller setting)&quot;);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 do_set(minio_rq, conf, mp-&gt;minio, &quot;(con=
fig file setting)&quot;);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 do_default(mp-&gt;minio, DEFAULT_MINIO_RQ);<br>
@@ -441,6 +470,7 @@ select_minio_bio (struct multipath * mp)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *origin;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_mpe(minio);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0mp_set_ovr(minio);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_hwe(minio);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_conf(minio);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_default(minio, DEFAULT_MINIO);<br>
@@ -465,6 +495,7 @@ select_fast_io_fail(struct multipath *mp)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *origin, buff[12];<br>
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0mp_set_ovr(fast_io_fail);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_hwe(fast_io_fail);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_conf(fast_io_fail);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_default(fast_io_fail, DEFAULT_FAST_IO_FA=
IL);<br>
@@ -479,6 +510,7 @@ select_dev_loss(struct multipath *mp)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *origin, buff[12];<br>
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0mp_set_ovr(dev_loss);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_hwe(dev_loss);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_conf(dev_loss);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp-&gt;dev_loss =3D 0;<br>
@@ -497,6 +529,7 @@ select_flush_on_last_del(struct multipath *mp)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (mp-&gt;flush_on_last_del =3D=3D FLUSH_IN_PR=
OGRESS)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_mpe(flush_on_last_del);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0mp_set_ovr(flush_on_last_del);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_hwe(flush_on_last_del);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_conf(flush_on_last_del);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_default(flush_on_last_del, FLUSH_DISABLE=
D);<br>
@@ -532,6 +565,7 @@ select_retain_hwhandler (struct multipath * mp)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 origin =3D &quot;(r=
equires kernel version &gt;=3D 1.5.0)&quot;;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0mp_set_ovr(retain_hwhandler);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_hwe(retain_hwhandler);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_conf(retain_hwhandler);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_default(retain_hwhandler, DEFAULT_RETAIN=
_HWHANDLER);<br>
@@ -547,6 +581,7 @@ select_detect_prio (struct path * pp)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *origin;<br>
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0pp_set_ovr(detect_prio);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 pp_set_hwe(detect_prio);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 pp_set_conf(detect_prio);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 pp_set_default(detect_prio, DEFAULT_DETECT_PRIO=
);<br>
diff --git a/libmultipath/structs.c b/libmultipath/structs.c<br>
index 30d247d..0538327 100644<br>
--- a/libmultipath/structs.c<br>
+++ b/libmultipath/structs.c<br>
@@ -206,10 +206,7 @@ free_multipath_attributes (struct multipath * mpp)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!mpp)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (mpp-&gt;selector &amp;&amp;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mpp-&gt;selector !=3D conf-&gt;se=
lector &amp;&amp;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(!mpp-&gt;mpe || (mpp-&gt;mpe &am=
p;&amp; mpp-&gt;selector !=3D mpp-&gt;mpe-&gt;selector)) &amp;&amp;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(!mpp-&gt;hwe || (mpp-&gt;hwe &am=
p;&amp; mpp-&gt;selector !=3D mpp-&gt;hwe-&gt;selector))) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (mpp-&gt;selector) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 FREE(mpp-&gt;select=
or);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mpp-&gt;selector =
=3D NULL;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
@@ -219,9 +216,7 @@ free_multipath_attributes (struct multipath * mpp)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mpp-&gt;features =
=3D NULL;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (mpp-&gt;hwhandler &amp;&amp;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mpp-&gt;hwhandler !=3D conf-&gt;h=
whandler &amp;&amp;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(!mpp-&gt;hwe || (mpp-&gt;hwe &am=
p;&amp; mpp-&gt;hwhandler !=3D mpp-&gt;hwe-&gt;hwhandler))) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (mpp-&gt;hwhandler) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 FREE(mpp-&gt;hwhand=
ler);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mpp-&gt;hwhandler =
=3D NULL;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
diff --git a/multipath.conf.annotated b/multipath.conf.annotated<br>
index 0af1d4c..71afc0a 100644<br>
--- a/multipath.conf.annotated<br>
+++ b/multipath.conf.annotated<br>
@@ -485,7 +485,8 @@<br>
=C2=A0## scope : multipath &amp; multipathd<br>
=C2=A0## desc=C2=A0 : list of per storage controller settings<br>
=C2=A0##=C2=A0 =C2=A0 =C2=A0 =C2=A0overrides default settings (device_maps =
block)<br>
-##=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0overriden by per multipath settings (m=
ultipaths block)<br>
+##=C2=A0 =C2=A0 =C2=A0 =C2=A0 overriden by per multipath settings (multipa=
ths block)<br>
+##=C2=A0 =C2=A0 =C2=A0 =C2=A0and the overrides settings (overrides block)<=
br>
=C2=A0##<br>
=C2=A0#devices {<br>
=C2=A0#=C2=A0 =C2=A0 =C2=A0 #<br>
@@ -651,3 +652,18 @@<br>
=C2=A0#=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rr_weight=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0priorities<br>
=C2=A0#=C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0#}<br>
+#<br>
+##<br>
+## name=C2=A0 : devices<br>
+## scope : multipath &amp; multipathd<br>
+## desc=C2=A0 : list of settings to override all hadware settings for all =
devices<br>
+##=C2=A0 =C2=A0 =C2=A0 =C2=A0overrides default settings (device_maps block=
)<br>
+##=C2=A0 =C2=A0 =C2=A0 =C2=A0and per device type settings (devices block)<=
br>
+##=C2=A0 =C2=A0 =C2=A0 =C2=A0 overriden by per multipath settings (multipa=
ths block)<br>
+##<br>
+#=C2=A0 =C2=A0 =C2=A0 attributes and values are identical to the device bl=
ock<br>
+#<br>
+#overrides {<br>
+#=C2=A0 =C2=A0 =C2=A0 dev_loss_tmo=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 60<br>
+#=C2=A0 =C2=A0 =C2=A0 no_path_retry=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0fail<br>
+#}<br>
diff --git a/multipath.conf.defaults b/multipath.conf.defaults<br>
index 654be97..1c65e02 100644<br>
--- a/multipath.conf.defaults<br>
+++ b/multipath.conf.defaults<br>
@@ -912,3 +912,5 @@<br>
=C2=A0#}<br>
=C2=A0#multipaths {<br>
=C2=A0#}<br>
+#overrides {<br>
+#}<br>
diff --git a/multipath.conf.synthetic b/multipath.conf.synthetic<br>
index bda1b75..f7b9b8a 100644<br>
--- a/multipath.conf.synthetic<br>
+++ b/multipath.conf.synthetic<br>
@@ -72,3 +72,6 @@<br>
=C2=A0#=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 path_grouping_polic=
y=C2=A0 =C2=A0 multibus<br>
=C2=A0#=C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0#}<br>
+#overrides {<br>
+#=C2=A0 =C2=A0 =C2=A0 no_path_retry=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fail<br>
+#}<br>
diff --git a/multipath/main.c b/multipath/main.c<br>
index fd6262f..ea453b4 100644<br>
--- a/multipath/main.c<br>
+++ b/multipath/main.c<br>
@@ -405,6 +405,12 @@ dump_config (void)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 reply =3D REALLOC(reply, maxlen *=3D 2);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 continue;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0c +=3D snprint_over=
rides(c, reply + maxlen - c, conf-&gt;overrides);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0again =3D ((c - rep=
ly) =3D=3D maxlen);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (again) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0reply =3D REALLOC(reply, maxlen *=3D 2);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0continue;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 c +=3D snprint_mpta=
ble(c, reply + maxlen - c, conf-&gt;mptable);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 again =3D ((c - rep=
ly) =3D=3D maxlen);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (again)<br>
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5<br>
index cadb34d..b823990 100644<br>
--- a/multipath/multipath.conf.5<br>
+++ b/multipath/multipath.conf.5<br>
@@ -61,6 +61,10 @@ the udev attribute given by the<br>
=C2=A0.TP<br>
=C2=A0.B devices<br>
=C2=A0This section defines the device-specific settings.<br>
+.TP<br>
+.B overrides<br>
+This section defines values for attributes that should override the<br>
+device-specific settings for all devices.<br>
=C2=A0.RE<br>
=C2=A0.LP<br>
=C2=A0.SH &quot;defaults section&quot;<br>
@@ -629,6 +633,59 @@ section:<br>
=C2=A0.RE<br>
=C2=A0.PD<br>
=C2=A0.LP<br>
+.SH &quot;overrides section&quot;<br>
+The overrides section recognizes the following optional attributes; if not=
 set<br>
+the values are taken from the<br>
+.I devices<br>
+or<br>
+.I defaults<br>
+sections:<br>
+.sp 1<br>
+.PD .1v<br>
+.RS<br>
+.TP 18<br>
+.B path_grouping_policy<br>
+.TP<br>
+.B uid_attribute<br>
+.TP<br>
+.B getuid_callout<br>
+.TP<br>
+.B path_selector<br>
+.TP<br>
+.B path_checker<br>
+.TP<br>
+.B alias_prefix<br>
+.TP<br>
+.B features<br>
+.TP<br>
+.B prio<br>
+.TP<br>
+.B prio_args<br>
+.TP<br>
+.B failback<br>
+.TP<br>
+.B rr_weight<br>
+.TP<br>
+.B no_path_retry<br>
+.TP<br>
+.B rr_min_io<br>
+.TP<br>
+.B rr_min_io_rq<br>
+.TP<br>
+.B flush_on_last_del<br>
+.TP<br>
+.B fast_io_fail_tmo<br>
+.TP<br>
+.B dev_loss_tmo<br>
+.TP<br>
+.B user_friendly_names<br>
+.TP<br>
+.B retain_attached_hw_handler<br>
+.TP<br>
+.B detect_prio<br>
+.RE<br>
+.PD<br>
+.LP<br>
=C2=A0.SH &quot;KNOWN ISSUES&quot;<br>
=C2=A0The usage of<br>
=C2=A0.B queue_if_no_path<br>
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c<br>
index b086340..0ce1408 100644<br>
--- a/multipathd/cli_handlers.c<br>
+++ b/multipathd/cli_handlers.c<br>
@@ -190,6 +190,16 @@ show_config (char ** r, int * len)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 maxlen *=3D 2;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 continue;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0c +=3D snprint_over=
rides(c, reply + maxlen - c, conf-&gt;overrides);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0again =3D ((c - rep=
ly) =3D=3D maxlen);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (again) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0reply =3D REALLOC(reply, maxlen * 2);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0if (!reply)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 1;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0memset(reply + maxlen, 0, maxlen);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0maxlen *=3D 2;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0continue;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 c +=3D snprint_mpta=
ble(c, reply + maxlen - c, conf-&gt;mptable);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 again =3D ((c - rep=
ly) =3D=3D maxlen);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 REALLOC_REPLY(reply=
, again, maxlen);<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
1.8.3.1<br>
<br>
</font></span></blockquote></div><br></div>

--001a11c373662472d0050c2c1742--


--===============5220622642520428565==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5220622642520428565==--
