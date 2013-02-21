From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH linux-next] DM RAID:
	validate_raid_redundancy: Silence uninitialized variable warning
Date: Thu, 21 Feb 2013 13:19:31 +0000
Message-ID: <20130221131931.GA29577@agk-dp.fab.redhat.com>
References: <1361392278-59767-1-git-send-email-tim.gardner@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1361392278-59767-1-git-send-email-tim.gardner@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tim Gardner <tim.gardner@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, Feb 20, 2013 at 01:31:18PM -0700, Tim Gardner wrote:
> drivers/md/dm-raid.c: In function 'raid_ctr':
> drivers/md/dm-raid.c:453:53: warning: 'rebuilds_per_group' may be used uninitialized in this function [-Wuninitialized]
> drivers/md/dm-raid.c:383:11: note: 'rebuilds_per_group' was declared here
 
> It appears unlikely that rebuilds_per_group could be used before set, but set
> it to 0 anyways just to shutup GCC.

Looks bogus to me.
uninitialized_var() please.

Alasdair
