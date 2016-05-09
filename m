From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [PATCH] dm-raid: check for zero feature flags in
 metadata
Date: Mon, 9 May 2016 17:20:58 +0200
Message-ID: <5730AADA.2050602@redhat.com>
References: <1461949196-17999-1-git-send-email-heinzm@redhat.com>
	<20160430003116.GA27436@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160430003116.GA27436@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids



On 04/30/2016 02:31 AM, Alasdair G Kergon wrote:
> On Fri, Apr 29, 2016 at 06:59:56PM +0200, heinzm@redhat.com wrote:
>> +	rs->ti->error = "Unable to assemble array: No feature flags supported yet";
>> +	if (le32_to_cpu(sb->features)) /* No features supported yet */
> Is it worth splitting this into compat_flags and incompat_flags like we did in
> thin and cache?

I'm envisioning a single feature flag for future reshape/takeover 
functionality.
Seems like a good idea still so I'll add this to the RAID superblock 
metadata changes.

Heinz

>
> Alasdair
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
