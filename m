From: "Thomas Wenzel" <thomas.wenzel@escape-germany.de>
Subject: Scaling with 4 NICs and Multibus
Date: Tue, 15 Apr 2008 19:43:43 +0200
Message-ID: <F08B0115A043C24CB7D8F6CCC9739792733B54@helmut.escape-germany.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Class: urn:content-classes:message
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

Hi,

I try to set up multipath on four iscsi connections.
(iStor gigastor + Fedora Core 8).

The transfer rate with one iscsi connection is 110 MB/s.
If I load balancing over two or four connections I get not more than 110 =
MB/s. But I see the traffic going fine thru all connections on host side =
and san side. Balancing works but too slow.

I set up w2003srv r2 with mpio on a second host - rate there is 280 MB/s =
with four nics.

Is it possible to get rates higher than one the rate on nic?

Regards Thomas



Mit freundlichen Gr=FC=DFen

Thomas F. Wenzel
_________________________________________________________________________=
_______
ESC58 - eine Kooperation der Firmen escape GmbH und fiftyeight GmbH www.e=
sc58.de

 =20
