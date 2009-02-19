From: Michael Keller <MKELLER@il.ibm.com>
Subject: Device-mapper for write monitoring
Date: Thu, 19 Feb 2009 10:06:26 +0200
Message-ID: <OF2FA15171.EBB61656-ONC2257562.00256C52-C2257562.002C88F5@il.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids


Hello,

I would like to ask the dm community whether our virtual block device
driver would be better implemented as a dm target; whether this is in-line
with the goals of the dm architecture, or constitutes abuse; and what
exactly would be the gain for us to do so.


For our block-based incremental backup software we need to monitor all
writes to a device, and report them to our user mode application for
further processing. Our plan is to add a virtual block device of our own
"on top" of every block device to be monitored. Our driver then intercepts
all writes to this virtual device, executes the appropriate logic, and
eventually passes it on to the underlying device.

Should we consider writing this as a dm target?

Some points that came up in discussions with other folks:
1. The "mapping" part itself is really trivial - it's an identity mapping.
Does this mean, we are really abusing the dm infrastructure?
2. What are the actual gains from writing a dm target over writing a
dedicated driver? The following comes to mind: writing less setup code, a
user space library, tools (dmsetup).
3. Are the interfaces of the device mapper relatively stable? (Assume that
our target is not general enough to be included into mainline, and we'll
have to do the API chasing ourselves.)

I was also hoping that the device-mapper can somehow help us with
monitoring the device hosting the root filesystem. Device-mapper apparently
comes with some special support, which allows it to, e.g., mount root on a
logical volume. Does this work for any device-mapper targets, or just for
inbuilt ones? Where do you store the configuration information (dm tables)
anyway, so that it's accessible before root is mounted?

Thank you very much,
Michael
