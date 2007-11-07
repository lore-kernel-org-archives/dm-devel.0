From: "Paul Cote" <paul.cote@incipient.com>
Subject: RE: Reloading multipathd?
Date: Wed, 7 Nov 2007 08:33:07 -0500
Message-ID: <940B4FF1F5958E4F96FC83C055A2F2611B8B8C@exch-2003.incipient.waltham>
References: <1194440870.6012.8.camel@sanderbal>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <1194440870.6012.8.camel@sanderbal>
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


Did you do a rescan so that the O/S "sees" the new LUN? If so; simply do
a multipath -v2 to build the new path list.

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of S. J. van Harmelen
Sent: Wednesday, November 07, 2007 8:08 AM
To: device-mapper development
Subject: [dm-devel] Reloading multipathd?

Hi...

I just added another LUN on our storage (MD3000). But now that I run
multipath -ll I don't see the new LUN.

Do I need to reload something (like /etc/init.d/multipath-tools reload
maybe)? And if so, can I do this without it interrupting the
connectivity of the other (production) LUN's?

Sander

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
