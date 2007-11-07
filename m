From: malahal@us.ibm.com
Subject: Re: Reloading multipathd?
Date: Wed, 7 Nov 2007 08:55:26 -0800
Message-ID: <20071107165526.GA25329@us.ibm.com>
References: <940B4FF1F5958E4F96FC83C055A2F2611B8B8C@exch-2003.incipient.waltham>
	<1194448727.6012.18.camel@sanderbal>
	<000301c82155$0de88c60$cf42e3c1@pitagora.it>
	<1194451276.6012.30.camel@sanderbal>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1194451276.6012.30.camel@sanderbal>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "S. J. van Harmelen" <svh@dds.nl>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

S. J. van Harmelen [svh@dds.nl] wrote:
> 
> Thanks for you help. But the MD3000 has SAS HBA's, so I don't have the
> issue_lip file on my system.
> 
> Any other way to get the same results for a SAS HBA?
> 
> And once again... Does this interrupt the LUN's that are already
> attached and in use?

LIP does interrupt the communication for a while, but ideally everything
would be retried on block devices at least. I don't think you need to
generate LIP in some instances (depends on how you added your LUN, E.g.
if you added new FC disk to FC Fabric switch, the Fabic would generate
an event, RSCN, without interrupting anything).

I don't know SAS world equivalents...
