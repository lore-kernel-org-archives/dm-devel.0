From: Hannes Reinecke <hare@suse.de>
Subject: Re: Is there a way to see updated contents of a	DM
 target's underlying device while the DM target is in use?
Date: Fri, 02 Jul 2010 16:52:19 +0200
Message-ID: <4C2DFD23.6070500@suse.de>
References: <4BD43A85686FC34D819098DB1C3999D99E4199BA@orsmsx502.amr.corp.intel.com>	<20100630230828.GX23989@agk-dp.fab.redhat.com>	<4BD43A85686FC34D819098DB1C3999D99E419AA2@orsmsx502.amr.corp.intel.com>	<20100701005156.GY23989@agk-dp.fab.redhat.com>	<4BD43A85686FC34D819098DB1C3999D99E591E16@orsmsx502.amr.corp.intel.com>
	<20100701190017.GC12613@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100701190017.GC12613@us.ibm.com>
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

Malahal Naineni wrote:
> Riches Jr, RobertX M [robertx.m.riches.jr@intel.com] wrote:
>> Many thanks to those who responded with helpful suggestions.  A couple o=
f the suggestions were sufficient to make my test script behave as I expect=
--to liberate the data that had been stuck in the page cache twilight zone.=
  :-)
>>
>> For the benefit of anyone who might come across the archives with a simi=
lar problem, here's what worked and what didn't, with all actions taken bet=
ween writing and reading:
>>
>>   - Using 'dd -iflag=3Ddirect' to read from /dev/vg1/lv1 (the underlying=
 device) worked.
>>
>>   - Doing 'blockdev --flushbufs /dev/vg1/lv1' (on the underlying device)=
 worked.
>>
>>   - Doing 'blockdev --flushbufs /dev/mapper/fred01' (on the device expos=
ed by dm-linear or my module) did not solve the problem.
> =

> I wonder why flushing the underlying device worked but not the actual
> device itself. I expected the opposite! :-(
> =

Why, no. That's exactly the point.
The device keeps the underlying block devices pinned in the cache, so any p=
age invalidation can only be triggered
by the device itself, not the underlying ones. Any writes to the underlying=
 devices won't trigger a page
invalidation, so they'll stay in the cache forever.
Hence you need to flush them explicitely.

Not that I'll recommend that. It'll play silly buggers with the page cache.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
