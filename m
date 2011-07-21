From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: What is a /dev/dm-* file ?
Date: Thu, 21 Jul 2011 10:35:25 +0100
Message-ID: <4E27F2DD.3010203@redhat.com>
References: <1353628002.1450009.1311150616312.JavaMail.root@zmail01.collab.prod.int.phx2.redhat.com>	<46858323.1450041.1311150878186.JavaMail.root@zmail01.collab.prod.int.phx2.redhat.com>
	<20110720101753.GA21124@ubuntu10.10>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110720101753.GA21124@ubuntu10.10>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: li mohua <moli@redhat.com>
List-Id: dm-devel.ids

On 07/20/2011 11:17 AM, li mohua wrote:
> 
> from the device number(major,minor), we could see it's another kind
> for device under /dev/mapper/*,sometimes could be a link(udev rules
> etc,no idea about the max number, you could have a test, i guess, 

On a modern system it's the other way around - the /dev/mapper entries are
symbolic links to ../dm-N entries maintained by a set of udev rules (look at
/lib/udev/rules.d/10-dm.rules on a RHEL6 system).

The /dev/$VG/$LV directories and symlinks for LVM2 volume groups and logical
volumes are maintained by a similar set of rules in 11-dm-lvm.rules.

Device mapper minor numbers are assigned dynamically so the upper limit is
dependent on the system (amount of memory) and the types of devices that you are
trying to create (number and type of targets used) - it's not that unusual to
see systems with 1000s of dm devices.

>> I have questions about /dev/dm-* in my mind for days, it seems here is the right place for the answers. 
>> What is a /dev/dm-* file? it says "/dev/dm-0: block special" from file command. 
>> Is there a limitation to the number of /dev/dm-* files ? I tried with RHEL6.1 GA, created 800 from dm-0 to dm-799 as maximum. 

Generally it's advised not to use the dm-N device nodes directly since they do
not provide persistent naming and are created as soon as a device-mapper device
is assigned a minor number in the kernel but possibly before the device is in a
usable state.

Depending on the device-mapper application you're using (LVM2, multipath-tools,
dmraid etc.) there are probably better ways to reference the devices via the
types of symlinks mentioned above.

Regards,
Bryn.
