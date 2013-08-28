From: Teng-Feng Yang <shinrairis@gmail.com>
Subject: Strange mapped block count kept by dm-thin driver for
	thin devices
Date: Wed, 28 Aug 2013 11:52:26 +0800
Message-ID: <CAKTMprNbFvezaSpAx7c2w2+qBzHp8dmJQLSeKEXfYtjSK5vGiw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
List-Id: dm-devel.ids

Hi,

I have already noticed that the mapped block count of thin devices
shown by "dmsetup status" looked unreasonable to me for a couple of
times in the last six months.
Sometimes the mapped block count was zero, but sometimes it was a
large number which was obviously larger than the total available
blocks in thin-pool.
So I dig into the source code, and I find some codes look suspicious to me.

In dm_pool_metadata_close() in dm-thin-metadata.c, it will try to
commit transaction for the last time before it destroys the
pmd(dm_pool_metadata).
However, it does not lock the pool_metadata before transaction commit,
which I am not really sure if we still need to acquire lock when it
reaches here.
I know that this function is mainly called when users try to remove
pool, but it seems like we can still have some on-the-fly transaction
commit when dm-thin module calls this function.
Although I would like to test it by myself, this problem occurs in
random and I am still trying to find a way to reproduce it
systematically.

Any help would be grateful.

Thanks

Dennis
