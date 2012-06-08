From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: different LUN numbers under the same dm device
Date: Fri, 08 Jun 2012 12:05:08 -0500
Message-ID: <4FD230C4.1000702@cs.wisc.edu>
References: <8DCD6D08-35CE-48CC-AC54-7436265C32CB@purestorage.com>
	<20120606203507.GC16432@redhat.com>
	<A1C07741-D139-45F5-A877-A5E5DC792AD3@purestorage.com>
	<20120607223954.GC3211@ether.msp.redhat.com>
	<F6378CE3-200B-4AF4-97BC-B3A310231420@purestorage.com>
	<4FD1A2BF.2090109@suse.de> <4FD1AF59.3040101@cs.wisc.edu>
	<F9D694F1-5E66-4B09-AF2B-DA2F56CAC492@purestorage.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <F9D694F1-5E66-4B09-AF2B-DA2F56CAC492@purestorage.com>
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
Cc: Brian Bunker <brian@purestorage.com>
List-Id: dm-devel.ids

On 06/08/2012 11:35 AM, Brian Bunker wrote:
> As far as the NAA number for different LUN's, we have the requirement that each LUN on our array has a different NAA number as you would expect. How those LUN's are presented to the host however there is no such restriction. For example, you could present the array's LUN 1 masked as LUN 10 to the initiator and then later masked that same LUN to the initiator as LUN 12 or any other number. In that case LUN 10 and later LUN 12 would have the same NAA number since they are in fact talking to the same actual LUN on the array. This is what I think multipath is having trouble with.
> 

This is different then what I thought you were talking about first. That
is the bug Hannes is talking about. As Hannes was saying we do not
handle that case, and in the scsi layer you get a message like:

"Warning! Received an indication that the "
"LUN assignments on this target have "
"changed. The Linux SCSI layer does not "
"automatically remap LUN assignments.\n");

logged in /var/log/messages.

This issue will definitely cause corruption if you are using the scsi
devices directly. For example if /dev/sda is LUN10, you then remap it,
and on the target it is now LUN11. The scsi layer just logs the message
above and the OS continues to use /dev/sda like it was LUN10, but the
data gets written to what is now LUN11's storage.

At the multipath layer if you do not rescan at the scsi layer level
after the remap, then there will be corruption because dm-0 is accessing
/dev/sda which it thinks is LUN10 but is now LUN 11. Because we do not
handle the sense indicating the LUNS changed, dm-0 will not change.

If you rescan at the scsi layer with just sysfs or procfs  and you get
new paths (/dev/sdXs) for the newly remapped LUNs, I was saying that I
think multipath should at least not add paths with different UUIDs to
the same dm deivce. So it should kick out the old paths before adding
the new ones or create a new device with the new paths, but it looks
like it doesn't.

So right now you should do what Hannes suggests and use
'rescan-scsi-bus.sh -r'. This will delete old mappings and setup
/dev/sdXs for new ones. multipath will get events and then should do the
right thing dm device assembly wise (I mean you should not end up with 4
paths where 2 have different UUIDs).
