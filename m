From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm-bufio
Date: Mon, 17 Oct 2011 12:24:00 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1110171223010.21071@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1110141500160.29246@hs20-bc2-1.build.redhat.com>
	<20111017112904.GH13963@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20111017112904.GH13963@ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <thornber@redhat.com>
Cc: dm-devel@redhat.com, Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, 17 Oct 2011, Joe Thornber wrote:

> On Fri, Oct 14, 2011 at 03:14:34PM -0400, Mikulas Patocka wrote:
> > Hi
> > 
> > This is a patch for dm-bufio.
> 
> I've merged all I'm going to at this point and pushed to thin-dev.

I think Alasdair currently holds the master version of this code. Or is it 
you? If we had three versions of the same code and don't know which one is 
the master, then there is a problem.

Mikulas

> If you put together a patch for the cond_resched stuff I'll take that;
> providing you don't call it in a tight loop like here:
> 
> > @@ -758,8 +772,9 @@ static struct dm_buffer *__find(struct d
> >  	struct dm_buffer *b;
> >  	struct hlist_node *hn;
> >  	hlist_for_each_entry(b, hn, &c->cache_hash[DM_BUFIO_HASH(block)], hash_list) {
> > -		if (b->block == block)
> > +		if (likely(b->block == block))
> >  			return b;
> > +		dm_bufio_cond_resched();
> >  	}
> 
> 
> I'm not really interested in the likely/unlikely annotations.
> 
> - Joe
> 
