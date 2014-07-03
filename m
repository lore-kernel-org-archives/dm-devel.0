From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: v3.15 dm-mpath regression: cable pull test causes
	I/O hang
Date: Thu, 3 Jul 2014 10:18:45 -0400
Message-ID: <20140703141844.GC28104@redhat.com>
References: <53AD6B62.2020407@acm.org> <20140627133345.GA6150@redhat.com>
	<20140702220223.GA23894@redhat.com> <53B56120.8040802@acm.org>
	<20140703140516.GB28104@redhat.com> <53B56594.1060104@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <53B56594.1060104@suse.de>
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
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, device-mapper development <dm-devel@redhat.com>, Bart Van Assche <bvanassche@acm.org>
List-Id: dm-devel.ids

On Thu, Jul 03 2014 at 10:15am -0400,
Hannes Reinecke <hare@suse.de> wrote:

> On 07/03/2014 04:05 PM, Mike Snitzer wrote:
> >
> >Hannes, do you have a testbed for heavy cable pull testing?  Are you
> >able to replicate these hangs?
> >
> Yes, I do. But sadly I've been tied up with polishing up SLES12
> (release deadline is looming nearer) and for some inexplicable
> reason management seems to find releasing a product more important
> than working on mainline issue ...

OK, so long as you didn't include these dm-mpath changes.. but if you
did then you could kill 2 birds with one stone ;)

> But I hope to find some time soonish (ie start of next week) to work
> on this; it's the very next thing on my to-do list.

OK, I really appreciate it, thanks.
