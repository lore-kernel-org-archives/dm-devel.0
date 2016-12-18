From: Ian Pilcher <arequipeno@gmail.com>
Subject: Re: dm-cache: please check/repair metadata
Date: Sun, 18 Dec 2016 09:51:41 -0600
Message-ID: <a58b3198-90a3-124e-b8ee-464e3f150057@gmail.com>
References: <o2adej$eaa$1@blaine.gmane.org>
	<2d776d72-744a-7aa7-a5ae-35192fe145d8@redhat.com>
	<efe12356-a132-c517-914d-4a4cf3a902fc@gmail.com>
	<o34lim$19u$1@blaine.gmane.org>
	<5a00ced3-0688-827a-f001-fd4677e46425@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5a00ced3-0688-827a-f001-fd4677e46425@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

> I'm not exactly sure what are you doing, are you maintaining your own dm
> cache volumes ?  (Writing your own volume manager and not using lvm2 -
> what is lvm2 missing/doing wrong ?)

Yup.  I've continuing to use my "zodcache" system for assembling
dm-cache devices.

As to what lvm2 is missing or doing wrong ... It's not that there's
anything "wrong" with it.  It's just that I prefer to have a "simpler"
setup with a cached PVs/VGs, rather than cached LVs.  I've also always
found the fact that LVM cache puts both the fast and slow devices into
the same VG to be counterintuitive.

These are really matters of personal preference, though.  I want to be
very, very clear that I don't think that there's anything wrong with
LVM.  (To be perfectly honest, my preferences are probably colored by
the fact that I first used bcache, so I'm used to its "model".)

> Are you going to write also your own recovery support ?

Until a few days ago I wasn't aware that such a thing might even be
necessary.  :-)

> Otherwise it's normally a business of lvm2 to maintain proper size of
> cached LVs (and even resize them when needed via monitoring)
> This will be necessary once we will support online resize of cache pools
> & cached volumes.

I didn't realize that LVM did that.  That's cool.

> From the source code of lvm2 it seems it uses about 44  bytes per cache
> chunk and with some transaction overhead for metadata (this could be
> possible lowered for 'smq' policy...)

I came across this in one of my Google searches.

 
http://people.redhat.com/msnitzer/patches/upstream/dm-cache-for-v3.13/dm-cache-variable-hints.patch

I wonder if I should just use 128.  It would be a bit wasteful, but
hopefully it would be future-proof.

-- 
========================================================================
Ian Pilcher                                         arequipeno@gmail.com
-------- "I grew up before Mark Zuckerberg invented friendship" --------
========================================================================
