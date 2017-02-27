From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: improve processing
 efficiency for addition and deletion of multipath devices
Date: Mon, 27 Feb 2017 07:15:54 +0100
Message-ID: <CABr-GndcizxvxRkB9Qc+YnrQkR8FqeOXHWBNh0c_TgSH2+3LYQ@mail.gmail.com>
References: <1487228041-1228-1-git-send-email-tang.junhui@zte.com.cn>
	<20170216162700.GU22981@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2278247001058869506=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170216162700.GU22981@octiron.msp.redhat.com>
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
Cc: tang.wenjun3@zte.com.cn, tang.junhui@zte.com.cn, zhang.kai16@zte.com.cn, device-mapper development <dm-devel@redhat.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

--===============2278247001058869506==
Content-Type: multipart/alternative; boundary=001a114e25ac1a5ff505497d0378

--001a114e25ac1a5ff505497d0378
Content-Type: text/plain; charset=UTF-8

Hi Junhui,

It seems I did not receive the patch version Acked by Ben,
Can you rebase and post please ?

Thanks.

On Thu, Feb 16, 2017 at 5:27 PM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> On Thu, Feb 16, 2017 at 02:54:01PM +0800, tang.junhui@zte.com.cn wrote:
> > From: "tang.junhui" <tang.junhui@zte.com.cn>
>
> ACK
>
> Thanks for all your work on this.
> -Ben
>
> >
> > Change-Id: I3f81a55fff389f991f915927000b281d7e263cc5
> > Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
> >
> > This patch used to improve processing efficiency for addition and
> deletion
> > of multipath devices.
> >
> > This patch is tested pass by ZTE multipath automatic testing system.
> > The modification reduces the system consumption(such as CPU) and shortens
> > the processing time obviously in scene of massive multipath devices
> > addition or deletion.
> >
> > The main processing flow of code is:
> > 1) add uid_attrs configuration in the defaults section:
> >    It is configured udev attribute which providing a unique path
> identifier
> >    for corresponding type of path devices. If this field is configured
> and
> >    matched with type of device, it would override any other methods
> providing
> >    for device unique identifier in config file, and it would activate
> merging
> >    uevents according to the identifier to promote effiecncy in processing
> >    uevents. Tt has no default value, so defaultly only uevents filtering
> >    works, and uevents merging does not works, if users want to identify
> path
> >    by udev attribute and to activate merging uevents for SCSI and DAS
> device,
> >    they can set it's value as:
> >    "sd:ID_SERIAL dasd:ID_UID"
> > 2) uevents accumulation in uevents burst scene:
> >    wait one seconds for more uevents in uevent_listen() in uevents burst
> >    situations
> > 3) uevents preparing, filtering and merging:
> >    discard unuse uevents and fetch path idendifier from uevents;
> >    filter uevents;
> >    merge uevents.
> > 4) uevents proccessing:
> >    proccess the merged uevents in uev->merge_node list without calling
> >    domap();
> >    proccess the last uevents uev with calling domap().
> > ---
> >  libmultipath/config.c      |   3 +
> >  libmultipath/config.h      |   1 +
> >  libmultipath/dict.c        |   3 +
> >  libmultipath/discovery.c   |   5 +-
> >  libmultipath/discovery.h   |   2 +-
> >  libmultipath/list.h        |  41 ++++++
> >  libmultipath/propsel.c     |   7 +
> >  libmultipath/uevent.c      | 320 ++++++++++++++++++++++++++++++
> +++++++++++++--
> >  libmultipath/uevent.h      |   2 +
> >  libmultipath/util.c        |  42 ++++++
> >  libmultipath/util.h        |   1 +
> >  multipath/multipath.conf.5 |  18 +++
> >  multipathd/cli_handlers.c  |   4 +-
> >  multipathd/main.c          |  93 +++++--------
> >  multipathd/main.h          |   4 +-
> >  15 files changed, 471 insertions(+), 75 deletions(-)
> >
> > diff --git a/libmultipath/config.c b/libmultipath/config.c
> > index 15ddbd8..765e91d 100644
> > --- a/libmultipath/config.c
> > +++ b/libmultipath/config.c
> > @@ -488,6 +488,9 @@ free_config (struct config * conf)
> >       if (conf->uid_attribute)
> >               FREE(conf->uid_attribute);
> >
> > +     if (conf->uid_attrs)
> > +             FREE(conf->uid_attrs);
> > +
> >       if (conf->getuid)
> >               FREE(conf->getuid);
> >
> > diff --git a/libmultipath/config.h b/libmultipath/config.h
> > index 9670020..ab85930 100644
> > --- a/libmultipath/config.h
> > +++ b/libmultipath/config.h
> > @@ -153,6 +153,7 @@ struct config {
> >
> >       char * multipath_dir;
> >       char * selector;
> > +     char * uid_attrs;
> >       char * uid_attribute;
> >       char * getuid;
> >       char * features;
> > diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> > index dc21846..0a531d1 100644
> > --- a/libmultipath/dict.c
> > +++ b/libmultipath/dict.c
> > @@ -249,6 +249,8 @@ declare_ovr_snprint(selector, print_str)
> >  declare_mp_handler(selector, set_str)
> >  declare_mp_snprint(selector, print_str)
> >
> > +declare_def_handler(uid_attrs, set_str)
> > +declare_def_snprint(uid_attrs, print_str)
> >  declare_def_handler(uid_attribute, set_str)
> >  declare_def_snprint_defstr(uid_attribute, print_str,
> DEFAULT_UID_ATTRIBUTE)
> >  declare_ovr_handler(uid_attribute, set_str)
> > @@ -1367,6 +1369,7 @@ init_keywords(vector keywords)
> >       install_keyword("multipath_dir", &def_multipath_dir_handler,
> &snprint_def_multipath_dir);
> >       install_keyword("path_selector", &def_selector_handler,
> &snprint_def_selector);
> >       install_keyword("path_grouping_policy", &def_pgpolicy_handler,
> &snprint_def_pgpolicy);
> > +     install_keyword("uid_attrs", &def_uid_attrs_handler,
> &snprint_def_uid_attrs);
> >       install_keyword("uid_attribute", &def_uid_attribute_handler,
> &snprint_def_uid_attribute);
> >       install_keyword("getuid_callout", &def_getuid_handler,
> &snprint_def_getuid);
> >       install_keyword("prio", &def_prio_name_handler,
> &snprint_def_prio_name);
> > diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> > index d1aec31..14904f2 100644
> > --- a/libmultipath/discovery.c
> > +++ b/libmultipath/discovery.c
> > @@ -33,7 +33,7 @@
> >
> >  int
> >  alloc_path_with_pathinfo (struct config *conf, struct udev_device
> *udevice,
> > -                       int flag, struct path **pp_ptr)
> > +                       char *wwid, int flag, struct path **pp_ptr)
> >  {
> >       int err = PATHINFO_FAILED;
> >       struct path * pp;
> > @@ -51,6 +51,9 @@ alloc_path_with_pathinfo (struct config *conf, struct
> udev_device *udevice,
> >       if (!pp)
> >               return PATHINFO_FAILED;
> >
> > +     if(wwid)
> > +             strncpy(pp->wwid, wwid, sizeof(pp->wwid));
> > +
> >       if (safe_sprintf(pp->dev, "%s", devname)) {
> >               condlog(0, "pp->dev too small");
> >       } else {
> > diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
> > index 3039268..d16a69a 100644
> > --- a/libmultipath/discovery.h
> > +++ b/libmultipath/discovery.h
> > @@ -37,7 +37,7 @@ int path_offline (struct path *);
> >  int get_state (struct path * pp, struct config * conf, int daemon);
> >  int pathinfo (struct path * pp, struct config * conf, int mask);
> >  int alloc_path_with_pathinfo (struct config *conf, struct udev_device
> *udevice,
> > -                           int flag, struct path **pp_ptr);
> > +                           char *wwid, int flag, struct path **pp_ptr);
> >  int store_pathinfo (vector pathvec, struct config *conf,
> >                   struct udev_device *udevice, int flag,
> >                   struct path **pp_ptr);
> > diff --git a/libmultipath/list.h b/libmultipath/list.h
> > index ceaa381..2b1dcf3 100644
> > --- a/libmultipath/list.h
> > +++ b/libmultipath/list.h
> > @@ -317,4 +317,45 @@ static inline void list_splice_tail_init(struct
> list_head *list,
> >            &pos->member != (head);                                    \
> >            pos = n, n = list_entry(n->member.next, typeof(*n), member))
> >
> > +/**
> > + * list_for_each_entry_reverse_safe - iterate backwards over list of
> given type safe against removal of list entry
> > + * @pos:     the type * to use as a loop counter.
> > + * @n:               another type * to use as temporary storage
> > + * @head:    the head for your list.
> > + * @member:  the name of the list_struct within the struct.
> > + */
> > +#define list_for_each_entry_reverse_safe(pos, n, head, member)
>   \
> > +     for (pos = list_entry((head)->prev, typeof(*pos), member),      \
> > +              n = list_entry(pos->member.prev, typeof(*pos), member);\
> > +          &pos->member != (head);                                    \
> > +          pos = n, n = list_entry(n->member.prev, typeof(*n), member))
> > +
> > +/**
> > + * list_for_some_entry_safe - iterate list from the given begin node to
> the given end node safe against removal of list entry
> > + * @pos:     the type * to use as a loop counter.
> > + * @n:               another type * to use as temporary storage
> > + * @from:    the begin node of the iteration.
> > + * @to:              the end node of the iteration.
> > + * @member:  the name of the list_struct within the struct.
> > + */
> > +#define list_for_some_entry_safe(pos, n, from, to, member)
> \
> > +     for (pos = list_entry((from)->next, typeof(*pos), member),      \
> > +          n = list_entry(pos->member.next, typeof(*pos), member);    \
> > +          &pos->member != (to);                                      \
> > +          pos = n, n = list_entry(n->member.next, typeof(*n), member))
> > +
> > +/**
> > + * list_for_some_entry_reverse_safe - iterate backwards list from the
> given begin node to the given end node safe against removal of list entry
> > + * @pos:     the type * to use as a loop counter.
> > + * @n:               another type * to use as temporary storage
> > + * @from:    the begin node of the iteration.
> > + * @to:              the end node of the iteration.
> > + * @member:  the name of the list_struct within the struct.
> > + */
> > +#define list_for_some_entry_reverse_safe(pos, n, from, to, member)
>   \
> > +     for (pos = list_entry((from)->prev, typeof(*pos), member),      \
> > +          n = list_entry(pos->member.prev, typeof(*pos), member);    \
> > +          &pos->member != (to);                                      \
> > +          pos = n, n = list_entry(n->member.prev, typeof(*n), member))
> > +
> >  #endif /* _LIST_H */
> > diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> > index c0bc616..c47bd08 100644
> > --- a/libmultipath/propsel.c
> > +++ b/libmultipath/propsel.c
> > @@ -18,6 +18,7 @@
> >  #include "prio.h"
> >  #include "discovery.h"
> >  #include "dict.h"
> > +#include "util.h"
> >  #include "prioritizers/alua_rtpg.h"
> >  #include <inttypes.h>
> >
> > @@ -339,6 +340,12 @@ int select_getuid(struct config *conf, struct path
> *pp)
> >  {
> >       char *origin;
> >
> > +     pp->uid_attribute = parse_uid_attribute_by_attrs(conf->uid_attrs,
> pp->dev);
> > +     if (pp->uid_attribute) {
> > +             origin = "(setting: multipath.conf defaults section)";
> > +             goto out;
> > +     }
> > +
> >       pp_set_ovr(getuid);
> >       pp_set_ovr(uid_attribute);
> >       pp_set_hwe(getuid);
> > diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
> > index 7edcce1..6e2527b 100644
> > --- a/libmultipath/uevent.c
> > +++ b/libmultipath/uevent.c
> > @@ -24,6 +24,7 @@
> >
> >  #include <unistd.h>
> >  #include <stdio.h>
> > +#include <stdbool.h>
> >  #include <errno.h>
> >  #include <stdlib.h>
> >  #include <stddef.h>
> > @@ -38,6 +39,7 @@
> >  #include <linux/netlink.h>
> >  #include <pthread.h>
> >  #include <sys/mman.h>
> > +#include <sys/time.h>
> >  #include <libudev.h>
> >  #include <errno.h>
> >
> > @@ -46,6 +48,14 @@
> >  #include "list.h"
> >  #include "uevent.h"
> >  #include "vector.h"
> > +#include "structs.h"
> > +#include "util.h"
> > +#include "config.h"
> > +#include "blacklist.h"
> > +
> > +#define MAX_ACCUMULATION_COUNT 2048
> > +#define MAX_ACCUMULATION_TIME 30*1000
> > +#define MIN_BURST_SPEED 10
> >
> >  typedef int (uev_trigger)(struct uevent *, void * trigger_data);
> >
> > @@ -72,48 +82,301 @@ struct uevent * alloc_uevent (void)
> >  {
> >       struct uevent *uev = MALLOC(sizeof(struct uevent));
> >
> > -     if (uev)
> > +     if (uev) {
> >               INIT_LIST_HEAD(&uev->node);
> > +             INIT_LIST_HEAD(&uev->merge_node);
> > +     }
> >
> >       return uev;
> >  }
> >
> >  void
> > -service_uevq(struct list_head *tmpq)
> > +uevq_cleanup(struct list_head *tmpq)
> >  {
> >       struct uevent *uev, *tmp;
> >
> >       list_for_each_entry_safe(uev, tmp, tmpq, node) {
> >               list_del_init(&uev->node);
> >
> > -             if (my_uev_trigger && my_uev_trigger(uev, my_trigger_data))
> > -                     condlog(0, "uevent trigger error");
> > -
> >               if (uev->udev)
> >                       udev_device_unref(uev->udev);
> >               FREE(uev);
> >       }
> >  }
> >
> > -static void uevent_cleanup(void *arg)
> > +void
> > +uevent_get_wwid(struct uevent *uev)
> >  {
> > -     struct udev *udev = arg;
> > +     int i;
> > +     char *uid_attribute;
> > +     struct config * conf;
> >
> > -     condlog(3, "Releasing uevent_listen() resources");
> > -     udev_unref(udev);
> > +     conf = get_multipath_config();
> > +     uid_attribute = parse_uid_attribute_by_attrs(conf->uid_attrs,
> uev->kernel);
> > +     put_multipath_config(conf);
> > +
> > +     if (!uid_attribute)
> > +             return;
> > +
> > +     for (i = 0; uev->envp[i] != NULL; i++) {
> > +             if (!strncmp(uev->envp[i], uid_attribute,
> strlen(uid_attribute)) &&
> > +                 strlen(uev->envp[i]) > strlen(uid_attribute) &&
> > +                 uev->envp[i][strlen(uid_attribute)] == '=') {
> > +                     uev->wwid = uev->envp[i] + strlen(uid_attribute) +
> 1;
> > +                     break;
> > +             }
> > +     }
> > +     free(uid_attribute);
> > +}
> > +
> > +bool
> > +uevent_need_merge(void)
> > +{
> > +     struct config * conf;
> > +     bool need_merge = false;
> > +
> > +     conf = get_multipath_config();
> > +     if (conf->uid_attrs)
> > +             need_merge = true;
> > +     put_multipath_config(conf);
> > +
> > +     return need_merge;
> > +}
> > +
> > +bool
> > +uevent_can_discard(struct uevent *uev)
> > +{
> > +     char *tmp;
> > +     char a[11], b[11];
> > +     struct config * conf;
> > +
> > +     /*
> > +      * keep only block devices, discard partitions
> > +      */
> > +     tmp = strstr(uev->devpath, "/block/");
> > +     if (tmp == NULL){
> > +             condlog(4, "no /block/ in '%s'", uev->devpath);
> > +             return true;
> > +     }
> > +     if (sscanf(tmp, "/block/%10s", a) != 1 ||
> > +         sscanf(tmp, "/block/%10[^/]/%10s", a, b) == 2) {
> > +             condlog(4, "discard event on %s", uev->devpath);
> > +             return true;
> > +     }
> > +
> > +     /*
> > +      * do not filter dm devices by devnode
> > +      */
> > +     if (!strncmp(uev->kernel, "dm-", 3))
> > +             return false;
> > +     /*
> > +      * filter paths devices by devnode
> > +      */
> > +     conf = get_multipath_config();
> > +     if (filter_devnode(conf->blist_devnode, conf->elist_devnode,
> > +                        uev->kernel) > 0) {
> > +             put_multipath_config(conf);
> > +             return true;
> > +     }
> > +     put_multipath_config(conf);
> > +
> > +     return false;
> > +}
> > +
> > +bool
> > +uevent_can_filter(struct uevent *earlier, struct uevent *later)
> > +{
> > +
> > +     /*
> > +      * filter earlier uvents if path has removed later. Eg:
> > +      * "add path1 |chang path1 |add path2 |remove path1"
> > +      * can filter as:
> > +      * "add path2 |remove path1"
> > +      * uevents "add path1" and "chang path1" are filtered out
> > +      */
> > +     if (!strcmp(earlier->kernel, later->kernel) &&
> > +             !strcmp(later->action, "remove") &&
> > +             strncmp(later->kernel, "dm-", 3)) {
> > +             return true;
> > +     }
> > +
> > +     /*
> > +      * filter change uvents if add uevents exist. Eg:
> > +      * "change path1| add path1 |add path2"
> > +      * can filter as:
> > +      * "add path1 |add path2"
> > +      * uevent "chang path1" is filtered out
> > +      */
> > +     if (!strcmp(earlier->kernel, later->kernel) &&
> > +             !strcmp(earlier->action, "change") &&
> > +             !strcmp(later->action, "add") &&
> > +             strncmp(later->kernel, "dm-", 3)) {
> > +             return true;
> > +     }
> > +
> > +     return false;
> > +}
> > +
> > +bool
> > +merge_need_stop(struct uevent *earlier, struct uevent *later)
> > +{
> > +     /*
> > +      * dm uevent do not try to merge with left uevents
> > +      */
> > +     if (!strncmp(later->kernel, "dm-", 3))
> > +             return true;
> > +
> > +     /*
> > +      * we can not make a jugement without wwid,
> > +      * so it is sensible to stop merging
> > +      */
> > +     if (!earlier->wwid || !later->wwid)
> > +             return true;
> > +     /*
> > +      * uevents merging stoped
> > +      * when we meet an opposite action uevent from the same LUN to
> AVOID
> > +      * "add path1 |remove path1 |add path2 |remove path2 |add path3"
> > +      * to merge as "remove path1, path2" and "add path1, path2, path3"
> > +      * OR
> > +      * "remove path1 |add path1 |remove path2 |add path2 |remove path3"
> > +      * to merge as "add path1, path2" and "remove path1, path2, path3"
> > +      * SO
> > +      * when we meet a non-change uevent from the same LUN
> > +      * with the same wwid and different action
> > +      * it would be better to stop merging.
> > +      */
> > +     if (!strcmp(earlier->wwid, later->wwid) &&
> > +         strcmp(earlier->action, later->action) &&
> > +         strcmp(earlier->action, "change") &&
> > +         strcmp(later->action, "change"))
> > +             return true;
> > +
> > +     return false;
> > +}
> > +
> > +bool
> > +uevent_can_merge(struct uevent *earlier, struct uevent *later)
> > +{
> > +     /* merge paths uevents
> > +      * whose wwids exsit and are same
> > +      * and actions are same,
> > +      * and actions are addition or deletion
> > +      */
> > +     if (earlier->wwid && later->wwid &&
> > +         !strcmp(earlier->wwid, later->wwid) &&
> > +         !strcmp(earlier->action, later->action) &&
> > +         strncmp(earlier->action, "change", 6) &&
> > +         strncmp(earlier->kernel, "dm-", 3)) {
> > +             return true;
> > +     }
> > +
> > +     return false;
> >  }
> >
> >  void
> > -uevq_cleanup(struct list_head *tmpq)
> > +uevent_prepare(struct list_head *tmpq)
> > +{
> > +     struct uevent *uev, *tmp;
> > +
> > +     list_for_each_entry_reverse_safe(uev, tmp, tmpq, node) {
> > +             if (uevent_can_discard(uev)) {
> > +                     list_del_init(&uev->node);
> > +                     if (uev->udev)
> > +                             udev_device_unref(uev->udev);
> > +                     FREE(uev);
> > +                     continue;
> > +             }
> > +
> > +             if (strncmp(uev->kernel, "dm-", 3) &&
> > +                 uevent_need_merge())
> > +                     uevent_get_wwid(uev);
> > +     }
> > +}
> > +
> > +void
> > +uevent_filter(struct uevent *later, struct list_head *tmpq)
> > +{
> > +     struct uevent *earlier, *tmp;
> > +
> > +     list_for_some_entry_reverse_safe(earlier, tmp, &later->node,
> tmpq, node) {
> > +             /*
> > +              * filter unnessary earlier uevents
> > +              * by the later uevent
> > +              */
> > +             if (uevent_can_filter(earlier, later)) {
> > +                     condlog(2, "uevent: %s-%s has filtered by uevent:
> %s-%s",
> > +                             earlier->kernel, earlier->action,
> > +                             later->kernel, later->action);
> > +
> > +                     list_del_init(&earlier->node);
> > +                     if (earlier->udev)
> > +                             udev_device_unref(earlier->udev);
> > +                     FREE(earlier);
> > +             }
> > +     }
> > +}
> > +
> > +void
> > +uevent_merge(struct uevent *later, struct list_head *tmpq)
> > +{
> > +     struct uevent *earlier, *tmp;
> > +
> > +     list_for_some_entry_reverse_safe(earlier, tmp, &later->node,
> tmpq, node) {
> > +             if (merge_need_stop(earlier, later))
> > +                     break;
> > +             /*
> > +              * merge earlier uevents to the later uevent
> > +              */
> > +             if (uevent_can_merge(earlier, later)) {
> > +                     condlog(2, "merged uevent: %s-%s-%s with uevent:
> %s-%s-%s",
> > +                             earlier->action, earlier->kernel,
> earlier->wwid,
> > +                             later->action, later->kernel, later->wwid);
> > +
> > +                     list_move(&earlier->node, &later->merge_node);
> > +             }
> > +     }
> > +}
> > +
> > +void
> > +merge_uevq(struct list_head *tmpq)
> > +{
> > +     struct uevent *later;
> > +
> > +     uevent_prepare(tmpq);
> > +     list_for_each_entry_reverse(later, tmpq, node) {
> > +             uevent_filter(later, tmpq);
> > +             if(uevent_need_merge())
> > +                     uevent_merge(later, tmpq);
> > +     }
> > +}
> > +
> > +void
> > +service_uevq(struct list_head *tmpq)
> >  {
> >       struct uevent *uev, *tmp;
> >
> >       list_for_each_entry_safe(uev, tmp, tmpq, node) {
> >               list_del_init(&uev->node);
> > +
> > +             if (my_uev_trigger && my_uev_trigger(uev, my_trigger_data))
> > +                     condlog(0, "uevent trigger error");
> > +
> > +             uevq_cleanup(&uev->merge_node);
> > +
> > +             if (uev->udev)
> > +                     udev_device_unref(uev->udev);
> >               FREE(uev);
> >       }
> >  }
> >
> > +static void uevent_cleanup(void *arg)
> > +{
> > +     struct udev *udev = arg;
> > +
> > +     condlog(3, "Releasing uevent_listen() resources");
> > +     udev_unref(udev);
> > +}
> > +
> >  /*
> >   * Service the uevent queue.
> >   */
> > @@ -142,6 +405,7 @@ int uevent_dispatch(int (*uev_trigger)(struct uevent
> *, void * trigger_data),
> >               pthread_mutex_unlock(uevq_lockp);
> >               if (!my_uev_trigger)
> >                       break;
> > +             merge_uevq(&uevq_tmp);
> >               service_uevq(&uevq_tmp);
> >       }
> >       condlog(3, "Terminating uev service queue");
> > @@ -442,11 +706,43 @@ struct uevent *uevent_from_udev_device(struct
> udev_device *dev)
> >       return uev;
> >  }
> >
> > +bool uevent_burst(struct timeval *start_time, int events)
> > +{
> > +     struct timeval diff_time, end_time;
> > +     unsigned long speed;
> > +     unsigned long eclipse_ms;
> > +
> > +     if(events > MAX_ACCUMULATION_COUNT) {
> > +             condlog(2, "burst got %u uevents, too much uevents,
> stopped", events);
> > +             return false;
> > +     }
> > +
> > +     gettimeofday(&end_time, NULL);
> > +     timersub(&end_time, start_time, &diff_time);
> > +
> > +     eclipse_ms = diff_time.tv_sec * 1000 + diff_time.tv_usec / 1000;
> > +
> > +     if (eclipse_ms == 0)
> > +             return true;
> > +
> > +     if (eclipse_ms > MAX_ACCUMULATION_TIME) {
> > +             condlog(2, "burst continued %lu ms, too long time,
> stopped", eclipse_ms);
> > +             return false;
> > +     }
> > +
> > +     speed = (events * 1000) / eclipse_ms;
> > +     if (speed > MIN_BURST_SPEED)
> > +             return true;
> > +
> > +     return false;
> > +}
> > +
> >  int uevent_listen(struct udev *udev)
> >  {
> >       int err = 2;
> >       struct udev_monitor *monitor = NULL;
> >       int fd, socket_flags, events;
> > +     struct timeval start_time;
> >       int need_failback = 1;
> >       int timeout = 30;
> >       LIST_HEAD(uevlisten_tmp);
> > @@ -500,6 +796,7 @@ int uevent_listen(struct udev *udev)
> >       }
> >
> >       events = 0;
> > +     gettimeofday(&start_time, NULL);
> >       while (1) {
> >               struct uevent *uev;
> >               struct udev_device *dev;
> > @@ -514,7 +811,7 @@ int uevent_listen(struct udev *udev)
> >               errno = 0;
> >               fdcount = poll(&ev_poll, 1, poll_timeout);
> >               if (fdcount && ev_poll.revents & POLLIN) {
> > -                     timeout = 0;
> > +                     timeout = uevent_burst(&start_time, events + 1) ?
> 1 : 0;
> >                       dev = udev_monitor_receive_device(monitor);
> >                       if (!dev) {
> >                               condlog(0, "failed getting udev device");
> > @@ -547,6 +844,7 @@ int uevent_listen(struct udev *udev)
> >                       pthread_mutex_unlock(uevq_lockp);
> >                       events = 0;
> >               }
> > +             gettimeofday(&start_time, NULL);
> >               timeout = 30;
> >       }
> >       need_failback = 0;
> > diff --git a/libmultipath/uevent.h b/libmultipath/uevent.h
> > index 9d22dcd..61a4207 100644
> > --- a/libmultipath/uevent.h
> > +++ b/libmultipath/uevent.h
> > @@ -17,11 +17,13 @@ struct udev;
> >
> >  struct uevent {
> >       struct list_head node;
> > +     struct list_head merge_node;
> >       struct udev_device *udev;
> >       char buffer[HOTPLUG_BUFFER_SIZE + OBJECT_SIZE];
> >       char *devpath;
> >       char *action;
> >       char *kernel;
> > +     char *wwid;
> >       unsigned long seqnum;
> >       char *envp[HOTPLUG_NUM_ENVP];
> >  };
> > diff --git a/libmultipath/util.c b/libmultipath/util.c
> > index 03a5738..e1e83cf 100644
> > --- a/libmultipath/util.c
> > +++ b/libmultipath/util.c
> > @@ -261,6 +261,48 @@ dev_t parse_devt(const char *dev_t)
> >       return makedev(maj, min);
> >  }
> >
> > +char *parse_uid_attribute_by_attrs(char *uid_attrs, char *path_dev)
> > +{
> > +     char *uid_attribute;
> > +     char *uid_attr_record;
> > +     char *dev;
> > +     char *attr;
> > +     char *tmp;
> > +     int  count;
> > +
> > +     if(!uid_attrs || !path_dev)
> > +             return NULL;
> > +
> > +     count = get_word(uid_attrs, &uid_attr_record);
> > +     while (uid_attr_record) {
> > +             tmp = strrchr(uid_attr_record, ':');
> > +             if (!tmp) {
> > +                     free(uid_attr_record);
> > +                     if (!count)
> > +                             break;
> > +                     uid_attrs += count;
> > +                     count = get_word(uid_attrs, &uid_attr_record);
> > +                     continue;
> > +             }
> > +             dev = uid_attr_record;
> > +             attr = tmp + 1;
> > +             *tmp = '\0';
> > +
> > +             if(!strncmp(path_dev, dev, strlen(dev))) {
> > +                     uid_attribute = STRDUP(attr);
> > +                     free(uid_attr_record);
> > +                     return uid_attribute;
> > +             }
> > +
> > +             free(uid_attr_record);
> > +             if (!count)
> > +                     break;
> > +             uid_attrs += count;
> > +             count = get_word(uid_attrs, &uid_attr_record);
> > +     }
> > +     return NULL;
> > +}
> > +
> >  void
> >  setup_thread_attr(pthread_attr_t *attr, size_t stacksize, int detached)
> >  {
> > diff --git a/libmultipath/util.h b/libmultipath/util.h
> > index f3b37ee..793f2b7 100644
> > --- a/libmultipath/util.h
> > +++ b/libmultipath/util.h
> > @@ -12,6 +12,7 @@ size_t strlcat(char *dst, const char *src, size_t
> size);
> >  int devt2devname (char *, int, char *);
> >  dev_t parse_devt(const char *dev_t);
> >  char *convert_dev(char *dev, int is_path_device);
> > +char *parse_uid_attribute_by_attrs(char *uid_attrs, char *path_dev);
> >  void setup_thread_attr(pthread_attr_t *attr, size_t stacksize, int
> detached);
> >
> >  #define safe_sprintf(var, format, args...)   \
> > diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> > index 36589f5..63c63c2 100644
> > --- a/multipath/multipath.conf.5
> > +++ b/multipath/multipath.conf.5
> > @@ -209,6 +209,24 @@ The default is: \fBfailover\fR
> >  .
> >  .
> >  .TP
> > +.B uid_attrs
> > +The udev attribute providing a unique path identifier for corresponding
> > +type of path devices. If this field is configured and matched with type
> > +of device, it would override any other methods providing for device
> > +unique identifier in config file, and it would activate merging uevents
> > +according to the identifier to promote effiecncy in processing uevents.
> > +Tt has no default value, if you want to identify path by udev attribute
> > +and to activate merging uevents for SCSI and DAS device, you can set
> > +it's value as:
> > +.RS
> > +.TP
> > +\fBuid_attrs "sd:ID_SERIAL dasd:ID_UID"\fR
> > +.TP
> > +The default is: \fB<unset>\fR
> > +.RE
> > +.
> > +.
> > +.TP
> >  .B uid_attribute
> >  The udev attribute providing a unique path identifier.
> >  .RS
> > diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> > index b0eeca6..12f85de 100644
> > --- a/multipathd/cli_handlers.c
> > +++ b/multipathd/cli_handlers.c
> > @@ -670,7 +670,7 @@ cli_add_path (void * v, char ** reply, int * len,
> void * data)
> >               pp->checkint = conf->checkint;
> >       }
> >       put_multipath_config(conf);
> > -     return ev_add_path(pp, vecs);
> > +     return ev_add_path(pp, vecs, 1);
> >  blacklisted:
> >       *reply = strdup("blacklisted\n");
> >       *len = strlen(*reply) + 1;
> > @@ -692,7 +692,7 @@ cli_del_path (void * v, char ** reply, int * len,
> void * data)
> >               condlog(0, "%s: path already removed", param);
> >               return 1;
> >       }
> > -     return ev_remove_path(pp, vecs);
> > +     return ev_remove_path(pp, vecs, 1);
> >  }
> >
> >  int
> > diff --git a/multipathd/main.c b/multipathd/main.c
> > index adc3258..e513f7d 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -608,7 +608,7 @@ ev_remove_map (char * devname, char * alias, int
> minor, struct vectors * vecs)
> >  }
> >
> >  static int
> > -uev_add_path (struct uevent *uev, struct vectors * vecs)
> > +uev_add_path (struct uevent *uev, struct vectors * vecs, int
> need_do_map)
> >  {
> >       struct path *pp;
> >       int ret = 0, i;
> > @@ -641,7 +641,7 @@ uev_add_path (struct uevent *uev, struct vectors *
> vecs)
> >                                    DI_ALL | DI_BLACKLIST);
> >                       put_multipath_config(conf);
> >                       if (r == PATHINFO_OK)
> > -                             ret = ev_add_path(pp, vecs);
> > +                             ret = ev_add_path(pp, vecs, need_do_map);
> >                       else if (r == PATHINFO_SKIPPED) {
> >                               condlog(3, "%s: remove blacklisted path",
> >                                       uev->kernel);
> > @@ -665,7 +665,7 @@ uev_add_path (struct uevent *uev, struct vectors *
> vecs)
> >        */
> >       conf = get_multipath_config();
> >       ret = alloc_path_with_pathinfo(conf, uev->udev,
> > -                                    DI_ALL, &pp);
> > +                                    uev->wwid, DI_ALL, &pp);
> >       put_multipath_config(conf);
> >       if (!pp) {
> >               if (ret == PATHINFO_SKIPPED)
> > @@ -681,7 +681,7 @@ uev_add_path (struct uevent *uev, struct vectors *
> vecs)
> >               conf = get_multipath_config();
> >               pp->checkint = conf->checkint;
> >               put_multipath_config(conf);
> > -             ret = ev_add_path(pp, vecs);
> > +             ret = ev_add_path(pp, vecs, need_do_map);
> >       } else {
> >               condlog(0, "%s: failed to store path info, "
> >                       "dropping event",
> > @@ -699,7 +699,7 @@ uev_add_path (struct uevent *uev, struct vectors *
> vecs)
> >   * 1: error
> >   */
> >  int
> > -ev_add_path (struct path * pp, struct vectors * vecs)
> > +ev_add_path (struct path * pp, struct vectors * vecs, int need_do_map)
> >  {
> >       struct multipath * mpp;
> >       char params[PARAMS_SIZE] = {0};
> > @@ -767,6 +767,13 @@ rescan:
> >       /* persistent reservation check*/
> >       mpath_pr_event_handle(pp);
> >
> > +     if (!need_do_map)
> > +             return 0;
> > +
> > +     if (!dm_map_present(mpp->alias)) {
> > +             mpp->action = ACT_CREATE;
> > +             start_waiter = 1;
> > +     }
> >       /*
> >        * push the map to the device-mapper
> >        */
> > @@ -833,7 +840,7 @@ fail:
> >  }
> >
> >  static int
> > -uev_remove_path (struct uevent *uev, struct vectors * vecs)
> > +uev_remove_path (struct uevent *uev, struct vectors * vecs, int
> need_do_map)
> >  {
> >       struct path *pp;
> >       int ret;
> > @@ -844,7 +851,7 @@ uev_remove_path (struct uevent *uev, struct vectors
> * vecs)
> >       pthread_testcancel();
> >       pp = find_path_by_dev(vecs->pathvec, uev->kernel);
> >       if (pp)
> > -             ret = ev_remove_path(pp, vecs);
> > +             ret = ev_remove_path(pp, vecs, need_do_map);
> >       lock_cleanup_pop(vecs->lock);
> >       if (!pp) {
> >               /* Not an error; path might have been purged earlier */
> > @@ -855,7 +862,7 @@ uev_remove_path (struct uevent *uev, struct vectors
> * vecs)
> >  }
> >
> >  int
> > -ev_remove_path (struct path *pp, struct vectors * vecs)
> > +ev_remove_path (struct path *pp, struct vectors * vecs, int need_do_map)
> >  {
> >       struct multipath * mpp;
> >       int i, retval = 0;
> > @@ -918,6 +925,8 @@ ev_remove_path (struct path *pp, struct vectors *
> vecs)
> >                       goto out;
> >               }
> >
> > +             if (!need_do_map)
> > +                     goto out;
> >               /*
> >                * reload the map
> >                */
> > @@ -995,7 +1004,7 @@ uev_update_path (struct uevent *uev, struct vectors
> * vecs)
> >               }
> >
> >               if (pp->initialized == INIT_REQUESTED_UDEV)
> > -                     retval = uev_add_path(uev, vecs);
> > +                     retval = uev_add_path(uev, vecs, 1);
> >               else if (mpp && ro >= 0) {
> >                       condlog(2, "%s: update path write_protect to '%d'
> (uevent)", uev->kernel, ro);
> >
> > @@ -1016,7 +1025,7 @@ out:
> >                       int flag = DI_SYSFS | DI_WWID;
> >
> >                       conf = get_multipath_config();
> > -                     retval = alloc_path_with_pathinfo(conf, uev->udev,
> flag, NULL);
> > +                     retval = alloc_path_with_pathinfo(conf, uev->udev,
> uev->wwid, flag, NULL);
> >                       put_multipath_config(conf);
> >
> >                       if (retval == PATHINFO_SKIPPED) {
> > @@ -1077,40 +1086,15 @@ uxsock_trigger (char * str, char ** reply, int *
> len, void * trigger_data)
> >       return r;
> >  }
> >
> > -static int
> > -uev_discard(char * devpath)
> > -{
> > -     char *tmp;
> > -     char a[11], b[11];
> > -
> > -     /*
> > -      * keep only block devices, discard partitions
> > -      */
> > -     tmp = strstr(devpath, "/block/");
> > -     if (tmp == NULL){
> > -             condlog(4, "no /block/ in '%s'", devpath);
> > -             return 1;
> > -     }
> > -     if (sscanf(tmp, "/block/%10s", a) != 1 ||
> > -         sscanf(tmp, "/block/%10[^/]/%10s", a, b) == 2) {
> > -             condlog(4, "discard event on %s", devpath);
> > -             return 1;
> > -     }
> > -     return 0;
> > -}
> > -
> >  int
> >  uev_trigger (struct uevent * uev, void * trigger_data)
> >  {
> >       int r = 0;
> >       struct vectors * vecs;
> > -     struct config *conf;
> > +     struct uevent *merge_uev, *tmp;
> >
> >       vecs = (struct vectors *)trigger_data;
> >
> > -     if (uev_discard(uev->devpath))
> > -             return 0;
> > -
> >       pthread_cleanup_push(config_cleanup, NULL);
> >       pthread_mutex_lock(&config_lock);
> >       if (running_state != DAEMON_IDLE &&
> > @@ -1139,28 +1123,21 @@ uev_trigger (struct uevent * uev, void *
> trigger_data)
> >       }
> >
> >       /*
> > -      * path add/remove event
> > +      * path add/remove/change event, add/remove maybe merged
> >        */
> > -     conf = get_multipath_config();
> > -     if (filter_devnode(conf->blist_devnode, conf->elist_devnode,
> > -                        uev->kernel) > 0) {
> > -             put_multipath_config(conf);
> > -             goto out;
> > +     list_for_each_entry_safe(merge_uev, tmp, &uev->merge_node, node) {
> > +             if (!strncmp(merge_uev->action, "add", 3))
> > +                     r += uev_add_path(merge_uev, vecs, 0);
> > +             if (!strncmp(merge_uev->action, "remove", 6))
> > +                     r += uev_remove_path(merge_uev, vecs, 0);
> >       }
> > -     put_multipath_config(conf);
> >
> > -     if (!strncmp(uev->action, "add", 3)) {
> > -             r = uev_add_path(uev, vecs);
> > -             goto out;
> > -     }
> > -     if (!strncmp(uev->action, "remove", 6)) {
> > -             r = uev_remove_path(uev, vecs);
> > -             goto out;
> > -     }
> > -     if (!strncmp(uev->action, "change", 6)) {
> > -             r = uev_update_path(uev, vecs);
> > -             goto out;
> > -     }
> > +     if (!strncmp(uev->action, "add", 3))
> > +             r += uev_add_path(uev, vecs, 1);
> > +     if (!strncmp(uev->action, "remove", 6))
> > +             r += uev_remove_path(uev, vecs, 1);
> > +     if (!strncmp(uev->action, "change", 6))
> > +             r += uev_update_path(uev, vecs);
> >
> >  out:
> >       return r;
> > @@ -1570,7 +1547,7 @@ check_path (struct vectors * vecs, struct path *
> pp, int ticks)
> >                       conf = get_multipath_config();
> >                       ret = pathinfo(pp, conf, DI_ALL | DI_BLACKLIST);
> >                       if (ret == PATHINFO_OK) {
> > -                             ev_add_path(pp, vecs);
> > +                             ev_add_path(pp, vecs, 1);
> >                               pp->tick = 1;
> >                       } else if (ret == PATHINFO_SKIPPED) {
> >                               put_multipath_config(conf);
> > @@ -1686,7 +1663,7 @@ check_path (struct vectors * vecs, struct path *
> pp, int ticks)
> >               }
> >               if (!disable_reinstate && reinstate_path(pp, add_active)) {
> >                       condlog(3, "%s: reload map", pp->dev);
> > -                     ev_add_path(pp, vecs);
> > +                     ev_add_path(pp, vecs, 1);
> >                       pp->tick = 1;
> >                       return 0;
> >               }
> > @@ -1709,7 +1686,7 @@ check_path (struct vectors * vecs, struct path *
> pp, int ticks)
> >                       /* Clear IO errors */
> >                       if (reinstate_path(pp, 0)) {
> >                               condlog(3, "%s: reload map", pp->dev);
> > -                             ev_add_path(pp, vecs);
> > +                             ev_add_path(pp, vecs, 1);
> >                               pp->tick = 1;
> >                               return 0;
> >                       }
> > diff --git a/multipathd/main.h b/multipathd/main.h
> > index f72580d..094b04f 100644
> > --- a/multipathd/main.h
> > +++ b/multipathd/main.h
> > @@ -22,8 +22,8 @@ void exit_daemon(void);
> >  const char * daemon_status(void);
> >  int need_to_delay_reconfig (struct vectors *);
> >  int reconfigure (struct vectors *);
> > -int ev_add_path (struct path *, struct vectors *);
> > -int ev_remove_path (struct path *, struct vectors *);
> > +int ev_add_path (struct path *, struct vectors *, int);
> > +int ev_remove_path (struct path *, struct vectors *, int);
> >  int ev_add_map (char *, char *, struct vectors *);
> >  int ev_remove_map (char *, char *, int, struct vectors *);
> >  void sync_map_state (struct multipath *);
> > --
> > 2.8.1.windows.1
> >
>

--001a114e25ac1a5ff505497d0378
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi Junhui,</div><div><br></div>It seems I did not rec=
eive the patch version Acked by Ben,<div>Can you rebase and post please ?</=
div><div><br></div><div>Thanks.</div></div><div class=3D"gmail_extra"><br><=
div class=3D"gmail_quote">On Thu, Feb 16, 2017 at 5:27 PM, Benjamin Marzins=
ki <span dir=3D"ltr">&lt;<a href=3D"mailto:bmarzins@redhat.com" target=3D"_=
blank">bmarzins@redhat.com</a>&gt;</span> wrote:<br><blockquote class=3D"gm=
ail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-le=
ft:1ex"><span class=3D"">On Thu, Feb 16, 2017 at 02:54:01PM +0800, <a href=
=3D"mailto:tang.junhui@zte.com.cn">tang.junhui@zte.com.cn</a> wrote:<br>
&gt; From: &quot;tang.junhui&quot; &lt;<a href=3D"mailto:tang.junhui@zte.co=
m.cn">tang.junhui@zte.com.cn</a>&gt;<br>
<br>
</span>ACK<br>
<br>
Thanks for all your work on this.<br>
-Ben<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
&gt;<br>
&gt; Change-Id: I3f81a55fff389f991f915927000b2<wbr>81d7e263cc5<br>
&gt; Signed-off-by: tang.junhui &lt;<a href=3D"mailto:tang.junhui@zte.com.c=
n">tang.junhui@zte.com.cn</a>&gt;<br>
&gt;<br>
&gt; This patch used to improve processing efficiency for addition and dele=
tion<br>
&gt; of multipath devices.<br>
&gt;<br>
&gt; This patch is tested pass by ZTE multipath automatic testing system.<b=
r>
&gt; The modification reduces the system consumption(such as CPU) and short=
ens<br>
&gt; the processing time obviously in scene of massive multipath devices<br=
>
&gt; addition or deletion.<br>
&gt;<br>
&gt; The main processing flow of code is:<br>
&gt; 1) add uid_attrs configuration in the defaults section:<br>
&gt;=C2=A0 =C2=A0 It is configured udev attribute which providing a unique =
path identifier<br>
&gt;=C2=A0 =C2=A0 for corresponding type of path devices. If this field is =
configured and<br>
&gt;=C2=A0 =C2=A0 matched with type of device, it would override any other =
methods providing<br>
&gt;=C2=A0 =C2=A0 for device unique identifier in config file, and it would=
 activate merging<br>
&gt;=C2=A0 =C2=A0 uevents according to the identifier to promote effiecncy =
in processing<br>
&gt;=C2=A0 =C2=A0 uevents. Tt has no default value, so defaultly only ueven=
ts filtering<br>
&gt;=C2=A0 =C2=A0 works, and uevents merging does not works, if users want =
to identify path<br>
&gt;=C2=A0 =C2=A0 by udev attribute and to activate merging uevents for SCS=
I and DAS device,<br>
&gt;=C2=A0 =C2=A0 they can set it&#39;s value as:<br>
&gt;=C2=A0 =C2=A0 &quot;sd:ID_SERIAL dasd:ID_UID&quot;<br>
&gt; 2) uevents accumulation in uevents burst scene:<br>
&gt;=C2=A0 =C2=A0 wait one seconds for more uevents in uevent_listen() in u=
events burst<br>
&gt;=C2=A0 =C2=A0 situations<br>
&gt; 3) uevents preparing, filtering and merging:<br>
&gt;=C2=A0 =C2=A0 discard unuse uevents and fetch path idendifier from ueve=
nts;<br>
&gt;=C2=A0 =C2=A0 filter uevents;<br>
&gt;=C2=A0 =C2=A0 merge uevents.<br>
&gt; 4) uevents proccessing:<br>
&gt;=C2=A0 =C2=A0 proccess the merged uevents in uev-&gt;merge_node list wi=
thout calling<br>
&gt;=C2=A0 =C2=A0 domap();<br>
&gt;=C2=A0 =C2=A0 proccess the last uevents uev with calling domap().<br>
&gt; ---<br>
&gt;=C2=A0 libmultipath/config.c=C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A03 +<br>
&gt;=C2=A0 libmultipath/config.h=C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A01 +<br>
&gt;=C2=A0 libmultipath/dict.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A03 +=
<br>
&gt;=C2=A0 libmultipath/discovery.c=C2=A0 =C2=A0|=C2=A0 =C2=A05 +-<br>
&gt;=C2=A0 libmultipath/discovery.h=C2=A0 =C2=A0|=C2=A0 =C2=A02 +-<br>
&gt;=C2=A0 libmultipath/list.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 41 ++++++=
<br>
&gt;=C2=A0 libmultipath/propsel.c=C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A07 +<br>
&gt;=C2=A0 libmultipath/uevent.c=C2=A0 =C2=A0 =C2=A0 | 320 ++++++++++++++++=
++++++++++++++<wbr>+++++++++++++--<br>
&gt;=C2=A0 libmultipath/uevent.h=C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A02 +<br>
&gt;=C2=A0 libmultipath/util.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 42 ++++++=
<br>
&gt;=C2=A0 libmultipath/util.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A01 +=
<br>
&gt;=C2=A0 multipath/multipath.conf.5 |=C2=A0 18 +++<br>
&gt;=C2=A0 multipathd/cli_handlers.c=C2=A0 |=C2=A0 =C2=A04 +-<br>
&gt;=C2=A0 multipathd/main.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 93 +=
++++--------<br>
&gt;=C2=A0 multipathd/main.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=
=A04 +-<br>
&gt;=C2=A0 15 files changed, 471 insertions(+), 75 deletions(-)<br>
&gt;<br>
&gt; diff --git a/libmultipath/config.c b/libmultipath/config.c<br>
&gt; index 15ddbd8..765e91d 100644<br>
&gt; --- a/libmultipath/config.c<br>
&gt; +++ b/libmultipath/config.c<br>
&gt; @@ -488,6 +488,9 @@ free_config (struct config * conf)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (conf-&gt;uid_attribute)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0FREE(conf-&gt;ui=
d_attribute);<br>
&gt;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (conf-&gt;uid_attrs)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0FREE(conf-&gt;uid_att=
rs);<br>
&gt; +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (conf-&gt;getuid)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0FREE(conf-&gt;ge=
tuid);<br>
&gt;<br>
&gt; diff --git a/libmultipath/config.h b/libmultipath/config.h<br>
&gt; index 9670020..ab85930 100644<br>
&gt; --- a/libmultipath/config.h<br>
&gt; +++ b/libmultipath/config.h<br>
&gt; @@ -153,6 +153,7 @@ struct config {<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0char * multipath_dir;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0char * selector;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0char * uid_attrs;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0char * uid_attribute;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0char * getuid;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0char * features;<br>
&gt; diff --git a/libmultipath/dict.c b/libmultipath/dict.c<br>
&gt; index dc21846..0a531d1 100644<br>
&gt; --- a/libmultipath/dict.c<br>
&gt; +++ b/libmultipath/dict.c<br>
&gt; @@ -249,6 +249,8 @@ declare_ovr_snprint(selector, print_str)<br>
&gt;=C2=A0 declare_mp_handler(selector, set_str)<br>
&gt;=C2=A0 declare_mp_snprint(selector, print_str)<br>
&gt;<br>
&gt; +declare_def_handler(uid_<wbr>attrs, set_str)<br>
&gt; +declare_def_snprint(uid_<wbr>attrs, print_str)<br>
&gt;=C2=A0 declare_def_handler(uid_<wbr>attribute, set_str)<br>
&gt;=C2=A0 declare_def_snprint_defstr(<wbr>uid_attribute, print_str, DEFAUL=
T_UID_ATTRIBUTE)<br>
&gt;=C2=A0 declare_ovr_handler(uid_<wbr>attribute, set_str)<br>
&gt; @@ -1367,6 +1369,7 @@ init_keywords(vector keywords)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0install_keyword(&quot;multipath_<wbr>dir&quo=
t;, &amp;def_multipath_dir_handler, &amp;snprint_def_multipath_dir);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0install_keyword(&quot;path_<wbr>selector&quo=
t;, &amp;def_selector_handler, &amp;snprint_def_selector);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0install_keyword(&quot;path_<wbr>grouping_pol=
icy&quot;, &amp;def_pgpolicy_handler, &amp;snprint_def_pgpolicy);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0install_keyword(&quot;uid_attrs&quot;, &amp;def_u=
id_attrs_handler, &amp;snprint_def_uid_attrs);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0install_keyword(&quot;uid_<wbr>attribute&quo=
t;, &amp;def_uid_attribute_handler, &amp;snprint_def_uid_attribute);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0install_keyword(&quot;getuid_<wbr>callout&qu=
ot;, &amp;def_getuid_handler, &amp;snprint_def_getuid);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0install_keyword(&quot;prio&quot;, &amp;def_p=
rio_name_handler, &amp;snprint_def_prio_name);<br>
&gt; diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c<br>
&gt; index d1aec31..14904f2 100644<br>
&gt; --- a/libmultipath/discovery.c<br>
&gt; +++ b/libmultipath/discovery.c<br>
&gt; @@ -33,7 +33,7 @@<br>
&gt;<br>
&gt;=C2=A0 int<br>
&gt;=C2=A0 alloc_path_with_pathinfo (struct config *conf, struct udev_devic=
e *udevice,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0int flag, struct path **pp_ptr)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0char *wwid, int flag, struct path **pp_ptr)<br>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int err =3D PATHINFO_FAILED;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct path * pp;<br>
&gt; @@ -51,6 +51,9 @@ alloc_path_with_pathinfo (struct config *conf, struc=
t udev_device *udevice,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!pp)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return PATHINFO_=
FAILED;<br>
&gt;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if(wwid)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0strncpy(pp-&gt;wwid, =
wwid, sizeof(pp-&gt;wwid));<br>
&gt; +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (safe_sprintf(pp-&gt;dev, &quot;%s&quot;,=
 devname)) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(0, &quot=
;pp-&gt;dev too small&quot;);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0} else {<br>
&gt; diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h<br>
&gt; index 3039268..d16a69a 100644<br>
&gt; --- a/libmultipath/discovery.h<br>
&gt; +++ b/libmultipath/discovery.h<br>
&gt; @@ -37,7 +37,7 @@ int path_offline (struct path *);<br>
&gt;=C2=A0 int get_state (struct path * pp, struct config * conf, int daemo=
n);<br>
&gt;=C2=A0 int pathinfo (struct path * pp, struct config * conf, int mask);=
<br>
&gt;=C2=A0 int alloc_path_with_pathinfo (struct config *conf, struct udev_d=
evice *udevice,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0int flag, struct path **pp_ptr);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0char *wwid, int flag, struct path **pp_ptr);<br=
>
&gt;=C2=A0 int store_pathinfo (vector pathvec, struct config *conf,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0st=
ruct udev_device *udevice, int flag,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0st=
ruct path **pp_ptr);<br>
&gt; diff --git a/libmultipath/list.h b/libmultipath/list.h<br>
&gt; index ceaa381..2b1dcf3 100644<br>
&gt; --- a/libmultipath/list.h<br>
&gt; +++ b/libmultipath/list.h<br>
&gt; @@ -317,4 +317,45 @@ static inline void list_splice_tail_init(struct l=
ist_head *list,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &amp;pos-&gt;member !=3D (hea=
d);=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 \<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pos =3D n, n =3D list_entry(n=
-&gt;member.next, typeof(*n), member))<br>
&gt;<br>
&gt; +/**<br>
&gt; + * list_for_each_entry_reverse_<wbr>safe - iterate backwards over lis=
t of given type safe against removal of list entry<br>
&gt; + * @pos:=C2=A0 =C2=A0 =C2=A0the type * to use as a loop counter.<br>
&gt; + * @n:=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0another =
type * to use as temporary storage<br>
&gt; + * @head:=C2=A0 =C2=A0 the head for your list.<br>
&gt; + * @member:=C2=A0 the name of the list_struct within the struct.<br>
&gt; + */<br>
&gt; +#define list_for_each_entry_reverse_<wbr>safe(pos, n, head, member)=
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 \<br>
&gt; +=C2=A0 =C2=A0 =C2=A0for (pos =3D list_entry((head)-&gt;prev, typeof(*=
pos), member),=C2=A0 =C2=A0 =C2=A0 \<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 n =3D list_entry(pos=
-&gt;member.prev, typeof(*pos), member);\<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &amp;pos-&gt;member !=3D (head);=
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 \<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pos =3D n, n =3D list_entry(n-&gt;=
member.prev, typeof(*n), member))<br>
&gt; +<br>
&gt; +/**<br>
&gt; + * list_for_some_entry_safe - iterate list from the given begin node =
to the given end node safe against removal of list entry<br>
&gt; + * @pos:=C2=A0 =C2=A0 =C2=A0the type * to use as a loop counter.<br>
&gt; + * @n:=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0another =
type * to use as temporary storage<br>
&gt; + * @from:=C2=A0 =C2=A0 the begin node of the iteration.<br>
&gt; + * @to:=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 the end node =
of the iteration.<br>
&gt; + * @member:=C2=A0 the name of the list_struct within the struct.<br>
&gt; + */<br>
&gt; +#define list_for_some_entry_safe(pos, n, from, to, member)=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 \<br>
&gt; +=C2=A0 =C2=A0 =C2=A0for (pos =3D list_entry((from)-&gt;next, typeof(*=
pos), member),=C2=A0 =C2=A0 =C2=A0 \<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 n =3D list_entry(pos-&gt;member.ne=
xt, typeof(*pos), member);=C2=A0 =C2=A0 \<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &amp;pos-&gt;member !=3D (to);=C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 \<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pos =3D n, n =3D list_entry(n-&gt;=
member.next, typeof(*n), member))<br>
&gt; +<br>
&gt; +/**<br>
&gt; + * list_for_some_entry_reverse_<wbr>safe - iterate backwards list fro=
m the given begin node to the given end node safe against removal of list e=
ntry<br>
&gt; + * @pos:=C2=A0 =C2=A0 =C2=A0the type * to use as a loop counter.<br>
&gt; + * @n:=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0another =
type * to use as temporary storage<br>
&gt; + * @from:=C2=A0 =C2=A0 the begin node of the iteration.<br>
&gt; + * @to:=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 the end node =
of the iteration.<br>
&gt; + * @member:=C2=A0 the name of the list_struct within the struct.<br>
&gt; + */<br>
&gt; +#define list_for_some_entry_reverse_<wbr>safe(pos, n, from, to, membe=
r)=C2=A0 =C2=A0 =C2=A0 \<br>
&gt; +=C2=A0 =C2=A0 =C2=A0for (pos =3D list_entry((from)-&gt;prev, typeof(*=
pos), member),=C2=A0 =C2=A0 =C2=A0 \<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 n =3D list_entry(pos-&gt;member.pr=
ev, typeof(*pos), member);=C2=A0 =C2=A0 \<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &amp;pos-&gt;member !=3D (to);=C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 \<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pos =3D n, n =3D list_entry(n-&gt;=
member.prev, typeof(*n), member))<br>
&gt; +<br>
&gt;=C2=A0 #endif /* _LIST_H */<br>
&gt; diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c<br>
&gt; index c0bc616..c47bd08 100644<br>
&gt; --- a/libmultipath/propsel.c<br>
&gt; +++ b/libmultipath/propsel.c<br>
&gt; @@ -18,6 +18,7 @@<br>
&gt;=C2=A0 #include &quot;prio.h&quot;<br>
&gt;=C2=A0 #include &quot;discovery.h&quot;<br>
&gt;=C2=A0 #include &quot;dict.h&quot;<br>
&gt; +#include &quot;util.h&quot;<br>
&gt;=C2=A0 #include &quot;prioritizers/alua_rtpg.h&quot;<br>
&gt;=C2=A0 #include &lt;inttypes.h&gt;<br>
&gt;<br>
&gt; @@ -339,6 +340,12 @@ int select_getuid(struct config *conf, struct pat=
h *pp)<br>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0char *origin;<br>
&gt;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0pp-&gt;uid_attribute =3D parse_uid_attribute_by_a=
ttrs(<wbr>conf-&gt;uid_attrs, pp-&gt;dev);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (pp-&gt;uid_attribute) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0origin =3D &quot;(set=
ting: multipath.conf defaults section)&quot;;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0pp_set_ovr(getuid);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0pp_set_ovr(uid_attribute);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0pp_set_hwe(getuid);<br>
&gt; diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c<br>
&gt; index 7edcce1..6e2527b 100644<br>
&gt; --- a/libmultipath/uevent.c<br>
&gt; +++ b/libmultipath/uevent.c<br>
&gt; @@ -24,6 +24,7 @@<br>
&gt;<br>
&gt;=C2=A0 #include &lt;unistd.h&gt;<br>
&gt;=C2=A0 #include &lt;stdio.h&gt;<br>
&gt; +#include &lt;stdbool.h&gt;<br>
&gt;=C2=A0 #include &lt;errno.h&gt;<br>
&gt;=C2=A0 #include &lt;stdlib.h&gt;<br>
&gt;=C2=A0 #include &lt;stddef.h&gt;<br>
&gt; @@ -38,6 +39,7 @@<br>
&gt;=C2=A0 #include &lt;linux/netlink.h&gt;<br>
&gt;=C2=A0 #include &lt;pthread.h&gt;<br>
&gt;=C2=A0 #include &lt;sys/mman.h&gt;<br>
&gt; +#include &lt;sys/time.h&gt;<br>
&gt;=C2=A0 #include &lt;libudev.h&gt;<br>
&gt;=C2=A0 #include &lt;errno.h&gt;<br>
&gt;<br>
&gt; @@ -46,6 +48,14 @@<br>
&gt;=C2=A0 #include &quot;list.h&quot;<br>
&gt;=C2=A0 #include &quot;uevent.h&quot;<br>
&gt;=C2=A0 #include &quot;vector.h&quot;<br>
&gt; +#include &quot;structs.h&quot;<br>
&gt; +#include &quot;util.h&quot;<br>
&gt; +#include &quot;config.h&quot;<br>
&gt; +#include &quot;blacklist.h&quot;<br>
&gt; +<br>
&gt; +#define MAX_ACCUMULATION_COUNT 2048<br>
&gt; +#define MAX_ACCUMULATION_TIME 30*1000<br>
&gt; +#define MIN_BURST_SPEED 10<br>
&gt;<br>
&gt;=C2=A0 typedef int (uev_trigger)(struct uevent *, void * trigger_data);=
<br>
&gt;<br>
&gt; @@ -72,48 +82,301 @@ struct uevent * alloc_uevent (void)<br>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct uevent *uev =3D MALLOC(sizeof(struct =
uevent));<br>
&gt;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0if (uev)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (uev) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0INIT_LIST_HEAD(&=
amp;uev-&gt;node);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0INIT_LIST_HEAD(&amp;u=
ev-&gt;merge_<wbr>node);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0return uev;<br>
&gt;=C2=A0 }<br>
&gt;<br>
&gt;=C2=A0 void<br>
&gt; -service_uevq(struct list_head *tmpq)<br>
&gt; +uevq_cleanup(struct list_head *tmpq)<br>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct uevent *uev, *tmp;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0list_for_each_entry_safe(uev, tmp, tmpq, nod=
e) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0list_del_init(&a=
mp;uev-&gt;node);<br>
&gt;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (my_uev_trigger &a=
mp;&amp; my_uev_trigger(uev, my_trigger_data))<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0condlog(0, &quot;uevent trigger error&quot;);<br>
&gt; -<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (uev-&gt;udev=
)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0udev_device_unref(uev-&gt;udev);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0FREE(uev);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 }<br>
&gt;<br>
&gt; -static void uevent_cleanup(void *arg)<br>
&gt; +void<br>
&gt; +uevent_get_wwid(struct uevent *uev)<br>
&gt;=C2=A0 {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0struct udev *udev =3D arg;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0int i;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0char *uid_attribute;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct config * conf;<br>
&gt;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0condlog(3, &quot;Releasing uevent_listen() resour=
ces&quot;);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0udev_unref(udev);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0conf =3D get_multipath_config();<br>
&gt; +=C2=A0 =C2=A0 =C2=A0uid_attribute =3D parse_uid_attribute_by_attrs(<w=
br>conf-&gt;uid_attrs, uev-&gt;kernel);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0put_multipath_config(conf);<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (!uid_attribute)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0for (i =3D 0; uev-&gt;envp[i] !=3D NULL; i++) {<b=
r>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!strncmp(uev-&gt;=
envp[i], uid_attribute, strlen(uid_attribute)) &amp;&amp;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0strlen(=
uev-&gt;envp[i]) &gt; strlen(uid_attribute) &amp;&amp;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0uev-&gt=
;envp[i][strlen(uid_<wbr>attribute)] =3D=3D &#39;=3D&#39;) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0uev-&gt;wwid =3D uev-&gt;envp[i] + strlen(uid_attribute) + 1;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0break;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +=C2=A0 =C2=A0 =C2=A0free(uid_attribute);<br>
&gt; +}<br>
&gt; +<br>
&gt; +bool<br>
&gt; +uevent_need_merge(void)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct config * conf;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0bool need_merge =3D false;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0conf =3D get_multipath_config();<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (conf-&gt;uid_attrs)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0need_merge =3D true;<=
br>
&gt; +=C2=A0 =C2=A0 =C2=A0put_multipath_config(conf);<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return need_merge;<br>
&gt; +}<br>
&gt; +<br>
&gt; +bool<br>
&gt; +uevent_can_discard(struct uevent *uev)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0char *tmp;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0char a[11], b[11];<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct config * conf;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0/*<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * keep only block devices, discard partitions<br=
>
&gt; +=C2=A0 =C2=A0 =C2=A0 */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0tmp =3D strstr(uev-&gt;devpath, &quot;/block/&quo=
t;);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (tmp =3D=3D NULL){<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(4, &quot;no /=
block/ in &#39;%s&#39;&quot;, uev-&gt;devpath);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return true;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (sscanf(tmp, &quot;/block/%10s&quot;, a) !=3D =
1 ||<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sscanf(tmp, &quot;/block/%10[^/]/%1=
0s&quot;, a, b) =3D=3D 2) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(4, &quot;disc=
ard event on %s&quot;, uev-&gt;devpath);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return true;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0/*<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * do not filter dm devices by devnode<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (!strncmp(uev-&gt;kernel, &quot;dm-&quot;, 3))=
<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return false;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0/*<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * filter paths devices by devnode<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0conf =3D get_multipath_config();<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (filter_devnode(conf-&gt;blist_<wbr>devnode, c=
onf-&gt;elist_devnode,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 uev-&gt;kernel) &gt; 0) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0put_multipath_config(=
conf);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return true;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +=C2=A0 =C2=A0 =C2=A0put_multipath_config(conf);<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return false;<br>
&gt; +}<br>
&gt; +<br>
&gt; +bool<br>
&gt; +uevent_can_filter(struct uevent *earlier, struct uevent *later)<br>
&gt; +{<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0/*<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * filter earlier uvents if path has removed late=
r. Eg:<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * &quot;add path1 |chang path1 |add path2 |remov=
e path1&quot;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * can filter as:<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * &quot;add path2 |remove path1&quot;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * uevents &quot;add path1&quot; and &quot;chang =
path1&quot; are filtered out<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (!strcmp(earlier-&gt;kernel, later-&gt;kernel)=
 &amp;&amp;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0!strcmp(later-&gt;act=
ion, &quot;remove&quot;) &amp;&amp;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0strncmp(later-&gt;ker=
nel, &quot;dm-&quot;, 3)) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return true;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0/*<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * filter change uvents if add uevents exist. Eg:=
<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * &quot;change path1| add path1 |add path2&quot;=
<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * can filter as:<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * &quot;add path1 |add path2&quot;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * uevent &quot;chang path1&quot; is filtered out=
<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (!strcmp(earlier-&gt;kernel, later-&gt;kernel)=
 &amp;&amp;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0!strcmp(earlier-&gt;a=
ction, &quot;change&quot;) &amp;&amp;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0!strcmp(later-&gt;act=
ion, &quot;add&quot;) &amp;&amp;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0strncmp(later-&gt;ker=
nel, &quot;dm-&quot;, 3)) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return true;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return false;<br>
&gt; +}<br>
&gt; +<br>
&gt; +bool<br>
&gt; +merge_need_stop(struct uevent *earlier, struct uevent *later)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0/*<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * dm uevent do not try to merge with left uevent=
s<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (!strncmp(later-&gt;kernel, &quot;dm-&quot;, 3=
))<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return true;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0/*<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * we can not make a jugement without wwid,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * so it is sensible to stop merging<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (!earlier-&gt;wwid || !later-&gt;wwid)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return true;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0/*<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * uevents merging stoped<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * when we meet an opposite action uevent from th=
e same LUN to AVOID<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * &quot;add path1 |remove path1 |add path2 |remo=
ve path2 |add path3&quot;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * to merge as &quot;remove path1, path2&quot; an=
d &quot;add path1, path2, path3&quot;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * OR<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * &quot;remove path1 |add path1 |remove path2 |a=
dd path2 |remove path3&quot;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * to merge as &quot;add path1, path2&quot; and &=
quot;remove path1, path2, path3&quot;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * SO<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * when we meet a non-change uevent from the same=
 LUN<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * with the same wwid and different action<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * it would be better to stop merging.<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (!strcmp(earlier-&gt;wwid, later-&gt;wwid) &am=
p;&amp;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0strcmp(earlier-&gt;action, later-&g=
t;action) &amp;&amp;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0strcmp(earlier-&gt;action, &quot;ch=
ange&quot;) &amp;&amp;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0strcmp(later-&gt;action, &quot;chan=
ge&quot;))<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return true;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return false;<br>
&gt; +}<br>
&gt; +<br>
&gt; +bool<br>
&gt; +uevent_can_merge(struct uevent *earlier, struct uevent *later)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0/* merge paths uevents<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * whose wwids exsit and are same<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * and actions are same,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * and actions are addition or deletion<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (earlier-&gt;wwid &amp;&amp; later-&gt;wwid &a=
mp;&amp;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0!strcmp(earlier-&gt;wwid, later-&gt=
;wwid) &amp;&amp;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0!strcmp(earlier-&gt;action, later-&=
gt;action) &amp;&amp;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0strncmp(earlier-&gt;action, &quot;c=
hange&quot;, 6) &amp;&amp;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0strncmp(earlier-&gt;kernel, &quot;d=
m-&quot;, 3)) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return true;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return false;<br>
&gt;=C2=A0 }<br>
&gt;<br>
&gt;=C2=A0 void<br>
&gt; -uevq_cleanup(struct list_head *tmpq)<br>
&gt; +uevent_prepare(struct list_head *tmpq)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct uevent *uev, *tmp;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0list_for_each_entry_reverse_<wbr>safe(uev, tmp, t=
mpq, node) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (uevent_can_discar=
d(uev)) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0list_del_init(&amp;uev-&gt;node);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0if (uev-&gt;udev)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0udev_device_unref(uev-&gt;udev);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0FREE(uev);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0continue;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (strncmp(uev-&gt;k=
ernel, &quot;dm-&quot;, 3) &amp;&amp;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0uevent_=
need_merge())<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0uevent_get_wwid(uev);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +}<br>
&gt; +<br>
&gt; +void<br>
&gt; +uevent_filter(struct uevent *later, struct list_head *tmpq)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct uevent *earlier, *tmp;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0list_for_some_entry_reverse_<wbr>safe(earlier, tm=
p, &amp;later-&gt;node, tmpq, node) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * filter unnessary e=
arlier uevents<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * by the later ueven=
t<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (uevent_can_filter=
(earlier, later)) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0condlog(2, &quot;uevent: %s-%s has filtered by uevent: %s-%s&quot;,<=
br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0earlier-&gt;kernel, earlier-&gt;action,<=
br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0later-&gt;kernel, later-&gt;action);<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0list_del_init(&amp;earlier-&gt;node);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0if (earlier-&gt;udev)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0udev_device_unref(earlier-&gt;<wbr>udev)=
;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0FREE(earlier);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +}<br>
&gt; +<br>
&gt; +void<br>
&gt; +uevent_merge(struct uevent *later, struct list_head *tmpq)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct uevent *earlier, *tmp;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0list_for_some_entry_reverse_<wbr>safe(earlier, tm=
p, &amp;later-&gt;node, tmpq, node) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (merge_need_stop(e=
arlier, later))<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0break;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * merge earlier ueve=
nts to the later uevent<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (uevent_can_merge(=
earlier, later)) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0condlog(2, &quot;merged uevent: %s-%s-%s with uevent: %s-%s-%s&quot;=
,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0earlier-&gt;action, earlier-&gt;kernel, =
earlier-&gt;wwid,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0later-&gt;action, later-&gt;kernel, late=
r-&gt;wwid);<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0list_move(&amp;earlier-&gt;node, &amp;later-&gt;merge_node);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +}<br>
&gt; +<br>
&gt; +void<br>
&gt; +merge_uevq(struct list_head *tmpq)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct uevent *later;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0uevent_prepare(tmpq);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0list_for_each_entry_reverse(<wbr>later, tmpq, nod=
e) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0uevent_filter(later, =
tmpq);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if(uevent_need_merge(=
))<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0uevent_merge(later, tmpq);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +}<br>
&gt; +<br>
&gt; +void<br>
&gt; +service_uevq(struct list_head *tmpq)<br>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct uevent *uev, *tmp;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0list_for_each_entry_safe(uev, tmp, tmpq, nod=
e) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0list_del_init(&a=
mp;uev-&gt;node);<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (my_uev_trigger &a=
mp;&amp; my_uev_trigger(uev, my_trigger_data))<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0condlog(0, &quot;uevent trigger error&quot;);<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0uevq_cleanup(&amp;uev=
-&gt;merge_node)<wbr>;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (uev-&gt;udev)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0udev_device_unref(uev-&gt;udev);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0FREE(uev);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 }<br>
&gt;<br>
&gt; +static void uevent_cleanup(void *arg)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct udev *udev =3D arg;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0condlog(3, &quot;Releasing uevent_listen() resour=
ces&quot;);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0udev_unref(udev);<br>
&gt; +}<br>
&gt; +<br>
&gt;=C2=A0 /*<br>
&gt;=C2=A0 =C2=A0* Service the uevent queue.<br>
&gt;=C2=A0 =C2=A0*/<br>
&gt; @@ -142,6 +405,7 @@ int uevent_dispatch(int (*uev_trigger)(struct ueve=
nt *, void * trigger_data),<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pthread_mutex_un=
lock(uevq_<wbr>lockp);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!my_uev_trig=
ger)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0break;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0merge_uevq(&amp;uevq_=
tmp);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0service_uevq(&am=
p;uevq_tmp);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(3, &quot;Terminating uev service que=
ue&quot;);<br>
&gt; @@ -442,11 +706,43 @@ struct uevent *uevent_from_udev_device(<wbr>stru=
ct udev_device *dev)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0return uev;<br>
&gt;=C2=A0 }<br>
&gt;<br>
&gt; +bool uevent_burst(struct timeval *start_time, int events)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct timeval diff_time, end_time;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0unsigned long speed;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0unsigned long eclipse_ms;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if(events &gt; MAX_ACCUMULATION_COUNT) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(2, &quot;burs=
t got %u uevents, too much uevents, stopped&quot;, events);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return false;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0gettimeofday(&amp;end_time, NULL);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0timersub(&amp;end_time, start_time, &amp;diff_tim=
e);<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0eclipse_ms =3D diff_time.tv_sec * 1000 + diff_tim=
e.tv_usec / 1000;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (eclipse_ms =3D=3D 0)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return true;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (eclipse_ms &gt; MAX_ACCUMULATION_TIME) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(2, &quot;burs=
t continued %lu ms, too long time, stopped&quot;, eclipse_ms);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return false;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0speed =3D (events * 1000) / eclipse_ms;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (speed &gt; MIN_BURST_SPEED)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return true;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return false;<br>
&gt; +}<br>
&gt; +<br>
&gt;=C2=A0 int uevent_listen(struct udev *udev)<br>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int err =3D 2;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct udev_monitor *monitor =3D NULL;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int fd, socket_flags, events;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct timeval start_time;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int need_failback =3D 1;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int timeout =3D 30;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0LIST_HEAD(uevlisten_tmp);<br>
&gt; @@ -500,6 +796,7 @@ int uevent_listen(struct udev *udev)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0events =3D 0;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0gettimeofday(&amp;start_time, NULL);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0while (1) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct uevent *u=
ev;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct udev_devi=
ce *dev;<br>
&gt; @@ -514,7 +811,7 @@ int uevent_listen(struct udev *udev)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0errno =3D 0;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fdcount =3D poll=
(&amp;ev_poll, 1, poll_timeout);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (fdcount &amp=
;&amp; ev_poll.revents &amp; POLLIN) {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0timeout =3D 0;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0timeout =3D uevent_burst(&amp;start_time, events + 1) ? 1 : 0;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0dev =3D udev_monitor_receive_device(<wbr>monitor);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0if (!dev) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(0, &quot;failed getting ud=
ev device&quot;);<br>
&gt; @@ -547,6 +844,7 @@ int uevent_listen(struct udev *udev)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0pthread_mutex_unlock(uevq_<wbr>lockp);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0events =3D 0;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0gettimeofday(&amp;sta=
rt_time, NULL);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0timeout =3D 30;<=
br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0need_failback =3D 0;<br>
&gt; diff --git a/libmultipath/uevent.h b/libmultipath/uevent.h<br>
&gt; index 9d22dcd..61a4207 100644<br>
&gt; --- a/libmultipath/uevent.h<br>
&gt; +++ b/libmultipath/uevent.h<br>
&gt; @@ -17,11 +17,13 @@ struct udev;<br>
&gt;<br>
&gt;=C2=A0 struct uevent {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct list_head node;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct list_head merge_node;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct udev_device *udev;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0char buffer[HOTPLUG_BUFFER_SIZE + OBJECT_SIZ=
E];<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0char *devpath;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0char *action;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0char *kernel;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0char *wwid;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long seqnum;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0char *envp[HOTPLUG_NUM_ENVP];<br>
&gt;=C2=A0 };<br>
&gt; diff --git a/libmultipath/util.c b/libmultipath/util.c<br>
&gt; index 03a5738..e1e83cf 100644<br>
&gt; --- a/libmultipath/util.c<br>
&gt; +++ b/libmultipath/util.c<br>
&gt; @@ -261,6 +261,48 @@ dev_t parse_devt(const char *dev_t)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0return makedev(maj, min);<br>
&gt;=C2=A0 }<br>
&gt;<br>
&gt; +char *parse_uid_attribute_by_attrs(<wbr>char *uid_attrs, char *path_d=
ev)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0char *uid_attribute;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0char *uid_attr_record;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0char *dev;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0char *attr;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0char *tmp;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0int=C2=A0 count;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if(!uid_attrs || !path_dev)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return NULL;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0count =3D get_word(uid_attrs, &amp;uid_attr_recor=
d);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0while (uid_attr_record) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tmp =3D strrchr(uid_a=
ttr_record, &#39;:&#39;);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!tmp) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0free(uid_attr_record);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0if (!count)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0uid_attrs +=3D count;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0count =3D get_word(uid_attrs, &amp;uid_attr_record);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0continue;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dev =3D uid_attr_reco=
rd;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0attr =3D tmp + 1;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*tmp =3D &#39;\0&#39;=
;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if(!strncmp(path_dev,=
 dev, strlen(dev))) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0uid_attribute =3D STRDUP(attr);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0free(uid_attr_record);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0return uid_attribute;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0free(uid_attr_record)=
;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!count)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0break;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0uid_attrs +=3D count;=
<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0count =3D get_word(ui=
d_attrs, &amp;uid_attr_record);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return NULL;<br>
&gt; +}<br>
&gt; +<br>
&gt;=C2=A0 void<br>
&gt;=C2=A0 setup_thread_attr(pthread_<wbr>attr_t *attr, size_t stacksize, i=
nt detached)<br>
&gt;=C2=A0 {<br>
&gt; diff --git a/libmultipath/util.h b/libmultipath/util.h<br>
&gt; index f3b37ee..793f2b7 100644<br>
&gt; --- a/libmultipath/util.h<br>
&gt; +++ b/libmultipath/util.h<br>
&gt; @@ -12,6 +12,7 @@ size_t strlcat(char *dst, const char *src, size_t si=
ze);<br>
&gt;=C2=A0 int devt2devname (char *, int, char *);<br>
&gt;=C2=A0 dev_t parse_devt(const char *dev_t);<br>
&gt;=C2=A0 char *convert_dev(char *dev, int is_path_device);<br>
&gt; +char *parse_uid_attribute_by_attrs(<wbr>char *uid_attrs, char *path_d=
ev);<br>
&gt;=C2=A0 void setup_thread_attr(pthread_<wbr>attr_t *attr, size_t stacksi=
ze, int detached);<br>
&gt;<br>
&gt;=C2=A0 #define safe_sprintf(var, format, args...)=C2=A0 =C2=A0\<br>
&gt; diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5<b=
r>
&gt; index 36589f5..63c63c2 100644<br>
&gt; --- a/multipath/multipath.conf.5<br>
&gt; +++ b/multipath/multipath.conf.5<br>
&gt; @@ -209,6 +209,24 @@ The default is: \fBfailover\fR<br>
&gt;=C2=A0 .<br>
&gt;=C2=A0 .<br>
&gt;=C2=A0 .TP<br>
&gt; +.B uid_attrs<br>
&gt; +The udev attribute providing a unique path identifier for correspondi=
ng<br>
&gt; +type of path devices. If this field is configured and matched with ty=
pe<br>
&gt; +of device, it would override any other methods providing for device<b=
r>
&gt; +unique identifier in config file, and it would activate merging ueven=
ts<br>
&gt; +according to the identifier to promote effiecncy in processing uevent=
s.<br>
&gt; +Tt has no default value, if you want to identify path by udev attribu=
te<br>
&gt; +and to activate merging uevents for SCSI and DAS device, you can set<=
br>
&gt; +it&#39;s value as:<br>
&gt; +.RS<br>
&gt; +.TP<br>
&gt; +\fBuid_attrs &quot;sd:ID_SERIAL dasd:ID_UID&quot;\fR<br>
&gt; +.TP<br>
&gt; +The default is: \fB&lt;unset&gt;\fR<br>
&gt; +.RE<br>
&gt; +.<br>
&gt; +.<br>
&gt; +.TP<br>
&gt;=C2=A0 .B uid_attribute<br>
&gt;=C2=A0 The udev attribute providing a unique path identifier.<br>
&gt;=C2=A0 .RS<br>
&gt; diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c<br>
&gt; index b0eeca6..12f85de 100644<br>
&gt; --- a/multipathd/cli_handlers.c<br>
&gt; +++ b/multipathd/cli_handlers.c<br>
&gt; @@ -670,7 +670,7 @@ cli_add_path (void * v, char ** reply, int * len, =
void * data)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pp-&gt;checkint =
=3D conf-&gt;checkint;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0put_multipath_config(conf);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0return ev_add_path(pp, vecs);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return ev_add_path(pp, vecs, 1);<br>
&gt;=C2=A0 blacklisted:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0*reply =3D strdup(&quot;blacklisted\n&quot;)=
;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0*len =3D strlen(*reply) + 1;<br>
&gt; @@ -692,7 +692,7 @@ cli_del_path (void * v, char ** reply, int * len, =
void * data)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(0, &quot=
;%s: path already removed&quot;, param);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 1;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; -=C2=A0 =C2=A0 =C2=A0return ev_remove_path(pp, vecs);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return ev_remove_path(pp, vecs, 1);<br>
&gt;=C2=A0 }<br>
&gt;<br>
&gt;=C2=A0 int<br>
&gt; diff --git a/multipathd/main.c b/multipathd/main.c<br>
&gt; index adc3258..e513f7d 100644<br>
&gt; --- a/multipathd/main.c<br>
&gt; +++ b/multipathd/main.c<br>
&gt; @@ -608,7 +608,7 @@ ev_remove_map (char * devname, char * alias, int m=
inor, struct vectors * vecs)<br>
&gt;=C2=A0 }<br>
&gt;<br>
&gt;=C2=A0 static int<br>
&gt; -uev_add_path (struct uevent *uev, struct vectors * vecs)<br>
&gt; +uev_add_path (struct uevent *uev, struct vectors * vecs, int need_do_=
map)<br>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct path *pp;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int ret =3D 0, i;<br>
&gt; @@ -641,7 +641,7 @@ uev_add_path (struct uevent *uev, struct vectors *=
 vecs)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 DI_ALL | DI_BLACKLI=
ST);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0put_multipath_config(conf);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0if (r =3D=3D PATHINFO_OK)<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D ev_add_path(pp, vecs);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D ev_add_path(pp, vecs, need_do_ma=
p);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0else if (r =3D=3D PATHINFO_SKIPPED) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(3, &quot;%s: remove blackl=
isted path&quot;,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0uev-&g=
t;kernel);<br>
&gt; @@ -665,7 +665,7 @@ uev_add_path (struct uevent *uev, struct vectors *=
 vecs)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0conf =3D get_multipath_config();<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D alloc_path_with_pathinfo(conf, uev-&=
gt;udev,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 DI_ALL, &amp;pp);<=
br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 uev-&gt;wwid, DI_A=
LL, &amp;pp);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0put_multipath_config(conf);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!pp) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret =3D=3D P=
ATHINFO_SKIPPED)<br>
&gt; @@ -681,7 +681,7 @@ uev_add_path (struct uevent *uev, struct vectors *=
 vecs)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0conf =3D get_mul=
tipath_config();<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pp-&gt;checkint =
=3D conf-&gt;checkint;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0put_multipath_co=
nfig(conf);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D ev_add_path(p=
p, vecs);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D ev_add_path(p=
p, vecs, need_do_map);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0} else {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(0, &quot=
;%s: failed to store path info, &quot;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0&quot;dropping event&quot;,<br>
&gt; @@ -699,7 +699,7 @@ uev_add_path (struct uevent *uev, struct vectors *=
 vecs)<br>
&gt;=C2=A0 =C2=A0* 1: error<br>
&gt;=C2=A0 =C2=A0*/<br>
&gt;=C2=A0 int<br>
&gt; -ev_add_path (struct path * pp, struct vectors * vecs)<br>
&gt; +ev_add_path (struct path * pp, struct vectors * vecs, int need_do_map=
)<br>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct multipath * mpp;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0char params[PARAMS_SIZE] =3D {0};<br>
&gt; @@ -767,6 +767,13 @@ rescan:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/* persistent reservation check*/<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0mpath_pr_event_handle(pp);<br>
&gt;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (!need_do_map)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (!dm_map_present(mpp-&gt;alias)) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mpp-&gt;action =3D AC=
T_CREATE;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0start_waiter =3D 1;<b=
r>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 * push the map to the device-mapper<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
&gt; @@ -833,7 +840,7 @@ fail:<br>
&gt;=C2=A0 }<br>
&gt;<br>
&gt;=C2=A0 static int<br>
&gt; -uev_remove_path (struct uevent *uev, struct vectors * vecs)<br>
&gt; +uev_remove_path (struct uevent *uev, struct vectors * vecs, int need_=
do_map)<br>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct path *pp;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int ret;<br>
&gt; @@ -844,7 +851,7 @@ uev_remove_path (struct uevent *uev, struct vector=
s * vecs)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0pthread_testcancel();<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0pp =3D find_path_by_dev(vecs-&gt;<wbr>pathve=
c, uev-&gt;kernel);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (pp)<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D ev_remove_pat=
h(pp, vecs);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D ev_remove_pat=
h(pp, vecs, need_do_map);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0lock_cleanup_pop(vecs-&gt;lock);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!pp) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Not an error;=
 path might have been purged earlier */<br>
&gt; @@ -855,7 +862,7 @@ uev_remove_path (struct uevent *uev, struct vector=
s * vecs)<br>
&gt;=C2=A0 }<br>
&gt;<br>
&gt;=C2=A0 int<br>
&gt; -ev_remove_path (struct path *pp, struct vectors * vecs)<br>
&gt; +ev_remove_path (struct path *pp, struct vectors * vecs, int need_do_m=
ap)<br>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct multipath * mpp;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int i, retval =3D 0;<br>
&gt; @@ -918,6 +925,8 @@ ev_remove_path (struct path *pp, struct vectors * =
vecs)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0goto out;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!need_do_map)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0goto out;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * reload the ma=
p<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
&gt; @@ -995,7 +1004,7 @@ uev_update_path (struct uevent *uev, struct vecto=
rs * vecs)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (pp-&gt;initi=
alized =3D=3D INIT_REQUESTED_UDEV)<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0retval =3D uev_add_path(uev, vecs);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0retval =3D uev_add_path(uev, vecs, 1);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0else if (mpp &am=
p;&amp; ro &gt;=3D 0) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0condlog(2, &quot;%s: update path write_protect to &#39;%d&#39;=
 (uevent)&quot;, uev-&gt;kernel, ro);<br>
&gt;<br>
&gt; @@ -1016,7 +1025,7 @@ out:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0int flag =3D DI_SYSFS | DI_WWID;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0conf =3D get_multipath_config();<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0retval =3D alloc_path_with_pathinfo(conf, uev-&gt;udev, flag, NULL);=
<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0retval =3D alloc_path_with_pathinfo(conf, uev-&gt;udev, uev-&gt;wwid=
, flag, NULL);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0put_multipath_config(conf);<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0if (retval =3D=3D PATHINFO_SKIPPED) {<br>
&gt; @@ -1077,40 +1086,15 @@ uxsock_trigger (char * str, char ** reply, int=
 * len, void * trigger_data)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0return r;<br>
&gt;=C2=A0 }<br>
&gt;<br>
&gt; -static int<br>
&gt; -uev_discard(char * devpath)<br>
&gt; -{<br>
&gt; -=C2=A0 =C2=A0 =C2=A0char *tmp;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0char a[11], b[11];<br>
&gt; -<br>
&gt; -=C2=A0 =C2=A0 =C2=A0/*<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 * keep only block devices, discard partitions<br=
>
&gt; -=C2=A0 =C2=A0 =C2=A0 */<br>
&gt; -=C2=A0 =C2=A0 =C2=A0tmp =3D strstr(devpath, &quot;/block/&quot;);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0if (tmp =3D=3D NULL){<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(4, &quot;no /=
block/ in &#39;%s&#39;&quot;, devpath);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 1;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0}<br>
&gt; -=C2=A0 =C2=A0 =C2=A0if (sscanf(tmp, &quot;/block/%10s&quot;, a) !=3D =
1 ||<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sscanf(tmp, &quot;/block/%10[^/]/%1=
0s&quot;, a, b) =3D=3D 2) {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(4, &quot;disc=
ard event on %s&quot;, devpath);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 1;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0}<br>
&gt; -=C2=A0 =C2=A0 =C2=A0return 0;<br>
&gt; -}<br>
&gt; -<br>
&gt;=C2=A0 int<br>
&gt;=C2=A0 uev_trigger (struct uevent * uev, void * trigger_data)<br>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int r =3D 0;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct vectors * vecs;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0struct config *conf;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct uevent *merge_uev, *tmp;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0vecs =3D (struct vectors *)trigger_data;<br>
&gt;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0if (uev_discard(uev-&gt;devpath))<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
&gt; -<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0pthread_cleanup_push(config_<wbr>cleanup, NU=
LL);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0pthread_mutex_lock(&amp;config_<wbr>lock);<b=
r>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (running_state !=3D DAEMON_IDLE &amp;&amp=
;<br>
&gt; @@ -1139,28 +1123,21 @@ uev_trigger (struct uevent * uev, void * trigg=
er_data)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 * path add/remove event<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * path add/remove/change event, add/remove maybe=
 merged<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
&gt; -=C2=A0 =C2=A0 =C2=A0conf =3D get_multipath_config();<br>
&gt; -=C2=A0 =C2=A0 =C2=A0if (filter_devnode(conf-&gt;blist_<wbr>devnode, c=
onf-&gt;elist_devnode,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 uev-&gt;kernel) &gt; 0) {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0put_multipath_config(=
conf);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0list_for_each_entry_safe(<wbr>merge_uev, tmp, &am=
p;uev-&gt;merge_node, node) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!strncmp(merge_ue=
v-&gt;action, &quot;add&quot;, 3))<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0r +=3D uev_add_path(merge_uev, vecs, 0);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!strncmp(merge_ue=
v-&gt;action, &quot;remove&quot;, 6))<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0r +=3D uev_remove_path(merge_uev, vecs, 0);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; -=C2=A0 =C2=A0 =C2=A0put_multipath_config(conf);<br>
&gt;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0if (!strncmp(uev-&gt;action, &quot;add&quot;, 3))=
 {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0r =3D uev_add_path(ue=
v, vecs);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0}<br>
&gt; -=C2=A0 =C2=A0 =C2=A0if (!strncmp(uev-&gt;action, &quot;remove&quot;, =
6)) {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0r =3D uev_remove_path=
(uev, vecs);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0}<br>
&gt; -=C2=A0 =C2=A0 =C2=A0if (!strncmp(uev-&gt;action, &quot;change&quot;, =
6)) {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0r =3D uev_update_path=
(uev, vecs);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (!strncmp(uev-&gt;action, &quot;add&quot;, 3))=
<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0r +=3D uev_add_path(u=
ev, vecs, 1);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (!strncmp(uev-&gt;action, &quot;remove&quot;, =
6))<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0r +=3D uev_remove_pat=
h(uev, vecs, 1);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (!strncmp(uev-&gt;action, &quot;change&quot;, =
6))<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0r +=3D uev_update_pat=
h(uev, vecs);<br>
&gt;<br>
&gt;=C2=A0 out:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0return r;<br>
&gt; @@ -1570,7 +1547,7 @@ check_path (struct vectors * vecs, struct path *=
 pp, int ticks)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0conf =3D get_multipath_config();<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0ret =3D pathinfo(pp, conf, DI_ALL | DI_BLACKLIST);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0if (ret =3D=3D PATHINFO_OK) {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ev_add_path(pp, vecs);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ev_add_path(pp, vecs, 1);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pp-&gt;tick =3D 1;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0} else if (ret =3D=3D PATHINFO_SKIPPED) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0put_multipath_config(conf);<br>
&gt; @@ -1686,7 +1663,7 @@ check_path (struct vectors * vecs, struct path *=
 pp, int ticks)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!disable_rei=
nstate &amp;&amp; reinstate_path(pp, add_active)) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0condlog(3, &quot;%s: reload map&quot;, pp-&gt;dev);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0ev_add_path(pp, vecs);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0ev_add_path(pp, vecs, 1);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0pp-&gt;tick =3D 1;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0return 0;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; @@ -1709,7 +1686,7 @@ check_path (struct vectors * vecs, struct path *=
 pp, int ticks)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0/* Clear IO errors */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0if (reinstate_path(pp, 0)) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(3, &quot;%s: reload map&qu=
ot;, pp-&gt;dev);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ev_add_path(pp, vecs);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ev_add_path(pp, vecs, 1);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pp-&gt;tick =3D 1;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0}<br>
&gt; diff --git a/multipathd/main.h b/multipathd/main.h<br>
&gt; index f72580d..094b04f 100644<br>
&gt; --- a/multipathd/main.h<br>
&gt; +++ b/multipathd/main.h<br>
&gt; @@ -22,8 +22,8 @@ void exit_daemon(void);<br>
&gt;=C2=A0 const char * daemon_status(void);<br>
&gt;=C2=A0 int need_to_delay_reconfig (struct vectors *);<br>
&gt;=C2=A0 int reconfigure (struct vectors *);<br>
&gt; -int ev_add_path (struct path *, struct vectors *);<br>
&gt; -int ev_remove_path (struct path *, struct vectors *);<br>
&gt; +int ev_add_path (struct path *, struct vectors *, int);<br>
&gt; +int ev_remove_path (struct path *, struct vectors *, int);<br>
&gt;=C2=A0 int ev_add_map (char *, char *, struct vectors *);<br>
&gt;=C2=A0 int ev_remove_map (char *, char *, int, struct vectors *);<br>
&gt;=C2=A0 void sync_map_state (struct multipath *);<br>
&gt; --<br>
&gt; 2.8.1.windows.1<br>
&gt;<br>
</div></div></blockquote></div><br></div>

--001a114e25ac1a5ff505497d0378--


--===============2278247001058869506==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2278247001058869506==--
