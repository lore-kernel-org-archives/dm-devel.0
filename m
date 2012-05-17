From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm thin: commit pool's metadata on last
 close of thin device
Date: Wed, 16 May 2012 20:43:10 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1205162033500.12442@file.rdu.redhat.com>
References: <1337206793-30658-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1337206793-30658-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: Edward Thornber <thornber@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids



On Wed, 16 May 2012, Mike Snitzer wrote:

> Reinstate dm_flush_all and dm_table_flush_all.  dm_blk_close will
> now trigger the .flush method of all targets within a table on the last
> close of a DM device.
> 
> In the case of the thin target, the thin_flush method will commit the
> backing pool's metadata.
> 
> Doing so avoids a deadlock that has been observed with the following
> sequence (as can be triggered via "dmsetup remove_all"):
> - IO is issued to a thin device, thin device is closed
> - pool's metadata device is suspended before the pool is
> - because the pool still has outstanding IO we deadlock because the
>   pool's metadata device is suspended
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> Cc: stable@vger.kernel.org

I'd say --- don't do this sequence.

Device mapper generally expects that devices are suspended top-down --- 
i.e. you should first suspend the thin device and then suspend its 
underlying data and metadata device. If you violate this sequence and 
suspend bottom-up, you get deadlocks.

For example, if dm-mirror is resynchronizing and you suspend the 
underlying leg or log volume and then suspend dm-mirror, you get a 
deadlock.

If dm-snapshot is merging and you suspend the underlying snapshot or 
origin volume and then suspend snapshot-merget target, you get a deadlock.

These are not bugs in dm-mirror or dm-snapshot, this is expected behavior. 
Userspace shouldn't do any bottom-up suspend sequence.

In the same sense, if you suspend the underlying data or metadata pool and 
then suspend dm-thin, you get a deadlock too. Fix userspace so that it 
doesn't do it.

Mikulas
