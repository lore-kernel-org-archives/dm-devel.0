From: "Paul Cote" <paul.cote@incipient.com>
Subject: RE: CLARiiON failover modes and DM.
Date: Mon, 19 Nov 2007 15:20:14 -0500
Message-ID: <940B4FF1F5958E4F96FC83C055A2F2611B8C6A@exch-2003.incipient.waltham>
References: <4741DB30.8020009@linpro.no>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <4741DB30.8020009@linpro.no>
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


Tore

I have found the definitions of all CX failover modes. The SAN admin
assigned failover mode 3. Will DM support option 3 assuming that I
follow EMC's guidance wrt the appropriate settings for the CX in
multipath.conf? ... Or should we reassign the failover mode to 1 per
your email? It seems to me that the path state status will differ
significantly based on the failover modes; specifically 1 or 3. We don't
have FLARE 26 so ALUA mode is N/A.

The failover definitions are:
1) Passive not ready; a command failure when I/O issued to non-owning
SP.
2) quiet trespass on I/O to non-owning SP
3) passive always ready; some commands (TUR) return "passive always
ready" status.

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of Tore Anderson
Sent: Monday, November 19, 2007 1:51 PM
To: device-mapper development
Subject: Re: [dm-devel] CLARiiON failover modes and DM.


* Paul Cote

> Is there a specific failover mode that the CX must be set for DM=20
> interoperability?

You have (at least) two options.  CLARiiON Open mode 1 is the=20
traditional way where all paths to the passive controller is present but

will refuse almost all I/O operations.  You'll need to be using the=20
"emc" hardware handler for that to work, since a proprietary command=20
needs to be sent to a path to the passive controller in order to=20
trespass the volume there.

The other option (which is only available in FLARE 26) is ALUA mode=20
(CLARiiON Open mode 4), where I/O is accepted on both controllers even=20
though only one is the one handling all the I/O.  You can use this=20
without a hardware handler (there's one in developement, though), but=20
you'll still want to be prioritising the paths to the preferred=20
controller for optimal performance.  This is the mode I would prefer, at

least.  I wrote a bit more about the ALUA mode a few days ago:

http://thread.gmane.org/gmane.linux.kernel.device-mapper.devel/4366/focu
s=3D4435

Regards
--=20
Tore Anderson

--
dm-devel mailing list
dm-devel@redhat.com https://www.redhat.com/mailman/listinfo/dm-devel
