From: heinzm@sourceware.org
Subject: dmraid dmraid.spec
Date: 19 Sep 2008 14:38:15 -0000
Message-ID: <20080919143815.23363.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	dmraid
Changes by:	heinzm@sourceware.org	2008-09-19 14:38:15

Modified files:
	.              : dmraid.spec 

Log message:
	

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/dmraid.spec.diff?cvsroot=dm&r1=1.4&r2=1.5

--- dmraid/dmraid.spec	2008/09/19 14:31:11	1.4
+++ dmraid/dmraid.spec	2008/09/19 14:38:14	1.5
@@ -6,18 +6,15 @@
 
 Summary: dmraid (Device-mapper RAID tool and library)
 Name: dmraid
-Version: 1.0.0.rc11
-Release: 1
+Version: 1.0.0.rc15-pre
+Release: 1%{?dist}
 License: GPL
 Group: System Environment/Base
 URL: http://people.redhat.com/heinzm/sw/dmraid
 BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-buildroot
-Source: ftp://people.redhat.com/heinzm/sw/dmraid/src/dmraid-%{version}.tar.bz2
-
-ExcludeArch:	s390
-ExcludeArch:	s390x
-
-%define dmraid_build_dso 0
+BuildRequires: device-mapper >= 1.02.02-2, libselinux-devel, libsepol-devel
+Requires: kpartx dmraid = %{version}-%{release}
+Source: ftp://people.redhat.com/heinzm/sw/dmraid/src/%{name}-%{version}.tar.bz2
 
 %description
 DMRAID supports RAID device discovery, RAID set activation and display of
@@ -35,17 +32,12 @@
 %setup -q -n dmraid/%{version}
 
 %build
-%configure --prefix=${RPM_BUILD_ROOT}/usr --sbindir=${RPM_BUILD_ROOT}/sbin --libdir=${RPM_BUILD_ROOT}/%{_libdir} --mandir=${RPM_BUILD_ROOT}/%{_mandir} --includedir=${RPM_BUILD_ROOT}/%{_includedir} --enable-debug --enable-libselinux --enable-static_link
+%configure --prefix=${RPM_BUILD_ROOT}/usr --sbindir=${RPM_BUILD_ROOT}/sbin --libdir=${RPM_BUILD_ROOT}/%{_libdir} --mandir=${RPM_BUILD_ROOT}/%{_mandir} --includedir=${RPM_BUILD_ROOT}/%{_includedir} --enable-debug --enable-libselinux --enable-libsepol --enable-static_link
 make DESTDIR=$RPM_BUILD_ROOT
 mv tools/dmraid tools/dmraid.static
 make clean
-%configure --prefix=${RPM_BUILD_ROOT}/usr --sbindir=${RPM_BUILD_ROOT}/sbin --libdir=${RPM_BUILD_ROOT}/%{_libdir} --mandir=${RPM_BUILD_ROOT}/%{_mandir} --includedir=${RPM_BUILD_ROOT}/%{_includedir} --enable-debug --enable-libselinux --disable-static_link
-%if "%{dmraid_build_dso}" == "1"
-(cd lib ; make DESTDIR=$RPM_BUILD_ROOT libdmraid.so)
-make DESTDIR=$RPM_BUILD_ROOT
-%else
-make DESTDIR=$RPM_BUILD_ROOT
-%endif
+%configure --prefix=${RPM_BUILD_ROOT}/usr --sbindir=${RPM_BUILD_ROOT}/sbin --libdir=${RPM_BUILD_ROOT}/%{_libdir} --mandir=${RPM_BUILD_ROOT}/%{_mandir} --includedir=${RPM_BUILD_ROOT}/%{_includedir} --enable-debug --enable-libselinux --enable-libsepol --disable-static_link
+make -C lib DESTDIR=$RPM_BUILD_ROOT libdmraid.so
 
 %install
 rm -rf $RPM_BUILD_ROOT
@@ -54,15 +46,12 @@
 install -m 755 tools/dmraid.static $RPM_BUILD_ROOT/sbin/dmraid.static
 install -m 644 include/dmraid/*.h $RPM_BUILD_ROOT%{_includedir}/dmraid/
 
-# install the static library
-install -m 755 lib/libdmraid.a $RPM_BUILD_ROOT%{_libdir}
-
 # if requested, install the dso
-%if "%{dmraid_build_dso}" == "1"
 install -m 755 lib/libdmraid.so \
 	$RPM_BUILD_ROOT%{_libdir}/libdmraid.so.%{version}
 (cd $RPM_BUILD_ROOT/%{_libdir} ; ln -sf libdmraid.so.%{version} libdmraid.so)
-%endif
+
+rm -f $RPM_BUILD_ROOT/%{_libdir}/libdmraid.a
 
 %clean
 rm -rf $RPM_BUILD_ROOT
@@ -72,25 +61,138 @@
 %doc CHANGELOG CREDITS KNOWN_BUGS LICENSE LICENSE_GPL LICENSE_LGPL README TODO doc/dmraid_design.txt
 /%{_mandir}/man8/*
 /sbin/*
-%if "%{dmraid_build_dso}" == "1"
 %{_libdir}/libdmraid.so.*
-%endif
+/var/lock/dmraid
 
 %files -n dmraid-devel
 %defattr(-,root,root)
 %dir %{_includedir}/dmraid
 %{_includedir}/dmraid/*
-%{_libdir}/libdmraid.a
-
-%if "%{dmraid_build_dso}" == "1"
 %{_libdir}/libdmraid.so
-%endif
 
 %changelog
-* Fri Feb 17 2006 Heinz Mauelshagen <jheinzm@redhat.com> - 1.0.0.rc9-FC5_5.3
+* Wed Sep 17 2008 Heinz Mauelshagen <heinzm@redhat.com> - 1.0.0.rc15
+- Added support for RAID set create/delete/rebuild and event handling
+  (Intel contributions)
+- Resolves: rhbz#437169 rhbz#437173 rhbz#437177 rhbz#439088
+
+* Fri Feb 08 2008 Ian Kent <ikent@redhat.com> - 1.0.0.rc15
+- Bug 427550: dmraid segfaults on boot resulting in broken mirror
+  - patch to fix SEGV when requesting activation of invalid raid set.
+  the feature.
+  Related: rhbz#427550
+
+* Wed Feb 06 2008 Peter Jones <pjones@redhat.com> - 1.0.0.rc13-8
+- Revert fix for 381501, since the RHEL kernel doesn't currently support
+  the feature.
+  Related: rhbz#381501
+
+* Fri Jan 18 2008 Ian Kent <ikent@redhat.com> - 1.0.0.rc13-7
+- fix incorrectly applied patch in spec file.
+- Related: rhbz#236891
+
+* Wed Nov 21 2007 Ian Kent <ikent@redhat.com> - 1.0.0.rc13-6
+- Bug 381511: dmraid needs to generate UUIDs for lib device-mapper
+  - add patch to set UUID.
+  - add "DMRAID-" prefix to dmraid UUID string.
+- Bug 381501: dmraid needs to activate device-mapper mirror resynchronization error handling
+- Resolves: rhbz#381511 rhbz#381501
+
+* Fri Nov 2 2007 Ian Kent <ikent@redhat.com> - 1.0.0.rc13-5
+- Fix SEGV on "dmraid -r -E" (bz 236891)
+- Resolves: rhbz#236891
+
+* Mon Sep 10 2007 Heinz Mauelshagen <heinzm@redhat.com> - 1.0.0.rc13-4
+- Adjusted %dist to rebuild
+- Resolves: #211012
+
+* Mon Sep 10 2007 Heinz Mauelshagen <heinzm@redhat.com> - 1.0.0.rc13-4
+- Missed a bug with dm map names
+- Resolves: #211012
+
+* Tue Jun 26 2007 Heinz Mauelshagen <heinzm@redhat.com> - 1.0.0.rc13-3
+- Fix dmraid map names
+- Resolves: #211012
+- Fix unaligned access messages
+  Resolves: #210361, #211150
+- Fix jmicron name parsing (bz#219058)
+
+* Wed Nov  8 2006 Peter Jones <pjones@redhat.com> - 1.0.0.rc13-2
+- We didn't change the API or ABI, so don't change the version number
+  because it'll change the SONAME, which means we have to needlessly rebuild
+  other packages.
+
+* Wed Nov 08 2006 Heinz Mauelshagen <heinzm@redhat.com> - 1.0.0.rc14-1
+- asr.c: fixed Adaptec HostRAID DDF1 metadata discovery (bz#211016)
+- ddf1_crc.c: added crc() routine to avoid linking to zlib alltogether,
+              because Ubuntu had problems with this
+- dropped zlib build requirement
+
+* Thu Oct 26 2006 Heinz Mauelshagen <heinzm@redhat.com> - 1.0.0.rc14-bz211016-1
+- ddf1.c: get_size() fixed (bz#211016)
+- ddf1_lib.c: ddf1_cr_off_maxpds_helper() fixed (bz#211016)
+
+* Wed Oct 11 2006 Heinz Mauelshagen <heinzm@redhat.com> - 1.0.0.rc13-1
+- metadata.c: fixed bug returning wrang unified RAID type (bz#210085)
+- pdc.c: fixed magic number check
+
+* Sun Oct 01 2006 Jesse Keating <jkeating@redhat.com> - 1.0.0.rc12-7
+- rebuilt for unwind info generation, broken in gcc-4.1.1-21
+
+* Fri Sep 22 2006 Heinz Mauelshagen <heinzm@redhat.com> - 1.0.0.rc12-1
+- sil.c: quorate() OBO fix
+- activate.c: handler() OBO fix
+- added SNIA DDF1 support
+- added reload functionality to devmapper.c
+- added log_zero_sectors() to various metadata format handlers
+- sil.[ch]: added JBOD support
+
+* Fri Sep  1 2006 Peter Jones <pjones@redhat.com> - 1.0.0.rc11-4
+- Require kpartx, so initscripts doesn't have to if you're not using dmraid
+
+* Thu Aug 17 2006 Jesse Keating <jkeating@redhat.com> - 1.0.0.rc11-3
+- Change Release to follow guidelines, and add dist tag.
+
+* Thu Aug 17 2006 Peter Jones <pjones@redhat.com> - 1.0.0.rc11-FC6.3
+- No more excludearch for s390/s390x
+
+* Fri Jul 28 2006 Peter Jones <pjones@redhat.com> - 1.0.0.rc11-FC6.2
+- Fix bounds checking on hpt37x error log
+- Only build the .so, not the .a
+- Fix asc.c duplication in makefile rule
+
+* Wed Jul 12 2006 Jesse Keating <jkeating@redhat.com> - 1.0.0.rc11-FC6.1.1
+- rebuild
+
+* Fri Jul  7 2006 Heinz Mauelshagen <heinzm@redhat.com> - 1.0.0.rc11-FC6.1
+- rebuilt for FC6 with dos partition discovery fix (#197573)
+
+* Tue May 16 2006 Heinz Mauelshagen <heinzm@redhat.com> - 1.0.0.rc11-FC6
+- rebuilt for FC6 with better tag
+
+* Tue May 16 2006 Heinz Mauelshagen <heinzm@redhat.com> - 1.0.0.rc11-FC5_7.2
+- rebuilt for FC5
+
+* Tue May 16 2006 Heinz Mauelshagen <heinzm@redhat.com> - 1.0.0.rc11-FC5_7.1
+- jm.c: checksum() calculation
+- misc.c: support "%d" in p_fmt and fix segfault with wrong format identifier
+- nv.c: size fix in setup_rd()
+- activate.c:
+        o striped devices could end on non-chunk boundaries
+        o calc_region_size() calculated too small sizes causing large
+          dirty logs in memory
+- isw.c: set raid5 type to left asymmetric
+- toollib.c: fixed 'No RAID...' message
+- support selection of RAID5 allocation algorithm in metadata format handlers
+- build
+
+* Mon Mar 27 2006 Milan Broz <mbroz@redhat.com> - 1.0.0.rc10-FC5_6.2
+- fixed /var/lock/dmraid in specfile (#168195)
+
+* Fri Feb 17 2006 Heinz Mauelshagen <heinzm@redhat.com> - 1.0.0.rc10-FC5_6
 - add doc/dmraid_design.txt to %doc (#181885)
-- add --enable-libselinux to configure
-- not build yet
+- add --enable-libselinux --enable-libsepol to configure
+- rebuilt
 
 * Fri Feb 10 2006 Jesse Keating <jkeating@redhat.com> - 1.0.0.rc9-FC5_5.2
 - bump again for double-long bug on ppc(64)
