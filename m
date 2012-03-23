From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: mpath_prio_rdac?
Date: Fri, 23 Mar 2012 14:50:41 +0000
Message-ID: <4F6C8DC1.9060708@redhat.com>
References: <756D2EE1FEBD2946972256A5FDFCB2EE2C38E064@IT-AIRSTORM.sooner.net.ou.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <756D2EE1FEBD2946972256A5FDFCB2EE2C38E064@IT-AIRSTORM.sooner.net.ou.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: "Hart, Brian R." <brianhart@ou.edu>
List-Id: dm-devel.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 03/23/2012 02:41 PM, Hart, Brian R. wrote:
> All,
> 
> I've been trying to figure this out and have not been able to
> locate any information on this.  I hope that I'm not just
> overlooking something silly...
> 
> We have a couple of Dell MD storage arrays that when installed
> setup multipath.conf to use this line: prio_callout
> "/sbin/mpath_prio_rdac /dev/%n"
> 
> Now, in RHEL5 and Debian Lenny this mpath_prio_rdac file exists.
> However, in the newer distro releases this file seems to be
> completely gone and I cannot find any reference to it in any
> packages.  Has this functionality been replaced some how?  Should
> this line really be different or is multipath handling it
> differently where it just ignores this line anyways in newer
> versions?
> 
> I would greatly appreciate any light that could be shed on the
> subject.  Thanks in advance!
> 
> -- Brian Hart

Callouts make life difficult when file systems go away so like the
path checkers before them they were merged into the libmultipath
shared library. This means that the daemon can lock them into memory
via mlock(2)/mlockall(2) and not have to worry about being able to
load a binary from disk when the paths to that storage have failed -
this is very useful if your root file system is on multipath and you
need to recover from a failure.

In RHEL5 this is dealt with using a complex and fragile private
namespace and RAM-backed file system - the required binaries are
copied into this ramfs at daemon startup and the daemon unmounts
unnecessary file systems to avoid blocking when failures occur.

For this reason the parameter is now just "prio", e.g.:

device {
    vendor                  "IBM"
    product                 "1742"
[...]
    hardware_handler        "1 rdac"
    path_selector           "round-robin 0"
    path_grouping_policy    group_by_prio
[...]
    path_checker            rdac
    prio                    rdac
}

See multipath.conf.defaults or the other example files in the package
your distribution provides.

Regards,
Bryn.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk9sjcEACgkQ6YSQoMYUY975UACfWKTaipiI4v1SxXzhEHU4WJWy
v5EAnjyv40wDVgtY8hQ5Jy6A3esM8hke
=laC0
-----END PGP SIGNATURE-----
