From: Igor Feoktistov <igorf@netapp.com>
Subject: Re: multipathd.init
Date: Fri, 1 Apr 2005 13:13:20 -0800 (PST)
Message-ID: <200504012114.j31LENYF011024@smtp2.corp.netapp.com>
Reply-To: Igor Feoktistov <igorf@netapp.com>,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-MD5: 6fBAGSfkBcTl0bxpVM8bYA==
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Does it have to be running from initrd in case of root on dm-multipath?
Would not it be sufficient just run multipath from initrd and then run
multipathd from init scripts? This is exactly what I'm doing in the lab
so far...

>From: Alasdair G Kergon <agk@redhat.com>
>To: device-mapper development <dm-devel@redhat.com>
>Mail-Followup-To: device-mapper development <dm-devel@redhat.com>
>Content-Disposition: inline
>User-Agent: Mutt/1.4.1i
>X-loop: dm-devel@redhat.com
>Subject: [dm-devel] multipathd.init
>
>Attached is a cleaned-up version of multipathd init script - at least 
>for Red Hat based systems.
>
>While it uses the standard daemon-handling functions, it's still only 
>suitable for a few situations though.
>
>If you have / on dm-multipath, the daemon has to be started from
>the initrd - so you don't want it stopping/starting from init.d,
>but you might want to HUP it.
>
>If you have other system parts of your filesystem (e.g. /usr) you 
>want the daemon starting from rc.sysinit.
>
>If you have data filesystems over multipath, you want something
>to mount them after multipathd starts.
>
>And you might also have cryptsetup, md, lvm2, kpartx involved
>- in various combinations...
>
>So you could have a multi-level startup with multiple instances
>of multipathd each configured to manage only a subset of devices.
>Then the init.d multipathd script would only kill the daemon
>instance started during by the init.d script, and would leave
>alone the instances managing / and /usr.
>
>Or you could forget completely about init.d and /var/lock/subsys
>and /var/run and just launch the daemon from the initrd or
>failing that from rc.sysinit.
>
>Then you would need a new mechanism to manage it.
>(ie a dedicated client program that communicates with it e.g. via
>shared memory)
>I anticipate that something like this is the right way to go.
>
>That client program could even be 'dmsetup' if the daemon functionality
>could be incorporated into plug-ins: The various types of mirroring 
>have similar requirements, so it's sensible to have a single
>daemon infrastructure for them all.
>
>Alasdair
>-- 
>agk@redhat.com
