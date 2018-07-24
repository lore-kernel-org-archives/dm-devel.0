From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [git pull] device mapper fix for 4.18-rc6
Date: Tue, 24 Jul 2018 11:18:54 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1807241108340.2382@file01.intranet.prod.int.rdu2.redhat.com>
References: <20180720191407.GA11868@redhat.com>
	<CA+55aFxGp1oh6hYuJVkRKXEaD-F2-qYUYgrerhxqwBTeeAqdxA@mail.gmail.com>
	<20180720224046.GA12929@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180720224046.GA12929@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: David Teigland <teigland@redhat.com>, dm-devel@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: dm-devel.ids



On Fri, 20 Jul 2018, Mike Snitzer wrote:

> On Fri, Jul 20 2018 at  5:25pm -0400,
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Fri, Jul 20, 2018 at 12:14 PM Mike Snitzer <snitzer@redhat.com> wrote:
> > >
> > >   Fix DM writecache target to allow an optional offset to the start of
> > >   the data and metadata area.  This allows userspace tools (e.g. LVM2)
> > >   to place a header and metadata at the front of the writecache device
> > >   for its use.
> > 
> > "fix"?
> > 
> > Not really.
> 
> I hold it to be a "fix" because it was an embarassing oversight on my
> part.  Without this, userspace support cannot be properly added.  LVM2
> developers raised their inability to put their metadata anywhere and I
> was like "oh shit".

This is not oversight.

It was originally planned that the dm-writecache target would use lvm 
metadata just like the dm-cache target - if it were implemented this way, 
no "offset" argument would be needed. But David Teigland who was given the 
task to implement dm-writecache support in lvm refused to do it this way 
and he insists that he must put some of his own metadata at the beginning 
of the cache device before the superblock.

So this patch is needed because of him.

Mikulas
