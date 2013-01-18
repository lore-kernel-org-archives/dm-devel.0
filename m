From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: dm-integrity: integrity protection device-mapper target
Date: Fri, 18 Jan 2013 23:16:33 +0000
Message-ID: <20130118231633.GM27585@agk-dp.fab.redhat.com>
References: <Pine.LNX.4.64.1301151955280.7468@file.rdu.redhat.com> <CALLzPKZVo3ng=Hz4cg0qrw0nDYsPjKy5AR=AJtMg+3PU=epz1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALLzPKZVo3ng=Hz4cg0qrw0nDYsPjKy5AR=AJtMg+3PU=epz1w@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, dm-devel@redhat.com, alan.cox@intel.com, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Fri, Jan 18, 2013 at 11:43:34PM +0200, Kasatkin, Dmitry wrote:
> This patch I sent out has one missing feature what I have not pushed yet.
> In the case of non-matching blocks, it just zeros blocks and returns
> no error (zero-on-mismatch).
> Writing to the block replaces the hmac.
> It works quite nicely. mkfs and fsck is able to read and write/fix the
> filesystem.
> In normal environment, if fsck crashes, it might corrupt file system
> in the same way.
> zero-on-mismatch makes block device still accessible/fixable for fsck.
 
I'm afraid I don't buy that.

We can hardly call this "integrity" if it's designed to lose some of
your data when the machine crashes - and worse - it doesn't tell you
what you lost, but just gives you blocks of zeroes instead!

I think a redesign is needed before this goes upstream.

Alasdair

