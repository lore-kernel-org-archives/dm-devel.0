From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 1 of 1] Updated cluster log patch
Date: Tue, 7 Apr 2009 01:52:54 +0100
Message-ID: <20090407005253.GG5688@agk.fab.redhat.com>
References: <1238683235.24108.5.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1238683235.24108.5.camel@hydrogen.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Apr 02, 2009 at 09:40:35AM -0500, Jon Brassow wrote:
> There is a kernel component (provided in this patch) and a
> user space component.  The kernel component implements the
> logging interface and passes all requests to userspace via
> 'connector' (a netlink wrapper).  The userspace daemon is
> built upon OpenAIS for cluster communication and is fault
> tolerant.
 
> +config DM_LOG_CLUSTERED
> +	tristate "Mirror cluster logging (EXPERIMENTAL)"
> +	depends on DM_MIRROR && EXPERIMENTAL
> +	select CONNECTOR

How does that interact with dependencies that CONNECTOR itself has?
Does it always behave correctly and sensibly?
Would another 'depends on' be better?

> +	  Cluster logging allows device-mapper mirroring to be
> +	  cluster-aware.  Mirror devices can be used by multiple
> +	  machines at the same time.  Note: this will not make
> +	  your applications cluster-aware.

Can we explain the jargon a bit more, particularly the first sentence?
And the second sentence is missing qualification.
Look at the style of other entries.
What about dependencies etc.?

> +dm-log-clustered-objs := dm-log-cluster.o dm-log-cluster-transfer.o

I've fixed that up to work with the latest kernels.

> ===================================================================
> --- linux-2.6.orig/include/linux/connector.h
> +++ linux-2.6/include/linux/connector.h
> @@ -39,8 +39,10 @@
>  #define CN_IDX_V86D			0x4
>  #define CN_VAL_V86D_UVESAFB		0x1
>  #define CN_IDX_BB			0x5	/* BlackBoard, from the TSP GPL sampling framework */
> +#define CN_IDX_DM			0x6     /* Device Mapper */
> +#define CN_VAL_DM_CLUSTER_LOG		0x1
>  
> -#define CN_NETLINK_USERS		6
> +#define CN_NETLINK_USERS		7
  
Has this been copied to the maintainer of that file and acked?
Please cc that maintainer on future posts unless the maintainer says it's
OK not to.

> +++ linux-2.6/include/linux/dm-log-cluster.h

> + * This file is released under the LGPL.

Is this header meant for userspace use too?
If so, the Kbuild file is missing from this patch.

> +#define DM_CLOG_IS_REMOTE_RECOVERING  17

> +#define REQUEST_TYPES {	\

> +	"DM_CLOG_IS_REMOTE_RECOVERING" \
> +}

I think there should be some sort of versioning in this file to make
it easier to modify that list in future.

> +struct clog_tfr {
> +	uint64_t private[2];

What for? Comment missing.

> +	char uuid[DM_UUID_LEN]; /* Ties a request to a specific mirror log */
> +
> +	int error;              /* Used by server to inform of errors */

If this struct is meant to be passed between userspace and kernel 
it would be a good idea to use unambiguous alignment: add some
padding after the char[] and only used fields with a universally-defined width
so avoid 'int'.
(And presumably userspace deals with endianness issues?)

> +static struct cn_msg *prealloced_cn_msg;
> +static struct clog_tfr *prealloced_clog_tfr;
> +static struct cb_id cn_clog_id = { CN_IDX_DM, CN_VAL_DM_CLUSTER_LOG };
> +static DEFINE_MUTEX(_lock);
> +struct receiving_pkg {
> +static DEFINE_SPINLOCK(receiving_list_lock);
> +static struct list_head receiving_list;

We're trying to use dm_<some_module_identifier> prefixes on more variables and
structs now.

> +	while (1) {
> +		set_current_state(TASK_INTERRUPTIBLE);
> +		schedule_timeout(2*HZ);
> +		DMWARN("Attempting to contact cluster log server...");

while(1) loops always ring alarm bells...
Were other approaches ruled out?
Frequency of attempts?
Too many log messages? (We do have *_LIMIT).

> +*Others have also suggested 'multi-log', 

Which is what?

> +this is the logging method used if logging disk in the "disk" method dies.

Unconditionally?  (I've forgotton.)

> +These types operate in the same way as their single machine counterparts,
> +but they are cluster-aware.  This is done by forwarding most logging

'cluster-aware' means what???

> +located in include/linux/dm-log-cluster.h.  'Connector' is used as the
> +interface for kernel/userspace interaction.  In userspace, the daemons

Definition of interface?
Perhaps more comments in the .h file?
Or more details here, or reference other documentation?

> +use openAIS/corosync in order to communicate with guaranteed ordering
> +and delivery.

Nope.  Kernel documentation ends at the kernel/userspace interface.
Then this can refer to one specific userspace implementation - available
from where? - that happens to use openAIS/corosync for its communication.
But if openAIS/corosysnc is a *requirement* of the kernel/userspace interface
then I think the interface is wrong and this shouldn't go in yet...
That interface should be independent of any specific userspace implementation.

Alasdair
-- 
agk@redhat.com
