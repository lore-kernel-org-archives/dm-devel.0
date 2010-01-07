From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: Shared snapshots
Date: Thu, 7 Jan 2010 10:42:55 +0200
Message-ID: <20100107084255.GP25902@reaktio.net>
References: <Pine.LNX.4.64.1001060927120.28095@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1001060927120.28095@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Mike Snitzer <msnitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, Jan 06, 2010 at 09:38:00AM -0500, Mikulas Patocka wrote:
> Hi
> 
> I uploaded new code for shared snapshots at
> http://people.redhat.com/mpatocka/patches/kernel/new-snapshots/devel/
> 
> Changes:
> - two queues, one for reads and one for writes, to improve read latency 
> when the device is write-congested
> - limit number of reallocations in flight (VM subsystem sends all writes 
> at once and without limit it creates big lags).
> - fixed one place where it didn't handle on-disk errors
> - simplified bitmap creation, removed some unneeded code
> - new macro for error reporting, as suggested by Zdenek
> - some comments added
> - DM_ prefix added to some macros
> 
> Userspace for lvm 2.02.53 is at
> http://people.redhat.com/mpatocka/patches/userspace/new-snapshots/lvm-2.02.54/
> 
> Please, someone, do offensive testing with this --- i.e. apply the 
> patches, try it, and try all possible lvm commands with it, try to stress 
> and crash it in various ways, etc. If we wait with testing until Alasdair 
> reads the code, it won't get much testing...
> 

Sorry for a stupid question, but what does "shared" mean? Support for CLVM?

-- Pasi
