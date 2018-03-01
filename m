From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [RFC PATCH 06/20] libmultipath/print: use "const"
 where appropriate
Date: Wed, 28 Feb 2018 23:37:22 -0600
Message-ID: <20180301053722.GV14513@octiron.msp.redhat.com>
References: <20180220132658.22295-1-mwilck@suse.com>
	<20180220132658.22295-7-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180220132658.22295-7-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Feb 20, 2018 at 02:26:44PM +0100, Martin Wilck wrote:
> Convert the print.h/print.c code to use "const" qualifiers
> properly. This is generally considered good programming practice,
> and the printing code shouldn't change any objects anyway.
> 

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/configure.h |   1 -
>  libmultipath/discovery.c |   6 +--
>  libmultipath/discovery.h |   6 ++-
>  libmultipath/print.c     | 133 ++++++++++++++++++++++++-----------------------
>  libmultipath/print.h     |  41 ++++++++-------
>  5 files changed, 95 insertions(+), 92 deletions(-)
> 
> diff --git a/libmultipath/configure.h b/libmultipath/configure.h
> index 0ffc28efdaf7..0f5d30a540ca 100644
> --- a/libmultipath/configure.h
> +++ b/libmultipath/configure.h
> @@ -35,5 +35,4 @@ int coalesce_paths (struct vectors *vecs, vector curmp, char * refwwid, int forc
>  int get_refwwid (enum mpath_cmds cmd, char * dev, enum devtypes dev_type,
>  		 vector pathvec, char **wwid);
>  int reload_map(struct vectors *vecs, struct multipath *mpp, int refresh, int is_daemon);
> -int sysfs_get_host_adapter_name(struct path *pp, char *adapter_name);
>  struct udev_device *get_udev_device(const char *dev, enum devtypes dev_type);
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index 88e9f3b61510..98bddee52c8f 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -401,7 +401,7 @@ sysfs_get_tgt_nodename (struct path *pp, char * node)
>  	return 0;
>  }
>  
> -int sysfs_get_host_adapter_name(struct path *pp, char *adapter_name)
> +int sysfs_get_host_adapter_name(const struct path *pp, char *adapter_name)
>  {
>  	int proto_id;
>  
> @@ -427,7 +427,7 @@ int sysfs_get_host_adapter_name(struct path *pp, char *adapter_name)
>  	return sysfs_get_host_pci_name(pp, adapter_name);
>  }
>  
> -int sysfs_get_host_pci_name(struct path *pp, char *pci_name)
> +int sysfs_get_host_pci_name(const struct path *pp, char *pci_name)
>  {
>  	struct udev_device *hostdev, *parent;
>  	char host_name[HOST_NAME_LEN];
> @@ -466,7 +466,7 @@ int sysfs_get_host_pci_name(struct path *pp, char *pci_name)
>  	return 1;
>  }
>  
> -int sysfs_get_iscsi_ip_address(struct path *pp, char *ip_address)
> +int sysfs_get_iscsi_ip_address(const struct path *pp, char *ip_address)
>  {
>  	struct udev_device *hostdev;
>  	char host_name[HOST_NAME_LEN];
> diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
> index bd5e6678a26d..9aacf75bfeb0 100644
> --- a/libmultipath/discovery.h
> +++ b/libmultipath/discovery.h
> @@ -44,8 +44,10 @@ int store_pathinfo (vector pathvec, struct config *conf,
>  		    struct path **pp_ptr);
>  int sysfs_set_scsi_tmo (struct multipath *mpp, int checkint);
>  int sysfs_get_timeout(struct path *pp, unsigned int *timeout);
> -int sysfs_get_host_pci_name(struct path *pp, char *pci_name);
> -int sysfs_get_iscsi_ip_address(struct path *pp, char *ip_address);
> +int sysfs_get_host_pci_name(const struct path *pp, char *pci_name);
> +int sysfs_get_iscsi_ip_address(const struct path *pp, char *ip_address);
> +int sysfs_get_host_adapter_name(const struct path *pp,
> +				char *adapter_name);
>  ssize_t sysfs_get_vpd (struct udev_device * udev, int pg, unsigned char * buff,
>  		       size_t len);
>  int sysfs_get_asymmetric_access_state(struct path *pp,
> diff --git a/libmultipath/print.c b/libmultipath/print.c
> index b5c00bfe69a5..594ca567e22a 100644
> --- a/libmultipath/print.c
> +++ b/libmultipath/print.c
> @@ -28,6 +28,7 @@
>  #include "devmapper.h"
>  #include "uevent.h"
>  #include "debug.h"
> +#include "discovery.h"
>  
>  #define MAX(x,y) (x > y) ? x : y
>  #define TAIL     (line + len - 1 - c)
> @@ -97,7 +98,7 @@ snprint_size (char * buff, size_t len, unsigned long long size)
>   * multipath info printing functions
>   */
>  static int
> -snprint_name (char * buff, size_t len, struct multipath * mpp)
> +snprint_name (char * buff, size_t len, const struct multipath * mpp)
>  {
>  	if (mpp->alias)
>  		return snprintf(buff, len, "%s", mpp->alias);
> @@ -106,7 +107,7 @@ snprint_name (char * buff, size_t len, struct multipath * mpp)
>  }
>  
>  static int
> -snprint_sysfs (char * buff, size_t len, struct multipath * mpp)
> +snprint_sysfs (char * buff, size_t len, const struct multipath * mpp)
>  {
>  	if (mpp->dmi)
>  		return snprintf(buff, len, "dm-%i", mpp->dmi->minor);
> @@ -115,7 +116,7 @@ snprint_sysfs (char * buff, size_t len, struct multipath * mpp)
>  }
>  
>  static int
> -snprint_ro (char * buff, size_t len, struct multipath * mpp)
> +snprint_ro (char * buff, size_t len, const struct multipath * mpp)
>  {
>  	if (!mpp->dmi)
>  		return snprintf(buff, len, "undef");
> @@ -154,7 +155,7 @@ out:
>  }
>  
>  static int
> -snprint_failback (char * buff, size_t len, struct multipath * mpp)
> +snprint_failback (char * buff, size_t len, const struct multipath * mpp)
>  {
>  	if (mpp->pgfailback == -FAILBACK_IMMEDIATE)
>  		return snprintf(buff, len, "immediate");
> @@ -169,7 +170,7 @@ snprint_failback (char * buff, size_t len, struct multipath * mpp)
>  }
>  
>  static int
> -snprint_queueing (char * buff, size_t len, struct multipath * mpp)
> +snprint_queueing (char * buff, size_t len, const struct multipath * mpp)
>  {
>  	if (mpp->no_path_retry == NO_PATH_RETRY_FAIL)
>  		return snprintf(buff, len, "off");
> @@ -191,13 +192,13 @@ snprint_queueing (char * buff, size_t len, struct multipath * mpp)
>  }
>  
>  static int
> -snprint_nb_paths (char * buff, size_t len, struct multipath * mpp)
> +snprint_nb_paths (char * buff, size_t len, const struct multipath * mpp)
>  {
>  	return snprint_int(buff, len, mpp->nr_active);
>  }
>  
>  static int
> -snprint_dm_map_state (char * buff, size_t len, struct multipath * mpp)
> +snprint_dm_map_state (char * buff, size_t len, const struct multipath * mpp)
>  {
>  	if (mpp->dmi && mpp->dmi->suspended)
>  		return snprintf(buff, len, "suspend");
> @@ -206,67 +207,67 @@ snprint_dm_map_state (char * buff, size_t len, struct multipath * mpp)
>  }
>  
>  static int
> -snprint_multipath_size (char * buff, size_t len, struct multipath * mpp)
> +snprint_multipath_size (char * buff, size_t len, const struct multipath * mpp)
>  {
>  	return snprint_size(buff, len, mpp->size);
>  }
>  
>  static int
> -snprint_features (char * buff, size_t len, struct multipath * mpp)
> +snprint_features (char * buff, size_t len, const struct multipath * mpp)
>  {
>  	return snprint_str(buff, len, mpp->features);
>  }
>  
>  static int
> -snprint_hwhandler (char * buff, size_t len, struct multipath * mpp)
> +snprint_hwhandler (char * buff, size_t len, const struct multipath * mpp)
>  {
>  	return snprint_str(buff, len, mpp->hwhandler);
>  }
>  
>  static int
> -snprint_path_faults (char * buff, size_t len, struct multipath * mpp)
> +snprint_path_faults (char * buff, size_t len, const struct multipath * mpp)
>  {
>  	return snprint_uint(buff, len, mpp->stat_path_failures);
>  }
>  
>  static int
> -snprint_switch_grp (char * buff, size_t len, struct multipath * mpp)
> +snprint_switch_grp (char * buff, size_t len, const struct multipath * mpp)
>  {
>  	return snprint_uint(buff, len, mpp->stat_switchgroup);
>  }
>  
>  static int
> -snprint_map_loads (char * buff, size_t len, struct multipath * mpp)
> +snprint_map_loads (char * buff, size_t len, const struct multipath * mpp)
>  {
>  	return snprint_uint(buff, len, mpp->stat_map_loads);
>  }
>  
>  static int
> -snprint_total_q_time (char * buff, size_t len, struct multipath * mpp)
> +snprint_total_q_time (char * buff, size_t len, const struct multipath * mpp)
>  {
>  	return snprint_uint(buff, len, mpp->stat_total_queueing_time);
>  }
>  
>  static int
> -snprint_q_timeouts (char * buff, size_t len, struct multipath * mpp)
> +snprint_q_timeouts (char * buff, size_t len, const struct multipath * mpp)
>  {
>  	return snprint_uint(buff, len, mpp->stat_queueing_timeouts);
>  }
>  
>  static int
> -snprint_map_failures (char * buff, size_t len, struct multipath * mpp)
> +snprint_map_failures (char * buff, size_t len, const struct multipath * mpp)
>  {
>  	return snprint_uint(buff, len, mpp->stat_map_failures);
>  }
>  
>  static int
> -snprint_multipath_uuid (char * buff, size_t len, struct multipath * mpp)
> +snprint_multipath_uuid (char * buff, size_t len, const struct multipath * mpp)
>  {
>  	return snprint_str(buff, len, mpp->wwid);
>  }
>  
>  static int
> -snprint_multipath_vpr (char * buff, size_t len, struct multipath * mpp)
> +snprint_multipath_vpr (char * buff, size_t len, const struct multipath * mpp)
>  {
>  	struct pathgroup * pgp;
>  	struct path * pp;
> @@ -286,7 +287,7 @@ snprint_multipath_vpr (char * buff, size_t len, struct multipath * mpp)
>  
>  
>  static int
> -snprint_multipath_vend (char * buff, size_t len, struct multipath * mpp)
> +snprint_multipath_vend (char * buff, size_t len, const struct multipath * mpp)
>  {
>  	struct pathgroup * pgp;
>  	struct path * pp;
> @@ -304,7 +305,7 @@ snprint_multipath_vend (char * buff, size_t len, struct multipath * mpp)
>  }
>  
>  static int
> -snprint_multipath_prod (char * buff, size_t len, struct multipath * mpp)
> +snprint_multipath_prod (char * buff, size_t len, const struct multipath * mpp)
>  {
>  	struct pathgroup * pgp;
>  	struct path * pp;
> @@ -322,7 +323,7 @@ snprint_multipath_prod (char * buff, size_t len, struct multipath * mpp)
>  }
>  
>  static int
> -snprint_multipath_rev (char * buff, size_t len, struct multipath * mpp)
> +snprint_multipath_rev (char * buff, size_t len, const struct multipath * mpp)
>  {
>  	struct pathgroup * pgp;
>  	struct path * pp;
> @@ -340,7 +341,7 @@ snprint_multipath_rev (char * buff, size_t len, struct multipath * mpp)
>  }
>  
>  static int
> -snprint_action (char * buff, size_t len, struct multipath * mpp)
> +snprint_action (char * buff, size_t len, const struct multipath * mpp)
>  {
>  	switch (mpp->action) {
>  	case ACT_REJECT:
> @@ -362,13 +363,13 @@ snprint_action (char * buff, size_t len, struct multipath * mpp)
>   * path info printing functions
>   */
>  static int
> -snprint_path_uuid (char * buff, size_t len, struct path * pp)
> +snprint_path_uuid (char * buff, size_t len, const struct path * pp)
>  {
>  	return snprint_str(buff, len, pp->wwid);
>  }
>  
>  static int
> -snprint_hcil (char * buff, size_t len, struct path * pp)
> +snprint_hcil (char * buff, size_t len, const struct path * pp)
>  {
>  	if (!pp || pp->sg_id.host_no < 0)
>  		return snprintf(buff, len, "#:#:#:#");
> @@ -381,7 +382,7 @@ snprint_hcil (char * buff, size_t len, struct path * pp)
>  }
>  
>  static int
> -snprint_dev (char * buff, size_t len, struct path * pp)
> +snprint_dev (char * buff, size_t len, const struct path * pp)
>  {
>  	if (!pp || !strlen(pp->dev))
>  		return snprintf(buff, len, "-");
> @@ -390,7 +391,7 @@ snprint_dev (char * buff, size_t len, struct path * pp)
>  }
>  
>  static int
> -snprint_dev_t (char * buff, size_t len, struct path * pp)
> +snprint_dev_t (char * buff, size_t len, const struct path * pp)
>  {
>  	if (!pp || !strlen(pp->dev))
>  		return snprintf(buff, len, "#:#");
> @@ -399,7 +400,7 @@ snprint_dev_t (char * buff, size_t len, struct path * pp)
>  }
>  
>  static int
> -snprint_offline (char * buff, size_t len, struct path * pp)
> +snprint_offline (char * buff, size_t len, const struct path * pp)
>  {
>  	if (!pp || !pp->mpp)
>  		return snprintf(buff, len, "unknown");
> @@ -410,7 +411,7 @@ snprint_offline (char * buff, size_t len, struct path * pp)
>  }
>  
>  static int
> -snprint_chk_state (char * buff, size_t len, struct path * pp)
> +snprint_chk_state (char * buff, size_t len, const struct path * pp)
>  {
>  	if (!pp || !pp->mpp)
>  		return snprintf(buff, len, "undef");
> @@ -436,7 +437,7 @@ snprint_chk_state (char * buff, size_t len, struct path * pp)
>  }
>  
>  static int
> -snprint_dm_path_state (char * buff, size_t len, struct path * pp)
> +snprint_dm_path_state (char * buff, size_t len, const struct path * pp)
>  {
>  	if (!pp)
>  		return snprintf(buff, len, "undef");
> @@ -452,14 +453,14 @@ snprint_dm_path_state (char * buff, size_t len, struct path * pp)
>  }
>  
>  static int
> -snprint_vpr (char * buff, size_t len, struct path * pp)
> +snprint_vpr (char * buff, size_t len, const struct path * pp)
>  {
>  	return snprintf(buff, len, "%s,%s",
>  			pp->vendor_id, pp->product_id);
>  }
>  
>  static int
> -snprint_next_check (char * buff, size_t len, struct path * pp)
> +snprint_next_check (char * buff, size_t len, const struct path * pp)
>  {
>  	if (!pp || !pp->mpp)
>  		return snprintf(buff, len, "orphan");
> @@ -468,13 +469,13 @@ snprint_next_check (char * buff, size_t len, struct path * pp)
>  }
>  
>  static int
> -snprint_pri (char * buff, size_t len, struct path * pp)
> +snprint_pri (char * buff, size_t len, const struct path * pp)
>  {
>  	return snprint_int(buff, len, pp ? pp->priority : -1);
>  }
>  
>  static int
> -snprint_pg_selector (char * buff, size_t len, struct pathgroup * pgp)
> +snprint_pg_selector (char * buff, size_t len, const struct pathgroup * pgp)
>  {
>  	const char *s = pgp->mpp->selector;
>  
> @@ -482,13 +483,13 @@ snprint_pg_selector (char * buff, size_t len, struct pathgroup * pgp)
>  }
>  
>  static int
> -snprint_pg_pri (char * buff, size_t len, struct pathgroup * pgp)
> +snprint_pg_pri (char * buff, size_t len, const struct pathgroup * pgp)
>  {
>  	return snprint_int(buff, len, pgp->priority);
>  }
>  
>  static int
> -snprint_pg_state (char * buff, size_t len, struct pathgroup * pgp)
> +snprint_pg_state (char * buff, size_t len, const struct pathgroup * pgp)
>  {
>  	switch (pgp->status) {
>  	case PGSTATE_ENABLED:
> @@ -503,19 +504,19 @@ snprint_pg_state (char * buff, size_t len, struct pathgroup * pgp)
>  }
>  
>  static int
> -snprint_path_size (char * buff, size_t len, struct path * pp)
> +snprint_path_size (char * buff, size_t len, const struct path * pp)
>  {
>  	return snprint_size(buff, len, pp->size);
>  }
>  
>  int
> -snprint_path_serial (char * buff, size_t len, struct path * pp)
> +snprint_path_serial (char * buff, size_t len, const struct path * pp)
>  {
>  	return snprint_str(buff, len, pp->serial);
>  }
>  
>  static int
> -snprint_path_mpp (char * buff, size_t len, struct path * pp)
> +snprint_path_mpp (char * buff, size_t len, const struct path * pp)
>  {
>  	if (!pp->mpp)
>  		return snprintf(buff, len, "[orphan]");
> @@ -525,7 +526,7 @@ snprint_path_mpp (char * buff, size_t len, struct path * pp)
>  }
>  
>  static int
> -snprint_host_attr (char * buff, size_t len, struct path * pp, char *attr)
> +snprint_host_attr (char * buff, size_t len, const struct path * pp, char *attr)
>  {
>  	struct udev_device *host_dev = NULL;
>  	char host_id[32];
> @@ -552,19 +553,19 @@ out:
>  }
>  
>  int
> -snprint_host_wwnn (char * buff, size_t len, struct path * pp)
> +snprint_host_wwnn (char * buff, size_t len, const struct path * pp)
>  {
>  	return snprint_host_attr(buff, len, pp, "node_name");
>  }
>  
>  int
> -snprint_host_wwpn (char * buff, size_t len, struct path * pp)
> +snprint_host_wwpn (char * buff, size_t len, const struct path * pp)
>  {
>  	return snprint_host_attr(buff, len, pp, "port_name");
>  }
>  
>  int
> -snprint_tgt_wwpn (char * buff, size_t len, struct path * pp)
> +snprint_tgt_wwpn (char * buff, size_t len, const struct path * pp)
>  {
>  	struct udev_device *rport_dev = NULL;
>  	char rport_id[32];
> @@ -594,7 +595,7 @@ out:
>  
>  
>  int
> -snprint_tgt_wwnn (char * buff, size_t len, struct path * pp)
> +snprint_tgt_wwnn (char * buff, size_t len, const struct path * pp)
>  {
>  	if (pp->tgt_node_name[0] == '\0')
>  		return snprintf(buff, len, "[undef]");
> @@ -602,7 +603,7 @@ snprint_tgt_wwnn (char * buff, size_t len, struct path * pp)
>  }
>  
>  static int
> -snprint_host_adapter (char * buff, size_t len, struct path * pp)
> +snprint_host_adapter (char * buff, size_t len, const struct path * pp)
>  {
>  	char adapter[SLOT_NAME_SIZE];
>  
> @@ -612,9 +613,9 @@ snprint_host_adapter (char * buff, size_t len, struct path * pp)
>  }
>  
>  static int
> -snprint_path_checker (char * buff, size_t len, struct path * pp)
> +snprint_path_checker (char * buff, size_t len, const struct path * pp)
>  {
> -	struct checker * c = &pp->checker;
> +	const struct checker * c = &pp->checker;
>  	return snprint_str(buff, len, c->name);
>  }
>  
> @@ -780,11 +781,11 @@ pgd_lookup(char wildcard)
>  }
>  
>  int
> -snprint_multipath_header (char * line, int len, char * format)
> +snprint_multipath_header (char * line, int len, const char * format)
>  {
>  	char * c = line;   /* line cursor */
>  	char * s = line;   /* for padding */
> -	char * f = format; /* format string cursor */
> +	const char * f = format; /* format string cursor */
>  	int fwd;
>  	struct multipath_data * data;
>  
> @@ -811,12 +812,12 @@ snprint_multipath_header (char * line, int len, char * format)
>  }
>  
>  int
> -snprint_multipath (char * line, int len, char * format,
> -	     struct multipath * mpp, int pad)
> +snprint_multipath (char * line, int len, const char * format,
> +	     const struct multipath * mpp, int pad)
>  {
>  	char * c = line;   /* line cursor */
>  	char * s = line;   /* for padding */
> -	char * f = format; /* format string cursor */
> +	const char * f = format; /* format string cursor */
>  	int fwd;
>  	struct multipath_data * data;
>  	char buff[MAX_FIELD_LEN] = {};
> @@ -847,11 +848,11 @@ snprint_multipath (char * line, int len, char * format,
>  }
>  
>  int
> -snprint_path_header (char * line, int len, char * format)
> +snprint_path_header (char * line, int len, const char * format)
>  {
>  	char * c = line;   /* line cursor */
>  	char * s = line;   /* for padding */
> -	char * f = format; /* format string cursor */
> +	const char * f = format; /* format string cursor */
>  	int fwd;
>  	struct path_data * data;
>  
> @@ -878,12 +879,12 @@ snprint_path_header (char * line, int len, char * format)
>  }
>  
>  int
> -snprint_path (char * line, int len, char * format,
> -	     struct path * pp, int pad)
> +snprint_path (char * line, int len, const char * format,
> +	     const struct path * pp, int pad)
>  {
>  	char * c = line;   /* line cursor */
>  	char * s = line;   /* for padding */
> -	char * f = format; /* format string cursor */
> +	const char * f = format; /* format string cursor */
>  	int fwd;
>  	struct path_data * data;
>  	char buff[MAX_FIELD_LEN];
> @@ -914,7 +915,7 @@ snprint_path (char * line, int len, char * format,
>  
>  int
>  snprint_pathgroup (char * line, int len, char * format,
> -		   struct pathgroup * pgp)
> +		   const struct pathgroup * pgp)
>  {
>  	char * c = line;   /* line cursor */
>  	char * s = line;   /* for padding */
> @@ -976,7 +977,7 @@ void print_multipath_topology(struct multipath *mpp, int verbosity)
>  	FREE(buff);
>  }
>  
> -int snprint_multipath_topology(char *buff, int len, struct multipath *mpp,
> +int snprint_multipath_topology(char *buff, int len, const struct multipath *mpp,
>  			       int verbosity)
>  {
>  	int j, i, fwd = 0;
> @@ -1100,7 +1101,7 @@ snprint_json_elem_footer (char * buff, int len, int indent, int last)
>  
>  static int
>  snprint_multipath_fields_json (char * buff, int len,
> -		struct multipath * mpp, int last)
> +		const struct multipath * mpp, int last)
>  {
>  	int i, j, fwd = 0;
>  	struct path *pp;
> @@ -1158,7 +1159,7 @@ snprint_multipath_fields_json (char * buff, int len,
>  
>  int
>  snprint_multipath_map_json (char * buff, int len,
> -		struct multipath * mpp, int last){
> +		const struct multipath * mpp, int last){
>  	int fwd = 0;
>  
>  	fwd +=  snprint_json_header(buff, len);
> @@ -1184,7 +1185,7 @@ snprint_multipath_map_json (char * buff, int len,
>  }
>  
>  int
> -snprint_multipath_topology_json (char * buff, int len, struct vectors * vecs)
> +snprint_multipath_topology_json (char * buff, int len, const struct vectors * vecs)
>  {
>  	int i, fwd = 0;
>  	struct multipath * mpp;
> @@ -1215,7 +1216,7 @@ snprint_multipath_topology_json (char * buff, int len, struct vectors * vecs)
>  }
>  
>  static int
> -snprint_hwentry (struct config *conf, char * buff, int len, struct hwentry * hwe)
> +snprint_hwentry (struct config *conf, char * buff, int len, const struct hwentry * hwe)
>  {
>  	int i;
>  	int fwd = 0;
> @@ -1273,7 +1274,7 @@ int snprint_hwtable(struct config *conf, char *buff, int len, vector hwtable)
>  }
>  
>  static int
> -snprint_mpentry (struct config *conf, char * buff, int len, struct mpentry * mpe)
> +snprint_mpentry (struct config *conf, char * buff, int len, const struct mpentry * mpe)
>  {
>  	int i;
>  	int fwd = 0;
> @@ -1325,7 +1326,7 @@ int snprint_mptable(struct config *conf, char *buff, int len, vector mptable)
>  }
>  
>  int snprint_overrides(struct config *conf, char * buff, int len,
> -		      struct hwentry *overrides)
> +		      const struct hwentry *overrides)
>  {
>  	int fwd = 0;
>  	int i;
> @@ -1649,7 +1650,7 @@ int snprint_blacklist_except(struct config *conf, char *buff, int len)
>  	return fwd;
>  }
>  
> -int snprint_status(char *buff, int len, struct vectors *vecs)
> +int snprint_status(char *buff, int len, const struct vectors *vecs)
>  {
>  	int fwd = 0;
>  	int i;
> @@ -1681,7 +1682,7 @@ int snprint_status(char *buff, int len, struct vectors *vecs)
>  }
>  
>  int snprint_devices(struct config *conf, char * buff, int len,
> -		    struct vectors *vecs)
> +		    const struct vectors *vecs)
>  {
>  	DIR *blkdir;
>  	struct dirent *blkdev;
> diff --git a/libmultipath/print.h b/libmultipath/print.h
> index 734f43fd4cb6..02c5b072cc2b 100644
> --- a/libmultipath/print.h
> +++ b/libmultipath/print.h
> @@ -73,50 +73,51 @@ struct path_data {
>  	char wildcard;
>  	char * header;
>  	int width;
> -	int (*snprint)(char * buff, size_t len, struct path * pp);
> +	int (*snprint)(char * buff, size_t len, const struct path * pp);
>  };
>  
>  struct multipath_data {
>  	char wildcard;
>  	char * header;
>  	int width;
> -	int (*snprint)(char * buff, size_t len, struct multipath * mpp);
> +	int (*snprint)(char * buff, size_t len, const struct multipath * mpp);
>  };
>  
>  struct pathgroup_data {
>  	char wildcard;
>  	char * header;
>  	int width;
> -	int (*snprint)(char * buff, size_t len, struct pathgroup * pgp);
> +	int (*snprint)(char * buff, size_t len, const struct pathgroup * pgp);
>  };
>  
>  void get_path_layout (vector pathvec, int header);
>  void get_multipath_layout (vector mpvec, int header);
> -int snprint_path_header (char *, int, char *);
> -int snprint_multipath_header (char *, int, char *);
> -int snprint_path (char *, int, char *, struct path *, int);
> -int snprint_multipath (char *, int, char *, struct multipath *, int);
> -int snprint_multipath_topology (char *, int, struct multipath * mpp,
> +int snprint_path_header (char *, int, const char *);
> +int snprint_multipath_header (char *, int, const char *);
> +int snprint_path (char *, int, const char *, const struct path *, int);
> +int snprint_multipath (char *, int, const char *,
> +		       const struct multipath *, int);
> +int snprint_multipath_topology (char *, int, const struct multipath * mpp,
>  				int verbosity);
>  int snprint_multipath_topology_json (char * buff, int len,
> -				struct vectors * vecs);
> +				const struct vectors * vecs);
>  int snprint_multipath_map_json (char * buff, int len,
> -				struct multipath * mpp, int last);
> +				const struct multipath * mpp, int last);
>  int snprint_defaults (struct config *, char *, int);
>  int snprint_blacklist (struct config *, char *, int);
>  int snprint_blacklist_except (struct config *, char *, int);
>  int snprint_blacklist_report (struct config *, char *, int);
>  int snprint_wildcards (char *, int);
> -int snprint_status (char *, int, struct vectors *);
> -int snprint_devices (struct config *, char *, int, struct vectors *);
> -int snprint_hwtable (struct config *, char *, int, vector);
> -int snprint_mptable (struct config *, char *, int, vector);
> -int snprint_overrides (struct config *, char *, int, struct hwentry *);
> -int snprint_path_serial (char *, size_t, struct path *);
> -int snprint_host_wwnn (char *, size_t, struct path *);
> -int snprint_host_wwpn (char *, size_t, struct path *);
> -int snprint_tgt_wwnn (char *, size_t, struct path *);
> -int snprint_tgt_wwpn (char *, size_t, struct path *);
> +int snprint_status (char *, int, const struct vectors *);
> +int snprint_devices (struct config *, char *, int, const struct vectors *);
> +int snprint_hwtable (struct config *, char *, int, const vector);
> +int snprint_mptable (struct config *, char *, int, const vector);
> +int snprint_overrides (struct config *, char *, int, const struct hwentry *);
> +int snprint_path_serial (char *, size_t, const struct path *);
> +int snprint_host_wwnn (char *, size_t, const struct path *);
> +int snprint_host_wwpn (char *, size_t, const struct path *);
> +int snprint_tgt_wwnn (char *, size_t, const struct path *);
> +int snprint_tgt_wwpn (char *, size_t, const struct path *);
>  
>  void print_multipath_topology (struct multipath * mpp, int verbosity);
>  void print_all_paths (vector pathvec, int banner);
> -- 
> 2.16.1
