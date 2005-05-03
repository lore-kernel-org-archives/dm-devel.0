From: "Magni Fabrizio" <Fabrizio.Magni@rasnet.it>
Subject: RE: Unable to use multipath with LVM2
Date: Tue, 3 May 2005 15:18:24 +0200
Message-ID: <BFCF159FFD14F444B205968F32DBD5BB01700379@MAILEX01.rasgroup.ita.localnet>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
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


> In SP2 and onwards, /dev/disk/by-name/ are symlinks to /dev/dm-* named
> after the mappings.
>=20

There is no /dev/disk/by-name/ on SP1 but that's not a problem.
I can create my own links to dm-* using multipath.conf and udev.rules.

The real issue is that they are not scanned by LVM2. :(

Is there a release date for SP2?
Any chance to ask for a beta?

Fabrizio
