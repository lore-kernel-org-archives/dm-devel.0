From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: dm-ioband = smarter than me
Date: Mon, 07 Apr 2008 13:08:23 +0900 (JST)
Message-ID: <20080407.130823.193698492.ryov@valinux.co.jp>
References: <2EABDA74-5CC4-4CA2-9839-1EA2C89F2548@blueboxgrp.com>
	<20080405014540.GB10916@us.ibm.com>
	<7ABA9490-2FB2-4886-8061-08BB30CA568B@blueboxgrp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <7ABA9490-2FB2-4886-8061-08BB30CA568B@blueboxgrp.com>
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
List-Id: dm-devel.ids

Hi Clint,

> 	I don't think that I missed that in the directions - do you have to do that?  I just assumed that it didn't matter.  Still, I'm not sure how I would do that to a root partition... unless you aren't supposed to use this on one.

I'll try to use an ioband device as root device while booting up.
I think it'll need to create an ioband device before mkrootdev is
executed in the initrd script like LVM.
I'll report back when I've made more progress.

Thanks,
Ryo Tsuruta
