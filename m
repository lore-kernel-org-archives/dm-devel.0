From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v3 3/3] dm: lookup devices by path with
	name_to_dev_t
Date: Mon, 24 May 2010 12:38:16 +0100
Message-ID: <20100524113815.GX3991@agk-dp.fab.redhat.com>
References: <1274294304-30606-1-git-send-email-wad@chromium.org> <1274294304-30606-3-git-send-email-wad@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1274294304-30606-3-git-send-email-wad@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Will Drewry <wad@chromium.org>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, snitzer@redhat.com
List-Id: dm-devel.ids

On Wed, May 19, 2010 at 01:38:24PM -0500, Will Drewry wrote:
> Replace major:minor parsing with name_to_dev_t.  This
> maintains the current functionality (as the code was the same),
> but adds support for the hexadecimal dev as well as device lookup
> before the root filesystem is available.  The latter is the motivation
> for this change.
> 
> It still falls back to lookup_bdev() for cases where the inode
> on disk provides more information than the name (and the path exceeds
> the length handled by name_to_dev_t).
 
I'll apply this, but anyone debugging problems in future should note the
functional change here: the standard in-kernel device names will now take
precedence over the inodes in /dev if the two don't match and this might
confuse people.  As it's technically an interface change, I'll bump
the version number so userspace can detect this if it ever needs to.

Alasdair
