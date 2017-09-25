From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v4 1/6] libmultipath: add detect_checker
	option
Date: Mon, 25 Sep 2017 11:49:24 -0500
Message-ID: <20170925164924.GX3145@octiron.msp.redhat.com>
References: <1488220003-20541-1-git-send-email-bmarzins@redhat.com>
	<1488220003-20541-2-git-send-email-bmarzins@redhat.com>
	<826b6ac9-7aa9-39bd-6126-3b5198b8056e@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <826b6ac9-7aa9-39bd-6126-3b5198b8056e@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>, "Stewart,
	Sean" <Sean.Stewart@netapp.com>
List-Id: dm-devel.ids

On Mon, Sep 25, 2017 at 06:15:20PM +0200, Xose Vazquez Perez wrote:
> On 02/27/2017 07:26 PM, Benjamin Marzinski wrote:
> 
> > This patch adds a detect_checker option that works just like the
> > detect_prio option.  It currently only detects ALUA devices, and
> > if it finds ALUA support, it sets the priortizier to TUR. This is
> > useful for devices like the VNX2, where it should be using the
> > TUR checker when in ALUA mode (or so I have been told). It is set on by
> > default just like detect_prio and retain_attached_hw_handler.
> 
> RDAC devices are going also to be affected with this change.
> Is it desired?

No. I'll send a patch that adds a check_rdac() call before setting the
checker type to TUR.

Good catch
-Ben

> 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/config.c                 |  3 +++
> >  libmultipath/config.h                 |  2 ++
> >  libmultipath/defaults.h               |  1 +
> >  libmultipath/dict.c                   | 10 ++++++++++
> >  libmultipath/discovery.c              | 28 ++++++++++++++++++++++++++--
> >  libmultipath/hwtable.c                |  1 +
> >  libmultipath/prioritizers/alua_spc3.h |  1 +
> >  libmultipath/propsel.c                | 31 +++++++++++++++++++++----------
> >  libmultipath/propsel.h                |  1 +
> >  libmultipath/structs.c                |  2 ++
> >  libmultipath/structs.h                |  7 +++++++
> >  multipath/multipath.conf.5            | 18 ++++++++++++++++++
> >  12 files changed, 93 insertions(+), 12 deletions(-)
> > 
> > diff --git a/libmultipath/config.c b/libmultipath/config.c
> > index 5837dc6..9d3f3e1 100644
> > --- a/libmultipath/config.c
> > +++ b/libmultipath/config.c
> > @@ -343,6 +343,7 @@ merge_hwe (struct hwentry * dst, struct hwentry * src)
> >  	merge_num(user_friendly_names);
> >  	merge_num(retain_hwhandler);
> >  	merge_num(detect_prio);
> > +	merge_num(detect_checker);
> >  	merge_num(deferred_remove);
> >  	merge_num(delay_watch_checks);
> >  	merge_num(delay_wait_checks);
> > @@ -423,6 +424,7 @@ store_hwe (vector hwtable, struct hwentry * dhwe)
> >  	hwe->user_friendly_names = dhwe->user_friendly_names;
> >  	hwe->retain_hwhandler = dhwe->retain_hwhandler;
> >  	hwe->detect_prio = dhwe->detect_prio;
> > +	hwe->detect_checker = dhwe->detect_checker;
> >  
> >  	if (dhwe->bl_product && !(hwe->bl_product = set_param_str(dhwe->bl_product)))
> >  		goto out;
> > @@ -610,6 +612,7 @@ load_config (char * file)
> >  	conf->fast_io_fail = DEFAULT_FAST_IO_FAIL;
> >  	conf->retain_hwhandler = DEFAULT_RETAIN_HWHANDLER;
> >  	conf->detect_prio = DEFAULT_DETECT_PRIO;
> > +	conf->detect_checker = DEFAULT_DETECT_CHECKER;
> >  	conf->force_sync = DEFAULT_FORCE_SYNC;
> >  	conf->partition_delim = DEFAULT_PARTITION_DELIM;
> >  	conf->processed_main_config = 0;
> > diff --git a/libmultipath/config.h b/libmultipath/config.h
> > index 9e47894..9a90745 100644
> > --- a/libmultipath/config.h
> > +++ b/libmultipath/config.h
> > @@ -62,6 +62,7 @@ struct hwentry {
> >  	int user_friendly_names;
> >  	int retain_hwhandler;
> >  	int detect_prio;
> > +	int detect_checker;
> >  	int deferred_remove;
> >  	int delay_watch_checks;
> >  	int delay_wait_checks;
> > @@ -139,6 +140,7 @@ struct config {
> >  	int reassign_maps;
> >  	int retain_hwhandler;
> >  	int detect_prio;
> > +	int detect_checker;
> >  	int force_sync;
> >  	int deferred_remove;
> >  	int processed_main_config;
> > diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
> > index 3ef1579..db2b756 100644
> > --- a/libmultipath/defaults.h
> > +++ b/libmultipath/defaults.h
> > @@ -22,6 +22,7 @@
> >  #define DEFAULT_DEV_LOSS_TMO	600
> >  #define DEFAULT_RETAIN_HWHANDLER RETAIN_HWHANDLER_ON
> >  #define DEFAULT_DETECT_PRIO	DETECT_PRIO_ON
> > +#define DEFAULT_DETECT_CHECKER	DETECT_CHECKER_ON
> >  #define DEFAULT_DEFERRED_REMOVE	DEFERRED_REMOVE_OFF
> >  #define DEFAULT_DELAY_CHECKS	NU_NO
> >  #define DEFAULT_ERR_CHECKS	NU_NO
> > diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> > index 3521c78..bababdb 100644
> > --- a/libmultipath/dict.c
> > +++ b/libmultipath/dict.c
> > @@ -379,6 +379,13 @@ declare_ovr_snprint(detect_prio, print_yes_no_undef)
> >  declare_hw_handler(detect_prio, set_yes_no_undef)
> >  declare_hw_snprint(detect_prio, print_yes_no_undef)
> >  
> > +declare_def_handler(detect_checker, set_yes_no_undef)
> > +declare_def_snprint_defint(detect_checker, print_yes_no_undef, YNU_NO)
> > +declare_ovr_handler(detect_checker, set_yes_no_undef)
> > +declare_ovr_snprint(detect_checker, print_yes_no_undef)
> > +declare_hw_handler(detect_checker, set_yes_no_undef)
> > +declare_hw_snprint(detect_checker, print_yes_no_undef)
> > +
> >  declare_def_handler(force_sync, set_yes_no)
> >  declare_def_snprint(force_sync, print_yes_no)
> >  
> > @@ -1419,6 +1426,7 @@ init_keywords(vector keywords)
> >  	install_keyword("reservation_key", &def_reservation_key_handler, &snprint_def_reservation_key);
> >  	install_keyword("retain_attached_hw_handler", &def_retain_hwhandler_handler, &snprint_def_retain_hwhandler);
> >  	install_keyword("detect_prio", &def_detect_prio_handler, &snprint_def_detect_prio);
> > +	install_keyword("detect_checker", &def_detect_checker_handler, &snprint_def_detect_checker);
> >  	install_keyword("force_sync", &def_force_sync_handler, &snprint_def_force_sync);
> >  	install_keyword("strict_timing", &def_strict_timing_handler, &snprint_def_strict_timing);
> >  	install_keyword("deferred_remove", &def_deferred_remove_handler, &snprint_def_deferred_remove);
> > @@ -1509,6 +1517,7 @@ init_keywords(vector keywords)
> >  	install_keyword("user_friendly_names", &hw_user_friendly_names_handler, &snprint_hw_user_friendly_names);
> >  	install_keyword("retain_attached_hw_handler", &hw_retain_hwhandler_handler, &snprint_hw_retain_hwhandler);
> >  	install_keyword("detect_prio", &hw_detect_prio_handler, &snprint_hw_detect_prio);
> > +	install_keyword("detect_checker", &hw_detect_checker_handler, &snprint_hw_detect_checker);
> >  	install_keyword("deferred_remove", &hw_deferred_remove_handler, &snprint_hw_deferred_remove);
> >  	install_keyword("delay_watch_checks", &hw_delay_watch_checks_handler, &snprint_hw_delay_watch_checks);
> >  	install_keyword("delay_wait_checks", &hw_delay_wait_checks_handler, &snprint_hw_delay_wait_checks);
> > @@ -1541,6 +1550,7 @@ init_keywords(vector keywords)
> >  	install_keyword("user_friendly_names", &ovr_user_friendly_names_handler, &snprint_ovr_user_friendly_names);
> >  	install_keyword("retain_attached_hw_handler", &ovr_retain_hwhandler_handler, &snprint_ovr_retain_hwhandler);
> >  	install_keyword("detect_prio", &ovr_detect_prio_handler, &snprint_ovr_detect_prio);
> > +	install_keyword("detect_checker", &ovr_detect_checker_handler, &snprint_ovr_detect_checker);
> >  	install_keyword("deferred_remove", &ovr_deferred_remove_handler, &snprint_ovr_deferred_remove);
> >  	install_keyword("delay_watch_checks", &ovr_delay_watch_checks_handler, &snprint_ovr_delay_watch_checks);
> >  	install_keyword("delay_wait_checks", &ovr_delay_wait_checks_handler, &snprint_ovr_delay_wait_checks);
> > diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> > index 39dd92a..4e99845 100644
> > --- a/libmultipath/discovery.c
> > +++ b/libmultipath/discovery.c
> > @@ -30,6 +30,7 @@
> >  #include "discovery.h"
> >  #include "prio.h"
> >  #include "defaults.h"
> > +#include "prioritizers/alua_rtpg.h"
> >  
> >  int
> >  alloc_path_with_pathinfo (struct config *conf, struct udev_device *udevice,
> > @@ -829,6 +830,25 @@ get_serial (char * str, int maxlen, int fd)
> >  	return 1;
> >  }
> >  
> > +static void
> > +detect_alua(struct path * pp, struct config *conf)
> > +{
> > +	int ret;
> > +	int tpgs;
> > +	unsigned int timeout = conf->checker_timeout;
> > +
> > +	if ((tpgs = get_target_port_group_support(pp->fd, timeout)) <= 0) {
> > +		pp->tpgs = TPGS_NONE;
> > +		return;
> > +	}
> > +	ret = get_target_port_group(pp, timeout);
> > +	if (ret < 0 || get_asymmetric_access_state(pp->fd, ret, timeout) < 0) {
> > +		pp->tpgs = TPGS_NONE;
> > +		return;
> > +	}
> > +	pp->tpgs = tpgs;
> > +}
> > +
> >  #define DEFAULT_SGIO_LEN 254
> >  
> >  static int
> > @@ -1460,11 +1480,14 @@ sysfs_pathinfo(struct path * pp, vector hwtable)
> >  }
> >  
> >  static int
> > -scsi_ioctl_pathinfo (struct path * pp, int mask)
> > +scsi_ioctl_pathinfo (struct path * pp, struct config *conf, int mask)
> >  {
> >  	struct udev_device *parent;
> >  	const char *attr_path = NULL;
> >  
> > +	if (pp->tpgs == TPGS_UNDEF)
> > +		detect_alua(pp, conf);
> > +
> >  	if (!(mask & DI_SERIAL))
> >  		return 0;
> >  
> > @@ -1524,6 +1547,7 @@ get_state (struct path * pp, struct config *conf, int daemon)
> >  				return PATH_UNCHECKED;
> >  			}
> >  		}
> > +		select_detect_checker(conf, pp);
> >  		select_checker(conf, pp);
> >  		if (!checker_selected(c)) {
> >  			condlog(3, "%s: No checker selected", pp->dev);
> > @@ -1832,7 +1856,7 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
> >  		get_geometry(pp);
> >  
> >  	if (path_state == PATH_UP && pp->bus == SYSFS_BUS_SCSI &&
> > -	    scsi_ioctl_pathinfo(pp, mask))
> > +	    scsi_ioctl_pathinfo(pp, conf, mask))
> >  		goto blank;
> >  
> >  	if (pp->bus == SYSFS_BUS_CCISS &&
> > diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> > index 8409261..c944015 100644
> > --- a/libmultipath/hwtable.c
> > +++ b/libmultipath/hwtable.c
> > @@ -1122,6 +1122,7 @@ static struct hwentry default_hw[] = {
> >  		.dev_loss      = 600,
> >  		.retain_hwhandler = RETAIN_HWHANDLER_ON,
> >  		.detect_prio   = DETECT_PRIO_ON,
> > +		.detect_checker = DETECT_CHECKER_ON,
> >  		.deferred_remove = DEFERRED_REMOVE_OFF,
> >  		.delay_watch_checks = DELAY_CHECKS_OFF,
> >  		.delay_wait_checks = DELAY_CHECKS_OFF,
> > diff --git a/libmultipath/prioritizers/alua_spc3.h b/libmultipath/prioritizers/alua_spc3.h
> > index 4d4969b..13a0924 100644
> > --- a/libmultipath/prioritizers/alua_spc3.h
> > +++ b/libmultipath/prioritizers/alua_spc3.h
> > @@ -109,6 +109,7 @@ inquiry_command_set_evpd(struct inquiry_command *ic)
> >  #define VERSION_SPC3					0x05
> >  
> >  /* Defined TPGS field values. */
> > +#define TPGS_UNDEF					 -1
> >  #define TPGS_NONE					0x0
> >  #define TPGS_IMPLICIT					0x1
> >  #define TPGS_EXPLICIT					0x2
> > diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> > index 1b27476..bba8194 100644
> > --- a/libmultipath/propsel.c
> > +++ b/libmultipath/propsel.c
> > @@ -312,6 +312,11 @@ int select_checker(struct config *conf, struct path *pp)
> >  	char *origin, *checker_name;
> >  	struct checker * c = &pp->checker;
> >  
> > +	if (pp->detect_checker == DETECT_CHECKER_ON && pp->tpgs > 0) {
> > +		checker_name = TUR;
> > +		origin = "(setting: array autodetected)";
> > +		goto out;
> > +	}
> >  	do_set(checker_name, conf->overrides, checker_name, "(setting: multipath.conf overrides section)");
> >  	do_set(checker_name, pp->hwe, checker_name, "(setting: array configuration)");
> >  	do_set(checker_name, conf, checker_name, "(setting: multipath.conf defaults/devices section)");
> > @@ -359,20 +364,11 @@ out:
> >  void
> >  detect_prio(struct config *conf, struct path * pp)
> >  {
> > -	int ret;
> >  	struct prio *p = &pp->prio;
> > -	int tpgs = 0;
> > -	unsigned int timeout = conf->checker_timeout;
> >  	char buff[512];
> >  	char *default_prio = PRIO_ALUA;
> >  
> > -	if ((tpgs = get_target_port_group_support(pp->fd, timeout)) <= 0)
> > -		return;
> > -	pp->tpgs = tpgs;
> > -	ret = get_target_port_group(pp, timeout);
> > -	if (ret < 0)
> > -		return;
> > -	if (get_asymmetric_access_state(pp->fd, ret, timeout) < 0)
> > +	if (pp->tpgs <= 0)
> >  		return;
> >  	if (sysfs_get_asymmetric_access_state(pp, buff, 512) >= 0)
> >  		default_prio = PRIO_SYSFS;
> > @@ -588,6 +584,21 @@ out:
> >  	return 0;
> >  }
> >  
> > +int select_detect_checker(struct config *conf, struct path *pp)
> > +{
> > +	char *origin;
> > +
> > +	pp_set_ovr(detect_checker);
> > +	pp_set_hwe(detect_checker);
> > +	pp_set_conf(detect_checker);
> > +	pp_set_default(detect_checker, DEFAULT_DETECT_CHECKER);
> > +out:
> > +	condlog(3, "%s: detect_checker = %s %s", pp->dev,
> > +		(pp->detect_checker == DETECT_CHECKER_ON)? "yes" : "no",
> > +		origin);
> > +	return 0;
> > +}
> > +
> >  int select_deferred_remove(struct config *conf, struct multipath *mp)
> >  {
> >  	char *origin;
> > diff --git a/libmultipath/propsel.h b/libmultipath/propsel.h
> > index e5b6f93..58a32f3 100644
> > --- a/libmultipath/propsel.h
> > +++ b/libmultipath/propsel.h
> > @@ -19,6 +19,7 @@ int select_dev_loss(struct config *conf, struct multipath *mp);
> >  int select_reservation_key(struct config *conf, struct multipath *mp);
> >  int select_retain_hwhandler (struct config *conf, struct multipath * mp);
> >  int select_detect_prio(struct config *conf, struct path * pp);
> > +int select_detect_checker(struct config *conf, struct path * pp);
> >  int select_deferred_remove(struct config *conf, struct multipath *mp);
> >  int select_delay_watch_checks (struct config *conf, struct multipath * mp);
> >  int select_delay_wait_checks (struct config *conf, struct multipath * mp);
> > diff --git a/libmultipath/structs.c b/libmultipath/structs.c
> > index ba9edf9..f36a055 100644
> > --- a/libmultipath/structs.c
> > +++ b/libmultipath/structs.c
> > @@ -17,6 +17,7 @@
> >  #include "structs_vec.h"
> >  #include "blacklist.h"
> >  #include "prio.h"
> > +#include "prioritizers/alua_spc3.h"
> >  
> >  struct adapter_group *
> >  alloc_adaptergroup(void)
> > @@ -96,6 +97,7 @@ alloc_path (void)
> >  		pp->sg_id.lun = -1;
> >  		pp->sg_id.proto_id = SCSI_PROTOCOL_UNSPEC;
> >  		pp->fd = -1;
> > +		pp->tpgs = TPGS_UNDEF;
> >  		pp->priority = PRIO_UNDEF;
> >  	}
> >  	return pp;
> > diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> > index dfd65ae..fdcfc85 100644
> > --- a/libmultipath/structs.h
> > +++ b/libmultipath/structs.h
> > @@ -122,6 +122,12 @@ enum detect_prio_states {
> >  	DETECT_PRIO_ON = YNU_YES,
> >  };
> >  
> > +enum detect_checker_states {
> > +	DETECT_CHECKER_UNDEF = YNU_UNDEF,
> > +	DETECT_CHECKER_OFF = YNU_NO,
> > +	DETECT_CHECKER_ON = YNU_YES,
> > +};
> > +
> >  enum deferred_remove_states {
> >  	DEFERRED_REMOVE_UNDEF = YNU_UNDEF,
> >  	DEFERRED_REMOVE_OFF = YNU_NO,
> > @@ -211,6 +217,7 @@ struct path {
> >  	int priority;
> >  	int pgindex;
> >  	int detect_prio;
> > +	int detect_checker;
> >  	int watch_checks;
> >  	int wait_checks;
> >  	int tpgs;
> > diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> > index 179013c..b08bda3 100644
> > --- a/multipath/multipath.conf.5
> > +++ b/multipath/multipath.conf.5
> > @@ -681,6 +681,20 @@ The default is: \fByes\fR
> >  .
> >  .
> >  .TP
> > +.B detect_checker
> > +if set to
> > +.I yes
> > +, multipath will try to detect if the device supports SCSI-3 ALUA. If so, the
> > +device will automatically use the \fItur\fR checker. If set to
> > +.I no
> > +, the checker will be selected as usual.
> > +.RS
> > +.TP
> > +The default is: \fByes\fR
> > +.RE
> > +.
> > +.
> > +.TP
> >  .B force_sync
> >  If set to
> >  .I yes
> > @@ -1169,6 +1183,8 @@ section:
> >  .TP
> >  .B detect_prio
> >  .TP
> > +.B detect_checker
> > +.TP
> >  .B deferred_remove
> >  .TP
> >  .B san_path_err_threshold
> > @@ -1239,6 +1255,8 @@ the values are taken from the \fIdevices\fR or \fIdefaults\fR sections:
> >  .TP
> >  .B detect_prio
> >  .TP
> > +.B detect_checker
> > +.TP
> >  .B deferred_remove
> >  .TP
> >  .B san_path_err_threshold
> > 
