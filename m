From: "Bryn M. Reeves" <breeves@redhat.com>
Subject: Re: Re: device mapper integrated loops - and one more
	year !
Date: Tue, 21 Nov 2006 21:11:37 +0000
Message-ID: <45636B89.7080407@redhat.com>
References: <1439173022@web.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1439173022@web.de>
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

devzero@web.de wrote:
> Hello !
> 
> after desparately seeking for a solution to have more than 256 loop
> devices (for a huge cd-rom server), i have recently come across
> dm-loop, which looks very promising (to replace loop.c)
> 
> can i have more than 256 devices which this?

Hi Roland,

Yes, dm-loop will support as many loop devices as device-mapper can allow.

> our cd-rom server is going to have more than 256 iso-images soon and
> i need to upgrade to a more recent OS, anyway, so this won`t be a 
> problem that dm-loop is so brand new.
> 
> but - any timeline for dm-loop mainline inclusion ?
> 
> should i wait for 2.6.19 or 2.6.20 ?

There isn't a fixed timeline. We are currently working to improve the
lookup code - the prototype patch uses a linear search which doesn't
scale well for large/fragmented image files. I have some tests running
at the moment and we hope to have something soon - the results so far
are good, it's just a case of selecting between a couple of different
methods.

The changes dm-loop requires in device-mapper core are pretty minor and
have already been merged in 2.6.19, so it's just the dm-loop patch
itself remaining.

> is it already useable with less recent kernels, i.e. can i download
> dm-loop patch and recent dmsetup tool and use with older kernel ?

This should work fine - there are a couple of known issues with the
existing patch, but unless you are using large images (>2G), or have a
severely fragmented filesystem you shouldn't run into these.

I'll see if we can get a revised version of the current patch for wider
testing in the next couple of weeks - let me know if you would be
interested in trying this out.

Thanks,

Bryn.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFFY2uJ6YSQoMYUY94RArTwAJwMmCJbTajxmX6Q/ps545zbgvJJOACg28NP
A+F6CtqcHH0fOG9lq2XQw/8=
=CzES
-----END PGP SIGNATURE-----
