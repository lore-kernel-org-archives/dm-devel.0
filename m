From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 2/3] libmultipath: cleanup propsel.c with
 macros for common actions
Date: Thu, 8 Jan 2015 23:44:09 +0100
Message-ID: <CABr-GnfhAcbmVWsQbNm82DRVHm16-oPQOY+HxfDGOmvseTGvRw@mail.gmail.com>
References: <1412211359-24766-1-git-send-email-bmarzins@redhat.com>
	<1412211359-24766-3-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7368921032232240824=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1412211359-24766-3-git-send-email-bmarzins@redhat.com>
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
Cc: Nir Soffer <nsoffer@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============7368921032232240824==
Content-Type: multipart/alternative; boundary=047d7b34318a3c8731050c2bc7b9

--047d7b34318a3c8731050c2bc7b9
Content-Type: text/plain; charset=UTF-8

Applied,

Valuable maintainability enhancement, again, thanks.

On Thu, Oct 2, 2014 at 2:55 AM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> Many of the functions in propsel.c are nearly identical, except for the
> names of the variables that they are dealing with.  Also, some variables
> that the user configured with a keyword were just printing the variable
> as an integer, which isn't very helpful without looking at the code to
> see what the number stands for. They were using the variable names
> instead of the config file names as well.  This patch tries to simplify
> the file by using macros for the repetitive work of the functions, and
> standardizes and clarifies the debug messages by using the print functions
> from dict.c
>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/dict.c       |  14 +-
>  libmultipath/dict.h       |   7 +
>  libmultipath/pgpolicies.c |   2 +-
>  libmultipath/propsel.c    | 712
> +++++++++++++++++-----------------------------
>  4 files changed, 282 insertions(+), 453 deletions(-)
>
> diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> index e88c122..98cbe48 100644
> --- a/libmultipath/dict.c
> +++ b/libmultipath/dict.c
> @@ -496,7 +496,7 @@ set_fast_io_fail(vector strvec, void *ptr)
>         return 0;
>  }
>
> -static int
> +int
>  print_fast_io_fail(char * buff, int len, void *ptr)
>  {
>         int *int_ptr = (int *)ptr;
> @@ -534,7 +534,7 @@ set_dev_loss(vector strvec, void *ptr)
>         return 0;
>  }
>
> -static int
> +int
>  print_dev_loss(char * buff, int len, void *ptr)
>  {
>         unsigned int *uint_ptr = (unsigned int *)ptr;
> @@ -567,7 +567,7 @@ set_pgpolicy(vector strvec, void *ptr)
>         return 0;
>  }
>
> -static int
> +int
>  print_pgpolicy(char * buff, int len, void *ptr)
>  {
>         char str[POLICY_NAME_SIZE];
> @@ -683,7 +683,7 @@ set_rr_weight(vector strvec, void *ptr)
>         return 0;
>  }
>
> -static int
> +int
>  print_rr_weight (char * buff, int len, void *ptr)
>  {
>         int *int_ptr = (int *)ptr;
> @@ -727,7 +727,7 @@ set_pgfailback(vector strvec, void *ptr)
>         return 0;
>  }
>
> -static int
> +int
>  print_pgfailback (char * buff, int len, void *ptr)
>  {
>         int *int_ptr = (int *)ptr;
> @@ -774,7 +774,7 @@ set_no_path_retry(vector strvec, void *ptr)
>         return 0;
>  }
>
> -static int
> +int
>  print_no_path_retry(char * buff, int len, void *ptr)
>  {
>         int *int_ptr = (int *)ptr;
> @@ -873,7 +873,7 @@ set_reservation_key(vector strvec, void *ptr)
>         return 0;
>  }
>
> -static int
> +int
>  print_reservation_key(char * buff, int len, void * ptr)
>  {
>         unsigned char **uchar_ptr = (unsigned char **)ptr;
> diff --git a/libmultipath/dict.h b/libmultipath/dict.h
> index 688eab7..84b6180 100644
> --- a/libmultipath/dict.h
> +++ b/libmultipath/dict.h
> @@ -7,5 +7,12 @@
>
>  void init_keywords(void);
>  int get_sys_max_fds(int *);
> +int print_rr_weight (char * buff, int len, void *ptr);
> +int print_pgfailback (char * buff, int len, void *ptr);
> +int print_pgpolicy(char * buff, int len, void *ptr);
> +int print_no_path_retry(char * buff, int len, void *ptr);
> +int print_fast_io_fail(char * buff, int len, void *ptr);
> +int print_dev_loss(char * buff, int len, void *ptr);
> +int print_reservation_key(char * buff, int len, void * ptr);
>
>  #endif /* _DICT_H */
> diff --git a/libmultipath/pgpolicies.c b/libmultipath/pgpolicies.c
> index f76ad60..2981d51 100644
> --- a/libmultipath/pgpolicies.c
> +++ b/libmultipath/pgpolicies.c
> @@ -27,7 +27,7 @@ get_pgpolicy_id (char * str)
>         if (0 == strncmp(str, "group_by_node_name", 18))
>                 return GROUP_BY_NODE_NAME;
>
> -       return -1;
> +       return IOPOLICY_UNDEF;
>  }
>
>  extern int
> diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> index 7a966bb..f2ab7d2 100644
> --- a/libmultipath/propsel.c
> +++ b/libmultipath/propsel.c
> @@ -17,6 +17,7 @@
>  #include "devmapper.h"
>  #include "prio.h"
>  #include "discovery.h"
> +#include "dict.h"
>  #include "prioritizers/alua_rtpg.h"
>  #include <inttypes.h>
>
> @@ -29,57 +30,92 @@ pgpolicyfn *pgpolicies[] = {
>         group_by_node_name
>  };
>
> +#define do_set(var, src, dest, msg)                                    \
> +do {                                                                   \
> +       if (src && src->var) {                                          \
> +               dest = src->var;                                        \
> +               origin = msg;                                           \
> +               goto out;                                               \
> +       }                                                               \
> +} while(0)
> +#define do_default(dest, value)
>       \
> +do {                                                                   \
> +       dest = value;                                                   \
> +       origin = "(internal default)";                                  \
> +} while(0)
> +
> +#define mp_set_mpe(var)
>       \
> +do_set(var, mp->mpe, mp->var, "(LUN setting)")
> +#define mp_set_hwe(var)
>       \
> +do_set(var, mp->hwe, mp->var, "(controller setting)")
> +#define mp_set_conf(var)                                               \
> +do_set(var, conf, mp->var, "(config file default)")
> +#define mp_set_default(var, value)                                     \
> +do_default(mp->var, value)
> +
> +#define pp_set_mpe(var)
>       \
> +do_set(var, mpe, pp->var, "(LUN setting)")
> +#define pp_set_hwe(var)
>       \
> +do_set(var, pp->hwe, pp->var, "(controller setting)")
> +#define pp_set_conf(var)                                               \
> +do_set(var, conf, pp->var, "(config file default)")
> +#define pp_set_default(var, value)                                     \
> +do_default(pp->var, value)
> +
> +#define do_attr_set(var, src, shift, msg)                              \
> +do {                                                                   \
> +       if (src && (src->attribute_flags & (1 << shift))) {             \
> +               mp->attribute_flags |= (1 << shift);                    \
> +               mp->var = src->var;                                     \
> +               origin = msg;                                           \
> +               goto out;                                               \
> +       }                                                               \
> +} while(0)
> +
> +#define set_attr_mpe(var, shift)                                       \
> +do_attr_set(var, mp->mpe, shift, "(LUN setting)")
> +#define set_attr_conf(var, shift)                                      \
> +do_attr_set(var, conf, shift, "(config file default)")
> +
>  extern int
>  select_mode (struct multipath *mp)
>  {
> -       if (mp->mpe && (mp->mpe->attribute_flags & (1 << ATTR_MODE))) {
> -               mp->attribute_flags |= (1 << ATTR_MODE);
> -               mp->mode = mp->mpe->mode;
> -               condlog(3, "mode = 0%o (LUN setting)", mp->mode);
> -       }
> -       else if (conf->attribute_flags & (1 << ATTR_MODE)) {
> -               mp->attribute_flags |= (1 << ATTR_MODE);
> -               mp->mode = conf->mode;
> -               condlog(3, "mode = 0%o (config file default)", mp->mode);
> -       }
> -       else
> -               mp->attribute_flags &= ~(1 << ATTR_MODE);
> +       char *origin;
> +
> +       set_attr_mpe(mode, ATTR_MODE);
> +       set_attr_conf(mode, ATTR_MODE);
> +       mp->attribute_flags &= ~(1 << ATTR_MODE);
> +       return 0;
> +out:
> +       condlog(3, "%s: mode = 0%o %s", mp->alias, mp->mode, origin);
>         return 0;
>  }
>
>  extern int
>  select_uid (struct multipath *mp)
>  {
> -       if (mp->mpe && (mp->mpe->attribute_flags & (1 << ATTR_UID))) {
> -               mp->attribute_flags |= (1 << ATTR_UID);
> -               mp->uid = mp->mpe->uid;
> -               condlog(3, "uid = %u (LUN setting)", mp->uid);
> -       }
> -       else if (conf->attribute_flags & (1 << ATTR_UID)) {
> -               mp->attribute_flags |= (1 << ATTR_UID);
> -               mp->uid = conf->uid;
> -               condlog(3, "uid = %u (config file default)", mp->uid);
> -       }
> -       else
> -               mp->attribute_flags &= ~(1 << ATTR_UID);
> +       char *origin;
> +
> +       set_attr_mpe(uid, ATTR_UID);
> +       set_attr_conf(uid, ATTR_UID);
> +       mp->attribute_flags &= ~(1 << ATTR_UID);
> +       return 0;
> +out:
> +       condlog(3, "%s: uid = 0%o %s", mp->alias, mp->uid, origin);
>         return 0;
>  }
>
>  extern int
>  select_gid (struct multipath *mp)
>  {
> -       if (mp->mpe && (mp->mpe->attribute_flags & (1 << ATTR_GID))) {
> -               mp->attribute_flags |= (1 << ATTR_GID);
> -               mp->gid = mp->mpe->gid;
> -               condlog(3, "gid = %u (LUN setting)", mp->gid);
> -       }
> -       else if (conf->attribute_flags & (1 << ATTR_GID)) {
> -               mp->attribute_flags |= (1 << ATTR_GID);
> -               mp->gid = conf->gid;
> -               condlog(3, "gid = %u (config file default)", mp->gid);
> -       }
> -       else
> -               mp->attribute_flags &= ~(1 << ATTR_GID);
> +       char *origin;
> +
> +       set_attr_mpe(gid, ATTR_GID);
> +       set_attr_conf(gid, ATTR_GID);
> +       mp->attribute_flags &= ~(1 << ATTR_GID);
> +       return 0;
> +out:
> +       condlog(3, "%s: gid = 0%o %s", mp->alias, mp->gid, origin);
>         return 0;
>  }
>
> @@ -91,151 +127,80 @@ select_gid (struct multipath *mp)
>  extern int
>  select_rr_weight (struct multipath * mp)
>  {
> -       if (mp->mpe && mp->mpe->rr_weight) {
> -               mp->rr_weight = mp->mpe->rr_weight;
> -               condlog(3, "%s: rr_weight = %i (LUN setting)",
> -                       mp->alias, mp->rr_weight);
> -               return 0;
> -       }
> -       if (mp->hwe && mp->hwe->rr_weight) {
> -               mp->rr_weight = mp->hwe->rr_weight;
> -               condlog(3, "%s: rr_weight = %i (controller setting)",
> -                       mp->alias, mp->rr_weight);
> -               return 0;
> -       }
> -       if (conf->rr_weight) {
> -               mp->rr_weight = conf->rr_weight;
> -               condlog(3, "%s: rr_weight = %i (config file default)",
> -                       mp->alias, mp->rr_weight);
> -               return 0;
> -       }
> -       mp->rr_weight = RR_WEIGHT_NONE;
> -       condlog(3, "%s: rr_weight = %i (internal default)",
> -               mp->alias, mp->rr_weight);
> +       char *origin, buff[13];
> +
> +       mp_set_mpe(rr_weight);
> +       mp_set_hwe(rr_weight);
> +       mp_set_conf(rr_weight);
> +       mp_set_default(rr_weight, RR_WEIGHT_NONE);
> +out:
> +       print_rr_weight(buff, 13, &mp->rr_weight);
> +       condlog(3, "%s: rr_weight = %s %s", mp->alias, buff, origin);
>         return 0;
>  }
>
>  extern int
>  select_pgfailback (struct multipath * mp)
>  {
> -       if (mp->mpe && mp->mpe->pgfailback != FAILBACK_UNDEF) {
> -               mp->pgfailback = mp->mpe->pgfailback;
> -               condlog(3, "%s: pgfailback = %i (LUN setting)",
> -                       mp->alias, mp->pgfailback);
> -               return 0;
> -       }
> -       if (mp->hwe && mp->hwe->pgfailback != FAILBACK_UNDEF) {
> -               mp->pgfailback = mp->hwe->pgfailback;
> -               condlog(3, "%s: pgfailback = %i (controller setting)",
> -                       mp->alias, mp->pgfailback);
> -               return 0;
> -       }
> -       if (conf->pgfailback != FAILBACK_UNDEF) {
> -               mp->pgfailback = conf->pgfailback;
> -               condlog(3, "%s: pgfailback = %i (config file default)",
> -                       mp->alias, mp->pgfailback);
> -               return 0;
> -       }
> -       mp->pgfailback = DEFAULT_FAILBACK;
> -       condlog(3, "%s: pgfailover = %i (internal default)",
> -               mp->alias, mp->pgfailback);
> +       char *origin, buff[13];
> +
> +       mp_set_mpe(pgfailback);
> +       mp_set_hwe(pgfailback);
> +       mp_set_conf(pgfailback);
> +       mp_set_default(pgfailback, DEFAULT_FAILBACK);
> +out:
> +       print_pgfailback(buff, 13, &mp->pgfailback);
> +       condlog(3, "%s: failback = %s %s", mp->alias, buff, origin);
>         return 0;
>  }
>
>  extern int
>  select_pgpolicy (struct multipath * mp)
>  {
> -       char pgpolicy_name[POLICY_NAME_SIZE];
> +       char *origin, buff[POLICY_NAME_SIZE];
>
>         if (conf->pgpolicy_flag > 0) {
>                 mp->pgpolicy = conf->pgpolicy_flag;
> -               mp->pgpolicyfn = pgpolicies[mp->pgpolicy];
> -               get_pgpolicy_name(pgpolicy_name, POLICY_NAME_SIZE,
> -                                 mp->pgpolicy);
> -               condlog(3, "%s: pgpolicy = %s (cmd line flag)",
> -                       mp->alias, pgpolicy_name);
> -               return 0;
> -       }
> -       if (mp->mpe && mp->mpe->pgpolicy > 0) {
> -               mp->pgpolicy = mp->mpe->pgpolicy;
> -               mp->pgpolicyfn = pgpolicies[mp->pgpolicy];
> -               get_pgpolicy_name(pgpolicy_name, POLICY_NAME_SIZE,
> -                                 mp->pgpolicy);
> -               condlog(3, "%s: pgpolicy = %s (LUN setting)",
> -                       mp->alias, pgpolicy_name);
> -               return 0;
> -       }
> -       if (mp->hwe && mp->hwe->pgpolicy > 0) {
> -               mp->pgpolicy = mp->hwe->pgpolicy;
> -               mp->pgpolicyfn = pgpolicies[mp->pgpolicy];
> -               get_pgpolicy_name(pgpolicy_name, POLICY_NAME_SIZE,
> -                                 mp->pgpolicy);
> -               condlog(3, "%s: pgpolicy = %s (controller setting)",
> -                       mp->alias, pgpolicy_name);
> -               return 0;
> -       }
> -       if (conf->pgpolicy > 0) {
> -               mp->pgpolicy = conf->pgpolicy;
> -               mp->pgpolicyfn = pgpolicies[mp->pgpolicy];
> -               get_pgpolicy_name(pgpolicy_name, POLICY_NAME_SIZE,
> -                                 mp->pgpolicy);
> -               condlog(3, "%s: pgpolicy = %s (config file default)",
> -                       mp->alias, pgpolicy_name);
> -               return 0;
> +               origin = "(cmd line flag)";
> +               goto out;
>         }
> -       mp->pgpolicy = DEFAULT_PGPOLICY;
> +       mp_set_mpe(pgpolicy);
> +       mp_set_hwe(pgpolicy);
> +       mp_set_conf(pgpolicy);
> +       mp_set_default(pgpolicy, DEFAULT_PGPOLICY);
> +out:
>         mp->pgpolicyfn = pgpolicies[mp->pgpolicy];
> -       get_pgpolicy_name(pgpolicy_name, POLICY_NAME_SIZE, mp->pgpolicy);
> -       condlog(3, "%s: pgpolicy = %s (internal default)",
> -               mp->alias, pgpolicy_name);
> +       get_pgpolicy_name(buff, POLICY_NAME_SIZE, mp->pgpolicy);
> +       condlog(3, "%s: path_grouping_policy = %s %s", mp->alias, buff,
> origin);
>         return 0;
>  }
>
>  extern int
>  select_selector (struct multipath * mp)
>  {
> -       if (mp->mpe && mp->mpe->selector) {
> -               mp->selector = mp->mpe->selector;
> -               condlog(3, "%s: selector = %s (LUN setting)",
> -                       mp->alias, mp->selector);
> -               return 0;
> -       }
> -       if (mp->hwe && mp->hwe->selector) {
> -               mp->selector = mp->hwe->selector;
> -               condlog(3, "%s: selector = %s (controller setting)",
> -                       mp->alias, mp->selector);
> -               return 0;
> -       }
> -       if (conf->selector) {
> -               mp->selector = conf->selector;
> -               condlog(3, "%s: selector = %s (config file default)",
> -                       mp->alias, mp->selector);
> -               return 0;
> -       }
> -       mp->selector = set_default(DEFAULT_SELECTOR);
> -       condlog(3, "%s: selector = %s (internal default)",
> -               mp->alias, mp->selector);
> +       char *origin;
> +
> +       mp_set_mpe(selector);
> +       mp_set_hwe(selector);
> +       mp_set_conf(selector);
> +       mp_set_default(selector, set_default(DEFAULT_SELECTOR));
> +out:
> +       condlog(3, "%s: path_selector = \"%s\" %s", mp->alias,
> mp->selector,
> +               origin);
>         return 0;
>  }
>
>  static void
>  select_alias_prefix (struct multipath * mp)
>  {
> -       if (mp->hwe && mp->hwe->alias_prefix) {
> -               mp->alias_prefix = mp->hwe->alias_prefix;
> -               condlog(3, "%s: alias_prefix = %s (controller setting)",
> -                       mp->wwid, mp->alias_prefix);
> -               return;
> -       }
> -       if (conf->alias_prefix) {
> -               mp->alias_prefix = conf->alias_prefix;
> -               condlog(3, "%s: alias_prefix = %s (config file default)",
> -                       mp->wwid, mp->alias_prefix);
> -               return;
> -       }
> -       mp->alias_prefix = set_default(DEFAULT_ALIAS_PREFIX);
> -       condlog(3, "%s: alias_prefix = %s (internal default)",
> -               mp->wwid, mp->alias_prefix);
> +       char *origin;
> +
> +       mp_set_hwe(alias_prefix);
> +       mp_set_conf(alias_prefix);
> +       mp_set_default(alias_prefix, DEFAULT_ALIAS_PREFIX);
> +out:
> +       condlog(3, "%s: alias_prefix = %s %s", mp->wwid, mp->alias_prefix,
> +               origin);
>  }
>
>  static int
> @@ -253,8 +218,11 @@ want_user_friendly_names(struct multipath * mp)
>  extern int
>  select_alias (struct multipath * mp)
>  {
> +       char *origin;
> +
>         if (mp->mpe && mp->mpe->alias) {
>                 mp->alias = STRDUP(mp->mpe->alias);
> +               origin = "(LUN setting)";
>                 goto out;
>         }
>
> @@ -269,39 +237,37 @@ select_alias (struct multipath * mp)
>                                 mp->alias_old, mp->alias_prefix,
>                                 conf->bindings_read_only);
>                 memset (mp->alias_old, 0, WWID_SIZE);
> +               origin = "(using existing alias)";
>         }
>
> -       if (mp->alias == NULL)
> +       if (mp->alias == NULL) {
>                 mp->alias = get_user_friendly_alias(mp->wwid,
>                                 conf->bindings_file, mp->alias_prefix,
> conf->bindings_read_only);
> +               origin = "(user_friendly_name)";
> +       }
>  out:
> -       if (mp->alias == NULL)
> +       if (mp->alias == NULL) {
>                 mp->alias = STRDUP(mp->wwid);
> -
> +               origin = "(default to wwid)";
> +       }
> +       if (mp->alias)
> +               condlog(3, "%s: alias = %s %s", mp->wwid, mp->alias,
> origin);
>         return mp->alias ? 0 : 1;
>  }
>
>  extern int
>  select_features (struct multipath * mp)
>  {
> -       struct mpentry * mpe;
>         char *origin;
>
> -       if ((mpe = find_mpe(mp->wwid)) && mpe->features) {
> -               mp->features = STRDUP(mpe->features);
> -               origin = "LUN setting";
> -       } else if (mp->hwe && mp->hwe->features) {
> -               mp->features = STRDUP(mp->hwe->features);
> -               origin = "controller setting";
> -       } else if (conf->features) {
> -               mp->features = STRDUP(conf->features);
> -               origin = "config file default";
> -       } else {
> -               mp->features = set_default(DEFAULT_FEATURES);
> -               origin = "internal default";
> -       }
> -       condlog(3, "%s: features = %s (%s)",
> -               mp->alias, mp->features, origin);
> +       mp_set_mpe(features);
> +       mp_set_hwe(features);
> +       mp_set_conf(features);
> +       mp_set_default(features, DEFAULT_FEATURES);
> +out:
> +       mp->features = STRDUP(mp->features);
> +       condlog(3, "%s: features = \"%s\" %s", mp->alias, mp->features,
> origin);
> +
>         if (strstr(mp->features, "queue_if_no_path")) {
>                 if (mp->no_path_retry == NO_PATH_RETRY_UNDEF)
>                         mp->no_path_retry = NO_PATH_RETRY_QUEUE;
> @@ -317,45 +283,29 @@ select_features (struct multipath * mp)
>  extern int
>  select_hwhandler (struct multipath * mp)
>  {
> -       if (mp->hwe && mp->hwe->hwhandler) {
> -               mp->hwhandler = mp->hwe->hwhandler;
> -               condlog(3, "%s: hwhandler = %s (controller setting)",
> -                       mp->alias, mp->hwhandler);
> -               return 0;
> -       }
> -       if (conf->hwhandler) {
> -               mp->hwhandler = conf->hwhandler;
> -               condlog(3, "%s: hwhandler = %s (config file default)",
> -                       mp->alias, mp->hwhandler);
> -               return 0;
> -       }
> -       mp->hwhandler = set_default(DEFAULT_HWHANDLER);
> -       condlog(3, "%s: hwhandler = %s (internal default)",
> -               mp->alias, mp->hwhandler);
> +       char *origin;
> +
> +       mp_set_hwe(hwhandler);
> +       mp_set_conf(hwhandler);
> +       mp_set_default(hwhandler, set_default(DEFAULT_HWHANDLER));
> +out:
> +       condlog(3, "%s: hardware_handler = \"%s\" %s", mp->alias,
> mp->hwhandler,
> +               origin);
>         return 0;
>  }
>
>  extern int
>  select_checker(struct path *pp)
>  {
> +       char *origin, *checker_name;
>         struct checker * c = &pp->checker;
>
> -       if (pp->hwe && pp->hwe->checker_name) {
> -               checker_get(c, pp->hwe->checker_name);
> -               condlog(3, "%s: path checker = %s (controller setting)",
> -                       pp->dev, checker_name(c));
> -               goto out;
> -       }
> -       if (conf->checker_name) {
> -               checker_get(c, conf->checker_name);
> -               condlog(3, "%s: path checker = %s (config file default)",
> -                       pp->dev, checker_name(c));
> -               goto out;
> -       }
> -       checker_get(c, DEFAULT_CHECKER);
> -       condlog(3, "%s: path checker = %s (internal default)",
> -               pp->dev, checker_name(c));
> +       do_set(checker_name, pp->hwe, checker_name, "(controller
> setting)");
> +       do_set(checker_name, conf, checker_name, "(config file setting)");
> +       do_default(checker_name, DEFAULT_CHECKER);
>  out:
> +       checker_get(c, checker_name);
> +       condlog(3, "%s: path_checker = %s %s", pp->dev, c->name, origin);
>         if (conf->checker_timeout) {
>                 c->timeout = conf->checker_timeout;
>                 condlog(3, "%s: checker timeout = %u s (config file
> default)",
> @@ -375,33 +325,20 @@ out:
>  extern int
>  select_getuid (struct path * pp)
>  {
> -       if (pp->hwe && pp->hwe->uid_attribute) {
> -               pp->uid_attribute = pp->hwe->uid_attribute;
> -               condlog(3, "%s: uid_attribute = %s (controller setting)",
> -                       pp->dev, pp->uid_attribute);
> -               return 0;
> -       }
> -       if (pp->hwe && pp->hwe->getuid) {
> -               pp->getuid = pp->hwe->getuid;
> -               condlog(3, "%s: getuid = %s (deprecated) (controller
> setting)",
> -                       pp->dev, pp->getuid);
> -               return 0;
> -       }
> -       if (conf->uid_attribute) {
> -               pp->uid_attribute = conf->uid_attribute;
> -               condlog(3, "%s: uid_attribute = %s (config file default)",
> -                       pp->dev, pp->uid_attribute);
> -               return 0;
> -       }
> -       if (conf->getuid) {
> -               pp->getuid = conf->getuid;
> -               condlog(3, "%s: getuid = %s (deprecated) (config file
> default)",
> -                       pp->dev, pp->getuid);
> -               return 0;
> -       }
> -       pp->uid_attribute = STRDUP(DEFAULT_UID_ATTRIBUTE);
> -       condlog(3, "%s: uid_attribute = %s (internal default)",
> -               pp->dev, pp->uid_attribute);
> +       char *origin;
> +
> +       pp_set_hwe(uid_attribute);
> +       pp_set_hwe(getuid);
> +       pp_set_conf(uid_attribute);
> +       pp_set_conf(getuid);
> +       pp_set_default(uid_attribute, DEFAULT_UID_ATTRIBUTE);
> +out:
> +       if (pp->uid_attribute)
> +               condlog(3, "%s: uid_attribute = %s %s", pp->dev,
> +                       pp->uid_attribute, origin);
> +       else if (pp->getuid)
> +               condlog(3, "%s: getuid = \"%s\" %s", pp->dev, pp->getuid,
> +                       origin);
>         return 0;
>  }
>
> @@ -421,140 +358,94 @@ detect_prio(struct path * pp)
>         prio_get(p, PRIO_ALUA, DEFAULT_PRIO_ARGS);
>  }
>
> +#define set_prio(src, msg)                                             \
> +do {                                                                   \
> +       if (src && src->prio_name) {                                    \
> +               prio_get(p, src->prio_name, src->prio_args);            \
> +               origin = msg;                                           \
> +               goto out;                                               \
> +       }                                                               \
> +} while(0)
> +
>  extern int
>  select_prio (struct path * pp)
>  {
> +       char *origin;
>         struct mpentry * mpe;
>         struct prio * p = &pp->prio;
>
>         if (pp->detect_prio == DETECT_PRIO_ON) {
>                 detect_prio(pp);
>                 if (prio_selected(p)) {
> -                       condlog(3, "%s: prio = %s (detected setting)",
> -                               pp->dev, prio_name(p));
> -                       return 0;
> -               }
> -       }
> -
> -       if ((mpe = find_mpe(pp->wwid))) {
> -               if (mpe->prio_name) {
> -                       prio_get(p, mpe->prio_name, mpe->prio_args);
> -                       condlog(3, "%s: prio = %s (LUN setting)",
> -                               pp->dev, prio_name(p));
> -                       return 0;
> +                       origin = "(detected setting)";
> +                       goto out;
>                 }
>         }
> -
> -       if (pp->hwe && pp->hwe->prio_name) {
> -               prio_get(p, pp->hwe->prio_name, pp->hwe->prio_args);
> -               condlog(3, "%s: prio = %s (controller setting)",
> -                       pp->dev, pp->hwe->prio_name);
> -               condlog(3, "%s: prio args = %s (controller setting)",
> -                       pp->dev, pp->hwe->prio_args);
> -               return 0;
> -       }
> -       if (conf->prio_name) {
> -               prio_get(p, conf->prio_name, conf->prio_args);
> -               condlog(3, "%s: prio = %s (config file default)",
> -                       pp->dev, conf->prio_name);
> -               condlog(3, "%s: prio args = %s (config file default)",
> -                       pp->dev, conf->prio_args);
> -               return 0;
> -       }
> +       mpe = find_mpe(pp->wwid);
> +       set_prio(mpe, "(LUN setting)");
> +       set_prio(pp->hwe, "controller setting)");
> +       set_prio(conf, "(config file default)");
>         prio_get(p, DEFAULT_PRIO, DEFAULT_PRIO_ARGS);
> -       condlog(3, "%s: prio = %s (internal default)",
> -               pp->dev, DEFAULT_PRIO);
> -       condlog(3, "%s: prio args = %s (internal default)",
> -               pp->dev, DEFAULT_PRIO_ARGS);
> +       origin = "(internal default)";
> +out:
> +       condlog(3, "%s: prio = %s %s", pp->dev, prio_name(p), origin);
> +       condlog(3, "%s: prio args = \"%s\" %s", pp->dev, prio_args(p),
> origin);
>         return 0;
>  }
>
>  extern int
>  select_no_path_retry(struct multipath *mp)
>  {
> +       char *origin = NULL;
> +       char buff[12];
> +
>         if (mp->flush_on_last_del == FLUSH_IN_PROGRESS) {
>                 condlog(0, "flush_on_last_del in progress");
>                 mp->no_path_retry = NO_PATH_RETRY_FAIL;
>                 return 0;
>         }
> -       if (mp->mpe && mp->mpe->no_path_retry != NO_PATH_RETRY_UNDEF) {
> -               mp->no_path_retry = mp->mpe->no_path_retry;
> -               condlog(3, "%s: no_path_retry = %i (multipath setting)",
> -                       mp->alias, mp->no_path_retry);
> -               return 0;
> -       }
> -       if (mp->hwe && mp->hwe->no_path_retry != NO_PATH_RETRY_UNDEF) {
> -               mp->no_path_retry = mp->hwe->no_path_retry;
> -               condlog(3, "%s: no_path_retry = %i (controller setting)",
> -                       mp->alias, mp->no_path_retry);
> -               return 0;
> -       }
> -       if (conf->no_path_retry != NO_PATH_RETRY_UNDEF) {
> -               mp->no_path_retry = conf->no_path_retry;
> -               condlog(3, "%s: no_path_retry = %i (config file default)",
> -                       mp->alias, mp->no_path_retry);
> -               return 0;
> -       }
> -       if (mp->no_path_retry != NO_PATH_RETRY_UNDEF)
> -               condlog(3, "%s: no_path_retry = %i (inherited setting)",
> -                       mp->alias, mp->no_path_retry);
> +       mp_set_mpe(no_path_retry);
> +       mp_set_hwe(no_path_retry);
> +       mp_set_conf(no_path_retry);
> +out:
> +       print_no_path_retry(buff, 12, &mp->no_path_retry);
> +       if (origin)
> +               condlog(3, "%s: no_path_retry = %s %s", mp->alias, buff,
> +                       origin);
> +       else if (mp->no_path_retry != NO_PATH_RETRY_UNDEF)
> +               condlog(3, "%s: no_path_retry = %s (inheritied setting)",
> +                       mp->alias, buff);
>         else
> -               condlog(3, "%s: no_path_retry = %i (internal default)",
> -                       mp->alias, mp->no_path_retry);
> +               condlog(3, "%s: no_path_retry = undef (internal default)",
> +                       mp->alias);
>         return 0;
>  }
>
>  int
>  select_minio_rq (struct multipath * mp)
>  {
> -       if (mp->mpe && mp->mpe->minio_rq) {
> -               mp->minio = mp->mpe->minio_rq;
> -               condlog(3, "%s: minio = %i rq (LUN setting)",
> -                       mp->alias, mp->minio);
> -               return 0;
> -       }
> -       if (mp->hwe && mp->hwe->minio_rq) {
> -               mp->minio = mp->hwe->minio_rq;
> -               condlog(3, "%s: minio = %i rq (controller setting)",
> -                       mp->alias, mp->minio);
> -               return 0;
> -       }
> -       if (conf->minio) {
> -               mp->minio = conf->minio_rq;
> -               condlog(3, "%s: minio = %i rq (config file default)",
> -                       mp->alias, mp->minio);
> -               return 0;
> -       }
> -       mp->minio = DEFAULT_MINIO_RQ;
> -       condlog(3, "%s: minio = %i rq (internal default)",
> -               mp->alias, mp->minio);
> +       char *origin;
> +
> +       do_set(minio_rq, mp->mpe, mp->minio, "(LUN setting)");
> +       do_set(minio_rq, mp->hwe, mp->minio, "(controller setting)");
> +       do_set(minio_rq, conf, mp->minio, "(config file setting)");
> +       do_default(mp->minio, DEFAULT_MINIO_RQ);
> +out:
> +       condlog(3, "%s: minio = %i %s", mp->alias, mp->minio, origin);
>         return 0;
>  }
>
>  int
>  select_minio_bio (struct multipath * mp)
>  {
> -       if (mp->mpe && mp->mpe->minio) {
> -               mp->minio = mp->mpe->minio;
> -               condlog(3, "%s: minio = %i (LUN setting)",
> -                       mp->alias, mp->minio);
> -               return 0;
> -       }
> -       if (mp->hwe && mp->hwe->minio) {
> -               mp->minio = mp->hwe->minio;
> -               condlog(3, "%s: minio = %i (controller setting)",
> -                       mp->alias, mp->minio);
> -               return 0;
> -       }
> -       if (conf->minio) {
> -               mp->minio = conf->minio;
> -               condlog(3, "%s: minio = %i (config file default)",
> -                       mp->alias, mp->minio);
> -               return 0;
> -       }
> -       mp->minio = DEFAULT_MINIO;
> -       condlog(3, "%s: minio = %i (internal default)",
> -               mp->alias, mp->minio);
> +       char *origin;
> +
> +       mp_set_mpe(minio);
> +       mp_set_hwe(minio);
> +       mp_set_conf(minio);
> +       mp_set_default(minio, DEFAULT_MINIO);
> +out:
> +       condlog(3, "%s: minio = %i %s", mp->alias, mp->minio, origin);
>         return 0;
>  }
>
> @@ -572,164 +463,95 @@ select_minio (struct multipath * mp)
>  extern int
>  select_fast_io_fail(struct multipath *mp)
>  {
> -       if (mp->hwe && mp->hwe->fast_io_fail != MP_FAST_IO_FAIL_UNSET) {
> -               mp->fast_io_fail = mp->hwe->fast_io_fail;
> -               if (mp->fast_io_fail == MP_FAST_IO_FAIL_OFF)
> -                       condlog(3, "%s: fast_io_fail_tmo = off "
> -                               "(controller setting)", mp->alias);
> -               else
> -                       condlog(3, "%s: fast_io_fail_tmo = %d "
> -                               "(controller setting)", mp->alias,
> -                               mp->fast_io_fail == MP_FAST_IO_FAIL_ZERO ?
> 0 : mp->fast_io_fail);
> -               return 0;
> -       }
> -       if (conf->fast_io_fail != MP_FAST_IO_FAIL_UNSET) {
> -               mp->fast_io_fail = conf->fast_io_fail;
> -               if (mp->fast_io_fail == MP_FAST_IO_FAIL_OFF)
> -                       condlog(3, "%s: fast_io_fail_tmo = off "
> -                               "(config file default)", mp->alias);
> -               else
> -                       condlog(3, "%s: fast_io_fail_tmo = %d "
> -                               "(config file default)", mp->alias,
> -                               mp->fast_io_fail == MP_FAST_IO_FAIL_ZERO ?
> 0 : mp->fast_io_fail);
> -               return 0;
> -       }
> -       mp->fast_io_fail = MP_FAST_IO_FAIL_UNSET;
> +       char *origin, buff[12];
> +
> +       mp_set_hwe(fast_io_fail);
> +       mp_set_conf(fast_io_fail);
> +       mp_set_default(fast_io_fail, DEFAULT_FAST_IO_FAIL);
> +out:
> +       print_fast_io_fail(buff, 12, &mp->fast_io_fail);
> +       condlog(3, "%s: fast_io_fail_tmo = %s %s", mp->alias, buff,
> origin);
>         return 0;
>  }
>
>  extern int
>  select_dev_loss(struct multipath *mp)
>  {
> -       if (mp->hwe && mp->hwe->dev_loss) {
> -               mp->dev_loss = mp->hwe->dev_loss;
> -               condlog(3, "%s: dev_loss_tmo = %u (controller default)",
> -                       mp->alias, mp->dev_loss);
> -               return 0;
> -       }
> -       if (conf->dev_loss) {
> -               mp->dev_loss = conf->dev_loss;
> -               condlog(3, "%s: dev_loss_tmo = %u (config file default)",
> -                       mp->alias, mp->dev_loss);
> -               return 0;
> -       }
> +       char *origin, buff[12];
> +
> +       mp_set_hwe(dev_loss);
> +       mp_set_conf(dev_loss);
>         mp->dev_loss = 0;
>         return 0;
> +out:
> +       print_dev_loss(buff, 12, &mp->dev_loss);
> +       condlog(3, "%s: dev_loss_tmo = %s %s", mp->alias, buff, origin);
> +       return 0;
>  }
>
>  extern int
>  select_flush_on_last_del(struct multipath *mp)
>  {
> +       char *origin;
> +
>         if (mp->flush_on_last_del == FLUSH_IN_PROGRESS)
>                 return 0;
> -       if (mp->mpe && mp->mpe->flush_on_last_del != FLUSH_UNDEF) {
> -               mp->flush_on_last_del = mp->mpe->flush_on_last_del;
> -               condlog(3, "%s: flush_on_last_del = %i (multipath
> setting)",
> -                       mp->alias, mp->flush_on_last_del);
> -               return 0;
> -       }
> -       if (mp->hwe && mp->hwe->flush_on_last_del != FLUSH_UNDEF) {
> -               mp->flush_on_last_del = mp->hwe->flush_on_last_del;
> -               condlog(3, "%s: flush_on_last_del = %i (controller
> setting)",
> -                       mp->alias, mp->flush_on_last_del);
> -               return 0;
> -       }
> -       if (conf->flush_on_last_del != FLUSH_UNDEF) {
> -               mp->flush_on_last_del = conf->flush_on_last_del;
> -               condlog(3, "%s: flush_on_last_del = %i (config file
> default)",
> -                       mp->alias, mp->flush_on_last_del);
> -               return 0;
> -       }
> -       mp->flush_on_last_del = FLUSH_UNDEF;
> -       condlog(3, "%s: flush_on_last_del = DISABLED (internal default)",
> -               mp->alias);
> +       mp_set_mpe(flush_on_last_del);
> +       mp_set_hwe(flush_on_last_del);
> +       mp_set_conf(flush_on_last_del);
> +       mp_set_default(flush_on_last_del, FLUSH_DISABLED);
> +out:
> +       condlog(3, "%s: flush_on_last_del = %s %s", mp->alias,
> +               (mp->flush_on_last_del == FLUSH_ENABLED)? "yes" : "no",
> origin);
>         return 0;
>  }
>
>  extern int
>  select_reservation_key (struct multipath * mp)
>  {
> -       int j;
> -       unsigned char *keyp;
> -       uint64_t prkey = 0;
> +       char *origin, buff[12];
>
> +       mp_set_mpe(reservation_key);
> +       mp_set_conf(reservation_key);
>         mp->reservation_key = NULL;
> -
> -       if (mp->mpe && mp->mpe->reservation_key) {
> -               keyp =  mp->mpe->reservation_key;
> -               for (j = 0; j < 8; ++j) {
> -                       if (j > 0)
> -                               prkey <<= 8;
> -                       prkey |= *keyp;
> -                       ++keyp;
> -               }
> -
> -               condlog(3, "%s: reservation_key = 0x%" PRIx64 " "
> -                               "(multipath setting)",  mp->alias, prkey);
> -
> -               mp->reservation_key = mp->mpe->reservation_key;
> -               return 0;
> -       }
> -
> -       if (conf->reservation_key) {
> -               keyp = conf->reservation_key;
> -               for (j = 0; j < 8; ++j) {
> -                       if (j > 0)
> -                               prkey <<= 8;
> -                       prkey |= *keyp;
> -                       ++keyp;
> -               }
> -
> -               condlog(3, "%s: reservation_key  = 0x%" PRIx64
> -                               " (config file default)", mp->alias,
> prkey);
> -
> -               mp->reservation_key = conf->reservation_key;
> -               return 0;
> -       }
> -
> +       return 0;
> +out:
> +       print_reservation_key(buff, 12, &mp->reservation_key);
> +       condlog(3, "%s: reservation_key = %s %s", mp->alias, buff, origin);
>         return 0;
>  }
>
>  extern int
>  select_retain_hwhandler (struct multipath * mp)
>  {
> +       char *origin;
>         unsigned int minv_dm_retain[3] = {1, 5, 0};
>
>         if (!VERSION_GE(conf->version, minv_dm_retain)) {
>                 mp->retain_hwhandler = RETAIN_HWHANDLER_OFF;
> -               condlog(3, "%s: retain_attached_hw_handler disabled
> (requires kernel version >= 1.5.0)", mp->alias);
> -               return 0;
> -       }
> -
> -       if (mp->hwe && mp->hwe->retain_hwhandler) {
> -               mp->retain_hwhandler = mp->hwe->retain_hwhandler;
> -               condlog(3, "%s: retain_attached_hw_handler = %d
> (controller default)", mp->alias, mp->retain_hwhandler);
> -               return 0;
> -       }
> -       if (conf->retain_hwhandler) {
> -               mp->retain_hwhandler = conf->retain_hwhandler;
> -               condlog(3, "%s: retain_attached_hw_handler = %d (config
> file default)", mp->alias, mp->retain_hwhandler);
> -               return 0;
> +               origin = "(requires kernel version >= 1.5.0)";
> +               goto out;
>         }
> -       mp->retain_hwhandler = 0;
> -       condlog(3, "%s: retain_attached_hw_handler = %d (compiled in
> default)", mp->alias, mp->retain_hwhandler);
> +       mp_set_hwe(retain_hwhandler);
> +       mp_set_conf(retain_hwhandler);
> +       mp_set_default(retain_hwhandler, DEFAULT_RETAIN_HWHANDLER);
> +out:
> +       condlog(3, "%s: retain_attached_hw_handler = %s %s", mp->alias,
> +               (mp->retain_hwhandler == RETAIN_HWHANDLER_ON)? "yes" :
> "no",
> +               origin);
>         return 0;
>  }
>
>  extern int
>  select_detect_prio (struct path * pp)
>  {
> -       if (pp->hwe && pp->hwe->detect_prio) {
> -               pp->detect_prio = pp->hwe->detect_prio;
> -               condlog(3, "%s: detect_prio = %d (controller default)",
> pp->dev, pp->detect_prio);
> -               return 0;
> -       }
> -       if (conf->detect_prio) {
> -               pp->detect_prio = conf->detect_prio;
> -               condlog(3, "%s: detect_prio = %d (config file default)",
> pp->dev, pp->detect_prio);
> -               return 0;
> -       }
> -       pp->detect_prio = 0;
> -       condlog(3, "%s: detect_prio = %d (compiled in default)", pp->dev,
> pp->detect_prio);
> +       char *origin;
> +
> +       pp_set_hwe(detect_prio);
> +       pp_set_conf(detect_prio);
> +       pp_set_default(detect_prio, DEFAULT_DETECT_PRIO);
> +out:
> +       condlog(3, "%s: detect_prio = %s %s", pp->dev,
> +               (pp->detect_prio == DETECT_PRIO_ON)? "yes" : "no", origin);
>         return 0;
>  }
> --
> 1.8.3.1
>
>

--047d7b34318a3c8731050c2bc7b9
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: base64

PGRpdiBkaXI9Imx0ciI+QXBwbGllZCw8ZGl2Pjxicj48L2Rpdj48ZGl2PlZhbHVhYmxlIG1haW50
YWluYWJpbGl0eSBlbmhhbmNlbWVudCwgYWdhaW4sIHRoYW5rcy48L2Rpdj48L2Rpdj48ZGl2IGNs
YXNzPSJnbWFpbF9leHRyYSI+PGJyPjxkaXYgY2xhc3M9ImdtYWlsX3F1b3RlIj5PbiBUaHUsIE9j
dCAyLCAyMDE0IGF0IDI6NTUgQU0sIEJlbmphbWluIE1hcnppbnNraSA8c3BhbiBkaXI9Imx0ciI+
Jmx0OzxhIGhyZWY9Im1haWx0bzpibWFyemluc0ByZWRoYXQuY29tIiB0YXJnZXQ9Il9ibGFuayI+
Ym1hcnppbnNAcmVkaGF0LmNvbTwvYT4mZ3Q7PC9zcGFuPiB3cm90ZTo8YnI+PGJsb2NrcXVvdGUg
Y2xhc3M9ImdtYWlsX3F1b3RlIiBzdHlsZT0ibWFyZ2luOjAgMCAwIC44ZXg7Ym9yZGVyLWxlZnQ6
MXB4ICNjY2Mgc29saWQ7cGFkZGluZy1sZWZ0OjFleCI+TWFueSBvZiB0aGUgZnVuY3Rpb25zIGlu
IHByb3BzZWwuYyBhcmUgbmVhcmx5IGlkZW50aWNhbCwgZXhjZXB0IGZvciB0aGU8YnI+DQpuYW1l
cyBvZiB0aGUgdmFyaWFibGVzIHRoYXQgdGhleSBhcmUgZGVhbGluZyB3aXRoLsKgIEFsc28sIHNv
bWUgdmFyaWFibGVzPGJyPg0KdGhhdCB0aGUgdXNlciBjb25maWd1cmVkIHdpdGggYSBrZXl3b3Jk
IHdlcmUganVzdCBwcmludGluZyB0aGUgdmFyaWFibGU8YnI+DQphcyBhbiBpbnRlZ2VyLCB3aGlj
aCBpc24mIzM5O3QgdmVyeSBoZWxwZnVsIHdpdGhvdXQgbG9va2luZyBhdCB0aGUgY29kZSB0bzxi
cj4NCnNlZSB3aGF0IHRoZSBudW1iZXIgc3RhbmRzIGZvci4gVGhleSB3ZXJlIHVzaW5nIHRoZSB2
YXJpYWJsZSBuYW1lczxicj4NCmluc3RlYWQgb2YgdGhlIGNvbmZpZyBmaWxlIG5hbWVzIGFzIHdl
bGwuwqAgVGhpcyBwYXRjaCB0cmllcyB0byBzaW1wbGlmeTxicj4NCnRoZSBmaWxlIGJ5IHVzaW5n
IG1hY3JvcyBmb3IgdGhlIHJlcGV0aXRpdmUgd29yayBvZiB0aGUgZnVuY3Rpb25zLCBhbmQ8YnI+
DQpzdGFuZGFyZGl6ZXMgYW5kIGNsYXJpZmllcyB0aGUgZGVidWcgbWVzc2FnZXMgYnkgdXNpbmcg
dGhlIHByaW50IGZ1bmN0aW9uczxicj4NCmZyb20gZGljdC5jPGJyPg0KPGJyPg0KU2lnbmVkLW9m
Zi1ieTogQmVuamFtaW4gTWFyemluc2tpICZsdDs8YSBocmVmPSJtYWlsdG86Ym1hcnppbnNAcmVk
aGF0LmNvbSI+Ym1hcnppbnNAcmVkaGF0LmNvbTwvYT4mZ3Q7PGJyPg0KLS0tPGJyPg0KwqBsaWJt
dWx0aXBhdGgvZGljdC5jwqAgwqAgwqAgwqB8wqAgMTQgKy08YnI+DQrCoGxpYm11bHRpcGF0aC9k
aWN0LmjCoCDCoCDCoCDCoHzCoCDCoDcgKzxicj4NCsKgbGlibXVsdGlwYXRoL3BncG9saWNpZXMu
YyB8wqAgwqAyICstPGJyPg0KwqBsaWJtdWx0aXBhdGgvcHJvcHNlbC5jwqAgwqAgfCA3MTIgKysr
KysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLTxicj4NCsKgNCBmaWxl
cyBjaGFuZ2VkLCAyODIgaW5zZXJ0aW9ucygrKSwgNDUzIGRlbGV0aW9ucygtKTxicj4NCjxicj4N
CmRpZmYgLS1naXQgYS9saWJtdWx0aXBhdGgvZGljdC5jIGIvbGlibXVsdGlwYXRoL2RpY3QuYzxi
cj4NCmluZGV4IGU4OGMxMjIuLjk4Y2JlNDggMTAwNjQ0PGJyPg0KLS0tIGEvbGlibXVsdGlwYXRo
L2RpY3QuYzxicj4NCisrKyBiL2xpYm11bHRpcGF0aC9kaWN0LmM8YnI+DQpAQCAtNDk2LDcgKzQ5
Niw3IEBAIHNldF9mYXN0X2lvX2ZhaWwodmVjdG9yIHN0cnZlYywgdm9pZCAqcHRyKTxicj4NCsKg
IMKgIMKgIMKgIHJldHVybiAwOzxicj4NCsKgfTxicj4NCjxicj4NCi1zdGF0aWMgaW50PGJyPg0K
K2ludDxicj4NCsKgcHJpbnRfZmFzdF9pb19mYWlsKGNoYXIgKiBidWZmLCBpbnQgbGVuLCB2b2lk
ICpwdHIpPGJyPg0KwqB7PGJyPg0KwqAgwqAgwqAgwqAgaW50ICppbnRfcHRyID0gKGludCAqKXB0
cjs8YnI+DQpAQCAtNTM0LDcgKzUzNCw3IEBAIHNldF9kZXZfbG9zcyh2ZWN0b3Igc3RydmVjLCB2
b2lkICpwdHIpPGJyPg0KwqAgwqAgwqAgwqAgcmV0dXJuIDA7PGJyPg0KwqB9PGJyPg0KPGJyPg0K
LXN0YXRpYyBpbnQ8YnI+DQoraW50PGJyPg0KwqBwcmludF9kZXZfbG9zcyhjaGFyICogYnVmZiwg
aW50IGxlbiwgdm9pZCAqcHRyKTxicj4NCsKgezxicj4NCsKgIMKgIMKgIMKgIHVuc2lnbmVkIGlu
dCAqdWludF9wdHIgPSAodW5zaWduZWQgaW50ICopcHRyOzxicj4NCkBAIC01NjcsNyArNTY3LDcg
QEAgc2V0X3BncG9saWN5KHZlY3RvciBzdHJ2ZWMsIHZvaWQgKnB0cik8YnI+DQrCoCDCoCDCoCDC
oCByZXR1cm4gMDs8YnI+DQrCoH08YnI+DQo8YnI+DQotc3RhdGljIGludDxicj4NCitpbnQ8YnI+
DQrCoHByaW50X3BncG9saWN5KGNoYXIgKiBidWZmLCBpbnQgbGVuLCB2b2lkICpwdHIpPGJyPg0K
wqB7PGJyPg0KwqAgwqAgwqAgwqAgY2hhciBzdHJbUE9MSUNZX05BTUVfU0laRV07PGJyPg0KQEAg
LTY4Myw3ICs2ODMsNyBAQCBzZXRfcnJfd2VpZ2h0KHZlY3RvciBzdHJ2ZWMsIHZvaWQgKnB0cik8
YnI+DQrCoCDCoCDCoCDCoCByZXR1cm4gMDs8YnI+DQrCoH08YnI+DQo8YnI+DQotc3RhdGljIGlu
dDxicj4NCitpbnQ8YnI+DQrCoHByaW50X3JyX3dlaWdodCAoY2hhciAqIGJ1ZmYsIGludCBsZW4s
IHZvaWQgKnB0cik8YnI+DQrCoHs8YnI+DQrCoCDCoCDCoCDCoCBpbnQgKmludF9wdHIgPSAoaW50
ICopcHRyOzxicj4NCkBAIC03MjcsNyArNzI3LDcgQEAgc2V0X3BnZmFpbGJhY2sodmVjdG9yIHN0
cnZlYywgdm9pZCAqcHRyKTxicj4NCsKgIMKgIMKgIMKgIHJldHVybiAwOzxicj4NCsKgfTxicj4N
Cjxicj4NCi1zdGF0aWMgaW50PGJyPg0KK2ludDxicj4NCsKgcHJpbnRfcGdmYWlsYmFjayAoY2hh
ciAqIGJ1ZmYsIGludCBsZW4sIHZvaWQgKnB0cik8YnI+DQrCoHs8YnI+DQrCoCDCoCDCoCDCoCBp
bnQgKmludF9wdHIgPSAoaW50ICopcHRyOzxicj4NCkBAIC03NzQsNyArNzc0LDcgQEAgc2V0X25v
X3BhdGhfcmV0cnkodmVjdG9yIHN0cnZlYywgdm9pZCAqcHRyKTxicj4NCsKgIMKgIMKgIMKgIHJl
dHVybiAwOzxicj4NCsKgfTxicj4NCjxicj4NCi1zdGF0aWMgaW50PGJyPg0KK2ludDxicj4NCsKg
cHJpbnRfbm9fcGF0aF9yZXRyeShjaGFyICogYnVmZiwgaW50IGxlbiwgdm9pZCAqcHRyKTxicj4N
CsKgezxicj4NCsKgIMKgIMKgIMKgIGludCAqaW50X3B0ciA9IChpbnQgKilwdHI7PGJyPg0KQEAg
LTg3Myw3ICs4NzMsNyBAQCBzZXRfcmVzZXJ2YXRpb25fa2V5KHZlY3RvciBzdHJ2ZWMsIHZvaWQg
KnB0cik8YnI+DQrCoCDCoCDCoCDCoCByZXR1cm4gMDs8YnI+DQrCoH08YnI+DQo8YnI+DQotc3Rh
dGljIGludDxicj4NCitpbnQ8YnI+DQrCoHByaW50X3Jlc2VydmF0aW9uX2tleShjaGFyICogYnVm
ZiwgaW50IGxlbiwgdm9pZCAqIHB0cik8YnI+DQrCoHs8YnI+DQrCoCDCoCDCoCDCoCB1bnNpZ25l
ZCBjaGFyICoqdWNoYXJfcHRyID0gKHVuc2lnbmVkIGNoYXIgKiopcHRyOzxicj4NCmRpZmYgLS1n
aXQgYS9saWJtdWx0aXBhdGgvZGljdC5oIGIvbGlibXVsdGlwYXRoL2RpY3QuaDxicj4NCmluZGV4
IDY4OGVhYjcuLjg0YjYxODAgMTAwNjQ0PGJyPg0KLS0tIGEvbGlibXVsdGlwYXRoL2RpY3QuaDxi
cj4NCisrKyBiL2xpYm11bHRpcGF0aC9kaWN0Lmg8YnI+DQpAQCAtNyw1ICs3LDEyIEBAPGJyPg0K
PGJyPg0KwqB2b2lkIGluaXRfa2V5d29yZHModm9pZCk7PGJyPg0KwqBpbnQgZ2V0X3N5c19tYXhf
ZmRzKGludCAqKTs8YnI+DQoraW50IHByaW50X3JyX3dlaWdodCAoY2hhciAqIGJ1ZmYsIGludCBs
ZW4sIHZvaWQgKnB0cik7PGJyPg0KK2ludCBwcmludF9wZ2ZhaWxiYWNrIChjaGFyICogYnVmZiwg
aW50IGxlbiwgdm9pZCAqcHRyKTs8YnI+DQoraW50IHByaW50X3BncG9saWN5KGNoYXIgKiBidWZm
LCBpbnQgbGVuLCB2b2lkICpwdHIpOzxicj4NCitpbnQgcHJpbnRfbm9fcGF0aF9yZXRyeShjaGFy
ICogYnVmZiwgaW50IGxlbiwgdm9pZCAqcHRyKTs8YnI+DQoraW50IHByaW50X2Zhc3RfaW9fZmFp
bChjaGFyICogYnVmZiwgaW50IGxlbiwgdm9pZCAqcHRyKTs8YnI+DQoraW50IHByaW50X2Rldl9s
b3NzKGNoYXIgKiBidWZmLCBpbnQgbGVuLCB2b2lkICpwdHIpOzxicj4NCitpbnQgcHJpbnRfcmVz
ZXJ2YXRpb25fa2V5KGNoYXIgKiBidWZmLCBpbnQgbGVuLCB2b2lkICogcHRyKTs8YnI+DQo8YnI+
DQrCoCNlbmRpZiAvKiBfRElDVF9IICovPGJyPg0KZGlmZiAtLWdpdCBhL2xpYm11bHRpcGF0aC9w
Z3BvbGljaWVzLmMgYi9saWJtdWx0aXBhdGgvcGdwb2xpY2llcy5jPGJyPg0KaW5kZXggZjc2YWQ2
MC4uMjk4MWQ1MSAxMDA2NDQ8YnI+DQotLS0gYS9saWJtdWx0aXBhdGgvcGdwb2xpY2llcy5jPGJy
Pg0KKysrIGIvbGlibXVsdGlwYXRoL3BncG9saWNpZXMuYzxicj4NCkBAIC0yNyw3ICsyNyw3IEBA
IGdldF9wZ3BvbGljeV9pZCAoY2hhciAqIHN0cik8YnI+DQrCoCDCoCDCoCDCoCBpZiAoMCA9PSBz
dHJuY21wKHN0ciwgJnF1b3Q7Z3JvdXBfYnlfbm9kZV9uYW1lJnF1b3Q7LCAxOCkpPGJyPg0KwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgcmV0dXJuIEdST1VQX0JZX05PREVfTkFNRTs8YnI+DQo8YnI+
DQotwqAgwqAgwqAgwqByZXR1cm4gLTE7PGJyPg0KK8KgIMKgIMKgIMKgcmV0dXJuIElPUE9MSUNZ
X1VOREVGOzxicj4NCsKgfTxicj4NCjxicj4NCsKgZXh0ZXJuIGludDxicj4NCmRpZmYgLS1naXQg
YS9saWJtdWx0aXBhdGgvcHJvcHNlbC5jIGIvbGlibXVsdGlwYXRoL3Byb3BzZWwuYzxicj4NCmlu
ZGV4IDdhOTY2YmIuLmYyYWI3ZDIgMTAwNjQ0PGJyPg0KLS0tIGEvbGlibXVsdGlwYXRoL3Byb3Bz
ZWwuYzxicj4NCisrKyBiL2xpYm11bHRpcGF0aC9wcm9wc2VsLmM8YnI+DQpAQCAtMTcsNiArMTcs
NyBAQDxicj4NCsKgI2luY2x1ZGUgJnF1b3Q7ZGV2bWFwcGVyLmgmcXVvdDs8YnI+DQrCoCNpbmNs
dWRlICZxdW90O3ByaW8uaCZxdW90Ozxicj4NCsKgI2luY2x1ZGUgJnF1b3Q7ZGlzY292ZXJ5Lmgm
cXVvdDs8YnI+DQorI2luY2x1ZGUgJnF1b3Q7ZGljdC5oJnF1b3Q7PGJyPg0KwqAjaW5jbHVkZSAm
cXVvdDtwcmlvcml0aXplcnMvYWx1YV9ydHBnLmgmcXVvdDs8YnI+DQrCoCNpbmNsdWRlICZsdDtp
bnR0eXBlcy5oJmd0Ozxicj4NCjxicj4NCkBAIC0yOSw1NyArMzAsOTIgQEAgcGdwb2xpY3lmbiAq
cGdwb2xpY2llc1tdID0gezxicj4NCsKgIMKgIMKgIMKgIGdyb3VwX2J5X25vZGVfbmFtZTxicj4N
CsKgfTs8YnI+DQo8YnI+DQorI2RlZmluZSBkb19zZXQodmFyLCBzcmMsIGRlc3QsIG1zZynCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBcPGJyPg0K
K2RvIHvCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoFw8YnI+DQor
wqAgwqAgwqAgwqBpZiAoc3JjICZhbXA7JmFtcDsgc3JjLSZndDt2YXIpIHvCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBcPGJyPg0K
K8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgZGVzdCA9IHNyYy0mZ3Q7dmFyO8KgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIFw8YnI+DQorwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqBvcmlnaW4gPSBtc2c7wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBcPGJyPg0KK8KgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgZ290byBvdXQ7wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBcPGJyPg0KK8KgIMKgIMKgIMKg
fcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgXDxicj4NCit9IHdoaWxlKDAp
PGJyPg0KKyNkZWZpbmUgZG9fZGVmYXVsdChkZXN0LCB2YWx1ZSnCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBcPGJy
Pg0KK2RvIHvCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoFw8YnI+
DQorwqAgwqAgwqAgwqBkZXN0ID0gdmFsdWU7wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBcPGJyPg0KK8Kg
IMKgIMKgIMKgb3JpZ2luID0gJnF1b3Q7KGludGVybmFsIGRlZmF1bHQpJnF1b3Q7O8KgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIFw8YnI+DQorfSB3aGls
ZSgwKTxicj4NCis8YnI+DQorI2RlZmluZSBtcF9zZXRfbXBlKHZhcinCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCBcPGJyPg0KK2RvX3NldCh2YXIsIG1wLSZndDttcGUsIG1wLSZndDt2YXIsICZx
dW90OyhMVU4gc2V0dGluZykmcXVvdDspPGJyPg0KKyNkZWZpbmUgbXBfc2V0X2h3ZSh2YXIpwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgXDxicj4NCitkb19zZXQodmFyLCBtcC0mZ3Q7aHdlLCBt
cC0mZ3Q7dmFyLCAmcXVvdDsoY29udHJvbGxlciBzZXR0aW5nKSZxdW90Oyk8YnI+DQorI2RlZmlu
ZSBtcF9zZXRfY29uZih2YXIpwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBcPGJyPg0KK2RvX3NldCh2YXIsIGNvbmYs
IG1wLSZndDt2YXIsICZxdW90Oyhjb25maWcgZmlsZSBkZWZhdWx0KSZxdW90Oyk8YnI+DQorI2Rl
ZmluZSBtcF9zZXRfZGVmYXVsdCh2YXIsIHZhbHVlKcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgXDxicj4NCitkb19kZWZhdWx0KG1wLSZndDt2
YXIsIHZhbHVlKTxicj4NCis8YnI+DQorI2RlZmluZSBwcF9zZXRfbXBlKHZhcinCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCBcPGJyPg0KK2RvX3NldCh2YXIsIG1wZSwgcHAtJmd0O3ZhciwgJnF1
b3Q7KExVTiBzZXR0aW5nKSZxdW90Oyk8YnI+DQorI2RlZmluZSBwcF9zZXRfaHdlKHZhcinCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBcPGJyPg0KK2RvX3NldCh2YXIsIHBwLSZndDtod2UsIHBw
LSZndDt2YXIsICZxdW90Oyhjb250cm9sbGVyIHNldHRpbmcpJnF1b3Q7KTxicj4NCisjZGVmaW5l
IHBwX3NldF9jb25mKHZhcinCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoFw8YnI+DQorZG9fc2V0KHZhciwgY29uZiwg
cHAtJmd0O3ZhciwgJnF1b3Q7KGNvbmZpZyBmaWxlIGRlZmF1bHQpJnF1b3Q7KTxicj4NCisjZGVm
aW5lIHBwX3NldF9kZWZhdWx0KHZhciwgdmFsdWUpwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBcPGJyPg0KK2RvX2RlZmF1bHQocHAtJmd0O3Zh
ciwgdmFsdWUpPGJyPg0KKzxicj4NCisjZGVmaW5lIGRvX2F0dHJfc2V0KHZhciwgc3JjLCBzaGlm
dCwgbXNnKcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIFw8YnI+
DQorZG8ge8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgXDxicj4N
CivCoCDCoCDCoCDCoGlmIChzcmMgJmFtcDsmYW1wOyAoc3JjLSZndDthdHRyaWJ1dGVfZmxhZ3Mg
JmFtcDsgKDEgJmx0OyZsdDsgc2hpZnQpKSkge8KgIMKgIMKgIMKgIMKgIMKgIMKgXDxicj4NCivC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoG1wLSZndDthdHRyaWJ1dGVfZmxhZ3MgfD0gKDEgJmx0OyZs
dDsgc2hpZnQpO8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIFw8YnI+DQorwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqBtcC0mZ3Q7dmFyID0gc3JjLSZndDt2YXI7wqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBcPGJyPg0KK8KgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgb3JpZ2luID0gbXNnO8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgXDxicj4NCivCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoGdvdG8gb3V0O8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgXDxicj4NCivCoCDCoCDCoCDCoH3CoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoFw8YnI+DQorfSB3aGlsZSgwKTxicj4NCis8
YnI+DQorI2RlZmluZSBzZXRfYXR0cl9tcGUodmFyLCBzaGlmdCnCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoFw8YnI+DQorZG9fYXR0cl9z
ZXQodmFyLCBtcC0mZ3Q7bXBlLCBzaGlmdCwgJnF1b3Q7KExVTiBzZXR0aW5nKSZxdW90Oyk8YnI+
DQorI2RlZmluZSBzZXRfYXR0cl9jb25mKHZhciwgc2hpZnQpwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgXDxicj4NCitkb19hdHRyX3NldCh2
YXIsIGNvbmYsIHNoaWZ0LCAmcXVvdDsoY29uZmlnIGZpbGUgZGVmYXVsdCkmcXVvdDspPGJyPg0K
Kzxicj4NCsKgZXh0ZXJuIGludDxicj4NCsKgc2VsZWN0X21vZGUgKHN0cnVjdCBtdWx0aXBhdGgg
Km1wKTxicj4NCsKgezxicj4NCi3CoCDCoCDCoCDCoGlmIChtcC0mZ3Q7bXBlICZhbXA7JmFtcDsg
KG1wLSZndDttcGUtJmd0O2F0dHJpYnV0ZV9mbGFncyAmYW1wOyAoMSAmbHQ7Jmx0OyBBVFRSX01P
REUpKSkgezxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoG1wLSZndDthdHRyaWJ1dGVfZmxh
Z3MgfD0gKDEgJmx0OyZsdDsgQVRUUl9NT0RFKTs8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqBtcC0mZ3Q7bW9kZSA9IG1wLSZndDttcGUtJmd0O21vZGU7PGJyPg0KLcKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgY29uZGxvZygzLCAmcXVvdDttb2RlID0gMCVvIChMVU4gc2V0dGluZykmcXVvdDss
IG1wLSZndDttb2RlKTs8YnI+DQotwqAgwqAgwqAgwqB9PGJyPg0KLcKgIMKgIMKgIMKgZWxzZSBp
ZiAoY29uZi0mZ3Q7YXR0cmlidXRlX2ZsYWdzICZhbXA7ICgxICZsdDsmbHQ7IEFUVFJfTU9ERSkp
IHs8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBtcC0mZ3Q7YXR0cmlidXRlX2ZsYWdzIHw9
ICgxICZsdDsmbHQ7IEFUVFJfTU9ERSk7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgbXAt
Jmd0O21vZGUgPSBjb25mLSZndDttb2RlOzxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoGNv
bmRsb2coMywgJnF1b3Q7bW9kZSA9IDAlbyAoY29uZmlnIGZpbGUgZGVmYXVsdCkmcXVvdDssIG1w
LSZndDttb2RlKTs8YnI+DQotwqAgwqAgwqAgwqB9PGJyPg0KLcKgIMKgIMKgIMKgZWxzZTxicj4N
Ci3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoG1wLSZndDthdHRyaWJ1dGVfZmxhZ3MgJmFtcDs9IH4o
MSAmbHQ7Jmx0OyBBVFRSX01PREUpOzxicj4NCivCoCDCoCDCoCDCoGNoYXIgKm9yaWdpbjs8YnI+
DQorPGJyPg0KK8KgIMKgIMKgIMKgc2V0X2F0dHJfbXBlKG1vZGUsIEFUVFJfTU9ERSk7PGJyPg0K
K8KgIMKgIMKgIMKgc2V0X2F0dHJfY29uZihtb2RlLCBBVFRSX01PREUpOzxicj4NCivCoCDCoCDC
oCDCoG1wLSZndDthdHRyaWJ1dGVfZmxhZ3MgJmFtcDs9IH4oMSAmbHQ7Jmx0OyBBVFRSX01PREUp
Ozxicj4NCivCoCDCoCDCoCDCoHJldHVybiAwOzxicj4NCitvdXQ6PGJyPg0KK8KgIMKgIMKgIMKg
Y29uZGxvZygzLCAmcXVvdDslczogbW9kZSA9IDAlbyAlcyZxdW90OywgbXAtJmd0O2FsaWFzLCBt
cC0mZ3Q7bW9kZSwgb3JpZ2luKTs8YnI+DQrCoCDCoCDCoCDCoCByZXR1cm4gMDs8YnI+DQrCoH08
YnI+DQo8YnI+DQrCoGV4dGVybiBpbnQ8YnI+DQrCoHNlbGVjdF91aWQgKHN0cnVjdCBtdWx0aXBh
dGggKm1wKTxicj4NCsKgezxicj4NCi3CoCDCoCDCoCDCoGlmIChtcC0mZ3Q7bXBlICZhbXA7JmFt
cDsgKG1wLSZndDttcGUtJmd0O2F0dHJpYnV0ZV9mbGFncyAmYW1wOyAoMSAmbHQ7Jmx0OyBBVFRS
X1VJRCkpKSB7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgbXAtJmd0O2F0dHJpYnV0ZV9m
bGFncyB8PSAoMSAmbHQ7Jmx0OyBBVFRSX1VJRCk7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgbXAtJmd0O3VpZCA9IG1wLSZndDttcGUtJmd0O3VpZDs8YnI+DQotwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqBjb25kbG9nKDMsICZxdW90O3VpZCA9ICV1IChMVU4gc2V0dGluZykmcXVvdDssIG1w
LSZndDt1aWQpOzxicj4NCi3CoCDCoCDCoCDCoH08YnI+DQotwqAgwqAgwqAgwqBlbHNlIGlmIChj
b25mLSZndDthdHRyaWJ1dGVfZmxhZ3MgJmFtcDsgKDEgJmx0OyZsdDsgQVRUUl9VSUQpKSB7PGJy
Pg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgbXAtJmd0O2F0dHJpYnV0ZV9mbGFncyB8PSAoMSAm
bHQ7Jmx0OyBBVFRSX1VJRCk7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgbXAtJmd0O3Vp
ZCA9IGNvbmYtJmd0O3VpZDs8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBjb25kbG9nKDMs
ICZxdW90O3VpZCA9ICV1IChjb25maWcgZmlsZSBkZWZhdWx0KSZxdW90OywgbXAtJmd0O3VpZCk7
PGJyPg0KLcKgIMKgIMKgIMKgfTxicj4NCi3CoCDCoCDCoCDCoGVsc2U8YnI+DQotwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqBtcC0mZ3Q7YXR0cmlidXRlX2ZsYWdzICZhbXA7PSB+KDEgJmx0OyZsdDsg
QVRUUl9VSUQpOzxicj4NCivCoCDCoCDCoCDCoGNoYXIgKm9yaWdpbjs8YnI+DQorPGJyPg0KK8Kg
IMKgIMKgIMKgc2V0X2F0dHJfbXBlKHVpZCwgQVRUUl9VSUQpOzxicj4NCivCoCDCoCDCoCDCoHNl
dF9hdHRyX2NvbmYodWlkLCBBVFRSX1VJRCk7PGJyPg0KK8KgIMKgIMKgIMKgbXAtJmd0O2F0dHJp
YnV0ZV9mbGFncyAmYW1wOz0gfigxICZsdDsmbHQ7IEFUVFJfVUlEKTs8YnI+DQorwqAgwqAgwqAg
wqByZXR1cm4gMDs8YnI+DQorb3V0Ojxicj4NCivCoCDCoCDCoCDCoGNvbmRsb2coMywgJnF1b3Q7
JXM6IHVpZCA9IDAlbyAlcyZxdW90OywgbXAtJmd0O2FsaWFzLCBtcC0mZ3Q7dWlkLCBvcmlnaW4p
Ozxicj4NCsKgIMKgIMKgIMKgIHJldHVybiAwOzxicj4NCsKgfTxicj4NCjxicj4NCsKgZXh0ZXJu
IGludDxicj4NCsKgc2VsZWN0X2dpZCAoc3RydWN0IG11bHRpcGF0aCAqbXApPGJyPg0KwqB7PGJy
Pg0KLcKgIMKgIMKgIMKgaWYgKG1wLSZndDttcGUgJmFtcDsmYW1wOyAobXAtJmd0O21wZS0mZ3Q7
YXR0cmlidXRlX2ZsYWdzICZhbXA7ICgxICZsdDsmbHQ7IEFUVFJfR0lEKSkpIHs8YnI+DQotwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqBtcC0mZ3Q7YXR0cmlidXRlX2ZsYWdzIHw9ICgxICZsdDsmbHQ7
IEFUVFJfR0lEKTs8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBtcC0mZ3Q7Z2lkID0gbXAt
Jmd0O21wZS0mZ3Q7Z2lkOzxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoGNvbmRsb2coMywg
JnF1b3Q7Z2lkID0gJXUgKExVTiBzZXR0aW5nKSZxdW90OywgbXAtJmd0O2dpZCk7PGJyPg0KLcKg
IMKgIMKgIMKgfTxicj4NCi3CoCDCoCDCoCDCoGVsc2UgaWYgKGNvbmYtJmd0O2F0dHJpYnV0ZV9m
bGFncyAmYW1wOyAoMSAmbHQ7Jmx0OyBBVFRSX0dJRCkpIHs8YnI+DQotwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqBtcC0mZ3Q7YXR0cmlidXRlX2ZsYWdzIHw9ICgxICZsdDsmbHQ7IEFUVFJfR0lEKTs8
YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBtcC0mZ3Q7Z2lkID0gY29uZi0mZ3Q7Z2lkOzxi
cj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoGNvbmRsb2coMywgJnF1b3Q7Z2lkID0gJXUgKGNv
bmZpZyBmaWxlIGRlZmF1bHQpJnF1b3Q7LCBtcC0mZ3Q7Z2lkKTs8YnI+DQotwqAgwqAgwqAgwqB9
PGJyPg0KLcKgIMKgIMKgIMKgZWxzZTxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoG1wLSZn
dDthdHRyaWJ1dGVfZmxhZ3MgJmFtcDs9IH4oMSAmbHQ7Jmx0OyBBVFRSX0dJRCk7PGJyPg0KK8Kg
IMKgIMKgIMKgY2hhciAqb3JpZ2luOzxicj4NCis8YnI+DQorwqAgwqAgwqAgwqBzZXRfYXR0cl9t
cGUoZ2lkLCBBVFRSX0dJRCk7PGJyPg0KK8KgIMKgIMKgIMKgc2V0X2F0dHJfY29uZihnaWQsIEFU
VFJfR0lEKTs8YnI+DQorwqAgwqAgwqAgwqBtcC0mZ3Q7YXR0cmlidXRlX2ZsYWdzICZhbXA7PSB+
KDEgJmx0OyZsdDsgQVRUUl9HSUQpOzxicj4NCivCoCDCoCDCoCDCoHJldHVybiAwOzxicj4NCitv
dXQ6PGJyPg0KK8KgIMKgIMKgIMKgY29uZGxvZygzLCAmcXVvdDslczogZ2lkID0gMCVvICVzJnF1
b3Q7LCBtcC0mZ3Q7YWxpYXMsIG1wLSZndDtnaWQsIG9yaWdpbik7PGJyPg0KwqAgwqAgwqAgwqAg
cmV0dXJuIDA7PGJyPg0KwqB9PGJyPg0KPGJyPg0KQEAgLTkxLDE1MSArMTI3LDgwIEBAIHNlbGVj
dF9naWQgKHN0cnVjdCBtdWx0aXBhdGggKm1wKTxicj4NCsKgZXh0ZXJuIGludDxicj4NCsKgc2Vs
ZWN0X3JyX3dlaWdodCAoc3RydWN0IG11bHRpcGF0aCAqIG1wKTxicj4NCsKgezxicj4NCi3CoCDC
oCDCoCDCoGlmIChtcC0mZ3Q7bXBlICZhbXA7JmFtcDsgbXAtJmd0O21wZS0mZ3Q7cnJfd2VpZ2h0
KSB7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgbXAtJmd0O3JyX3dlaWdodCA9IG1wLSZn
dDttcGUtJmd0O3JyX3dlaWdodDs8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBjb25kbG9n
KDMsICZxdW90OyVzOiBycl93ZWlnaHQgPSAlaSAoTFVOIHNldHRpbmcpJnF1b3Q7LDxicj4NCi3C
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoG1wLSZndDthbGlhcywgbXAtJmd0O3Jy
X3dlaWdodCk7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgcmV0dXJuIDA7PGJyPg0KLcKg
IMKgIMKgIMKgfTxicj4NCi3CoCDCoCDCoCDCoGlmIChtcC0mZ3Q7aHdlICZhbXA7JmFtcDsgbXAt
Jmd0O2h3ZS0mZ3Q7cnJfd2VpZ2h0KSB7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgbXAt
Jmd0O3JyX3dlaWdodCA9IG1wLSZndDtod2UtJmd0O3JyX3dlaWdodDs8YnI+DQotwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqBjb25kbG9nKDMsICZxdW90OyVzOiBycl93ZWlnaHQgPSAlaSAoY29udHJv
bGxlciBzZXR0aW5nKSZxdW90Oyw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqBtcC0mZ3Q7YWxpYXMsIG1wLSZndDtycl93ZWlnaHQpOzxicj4NCi3CoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoHJldHVybiAwOzxicj4NCi3CoCDCoCDCoCDCoH08YnI+DQotwqAgwqAgwqAgwqBp
ZiAoY29uZi0mZ3Q7cnJfd2VpZ2h0KSB7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgbXAt
Jmd0O3JyX3dlaWdodCA9IGNvbmYtJmd0O3JyX3dlaWdodDs8YnI+DQotwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqBjb25kbG9nKDMsICZxdW90OyVzOiBycl93ZWlnaHQgPSAlaSAoY29uZmlnIGZpbGUg
ZGVmYXVsdCkmcXVvdDssPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
bXAtJmd0O2FsaWFzLCBtcC0mZ3Q7cnJfd2VpZ2h0KTs8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqByZXR1cm4gMDs8YnI+DQotwqAgwqAgwqAgwqB9PGJyPg0KLcKgIMKgIMKgIMKgbXAtJmd0
O3JyX3dlaWdodCA9IFJSX1dFSUdIVF9OT05FOzxicj4NCi3CoCDCoCDCoCDCoGNvbmRsb2coMywg
JnF1b3Q7JXM6IHJyX3dlaWdodCA9ICVpIChpbnRlcm5hbCBkZWZhdWx0KSZxdW90Oyw8YnI+DQot
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBtcC0mZ3Q7YWxpYXMsIG1wLSZndDtycl93ZWlnaHQpOzxi
cj4NCivCoCDCoCDCoCDCoGNoYXIgKm9yaWdpbiwgYnVmZlsxM107PGJyPg0KKzxicj4NCivCoCDC
oCDCoCDCoG1wX3NldF9tcGUocnJfd2VpZ2h0KTs8YnI+DQorwqAgwqAgwqAgwqBtcF9zZXRfaHdl
KHJyX3dlaWdodCk7PGJyPg0KK8KgIMKgIMKgIMKgbXBfc2V0X2NvbmYocnJfd2VpZ2h0KTs8YnI+
DQorwqAgwqAgwqAgwqBtcF9zZXRfZGVmYXVsdChycl93ZWlnaHQsIFJSX1dFSUdIVF9OT05FKTs8
YnI+DQorb3V0Ojxicj4NCivCoCDCoCDCoCDCoHByaW50X3JyX3dlaWdodChidWZmLCAxMywgJmFt
cDttcC0mZ3Q7cnJfd2VpZ2h0KTs8YnI+DQorwqAgwqAgwqAgwqBjb25kbG9nKDMsICZxdW90OyVz
OiBycl93ZWlnaHQgPSAlcyAlcyZxdW90OywgbXAtJmd0O2FsaWFzLCBidWZmLCBvcmlnaW4pOzxi
cj4NCsKgIMKgIMKgIMKgIHJldHVybiAwOzxicj4NCsKgfTxicj4NCjxicj4NCsKgZXh0ZXJuIGlu
dDxicj4NCsKgc2VsZWN0X3BnZmFpbGJhY2sgKHN0cnVjdCBtdWx0aXBhdGggKiBtcCk8YnI+DQrC
oHs8YnI+DQotwqAgwqAgwqAgwqBpZiAobXAtJmd0O21wZSAmYW1wOyZhbXA7IG1wLSZndDttcGUt
Jmd0O3BnZmFpbGJhY2sgIT0gRkFJTEJBQ0tfVU5ERUYpIHs8YnI+DQotwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqBtcC0mZ3Q7cGdmYWlsYmFjayA9IG1wLSZndDttcGUtJmd0O3BnZmFpbGJhY2s7PGJy
Pg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgY29uZGxvZygzLCAmcXVvdDslczogcGdmYWlsYmFj
ayA9ICVpIChMVU4gc2V0dGluZykmcXVvdDssPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgbXAtJmd0O2FsaWFzLCBtcC0mZ3Q7cGdmYWlsYmFjayk7PGJyPg0KLcKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgcmV0dXJuIDA7PGJyPg0KLcKgIMKgIMKgIMKgfTxicj4NCi3CoCDC
oCDCoCDCoGlmIChtcC0mZ3Q7aHdlICZhbXA7JmFtcDsgbXAtJmd0O2h3ZS0mZ3Q7cGdmYWlsYmFj
ayAhPSBGQUlMQkFDS19VTkRFRikgezxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoG1wLSZn
dDtwZ2ZhaWxiYWNrID0gbXAtJmd0O2h3ZS0mZ3Q7cGdmYWlsYmFjazs8YnI+DQotwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqBjb25kbG9nKDMsICZxdW90OyVzOiBwZ2ZhaWxiYWNrID0gJWkgKGNvbnRy
b2xsZXIgc2V0dGluZykmcXVvdDssPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgbXAtJmd0O2FsaWFzLCBtcC0mZ3Q7cGdmYWlsYmFjayk7PGJyPg0KLcKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgcmV0dXJuIDA7PGJyPg0KLcKgIMKgIMKgIMKgfTxicj4NCi3CoCDCoCDCoCDC
oGlmIChjb25mLSZndDtwZ2ZhaWxiYWNrICE9IEZBSUxCQUNLX1VOREVGKSB7PGJyPg0KLcKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgbXAtJmd0O3BnZmFpbGJhY2sgPSBjb25mLSZndDtwZ2ZhaWxiYWNr
Ozxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoGNvbmRsb2coMywgJnF1b3Q7JXM6IHBnZmFp
bGJhY2sgPSAlaSAoY29uZmlnIGZpbGUgZGVmYXVsdCkmcXVvdDssPGJyPg0KLcKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgbXAtJmd0O2FsaWFzLCBtcC0mZ3Q7cGdmYWlsYmFjayk7
PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgcmV0dXJuIDA7PGJyPg0KLcKgIMKgIMKgIMKg
fTxicj4NCi3CoCDCoCDCoCDCoG1wLSZndDtwZ2ZhaWxiYWNrID0gREVGQVVMVF9GQUlMQkFDSzs8
YnI+DQotwqAgwqAgwqAgwqBjb25kbG9nKDMsICZxdW90OyVzOiBwZ2ZhaWxvdmVyID0gJWkgKGlu
dGVybmFsIGRlZmF1bHQpJnF1b3Q7LDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoG1wLSZn
dDthbGlhcywgbXAtJmd0O3BnZmFpbGJhY2spOzxicj4NCivCoCDCoCDCoCDCoGNoYXIgKm9yaWdp
biwgYnVmZlsxM107PGJyPg0KKzxicj4NCivCoCDCoCDCoCDCoG1wX3NldF9tcGUocGdmYWlsYmFj
ayk7PGJyPg0KK8KgIMKgIMKgIMKgbXBfc2V0X2h3ZShwZ2ZhaWxiYWNrKTs8YnI+DQorwqAgwqAg
wqAgwqBtcF9zZXRfY29uZihwZ2ZhaWxiYWNrKTs8YnI+DQorwqAgwqAgwqAgwqBtcF9zZXRfZGVm
YXVsdChwZ2ZhaWxiYWNrLCBERUZBVUxUX0ZBSUxCQUNLKTs8YnI+DQorb3V0Ojxicj4NCivCoCDC
oCDCoCDCoHByaW50X3BnZmFpbGJhY2soYnVmZiwgMTMsICZhbXA7bXAtJmd0O3BnZmFpbGJhY2sp
Ozxicj4NCivCoCDCoCDCoCDCoGNvbmRsb2coMywgJnF1b3Q7JXM6IGZhaWxiYWNrID0gJXMgJXMm
cXVvdDssIG1wLSZndDthbGlhcywgYnVmZiwgb3JpZ2luKTs8YnI+DQrCoCDCoCDCoCDCoCByZXR1
cm4gMDs8YnI+DQrCoH08YnI+DQo8YnI+DQrCoGV4dGVybiBpbnQ8YnI+DQrCoHNlbGVjdF9wZ3Bv
bGljeSAoc3RydWN0IG11bHRpcGF0aCAqIG1wKTxicj4NCsKgezxicj4NCi3CoCDCoCDCoCDCoGNo
YXIgcGdwb2xpY3lfbmFtZVtQT0xJQ1lfTkFNRV9TSVpFXTs8YnI+DQorwqAgwqAgwqAgwqBjaGFy
ICpvcmlnaW4sIGJ1ZmZbUE9MSUNZX05BTUVfU0laRV07PGJyPg0KPGJyPg0KwqAgwqAgwqAgwqAg
aWYgKGNvbmYtJmd0O3BncG9saWN5X2ZsYWcgJmd0OyAwKSB7PGJyPg0KwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgbXAtJmd0O3BncG9saWN5ID0gY29uZi0mZ3Q7cGdwb2xpY3lfZmxhZzs8YnI+DQot
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBtcC0mZ3Q7cGdwb2xpY3lmbiA9IHBncG9saWNpZXNbbXAt
Jmd0O3BncG9saWN5XTs8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBnZXRfcGdwb2xpY3lf
bmFtZShwZ3BvbGljeV9uYW1lLCBQT0xJQ1lfTkFNRV9TSVpFLDxicj4NCi3CoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoG1wLSZndDtwZ3BvbGljeSk7PGJy
Pg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgY29uZGxvZygzLCAmcXVvdDslczogcGdwb2xpY3kg
PSAlcyAoY21kIGxpbmUgZmxhZykmcXVvdDssPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgbXAtJmd0O2FsaWFzLCBwZ3BvbGljeV9uYW1lKTs8YnI+DQotwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqByZXR1cm4gMDs8YnI+DQotwqAgwqAgwqAgwqB9PGJyPg0KLcKgIMKgIMKg
IMKgaWYgKG1wLSZndDttcGUgJmFtcDsmYW1wOyBtcC0mZ3Q7bXBlLSZndDtwZ3BvbGljeSAmZ3Q7
IDApIHs8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBtcC0mZ3Q7cGdwb2xpY3kgPSBtcC0m
Z3Q7bXBlLSZndDtwZ3BvbGljeTs8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBtcC0mZ3Q7
cGdwb2xpY3lmbiA9IHBncG9saWNpZXNbbXAtJmd0O3BncG9saWN5XTs8YnI+DQotwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqBnZXRfcGdwb2xpY3lfbmFtZShwZ3BvbGljeV9uYW1lLCBQT0xJQ1lfTkFN
RV9TSVpFLDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoG1wLSZndDtwZ3BvbGljeSk7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgY29u
ZGxvZygzLCAmcXVvdDslczogcGdwb2xpY3kgPSAlcyAoTFVOIHNldHRpbmcpJnF1b3Q7LDxicj4N
Ci3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoG1wLSZndDthbGlhcywgcGdwb2xp
Y3lfbmFtZSk7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgcmV0dXJuIDA7PGJyPg0KLcKg
IMKgIMKgIMKgfTxicj4NCi3CoCDCoCDCoCDCoGlmIChtcC0mZ3Q7aHdlICZhbXA7JmFtcDsgbXAt
Jmd0O2h3ZS0mZ3Q7cGdwb2xpY3kgJmd0OyAwKSB7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgbXAtJmd0O3BncG9saWN5ID0gbXAtJmd0O2h3ZS0mZ3Q7cGdwb2xpY3k7PGJyPg0KLcKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgbXAtJmd0O3BncG9saWN5Zm4gPSBwZ3BvbGljaWVzW21wLSZndDtw
Z3BvbGljeV07PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgZ2V0X3BncG9saWN5X25hbWUo
cGdwb2xpY3lfbmFtZSwgUE9MSUNZX05BTUVfU0laRSw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBtcC0mZ3Q7cGdwb2xpY3kpOzxicj4NCi3C
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoGNvbmRsb2coMywgJnF1b3Q7JXM6IHBncG9saWN5ID0gJXMg
KGNvbnRyb2xsZXIgc2V0dGluZykmcXVvdDssPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgbXAtJmd0O2FsaWFzLCBwZ3BvbGljeV9uYW1lKTs8YnI+DQotwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqByZXR1cm4gMDs8YnI+DQotwqAgwqAgwqAgwqB9PGJyPg0KLcKgIMKgIMKg
IMKgaWYgKGNvbmYtJmd0O3BncG9saWN5ICZndDsgMCkgezxicj4NCi3CoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoG1wLSZndDtwZ3BvbGljeSA9IGNvbmYtJmd0O3BncG9saWN5Ozxicj4NCi3CoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoG1wLSZndDtwZ3BvbGljeWZuID0gcGdwb2xpY2llc1ttcC0mZ3Q7cGdw
b2xpY3ldOzxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoGdldF9wZ3BvbGljeV9uYW1lKHBn
cG9saWN5X25hbWUsIFBPTElDWV9OQU1FX1NJWkUsPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgbXAtJmd0O3BncG9saWN5KTs8YnI+DQotwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqBjb25kbG9nKDMsICZxdW90OyVzOiBwZ3BvbGljeSA9ICVzIChj
b25maWcgZmlsZSBkZWZhdWx0KSZxdW90Oyw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqBtcC0mZ3Q7YWxpYXMsIHBncG9saWN5X25hbWUpOzxicj4NCi3CoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoHJldHVybiAwOzxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoG9yaWdp
biA9ICZxdW90OyhjbWQgbGluZSBmbGFnKSZxdW90Ozs8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqBnb3RvIG91dDs8YnI+DQrCoCDCoCDCoCDCoCB9PGJyPg0KLcKgIMKgIMKgIMKgbXAtJmd0
O3BncG9saWN5ID0gREVGQVVMVF9QR1BPTElDWTs8YnI+DQorwqAgwqAgwqAgwqBtcF9zZXRfbXBl
KHBncG9saWN5KTs8YnI+DQorwqAgwqAgwqAgwqBtcF9zZXRfaHdlKHBncG9saWN5KTs8YnI+DQor
wqAgwqAgwqAgwqBtcF9zZXRfY29uZihwZ3BvbGljeSk7PGJyPg0KK8KgIMKgIMKgIMKgbXBfc2V0
X2RlZmF1bHQocGdwb2xpY3ksIERFRkFVTFRfUEdQT0xJQ1kpOzxicj4NCitvdXQ6PGJyPg0KwqAg
wqAgwqAgwqAgbXAtJmd0O3BncG9saWN5Zm4gPSBwZ3BvbGljaWVzW21wLSZndDtwZ3BvbGljeV07
PGJyPg0KLcKgIMKgIMKgIMKgZ2V0X3BncG9saWN5X25hbWUocGdwb2xpY3lfbmFtZSwgUE9MSUNZ
X05BTUVfU0laRSwgbXAtJmd0O3BncG9saWN5KTs8YnI+DQotwqAgwqAgwqAgwqBjb25kbG9nKDMs
ICZxdW90OyVzOiBwZ3BvbGljeSA9ICVzIChpbnRlcm5hbCBkZWZhdWx0KSZxdW90Oyw8YnI+DQot
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBtcC0mZ3Q7YWxpYXMsIHBncG9saWN5X25hbWUpOzxicj4N
CivCoCDCoCDCoCDCoGdldF9wZ3BvbGljeV9uYW1lKGJ1ZmYsIFBPTElDWV9OQU1FX1NJWkUsIG1w
LSZndDtwZ3BvbGljeSk7PGJyPg0KK8KgIMKgIMKgIMKgY29uZGxvZygzLCAmcXVvdDslczogcGF0
aF9ncm91cGluZ19wb2xpY3kgPSAlcyAlcyZxdW90OywgbXAtJmd0O2FsaWFzLCBidWZmLCBvcmln
aW4pOzxicj4NCsKgIMKgIMKgIMKgIHJldHVybiAwOzxicj4NCsKgfTxicj4NCjxicj4NCsKgZXh0
ZXJuIGludDxicj4NCsKgc2VsZWN0X3NlbGVjdG9yIChzdHJ1Y3QgbXVsdGlwYXRoICogbXApPGJy
Pg0KwqB7PGJyPg0KLcKgIMKgIMKgIMKgaWYgKG1wLSZndDttcGUgJmFtcDsmYW1wOyBtcC0mZ3Q7
bXBlLSZndDtzZWxlY3Rvcikgezxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoG1wLSZndDtz
ZWxlY3RvciA9IG1wLSZndDttcGUtJmd0O3NlbGVjdG9yOzxicj4NCi3CoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoGNvbmRsb2coMywgJnF1b3Q7JXM6IHNlbGVjdG9yID0gJXMgKExVTiBzZXR0aW5nKSZx
dW90Oyw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBtcC0mZ3Q7YWxp
YXMsIG1wLSZndDtzZWxlY3Rvcik7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgcmV0dXJu
IDA7PGJyPg0KLcKgIMKgIMKgIMKgfTxicj4NCi3CoCDCoCDCoCDCoGlmIChtcC0mZ3Q7aHdlICZh
bXA7JmFtcDsgbXAtJmd0O2h3ZS0mZ3Q7c2VsZWN0b3IpIHs8YnI+DQotwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqBtcC0mZ3Q7c2VsZWN0b3IgPSBtcC0mZ3Q7aHdlLSZndDtzZWxlY3Rvcjs8YnI+DQot
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBjb25kbG9nKDMsICZxdW90OyVzOiBzZWxlY3RvciA9ICVz
IChjb250cm9sbGVyIHNldHRpbmcpJnF1b3Q7LDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoG1wLSZndDthbGlhcywgbXAtJmd0O3NlbGVjdG9yKTs8YnI+DQotwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqByZXR1cm4gMDs8YnI+DQotwqAgwqAgwqAgwqB9PGJyPg0KLcKgIMKg
IMKgIMKgaWYgKGNvbmYtJmd0O3NlbGVjdG9yKSB7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgbXAtJmd0O3NlbGVjdG9yID0gY29uZi0mZ3Q7c2VsZWN0b3I7PGJyPg0KLcKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgY29uZGxvZygzLCAmcXVvdDslczogc2VsZWN0b3IgPSAlcyAoY29uZmlnIGZp
bGUgZGVmYXVsdCkmcXVvdDssPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgbXAtJmd0O2FsaWFzLCBtcC0mZ3Q7c2VsZWN0b3IpOzxicj4NCi3CoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoHJldHVybiAwOzxicj4NCi3CoCDCoCDCoCDCoH08YnI+DQotwqAgwqAgwqAgwqBtcC0m
Z3Q7c2VsZWN0b3IgPSBzZXRfZGVmYXVsdChERUZBVUxUX1NFTEVDVE9SKTs8YnI+DQotwqAgwqAg
wqAgwqBjb25kbG9nKDMsICZxdW90OyVzOiBzZWxlY3RvciA9ICVzIChpbnRlcm5hbCBkZWZhdWx0
KSZxdW90Oyw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBtcC0mZ3Q7YWxpYXMsIG1wLSZn
dDtzZWxlY3Rvcik7PGJyPg0KK8KgIMKgIMKgIMKgY2hhciAqb3JpZ2luOzxicj4NCis8YnI+DQor
wqAgwqAgwqAgwqBtcF9zZXRfbXBlKHNlbGVjdG9yKTs8YnI+DQorwqAgwqAgwqAgwqBtcF9zZXRf
aHdlKHNlbGVjdG9yKTs8YnI+DQorwqAgwqAgwqAgwqBtcF9zZXRfY29uZihzZWxlY3Rvcik7PGJy
Pg0KK8KgIMKgIMKgIMKgbXBfc2V0X2RlZmF1bHQoc2VsZWN0b3IsIHNldF9kZWZhdWx0KERFRkFV
TFRfU0VMRUNUT1IpKTs8YnI+DQorb3V0Ojxicj4NCivCoCDCoCDCoCDCoGNvbmRsb2coMywgJnF1
b3Q7JXM6IHBhdGhfc2VsZWN0b3IgPSBcJnF1b3Q7JXNcJnF1b3Q7ICVzJnF1b3Q7LCBtcC0mZ3Q7
YWxpYXMsIG1wLSZndDtzZWxlY3Rvciw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBvcmln
aW4pOzxicj4NCsKgIMKgIMKgIMKgIHJldHVybiAwOzxicj4NCsKgfTxicj4NCjxicj4NCsKgc3Rh
dGljIHZvaWQ8YnI+DQrCoHNlbGVjdF9hbGlhc19wcmVmaXggKHN0cnVjdCBtdWx0aXBhdGggKiBt
cCk8YnI+DQrCoHs8YnI+DQotwqAgwqAgwqAgwqBpZiAobXAtJmd0O2h3ZSAmYW1wOyZhbXA7IG1w
LSZndDtod2UtJmd0O2FsaWFzX3ByZWZpeCkgezxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oG1wLSZndDthbGlhc19wcmVmaXggPSBtcC0mZ3Q7aHdlLSZndDthbGlhc19wcmVmaXg7PGJyPg0K
LcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgY29uZGxvZygzLCAmcXVvdDslczogYWxpYXNfcHJlZml4
ID0gJXMgKGNvbnRyb2xsZXIgc2V0dGluZykmcXVvdDssPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgbXAtJmd0O3d3aWQsIG1wLSZndDthbGlhc19wcmVmaXgpOzxicj4N
Ci3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoHJldHVybjs8YnI+DQotwqAgwqAgwqAgwqB9PGJyPg0K
LcKgIMKgIMKgIMKgaWYgKGNvbmYtJmd0O2FsaWFzX3ByZWZpeCkgezxicj4NCi3CoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoG1wLSZndDthbGlhc19wcmVmaXggPSBjb25mLSZndDthbGlhc19wcmVmaXg7
PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgY29uZGxvZygzLCAmcXVvdDslczogYWxpYXNf
cHJlZml4ID0gJXMgKGNvbmZpZyBmaWxlIGRlZmF1bHQpJnF1b3Q7LDxicj4NCi3CoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoG1wLSZndDt3d2lkLCBtcC0mZ3Q7YWxpYXNfcHJlZml4
KTs8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqByZXR1cm47PGJyPg0KLcKgIMKgIMKgIMKg
fTxicj4NCi3CoCDCoCDCoCDCoG1wLSZndDthbGlhc19wcmVmaXggPSBzZXRfZGVmYXVsdChERUZB
VUxUX0FMSUFTX1BSRUZJWCk7PGJyPg0KLcKgIMKgIMKgIMKgY29uZGxvZygzLCAmcXVvdDslczog
YWxpYXNfcHJlZml4ID0gJXMgKGludGVybmFsIGRlZmF1bHQpJnF1b3Q7LDxicj4NCi3CoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoG1wLSZndDt3d2lkLCBtcC0mZ3Q7YWxpYXNfcHJlZml4KTs8YnI+DQor
wqAgwqAgwqAgwqBjaGFyICpvcmlnaW47PGJyPg0KKzxicj4NCivCoCDCoCDCoCDCoG1wX3NldF9o
d2UoYWxpYXNfcHJlZml4KTs8YnI+DQorwqAgwqAgwqAgwqBtcF9zZXRfY29uZihhbGlhc19wcmVm
aXgpOzxicj4NCivCoCDCoCDCoCDCoG1wX3NldF9kZWZhdWx0KGFsaWFzX3ByZWZpeCwgREVGQVVM
VF9BTElBU19QUkVGSVgpOzxicj4NCitvdXQ6PGJyPg0KK8KgIMKgIMKgIMKgY29uZGxvZygzLCAm
cXVvdDslczogYWxpYXNfcHJlZml4ID0gJXMgJXMmcXVvdDssIG1wLSZndDt3d2lkLCBtcC0mZ3Q7
YWxpYXNfcHJlZml4LDxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoG9yaWdpbik7PGJyPg0K
wqB9PGJyPg0KPGJyPg0KwqBzdGF0aWMgaW50PGJyPg0KQEAgLTI1Myw4ICsyMTgsMTEgQEAgd2Fu
dF91c2VyX2ZyaWVuZGx5X25hbWVzKHN0cnVjdCBtdWx0aXBhdGggKiBtcCk8YnI+DQrCoGV4dGVy
biBpbnQ8YnI+DQrCoHNlbGVjdF9hbGlhcyAoc3RydWN0IG11bHRpcGF0aCAqIG1wKTxicj4NCsKg
ezxicj4NCivCoCDCoCDCoCDCoGNoYXIgKm9yaWdpbjs8YnI+DQorPGJyPg0KwqAgwqAgwqAgwqAg
aWYgKG1wLSZndDttcGUgJmFtcDsmYW1wOyBtcC0mZ3Q7bXBlLSZndDthbGlhcykgezxicj4NCsKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIG1wLSZndDthbGlhcyA9IFNUUkRVUChtcC0mZ3Q7bXBlLSZn
dDthbGlhcyk7PGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgb3JpZ2luID0gJnF1b3Q7KExV
TiBzZXR0aW5nKSZxdW90Ozs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBnb3RvIG91dDs8
YnI+DQrCoCDCoCDCoCDCoCB9PGJyPg0KPGJyPg0KQEAgLTI2OSwzOSArMjM3LDM3IEBAIHNlbGVj
dF9hbGlhcyAoc3RydWN0IG11bHRpcGF0aCAqIG1wKTxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIG1wLSZndDthbGlhc19vbGQsIG1wLSZndDthbGlh
c19wcmVmaXgsPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgY29uZi0mZ3Q7YmluZGluZ3NfcmVhZF9vbmx5KTs8YnI+DQrCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCBtZW1zZXQgKG1wLSZndDthbGlhc19vbGQsIDAsIFdXSURfU0laRSk7PGJyPg0KK8Kg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgb3JpZ2luID0gJnF1b3Q7KHVzaW5nIGV4aXN0aW5nIGFsaWFz
KSZxdW90Ozs8YnI+DQrCoCDCoCDCoCDCoCB9PGJyPg0KPGJyPg0KLcKgIMKgIMKgIMKgaWYgKG1w
LSZndDthbGlhcyA9PSBOVUxMKTxicj4NCivCoCDCoCDCoCDCoGlmIChtcC0mZ3Q7YWxpYXMgPT0g
TlVMTCkgezxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIG1wLSZndDthbGlhcyA9IGdldF91
c2VyX2ZyaWVuZGx5X2FsaWFzKG1wLSZndDt3d2lkLDxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGNvbmYtJmd0O2JpbmRpbmdzX2ZpbGUsIG1wLSZn
dDthbGlhc19wcmVmaXgsIGNvbmYtJmd0O2JpbmRpbmdzX3JlYWRfb25seSk7PGJyPg0KK8KgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgb3JpZ2luID0gJnF1b3Q7KHVzZXJfZnJpZW5kbHlfbmFtZSkmcXVv
dDs7PGJyPg0KK8KgIMKgIMKgIMKgfTxicj4NCsKgb3V0Ojxicj4NCi3CoCDCoCDCoCDCoGlmICht
cC0mZ3Q7YWxpYXMgPT0gTlVMTCk8YnI+DQorwqAgwqAgwqAgwqBpZiAobXAtJmd0O2FsaWFzID09
IE5VTEwpIHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBtcC0mZ3Q7YWxpYXMgPSBTVFJE
VVAobXAtJmd0O3d3aWQpOzxicj4NCi08YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBvcmln
aW4gPSAmcXVvdDsoZGVmYXVsdCB0byB3d2lkKSZxdW90Ozs8YnI+DQorwqAgwqAgwqAgwqB9PGJy
Pg0KK8KgIMKgIMKgIMKgaWYgKG1wLSZndDthbGlhcyk8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqBjb25kbG9nKDMsICZxdW90OyVzOiBhbGlhcyA9ICVzICVzJnF1b3Q7LCBtcC0mZ3Q7d3dp
ZCwgbXAtJmd0O2FsaWFzLCBvcmlnaW4pOzxicj4NCsKgIMKgIMKgIMKgIHJldHVybiBtcC0mZ3Q7
YWxpYXMgPyAwIDogMTs8YnI+DQrCoH08YnI+DQo8YnI+DQrCoGV4dGVybiBpbnQ8YnI+DQrCoHNl
bGVjdF9mZWF0dXJlcyAoc3RydWN0IG11bHRpcGF0aCAqIG1wKTxicj4NCsKgezxicj4NCi3CoCDC
oCDCoCDCoHN0cnVjdCBtcGVudHJ5ICogbXBlOzxicj4NCsKgIMKgIMKgIMKgIGNoYXIgKm9yaWdp
bjs8YnI+DQo8YnI+DQotwqAgwqAgwqAgwqBpZiAoKG1wZSA9IGZpbmRfbXBlKG1wLSZndDt3d2lk
KSkgJmFtcDsmYW1wOyBtcGUtJmd0O2ZlYXR1cmVzKSB7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgbXAtJmd0O2ZlYXR1cmVzID0gU1RSRFVQKG1wZS0mZ3Q7ZmVhdHVyZXMpOzxicj4NCi3C
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoG9yaWdpbiA9ICZxdW90O0xVTiBzZXR0aW5nJnF1b3Q7Ozxi
cj4NCi3CoCDCoCDCoCDCoH0gZWxzZSBpZiAobXAtJmd0O2h3ZSAmYW1wOyZhbXA7IG1wLSZndDto
d2UtJmd0O2ZlYXR1cmVzKSB7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgbXAtJmd0O2Zl
YXR1cmVzID0gU1RSRFVQKG1wLSZndDtod2UtJmd0O2ZlYXR1cmVzKTs8YnI+DQotwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqBvcmlnaW4gPSAmcXVvdDtjb250cm9sbGVyIHNldHRpbmcmcXVvdDs7PGJy
Pg0KLcKgIMKgIMKgIMKgfSBlbHNlIGlmIChjb25mLSZndDtmZWF0dXJlcykgezxicj4NCi3CoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoG1wLSZndDtmZWF0dXJlcyA9IFNUUkRVUChjb25mLSZndDtmZWF0
dXJlcyk7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgb3JpZ2luID0gJnF1b3Q7Y29uZmln
IGZpbGUgZGVmYXVsdCZxdW90Ozs8YnI+DQotwqAgwqAgwqAgwqB9IGVsc2Ugezxicj4NCi3CoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoG1wLSZndDtmZWF0dXJlcyA9IHNldF9kZWZhdWx0KERFRkFVTFRf
RkVBVFVSRVMpOzxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoG9yaWdpbiA9ICZxdW90O2lu
dGVybmFsIGRlZmF1bHQmcXVvdDs7PGJyPg0KLcKgIMKgIMKgIMKgfTxicj4NCi3CoCDCoCDCoCDC
oGNvbmRsb2coMywgJnF1b3Q7JXM6IGZlYXR1cmVzID0gJXMgKCVzKSZxdW90Oyw8YnI+DQotwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqBtcC0mZ3Q7YWxpYXMsIG1wLSZndDtmZWF0dXJlcywgb3JpZ2lu
KTs8YnI+DQorwqAgwqAgwqAgwqBtcF9zZXRfbXBlKGZlYXR1cmVzKTs8YnI+DQorwqAgwqAgwqAg
wqBtcF9zZXRfaHdlKGZlYXR1cmVzKTs8YnI+DQorwqAgwqAgwqAgwqBtcF9zZXRfY29uZihmZWF0
dXJlcyk7PGJyPg0KK8KgIMKgIMKgIMKgbXBfc2V0X2RlZmF1bHQoZmVhdHVyZXMsIERFRkFVTFRf
RkVBVFVSRVMpOzxicj4NCitvdXQ6PGJyPg0KK8KgIMKgIMKgIMKgbXAtJmd0O2ZlYXR1cmVzID0g
U1RSRFVQKG1wLSZndDtmZWF0dXJlcyk7PGJyPg0KK8KgIMKgIMKgIMKgY29uZGxvZygzLCAmcXVv
dDslczogZmVhdHVyZXMgPSBcJnF1b3Q7JXNcJnF1b3Q7ICVzJnF1b3Q7LCBtcC0mZ3Q7YWxpYXMs
IG1wLSZndDtmZWF0dXJlcywgb3JpZ2luKTs8YnI+DQorPGJyPg0KwqAgwqAgwqAgwqAgaWYgKHN0
cnN0cihtcC0mZ3Q7ZmVhdHVyZXMsICZxdW90O3F1ZXVlX2lmX25vX3BhdGgmcXVvdDspKSB7PGJy
Pg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgaWYgKG1wLSZndDtub19wYXRoX3JldHJ5ID09IE5P
X1BBVEhfUkVUUllfVU5ERUYpPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgbXAtJmd0O25vX3BhdGhfcmV0cnkgPSBOT19QQVRIX1JFVFJZX1FVRVVFOzxicj4NCkBAIC0z
MTcsNDUgKzI4MywyOSBAQCBzZWxlY3RfZmVhdHVyZXMgKHN0cnVjdCBtdWx0aXBhdGggKiBtcCk8
YnI+DQrCoGV4dGVybiBpbnQ8YnI+DQrCoHNlbGVjdF9od2hhbmRsZXIgKHN0cnVjdCBtdWx0aXBh
dGggKiBtcCk8YnI+DQrCoHs8YnI+DQotwqAgwqAgwqAgwqBpZiAobXAtJmd0O2h3ZSAmYW1wOyZh
bXA7IG1wLSZndDtod2UtJmd0O2h3aGFuZGxlcikgezxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoG1wLSZndDtod2hhbmRsZXIgPSBtcC0mZ3Q7aHdlLSZndDtod2hhbmRsZXI7PGJyPg0KLcKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgY29uZGxvZygzLCAmcXVvdDslczogaHdoYW5kbGVyID0gJXMg
KGNvbnRyb2xsZXIgc2V0dGluZykmcXVvdDssPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgbXAtJmd0O2FsaWFzLCBtcC0mZ3Q7aHdoYW5kbGVyKTs8YnI+DQotwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqByZXR1cm4gMDs8YnI+DQotwqAgwqAgwqAgwqB9PGJyPg0KLcKgIMKg
IMKgIMKgaWYgKGNvbmYtJmd0O2h3aGFuZGxlcikgezxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoG1wLSZndDtod2hhbmRsZXIgPSBjb25mLSZndDtod2hhbmRsZXI7PGJyPg0KLcKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgY29uZGxvZygzLCAmcXVvdDslczogaHdoYW5kbGVyID0gJXMgKGNvbmZp
ZyBmaWxlIGRlZmF1bHQpJnF1b3Q7LDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoG1wLSZndDthbGlhcywgbXAtJmd0O2h3aGFuZGxlcik7PGJyPg0KLcKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgcmV0dXJuIDA7PGJyPg0KLcKgIMKgIMKgIMKgfTxicj4NCi3CoCDCoCDCoCDC
oG1wLSZndDtod2hhbmRsZXIgPSBzZXRfZGVmYXVsdChERUZBVUxUX0hXSEFORExFUik7PGJyPg0K
LcKgIMKgIMKgIMKgY29uZGxvZygzLCAmcXVvdDslczogaHdoYW5kbGVyID0gJXMgKGludGVybmFs
IGRlZmF1bHQpJnF1b3Q7LDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoG1wLSZndDthbGlh
cywgbXAtJmd0O2h3aGFuZGxlcik7PGJyPg0KK8KgIMKgIMKgIMKgY2hhciAqb3JpZ2luOzxicj4N
Cis8YnI+DQorwqAgwqAgwqAgwqBtcF9zZXRfaHdlKGh3aGFuZGxlcik7PGJyPg0KK8KgIMKgIMKg
IMKgbXBfc2V0X2NvbmYoaHdoYW5kbGVyKTs8YnI+DQorwqAgwqAgwqAgwqBtcF9zZXRfZGVmYXVs
dChod2hhbmRsZXIsIHNldF9kZWZhdWx0KERFRkFVTFRfSFdIQU5ETEVSKSk7PGJyPg0KK291dDo8
YnI+DQorwqAgwqAgwqAgwqBjb25kbG9nKDMsICZxdW90OyVzOiBoYXJkd2FyZV9oYW5kbGVyID0g
XCZxdW90OyVzXCZxdW90OyAlcyZxdW90OywgbXAtJmd0O2FsaWFzLCBtcC0mZ3Q7aHdoYW5kbGVy
LDxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoG9yaWdpbik7PGJyPg0KwqAgwqAgwqAgwqAg
cmV0dXJuIDA7PGJyPg0KwqB9PGJyPg0KPGJyPg0KwqBleHRlcm4gaW50PGJyPg0KwqBzZWxlY3Rf
Y2hlY2tlcihzdHJ1Y3QgcGF0aCAqcHApPGJyPg0KwqB7PGJyPg0KK8KgIMKgIMKgIMKgY2hhciAq
b3JpZ2luLCAqY2hlY2tlcl9uYW1lOzxicj4NCsKgIMKgIMKgIMKgIHN0cnVjdCBjaGVja2VyICog
YyA9ICZhbXA7cHAtJmd0O2NoZWNrZXI7PGJyPg0KPGJyPg0KLcKgIMKgIMKgIMKgaWYgKHBwLSZn
dDtod2UgJmFtcDsmYW1wOyBwcC0mZ3Q7aHdlLSZndDtjaGVja2VyX25hbWUpIHs8YnI+DQotwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqBjaGVja2VyX2dldChjLCBwcC0mZ3Q7aHdlLSZndDtjaGVja2Vy
X25hbWUpOzxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoGNvbmRsb2coMywgJnF1b3Q7JXM6
IHBhdGggY2hlY2tlciA9ICVzIChjb250cm9sbGVyIHNldHRpbmcpJnF1b3Q7LDxicj4NCi3CoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoHBwLSZndDtkZXYsIGNoZWNrZXJfbmFtZShj
KSk7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgZ290byBvdXQ7PGJyPg0KLcKgIMKgIMKg
IMKgfTxicj4NCi3CoCDCoCDCoCDCoGlmIChjb25mLSZndDtjaGVja2VyX25hbWUpIHs8YnI+DQot
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBjaGVja2VyX2dldChjLCBjb25mLSZndDtjaGVja2VyX25h
bWUpOzxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoGNvbmRsb2coMywgJnF1b3Q7JXM6IHBh
dGggY2hlY2tlciA9ICVzIChjb25maWcgZmlsZSBkZWZhdWx0KSZxdW90Oyw8YnI+DQotwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBwcC0mZ3Q7ZGV2LCBjaGVja2VyX25hbWUoYykp
Ozxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoGdvdG8gb3V0Ozxicj4NCi3CoCDCoCDCoCDC
oH08YnI+DQotwqAgwqAgwqAgwqBjaGVja2VyX2dldChjLCBERUZBVUxUX0NIRUNLRVIpOzxicj4N
Ci3CoCDCoCDCoCDCoGNvbmRsb2coMywgJnF1b3Q7JXM6IHBhdGggY2hlY2tlciA9ICVzIChpbnRl
cm5hbCBkZWZhdWx0KSZxdW90Oyw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBwcC0mZ3Q7
ZGV2LCBjaGVja2VyX25hbWUoYykpOzxicj4NCivCoCDCoCDCoCDCoGRvX3NldChjaGVja2VyX25h
bWUsIHBwLSZndDtod2UsIGNoZWNrZXJfbmFtZSwgJnF1b3Q7KGNvbnRyb2xsZXIgc2V0dGluZykm
cXVvdDspOzxicj4NCivCoCDCoCDCoCDCoGRvX3NldChjaGVja2VyX25hbWUsIGNvbmYsIGNoZWNr
ZXJfbmFtZSwgJnF1b3Q7KGNvbmZpZyBmaWxlIHNldHRpbmcpJnF1b3Q7KTs8YnI+DQorwqAgwqAg
wqAgwqBkb19kZWZhdWx0KGNoZWNrZXJfbmFtZSwgREVGQVVMVF9DSEVDS0VSKTs8YnI+DQrCoG91
dDo8YnI+DQorwqAgwqAgwqAgwqBjaGVja2VyX2dldChjLCBjaGVja2VyX25hbWUpOzxicj4NCivC
oCDCoCDCoCDCoGNvbmRsb2coMywgJnF1b3Q7JXM6IHBhdGhfY2hlY2tlciA9ICVzICVzJnF1b3Q7
LCBwcC0mZ3Q7ZGV2LCBjLSZndDtuYW1lLCBvcmlnaW4pOzxicj4NCsKgIMKgIMKgIMKgIGlmIChj
b25mLSZndDtjaGVja2VyX3RpbWVvdXQpIHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBj
LSZndDt0aW1lb3V0ID0gY29uZi0mZ3Q7Y2hlY2tlcl90aW1lb3V0Ozxicj4NCsKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIGNvbmRsb2coMywgJnF1b3Q7JXM6IGNoZWNrZXIgdGltZW91dCA9ICV1IHMg
KGNvbmZpZyBmaWxlIGRlZmF1bHQpJnF1b3Q7LDxicj4NCkBAIC0zNzUsMzMgKzMyNSwyMCBAQCBv
dXQ6PGJyPg0KwqBleHRlcm4gaW50PGJyPg0KwqBzZWxlY3RfZ2V0dWlkIChzdHJ1Y3QgcGF0aCAq
IHBwKTxicj4NCsKgezxicj4NCi3CoCDCoCDCoCDCoGlmIChwcC0mZ3Q7aHdlICZhbXA7JmFtcDsg
cHAtJmd0O2h3ZS0mZ3Q7dWlkX2F0dHJpYnV0ZSkgezxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoHBwLSZndDt1aWRfYXR0cmlidXRlID0gcHAtJmd0O2h3ZS0mZ3Q7dWlkX2F0dHJpYnV0ZTs8
YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBjb25kbG9nKDMsICZxdW90OyVzOiB1aWRfYXR0
cmlidXRlID0gJXMgKGNvbnRyb2xsZXIgc2V0dGluZykmcXVvdDssPGJyPg0KLcKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgcHAtJmd0O2RldiwgcHAtJmd0O3VpZF9hdHRyaWJ1dGUp
Ozxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoHJldHVybiAwOzxicj4NCi3CoCDCoCDCoCDC
oH08YnI+DQotwqAgwqAgwqAgwqBpZiAocHAtJmd0O2h3ZSAmYW1wOyZhbXA7IHBwLSZndDtod2Ut
Jmd0O2dldHVpZCkgezxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoHBwLSZndDtnZXR1aWQg
PSBwcC0mZ3Q7aHdlLSZndDtnZXR1aWQ7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgY29u
ZGxvZygzLCAmcXVvdDslczogZ2V0dWlkID0gJXMgKGRlcHJlY2F0ZWQpIChjb250cm9sbGVyIHNl
dHRpbmcpJnF1b3Q7LDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoHBw
LSZndDtkZXYsIHBwLSZndDtnZXR1aWQpOzxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoHJl
dHVybiAwOzxicj4NCi3CoCDCoCDCoCDCoH08YnI+DQotwqAgwqAgwqAgwqBpZiAoY29uZi0mZ3Q7
dWlkX2F0dHJpYnV0ZSkgezxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoHBwLSZndDt1aWRf
YXR0cmlidXRlID0gY29uZi0mZ3Q7dWlkX2F0dHJpYnV0ZTs8YnI+DQotwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqBjb25kbG9nKDMsICZxdW90OyVzOiB1aWRfYXR0cmlidXRlID0gJXMgKGNvbmZpZyBm
aWxlIGRlZmF1bHQpJnF1b3Q7LDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoHBwLSZndDtkZXYsIHBwLSZndDt1aWRfYXR0cmlidXRlKTs8YnI+DQotwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqByZXR1cm4gMDs8YnI+DQotwqAgwqAgwqAgwqB9PGJyPg0KLcKgIMKgIMKgIMKg
aWYgKGNvbmYtJmd0O2dldHVpZCkgezxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoHBwLSZn
dDtnZXR1aWQgPSBjb25mLSZndDtnZXR1aWQ7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
Y29uZGxvZygzLCAmcXVvdDslczogZ2V0dWlkID0gJXMgKGRlcHJlY2F0ZWQpIChjb25maWcgZmls
ZSBkZWZhdWx0KSZxdW90Oyw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqBwcC0mZ3Q7ZGV2LCBwcC0mZ3Q7Z2V0dWlkKTs8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqByZXR1cm4gMDs8YnI+DQotwqAgwqAgwqAgwqB9PGJyPg0KLcKgIMKgIMKgIMKgcHAtJmd0O3Vp
ZF9hdHRyaWJ1dGUgPSBTVFJEVVAoREVGQVVMVF9VSURfQVRUUklCVVRFKTs8YnI+DQotwqAgwqAg
wqAgwqBjb25kbG9nKDMsICZxdW90OyVzOiB1aWRfYXR0cmlidXRlID0gJXMgKGludGVybmFsIGRl
ZmF1bHQpJnF1b3Q7LDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoHBwLSZndDtkZXYsIHBw
LSZndDt1aWRfYXR0cmlidXRlKTs8YnI+DQorwqAgwqAgwqAgwqBjaGFyICpvcmlnaW47PGJyPg0K
Kzxicj4NCivCoCDCoCDCoCDCoHBwX3NldF9od2UodWlkX2F0dHJpYnV0ZSk7PGJyPg0KK8KgIMKg
IMKgIMKgcHBfc2V0X2h3ZShnZXR1aWQpOzxicj4NCivCoCDCoCDCoCDCoHBwX3NldF9jb25mKHVp
ZF9hdHRyaWJ1dGUpOzxicj4NCivCoCDCoCDCoCDCoHBwX3NldF9jb25mKGdldHVpZCk7PGJyPg0K
K8KgIMKgIMKgIMKgcHBfc2V0X2RlZmF1bHQodWlkX2F0dHJpYnV0ZSwgREVGQVVMVF9VSURfQVRU
UklCVVRFKTs8YnI+DQorb3V0Ojxicj4NCivCoCDCoCDCoCDCoGlmIChwcC0mZ3Q7dWlkX2F0dHJp
YnV0ZSk8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBjb25kbG9nKDMsICZxdW90OyVzOiB1
aWRfYXR0cmlidXRlID0gJXMgJXMmcXVvdDssIHBwLSZndDtkZXYsPGJyPg0KK8KgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgcHAtJmd0O3VpZF9hdHRyaWJ1dGUsIG9yaWdpbik7PGJy
Pg0KK8KgIMKgIMKgIMKgZWxzZSBpZiAocHAtJmd0O2dldHVpZCk8YnI+DQorwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqBjb25kbG9nKDMsICZxdW90OyVzOiBnZXR1aWQgPSBcJnF1b3Q7JXNcJnF1b3Q7
ICVzJnF1b3Q7LCBwcC0mZ3Q7ZGV2LCBwcC0mZ3Q7Z2V0dWlkLDxicj4NCivCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoG9yaWdpbik7PGJyPg0KwqAgwqAgwqAgwqAgcmV0dXJuIDA7
PGJyPg0KwqB9PGJyPg0KPGJyPg0KQEAgLTQyMSwxNDAgKzM1OCw5NCBAQCBkZXRlY3RfcHJpbyhz
dHJ1Y3QgcGF0aCAqIHBwKTxicj4NCsKgIMKgIMKgIMKgIHByaW9fZ2V0KHAsIFBSSU9fQUxVQSwg
REVGQVVMVF9QUklPX0FSR1MpOzxicj4NCsKgfTxicj4NCjxicj4NCisjZGVmaW5lIHNldF9wcmlv
KHNyYywgbXNnKcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgXDxicj4NCitkbyB7wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqBcPGJyPg0KK8KgIMKgIMKgIMKgaWYgKHNyYyAmYW1wOyZhbXA7
IHNyYy0mZ3Q7cHJpb19uYW1lKSB7wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgXDxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoHByaW9fZ2V0
KHAsIHNyYy0mZ3Q7cHJpb19uYW1lLCBzcmMtJmd0O3ByaW9fYXJncyk7wqAgwqAgwqAgwqAgwqAg
wqAgXDxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoG9yaWdpbiA9IG1zZzvCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoFw8
YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBnb3RvIG91dDvCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoFw8YnI+
DQorwqAgwqAgwqAgwqB9wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBcPGJy
Pg0KK30gd2hpbGUoMCk8YnI+DQorPGJyPg0KwqBleHRlcm4gaW50PGJyPg0KwqBzZWxlY3RfcHJp
byAoc3RydWN0IHBhdGggKiBwcCk8YnI+DQrCoHs8YnI+DQorwqAgwqAgwqAgwqBjaGFyICpvcmln
aW47PGJyPg0KwqAgwqAgwqAgwqAgc3RydWN0IG1wZW50cnkgKiBtcGU7PGJyPg0KwqAgwqAgwqAg
wqAgc3RydWN0IHByaW8gKiBwID0gJmFtcDtwcC0mZ3Q7cHJpbzs8YnI+DQo8YnI+DQrCoCDCoCDC
oCDCoCBpZiAocHAtJmd0O2RldGVjdF9wcmlvID09IERFVEVDVF9QUklPX09OKSB7PGJyPg0KwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgZGV0ZWN0X3ByaW8ocHApOzxicj4NCsKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIGlmIChwcmlvX3NlbGVjdGVkKHApKSB7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgY29uZGxvZygzLCAmcXVvdDslczogcHJpbyA9ICVzIChkZXRlY3Rl
ZCBzZXR0aW5nKSZxdW90Oyw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqBwcC0mZ3Q7ZGV2LCBwcmlvX25hbWUocCkpOzxicj4NCi3CoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoHJldHVybiAwOzxicj4NCi3CoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoH08YnI+DQotwqAgwqAgwqAgwqB9PGJyPg0KLTxicj4NCi3CoCDCoCDCoCDCoGlmICgo
bXBlID0gZmluZF9tcGUocHAtJmd0O3d3aWQpKSkgezxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoGlmIChtcGUtJmd0O3ByaW9fbmFtZSkgezxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoHByaW9fZ2V0KHAsIG1wZS0mZ3Q7cHJpb19uYW1lLCBtcGUtJmd0O3ByaW9f
YXJncyk7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgY29uZGxvZygz
LCAmcXVvdDslczogcHJpbyA9ICVzIChMVU4gc2V0dGluZykmcXVvdDssPGJyPg0KLcKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgcHAtJmd0O2RldiwgcHJpb19u
YW1lKHApKTs8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqByZXR1cm4g
MDs8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBvcmlnaW4gPSAmcXVv
dDsoZGV0ZWN0ZWQgc2V0dGluZykmcXVvdDs7PGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgZ290byBvdXQ7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgfTxicj4N
CsKgIMKgIMKgIMKgIH08YnI+DQotPGJyPg0KLcKgIMKgIMKgIMKgaWYgKHBwLSZndDtod2UgJmFt
cDsmYW1wOyBwcC0mZ3Q7aHdlLSZndDtwcmlvX25hbWUpIHs8YnI+DQotwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqBwcmlvX2dldChwLCBwcC0mZ3Q7aHdlLSZndDtwcmlvX25hbWUsIHBwLSZndDtod2Ut
Jmd0O3ByaW9fYXJncyk7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgY29uZGxvZygzLCAm
cXVvdDslczogcHJpbyA9ICVzIChjb250cm9sbGVyIHNldHRpbmcpJnF1b3Q7LDxicj4NCi3CoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoHBwLSZndDtkZXYsIHBwLSZndDtod2UtJmd0
O3ByaW9fbmFtZSk7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgY29uZGxvZygzLCAmcXVv
dDslczogcHJpbyBhcmdzID0gJXMgKGNvbnRyb2xsZXIgc2V0dGluZykmcXVvdDssPGJyPg0KLcKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgcHAtJmd0O2RldiwgcHAtJmd0O2h3ZS0m
Z3Q7cHJpb19hcmdzKTs8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqByZXR1cm4gMDs8YnI+
DQotwqAgwqAgwqAgwqB9PGJyPg0KLcKgIMKgIMKgIMKgaWYgKGNvbmYtJmd0O3ByaW9fbmFtZSkg
ezxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoHByaW9fZ2V0KHAsIGNvbmYtJmd0O3ByaW9f
bmFtZSwgY29uZi0mZ3Q7cHJpb19hcmdzKTs8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBj
b25kbG9nKDMsICZxdW90OyVzOiBwcmlvID0gJXMgKGNvbmZpZyBmaWxlIGRlZmF1bHQpJnF1b3Q7
LDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoHBwLSZndDtkZXYsIGNv
bmYtJmd0O3ByaW9fbmFtZSk7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgY29uZGxvZygz
LCAmcXVvdDslczogcHJpbyBhcmdzID0gJXMgKGNvbmZpZyBmaWxlIGRlZmF1bHQpJnF1b3Q7LDxi
cj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoHBwLSZndDtkZXYsIGNvbmYt
Jmd0O3ByaW9fYXJncyk7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgcmV0dXJuIDA7PGJy
Pg0KLcKgIMKgIMKgIMKgfTxicj4NCivCoCDCoCDCoCDCoG1wZSA9IGZpbmRfbXBlKHBwLSZndDt3
d2lkKTs8YnI+DQorwqAgwqAgwqAgwqBzZXRfcHJpbyhtcGUsICZxdW90OyhMVU4gc2V0dGluZykm
cXVvdDspOzxicj4NCivCoCDCoCDCoCDCoHNldF9wcmlvKHBwLSZndDtod2UsICZxdW90O2NvbnRy
b2xsZXIgc2V0dGluZykmcXVvdDspOzxicj4NCivCoCDCoCDCoCDCoHNldF9wcmlvKGNvbmYsICZx
dW90Oyhjb25maWcgZmlsZSBkZWZhdWx0KSZxdW90Oyk7PGJyPg0KwqAgwqAgwqAgwqAgcHJpb19n
ZXQocCwgREVGQVVMVF9QUklPLCBERUZBVUxUX1BSSU9fQVJHUyk7PGJyPg0KLcKgIMKgIMKgIMKg
Y29uZGxvZygzLCAmcXVvdDslczogcHJpbyA9ICVzIChpbnRlcm5hbCBkZWZhdWx0KSZxdW90Oyw8
YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBwcC0mZ3Q7ZGV2LCBERUZBVUxUX1BSSU8pOzxi
cj4NCi3CoCDCoCDCoCDCoGNvbmRsb2coMywgJnF1b3Q7JXM6IHByaW8gYXJncyA9ICVzIChpbnRl
cm5hbCBkZWZhdWx0KSZxdW90Oyw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBwcC0mZ3Q7
ZGV2LCBERUZBVUxUX1BSSU9fQVJHUyk7PGJyPg0KK8KgIMKgIMKgIMKgb3JpZ2luID0gJnF1b3Q7
KGludGVybmFsIGRlZmF1bHQpJnF1b3Q7Ozxicj4NCitvdXQ6PGJyPg0KK8KgIMKgIMKgIMKgY29u
ZGxvZygzLCAmcXVvdDslczogcHJpbyA9ICVzICVzJnF1b3Q7LCBwcC0mZ3Q7ZGV2LCBwcmlvX25h
bWUocCksIG9yaWdpbik7PGJyPg0KK8KgIMKgIMKgIMKgY29uZGxvZygzLCAmcXVvdDslczogcHJp
byBhcmdzID0gXCZxdW90OyVzXCZxdW90OyAlcyZxdW90OywgcHAtJmd0O2RldiwgcHJpb19hcmdz
KHApLCBvcmlnaW4pOzxicj4NCsKgIMKgIMKgIMKgIHJldHVybiAwOzxicj4NCsKgfTxicj4NCjxi
cj4NCsKgZXh0ZXJuIGludDxicj4NCsKgc2VsZWN0X25vX3BhdGhfcmV0cnkoc3RydWN0IG11bHRp
cGF0aCAqbXApPGJyPg0KwqB7PGJyPg0KK8KgIMKgIMKgIMKgY2hhciAqb3JpZ2luID0gTlVMTDs8
YnI+DQorwqAgwqAgwqAgwqBjaGFyIGJ1ZmZbMTJdOzxicj4NCis8YnI+DQrCoCDCoCDCoCDCoCBp
ZiAobXAtJmd0O2ZsdXNoX29uX2xhc3RfZGVsID09IEZMVVNIX0lOX1BST0dSRVNTKSB7PGJyPg0K
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgY29uZGxvZygwLCAmcXVvdDtmbHVzaF9vbl9sYXN0X2Rl
bCBpbiBwcm9ncmVzcyZxdW90Oyk7PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgbXAtJmd0
O25vX3BhdGhfcmV0cnkgPSBOT19QQVRIX1JFVFJZX0ZBSUw7PGJyPg0KwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgcmV0dXJuIDA7PGJyPg0KwqAgwqAgwqAgwqAgfTxicj4NCi3CoCDCoCDCoCDCoGlm
IChtcC0mZ3Q7bXBlICZhbXA7JmFtcDsgbXAtJmd0O21wZS0mZ3Q7bm9fcGF0aF9yZXRyeSAhPSBO
T19QQVRIX1JFVFJZX1VOREVGKSB7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgbXAtJmd0
O25vX3BhdGhfcmV0cnkgPSBtcC0mZ3Q7bXBlLSZndDtub19wYXRoX3JldHJ5Ozxicj4NCi3CoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoGNvbmRsb2coMywgJnF1b3Q7JXM6IG5vX3BhdGhfcmV0cnkgPSAl
aSAobXVsdGlwYXRoIHNldHRpbmcpJnF1b3Q7LDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoG1wLSZndDthbGlhcywgbXAtJmd0O25vX3BhdGhfcmV0cnkpOzxicj4NCi3C
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoHJldHVybiAwOzxicj4NCi3CoCDCoCDCoCDCoH08YnI+DQot
wqAgwqAgwqAgwqBpZiAobXAtJmd0O2h3ZSAmYW1wOyZhbXA7IG1wLSZndDtod2UtJmd0O25vX3Bh
dGhfcmV0cnkgIT0gTk9fUEFUSF9SRVRSWV9VTkRFRikgezxicj4NCi3CoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoG1wLSZndDtub19wYXRoX3JldHJ5ID0gbXAtJmd0O2h3ZS0mZ3Q7bm9fcGF0aF9yZXRy
eTs8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBjb25kbG9nKDMsICZxdW90OyVzOiBub19w
YXRoX3JldHJ5ID0gJWkgKGNvbnRyb2xsZXIgc2V0dGluZykmcXVvdDssPGJyPg0KLcKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgbXAtJmd0O2FsaWFzLCBtcC0mZ3Q7bm9fcGF0aF9y
ZXRyeSk7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgcmV0dXJuIDA7PGJyPg0KLcKgIMKg
IMKgIMKgfTxicj4NCi3CoCDCoCDCoCDCoGlmIChjb25mLSZndDtub19wYXRoX3JldHJ5ICE9IE5P
X1BBVEhfUkVUUllfVU5ERUYpIHs8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBtcC0mZ3Q7
bm9fcGF0aF9yZXRyeSA9IGNvbmYtJmd0O25vX3BhdGhfcmV0cnk7PGJyPg0KLcKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgY29uZGxvZygzLCAmcXVvdDslczogbm9fcGF0aF9yZXRyeSA9ICVpIChjb25m
aWcgZmlsZSBkZWZhdWx0KSZxdW90Oyw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqBtcC0mZ3Q7YWxpYXMsIG1wLSZndDtub19wYXRoX3JldHJ5KTs8YnI+DQotwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqByZXR1cm4gMDs8YnI+DQotwqAgwqAgwqAgwqB9PGJyPg0KLcKgIMKg
IMKgIMKgaWYgKG1wLSZndDtub19wYXRoX3JldHJ5ICE9IE5PX1BBVEhfUkVUUllfVU5ERUYpPGJy
Pg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgY29uZGxvZygzLCAmcXVvdDslczogbm9fcGF0aF9y
ZXRyeSA9ICVpIChpbmhlcml0ZWQgc2V0dGluZykmcXVvdDssPGJyPg0KLcKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgbXAtJmd0O2FsaWFzLCBtcC0mZ3Q7bm9fcGF0aF9yZXRyeSk7
PGJyPg0KK8KgIMKgIMKgIMKgbXBfc2V0X21wZShub19wYXRoX3JldHJ5KTs8YnI+DQorwqAgwqAg
wqAgwqBtcF9zZXRfaHdlKG5vX3BhdGhfcmV0cnkpOzxicj4NCivCoCDCoCDCoCDCoG1wX3NldF9j
b25mKG5vX3BhdGhfcmV0cnkpOzxicj4NCitvdXQ6PGJyPg0KK8KgIMKgIMKgIMKgcHJpbnRfbm9f
cGF0aF9yZXRyeShidWZmLCAxMiwgJmFtcDttcC0mZ3Q7bm9fcGF0aF9yZXRyeSk7PGJyPg0KK8Kg
IMKgIMKgIMKgaWYgKG9yaWdpbik8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBjb25kbG9n
KDMsICZxdW90OyVzOiBub19wYXRoX3JldHJ5ID0gJXMgJXMmcXVvdDssIG1wLSZndDthbGlhcywg
YnVmZiw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBvcmlnaW4pOzxi
cj4NCivCoCDCoCDCoCDCoGVsc2UgaWYgKG1wLSZndDtub19wYXRoX3JldHJ5ICE9IE5PX1BBVEhf
UkVUUllfVU5ERUYpPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgY29uZGxvZygzLCAmcXVv
dDslczogbm9fcGF0aF9yZXRyeSA9ICVzIChpbmhlcml0aWVkIHNldHRpbmcpJnF1b3Q7LDxicj4N
CivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoG1wLSZndDthbGlhcywgYnVmZik7
PGJyPg0KwqAgwqAgwqAgwqAgZWxzZTxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoGNvbmRs
b2coMywgJnF1b3Q7JXM6IG5vX3BhdGhfcmV0cnkgPSAlaSAoaW50ZXJuYWwgZGVmYXVsdCkmcXVv
dDssPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgbXAtJmd0O2FsaWFz
LCBtcC0mZ3Q7bm9fcGF0aF9yZXRyeSk7PGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgY29u
ZGxvZygzLCAmcXVvdDslczogbm9fcGF0aF9yZXRyeSA9IHVuZGVmIChpbnRlcm5hbCBkZWZhdWx0
KSZxdW90Oyw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBtcC0mZ3Q7
YWxpYXMpOzxicj4NCsKgIMKgIMKgIMKgIHJldHVybiAwOzxicj4NCsKgfTxicj4NCjxicj4NCsKg
aW50PGJyPg0KwqBzZWxlY3RfbWluaW9fcnEgKHN0cnVjdCBtdWx0aXBhdGggKiBtcCk8YnI+DQrC
oHs8YnI+DQotwqAgwqAgwqAgwqBpZiAobXAtJmd0O21wZSAmYW1wOyZhbXA7IG1wLSZndDttcGUt
Jmd0O21pbmlvX3JxKSB7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgbXAtJmd0O21pbmlv
ID0gbXAtJmd0O21wZS0mZ3Q7bWluaW9fcnE7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
Y29uZGxvZygzLCAmcXVvdDslczogbWluaW8gPSAlaSBycSAoTFVOIHNldHRpbmcpJnF1b3Q7LDxi
cj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoG1wLSZndDthbGlhcywgbXAt
Jmd0O21pbmlvKTs8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqByZXR1cm4gMDs8YnI+DQot
wqAgwqAgwqAgwqB9PGJyPg0KLcKgIMKgIMKgIMKgaWYgKG1wLSZndDtod2UgJmFtcDsmYW1wOyBt
cC0mZ3Q7aHdlLSZndDttaW5pb19ycSkgezxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoG1w
LSZndDttaW5pbyA9IG1wLSZndDtod2UtJmd0O21pbmlvX3JxOzxicj4NCi3CoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoGNvbmRsb2coMywgJnF1b3Q7JXM6IG1pbmlvID0gJWkgcnEgKGNvbnRyb2xsZXIg
c2V0dGluZykmcXVvdDssPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
bXAtJmd0O2FsaWFzLCBtcC0mZ3Q7bWluaW8pOzxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oHJldHVybiAwOzxicj4NCi3CoCDCoCDCoCDCoH08YnI+DQotwqAgwqAgwqAgwqBpZiAoY29uZi0m
Z3Q7bWluaW8pIHs8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBtcC0mZ3Q7bWluaW8gPSBj
b25mLSZndDttaW5pb19ycTs8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBjb25kbG9nKDMs
ICZxdW90OyVzOiBtaW5pbyA9ICVpIHJxIChjb25maWcgZmlsZSBkZWZhdWx0KSZxdW90Oyw8YnI+
DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBtcC0mZ3Q7YWxpYXMsIG1wLSZn
dDttaW5pbyk7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgcmV0dXJuIDA7PGJyPg0KLcKg
IMKgIMKgIMKgfTxicj4NCi3CoCDCoCDCoCDCoG1wLSZndDttaW5pbyA9IERFRkFVTFRfTUlOSU9f
UlE7PGJyPg0KLcKgIMKgIMKgIMKgY29uZGxvZygzLCAmcXVvdDslczogbWluaW8gPSAlaSBycSAo
aW50ZXJuYWwgZGVmYXVsdCkmcXVvdDssPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgbXAt
Jmd0O2FsaWFzLCBtcC0mZ3Q7bWluaW8pOzxicj4NCivCoCDCoCDCoCDCoGNoYXIgKm9yaWdpbjs8
YnI+DQorPGJyPg0KK8KgIMKgIMKgIMKgZG9fc2V0KG1pbmlvX3JxLCBtcC0mZ3Q7bXBlLCBtcC0m
Z3Q7bWluaW8sICZxdW90OyhMVU4gc2V0dGluZykmcXVvdDspOzxicj4NCivCoCDCoCDCoCDCoGRv
X3NldChtaW5pb19ycSwgbXAtJmd0O2h3ZSwgbXAtJmd0O21pbmlvLCAmcXVvdDsoY29udHJvbGxl
ciBzZXR0aW5nKSZxdW90Oyk7PGJyPg0KK8KgIMKgIMKgIMKgZG9fc2V0KG1pbmlvX3JxLCBjb25m
LCBtcC0mZ3Q7bWluaW8sICZxdW90Oyhjb25maWcgZmlsZSBzZXR0aW5nKSZxdW90Oyk7PGJyPg0K
K8KgIMKgIMKgIMKgZG9fZGVmYXVsdChtcC0mZ3Q7bWluaW8sIERFRkFVTFRfTUlOSU9fUlEpOzxi
cj4NCitvdXQ6PGJyPg0KK8KgIMKgIMKgIMKgY29uZGxvZygzLCAmcXVvdDslczogbWluaW8gPSAl
aSAlcyZxdW90OywgbXAtJmd0O2FsaWFzLCBtcC0mZ3Q7bWluaW8sIG9yaWdpbik7PGJyPg0KwqAg
wqAgwqAgwqAgcmV0dXJuIDA7PGJyPg0KwqB9PGJyPg0KPGJyPg0KwqBpbnQ8YnI+DQrCoHNlbGVj
dF9taW5pb19iaW8gKHN0cnVjdCBtdWx0aXBhdGggKiBtcCk8YnI+DQrCoHs8YnI+DQotwqAgwqAg
wqAgwqBpZiAobXAtJmd0O21wZSAmYW1wOyZhbXA7IG1wLSZndDttcGUtJmd0O21pbmlvKSB7PGJy
Pg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgbXAtJmd0O21pbmlvID0gbXAtJmd0O21wZS0mZ3Q7
bWluaW87PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgY29uZGxvZygzLCAmcXVvdDslczog
bWluaW8gPSAlaSAoTFVOIHNldHRpbmcpJnF1b3Q7LDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoG1wLSZndDthbGlhcywgbXAtJmd0O21pbmlvKTs8YnI+DQotwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqByZXR1cm4gMDs8YnI+DQotwqAgwqAgwqAgwqB9PGJyPg0KLcKgIMKg
IMKgIMKgaWYgKG1wLSZndDtod2UgJmFtcDsmYW1wOyBtcC0mZ3Q7aHdlLSZndDttaW5pbykgezxi
cj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoG1wLSZndDttaW5pbyA9IG1wLSZndDtod2UtJmd0
O21pbmlvOzxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoGNvbmRsb2coMywgJnF1b3Q7JXM6
IG1pbmlvID0gJWkgKGNvbnRyb2xsZXIgc2V0dGluZykmcXVvdDssPGJyPg0KLcKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgbXAtJmd0O2FsaWFzLCBtcC0mZ3Q7bWluaW8pOzxicj4N
Ci3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoHJldHVybiAwOzxicj4NCi3CoCDCoCDCoCDCoH08YnI+
DQotwqAgwqAgwqAgwqBpZiAoY29uZi0mZ3Q7bWluaW8pIHs8YnI+DQotwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqBtcC0mZ3Q7bWluaW8gPSBjb25mLSZndDttaW5pbzs8YnI+DQotwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqBjb25kbG9nKDMsICZxdW90OyVzOiBtaW5pbyA9ICVpIChjb25maWcgZmlsZSBk
ZWZhdWx0KSZxdW90Oyw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBt
cC0mZ3Q7YWxpYXMsIG1wLSZndDttaW5pbyk7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
cmV0dXJuIDA7PGJyPg0KLcKgIMKgIMKgIMKgfTxicj4NCi3CoCDCoCDCoCDCoG1wLSZndDttaW5p
byA9IERFRkFVTFRfTUlOSU87PGJyPg0KLcKgIMKgIMKgIMKgY29uZGxvZygzLCAmcXVvdDslczog
bWluaW8gPSAlaSAoaW50ZXJuYWwgZGVmYXVsdCkmcXVvdDssPGJyPg0KLcKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgbXAtJmd0O2FsaWFzLCBtcC0mZ3Q7bWluaW8pOzxicj4NCivCoCDCoCDCoCDCoGNo
YXIgKm9yaWdpbjs8YnI+DQorPGJyPg0KK8KgIMKgIMKgIMKgbXBfc2V0X21wZShtaW5pbyk7PGJy
Pg0KK8KgIMKgIMKgIMKgbXBfc2V0X2h3ZShtaW5pbyk7PGJyPg0KK8KgIMKgIMKgIMKgbXBfc2V0
X2NvbmYobWluaW8pOzxicj4NCivCoCDCoCDCoCDCoG1wX3NldF9kZWZhdWx0KG1pbmlvLCBERUZB
VUxUX01JTklPKTs8YnI+DQorb3V0Ojxicj4NCivCoCDCoCDCoCDCoGNvbmRsb2coMywgJnF1b3Q7
JXM6IG1pbmlvID0gJWkgJXMmcXVvdDssIG1wLSZndDthbGlhcywgbXAtJmd0O21pbmlvLCBvcmln
aW4pOzxicj4NCsKgIMKgIMKgIMKgIHJldHVybiAwOzxicj4NCsKgfTxicj4NCjxicj4NCkBAIC01
NzIsMTY0ICs0NjMsOTUgQEAgc2VsZWN0X21pbmlvIChzdHJ1Y3QgbXVsdGlwYXRoICogbXApPGJy
Pg0KwqBleHRlcm4gaW50PGJyPg0KwqBzZWxlY3RfZmFzdF9pb19mYWlsKHN0cnVjdCBtdWx0aXBh
dGggKm1wKTxicj4NCsKgezxicj4NCi3CoCDCoCDCoCDCoGlmIChtcC0mZ3Q7aHdlICZhbXA7JmFt
cDsgbXAtJmd0O2h3ZS0mZ3Q7ZmFzdF9pb19mYWlsICE9IE1QX0ZBU1RfSU9fRkFJTF9VTlNFVCkg
ezxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoG1wLSZndDtmYXN0X2lvX2ZhaWwgPSBtcC0m
Z3Q7aHdlLSZndDtmYXN0X2lvX2ZhaWw7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgaWYg
KG1wLSZndDtmYXN0X2lvX2ZhaWwgPT0gTVBfRkFTVF9JT19GQUlMX09GRik8YnI+DQotwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBjb25kbG9nKDMsICZxdW90OyVzOiBmYXN0X2lv
X2ZhaWxfdG1vID0gb2ZmICZxdW90Ozxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCZxdW90Oyhjb250cm9sbGVyIHNldHRpbmcpJnF1b3Q7LCBtcC0m
Z3Q7YWxpYXMpOzxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoGVsc2U8YnI+DQotwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBjb25kbG9nKDMsICZxdW90OyVzOiBmYXN0X2lv
X2ZhaWxfdG1vID0gJWQgJnF1b3Q7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgJnF1b3Q7KGNvbnRyb2xsZXIgc2V0dGluZykmcXVvdDssIG1wLSZn
dDthbGlhcyw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqBtcC0mZ3Q7ZmFzdF9pb19mYWlsID09IE1QX0ZBU1RfSU9fRkFJTF9aRVJPID8gMCA6IG1w
LSZndDtmYXN0X2lvX2ZhaWwpOzxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoHJldHVybiAw
Ozxicj4NCi3CoCDCoCDCoCDCoH08YnI+DQotwqAgwqAgwqAgwqBpZiAoY29uZi0mZ3Q7ZmFzdF9p
b19mYWlsICE9IE1QX0ZBU1RfSU9fRkFJTF9VTlNFVCkgezxicj4NCi3CoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoG1wLSZndDtmYXN0X2lvX2ZhaWwgPSBjb25mLSZndDtmYXN0X2lvX2ZhaWw7PGJyPg0K
LcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgaWYgKG1wLSZndDtmYXN0X2lvX2ZhaWwgPT0gTVBfRkFT
VF9JT19GQUlMX09GRik8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBj
b25kbG9nKDMsICZxdW90OyVzOiBmYXN0X2lvX2ZhaWxfdG1vID0gb2ZmICZxdW90Ozxicj4NCi3C
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCZxdW90Oyhjb25m
aWcgZmlsZSBkZWZhdWx0KSZxdW90OywgbXAtJmd0O2FsaWFzKTs8YnI+DQotwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqBlbHNlPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
Y29uZGxvZygzLCAmcXVvdDslczogZmFzdF9pb19mYWlsX3RtbyA9ICVkICZxdW90Ozxicj4NCi3C
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCZxdW90Oyhjb25m
aWcgZmlsZSBkZWZhdWx0KSZxdW90OywgbXAtJmd0O2FsaWFzLDxicj4NCi3CoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoG1wLSZndDtmYXN0X2lvX2ZhaWwgPT0g
TVBfRkFTVF9JT19GQUlMX1pFUk8gPyAwIDogbXAtJmd0O2Zhc3RfaW9fZmFpbCk7PGJyPg0KLcKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgcmV0dXJuIDA7PGJyPg0KLcKgIMKgIMKgIMKgfTxicj4NCi3C
oCDCoCDCoCDCoG1wLSZndDtmYXN0X2lvX2ZhaWwgPSBNUF9GQVNUX0lPX0ZBSUxfVU5TRVQ7PGJy
Pg0KK8KgIMKgIMKgIMKgY2hhciAqb3JpZ2luLCBidWZmWzEyXTs8YnI+DQorPGJyPg0KK8KgIMKg
IMKgIMKgbXBfc2V0X2h3ZShmYXN0X2lvX2ZhaWwpOzxicj4NCivCoCDCoCDCoCDCoG1wX3NldF9j
b25mKGZhc3RfaW9fZmFpbCk7PGJyPg0KK8KgIMKgIMKgIMKgbXBfc2V0X2RlZmF1bHQoZmFzdF9p
b19mYWlsLCBERUZBVUxUX0ZBU1RfSU9fRkFJTCk7PGJyPg0KK291dDo8YnI+DQorwqAgwqAgwqAg
wqBwcmludF9mYXN0X2lvX2ZhaWwoYnVmZiwgMTIsICZhbXA7bXAtJmd0O2Zhc3RfaW9fZmFpbCk7
PGJyPg0KK8KgIMKgIMKgIMKgY29uZGxvZygzLCAmcXVvdDslczogZmFzdF9pb19mYWlsX3RtbyA9
ICVzICVzJnF1b3Q7LCBtcC0mZ3Q7YWxpYXMsIGJ1ZmYsIG9yaWdpbik7PGJyPg0KwqAgwqAgwqAg
wqAgcmV0dXJuIDA7PGJyPg0KwqB9PGJyPg0KPGJyPg0KwqBleHRlcm4gaW50PGJyPg0KwqBzZWxl
Y3RfZGV2X2xvc3Moc3RydWN0IG11bHRpcGF0aCAqbXApPGJyPg0KwqB7PGJyPg0KLcKgIMKgIMKg
IMKgaWYgKG1wLSZndDtod2UgJmFtcDsmYW1wOyBtcC0mZ3Q7aHdlLSZndDtkZXZfbG9zcykgezxi
cj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoG1wLSZndDtkZXZfbG9zcyA9IG1wLSZndDtod2Ut
Jmd0O2Rldl9sb3NzOzxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoGNvbmRsb2coMywgJnF1
b3Q7JXM6IGRldl9sb3NzX3RtbyA9ICV1IChjb250cm9sbGVyIGRlZmF1bHQpJnF1b3Q7LDxicj4N
Ci3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoG1wLSZndDthbGlhcywgbXAtJmd0
O2Rldl9sb3NzKTs8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqByZXR1cm4gMDs8YnI+DQot
wqAgwqAgwqAgwqB9PGJyPg0KLcKgIMKgIMKgIMKgaWYgKGNvbmYtJmd0O2Rldl9sb3NzKSB7PGJy
Pg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgbXAtJmd0O2Rldl9sb3NzID0gY29uZi0mZ3Q7ZGV2
X2xvc3M7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgY29uZGxvZygzLCAmcXVvdDslczog
ZGV2X2xvc3NfdG1vID0gJXUgKGNvbmZpZyBmaWxlIGRlZmF1bHQpJnF1b3Q7LDxicj4NCi3CoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoG1wLSZndDthbGlhcywgbXAtJmd0O2Rldl9s
b3NzKTs8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqByZXR1cm4gMDs8YnI+DQotwqAgwqAg
wqAgwqB9PGJyPg0KK8KgIMKgIMKgIMKgY2hhciAqb3JpZ2luLCBidWZmWzEyXTs8YnI+DQorPGJy
Pg0KK8KgIMKgIMKgIMKgbXBfc2V0X2h3ZShkZXZfbG9zcyk7PGJyPg0KK8KgIMKgIMKgIMKgbXBf
c2V0X2NvbmYoZGV2X2xvc3MpOzxicj4NCsKgIMKgIMKgIMKgIG1wLSZndDtkZXZfbG9zcyA9IDA7
PGJyPg0KwqAgwqAgwqAgwqAgcmV0dXJuIDA7PGJyPg0KK291dDo8YnI+DQorwqAgwqAgwqAgwqBw
cmludF9kZXZfbG9zcyhidWZmLCAxMiwgJmFtcDttcC0mZ3Q7ZGV2X2xvc3MpOzxicj4NCivCoCDC
oCDCoCDCoGNvbmRsb2coMywgJnF1b3Q7JXM6IGRldl9sb3NzX3RtbyA9ICVzICVzJnF1b3Q7LCBt
cC0mZ3Q7YWxpYXMsIGJ1ZmYsIG9yaWdpbik7PGJyPg0KK8KgIMKgIMKgIMKgcmV0dXJuIDA7PGJy
Pg0KwqB9PGJyPg0KPGJyPg0KwqBleHRlcm4gaW50PGJyPg0KwqBzZWxlY3RfZmx1c2hfb25fbGFz
dF9kZWwoc3RydWN0IG11bHRpcGF0aCAqbXApPGJyPg0KwqB7PGJyPg0KK8KgIMKgIMKgIMKgY2hh
ciAqb3JpZ2luOzxicj4NCis8YnI+DQrCoCDCoCDCoCDCoCBpZiAobXAtJmd0O2ZsdXNoX29uX2xh
c3RfZGVsID09IEZMVVNIX0lOX1BST0dSRVNTKTxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IHJldHVybiAwOzxicj4NCi3CoCDCoCDCoCDCoGlmIChtcC0mZ3Q7bXBlICZhbXA7JmFtcDsgbXAt
Jmd0O21wZS0mZ3Q7Zmx1c2hfb25fbGFzdF9kZWwgIT0gRkxVU0hfVU5ERUYpIHs8YnI+DQotwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqBtcC0mZ3Q7Zmx1c2hfb25fbGFzdF9kZWwgPSBtcC0mZ3Q7bXBl
LSZndDtmbHVzaF9vbl9sYXN0X2RlbDs8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBjb25k
bG9nKDMsICZxdW90OyVzOiBmbHVzaF9vbl9sYXN0X2RlbCA9ICVpIChtdWx0aXBhdGggc2V0dGlu
ZykmcXVvdDssPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgbXAtJmd0
O2FsaWFzLCBtcC0mZ3Q7Zmx1c2hfb25fbGFzdF9kZWwpOzxicj4NCi3CoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoHJldHVybiAwOzxicj4NCi3CoCDCoCDCoCDCoH08YnI+DQotwqAgwqAgwqAgwqBpZiAo
bXAtJmd0O2h3ZSAmYW1wOyZhbXA7IG1wLSZndDtod2UtJmd0O2ZsdXNoX29uX2xhc3RfZGVsICE9
IEZMVVNIX1VOREVGKSB7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgbXAtJmd0O2ZsdXNo
X29uX2xhc3RfZGVsID0gbXAtJmd0O2h3ZS0mZ3Q7Zmx1c2hfb25fbGFzdF9kZWw7PGJyPg0KLcKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgY29uZGxvZygzLCAmcXVvdDslczogZmx1c2hfb25fbGFzdF9k
ZWwgPSAlaSAoY29udHJvbGxlciBzZXR0aW5nKSZxdW90Oyw8YnI+DQotwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqBtcC0mZ3Q7YWxpYXMsIG1wLSZndDtmbHVzaF9vbl9sYXN0X2Rl
bCk7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgcmV0dXJuIDA7PGJyPg0KLcKgIMKgIMKg
IMKgfTxicj4NCi3CoCDCoCDCoCDCoGlmIChjb25mLSZndDtmbHVzaF9vbl9sYXN0X2RlbCAhPSBG
TFVTSF9VTkRFRikgezxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoG1wLSZndDtmbHVzaF9v
bl9sYXN0X2RlbCA9IGNvbmYtJmd0O2ZsdXNoX29uX2xhc3RfZGVsOzxicj4NCi3CoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoGNvbmRsb2coMywgJnF1b3Q7JXM6IGZsdXNoX29uX2xhc3RfZGVsID0gJWkg
KGNvbmZpZyBmaWxlIGRlZmF1bHQpJnF1b3Q7LDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoG1wLSZndDthbGlhcywgbXAtJmd0O2ZsdXNoX29uX2xhc3RfZGVsKTs8YnI+
DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqByZXR1cm4gMDs8YnI+DQotwqAgwqAgwqAgwqB9PGJy
Pg0KLcKgIMKgIMKgIMKgbXAtJmd0O2ZsdXNoX29uX2xhc3RfZGVsID0gRkxVU0hfVU5ERUY7PGJy
Pg0KLcKgIMKgIMKgIMKgY29uZGxvZygzLCAmcXVvdDslczogZmx1c2hfb25fbGFzdF9kZWwgPSBE
SVNBQkxFRCAoaW50ZXJuYWwgZGVmYXVsdCkmcXVvdDssPGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgbXAtJmd0O2FsaWFzKTs8YnI+DQorwqAgwqAgwqAgwqBtcF9zZXRfbXBlKGZsdXNoX29u
X2xhc3RfZGVsKTs8YnI+DQorwqAgwqAgwqAgwqBtcF9zZXRfaHdlKGZsdXNoX29uX2xhc3RfZGVs
KTs8YnI+DQorwqAgwqAgwqAgwqBtcF9zZXRfY29uZihmbHVzaF9vbl9sYXN0X2RlbCk7PGJyPg0K
K8KgIMKgIMKgIMKgbXBfc2V0X2RlZmF1bHQoZmx1c2hfb25fbGFzdF9kZWwsIEZMVVNIX0RJU0FC
TEVEKTs8YnI+DQorb3V0Ojxicj4NCivCoCDCoCDCoCDCoGNvbmRsb2coMywgJnF1b3Q7JXM6IGZs
dXNoX29uX2xhc3RfZGVsID0gJXMgJXMmcXVvdDssIG1wLSZndDthbGlhcyw8YnI+DQorwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAobXAtJmd0O2ZsdXNoX29uX2xhc3RfZGVsID09IEZMVVNIX0VOQUJM
RUQpPyAmcXVvdDt5ZXMmcXVvdDsgOiAmcXVvdDtubyZxdW90Oywgb3JpZ2luKTs8YnI+DQrCoCDC
oCDCoCDCoCByZXR1cm4gMDs8YnI+DQrCoH08YnI+DQo8YnI+DQrCoGV4dGVybiBpbnQ8YnI+DQrC
oHNlbGVjdF9yZXNlcnZhdGlvbl9rZXkgKHN0cnVjdCBtdWx0aXBhdGggKiBtcCk8YnI+DQrCoHs8
YnI+DQotwqAgwqAgwqAgwqBpbnQgajs8YnI+DQotwqAgwqAgwqAgwqB1bnNpZ25lZCBjaGFyICpr
ZXlwOzxicj4NCi3CoCDCoCDCoCDCoHVpbnQ2NF90IHBya2V5ID0gMDs8YnI+DQorwqAgwqAgwqAg
wqBjaGFyICpvcmlnaW4sIGJ1ZmZbMTJdOzxicj4NCjxicj4NCivCoCDCoCDCoCDCoG1wX3NldF9t
cGUocmVzZXJ2YXRpb25fa2V5KTs8YnI+DQorwqAgwqAgwqAgwqBtcF9zZXRfY29uZihyZXNlcnZh
dGlvbl9rZXkpOzxicj4NCsKgIMKgIMKgIMKgIG1wLSZndDtyZXNlcnZhdGlvbl9rZXkgPSBOVUxM
Ozxicj4NCi08YnI+DQotwqAgwqAgwqAgwqBpZiAobXAtJmd0O21wZSAmYW1wOyZhbXA7IG1wLSZn
dDttcGUtJmd0O3Jlc2VydmF0aW9uX2tleSkgezxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oGtleXAgPcKgIG1wLSZndDttcGUtJmd0O3Jlc2VydmF0aW9uX2tleTs8YnI+DQotwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqBmb3IgKGogPSAwOyBqICZsdDsgODsgKytqKSB7PGJyPg0KLcKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgaWYgKGogJmd0OyAwKTxicj4NCi3CoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoHBya2V5ICZsdDsmbHQ7PSA4Ozxi
cj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoHBya2V5IHw9ICprZXlwOzxi
cj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCsra2V5cDs8YnI+DQotwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqB9PGJyPg0KLTxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oGNvbmRsb2coMywgJnF1b3Q7JXM6IHJlc2VydmF0aW9uX2tleSA9IDB4JSZxdW90OyBQUkl4NjQg
JnF1b3Q7ICZxdW90Ozxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCZxdW90OyhtdWx0aXBhdGggc2V0dGluZykmcXVvdDsswqAgbXAtJmd0O2FsaWFz
LCBwcmtleSk7PGJyPg0KLTxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoG1wLSZndDtyZXNl
cnZhdGlvbl9rZXkgPSBtcC0mZ3Q7bXBlLSZndDtyZXNlcnZhdGlvbl9rZXk7PGJyPg0KLcKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgcmV0dXJuIDA7PGJyPg0KLcKgIMKgIMKgIMKgfTxicj4NCi08YnI+
DQotwqAgwqAgwqAgwqBpZiAoY29uZi0mZ3Q7cmVzZXJ2YXRpb25fa2V5KSB7PGJyPg0KLcKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKga2V5cCA9IGNvbmYtJmd0O3Jlc2VydmF0aW9uX2tleTs8YnI+DQot
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBmb3IgKGogPSAwOyBqICZsdDsgODsgKytqKSB7PGJyPg0K
LcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgaWYgKGogJmd0OyAwKTxicj4NCi3C
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoHBya2V5ICZsdDsm
bHQ7PSA4Ozxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoHBya2V5IHw9
ICprZXlwOzxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCsra2V5cDs8
YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqB9PGJyPg0KLTxicj4NCi3CoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoGNvbmRsb2coMywgJnF1b3Q7JXM6IHJlc2VydmF0aW9uX2tlecKgID0gMHglJnF1
b3Q7IFBSSXg2NDxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCZxdW90OyAoY29uZmlnIGZpbGUgZGVmYXVsdCkmcXVvdDssIG1wLSZndDthbGlhcywg
cHJrZXkpOzxicj4NCi08YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBtcC0mZ3Q7cmVzZXJ2
YXRpb25fa2V5ID0gY29uZi0mZ3Q7cmVzZXJ2YXRpb25fa2V5Ozxicj4NCi3CoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoHJldHVybiAwOzxicj4NCi3CoCDCoCDCoCDCoH08YnI+DQotPGJyPg0KK8KgIMKg
IMKgIMKgcmV0dXJuIDA7PGJyPg0KK291dDo8YnI+DQorwqAgwqAgwqAgwqBwcmludF9yZXNlcnZh
dGlvbl9rZXkoYnVmZiwgMTIsICZhbXA7bXAtJmd0O3Jlc2VydmF0aW9uX2tleSk7PGJyPg0KK8Kg
IMKgIMKgIMKgY29uZGxvZygzLCAmcXVvdDslczogcmVzZXJ2YXRpb25fa2V5ID0gJXMgJXMmcXVv
dDssIG1wLSZndDthbGlhcywgYnVmZiwgb3JpZ2luKTs8YnI+DQrCoCDCoCDCoCDCoCByZXR1cm4g
MDs8YnI+DQrCoH08YnI+DQo8YnI+DQrCoGV4dGVybiBpbnQ8YnI+DQrCoHNlbGVjdF9yZXRhaW5f
aHdoYW5kbGVyIChzdHJ1Y3QgbXVsdGlwYXRoICogbXApPGJyPg0KwqB7PGJyPg0KK8KgIMKgIMKg
IMKgY2hhciAqb3JpZ2luOzxicj4NCsKgIMKgIMKgIMKgIHVuc2lnbmVkIGludCBtaW52X2RtX3Jl
dGFpblszXSA9IHsxLCA1LCAwfTs8YnI+DQo8YnI+DQrCoCDCoCDCoCDCoCBpZiAoIVZFUlNJT05f
R0UoY29uZi0mZ3Q7dmVyc2lvbiwgbWludl9kbV9yZXRhaW4pKSB7PGJyPg0KwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgbXAtJmd0O3JldGFpbl9od2hhbmRsZXIgPSBSRVRBSU5fSFdIQU5ETEVSX09G
Rjs8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBjb25kbG9nKDMsICZxdW90OyVzOiByZXRh
aW5fYXR0YWNoZWRfaHdfaGFuZGxlciBkaXNhYmxlZCAocmVxdWlyZXMga2VybmVsIHZlcnNpb24g
Jmd0Oz0gMS41LjApJnF1b3Q7LCBtcC0mZ3Q7YWxpYXMpOzxicj4NCi3CoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoHJldHVybiAwOzxicj4NCi3CoCDCoCDCoCDCoH08YnI+DQotPGJyPg0KLcKgIMKgIMKg
IMKgaWYgKG1wLSZndDtod2UgJmFtcDsmYW1wOyBtcC0mZ3Q7aHdlLSZndDtyZXRhaW5faHdoYW5k
bGVyKSB7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgbXAtJmd0O3JldGFpbl9od2hhbmRs
ZXIgPSBtcC0mZ3Q7aHdlLSZndDtyZXRhaW5faHdoYW5kbGVyOzxicj4NCi3CoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoGNvbmRsb2coMywgJnF1b3Q7JXM6IHJldGFpbl9hdHRhY2hlZF9od19oYW5kbGVy
ID0gJWQgKGNvbnRyb2xsZXIgZGVmYXVsdCkmcXVvdDssIG1wLSZndDthbGlhcywgbXAtJmd0O3Jl
dGFpbl9od2hhbmRsZXIpOzxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoHJldHVybiAwOzxi
cj4NCi3CoCDCoCDCoCDCoH08YnI+DQotwqAgwqAgwqAgwqBpZiAoY29uZi0mZ3Q7cmV0YWluX2h3
aGFuZGxlcikgezxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoG1wLSZndDtyZXRhaW5faHdo
YW5kbGVyID0gY29uZi0mZ3Q7cmV0YWluX2h3aGFuZGxlcjs8YnI+DQotwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqBjb25kbG9nKDMsICZxdW90OyVzOiByZXRhaW5fYXR0YWNoZWRfaHdfaGFuZGxlciA9
ICVkIChjb25maWcgZmlsZSBkZWZhdWx0KSZxdW90OywgbXAtJmd0O2FsaWFzLCBtcC0mZ3Q7cmV0
YWluX2h3aGFuZGxlcik7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgcmV0dXJuIDA7PGJy
Pg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgb3JpZ2luID0gJnF1b3Q7KHJlcXVpcmVzIGtlcm5l
bCB2ZXJzaW9uICZndDs9IDEuNS4wKSZxdW90Ozs8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqBnb3RvIG91dDs8YnI+DQrCoCDCoCDCoCDCoCB9PGJyPg0KLcKgIMKgIMKgIMKgbXAtJmd0O3Jl
dGFpbl9od2hhbmRsZXIgPSAwOzxicj4NCi3CoCDCoCDCoCDCoGNvbmRsb2coMywgJnF1b3Q7JXM6
IHJldGFpbl9hdHRhY2hlZF9od19oYW5kbGVyID0gJWQgKGNvbXBpbGVkIGluIGRlZmF1bHQpJnF1
b3Q7LCBtcC0mZ3Q7YWxpYXMsIG1wLSZndDtyZXRhaW5faHdoYW5kbGVyKTs8YnI+DQorwqAgwqAg
wqAgwqBtcF9zZXRfaHdlKHJldGFpbl9od2hhbmRsZXIpOzxicj4NCivCoCDCoCDCoCDCoG1wX3Nl
dF9jb25mKHJldGFpbl9od2hhbmRsZXIpOzxicj4NCivCoCDCoCDCoCDCoG1wX3NldF9kZWZhdWx0
KHJldGFpbl9od2hhbmRsZXIsIERFRkFVTFRfUkVUQUlOX0hXSEFORExFUik7PGJyPg0KK291dDo8
YnI+DQorwqAgwqAgwqAgwqBjb25kbG9nKDMsICZxdW90OyVzOiByZXRhaW5fYXR0YWNoZWRfaHdf
aGFuZGxlciA9ICVzICVzJnF1b3Q7LCBtcC0mZ3Q7YWxpYXMsPGJyPg0KK8KgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgKG1wLSZndDtyZXRhaW5faHdoYW5kbGVyID09IFJFVEFJTl9IV0hBTkRMRVJfT04p
PyAmcXVvdDt5ZXMmcXVvdDsgOiAmcXVvdDtubyZxdW90Oyw8YnI+DQorwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqBvcmlnaW4pOzxicj4NCsKgIMKgIMKgIMKgIHJldHVybiAwOzxicj4NCsKgfTxicj4N
Cjxicj4NCsKgZXh0ZXJuIGludDxicj4NCsKgc2VsZWN0X2RldGVjdF9wcmlvIChzdHJ1Y3QgcGF0
aCAqIHBwKTxicj4NCsKgezxicj4NCi3CoCDCoCDCoCDCoGlmIChwcC0mZ3Q7aHdlICZhbXA7JmFt
cDsgcHAtJmd0O2h3ZS0mZ3Q7ZGV0ZWN0X3ByaW8pIHs8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqBwcC0mZ3Q7ZGV0ZWN0X3ByaW8gPSBwcC0mZ3Q7aHdlLSZndDtkZXRlY3RfcHJpbzs8YnI+
DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBjb25kbG9nKDMsICZxdW90OyVzOiBkZXRlY3RfcHJp
byA9ICVkIChjb250cm9sbGVyIGRlZmF1bHQpJnF1b3Q7LCBwcC0mZ3Q7ZGV2LCBwcC0mZ3Q7ZGV0
ZWN0X3ByaW8pOzxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoHJldHVybiAwOzxicj4NCi3C
oCDCoCDCoCDCoH08YnI+DQotwqAgwqAgwqAgwqBpZiAoY29uZi0mZ3Q7ZGV0ZWN0X3ByaW8pIHs8
YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBwcC0mZ3Q7ZGV0ZWN0X3ByaW8gPSBjb25mLSZn
dDtkZXRlY3RfcHJpbzs8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBjb25kbG9nKDMsICZx
dW90OyVzOiBkZXRlY3RfcHJpbyA9ICVkIChjb25maWcgZmlsZSBkZWZhdWx0KSZxdW90OywgcHAt
Jmd0O2RldiwgcHAtJmd0O2RldGVjdF9wcmlvKTs8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqByZXR1cm4gMDs8YnI+DQotwqAgwqAgwqAgwqB9PGJyPg0KLcKgIMKgIMKgIMKgcHAtJmd0O2Rl
dGVjdF9wcmlvID0gMDs8YnI+DQotwqAgwqAgwqAgwqBjb25kbG9nKDMsICZxdW90OyVzOiBkZXRl
Y3RfcHJpbyA9ICVkIChjb21waWxlZCBpbiBkZWZhdWx0KSZxdW90OywgcHAtJmd0O2RldiwgcHAt
Jmd0O2RldGVjdF9wcmlvKTs8YnI+DQorwqAgwqAgwqAgwqBjaGFyICpvcmlnaW47PGJyPg0KKzxi
cj4NCivCoCDCoCDCoCDCoHBwX3NldF9od2UoZGV0ZWN0X3ByaW8pOzxicj4NCivCoCDCoCDCoCDC
oHBwX3NldF9jb25mKGRldGVjdF9wcmlvKTs8YnI+DQorwqAgwqAgwqAgwqBwcF9zZXRfZGVmYXVs
dChkZXRlY3RfcHJpbywgREVGQVVMVF9ERVRFQ1RfUFJJTyk7PGJyPg0KK291dDo8YnI+DQorwqAg
wqAgwqAgwqBjb25kbG9nKDMsICZxdW90OyVzOiBkZXRlY3RfcHJpbyA9ICVzICVzJnF1b3Q7LCBw
cC0mZ3Q7ZGV2LDxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoChwcC0mZ3Q7ZGV0ZWN0X3By
aW8gPT0gREVURUNUX1BSSU9fT04pPyAmcXVvdDt5ZXMmcXVvdDsgOiAmcXVvdDtubyZxdW90Oywg
b3JpZ2luKTs8YnI+DQrCoCDCoCDCoCDCoCByZXR1cm4gMDs8YnI+DQrCoH08YnI+DQo8c3BhbiBj
bGFzcz0iSE9FblpiIj48Zm9udCBjb2xvcj0iIzg4ODg4OCI+LS08YnI+DQoxLjguMy4xPGJyPg0K
PGJyPg0KPC9mb250Pjwvc3Bhbj48L2Jsb2NrcXVvdGU+PC9kaXY+PGJyPjwvZGl2Pg0K
--047d7b34318a3c8731050c2bc7b9--


--===============7368921032232240824==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7368921032232240824==--
