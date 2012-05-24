From: Kent Overstreet <koverstreet@google.com>
Subject: Re: [PATCH v2 07/14] pktcdvd: Switch to bio_kmalloc()
Date: Thu, 24 May 2012 12:55:49 -0700
Message-ID: <20120524195549.GA18624@google.com>
References: <1337817771-25038-1-git-send-email-koverstreet@google.com>
	<1337817771-25038-8-git-send-email-koverstreet@google.com>
	<20120524194252.GF27550@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20120524194252.GF27550@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, yehuda@hq.newdream.net, dm-devel@redhat.com, linux-kernel@vger.kernel.org, tj@kernel.org, linux-bcache@vger.kernel.org, mpatocka@redhat.com, bharrosh@panasas.com, linux-fsdevel@vger.kernel.org, sage@newdream.net, agk@redhat.com, drbd-dev@lists.linbit.com
List-Id: dm-devel.ids

On Thu, May 24, 2012 at 03:42:52PM -0400, Vivek Goyal wrote:
> On Wed, May 23, 2012 at 05:02:44PM -0700, Kent Overstreet wrote:
> 
> [..]
> > @@ -567,10 +569,13 @@ static struct packet_data *pkt_alloc_packet_data(int frames)
> >  		goto no_pkt;
> >  
> >  	pkt->frames = frames;
> > -	pkt->w_bio = pkt_bio_alloc(frames);
> > +	pkt->w_bio = bio_kmalloc(GFP_KERNEL, frames);
> 
> So previously bios allocated were being kfreed by pkt_bio_destructor().
> Now where are we doing kfree() on bio being allocated by bio_kmalloc()?

bio_kmalloc() sets up bi_destructor, so there's no need to kfree() the
bio - bio_put() frees it just like normal.
