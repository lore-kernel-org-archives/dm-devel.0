From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: new dm-bufio
Date: Tue, 23 Aug 2011 12:44:47 +0100
Message-ID: <20110823114446.GD26199@agk-dp.fab.redhat.com>
References: <Pine.LNX.4.64.1108221600510.26651@hs20-bc2-1.build.redhat.com>
	<20110823113048.GC5442@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20110823113048.GC5442@ubuntu>
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

On Tue, Aug 23, 2011 at 12:30:48PM +0100, Joe Thornber wrote:
> Are these stats broken down by bufio client?

That can indeed be done later, but it's a bigger job to do it properly I think,
with some core dm changes to support callbacks for target-based sysfs
attributes on mapped devices.

My only esssential upstream requirement for the initial release is that the
total memory usage of this module is easily monitored by people who aren't dm
developers.

Alasdair
