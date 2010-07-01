From: "Riches Jr, RobertX M" <robertx.m.riches.jr@intel.com>
Subject: Re: Is there a way to see updated contents of a
	DM	target's underlying device while the DM target is in use?
Date: Thu, 1 Jul 2010 09:46:07 -0700
Message-ID: <4BD43A85686FC34D819098DB1C3999D99E591E16@orsmsx502.amr.corp.intel.com>
References: <4BD43A85686FC34D819098DB1C3999D99E4199BA@orsmsx502.amr.corp.intel.com>
	<20100630230828.GX23989@agk-dp.fab.redhat.com>
	<4BD43A85686FC34D819098DB1C3999D99E419AA2@orsmsx502.amr.corp.intel.com>
	<20100701005156.GY23989@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100701005156.GY23989@agk-dp.fab.redhat.com>
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
To: Alasdair G Kergon <agk@redhat.com>
Cc: "Dm-Devel Mailing List Send-To Address (dm-devel@redhat.com)" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Many thanks to those who responded with helpful suggestions.  A couple of the suggestions were sufficient to make my test script behave as I expect--to liberate the data that had been stuck in the page cache twilight zone.  :-)

For the benefit of anyone who might come across the archives with a similar problem, here's what worked and what didn't, with all actions taken between writing and reading:

  - Using 'dd -iflag=direct' to read from /dev/vg1/lv1 (the underlying device) worked.

  - Doing 'blockdev --flushbufs /dev/vg1/lv1' (on the underlying device) worked.

  - Doing 'blockdev --flushbufs /dev/mapper/fred01' (on the device exposed by dm-linear or my module) did not solve the problem.

  - Doing 'dmsetup suspend fred01' did not work.

  - Doing fsync() on /dev/mapper/fred01 did not work.

  - Doing fsync() on /dev/vg1/lv1 did not work.

Of those above that "worked", each was independently sufficient to solve the problematic symptoms. IOW, I only had to apply one solution, not all of them.

Again, thanks for all the solutions.

Robert Riches
Azad Consultant at Intel
 
-----Original Message-----
From: Alasdair G Kergon [mailto:agk@redhat.com] 
Sent: Wednesday, June 30, 2010 5:52 PM
To: Riches Jr, RobertX M
Cc: Dm-Devel Mailing List Send-To Address (dm-devel@redhat.com)
Subject: Re: [dm-devel] Is there a way to see updated contents of a DM target's underlying device while the DM target is in use?

On Wed, Jun 30, 2010 at 04:53:23PM -0700, Riches Jr, RobertX M wrote:
> I didn't see any queues or caches in dm-linear that would need to be flushed.
 
It's your test script that is not behaving as you expect:)

Add conv=odirect to dd

Add blockdev --flushbufs after other writes.

Alasdair
