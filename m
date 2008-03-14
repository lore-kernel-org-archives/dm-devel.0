From: lemons_terry@emc.com
Subject: RE: Linux utility to determine WWN from a LUN number
Date: Fri, 14 Mar 2008 17:10:55 -0400
Message-ID: <B6FF36386FC9AC4BB098A4528811409F0228C44A@CORPUSMX40A.corp.emc.com>
References: <B6FF36386FC9AC4BB098A4528811409F022309BE@CORPUSMX40A.corp.emc.com>	<20080313214352.GA18433@us.ibm.com><B6FF36386FC9AC4BB098A4528811409F02230CC4@CORPUSMX40A.corp.emc.com>
	<47DA257B.70904@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <47DA257B.70904@suse.de>
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

=20

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of Hannes Reinecke
Sent: Friday, March 14, 2008 3:13 AM
To: device-mapper development
Subject: Re: [dm-devel] Linux utility to determine WWN from a LUN number

Hannes Reinecke wrote:
>The WWN is either in VPD page 0x83 or 0x80 (in that order of
preference).

In my experience, not always.  I've seen FC products (especially
autochanger and tape devices) that do not embed a WWN in VPD page 0x83.
Some embed a non-unique WWN value.

tl
