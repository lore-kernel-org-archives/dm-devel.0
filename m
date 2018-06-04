From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git pull] device mapper changes for 4.18
Date: Mon, 4 Jun 2018 11:54:53 -0700
Message-ID: <CA+55aFyZk6Yeo0DSdakROxXRPvx9HWutbP1TwfoFd6fi-1FSUw@mail.gmail.com>
References: <20180604153254.GA4793@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180604153254.GA4793@redhat.com>
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
Cc: Peter Zijlstra <peterz@infradead.org>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Jun 4, 2018 at 8:32 AM Mike Snitzer <snitzer@redhat.com> wrote:
>
> - Export 2 swait symbols for use by the new DM writecache target.

I am *EXTREMELY* unhappy with this.

The swait interface is pure and utter garbage, and I thought we
already agreed to just have a big comment telling people not to use
them.

That seems to not have happened.

The swait() interfaces are pure and utter garbage because they have
absolutely horrid semantics that are very different from normal
wait-queues, and there has never been any sign that the swait users
are actually valid.

In particular, existing users were using swait because of complete
garbage reasons, like the alleged "win" for KVM, which was just
because there was only ever one waiter anyway.

Is the new writecache usage really worth it?

Is it even *correct*?

As mentioned, swait semantics are completely buggy, with "swake_up()"
not at all approximating a normal wake-up. It only wakes *one* user,
so it's more like an exclusive waiter, except it ends up alway
sassuming that every waiter is exclusive without any actual marker for
that.

End result: the interface has some very subtle races, and I'm not at
all convinced that the new writecache code is aware of this.

In particular, I see what appears to be a bug in writecache_map(): it
does a writecache_wait_on_freelist(), but it doesn't actually
guarantee that it will then use the slot that it was woken up for (it
just does a "continue", which might instead do a
writecache_find_entry().

So *another* thread that was waiting for a slot will now not be woken
up, and the thread that *was* woken up didn't actually use the
freelist entry that it was waiting for.

This is *EXACTLY* the kind of code that should not use swait lists.
It's buggy, and broken. And it probably works in 99% of all cases by
pure luck, so it's hard to debug too.

In other words: I'm not pulling this shit. I want people to be *VERY*
aware of how broken swait queues are. You are *not* to use them unless
you understand them, and I have yet to find a single person who does.

No way in hell are we exporting that shit.

                   Linus
