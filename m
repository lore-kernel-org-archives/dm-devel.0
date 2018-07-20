From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [git pull] device mapper fix for 4.18-rc6
Date: Fri, 20 Jul 2018 18:40:46 -0400
Message-ID: <20180720224046.GA12929@redhat.com>
References: <20180720191407.GA11868@redhat.com>
	<CA+55aFxGp1oh6hYuJVkRKXEaD-F2-qYUYgrerhxqwBTeeAqdxA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CA+55aFxGp1oh6hYuJVkRKXEaD-F2-qYUYgrerhxqwBTeeAqdxA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Fri, Jul 20 2018 at  5:25pm -0400,
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, Jul 20, 2018 at 12:14 PM Mike Snitzer <snitzer@redhat.com> wrote:
> >
> >   Fix DM writecache target to allow an optional offset to the start of
> >   the data and metadata area.  This allows userspace tools (e.g. LVM2)
> >   to place a header and metadata at the front of the writecache device
> >   for its use.
> 
> "fix"?
> 
> Not really.

I hold it to be a "fix" because it was an embarassing oversight on my
part.  Without this, userspace support cannot be properly added.  LVM2
developers raised their inability to put their metadata anywhere and I
was like "oh shit".

Not much point releasing the DM kernel code if it cannot be properly
tied into a volume manager for persistent use across boots, etc.

> But I'm a softie, and I took it. Don't do it again.

Considering dm-writecache was merged for 4.18 I think it important to
get it right.  So thankfully you've chosen wisely ;)

But I certainly sat on this change for a couple rc releases, should've
gotten it to you a couple weeks ago.

Thanks,
Mike
