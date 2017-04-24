From: Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH] dm verity: deferred hash checking for restart/logging
 mode
Date: Mon, 24 Apr 2017 08:54:08 -0700
Message-ID: <20170424155408.GA60835@samitolvanen.mtv.corp.google.com>
References: <1493019260-43938-1-git-send-email-bongkyu.kim@lge.com>
 <76b0b4ab-f811-7c8e-c88c-1210a0e67119@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <76b0b4ab-f811-7c8e-c88c-1210a0e67119@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <gmazyland@gmail.com>
Cc: Bongkyu Kim <bongkyu.kim@lge.com>, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, shli@kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Will Drewry <wad@chromium.org>
List-Id: dm-devel.ids

On Mon, Apr 24, 2017 at 10:05:03AM +0200, Milan Broz wrote:
> Isn't one of the goal of integrity checking to PREVENT that userspace
> accesses tampered data?

Absolutely. It's not acceptable for dm-verity to return unverified data
to userspace in restart mode.

Sami
