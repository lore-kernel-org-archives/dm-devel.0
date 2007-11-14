From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: Multipath blacklist exceptions issues
Date: Wed, 14 Nov 2007 15:44:56 -0500 (EST)
Message-ID: <20071114.154456.71084719.k-ueda@ct.jp.nec.com>
References: <5201e28f0711101625r19ceaf11yd3727c424f27b7d8@mail.gmail.com>
	<20071113201804.GJ28113@ether.msp.redhat.com>
	<5201e28f0711131517p79fc4a8dk1da9bda922c3093e@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5201e28f0711131517p79fc4a8dk1da9bda922c3093e@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, sbader3@googlemail.com
List-Id: dm-devel.ids

Hi Stefan,

On Wed, 14 Nov 2007 00:17:25 +0100, "Stefan Bader" <sbader3@googlemail.com> wrote:
> > Um. Mostly because I just thought up this idea to address the issues you
> > had with my first idea.  I though it would be nice if multipath had a
> > clearly defined set of devices it didn't need to bother checking, and
> > then it would only need to look at the filter rules after all the path
> > information had been gathered.  However, you are correct.  Multipath can
> > just check the blacklist_driver rules at the beginning of the filter
> > section before gathering path information, and the rest of the rules
> > afterwards, to achieve the same effect. As a side note, blacklist_driver
> > should also allow the special string "*", which blacklists all devices.
> > Also, whitelist_driver rules don't make any sense.
> 
> 
> I tried to avoid having multiple filter-defining sections but I must admit
> having everything in one section might be confusing as well. The problem is,
> that there are three stages at which a decission has to be made to continue
> or not. First by driver or node name (Kiyoshi has a valid argument there).
> Every match at this early stage prevents useless work. Whitelist rules for
> driver and devnode make sense if internal rules have to be reversed (e.g.
> internal blacklist uses blacklist_driver "*").
> Second stage is to check whether it makes sense to continue with a certain
> class of devices (from vendor, model). At this point I do not think it makes
> sense to look at the driver and devnode rules again.
> And finally, if the UID information has been gathered, there would be the
> moment to check which of them should be used.
> 
> When the current code does the final filtering it goes again through all
> stacked filters and by that a whitelist for a devnode(range) cannot be
> limited by a wwid blacklist.
...
snip
...
> I admit my idea had a major flaw. It is just not compatible with the way
> device detection is run. It might turn out that the only thing that has to
> be changed is to change which filter rules are used at a certain point of
> the detection.

Before discussing details, I would like to make my standpoint clear.
  - Minimize the number of sections user has to modify as possible
  - Don't confuse users by pretending too much flexibility

If we could do with only one section, it would be ideal.
However, wwid can be obtained only by getuid callout, which has
side effects of accessing devices and yielding unpleasant kernel
warning messages, etc.
So the filtering has to be splitted into 2 stages at least:
  before running getuid callout and after that
and we can't use wwid in the 1st stage.
Not to pretend that mixing wwid filtering and others is possible,
it's natural to have 2 different filtering sections.
 

> Decide which device to ignore at all:
> - look at the whitelist entries for devnode (and driver), continue to check
> if found
> - look at the blacklist entries for devnode (and driver), do not use if
> found
> - no match, continue
> Decide for which devices to call getuid:
> - look at the whitelist entries for device, continue to check if found
> - look at the blacklist entries for device, do not use if found
> - no match, continue
> Decide which UIDs should be used:
> - look at the whitelist entries for wwid, use if found
> - look at the blacklist entries for wwid, do not use if found
> - no match, use device

Why do you need to separate the first stage and the second stage?
I don't think we need to separate them.
I think the point is whether execute getuid callout or not.
So we should need just 2 stages like below:
(The keyword "pre_getuid_filter" is not so good, just a example.)

----------------------- /etc/multipath.conf -------------------------
# First stage filter.  Drop unneeded devices on this stage
pre_getuid_filter {
	whitelist_driver "scsi|cciss"
	whitelist_device {
		vendor	"IBM"
		model	"S/390 DASD ECKD"
	}
	blacklist_driver "*"
}

# Second stage filter
filter {
	blacklist_devnode "sda"
	whitelist_wwid "012345"
	blacklist_wwid "*"
	# only wwid filter may be enough in this stage
}
---------------------------------------------------------------------

---------------------------- multipathd -----------------------------
for_each_devnode in /sys/block {
    o gather all sysfs information including vendor and model
    o decide whether it is needed using the first stage filter
      (the matching rule is that first match is used)
    o store it in pathvec if needed
}

for_each_remained_devnode in pathvec {
    o run getuid callout
    o decide whether it should be used for map by the second stage filter
      (the matching rule is that first match is used)
}
---------------------------------------------------------------------

What do you think?

Thanks,
Kiyoshi Ueda
