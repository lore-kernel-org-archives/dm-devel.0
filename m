From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: Chicken and egg problem with multipath-tools
Date: Mon, 04 Mar 2013 10:49:26 +0000
Message-ID: <51347C36.5000406@redhat.com>
References: <1362220999.44153.YahooMailClassic@web126202.mail.ne1.yahoo.com>
	<kgvcv1$l3e$4@ger.gmane.org> <5133BA31.6080208@yahoo.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5133BA31.6080208@yahoo.com>
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
Cc: Andrei B <andrixnet@yahoo.com>
List-Id: dm-devel.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 03/03/2013 09:01 PM, Andrei B wrote:
> Well, that would be an idea. However, multipathd has the pidfile 
> hardcoded. It cannot be changed at runtime, nor can it be
> disabled.

It's not pretty but if you really want the daemon running this early
(most distros without /run don't bother) you can modify the init
script to mount some writable (e.g. ramfs/tmpfs) location over the top
of the read-only /var during start up.

E.g.:

mount -t ramfs none /var/run/

> I know, I could compile it with a different hardcoded path, but
> that's really a bad idea, because then if multipathd were to be
> restarted anytime later after boot, it would then fail because of
> the same reason.

Since the daemon only manages path monitoring and failback when paths
are down most distros that need to cope with read only /var (i.e.
pre-systemd and /run) do not start multipathd until later in the boot
process when /var has been made writable.

Regards,
Bryn.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAlE0fDYACgkQ6YSQoMYUY97ZEgCgsgdZfaVC8D1ZCfhY93UPA9Sh
BEEAniaeRZTap/rbp6pbanE78DpD3myy
=ZTTO
-----END PGP SIGNATURE-----
