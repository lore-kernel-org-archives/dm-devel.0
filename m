From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: different LUN numbers under the same dm device
Date: Wed, 6 Jun 2012 16:35:07 -0400
Message-ID: <20120606203507.GC16432@redhat.com>
References: <8DCD6D08-35CE-48CC-AC54-7436265C32CB@purestorage.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <8DCD6D08-35CE-48CC-AC54-7436265C32CB@purestorage.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Brian Bunker <brian@purestorage.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Jun 06 2012 at  3:27pm -0400,
Brian Bunker <brian@purestorage.com> wrote:

> Our company produces a multiple port Fibre Channel storage array. We
> are continually plagued by this problem. We get a dm device which
> combines paths for different LUN's. We would like to understand why
> this is happening. Wouldn't this problem almost certainly lead to a
> data corruption?
> 
> Thanks,
> Brian
> 
> 3624a93700a14254d729923840001000b dm-11 PURE,FlashArray
> size=500G features='0' hwhandler='0' wp=rw
> `-+- policy='round-robin 0' prio=1 status=active
>   |- 1:0:0:12 sde  8:64   failed faulty running
>   |- 0:0:0:12 sdd  8:48   failed faulty running
>   |- 0:0:0:10 sdar 66:176 active ready  running
>   `- 1:0:0:10 sdba 67:64  active ready  running
> 
> Of the 4 paths to dm-11, we can see two paths are for LUN 10 and the
> other two are for LUN 12. We have 24 other dm devices which have only
> the expected 2 paths.

Multipath considers all LUNs with the same UUID to be the same LUN.

So you should first try to understand why all of these paths were held
to have the same UUID (3624a93700a14254d729923840001000b).
