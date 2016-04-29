From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-raid: check for zero feature flags in metadata
Date: Fri, 29 Apr 2016 15:18:36 -0400
Message-ID: <20160429191835.GA22007@redhat.com>
References: <1461949196-17999-1-git-send-email-heinzm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1461949196-17999-1-git-send-email-heinzm@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: heinzm@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Apr 29 2016 at 12:59pm -0400,
heinzm@redhat.com <heinzm@redhat.com> wrote:

> From: Heinz Mauelshagen <heinzm@redhat.com>
> 
> Because we don't support any feature flags in the dm-raid ondisk
> metadata yet (see struct dm_raid_superblock, 'features' member), 
> this patch adds a check to ensure no flags are actually set or
> reject the activation of the RAID mapping.
> 
> This is to prevent possible data corruption in case of a
> kernel downgrade when there'll potentially be feature flags
> set by a future dm-raid target.
> 
> 
> Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>

merged for 4.7, see:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.7&id=480375cd7ea3eed60381539dbfa96851b6174820
