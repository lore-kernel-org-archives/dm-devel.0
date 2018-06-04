From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git pull] device mapper changes for 4.18
Date: Mon, 4 Jun 2018 12:09:27 -0700
Message-ID: <CA+55aFy1L9FwoahMdVtvSpZi2EpzD4_hbM++XxhfnUr2aRuoQQ@mail.gmail.com>
References: <20180604153254.GA4793@redhat.com>
	<CA+55aFyZk6Yeo0DSdakROxXRPvx9HWutbP1TwfoFd6fi-1FSUw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CA+55aFyZk6Yeo0DSdakROxXRPvx9HWutbP1TwfoFd6fi-1FSUw@mail.gmail.com>
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

On Mon, Jun 4, 2018 at 11:54 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> The swait interface is pure and utter garbage, and I thought we
> already agreed to just have a big comment telling people not to use
> them.
>
> That seems to not have happened.

.. oh, actually it did, but it was apparently too subtle.

See commit 88796e7e5c45 ("sched/swait: Document it clearly that the
swait facilities are special and shouldn't be used"), which has pretty
strong language in the commit message, but the strong language never
really made it into the comments, which are much more subtle.

I added more strongly worded comments. Maybe somebody will even read them.

                Linus
