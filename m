From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: Revert "dm mpath: remove unnecessary NVMe branching
 in favor of scsi_dh checks"
Date: Tue, 13 Mar 2018 16:38:38 +0000
Message-ID: <1520959117.2638.12.camel@wdc.com>
References: <20180312202808.3556-1-bart.vanassche@wdc.com>
	<20180312212314.GA30763@redhat.com> <1520890358.3469.68.camel@wdc.com>
	<20180313152551.GA2785@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180313152551.GA2785@redhat.com>
Content-Language: en-US
Content-ID: <4F057791EC481E49A9A8E07473CA69BD@namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, 2018-03-13 at 11:25 -0400, Mike Snitzer wrote:
> A pointer to the commit ids in question would be helpful so I can
> appreciate the details better.

Not sure whether this list is complete, but this is the most important one:

63cf1a902c9dd6b0761861ea87fce3663f59403b IB/srpt: Add RDMA/CM support

> Why is there need for a virtual machine?
> Just using extra isolation so as not to conflict with anything on the
> host?

Running these tests directly on the host is also fine. I wanted to explain
that no InfiniBand hardware is required.

Bart.
