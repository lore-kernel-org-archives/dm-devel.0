From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: improve processing
 efficiency for addition and deletion of multipath devices
Date: Wed, 1 Mar 2017 01:39:56 +0100
Message-ID: <CABr-GncncrKvuSCTws3J_PNuQHty31tvf6OhEgYmoCK3Nfe8cw@mail.gmail.com>
References: <1488265549-1936-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5142436928728946796=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1488265549-1936-1-git-send-email-tang.junhui@zte.com.cn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: tang.junhui@zte.com.cn
Cc: zhang.kai16@zte.com.cn, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============5142436928728946796==
Content-Type: multipart/alternative; boundary=001a113524923ab6f40549a08d61

--001a113524923ab6f40549a08d61
Content-Type: text/plain; charset=UTF-8

Applied.
Thanks.

On Tue, Feb 28, 2017 at 8:05 AM, <tang.junhui@zte.com.cn> wrote:

> From: "tang.junhui" <tang.junhui@zte.com.cn>
>
> This patch used to improve processing efficiency for addition and deletion
> of multipath devices.
>
> This patch is tested pass by ZTE multipath automatic testing system.
> The modification reduces the system consumption(such as CPU) and shortens
> the processing time obviously in scene of massive multipath devices
> addition or deletion.
>
> The main processing flow of code is:
> 1) add uid_attrs configuration in the defaults section:
>    It is configured udev attribute which providing a unique path identifier
>    for corresponding type of path devices. If this field is configured and
>    matched with type of device, it would override any other methods
>    providing for device unique identifier in config file, and it would
>    activate merging uevents according to the identifier to promote
> effiecncy
>    in processing uevents. Tt has no default value, so defaultly only
> uevents
>    filtering works, and uevents merging does not works, if users want to
>    identify path by udev attribute and to activate merging uevents for SCSI
>    and DAS device, they can set it's value as:
>    "sd:ID_SERIAL dasd:ID_UID"
> 2) uevents accumulation in uevents burst scene:
>    wait one seconds for more uevents in uevent_listen() in uevents burst
>    situations
> 3) uevents preparing, filtering and merging:
>    discard unuse uevents and fetch path idendifier from uevents;
>    filter uevents;
>    merge uevents.
> 4) uevents proccessing:
>    proccess the merged uevents in uev->merge_node list without calling
>    domap();
>    proccess the last uevents uev with calling domap().
>
> Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
> ---
>  libmultipath/config.c      |   3 +
>  libmultipath/config.h      |   1 +
>  libmultipath/dict.c        |   3 +
>  libmultipath/discovery.c   |   5 +-
>  libmultipath/discovery.h   |   2 +-
>  libmultipath/list.h        |  41 ++++++
>  libmultipath/propsel.c     |   7 +
>  libmultipath/uevent.c      | 320 ++++++++++++++++++++++++++++++
> +++++++++++++--
>  libmultipath/uevent.h      |   2 +
>  libmultipath/util.c        |  42 ++++++
>  libmultipath/util.h        |   1 +
>  multipath/multipath.conf.5 |  18 +++
>  multipathd/cli_handlers.c  |   4 +-
>  multipathd/main.c          |  93 +++++--------
>  multipathd/main.h          |   4 +-
>  15 files changed, 471 insertions(+), 75 deletions(-)
>
> diff --git a/libmultipath/config.c b/libmultipath/config.c
> index 9d3f3e1..bb6619b 100644
> --- a/libmultipath/config.c
> +++ b/libmultipath/config.c
> @@ -493,6 +493,9 @@ free_config (struct config * conf)
>         if (conf->uid_attribute)
>                 FREE(conf->uid_attribute);
>
> +       if (conf->uid_attrs)
> +               FREE(conf->uid_attrs);
> +
>         if (conf->getuid)
>                 FREE(conf->getuid);
>
> diff --git a/libmultipath/config.h b/libmultipath/config.h
> index 9a90745..4f1d596 100644
> --- a/libmultipath/config.h
> +++ b/libmultipath/config.h
> @@ -164,6 +164,7 @@ struct config {
>
>         char * multipath_dir;
>         char * selector;
> +       char * uid_attrs;
>         char * uid_attribute;
>         char * getuid;
>         char * features;
> diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> index bababdb..82066f6 100644
> --- a/libmultipath/dict.c
> +++ b/libmultipath/dict.c
> @@ -249,6 +249,8 @@ declare_ovr_snprint(selector, print_str)
>  declare_mp_handler(selector, set_str)
>  declare_mp_snprint(selector, print_str)
>
> +declare_def_handler(uid_attrs, set_str)
> +declare_def_snprint(uid_attrs, print_str)
>  declare_def_handler(uid_attribute, set_str)
>  declare_def_snprint_defstr(uid_attribute, print_str,
> DEFAULT_UID_ATTRIBUTE)
>  declare_ovr_handler(uid_attribute, set_str)
> @@ -1396,6 +1398,7 @@ init_keywords(vector keywords)
>         install_keyword("multipath_dir", &def_multipath_dir_handler,
> &snprint_def_multipath_dir);
>         install_keyword("path_selector", &def_selector_handler,
> &snprint_def_selector);
>         install_keyword("path_grouping_policy", &def_pgpolicy_handler,
> &snprint_def_pgpolicy);
> +       install_keyword("uid_attrs", &def_uid_attrs_handler,
> &snprint_def_uid_attrs);
>         install_keyword("uid_attribute", &def_uid_attribute_handler,
> &snprint_def_uid_attribute);
>         install_keyword("getuid_callout", &def_getuid_handler,
> &snprint_def_getuid);
>         install_keyword("prio", &def_prio_name_handler,
> &snprint_def_prio_name);
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index 4e99845..7398040 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -34,7 +34,7 @@
>
>  int
>  alloc_path_with_pathinfo (struct config *conf, struct udev_device
> *udevice,
> -                         int flag, struct path **pp_ptr)
> +                         char *wwid, int flag, struct path **pp_ptr)
>  {
>         int err = PATHINFO_FAILED;
>         struct path * pp;
> @@ -52,6 +52,9 @@ alloc_path_with_pathinfo (struct config *conf, struct
> udev_device *udevice,
>         if (!pp)
>                 return PATHINFO_FAILED;
>
> +       if(wwid)
> +               strncpy(pp->wwid, wwid, sizeof(pp->wwid));
> +
>         if (safe_sprintf(pp->dev, "%s", devname)) {
>                 condlog(0, "pp->dev too small");
>         } else {
> diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
> index 3039268..d16a69a 100644
> --- a/libmultipath/discovery.h
> +++ b/libmultipath/discovery.h
> @@ -37,7 +37,7 @@ int path_offline (struct path *);
>  int get_state (struct path * pp, struct config * conf, int daemon);
>  int pathinfo (struct path * pp, struct config * conf, int mask);
>  int alloc_path_with_pathinfo (struct config *conf, struct udev_device
> *udevice,
> -                             int flag, struct path **pp_ptr);
> +                             char *wwid, int flag, struct path **pp_ptr);
>  int store_pathinfo (vector pathvec, struct config *conf,
>                     struct udev_device *udevice, int flag,
>                     struct path **pp_ptr);
> diff --git a/libmultipath/list.h b/libmultipath/list.h
> index ceaa381..2b1dcf3 100644
> --- a/libmultipath/list.h
> +++ b/libmultipath/list.h
> @@ -317,4 +317,45 @@ static inline void list_splice_tail_init(struct
> list_head *list,
>              &pos->member != (head);                                    \
>              pos = n, n = list_entry(n->member.next, typeof(*n), member))
>
> +/**
> + * list_for_each_entry_reverse_safe - iterate backwards over list of
> given type safe against removal of list entry
> + * @pos:       the type * to use as a loop counter.
> + * @n:         another type * to use as temporary storage
> + * @head:      the head for your list.
> + * @member:    the name of the list_struct within the struct.
> + */
> +#define list_for_each_entry_reverse_safe(pos, n, head, member)          \
> +       for (pos = list_entry((head)->prev, typeof(*pos), member),      \
> +                n = list_entry(pos->member.prev, typeof(*pos), member);\
> +            &pos->member != (head);                                    \
> +            pos = n, n = list_entry(n->member.prev, typeof(*n), member))
> +
> +/**
> + * list_for_some_entry_safe - iterate list from the given begin node to
> the given end node safe against removal of list entry
> + * @pos:       the type * to use as a loop counter.
> + * @n:         another type * to use as temporary storage
> + * @from:      the begin node of the iteration.
> + * @to:                the end node of the iteration.
> + * @member:    the name of the list_struct within the struct.
> + */
> +#define list_for_some_entry_safe(pos, n, from, to, member)              \
> +       for (pos = list_entry((from)->next, typeof(*pos), member),      \
> +            n = list_entry(pos->member.next, typeof(*pos), member);    \
> +            &pos->member != (to);                                      \
> +            pos = n, n = list_entry(n->member.next, typeof(*n), member))
> +
> +/**
> + * list_for_some_entry_reverse_safe - iterate backwards list from the
> given begin node to the given end node safe against removal of list entry
> + * @pos:       the type * to use as a loop counter.
> + * @n:         another type * to use as temporary storage
> + * @from:      the begin node of the iteration.
> + * @to:                the end node of the iteration.
> + * @member:    the name of the list_struct within the struct.
> + */
> +#define list_for_some_entry_reverse_safe(pos, n, from, to, member)      \
> +       for (pos = list_entry((from)->prev, typeof(*pos), member),      \
> +            n = list_entry(pos->member.prev, typeof(*pos), member);    \
> +            &pos->member != (to);                                      \
> +            pos = n, n = list_entry(n->member.prev, typeof(*n), member))
> +
>  #endif /* _LIST_H */
> diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> index bba8194..38eb424 100644
> --- a/libmultipath/propsel.c
> +++ b/libmultipath/propsel.c
> @@ -18,6 +18,7 @@
>  #include "prio.h"
>  #include "discovery.h"
>  #include "dict.h"
> +#include "util.h"
>  #include "prioritizers/alua_rtpg.h"
>  #include <inttypes.h>
>
> @@ -344,6 +345,12 @@ int select_getuid(struct config *conf, struct path
> *pp)
>  {
>         char *origin;
>
> +       pp->uid_attribute = parse_uid_attribute_by_attrs(conf->uid_attrs,
> pp->dev);
> +       if (pp->uid_attribute) {
> +               origin = "(setting: multipath.conf defaults section)";
> +               goto out;
> +       }
> +
>         pp_set_ovr(getuid);
>         pp_set_ovr(uid_attribute);
>         pp_set_hwe(getuid);
> diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
> index 7edcce1..6e2527b 100644
> --- a/libmultipath/uevent.c
> +++ b/libmultipath/uevent.c
> @@ -24,6 +24,7 @@
>
>  #include <unistd.h>
>  #include <stdio.h>
> +#include <stdbool.h>
>  #include <errno.h>
>  #include <stdlib.h>
>  #include <stddef.h>
> @@ -38,6 +39,7 @@
>  #include <linux/netlink.h>
>  #include <pthread.h>
>  #include <sys/mman.h>
> +#include <sys/time.h>
>  #include <libudev.h>
>  #include <errno.h>
>
> @@ -46,6 +48,14 @@
>  #include "list.h"
>  #include "uevent.h"
>  #include "vector.h"
> +#include "structs.h"
> +#include "util.h"
> +#include "config.h"
> +#include "blacklist.h"
> +
> +#define MAX_ACCUMULATION_COUNT 2048
> +#define MAX_ACCUMULATION_TIME 30*1000
> +#define MIN_BURST_SPEED 10
>
>  typedef int (uev_trigger)(struct uevent *, void * trigger_data);
>
> @@ -72,48 +82,301 @@ struct uevent * alloc_uevent (void)
>  {
>         struct uevent *uev = MALLOC(sizeof(struct uevent));
>
> -       if (uev)
> +       if (uev) {
>                 INIT_LIST_HEAD(&uev->node);
> +               INIT_LIST_HEAD(&uev->merge_node);
> +       }
>
>         return uev;
>  }
>
>  void
> -service_uevq(struct list_head *tmpq)
> +uevq_cleanup(struct list_head *tmpq)
>  {
>         struct uevent *uev, *tmp;
>
>         list_for_each_entry_safe(uev, tmp, tmpq, node) {
>                 list_del_init(&uev->node);
>
> -               if (my_uev_trigger && my_uev_trigger(uev, my_trigger_data))
> -                       condlog(0, "uevent trigger error");
> -
>                 if (uev->udev)
>                         udev_device_unref(uev->udev);
>                 FREE(uev);
>         }
>  }
>
> -static void uevent_cleanup(void *arg)
> +void
> +uevent_get_wwid(struct uevent *uev)
>  {
> -       struct udev *udev = arg;
> +       int i;
> +       char *uid_attribute;
> +       struct config * conf;
>
> -       condlog(3, "Releasing uevent_listen() resources");
> -       udev_unref(udev);
> +       conf = get_multipath_config();
> +       uid_attribute = parse_uid_attribute_by_attrs(conf->uid_attrs,
> uev->kernel);
> +       put_multipath_config(conf);
> +
> +       if (!uid_attribute)
> +               return;
> +
> +       for (i = 0; uev->envp[i] != NULL; i++) {
> +               if (!strncmp(uev->envp[i], uid_attribute,
> strlen(uid_attribute)) &&
> +                   strlen(uev->envp[i]) > strlen(uid_attribute) &&
> +                   uev->envp[i][strlen(uid_attribute)] == '=') {
> +                       uev->wwid = uev->envp[i] + strlen(uid_attribute) +
> 1;
> +                       break;
> +               }
> +       }
> +       free(uid_attribute);
> +}
> +
> +bool
> +uevent_need_merge(void)
> +{
> +       struct config * conf;
> +       bool need_merge = false;
> +
> +       conf = get_multipath_config();
> +       if (conf->uid_attrs)
> +               need_merge = true;
> +       put_multipath_config(conf);
> +
> +       return need_merge;
> +}
> +
> +bool
> +uevent_can_discard(struct uevent *uev)
> +{
> +       char *tmp;
> +       char a[11], b[11];
> +       struct config * conf;
> +
> +       /*
> +        * keep only block devices, discard partitions
> +        */
> +       tmp = strstr(uev->devpath, "/block/");
> +       if (tmp == NULL){
> +               condlog(4, "no /block/ in '%s'", uev->devpath);
> +               return true;
> +       }
> +       if (sscanf(tmp, "/block/%10s", a) != 1 ||
> +           sscanf(tmp, "/block/%10[^/]/%10s", a, b) == 2) {
> +               condlog(4, "discard event on %s", uev->devpath);
> +               return true;
> +       }
> +
> +       /*
> +        * do not filter dm devices by devnode
> +        */
> +       if (!strncmp(uev->kernel, "dm-", 3))
> +               return false;
> +       /*
> +        * filter paths devices by devnode
> +        */
> +       conf = get_multipath_config();
> +       if (filter_devnode(conf->blist_devnode, conf->elist_devnode,
> +                          uev->kernel) > 0) {
> +               put_multipath_config(conf);
> +               return true;
> +       }
> +       put_multipath_config(conf);
> +
> +       return false;
> +}
> +
> +bool
> +uevent_can_filter(struct uevent *earlier, struct uevent *later)
> +{
> +
> +       /*
> +        * filter earlier uvents if path has removed later. Eg:
> +        * "add path1 |chang path1 |add path2 |remove path1"
> +        * can filter as:
> +        * "add path2 |remove path1"
> +        * uevents "add path1" and "chang path1" are filtered out
> +        */
> +       if (!strcmp(earlier->kernel, later->kernel) &&
> +               !strcmp(later->action, "remove") &&
> +               strncmp(later->kernel, "dm-", 3)) {
> +               return true;
> +       }
> +
> +       /*
> +        * filter change uvents if add uevents exist. Eg:
> +        * "change path1| add path1 |add path2"
> +        * can filter as:
> +        * "add path1 |add path2"
> +        * uevent "chang path1" is filtered out
> +        */
> +       if (!strcmp(earlier->kernel, later->kernel) &&
> +               !strcmp(earlier->action, "change") &&
> +               !strcmp(later->action, "add") &&
> +               strncmp(later->kernel, "dm-", 3)) {
> +               return true;
> +       }
> +
> +       return false;
> +}
> +
> +bool
> +merge_need_stop(struct uevent *earlier, struct uevent *later)
> +{
> +       /*
> +        * dm uevent do not try to merge with left uevents
> +        */
> +       if (!strncmp(later->kernel, "dm-", 3))
> +               return true;
> +
> +       /*
> +        * we can not make a jugement without wwid,
> +        * so it is sensible to stop merging
> +        */
> +       if (!earlier->wwid || !later->wwid)
> +               return true;
> +       /*
> +        * uevents merging stoped
> +        * when we meet an opposite action uevent from the same LUN to
> AVOID
> +        * "add path1 |remove path1 |add path2 |remove path2 |add path3"
> +        * to merge as "remove path1, path2" and "add path1, path2, path3"
> +        * OR
> +        * "remove path1 |add path1 |remove path2 |add path2 |remove path3"
> +        * to merge as "add path1, path2" and "remove path1, path2, path3"
> +        * SO
> +        * when we meet a non-change uevent from the same LUN
> +        * with the same wwid and different action
> +        * it would be better to stop merging.
> +        */
> +       if (!strcmp(earlier->wwid, later->wwid) &&
> +           strcmp(earlier->action, later->action) &&
> +           strcmp(earlier->action, "change") &&
> +           strcmp(later->action, "change"))
> +               return true;
> +
> +       return false;
> +}
> +
> +bool
> +uevent_can_merge(struct uevent *earlier, struct uevent *later)
> +{
> +       /* merge paths uevents
> +        * whose wwids exsit and are same
> +        * and actions are same,
> +        * and actions are addition or deletion
> +        */
> +       if (earlier->wwid && later->wwid &&
> +           !strcmp(earlier->wwid, later->wwid) &&
> +           !strcmp(earlier->action, later->action) &&
> +           strncmp(earlier->action, "change", 6) &&
> +           strncmp(earlier->kernel, "dm-", 3)) {
> +               return true;
> +       }
> +
> +       return false;
>  }
>
>  void
> -uevq_cleanup(struct list_head *tmpq)
> +uevent_prepare(struct list_head *tmpq)
> +{
> +       struct uevent *uev, *tmp;
> +
> +       list_for_each_entry_reverse_safe(uev, tmp, tmpq, node) {
> +               if (uevent_can_discard(uev)) {
> +                       list_del_init(&uev->node);
> +                       if (uev->udev)
> +                               udev_device_unref(uev->udev);
> +                       FREE(uev);
> +                       continue;
> +               }
> +
> +               if (strncmp(uev->kernel, "dm-", 3) &&
> +                   uevent_need_merge())
> +                       uevent_get_wwid(uev);
> +       }
> +}
> +
> +void
> +uevent_filter(struct uevent *later, struct list_head *tmpq)
> +{
> +       struct uevent *earlier, *tmp;
> +
> +       list_for_some_entry_reverse_safe(earlier, tmp, &later->node,
> tmpq, node) {
> +               /*
> +                * filter unnessary earlier uevents
> +                * by the later uevent
> +                */
> +               if (uevent_can_filter(earlier, later)) {
> +                       condlog(2, "uevent: %s-%s has filtered by uevent:
> %s-%s",
> +                               earlier->kernel, earlier->action,
> +                               later->kernel, later->action);
> +
> +                       list_del_init(&earlier->node);
> +                       if (earlier->udev)
> +                               udev_device_unref(earlier->udev);
> +                       FREE(earlier);
> +               }
> +       }
> +}
> +
> +void
> +uevent_merge(struct uevent *later, struct list_head *tmpq)
> +{
> +       struct uevent *earlier, *tmp;
> +
> +       list_for_some_entry_reverse_safe(earlier, tmp, &later->node,
> tmpq, node) {
> +               if (merge_need_stop(earlier, later))
> +                       break;
> +               /*
> +                * merge earlier uevents to the later uevent
> +                */
> +               if (uevent_can_merge(earlier, later)) {
> +                       condlog(2, "merged uevent: %s-%s-%s with uevent:
> %s-%s-%s",
> +                               earlier->action, earlier->kernel,
> earlier->wwid,
> +                               later->action, later->kernel, later->wwid);
> +
> +                       list_move(&earlier->node, &later->merge_node);
> +               }
> +       }
> +}
> +
> +void
> +merge_uevq(struct list_head *tmpq)
> +{
> +       struct uevent *later;
> +
> +       uevent_prepare(tmpq);
> +       list_for_each_entry_reverse(later, tmpq, node) {
> +               uevent_filter(later, tmpq);
> +               if(uevent_need_merge())
> +                       uevent_merge(later, tmpq);
> +       }
> +}
> +
> +void
> +service_uevq(struct list_head *tmpq)
>  {
>         struct uevent *uev, *tmp;
>
>         list_for_each_entry_safe(uev, tmp, tmpq, node) {
>                 list_del_init(&uev->node);
> +
> +               if (my_uev_trigger && my_uev_trigger(uev, my_trigger_data))
> +                       condlog(0, "uevent trigger error");
> +
> +               uevq_cleanup(&uev->merge_node);
> +
> +               if (uev->udev)
> +                       udev_device_unref(uev->udev);
>                 FREE(uev);
>         }
>  }
>
> +static void uevent_cleanup(void *arg)
> +{
> +       struct udev *udev = arg;
> +
> +       condlog(3, "Releasing uevent_listen() resources");
> +       udev_unref(udev);
> +}
> +
>  /*
>   * Service the uevent queue.
>   */
> @@ -142,6 +405,7 @@ int uevent_dispatch(int (*uev_trigger)(struct uevent
> *, void * trigger_data),
>                 pthread_mutex_unlock(uevq_lockp);
>                 if (!my_uev_trigger)
>                         break;
> +               merge_uevq(&uevq_tmp);
>                 service_uevq(&uevq_tmp);
>         }
>         condlog(3, "Terminating uev service queue");
> @@ -442,11 +706,43 @@ struct uevent *uevent_from_udev_device(struct
> udev_device *dev)
>         return uev;
>  }
>
> +bool uevent_burst(struct timeval *start_time, int events)
> +{
> +       struct timeval diff_time, end_time;
> +       unsigned long speed;
> +       unsigned long eclipse_ms;
> +
> +       if(events > MAX_ACCUMULATION_COUNT) {
> +               condlog(2, "burst got %u uevents, too much uevents,
> stopped", events);
> +               return false;
> +       }
> +
> +       gettimeofday(&end_time, NULL);
> +       timersub(&end_time, start_time, &diff_time);
> +
> +       eclipse_ms = diff_time.tv_sec * 1000 + diff_time.tv_usec / 1000;
> +
> +       if (eclipse_ms == 0)
> +               return true;
> +
> +       if (eclipse_ms > MAX_ACCUMULATION_TIME) {
> +               condlog(2, "burst continued %lu ms, too long time,
> stopped", eclipse_ms);
> +               return false;
> +       }
> +
> +       speed = (events * 1000) / eclipse_ms;
> +       if (speed > MIN_BURST_SPEED)
> +               return true;
> +
> +       return false;
> +}
> +
>  int uevent_listen(struct udev *udev)
>  {
>         int err = 2;
>         struct udev_monitor *monitor = NULL;
>         int fd, socket_flags, events;
> +       struct timeval start_time;
>         int need_failback = 1;
>         int timeout = 30;
>         LIST_HEAD(uevlisten_tmp);
> @@ -500,6 +796,7 @@ int uevent_listen(struct udev *udev)
>         }
>
>         events = 0;
> +       gettimeofday(&start_time, NULL);
>         while (1) {
>                 struct uevent *uev;
>                 struct udev_device *dev;
> @@ -514,7 +811,7 @@ int uevent_listen(struct udev *udev)
>                 errno = 0;
>                 fdcount = poll(&ev_poll, 1, poll_timeout);
>                 if (fdcount && ev_poll.revents & POLLIN) {
> -                       timeout = 0;
> +                       timeout = uevent_burst(&start_time, events + 1) ?
> 1 : 0;
>                         dev = udev_monitor_receive_device(monitor);
>                         if (!dev) {
>                                 condlog(0, "failed getting udev device");
> @@ -547,6 +844,7 @@ int uevent_listen(struct udev *udev)
>                         pthread_mutex_unlock(uevq_lockp);
>                         events = 0;
>                 }
> +               gettimeofday(&start_time, NULL);
>                 timeout = 30;
>         }
>         need_failback = 0;
> diff --git a/libmultipath/uevent.h b/libmultipath/uevent.h
> index 9d22dcd..61a4207 100644
> --- a/libmultipath/uevent.h
> +++ b/libmultipath/uevent.h
> @@ -17,11 +17,13 @@ struct udev;
>
>  struct uevent {
>         struct list_head node;
> +       struct list_head merge_node;
>         struct udev_device *udev;
>         char buffer[HOTPLUG_BUFFER_SIZE + OBJECT_SIZE];
>         char *devpath;
>         char *action;
>         char *kernel;
> +       char *wwid;
>         unsigned long seqnum;
>         char *envp[HOTPLUG_NUM_ENVP];
>  };
> diff --git a/libmultipath/util.c b/libmultipath/util.c
> index 1841f35..85d21fa 100644
> --- a/libmultipath/util.c
> +++ b/libmultipath/util.c
> @@ -262,6 +262,48 @@ dev_t parse_devt(const char *dev_t)
>         return makedev(maj, min);
>  }
>
> +char *parse_uid_attribute_by_attrs(char *uid_attrs, char *path_dev)
> +{
> +       char *uid_attribute;
> +       char *uid_attr_record;
> +       char *dev;
> +       char *attr;
> +       char *tmp;
> +       int  count;
> +
> +       if(!uid_attrs || !path_dev)
> +               return NULL;
> +
> +       count = get_word(uid_attrs, &uid_attr_record);
> +       while (uid_attr_record) {
> +               tmp = strrchr(uid_attr_record, ':');
> +               if (!tmp) {
> +                       free(uid_attr_record);
> +                       if (!count)
> +                               break;
> +                       uid_attrs += count;
> +                       count = get_word(uid_attrs, &uid_attr_record);
> +                       continue;
> +               }
> +               dev = uid_attr_record;
> +               attr = tmp + 1;
> +               *tmp = '\0';
> +
> +               if(!strncmp(path_dev, dev, strlen(dev))) {
> +                       uid_attribute = STRDUP(attr);
> +                       free(uid_attr_record);
> +                       return uid_attribute;
> +               }
> +
> +               free(uid_attr_record);
> +               if (!count)
> +                       break;
> +               uid_attrs += count;
> +               count = get_word(uid_attrs, &uid_attr_record);
> +       }
> +       return NULL;
> +}
> +
>  void
>  setup_thread_attr(pthread_attr_t *attr, size_t stacksize, int detached)
>  {
> diff --git a/libmultipath/util.h b/libmultipath/util.h
> index f3b37ee..793f2b7 100644
> --- a/libmultipath/util.h
> +++ b/libmultipath/util.h
> @@ -12,6 +12,7 @@ size_t strlcat(char *dst, const char *src, size_t size);
>  int devt2devname (char *, int, char *);
>  dev_t parse_devt(const char *dev_t);
>  char *convert_dev(char *dev, int is_path_device);
> +char *parse_uid_attribute_by_attrs(char *uid_attrs, char *path_dev);
>  void setup_thread_attr(pthread_attr_t *attr, size_t stacksize, int
> detached);
>
>  #define safe_sprintf(var, format, args...)     \
> diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> index b08bda3..efeead5 100644
> --- a/multipath/multipath.conf.5
> +++ b/multipath/multipath.conf.5
> @@ -207,6 +207,24 @@ The default is: \fBfailover\fR
>  .
>  .
>  .TP
> +.B uid_attrs
> +The udev attribute providing a unique path identifier for corresponding
> +type of path devices. If this field is configured and matched with type
> +of device, it would override any other methods providing for device
> +unique identifier in config file, and it would activate merging uevents
> +according to the identifier to promote effiecncy in processing uevents.
> +Tt has no default value, if you want to identify path by udev attribute
> +and to activate merging uevents for SCSI and DAS device, you can set
> +it's value as:
> +.RS
> +.TP
> +\fBuid_attrs "sd:ID_SERIAL dasd:ID_UID"\fR
> +.TP
> +The default is: \fB<unset>\fR
> +.RE
> +.
> +.
> +.TP
>  .B uid_attribute
>  The udev attribute providing a unique path identifier.
>  .RS
> diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> index b20b054..9e90328 100644
> --- a/multipathd/cli_handlers.c
> +++ b/multipathd/cli_handlers.c
> @@ -714,7 +714,7 @@ cli_add_path (void * v, char ** reply, int * len, void
> * data)
>                 pp->checkint = conf->checkint;
>         }
>         put_multipath_config(conf);
> -       return ev_add_path(pp, vecs);
> +       return ev_add_path(pp, vecs, 1);
>  blacklisted:
>         *reply = strdup("blacklisted\n");
>         *len = strlen(*reply) + 1;
> @@ -736,7 +736,7 @@ cli_del_path (void * v, char ** reply, int * len, void
> * data)
>                 condlog(0, "%s: path already removed", param);
>                 return 1;
>         }
> -       return ev_remove_path(pp, vecs);
> +       return ev_remove_path(pp, vecs, 1);
>  }
>
>  int
> diff --git a/multipathd/main.c b/multipathd/main.c
> index e317a4c..0c69f3b 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -611,7 +611,7 @@ ev_remove_map (char * devname, char * alias, int
> minor, struct vectors * vecs)
>  }
>
>  static int
> -uev_add_path (struct uevent *uev, struct vectors * vecs)
> +uev_add_path (struct uevent *uev, struct vectors * vecs, int need_do_map)
>  {
>         struct path *pp;
>         int ret = 0, i;
> @@ -644,7 +644,7 @@ uev_add_path (struct uevent *uev, struct vectors *
> vecs)
>                                      DI_ALL | DI_BLACKLIST);
>                         put_multipath_config(conf);
>                         if (r == PATHINFO_OK)
> -                               ret = ev_add_path(pp, vecs);
> +                               ret = ev_add_path(pp, vecs, need_do_map);
>                         else if (r == PATHINFO_SKIPPED) {
>                                 condlog(3, "%s: remove blacklisted path",
>                                         uev->kernel);
> @@ -668,7 +668,7 @@ uev_add_path (struct uevent *uev, struct vectors *
> vecs)
>          */
>         conf = get_multipath_config();
>         ret = alloc_path_with_pathinfo(conf, uev->udev,
> -                                      DI_ALL, &pp);
> +                                      uev->wwid, DI_ALL, &pp);
>         put_multipath_config(conf);
>         if (!pp) {
>                 if (ret == PATHINFO_SKIPPED)
> @@ -684,7 +684,7 @@ uev_add_path (struct uevent *uev, struct vectors *
> vecs)
>                 conf = get_multipath_config();
>                 pp->checkint = conf->checkint;
>                 put_multipath_config(conf);
> -               ret = ev_add_path(pp, vecs);
> +               ret = ev_add_path(pp, vecs, need_do_map);
>         } else {
>                 condlog(0, "%s: failed to store path info, "
>                         "dropping event",
> @@ -702,7 +702,7 @@ uev_add_path (struct uevent *uev, struct vectors *
> vecs)
>   * 1: error
>   */
>  int
> -ev_add_path (struct path * pp, struct vectors * vecs)
> +ev_add_path (struct path * pp, struct vectors * vecs, int need_do_map)
>  {
>         struct multipath * mpp;
>         char params[PARAMS_SIZE] = {0};
> @@ -771,6 +771,13 @@ rescan:
>         /* persistent reservation check*/
>         mpath_pr_event_handle(pp);
>
> +       if (!need_do_map)
> +               return 0;
> +
> +       if (!dm_map_present(mpp->alias)) {
> +               mpp->action = ACT_CREATE;
> +               start_waiter = 1;
> +       }
>         /*
>          * push the map to the device-mapper
>          */
> @@ -837,7 +844,7 @@ fail:
>  }
>
>  static int
> -uev_remove_path (struct uevent *uev, struct vectors * vecs)
> +uev_remove_path (struct uevent *uev, struct vectors * vecs, int
> need_do_map)
>  {
>         struct path *pp;
>         int ret;
> @@ -848,7 +855,7 @@ uev_remove_path (struct uevent *uev, struct vectors *
> vecs)
>         pthread_testcancel();
>         pp = find_path_by_dev(vecs->pathvec, uev->kernel);
>         if (pp)
> -               ret = ev_remove_path(pp, vecs);
> +               ret = ev_remove_path(pp, vecs, need_do_map);
>         lock_cleanup_pop(vecs->lock);
>         if (!pp) {
>                 /* Not an error; path might have been purged earlier */
> @@ -859,7 +866,7 @@ uev_remove_path (struct uevent *uev, struct vectors *
> vecs)
>  }
>
>  int
> -ev_remove_path (struct path *pp, struct vectors * vecs)
> +ev_remove_path (struct path *pp, struct vectors * vecs, int need_do_map)
>  {
>         struct multipath * mpp;
>         int i, retval = 0;
> @@ -922,6 +929,8 @@ ev_remove_path (struct path *pp, struct vectors * vecs)
>                         goto out;
>                 }
>
> +               if (!need_do_map)
> +                       goto out;
>                 /*
>                  * reload the map
>                  */
> @@ -999,7 +1008,7 @@ uev_update_path (struct uevent *uev, struct vectors *
> vecs)
>                 }
>
>                 if (pp->initialized == INIT_REQUESTED_UDEV)
> -                       retval = uev_add_path(uev, vecs);
> +                       retval = uev_add_path(uev, vecs, 1);
>                 else if (mpp && ro >= 0) {
>                         condlog(2, "%s: update path write_protect to '%d'
> (uevent)", uev->kernel, ro);
>
> @@ -1020,7 +1029,7 @@ out:
>                         int flag = DI_SYSFS | DI_WWID;
>
>                         conf = get_multipath_config();
> -                       retval = alloc_path_with_pathinfo(conf, uev->udev,
> flag, NULL);
> +                       retval = alloc_path_with_pathinfo(conf, uev->udev,
> uev->wwid, flag, NULL);
>                         put_multipath_config(conf);
>
>                         if (retval == PATHINFO_SKIPPED) {
> @@ -1090,40 +1099,15 @@ uxsock_trigger (char * str, char ** reply, int *
> len, bool is_root,
>         return r;
>  }
>
> -static int
> -uev_discard(char * devpath)
> -{
> -       char *tmp;
> -       char a[11], b[11];
> -
> -       /*
> -        * keep only block devices, discard partitions
> -        */
> -       tmp = strstr(devpath, "/block/");
> -       if (tmp == NULL){
> -               condlog(4, "no /block/ in '%s'", devpath);
> -               return 1;
> -       }
> -       if (sscanf(tmp, "/block/%10s", a) != 1 ||
> -           sscanf(tmp, "/block/%10[^/]/%10s", a, b) == 2) {
> -               condlog(4, "discard event on %s", devpath);
> -               return 1;
> -       }
> -       return 0;
> -}
> -
>  int
>  uev_trigger (struct uevent * uev, void * trigger_data)
>  {
>         int r = 0;
>         struct vectors * vecs;
> -       struct config *conf;
> +       struct uevent *merge_uev, *tmp;
>
>         vecs = (struct vectors *)trigger_data;
>
> -       if (uev_discard(uev->devpath))
> -               return 0;
> -
>         pthread_cleanup_push(config_cleanup, NULL);
>         pthread_mutex_lock(&config_lock);
>         if (running_state != DAEMON_IDLE &&
> @@ -1152,28 +1136,21 @@ uev_trigger (struct uevent * uev, void *
> trigger_data)
>         }
>
>         /*
> -        * path add/remove event
> +        * path add/remove/change event, add/remove maybe merged
>          */
> -       conf = get_multipath_config();
> -       if (filter_devnode(conf->blist_devnode, conf->elist_devnode,
> -                          uev->kernel) > 0) {
> -               put_multipath_config(conf);
> -               goto out;
> +       list_for_each_entry_safe(merge_uev, tmp, &uev->merge_node, node) {
> +               if (!strncmp(merge_uev->action, "add", 3))
> +                       r += uev_add_path(merge_uev, vecs, 0);
> +               if (!strncmp(merge_uev->action, "remove", 6))
> +                       r += uev_remove_path(merge_uev, vecs, 0);
>         }
> -       put_multipath_config(conf);
>
> -       if (!strncmp(uev->action, "add", 3)) {
> -               r = uev_add_path(uev, vecs);
> -               goto out;
> -       }
> -       if (!strncmp(uev->action, "remove", 6)) {
> -               r = uev_remove_path(uev, vecs);
> -               goto out;
> -       }
> -       if (!strncmp(uev->action, "change", 6)) {
> -               r = uev_update_path(uev, vecs);
> -               goto out;
> -       }
> +       if (!strncmp(uev->action, "add", 3))
> +               r += uev_add_path(uev, vecs, 1);
> +       if (!strncmp(uev->action, "remove", 6))
> +               r += uev_remove_path(uev, vecs, 1);
> +       if (!strncmp(uev->action, "change", 6))
> +               r += uev_update_path(uev, vecs);
>
>  out:
>         return r;
> @@ -1663,7 +1640,7 @@ check_path (struct vectors * vecs, struct path * pp,
> int ticks)
>                         conf = get_multipath_config();
>                         ret = pathinfo(pp, conf, DI_ALL | DI_BLACKLIST);
>                         if (ret == PATHINFO_OK) {
> -                               ev_add_path(pp, vecs);
> +                               ev_add_path(pp, vecs, 1);
>                                 pp->tick = 1;
>                         } else if (ret == PATHINFO_SKIPPED) {
>                                 put_multipath_config(conf);
> @@ -1785,7 +1762,7 @@ check_path (struct vectors * vecs, struct path * pp,
> int ticks)
>                 }
>                 if (!disable_reinstate && reinstate_path(pp, add_active)) {
>                         condlog(3, "%s: reload map", pp->dev);
> -                       ev_add_path(pp, vecs);
> +                       ev_add_path(pp, vecs, 1);
>                         pp->tick = 1;
>                         return 0;
>                 }
> @@ -1808,7 +1785,7 @@ check_path (struct vectors * vecs, struct path * pp,
> int ticks)
>                         /* Clear IO errors */
>                         if (reinstate_path(pp, 0)) {
>                                 condlog(3, "%s: reload map", pp->dev);
> -                               ev_add_path(pp, vecs);
> +                               ev_add_path(pp, vecs, 1);
>                                 pp->tick = 1;
>                                 return 0;
>                         }
> diff --git a/multipathd/main.h b/multipathd/main.h
> index f72580d..094b04f 100644
> --- a/multipathd/main.h
> +++ b/multipathd/main.h
> @@ -22,8 +22,8 @@ void exit_daemon(void);
>  const char * daemon_status(void);
>  int need_to_delay_reconfig (struct vectors *);
>  int reconfigure (struct vectors *);
> -int ev_add_path (struct path *, struct vectors *);
> -int ev_remove_path (struct path *, struct vectors *);
> +int ev_add_path (struct path *, struct vectors *, int);
> +int ev_remove_path (struct path *, struct vectors *, int);
>  int ev_add_map (char *, char *, struct vectors *);
>  int ev_remove_map (char *, char *, int, struct vectors *);
>  void sync_map_state (struct multipath *);
> --
> 2.8.1.windows.1
>
>
>

--001a113524923ab6f40549a08d61
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied.<div>Thanks.</div></div><div class=3D"gmail_extra"=
><br><div class=3D"gmail_quote">On Tue, Feb 28, 2017 at 8:05 AM,  <span dir=
=3D"ltr">&lt;<a href=3D"mailto:tang.junhui@zte.com.cn" target=3D"_blank">ta=
ng.junhui@zte.com.cn</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_qu=
ote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex=
">From: &quot;tang.junhui&quot; &lt;<a href=3D"mailto:tang.junhui@zte.com.c=
n">tang.junhui@zte.com.cn</a>&gt;<br>
<br>
This patch used to improve processing efficiency for addition and deletion<=
br>
of multipath devices.<br>
<br>
This patch is tested pass by ZTE multipath automatic testing system.<br>
The modification reduces the system consumption(such as CPU) and shortens<b=
r>
the processing time obviously in scene of massive multipath devices<br>
addition or deletion.<br>
<br>
The main processing flow of code is:<br>
1) add uid_attrs configuration in the defaults section:<br>
=C2=A0 =C2=A0It is configured udev attribute which providing a unique path =
identifier<br>
=C2=A0 =C2=A0for corresponding type of path devices. If this field is confi=
gured and<br>
=C2=A0 =C2=A0matched with type of device, it would override any other metho=
ds<br>
=C2=A0 =C2=A0providing for device unique identifier in config file, and it =
would<br>
=C2=A0 =C2=A0activate merging uevents according to the identifier to promot=
e effiecncy<br>
=C2=A0 =C2=A0in processing uevents. Tt has no default value, so defaultly o=
nly uevents<br>
=C2=A0 =C2=A0filtering works, and uevents merging does not works, if users =
want to<br>
=C2=A0 =C2=A0identify path by udev attribute and to activate merging uevent=
s for SCSI<br>
=C2=A0 =C2=A0and DAS device, they can set it&#39;s value as:<br>
=C2=A0 =C2=A0&quot;sd:ID_SERIAL dasd:ID_UID&quot;<br>
2) uevents accumulation in uevents burst scene:<br>
=C2=A0 =C2=A0wait one seconds for more uevents in uevent_listen() in uevent=
s burst<br>
=C2=A0 =C2=A0situations<br>
3) uevents preparing, filtering and merging:<br>
=C2=A0 =C2=A0discard unuse uevents and fetch path idendifier from uevents;<=
br>
=C2=A0 =C2=A0filter uevents;<br>
=C2=A0 =C2=A0merge uevents.<br>
4) uevents proccessing:<br>
=C2=A0 =C2=A0proccess the merged uevents in uev-&gt;merge_node list without=
 calling<br>
=C2=A0 =C2=A0domap();<br>
=C2=A0 =C2=A0proccess the last uevents uev with calling domap().<br>
<br>
Signed-off-by: tang.junhui &lt;<a href=3D"mailto:tang.junhui@zte.com.cn">ta=
ng.junhui@zte.com.cn</a>&gt;<br>
---<br>
=C2=A0libmultipath/config.c=C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A03 +<br>
=C2=A0libmultipath/config.h=C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A01 +<br>
=C2=A0libmultipath/dict.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A03 +<br>
=C2=A0libmultipath/discovery.c=C2=A0 =C2=A0|=C2=A0 =C2=A05 +-<br>
=C2=A0libmultipath/discovery.h=C2=A0 =C2=A0|=C2=A0 =C2=A02 +-<br>
=C2=A0libmultipath/list.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 41 ++++++<br>
=C2=A0libmultipath/propsel.c=C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A07 +<br>
=C2=A0libmultipath/uevent.c=C2=A0 =C2=A0 =C2=A0 | 320 +++++++++++++++++++++=
+++++++++<wbr>+++++++++++++--<br>
=C2=A0libmultipath/uevent.h=C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A02 +<br>
=C2=A0libmultipath/util.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 42 ++++++<br>
=C2=A0libmultipath/util.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A01 +<br>
=C2=A0multipath/multipath.conf.5 |=C2=A0 18 +++<br>
=C2=A0multipathd/cli_handlers.c=C2=A0 |=C2=A0 =C2=A04 +-<br>
=C2=A0multipathd/main.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 93 +++++-=
-------<br>
=C2=A0multipathd/main.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A04 +=
-<br>
=C2=A015 files changed, 471 insertions(+), 75 deletions(-)<br>
<br>
diff --git a/libmultipath/config.c b/libmultipath/config.c<br>
index 9d3f3e1..bb6619b 100644<br>
--- a/libmultipath/config.c<br>
+++ b/libmultipath/config.c<br>
@@ -493,6 +493,9 @@ free_config (struct config * conf)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (conf-&gt;uid_attribute)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 FREE(conf-&gt;uid_a=
ttribute);<br>
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (conf-&gt;uid_attrs)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0FREE(conf-&gt;uid_a=
ttrs);<br>
+<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (conf-&gt;getuid)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 FREE(conf-&gt;getui=
d);<br>
<br>
diff --git a/libmultipath/config.h b/libmultipath/config.h<br>
index 9a90745..4f1d596 100644<br>
--- a/libmultipath/config.h<br>
+++ b/libmultipath/config.h<br>
@@ -164,6 +164,7 @@ struct config {<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char * multipath_dir;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char * selector;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0char * uid_attrs;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char * uid_attribute;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char * getuid;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char * features;<br>
diff --git a/libmultipath/dict.c b/libmultipath/dict.c<br>
index bababdb..82066f6 100644<br>
--- a/libmultipath/dict.c<br>
+++ b/libmultipath/dict.c<br>
@@ -249,6 +249,8 @@ declare_ovr_snprint(selector, print_str)<br>
=C2=A0declare_mp_handler(selector, set_str)<br>
=C2=A0declare_mp_snprint(selector, print_str)<br>
<br>
+declare_def_handler(uid_<wbr>attrs, set_str)<br>
+declare_def_snprint(uid_<wbr>attrs, print_str)<br>
=C2=A0declare_def_handler(uid_<wbr>attribute, set_str)<br>
=C2=A0declare_def_snprint_defstr(<wbr>uid_attribute, print_str, DEFAULT_UID=
_ATTRIBUTE)<br>
=C2=A0declare_ovr_handler(uid_<wbr>attribute, set_str)<br>
@@ -1396,6 +1398,7 @@ init_keywords(vector keywords)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword(&quot;multipath_<wbr>dir&quot;,=
 &amp;def_multipath_dir_handler, &amp;snprint_def_multipath_dir);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword(&quot;path_<wbr>selector&quot;,=
 &amp;def_selector_handler, &amp;snprint_def_selector);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword(&quot;path_<wbr>grouping_policy=
&quot;, &amp;def_pgpolicy_handler, &amp;snprint_def_pgpolicy);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0install_keyword(&quot;uid_attrs&quot;, &amp;def=
_uid_attrs_handler, &amp;snprint_def_uid_attrs);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword(&quot;uid_<wbr>attribute&quot;,=
 &amp;def_uid_attribute_handler, &amp;snprint_def_uid_attribute);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword(&quot;getuid_<wbr>callout&quot;=
, &amp;def_getuid_handler, &amp;snprint_def_getuid);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword(&quot;prio&quot;, &amp;def_prio=
_name_handler, &amp;snprint_def_prio_name);<br>
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c<br>
index 4e99845..7398040 100644<br>
--- a/libmultipath/discovery.c<br>
+++ b/libmultipath/discovery.c<br>
@@ -34,7 +34,7 @@<br>
<br>
=C2=A0int<br>
=C2=A0alloc_path_with_pathinfo (struct config *conf, struct udev_device *ud=
evice,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0int flag, struct path **pp_ptr)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0char *wwid, int flag, struct path **pp_ptr)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int err =3D PATHINFO_FAILED;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct path * pp;<br>
@@ -52,6 +52,9 @@ alloc_path_with_pathinfo (struct config *conf, struct ude=
v_device *udevice,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!pp)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return PATHINFO_FAI=
LED;<br>
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if(wwid)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0strncpy(pp-&gt;wwid=
, wwid, sizeof(pp-&gt;wwid));<br>
+<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (safe_sprintf(pp-&gt;dev, &quot;%s&quot;, de=
vname)) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 condlog(0, &quot;pp=
-&gt;dev too small&quot;);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 } else {<br>
diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h<br>
index 3039268..d16a69a 100644<br>
--- a/libmultipath/discovery.h<br>
+++ b/libmultipath/discovery.h<br>
@@ -37,7 +37,7 @@ int path_offline (struct path *);<br>
=C2=A0int get_state (struct path * pp, struct config * conf, int daemon);<b=
r>
=C2=A0int pathinfo (struct path * pp, struct config * conf, int mask);<br>
=C2=A0int alloc_path_with_pathinfo (struct config *conf, struct udev_device=
 *udevice,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int flag, struct path **pp_ptr);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0char *wwid, int flag, struct path **pp_ptr);=
<br>
=C2=A0int store_pathinfo (vector pathvec, struct config *conf,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struc=
t udev_device *udevice, int flag,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struc=
t path **pp_ptr);<br>
diff --git a/libmultipath/list.h b/libmultipath/list.h<br>
index ceaa381..2b1dcf3 100644<br>
--- a/libmultipath/list.h<br>
+++ b/libmultipath/list.h<br>
@@ -317,4 +317,45 @@ static inline void list_splice_tail_init(struct list_h=
ead *list,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&amp;pos-&gt;member !=3D (h=
ead);=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 \<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pos =3D n, n =3D list_entry=
(n-&gt;member.next, typeof(*n), member))<br>
<br>
+/**<br>
+ * list_for_each_entry_reverse_<wbr>safe - iterate backwards over list of =
given type safe against removal of list entry<br>
+ * @pos:=C2=A0 =C2=A0 =C2=A0 =C2=A0the type * to use as a loop counter.<br=
>
+ * @n:=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0another type * to use as temporary=
 storage<br>
+ * @head:=C2=A0 =C2=A0 =C2=A0 the head for your list.<br>
+ * @member:=C2=A0 =C2=A0 the name of the list_struct within the struct.<br=
>
+ */<br>
+#define list_for_each_entry_reverse_<wbr>safe(pos, n, head, member)=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 \<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0for (pos =3D list_entry((head)-&gt;prev, typeof=
(*pos), member),=C2=A0 =C2=A0 =C2=A0 \<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 n =3D list_entry(p=
os-&gt;member.prev, typeof(*pos), member);\<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &amp;pos-&gt;member !=3D (head);=
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 \<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pos =3D n, n =3D list_entry(n-&g=
t;member.prev, typeof(*n), member))<br>
+<br>
+/**<br>
+ * list_for_some_entry_safe - iterate list from the given begin node to th=
e given end node safe against removal of list entry<br>
+ * @pos:=C2=A0 =C2=A0 =C2=A0 =C2=A0the type * to use as a loop counter.<br=
>
+ * @n:=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0another type * to use as temporary=
 storage<br>
+ * @from:=C2=A0 =C2=A0 =C2=A0 the begin node of the iteration.<br>
+ * @to:=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 the end nod=
e of the iteration.<br>
+ * @member:=C2=A0 =C2=A0 the name of the list_struct within the struct.<br=
>
+ */<br>
+#define list_for_some_entry_safe(pos, n, from, to, member)=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 \<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0for (pos =3D list_entry((from)-&gt;next, typeof=
(*pos), member),=C2=A0 =C2=A0 =C2=A0 \<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 n =3D list_entry(pos-&gt;member.=
next, typeof(*pos), member);=C2=A0 =C2=A0 \<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &amp;pos-&gt;member !=3D (to);=
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 \<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pos =3D n, n =3D list_entry(n-&g=
t;member.next, typeof(*n), member))<br>
+<br>
+/**<br>
+ * list_for_some_entry_reverse_<wbr>safe - iterate backwards list from the=
 given begin node to the given end node safe against removal of list entry<=
br>
+ * @pos:=C2=A0 =C2=A0 =C2=A0 =C2=A0the type * to use as a loop counter.<br=
>
+ * @n:=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0another type * to use as temporary=
 storage<br>
+ * @from:=C2=A0 =C2=A0 =C2=A0 the begin node of the iteration.<br>
+ * @to:=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 the end nod=
e of the iteration.<br>
+ * @member:=C2=A0 =C2=A0 the name of the list_struct within the struct.<br=
>
+ */<br>
+#define list_for_some_entry_reverse_<wbr>safe(pos, n, from, to, member)=C2=
=A0 =C2=A0 =C2=A0 \<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0for (pos =3D list_entry((from)-&gt;prev, typeof=
(*pos), member),=C2=A0 =C2=A0 =C2=A0 \<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 n =3D list_entry(pos-&gt;member.=
prev, typeof(*pos), member);=C2=A0 =C2=A0 \<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &amp;pos-&gt;member !=3D (to);=
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 \<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pos =3D n, n =3D list_entry(n-&g=
t;member.prev, typeof(*n), member))<br>
+<br>
=C2=A0#endif /* _LIST_H */<br>
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c<br>
index bba8194..38eb424 100644<br>
--- a/libmultipath/propsel.c<br>
+++ b/libmultipath/propsel.c<br>
@@ -18,6 +18,7 @@<br>
=C2=A0#include &quot;prio.h&quot;<br>
=C2=A0#include &quot;discovery.h&quot;<br>
=C2=A0#include &quot;dict.h&quot;<br>
+#include &quot;util.h&quot;<br>
=C2=A0#include &quot;prioritizers/alua_rtpg.h&quot;<br>
=C2=A0#include &lt;inttypes.h&gt;<br>
<br>
@@ -344,6 +345,12 @@ int select_getuid(struct config *conf, struct path *pp=
)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *origin;<br>
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0pp-&gt;uid_attribute =3D parse_uid_attribute_by=
_attrs(<wbr>conf-&gt;uid_attrs, pp-&gt;dev);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (pp-&gt;uid_attribute) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0origin =3D &quot;(s=
etting: multipath.conf defaults section)&quot;;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 pp_set_ovr(getuid);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 pp_set_ovr(uid_attribute);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 pp_set_hwe(getuid);<br>
diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c<br>
index 7edcce1..6e2527b 100644<br>
--- a/libmultipath/uevent.c<br>
+++ b/libmultipath/uevent.c<br>
@@ -24,6 +24,7 @@<br>
<br>
=C2=A0#include &lt;unistd.h&gt;<br>
=C2=A0#include &lt;stdio.h&gt;<br>
+#include &lt;stdbool.h&gt;<br>
=C2=A0#include &lt;errno.h&gt;<br>
=C2=A0#include &lt;stdlib.h&gt;<br>
=C2=A0#include &lt;stddef.h&gt;<br>
@@ -38,6 +39,7 @@<br>
=C2=A0#include &lt;linux/netlink.h&gt;<br>
=C2=A0#include &lt;pthread.h&gt;<br>
=C2=A0#include &lt;sys/mman.h&gt;<br>
+#include &lt;sys/time.h&gt;<br>
=C2=A0#include &lt;libudev.h&gt;<br>
=C2=A0#include &lt;errno.h&gt;<br>
<br>
@@ -46,6 +48,14 @@<br>
=C2=A0#include &quot;list.h&quot;<br>
=C2=A0#include &quot;uevent.h&quot;<br>
=C2=A0#include &quot;vector.h&quot;<br>
+#include &quot;structs.h&quot;<br>
+#include &quot;util.h&quot;<br>
+#include &quot;config.h&quot;<br>
+#include &quot;blacklist.h&quot;<br>
+<br>
+#define MAX_ACCUMULATION_COUNT 2048<br>
+#define MAX_ACCUMULATION_TIME 30*1000<br>
+#define MIN_BURST_SPEED 10<br>
<br>
=C2=A0typedef int (uev_trigger)(struct uevent *, void * trigger_data);<br>
<br>
@@ -72,48 +82,301 @@ struct uevent * alloc_uevent (void)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct uevent *uev =3D MALLOC(sizeof(struct uev=
ent));<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (uev)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (uev) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 INIT_LIST_HEAD(&amp=
;uev-&gt;node);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0INIT_LIST_HEAD(&amp=
;uev-&gt;merge_<wbr>node);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return uev;<br>
=C2=A0}<br>
<br>
=C2=A0void<br>
-service_uevq(struct list_head *tmpq)<br>
+uevq_cleanup(struct list_head *tmpq)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct uevent *uev, *tmp;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 list_for_each_entry_safe(uev, tmp, tmpq, node) =
{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 list_del_init(&amp;=
uev-&gt;node);<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (my_uev_trigger =
&amp;&amp; my_uev_trigger(uev, my_trigger_data))<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0condlog(0, &quot;uevent trigger error&quot;);<br>
-<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (uev-&gt;udev)<b=
r>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 udev_device_unref(uev-&gt;udev);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 FREE(uev);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0}<br>
<br>
-static void uevent_cleanup(void *arg)<br>
+void<br>
+uevent_get_wwid(struct uevent *uev)<br>
=C2=A0{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0struct udev *udev =3D arg;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0int i;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0char *uid_attribute;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct config * conf;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(3, &quot;Releasing uevent_listen() reso=
urces&quot;);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0udev_unref(udev);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0conf =3D get_multipath_config();<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0uid_attribute =3D parse_uid_attribute_by_attrs(=
<wbr>conf-&gt;uid_attrs, uev-&gt;kernel);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0put_multipath_config(conf);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!uid_attribute)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 0; uev-&gt;envp[i] !=3D NULL; i++) {=
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!strncmp(uev-&g=
t;envp[i], uid_attribute, strlen(uid_attribute)) &amp;&amp;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0strle=
n(uev-&gt;envp[i]) &gt; strlen(uid_attribute) &amp;&amp;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0uev-&=
gt;envp[i][strlen(uid_<wbr>attribute)] =3D=3D &#39;=3D&#39;) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0uev-&gt;wwid =3D uev-&gt;envp[i] + strlen(uid_attribute) + 1;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0break;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0free(uid_attribute);<br>
+}<br>
+<br>
+bool<br>
+uevent_need_merge(void)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct config * conf;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0bool need_merge =3D false;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0conf =3D get_multipath_config();<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (conf-&gt;uid_attrs)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0need_merge =3D true=
;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0put_multipath_config(conf);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return need_merge;<br>
+}<br>
+<br>
+bool<br>
+uevent_can_discard(struct uevent *uev)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0char *tmp;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0char a[11], b[11];<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct config * conf;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * keep only block devices, discard partitions<=
br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0tmp =3D strstr(uev-&gt;devpath, &quot;/block/&q=
uot;);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (tmp =3D=3D NULL){<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(4, &quot;no=
 /block/ in &#39;%s&#39;&quot;, uev-&gt;devpath);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return true;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (sscanf(tmp, &quot;/block/%10s&quot;, a) !=
=3D 1 ||<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sscanf(tmp, &quot;/block/%10[^/]/=
%10s&quot;, a, b) =3D=3D 2) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(4, &quot;di=
scard event on %s&quot;, uev-&gt;devpath);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return true;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * do not filter dm devices by devnode<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!strncmp(uev-&gt;kernel, &quot;dm-&quot;, 3=
))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return false;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * filter paths devices by devnode<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0conf =3D get_multipath_config();<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (filter_devnode(conf-&gt;blist_<wbr>devnode,=
 conf-&gt;elist_devnode,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 uev-&gt;kernel) &gt; 0) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0put_multipath_confi=
g(conf);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return true;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0put_multipath_config(conf);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return false;<br>
+}<br>
+<br>
+bool<br>
+uevent_can_filter(struct uevent *earlier, struct uevent *later)<br>
+{<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * filter earlier uvents if path has removed la=
ter. Eg:<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * &quot;add path1 |chang path1 |add path2 |rem=
ove path1&quot;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * can filter as:<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * &quot;add path2 |remove path1&quot;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * uevents &quot;add path1&quot; and &quot;chan=
g path1&quot; are filtered out<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!strcmp(earlier-&gt;kernel, later-&gt;kerne=
l) &amp;&amp;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0!strcmp(later-&gt;a=
ction, &quot;remove&quot;) &amp;&amp;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0strncmp(later-&gt;k=
ernel, &quot;dm-&quot;, 3)) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return true;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * filter change uvents if add uevents exist. E=
g:<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * &quot;change path1| add path1 |add path2&quo=
t;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * can filter as:<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * &quot;add path1 |add path2&quot;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * uevent &quot;chang path1&quot; is filtered o=
ut<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!strcmp(earlier-&gt;kernel, later-&gt;kerne=
l) &amp;&amp;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0!strcmp(earlier-&gt=
;action, &quot;change&quot;) &amp;&amp;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0!strcmp(later-&gt;a=
ction, &quot;add&quot;) &amp;&amp;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0strncmp(later-&gt;k=
ernel, &quot;dm-&quot;, 3)) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return true;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return false;<br>
+}<br>
+<br>
+bool<br>
+merge_need_stop(struct uevent *earlier, struct uevent *later)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * dm uevent do not try to merge with left ueve=
nts<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!strncmp(later-&gt;kernel, &quot;dm-&quot;,=
 3))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return true;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * we can not make a jugement without wwid,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * so it is sensible to stop merging<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!earlier-&gt;wwid || !later-&gt;wwid)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return true;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * uevents merging stoped<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * when we meet an opposite action uevent from =
the same LUN to AVOID<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * &quot;add path1 |remove path1 |add path2 |re=
move path2 |add path3&quot;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * to merge as &quot;remove path1, path2&quot; =
and &quot;add path1, path2, path3&quot;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * OR<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * &quot;remove path1 |add path1 |remove path2 =
|add path2 |remove path3&quot;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * to merge as &quot;add path1, path2&quot; and=
 &quot;remove path1, path2, path3&quot;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * SO<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * when we meet a non-change uevent from the sa=
me LUN<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * with the same wwid and different action<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * it would be better to stop merging.<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!strcmp(earlier-&gt;wwid, later-&gt;wwid) &=
amp;&amp;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0strcmp(earlier-&gt;action, later-=
&gt;action) &amp;&amp;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0strcmp(earlier-&gt;action, &quot;=
change&quot;) &amp;&amp;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0strcmp(later-&gt;action, &quot;ch=
ange&quot;))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return true;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return false;<br>
+}<br>
+<br>
+bool<br>
+uevent_can_merge(struct uevent *earlier, struct uevent *later)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0/* merge paths uevents<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * whose wwids exsit and are same<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * and actions are same,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * and actions are addition or deletion<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (earlier-&gt;wwid &amp;&amp; later-&gt;wwid =
&amp;&amp;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0!strcmp(earlier-&gt;wwid, later-&=
gt;wwid) &amp;&amp;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0!strcmp(earlier-&gt;action, later=
-&gt;action) &amp;&amp;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0strncmp(earlier-&gt;action, &quot=
;change&quot;, 6) &amp;&amp;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0strncmp(earlier-&gt;kernel, &quot=
;dm-&quot;, 3)) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return true;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return false;<br>
=C2=A0}<br>
<br>
=C2=A0void<br>
-uevq_cleanup(struct list_head *tmpq)<br>
+uevent_prepare(struct list_head *tmpq)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct uevent *uev, *tmp;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0list_for_each_entry_reverse_<wbr>safe(uev, tmp,=
 tmpq, node) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (uevent_can_disc=
ard(uev)) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0list_del_init(&amp;uev-&gt;node);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0if (uev-&gt;udev)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0udev_device_unref(uev-&gt;udev);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0FREE(uev);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0continue;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (strncmp(uev-&gt=
;kernel, &quot;dm-&quot;, 3) &amp;&amp;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ueven=
t_need_merge())<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0uevent_get_wwid(uev);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+}<br>
+<br>
+void<br>
+uevent_filter(struct uevent *later, struct list_head *tmpq)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct uevent *earlier, *tmp;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0list_for_some_entry_reverse_<wbr>safe(earlier, =
tmp, &amp;later-&gt;node, tmpq, node) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * filter unnessary=
 earlier uevents<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * by the later uev=
ent<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (uevent_can_filt=
er(earlier, later)) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0condlog(2, &quot;uevent: %s-%s has filtered by uevent: %s-%s&quot=
;,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0earlier-&gt;kernel, earlier-&gt;actio=
n,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0later-&gt;kernel, later-&gt;action);<=
br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0list_del_init(&amp;earlier-&gt;node);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0if (earlier-&gt;udev)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0udev_device_unref(earlier-&gt;<wbr>ud=
ev);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0FREE(earlier);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+}<br>
+<br>
+void<br>
+uevent_merge(struct uevent *later, struct list_head *tmpq)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct uevent *earlier, *tmp;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0list_for_some_entry_reverse_<wbr>safe(earlier, =
tmp, &amp;later-&gt;node, tmpq, node) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (merge_need_stop=
(earlier, later))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0break;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * merge earlier ue=
vents to the later uevent<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (uevent_can_merg=
e(earlier, later)) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0condlog(2, &quot;merged uevent: %s-%s-%s with uevent: %s-%s-%s&qu=
ot;,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0earlier-&gt;action, earlier-&gt;kerne=
l, earlier-&gt;wwid,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0later-&gt;action, later-&gt;kernel, l=
ater-&gt;wwid);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0list_move(&amp;earlier-&gt;node, &amp;later-&gt;merge_node);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+}<br>
+<br>
+void<br>
+merge_uevq(struct list_head *tmpq)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct uevent *later;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0uevent_prepare(tmpq);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0list_for_each_entry_reverse(<wbr>later, tmpq, n=
ode) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0uevent_filter(later=
, tmpq);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if(uevent_need_merg=
e())<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0uevent_merge(later, tmpq);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+}<br>
+<br>
+void<br>
+service_uevq(struct list_head *tmpq)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct uevent *uev, *tmp;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 list_for_each_entry_safe(uev, tmp, tmpq, node) =
{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 list_del_init(&amp;=
uev-&gt;node);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (my_uev_trigger =
&amp;&amp; my_uev_trigger(uev, my_trigger_data))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0condlog(0, &quot;uevent trigger error&quot;);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0uevq_cleanup(&amp;u=
ev-&gt;merge_node)<wbr>;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (uev-&gt;udev)<b=
r>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0udev_device_unref(uev-&gt;udev);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 FREE(uev);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0}<br>
<br>
+static void uevent_cleanup(void *arg)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct udev *udev =3D arg;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(3, &quot;Releasing uevent_listen() reso=
urces&quot;);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0udev_unref(udev);<br>
+}<br>
+<br>
=C2=A0/*<br>
=C2=A0 * Service the uevent queue.<br>
=C2=A0 */<br>
@@ -142,6 +405,7 @@ int uevent_dispatch(int (*uev_trigger)(struct uevent *,=
 void * trigger_data),<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pthread_mutex_unloc=
k(uevq_<wbr>lockp);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!my_uev_trigger=
)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 break;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0merge_uevq(&amp;uev=
q_tmp);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 service_uevq(&amp;u=
evq_tmp);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 condlog(3, &quot;Terminating uev service queue&=
quot;);<br>
@@ -442,11 +706,43 @@ struct uevent *uevent_from_udev_device(<wbr>struct ud=
ev_device *dev)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return uev;<br>
=C2=A0}<br>
<br>
+bool uevent_burst(struct timeval *start_time, int events)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct timeval diff_time, end_time;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long speed;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long eclipse_ms;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if(events &gt; MAX_ACCUMULATION_COUNT) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(2, &quot;bu=
rst got %u uevents, too much uevents, stopped&quot;, events);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return false;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0gettimeofday(&amp;end_time, NULL);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0timersub(&amp;end_time, start_time, &amp;diff_t=
ime);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0eclipse_ms =3D diff_time.tv_sec * 1000 + diff_t=
ime.tv_usec / 1000;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (eclipse_ms =3D=3D 0)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return true;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (eclipse_ms &gt; MAX_ACCUMULATION_TIME) {<br=
>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(2, &quot;bu=
rst continued %lu ms, too long time, stopped&quot;, eclipse_ms);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return false;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0speed =3D (events * 1000) / eclipse_ms;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (speed &gt; MIN_BURST_SPEED)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return true;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return false;<br>
+}<br>
+<br>
=C2=A0int uevent_listen(struct udev *udev)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int err =3D 2;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct udev_monitor *monitor =3D NULL;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int fd, socket_flags, events;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct timeval start_time;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int need_failback =3D 1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int timeout =3D 30;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 LIST_HEAD(uevlisten_tmp);<br>
@@ -500,6 +796,7 @@ int uevent_listen(struct udev *udev)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 events =3D 0;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0gettimeofday(&amp;start_time, NULL);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 while (1) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct uevent *uev;=
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct udev_device =
*dev;<br>
@@ -514,7 +811,7 @@ int uevent_listen(struct udev *udev)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 errno =3D 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fdcount =3D poll(&a=
mp;ev_poll, 1, poll_timeout);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (fdcount &amp;&a=
mp; ev_poll.revents &amp; POLLIN) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0timeout =3D 0;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0timeout =3D uevent_burst(&amp;start_time, events + 1) ? 1 : 0;<br=
>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 dev =3D udev_monitor_receive_device(<wbr>monitor);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if (!dev) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 condlog(0, &quot;failed getting udev=
 device&quot;);<br>
@@ -547,6 +844,7 @@ int uevent_listen(struct udev *udev)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 pthread_mutex_unlock(uevq_<wbr>lockp);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 events =3D 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0gettimeofday(&amp;s=
tart_time, NULL);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 timeout =3D 30;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 need_failback =3D 0;<br>
diff --git a/libmultipath/uevent.h b/libmultipath/uevent.h<br>
index 9d22dcd..61a4207 100644<br>
--- a/libmultipath/uevent.h<br>
+++ b/libmultipath/uevent.h<br>
@@ -17,11 +17,13 @@ struct udev;<br>
<br>
=C2=A0struct uevent {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct list_head node;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct list_head merge_node;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct udev_device *udev;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char buffer[HOTPLUG_BUFFER_SIZE + OBJECT_SIZE];=
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *devpath;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *action;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *kernel;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0char *wwid;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned long seqnum;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *envp[HOTPLUG_NUM_ENVP];<br>
=C2=A0};<br>
diff --git a/libmultipath/util.c b/libmultipath/util.c<br>
index 1841f35..85d21fa 100644<br>
--- a/libmultipath/util.c<br>
+++ b/libmultipath/util.c<br>
@@ -262,6 +262,48 @@ dev_t parse_devt(const char *dev_t)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return makedev(maj, min);<br>
=C2=A0}<br>
<br>
+char *parse_uid_attribute_by_attrs(<wbr>char *uid_attrs, char *path_dev)<b=
r>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0char *uid_attribute;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0char *uid_attr_record;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0char *dev;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0char *attr;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0char *tmp;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0int=C2=A0 count;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if(!uid_attrs || !path_dev)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return NULL;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0count =3D get_word(uid_attrs, &amp;uid_attr_rec=
ord);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0while (uid_attr_record) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tmp =3D strrchr(uid=
_attr_record, &#39;:&#39;);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!tmp) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0free(uid_attr_record);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0if (!count)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0uid_attrs +=3D count;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0count =3D get_word(uid_attrs, &amp;uid_attr_record);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0continue;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dev =3D uid_attr_re=
cord;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0attr =3D tmp + 1;<b=
r>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*tmp =3D &#39;\0&#3=
9;;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if(!strncmp(path_de=
v, dev, strlen(dev))) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0uid_attribute =3D STRDUP(attr);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0free(uid_attr_record);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0return uid_attribute;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0free(uid_attr_recor=
d);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!count)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0break;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0uid_attrs +=3D coun=
t;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0count =3D get_word(=
uid_attrs, &amp;uid_attr_record);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return NULL;<br>
+}<br>
+<br>
=C2=A0void<br>
=C2=A0setup_thread_attr(pthread_<wbr>attr_t *attr, size_t stacksize, int de=
tached)<br>
=C2=A0{<br>
diff --git a/libmultipath/util.h b/libmultipath/util.h<br>
index f3b37ee..793f2b7 100644<br>
--- a/libmultipath/util.h<br>
+++ b/libmultipath/util.h<br>
@@ -12,6 +12,7 @@ size_t strlcat(char *dst, const char *src, size_t size);<=
br>
=C2=A0int devt2devname (char *, int, char *);<br>
=C2=A0dev_t parse_devt(const char *dev_t);<br>
=C2=A0char *convert_dev(char *dev, int is_path_device);<br>
+char *parse_uid_attribute_by_attrs(<wbr>char *uid_attrs, char *path_dev);<=
br>
=C2=A0void setup_thread_attr(pthread_<wbr>attr_t *attr, size_t stacksize, i=
nt detached);<br>
<br>
=C2=A0#define safe_sprintf(var, format, args...)=C2=A0 =C2=A0 =C2=A0\<br>
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5<br>
index b08bda3..efeead5 100644<br>
--- a/multipath/multipath.conf.5<br>
+++ b/multipath/multipath.conf.5<br>
@@ -207,6 +207,24 @@ The default is: \fBfailover\fR<br>
=C2=A0.<br>
=C2=A0.<br>
=C2=A0.TP<br>
+.B uid_attrs<br>
+The udev attribute providing a unique path identifier for corresponding<br=
>
+type of path devices. If this field is configured and matched with type<br=
>
+of device, it would override any other methods providing for device<br>
+unique identifier in config file, and it would activate merging uevents<br=
>
+according to the identifier to promote effiecncy in processing uevents.<br=
>
+Tt has no default value, if you want to identify path by udev attribute<br=
>
+and to activate merging uevents for SCSI and DAS device, you can set<br>
+it&#39;s value as:<br>
+.RS<br>
+.TP<br>
+\fBuid_attrs &quot;sd:ID_SERIAL dasd:ID_UID&quot;\fR<br>
+.TP<br>
+The default is: \fB&lt;unset&gt;\fR<br>
+.RE<br>
+.<br>
+.<br>
+.TP<br>
=C2=A0.B uid_attribute<br>
=C2=A0The udev attribute providing a unique path identifier.<br>
=C2=A0.RS<br>
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c<br>
index b20b054..9e90328 100644<br>
--- a/multipathd/cli_handlers.c<br>
+++ b/multipathd/cli_handlers.c<br>
@@ -714,7 +714,7 @@ cli_add_path (void * v, char ** reply, int * len, void =
* data)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pp-&gt;checkint =3D=
 conf-&gt;checkint;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 put_multipath_config(conf);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0return ev_add_path(pp, vecs);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return ev_add_path(pp, vecs, 1);<br>
=C2=A0blacklisted:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 *reply =3D strdup(&quot;blacklisted\n&quot;);<b=
r>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 *len =3D strlen(*reply) + 1;<br>
@@ -736,7 +736,7 @@ cli_del_path (void * v, char ** reply, int * len, void =
* data)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 condlog(0, &quot;%s=
: path already removed&quot;, param);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0return ev_remove_path(pp, vecs);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return ev_remove_path(pp, vecs, 1);<br>
=C2=A0}<br>
<br>
=C2=A0int<br>
diff --git a/multipathd/main.c b/multipathd/main.c<br>
index e317a4c..0c69f3b 100644<br>
--- a/multipathd/main.c<br>
+++ b/multipathd/main.c<br>
@@ -611,7 +611,7 @@ ev_remove_map (char * devname, char * alias, int minor,=
 struct vectors * vecs)<br>
=C2=A0}<br>
<br>
=C2=A0static int<br>
-uev_add_path (struct uevent *uev, struct vectors * vecs)<br>
+uev_add_path (struct uevent *uev, struct vectors * vecs, int need_do_map)<=
br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct path *pp;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int ret =3D 0, i;<br>
@@ -644,7 +644,7 @@ uev_add_path (struct uevent *uev, struct vectors * vecs=
)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0DI_ALL | DI_BLAC=
KLIST);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 put_multipath_config(conf);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if (r =3D=3D PATHINFO_OK)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D ev_add_path(pp, vecs);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D ev_add_path(pp, vecs, need_do=
_map);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 else if (r =3D=3D PATHINFO_SKIPPED) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 condlog(3, &quot;%s: remove blacklis=
ted path&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 uev-&gt;=
kernel);<br>
@@ -668,7 +668,7 @@ uev_add_path (struct uevent *uev, struct vectors * vecs=
)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 conf =3D get_multipath_config();<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D alloc_path_with_pathinfo(conf, uev-&gt;=
udev,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 DI_ALL, &amp;pp=
);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 uev-&gt;wwid, D=
I_ALL, &amp;pp);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 put_multipath_config(conf);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!pp) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ret =3D=3D PATH=
INFO_SKIPPED)<br>
@@ -684,7 +684,7 @@ uev_add_path (struct uevent *uev, struct vectors * vecs=
)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 conf =3D get_multip=
ath_config();<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pp-&gt;checkint =3D=
 conf-&gt;checkint;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 put_multipath_confi=
g(conf);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D ev_add_path=
(pp, vecs);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D ev_add_path=
(pp, vecs, need_do_map);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 } else {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 condlog(0, &quot;%s=
: failed to store path info, &quot;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 &quot;dropping event&quot;,<br>
@@ -702,7 +702,7 @@ uev_add_path (struct uevent *uev, struct vectors * vecs=
)<br>
=C2=A0 * 1: error<br>
=C2=A0 */<br>
=C2=A0int<br>
-ev_add_path (struct path * pp, struct vectors * vecs)<br>
+ev_add_path (struct path * pp, struct vectors * vecs, int need_do_map)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct multipath * mpp;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char params[PARAMS_SIZE] =3D {0};<br>
@@ -771,6 +771,13 @@ rescan:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /* persistent reservation check*/<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mpath_pr_event_handle(pp);<br>
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!need_do_map)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!dm_map_present(mpp-&gt;alias)) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mpp-&gt;action =3D =
ACT_CREATE;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0start_waiter =3D 1;=
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /*<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* push the map to the device-mapper<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/<br>
@@ -837,7 +844,7 @@ fail:<br>
=C2=A0}<br>
<br>
=C2=A0static int<br>
-uev_remove_path (struct uevent *uev, struct vectors * vecs)<br>
+uev_remove_path (struct uevent *uev, struct vectors * vecs, int need_do_ma=
p)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct path *pp;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int ret;<br>
@@ -848,7 +855,7 @@ uev_remove_path (struct uevent *uev, struct vectors * v=
ecs)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 pthread_testcancel();<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 pp =3D find_path_by_dev(vecs-&gt;<wbr>pathvec, =
uev-&gt;kernel);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (pp)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D ev_remove_p=
ath(pp, vecs);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D ev_remove_p=
ath(pp, vecs, need_do_map);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 lock_cleanup_pop(vecs-&gt;lock);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!pp) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Not an error; pa=
th might have been purged earlier */<br>
@@ -859,7 +866,7 @@ uev_remove_path (struct uevent *uev, struct vectors * v=
ecs)<br>
=C2=A0}<br>
<br>
=C2=A0int<br>
-ev_remove_path (struct path *pp, struct vectors * vecs)<br>
+ev_remove_path (struct path *pp, struct vectors * vecs, int need_do_map)<b=
r>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct multipath * mpp;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int i, retval =3D 0;<br>
@@ -922,6 +929,8 @@ ev_remove_path (struct path *pp, struct vectors * vecs)=
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 goto out;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!need_do_map)<b=
r>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0goto out;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* reload the =
map<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/<br>
@@ -999,7 +1008,7 @@ uev_update_path (struct uevent *uev, struct vectors * =
vecs)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (pp-&gt;initiali=
zed =3D=3D INIT_REQUESTED_UDEV)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0retval =3D uev_add_path(uev, vecs);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0retval =3D uev_add_path(uev, vecs, 1);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else if (mpp &amp;&=
amp; ro &gt;=3D 0) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 condlog(2, &quot;%s: update path write_protect to &#39;%d&#39; (=
uevent)&quot;, uev-&gt;kernel, ro);<br>
<br>
@@ -1020,7 +1029,7 @@ out:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 int flag =3D DI_SYSFS | DI_WWID;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 conf =3D get_multipath_config();<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0retval =3D alloc_path_with_pathinfo(conf, uev-&gt;udev, flag, NUL=
L);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0retval =3D alloc_path_with_pathinfo(conf, uev-&gt;udev, uev-&gt;w=
wid, flag, NULL);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 put_multipath_config(conf);<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if (retval =3D=3D PATHINFO_SKIPPED) {<br>
@@ -1090,40 +1099,15 @@ uxsock_trigger (char * str, char ** reply, int * le=
n, bool is_root,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return r;<br>
=C2=A0}<br>
<br>
-static int<br>
-uev_discard(char * devpath)<br>
-{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0char *tmp;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0char a[11], b[11];<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 * keep only block devices, discard partitions<=
br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0tmp =3D strstr(devpath, &quot;/block/&quot;);<b=
r>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (tmp =3D=3D NULL){<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(4, &quot;no=
 /block/ in &#39;%s&#39;&quot;, devpath);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 1;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (sscanf(tmp, &quot;/block/%10s&quot;, a) !=
=3D 1 ||<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sscanf(tmp, &quot;/block/%10[^/]/=
%10s&quot;, a, b) =3D=3D 2) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(4, &quot;di=
scard event on %s&quot;, devpath);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 1;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
-}<br>
-<br>
=C2=A0int<br>
=C2=A0uev_trigger (struct uevent * uev, void * trigger_data)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int r =3D 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct vectors * vecs;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0struct config *conf;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct uevent *merge_uev, *tmp;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 vecs =3D (struct vectors *)trigger_data;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (uev_discard(uev-&gt;devpath))<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
-<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 pthread_cleanup_push(config_<wbr>cleanup, NULL)=
;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 pthread_mutex_lock(&amp;config_<wbr>lock);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (running_state !=3D DAEMON_IDLE &amp;&amp;<b=
r>
@@ -1152,28 +1136,21 @@ uev_trigger (struct uevent * uev, void * trigger_da=
ta)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /*<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 * path add/remove event<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * path add/remove/change event, add/remove may=
be merged<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0conf =3D get_multipath_config();<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (filter_devnode(conf-&gt;blist_<wbr>devnode,=
 conf-&gt;elist_devnode,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 uev-&gt;kernel) &gt; 0) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0put_multipath_confi=
g(conf);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0list_for_each_entry_safe(<wbr>merge_uev, tmp, &=
amp;uev-&gt;merge_node, node) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!strncmp(merge_=
uev-&gt;action, &quot;add&quot;, 3))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0r +=3D uev_add_path(merge_uev, vecs, 0);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!strncmp(merge_=
uev-&gt;action, &quot;remove&quot;, 6))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0r +=3D uev_remove_path(merge_uev, vecs, 0);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0put_multipath_config(conf);<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!strncmp(uev-&gt;action, &quot;add&quot;, 3=
)) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0r =3D uev_add_path(=
uev, vecs);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!strncmp(uev-&gt;action, &quot;remove&quot;=
, 6)) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0r =3D uev_remove_pa=
th(uev, vecs);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!strncmp(uev-&gt;action, &quot;change&quot;=
, 6)) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0r =3D uev_update_pa=
th(uev, vecs);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!strncmp(uev-&gt;action, &quot;add&quot;, 3=
))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0r +=3D uev_add_path=
(uev, vecs, 1);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!strncmp(uev-&gt;action, &quot;remove&quot;=
, 6))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0r +=3D uev_remove_p=
ath(uev, vecs, 1);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!strncmp(uev-&gt;action, &quot;change&quot;=
, 6))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0r +=3D uev_update_p=
ath(uev, vecs);<br>
<br>
=C2=A0out:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return r;<br>
@@ -1663,7 +1640,7 @@ check_path (struct vectors * vecs, struct path * pp, =
int ticks)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 conf =3D get_multipath_config();<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 ret =3D pathinfo(pp, conf, DI_ALL | DI_BLACKLIST);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if (ret =3D=3D PATHINFO_OK) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ev_add_path(pp, vecs);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ev_add_path(pp, vecs, 1);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pp-&gt;tick =3D 1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 } else if (ret =3D=3D PATHINFO_SKIPPED) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 put_multipath_config(conf);<br>
@@ -1785,7 +1762,7 @@ check_path (struct vectors * vecs, struct path * pp, =
int ticks)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!disable_reinst=
ate &amp;&amp; reinstate_path(pp, add_active)) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 condlog(3, &quot;%s: reload map&quot;, pp-&gt;dev);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0ev_add_path(pp, vecs);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0ev_add_path(pp, vecs, 1);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 pp-&gt;tick =3D 1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 return 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
@@ -1808,7 +1785,7 @@ check_path (struct vectors * vecs, struct path * pp, =
int ticks)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 /* Clear IO errors */<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if (reinstate_path(pp, 0)) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 condlog(3, &quot;%s: reload map&quot=
;, pp-&gt;dev);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ev_add_path(pp, vecs);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ev_add_path(pp, vecs, 1);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pp-&gt;tick =3D 1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 }<br>
diff --git a/multipathd/main.h b/multipathd/main.h<br>
index f72580d..094b04f 100644<br>
--- a/multipathd/main.h<br>
+++ b/multipathd/main.h<br>
@@ -22,8 +22,8 @@ void exit_daemon(void);<br>
=C2=A0const char * daemon_status(void);<br>
=C2=A0int need_to_delay_reconfig (struct vectors *);<br>
=C2=A0int reconfigure (struct vectors *);<br>
-int ev_add_path (struct path *, struct vectors *);<br>
-int ev_remove_path (struct path *, struct vectors *);<br>
+int ev_add_path (struct path *, struct vectors *, int);<br>
+int ev_remove_path (struct path *, struct vectors *, int);<br>
=C2=A0int ev_add_map (char *, char *, struct vectors *);<br>
=C2=A0int ev_remove_map (char *, char *, int, struct vectors *);<br>
=C2=A0void sync_map_state (struct multipath *);<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.8.1.windows.1<br>
<br>
<br>
</font></span></blockquote></div><br></div>

--001a113524923ab6f40549a08d61--


--===============5142436928728946796==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5142436928728946796==--
