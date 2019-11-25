From: Martin Wilck <mwilck@suse.de>
Subject: Re: multipath - unable to use multiple active paths at
 once, and deprecated example in docs
Date: Mon, 25 Nov 2019 20:49:05 +0100
Message-ID: <329fd408ea605f1f14c0eebb46209fd3c46c3af8.camel@suse.de>
References: <CAN-y+EJOt=MRDEXCx9_U4zmDs+i9yXj364E4+z=xC=u8+Ao1PQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAN-y+EJOt=MRDEXCx9_U4zmDs+i9yXj364E4+z=xC=u8+Ao1PQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Drew Hastings <dhastings@crucialwebhost.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, 2019-11-22 at 13:27 -0700, Drew Hastings wrote:
> My use case doesn't lend itself well to multipathd, so I'm trying to
> implement multipathing with device mapper directly.
> 
> My only assumption is that the multipath features, in particular
> queue_mode bio, prevent this from behaving properly. If that is the
> case, why can this not be achieved with bios, as this is not a
> limitation of raid1 (which will load balance read IO to device mapper
> targets). I also believe this is the only feature option that is
> viable for me, since this multipath device is on top of device mapper
> targets.

I think you are seeing this FIXME:

https://elixir.bootlin.com/linux/v4.19.79/source/drivers/md/dm-mpath.c#L612

For your testing, perhaps you just remove that if(!pgpath) condition.

Regards,
Martin
