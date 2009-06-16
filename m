From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/6] dm raid45 target: export region hash
	functions and add a needed one
Date: Tue, 16 Jun 2009 10:09:14 -0400
Message-ID: <20090616140914.GA3348@infradead.org>
References: <4a368301.KBrCZcokAm87BF/S%heinzm@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4a368301.KBrCZcokAm87BF/S%heinzm@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Jun 15, 2009 at 07:21:05PM +0200, heinzm@redhat.com wrote:
> Hi,
> 
> this patch series introduces the raid45 target.
> Please include upstream.

NACK, no need for another raid target, especially if it happens to be
as broken as the raid1 one.  Please help on making the md raid4/5 code
more useful for your purposes (whatever that may be).
