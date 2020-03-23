From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH RFC 0/2] dm-zoned: add cache device
Date: Mon, 23 Mar 2020 11:15:38 -0400
Message-ID: <20200323151538.GA27573@redhat.com>
References: <20200323150352.107826-1-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200323150352.107826-1-hare@suse.de>
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
Cc: Damien LeMoal <damien.lemoal@wdc.com>, Johannes Thumshirn <jth@kernel.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Mar 23 2020 at 11:03am -0400,
Hannes Reinecke <hare@suse.de> wrote:

> Hi Damien,
> 
> as my original plan to upgrade bcache to work for SMR devices
> turned out to be more complex than anticipated I went for the
> simpler approach and added a 'cache' device for dm-zoned.
> It is using a normal device (eg '/dev/pmem0' :-), split it
> into zones of the same size of the original SMR device, and
> makes those 'virtual' zones avialable to dm-zoned in a similar
> manner than the existing 'random write' zoned.
> 
> The implementation is still a bit rough (one would need to add
> metadata to the cache device, too), but so far it seems to work
> quite well; still running after copying 300GB of data back and forth.
> 
> As usual, comments and reviews are welcome.

Not seeing why this needs to be so specialized (natively implemented in
dm-zoned).  Did you try stacking dm-writecache on dm-zoned?

Mike
