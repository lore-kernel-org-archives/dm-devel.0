From: Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH v2 0/2] dm verity: add support for error correction
Date: Mon, 7 Dec 2015 16:31:08 +0000
Message-ID: <20151207163108.GA21472@google.com>
References: <1446688954-29589-1-git-send-email-samitolvanen@google.com>
 <1449152791-33586-1-git-send-email-samitolvanen@google.com>
 <20151203195401.GA5444@redhat.com>
 <20151203230538.GB5444@redhat.com>
 <20151204100305.GA37949@google.com>
 <20151204210935.GA63877@redhat.com>
 <20151207132149.GA7583@google.com>
 <20151207145814.GB29457@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151207145814.GB29457@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mandeep Baines <msb@chromium.org>, Will Drewry <wad@chromium.org>, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, Mark Salyzyn <salyzyn@google.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Mon, Dec 07, 2015 at 09:58:14AM -0500, Mike Snitzer wrote:
> Great.  Moving forward it'd be awesome if you could work to get your
> verity FEC support regression tests into cryptsetup's tests.

Sure. These tests would basically involve generating a valid disk
image, corrupting it up to the theoretical maximum, and verifying that
dm-verity can correct it.

> Also, I know you said you'd be getting Milan a veritysetup patch soon.
> How are things going on that?

I'm still planning to have a patch for him this week.

Sami
