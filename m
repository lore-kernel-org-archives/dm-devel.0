From: Christoph Hellwig <hch@infradead.org>
Subject: Re: good dm-mpath test setup?
Date: Thu, 5 Jun 2014 07:49:28 -0700
Message-ID: <20140605144928.GA23363@infradead.org>
References: <20140605115011.GA816@infradead.org>
 <53905F19.2070401@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <53905F19.2070401@suse.de>
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

On Thu, Jun 05, 2014 at 02:14:17PM +0200, Hannes Reinecke wrote:
> Hmm. This shouldn't happen.
> 
> But be aware, that multipath doesn't play well together with systemd
> currently.
> I've done plenty of fixes to get it up and running for SLES12; once
> they've stabilized I'll be sending them mainline.
> 
> But for a stable testbed I would recommend against systemd currently.

I'm not going anywhere near that stinking pile if I can avoid it.
This is a Debian Wheezy setup.

> >Does anyone have a good default iet or maybe lio config for dm-mpath
> >testing?
> >
> The easiest bit would be set set up lio in loopback mode, and map
> two luns pointing to the same device.
> 
> I've attached a small script I'm using for a quick test here.

Thanks!
