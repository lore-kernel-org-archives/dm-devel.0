From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: Stopped disk causes LVM to go crazy
Date: Wed, 11 Feb 2009 18:50:45 +0000
Message-ID: <49931E05.2010901@redhat.com>
References: <798685706.2823991234377915224.JavaMail.root@jaguar7.sfu.ca>
Reply-To: bmr@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <798685706.2823991234377915224.JavaMail.root@jaguar7.sfu.ca>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alireza Nematollahi <alirezan@sfu.ca>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Alireza Nematollahi wrote:
> hi. Thanks for your reply. Well, I had tried that before, but no luck. I tried it again, and still no luck: 

You have to do it *BEFORE* you disable/remove the storage. Doing it 
afterwards will just throw all the errors you are seeing since the LVM 
tools can no longer access the device.

You have to do things in the correct order; first unmount any file 
systems, then de-activate LVs/VGs, then stop or remove the storage 
hardware.

If you do this in the wrong order you'll end up with the problems 
you're seeing.

For now, you can clean up /dev/sdb by deleting it via sysfs:

echo 1 > /sys/block/sdb/device/delete

Which will stop other commands that scan the disks from tripping over 
the dead device. You can also manually delete any remaining device 
mapper devices that reference the removed disk (see similar thread 
yesterday).

Regards,
Bryn.
