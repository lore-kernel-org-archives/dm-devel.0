From: David Teigland <teigland@redhat.com>
Subject: Re: [git pull] device mapper fix for 4.18-rc6
Date: Tue, 24 Jul 2018 10:30:55 -0500
Message-ID: <20180724153055.GA12605@redhat.com>
References: <20180720191407.GA11868@redhat.com>
	<CA+55aFxGp1oh6hYuJVkRKXEaD-F2-qYUYgrerhxqwBTeeAqdxA@mail.gmail.com>
	<20180720224046.GA12929@redhat.com>
	<alpine.LRH.2.02.1807241108340.2382@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1807241108340.2382@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: dm-devel@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Tue, Jul 24, 2018 at 11:18:54AM -0400, Mikulas Patocka wrote:
> > I hold it to be a "fix" because it was an embarassing oversight on my
> > part.  Without this, userspace support cannot be properly added.  LVM2
> > developers raised their inability to put their metadata anywhere and I
> > was like "oh shit".
> 
> This is not oversight.
> 
> It was originally planned that the dm-writecache target would use lvm 
> metadata just like the dm-cache target - if it were implemented this way, 
> no "offset" argument would be needed. But David Teigland who was given the 
> task to implement dm-writecache support in lvm refused to do it this way 
> and he insists that he must put some of his own metadata at the beginning 
> of the cache device before the superblock.
> 
> So this patch is needed because of him.

Mikulas, an offset would have been useful while I was experimenting with
dm-writecache.  I don't actually use or need the offset in lvm.  I don't
think it's a bad idea, but I don't care.

Dave
