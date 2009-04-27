From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 4/8] raid1 barriers
Date: Mon, 27 Apr 2009 07:49:22 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0904270748250.18227@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0904270701250.12459@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904270743540.18227@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904270744220.18227@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904270745190.18227@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904270745510.18227@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904270746210.18227@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0904270746210.18227@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Heinz Mauelshagen <heinzm@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

> Introduce a callback pointer from the log to dm-raid1 layer.
> 
> Before some region is set as "in-sync", we need to flush hardware cache on
> all the disks. But the log module doesn't have access to the mirror_set
> structure. So it will use this callback.
> 
> So far the callback is unused, it will be used in further patches.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

This one is out of order. Ignore it.

Mikulas
