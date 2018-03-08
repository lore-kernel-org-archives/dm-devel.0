From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] dm-bufio: move dm-bufio.h to include/linux/
Date: Thu, 8 Mar 2018 06:49:55 -0800
Message-ID: <20180308144955.GA23262@infradead.org>
References: <alpine.LRH.2.02.1803080421030.9508@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1803080421030.9508@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com, Thomas Jaskiewicz <tomj@permabit.com>
List-Id: dm-devel.ids

On Thu, Mar 08, 2018 at 04:22:01AM -0500, Mikulas Patocka wrote:
> This patch moves dm-bufio to include/linux/, so that external modules can
> use it. (it is needed for the VDO team)

NAK.  That code once merged should just move to drivers/md/.
