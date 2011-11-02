From: <Jim_Ramsay@DELL.com>
Subject: Re: RFC: dm-switch target [v3]
Date: Wed, 2 Nov 2011 11:36:19 -0500
Message-ID: <32C294CE27383749AAB52C2549D4120C0166E90B3F@AUSX7MCPS306.AMER.DELL.COM>
References: <20111021202253.GA27434@freewill.equallogic.com>
	<20111027185223.GA6444@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20111027185223.GA6444@redhat.com>
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
To: snitzer@redhat.com
Cc: dm-devel@redhat.com, Parind_Shah@DELL.com, Jason_Shamberger@DELL.com, Kevin_OKelley@DELL.com
List-Id: dm-devel.ids

Mike Snitzer wrote:
> On Fri, Oct 21 2011 at  4:22pm -0400, Jim Ramsay <jim_ramsay@dell.com> wrote:
> > - Added a sysfs file so userland applications can easily check the version of
> >   this module.
> 
> One would hope that this "version" file isn't needed.  DM already provides
> the ability to query the version of targets via the DM_LIST_VERSIONS dm-
> ioctl.  
...
> But we don't have the ability to ask for a specific target's version.
> 
> (lvm2's tools/dmsetup.c:_targets() illustrates how to collect the targets and
> access their versions -- would require linking against libdm).

Thanks very much for the feedback, Mike.

This sysfs 'version' file is more for userland utilities so they know what version of the netlink message is spoken by the kernel piece.  Since it is related to the netlink socket specifically, it made sense to add it alongside the existing '/sys/module/dm_switch/familyid', so there's easy one-stop-shopping for everything that userland needs to use out the netlink interface.

We certainly could use dmsetup or libdm for the same purpose, but is there much harm in having this version file in sysfs?

> But we could add a --target flag to dmsetup targets (like 'dmsetup ls'
> allows), e.g.: dmsetup targets --target switch

I agree that this would be a valuable addition to dmsetup, but keeping the version file in sysfs would have the benefit of the one-stop-shopping I mention above, as well as not requiring a specific version of the dmsetup tool to be present for userland programs to easily locate the information they require.

-- 
Jim Ramsay
