From: Alasdair G Kergon <agk@redhat.com>
Subject: FW: Re: [PATCH 2/3] check for completed exception after
	dropped lock
Date: Tue, 17 Mar 2009 19:08:04 +0000
Message-ID: <20090317190804.GO3063@agk.fab.redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

----- Forwarded message from Mikulas Patocka <mpatocka@redhat.com> -----

Date: Wed, 25 Feb 2009 14:26:08 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 2/3] check for completed exception after dropped lock
To: dm-devek@redhat.com
cc: Alasdair G Kergon <agk@redhat.com>

> -	up_write(&s->lock);
> -	pe = alloc_pending_exception(s);
> -	down_write(&s->lock);

BTW. shouldn't this rw-semaphore be replaced with a mutex or normal 
semaphore? It is never locked for read. (it used to be in locked for reads 
in RHEL-4). Mutex has better performance than a rw-semaphore --- it takes 
fewer cycles and it also guarantees first-in-first-out ordering.

Mikulas
