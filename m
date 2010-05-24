From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v3 3/3] dm: lookup devices by path with
	name_to_dev_t
Date: Mon, 24 May 2010 12:57:37 +0100
Message-ID: <20100524115737.GY3991@agk-dp.fab.redhat.com>
References: <1274294304-30606-1-git-send-email-wad@chromium.org> <1274294304-30606-3-git-send-email-wad@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1274294304-30606-3-git-send-email-wad@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Will Drewry <wad@chromium.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, snitzer@redhat.com
List-Id: dm-devel.ids

On Wed, May 19, 2010 at 01:38:24PM -0500, Will Drewry wrote:
> +	char base_path[32];  /* size from name_to_dev_t */
  
> +	/* stage the shorter path for name_to_dev_t. */
> +	strncpy(base_path, path, sizeof(base_path));

I'm dropping that, and just passing path directly, so the strlen test
will be used.  (There's a "name += 5" in there so 32 would ignore
any longer standard names anyway.)

Alasdair
