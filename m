From: "roland" <devzero@web.de>
Subject: Re: Re: device mapper integrated loops - and one more
Date: Wed, 22 Nov 2006 01:15:01 +0100
Message-ID: <076601c70dcb$410c8450$eeeea8c0@aldipc>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: breeves@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Bryn,

>Yes, dm-loop will support as many loop devices as device-mapper can allo=
w.

fine. i assume this is >>256  !?  :)

>The changes dm-loop requires in device-mapper core are pretty minor and
>have already been merged in 2.6.19, so it's just the dm-loop patch
>itself remaining.

ok, thanks

>This should work fine - there are a couple of known issues with the
>existing patch, but unless you are using large images (>2G), or have a
>severely fragmented filesystem you shouldn't run into these.

i have several iso images of dvd-roms on my server which i`d like to moun=
t=20
loopback.
they are >2gb, so i think i wait for the fix.

>I'll see if we can get a revised version of the current patch for wider
>testing in the next couple of weeks - let me know if you would be
>interested in trying this out.

yes indeed, that would be nice! if it isn=B4t any additional effort for y=
ou,=20
please let me know since i`m not on this list (too much mail, anyway)
i can offer testing dm-loop with a very large number (>200) of=20
cd-rom/dvd-images.

roland







Subject:    Re: [dm-devel] Re: device mapper integrated loops - and one m=
ore
From:       "Bryn M. Reeves" <breeves () redhat ! com>
Date:       2006-11-21 21:11:37
Message-ID: 45636B89.7080407 () redhat ! com
[Download message RAW]

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

Yes, dm-loop will support as many loop devices as device-mapper can allow=
.

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
A+F6CtqcHH0fOG9lq2XQw/8=3D
=3DCzES
-----END PGP SIGNATURE-----

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel=20
