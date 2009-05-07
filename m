From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: [PATCH 1 of 1] Updated cluster log patch
Date: Thu, 7 May 2009 14:36:26 -0500
Message-ID: <C5FAA834-F408-4F88-90EA-04A8AC3C1EB3@redhat.com>
References: <1238683235.24108.5.camel@hydrogen.msp.redhat.com>
	<20090407005253.GG5688@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090407005253.GG5688@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

I will repost a patch with the necessary changes shortly.  I will try  
to answer your concerns in this e-mail.

  brassow

On Apr 6, 2009, at 7:52 PM, Alasdair G Kergon wrote:

> On Thu, Apr 02, 2009 at 09:40:35AM -0500, Jon Brassow wrote:
>> There is a kernel component (provided in this patch) and a
>> user space component.  The kernel component implements the
>> logging interface and passes all requests to userspace via
>> 'connector' (a netlink wrapper).  The userspace daemon is
>> built upon OpenAIS for cluster communication and is fault
>> tolerant.
>
>> +config DM_LOG_CLUSTERED
>> +	tristate "Mirror cluster logging (EXPERIMENTAL)"
>> +	depends on DM_MIRROR && EXPERIMENTAL
>> +	select CONNECTOR
>
> How does that interact with dependencies that CONNECTOR itself has?
> Does it always behave correctly and sensibly?
> Would another 'depends on' be better?

If I use 'depends on', then the option to select the cluster log will  
not show up if CONNECTOR is not selected.  This is bad IMO.  Other  
build targets use 'select' in similar fashion.  See especially drivers/ 
staging/pohmelfs/Kconfig and drivers/staging/dst/Kconfig.

>> +	  Cluster logging allows device-mapper mirroring to be
>> +	  cluster-aware.  Mirror devices can be used by multiple
>> +	  machines at the same time.  Note: this will not make
>> +	  your applications cluster-aware.
>
> Can we explain the jargon a bit more, particularly the first sentence?
> And the second sentence is missing qualification.
> Look at the style of other entries.
> What about dependencies etc.?

I've taken a shot at reworking this wording.

>> +dm-log-clustered-objs := dm-log-cluster.o dm-log-cluster-transfer.o
>
> I've fixed that up to work with the latest kernels.

It is likely fixed in my upcoming repost too.

>> ===================================================================
>> --- linux-2.6.orig/include/linux/connector.h
>> +++ linux-2.6/include/linux/connector.h
>> @@ -39,8 +39,10 @@
>> #define CN_IDX_V86D			0x4
>> #define CN_VAL_V86D_UVESAFB		0x1
>> #define CN_IDX_BB			0x5	/* BlackBoard, from the TSP GPL sampling  
>> framework */
>> +#define CN_IDX_DM			0x6     /* Device Mapper */
>> +#define CN_VAL_DM_CLUSTER_LOG		0x1
>>
>> -#define CN_NETLINK_USERS		6
>> +#define CN_NETLINK_USERS		7
>
> Has this been copied to the maintainer of that file and acked?
> Please cc that maintainer on future posts unless the maintainer says  
> it's
> OK not to.

I will copy the maintainer on my upcoming repost.

>> +++ linux-2.6/include/linux/dm-log-cluster.h
>
>> + * This file is released under the LGPL.
>
> Is this header meant for userspace use too?
> If so, the Kbuild file is missing from this patch.

Added.

>> +#define DM_CLOG_IS_REMOTE_RECOVERING  17
>
>> +#define REQUEST_TYPES {	\
>
>> +	"DM_CLOG_IS_REMOTE_RECOVERING" \
>> +}
>
> I think there should be some sort of versioning in this file to make
> it easier to modify that list in future.

I've pulled out the unnecessary REQUEST_TYPE macro and added a 'mask'  
to get at the request_type value - this leaves future compatibility.

>> +struct clog_tfr {
>> +	uint64_t private[2];
>
> What for? Comment missing.

This field has been pulled along with the 'originator' field, which  
was only ever used in user-space.

>> +	char uuid[DM_UUID_LEN]; /* Ties a request to a specific mirror  
>> log */
>> +
>> +	int error;              /* Used by server to inform of errors */
>
> If this struct is meant to be passed between userspace and kernel
> it would be a good idea to use unambiguous alignment: add some
> padding after the char[] and only used fields with a universally- 
> defined width
> so avoid 'int'.
> (And presumably userspace deals with endianness issues?)

Padding has been add and I've changed the 'int' to 'int32_t'.

>> +static struct cn_msg *prealloced_cn_msg;
>> +static struct clog_tfr *prealloced_clog_tfr;
>> +static struct cb_id cn_clog_id = { CN_IDX_DM,  
>> CN_VAL_DM_CLUSTER_LOG };
>> +static DEFINE_MUTEX(_lock);
>> +struct receiving_pkg {
>> +static DEFINE_SPINLOCK(receiving_list_lock);
>> +static struct list_head receiving_list;
>
> We're trying to use dm_<some_module_identifier> prefixes on more  
> variables and
> structs now.

This is why I have changed the very public 'struct clog_tfr' in  
include/linux/dm-log-cluster.h to 'struct dm_clog_request' in the  
upcoming repost.  I did not change the name of 'struct receiving_pkg'  
because it is very local - used only in dm-log-cluster-transfer.c.

>> +	while (1) {
>> +		set_current_state(TASK_INTERRUPTIBLE);
>> +		schedule_timeout(2*HZ);
>> +		DMWARN("Attempting to contact cluster log server...");
>
> while(1) loops always ring alarm bells...
> Were other approaches ruled out?
> Frequency of attempts?
> Too many log messages? (We do have *_LIMIT).

When communication with the userspace server is absolutely necessary,  
this function (which uses the 'while (1)') is called.  Otherwise,  
another function which can simply return error is called.  Basically,  
the function is waiting for the userspace server to be restarted.  In  
fact, you will never get to this 'while (1)' retry code unless the  
userspace server has vanished.  I think this  is the right approach -  
have any other suggestions?

I also don't think the messages will be too many given that they are  
at least separated by 2 seconds.

>> +*Others have also suggested 'multi-log',
>
> Which is what?

Pulled that out... it should be obvious that other possibilities  
exist.  I don't need to specify nebulous possibilities.

>> +this is the logging method used if logging disk in the "disk"  
>> method dies.
>
> Unconditionally?  (I've forgotton.)

I also rephrased this.

>> +These types operate in the same way as their single machine  
>> counterparts,
>> +but they are cluster-aware.  This is done by forwarding most logging
>
> 'cluster-aware' means what???

... and rephrased that.

>> +located in include/linux/dm-log-cluster.h.  'Connector' is used as  
>> the
>> +interface for kernel/userspace interaction.  In userspace, the  
>> daemons
>
> Definition of interface?
> Perhaps more comments in the .h file?
> Or more details here, or reference other documentation?

I've tried to clean-up the language a bit concerning the use of  
connector and such... not sure if I've quite gotten to what you are  
looking for.

>> +use openAIS/corosync in order to communicate with guaranteed  
>> ordering
>> +and delivery.
>
> Nope.  Kernel documentation ends at the kernel/userspace interface.
> Then this can refer to one specific userspace implementation -  
> available
> from where? - that happens to use openAIS/corosync for its  
> communication.
> But if openAIS/corosysnc is a *requirement* of the kernel/userspace  
> interface
> then I think the interface is wrong and this shouldn't go in yet...
> That interface should be independent of any specific userspace  
> implementation.

Indeed.  I've changed this as well.

I've also been thinking about pulling dm-log-cluster-transfer* into  
the main dm-log-cluster.c file.  What do you think of this?  The  
combined file would be somewhere around 1000 - 1100 lines, which is in  
the size range of other dm files (also consider the large number of  
comments in the file... so not that much code really).

Re-post to follow shortly,
  brassow
