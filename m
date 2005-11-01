From: "Brian Wong" <bwong@pillardata.com>
Subject: RE: latest device-mapper cvs @ 1.02.00,
	but latestmultipath-tools requires 01.03.00 ?
Date: Tue, 1 Nov 2005 15:38:05 -0800
Message-ID: <35D744B011AD9A4A86B5962E85181C78027AB670@caex02.trans.corp>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

>=20
> xa-s05:~/scm/multipath-tools-0.4.6# dmsetup version
> Library version:   1.01.05 (2005-09-26)
> Driver version:    4.4.0

Updating to an SLES9 SP2 kernel package did the trick.  Thanks all.

- bwong@sneezy$ su -c 'dmsetup version'
Password:
Library version:   1.01.01 (2005-03-29)
Driver version:    4.4.0
- bwong@sneezy$ uname -a
Linux sneezy 2.6.5-7.191-bigsmp #1 SMP Tue Jun 28 14:58:56 UTC 2005 i686
i686 i386 GNU/Linux

=20
