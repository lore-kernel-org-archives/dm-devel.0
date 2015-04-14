From: Thomas Wouters <thomas@kangaroot.net>
Subject: Re: ALUA - rescan device capacity on zero sized block
 devices
Date: Tue, 14 Apr 2015 09:20:31 +0200 (CEST)
Message-ID: <987831457.156812.1428996031503.JavaMail.zimbra@kangaroot.net>
References: <1887682221.152035.1428939145196.JavaMail.zimbra@kangaroot.net>
	<552C008A.9070201@sandisk.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <552C008A.9070201@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

----- On Apr 13, 2015, at 7:44 PM, Bart Van Assche bart.vanassche@sandisk.com wrote:
> On 04/13/15 17:32, Thomas Wouters wrote:
>> We're performing some tests with open-iscsi and multipath on two 3par
>> servers and their peer persistence feature.
>> 3par is a commercial storage solution that uses ALUA to allow failover.
>> We have two connections from each 3par server to a linux server.
>>
>> Every 3par server has two network controllers, so on our linux server we
>> initiate 4 iscsi connections.
>> Multipath detects that two of these connections are active paths (both
>> to the same 3par device, that is active at that point) and two are ghost
>> paths, to the passive 3par device.
>>
>> At this moment we have four block devices, the active paths show the
>> actual device size and the standby paths show the devices as zero sized:
>>
>> # multipath -ll
>> 360002ac000000000000000420001510c dm-3 3PARdata,VV
>> size=100G features='1 queue_if_no_path' hwhandler='1 alua' wp=rw
>> |-+- policy='round-robin 0' prio=130 status=active
>> | |- 48:0:0:123 sdc 8:32 active ready running
>> | `- 50:0:0:123 sdb 8:16 active ready running
>> `-+- policy='round-robin 0' prio=1 status=enabled
>>    |- 49:0:0:123 sdd 8:48 active ghost running
>>    `- 51:0:0:123 sde 8:64 active ghost running
>>
>> # cat /sys/block/sdb/size
>> 209715200
>> # cat /sys/block/sdc/size
>> 209715200
>> # cat /sys/block/sdd/size
>> 0
>> # cat /sys/block/sde/size
>> 0
>>
>> As soon as we perform a switchover on the 3par systems, multipath
>> detects the priority changes and switches paths but the new active paths
>> fail.
>> We believe this is because 3par doesn't allow us to read the capacity of
>> the disk on a standby path - and we have proof of this in the logs:
>>
>> Apr 13 15:05:12 deb-3par-test kernel: [   40.079736] sd 5:0:0:0: [sdc]
>> READ CAPACITY failed
>>
>> Unfortunately, once we perform the switchover on 3par, the capacity of
>> those old ghost paths, now active paths, is not re-read.  The multipath
>> device is therefore reduced to a size of 0 and the filesystem becomes
>> unavailable.
>>
>> If we only login on the two active paths without starting multipath,
>> perform a switchover, then login on the two new active paths and start
>> multipath, we have four block devices with a non-zero size and we can
>> perform switchovers at will without any issues.
>>
>> We've found some older discussions describing these issues on the scsi
>> target-devel and dm-devel mailinglists:
>> - http://permalink.gmane.org/gmane.linux.scsi.target.devel/6531
>> - https://www.redhat.com/archives/dm-devel/2014-July/msg00156.html
>>
>> As far as we can conclude after reading these messages, it is correct
>> behavior for disallowing READ CAPACITY on ghost paths.  However, once
>> the path becomes active, we do need a reread of the capacity in order
>> for the path to be functional...
>>
>> We've created a workaround for our issue but we're not sure we're going
>> in the right direction.
>>
>> diff --git a/multipathd/main.c b/multipathd/main.c
>> index f876258..ff32681 100644
>> --- a/multipathd/main.c
>> +++ b/multipathd/main.c
>> @@ -1235,6 +1235,11 @@ check_path (struct vectors * vecs, struct path * pp)
>>
>> pp->chkrstate = newstate;
>> if (newstate != pp->state) {
>> +
>> + if (newstate == PATH_UP && pp->size != pp->mpp->size ) {
>> + sysfs_attr_set_value(pp->udev, "device/rescan", "1\n",2);
>> + }
>> +
>> int oldstate = pp->state;
>> pp->state = newstate;
> 
> Hello Thomas,
> 
> The above patch will trigger a rescan after every failover and failback.
> I'm afraid that will slow down failover and failback, especially if the
> number of LUNs is large. I would appreciate it if the capacity would be
> reexamined only if it is not yet known.
> 
> Thanks,
> 
> Bart.

Hi Bart,

I realize this is not the best way to handle the situation.
This patch was never meant to be implemented as is but more of a clarification of how we look at the issue.

If we resize a lun on the storage servers, the new size can't be read on standby paths.
This means that if a failover occurs for any reason we could end up with a corrupt block device?

Is there a better way to rescan the capacity? Using sysfs_attr_set_value() like this doesn't look clean to me.

Would it make sense to make this a configurable setting which is used for systems that don't allow READ CAPACITY on standby paths?

Thomas
