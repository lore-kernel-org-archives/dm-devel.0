From: "Domenico Viggiani" <dviggiani@tiscali.it>
Subject: RE: dup mpath?
Date: Fri, 12 Oct 2007 16:39:07 +0200
Message-ID: <000101c80cdd$a4de0aa0$222813ac@pitagora.it>
References: <000001c80ca5$9e4ef150$222813ac@pitagora.it>
	<470F744F.5080709@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <470F744F.5080709@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: 'device-mapper development' <dm-devel@redhat.com>
List-Id: dm-devel.ids

> Looks like you have a problem with your bindings 
> (/var/lib/mpath/bindings). This can happen if, for e.g. the 
> /var tree is a separate file system.
> 
> In this case, multipath devices are created by rc.sysinit 
> before /var is mounted. Later on, if the wwid to mpath names 
> in the bindings file are different from those that mpath 
> auto-detected in rc.sysinit you end up with conflicts like 
> this - multipath is trying to re-name the mpath devices 
> according to the entries in the bindings file.
> 
> If LVM has already activated volume groups on the devices 
> this gives you the "map in use" errors you noted above.
> 
> See this bugzilla:
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=320151

It's amazing the way you answer me with this wonderful description of the
problem after only a few tens of minutes while regular Red Hat support is
struggling with my call since many days!
In my opinion, this is a limit to the adoption of Linux in the enterprise
environment: it needs too technical involvement from specialized personnel.
I hope that Red Hat will understand that it needs more expert engineers in
the frontline.

Heartfelt thanks and sorry for my bad english
..
Domenico Viggiani
