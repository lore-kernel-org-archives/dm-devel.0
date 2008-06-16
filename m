From: Adam Hamsik <haaaad@gmail.com>
Subject: Re: NetBSD libdevmapper port
Date: Tue, 17 Jun 2008 00:03:47 +0200
Message-ID: <9B8150BC-CD20-4E8B-A40F-17CD4BA5DA69@gmail.com>
References: <7F5B52C7-1511-49C8-B81A-D4D58E6B12F3@gmail.com>
	<Pine.LNX.4.64.0806131236500.32455@engineering.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v924)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0806131236500.32455@engineering.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, tech-kern@netbsd.org
List-Id: dm-devel.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1


On Jun,Friday 13 2008, at 6:51 PM, Mikulas Patocka wrote:

> Hi
>
> If you are rewriting it --- have you somehow thought about avoiding  
> suspend?

device suspend/resume are unsupported for now. I was not sure what  
these commands should really do.
Because GPL/BSD licensing issues I haven't look at linux code.

>
>
> A big source of problems in Linux is, that when you suspend a  
> device, you can do only a limited set of calls --- basically, you  
> must avoid anything that could possibly wait for I/O or allocate  
> memory --- or you might end up waiting for the suspended device and  
> deadlock. And I know still about 3 places in kernel that have this  
> error possibility.

ok but why I should want to do something like suspending of device ?  
to avoid IO operations when I'm changing
device table or what problem are device suspend/resume want to solve.  
If this is problem I can use one mutex
shared between dm_dev_suspend/resume_ioctl call and dmstrategy(this  
routine does IO) so I can avoid IO's when
device is suspended.

>
>
> A Linux LVM does something like: suspend old table, write to disk  
> with direct i/o, resume new table. I'd suggest that you invent some  
> method how to batch these operations into single syscall --- or you  
> run into a several years of deadlock problems on NetBSD ---  
> basically, on Linux, we have to preallocate a stack and heap (so  
> that running LVM process won't cause a page fault --- the question  
> --- how to do it portably on all NetBSD architectures?), mlock the  
> process, make sure that we don't open files or write anything to  
> terminal while suspended, make sure that the ioctl syscall doesn't  
> allocate anything (currently false, it won't deadlock but it could  
> randomly fail), make sure that O_DIRECT write syscall doesn't  
> allocate anything or wait for other I/O (currently it false, there  
> is a deadlock possibility) ... etc.
>
> --- if you port lvm2 as it is, you'll have to audit (and maybe  
> rewrite) many parts of NetBSD kernel for not waiting for I/O. If you  
> do it badly, you'll get deadlocks.

I want definitely avoid such massive changes to our kernel.

>
>
> This suspend thing was a big misdesign and if you are writing it  
> from scratch, try to avoid it.

Regards

Adam.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)

iD8DBQFIVuNElIxPgX3Go0MRAvoaAJ9TC+dcYmp9S7yv/0un4YcMUE+AwwCeP1G0
C5o2j8D/+heQATR8eewYd34=
=dmZO
-----END PGP SIGNATURE-----
