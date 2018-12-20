From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 15/19] libmultipath: ANA prioritzer: use nvme
 wrapper library
Date: Thu, 20 Dec 2018 16:58:59 -0600
Message-ID: <20181220225859.GG11315@octiron.msp.redhat.com>
References: <20181218231931.10762-1-mwilck@suse.com>
	<20181218231931.10762-16-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20181218231931.10762-16-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, lijie <lijie34@huawei.com>
List-Id: dm-devel.ids

On Wed, Dec 19, 2018 at 12:19:27AM +0100, Martin Wilck wrote:
> Use the previously introduced NVME wrapper library for
> the passthrough commands from the ANA prioritizer. Discard
> code duplicated from nvme-cli from the ana code itself.
> 
> Furthermore, make additional cleanups in the ANA prioritizer:
> 
>  - don't use the same enum for priorities and error codes
>  - use char* arrays for error messages and state names
>  - return -1 prio to libmultipath for all error cases
>  - check if a device is NVMe before trying ioctl

It's not a big deal, but I do wonder what's the point with this.
Presumably the nvme prioritizer was configured for this device. Also,
the first thing we do is get the identify controller data structure via
a NVMe ioctl. This should fail if the device isn't an NVMe device. Doing
this check does give us more informational error messages, but we don't
do this kind of double-checking for the ALUA prioritizer, for instance.

>  - check for overflow in check_ana_state()
>  - get_ana_info(): improve readability with is_anagrpid_const
>  - priorities: PERSISTENT_LOSS state is worse than INACCESSIBLE
>  and CHANGE
> 
> Cc: lijie <lijie34@huawei.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/prioritizers/Makefile |   6 +-
>  libmultipath/prioritizers/ana.c    | 305 ++++++++++-------------------

Is there a reason why this patch doesn't remove ana.h?

Otherwise, this looks good.

-Ben

>  2 files changed, 113 insertions(+), 198 deletions(-)
> 
> diff --git a/libmultipath/prioritizers/Makefile b/libmultipath/prioritizers/Makefile
> index 15afaba3..4d80c20c 100644
> --- a/libmultipath/prioritizers/Makefile
> +++ b/libmultipath/prioritizers/Makefile
> @@ -19,9 +19,13 @@ LIBS = \
>  	libpriordac.so \
>  	libprioweightedpath.so \
>  	libpriopath_latency.so \
> -	libprioana.so \
>  	libpriosysfs.so
>  
> +ifneq ($(call check_file,/usr/include/linux/nvme_ioctl.h),0)
> +	LIBS += libprioana.so
> +	CFLAGS += -I../nvme
> +endif
> +
>  all: $(LIBS)
>  
>  libprioalua.so: alua.o alua_rtpg.o
> diff --git a/libmultipath/prioritizers/ana.c b/libmultipath/prioritizers/ana.c
> index c5aaa5fb..88edb224 100644
> --- a/libmultipath/prioritizers/ana.c
> +++ b/libmultipath/prioritizers/ana.c
> @@ -17,155 +17,91 @@
>  #include <sys/stat.h>
>  #include <sys/types.h>
>  #include <stdbool.h>
> +#include <libudev.h>
>  
>  #include "debug.h"
> +#include "nvme-lib.h"
>  #include "prio.h"
> +#include "util.h"
>  #include "structs.h"
> -#include "ana.h"
>  
>  enum {
> -	ANA_PRIO_OPTIMIZED		= 50,
> -	ANA_PRIO_NONOPTIMIZED		= 10,
> -	ANA_PRIO_INACCESSIBLE		= 5,
> -	ANA_PRIO_PERSISTENT_LOSS	= 1,
> -	ANA_PRIO_CHANGE			= 0,
> -	ANA_PRIO_RESERVED		= 0,
> -	ANA_PRIO_GETCTRL_FAILED		= -1,
> -	ANA_PRIO_NOT_SUPPORTED		= -2,
> -	ANA_PRIO_GETANAS_FAILED		= -3,
> -	ANA_PRIO_GETANALOG_FAILED	= -4,
> -	ANA_PRIO_GETNSID_FAILED		= -5,
> -	ANA_PRIO_GETNS_FAILED		= -6,
> -	ANA_PRIO_NO_MEMORY		= -7,
> -	ANA_PRIO_NO_INFORMATION		= -8,
> +	ANA_ERR_GETCTRL_FAILED		= 1,
> +	ANA_ERR_NOT_NVME,
> +	ANA_ERR_NOT_SUPPORTED,
> +	ANA_ERR_GETANAS_OVERFLOW,
> +	ANA_ERR_GETANAS_NOTFOUND,
> +	ANA_ERR_GETANALOG_FAILED,
> +	ANA_ERR_GETNSID_FAILED,
> +	ANA_ERR_GETNS_FAILED,
> +	ANA_ERR_NO_MEMORY,
> +	ANA_ERR_NO_INFORMATION,
>  };
>  
> -static const char * anas_string[] = {
> +static const char *ana_errmsg[] = {
> +	[ANA_ERR_GETCTRL_FAILED]	= "couldn't get ctrl info",
> +	[ANA_ERR_NOT_NVME]		= "not an NVMe device",
> +	[ANA_ERR_NOT_SUPPORTED]		= "ANA not supported",
> +	[ANA_ERR_GETANAS_OVERFLOW]	= "buffer overflow in ANA log",
> +	[ANA_ERR_GETANAS_NOTFOUND]	= "NSID or ANAGRPID not found",
> +	[ANA_ERR_GETANALOG_FAILED]	= "couldn't get ana log",
> +	[ANA_ERR_GETNSID_FAILED]	= "couldn't get NSID",
> +	[ANA_ERR_GETNS_FAILED]		= "couldn't get namespace info",
> +	[ANA_ERR_NO_MEMORY]		= "out of memory",
> +	[ANA_ERR_NO_INFORMATION]	= "invalid fd",
> +};
> +
> +/* Use the implicit initialization: value 0 is "invalid" */
> +static const int ana_prio [] = {
> +	[NVME_ANA_OPTIMIZED]		= 50,
> +	[NVME_ANA_NONOPTIMIZED]		= 10,
> +	[NVME_ANA_INACCESSIBLE]		=  5,
> +	[NVME_ANA_PERSISTENT_LOSS]	=  1,
> +	[NVME_ANA_CHANGE]		=  5,
> +};
> +
> +static const char *anas_string[] = {
>  	[NVME_ANA_OPTIMIZED]			= "ANA Optimized State",
>  	[NVME_ANA_NONOPTIMIZED]			= "ANA Non-Optimized State",
>  	[NVME_ANA_INACCESSIBLE]			= "ANA Inaccessible State",
>  	[NVME_ANA_PERSISTENT_LOSS]		= "ANA Persistent Loss State",
>  	[NVME_ANA_CHANGE]			= "ANA Change state",
> -	[NVME_ANA_RESERVED]			= "Invalid namespace group state!",
>  };
>  
>  static const char *aas_print_string(int rc)
>  {
>  	rc &= 0xff;
> -
> -	switch(rc) {
> -	case NVME_ANA_OPTIMIZED:
> -	case NVME_ANA_NONOPTIMIZED:
> -	case NVME_ANA_INACCESSIBLE:
> -	case NVME_ANA_PERSISTENT_LOSS:
> -	case NVME_ANA_CHANGE:
> +	if (rc >= 0 && rc < ARRAY_SIZE(anas_string) &&
> +	    anas_string[rc] != NULL)
>  		return anas_string[rc];
> -	default:
> -		return anas_string[NVME_ANA_RESERVED];
> -	}
> -
> -	return anas_string[NVME_ANA_RESERVED];
> -}
> -
> -static int nvme_get_nsid(int fd, unsigned *nsid)
> -{
> -	static struct stat nvme_stat;
> -	int err = fstat(fd, &nvme_stat);
> -	if (err < 0)
> -		return 1;
> -
> -	if (!S_ISBLK(nvme_stat.st_mode)) {
> -		condlog(0, "Error: requesting namespace-id from non-block device\n");
> -		return 1;
> -	}
> -
> -	*nsid = ioctl(fd, NVME_IOCTL_ID);
> -	return 0;
> -}
> -
> -static int nvme_submit_admin_passthru(int fd, struct nvme_passthru_cmd *cmd)
> -{
> -	return ioctl(fd, NVME_IOCTL_ADMIN_CMD, cmd);
> -}
> -
> -int nvme_get_log13(int fd, __u32 nsid, __u8 log_id, __u8 lsp, __u64 lpo,
> -                 __u16 lsi, bool rae, __u32 data_len, void *data)
> -{
> -	struct nvme_admin_cmd cmd = {
> -		.opcode		= nvme_admin_get_log_page,
> -		.nsid		= nsid,
> -		.addr		= (__u64)(uintptr_t) data,
> -		.data_len	= data_len,
> -	};
> -	__u32 numd = (data_len >> 2) - 1;
> -	__u16 numdu = numd >> 16, numdl = numd & 0xffff;
> -
> -	cmd.cdw10 = log_id | (numdl << 16) | (rae ? 1 << 15 : 0);
> -	if (lsp)
> -		cmd.cdw10 |= lsp << 8;
> -
> -	cmd.cdw11 = numdu | (lsi << 16);
> -	cmd.cdw12 = lpo;
> -	cmd.cdw13 = (lpo >> 32);
> -
> -	return nvme_submit_admin_passthru(fd, &cmd);
> -
> -}
> -
> -int nvme_identify13(int fd, __u32 nsid, __u32 cdw10, __u32 cdw11, void *data)
> -{
> -	struct nvme_admin_cmd cmd = {
> -		.opcode		= nvme_admin_identify,
> -		.nsid		= nsid,
> -		.addr		= (__u64)(uintptr_t) data,
> -		.data_len	= NVME_IDENTIFY_DATA_SIZE,
> -		.cdw10		= cdw10,
> -		.cdw11		= cdw11,
> -	};
> -
> -	return nvme_submit_admin_passthru(fd, &cmd);
> -}
> -
> -int nvme_identify(int fd, __u32 nsid, __u32 cdw10, void *data)
> -{
> -	return nvme_identify13(fd, nsid, cdw10, 0, data);
> -}
>  
> -int nvme_identify_ctrl(int fd, void *data)
> -{
> -	return nvme_identify(fd, 0, NVME_ID_CNS_CTRL, data);
> -}
> -
> -int nvme_identify_ns(int fd, __u32 nsid, void *data)
> -{
> -	return nvme_identify(fd, nsid, NVME_ID_CNS_NS, data);
> -}
> -
> -int nvme_ana_log(int fd, void *ana_log, size_t ana_log_len, int rgo)
> -{
> -	__u64 lpo = 0;
> -
> -	return nvme_get_log13(fd, NVME_NSID_ALL, NVME_LOG_ANA, rgo, lpo, 0,
> -			true, ana_log_len, ana_log);
> +	return "invalid ANA state";
>  }
>  
> -static int get_ana_state(__u32 nsid, __u32 anagrpid, void *ana_log)
> +static int get_ana_state(__u32 nsid, __u32 anagrpid, void *ana_log,
> +			 size_t ana_log_len)
>  {
> -	int	rc = ANA_PRIO_GETANAS_FAILED;
>  	void *base = ana_log;
>  	struct nvme_ana_rsp_hdr *hdr = base;
>  	struct nvme_ana_group_desc *ana_desc;
> -	int offset = sizeof(struct nvme_ana_rsp_hdr);
> +	size_t offset = sizeof(struct nvme_ana_rsp_hdr);
>  	__u32 nr_nsids;
>  	size_t nsid_buf_size;
>  	int i, j;
>  
>  	for (i = 0; i < le16_to_cpu(hdr->ngrps); i++) {
>  		ana_desc = base + offset;
> +
> +		offset += sizeof(*ana_desc);
> +		if (offset > ana_log_len)
> +			return -ANA_ERR_GETANAS_OVERFLOW;
> +
>  		nr_nsids = le32_to_cpu(ana_desc->nnsids);
>  		nsid_buf_size = nr_nsids * sizeof(__le32);
>  
> -		offset += sizeof(*ana_desc);
> +		offset += nsid_buf_size;
> +		if (offset > ana_log_len)
> +			return -ANA_ERR_GETANAS_OVERFLOW;
>  
>  		for (j = 0; j < nr_nsids; j++) {
>  			if (nsid == le32_to_cpu(ana_desc->nsids[j]))
> @@ -173,12 +109,10 @@ static int get_ana_state(__u32 nsid, __u32 anagrpid, void *ana_log)
>  		}
>  
>  		if (anagrpid != 0 && anagrpid == le32_to_cpu(ana_desc->grpid))
> -			rc = ana_desc->state;
> +			return ana_desc->state;
>  
> -		offset += nsid_buf_size;
>  	}
> -
> -	return rc;
> +	return -ANA_ERR_GETANAS_NOTFOUND;
>  }
>  
>  int get_ana_info(struct path * pp, unsigned int timeout)
> @@ -189,104 +123,81 @@ int get_ana_info(struct path * pp, unsigned int timeout)
>  	struct nvme_id_ns ns;
>  	void *ana_log;
>  	size_t ana_log_len;
> +	bool is_anagrpid_const;
>  
>  	rc = nvme_identify_ctrl(pp->fd, &ctrl);
> -	if (rc)
> -		return ANA_PRIO_GETCTRL_FAILED;
> +	if (rc < 0) {
> +		log_nvme_errcode(rc, pp->dev, "nvme_identify_ctrl");
> +		return -ANA_ERR_GETCTRL_FAILED;
> +	}
>  
>  	if(!(ctrl.cmic & (1 << 3)))
> -		return ANA_PRIO_NOT_SUPPORTED;
> -
> -	rc = nvme_get_nsid(pp->fd, &nsid);
> -	if (rc)
> -		return ANA_PRIO_GETNSID_FAILED;
> +		return -ANA_ERR_NOT_SUPPORTED;
>  
> -	rc = nvme_identify_ns(pp->fd, nsid, &ns);
> -	if (rc)
> -		return ANA_PRIO_GETNS_FAILED;
> +	nsid = nvme_get_nsid(pp->fd);
> +	if (nsid <= 0) {
> +		log_nvme_errcode(rc, pp->dev, "nvme_get_nsid");
> +		return -ANA_ERR_GETNSID_FAILED;
> +	}
> +	is_anagrpid_const = ctrl.anacap & (1 << 6);
>  
> +	/*
> +	 * Code copied from nvme-cli/nvme.c. We don't need to allocate an
> +	 * [nanagrpid*mnan] array of NSIDs because each NSID can occur at most
> +	 * in one ANA group.
> +	 */
>  	ana_log_len = sizeof(struct nvme_ana_rsp_hdr) +
> -		le32_to_cpu(ctrl.nanagrpid) * sizeof(struct nvme_ana_group_desc);
> -	if (!(ctrl.anacap & (1 << 6)))
> +		le32_to_cpu(ctrl.nanagrpid)
> +		* sizeof(struct nvme_ana_group_desc);
> +
> +	if (is_anagrpid_const) {
> +		rc = nvme_identify_ns(pp->fd, nsid, 0, &ns);
> +		if (rc) {
> +			log_nvme_errcode(rc, pp->dev, "nvme_identify_ns");
> +			return -ANA_ERR_GETNS_FAILED;
> +		}
> +	} else
>  		ana_log_len += le32_to_cpu(ctrl.mnan) * sizeof(__le32);
>  
>  	ana_log = malloc(ana_log_len);
>  	if (!ana_log)
> -		return ANA_PRIO_NO_MEMORY;
> -
> +		return -ANA_ERR_NO_MEMORY;
> +	pthread_cleanup_push(free, ana_log);
>  	rc = nvme_ana_log(pp->fd, ana_log, ana_log_len,
> -		(ctrl.anacap & (1 << 6)) ? NVME_ANA_LOG_RGO : 0);
> +			  is_anagrpid_const ? NVME_ANA_LOG_RGO : 0);
>  	if (rc) {
> -		free(ana_log);
> -		return ANA_PRIO_GETANALOG_FAILED;
> -	}
> -
> -	rc = get_ana_state(nsid, le32_to_cpu(ns.anagrpid), ana_log);
> -	if (rc < 0){
> -		free(ana_log);
> -		return ANA_PRIO_GETANAS_FAILED;
> -	}
> -
> -	free(ana_log);
> -	condlog(3, "%s: ana state = %02x [%s]", pp->dev, rc, aas_print_string(rc));
> -
> +		log_nvme_errcode(rc, pp->dev, "nvme_ana_log");
> +		rc = -ANA_ERR_GETANALOG_FAILED;
> +	} else
> +		rc = get_ana_state(nsid,
> +				   is_anagrpid_const ?
> +				   le32_to_cpu(ns.anagrpid) : 0,
> +				   ana_log, ana_log_len);
> +	pthread_cleanup_pop(1);
> +	if (rc >= 0)
> +		condlog(3, "%s: ana state = %02x [%s]", pp->dev, rc,
> +			aas_print_string(rc));
>  	return rc;
>  }
>  
> -int getprio(struct path * pp, char * args, unsigned int timeout)
> +int getprio(struct path *pp, char *args, unsigned int timeout)
>  {
>  	int rc;
>  
>  	if (pp->fd < 0)
> -		return ANA_PRIO_NO_INFORMATION;
> -
> -	rc = get_ana_info(pp, timeout);
> -	if (rc >= 0) {
> -		rc &= 0x0f;
> -		switch(rc) {
> -		case NVME_ANA_OPTIMIZED:
> -			rc = ANA_PRIO_OPTIMIZED;
> -			break;
> -		case NVME_ANA_NONOPTIMIZED:
> -			rc = ANA_PRIO_NONOPTIMIZED;
> -			break;
> -		case NVME_ANA_INACCESSIBLE:
> -			rc = ANA_PRIO_INACCESSIBLE;
> -			break;
> -		case NVME_ANA_PERSISTENT_LOSS:
> -			rc = ANA_PRIO_PERSISTENT_LOSS;
> -			break;
> -		case NVME_ANA_CHANGE:
> -			rc = ANA_PRIO_CHANGE;
> -			break;
> -		default:
> -			rc = ANA_PRIO_RESERVED;
> -		}
> -	} else {
> -		switch(rc) {
> -		case ANA_PRIO_GETCTRL_FAILED:
> -			condlog(0, "%s: couldn't get ctrl info", pp->dev);
> -			break;
> -		case ANA_PRIO_NOT_SUPPORTED:
> -			condlog(0, "%s: ana not supported", pp->dev);
> -			break;
> -		case ANA_PRIO_GETANAS_FAILED:
> -			condlog(0, "%s: couldn't get ana state", pp->dev);
> -			break;
> -		case ANA_PRIO_GETANALOG_FAILED:
> -			condlog(0, "%s: couldn't get ana log", pp->dev);
> -			break;
> -		case ANA_PRIO_GETNS_FAILED:
> -			condlog(0, "%s: couldn't get namespace", pp->dev);
> -			break;
> -		case ANA_PRIO_GETNSID_FAILED:
> -			condlog(0, "%s: couldn't get namespace id", pp->dev);
> -			break;
> -		case ANA_PRIO_NO_MEMORY:
> -			condlog(0, "%s: couldn't alloc memory", pp->dev);
> -			break;
> -		}
> +		rc = -ANA_ERR_NO_INFORMATION;
> +	else if (udev_device_get_parent_with_subsystem_devtype(pp->udev,
> +							       "nvme", NULL)
> +		 == NULL)
> +		rc = -ANA_ERR_NOT_NVME;
> +	else {
> +		rc = get_ana_info(pp, timeout);
> +		if (rc >= 0 && rc < ARRAY_SIZE(ana_prio) && ana_prio[rc] != 0)
> +			return ana_prio[rc];
>  	}
> -	return rc;
> +	if (rc < 0 && -rc < ARRAY_SIZE(ana_errmsg))
> +		condlog(2, "%s: ANA error: %s", pp->dev, ana_errmsg[-rc]);
> +	else
> +		condlog(1, "%s: invalid ANA rc code %d", pp->dev, rc);
> +	return -1;
>  }
> -
> -- 
> 2.19.2
