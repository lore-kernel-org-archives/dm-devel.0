From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm-thinp bug
Date: Wed, 27 Apr 2011 10:23:40 +0100
Message-ID: <1303896220.4679.54.camel@ubuntu>
References: <20110426184742.GA13880@infradead.org>
	<1303892857.4679.2.camel@ubuntu> <20110427083917.GA23330@infradead.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110427083917.GA23330@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@infradead.org>
Cc: dm-devel@redhat.com, ejt@redhat.com
List-Id: dm-devel.ids

On Wed, 2011-04-27 at 04:39 -0400, Christoph Hellwig wrote:
> On Wed, Apr 27, 2011 at 09:27:37AM +0100, Joe Thornber wrote:
> > On Tue, 2011-04-26 at 14:47 -0400, Christoph Hellwig wrote:
> > > I can reproduce a bug in virtio triggered by running under dm-thinp by
> > > just copying lots of files from my home directory into a freshly created
> > > filesystem on dm-thinp.
> > 
> > Finally someone has tried using it!  I'll look into this today.
> 
> I actually used the earlier version you posted and didn't reproduce it
> there.  I have a gut feeling it's related to barriers, as I probably
> just did a basic ext3 test back then.

I hope this isn't the case.

> 
> One thing that springs to mind is that both the thinp and multisnap
> targets don't appear to support empty barriers (that is REQ_FLUSH
> without a payload), because they don't set ti->num_flush_requests, but
> I'm not sure that's related.

Fixed in thinp and multisnap public repos.

- Joe
