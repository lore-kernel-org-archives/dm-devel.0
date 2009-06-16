From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 1/6] dm raid45 target: export region hash
	functions and add a needed one
Date: Wed, 17 Jun 2009 08:46:28 +1000
Message-ID: <19000.8388.899607.749942@notabene.brown>
References: <4a368301.KBrCZcokAm87BF/S%heinzm@redhat.com>
	<20090616140914.GA3348@infradead.org>
	<1245163906.28257.113.camel@o>
	<e9c3a7c20906161055g6434ffd8uc7fc1ca53950556@mail.gmail.com>
	<1245179467.4278.11.camel@o>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: message from Heinz Mauelshagen on Tuesday June 16
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: heinzm@redhat.com
Cc: Christoph Hellwig <hch@infradead.org>, Dan Williams <dan.j.williams@intel.com>, device-mapper development <dm-devel@redhat.com>, Ed Ciechanowski <ed.ciechanowski@intel.com>
List-Id: dm-devel.ids

On Tuesday June 16, heinzm@redhat.com wrote:
> 
> That being said: once the future work on a unified virtual block device
> infrastructure is production ready, we're open to use that.
> 

I was kind-a hoping that you (and others) would be involved in
developing this unified infrastructure, rather than just waiting for
it.

I think a great first step would be to allow md/raid5 to be used
directly as a dm target, thus turning dm-raid5 into a shim layer over
md/raid5.  The process of doing this would very likely highlight a
lot of the issues we would need to address in creating a unified
framework.

I will try to find time to review your dm-raid5 code with a view to
understanding how it plugs in to dm, and then how the md/raid5 engine
can be used by dm-raid5.

Part of this will be disconnecting the md/raid5 code from any specific
knowledge of a gendisk and a request_queue as I suppose a dm-target
doesn't own any of these.  Also I would probably want the mddev not be
have to be on the "all_mddevs" list, as we would not want a 'dm' raid5
to appear in /proc/mdstat.

NeilBrown
