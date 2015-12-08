From: Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH v2 0/2] dm verity: add support for error correction
Date: Tue, 8 Dec 2015 10:18:14 +0000
Message-ID: <20151208101814.GA9762@google.com>
References: <1449152791-33586-1-git-send-email-samitolvanen@google.com>
 <20151203195401.GA5444@redhat.com>
 <20151203230538.GB5444@redhat.com>
 <20151204100305.GA37949@google.com>
 <20151204210935.GA63877@redhat.com>
 <20151207132149.GA7583@google.com>
 <20151207145814.GB29457@redhat.com>
 <20151207163108.GA21472@google.com>
 <5665CAD5.9000704@redhat.com>
 <20151207190743.GA30593@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151207190743.GA30593@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Milan Broz <mbroz@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Mandeep Baines <msb@chromium.org>, Will Drewry <wad@chromium.org>, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, Mark Salyzyn <salyzyn@google.com>
List-Id: dm-devel.ids

On Mon, Dec 07, 2015 at 02:07:43PM -0500, Mike Snitzer wrote:
> I'm not seeing any verification of the metadata in fec_read_parity() --
> so it would seem that corrupt RS blocks would result in -EBADMSG being
> returned from decode_rs8() (by virtue of incorrect parity being passed
> to decode_rs8).
> 
> Sami (or others) am I right?

Yes, decode_rs8 failing with -EBADMSG is one option. There are also two
other cases:

 1) If the parity data is only partially corrupted, it may still be
    possible to correct errors, provided that the actual data isn't
    too severely corrupted.

 2) If there's too much corruption for Reed-Solomon to detect, it's
    also possible that decode_rs8 just returns bogus data, which we
    will catch when verifying the hash again. This is why combining
    error correction with integrity checking is essential.

In other words, the worst case is that we cannot correct errors for the
blocks covered by the corrupted parity data.

Sami
