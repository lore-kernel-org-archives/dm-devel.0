From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: dm-bufio: avoid false-positive Wmaybe-uninitialized warning
Date: Tue, 6 Mar 2018 22:33:46 +0100
Message-ID: <CAK8P3a1jpj0ZCs81YJu0Dx3QFSypQ+VBr348UfEaagcuvM_1gA@mail.gmail.com>
References: <20180222155627.1800948-1-arnd@arndb.de> <20180222160432.GA16971@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180222160432.GA16971@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Ingo Molnar <mingo@kernel.org>, Aliaksei Karaliou <akaraliou.dev@gmail.com>, Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>, Dan Carpenter <dan.carpenter@oracle.com>, Mark Rutland <mark.rutland@arm.com>, Eric Biggers <ebiggers@google.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>
List-Id: dm-devel.ids

On Thu, Feb 22, 2018 at 5:04 PM, Mike Snitzer <snitzer@redhat.com> wrote:
> On Thu, Feb 22 2018 at 10:56am -0500,
> Arnd Bergmann <arnd@arndb.de> wrote:

>
> Mikulas already sent a fix for this:
> https://patchwork.kernel.org/patch/10211631/
>
> But I like yours a bit better, though I'll likely move the declaration
> of 'noio_flag' temporary inside the conditional.
>
> Anyway, I'll get this fixed up shortly, thanks.

I see the fix made it into linux-next on the same day, but the build bots still
report the warning for mainline kernels and now also for stable kernels
that got a backport of the patch that introduced it on arm64.

I assume you had not planned to send it for mainline, any chance you
could change that and send it as a bugfix with a 'Cc:
stable@vger.kernel.org' tag to restore a clean build?

       Arnd
