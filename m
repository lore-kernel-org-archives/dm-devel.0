From: Yang Feng <philip.yang@huawei.com>
Subject: Re: [PATCH v6 1/1] multipath-tools: Prioritizer based on
 a latency algorithm
Date: Thu, 22 Jun 2017 10:05:16 +0800
Message-ID: <959d51bf-513d-e8c0-5e94-fbef0162f814@huawei.com>
References: <1498038034-18276-1-git-send-email-philip.yang@huawei.com>
	<1498038034-18276-2-git-send-email-philip.yang@huawei.com>
	<CABr-Gne-2UNuBnNk-_hi7ao5k9p=ELXwpABVOxmBt4V_JWxi4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABr-Gne-2UNuBnNk-_hi7ao5k9p=ELXwpABVOxmBt4V_JWxi4A@mail.gmail.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, shenhong09@huawei.com, device-mapper development <dm-devel@redhat.com>, hege09@huawei.com, tristan.ye@suse.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Hi Christophe,

OK, thanks a lot.

Regards,
Yang

---
On 2017/6/21 18:22, Christophe Varoqui wrote:
> This version is now merged.
> Thanks.
> 
> Incremental enhancements can go from there if needed.
> 
> On Wed, Jun 21, 2017 at 11:40 AM, Yang Feng <philip.yang@huawei.com <mailto:philip.yang@huawei.com>> wrote:
> 
>     libmultipath/prioritizers: Prioritizer for device mapper multipath,
>     where the corresponding priority values of specific paths are provided
>     by a latency algorithm on the logarithmic scale. And the latency algorithm
>     is dependent on the following arguments(io_num and base_num).
>     The principle of the algorithm is illustrated as follows:
>     1. By sending a certain number "io_num" of read IOs to the current
>     path continuously, the IOs' average latency can be calculated.
>     2. Max average latency value is 100s, and min value is 1us. According
>     to the average latency of each path and the "base_number" of logarithmic
>     scale, the priority "rc" of each path can be provided.
> 
>     For example: If base_num=10, the paths will be grouped in priority groups
>     with path latency <=1us, (1us, 10us], (10us, 100us], (100us, 1ms], (1ms, 10ms],
>     (10ms, 100ms], (100ms, 1s], (1s, 10s], (10s, 100s], >100s. As follows:
> 
>            <=1us            (1us, 10us]      (10us, 100us]               >100s
>     |------------------|------------------|------------------|...|------------------|
>     |  priority rank 9 |  priority rank 8 |  priority rank 7 |...|  priority rank 0 |
>     |------------------|------------------|------------------|...|------------------|
>                                Priority Rank Partitioning
> 
>     Signed-off-by: Yang Feng <philip.yang@huawei.com <mailto:philip.yang@huawei.com>>
>     Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com <mailto:bmarzins@redhat.com>>
>     Reviewed-by: Martin Wilck <mwilck@suse.com <mailto:mwilck@suse.com>>
>     Reviewed-by: Xose Vazquez Perez <xose.vazquez@gmail.com <mailto:xose.vazquez@gmail.com>>
>     Reviewed-by: Hannes Reinecke <hare@suse.de <mailto:hare@suse.de>>
>     ---
>      libmultipath/prio.h                      |   1 +
>      libmultipath/prioritizers/Makefile       |   4 +
>      libmultipath/prioritizers/path_latency.c | 257 +++++++++++++++++++++++++++++++
>      multipath/multipath.conf.5               |  20 +++
>      4 files changed, 282 insertions(+)
>      create mode 100644 libmultipath/prioritizers/path_latency.c
> 
---
