From: Yang Feng <philip.yang@huawei.com>
Subject: Re: [PATCH]prioritizers/path_latency: Fix failure of
 sg_read to a nvme device
Date: Fri, 14 Jul 2017 09:41:04 +0800
Message-ID: <49d1e3be-f68b-d015-fcce-420098fe304f@huawei.com>
References: <1498624934-4740-1-git-send-email-philip.yang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1498624934-4740-1-git-send-email-philip.yang@huawei.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: guanjunxiong@huawei.com, hege09@huawei.com, shenhong09@huawei.com
List-Id: dm-devel.ids

Closed and traced by another patch.
-Yang

On 2017/6/28 12:42, Yang Feng wrote:
> Fixed failure of sg_read to a nvme device:
> 1. Send sg_read command to a nvme device failed,
> because the block size in user-mode is 4096 bytes,
> not equal to the bolck size in kernel-mode, who is
> 512 bytes. According to the func nvme_trans_io of
> scsi.c in the dir "drivers/nvme/host". The code
> fragmentS as follows:
> /* If block count and actual data buffer size dont match, error out */
> if (xfer_bytes != (cdb_info.xfer_len << ns->lba_shift)) {
>     res = -EINVAL;
>     goto out;
> }
> 2. And the SCSI-to-NVMe translations will be removed in
> the patch "nvme: Remove SCSI translations" in the linux-nvme,
> so using the nvme_read command is a good idea.
> 
> Signed-off-by: Yang Feng <philip.yang@huawei.com>
> ---
>  libmultipath/prioritizers/path_latency.c | 78 +++++++++++++++++++++++++++-----
>  1 file changed, 66 insertions(+), 12 deletions(-)
> 
> diff --git a/libmultipath/prioritizers/path_latency.c b/libmultipath/prioritizers/path_latency.c
> index 34b734b..8f633e0 100644
> --- a/libmultipath/prioritizers/path_latency.c
> +++ b/libmultipath/prioritizers/path_latency.c
> @@ -23,14 +23,32 @@
>  #include <math.h>
>  #include <ctype.h>
>  #include <time.h>
> -
>  #include "debug.h"
>  #include "prio.h"
>  #include "structs.h"
> +#include <linux/types.h>
> +#include <sys/ioctl.h>
>  #include "../checkers/libsg.h"
>  
>  #define pp_pl_log(prio, fmt, args...) condlog(prio, "path_latency prio: " fmt, ##args)
>  
> +struct nvme_user_io {
> +    __u8 opcode;
> +    __u8 flags;
> +    __u16 control;
> +    __u16 nblocks;
> +    __u16 rsvd;
> +    __u64 metadata;
> +    __u64 addr;
> +    __u64 slba;
> +    __u32 dsmgmt;
> +    __u32 reftag;
> +    __u16 apptag;
> +    __u16 appmask;
> +};
> +
> +#define NVME_IOCTL_SUBMIT_IO _IOW('N', 0x42, struct nvme_user_io)
> +
>  #define MAX_IO_NUM              200
>  #define MIN_IO_NUM              2
>  
> @@ -51,19 +69,55 @@ static long long path_latency[MAX_IO_NUM];
>  
>  static inline long long timeval_to_us(const struct timespec *tv)
>  {
> -	return ((long long) tv->tv_sec * USEC_PER_SEC) + (tv->tv_nsec / NSEC_PER_USEC);
> +    return ((long long) tv->tv_sec * USEC_PER_SEC) + (tv->tv_nsec / NSEC_PER_USEC);
> +}
> +
> +int nvme_io(int fd, __u8 opcode, __u64 slba, __u16 nblocks, __u16 control,
> +            __u32 dsmgmt, __u32 reftag, __u16 apptag, __u16 appmask, void *data, void *metadata)
> +{
> +    struct nvme_user_io io = {
> +    .opcode = opcode,
> +    .flags = 0,
> +    .control = control,
> +    .nblocks = nblocks,
> +    .rsvd = 0,
> +    .metadata = (__u64)(uintptr_t) metadata,
> +    .addr = (__u64)(uintptr_t) data,
> +    .slba = slba,
> +    .dsmgmt = dsmgmt,
> +    .reftag = reftag,
> +    .appmask = apptag,
> +    .apptag = appmask,
> +    };
> +
> +    return ioctl(fd, NVME_IOCTL_SUBMIT_IO, &io);
> +}
> +
> +int nvme_read(int fd, __u64 slba, __u16 nblocks, __u16 control, __u32 dsmgmt,
> +            __u32 reftag, __u16 apptag, __u16 appmask, void *data, void *metadata)
> +{
> +    return nvme_io(fd, 0x2, slba, nblocks, control, dsmgmt,
> +        reftag, apptag, appmask, data, metadata);
>  }
>  
> -static int do_readsector0(int fd, unsigned int timeout)
> +static int do_readsector0(struct path *pp, unsigned int timeout)
>  {
> -	unsigned char buf[4096];
> -	unsigned char sbuf[SENSE_BUFF_LEN];
> -	int ret;
> +    unsigned char buf[4096];
> +    unsigned char mbuf[512];
> +    unsigned char sbuf[SENSE_BUFF_LEN];
>  
> -	ret = sg_read(fd, &buf[0], 4096, &sbuf[0],
> -		      SENSE_BUFF_LEN, timeout);
> +    if (!strncmp(pp->dev, "nvme", 4))
> +    {
> +        if (nvme_read(pp->fd, 0, 1, 0, 0, 0, 0, 0, buf, mbuf) < 0)
> +            return 0;
> +    }
> +    else
> +    {
> +        if (sg_read(pp->fd, &buf[0], 4096, &sbuf[0],SENSE_BUFF_LEN, timeout) == 2)
> +            return 0;
> +    }
>  
> -	return ret;
> +    return 1;
>  }
>  
>  int check_args_valid(int io_num, int base_num)
> @@ -218,9 +272,9 @@ int getprio (struct path *pp, char *args, unsigned int timeout)
>          (void)clock_gettime(CLOCK_MONOTONIC, &tv);
>          before = timeval_to_us(&tv);
>  
> -        if (do_readsector0(pp->fd, timeout) == 2)
> +        if (do_readsector0(pp, timeout) == 0)
>          {
> -            pp_pl_log(0, "%s: path down", pp->dev);
> +            pp_pl_log(0, "%s: send read sector0 command fail", pp->dev);
>              return -1;
>          }
>  
> @@ -246,7 +300,7 @@ int getprio (struct path *pp, char *args, unsigned int timeout)
>      Warn the user if latency_interval is smaller than (2 * standard_deviation), or equal */
>      standard_deviation = calc_standard_deviation(path_latency, index, avglatency);
>      latency_interval = calc_latency_interval(avglatency, MAX_AVG_LATENCY, MIN_AVG_LATENCY, base_num);
> -    if ((latency_interval!= 0)
> +    if ((latency_interval != 0)
>          && (latency_interval <= (2 * standard_deviation)))
>          pp_pl_log(3, "%s: latency interval (%lld) according to average latency (%lld us) is smaller than "
>              "2 * standard deviation (%lld us), or equal, args base_num (%d) needs to be set bigger value",
> 
