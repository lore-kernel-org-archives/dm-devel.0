From: Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH 0/4] dm verity: add support for error correction
Date: Thu, 3 Dec 2015 09:33:48 +0000
Message-ID: <20151203093348.GB23048@google.com>
References: <1446688954-29589-1-git-send-email-samitolvanen@google.com>
 <563B066C.6050202@redhat.com>
 <20151105173306.GA22302@google.com>
 <20151109163735.GA28884@redhat.com>
 <20151109191925.GA29185@google.com>
 <alpine.LRH.2.02.1511121318110.15026@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1511121318110.15026@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Milan Broz <mbroz@redhat.com>, device-mapper development <dm-devel@redhat.com>, Mandeep Baines <msb@chromium.org>, Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mark Salyzyn <salyzyn@google.com>
List-Id: dm-devel.ids

On Thu, Nov 12, 2015 at 01:50:04PM -0500, Mikulas Patocka wrote:
> What flash controller and chips do you use?

Considering the number of different devices running Android, I don't
have a good answer for this. I'm guessing most of them.

> Is the silent data corruption permanent or transient?

Most of the corruption we have observed is permanent, and typically
caused by a write failure rather than a read failure. A while ago we
also discovered a bug in our kernels which resulted in unexpected
modification of read-only partitions and ended up causing quite a lot
of problems. While in an ideal world this wouldn't happen, in real
life it's better to have an additional layer of protection against
issues like these.

> Why can't you ask the hardware engineers to use a controler with
> proper error correction?

The most advanced hardware error correction I've seen only handles
errors within a single sector and cannot detect all possible
corruption, let alone correct it. If you have examples of hardware
with proper error correction, I would love to take a look. Of course,
if this is even $1-2 more expensive per device than the current
hardware, chances are it's not going to make the budget cut with many
device manufacturers, whether we like it or not.

> Without these data - it looks like you first wrote the patch and
> then tried to make some excuses why it should be accepted.

I posted the patches primarily to hear your feedback, not necessarily
to get them accepted. The only goal I have is to improve the
reliability of devices using dm-verity. This solution makes it
possible to recover from a large number of corrupted blocks with
a very small storage overhead and no additional CPU overhead when
the partition is not corrupted (and thus, no additional power
consumption). I can fully understand that these may not be important
concerns in other environments where one might just as well run raid5
over multiple dm-verity devices, as you suggested.

> I'm also a little bit concerned that the patch will increase
> prevalence of crapware on the market

We are already concerned about current devices that end up with
corrupted partitions for one reason or another. When an ecosystem
consists of more than 10^9 devices, if even a small fraction of them
are returned or need to be repaired due to a dm-verity failure,
it quickly becomes very expensive and actively discourages device
manufacturers from adopting dm-verity. This is not even considering
the number of people inconvenienced by these issues.

Sami
