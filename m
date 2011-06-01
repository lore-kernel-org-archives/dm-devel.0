From: Joe Thornber <ejt@redhat.com>
Subject: Re: [PATCH 1/2] dm-kcopyd: introduce per-module throttle
 structure
Date: Wed, 1 Jun 2011 10:51:07 +0100
Message-ID: <20110601095106.GA3718@ubuntu>
References: <Pine.LNX.4.64.1105311802330.9322@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1105311802330.9322@hs20-bc2-1.build.redhat.com>
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
Cc: "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, May 31, 2011 at 06:03:39PM -0400, Mikulas Patocka wrote:
> Hi
> 
> Here I'm sending new kcopyd throttling patches that allow the throttle to 
> be set per module (i.e. one throttle for mirror and the other for 
> snapshots).

I'm sorry Mikulas, but these patches still really worry me.

i) Your throttling is time based, rather than throughput.

ii) No account is taken of the source and destination devices.  If I
have an idle mirror, I would like the resyncing of a new leg to go at
100% speed.  Other mirrors in the system may be under load so should
resync in a more sympathetic manner.  Should we be using the
congestion functions to see if the source or destination are too busy?
 
iii) calling msleep in kernel code really makes me shudder, especially
when you call it with a fixed, small duration and then loop.  Can't
you work out how long you should sleep for?  Why not defer the worker
thread until this time? (i.e. use queue_delayed_work()).

iv) you haven't explained how the sys admin works out the correct
throttle value.  If we write this down then maybe we can think about
automating it.

- Joe
