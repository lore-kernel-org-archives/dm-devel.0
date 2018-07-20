From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git pull] device mapper fix for 4.18-rc6
Date: Fri, 20 Jul 2018 14:25:56 -0700
Message-ID: <CA+55aFxGp1oh6hYuJVkRKXEaD-F2-qYUYgrerhxqwBTeeAqdxA@mail.gmail.com>
References: <20180720191407.GA11868@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180720191407.GA11868@redhat.com>
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
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Fri, Jul 20, 2018 at 12:14 PM Mike Snitzer <snitzer@redhat.com> wrote:
>
>   Fix DM writecache target to allow an optional offset to the start of
>   the data and metadata area.  This allows userspace tools (e.g. LVM2)
>   to place a header and metadata at the front of the writecache device
>   for its use.

"fix"?

Not really.

But I'm a softie, and I took it. Don't do it again.

              Linus
