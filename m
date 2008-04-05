From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: dm-ioband = smarter than me
Date: Sat, 5 Apr 2008 01:45:20 +0100
Message-ID: <20080405004520.GV2572@agk.fab.redhat.com>
References: <2EABDA74-5CC4-4CA2-9839-1EA2C89F2548@blueboxgrp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <2EABDA74-5CC4-4CA2-9839-1EA2C89F2548@blueboxgrp.com>
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

On Fri, Apr 04, 2008 at 04:53:32PM -0700, Clint Moore wrote:
> [root@ test 2.6.24]# echo "0 $(blockdev --getsize /dev/sda3) ioband / 
> dev/sda3 1" | dmsetup create ioband1
           ^ why 1?

dmesg gives better error message

Alasdair
-- 
agk@redhat.com
