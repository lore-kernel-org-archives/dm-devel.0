From: Guido Guenther <agx@sigxcpu.org>
Subject: Re: multipath-tools causes path to come back as
	different block device
Date: Fri, 20 Jul 2007 19:29:20 +0200
Message-ID: <20070720172919.GA2497@bogon.ms20.nix>
References: <469FEBBB.5040507@csupomona.edu> <46A0631F.4030404@suse.de>
	<20070720115315.GA26421@bogon.ms20.nix> <46A0C94B.4010905@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <46A0C94B.4010905@suse.de>
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

Hi Hannes,
On Fri, Jul 20, 2007 at 04:40:11PM +0200, Hannes Reinecke wrote:
> Removing from /dev and /sys in not sufficient, sadly.
> The memory is only released after the last reference has gone.
> So all fd's have to be closed (ie multipathd and the path checkers have
> to have this path disabled) and no device-mapper table must reference i=
t.
Knowing this, the problem is much easier to spot...

> So easiest way is infact to have multipathd run with -v 4, as this will
> tell you exactly if multipathd has stopped the path checker.
> The device-mapper tables can be checked manually with dmsetup.
...it's in multpathd/main.c. The sysfs device is already gone when we
get the remove event. This patch makes it obvious:

diff --git a/multipathd/main.c b/multipathd/main.c
index 5f98c33..00890d7 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -635,8 +635,10 @@ uev_trigger (struct uevent * uev, void * trigger_dat=
a)
 		return 0;
=20
 	sysdev =3D sysfs_device_get(uev->devpath);
-	if(!sysdev)
-		return 0;=09
+	if (!sysdev) {
+		condlog(4, "Devpath '%s' of uevent '%s' vanished", uev->devpath, uev->=
action);
+		return 0;
+	}
=20
 	lock(vecs->lock);

Signed-Off-By: Guido G=FCnther <agx@sigxcpu.org>

The sysfs device is already gone, so sysfs_device_get returns 0 and we
never call uev_remove_path further down below. The check of the return
value was added by f1b1fca2ccbfd7d58350eb136105fdaf8aa4f59ca, which is
imho correct. Can we expect the sysfs node to stay around long enough? I
don't think so, so should we cache the sysfs_device structures somewhere
to use them on path removal? I could cook up a patch.
Cheers,
 -- Guido
