From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH] 2.6.12-rc6: fix rh_dec()/rh_inc() race in
	dm-raid1.c
Date: Fri, 24 Jun 2005 11:45:31 -0400
Message-ID: <42BC2A9B.6090304@ce.jp.nec.com>
References: <42B2027D.7040807@ce.jp.nec.com>
	<5d3aa9a8d94cf891a9a4b86c8f506379@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5d3aa9a8d94cf891a9a4b86c8f506379@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Jon,

Jonathan E Brassow wrote:
 > could this be solved by doing your patch in rh_dec and just moving the
 > atomic_inc in rh_inc?  The reason I ask is that the mark_region log
 > call can block.

No.
Unless they are serialized, it's possible that rh_inc() will see the
state RH_DIRTY, while rh_dec change it to RH_CLEAN.
As a result, the region which has I/O in-flight may be freed.

Is it reasonable to call mark_region() unconditionally?
Then we can call it outside of the lock.

 >>    CPU0                                   CPU1
 >>
 >> -----------------------------------------------------------------------
 >> -------
 >>    rh_dec()
 >>      if (atomic_dec_and_test(pending))
 >>         <the region is still marked dirty>
            if (atomic_read(pending)==0)
 >>                                           rh_inc()
 >>                                             atomic_inc(pending)
 >>                                             if the region is clean
 >>                                                mark the region dirty
 >>                                                and remove from clean list
                                                else do nothing
 >>         mark the region clean
 >>         and move to clean list
