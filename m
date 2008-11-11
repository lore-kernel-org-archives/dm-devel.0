From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Queue upcall locking (was: [RFC][PATCH] fix
	dm_any_congested() to properly sync up with suspend code path)
Date: Tue, 11 Nov 2008 13:18:54 -0500
Message-ID: <20081111181854.GA25049@infradead.org>
References: <1225944008.14830.1101.camel@chandra-ubuntu>
	<Pine.LNX.4.64.0811100746180.24696@hs20-bc2-1.build.redhat.com>
	<20081110135401.GA11606@infradead.org>
	<Pine.LNX.4.64.0811100914500.14825@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0811100914500.14825@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, dm-devel <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Nov 10, 2008 at 09:19:21AM -0500, Mikulas Patocka wrote:
> For device mapper, congested_fn asks every device in the tree and make OR 
> of their bits --- so if the user has 50 devices, it asks them all.
> 
> For md-linear, md-raid0, md-raid1, md-raid10 and md-multipath it does the 
> same --- asking every device.
> 
> If you have a better idea how to implement congested_fn, say it.

Well, even asking 50 devices shouldn't take that long normally.  Do you
take some sleeping lock that might block forever?  In that case I would
just return congested for that device as it would delay pdflush
otherwise.
