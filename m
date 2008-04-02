From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Desynchronizing dm-raid1
Date: Wed, 2 Apr 2008 18:13:30 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0804021810490.16073@porkchop.devel.redhat.com>
References: <Pine.LNX.4.64.0803131238520.23136@porkchop.devel.redhat.com>
	<Pine.LNX.4.64.0803171338130.7598@porkchop.devel.redhat.com>
	<47DEC402.10309@redhat.com>
	<Pine.LNX.4.64.0803171611430.31803@porkchop.devel.redhat.com>
	<20080317215631.GG29322@agk.fab.redhat.com>
	<Pine.LNX.4.64.0803181921380.10939@porkchop.devel.redhat.com>
	<20080318233955.GA12007@agk.fab.redhat.com>
	<Pine.LNX.4.64.0803181942140.20490@porkchop.devel.redhat.com>
	<20080319000241.GB12007@agk.fab.redhat.com>
	<Pine.LNX.4.64.0803182015001.21077@porkchop.devel.redhat.com>
	<20080319011757.GD12007@agk.fab.redhat.com>
	<Pine.LNX.4.64.0804021444120.22485@porkchop.devel.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0804021444120.22485@porkchop.devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

> No other driver than dm-raid1 
> has problems with this and they wouldn't damp performance because of one 
> driver.

--- so I found that md-raid-[156] recently (2.6.13 or so) added a bitmap 
mode and when this is used (argument --bitmap to mdadm), it is vulnerable 
to this desynchronization bug too. Before, it synced the whole device when 
it crashed without shutdown, so it was OK.

Mikulas
