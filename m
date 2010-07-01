From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Is there a way to see updated contents of a
	DM	target's underlying device while the DM target is in use?
Date: Thu, 1 Jul 2010 02:01:37 +0100
Message-ID: <20100701010137.GZ23989@agk-dp.fab.redhat.com>
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
To: "Riches Jr, RobertX M" <robertx.m.riches.jr@intel.com>
Cc: "Dm-Devel Mailing List Send-To Address (dm-devel@redhat.com)" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Jul 01, 2010 at 01:51:57AM +0100, Alasdair G Kergon wrote:
> Add conv=odirect to dd
> Add blockdev --flushbufs after other writes.
 
Applications like lvm2 have those things built in to guarantee metadata
consistency at application level.

Alasdair
