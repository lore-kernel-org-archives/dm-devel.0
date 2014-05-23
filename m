From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] dm thin: return ENOSPC instead of EIO
 when error_if_no_space enabled
Date: Fri, 23 May 2014 16:52:38 -0400
Message-ID: <20140523205237.GA16191@redhat.com>
References: <1400782364-6537-1-git-send-email-snitzer@redhat.com>
	<20140522183250.GA7799@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20140522183250.GA7799@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: sandeen@redhat.com, ejt@redhat.com
List-Id: dm-devel.ids

On Thu, May 22 2014 at  2:32pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> Update the DM thin provisioning target's allocation failure error to be
> consistent with commit a9d6ceb8 ("[SCSI] return ENOSPC on thin
> provisioning failure").
> 
> The DM thin target now returns -ENOSPC rather than -EIO when
> block allocation fails due to the pool being out of data space (and
> the 'error_if_no_space' thin-pool feature is enabled).
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  drivers/md/dm-bio-prison.c |    4 ++--
>  drivers/md/dm-bio-prison.h |    2 +-
>  drivers/md/dm-thin.c       |   35 +++++++++++++++++++++++------------
>  3 files changed, 26 insertions(+), 15 deletions(-)
> 
> v2: update other should_error_unserviceable_bio() callers and dm_cell_error()

Noticed a leak introduced with my v2, but I've now staged what could be
considered v3 in linux-next via linux-dm.git 'for-next' branch, see:

https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=5d7d20909130de87ae4bccee0c9e92105eb7c886
