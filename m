From: "Bryn M. Reeves" <breeves@redhat.com>
Subject: Re: dup mpath?
Date: Fri, 12 Oct 2007 14:19:11 +0100
Message-ID: <470F744F.5080709@redhat.com>
References: <000001c80ca5$9e4ef150$222813ac@pitagora.it>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <000001c80ca5$9e4ef150$222813ac@pitagora.it>
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Domenico Viggiani wrote:
> Hi,
> what's the exact meaning of these messages:
> 
>  # multipath -v2    
>  remove: mpath9 (dup of mpath1)
>  mpath9: map in use
>  remove: mpath13 (dup of mpath2)
>  mpath13: map in use
> 
> ?
> If mpath9/13 already exist, why does multipath try to create mpath1/2?
> 
> System (RH 4.5) is just rebooted, storage is EMC Clariion CX700.
> LVM is in use.

Looks like you have a problem with your bindings
(/var/lib/mpath/bindings). This can happen if, for e.g. the /var tree is
a separate file system.

In this case, multipath devices are created by rc.sysinit before /var is
mounted. Later on, if the wwid to mpath names in the bindings file are
different from those that mpath auto-detected in rc.sysinit you end up
with conflicts like this - multipath is trying to re-name the mpath
devices according to the entries in the bindings file.

If LVM has already activated volume groups on the devices this gives you
the "map in use" errors you noted above.

See this bugzilla:

https://bugzilla.redhat.com/show_bug.cgi?id=320151

There are a couple of workarounds you can use: make /var part of the
root file system, configure your bindings via /etc/multipath.conf
instead (use device { /* ... */ wwid = } blocks), or copy the bindings
file from the /var file system into a location named
/var/lib/mpath/bindings on the root file system (although I would not
recommend this last option as it can become confusing).

Kind regards,
Bryn.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFHD3RP6YSQoMYUY94RAhqMAKC33LKJBCK5R7RFhk8pkixTMzOB+gCfbE6y
Nb2C5vqHipk9lVXyoudOOMI=
=aUoK
-----END PGP SIGNATURE-----
