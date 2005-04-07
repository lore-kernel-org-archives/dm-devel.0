From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] self-contained "kpartx kicker"
Date: Thu, 7 Apr 2005 12:46:31 +0100
Message-ID: <20050407114631.GM9049@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

> +char *
> +dm_mapname(int major, int minor)

> +	if (!(dmt = dm_task_create(DM_DEVICE_LIST)))
> +		return 0;

You don't need this.  Just set the major/minor directly.
cf dmsetup -j -m

Alasdair.
-- 
agk@redhat.com
