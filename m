From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: multipath target and non-request-stackable devices
Date: Wed, 31 Oct 2018 18:14:03 -0400
Message-ID: <20181031221402.GA22981@redhat.com>
References: <CAN-y+EKcNSQL5_eFD1iuJeyUfk7UApgWWA_Vj72TKQN7-a_kVw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAN-y+EKcNSQL5_eFD1iuJeyUfk7UApgWWA_Vj72TKQN7-a_kVw@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Drew Hastings <dhastings@crucialwebhost.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Oct 31 2018 at  5:32am -0400,
Drew Hastings <dhastings@crucialwebhost.com> wrote:

>    Firstly, thanks for the hard work you guys are doing on the dm drivers.
>    I'm curious to know if I correctly understand the limitations of the
>    multipath target. I'm using kernel 4.19.0-rc5
>    When attempting to create a device from two NVMEs connected over nvme_rdma
>    / nvmf, I get the following message:
> 
>    [43012.002418] device-mapper: table: table load rejected: including
>    non-request-stackable devices
>    [43012.004067] device-mapper: table: unable to determine table type
>    Here's an example request that will fail:
>    dmsetup create test_path --table "0 1562824368 multipath 0 0 2 1
>    round-robin 0 1 1 /dev/nvme1n1 1 round-robin 0 1 1 /dev/nvme2n1 1"

dm-multipath works fine ontop of nvme.  Both blktests and mptest have
test coverage for dm-multipath on nvme:
https://github.com/osandov/blktests 
https://github.com/snitm/mptest

That said, there are 2 different modes that can be used when creating
the dm-multipath device,  The default is request-based ("mq") and there
is also bio-based ("bio"), e.g.:
 queue_mode mq
or
 queue_mode bio

It should be noted that in 4.20 request-based DM _only_ supports blk-mq
("queue_mode mq").  Using "rq" just means "mq" (and vice-versa) as of
4.20.

The error you've encountered shouldn't occur given that nvme devices use
blk-mq for their request_queue.  It could be that 4.19-rc5 had a bug
that was fixed but nothing springs to mind.

But I do recall hitting such an error during development and testing.
And dm_table_determine_type() still isn't as "clean" as I'd like...

>    This will work:
>    dmsetup create test_path --table "0 1562824368 multipath 0 0 2 1
>    round-robin 0 1 1 /dev/sdc 1 round-robin 0 1 1 /dev/sdb 1"
>    After looking at dm-table.c, it seems like this may be an issue of these
>    underlying devices not being compatible with the multipath driver. I had
>    noticed this same error when trying "non-physical" devices in other tests,
>    such as trying to multipath other virtual devices.
>    Is there anything that can be done to do the (relatively "basic")
>    multipath that detects IO errors and switches to the other device? It
>    seems like fundamentally multipath's error detection works in the same way
>    raid1 implements IO error detection of the underlying devices, so why is
>    it that multipath seems to have this limitation but raid1 does not?

request-based DM can only be stacked on request-based devices.  MD raid1
is bio-based, bio-based can stack on anything.

But again: nvme uses blk-mq.

>    Is md-multipath.c still in use? It seems like it might not have this same
>    restriction on the underlying device.

I don't know of anyone who uses MD multipath.

Mike
