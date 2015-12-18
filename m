From: Ian Pilcher <arequipeno@gmail.com>
Subject: [RFC] zodcache - auto-start dm-cache devices
Date: Fri, 18 Dec 2015 00:16:32 -0600
Message-ID: <n508c1$8dl$1@ger.gmane.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

https://github.com/ipilcher/zodcache

I've been looking for a "simple" way to manage dm-cache devices for a
while now -- something that operates a bit more like bcache than LVM
cache does, while still using the dm-cache infrastructure.  Having not
found anything, I finally created "zodcache".  (The name is mostly due
to wanting something that could be used as a magic number -- 20DCAC8E.)

Hopefully the README does a decent job of explaining how it works, so I
won't belabor it here:

   https://github.com/ipilcher/zodcache/blob/master/readme.pdf

I'm very interested in any feedback on this.

  * Is this approach useful?
  * Is there a better way of doing this?
  * Is the libdevmapper stuff in zcstart.c correct/optimal?

And now to sleep ...

Thanks!

-- 
========================================================================
Ian Pilcher                                         arequipeno@gmail.com
-------- "I grew up before Mark Zuckerberg invented friendship" --------
========================================================================
