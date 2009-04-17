From: "Romanowski, John (OFT)" <John.Romanowski@oft.state.ny.us>
Subject: RE: FS directly on top of dm devices?
Date: Fri, 17 Apr 2009 08:20:19 -0400
Message-ID: <16F7C86087BE0247B20562A9E6B07DC781D2BF95@excnysm95bagp.nysemail.nyenet>
References: <49E7C4A6.3080301@gps.caltech.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49E7C4A6.3080301@gps.caltech.edu>
Content-Language: en-US
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

Partitioning and LVM is optional, depends upon what you want to accomplis=
h.
Sometimes I make the file system directly on the multipathed device, as i=
n
mkfs /dev/mapper/mpatha

Other than having more paths to the LUN it's no different then making a f=
ile system on an unpartitioned scsi device as in
mkfs /dev/sda

> -----Original Message-----
> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
> On Behalf Of Scott Dungan
> Sent: Thursday, April 16, 2009 7:52 PM
> To: dm-devel@redhat.com
> Subject: [dm-devel] FS directly on top of dm devices?
>
> We recently had an engineer from a large storage vendor suggest that we
> make our file systems directly onto the multipathed devices without
> first creating underlying partitions or using LVM.  Having not run with
> this method in production before, we would like to gather as much
> information as possible first. Initial searches for documentation on
> this method has produced few results, short of a Suse/Novell document
> from 2005 under section 4:
>
> http://support.novell.com/techcenter/sdb/en/2005/04/sles_multipathing.h
> tml
>
> Does anyone have any experience with this or can point us to more
> documentation. thoughts or recommendations?
>
> Thanks,
>
> --
>
> Scott A Dungan
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel


This e-mail, including any attachments, may be confidential, privileged o=
r otherwise legally protected. It is intended only for the addressee. If =
you received this e-mail in error or from someone who was not authorized =
to send it to you, do not disseminate, copy or otherwise use this e-mail =
or its attachments.  Please notify the sender immediately by reply e-mail=
 and delete the e-mail from your system.
