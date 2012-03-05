From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Crash in dm_done()
Date: Mon, 5 Mar 2012 13:23:38 -0500
Message-ID: <20120305182338.GA28280@redhat.com>
References: <4F0C1E68.30602@suse.de> <4F0D4A23.7060604@ce.jp.nec.com>
	<20120111162501.GA25980@redhat.com> <4F0E8B10.2000909@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4F0E8B10.2000909@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Jan 12 2012 at  2:26am -0500,
Hannes Reinecke <hare@suse.de> wrote:

> On 01/11/2012 05:25 PM, Mike Snitzer wrote:
> > But we never did get to the bottom of _why_, and Jun'ichi pointed out
> > a NULL pointer check is missing:
> > http://www.redhat.com/archives/dm-devel/2011-December/msg00022.html
> > 
> > Anyway, Hannes, if you can reproduce it'd also be interesting to see if
> > your patch (updated with NULL pointer check?) makes any difference.
> > 
> Sad news: This is _with_ my patch applied.
> (Hey, these are my patches. Obviously I will be using them :-)

Hi Hannes,

Alasdair staged an old version of your patch here (for 3.4):
http://people.redhat.com/agk/patches/linux/editing/dm-mpath-clear-map_context-when-requeueing.patch

But it is missing a mpio NULL pointer check in do_end_io().

Did you have an updated patch you'd like used instead of the one above?
If so, please post it to dm-devel.

Thanks,
Mike
