From: Malahal Naineni <malahal@us.ibm.com>
Subject: Re: Is there a way to see updated contents of a	DM
 target's underlying device while the DM target is in use?
Date: Wed, 30 Jun 2010 17:54:54 -0700
Message-ID: <20100701005454.GA24284@us.ibm.com>
References: <4BD43A85686FC34D819098DB1C3999D99E4199BA@orsmsx502.amr.corp.intel.com>
	<20100630230828.GX23989@agk-dp.fab.redhat.com>
	<4BD43A85686FC34D819098DB1C3999D99E419AA2@orsmsx502.amr.corp.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4BD43A85686FC34D819098DB1C3999D99E419AA2@orsmsx502.amr.corp.intel.com>
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
> However, I am able to reproduce the symptom using the standard dm-linear module supplied with the x86_64 kernel that comes with Ubuntu Karmic.  With the attached script, the first 'od' on /dev/vg1/lv1, done before 'dmsetup remove', shows the first part of the file contains 0x00.  A second 'od' after 'dmsetup remove' shows the file contains random data.
> 
> I didn't see any queues or caches in dm-linear that would need to be flushed.
> 
> Any other suggestions?

If you write to a block device devA and read from it on the same system,
you would get the expected data. In your case, you have devA and devB
(devB is a mapped device on devA, but that doesn't matter), you write to
devA and read from devB. You won't see what you wrote because of block
device caching. Try fsync() on the block device fred01 before copying or
try suspend on the linear dev (fred01 in your case).

Thanks, Malahal.
