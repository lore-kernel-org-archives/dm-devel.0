From: "Bryn M. Reeves" <breeves@redhat.com>
Subject: Re: dup mpath?
Date: Fri, 12 Oct 2007 14:28:54 +0100
Message-ID: <470F7696.9080208@redhat.com>
References: <000001c80ca5$9e4ef150$222813ac@pitagora.it>
	<470F744F.5080709@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Bryn M. Reeves wrote:
> There are a couple of workarounds you can use: make /var part of the
> root file system, configure your bindings via /etc/multipath.conf
> instead (use device { /* ... */ wwid = } blocks), or copy the bindings
> file from the /var file system into a location named
> /var/lib/mpath/bindings on the root file system (although I would not
> recommend this last option as it can become confusing).

Blech - I meant "multipath" blocks, not "device" blocks, e.g., putting
something like this into multipath.conf:

multipaths {
    multipath {
        wwid 360060480000190102501530123456789
        alias  mpath0
    }

    multipath {
        wwid    360060480000190102501530123456799
        alias   mpath1
    }
}

Kind regards,
Bryn.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFHD3aW6YSQoMYUY94RArcjAJ9H7fPbMfoaCK+v0HlVISrF8lLhnwCg1FTB
goQimrLbcWfNoh526bkEyGo=
=ynBE
-----END PGP SIGNATURE-----
