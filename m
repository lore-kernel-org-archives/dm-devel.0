From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Barriers still not passing on simple dm devices...
Date: Thu, 26 Mar 2009 14:05:00 +0100
Message-ID: <E1LmpGX-0001gP-6q@be1.7eggert.dyndns.org>
References: <ciXHh-39c-37@gated-at.bofh.it> <cjfuL-6vJ-43@gated-at.bofh.it>
	<cjfEl-6J2-45@gated-at.bofh.it> <cjfNX-6Wh-27@gated-at.bofh.it>
Reply-To: 7eggert@gmx.de, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <jens.axboe@oracle.com>, device-mapper development <dm-devel@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

Mikulas Patocka <mpatocka@redhat.com> wrote:

> ./drivers/block/loop.c:
> doesn't reject barriers, it's ok because it doesn't reorder requests

But it relies on other devices to not reorder.
