From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: A better solution than "md_component_detection = 1"
Date: Wed, 20 Apr 2005 12:36:24 +0200
Message-ID: <1113993384.24817.103.camel@zezette>
References: <000001c5136d$3b3502a0$11051aac@pcp41116>
	<20050410172931.GF12752@marowsky-bree.de>
	<20050419213810.GY29071@marowsky-bree.de>
	<1113947755.24817.81.camel@zezette>
	<20050420101341.GL29071@marowsky-bree.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050420101341.GL29071@marowsky-bree.de>
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
Cc: gregkh@suse.de, hare@suse.de
List-Id: dm-devel.ids

On mer, 2005-04-20 at 12:13 +0200, Lars Marowsky-Bree wrote:
> On 2005-04-19T23:55:55, christophe varoqui <christophe.varoqui@free.fr> wrote:
> 
> > > > For example, /sys/block/sda would have a sub/ directory with "dm-0" in
> > > > there, pointing at /sys/block/dm-0 (surprise). The
> > > > /sys/block/dm-0/parent/sd{a,b} entries would do a very surprising
> > > > thing.
> > > > 
> > > > This would also allow us to handle partitions in DM better: as all
> > > > linear mappings on top of /dev/dm-0 would show up in block/dm-0/sub/ and
> > > > vice versa.
> > > > 
> > > > md could work the same: block/sys/md0/parent/ would list all the devices
> > > > (or partitions) which it consists of.
> > > > 
> > Regardless of the implementation, am I the only one to think that
> > dm-0/parent/ should contain "parents of dm-0" ? :)
> 
> I thought that was exactly what I was proposing.
> 
I mean the following would be more friendly to me.

/sys/block/sda/parent/dm-0
/sys/block/sdb/parent/dm-0
/sys/block/dm-0/sub/sd[ab]

In your proposed example, "parent" in fact means "parents of" and "sub"
means "sub of" ... which I find misleading.

But may be that's just me :)

Regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>
