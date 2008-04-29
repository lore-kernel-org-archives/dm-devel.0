From: Tore Anderson <tore@linpro.no>
Subject: Re: Different Path priorities for iSCSI and FC paths to
	a	combination lun.
Date: Tue, 29 Apr 2008 22:06:00 +0200
Message-ID: <48177FA8.7030206@linpro.no>
References: <200804241603.m3OG3B5M030182@hera.kernel.org>	<20080429145629.GK18935@agk.fab.redhat.com>
	<7DAA28B9259FAD458DEE03DC3DA236DA043F66DF@caex02.trans.corp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <7DAA28B9259FAD458DEE03DC3DA236DA043F66DF@caex02.trans.corp>
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

Hi,

* Srinivas Ramani

> I would be grateful to learn from this forum on how one would be able
> to have different path priorities for a FC / iSCSI  paths to a
> multiprotocol FC/iSCSI combination lun using device mapper . The
> intention is that a  FC path should have a higher priority than an
> iSCSI path to the same lun. Is it possible to do it with a
> configuration change or would one need to  add this feature to the 
> mpath_prio_alua  code.

Make a small wrapper script that invokes mpath_prio_alua and also checks
if the path is to a iSCSI volume or not (you can probably determine this
by looking somewhere beneath /sys/block/$dev/).  If it is, add 100 to
whatever mpath_prio_alua returned, and print the sum.

Regards
-- 
Tore Anderson
