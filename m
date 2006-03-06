From: Eddie Williams <Eddie.Williams@steeleye.com>
Subject: Re: SCSI-3 Persistent Reservations and Multipathing
Date: Mon, 06 Mar 2006 09:35:38 -0500
Message-ID: <1141655738.3115.2.camel@gator.sc.steeleye.com>
References: <60835.194.39.131.40.1141378050.squirrel@www.hcsd.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <60835.194.39.131.40.1141378050.squirrel@www.hcsd.de>
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


I have been using the sg_persist utility from sg3_utils to reserve each
path defined in a multipath configuration and it seems to be working
fine.  I am using the write lock so other nodes on the SAN are still
able to configure the multipath device as well.

Eddie
On Fri, 2006-03-03 at 10:27 +0100, Stephan Austerm=C3=BChle wrote:
> Hi,
>=20
> can I use SCSI-3 Persistent Reservations with multipathing (SLES9 SP2)?
>=20
> Kind regards,
>=20
> Stephan
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
