From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: lvmcreate -i 128 limitation
Date: Mon, 21 Sep 2009 13:58:25 +0100
Message-ID: <20090921125824.GE1210@agk-dp.fab.redhat.com>
References: <1253536631.4612.13.camel@cail>
	<20090921125601.GD1210@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090921125601.GD1210@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Sep 21, 2009 at 01:56:01PM +0100, Alasdair G Kergon wrote:
> What error message do you get?
 
Found it.

There's no kernel-side limitation and no lvm2-format metadata limitation
I can think of.

Just a restriction inherited from LVM1 that we've never had cause to remove.

Alasdair
