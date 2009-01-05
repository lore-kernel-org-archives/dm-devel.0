From: malahal@us.ibm.com
Subject: Re: [RFC][PATCH 0/4] dm-log: support multi-log devices
Date: Mon, 5 Jan 2009 10:44:08 -0800
Message-ID: <20090105184408.GA20412@us.ibm.com>
References: <492C91DF.7040507@redhat.com>
	<ACCFADCE-51D8-4183-803D-32050E3BE436@redhat.com>
	<49467039.6060801@redhat.com> <20081220001305.GA8574@us.ibm.com>
	<49502F7E.9040300@redhat.com> <20081223180228.GA24831@us.ibm.com>
	<49622ADB.7040200@redhat.com>
	<20090105162435.GB18452@us.ibm.com> <4962450C.20507@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4962450C.20507@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Takahiro Yasui <tyasui@redhat.com>
Cc: dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

Takahiro Yasui [tyasui@redhat.com] wrote:
> > Not really. What I meant is re-integrating a failed log device when it
> > comes back again. That is also what I mean by handling 'transient
> > errors'.
> 
> Thanks, I see your requirement on this feature.
> Let me put one more question.
> 
> LVM mirroring is used to make system available even if some devices,
> such as data and log device, have a problem. Currently, activations
> by "vgchange -ay" command seem to fail during system booting if one
> of devices related to VG are missing or had I/O error. For example,
> if a mirror is structured by two data devices and log devices, the
> mirror logical device should be activated and used even if one data
> device and one log device are missing.
>
> Could you give me an idea or solution to handle this? Do we need to
> enhance your feature to achieve this requirement?

The requirement you are asking is more than "mirrored log" support.
Actually it is nothing to do with "mirrored log" support! LVM has
"--partial' option but that creates read-only volumes.  IBM has
implemented "--partial-rw" that activates such mirror devices.
Essentially it creates an 'error device' in place of a missing device,
but the patch isn't complete as it doesn't work well with other segment
(target) types!

What we need is changes to LVM "--partial" code path where it can create
volumes read-only or read-write based on what is available instead of
blindly doing read-only.

Thank you for looking at these enterprise level features.

Thanks, Malahal.
