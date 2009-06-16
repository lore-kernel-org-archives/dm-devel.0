From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [PATCH 1/6] dm raid45 target: export region hash
	functions and add a needed one
Date: Tue, 16 Jun 2009 16:51:46 +0200
Message-ID: <1245163906.28257.113.camel@o>
References: <4a368301.KBrCZcokAm87BF/S%heinzm@redhat.com>
	<20090616140914.GA3348@infradead.org>
Reply-To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090616140914.GA3348@infradead.org>
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

On Tue, 2009-06-16 at 10:09 -0400, Christoph Hellwig wrote:
> On Mon, Jun 15, 2009 at 07:21:05PM +0200, heinzm@redhat.com wrote:
> > Hi,
> > 
> > this patch series introduces the raid45 target.
> > Please include upstream.
> 
> NACK, no need for another raid target, especially if it happens to be
> as broken as the raid1 one.

You didn't review it it seems ?

What are your particular pointers to any raid1 code issues ?
Please point to particular code of concern.

Mind you, that we've got clustered mirroring with it, which isn't
supported in MD.

>   Please help on making the md raid4/5 code
> more useful for your purposes (whatever that may be).

Supporting various ATARAID raid5 mappings via dmraid long before md got
external metadata suport added.

Heinz

> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
