From: Navid Zamani <navid.zamani@googlemail.com>
Subject: A simple, generic DM-API, for codecs/transcoders to use?
Date: Wed, 18 Mar 2009 09:58:02 +0100
Message-ID: <49C0B79A.9010601@googlemail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hello DM mailing list.

I a have a simple question:
Is there a way to use the device-mapper to hang an arbitrary program
in-between a real block device, and the virtual device created by the
device-mapper?
Like with LUKS. Only that I do not want to compress or encrypt. I want
to hang an error-correcting transcoder in between, so I can put ECC on
any block device I want.
The optimal thing would be a simple API, that is implemented in many
languages. (Like FUSE is available in many languages.)
Something like this would really be a powerful abstraction to have.

In case you are interested in the reasons: Modern consumer HDDs do not
have any ECC, but they get less and less reliable. It went so far, that
I saw random corruption without SMART telling me of any errors. (Of
course I eliminated the software as a cause.) RAID, backups and all that
stuff, does not help. Because this is a consumer case, and frankly, I do
not have the money for a RAID. Backups do not help, because you back up
your corrupt files with everything else, and only notice it, when it=E2=80=
=99s
too late.
So I decided to put my whole archive on a partititon with software-based
ECC. And because I could not find something that resembled this, I chose
to implement it myself.
I will program it in Haskell, and use cross-interleaved Reed-Solomon
codes (much like those on CDs) as a ECC. Is is a must-have to 1. fix
corruption on read (and re-write the fixed data), 2. report any tiny
problem to the user (log, mail, console message. all at once if
possible), and 3. protect the whole partition (else I would have used FUS=
E).

I bet there are more people out there who could use something like that.
Most certainly certain government agencies or scientists.
I wonder, what you have to say about this. Is there something like this
out there? Is there a better way? How would I implement it with the
device-mapper.

Navid
