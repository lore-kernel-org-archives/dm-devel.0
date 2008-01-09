From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH][RFC] fast file mapping for loop
Date: Wed, 9 Jan 2008 23:53:49 +0000
Message-ID: <20080109235349.GH3510@agk.fab.redhat.com>
References: <95637914@web.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <95637914@web.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: devzero@web.de
Cc: Heinz Mauelshagen <mauelshagen@redhat.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org, chris.mason@oracle.com
List-Id: dm-devel.ids

On Thu, Jan 10, 2008 at 12:43:19AM +0100, devzero@web.de wrote:
> oh, nice to see that this is still alive.

> at least i got no crashes and was able to mount and acess more than 300 iso-images with that.

> were there fixes/chances since then?

Little has changed for some time - mostly code cleanups and the occasional bug fix.

It's time to give it wider exposure, I think, and we'll find out how well it holds up.

Alasdair
-- 
agk@redhat.com
