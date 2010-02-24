From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: rqdm: bad usage of dm_get/dm_put (Was: Re: dm mpath:
 fix stall when requeueing io)
Date: Wed, 24 Feb 2010 17:33:30 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1002241732300.2537@hs20-bc2-1.build.redhat.com>
References: <20100219163257.186977438@kvm.kroah.org>
	<4B815A3D.9040402@canonical.com> <4B825982.3060606@ct.jp.nec.com>
	<20100223175331.GE560@agk-dp.fab.redhat.com>
	<Pine.LNX.4.64.1002231429210.29863@hs20-bc2-1.build.redhat.com>
	<4B84E05C.4070300@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4B84E05C.4070300@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

> Indeed, we shouldn't use the current dm_put() in any interrupt-context.
> But the "mapped_device" can disappear in request-based dm while there
> is a request after all bios complete, so I used dm_get()/dm_put() there.
> I'll consider another way to prevent the problem without dm_get()/dm_put().
> E.g. wait for request completion in dm_put() instead.

How can a request-in-progress exists when all the bios complete and the 
device is closed?

Mikulas
