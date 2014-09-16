From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] fix mirror device creation with
	lvcreate	failed
Date: Wed, 17 Sep 2014 00:40:08 +0100
Message-ID: <20140916234008.GE2407@agk-dp.fab.redhat.com>
References: <1409127505-5246-1-git-send-email-lwang@suse.com>
	<20140916232104.GC2407@agk-dp.fab.redhat.com>
	<20140916233529.GD2407@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20140916233529.GD2407@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Liuhua Wang <lwang@suse.com>
Cc: nfbrown@suse.com, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Sep 17, 2014 at 12:35:29AM +0100, Alasdair G Kergon wrote:
> > > -	ret = read_disk_sb(rdev, rdev->sb_size);

And if that needed changing to 4096, why does this similar instance elsewhere
one not also need changing?

  static void attempt_restore_of_faulty_devices(struct raid_set *rs)
  {
  ...
                    sync_page_io(r, 0, r->sb_size, r->sb_page, READ, 1)) {

Alasdair
