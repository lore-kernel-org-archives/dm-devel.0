From: "Charles Polk" <Charles.Polk@vion.com>
Subject: RE: Multipathd not starting up properly
Date: Wed, 30 Aug 2006 14:52:24 -0400
Message-ID: <7221D0B8D5D73A4F81D21DFE8332D12C7AC53F@condor.www.vionnet.com>
References: <44F5DD6F.4080208@netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <44F5DD6F.4080208@netapp.com>
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

Is this for me???

Charles R. Polk -           Sr. Systems Engineer
ViON Corporation
Cell: (301) 518-9266 -       Pager: (888) 257.5538
Fax: (202) 342-1404
E-Mail: charles.polk@vion.com
=20
http://www.vion.com

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] On
Behalf Of David Wysochanski
Sent: Wednesday, August 30, 2006 2:48 PM
To: device-mapper development
Subject: Re: [dm-devel] Multipathd not starting up properly

Adam Huffman wrote:
> I'm seeing the following messages when I start multipathd:
>=20
> Aug 29 19:00:21 multipathd: error calling out /sbin/scsi_id -g -u -s=20
> /block/sda
> Aug 29 19:00:21 multipathd: error calling out /sbin/scsi_id -g -u -s=20
> /block/sdb
>=20

Does /sbin/scsi_id exist on your system?

Did you try running this manually from the command line?

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
