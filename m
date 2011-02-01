From: Andreas Heinlein <aheinlein@gmx.com>
Subject: Re: Possible severe bug in the device mapper?
Date: Tue, 01 Feb 2011 14:29:51 +0100
Message-ID: <4D480ACF.8060305@gmx.com>
References: <4D46811C.9050506@gmx.com>
	<1296472845.2642.2.camel@ubuntu>	<4D47D29F.5040200@gmx.com>
	<4D47DAEB.6010506@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4D47DAEB.6010506@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids


> Do you mean 'device' or filesystem as read-only?
> For filesystem you may easily switch error behavior so you will not destroy
> your data when inconsistency is detected (tune2fs -e remount-ro)
>
> Zdenek
I mean filesystem. But the strange thing about my observation is that
obviously no inconsistency is ever detected, except for openSuSE. The
filesystem on the loopback device under Ubuntu and Fedora, backed by the
no-longer-existing usb drive, can be happily read from and written to
and even be fsck'ed without any problems. Only after completely
unmounting it, deleting the loopback device, then re-inserting the drive
and loop-mounting again you can see that data was lost. 'remount-ro' is
set in all cases.

Andreas
