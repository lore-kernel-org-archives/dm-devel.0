From: Anatol Pomozov <anatol.pomozov@gmail.com>
Subject: Re: [PATCH 1/2] Revert "Revert "math64: New div64_u64_rem helper""
Date: Wed, 4 Sep 2013 09:11:25 -0700
Message-ID: <CAOMFOmXhoBoFrkr8bgP5qV-jZXA=6ZfXnSsg1j5fEVv_RgRAyw@mail.gmail.com>
References: <1376078164-23147-1-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1376078164-23147-1-git-send-email-snitzer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, LKML <linux-kernel@vger.kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, Stanislaw Gruszka <sgruszka@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>
List-Id: dm-devel.ids

Hi,

On Fri, Aug 9, 2013 at 12:56 PM, Mike Snitzer <snitzer@redhat.com> wrote:
> This reverts commit f3002134158092178be81339ec5a22ff80e6c308.
>
> div64_u64_rem was removed because there were no other users.

In the light of this discussion https://lkml.org/lkml/2013/8/30/417 we
will have more users of div64_u64_rem

For example code from ext4_mb_find_by_goal() function uses function
do_div() with divisor sbi->s_stripe that has "unsigned long" type.
do_div() silently truncates the type to 32bits and do_div() returns
incorrect result (or crash if lower 32bits are zero). It should be
either replaced with div64_u64_rem() posted here or with just "a % b".
