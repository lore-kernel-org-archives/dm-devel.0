From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 0/7] dm-mpath: Do not clone requests
Date: Thu, 5 Jun 2014 06:36:26 -0700
Message-ID: <20140605133626.GA7149@infradead.org>
References: <1401973867-121561-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1401973867-121561-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Oh, you're not even cloning the request.  I though you'd just avoid
cloning the bios.  Passing the requests through isn't going to work
when sitting on top of a blk-mq driver.

I have a queue I'm trying to start to test now that approaches this
a little bit differently:

 - request based dm is converted to use blk-mq itself, allowing us to
   allocate private data as part of the incoming request, and gets
   rid of the nasty prep_fn/request_fn split
 - it then just allocates a new request on the underlying device after
   chosing the path.  By using blk_get_request to allocate the lower
   request dm-mpath doesn't care if the underlying device uses blk-mq
   or not.

As said I'm already running into issues with plain dm mpath in my
trivial test setup, so this is stalled for the moment.

But I'd still love to understand why dm even bothers cloning the bios.
At the request layer we only touch the bios in two places: first
for merging in into the request, and second in blk_update_request.

Now with dm-mpath we'd never want to do this sort of merging for the
lower request anyway, and I don't see a real problem keeting the lower
driver complete the bio and just never call blk_update_request in
dm-mpath either.  At least that's my impression that hasn't made contact
with the ugly reality yet..
