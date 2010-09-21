From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] virtio-blk: put request that was created to retrieve the
 device id
Date: Tue, 21 Sep 2010 17:00:33 -0400
Message-ID: <20100921210033.GA24729@infradead.org>
References: <20100909160324.GJ30086@us.ibm.com>
 <20100909175537.GA9589@redhat.com>
 <20100909183554.GK30086@us.ibm.com>
 <20100909191555.GA14486@redhat.com>
 <20100909194300.GA16908@redhat.com>
 <20100909201445.GA19656@redhat.com>
 <20100909203052.GL30086@us.ibm.com>
 <20100909210042.GA22092@redhat.com>
 <20100909211504.GA24506@infradead.org>
 <20100917145848.GK30086@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100917145848.GK30086@us.ibm.com>
Sender: kvm-owner@vger.kernel.org
To: Ryan Harper <ryanh@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, Tejun Heo <tj@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com, Vivek Goyal <vgoyal@redhat.com>, john.cooper@redhat.com, rusty@rustcorp.com.au, kvm@vger.kernel.org
List-Id: dm-devel.ids

On Fri, Sep 17, 2010 at 09:58:48AM -0500, Ryan Harper wrote:
> Since __bio_map_kern() sets up bio->bi_end_io = bio_map_kern_endio
> (which does a bio_put(bio)) doesn't that ensure we don't leak?

Indeed, that should take care of it.

