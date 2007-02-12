From: "Bryn M. Reeves" <breeves@redhat.com>
Subject: Re: [PATCH 2.6.20] updated dm-loop patch
Date: Mon, 12 Feb 2007 15:24:18 +0000
Message-ID: <45D086A2.1060900@redhat.com>
References: <0a3001c74e82$bb519730$eeeea8c0@aldipc>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000102000107070608050902"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <0a3001c74e82$bb519730$eeeea8c0@aldipc>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: roland <devzero@web.de>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------000102000107070608050902
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

roland wrote:
> Hi Bryn,
> 
> after some first tests which looked very very promising (could dmlosetup
> files >2gb, could create more than 256 loop dm-loop devices...), i have
> bad news.
> maybe it`s not that "bad" because you may be able to fix it quickly, but
> it seems that dm-loop is racy (or whatever). maybe smp safeness, since i
> was testing on a P4 with HT enabled ? i did my first tests on non-smp
> system (VM), but it wasn`t put under that load as i did now.

Hi Roland,

At first sight, this doesn't look SMP related. The backtrace you posted
comes from a BUG() macro in the source that triggers when we can't find
an extent we're looking for in the table.

There's also a rather odd number in the "not using" message:

device-mapper: loop: not using 4294967296 bytes in incomplete block at EOF

So I think for some reason we're not building a correct block map for
this file.

I'll have time to take a proper look at this this evening - while I'm
looking into this one, do you have any other info on the file that gave
the problem:

- - was it a sparse file?
- - was an offset used when creating the device?

If you have the time, I'd also be interested in seeing the following
information:

- - output of dmsetup table <device>
- - debugfs output for the loop file concerned

For the first one, there's no need to perform any I/O to the device
after creating it, so you shouldn't need to trigger the BUG() again - it
might help to kill udevd though, as it will try to run vol_id etc. on
the device otherwise.

For the debugfs data, please run the attached script on the device/file
that had the problem, for e.g.:

do_debugfs.sh /dev/hda3 src/5gig.dat > /tmp/5gig.dat.out

The first argument is the device containing the file and the second is
the path relative to the device's root directory - change the
path/device to suit your system.

This will give a complete block map for the file so I can see what we're
tripping over. For a 5G file this may take a few minutes and the file
will be 50-100k in size - you can send it to me privately rather than
spamming the whole list :)

> ps:
> hey, why not announcing this on lkml, so this gut get some more notice
> or being reviewed by others?

So that we can work these kind of problems out first! ;)

Kind regards,

Bryn.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFF0Iai6YSQoMYUY94RAiNmAKC99G8+slz+tVDnSkCiVsPN6GVoJwCeJcCg
wQ3iLG/ZVzGsualWfcmVv34=
=y8/d
-----END PGP SIGNATURE-----

--------------000102000107070608050902
Content-Type: application/x-shellscript;
 name="do_debugfs.sh"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="do_debugfs.sh"

IyEvYmluL2Jhc2gKIwojIHVzYWdlOiBkb19kZWJ1Z2ZzLnNoIDxkZXZpY2U+IDxyZWxhdGl2
ZSBwYXRoPgojCiMgZS5nLjogZG9fZGVidWdmcy5zaCAvZGV2L2hkYTIgdG1wL2JsYWguZmls
ZQoKaWYgWyAiJCMiICE9ICIyIiBdOyB0aGVuCgllY2hvICd1c2FnZTogZG9fZGVidWdmcy5z
aCA8ZGV2aWNlPiA8cmVsYXRpdmUgcGF0aD4nCglleGl0IDEKZmkKCkRFQlVHRlM9L3NiaW4v
ZGVidWdmcwpERVY9JDEKUEFUSD0kMgoKJERFQlVHRlMgJERFViA8PEVPRgpzdGF0ICRQQVRI
CnF1aXQKRU9GCmVjaG8KCg==
--------------000102000107070608050902
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------000102000107070608050902--
