From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm raid: avoid busy error on scrubbing message
Date: Tue, 18 Dec 2018 14:50:20 -0500
Message-ID: <20181218195020.GC24676@redhat.com>
References: <94d065d1aa09b9151280a0fd34502ac335e1ac3e.1545150818.git.heinzm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <94d065d1aa09b9151280a0fd34502ac335e1ac3e.1545150818.git.heinzm@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Heinz Mauelshagen <heinzm@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Dec 18 2018 at 11:35am -0500,
Heinz Mauelshagen <heinzm@redhat.com> wrote:

> Sending a check/repair message infrequently leads to -EBUSY
> as oposed to identifying an active resync properly.
> Cause is raid_message() testing recovery bits in a racy way.
> 
> Fix by calling decipher_sync_action() from raid_message()
> to identify the idle state of the RAID device properly.
> 
> Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>

Applied:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.21&id=74694bcbdf7e28a5ad548cdda9ac56d30be00d13

Thanks,
Mike
