From: Juerg Haefliger <juergh@gmail.com>
Subject: Re: RAID status, CSMI, and dmRAID
Date: Tue, 19 Apr 2011 17:57:59 +0200
Message-ID: <BANLkTinvCPN0u_ZKisty7H66FZoqFFxsrA@mail.gmail.com>
References: <C70A636B101FD44999B82525C3E92AFABC2006@otis.burlington.evertz.tv>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <C70A636B101FD44999B82525C3E92AFABC2006@otis.burlington.evertz.tv>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Hi Sandra,

> I=92ve recently been researching the issue of obtaining RAID status on Li=
nux
> (using a library or API, not through scripts). I=92ve read that CSMI code=
s can
> be issued (using ioctl() calls) to get RAID status, and from my
> understanding (please correct me if I=92m wrong), dmraid doesn=92t use CS=
MI at
> all, and the status is obtained using the metadata on the member drives.
> Does this mean that using CSMI and ioctl is not possible on Linux, or does
> this mean that using CSMI and ioctl is a bad idea on Linux?

CSMI is an interface introduced by Compaq which never gained traction
nor was accepted as an industry standard. It's only supported by the
low-level drivers that manage controllers sold by Compaq/HP. That is
mptlinux, mpt2sas and probably the cciss driver as well which btw has
been replaced by hpsa by now. Stay away from CSMI. It's proprietary
and obsolete.

...Juerg
