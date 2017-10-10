From: Guan Junxiong <guanjunxiong@huawei.com>
Subject: Re: [PATCH V2 0/4]multipath-tools: some fixup and
 enhancement for path-latency
Date: Tue, 10 Oct 2017 21:28:57 +0800
Message-ID: <61c4c75b-dcd1-1b0b-1437-47b81e69de09@huawei.com>
References: <1506000199-9644-1-git-send-email-guanjunxiong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1506000199-9644-1-git-send-email-guanjunxiong@huawei.com>
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
To: christophe.varoqui@opensvc.com, dm-devel@redhat.com, hare@suse.de
Cc: chengjike.cheng@huawei.com, xose.vazquez@gmail.com, Yang Feng <philip.yang@huawei.com>, shenhong09@huawei.com, niuhaoxin@huawei.com, mwilck@suse.com
List-Id: dm-devel.ids

Hi Christophe,

Please consider this series of patches.

>
> This series of patches help to make IO processing more common for
> path-latency prioritizer, make the multipath.conf more user-friendly
> and fixup the error of calculation on log scale standard deviation.
>

Thanks very much.

Regards
Guan

On 2017/9/21 21:23, Guan Junxiong wrote:
> Hi Christophe,
> 
> Please consider this series of patches.
> 
> This series of patches help to make IO processing more common for
> path-latency prioritizer, make the multipath.conf more user-friendly
> and fixup the error of calculation on log scale standard deviation.  
> 
> First, the SCSI-to-NVMe translations which was blamed broken has been removed
> since linux kernel 4.13, so that SG_IO IOCTL used in the reading is not
> supported. Instead, PATCH 1/4 drops sg_read method and uses direct IO
> reading both for NVMe device and SCSI device.
> 
> Second, the original prio_args for prioritizer is like this: 20|10 which
> is somewhat unconvenient for user. PATCH 3/4 drops it and use a syntax that
> similar to other prioritizers, for example :
> "base_num=5 io_num=10".
> 
> PATCH 2/4 can be an independent patch.
> 
> Third, Martin has pointed that standard deviation in the path-latency prioritizer
> is wrong. We have solved this and here come the PATCH 4/4.  
> 
> 
> Thanks
> Guan Junxiong
> 
> 
> Changes from V1:
> * add PATCH 4/4 
> * rebase on the 0.7.3 tag
> 
> Junxiong Guan (3):
>   multipath-tools: use direct IO for path latency prioritizer
>   multipath-tools: move get_next_string to util
>   multipath-tools: use user-friendly prio_args for path-latency
> 
>  libmultipath/prioritizers/path_latency.c | 156 +++++++++++++++++++++++--------
>  libmultipath/prioritizers/weightedpath.c |  10 +-
>  libmultipath/util.c                      |   9 ++
>  libmultipath/util.h                      |   1 +
>  multipath/multipath.conf.5               |   2 +-
>  5 files changed, 127 insertions(+), 51 deletions(-)
> 
> Guan Junxiong (4):
>   multipath-tools: use direct IO for path latency prioritizer
>   multipath-tools: move get_next_string to util
>   multipath-tools: use user-friendly prio_args for path-latency
>   multipath-tools: calculate standard deviation on a logarithmic scale
>     for prioritizer path_latency
> 
>  libmultipath/prioritizers/path_latency.c | 321 ++++++++++++++++++++-----------
>  libmultipath/prioritizers/weightedpath.c |  10 +-
>  libmultipath/util.c                      |   9 +
>  libmultipath/util.h                      |   1 +
>  multipath/multipath.conf.5               |   2 +-
>  5 files changed, 217 insertions(+), 126 deletions(-)
> 
