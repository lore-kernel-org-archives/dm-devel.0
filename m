From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm-thin vs lvm performance
Date: Fri, 20 Jan 2012 17:33:34 +0000
Message-ID: <20120120173333.GA12920@ubuntu>
References: <1326416116.56981.YahooMailNeo@web36404.mail.mud.yahoo.com>
	<20120116124158.GA4426@ubuntu>
	<1326915054.99335.YahooMailNeo@web36407.mail.mud.yahoo.com>
	<20120120170335.GA10518@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20120120170335.GA10518@ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jagan Reddy <gjmsreddy@yahoo.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Jan 20, 2012 at 05:03:35PM +0000, Joe Thornber wrote:
> For me, the first run of aio_stress manages a throughput of ~9G/s.
> After the wipe, which is just a simple dd across the device,
> performance drops to ~5.5 G/s.  Also throughput on the device under
> the linear target also drops.  Permanently.
> 
> I don't know if this is specific to aio, or a more general slowdown.

It's just me being stupid.  For the initial pass the ramdisk has no
memory backing it and is just returning zeroes.

Back to testing ...

- Joe
