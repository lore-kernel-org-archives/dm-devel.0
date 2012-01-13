From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: kpartx -l side effects
Date: Fri, 13 Jan 2012 11:42:51 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1201131142170.32458@hs20-bc2-1.build.redhat.com>
References: <4F0F2024.7060205@redhat.com>
	<Pine.LNX.4.64.1201121606210.12911@hs20-bc2-1.build.redhat.com>
	<4F102EA5.3040304@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="168436252-1803508421-1326472971=:32458"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4F102EA5.3040304@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: =?UTF-8?B?UMOhZHJhaWcgQnJhZHk=?= <pbrady@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--168436252-1803508421-1326472971=:32458
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Fri, 13 Jan 2012, P=C3=A1draig Brady wrote:

> On 01/12/2012 09:08 PM, Mikulas Patocka wrote:
> >=20
> >=20
> > On Thu, 12 Jan 2012, P=C3=A1draig Brady wrote:
> >=20
> >> I was playing around with kpartx on 2.6.40.4-5.fc15.x86_64 and did:
> >> kpartx -l /bin/ls
> >> Now I get "text file busy" when trying to run ls.
> >> How does one undo that?
> >>
> >> cheers,
> >> P=C3=A1draig.
> >=20
> > Run losetup -a, you find that one of loopback devices is assigned to=20
> > /bin/ls (for example /dev/loop0). Then, run losetup -d /dev/loop0 to=20
> > remove that block device. Then, you can use /bin/ls again.
>=20
> Cool that works.
> It's still a bug though right?
> I.E. `kpartx -l` has side effects (only when it can't map partitions).
>=20
> cheers,
> P=C3=A1draig.

It may be a bug. You can report it to kpartx developers.

Mikulas
--168436252-1803508421-1326472971=:32458
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--168436252-1803508421-1326472971=:32458--
