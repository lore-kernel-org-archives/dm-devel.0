From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: rqdm: bad usage of dm_get/dm_put (Was: Re: dm mpath:
 fix stall when requeueing io)
Date: Thu, 25 Feb 2010 16:04:35 +0900
Message-ID: <4B862103.1040802@ct.jp.nec.com>
References: <20100219163257.186977438@kvm.kroah.org>
	<4B815A3D.9040402@canonical.com> <4B825982.3060606@ct.jp.nec.com>
	<20100223175331.GE560@agk-dp.fab.redhat.com>
	<Pine.LNX.4.64.1002231429210.29863@hs20-bc2-1.build.redhat.com>
	<4B84E05C.4070300@ct.jp.nec.com>
	<Pine.LNX.4.64.1002241732300.2537@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1002241732300.2537@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Mikulas,

On 02/25/2010 07:33 AM +0900, Mikulas Patocka wrote:
>> Indeed, we shouldn't use the current dm_put() in any interrupt-context.
>> But the "mapped_device" can disappear in request-based dm while there
>> is a request after all bios complete, so I used dm_get()/dm_put() there.
>> I'll consider another way to prevent the problem without dm_get()/dm_put().
>> E.g. wait for request completion in dm_put() instead.
> 
> How can a request-in-progress exists when all the bios complete and the 
> device is closed?

In the current request-based dm, the device opener can remove
the mapped_device while the last request is still completing,
because bios in the last request complete first and then the device
opener can remove the mapped_device before the last request completes:
 CPU0                                           CPU1
 ======================================================================
 <<INTERRUPT>>
 blk_end_request_all(clone_rq)
   blk_update_request(clone_rq)
     bio_endio(clone_bio) == end_clone_bio
       blk_update_request(orig_rq)
         bio_endio(orig_bio)
                                                <<I/O completed>>
                                                dm_blk_close()
                                                dev_remove()
                                                  dm_put(md)
                                                    <<Free md>>
   blk_finish_request(clone_rq)
     ....
     dm_end_request(clone_rq)
       free_rq_clone(clone_rq)
       blk_end_request_all(orig_rq)
       rq_completed(md)

So we need a mechanism to defer the md deletion until the last request
completes.

Thanks,
Kiyoshi Ueda
