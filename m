From: Malahal Naineni <malahal@us.ibm.com>
Subject: Re: Is there a way to see updated contents of a	DM
 target's underlying device while the DM target is in use?
Date: Wed, 30 Jun 2010 18:03:09 -0700
Message-ID: <20100701010309.GC24284@us.ibm.com>
References: <4BD43A85686FC34D819098DB1C3999D99E4199BA@orsmsx502.amr.corp.intel.com>
	<20100630230828.GX23989@agk-dp.fab.redhat.com>
	<4BD43A85686FC34D819098DB1C3999D99E419AA2@orsmsx502.amr.corp.intel.com>
	<20100701005156.GY23989@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20100701005156.GY23989@agk-dp.fab.redhat.com>
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
Cc: "Riches Jr, RobertX M" <robertx.m.riches.jr@intel.com>
List-Id: dm-devel.ids

Alasdair G Kergon [agk@redhat.com] wrote:
> On Wed, Jun 30, 2010 at 04:53:23PM -0700, Riches Jr, RobertX M wrote:
> > I didn't see any queues or caches in dm-linear that would need to be flushed.
> 
> It's your test script that is not behaving as you expect:)
> 
> Add conv=odirect to dd

You mean flags rather than conv? conv just converts ascii to ebcdic etc. 
oflag=direct would do direct I/O on the writes and iflag=direct should do
direct I/O on reads.

Thanks, Malahal.
