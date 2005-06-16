From: "Nitin Chandna" <cnitin@cisco.com>
Subject: RE: Multipath tool for 2.6.9 RHEL 4 U1
Date: Thu, 16 Jun 2005 16:18:25 +0530
Message-ID: <200506161041.AME01522@ind-mira-01.cisco.com>
References: <1115934399.2277.94.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1115934399.2277.94.camel@zezette>
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
Cc: 'christophe varoqui' <christophe.varoqui@free.fr>
List-Id: dm-devel.ids

Hi,

I am working with testing of iSCSI Initiators and iSCSI targets in India and
was wondering how would multipathing work with iSCSI disks.

I have the Red Hat's recent RHEL 4 U1 kernel available:
# uname -a
Linux cnitin-linux-6 2.6.9-11.ELsmp #1 SMP Fri May 20 18:26:27 EDT 2005 i686
i686 i386 GNU/Linux

I understand that device-mapper is the kernel component and multipath-tools
is the user space component. My understanding is that RHEL 4 U1 already has
the device mapper integrated.

I downloaded multipath-tools-0.4.4.tar.bz2  from the URL:
http://christophe.varoqui.free.fr, but during compilation, I am getting the
following error:
/****************************************************/
[root@cnitin-linux-6 multipath-tools-0.4.4]# make
make[1]: Entering directory
`/usr/src/iscsi/tools/multipath-tools-0.4.4/libmultipath'
rm -f core *.o *.gz
cc -pipe -g -Wall -Wunused -Wstrict-prototypes   -c -o memory.o memory.c
cc -pipe -g -Wall -Wunused -Wstrict-prototypes   -c -o parser.o parser.c
cc -pipe -g -Wall -Wunused -Wstrict-prototypes   -c -o vector.o vector.c
cc -pipe -g -Wall -Wunused -Wstrict-prototypes   -c -o devmapper.o
devmapper.c
devmapper.c: In function `dm_prereq':
devmapper.c:24: warning: implicit declaration of function
`dm_task_no_open_count'
cc -pipe -g -Wall -Wunused -Wstrict-prototypes   -c -o callout.o callout.c
cc -pipe -g -Wall -Wunused -Wstrict-prototypes   -c -o hwtable.o hwtable.c
cc -pipe -g -Wall -Wunused -Wstrict-prototypes   -c -o blacklist.o
blacklist.c
cc -pipe -g -Wall -Wunused -Wstrict-prototypes   -c -o util.o util.c
cc -pipe -g -Wall -Wunused -Wstrict-prototypes   -c -o dmparser.o dmparser.c
cc -pipe -g -Wall -Wunused -Wstrict-prototypes   -c -o config.o config.c
cc -pipe -g -Wall -Wunused -Wstrict-prototypes   -c -o structs.o structs.c
cc -pipe -g -Wall -Wunused -Wstrict-prototypes   -c -o cache.o cache.c
cc -pipe -g -Wall -Wunused -Wstrict-prototypes   -c -o discovery.o
discovery.c
cc -pipe -g -Wall -Wunused -Wstrict-prototypes   -c -o propsel.o propsel.c
cc -pipe -g -Wall -Wunused -Wstrict-prototypes   -c -o dict.o dict.c
cc -pipe -g -Wall -Wunused -Wstrict-prototypes   -c -o pgpolicies.o
pgpolicies.c
cc -pipe -g -Wall -Wunused -Wstrict-prototypes   -c -o debug.o debug.c
cc -pipe -g -Wall -Wunused -Wstrict-prototypes   -c -o regex.o regex.c
cc -pipe -g -Wall -Wunused -Wstrict-prototypes   -c -o defaults.o defaults.c
ar rs libmultipath-glibc.a *.o
make[1]: Leaving directory
`/usr/src/iscsi/tools/multipath-tools-0.4.4/libmultipath'
make[1]: Entering directory
`/usr/src/iscsi/tools/multipath-tools-0.4.4/libcheckers'
rm -f core *.o *.gz
cc    -c -o readsector0.o readsector0.c
cc    -c -o tur.o tur.c
cc    -c -o selector.o selector.c
cc    -c -o emc_clariion.o emc_clariion.c
ar rs libcheckers-glibc.a *.o
make[1]: Leaving directory
`/usr/src/iscsi/tools/multipath-tools-0.4.4/libcheckers'
make[1]: Entering directory
`/usr/src/iscsi/tools/multipath-tools-0.4.4/path_priority'
rm -f core *.o *.gz
cc -pipe -g -Wall -Wunused -Wstrict-prototypes -I../libmultipath -DDEBUG=0
-c -o pp_balance_units.o pp_balance_units.c
cc -o pp_balance_units pp_balance_units.o
../libmultipath/libmultipath-glibc.a -ldevmapper
strip --strip-all -R .comment -R .note pp_balance_units
make[2]: Entering directory
`/usr/src/iscsi/tools/multipath-tools-0.4.4/path_priority/pp_emc'
cc -o pp_emc pp_emc.o 
strip --strip-all -R .comment -R .note pp_emc
make[2]: Leaving directory
`/usr/src/iscsi/tools/multipath-tools-0.4.4/path_priority/pp_emc'
make[2]: Entering directory
`/usr/src/iscsi/tools/multipath-tools-0.4.4/path_priority/pp_alua'
cc -o pp_alua main.o rtpg.o 
strip --strip-all -R .comment -R .note pp_alua
make[2]: Leaving directory
`/usr/src/iscsi/tools/multipath-tools-0.4.4/path_priority/pp_alua'
make[1]: Leaving directory
`/usr/src/iscsi/tools/multipath-tools-0.4.4/path_priority'
make[1]: Entering directory
`/usr/src/iscsi/tools/multipath-tools-0.4.4/devmap_name'
rm -f core *.o *.gz
cc -pipe -g -Wall -Wunused -Wstrict-prototypes   -c -o devmap_name.o
devmap_name.c
devmap_name.c: In function `dm_target_type':
devmap_name.c:31: warning: implicit declaration of function
`dm_task_no_open_count'
cc -o devmap_name devmap_name.o -ldevmapper
devmap_name.o(.text+0xb6): In function `dm_target_type':
/usr/src/iscsi/tools/multipath-tools-0.4.4/devmap_name/devmap_name.c:31:
undefined reference to `dm_task_no_open_count'
collect2: ld returned 1 exit status
make[1]: *** [glibc] Error 1
make[1]: Leaving directory
`/usr/src/iscsi/tools/multipath-tools-0.4.4/devmap_name'
make: *** [recurse] Error 2
[root@cnitin-linux-6 multipath-tools-0.4.4]# 
/****************************************************/

How can I overcome this compilation issue? Please let me know if you will
need any more information from me to resolve this issue?

Regards,
Nitin

-----Original Message-----
From: christophe varoqui [mailto:christophe.varoqui@free.fr] 
Sent: Friday, May 13, 2005 3:17 AM
To: Nitin Chandna
Subject: RE: Multipath tool for 2.6.9 RHEL 4 U1

RedHat patches its kernels, so their 2.6.9 might have the adequate DM
fonctionnality for 0.4.4 to compile and run.

Again, post the build log if you want this thread to go somewhere :)

Regards,
cvaroqui

On jeu, 2005-05-12 at 18:15 +0530, Nitin Chandna wrote:
> 0.4.4 was meant for 2.6.10 onwards, whereas I was aiming at 2.6.9 RHEL 
> 4 U1 kernel, that's where the compilation seems to be failing for 
> 0.4.4. Any clue which version would suite the mentioned kernel?
> 
> Regards,
> Nitin
> 
> -----Original Message-----
> From: Christophe Varoqui [mailto:christophe.varoqui@free.fr]
> Sent: Thursday, May 12, 2005 6:13 PM
> To: Nitin Chandna
> Subject: Re: Multipath tool for 2.6.9 RHEL 4 U1
> 
> Try the lastest stable release : 0.4.4
> 
> Multipath-tools are the userspace part of the Linux multipath 
> implementation. The kernel part is a Device Mapper target module.
> 
> Regards,
> cvaroqui
> 
> On Thu, May 12, 2005 at 05:38:19PM +0530, Nitin Chandna wrote:
> > Hi Christophe,
> > 
> > Will be able to suggest the appropriate version of multipath tools for
me?
> > I was also wondering if Device Mapper has the same functionality as 
> > multipath tools - though I am sure that is used for making RAID systems.
> > 
> > Regards,
> > Nitin
> > 
> > -----Original Message-----
> > From: Nitin Chandna [mailto:cnitin@cisco.com]
> > Sent: Thursday, May 05, 2005 10:58 AM
> > To: 'christophe varoqui'
> > Subject: RE: Multipath tool for 2.6.9 RHEL 4 U1
> > 
> > Hi Christopher,
> > 
> > I am planning to test Linux LVM with alternate-path SW from RH 
> > Release
> > 4 update 1 with Cisco iSCSI Targets. I was not sure whether the 
> > multipath tools are packaged as RPM in this kernel itself. If 
> > packaged, then under what name I can search them.
> > I would be grateful, if you can let me know or put me to the 
> > concerned person to determine the correct version recommended for 
> > Multipath tools by Red Hat.
> > 
> > We are currently not trying to do any development on this.
> > 
> > Thanks and Regards,
> > Nitin
> > 
> > -----Original Message-----
> > From: christophe varoqui [mailto:christophe.varoqui@free.fr]
> > Sent: Thursday, May 05, 2005 4:01 AM
> > To: smithan@cisco.com
> > Cc: dm-devel@redhat.com; 'Nitin Chandna'
> > Subject: Re: Multipath tool for 2.6.9 RHEL 4 U1
> > 
> > On mer, 2005-05-04 at 18:17 +0530, Smitha Narayanaswamy (smithan) wrote:
> > > Hi,
> > > Which is the version of the multipath tool to be used for 2.6.9 
> > > RHEL
> > > 4
> > > U1 kernel?
> > > 
> > Depends on your objectives.
> > 
> > If you intend to do useful things with this server, you should stick 
> > with to tools version provided by RedHat.
> > 
> > On the other hand, if you want to help with the development, you 
> > should stick with upstream kernel+udm patches and upstream tools 
> > from kernel.org git repository.
> > 
> > Regards,
> > --
> > christophe varoqui <christophe.varoqui@free.fr>
--
christophe varoqui <christophe.varoqui@free.fr>
