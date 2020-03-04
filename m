From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git pull] device mapper fixes for 5.6-rc5
Date: Wed, 4 Mar 2020 13:06:55 -0600
Message-ID: <CAHk-=wgP=q648JXn8Hd9q7DuNaOEpLmxQp2W3RO3vkaD2CS_9g@mail.gmail.com>
References: <20200304150257.GA19885@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200304150257.GA19885@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, linux-block <linux-block@vger.kernel.org>, Alasdair G Kergon <agk@redhat.com>, Hou Tao <houtao1@huawei.com>, Mikulas Patocka <mpatocka@redhat.com>, Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Theodore Ts'o <tytso@mit.edu>
List-Id: dm-devel.ids

On Wed, Mar 4, 2020 at 9:03 AM Mike Snitzer <snitzer@redhat.com> wrote:
>
> - Bump the minor version for DM core and all target versions that have
>   seen interface changes or important fixes during the 5.6 cycle.

Can we please remove these pointless version markers entirely?

They make no sense. The kernel doesn't allow backwards incompatible
changes anyway, so the whole point of using some kind of interface
versioning is entirely bogus.

The way you test if a new feature exists or not is to just use it, and
if you're running on an old kernel that doesn't support that
operation, then it should return an error.

             Linus
