From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH] dm-table: delayed cleanup for
	dm_table_destroy()
Date: Wed, 21 Mar 2012 14:34:37 +0900
Message-ID: <4F69686D.8010208@ce.jp.nec.com>
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
To: device-mapper development <dm-devel@redhat.com>, Hannes Reinecke <hare@suse.de>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Hannes,

On 03/21/12 00:35, Hannes Reinecke wrote:
> The actual problem I'm trying to track down is that I'm seeing an
> excessive duration for the 'resume' dm ioctl after a table update.
> I've got reports where the ioctl can take up to several seconds.
> Which (as this is multipath) causes an extremely erratic behaviour.
> 
> And the 'msleep' here is one of the obvious culprits.
> 
> But I'll continue debugging, maybe I'll find something else.

Did you track down which part of the resume ioctl took long?

If table is updated and the device is not yet suspended,
resume ioctl itself suspends the device.
And dm_suspend() could take long depending on lower devices
as it waits for already-submitted I/Os to return to dm.

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation
