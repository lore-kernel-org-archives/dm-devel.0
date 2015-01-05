From: Joe Thornber <thornber@redhat.com>
Subject: Re: DM limits setup
Date: Mon, 5 Jan 2015 10:21:52 +0000
Message-ID: <20150105102151.GC11818@debian>
References: <CAFx4rwQudUhVH4rgJYb+uHPe17PKJHYQRsxbUpwr5h_1r2B8+w@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAFx4rwQudUhVH4rgJYb+uHPe17PKJHYQRsxbUpwr5h_1r2B8+w@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: doug@easyco.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Dec 31, 2014 at 02:10:52PM -0800, Doug Dumitru wrote:
> Hello all,
> 
> I have a test dm target module that I use to validate storage subsystems
> for data accuracy.  It basically builds weak hashes for every sector of a
> device when written, and validates these hashes when the sector is read
> back.  Ugly memory usage, but it is just a test tool.
> 
> I can deploy this with an iterator target and it will take on the limits of
> the device underneath, or I can skip the iterator target and get limits at
> 2048 sectors.  What I would like to do is set the limit manually.  I know
> this is "really bad program design", but again, this is a test tool and not
> anything for production use.
> 
> Can anyone point me at an example of where the limits are setup explicitly.

Hi Doug,

This sounds like a useful target for testing, any chance you could
post it here when you finish it please?

dm-thin does lots of tweaking of limits, so that's probably the best one to look at:

https://github.com/jthornber/linux-2.6/blob/thin-dev/drivers/md/dm-thin.c#L3707

- Joe
