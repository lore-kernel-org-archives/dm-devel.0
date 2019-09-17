From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: introduce DM_GET_TARGET_VERSION
Date: Tue, 17 Sep 2019 16:08:28 -0400
Message-ID: <20190917200827.GA5042@redhat.com>
References: <alpine.LRH.2.02.1909160553360.11421@file01.intranet.prod.int.rdu2.redhat.com>
	<20190916180107.GA725@infradead.org>
	<127b8c4e-a6dc-6d5e-caff-fe1a0ca3a5bb@gmail.com>
	<CAMeeMh9t4LBwJn_CPQgFNa_Tyj22fJYHK-4qAnyn0RXm9RzCnw@mail.gmail.com>
	<20190917140632.GA3728@redhat.com>
	<alpine.LRH.2.02.1909171133100.1876@file01.intranet.prod.int.rdu2.redhat.com>
	<CAMeeMh_cq=F3JRZQrLbXA8=DkrvWD7qWNrNyBZdLarWWKcZXAQ@mail.gmail.com>
Reply-To: LVM2 development <lvm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <lvm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAMeeMh_cq=F3JRZQrLbXA8=DkrvWD7qWNrNyBZdLarWWKcZXAQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/lvm-devel>,
	<mailto:lvm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/lvm-devel>
List-Post: <mailto:lvm-devel@redhat.com>
List-Help: <mailto:lvm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/lvm-devel>,
	<mailto:lvm-devel-request@redhat.com?subject=subscribe>
Sender: lvm-devel-bounces@redhat.com
Errors-To: lvm-devel-bounces@redhat.com
To: John Dorminy <jdorminy@redhat.com>
Cc: lvm-devel@redhat.com, Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>, Milan Broz <gmazyland@gmail.com>
List-Id: dm-devel.ids

On Tue, Sep 17 2019 at 11:44am -0400,
John Dorminy <jdorminy@redhat.com> wrote:

>    Makes sense, sorry I missed that detail.
> 
>    Might it be better to just extend 'dmsetup targets' to take an optional
>    target-name parameter? When I saw this change, I thought 'dmsetup targets
>    <name>' surely worked already for the purpose, and was somewhat surprised
>    when experiment disagreed. Then list_versions() has much the same code
>    change as in this change, there's a little change in validate_params(),
>    and it seems less surprising (to me) to extend the existing
>    target-information-printing dmsetup command than to add another one.

No, I don't think it better to extend 'dmsetup targets'.  There is
little to be gained in doing so.

The DM_GET_TARGET_VERSION ioctl's implementation happens to be shared
with the DM_LIST_VERSIONS ioctl (used by 'dmsetup targets') but that
doesn't imply DM_LIST_VERSIONS should be extended instead.

This is a simple change that enables userspace to accomplish a specific
goal without altering an established DM ioctl.

--
lvm-devel mailing list
lvm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/lvm-devel
