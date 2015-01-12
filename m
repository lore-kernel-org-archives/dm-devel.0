From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 3/6] libmultipath: add overrides section to
	multipath.conf
Date: Mon, 12 Jan 2015 21:27:40 +0100
Message-ID: <CABr-GneMJ7NKp3gpwL5LvGKPRV_fjZ=1dO7tWgO8q_69mCaQeQ@mail.gmail.com>
References: <1416377859-15073-1-git-send-email-bmarzins@redhat.com>
	<1416377859-15073-4-git-send-email-bmarzins@redhat.com>
	<CABr-GndVm5ct_E7UoF86no5b36k8MpLU4KD5pYtO=h1NiT4LGQ@mail.gmail.com>
	<20150112180507.GY30600@ask-08.lab.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2208771626168058446=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150112180507.GY30600@ask-08.lab.msp.redhat.com>
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

--===============2208771626168058446==
Content-Type: multipart/alternative; boundary=001a11c373667c5c2a050c7a56e3

--001a11c373667c5c2a050c7a56e3
Content-Type: text/plain; charset=UTF-8

Ben,

I have no complaints about this patch iteration, and acknowledged the need
for some users. As nobody voiced against it, I will apply the patch.

Thanks,
Christophe Varoqui
OpenSVC


On Mon, Jan 12, 2015 at 7:05 PM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> On Fri, Jan 09, 2015 at 12:06:29AM +0100, Christophe Varoqui wrote:
> >    I have no strong opinion on this one : I feel like the complexity of
> the
> >    parameter inheritance system is already quite complicated ... but this
> >    addition of a new layer would likely and safely be ignored by users
> who
> >    don't need it. Those who need it are surely ready to pay the price.
> >    Does someone have objection to my applying this patch ?
>
> Christophe, I wrote this patch because you thought an "overrides"
> section would be more intuitive than my previous solution of a
> specialized "all_devs" devices section option to overwrite options on
> all the devices.
>
> http://www.redhat.com/archives/dm-devel/2014-September/msg00047.html
>
> Maybe this isn't exactly what you had in mind.  At any rate, I'd like to
> have some method inside of multipath to accomplish this.
>
> -Ben
>
> >    Best regards,
> >    Christophe
> >    On Wed, Nov 19, 2014 at 7:17 AM, Benjamin Marzinski <
> bmarzins@redhat.com>
> >    wrote:
> >
> >      Sometimes users want to be able to set a configuration value for all
> >      their
> >      devices (for instance, they may want all devices to set
> no_path_retry to
> >      fail). The builtin device configurations make this tricky, since
> users
> >      need
> >      to change each device configuration individually. To avoid that,
> this
> >      patch
> >      adds a new section to multipath.conf, "overrides".A  This section
> has
> >      all of
> >      the attributes that are in both the devices and defaults section.
> >      Attributes set in the overrides section have a higher priority that
> >      those
> >      in the devices section. With this section added, the multipath
> >      configuration order now goes:
> >
> >      multipaths > overrides > devices > defaults
> >
> >      I also made want_user_friendly_names print out where the
> configuration
> >      came
> >      from, and I made made select_hwhandler and select_selector always
> strdup
> >      the string, instead of only on the defaults.A  Since multipathd will
> >      update
> >      the device strings from the kernel anyway, the old way just added
> >      complexity without saving any memory.
> >
> >      To store the overrides configuration, I used a hwentry structure.
> We may
> >      want to make a new overrides structure, so that we set any of the
> >      defaults
> >      values in overrides.A  That way, users could skip using defaults and
> >      just
> >      use overrides if they wanted. However, this would take some
> additional
> >      changes to make sure that all the defaults options can undefined,
> which
> >      they can't currently be.
> >
> >      Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> >      ---
> >      A libmultipath/config.cA  A  A  |A  1 +
> >      A libmultipath/config.hA  A  A  |A  1 +
> >      A libmultipath/dict.cA  A  A  A  | 98
> >      ++++++++++++++++++++++++++++++++++++++++++++++
> >      A libmultipath/print.cA  A  A  A | 30 ++++++++++++++
> >      A libmultipath/print.hA  A  A  A |A  1 +
> >      A libmultipath/propsel.cA  A  A | 55 +++++++++++++++++++++-----
> >      A libmultipath/structs.cA  A  A |A  9 +----
> >      A multipath.conf.annotatedA  A | 18 ++++++++-
> >      A multipath.conf.defaultsA  A  |A  2 +
> >      A multipath.conf.syntheticA  A |A  3 ++
> >      A multipath/main.cA  A  A  A  A  A |A  6 +++
> >      A multipath/multipath.conf.5 | 57 +++++++++++++++++++++++++++
> >      A multipathd/cli_handlers.cA  | 10 +++++
> >      A 13 files changed, 273 insertions(+), 18 deletions(-)
> >
> >      diff --git a/libmultipath/config.c b/libmultipath/config.c
> >      index bfd8ee8..7f7bd5a 100644
> >      --- a/libmultipath/config.c
> >      +++ b/libmultipath/config.c
> >      @@ -523,6 +523,7 @@ free_config (struct config * conf)
> >
> >      A  A  A  A  free_mptable(conf->mptable);
> >      A  A  A  A  free_hwtable(conf->hwtable);
> >      +A  A  A  A free_hwe(conf->overrides);
> >      A  A  A  A  free_keywords(conf->keywords);
> >      A  A  A  A  FREE(conf);
> >      A }
> >      diff --git a/libmultipath/config.h b/libmultipath/config.h
> >      index c57ab31..ef1d7c3 100644
> >      --- a/libmultipath/config.h
> >      +++ b/libmultipath/config.h
> >      @@ -145,6 +145,7 @@ struct config {
> >      A  A  A  A  vector keywords;
> >      A  A  A  A  vector mptable;
> >      A  A  A  A  vector hwtable;
> >      +A  A  A  A struct hwentry *overrides;
> >
> >      A  A  A  A  vector blist_devnode;
> >      A  A  A  A  vector blist_wwid;
> >      diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> >      index 98cbe48..737c9b0 100644
> >      --- a/libmultipath/dict.c
> >      +++ b/libmultipath/dict.c
> >      @@ -181,6 +181,22 @@ snprint_hw_ ## option (char * buff, int len,
> void *
> >      data)A  A  A  A  A  \
> >      A  A  A  A  return function (buff, len, &hwe->option);A  A  A  A
> A  A
> >      A  A  A  A  A  \
> >      A }
> >
> >      +#define declare_ovr_handler(option, function)A  A  A  A  A  A  A
> A  A
> >      A  A  A  A  \
> >      +static intA  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A
> A
> >      A  A  A  A  A  A  A  A  A  A  A \
> >      +ovr_ ## option ## _handler (vector strvec)A  A  A  A  A  A  A  A
> A  A
> >      A  A  A  A  A \
> >      +{A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A
> A
> >      A  A  A  A  A  A  A  A  A  A  A  A  \
> >      +A  A  A  A if (!conf->overrides)A  A  A  A  A  A  A  A  A  A  A
> A  A
> >      A  A  A  A  A  A  A  A  A \
> >      +A  A  A  A  A  A  A  A return 1;A  A  A  A  A  A  A  A  A  A  A
> A  A
> >      A  A  A  A  A  A  A  A  A  A  A \
> >      +A  A  A  A return function (strvec, &conf->overrides->option);A
> A  A
> >      A  A  A  A \
> >      +}
> >      +
> >      +#define declare_ovr_snprint(option, function)A  A  A  A  A  A  A
> A  A
> >      A  A  A  A  \
> >      +static intA  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A
> A
> >      A  A  A  A  A  A  A  A  A  A  A \
> >      +snprint_ovr_ ## option (char * buff, int len, void * data)A  A  A
> A
> >      A  A  A \
> >      +{A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A
> A
> >      A  A  A  A  A  A  A  A  A  A  A  A  \
> >      +A  A  A  A return function (buff, len,
> &conf->overrides->option);A  A
> >      A  A  A  \
> >      +}
> >      +
> >      A #define declare_mp_handler(option, function)A  A  A  A  A  A  A
> A  A
> >      A  A  A  A  A \
> >      A static intA  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A
> A  A
> >      A  A  A  A  A  A  A  A  A  A  A \
> >      A mp_ ## option ## _handler (vector strvec)A  A  A  A  A  A  A  A
> A  A
> >      A  A  A  A  A  \
> >      @@ -218,21 +234,29 @@ declare_def_handler(selector, set_str)
> >      A declare_def_snprint_defstr(selector, print_str, DEFAULT_SELECTOR)
> >      A declare_hw_handler(selector, set_str)
> >      A declare_hw_snprint(selector, print_str)
> >      +declare_ovr_handler(selector, set_str)
> >      +declare_ovr_snprint(selector, print_str)
> >      A declare_mp_handler(selector, set_str)
> >      A declare_mp_snprint(selector, print_str)
> >
> >      A declare_def_handler(uid_attribute, set_str)
> >      A declare_def_snprint_defstr(uid_attribute, print_str,
> >      DEFAULT_UID_ATTRIBUTE)
> >      +declare_ovr_handler(uid_attribute, set_str)
> >      +declare_ovr_snprint(uid_attribute, print_str)
> >      A declare_hw_handler(uid_attribute, set_str)
> >      A declare_hw_snprint(uid_attribute, print_str)
> >
> >      A declare_def_handler(getuid, set_str)
> >      A declare_def_snprint(getuid, print_str)
> >      +declare_ovr_handler(getuid, set_str)
> >      +declare_ovr_snprint(getuid, print_str)
> >      A declare_hw_handler(getuid, set_str)
> >      A declare_hw_snprint(getuid, print_str)
> >
> >      A declare_def_handler(prio_name, set_str)
> >      A declare_def_snprint_defstr(prio_name, print_str, DEFAULT_PRIO)
> >      +declare_ovr_handler(prio_name, set_str)
> >      +declare_ovr_snprint(prio_name, print_str)
> >      A declare_hw_handler(prio_name, set_str)
> >      A declare_hw_snprint(prio_name, print_str)
> >      A declare_mp_handler(prio_name, set_str)
> >      @@ -240,11 +264,15 @@ declare_mp_snprint(prio_name, print_str)
> >
> >      A declare_def_handler(alias_prefix, set_str)
> >      A declare_def_snprint_defstr(alias_prefix, print_str,
> >      DEFAULT_ALIAS_PREFIX)
> >      +declare_ovr_handler(alias_prefix, set_str)
> >      +declare_ovr_snprint(alias_prefix, print_str)
> >      A declare_hw_handler(alias_prefix, set_str)
> >      A declare_hw_snprint(alias_prefix, print_str)
> >
> >      A declare_def_handler(prio_args, set_str)
> >      A declare_def_snprint_defstr(prio_args, print_str,
> DEFAULT_PRIO_ARGS)
> >      +declare_ovr_handler(prio_args, set_str)
> >      +declare_ovr_snprint(prio_args, print_str)
> >      A declare_hw_handler(prio_args, set_str)
> >      A declare_hw_snprint(prio_args, print_str)
> >      A declare_mp_handler(prio_args, set_str)
> >      @@ -252,6 +280,8 @@ declare_mp_snprint(prio_args, print_str)
> >
> >      A declare_def_handler(features, set_str)
> >      A declare_def_snprint_defstr(features, print_str, DEFAULT_FEATURES)
> >      +declare_ovr_handler(features, set_str)
> >      +declare_ovr_snprint(features, print_str)
> >      A declare_hw_handler(features, set_str)
> >      A declare_hw_snprint(features, print_str)
> >      A declare_mp_handler(features, set_str)
> >      @@ -259,11 +289,15 @@ declare_mp_snprint(features, print_str)
> >
> >      A declare_def_handler(checker_name, set_str)
> >      A declare_def_snprint_defstr(checker_name, print_str,
> DEFAULT_CHECKER)
> >      +declare_ovr_handler(checker_name, set_str)
> >      +declare_ovr_snprint(checker_name, print_str)
> >      A declare_hw_handler(checker_name, set_str)
> >      A declare_hw_snprint(checker_name, print_str)
> >
> >      A declare_def_handler(minio, set_int)
> >      A declare_def_snprint_defint(minio, print_int, DEFAULT_MINIO)
> >      +declare_ovr_handler(minio, set_int)
> >      +declare_ovr_snprint(minio, print_nonzero)
> >      A declare_hw_handler(minio, set_int)
> >      A declare_hw_snprint(minio, print_nonzero)
> >      A declare_mp_handler(minio, set_int)
> >      @@ -271,6 +305,8 @@ declare_mp_snprint(minio, print_nonzero)
> >
> >      A declare_def_handler(minio_rq, set_int)
> >      A declare_def_snprint_defint(minio_rq, print_int, DEFAULT_MINIO_RQ)
> >      +declare_ovr_handler(minio_rq, set_int)
> >      +declare_ovr_snprint(minio_rq, print_nonzero)
> >      A declare_hw_handler(minio_rq, set_int)
> >      A declare_hw_snprint(minio_rq, print_nonzero)
> >      A declare_mp_handler(minio_rq, set_int)
> >      @@ -296,6 +332,8 @@ declare_def_snprint(checker_timeout,
> print_nonzero)
> >
> >      A declare_def_handler(flush_on_last_del, set_yes_no_undef)
> >      A declare_def_snprint_defint(flush_on_last_del, print_yes_no_undef,
> >      YNU_NO)
> >      +declare_ovr_handler(flush_on_last_del, set_yes_no_undef)
> >      +declare_ovr_snprint(flush_on_last_del, print_yes_no_undef)
> >      A declare_hw_handler(flush_on_last_del, set_yes_no_undef)
> >      A declare_hw_snprint(flush_on_last_del, print_yes_no_undef)
> >      A declare_mp_handler(flush_on_last_del, set_yes_no_undef)
> >      @@ -303,6 +341,8 @@ declare_mp_snprint(flush_on_last_del,
> >      print_yes_no_undef)
> >
> >      A declare_def_handler(user_friendly_names, set_yes_no_undef)
> >      A declare_def_snprint_defint(user_friendly_names,
> print_yes_no_undef,
> >      YNU_NO)
> >      +declare_ovr_handler(user_friendly_names, set_yes_no_undef)
> >      +declare_ovr_snprint(user_friendly_names, print_yes_no_undef)
> >      A declare_hw_handler(user_friendly_names, set_yes_no_undef)
> >      A declare_hw_snprint(user_friendly_names, print_yes_no_undef)
> >      A declare_mp_handler(user_friendly_names, set_yes_no_undef)
> >      @@ -316,11 +356,15 @@ declare_def_snprint(wwids_file, print_str)
> >
> >      A declare_def_handler(retain_hwhandler, set_yes_no_undef)
> >      A declare_def_snprint_defint(retain_hwhandler, print_yes_no_undef,
> >      YNU_NO)
> >      +declare_ovr_handler(retain_hwhandler, set_yes_no_undef)
> >      +declare_ovr_snprint(retain_hwhandler, print_yes_no_undef)
> >      A declare_hw_handler(retain_hwhandler, set_yes_no_undef)
> >      A declare_hw_snprint(retain_hwhandler, print_yes_no_undef)
> >
> >      A declare_def_handler(detect_prio, set_yes_no_undef)
> >      A declare_def_snprint_defint(detect_prio, print_yes_no_undef,
> YNU_NO)
> >      +declare_ovr_handler(detect_prio, set_yes_no_undef)
> >      +declare_ovr_snprint(detect_prio, print_yes_no_undef)
> >      A declare_hw_handler(detect_prio, set_yes_no_undef)
> >      A declare_hw_snprint(detect_prio, print_yes_no_undef)
> >
> >      @@ -512,6 +556,8 @@ print_fast_io_fail(char * buff, int len, void
> *ptr)
> >
> >      A declare_def_handler(fast_io_fail, set_fast_io_fail)
> >      A declare_def_snprint(fast_io_fail, print_fast_io_fail)
> >      +declare_ovr_handler(fast_io_fail, set_fast_io_fail)
> >      +declare_ovr_snprint(fast_io_fail, print_fast_io_fail)
> >      A declare_hw_handler(fast_io_fail, set_fast_io_fail)
> >      A declare_hw_snprint(fast_io_fail, print_fast_io_fail)
> >
> >      @@ -548,6 +594,8 @@ print_dev_loss(char * buff, int len, void *ptr)
> >
> >      A declare_def_handler(dev_loss, set_dev_loss)
> >      A declare_def_snprint(dev_loss, print_dev_loss)
> >      +declare_ovr_handler(dev_loss, set_dev_loss)
> >      +declare_ovr_snprint(dev_loss, print_dev_loss)
> >      A declare_hw_handler(dev_loss, set_dev_loss)
> >      A declare_hw_snprint(dev_loss, print_dev_loss)
> >
> >      @@ -583,6 +631,8 @@ print_pgpolicy(char * buff, int len, void *ptr)
> >
> >      A declare_def_handler(pgpolicy, set_pgpolicy)
> >      A declare_def_snprint_defint(pgpolicy, print_pgpolicy,
> DEFAULT_PGPOLICY)
> >      +declare_ovr_handler(pgpolicy, set_pgpolicy)
> >      +declare_ovr_snprint(pgpolicy, print_pgpolicy)
> >      A declare_hw_handler(pgpolicy, set_pgpolicy)
> >      A declare_hw_snprint(pgpolicy, print_pgpolicy)
> >      A declare_mp_handler(pgpolicy, set_pgpolicy)
> >      @@ -700,6 +750,8 @@ print_rr_weight (char * buff, int len, void
> *ptr)
> >
> >      A declare_def_handler(rr_weight, set_rr_weight)
> >      A declare_def_snprint_defint(rr_weight, print_rr_weight,
> RR_WEIGHT_NONE)
> >      +declare_ovr_handler(rr_weight, set_rr_weight)
> >      +declare_ovr_snprint(rr_weight, print_rr_weight)
> >      A declare_hw_handler(rr_weight, set_rr_weight)
> >      A declare_hw_snprint(rr_weight, print_rr_weight)
> >      A declare_mp_handler(rr_weight, set_rr_weight)
> >      @@ -748,6 +800,8 @@ print_pgfailback (char * buff, int len, void
> *ptr)
> >
> >      A declare_def_handler(pgfailback, set_pgfailback)
> >      A declare_def_snprint_defint(pgfailback, print_pgfailback,
> >      DEFAULT_FAILBACK)
> >      +declare_ovr_handler(pgfailback, set_pgfailback)
> >      +declare_ovr_snprint(pgfailback, print_pgfailback)
> >      A declare_hw_handler(pgfailback, set_pgfailback)
> >      A declare_hw_snprint(pgfailback, print_pgfailback)
> >      A declare_mp_handler(pgfailback, set_pgfailback)
> >      @@ -793,6 +847,8 @@ print_no_path_retry(char * buff, int len, void
> *ptr)
> >
> >      A declare_def_handler(no_path_retry, set_no_path_retry)
> >      A declare_def_snprint(no_path_retry, print_no_path_retry)
> >      +declare_ovr_handler(no_path_retry, set_no_path_retry)
> >      +declare_ovr_snprint(no_path_retry, print_no_path_retry)
> >      A declare_hw_handler(no_path_retry, set_no_path_retry)
> >      A declare_hw_snprint(no_path_retry, print_no_path_retry)
> >      A declare_mp_handler(no_path_retry, set_no_path_retry)
> >      @@ -1061,6 +1117,25 @@ declare_hw_handler(hwhandler, set_str)
> >      A declare_hw_snprint(hwhandler, print_str)
> >
> >      A /*
> >      + * overrides handlers
> >      + */
> >      +static int
> >      +overrides_handler(vector strvec)
> >      +{
> >      +A  A  A  A struct hwentry * overrides;
> >      +
> >      +A  A  A  A overrides = alloc_hwe();
> >      +
> >      +A  A  A  A if (!overrides)
> >      +A  A  A  A  A  A  A  A return 1;
> >      +
> >      +A  A  A  A conf->overrides = overrides;
> >      +A  A  A  A return 0;
> >      +}
> >      +
> >      +
> >      +
> >      +/*
> >      A  * multipaths block handlers
> >      A  */
> >      A static int
> >      @@ -1236,6 +1311,29 @@ init_keywords(void)
> >      A  A  A  A  install_keyword("detect_prio", &hw_detect_prio_handler,
> >      &snprint_hw_detect_prio);
> >      A  A  A  A  install_sublevel_end();
> >
> >      +A  A  A  A install_keyword_root("overrides", &overrides_handler);
> >      +A  A  A  A install_keyword("path_grouping_policy",
> >      &ovr_pgpolicy_handler, &snprint_ovr_pgpolicy);
> >      +A  A  A  A install_keyword("uid_attribute",
> &ovr_uid_attribute_handler,
> >      &snprint_ovr_uid_attribute);
> >      +A  A  A  A install_keyword("getuid_callout", &ovr_getuid_handler,
> >      &snprint_ovr_getuid);
> >      +A  A  A  A install_keyword("path_selector", &ovr_selector_handler,
> >      &snprint_ovr_selector);
> >      +A  A  A  A install_keyword("path_checker",
> &ovr_checker_name_handler,
> >      &snprint_ovr_checker_name);
> >      +A  A  A  A install_keyword("checker", &ovr_checker_name_handler,
> NULL);
> >      +A  A  A  A install_keyword("alias_prefix",
> &ovr_alias_prefix_handler,
> >      &snprint_ovr_alias_prefix);
> >      +A  A  A  A install_keyword("features", &ovr_features_handler,
> >      &snprint_ovr_features);
> >      +A  A  A  A install_keyword("prio", &ovr_prio_name_handler,
> >      &snprint_ovr_prio_name);
> >      +A  A  A  A install_keyword("prio_args", &ovr_prio_args_handler,
> >      &snprint_ovr_prio_args);
> >      +A  A  A  A install_keyword("failback", &ovr_pgfailback_handler,
> >      &snprint_ovr_pgfailback);
> >      +A  A  A  A install_keyword("rr_weight", &ovr_rr_weight_handler,
> >      &snprint_ovr_rr_weight);
> >      +A  A  A  A install_keyword("no_path_retry",
> &ovr_no_path_retry_handler,
> >      &snprint_ovr_no_path_retry);
> >      +A  A  A  A install_keyword("rr_min_io", &ovr_minio_handler,
> >      &snprint_ovr_minio);
> >      +A  A  A  A install_keyword("rr_min_io_rq", &ovr_minio_rq_handler,
> >      &snprint_ovr_minio_rq);
> >      +A  A  A  A install_keyword("flush_on_last_del",
> >      &ovr_flush_on_last_del_handler, &snprint_ovr_flush_on_last_del);
> >      +A  A  A  A install_keyword("fast_io_fail_tmo",
> >      &ovr_fast_io_fail_handler, &snprint_ovr_fast_io_fail);
> >      +A  A  A  A install_keyword("dev_loss_tmo", &ovr_dev_loss_handler,
> >      &snprint_ovr_dev_loss);
> >      +A  A  A  A install_keyword("user_friendly_names",
> >      &ovr_user_friendly_names_handler, &snprint_ovr_user_friendly_names);
> >      +A  A  A  A install_keyword("retain_attached_hw_handler",
> >      &ovr_retain_hwhandler_handler, &snprint_ovr_retain_hwhandler);
> >      +A  A  A  A install_keyword("detect_prio", &ovr_detect_prio_handler,
> >      &snprint_ovr_detect_prio);
> >      +
> >      A  A  A  A  install_keyword_root("multipaths", &multipaths_handler);
> >      A  A  A  A  install_keyword_multi("multipath", &multipath_handler,
> >      NULL);
> >      A  A  A  A  install_sublevel();
> >      diff --git a/libmultipath/print.c b/libmultipath/print.c
> >      index 383eae4..ade3841 100644
> >      --- a/libmultipath/print.c
> >      +++ b/libmultipath/print.c
> >      @@ -1080,6 +1080,36 @@ snprint_mptable (char * buff, int len, vector
> >      mptable)
> >      A }
> >
> >      A extern int
> >      +snprint_overrides (char * buff, int len, struct hwentry *overrides)
> >      +{
> >      +A  A  A  A int fwd = 0;
> >      +A  A  A  A int i;
> >      +A  A  A  A struct keyword *rootkw;
> >      +A  A  A  A struct keyword *kw;
> >      +
> >      +A  A  A  A rootkw = find_keyword(NULL, "overrides");
> >      +A  A  A  A if (!rootkw)
> >      +A  A  A  A  A  A  A  A return 0;
> >      +
> >      +A  A  A  A fwd += snprintf(buff + fwd, len - fwd, "overrides {\n");
> >      +A  A  A  A if (fwd > len)
> >      +A  A  A  A  A  A  A  A return len;
> >      +A  A  A  A if (!overrides)
> >      +A  A  A  A  A  A  A  A goto out;
> >      +A  A  A  A iterate_sub_keywords(rootkw, kw, i) {
> >      +A  A  A  A  A  A  A  A fwd += snprint_keyword(buff + fwd, len -
> fwd,
> >      "\t%k %v\n",
> >      +A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  kw, NULL);
> >      +A  A  A  A  A  A  A  A if (fwd > len)
> >      +A  A  A  A  A  A  A  A  A  A  A  A return len;
> >      +A  A  A  A }
> >      +out:
> >      +A  A  A  A fwd += snprintf(buff + fwd, len - fwd, "}\n");
> >      +A  A  A  A if (fwd > len)
> >      +A  A  A  A  A  A  A  A return len;
> >      +A  A  A  A return fwd;
> >      +}
> >      +
> >      +extern int
> >      A snprint_defaults (char * buff, int len)
> >      A {
> >      A  A  A  A  int fwd = 0;
> >      diff --git a/libmultipath/print.h b/libmultipath/print.h
> >      index aef182b..a3c3319 100644
> >      --- a/libmultipath/print.h
> >      +++ b/libmultipath/print.h
> >      @@ -50,6 +50,7 @@ int snprint_status (char *, int, struct vectors
> *);
> >      A int snprint_devices (char *, int, struct vectors *);
> >      A int snprint_hwtable (char *, int, vector);
> >      A int snprint_mptable (char *, int, vector);
> >      +int snprint_overrides (char *, int, struct hwentry *);
> >
> >      A void print_multipath_topology (struct multipath * mpp, int
> verbosity);
> >      A void print_path (struct path * pp, char * style);
> >      diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> >      index f2ab7d2..440802c 100644
> >      --- a/libmultipath/propsel.c
> >      +++ b/libmultipath/propsel.c
> >      @@ -48,6 +48,8 @@ do {A  A  A  A  A  A  A  A  A  A  A  A  A  A  A
> A  A
> >      A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  \
> >      A do_set(var, mp->mpe, mp->var, "(LUN setting)")
> >      A #define mp_set_hwe(var)A  A  A  A  A  A  A  A  A  A  A  A  A  A
> A  A
> >      A  A  A  A  A  A  A  A  A  A  A  A  \
> >      A do_set(var, mp->hwe, mp->var, "(controller setting)")
> >      +#define mp_set_ovr(var)A  A  A  A  A  A  A  A  A  A  A  A  A  A
> A  A
> >      A  A  A  A  A  A  A  A  A  A  A  A  \
> >      +do_set(var, conf->overrides, mp->var, "(overrides setting)")
> >      A #define mp_set_conf(var)A  A  A  A  A  A  A  A  A  A  A  A  A  A
> A
> >      A  A  A  A  A  A  A  A  A \
> >      A do_set(var, conf, mp->var, "(config file default)")
> >      A #define mp_set_default(var, value)A  A  A  A  A  A  A  A  A  A
> A  A
> >      A  A  A  A  A  A  A \
> >      @@ -59,6 +61,8 @@ do_set(var, mpe, pp->var, "(LUN setting)")
> >      A do_set(var, pp->hwe, pp->var, "(controller setting)")
> >      A #define pp_set_conf(var)A  A  A  A  A  A  A  A  A  A  A  A  A  A
> A
> >      A  A  A  A  A  A  A  A  A \
> >      A do_set(var, conf, pp->var, "(config file default)")
> >      +#define pp_set_ovr(var)A  A  A  A  A  A  A  A  A  A  A  A  A  A
> A  A
> >      A  A  A  A  A  A  A  A  A  A  A  A  \
> >      +do_set(var, conf->overrides, pp->var, "(overrides setting)")
> >      A #define pp_set_default(var, value)A  A  A  A  A  A  A  A  A  A
> A  A
> >      A  A  A  A  A  A  A \
> >      A do_default(pp->var, value)
> >
> >      @@ -130,6 +134,7 @@ select_rr_weight (struct multipath * mp)
> >      A  A  A  A  char *origin, buff[13];
> >
> >      A  A  A  A  mp_set_mpe(rr_weight);
> >      +A  A  A  A mp_set_ovr(rr_weight);
> >      A  A  A  A  mp_set_hwe(rr_weight);
> >      A  A  A  A  mp_set_conf(rr_weight);
> >      A  A  A  A  mp_set_default(rr_weight, RR_WEIGHT_NONE);
> >      @@ -145,6 +150,7 @@ select_pgfailback (struct multipath * mp)
> >      A  A  A  A  char *origin, buff[13];
> >
> >      A  A  A  A  mp_set_mpe(pgfailback);
> >      +A  A  A  A mp_set_ovr(pgfailback);
> >      A  A  A  A  mp_set_hwe(pgfailback);
> >      A  A  A  A  mp_set_conf(pgfailback);
> >      A  A  A  A  mp_set_default(pgfailback, DEFAULT_FAILBACK);
> >      @@ -165,6 +171,7 @@ select_pgpolicy (struct multipath * mp)
> >      A  A  A  A  A  A  A  A  goto out;
> >      A  A  A  A  }
> >      A  A  A  A  mp_set_mpe(pgpolicy);
> >      +A  A  A  A mp_set_ovr(pgpolicy);
> >      A  A  A  A  mp_set_hwe(pgpolicy);
> >      A  A  A  A  mp_set_conf(pgpolicy);
> >      A  A  A  A  mp_set_default(pgpolicy, DEFAULT_PGPOLICY);
> >      @@ -181,10 +188,12 @@ select_selector (struct multipath * mp)
> >      A  A  A  A  char *origin;
> >
> >      A  A  A  A  mp_set_mpe(selector);
> >      +A  A  A  A mp_set_ovr(selector);
> >      A  A  A  A  mp_set_hwe(selector);
> >      A  A  A  A  mp_set_conf(selector);
> >      -A  A  A  A mp_set_default(selector, set_default(DEFAULT_SELECTOR));
> >      +A  A  A  A mp_set_default(selector, DEFAULT_SELECTOR);
> >      A out:
> >      +A  A  A  A mp->selector = STRDUP(mp->selector);
> >      A  A  A  A  condlog(3, "%s: path_selector = \"%s\" %s", mp->alias,
> >      mp->selector,
> >      A  A  A  A  A  A  A  A  origin);
> >      A  A  A  A  return 0;
> >      @@ -195,6 +204,7 @@ select_alias_prefix (struct multipath * mp)
> >      A {
> >      A  A  A  A  char *origin;
> >
> >      +A  A  A  A mp_set_ovr(alias_prefix);
> >      A  A  A  A  mp_set_hwe(alias_prefix);
> >      A  A  A  A  mp_set_conf(alias_prefix);
> >      A  A  A  A  mp_set_default(alias_prefix, DEFAULT_ALIAS_PREFIX);
> >      @@ -206,19 +216,30 @@ out:
> >      A static int
> >      A want_user_friendly_names(struct multipath * mp)
> >      A {
> >      -A  A  A  A if (mp->mpe &&
> >      -A  A  A  A  A  A mp->mpe->user_friendly_names !=
> >      USER_FRIENDLY_NAMES_UNDEF)
> >      -A  A  A  A  A  A  A  A return (mp->mpe->user_friendly_names ==
> >      USER_FRIENDLY_NAMES_ON);
> >      -A  A  A  A if (mp->hwe &&
> >      -A  A  A  A  A  A mp->hwe->user_friendly_names !=
> >      USER_FRIENDLY_NAMES_UNDEF)
> >      -A  A  A  A  A  A  A  A return (mp->hwe->user_friendly_names ==
> >      USER_FRIENDLY_NAMES_ON);
> >      -A  A  A  A return (conf->user_friendly_namesA  ==
> >      USER_FRIENDLY_NAMES_ON);
> >      +
> >      +A  A  A  A char *origin;
> >      +A  A  A  A int user_friendly_names;
> >      +
> >      +A  A  A  A do_set(user_friendly_names, mp->mpe,
> user_friendly_names,
> >      +A  A  A  A  A  A  A  "(LUN setting)");
> >      +A  A  A  A do_set(user_friendly_names, conf->overrides,
> >      user_friendly_names,
> >      +A  A  A  A  A  A  A  "(overrides setting)");
> >      +A  A  A  A do_set(user_friendly_names, mp->hwe,
> user_friendly_names,
> >      +A  A  A  A  A  A  A  "(controller setting)");
> >      +A  A  A  A do_set(user_friendly_names, conf, user_friendly_names,
> >      +A  A  A  A  A  A  A  "(config file setting)");
> >      +A  A  A  A do_default(user_friendly_names,
> USER_FRIENDLY_NAMES_OFF);
> >      +out:
> >      +A  A  A  A condlog(3, "%s: user_friendly_names = %s %s", mp->wwid,
> >      +A  A  A  A  A  A  A  A (user_friendly_names ==
> USER_FRIENDLY_NAMES_ON)?
> >      "yes" : "no",
> >      +A  A  A  A  A  A  A  A origin);
> >      +A  A  A  A return (user_friendly_names == USER_FRIENDLY_NAMES_ON);
> >      A }
> >
> >      A extern int
> >      A select_alias (struct multipath * mp)
> >      A {
> >      -A  A  A  A char *origin;
> >      +A  A  A  A char *origin = NULL;
> >
> >      A  A  A  A  if (mp->mpe && mp->mpe->alias) {
> >      A  A  A  A  A  A  A  A  mp->alias = STRDUP(mp->mpe->alias);
> >      @@ -261,6 +282,7 @@ select_features (struct multipath * mp)
> >      A  A  A  A  char *origin;
> >
> >      A  A  A  A  mp_set_mpe(features);
> >      +A  A  A  A mp_set_ovr(features);
> >      A  A  A  A  mp_set_hwe(features);
> >      A  A  A  A  mp_set_conf(features);
> >      A  A  A  A  mp_set_default(features, DEFAULT_FEATURES);
> >      @@ -287,8 +309,9 @@ select_hwhandler (struct multipath * mp)
> >
> >      A  A  A  A  mp_set_hwe(hwhandler);
> >      A  A  A  A  mp_set_conf(hwhandler);
> >      -A  A  A  A mp_set_default(hwhandler,
> set_default(DEFAULT_HWHANDLER));
> >      +A  A  A  A mp_set_default(hwhandler, DEFAULT_HWHANDLER);
> >      A out:
> >      +A  A  A  A mp->hwhandler = STRDUP(mp->hwhandler);
> >      A  A  A  A  condlog(3, "%s: hardware_handler = \"%s\" %s",
> mp->alias,
> >      mp->hwhandler,
> >      A  A  A  A  A  A  A  A  origin);
> >      A  A  A  A  return 0;
> >      @@ -300,6 +323,7 @@ select_checker(struct path *pp)
> >      A  A  A  A  char *origin, *checker_name;
> >      A  A  A  A  struct checker * c = &pp->checker;
> >
> >      +A  A  A  A do_set(checker_name, conf->overrides, checker_name,
> >      "(overrides setting)");
> >      A  A  A  A  do_set(checker_name, pp->hwe, checker_name, "(controller
> >      setting)");
> >      A  A  A  A  do_set(checker_name, conf, checker_name, "(config file
> >      setting)");
> >      A  A  A  A  do_default(checker_name, DEFAULT_CHECKER);
> >      @@ -327,6 +351,8 @@ select_getuid (struct path * pp)
> >      A {
> >      A  A  A  A  char *origin;
> >
> >      +A  A  A  A pp_set_ovr(uid_attribute);
> >      +A  A  A  A pp_set_ovr(getuid);
> >      A  A  A  A  pp_set_hwe(uid_attribute);
> >      A  A  A  A  pp_set_hwe(getuid);
> >      A  A  A  A  pp_set_conf(uid_attribute);
> >      @@ -383,6 +409,7 @@ select_prio (struct path * pp)
> >      A  A  A  A  }
> >      A  A  A  A  mpe = find_mpe(pp->wwid);
> >      A  A  A  A  set_prio(mpe, "(LUN setting)");
> >      +A  A  A  A set_prio(conf->overrides, "(overrides setting)");
> >      A  A  A  A  set_prio(pp->hwe, "controller setting)");
> >      A  A  A  A  set_prio(conf, "(config file default)");
> >      A  A  A  A  prio_get(p, DEFAULT_PRIO, DEFAULT_PRIO_ARGS);
> >      @@ -405,6 +432,7 @@ select_no_path_retry(struct multipath *mp)
> >      A  A  A  A  A  A  A  A  return 0;
> >      A  A  A  A  }
> >      A  A  A  A  mp_set_mpe(no_path_retry);
> >      +A  A  A  A mp_set_ovr(no_path_retry);
> >      A  A  A  A  mp_set_hwe(no_path_retry);
> >      A  A  A  A  mp_set_conf(no_path_retry);
> >      A out:
> >      @@ -427,6 +455,7 @@ select_minio_rq (struct multipath * mp)
> >      A  A  A  A  char *origin;
> >
> >      A  A  A  A  do_set(minio_rq, mp->mpe, mp->minio, "(LUN setting)");
> >      +A  A  A  A do_set(minio_rq, conf->overrides, mp->minio, "(overrides
> >      setting)");
> >      A  A  A  A  do_set(minio_rq, mp->hwe, mp->minio, "(controller
> >      setting)");
> >      A  A  A  A  do_set(minio_rq, conf, mp->minio, "(config file
> setting)");
> >      A  A  A  A  do_default(mp->minio, DEFAULT_MINIO_RQ);
> >      @@ -441,6 +470,7 @@ select_minio_bio (struct multipath * mp)
> >      A  A  A  A  char *origin;
> >
> >      A  A  A  A  mp_set_mpe(minio);
> >      +A  A  A  A mp_set_ovr(minio);
> >      A  A  A  A  mp_set_hwe(minio);
> >      A  A  A  A  mp_set_conf(minio);
> >      A  A  A  A  mp_set_default(minio, DEFAULT_MINIO);
> >      @@ -465,6 +495,7 @@ select_fast_io_fail(struct multipath *mp)
> >      A {
> >      A  A  A  A  char *origin, buff[12];
> >
> >      +A  A  A  A mp_set_ovr(fast_io_fail);
> >      A  A  A  A  mp_set_hwe(fast_io_fail);
> >      A  A  A  A  mp_set_conf(fast_io_fail);
> >      A  A  A  A  mp_set_default(fast_io_fail, DEFAULT_FAST_IO_FAIL);
> >      @@ -479,6 +510,7 @@ select_dev_loss(struct multipath *mp)
> >      A {
> >      A  A  A  A  char *origin, buff[12];
> >
> >      +A  A  A  A mp_set_ovr(dev_loss);
> >      A  A  A  A  mp_set_hwe(dev_loss);
> >      A  A  A  A  mp_set_conf(dev_loss);
> >      A  A  A  A  mp->dev_loss = 0;
> >      @@ -497,6 +529,7 @@ select_flush_on_last_del(struct multipath *mp)
> >      A  A  A  A  if (mp->flush_on_last_del == FLUSH_IN_PROGRESS)
> >      A  A  A  A  A  A  A  A  return 0;
> >      A  A  A  A  mp_set_mpe(flush_on_last_del);
> >      +A  A  A  A mp_set_ovr(flush_on_last_del);
> >      A  A  A  A  mp_set_hwe(flush_on_last_del);
> >      A  A  A  A  mp_set_conf(flush_on_last_del);
> >      A  A  A  A  mp_set_default(flush_on_last_del, FLUSH_DISABLED);
> >      @@ -532,6 +565,7 @@ select_retain_hwhandler (struct multipath * mp)
> >      A  A  A  A  A  A  A  A  origin = "(requires kernel version >=
> 1.5.0)";
> >      A  A  A  A  A  A  A  A  goto out;
> >      A  A  A  A  }
> >      +A  A  A  A mp_set_ovr(retain_hwhandler);
> >      A  A  A  A  mp_set_hwe(retain_hwhandler);
> >      A  A  A  A  mp_set_conf(retain_hwhandler);
> >      A  A  A  A  mp_set_default(retain_hwhandler,
> DEFAULT_RETAIN_HWHANDLER);
> >      @@ -547,6 +581,7 @@ select_detect_prio (struct path * pp)
> >      A {
> >      A  A  A  A  char *origin;
> >
> >      +A  A  A  A pp_set_ovr(detect_prio);
> >      A  A  A  A  pp_set_hwe(detect_prio);
> >      A  A  A  A  pp_set_conf(detect_prio);
> >      A  A  A  A  pp_set_default(detect_prio, DEFAULT_DETECT_PRIO);
> >      diff --git a/libmultipath/structs.c b/libmultipath/structs.c
> >      index 30d247d..0538327 100644
> >      --- a/libmultipath/structs.c
> >      +++ b/libmultipath/structs.c
> >      @@ -206,10 +206,7 @@ free_multipath_attributes (struct multipath *
> mpp)
> >      A  A  A  A  if (!mpp)
> >      A  A  A  A  A  A  A  A  return;
> >
> >      -A  A  A  A if (mpp->selector &&
> >      -A  A  A  A  A  A mpp->selector != conf->selector &&
> >      -A  A  A  A  A  A (!mpp->mpe || (mpp->mpe && mpp->selector !=
> >      mpp->mpe->selector)) &&
> >      -A  A  A  A  A  A (!mpp->hwe || (mpp->hwe && mpp->selector !=
> >      mpp->hwe->selector))) {
> >      +A  A  A  A if (mpp->selector) {
> >      A  A  A  A  A  A  A  A  FREE(mpp->selector);
> >      A  A  A  A  A  A  A  A  mpp->selector = NULL;
> >      A  A  A  A  }
> >      @@ -219,9 +216,7 @@ free_multipath_attributes (struct multipath *
> mpp)
> >      A  A  A  A  A  A  A  A  mpp->features = NULL;
> >      A  A  A  A  }
> >
> >      -A  A  A  A if (mpp->hwhandler &&
> >      -A  A  A  A  A  A mpp->hwhandler != conf->hwhandler &&
> >      -A  A  A  A  A  A (!mpp->hwe || (mpp->hwe && mpp->hwhandler !=
> >      mpp->hwe->hwhandler))) {
> >      +A  A  A  A if (mpp->hwhandler) {
> >      A  A  A  A  A  A  A  A  FREE(mpp->hwhandler);
> >      A  A  A  A  A  A  A  A  mpp->hwhandler = NULL;
> >      A  A  A  A  }
> >      diff --git a/multipath.conf.annotated b/multipath.conf.annotated
> >      index 0af1d4c..71afc0a 100644
> >      --- a/multipath.conf.annotated
> >      +++ b/multipath.conf.annotated
> >      @@ -485,7 +485,8 @@
> >      A ## scope : multipath & multipathd
> >      A ## descA  : list of per storage controller settings
> >      A ##A  A  A  A overrides default settings (device_maps block)
> >      -##A  A  A  A  A overriden by per multipath settings (multipaths
> block)
> >      +##A  A  A  A  overriden by per multipath settings (multipaths
> block)
> >      +##A  A  A  A and the overrides settings (overrides block)
> >      A ##
> >      A #devices {
> >      A #A  A  A  #
> >      @@ -651,3 +652,18 @@
> >      A #A  A  A  A  A  A  A  rr_weightA  A  A  A  A  A  A  A priorities
> >      A #A  A  A  }
> >      A #}
> >      +#
> >      +##
> >      +## nameA  : devices
> >      +## scope : multipath & multipathd
> >      +## descA  : list of settings to override all hadware settings for
> all
> >      devices
> >      +##A  A  A  A overrides default settings (device_maps block)
> >      +##A  A  A  A and per device type settings (devices block)
> >      +##A  A  A  A  overriden by per multipath settings (multipaths
> block)
> >      +##
> >      +#A  A  A  attributes and values are identical to the device block
> >      +#
> >      +#overrides {
> >      +#A  A  A  dev_loss_tmoA  A  A  A  A  A  60
> >      +#A  A  A  no_path_retryA  A  A  A  A  A fail
> >      +#}
> >      diff --git a/multipath.conf.defaults b/multipath.conf.defaults
> >      index 654be97..1c65e02 100644
> >      --- a/multipath.conf.defaults
> >      +++ b/multipath.conf.defaults
> >      @@ -912,3 +912,5 @@
> >      A #}
> >      A #multipaths {
> >      A #}
> >      +#overrides {
> >      +#}
> >      diff --git a/multipath.conf.synthetic b/multipath.conf.synthetic
> >      index bda1b75..f7b9b8a 100644
> >      --- a/multipath.conf.synthetic
> >      +++ b/multipath.conf.synthetic
> >      @@ -72,3 +72,6 @@
> >      A #A  A  A  A  A  A  A  path_grouping_policyA  A  multibus
> >      A #A  A  A  }
> >      A #}
> >      +#overrides {
> >      +#A  A  A  no_path_retryA  A  A  A  A  A  A  A  A  A fail
> >      +#}
> >      diff --git a/multipath/main.c b/multipath/main.c
> >      index fd6262f..ea453b4 100644
> >      --- a/multipath/main.c
> >      +++ b/multipath/main.c
> >      @@ -405,6 +405,12 @@ dump_config (void)
> >      A  A  A  A  A  A  A  A  A  A  A  A  reply = REALLOC(reply, maxlen
> *= 2);
> >      A  A  A  A  A  A  A  A  A  A  A  A  continue;
> >      A  A  A  A  A  A  A  A  }
> >      +A  A  A  A  A  A  A  A c += snprint_overrides(c, reply + maxlen -
> c,
> >      conf->overrides);
> >      +A  A  A  A  A  A  A  A again = ((c - reply) == maxlen);
> >      +A  A  A  A  A  A  A  A if (again) {
> >      +A  A  A  A  A  A  A  A  A  A  A  A reply = REALLOC(reply, maxlen
> *= 2);
> >      +A  A  A  A  A  A  A  A  A  A  A  A continue;
> >      +A  A  A  A  A  A  A  A }
> >      A  A  A  A  A  A  A  A  c += snprint_mptable(c, reply + maxlen - c,
> >      conf->mptable);
> >      A  A  A  A  A  A  A  A  again = ((c - reply) == maxlen);
> >      A  A  A  A  A  A  A  A  if (again)
> >      diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> >      index cadb34d..b823990 100644
> >      --- a/multipath/multipath.conf.5
> >      +++ b/multipath/multipath.conf.5
> >      @@ -61,6 +61,10 @@ the udev attribute given by the
> >      A .TP
> >      A .B devices
> >      A This section defines the device-specific settings.
> >      +.TP
> >      +.B overrides
> >      +This section defines values for attributes that should override the
> >      +device-specific settings for all devices.
> >      A .RE
> >      A .LP
> >      A .SH "defaults section"
> >      @@ -629,6 +633,59 @@ section:
> >      A .RE
> >      A .PD
> >      A .LP
> >      +.SH "overrides section"
> >      +The overrides section recognizes the following optional
> attributes; if
> >      not set
> >      +the values are taken from the
> >      +.I devices
> >      +or
> >      +.I defaults
> >      +sections:
> >      +.sp 1
> >      +.PD .1v
> >      +.RS
> >      +.TP 18
> >      +.B path_grouping_policy
> >      +.TP
> >      +.B uid_attribute
> >      +.TP
> >      +.B getuid_callout
> >      +.TP
> >      +.B path_selector
> >      +.TP
> >      +.B path_checker
> >      +.TP
> >      +.B alias_prefix
> >      +.TP
> >      +.B features
> >      +.TP
> >      +.B prio
> >      +.TP
> >      +.B prio_args
> >      +.TP
> >      +.B failback
> >      +.TP
> >      +.B rr_weight
> >      +.TP
> >      +.B no_path_retry
> >      +.TP
> >      +.B rr_min_io
> >      +.TP
> >      +.B rr_min_io_rq
> >      +.TP
> >      +.B flush_on_last_del
> >      +.TP
> >      +.B fast_io_fail_tmo
> >      +.TP
> >      +.B dev_loss_tmo
> >      +.TP
> >      +.B user_friendly_names
> >      +.TP
> >      +.B retain_attached_hw_handler
> >      +.TP
> >      +.B detect_prio
> >      +.RE
> >      +.PD
> >      +.LP
> >      A .SH "KNOWN ISSUES"
> >      A The usage of
> >      A .B queue_if_no_path
> >      diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> >      index b086340..0ce1408 100644
> >      --- a/multipathd/cli_handlers.c
> >      +++ b/multipathd/cli_handlers.c
> >      @@ -190,6 +190,16 @@ show_config (char ** r, int * len)
> >      A  A  A  A  A  A  A  A  A  A  A  A  maxlen *= 2;
> >      A  A  A  A  A  A  A  A  A  A  A  A  continue;
> >      A  A  A  A  A  A  A  A  }
> >      +A  A  A  A  A  A  A  A c += snprint_overrides(c, reply + maxlen -
> c,
> >      conf->overrides);
> >      +A  A  A  A  A  A  A  A again = ((c - reply) == maxlen);
> >      +A  A  A  A  A  A  A  A if (again) {
> >      +A  A  A  A  A  A  A  A  A  A  A  A reply = REALLOC(reply, maxlen *
> 2);
> >      +A  A  A  A  A  A  A  A  A  A  A  A if (!reply)
> >      +A  A  A  A  A  A  A  A  A  A  A  A  A  A  A  A return 1;
> >      +A  A  A  A  A  A  A  A  A  A  A  A memset(reply + maxlen, 0,
> maxlen);
> >      +A  A  A  A  A  A  A  A  A  A  A  A maxlen *= 2;
> >      +A  A  A  A  A  A  A  A  A  A  A  A continue;
> >      +A  A  A  A  A  A  A  A }
> >      A  A  A  A  A  A  A  A  c += snprint_mptable(c, reply + maxlen - c,
> >      conf->mptable);
> >      A  A  A  A  A  A  A  A  again = ((c - reply) == maxlen);
> >      A  A  A  A  A  A  A  A  REALLOC_REPLY(reply, again, maxlen);
> >      --
> >      1.8.3.1
>

--001a11c373667c5c2a050c7a56e3
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Ben,<div><br></div><div>I have no complaints about this pa=
tch iteration, and acknowledged the need for some users. As nobody voiced a=
gainst it, I will apply the patch.</div><div><br></div><div>Thanks,</div><d=
iv>Christophe Varoqui</div><div>OpenSVC</div><div><br></div></div><div clas=
s=3D"gmail_extra"><br><div class=3D"gmail_quote">On Mon, Jan 12, 2015 at 7:=
05 PM, Benjamin Marzinski <span dir=3D"ltr">&lt;<a href=3D"mailto:bmarzins@=
redhat.com" target=3D"_blank">bmarzins@redhat.com</a>&gt;</span> wrote:<br>=
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><span class=3D"">On Fri, Jan 09, 2015 at 12:=
06:29AM +0100, Christophe Varoqui wrote:<br>
&gt;=C2=A0 =C2=A0 I have no strong opinion on this one : I feel like the co=
mplexity of the<br>
&gt;=C2=A0 =C2=A0 parameter inheritance system is already quite complicated=
 ... but this<br>
&gt;=C2=A0 =C2=A0 addition of a new layer would likely and safely be ignore=
d by users who<br>
&gt;=C2=A0 =C2=A0 don&#39;t need it. Those who need it are surely ready to =
pay the price.<br>
&gt;=C2=A0 =C2=A0 Does someone have objection to my applying this patch ?<b=
r>
<br>
</span>Christophe, I wrote this patch because you thought an &quot;override=
s&quot;<br>
section would be more intuitive than my previous solution of a<br>
specialized &quot;all_devs&quot; devices section option to overwrite option=
s on<br>
all the devices.<br>
<br>
<a href=3D"http://www.redhat.com/archives/dm-devel/2014-September/msg00047.=
html" target=3D"_blank">http://www.redhat.com/archives/dm-devel/2014-Septem=
ber/msg00047.html</a><br>
<br>
Maybe this isn&#39;t exactly what you had in mind.=C2=A0 At any rate, I&#39=
;d like to<br>
have some method inside of multipath to accomplish this.<br>
<br>
-Ben<br>
<span class=3D""><br>
&gt;=C2=A0 =C2=A0 Best regards,<br>
&gt;=C2=A0 =C2=A0 Christophe<br>
&gt;=C2=A0 =C2=A0 On Wed, Nov 19, 2014 at 7:17 AM, Benjamin Marzinski &lt;<=
a href=3D"mailto:bmarzins@redhat.com">bmarzins@redhat.com</a>&gt;<br>
&gt;=C2=A0 =C2=A0 wrote:<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 Sometimes users want to be able to set a configura=
tion value for all<br>
&gt;=C2=A0 =C2=A0 =C2=A0 their<br>
&gt;=C2=A0 =C2=A0 =C2=A0 devices (for instance, they may want all devices t=
o set no_path_retry to<br>
&gt;=C2=A0 =C2=A0 =C2=A0 fail). The builtin device configurations make this=
 tricky, since users<br>
&gt;=C2=A0 =C2=A0 =C2=A0 need<br>
&gt;=C2=A0 =C2=A0 =C2=A0 to change each device configuration individually. =
To avoid that, this<br>
&gt;=C2=A0 =C2=A0 =C2=A0 patch<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 adds a new section to multipath.conf, &quot=
;overrides&quot;.A=C2=A0 This section has<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 all of<br>
&gt;=C2=A0 =C2=A0 =C2=A0 the attributes that are in both the devices and de=
faults section.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 Attributes set in the overrides section have a hig=
her priority that<br>
&gt;=C2=A0 =C2=A0 =C2=A0 those<br>
&gt;=C2=A0 =C2=A0 =C2=A0 in the devices section. With this section added, t=
he multipath<br>
&gt;=C2=A0 =C2=A0 =C2=A0 configuration order now goes:<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 multipaths &gt; overrides &gt; devices &gt; defaul=
ts<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 I also made want_user_friendly_names print out whe=
re the configuration<br>
&gt;=C2=A0 =C2=A0 =C2=A0 came<br>
&gt;=C2=A0 =C2=A0 =C2=A0 from, and I made made select_hwhandler and select_=
selector always strdup<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 the string, instead of only on the defaults=
.A=C2=A0 Since multipathd will<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 update<br>
&gt;=C2=A0 =C2=A0 =C2=A0 the device strings from the kernel anyway, the old=
 way just added<br>
&gt;=C2=A0 =C2=A0 =C2=A0 complexity without saving any memory.<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 To store the overrides configuration, I used a hwe=
ntry structure. We may<br>
&gt;=C2=A0 =C2=A0 =C2=A0 want to make a new overrides structure, so that we=
 set any of the<br>
&gt;=C2=A0 =C2=A0 =C2=A0 defaults<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 values in overrides.A=C2=A0 That way, users=
 could skip using defaults and<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 just<br>
&gt;=C2=A0 =C2=A0 =C2=A0 use overrides if they wanted. However, this would =
take some additional<br>
&gt;=C2=A0 =C2=A0 =C2=A0 changes to make sure that all the defaults options=
 can undefined, which<br>
&gt;=C2=A0 =C2=A0 =C2=A0 they can&#39;t currently be.<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 Signed-off-by: Benjamin Marzinski &lt;<a href=3D"m=
ailto:bmarzins@redhat.com">bmarzins@redhat.com</a>&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 ---<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A libmultipath/config.cA=C2=A0 A=C2=A0 A=C2=
=A0 |A=C2=A0 1 +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A libmultipath/config.hA=C2=A0 A=C2=A0 A=C2=A0 |A=
=C2=A0 1 +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A libmultipath/dict.cA=C2=A0 A=C2=A0 A=C2=A0 A=C2=
=A0 | 98<br>
&gt;=C2=A0 =C2=A0 =C2=A0 ++++++++++++++++++++++++++++++++++++++++++++++<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A libmultipath/print.cA=C2=A0 A=C2=A0 A=C2=A0 A | =
30 ++++++++++++++<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A libmultipath/print.hA=C2=A0 A=C2=A0 A=C2=A0 A |A=
=C2=A0 1 +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A libmultipath/propsel.cA=C2=A0 A=C2=A0 A | 55 +++=
++++++++++++++++++-----<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A libmultipath/structs.cA=C2=A0 A=C2=A0 A |A=C2=A0=
 9 +----<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A multipath.conf.annotatedA=C2=A0 A | 18 ++++++++-=
<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A multipath.conf.defaultsA=C2=A0 A=C2=A0 |A=C2=A0 =
2 +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A multipath.conf.syntheticA=C2=A0 A |A=C2=A0 3 ++<=
br>
&gt;=C2=A0 =C2=A0 =C2=A0 A multipath/main.cA=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 =
A=C2=A0 A |A=C2=A0 6 +++<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A multipath/multipath.conf.5 | 57 ++++++++++++++++=
+++++++++++<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A multipathd/cli_handlers.cA=C2=A0 | 10 +++++<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A 13 files changed, 273 insertions(+), 18 deletion=
s(-)<br>
<span class=3D"">&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 diff --git a/libmultipath/config.c b/libmultipath/=
config.c<br>
&gt;=C2=A0 =C2=A0 =C2=A0 index bfd8ee8..7f7bd5a 100644<br>
&gt;=C2=A0 =C2=A0 =C2=A0 --- a/libmultipath/config.c<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +++ b/libmultipath/config.c<br>
&gt;=C2=A0 =C2=A0 =C2=A0 @@ -523,6 +523,7 @@ free_config (struct config * c=
onf)<br>
&gt;<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 free_mptabl=
e(conf-&gt;mptable);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 free_hwtable(conf-=
&gt;hwtable);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A free_hwe(conf-&gt;overr=
ides);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 free_keywords(conf=
-&gt;keywords);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 FREE(conf);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A }<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 diff --git a/libmultipath/config.=
h b/libmultipath/config.h<br>
&gt;=C2=A0 =C2=A0 =C2=A0 index c57ab31..ef1d7c3 100644<br>
&gt;=C2=A0 =C2=A0 =C2=A0 --- a/libmultipath/config.h<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +++ b/libmultipath/config.h<br>
&gt;=C2=A0 =C2=A0 =C2=A0 @@ -145,6 +145,7 @@ struct config {<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 vector keyw=
ords;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 vector mptable;<br=
>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 vector hwtable;<br=
>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A struct hwentry *overrid=
es;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 vector blist_devno=
de;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 vector blist_wwid;=
<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 diff --git a/libmultipath/dict.c =
b/libmultipath/dict.c<br>
&gt;=C2=A0 =C2=A0 =C2=A0 index 98cbe48..737c9b0 100644<br>
&gt;=C2=A0 =C2=A0 =C2=A0 --- a/libmultipath/dict.c<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +++ b/libmultipath/dict.c<br>
&gt;=C2=A0 =C2=A0 =C2=A0 @@ -181,6 +181,22 @@ snprint_hw_ ## option (char *=
 buff, int len, void *<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 data)A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=
=A0 \<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 return function (b=
uff, len, &amp;hwe-&gt;option);A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A<br=
>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 \<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A }<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +#define declare_ovr_handler(option, function)A=C2=
=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 \<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +static intA=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0=
 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A \<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +ovr_ ## option ## _handler (vector strvec)A=C2=A0=
 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A \<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +{A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 =
A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 \<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A if (!conf-&gt;overrides=
)A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 A=C2=A0 A<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 A \<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A return 1;A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A \<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A return function (strvec=
, &amp;conf-&gt;overrides-&gt;option);A=C2=A0 A=C2=A0 A<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A \<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +#define declare_ovr_snprint(option, function)A=C2=
=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 \<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +static intA=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0=
 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A \<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +snprint_ovr_ ## option (char * buff, int len, voi=
d * data)A=C2=A0 A=C2=A0 A=C2=A0 A<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A \<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +{A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 =
A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 \<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A return function (buff, =
len, &amp;conf-&gt;overrides-&gt;option);A=C2=A0 A<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 \<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A #define declare_mp_handler(option, function)A=C2=
=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A \<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A static intA=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=
=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0=
 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A \<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A mp_ ## option ## _handler (vector strvec)A=C2=A0=
 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 \<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 @@ -218,21 +234,29 @@ declare_def=
_handler(selector, set_str)<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A declare_def_snprint_defstr(selector, prin=
t_str, DEFAULT_SELECTOR)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_hw_handler(selector, set_str)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_hw_snprint(selector, print_str)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +declare_ovr_handler(selector, set_str)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +declare_ovr_snprint(selector, print_str)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_mp_handler(selector, set_str)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_mp_snprint(selector, print_str)<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_def_handler(uid_attribute, set_str)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_def_snprint_defstr(uid_attribute, print_=
str,<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 DEFAULT_UID_ATTRIBUTE)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +declare_ovr_handler(uid_attribute, set_str)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +declare_ovr_snprint(uid_attribute, print_str)<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A declare_hw_handler(uid_attribute, set_str=
)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_hw_snprint(uid_attribute, print_str)<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_def_handler(getuid, set_str)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_def_snprint(getuid, print_str)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +declare_ovr_handler(getuid, set_str)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +declare_ovr_snprint(getuid, print_str)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_hw_handler(getuid, set_str)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_hw_snprint(getuid, print_str)<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_def_handler(prio_name, set_str)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_def_snprint_defstr(prio_name, print_str,=
 DEFAULT_PRIO)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +declare_ovr_handler(prio_name, set_str)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +declare_ovr_snprint(prio_name, print_str)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_hw_handler(prio_name, set_str)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_hw_snprint(prio_name, print_str)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_mp_handler(prio_name, set_str)<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 @@ -240,11 +264,15 @@ declare_mp_=
snprint(prio_name, print_str)<br>
&gt;<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A declare_def_handler(alias_prefix, set_str=
)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_def_snprint_defstr(alias_prefix, print_s=
tr,<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 DEFAULT_ALIAS_PREFIX)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +declare_ovr_handler(alias_prefix, set_str)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +declare_ovr_snprint(alias_prefix, print_str)<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A declare_hw_handler(alias_prefix, set_str)=
<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_hw_snprint(alias_prefix, print_str)<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_def_handler(prio_args, set_str)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_def_snprint_defstr(prio_args, print_str,=
 DEFAULT_PRIO_ARGS)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +declare_ovr_handler(prio_args, set_str)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +declare_ovr_snprint(prio_args, print_str)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_hw_handler(prio_args, set_str)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_hw_snprint(prio_args, print_str)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_mp_handler(prio_args, set_str)<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 @@ -252,6 +280,8 @@ declare_mp_sn=
print(prio_args, print_str)<br>
&gt;<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A declare_def_handler(features, set_str)<br=
>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_def_snprint_defstr(features, print_str, =
DEFAULT_FEATURES)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +declare_ovr_handler(features, set_str)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +declare_ovr_snprint(features, print_str)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_hw_handler(features, set_str)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_hw_snprint(features, print_str)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_mp_handler(features, set_str)<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 @@ -259,11 +289,15 @@ declare_mp_=
snprint(features, print_str)<br>
&gt;<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A declare_def_handler(checker_name, set_str=
)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_def_snprint_defstr(checker_name, print_s=
tr, DEFAULT_CHECKER)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +declare_ovr_handler(checker_name, set_str)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +declare_ovr_snprint(checker_name, print_str)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_hw_handler(checker_name, set_str)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_hw_snprint(checker_name, print_str)<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_def_handler(minio, set_int)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_def_snprint_defint(minio, print_int, DEF=
AULT_MINIO)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +declare_ovr_handler(minio, set_int)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +declare_ovr_snprint(minio, print_nonzero)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_hw_handler(minio, set_int)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_hw_snprint(minio, print_nonzero)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_mp_handler(minio, set_int)<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 @@ -271,6 +305,8 @@ declare_mp_sn=
print(minio, print_nonzero)<br>
&gt;<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A declare_def_handler(minio_rq, set_int)<br=
>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_def_snprint_defint(minio_rq, print_int, =
DEFAULT_MINIO_RQ)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +declare_ovr_handler(minio_rq, set_int)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +declare_ovr_snprint(minio_rq, print_nonzero)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_hw_handler(minio_rq, set_int)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_hw_snprint(minio_rq, print_nonzero)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_mp_handler(minio_rq, set_int)<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 @@ -296,6 +332,8 @@ declare_def_s=
nprint(checker_timeout, print_nonzero)<br>
&gt;<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A declare_def_handler(flush_on_last_del, se=
t_yes_no_undef)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_def_snprint_defint(flush_on_last_del, pr=
int_yes_no_undef,<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 YNU_NO)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +declare_ovr_handler(flush_on_last_del, set_yes_no=
_undef)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +declare_ovr_snprint(flush_on_last_del, print_yes_=
no_undef)<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A declare_hw_handler(flush_on_last_del, set=
_yes_no_undef)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_hw_snprint(flush_on_last_del, print_yes_=
no_undef)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_mp_handler(flush_on_last_del, set_yes_no=
_undef)<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 @@ -303,6 +341,8 @@ declare_mp_sn=
print(flush_on_last_del,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 print_yes_no_undef)<br>
&gt;<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A declare_def_handler(user_friendly_names, =
set_yes_no_undef)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_def_snprint_defint(user_friendly_names, =
print_yes_no_undef,<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 YNU_NO)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +declare_ovr_handler(user_friendly_names, set_yes_=
no_undef)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +declare_ovr_snprint(user_friendly_names, print_ye=
s_no_undef)<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A declare_hw_handler(user_friendly_names, s=
et_yes_no_undef)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_hw_snprint(user_friendly_names, print_ye=
s_no_undef)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_mp_handler(user_friendly_names, set_yes_=
no_undef)<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 @@ -316,11 +356,15 @@ declare_def=
_snprint(wwids_file, print_str)<br>
&gt;<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A declare_def_handler(retain_hwhandler, set=
_yes_no_undef)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_def_snprint_defint(retain_hwhandler, pri=
nt_yes_no_undef,<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 YNU_NO)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +declare_ovr_handler(retain_hwhandler, set_yes_no_=
undef)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +declare_ovr_snprint(retain_hwhandler, print_yes_n=
o_undef)<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A declare_hw_handler(retain_hwhandler, set_=
yes_no_undef)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_hw_snprint(retain_hwhandler, print_yes_n=
o_undef)<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_def_handler(detect_prio, set_yes_no_unde=
f)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_def_snprint_defint(detect_prio, print_ye=
s_no_undef, YNU_NO)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +declare_ovr_handler(detect_prio, set_yes_no_undef=
)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +declare_ovr_snprint(detect_prio, print_yes_no_und=
ef)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_hw_handler(detect_prio, set_yes_no_undef=
)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_hw_snprint(detect_prio, print_yes_no_und=
ef)<br>
<span class=3D"">&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 @@ -512,6 +556,8 @@ print_fast_io_fail(char * buff=
, int len, void *ptr)<br>
&gt;<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A declare_def_handler(fast_io_fail, set_fas=
t_io_fail)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_def_snprint(fast_io_fail, print_fast_io_=
fail)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +declare_ovr_handler(fast_io_fail, set_fast_io_fai=
l)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +declare_ovr_snprint(fast_io_fail, print_fast_io_f=
ail)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_hw_handler(fast_io_fail, set_fast_io_fai=
l)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_hw_snprint(fast_io_fail, print_fast_io_f=
ail)<br>
<span class=3D"">&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 @@ -548,6 +594,8 @@ print_dev_loss(char * buff, in=
t len, void *ptr)<br>
&gt;<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A declare_def_handler(dev_loss, set_dev_los=
s)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_def_snprint(dev_loss, print_dev_loss)<br=
>
&gt;=C2=A0 =C2=A0 =C2=A0 +declare_ovr_handler(dev_loss, set_dev_loss)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +declare_ovr_snprint(dev_loss, print_dev_loss)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_hw_handler(dev_loss, set_dev_loss)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_hw_snprint(dev_loss, print_dev_loss)<br>
<span class=3D"">&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 @@ -583,6 +631,8 @@ print_pgpolicy(char * buff, in=
t len, void *ptr)<br>
&gt;<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A declare_def_handler(pgpolicy, set_pgpolic=
y)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_def_snprint_defint(pgpolicy, print_pgpol=
icy, DEFAULT_PGPOLICY)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +declare_ovr_handler(pgpolicy, set_pgpolicy)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +declare_ovr_snprint(pgpolicy, print_pgpolicy)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_hw_handler(pgpolicy, set_pgpolicy)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_hw_snprint(pgpolicy, print_pgpolicy)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_mp_handler(pgpolicy, set_pgpolicy)<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 @@ -700,6 +750,8 @@ print_rr_weig=
ht (char * buff, int len, void *ptr)<br>
&gt;<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A declare_def_handler(rr_weight, set_rr_wei=
ght)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_def_snprint_defint(rr_weight, print_rr_w=
eight, RR_WEIGHT_NONE)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +declare_ovr_handler(rr_weight, set_rr_weight)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +declare_ovr_snprint(rr_weight, print_rr_weight)<b=
r>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_hw_handler(rr_weight, set_rr_weight)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_hw_snprint(rr_weight, print_rr_weight)<b=
r>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_mp_handler(rr_weight, set_rr_weight)<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 @@ -748,6 +800,8 @@ print_pgfailb=
ack (char * buff, int len, void *ptr)<br>
&gt;<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A declare_def_handler(pgfailback, set_pgfai=
lback)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_def_snprint_defint(pgfailback, print_pgf=
ailback,<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 DEFAULT_FAILBACK)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +declare_ovr_handler(pgfailback, set_pgfailback)<b=
r>
&gt;=C2=A0 =C2=A0 =C2=A0 +declare_ovr_snprint(pgfailback, print_pgfailback)=
<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A declare_hw_handler(pgfailback, set_pgfail=
back)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_hw_snprint(pgfailback, print_pgfailback)=
<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_mp_handler(pgfailback, set_pgfailback)<b=
r>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 @@ -793,6 +847,8 @@ print_no_path=
_retry(char * buff, int len, void *ptr)<br>
&gt;<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A declare_def_handler(no_path_retry, set_no=
_path_retry)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_def_snprint(no_path_retry, print_no_path=
_retry)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +declare_ovr_handler(no_path_retry, set_no_path_re=
try)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +declare_ovr_snprint(no_path_retry, print_no_path_=
retry)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_hw_handler(no_path_retry, set_no_path_re=
try)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_hw_snprint(no_path_retry, print_no_path_=
retry)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A declare_mp_handler(no_path_retry, set_no_path_re=
try)<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 @@ -1061,6 +1117,25 @@ declare_hw=
_handler(hwhandler, set_str)<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A declare_hw_snprint(hwhandler, print_str)<=
br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A /*<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 + * overrides handlers<br>
&gt;=C2=A0 =C2=A0 =C2=A0 + */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +static int<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +overrides_handler(vector strvec)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +{<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A struct hwentry *=
 overrides;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A overrides =3D alloc_hwe=
();<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A if (!overrides)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A return 1;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A conf-&gt;overrides =3D =
overrides;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A return 0;<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 +}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +/*<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 * multipaths block handlers<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A static int<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 @@ -1236,6 +1311,29 @@ init_keywo=
rds(void)<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 install_key=
word(&quot;detect_prio&quot;, &amp;hw_detect_prio_handler,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &amp;snprint_hw_detect_prio);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 install_sublevel_e=
nd();<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A install_keyword_root(&q=
uot;overrides&quot;, &amp;overrides_handler);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A install_keyword(&quot;p=
ath_grouping_policy&quot;,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &amp;ovr_pgpolicy_handler, &amp;snprint_ovr_pgpoli=
cy);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A install_keyword(&quot;u=
id_attribute&quot;, &amp;ovr_uid_attribute_handler,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &amp;snprint_ovr_uid_attribute);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A install_keyword(&quot;g=
etuid_callout&quot;, &amp;ovr_getuid_handler,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &amp;snprint_ovr_getuid);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A install_keyword(&quot;p=
ath_selector&quot;, &amp;ovr_selector_handler,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &amp;snprint_ovr_selector);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A install_keyword(&quot;p=
ath_checker&quot;, &amp;ovr_checker_name_handler,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &amp;snprint_ovr_checker_name);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A install_keyword(&quot;c=
hecker&quot;, &amp;ovr_checker_name_handler, NULL);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A install_keyword(&quot;a=
lias_prefix&quot;, &amp;ovr_alias_prefix_handler,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &amp;snprint_ovr_alias_prefix);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A install_keyword(&quot;f=
eatures&quot;, &amp;ovr_features_handler,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &amp;snprint_ovr_features);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A install_keyword(&quot;p=
rio&quot;, &amp;ovr_prio_name_handler,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &amp;snprint_ovr_prio_name);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A install_keyword(&quot;p=
rio_args&quot;, &amp;ovr_prio_args_handler,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &amp;snprint_ovr_prio_args);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A install_keyword(&quot;f=
ailback&quot;, &amp;ovr_pgfailback_handler,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &amp;snprint_ovr_pgfailback);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A install_keyword(&quot;r=
r_weight&quot;, &amp;ovr_rr_weight_handler,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &amp;snprint_ovr_rr_weight);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A install_keyword(&quot;n=
o_path_retry&quot;, &amp;ovr_no_path_retry_handler,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &amp;snprint_ovr_no_path_retry);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A install_keyword(&quot;r=
r_min_io&quot;, &amp;ovr_minio_handler,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &amp;snprint_ovr_minio);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A install_keyword(&quot;r=
r_min_io_rq&quot;, &amp;ovr_minio_rq_handler,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &amp;snprint_ovr_minio_rq);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A install_keyword(&quot;f=
lush_on_last_del&quot;,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &amp;ovr_flush_on_last_del_handler, &amp;snprint_o=
vr_flush_on_last_del);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A install_keyword(&quot;f=
ast_io_fail_tmo&quot;,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &amp;ovr_fast_io_fail_handler, &amp;snprint_ovr_fa=
st_io_fail);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A install_keyword(&quot;d=
ev_loss_tmo&quot;, &amp;ovr_dev_loss_handler,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &amp;snprint_ovr_dev_loss);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A install_keyword(&quot;u=
ser_friendly_names&quot;,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &amp;ovr_user_friendly_names_handler, &amp;snprint=
_ovr_user_friendly_names);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A install_keyword(&quot;r=
etain_attached_hw_handler&quot;,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &amp;ovr_retain_hwhandler_handler, &amp;snprint_ov=
r_retain_hwhandler);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A install_keyword(&quot;d=
etect_prio&quot;, &amp;ovr_detect_prio_handler,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &amp;snprint_ovr_detect_prio);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 install_keyword_ro=
ot(&quot;multipaths&quot;, &amp;multipaths_handler);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 install_keyword_mu=
lti(&quot;multipath&quot;, &amp;multipath_handler,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 NULL);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 install_sublevel()=
;<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 diff --git a/libmultipath/print.c=
 b/libmultipath/print.c<br>
&gt;=C2=A0 =C2=A0 =C2=A0 index 383eae4..ade3841 100644<br>
&gt;=C2=A0 =C2=A0 =C2=A0 --- a/libmultipath/print.c<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +++ b/libmultipath/print.c<br>
&gt;=C2=A0 =C2=A0 =C2=A0 @@ -1080,6 +1080,36 @@ snprint_mptable (char * buf=
f, int len, vector<br>
&gt;=C2=A0 =C2=A0 =C2=A0 mptable)<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A }<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A extern int<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 +snprint_overrides (char * buff, =
int len, struct hwentry *overrides)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +{<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A int fwd =3D 0;<b=
r>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A int i;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A struct keyword *rootkw;=
<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A struct keyword *kw;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A rootkw =3D find_keyword=
(NULL, &quot;overrides&quot;);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A if (!rootkw)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A return 0;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A fwd +=3D snprintf(buff =
+ fwd, len - fwd, &quot;overrides {\n&quot;);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A if (fwd &gt; len)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A return len;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A if (!overrides)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A goto out;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A iterate_sub_keywords(ro=
otkw, kw, i) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A fwd +=3D snprint_keyword(buff + fwd, len - fwd,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &quot;\t%k %v\n&quot;,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=
=A0 A=C2=A0 A=C2=A0 A=C2=A0 kw, NULL);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A if (fwd &gt; len)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A return len;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A }<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +out:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A fwd +=3D snprintf(buff =
+ fwd, len - fwd, &quot;}\n&quot;);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A if (fwd &gt; len)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A return len;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A return fwd;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +extern int<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A snprint_defaults (char * buff, int len)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 int fwd =3D 0;<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 diff --git a/libmultipath/print.h=
 b/libmultipath/print.h<br>
&gt;=C2=A0 =C2=A0 =C2=A0 index aef182b..a3c3319 100644<br>
&gt;=C2=A0 =C2=A0 =C2=A0 --- a/libmultipath/print.h<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +++ b/libmultipath/print.h<br>
&gt;=C2=A0 =C2=A0 =C2=A0 @@ -50,6 +50,7 @@ int snprint_status (char *, int,=
 struct vectors *);<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A int snprint_devices (char *, int, struct =
vectors *);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A int snprint_hwtable (char *, int, vector);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A int snprint_mptable (char *, int, vector);<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 +int snprint_overrides (char *, i=
nt, struct hwentry *);<br>
&gt;<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A void print_multipath_topology (struct mul=
tipath * mpp, int verbosity);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A void print_path (struct path * pp, char * style)=
;<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 diff --git a/libmultipath/propsel=
.c b/libmultipath/propsel.c<br>
&gt;=C2=A0 =C2=A0 =C2=A0 index f2ab7d2..440802c 100644<br>
&gt;=C2=A0 =C2=A0 =C2=A0 --- a/libmultipath/propsel.c<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +++ b/libmultipath/propsel.c<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 @@ -48,6 +48,8 @@ do {A=C2=A0 A=C2=A0 A=C2=
=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0=
 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=
=A0 \<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A do_set(var, mp-&gt;mpe, mp-&gt;var, &quot;(LUN s=
etting)&quot;)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A #define mp_set_hwe(var)A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=
=A0 A=C2=A0 A=C2=A0 A<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 \<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A do_set(var, mp-&gt;hwe, mp-&gt;var, &quot;(contr=
oller setting)&quot;)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +#define mp_set_ovr(var)A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=
=A0 A=C2=A0 A=C2=A0 A<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 \<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 +do_set(var, conf-&gt;overrides, =
mp-&gt;var, &quot;(overrides setting)&quot;)<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A #define mp_set_conf(var)A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=
=A0 A=C2=A0 A=C2=A0 A<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 A \<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A do_set(var, conf, mp-&gt;var, &quot;(config file=
 default)&quot;)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A #define mp_set_default(var, value)A=C2=A0 A=C2=
=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0=
 A<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A =
\<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 @@ -59,6 +61,8 @@ do_set(var, mpe=
, pp-&gt;var, &quot;(LUN setting)&quot;)<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A do_set(var, pp-&gt;hwe, pp-&gt;var, &quot=
;(controller setting)&quot;)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A #define pp_set_conf(var)A=C2=A0 A=C2=A0 A=C2=A0 =
A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 A<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 A \<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A do_set(var, conf, pp-&gt;var, &quot;(config file=
 default)&quot;)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +#define pp_set_ovr(var)A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=
=A0 A=C2=A0 A=C2=A0 A<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 \<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 +do_set(var, conf-&gt;overrides, =
pp-&gt;var, &quot;(overrides setting)&quot;)<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A #define pp_set_default(var, value)A=C2=A0=
 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A =
\<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A do_default(pp-&gt;var, value)<br>
<span class=3D"">&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 @@ -130,6 +134,7 @@ select_rr_weight (struct multi=
path * mp)<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 char *origi=
n, buff[13];<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 mp_set_mpe(rr_weig=
ht);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A mp_set_ovr(rr_weight);<=
br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 mp_set_hwe(rr_weig=
ht);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 mp_set_conf(rr_wei=
ght);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 mp_set_default(rr_=
weight, RR_WEIGHT_NONE);<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 @@ -145,6 +150,7 @@ select_pgfail=
back (struct multipath * mp)<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 char *origi=
n, buff[13];<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 mp_set_mpe(pgfailb=
ack);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A mp_set_ovr(pgfailback);=
<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 mp_set_hwe(pgfailb=
ack);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 mp_set_conf(pgfail=
back);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 mp_set_default(pgf=
ailback, DEFAULT_FAILBACK);<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 @@ -165,6 +171,7 @@ select_pgpoli=
cy (struct multipath * mp)<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 A=C2=A0 goto out;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 }<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 mp_set_mpe(pgpolic=
y);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A mp_set_ovr(pgpolicy);<b=
r>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 mp_set_hwe(pgpolic=
y);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 mp_set_conf(pgpoli=
cy);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 mp_set_default(pgp=
olicy, DEFAULT_PGPOLICY);<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 @@ -181,10 +188,12 @@ select_sele=
ctor (struct multipath * mp)<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 char *origi=
n;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 mp_set_mpe(selecto=
r);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A mp_set_ovr(selector);<b=
r>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 mp_set_hwe(selecto=
r);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 mp_set_conf(select=
or);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 -A=C2=A0 A=C2=A0 A=C2=A0 A mp_set_default(selector=
, set_default(DEFAULT_SELECTOR));<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A mp_set_default(selector=
, DEFAULT_SELECTOR);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A out:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A mp-&gt;selector =3D STR=
DUP(mp-&gt;selector);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 condlog(3, &quot;%=
s: path_selector =3D \&quot;%s\&quot; %s&quot;, mp-&gt;alias,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 mp-&gt;selector,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 origin);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 return 0;<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 @@ -195,6 +204,7 @@ select_alias_=
prefix (struct multipath * mp)<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 char *origin;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A mp_set_ovr(alias_prefix=
);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 mp_set_hwe(alias_p=
refix);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 mp_set_conf(alias_=
prefix);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 mp_set_default(ali=
as_prefix, DEFAULT_ALIAS_PREFIX);<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 @@ -206,19 +216,30 @@ out:<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A static int<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A want_user_friendly_names(struct multipath * mp)<=
br>
&gt;=C2=A0 =C2=A0 =C2=A0 A {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 -A=C2=A0 A=C2=A0 A=C2=A0 A if (mp-&gt;mpe &amp;&am=
p;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 -A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A mp-&gt;=
mpe-&gt;user_friendly_names !=3D<br>
&gt;=C2=A0 =C2=A0 =C2=A0 USER_FRIENDLY_NAMES_UNDEF)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 -A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A return (mp-&gt;mpe-&gt;user_friendly_names =3D=3D<br>
&gt;=C2=A0 =C2=A0 =C2=A0 USER_FRIENDLY_NAMES_ON);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 -A=C2=A0 A=C2=A0 A=C2=A0 A if (mp-&gt;hwe &amp;&am=
p;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 -A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A mp-&gt;=
hwe-&gt;user_friendly_names !=3D<br>
&gt;=C2=A0 =C2=A0 =C2=A0 USER_FRIENDLY_NAMES_UNDEF)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 -A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A return (mp-&gt;hwe-&gt;user_friendly_names =3D=3D<br>
&gt;=C2=A0 =C2=A0 =C2=A0 USER_FRIENDLY_NAMES_ON);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 -A=C2=A0 A=C2=A0 A=C2=A0 A return (conf-&gt;user_f=
riendly_namesA=C2=A0 =3D=3D<br>
&gt;=C2=A0 =C2=A0 =C2=A0 USER_FRIENDLY_NAMES_ON);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A char *origin;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A int user_friendly_names=
;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A do_set(user_friendly_na=
mes, mp-&gt;mpe, user_friendly_names,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 &quot;(LUN setting)&quot;);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A do_set(user_friendly_na=
mes, conf-&gt;overrides,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 user_friendly_names,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 &quot;(overrides setting)&quot;);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A do_set(user_friendly_na=
mes, mp-&gt;hwe, user_friendly_names,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 &quot;(controller setting)&quot;);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A do_set(user_friendly_na=
mes, conf, user_friendly_names,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 &quot;(config file setting)&quot;);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A do_default(user_friendl=
y_names, USER_FRIENDLY_NAMES_OFF);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +out:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A condlog(3, &quot;%s: us=
er_friendly_names =3D %s %s&quot;, mp-&gt;wwid,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A (user_friendly_names =3D=3D USER_FRIENDLY_NAMES_ON)?<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &quot;yes&quot; : &quot;no&quot;,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A origin);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A return (user_friendly_n=
ames =3D=3D USER_FRIENDLY_NAMES_ON);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A }<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A extern int<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A select_alias (struct multipath * mp)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 -A=C2=A0 A=C2=A0 A=C2=A0 A char *origin;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A char *origin =3D NULL;<=
br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 if (mp-&gt;mpe &am=
p;&amp; mp-&gt;mpe-&gt;alias) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 mp-&gt;alias =3D STRDUP(mp-&gt;mpe-&gt;alias);<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 @@ -261,6 +282,7 @@ select_featur=
es (struct multipath * mp)<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 char *origi=
n;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 mp_set_mpe(feature=
s);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A mp_set_ovr(features);<b=
r>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 mp_set_hwe(feature=
s);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 mp_set_conf(featur=
es);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 mp_set_default(fea=
tures, DEFAULT_FEATURES);<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 @@ -287,8 +309,9 @@ select_hwhand=
ler (struct multipath * mp)<br>
&gt;<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 mp_set_hwe(=
hwhandler);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 mp_set_conf(hwhand=
ler);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 -A=C2=A0 A=C2=A0 A=C2=A0 A mp_set_default(hwhandle=
r, set_default(DEFAULT_HWHANDLER));<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A mp_set_default(hwhandle=
r, DEFAULT_HWHANDLER);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A out:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A mp-&gt;hwhandler =3D ST=
RDUP(mp-&gt;hwhandler);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 condlog(3, &quot;%=
s: hardware_handler =3D \&quot;%s\&quot; %s&quot;, mp-&gt;alias,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 mp-&gt;hwhandler,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 origin);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 return 0;<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 @@ -300,6 +323,7 @@ select_checke=
r(struct path *pp)<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 char *origi=
n, *checker_name;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 struct checker * c=
 =3D &amp;pp-&gt;checker;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A do_set(checker_name, co=
nf-&gt;overrides, checker_name,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &quot;(overrides setting)&quot;);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 do_set(checker_nam=
e, pp-&gt;hwe, checker_name, &quot;(controller<br>
&gt;=C2=A0 =C2=A0 =C2=A0 setting)&quot;);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 do_set(checker_nam=
e, conf, checker_name, &quot;(config file<br>
&gt;=C2=A0 =C2=A0 =C2=A0 setting)&quot;);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 do_default(checker=
_name, DEFAULT_CHECKER);<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 @@ -327,6 +351,8 @@ select_getuid=
 (struct path * pp)<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 char *origin;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A pp_set_ovr(uid_attribut=
e);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A pp_set_ovr(getuid);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 pp_set_hwe(uid_att=
ribute);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 pp_set_hwe(getuid)=
;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 pp_set_conf(uid_at=
tribute);<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 @@ -383,6 +409,7 @@ select_prio (=
struct path * pp)<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 }<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 mpe =3D find_mpe(p=
p-&gt;wwid);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 set_prio(mpe, &quo=
t;(LUN setting)&quot;);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A set_prio(conf-&gt;overr=
ides, &quot;(overrides setting)&quot;);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 set_prio(pp-&gt;hw=
e, &quot;controller setting)&quot;);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 set_prio(conf, &qu=
ot;(config file default)&quot;);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 prio_get(p, DEFAUL=
T_PRIO, DEFAULT_PRIO_ARGS);<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 @@ -405,6 +432,7 @@ select_no_pat=
h_retry(struct multipath *mp)<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 A=C2=A0 return 0;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 }<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 mp_set_mpe(no_path=
_retry);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A mp_set_ovr(no_path_retr=
y);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 mp_set_hwe(no_path=
_retry);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 mp_set_conf(no_pat=
h_retry);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A out:<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 @@ -427,6 +455,7 @@ select_minio_=
rq (struct multipath * mp)<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 char *origi=
n;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 do_set(minio_rq, m=
p-&gt;mpe, mp-&gt;minio, &quot;(LUN setting)&quot;);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A do_set(minio_rq, conf-&=
gt;overrides, mp-&gt;minio, &quot;(overrides<br>
&gt;=C2=A0 =C2=A0 =C2=A0 setting)&quot;);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 do_set(minio_rq, m=
p-&gt;hwe, mp-&gt;minio, &quot;(controller<br>
&gt;=C2=A0 =C2=A0 =C2=A0 setting)&quot;);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 do_set(minio_rq, c=
onf, mp-&gt;minio, &quot;(config file setting)&quot;);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 do_default(mp-&gt;=
minio, DEFAULT_MINIO_RQ);<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 @@ -441,6 +470,7 @@ select_minio_=
bio (struct multipath * mp)<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 char *origi=
n;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 mp_set_mpe(minio);=
<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A mp_set_ovr(minio);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 mp_set_hwe(minio);=
<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 mp_set_conf(minio)=
;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 mp_set_default(min=
io, DEFAULT_MINIO);<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 @@ -465,6 +495,7 @@ select_fast_i=
o_fail(struct multipath *mp)<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 char *origin, buff=
[12];<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A mp_set_ovr(fast_io_fail=
);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 mp_set_hwe(fast_io=
_fail);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 mp_set_conf(fast_i=
o_fail);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 mp_set_default(fas=
t_io_fail, DEFAULT_FAST_IO_FAIL);<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 @@ -479,6 +510,7 @@ select_dev_lo=
ss(struct multipath *mp)<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 char *origin, buff=
[12];<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A mp_set_ovr(dev_loss);<b=
r>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 mp_set_hwe(dev_los=
s);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 mp_set_conf(dev_lo=
ss);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 mp-&gt;dev_loss =
=3D 0;<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 @@ -497,6 +529,7 @@ select_flush_=
on_last_del(struct multipath *mp)<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 if (mp-&gt;=
flush_on_last_del =3D=3D FLUSH_IN_PROGRESS)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 return 0;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 mp_set_mpe(flush_o=
n_last_del);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A mp_set_ovr(flush_on_las=
t_del);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 mp_set_hwe(flush_o=
n_last_del);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 mp_set_conf(flush_=
on_last_del);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 mp_set_default(flu=
sh_on_last_del, FLUSH_DISABLED);<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 @@ -532,6 +565,7 @@ select_retain=
_hwhandler (struct multipath * mp)<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 A=C2=A0 origin =3D &quot;(requires kernel version &gt;=3D 1.=
5.0)&quot;;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 goto out;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 }<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A mp_set_ovr(retain_hwhan=
dler);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 mp_set_hwe(retain_=
hwhandler);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 mp_set_conf(retain=
_hwhandler);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 mp_set_default(ret=
ain_hwhandler, DEFAULT_RETAIN_HWHANDLER);<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 @@ -547,6 +581,7 @@ select_detect=
_prio (struct path * pp)<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 char *origin;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A pp_set_ovr(detect_prio)=
;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 pp_set_hwe(detect_=
prio);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 pp_set_conf(detect=
_prio);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 pp_set_default(det=
ect_prio, DEFAULT_DETECT_PRIO);<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 diff --git a/libmultipath/structs=
.c b/libmultipath/structs.c<br>
&gt;=C2=A0 =C2=A0 =C2=A0 index 30d247d..0538327 100644<br>
&gt;=C2=A0 =C2=A0 =C2=A0 --- a/libmultipath/structs.c<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +++ b/libmultipath/structs.c<br>
&gt;=C2=A0 =C2=A0 =C2=A0 @@ -206,10 +206,7 @@ free_multipath_attributes (st=
ruct multipath * mpp)<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 if (!mpp)<b=
r>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 return;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 -A=C2=A0 A=C2=A0 A=C2=A0 A if (mpp-&gt;selector &a=
mp;&amp;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 -A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A mpp-&gt=
;selector !=3D conf-&gt;selector &amp;&amp;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 -A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A (!mpp-&=
gt;mpe || (mpp-&gt;mpe &amp;&amp; mpp-&gt;selector !=3D<br>
&gt;=C2=A0 =C2=A0 =C2=A0 mpp-&gt;mpe-&gt;selector)) &amp;&amp;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 -A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A (!mpp-&=
gt;hwe || (mpp-&gt;hwe &amp;&amp; mpp-&gt;selector !=3D<br>
&gt;=C2=A0 =C2=A0 =C2=A0 mpp-&gt;hwe-&gt;selector))) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A if (mpp-&gt;selector) {=
<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 FREE(mpp-&gt;selector);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 mpp-&gt;selector =3D NULL;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 }<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 @@ -219,9 +216,7 @@ free_multipat=
h_attributes (struct multipath * mpp)<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 A=C2=A0 mpp-&gt;features =3D NULL;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 }<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 -A=C2=A0 A=C2=A0 A=C2=A0 A if (mpp-&gt;hwhandler &=
amp;&amp;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 -A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A mpp-&gt=
;hwhandler !=3D conf-&gt;hwhandler &amp;&amp;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 -A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A (!mpp-&=
gt;hwe || (mpp-&gt;hwe &amp;&amp; mpp-&gt;hwhandler !=3D<br>
&gt;=C2=A0 =C2=A0 =C2=A0 mpp-&gt;hwe-&gt;hwhandler))) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A if (mpp-&gt;hwhandler) =
{<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 FREE(mpp-&gt;hwhandler);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 mpp-&gt;hwhandler =3D NULL;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 }<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 diff --git a/multipath.conf.annot=
ated b/multipath.conf.annotated<br>
&gt;=C2=A0 =C2=A0 =C2=A0 index 0af1d4c..71afc0a 100644<br>
&gt;=C2=A0 =C2=A0 =C2=A0 --- a/multipath.conf.annotated<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +++ b/multipath.conf.annotated<br>
&gt;=C2=A0 =C2=A0 =C2=A0 @@ -485,7 +485,8 @@<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A ## scope : multipath &amp; multipathd<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A ## descA=C2=A0 : list of per storage controller =
settings<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A ##A=C2=A0 A=C2=A0 A=C2=A0 A overrides default se=
ttings (device_maps block)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 -##A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A overriden by =
per multipath settings (multipaths block)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +##A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 overriden by pe=
r multipath settings (multipaths block)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +##A=C2=A0 A=C2=A0 A=C2=A0 A and the overrides set=
tings (overrides block)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A ##<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A #devices {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A #A=C2=A0 A=C2=A0 A=C2=A0 #<br>
&gt;=C2=A0 =C2=A0 =C2=A0 @@ -651,3 +652,18 @@<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A #A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0=
 A=C2=A0 rr_weightA=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
 priorities<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A #A=C2=A0 A=C2=A0 A=C2=A0 }<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A #}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +#<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +##<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +## nameA=C2=A0 : devices<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 +## scope : multipath &amp; multi=
pathd<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 +## descA=C2=A0 : list of settings to overr=
ide all hadware settings for all<br>
&gt;=C2=A0 =C2=A0 =C2=A0 devices<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +##A=C2=A0 A=C2=A0 A=C2=A0 A overrides default set=
tings (device_maps block)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +##A=C2=A0 A=C2=A0 A=C2=A0 A and per device type s=
ettings (devices block)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +##A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 overriden by pe=
r multipath settings (multipaths block)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +##<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +#A=C2=A0 A=C2=A0 A=C2=A0 attributes and values ar=
e identical to the device block<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +#<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +#overrides {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +#A=C2=A0 A=C2=A0 A=C2=A0 dev_loss_tmoA=C2=A0 A=C2=
=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 60<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +#A=C2=A0 A=C2=A0 A=C2=A0 no_path_retryA=C2=A0 A=
=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A fail<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 +#}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 diff --git a/multipath.conf.defaults b/multipath.c=
onf.defaults<br>
&gt;=C2=A0 =C2=A0 =C2=A0 index 654be97..1c65e02 100644<br>
&gt;=C2=A0 =C2=A0 =C2=A0 --- a/multipath.conf.defaults<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +++ b/multipath.conf.defaults<br>
&gt;=C2=A0 =C2=A0 =C2=A0 @@ -912,3 +912,5 @@<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A #}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A #multipaths {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A #}<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 +#overrides {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +#}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 diff --git a/multipath.conf.synthetic b/multipath.=
conf.synthetic<br>
&gt;=C2=A0 =C2=A0 =C2=A0 index bda1b75..f7b9b8a 100644<br>
&gt;=C2=A0 =C2=A0 =C2=A0 --- a/multipath.conf.synthetic<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +++ b/multipath.conf.synthetic<br>
&gt;=C2=A0 =C2=A0 =C2=A0 @@ -72,3 +72,6 @@<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A #A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 =
A=C2=A0 A=C2=A0 path_grouping_policyA=C2=A0 A=C2=A0 multibus<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A #A=C2=A0 A=C2=A0 A=C2=A0 }<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A #}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +#overrides {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +#A=C2=A0 A=C2=A0 A=C2=A0 no_path_retryA=C2=A0 A=
=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A fail<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 +#}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 diff --git a/multipath/main.c b/multipath/main.c<b=
r>
&gt;=C2=A0 =C2=A0 =C2=A0 index fd6262f..ea453b4 100644<br>
&gt;=C2=A0 =C2=A0 =C2=A0 --- a/multipath/main.c<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +++ b/multipath/main.c<br>
&gt;=C2=A0 =C2=A0 =C2=A0 @@ -405,6 +405,12 @@ dump_config (void)<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 reply =3D REALLOC(re=
ply, maxlen *=3D 2);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 continue;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 }<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A c +=3D snprint_overrides(c, reply + maxlen - c,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 conf-&gt;overrides);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A again =3D ((c - reply) =3D=3D maxlen);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A if (again) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A reply =3D REALLOC(reply, maxlen *=
=3D 2);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A continue;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A }<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 c +=3D snprint_mptable(c, reply + maxlen - c,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 conf-&gt;mptable);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 again =3D ((c - reply) =3D=3D maxlen);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 if (again)<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 diff --git a/multipath/multipath.=
conf.5 b/multipath/multipath.conf.5<br>
&gt;=C2=A0 =C2=A0 =C2=A0 index cadb34d..b823990 100644<br>
&gt;=C2=A0 =C2=A0 =C2=A0 --- a/multipath/multipath.conf.5<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +++ b/multipath/multipath.conf.5<br>
&gt;=C2=A0 =C2=A0 =C2=A0 @@ -61,6 +61,10 @@ the udev attribute given by the=
<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A .TP<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A .B devices<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A This section defines the device-specific setting=
s.<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 +.TP<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +.B overrides<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +This section defines values for attributes that s=
hould override the<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +device-specific settings for all devices.<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A .RE<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A .LP<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A .SH &quot;defaults section&quot;<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 @@ -629,6 +633,59 @@ section:<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A .RE<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A .PD<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A .LP<br>
<div><div class=3D"h5">&gt;=C2=A0 =C2=A0 =C2=A0 +.SH &quot;overrides sectio=
n&quot;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +The overrides section recognizes the following op=
tional attributes; if<br>
&gt;=C2=A0 =C2=A0 =C2=A0 not set<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +the values are taken from the<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +.I devices<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +or<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +.I defaults<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +sections:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +.sp 1<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +.PD .1v<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +.RS<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +.TP 18<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +.B path_grouping_policy<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +.TP<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +.B uid_attribute<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +.TP<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +.B getuid_callout<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +.TP<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +.B path_selector<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +.TP<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +.B path_checker<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +.TP<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +.B alias_prefix<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +.TP<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +.B features<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +.TP<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +.B prio<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +.TP<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +.B prio_args<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +.TP<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +.B failback<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +.TP<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +.B rr_weight<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +.TP<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +.B no_path_retry<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +.TP<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +.B rr_min_io<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +.TP<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +.B rr_min_io_rq<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +.TP<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +.B flush_on_last_del<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +.TP<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +.B fast_io_fail_tmo<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +.TP<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +.B dev_loss_tmo<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +.TP<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +.B user_friendly_names<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +.TP<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +.B retain_attached_hw_handler<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +.TP<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +.B detect_prio<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +.RE<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +.PD<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +.LP<br>
</div></div>&gt;=C2=A0 =C2=A0 =C2=A0 A .SH &quot;KNOWN ISSUES&quot;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A The usage of<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A .B queue_if_no_path<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 diff --git a/multipathd/cli_handl=
ers.c b/multipathd/cli_handlers.c<br>
&gt;=C2=A0 =C2=A0 =C2=A0 index b086340..0ce1408 100644<br>
&gt;=C2=A0 =C2=A0 =C2=A0 --- a/multipathd/cli_handlers.c<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +++ b/multipathd/cli_handlers.c<br>
&gt;=C2=A0 =C2=A0 =C2=A0 @@ -190,6 +190,16 @@ show_config (char ** r, int *=
 len)<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 maxlen *=3D 2;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 continue;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 }<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A c +=3D snprint_overrides(c, reply + maxlen - c,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 conf-&gt;overrides);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A again =3D ((c - reply) =3D=3D maxlen);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A if (again) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A reply =3D REALLOC(reply, maxlen * =
2);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A if (!reply)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A re=
turn 1;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A memset(reply + maxlen, 0, maxlen);=
<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A maxlen *=3D 2;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A continue;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 +A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A }<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 c +=3D snprint_mptable(c, reply + maxlen - c,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 conf-&gt;mptable);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 again =3D ((c - reply) =3D=3D maxlen);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=C2=A0 A=
=C2=A0 A=C2=A0 REALLOC_REPLY(reply, again, maxlen);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 --<br>
&gt;=C2=A0 =C2=A0 =C2=A0 1.8.3.1<br>
</blockquote></div><br></div>

--001a11c373667c5c2a050c7a56e3--


--===============2208771626168058446==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2208771626168058446==--
