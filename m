From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm-table: delayed cleanup for
	dm_table_destroy()
Date: Tue, 20 Mar 2012 21:24:12 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1203202120320.23255@file.rdu.redhat.com>
References: <1332172428-35948-1-git-send-email-hare@suse.de>
	<1332172428-35948-2-git-send-email-hare@suse.de>
	<1332172428-35948-3-git-send-email-hare@suse.de>
	<1332172428-35948-4-git-send-email-hare@suse.de>
	<Pine.LNX.4.64.1203191714090.10651@file.rdu.redhat.com>
	<4F68A3D8.40005@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4F68A3D8.40005@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids



On Tue, 20 Mar 2012, Hannes Reinecke wrote:

> Ah. That'll explain it.
> The actual problem I'm trying to track down is that I'm seeing an
> excessive duration for the 'resume' dm ioctl after a table update.
> I've got reports where the ioctl can take up to several seconds.
> Which (as this is multipath) causes an extremely erratic behaviour.
> 
> And the 'msleep' here is one of the obvious culprits.
> 
> But I'll continue debugging, maybe I'll find something else.
> 
> Cheers,
> 
> Hannes

If it takes several second, it is not obviously problem with msleep(1) --- 
if we converted msleep(1) to a wait queue, it would improve by at most 
1ms, but it couldn't improve by a few seconds.

Mikulas
