From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH 0/3] multipath-tools: use direct IO and
 user-friend arguments for path-latency
Date: Thu, 21 Sep 2017 13:30:23 +0200
Message-ID: <3b7d74d2-136b-dd23-a6a2-93d7918cc86a@gmail.com>
References: <1504619105-14788-1-git-send-email-guanjunxiong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1504619105-14788-1-git-send-email-guanjunxiong@huawei.com>
Content-Language: en-GB
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Guan Junxiong <guanjunxiong@huawei.com>, dm-devel@redhat.com, christophe.varoqui@opensvc.com
Cc: philip.yang@huawei.com, niuhaoxin@huawei.com, shenhong09@huawei.com, chengjike.cheng@huawei.com
List-Id: dm-devel.ids

On 09/05/2017 03:45 PM, Guan Junxiong wrote:
> This series of patches help to make IO processing more common for
> path-latency prioritizer and make it more user-friendly. 

This patch set is missing.

> First, the SCSI-to-NVMe translations which was blamed broken has been removed
> since linux kernel 4.13, so that SG_IO IOCTL used in the reading is not
> supported. Instead, this patch drops sg_read method and uses direct IO
> reading both for NVMe device and SCSI device.
> 
> Second, the original prio_args for prioritizer is like this: 20|10 which
> is somewhat unconvenient for user. Third patch drops it and use a syntax that
> similar to other prioritizers, for example :
> "base_num=5 io_num=10".
> 
> PATCH 2/3 can be an independent patch.
> 
> Those above are the two things being addressed by this series of patches.
> 
> Note:
> Martin has pointed that standard deviation in the path-latency prioritizer
> is wrong. We are solving this but it will take more days to prove the
> correctness and verify this by testing.  
> 
> Thanks
> Guan Junxiong
> 
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
