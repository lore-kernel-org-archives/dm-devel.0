From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: Multipath blacklist exceptions issues
Date: Thu, 15 Nov 2007 10:57:27 -0500 (EST)
Message-ID: <20071115.105727.74752585.k-ueda@ct.jp.nec.com>
References: <5201e28f0711131517p79fc4a8dk1da9bda922c3093e@mail.gmail.com>
	<20071114.154456.71084719.k-ueda@ct.jp.nec.com>
	<5201e28f0711141411ue475f31qc4db61076479bd7e@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5201e28f0711141411ue475f31qc4db61076479bd7e@mail.gmail.com>
	<5201e28f0711150707p18c8d1f8i39fb2ad26e955d65@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

On Thu, 15 Nov 2007 16:07:35 +0100, "Stefan Bader" <Stefan.Bader@de.ibm.com> wrote:
> > Did you drop dm-devel from Cc meaningly?
> 
> 
> Oops, no. Just me accidentally using reply instead of reply-all

OK.  I attached the Stefan's reply which was sent to only me
so that dm-devel can see it.


-------------------------------------------------------------------
Hi Kiyoshi,

2007/11/14, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>:
>
>
> Before discussing details, I would like to make my standpoint clear.
>   - Minimize the number of sections user has to modify as possible
>   - Don't confuse users by pretending too much flexibility
>
> If we could do with only one section, it would be ideal.
> However, wwid can be obtained only by getuid callout, which has
> side effects of accessing devices and yielding unpleasant kernel
> warning messages, etc.
> So the filtering has to be splitted into 2 stages at least:
>   before running getuid callout and after that
> and we can't use wwid in the 1st stage.
> Not to pretend that mixing wwid filtering and others is possible,
> it's natural to have 2 different filtering sections.


The behavior that is not that well expected is that if you can not do the
following:

blacklist {
    devnode ".*"
    wwid ".*"
}
blacklist_execptions {
    devnode "^sda[0-9+]"
    wwid "foo"
}

> Decide which device to ignore at all:
> > - look at the whitelist entries for devnode (and driver), continue to
> check
> > if found
> > - look at the blacklist entries for devnode (and driver), do not use if
> > found
> > - no match, continue
> > Decide for which devices to call getuid:
> > - look at the whitelist entries for device, continue to check if found
> > - look at the blacklist entries for device, do not use if found
> > - no match, continue
> > Decide which UIDs should be used:
> > - look at the whitelist entries for wwid, use if found
> > - look at the blacklist entries for wwid, do not use if found
> > - no match, use device
>
> Why do you need to separate the first stage and the second stage?
> I don't think we need to separate them.


There just might be block devices that should be ignored right away. Not all
drivers  have a vendor and model attribute. Though, such devices could be
ignored as well.

I think the point is whether execute getuid callout or not.
> So we should need just 2 stages like below:
> (The keyword "pre_getuid_filter" is not so good, just a example.)
>
> ----------------------- /etc/multipath.conf -------------------------
> # First stage filter.  Drop unneeded devices on this stage
> pre_getuid_filter {
>         whitelist_driver "scsi|cciss"
>         whitelist_device {
>                 vendor  "IBM"
>                 model   "S/390 DASD ECKD"
>         }
>         blacklist_driver "*"
> }

# Second stage filter
> filter {
>         blacklist_devnode "sda"
>         whitelist_wwid "012345"
>         blacklist_wwid "*"
>         # only wwid filter may be enough in this stage
> }
> ---------------------------------------------------------------------


It clearly shows that there are different stages in filtering. Good as long
there are only two stages.

---------------------------- multipathd -----------------------------
> for_each_devnode in /sys/block {
>     o gather all sysfs information including vendor and model
>     o decide whether it is needed using the first stage filter
>       (the matching rule is that first match is used)
>     o store it in pathvec if needed
> }


Basically split the filter rules into two distinct sets: driver and device
rules for pre-filtering and devnode and wwid for post-getuid-filtering.
As I said, this looks fine, if those two stages are enough for everyone.

Regards,
Stefan
