From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH RFC 0/2] dm-mp netlink events
Date: Wed, 9 Nov 2005 09:26:32 -0800
Message-ID: <20051109172632.GB16171@us.ibm.com>
References: <20051109075423.GA11492@us.ibm.com>
	<20051109091000.GA16793@free.fr>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20051109091000.GA16793@free.fr>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Christophe Varoqui <christophe.varoqui@free.fr> wrote:
> Would uevents work instead of yet another Netlink wire ?
> The multipath daemon already listens for uevents ...

I general similar information could have been sent using the uevents
netlink. Though changes would be needed in kobject_uevent to allow more
event data to be passed in the events environmental data. Also while we
could generate events against /sys/block/dm-* it might be more interesting
if we had more detailed kobjects in the sysfs tree to generate events
against, but that is a larger change.

The reason I decide to use a different netlink number was that I was trying
to use a event method that would have a higher chance of working under low
memory conditions (i.e. the skb mempool). I also used unicast instead of
broadcast. When using netlink_broadcast I could not control the memory
allocation in the skb_clone. While skb_clone just clones the header so it
would me a smaller allocation and you can pass in the flags for the
allocation I was still concerned that this might not work in low memory
cases.

-andmike
--
Michael Anderson
andmike@us.ibm.com
