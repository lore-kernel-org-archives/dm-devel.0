From: Harald Hoyer <harald@redhat.com>
Subject: Re: root on multipath and dracut
Date: Mon, 10 Feb 2014 15:34:20 +0100
Message-ID: <52F8E36C.5040503@redhat.com>
References: <52F8D490.8000500@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <52F8D490.8000500@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 02/10/2014 02:30 PM, Hannes Reinecke wrote:
> Hi Ben,
> 
> as we're switching to dracut/systemd nowadays I've tried to setup
> and enable root on multipath for this, too.
> 
> As you might've seen, I've already added proper systemd support for
> multipath-tools, so it should be easy to plug it into dracut.
> 
> Or so I thought.
> 
> As it turns out, dracut is trying to add some RH-specific rules files:
> 
> 40-multipath.rules
> 62-multipath.rules
> 65-multipath.rules
> 
> which have only _very_ sparse documentation.
> Wouldn't it be a good idea to settle on a default set on scripts
> here and include those into the multipath-tools repository?
> 
> Cheers,
> 
> Hannes
> 

Currently we only ship /lib/udev/rules.d/62-multipath.rules with
device-mapper-multipath-0.4.9-56.

Gentoo was using 65-multipath.rules and we formerly used 40-multipath.rules.

So, basically dracut tries to find any of them to be backwards compatible and
cross distro.
