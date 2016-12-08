From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: Refuse to load an sq table on an mq device
Date: Thu, 8 Dec 2016 14:54:30 -0500
Message-ID: <20161208195430.GA7742@redhat.com>
References: <d6cb4e39-41ea-18e1-3347-398f17ba6e8d@sandisk.com>
	<20161208021159.GA5944@redhat.com>
	<d22b29da-c02d-ff75-54be-dfbf4c366642@sandisk.com>
	<20161208171844.GA7305@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20161208171844.GA7305@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Dec 08 2016 at 12:18pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Thu, Dec 08 2016 at 11:52am -0500,
> Bart Van Assche <bart.vanassche@sandisk.com> wrote:
> 
> > On 12/07/2016 06:11 PM, Mike Snitzer wrote:
> > >Should I still attribute authorship of this change to you?  Or would you
> > >prefer I switch to you being the Reporter (via Reported-by)?
> > 
> > Hello Mike,
> > 
> > I'm fine with a Reported-by tag.
> 
> Thinking about rebasing this fix to come before this cleanup (so that
> backporting to stable@ is easier):
> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.10&id=db1c06dc2edd242146e25d38b1af61b681d49253
> 
> And then still attributing this fix to you.  I'll let you know what I
> come up with later today.

Done, please see:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.10&id=301fc3f5efb98633115bd887655b19f42c6dfaa8
