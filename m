From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 1/3] Send KOBJ_ADD event after dm
	resume	ioctl.
Date: Fri, 19 Mar 2010 15:24:10 +0000
Message-ID: <20100319152409.GG919@agk-dp.fab.redhat.com>
References: <ac3eb2511003180913t5f69e0bs29ff3dcfd1209c60@mail.gmail.com>
	<4BA29CA4.9070000@redhat.com>
	<ac3eb2511003190127n1aa2dda5pbd4e0841a46830bc@mail.gmail.com>
	<20100319090656.GR6379@soda.linbit>
	<ac3eb2511003190224u1eb19e4lfeda36bbab18939@mail.gmail.com>
	<4BA37B06.1040107@redhat.com>
	<ac3eb2511003190643u32a8e702l4e7774e7ec924a12@mail.gmail.com>
	<7b13a0f81003190658i78664328ocb94aa0048054a17@mail.gmail.com>
	<20100319143412.GE919@agk-dp.fab.redhat.com>
	<7b13a0f81003190759w4de7be34pfa1a0454ac311ad8@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <7b13a0f81003190759w4de7be34pfa1a0454ac311ad8@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: David Zeuthen <zeuthen@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Mar 19, 2010 at 10:59:12AM -0400, David Zeuthen wrote:
> I'd like to reiterate that it's actually not a problem that the sequence is
>  - "add" uevent
>  - device is not usable, access to the device fails gracefully
>  - "change" uevent
>  - device usable, blkid on the device etc. works
> the point really is that you have to accept that there will exist
> user space programs that does things on the device between
> "add" and the initial "change" uevent.
 
It is a problem if both:
    1) something attempts to open the devices in that window
AND 2) we have no mechanism to wait for it to finish

Also note that if it is permitted to run 'udevadm trigger' at
any time that also causes a synchonisation problem here: our
application code doesn't even know there is something conflicting
that it needs to wait for.  [Even though we want to ignore ADD,
we may still need to synchronise against it.]

So again, the 'don't issue ADD until device is usable' offers a simple
way of avoiding this class of problems.  The 'private device
attribute' we suggested offers another - all would be expected
to respect a 'private' sysfs attribute.

Alasdair
