From: "Andrei B." <andrixnet@yahoo.com>
Subject: Re: Chicken and egg problem with multipath-tools
Date: Mon, 4 Mar 2013 03:00:47 -0800 (PST)
Message-ID: <1362394847.623.YahooMailClassic@web126204.mail.ne1.yahoo.com>
References: <51344531.90705@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <51344531.90705@suse.de>
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
List-Id: dm-devel.ids



--- On Mon, 3/4/13, Hannes Reinecke <hare@suse.de> wrote:

> From: Hannes Reinecke <hare@suse.de>

> > The problem is that multipathd wants to create a PID
> file under /var (which is at this time readonly).
> > This fails and multipathd fails to start.
> > It took me a lot of testing and reboots until I managed
> to determine this is the actual problem.
> > 

> Hmm. Why? multipathd can happily live without a PID file;
> SUSE has been doing this for years (for precisely the same
> reason).
> Check the SUSE init scripts.

Official (from author's website) multipath-tools contain a multipathd that has hardcoded PIDFILE location and there is no runtime option to change its location or disable it. Both manpage and source show this. 
Maybe SUSE has a modified multipathd with added option to control PIDFILE creation. 
