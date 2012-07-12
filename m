From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH v2] DM RAID: Add support for MD RAID10
Date: Thu, 12 Jul 2012 10:56:24 +0100
Message-ID: <20120712095624.GD2095@agk-dp.fab.redhat.com>
References: <1342057001.22214.6.camel@f16> <20120712163207.222b4bcc@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120712163207.222b4bcc@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Jonathan Brassow <jbrassow@redhat.com>, dm-devel@redhat.com, linux-raid@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids

On Thu, Jul 12, 2012 at 04:32:07PM +1000, Neil Brown wrote:
> Alasdair: I guess we should make sure we are in agreement about how patches
> to dm-raid.c are funnelled through.  So far both you and I have feed them to
> Linus, which doesn't seem to have caused any problems yet.  

Just take it case-by-case as has been happening.
Roughly speaking, when changes are driven from the md side, you take the
coupled patches to the dm files too; when the changes are driven from the dm
side, I'll take them.

Alasdair

