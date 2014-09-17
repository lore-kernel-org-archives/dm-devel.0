From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] fix mirror device creation with
	lvcreate	failed
Date: Wed, 17 Sep 2014 12:41:52 +0100
Message-ID: <20140917114151.GF2407@agk-dp.fab.redhat.com>
References: <1409127505-5246-1-git-send-email-lwang@suse.com>
	<20140916232104.GC2407@agk-dp.fab.redhat.com>
	<54198887020000A00000CFC2@soto.provo.novell.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <54198887020000A00000CFC2@soto.provo.novell.com>
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
Cc: Neil F Brown <NFBrown@suse.com>, dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Sep 16, 2014 at 11:11:35PM -0600, Liuhua Wang wrote:
> There are error messages:
> ---------------------
> [22798.077877] end_request: I/O error, dev dasdd, sector 2240
> [22798.077902] device-mapper: raid: Failed to read superblock of device at position 1
> [23087.875420] type=1006 audit(1404313201.346:28): pid=1596 uid=0 old auid=4294967295 new auid=0 old ses=4294967295 new ses=27 res=1
> [23127.707296] dasd-eckd.d2bf98: 0.0.141d: ERP 0000000036ab1e40 has run out of retries and failed
> ----------------------
 
OK, so it sounds like Neil's patch will be enough to fix this.
Can you test that and confirm it solves the problem?

Alasdair
