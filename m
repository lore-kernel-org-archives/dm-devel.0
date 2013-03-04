From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: Chicken and egg problem with multipath-tools
Date: Mon, 04 Mar 2013 11:27:52 +0000
Message-ID: <51348538.20406@redhat.com>
References: <1362394847.623.YahooMailClassic@web126204.mail.ne1.yahoo.com>
	<513481CF.8020405@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <513481CF.8020405@suse.de>
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
List-Id: dm-devel.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 03/04/2013 11:13 AM, Hannes Reinecke wrote:
> multipathd/main.c:1996 /* Startup complete, create logfile */ 
> pid_rc = pidfile_create(DEFAULT_PIDFILE, daemon_pid); /* Ignore
> errors, we can live without */
> 
> 
> No option, but multipathd doesn't _need_ to create a pidfile. And
> it certainly won't abort if it cannot create one.

Maybe an old version (prior to commit 6cda789 in May 2011)?

- -       if (pidfile_create(DEFAULT_PIDFILE, getpid())) {
- -               if (logsink)
- -                       log_thread_stop();
+       if (pidfile_create(DEFAULT_PIDFILE, getpid()))
+               /* Ignore errors, we can live without */
+               condlog(1, "failed to create pidfile");

- -               exit(1);
- -       }

If this is the case then using a more recent multipath-tools would
definitely be a good plan.

Regards,
Bryn.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAlE0hTgACgkQ6YSQoMYUY96+8wCdG/zOh6fDAOW2LzCNitHNTiek
VzkAn3ovG1230AQMPV/uRcVk8pA1emN/
=o2M/
-----END PGP SIGNATURE-----
