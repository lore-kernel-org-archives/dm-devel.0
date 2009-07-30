From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] drop mutex in __set_size
Date: Thu, 30 Jul 2009 11:17:06 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0907301114580.6696@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0904281211590.22533@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904281214120.22533@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904290223490.9079@hs20-bc2-1.build.redhat.com>
	<4A093417.6050007@ce.jp.nec.com> <4A6824DA.30205@ce.jp.nec.com>
	<Pine.LNX.4.64.0907271942001.10397@hs20-bc2-1.build.redhat.com>
	<4A6F945B.8040502@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4A6F945B.8040502@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids



On Wed, 29 Jul 2009, Jun'ichi Nomura wrote:

> Hi Mikulas,
> 
> Mikulas Patocka wrote:
> > Drop the mutex.
> > 
> > It doesn't make sense to lock it for a single assignment, this code can't
> > be executed concurrently. The size should be read with i_size_read which
> > is automatically protected against concurrent i_size_write.
> 
> But it seems there are codes which depend on i_mutex for
> protected access to i_size: e.g. block_write_begin().

You are right, but I don't know what to do with it. Catch such uses and 
convert them to i_size_read?

> And while my description only mentioned noflush suspend,
> with 2.6.31-rc, the deadlock can occur under normal suspend
> because the new barrier code may push bios to deferred queue.

It can deadlock with any code that takes i_mutex and submits or waits for 
i/os, regardless of barriers.

Mikulas
