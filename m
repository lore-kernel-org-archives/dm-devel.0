From: Guido Guenther <agx@sigxcpu.org>
Subject: Multipath: [patch] exclude meta data dirs
Date: Sun, 10 Jun 2007 22:47:50 +0200
Message-ID: <20070610204749.GA6493@bogon.ms20.nix>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@free.fr>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

make sure we don't try to build in .svn, .pc, .git or other SCM metadata
directories.
Cheers,
 -- Guido

Signed-Off-By: Guido G=FCnther <agx@sigxcpu.org>

Index: multipath-tools/Makefile
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- multipath-tools.orig/Makefile	2006-12-17 20:22:51.000000000 +0100
+++ multipath-tools/Makefile	2006-12-17 20:23:04.000000000 +0100
@@ -20,7 +20,7 @@
 export KRNLSRC
 export KRNLOBJ
=20
-BUILDDIRS =3D $(shell find . -mindepth 2 -name Makefile -exec dirname {}=
 \; | grep -v ^lib)
+BUILDDIRS =3D $(shell find . -mindepth 2 -name Makefile -exec dirname {}=
 \; | grep -vE '^lib|/\.')
=20
 ifeq   ($(MULTIPATH_VERSION),)
 VERSION =3D $(shell basename ${PWD} | cut -d'-' -f3)
