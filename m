From: Tahsin Erdogan <tahsin@google.com>
Subject: Re: dm: free io_barrier after blk_cleanup_queue call
Date: Mon, 10 Oct 2016 07:52:05 -0700
Message-ID: <CAAeU0aMcaaMehJ31ANVFrwrC7YiCLW1dPosNujFtNyG9nOcC+g@mail.gmail.com>
References: <1476102919-25112-1-git-send-email-tahsin@google.com> <20161010132542.GA17958@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161010132542.GA17958@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon, Oct 10, 2016 at 6:25 AM, Mike Snitzer <snitzer@redhat.com> wrote:
> I have to believe this was born out of code inspection rather than
> actual need (due to crash, etc)?

This got originated from several crashes I have seen with 4.3 kernel.
The crashes
were caused by null dereferencing of io_barrier->per_cpu_ref.

The issue may no longer be relevant after commit c91852ff0815
("dm: optimize dm_request_fn()") because conditions for accessing
io_barrier may not longer exist. But fix should be considered for
forked stable trees.
