From: Martijn Coenen <maco@android.com>
Subject: Re: dm-bufio: Allow clients to specify an upper bound on cache size.
Date: Tue, 10 Sep 2019 10:55:58 +0200
Message-ID: <CAB0TPYEb-WdggSj=i+tpABfkO9KFqcgMc0twMx0L=ZcAN4HDfw@mail.gmail.com>
References: <20190906074526.169194-1-maco@android.com> <20190909145703.GA16249@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190909145703.GA16249@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, agk@redhat.com, dm-devel@redhat.com, Dario Freni <dariofreni@google.com>, Jiyong Park <jiyong@google.com>, Greg KH <gregkh@linuxfoundation.org>, LKML <linux-kernel@vger.kernel.org>, Martijn Coenen <maco@google.com>, Nikita Ioffe <ioffe@google.com>, Narayan Kamath <narayan@google.com>, kernel-team@android.com
List-Id: dm-devel.ids

Hi Mike,

On Mon, Sep 9, 2019 at 4:57 PM Mike Snitzer <snitzer@redhat.com> wrote:
> Definitely not very intuitive.. but yes I think it is a reasonable
> tradeoff between your goals and further code complexity to be able to
> achieve the "ideal".

Thanks for the feedback. I do have a patch for the "optimal"
allocation lying around as well, if you'd like to take a look. It's
not as bad as I thought, but it does require another list_head in
dm_bufio_client; other than that it's just O(N), so not so bad.

> Think the documented example can be made clearer by documenting that
> dm_bufio_cache_size_per_client = 49.  And that _that_ is the reason why
> the client that didn't set a maximum is bounded to 49.

Ack, will send a v2 to clarify.

>
> Overall I think this patch looks reasonable, but I'd like Mikulas to
> review this closer before I pick it up.

Thanks; let me know if you want to see the alternative as an RFC, and
I'll clean it up and send it out.

Thanks,
Martijn

>
> Thanks,
> Mike
