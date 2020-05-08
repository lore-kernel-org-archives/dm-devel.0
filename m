From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 01/14] dm-zoned: add 'status' and 'message'
	callbacks
Date: Fri, 8 May 2020 17:00:29 -0400
Message-ID: <20200508210029.GA19773@redhat.com>
References: <20200508090332.40716-1-hare@suse.de>
	<20200508090332.40716-2-hare@suse.de>
	<20200508162955.GA18662@redhat.com>
	<9dee23c7-76ed-d80b-bfe2-9d2930488316@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <9dee23c7-76ed-d80b-bfe2-9d2930488316@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Hannes Reinecke <hare@suse.de>
Cc: Damien LeMoal <damien.lemoal@wdc.com>, Bob Liu <bob.liu@oracle.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, May 08 2020 at  2:25pm -0400,
Hannes Reinecke <hare@suse.de> wrote:

> On 5/8/20 6:29 PM, Mike Snitzer wrote:
> >On Fri, May 08 2020 at  5:03am -0400,
> >Hannes Reinecke <hare@suse.de> wrote:
> >
> >>Add callbacks to supply information for 'dmsetup status'
> >>and 'dmsetup info', and implement the message 'reclaim'
> >>to start the reclaim worker.
> >
> >Same feedback from before:
> >https://www.redhat.com/archives/dm-devel/2020-March/msg00189.html
> >
> >Who/What will use the 'reclaim' message?  Shouldn't it be documented?
> >Think the dmz_status changes should be split out from this reclaim
> >message?
> >
> 'reclaim' means that dm-zoned should start moving zones from the
> random zones to the sequential zones to free up more random zones.
> There's a threshold after which it'll start automatically, but this
> allows you to start reclaim even if the threshold isn't reached.
> You might be right, it should be documented.
> (Where? In the code?)

Documentation/admin-guide/device-mapper/dm-zoned.rst

Anything else worthy of sharing with others about v2 metadata format
would also be wise to document as part of those changes,

> As for splitting things off; yeah, I could; maybe I should if the
> 'reclaim' message turns out to be controversial...

Not controversial per se, but its disjoint from the rest of this series.
So best to split it out I think.

Thanks,
Mike
