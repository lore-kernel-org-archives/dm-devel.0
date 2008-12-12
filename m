From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [patch] leastpending_io load balancing policy
Date: Fri, 12 Dec 2008 11:51:05 +0900
Message-ID: <4941D199.7080803@ct.jp.nec.com>
References: <2118D41AB77C214BBF7D2330CD977BCF1BB4687032@GVW1162EXB.americas.hpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <2118D41AB77C214BBF7D2330CD977BCF1BB4687032@GVW1162EXB.americas.hpqcorp.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Balasubramanian, Vijayakumar (STSD)" <vijayakumar@hp.com>
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Vijayakumar,

Balasubramanian, Vijayakumar (STSD) wrote:
> > Hi,
> > Attached is modified patch with the comments incorporated.

I think it doesn't work correctly if repeat_count is more than 1
because io_count is decremented for every end_io while it is
incremented only when the path is selected.


The 'leastpending_io' balancing is actually what our queue-length
based dynamic load balancer, which is originally posted by Stefan
Bader, is already doing.
Our patches work with repeat_count more than 1 by adding a hook
at starting I/O:
http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/rqdm-dlb-01-interface-change-for-queue-length-dlb.patch

So, please take a look at our patches and let's avoid the duplication
of efforts.  Comments are welcome.


Also, if you are interested in dynamic load balancing, you might
want to check the request-based dm-multipath, too.
Since necessary changes in the block layer and SCSI subsystem are
already included in Linus's tree, remaining patches are dm only.
The latest version is in the Alasdair's editing tree.

Thanks,
Kiyoshi Ueda
