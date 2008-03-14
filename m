From: Alexander Warmuth <WARMUTH@de.ibm.com>
Subject: Inconsistent results of different multipath options
Date: Fri, 14 Mar 2008 12:02:21 +0100
Message-ID: <OF4F96C5A5.DE843174-ONC125740C.00382EA3-C125740C.003CA421@de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids


Hello,

I am doing some tests with SLES10 SP2 beta4 and an IBM DS4700 Storage
system, particularly focusing on DM-MP with the DS4000.

When configuring DM-MP I get inconsistent results when running multipath
with various options. I also have a problem with path fail back, which I
will describe in a separate mail to avoid confusion.

Here's the setup:
- IBM System x 3650 server with 2 QLA2460 HBAs
- SLES10 SP2 beta4 X86_64 installed on internal disk
  - kernel-smp-2.6.16.60-0.6
  - multipath-tools-0.4.7-34.32
  - qla2xxx 8.02.00-k6-SLES10.2-02
- Brocade B32 4Gb switch, zoned that
  each HBA can see one DS4700 controller
- DS4700 presenting a 50 GB LUN to the server

Another system is equipped with 2 Emulex LP1150 HBAs,
running lpfc 8.2.0.19. All the rest is the same as above.

I looked at the HW table of the multipath tools:

device {
                vendor "IBM"
                product "1814"
                path_grouping_policy "group_by_prio"
                path_checker "rdac"
                hardware_handler "1 rdac"
                prio "rdac"
                no_path_retry "queue"
        }

and decided that the internal defaults are ok for me with 2 exceptions:
- I want immediate automatic fail back
- I don't want "queue if no path".

So my "/etc/multipath.conf" is quite simple and looks like this:

x3650-lab-11:~ # cat /etc/multipath.conf
defaults {
        no_path_retry           300
        features                "0"
        failback                immediate
        user_friendly_names     yes
        }

blacklist {
        devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
        devnode "^hd[a-z][[0-9]*]"
        devnode "^cciss!c[0-9]d[0-9]*[p[0-9]*]"
        wwid SServeRA_Daten_6673ADC0
        wwid SServeRA_OS_77F79DC0
        }


Here are the outputs of multipath with various options. Look at the
priority values and the [features=3D...] statement. BTW - the results are=
 the
same on the machine with LPFC HBAs and also if I use the mpath_prio_rdac
callout.

Dry-Run
-------

x3650-lab-11:~ # multipath -d
create: mpatha (3600a0b800011fa78000033d947d7650d) n/a IBM,1814      FASt=
T
[size=3D50G][features=3D0][hwhandler=3D1 rdac]
\_ round-robin 0 [prio=3D2][undef]
 \_ 4:0:0:0 sdd 8:48  [undef][ghost]
\_ round-robin 0 [prio=3D1][undef]
 \_ 3:0:0:0 sdc 8:32  [undef][ready]

Configure DM-MP
---------------

x3650-lab-11:~ # multipath
create: mpatha (3600a0b800011fa78000033d947d7650d) n/a IBM,1814      FASt=
T
[size=3D50G][features=3D0][hwhandler=3D1 rdac]
\_ round-robin 0 [prio=3D2][undef]
 \_ 4:0:0:0 sdd 8:48  [undef][ghost]
\_ round-robin 0 [prio=3D1][undef]
 \_ 3:0:0:0 sdc 8:32  [undef][ready]

Show multipath topology (sysfs and DM info)
-------------------------------------------

x3650-lab-11:~ # multipath -l
mpatha (3600a0b800011fa78000033d947d7650d) dm-0 IBM,1814      FAStT
[size=3D50G][features=3D1 queue_if_no_path][hwhandler=3D1 rdac]
\_ round-robin 0 [prio=3D-1][active]
 \_ 4:0:0:0 sdd 8:48  [active][undef]
\_ round-robin 0 [prio=3D-1][enabled]
 \_ 3:0:0:0 sdc 8:32  [active][undef]

Show multipath topology (maximum info)
--------------------------------------

x3650-lab-11:~ # multipath -ll
mpatha (3600a0b800011fa78000033d947d7650d) dm-0 IBM,1814      FAStT
[size=3D50G][features=3D1 queue_if_no_path][hwhandler=3D1 rdac]
\_ round-robin 0 [prio=3D3][active]
 \_ 4:0:0:0 sdd 8:48  [active][ready]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 3:0:0:0 sdc 8:32  [active][ghost]


The resulting device mapper table looks like this

x3650-lab-11:~ # dmsetup table mpatha
0 104857600 multipath 1 queue_if_no_path 1 rdac 2 1 round-robin 0 1 1 8:4=
8
1000 round-robin 0 1 1 8:32 1000


With this said, here are my questions:
- How can I avoid that "queue if no path" is set?
- Am I using an outdated version of multipath?
- Which of the different outputs is the correct one?
- What is the true configuration (I can't "read" the dm table)?
- Are the differences in output a bug or are they correct and I can't
interpret them?

Many thanks in advance ........... Alex




Mit freundlichen Gr=FC=DFen ... Kind regards ...
Alexander Warmuth

Advanced Technical Support System Storage Europe
Enterprise Disk High End Solutions

Mail: warmuth@de.ibm.com
Phone: +49-6131-84-2887
Mobile: +49-171-5506083

Request ATS support at
http://web.mainz.de.ibm.com/e_dir/esccw3.nsf/ContentDocsByTitle/Request+s=
upport


IBM Deutschland GmbH, Vorsitzender des Aufsichtsrats: Hans Ulrich Maerki,
Gesch=E4ftsf=FChrung: Martin Jetter (Vorsitzender), Christian Diedrich,
Christoph Grandpierre, Matthias Hartmann, Thomas Fell, Michael Diemer, Si=
tz
der Gesellschaft: Stuttgart, Registergericht: Amtsgericht Stuttgart, HRB
14562, WEEE-Reg.-Nr. DE 99369940
