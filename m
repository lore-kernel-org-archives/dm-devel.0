From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Queue upcall locking (was: [RFC][PATCH] fix
	dm_any_congested() to properly sync up with suspend code path)
Date: Mon, 10 Nov 2008 14:35:22 +0000
Message-ID: <20081110143522.GE16649@agk.fab.redhat.com>
References: <1225944008.14830.1101.camel@chandra-ubuntu>
	<Pine.LNX.4.64.0811100746180.24696@hs20-bc2-1.build.redhat.com>
	<20081110135401.GA11606@infradead.org>
	<Pine.LNX.4.64.0811100914500.14825@hs20-bc2-1.build.redhat.com>
	<1226327210.7685.173.camel@twins>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1226327210.7685.173.camel@twins>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Peter Zijlstra <peterz@infradead.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, dm-devel <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Mon, Nov 10, 2008 at 03:26:50PM +0100, Peter Zijlstra wrote:
> Fix the infrastructure by adding a function call so that you can have
> the individual devices report their congestion state to the aggregate.
 
Which requires knowing/accessing some device hierarchy, which would be nice
for other things too (like propagation of notification of changes to device
properties such as size, hardsect size etc.).

Alasdair
-- 
agk@redhat.com
