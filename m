From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: Fwd: [Next problem with multipath-tools]
Date: Tue, 15 Feb 2005 22:48:44 +0100
Message-ID: <42126E3C.2080306@free.fr>
References: <20050214145026.GB13778@tykepenguin.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <20050214145026.GB13778@tykepenguin.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, pcaulfie@redhat.com
List-Id: dm-devel.ids

Patrick,

remember me why you can't start the daemon later in the boot process ?
Last time when talked about that I guess we concluded the startup 
position didn't really care ...

Anyway, if you maintain the need, several solution might be evaluated :
o a cmdline flag to disable pidfile creation, for those distro that 
manage that in the init script
o a different default pidfile location, or a flag to point to a custom 
location
o rip the pidfile logic altogether and go for a pidof() thing in the tool

Concerning /var/cache/multipathd, I guess the overlay doesn't matter as 
the CLONE_NEWNS flag should protect our namespace.

Please comment on your prefered ways.

Regards,
cvaroqui

>
>	Hello Patrick,
>
>I installed the new version of libsysfs1 which fixed problem in location of 
>libsysfs in /lib (instead in /usr/lib). But I think that this bug fix didn't
>solve problem with multipath-tools. After reboot multipathd is able to start
>correctly when server is coming up. Unfortunately if /var is located on
>separate volume and is mounted at startup sequence after multipathd start, the
>new mounted file system will overlay directory structure (located in /var -
>i.e. /var/run and /var/cache/multipathd) for multipathd and daemon will stay
>nonfunctional. Multipathd is running but do nothing from this moment. It is
>necessary to restart multipathd after mounting of /var file system. I have no
>idea how to solve this problem (maybe it is necessary to modify multipathd to
>store information elsewhere than in /var - i.e. somewhere on root partition or
>in ram disk).
>  
>
>


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
