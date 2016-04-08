From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: [PATCH v2 10/18] multipathd: delay reloads during
	creation
Date: Fri, 8 Apr 2016 10:36:07 +0200
Message-ID: <57076D77.6020208@redhat.com>
References: <1460071212-21018-1-git-send-email-bmarzins@redhat.com>
	<1460071212-21018-11-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1460071212-21018-11-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

Dne 8.4.2016 v 01:20 Benjamin Marzinski napsal(a):
> lvm needs PV devices to not be suspended while the udev rules are
> running, for them to be correctly identified as PVs. However, multipathd
> will often be in a situation where it will create a multipath device
> upon seeing a path, and then immediately reload the device upon seeing
> another path.  If multipath is reloading a device while processing the
> udev event from its creation, lvm can fail to identify it as a PV. This
> can cause systems to fail to boot. Unfortunately, using udev
> synchronization cookies to solve this issue would cause a host of other
> issues that could only be avoided by a pretty substantial change in how
> multipathd does locking and event processing.


This is somewhat misunderstanding of the core problem it's not about 'lvm2 
needs to be not suspended'. So let me elaborate here with more details.
(And Peter please fix me in case of mistakes ;)


Lvm2 command has lvm.conf settings allowing a user to select if he wants to 
scan devices that are suspended or not - there is already a 'race' - since 
checking device is not suspended and then opening it has lots of room for the 
race, but it's not a major issue in this case.


The reasons to skip reading suspended devices are primarily to avoid holding 
VG lock for potentially a very long time and also avoiding udev with its 
'built-in' 30sec timeout to kills its worker process blocked in blkid scan
with a danger of marking device as GONE and having further consequences like 
an automated umount by systemd....


Thus lvm2/dm udev rules implemented a (racy) check for skipping a read of 
suspended device and this check may also skip the call of pvscan with the 
generic assumption  RESUME goes afterwards with a CHANGE event and device will 
be properly scanned anyway - so there would be no info lost - only gets into 
udev database later.


However now the multipathd *kills* this assumption - since the current udev 
rules implementation for multipath devices targets only for the initial scan 
and all subsequent RESUMES are supposed to be ignored as it's believed the 
device remained in the same state and only some paths have been added/lost. 
Scanning such a device thus shall not change any remembered info in udev 
database. As 'extra' bonus multipath may SUSPEND devices (and that's somehow 
solved by this patch) right after the initial activation of the device so the 
lvm2 check for skipping of suspended devices may have skipped the whole 
discovery operation and since further RESUMES were meant to be ignore, device 
remained invisible forever.

Now we get to the best technical solution for multipath here with other 
surrounding software (i.e. udev) - before multipath starts to mark RESUMES as 
'ignorable' it should check/validate if udevdb already does contain a valid 
information about the device (i.e. it's been scanned...)  and only in this 
case it would mark this device to be ignored.

This may of course mean there will be few more extra initial repeated scans - 
but it's the only 'safest' way to proceed (i.e. you can't resolve the problem 
with cookie waiting on loaded system - since the udev 30sec timeout is 
unpredictable....)

Regards

Zdenek
