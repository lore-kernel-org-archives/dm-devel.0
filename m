From: Chongyun Wu <wu.chongyun@h3c.com>
Subject: Re: [PATCH] multipathd: check and cleanup zombie paths
Date: Wed, 21 Mar 2018 01:17:03 +0000
Message-ID: <CEB9978CF3252343BE3C67AC9F0086A34295E214@H3CMLB14-EX.srv.huawei-3com.com>
References: <CEB9978CF3252343BE3C67AC9F0086A34295C462@H3CMLB14-EX.srv.huawei-3com.com>
	<1520325779.4131.4.camel@suse.com>
	<CEB9978CF3252343BE3C67AC9F0086A34295C9D0@H3CMLB14-EX.srv.huawei-3com.com>
	<1520349519.4131.20.camel@suse.com>
	<CEB9978CF3252343BE3C67AC9F0086A34295CA7D@H3CMLB14-EX.srv.huawei-3com.com>
	<1520426679.11340.5.camel@suse.com>
	<CEB9978CF3252343BE3C67AC9F0086A34295CF62@H3CMLB14-EX.srv.huawei-3com.com>
	<20180308154435.GB14513@octiron.msp.redhat.com>
	<CEB9978CF3252343BE3C67AC9F0086A34295D215@H3CMLB14-EX.srv.huawei-3com.com>
	<20180309162243.GE14513@octiron.msp.redhat.com>
	<1521495726.3798.141.camel@suse.com>
	<CEB9978CF3252343BE3C67AC9F0086A34295DF37@H3CMLB14-EX.srv.huawei-3com.com>
	<1521557887.3156.5.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "bmarzins@redhat.com" <bmarzins@redhat.com>, "mwilck@suse.com" <mwilck@suse.com>
Cc: Guozhonghua <guozhonghua@h3c.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Changlimin <changlimin@h3c.com>, "xose.vazquez@gmail.com" <xose.vazquez@gmail.com>, Changwei Ge <ge.changwei@h3c.com>
List-Id: dm-devel.ids

On 2018/3/20 22:58, Bart Van Assche wrote:
> On Tue, 2018-03-20 at 03:19 +0000, Chongyun Wu wrote:
>> Actually there are two scenario:
>> (1)Export the LUN to a server at the same time using different LUN nubmer.
>> As you mentioned this scenario can be considered a misconfiguration
>> which we might not care about it.
>> (2)Export the LUN to a server not at the same time using different LUN
>> number.
>> This scenario's operation may be right, the customer just want to
>> reassignment the export relations in the storage.
>> But the former export operation leave a residual device in the system
>> which will been adopted by the latter exported device's multipath. Also
>> there are lots of syslog for the former device which actually not
>> exist(at lest customer don't think it exists, the customer want only the
>> new exported device exist)
> 
> Hello Chongyun,
> 
> It is on purpose that the SCSI core does not remove stale SCSI device nodes.
> If you want that these stale SCSI device nodes get removed automatically,
> two possible approaches are (there might be other approaches):
> * Write a new user space daemon that periodically checks for stale devices
>    (e.g. by running grep -aH . /sys/class/scsi_device/*/*/state |
>     grep -v running) and that triggers a SCSI rescan if any stale devices are
>    found.
> * Write a udev rule that listens for SDEV_UA=REPORTED_LUNS_DATA_HAS_CHANGED
>    and that triggers a SCSI rescan if this event is triggered by the kernel.
> 
> Bart.

Hi Bart,

Thank you very much for your advice, I think the two approaches are new 
way for me to clean up stale devices, I will have a try.

Regards,
Chongyun
