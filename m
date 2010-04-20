From: Nikanth Karthikesan <knikanth@suse.de>
Subject: Re:
 =?iso-8859-1?q?=5BPATCH=5D_Just_inform_and_dont_warn_w?=
 =?iso-8859-1?q?hen_DM=5FDEV=5FREMOVE_is=09tried_on_a_open_device?=
Date: Tue, 20 Apr 2010 14:13:15 +0530
Message-ID: <201004201413.15467.knikanth@suse.de>
References: <201004201246.58828.knikanth@suse.de> <4BCD5F12.7080107@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4BCD5F12.7080107@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <mbroz@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Stefan Assmann <s.assmann@gmx.de>
List-Id: dm-devel.ids

On Tuesday 20 April 2010 13:30:18 Milan Broz wrote:
> On 04/20/2010 09:16 AM, Nikanth Karthikesan wrote:
> > Dont warn when DM_DEV_REMOVE ioctl is tried on a open device.
> >
> > On openSUSE when cryptsetup and udev interact, cryptsetup sometimes tries
> > to remove a dm device currently opened by blkid, which is not a serious
> > issue to print a kernel warning. The application should retry if -EBUSY
> > is returned. So let us make it an informational message instead.
> >
> > -		DMWARN("unable to remove open device %s", hc->name);
> > +		DMINFO("unable to remove open device %s", hc->name);
> 
> NAK.
> 
> Firstly, it is security problem if someone from udev rules tries to open
> temporary-cryptsetup device, it contains only private key material.
> 

Okay.

> Secondly, it must be solved on application level and not paper kernel using
> patches which hides errors.
> 

Agreed, it must be solved in the application level.

/me wonders whether this is an error worth a warning from kernel? Returning 
-EBUSY seems enough. May be a KERN_INFO message... But yes rest of DM prints 
warnings for these kind of events.

> FYI there is already patch in upstream cryptsetup which uses udev cookie
>  mechanism. It still cannot solve artificial change events (which causes
>  scan from rules randomly), but should help here. (will be in cryptsetup
>  1.1.1)
> 

Oh, ok. Thanks for the pointer.

Thanks
Nikanth
