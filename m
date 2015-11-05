From: Milan Broz <mbroz@redhat.com>
Subject: Re: [PATCH 0/4] dm verity: add support for error correction
Date: Thu, 5 Nov 2015 08:34:04 +0100
Message-ID: <563B066C.6050202@redhat.com>
References: <1446688954-29589-1-git-send-email-samitolvanen@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1446688954-29589-1-git-send-email-samitolvanen@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sami Tolvanen <samitolvanen@google.com>
Cc: device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Mandeep Baines <msb@chromium.org>, Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>, Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mark Salyzyn <salyzyn@google.com>
List-Id: dm-devel.ids

On 11/05/2015 03:02 AM, Sami Tolvanen wrote:
> This patch set adds error correction support to dm-verity, which
> makes it possible to recover from data corruption in exchange of
> increased space overhead.
> 
> The feature is implemented as part of dm-verity to take advantage
> of the existing hash tree to improve performance and locate known
> erasures.

Hi,

could you please elaborate why is all this needed? To extend support
of some faulty flash chips?

Do you have some statistics that there are really such correctable errors
in real devices?

Anyway, I really do not understand layer separation here. Either we have
cryptographically strong data integrity checking or we have
error-correction. Are we sure this combination does not create some unintended
gap in integrity checking? Why the integrity check should even try to do some
error correction if there is an intentional integrity attack?

IMO if you need an error correction, this should be placed as a separate
layer below the crypto integrity check, the same as RAID operates.

The second question - why are you writing another separate tool
for maintenance for dm-verity when there is veritysetup?

Milan
