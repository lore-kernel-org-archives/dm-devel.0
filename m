From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH] DM RAID: Add message/status support for
	changing sync action
Date: Sun, 17 Mar 2013 22:52:16 +0000
Message-ID: <20130317225216.GA20480@agk-dp.fab.redhat.com>
References: <1363380503.5163.2.camel@f16>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1363380503.5163.2.camel@f16>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On Fri, Mar 15, 2013 at 03:48:23PM -0500, Jon Brassow wrote:
> DM RAID:  Add message/status support for changing sync action
 
Quick points:

> Two additional fields 

(which are *always* populated)

> have been added 

appended

> to the status output to provide more
> information about the type of sync action occurring and the results of those
> actions, specifically: <sync_action> and <mismatch_cnt>.  This is essentially
> the device-mapper way of doing what MD controls through the 'sync_action'
> sysfs file and shows through the 'mismatch_cnt' sysfs file.
 
> +	char *sync_action_type = "idle";

(const?)  

> +		/*
> +		 * Sync action:
> +		 *   See Documentation/device-mapper/dm-raid.c for
> +		 *   information on each of these states.
> +		 */
> +		if (test_bit(MD_RECOVERY_FROZEN, &rs->md.recovery))
> +			sync_action_type = "frozen";
> +		else if (test_bit(MD_RECOVERY_RUNNING, &rs->md.recovery) ||
> +			 (!rs->md.ro && test_bit(MD_RECOVERY_NEEDED,
> +						 &rs->md.recovery))) {
> +			if (test_bit(MD_RECOVERY_RESHAPE, &rs->md.recovery))
> +				sync_action_type = "reshape";
> +			else if (test_bit(MD_RECOVERY_SYNC, &rs->md.recovery)) {
> +				if (!test_bit(MD_RECOVERY_REQUESTED,
> +					      &rs->md.recovery))
> +					sync_action_type = "resync";
> +				else if (test_bit(MD_RECOVERY_CHECK,
> +						  &rs->md.recovery))
> +					sync_action_type = "check";
> +				else
> +					sync_action_type = "repair";
> +			} else if (test_bit(MD_RECOVERY_RECOVER,
> +					    &rs->md.recovery))
> +				sync_action_type = "recover";
> +		}

Move this out into a fn that can simply return once it's selected
the most appropriate string?

> -	.version = {1, 4, 1},
> +	.version = {1, 4, 2},

  1.5.0 - inc minor when the change affects interface or behaviour in a non-neglible way

Alasdair

