From: "Peter Koutoupis" <Peter_Koutoupis@us.xyratex.com>
Subject: RE: geometry of dm devices......
Date: Thu, 10 Aug 2006 04:38:17 -0700
Message-ID: <1121230D3E3B6B4E9162069832D90A641BC10E@XYUS-EX22.xyus.xyratex.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Darrick J. Wong" <djwong@us.ibm.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Thanks Darrick,

I actually saw that in the source to build 1.02.08 but unfortunately it
would be of no help in my situation.  You see I work in a storage/array
test environment and as for dm, we must specifically work with the
builds packaged with the releases of Redhat, Suse, etc.  I saw that
SLES10 had a build of 1.02.xx but I can also see that it was prior to
this new implementation.  We are unable to modify (unless required in a
customer support scenario) what is packaged with these releases.  Thanks
again.=20

Regards,

Peter

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of Darrick J. Wong
Sent: Tuesday, August 08, 2006 5:09 PM
To: device-mapper development
Subject: Re: [dm-devel] geometry of dm devices......

Peter Koutoupis wrote:

>> I understand the HDIO_GETGEO is an unsupported feature to dm=20
>> devices....but under normal practices how would a normal end-user be=20
>> able to obtain such geometry from a raw dm device?  I have read of

Wow, I'm late to the game.  If your kernel/software are new enough, you
can set a dm device's geometry via the DM_DEV_SET_GEOMETRY_CMD ioctl.
iirc, the userland equivalent is:

# dmsetup setgeometry /dev/foo cyl head spt start

...after which HDIO_GETGEO should return nonzero values.

You'll need kernel 2.6.16+ and I think the requisite version of dmsetup
is 1.02.  And to my (very limited) knowledge of multipath, geometry is
not set up automatically.

--D
