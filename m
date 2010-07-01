From: Malahal Naineni <malahal@us.ibm.com>
Subject: Re: Is there a way to see updated contents of a	DM
 target's underlying device while the DM target is in use?
Date: Thu, 1 Jul 2010 12:00:17 -0700
Message-ID: <20100701190017.GC12613@us.ibm.com>
References: <4BD43A85686FC34D819098DB1C3999D99E4199BA@orsmsx502.amr.corp.intel.com>
	<20100630230828.GX23989@agk-dp.fab.redhat.com>
	<4BD43A85686FC34D819098DB1C3999D99E419AA2@orsmsx502.amr.corp.intel.com>
	<20100701005156.GY23989@agk-dp.fab.redhat.com>
	<4BD43A85686FC34D819098DB1C3999D99E591E16@orsmsx502.amr.corp.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4BD43A85686FC34D819098DB1C3999D99E591E16@orsmsx502.amr.corp.intel.com>
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

Riches Jr, RobertX M [robertx.m.riches.jr@intel.com] wrote:
> Many thanks to those who responded with helpful suggestions.  A couple of the suggestions were sufficient to make my test script behave as I expect--to liberate the data that had been stuck in the page cache twilight zone.  :-)
> 
> For the benefit of anyone who might come across the archives with a similar problem, here's what worked and what didn't, with all actions taken between writing and reading:
> 
>   - Using 'dd -iflag=direct' to read from /dev/vg1/lv1 (the underlying device) worked.
> 
>   - Doing 'blockdev --flushbufs /dev/vg1/lv1' (on the underlying device) worked.
> 
>   - Doing 'blockdev --flushbufs /dev/mapper/fred01' (on the device exposed by dm-linear or my module) did not solve the problem.

I wonder why flushing the underlying device worked but not the actual
device itself. I expected the opposite! :-(
