From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Review of dm-block-manager.c
Date: Mon, 1 Aug 2011 17:17:29 -0400
Message-ID: <20110801211729.GA11406@redhat.com>
References: <Pine.LNX.4.64.1108011620590.9983@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1108011620590.9983@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Edward Thornber <thornber@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Aug 01 2011 at  5:00pm -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Hi
> 
> This is review of dm-block-manager.c:
> 
> 
> char buffer_cache_name[32];
> sprintf(bm->buffer_cache_name, "dm_block_buffer-%d:%d",
> --- it may not fit in 32 bytes.

It can accomodate nearly 1 trillion DM devices:

dm_block_buffer-253:9999999999

The goal is to move to using a common slab cache per blocksize long
before this limit becomes a concern.

Mike
