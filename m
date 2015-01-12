From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 3/6] libmultipath: add overrides section to
	multipath.conf
Date: Mon, 12 Jan 2015 12:05:07 -0600
Message-ID: <20150112180507.GY30600@ask-08.lab.msp.redhat.com>
References: <1416377859-15073-1-git-send-email-bmarzins@redhat.com>
	<1416377859-15073-4-git-send-email-bmarzins@redhat.com>
	<CABr-GndVm5ct_E7UoF86no5b36k8MpLU4KD5pYtO=h1NiT4LGQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CABr-GndVm5ct_E7UoF86no5b36k8MpLU4KD5pYtO=h1NiT4LGQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Jan 09, 2015 at 12:06:29AM +0100, Christophe Varoqui wrote:
>    I have no strong opinion on this one : I feel like the complexity of the
>    parameter inheritance system is already quite complicated ... but this
>    addition of a new layer would likely and safely be ignored by users who
>    don't need it. Those who need it are surely ready to pay the price.
>    Does someone have objection to my applying this patch ?

Christophe, I wrote this patch because you thought an "overrides"
section would be more intuitive than my previous solution of a
specialized "all_devs" devices section option to overwrite options on
all the devices.

http://www.redhat.com/archives/dm-devel/2014-September/msg00047.html

Maybe this isn't exactly what you had in mind.  At any rate, I'd like to
have some method inside of multipath to accomplish this.

-Ben 

>    Best regards,
>    Christophe
>    On Wed, Nov 19, 2014 at 7:17 AM, Benjamin Marzinski <bmarzins@redhat.com>
>    wrote:
> 
>      Sometimes users want to be able to set a configuration value for all
>      their
>      devices (for instance, they may want all devices to set no_path_retry to
>      fail). The builtin device configurations make this tricky, since users
>      need
>      to change each device configuration individually. To avoid that, this
>      patch
>      adds a new section to multipath.conf, "overrides".A  This section has
>      all of
>      the attributes that are in both the devices and defaults section.
>      Attributes set in the overrides section have a higher priority that
>      those
>      in the devices section. With this section added, the multipath
>      configuration order now goes:
> 
>      multipaths > overrides > devices > defaults
> 
>      I also made want_user_friendly_names print out where the configuration
>      came
>      from, and I made made select_hwhandler and select_selector always strdup
>      the string, instead of only on the defaults.A  Since multipathd will
>      update
>      the device strings from the kernel anyway, the old way just added
>      complexity without saving any memory.
> 
>      To store the overrides configuration, I used a hwentry structure. We may
>      want to make a new overrides structure, so that we set any of the
>      defaults
>      values in overrides.A  That way, users could skip using defaults and
>      just
>      use overrides if they wanted. However, this would take some additional
>      changes to make sure that all the defaults options can undefined, which
>      they can't currently be.
> 
>      Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
>      ---
>      A libmultipath/config.cA  A  A  |A  1 +
>      A libmultipath/config.hA  A  A  |A  1 +
>      A libmultipath/dict.cA  A  A  A  | 98
>      ++++++++++++++++++++++++++++++++++++++++++++++
>      A libmultipath/print.cA  A  A  A | 30 ++++++++++++++
>      A libmultipath/print.hA  A  A  A |A  1 +
>      A libmultipath/propsel.cA  A  A | 55 +++++++++++++++++++++-----
>      A libmultipath/structs.cA  A  A |A  9 +----
>      A multipath.conf.annotatedA  A | 18 ++++++++-
>      A multipath.conf.defaultsA  A  |A  2 +
>      A multipath.conf.syntheticA  A |A  3 ++
>      A multipath/main.cA  A  A  A  A  A |A  6 +++
>      A multipath/multipath.conf.5 | 57 +++++++++++++++++++++++++++
>      A multipathd/cli_handlers.cA  | 10 +++++
>      A 13 files changed, 273 insertions(+), 18 deletions(-)
> 
>      diff --git a/libmultipath/config.c b/libmultipath/config.c
>      index bfd8ee8..7f7bd5a 100644
>      --- a/libmultipath/config.c
>      +++ b/libmultipath/config.c
>      @@ -523,6 +523,7 @@ free_config (struct config * conf)
> 
>      A  A  A  A  free_mptable(conf->mptable);
>      A  A  A  A  free_hwtable(conf->hwtable);
>      +A  A  A  A free_hwe(conf->overrides);
>      A  A  A  A  free_keywords(conf->keywords);
>      A  A  A  A  FREE(conf);
>      A }
>      diff --git a/libmultipath/config.h b/libmultipath/config.h
>      index c57ab31..ef1d7c3 100644
>      --- a/libmultipath/config.h
>      +++ b/libmultipath/config.h
>      @@ -145,6 +145,7 @@ struct config {
>      A  A  A  A  vector keywords;
>      A  A  A  A  vector mptable;
>      A  A  A  A  vector hwtable;
>      +A  A  A  A struct hwentry *overrides;
> 
>      A  A  A  A  vector blist_devnode;
>      A  A  A  A  vector blist_wwid;
>      diff --git a/libmultipath/dict.c b/libmultipath/dict.c
>      index 98cbe48..737c9b0 100644
>      --- a/libmultipath/dict.c
>      +++ b/libmultipath/dict.c
>      @@ -181,6 +181,22 @@ snprint_hw_ ## option (char * buff, int len, void *
>      data)A  A  A  A  A  \
>      A  A  A  A  return function (buff, len, &hwe->option);A  A  A  A  A  A 
>      A  A  A  A  A  \
>      A }
> 
>      +#define declare_ovr_handler(option, function)A  A  A  A  A  A  A  A  A 
>      A  A  A  A  \
>      +static intA  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A 
>      A  A  A  A  A  A  A  A  A  A  A \
>      +ovr_ ## option ## _handler (vector strvec)A  A  A  A  A  A  A  A  A  A 
>      A  A  A  A  A \
>      +{A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A 
>      A  A  A  A  A  A  A  A  A  A  A  A  \
>      +A  A  A  A if (!conf->overrides)A  A  A  A  A  A  A  A  A  A  A  A  A 
>      A  A  A  A  A  A  A  A  A \
>      +A  A  A  A  A  A  A  A return 1;A  A  A  A  A  A  A  A  A  A  A  A  A 
>      A  A  A  A  A  A  A  A  A  A  A \
>      +A  A  A  A return function (strvec, &conf->overrides->option);A  A  A 
>      A  A  A  A \
>      +}
>      +
>      +#define declare_ovr_snprint(option, function)A  A  A  A  A  A  A  A  A 
>      A  A  A  A  \
>      +static intA  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A 
>      A  A  A  A  A  A  A  A  A  A  A \
>      +snprint_ovr_ ## option (char * buff, int len, void * data)A  A  A  A 
>      A  A  A \
>      +{A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A 
>      A  A  A  A  A  A  A  A  A  A  A  A  \
>      +A  A  A  A return function (buff, len, &conf->overrides->option);A  A 
>      A  A  A  \
>      +}
>      +
>      A #define declare_mp_handler(option, function)A  A  A  A  A  A  A  A  A 
>      A  A  A  A  A \
>      A static intA  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A 
>      A  A  A  A  A  A  A  A  A  A  A \
>      A mp_ ## option ## _handler (vector strvec)A  A  A  A  A  A  A  A  A  A 
>      A  A  A  A  A  \
>      @@ -218,21 +234,29 @@ declare_def_handler(selector, set_str)
>      A declare_def_snprint_defstr(selector, print_str, DEFAULT_SELECTOR)
>      A declare_hw_handler(selector, set_str)
>      A declare_hw_snprint(selector, print_str)
>      +declare_ovr_handler(selector, set_str)
>      +declare_ovr_snprint(selector, print_str)
>      A declare_mp_handler(selector, set_str)
>      A declare_mp_snprint(selector, print_str)
> 
>      A declare_def_handler(uid_attribute, set_str)
>      A declare_def_snprint_defstr(uid_attribute, print_str,
>      DEFAULT_UID_ATTRIBUTE)
>      +declare_ovr_handler(uid_attribute, set_str)
>      +declare_ovr_snprint(uid_attribute, print_str)
>      A declare_hw_handler(uid_attribute, set_str)
>      A declare_hw_snprint(uid_attribute, print_str)
> 
>      A declare_def_handler(getuid, set_str)
>      A declare_def_snprint(getuid, print_str)
>      +declare_ovr_handler(getuid, set_str)
>      +declare_ovr_snprint(getuid, print_str)
>      A declare_hw_handler(getuid, set_str)
>      A declare_hw_snprint(getuid, print_str)
> 
>      A declare_def_handler(prio_name, set_str)
>      A declare_def_snprint_defstr(prio_name, print_str, DEFAULT_PRIO)
>      +declare_ovr_handler(prio_name, set_str)
>      +declare_ovr_snprint(prio_name, print_str)
>      A declare_hw_handler(prio_name, set_str)
>      A declare_hw_snprint(prio_name, print_str)
>      A declare_mp_handler(prio_name, set_str)
>      @@ -240,11 +264,15 @@ declare_mp_snprint(prio_name, print_str)
> 
>      A declare_def_handler(alias_prefix, set_str)
>      A declare_def_snprint_defstr(alias_prefix, print_str,
>      DEFAULT_ALIAS_PREFIX)
>      +declare_ovr_handler(alias_prefix, set_str)
>      +declare_ovr_snprint(alias_prefix, print_str)
>      A declare_hw_handler(alias_prefix, set_str)
>      A declare_hw_snprint(alias_prefix, print_str)
> 
>      A declare_def_handler(prio_args, set_str)
>      A declare_def_snprint_defstr(prio_args, print_str, DEFAULT_PRIO_ARGS)
>      +declare_ovr_handler(prio_args, set_str)
>      +declare_ovr_snprint(prio_args, print_str)
>      A declare_hw_handler(prio_args, set_str)
>      A declare_hw_snprint(prio_args, print_str)
>      A declare_mp_handler(prio_args, set_str)
>      @@ -252,6 +280,8 @@ declare_mp_snprint(prio_args, print_str)
> 
>      A declare_def_handler(features, set_str)
>      A declare_def_snprint_defstr(features, print_str, DEFAULT_FEATURES)
>      +declare_ovr_handler(features, set_str)
>      +declare_ovr_snprint(features, print_str)
>      A declare_hw_handler(features, set_str)
>      A declare_hw_snprint(features, print_str)
>      A declare_mp_handler(features, set_str)
>      @@ -259,11 +289,15 @@ declare_mp_snprint(features, print_str)
> 
>      A declare_def_handler(checker_name, set_str)
>      A declare_def_snprint_defstr(checker_name, print_str, DEFAULT_CHECKER)
>      +declare_ovr_handler(checker_name, set_str)
>      +declare_ovr_snprint(checker_name, print_str)
>      A declare_hw_handler(checker_name, set_str)
>      A declare_hw_snprint(checker_name, print_str)
> 
>      A declare_def_handler(minio, set_int)
>      A declare_def_snprint_defint(minio, print_int, DEFAULT_MINIO)
>      +declare_ovr_handler(minio, set_int)
>      +declare_ovr_snprint(minio, print_nonzero)
>      A declare_hw_handler(minio, set_int)
>      A declare_hw_snprint(minio, print_nonzero)
>      A declare_mp_handler(minio, set_int)
>      @@ -271,6 +305,8 @@ declare_mp_snprint(minio, print_nonzero)
> 
>      A declare_def_handler(minio_rq, set_int)
>      A declare_def_snprint_defint(minio_rq, print_int, DEFAULT_MINIO_RQ)
>      +declare_ovr_handler(minio_rq, set_int)
>      +declare_ovr_snprint(minio_rq, print_nonzero)
>      A declare_hw_handler(minio_rq, set_int)
>      A declare_hw_snprint(minio_rq, print_nonzero)
>      A declare_mp_handler(minio_rq, set_int)
>      @@ -296,6 +332,8 @@ declare_def_snprint(checker_timeout, print_nonzero)
> 
>      A declare_def_handler(flush_on_last_del, set_yes_no_undef)
>      A declare_def_snprint_defint(flush_on_last_del, print_yes_no_undef,
>      YNU_NO)
>      +declare_ovr_handler(flush_on_last_del, set_yes_no_undef)
>      +declare_ovr_snprint(flush_on_last_del, print_yes_no_undef)
>      A declare_hw_handler(flush_on_last_del, set_yes_no_undef)
>      A declare_hw_snprint(flush_on_last_del, print_yes_no_undef)
>      A declare_mp_handler(flush_on_last_del, set_yes_no_undef)
>      @@ -303,6 +341,8 @@ declare_mp_snprint(flush_on_last_del,
>      print_yes_no_undef)
> 
>      A declare_def_handler(user_friendly_names, set_yes_no_undef)
>      A declare_def_snprint_defint(user_friendly_names, print_yes_no_undef,
>      YNU_NO)
>      +declare_ovr_handler(user_friendly_names, set_yes_no_undef)
>      +declare_ovr_snprint(user_friendly_names, print_yes_no_undef)
>      A declare_hw_handler(user_friendly_names, set_yes_no_undef)
>      A declare_hw_snprint(user_friendly_names, print_yes_no_undef)
>      A declare_mp_handler(user_friendly_names, set_yes_no_undef)
>      @@ -316,11 +356,15 @@ declare_def_snprint(wwids_file, print_str)
> 
>      A declare_def_handler(retain_hwhandler, set_yes_no_undef)
>      A declare_def_snprint_defint(retain_hwhandler, print_yes_no_undef,
>      YNU_NO)
>      +declare_ovr_handler(retain_hwhandler, set_yes_no_undef)
>      +declare_ovr_snprint(retain_hwhandler, print_yes_no_undef)
>      A declare_hw_handler(retain_hwhandler, set_yes_no_undef)
>      A declare_hw_snprint(retain_hwhandler, print_yes_no_undef)
> 
>      A declare_def_handler(detect_prio, set_yes_no_undef)
>      A declare_def_snprint_defint(detect_prio, print_yes_no_undef, YNU_NO)
>      +declare_ovr_handler(detect_prio, set_yes_no_undef)
>      +declare_ovr_snprint(detect_prio, print_yes_no_undef)
>      A declare_hw_handler(detect_prio, set_yes_no_undef)
>      A declare_hw_snprint(detect_prio, print_yes_no_undef)
> 
>      @@ -512,6 +556,8 @@ print_fast_io_fail(char * buff, int len, void *ptr)
> 
>      A declare_def_handler(fast_io_fail, set_fast_io_fail)
>      A declare_def_snprint(fast_io_fail, print_fast_io_fail)
>      +declare_ovr_handler(fast_io_fail, set_fast_io_fail)
>      +declare_ovr_snprint(fast_io_fail, print_fast_io_fail)
>      A declare_hw_handler(fast_io_fail, set_fast_io_fail)
>      A declare_hw_snprint(fast_io_fail, print_fast_io_fail)
> 
>      @@ -548,6 +594,8 @@ print_dev_loss(char * buff, int len, void *ptr)
> 
>      A declare_def_handler(dev_loss, set_dev_loss)
>      A declare_def_snprint(dev_loss, print_dev_loss)
>      +declare_ovr_handler(dev_loss, set_dev_loss)
>      +declare_ovr_snprint(dev_loss, print_dev_loss)
>      A declare_hw_handler(dev_loss, set_dev_loss)
>      A declare_hw_snprint(dev_loss, print_dev_loss)
> 
>      @@ -583,6 +631,8 @@ print_pgpolicy(char * buff, int len, void *ptr)
> 
>      A declare_def_handler(pgpolicy, set_pgpolicy)
>      A declare_def_snprint_defint(pgpolicy, print_pgpolicy, DEFAULT_PGPOLICY)
>      +declare_ovr_handler(pgpolicy, set_pgpolicy)
>      +declare_ovr_snprint(pgpolicy, print_pgpolicy)
>      A declare_hw_handler(pgpolicy, set_pgpolicy)
>      A declare_hw_snprint(pgpolicy, print_pgpolicy)
>      A declare_mp_handler(pgpolicy, set_pgpolicy)
>      @@ -700,6 +750,8 @@ print_rr_weight (char * buff, int len, void *ptr)
> 
>      A declare_def_handler(rr_weight, set_rr_weight)
>      A declare_def_snprint_defint(rr_weight, print_rr_weight, RR_WEIGHT_NONE)
>      +declare_ovr_handler(rr_weight, set_rr_weight)
>      +declare_ovr_snprint(rr_weight, print_rr_weight)
>      A declare_hw_handler(rr_weight, set_rr_weight)
>      A declare_hw_snprint(rr_weight, print_rr_weight)
>      A declare_mp_handler(rr_weight, set_rr_weight)
>      @@ -748,6 +800,8 @@ print_pgfailback (char * buff, int len, void *ptr)
> 
>      A declare_def_handler(pgfailback, set_pgfailback)
>      A declare_def_snprint_defint(pgfailback, print_pgfailback,
>      DEFAULT_FAILBACK)
>      +declare_ovr_handler(pgfailback, set_pgfailback)
>      +declare_ovr_snprint(pgfailback, print_pgfailback)
>      A declare_hw_handler(pgfailback, set_pgfailback)
>      A declare_hw_snprint(pgfailback, print_pgfailback)
>      A declare_mp_handler(pgfailback, set_pgfailback)
>      @@ -793,6 +847,8 @@ print_no_path_retry(char * buff, int len, void *ptr)
> 
>      A declare_def_handler(no_path_retry, set_no_path_retry)
>      A declare_def_snprint(no_path_retry, print_no_path_retry)
>      +declare_ovr_handler(no_path_retry, set_no_path_retry)
>      +declare_ovr_snprint(no_path_retry, print_no_path_retry)
>      A declare_hw_handler(no_path_retry, set_no_path_retry)
>      A declare_hw_snprint(no_path_retry, print_no_path_retry)
>      A declare_mp_handler(no_path_retry, set_no_path_retry)
>      @@ -1061,6 +1117,25 @@ declare_hw_handler(hwhandler, set_str)
>      A declare_hw_snprint(hwhandler, print_str)
> 
>      A /*
>      + * overrides handlers
>      + */
>      +static int
>      +overrides_handler(vector strvec)
>      +{
>      +A  A  A  A struct hwentry * overrides;
>      +
>      +A  A  A  A overrides = alloc_hwe();
>      +
>      +A  A  A  A if (!overrides)
>      +A  A  A  A  A  A  A  A return 1;
>      +
>      +A  A  A  A conf->overrides = overrides;
>      +A  A  A  A return 0;
>      +}
>      +
>      +
>      +
>      +/*
>      A  * multipaths block handlers
>      A  */
>      A static int
>      @@ -1236,6 +1311,29 @@ init_keywords(void)
>      A  A  A  A  install_keyword("detect_prio", &hw_detect_prio_handler,
>      &snprint_hw_detect_prio);
>      A  A  A  A  install_sublevel_end();
> 
>      +A  A  A  A install_keyword_root("overrides", &overrides_handler);
>      +A  A  A  A install_keyword("path_grouping_policy",
>      &ovr_pgpolicy_handler, &snprint_ovr_pgpolicy);
>      +A  A  A  A install_keyword("uid_attribute", &ovr_uid_attribute_handler,
>      &snprint_ovr_uid_attribute);
>      +A  A  A  A install_keyword("getuid_callout", &ovr_getuid_handler,
>      &snprint_ovr_getuid);
>      +A  A  A  A install_keyword("path_selector", &ovr_selector_handler,
>      &snprint_ovr_selector);
>      +A  A  A  A install_keyword("path_checker", &ovr_checker_name_handler,
>      &snprint_ovr_checker_name);
>      +A  A  A  A install_keyword("checker", &ovr_checker_name_handler, NULL);
>      +A  A  A  A install_keyword("alias_prefix", &ovr_alias_prefix_handler,
>      &snprint_ovr_alias_prefix);
>      +A  A  A  A install_keyword("features", &ovr_features_handler,
>      &snprint_ovr_features);
>      +A  A  A  A install_keyword("prio", &ovr_prio_name_handler,
>      &snprint_ovr_prio_name);
>      +A  A  A  A install_keyword("prio_args", &ovr_prio_args_handler,
>      &snprint_ovr_prio_args);
>      +A  A  A  A install_keyword("failback", &ovr_pgfailback_handler,
>      &snprint_ovr_pgfailback);
>      +A  A  A  A install_keyword("rr_weight", &ovr_rr_weight_handler,
>      &snprint_ovr_rr_weight);
>      +A  A  A  A install_keyword("no_path_retry", &ovr_no_path_retry_handler,
>      &snprint_ovr_no_path_retry);
>      +A  A  A  A install_keyword("rr_min_io", &ovr_minio_handler,
>      &snprint_ovr_minio);
>      +A  A  A  A install_keyword("rr_min_io_rq", &ovr_minio_rq_handler,
>      &snprint_ovr_minio_rq);
>      +A  A  A  A install_keyword("flush_on_last_del",
>      &ovr_flush_on_last_del_handler, &snprint_ovr_flush_on_last_del);
>      +A  A  A  A install_keyword("fast_io_fail_tmo",
>      &ovr_fast_io_fail_handler, &snprint_ovr_fast_io_fail);
>      +A  A  A  A install_keyword("dev_loss_tmo", &ovr_dev_loss_handler,
>      &snprint_ovr_dev_loss);
>      +A  A  A  A install_keyword("user_friendly_names",
>      &ovr_user_friendly_names_handler, &snprint_ovr_user_friendly_names);
>      +A  A  A  A install_keyword("retain_attached_hw_handler",
>      &ovr_retain_hwhandler_handler, &snprint_ovr_retain_hwhandler);
>      +A  A  A  A install_keyword("detect_prio", &ovr_detect_prio_handler,
>      &snprint_ovr_detect_prio);
>      +
>      A  A  A  A  install_keyword_root("multipaths", &multipaths_handler);
>      A  A  A  A  install_keyword_multi("multipath", &multipath_handler,
>      NULL);
>      A  A  A  A  install_sublevel();
>      diff --git a/libmultipath/print.c b/libmultipath/print.c
>      index 383eae4..ade3841 100644
>      --- a/libmultipath/print.c
>      +++ b/libmultipath/print.c
>      @@ -1080,6 +1080,36 @@ snprint_mptable (char * buff, int len, vector
>      mptable)
>      A }
> 
>      A extern int
>      +snprint_overrides (char * buff, int len, struct hwentry *overrides)
>      +{
>      +A  A  A  A int fwd = 0;
>      +A  A  A  A int i;
>      +A  A  A  A struct keyword *rootkw;
>      +A  A  A  A struct keyword *kw;
>      +
>      +A  A  A  A rootkw = find_keyword(NULL, "overrides");
>      +A  A  A  A if (!rootkw)
>      +A  A  A  A  A  A  A  A return 0;
>      +
>      +A  A  A  A fwd += snprintf(buff + fwd, len - fwd, "overrides {\n");
>      +A  A  A  A if (fwd > len)
>      +A  A  A  A  A  A  A  A return len;
>      +A  A  A  A if (!overrides)
>      +A  A  A  A  A  A  A  A goto out;
>      +A  A  A  A iterate_sub_keywords(rootkw, kw, i) {
>      +A  A  A  A  A  A  A  A fwd += snprint_keyword(buff + fwd, len - fwd,
>      "\t%k %v\n",
>      +A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  kw, NULL);
>      +A  A  A  A  A  A  A  A if (fwd > len)
>      +A  A  A  A  A  A  A  A  A  A  A  A return len;
>      +A  A  A  A }
>      +out:
>      +A  A  A  A fwd += snprintf(buff + fwd, len - fwd, "}\n");
>      +A  A  A  A if (fwd > len)
>      +A  A  A  A  A  A  A  A return len;
>      +A  A  A  A return fwd;
>      +}
>      +
>      +extern int
>      A snprint_defaults (char * buff, int len)
>      A {
>      A  A  A  A  int fwd = 0;
>      diff --git a/libmultipath/print.h b/libmultipath/print.h
>      index aef182b..a3c3319 100644
>      --- a/libmultipath/print.h
>      +++ b/libmultipath/print.h
>      @@ -50,6 +50,7 @@ int snprint_status (char *, int, struct vectors *);
>      A int snprint_devices (char *, int, struct vectors *);
>      A int snprint_hwtable (char *, int, vector);
>      A int snprint_mptable (char *, int, vector);
>      +int snprint_overrides (char *, int, struct hwentry *);
> 
>      A void print_multipath_topology (struct multipath * mpp, int verbosity);
>      A void print_path (struct path * pp, char * style);
>      diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
>      index f2ab7d2..440802c 100644
>      --- a/libmultipath/propsel.c
>      +++ b/libmultipath/propsel.c
>      @@ -48,6 +48,8 @@ do {A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A 
>      A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  \
>      A do_set(var, mp->mpe, mp->var, "(LUN setting)")
>      A #define mp_set_hwe(var)A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A 
>      A  A  A  A  A  A  A  A  A  A  A  A  \
>      A do_set(var, mp->hwe, mp->var, "(controller setting)")
>      +#define mp_set_ovr(var)A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A 
>      A  A  A  A  A  A  A  A  A  A  A  A  \
>      +do_set(var, conf->overrides, mp->var, "(overrides setting)")
>      A #define mp_set_conf(var)A  A  A  A  A  A  A  A  A  A  A  A  A  A  A 
>      A  A  A  A  A  A  A  A  A \
>      A do_set(var, conf, mp->var, "(config file default)")
>      A #define mp_set_default(var, value)A  A  A  A  A  A  A  A  A  A  A  A 
>      A  A  A  A  A  A  A \
>      @@ -59,6 +61,8 @@ do_set(var, mpe, pp->var, "(LUN setting)")
>      A do_set(var, pp->hwe, pp->var, "(controller setting)")
>      A #define pp_set_conf(var)A  A  A  A  A  A  A  A  A  A  A  A  A  A  A 
>      A  A  A  A  A  A  A  A  A \
>      A do_set(var, conf, pp->var, "(config file default)")
>      +#define pp_set_ovr(var)A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A 
>      A  A  A  A  A  A  A  A  A  A  A  A  \
>      +do_set(var, conf->overrides, pp->var, "(overrides setting)")
>      A #define pp_set_default(var, value)A  A  A  A  A  A  A  A  A  A  A  A 
>      A  A  A  A  A  A  A \
>      A do_default(pp->var, value)
> 
>      @@ -130,6 +134,7 @@ select_rr_weight (struct multipath * mp)
>      A  A  A  A  char *origin, buff[13];
> 
>      A  A  A  A  mp_set_mpe(rr_weight);
>      +A  A  A  A mp_set_ovr(rr_weight);
>      A  A  A  A  mp_set_hwe(rr_weight);
>      A  A  A  A  mp_set_conf(rr_weight);
>      A  A  A  A  mp_set_default(rr_weight, RR_WEIGHT_NONE);
>      @@ -145,6 +150,7 @@ select_pgfailback (struct multipath * mp)
>      A  A  A  A  char *origin, buff[13];
> 
>      A  A  A  A  mp_set_mpe(pgfailback);
>      +A  A  A  A mp_set_ovr(pgfailback);
>      A  A  A  A  mp_set_hwe(pgfailback);
>      A  A  A  A  mp_set_conf(pgfailback);
>      A  A  A  A  mp_set_default(pgfailback, DEFAULT_FAILBACK);
>      @@ -165,6 +171,7 @@ select_pgpolicy (struct multipath * mp)
>      A  A  A  A  A  A  A  A  goto out;
>      A  A  A  A  }
>      A  A  A  A  mp_set_mpe(pgpolicy);
>      +A  A  A  A mp_set_ovr(pgpolicy);
>      A  A  A  A  mp_set_hwe(pgpolicy);
>      A  A  A  A  mp_set_conf(pgpolicy);
>      A  A  A  A  mp_set_default(pgpolicy, DEFAULT_PGPOLICY);
>      @@ -181,10 +188,12 @@ select_selector (struct multipath * mp)
>      A  A  A  A  char *origin;
> 
>      A  A  A  A  mp_set_mpe(selector);
>      +A  A  A  A mp_set_ovr(selector);
>      A  A  A  A  mp_set_hwe(selector);
>      A  A  A  A  mp_set_conf(selector);
>      -A  A  A  A mp_set_default(selector, set_default(DEFAULT_SELECTOR));
>      +A  A  A  A mp_set_default(selector, DEFAULT_SELECTOR);
>      A out:
>      +A  A  A  A mp->selector = STRDUP(mp->selector);
>      A  A  A  A  condlog(3, "%s: path_selector = \"%s\" %s", mp->alias,
>      mp->selector,
>      A  A  A  A  A  A  A  A  origin);
>      A  A  A  A  return 0;
>      @@ -195,6 +204,7 @@ select_alias_prefix (struct multipath * mp)
>      A {
>      A  A  A  A  char *origin;
> 
>      +A  A  A  A mp_set_ovr(alias_prefix);
>      A  A  A  A  mp_set_hwe(alias_prefix);
>      A  A  A  A  mp_set_conf(alias_prefix);
>      A  A  A  A  mp_set_default(alias_prefix, DEFAULT_ALIAS_PREFIX);
>      @@ -206,19 +216,30 @@ out:
>      A static int
>      A want_user_friendly_names(struct multipath * mp)
>      A {
>      -A  A  A  A if (mp->mpe &&
>      -A  A  A  A  A  A mp->mpe->user_friendly_names !=
>      USER_FRIENDLY_NAMES_UNDEF)
>      -A  A  A  A  A  A  A  A return (mp->mpe->user_friendly_names ==
>      USER_FRIENDLY_NAMES_ON);
>      -A  A  A  A if (mp->hwe &&
>      -A  A  A  A  A  A mp->hwe->user_friendly_names !=
>      USER_FRIENDLY_NAMES_UNDEF)
>      -A  A  A  A  A  A  A  A return (mp->hwe->user_friendly_names ==
>      USER_FRIENDLY_NAMES_ON);
>      -A  A  A  A return (conf->user_friendly_namesA  ==
>      USER_FRIENDLY_NAMES_ON);
>      +
>      +A  A  A  A char *origin;
>      +A  A  A  A int user_friendly_names;
>      +
>      +A  A  A  A do_set(user_friendly_names, mp->mpe, user_friendly_names,
>      +A  A  A  A  A  A  A  "(LUN setting)");
>      +A  A  A  A do_set(user_friendly_names, conf->overrides,
>      user_friendly_names,
>      +A  A  A  A  A  A  A  "(overrides setting)");
>      +A  A  A  A do_set(user_friendly_names, mp->hwe, user_friendly_names,
>      +A  A  A  A  A  A  A  "(controller setting)");
>      +A  A  A  A do_set(user_friendly_names, conf, user_friendly_names,
>      +A  A  A  A  A  A  A  "(config file setting)");
>      +A  A  A  A do_default(user_friendly_names, USER_FRIENDLY_NAMES_OFF);
>      +out:
>      +A  A  A  A condlog(3, "%s: user_friendly_names = %s %s", mp->wwid,
>      +A  A  A  A  A  A  A  A (user_friendly_names == USER_FRIENDLY_NAMES_ON)?
>      "yes" : "no",
>      +A  A  A  A  A  A  A  A origin);
>      +A  A  A  A return (user_friendly_names == USER_FRIENDLY_NAMES_ON);
>      A }
> 
>      A extern int
>      A select_alias (struct multipath * mp)
>      A {
>      -A  A  A  A char *origin;
>      +A  A  A  A char *origin = NULL;
> 
>      A  A  A  A  if (mp->mpe && mp->mpe->alias) {
>      A  A  A  A  A  A  A  A  mp->alias = STRDUP(mp->mpe->alias);
>      @@ -261,6 +282,7 @@ select_features (struct multipath * mp)
>      A  A  A  A  char *origin;
> 
>      A  A  A  A  mp_set_mpe(features);
>      +A  A  A  A mp_set_ovr(features);
>      A  A  A  A  mp_set_hwe(features);
>      A  A  A  A  mp_set_conf(features);
>      A  A  A  A  mp_set_default(features, DEFAULT_FEATURES);
>      @@ -287,8 +309,9 @@ select_hwhandler (struct multipath * mp)
> 
>      A  A  A  A  mp_set_hwe(hwhandler);
>      A  A  A  A  mp_set_conf(hwhandler);
>      -A  A  A  A mp_set_default(hwhandler, set_default(DEFAULT_HWHANDLER));
>      +A  A  A  A mp_set_default(hwhandler, DEFAULT_HWHANDLER);
>      A out:
>      +A  A  A  A mp->hwhandler = STRDUP(mp->hwhandler);
>      A  A  A  A  condlog(3, "%s: hardware_handler = \"%s\" %s", mp->alias,
>      mp->hwhandler,
>      A  A  A  A  A  A  A  A  origin);
>      A  A  A  A  return 0;
>      @@ -300,6 +323,7 @@ select_checker(struct path *pp)
>      A  A  A  A  char *origin, *checker_name;
>      A  A  A  A  struct checker * c = &pp->checker;
> 
>      +A  A  A  A do_set(checker_name, conf->overrides, checker_name,
>      "(overrides setting)");
>      A  A  A  A  do_set(checker_name, pp->hwe, checker_name, "(controller
>      setting)");
>      A  A  A  A  do_set(checker_name, conf, checker_name, "(config file
>      setting)");
>      A  A  A  A  do_default(checker_name, DEFAULT_CHECKER);
>      @@ -327,6 +351,8 @@ select_getuid (struct path * pp)
>      A {
>      A  A  A  A  char *origin;
> 
>      +A  A  A  A pp_set_ovr(uid_attribute);
>      +A  A  A  A pp_set_ovr(getuid);
>      A  A  A  A  pp_set_hwe(uid_attribute);
>      A  A  A  A  pp_set_hwe(getuid);
>      A  A  A  A  pp_set_conf(uid_attribute);
>      @@ -383,6 +409,7 @@ select_prio (struct path * pp)
>      A  A  A  A  }
>      A  A  A  A  mpe = find_mpe(pp->wwid);
>      A  A  A  A  set_prio(mpe, "(LUN setting)");
>      +A  A  A  A set_prio(conf->overrides, "(overrides setting)");
>      A  A  A  A  set_prio(pp->hwe, "controller setting)");
>      A  A  A  A  set_prio(conf, "(config file default)");
>      A  A  A  A  prio_get(p, DEFAULT_PRIO, DEFAULT_PRIO_ARGS);
>      @@ -405,6 +432,7 @@ select_no_path_retry(struct multipath *mp)
>      A  A  A  A  A  A  A  A  return 0;
>      A  A  A  A  }
>      A  A  A  A  mp_set_mpe(no_path_retry);
>      +A  A  A  A mp_set_ovr(no_path_retry);
>      A  A  A  A  mp_set_hwe(no_path_retry);
>      A  A  A  A  mp_set_conf(no_path_retry);
>      A out:
>      @@ -427,6 +455,7 @@ select_minio_rq (struct multipath * mp)
>      A  A  A  A  char *origin;
> 
>      A  A  A  A  do_set(minio_rq, mp->mpe, mp->minio, "(LUN setting)");
>      +A  A  A  A do_set(minio_rq, conf->overrides, mp->minio, "(overrides
>      setting)");
>      A  A  A  A  do_set(minio_rq, mp->hwe, mp->minio, "(controller
>      setting)");
>      A  A  A  A  do_set(minio_rq, conf, mp->minio, "(config file setting)");
>      A  A  A  A  do_default(mp->minio, DEFAULT_MINIO_RQ);
>      @@ -441,6 +470,7 @@ select_minio_bio (struct multipath * mp)
>      A  A  A  A  char *origin;
> 
>      A  A  A  A  mp_set_mpe(minio);
>      +A  A  A  A mp_set_ovr(minio);
>      A  A  A  A  mp_set_hwe(minio);
>      A  A  A  A  mp_set_conf(minio);
>      A  A  A  A  mp_set_default(minio, DEFAULT_MINIO);
>      @@ -465,6 +495,7 @@ select_fast_io_fail(struct multipath *mp)
>      A {
>      A  A  A  A  char *origin, buff[12];
> 
>      +A  A  A  A mp_set_ovr(fast_io_fail);
>      A  A  A  A  mp_set_hwe(fast_io_fail);
>      A  A  A  A  mp_set_conf(fast_io_fail);
>      A  A  A  A  mp_set_default(fast_io_fail, DEFAULT_FAST_IO_FAIL);
>      @@ -479,6 +510,7 @@ select_dev_loss(struct multipath *mp)
>      A {
>      A  A  A  A  char *origin, buff[12];
> 
>      +A  A  A  A mp_set_ovr(dev_loss);
>      A  A  A  A  mp_set_hwe(dev_loss);
>      A  A  A  A  mp_set_conf(dev_loss);
>      A  A  A  A  mp->dev_loss = 0;
>      @@ -497,6 +529,7 @@ select_flush_on_last_del(struct multipath *mp)
>      A  A  A  A  if (mp->flush_on_last_del == FLUSH_IN_PROGRESS)
>      A  A  A  A  A  A  A  A  return 0;
>      A  A  A  A  mp_set_mpe(flush_on_last_del);
>      +A  A  A  A mp_set_ovr(flush_on_last_del);
>      A  A  A  A  mp_set_hwe(flush_on_last_del);
>      A  A  A  A  mp_set_conf(flush_on_last_del);
>      A  A  A  A  mp_set_default(flush_on_last_del, FLUSH_DISABLED);
>      @@ -532,6 +565,7 @@ select_retain_hwhandler (struct multipath * mp)
>      A  A  A  A  A  A  A  A  origin = "(requires kernel version >= 1.5.0)";
>      A  A  A  A  A  A  A  A  goto out;
>      A  A  A  A  }
>      +A  A  A  A mp_set_ovr(retain_hwhandler);
>      A  A  A  A  mp_set_hwe(retain_hwhandler);
>      A  A  A  A  mp_set_conf(retain_hwhandler);
>      A  A  A  A  mp_set_default(retain_hwhandler, DEFAULT_RETAIN_HWHANDLER);
>      @@ -547,6 +581,7 @@ select_detect_prio (struct path * pp)
>      A {
>      A  A  A  A  char *origin;
> 
>      +A  A  A  A pp_set_ovr(detect_prio);
>      A  A  A  A  pp_set_hwe(detect_prio);
>      A  A  A  A  pp_set_conf(detect_prio);
>      A  A  A  A  pp_set_default(detect_prio, DEFAULT_DETECT_PRIO);
>      diff --git a/libmultipath/structs.c b/libmultipath/structs.c
>      index 30d247d..0538327 100644
>      --- a/libmultipath/structs.c
>      +++ b/libmultipath/structs.c
>      @@ -206,10 +206,7 @@ free_multipath_attributes (struct multipath * mpp)
>      A  A  A  A  if (!mpp)
>      A  A  A  A  A  A  A  A  return;
> 
>      -A  A  A  A if (mpp->selector &&
>      -A  A  A  A  A  A mpp->selector != conf->selector &&
>      -A  A  A  A  A  A (!mpp->mpe || (mpp->mpe && mpp->selector !=
>      mpp->mpe->selector)) &&
>      -A  A  A  A  A  A (!mpp->hwe || (mpp->hwe && mpp->selector !=
>      mpp->hwe->selector))) {
>      +A  A  A  A if (mpp->selector) {
>      A  A  A  A  A  A  A  A  FREE(mpp->selector);
>      A  A  A  A  A  A  A  A  mpp->selector = NULL;
>      A  A  A  A  }
>      @@ -219,9 +216,7 @@ free_multipath_attributes (struct multipath * mpp)
>      A  A  A  A  A  A  A  A  mpp->features = NULL;
>      A  A  A  A  }
> 
>      -A  A  A  A if (mpp->hwhandler &&
>      -A  A  A  A  A  A mpp->hwhandler != conf->hwhandler &&
>      -A  A  A  A  A  A (!mpp->hwe || (mpp->hwe && mpp->hwhandler !=
>      mpp->hwe->hwhandler))) {
>      +A  A  A  A if (mpp->hwhandler) {
>      A  A  A  A  A  A  A  A  FREE(mpp->hwhandler);
>      A  A  A  A  A  A  A  A  mpp->hwhandler = NULL;
>      A  A  A  A  }
>      diff --git a/multipath.conf.annotated b/multipath.conf.annotated
>      index 0af1d4c..71afc0a 100644
>      --- a/multipath.conf.annotated
>      +++ b/multipath.conf.annotated
>      @@ -485,7 +485,8 @@
>      A ## scope : multipath & multipathd
>      A ## descA  : list of per storage controller settings
>      A ##A  A  A  A overrides default settings (device_maps block)
>      -##A  A  A  A  A overriden by per multipath settings (multipaths block)
>      +##A  A  A  A  overriden by per multipath settings (multipaths block)
>      +##A  A  A  A and the overrides settings (overrides block)
>      A ##
>      A #devices {
>      A #A  A  A  #
>      @@ -651,3 +652,18 @@
>      A #A  A  A  A  A  A  A  rr_weightA  A  A  A  A  A  A  A priorities
>      A #A  A  A  }
>      A #}
>      +#
>      +##
>      +## nameA  : devices
>      +## scope : multipath & multipathd
>      +## descA  : list of settings to override all hadware settings for all
>      devices
>      +##A  A  A  A overrides default settings (device_maps block)
>      +##A  A  A  A and per device type settings (devices block)
>      +##A  A  A  A  overriden by per multipath settings (multipaths block)
>      +##
>      +#A  A  A  attributes and values are identical to the device block
>      +#
>      +#overrides {
>      +#A  A  A  dev_loss_tmoA  A  A  A  A  A  60
>      +#A  A  A  no_path_retryA  A  A  A  A  A fail
>      +#}
>      diff --git a/multipath.conf.defaults b/multipath.conf.defaults
>      index 654be97..1c65e02 100644
>      --- a/multipath.conf.defaults
>      +++ b/multipath.conf.defaults
>      @@ -912,3 +912,5 @@
>      A #}
>      A #multipaths {
>      A #}
>      +#overrides {
>      +#}
>      diff --git a/multipath.conf.synthetic b/multipath.conf.synthetic
>      index bda1b75..f7b9b8a 100644
>      --- a/multipath.conf.synthetic
>      +++ b/multipath.conf.synthetic
>      @@ -72,3 +72,6 @@
>      A #A  A  A  A  A  A  A  path_grouping_policyA  A  multibus
>      A #A  A  A  }
>      A #}
>      +#overrides {
>      +#A  A  A  no_path_retryA  A  A  A  A  A  A  A  A  A fail
>      +#}
>      diff --git a/multipath/main.c b/multipath/main.c
>      index fd6262f..ea453b4 100644
>      --- a/multipath/main.c
>      +++ b/multipath/main.c
>      @@ -405,6 +405,12 @@ dump_config (void)
>      A  A  A  A  A  A  A  A  A  A  A  A  reply = REALLOC(reply, maxlen *= 2);
>      A  A  A  A  A  A  A  A  A  A  A  A  continue;
>      A  A  A  A  A  A  A  A  }
>      +A  A  A  A  A  A  A  A c += snprint_overrides(c, reply + maxlen - c,
>      conf->overrides);
>      +A  A  A  A  A  A  A  A again = ((c - reply) == maxlen);
>      +A  A  A  A  A  A  A  A if (again) {
>      +A  A  A  A  A  A  A  A  A  A  A  A reply = REALLOC(reply, maxlen *= 2);
>      +A  A  A  A  A  A  A  A  A  A  A  A continue;
>      +A  A  A  A  A  A  A  A }
>      A  A  A  A  A  A  A  A  c += snprint_mptable(c, reply + maxlen - c,
>      conf->mptable);
>      A  A  A  A  A  A  A  A  again = ((c - reply) == maxlen);
>      A  A  A  A  A  A  A  A  if (again)
>      diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
>      index cadb34d..b823990 100644
>      --- a/multipath/multipath.conf.5
>      +++ b/multipath/multipath.conf.5
>      @@ -61,6 +61,10 @@ the udev attribute given by the
>      A .TP
>      A .B devices
>      A This section defines the device-specific settings.
>      +.TP
>      +.B overrides
>      +This section defines values for attributes that should override the
>      +device-specific settings for all devices.
>      A .RE
>      A .LP
>      A .SH "defaults section"
>      @@ -629,6 +633,59 @@ section:
>      A .RE
>      A .PD
>      A .LP
>      +.SH "overrides section"
>      +The overrides section recognizes the following optional attributes; if
>      not set
>      +the values are taken from the
>      +.I devices
>      +or
>      +.I defaults
>      +sections:
>      +.sp 1
>      +.PD .1v
>      +.RS
>      +.TP 18
>      +.B path_grouping_policy
>      +.TP
>      +.B uid_attribute
>      +.TP
>      +.B getuid_callout
>      +.TP
>      +.B path_selector
>      +.TP
>      +.B path_checker
>      +.TP
>      +.B alias_prefix
>      +.TP
>      +.B features
>      +.TP
>      +.B prio
>      +.TP
>      +.B prio_args
>      +.TP
>      +.B failback
>      +.TP
>      +.B rr_weight
>      +.TP
>      +.B no_path_retry
>      +.TP
>      +.B rr_min_io
>      +.TP
>      +.B rr_min_io_rq
>      +.TP
>      +.B flush_on_last_del
>      +.TP
>      +.B fast_io_fail_tmo
>      +.TP
>      +.B dev_loss_tmo
>      +.TP
>      +.B user_friendly_names
>      +.TP
>      +.B retain_attached_hw_handler
>      +.TP
>      +.B detect_prio
>      +.RE
>      +.PD
>      +.LP
>      A .SH "KNOWN ISSUES"
>      A The usage of
>      A .B queue_if_no_path
>      diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
>      index b086340..0ce1408 100644
>      --- a/multipathd/cli_handlers.c
>      +++ b/multipathd/cli_handlers.c
>      @@ -190,6 +190,16 @@ show_config (char ** r, int * len)
>      A  A  A  A  A  A  A  A  A  A  A  A  maxlen *= 2;
>      A  A  A  A  A  A  A  A  A  A  A  A  continue;
>      A  A  A  A  A  A  A  A  }
>      +A  A  A  A  A  A  A  A c += snprint_overrides(c, reply + maxlen - c,
>      conf->overrides);
>      +A  A  A  A  A  A  A  A again = ((c - reply) == maxlen);
>      +A  A  A  A  A  A  A  A if (again) {
>      +A  A  A  A  A  A  A  A  A  A  A  A reply = REALLOC(reply, maxlen * 2);
>      +A  A  A  A  A  A  A  A  A  A  A  A if (!reply)
>      +A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A return 1;
>      +A  A  A  A  A  A  A  A  A  A  A  A memset(reply + maxlen, 0, maxlen);
>      +A  A  A  A  A  A  A  A  A  A  A  A maxlen *= 2;
>      +A  A  A  A  A  A  A  A  A  A  A  A continue;
>      +A  A  A  A  A  A  A  A }
>      A  A  A  A  A  A  A  A  c += snprint_mptable(c, reply + maxlen - c,
>      conf->mptable);
>      A  A  A  A  A  A  A  A  again = ((c - reply) == maxlen);
>      A  A  A  A  A  A  A  A  REALLOC_REPLY(reply, again, maxlen);
>      --
>      1.8.3.1
