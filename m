From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 1/1] dm-mpath: Extend path selector	interface
	for supporting Dell EqualLogic path selector
Date: Mon, 12 Jul 2010 23:34:49 +0100
Message-ID: <20100712223449.GP26290@agk-dp.fab.redhat.com>
References: <86A3089001A44141B76B882059E7E53B01E87A3B@M31.equallogic.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <86A3089001A44141B76B882059E7E53B01E87A3B@M31.equallogic.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Parind Shah <Parind_Shah@dell.com>, Jason Shamberger <Jason_Shamberger@dell.com>, Narendran Ganapathy <Narendran_Ganapathy@dell.com>
List-Id: dm-devel.ids

On Mon, Jun 28, 2010 at 09:53:20AM -0400, Narendran Ganapathy wrote:
> This patch extends the dm-path-selector interface to allow path selectors to
> use extra information from the IO request when selecting a path.

> To do location based routing, we need the address information of the request.

What other inputs - in addition to offset - will the path selector need to take
into account to make its decision and how will it get those inputs?
Presumably you envisage some sort of semi-static or cached information,
and not asking the hardware before every piece of I/O?
 
How many ranges are there likely to be in this offset-based routing table?
How frequently is the offset-based routing table likely to change?

As Hannes points out, the dm table layer is already designed to handle
offset-based routing, so I'll need some convincing there's a need to duplicate
part of this inside path selectors.
 
If this information is rapidly changing - many reconfigurations per minute,
then we may need to consider some in-kernel solution.  Otherwise I'll be
seeking solutions performing the reconfiguration from userspace first.

> We also propose extending the dm_mpath_io structure used to hold information

I'll consider proposals for any new fields alongside patches that make good use
of them, but I won't add fields in advance.

Alasdair
