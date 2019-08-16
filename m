From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm dust: use dust blksz for badblocklist index
Date: Fri, 16 Aug 2019 10:45:26 -0400
Message-ID: <20190816144526.GA2468@redhat.com>
References: <1565964593-13195-1-git-send-email-bgurney@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1565964593-13195-1-git-send-email-bgurney@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bryan Gurney <bgurney@redhat.com>
Cc: dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On Fri, Aug 16 2019 at 10:09am -0400,
Bryan Gurney <bgurney@redhat.com> wrote:

> Change the "frontend" dust_remove_block, dust_add_block, and
> dust_query_block functions to store the "dust block number", instead
> of the sector number corresponding to the "dust block number"
> 
> For the "backend" functions dust_map_read and dust_map_write,
> right-shift by sect_per_block_shift.  This fixes the inability
> to emulate failure beyond the first sector of each "dust block",
> for devices with a "dust block size" larger than 512 bytes.
> 
> Signed-off-by: Bryan Gurney <bgurney@redhat.com>

Thanks, I tweaked the header very slightly and staged it in linux-next
for 5.4 via linux-dm.git.

Mike
