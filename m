From: "Charles Polk" <Charles.Polk@vion.com>
Subject: RE: Multipath not re-activating failed paths?
Date: Thu, 14 Sep 2006 22:59:49 -0400
Message-ID: <7221D0B8D5D73A4F81D21DFE8332D12C4BC9C7@condor.www.vionnet.com>
References: <46253.203.97.62.217.1158278020.squirrel@pythonhacker.is-a-geek.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----_=_NextPart_001_01C6D873.3CC3FE2B"
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
To: esrever_otua@pythonhacker.is-a-geek.net, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

------_=_NextPart_001_01C6D873.3CC3FE2B
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Depending on your version, I was instructed to raise the PROCESS' =
PRIORITY to
get the response.
=20
Charles Polk
Systems Engineer, ViON Corporation
Voice: 202.467.5500 x236, Cell: 301.518.9266, Fax: 202.342.1404
Email:Charles.Polk@vion.com, Web: www.vion.com

________________________________

From: dm-devel-bounces@redhat.com on behalf of Darryl Dixon
Sent: Thu 9/14/2006 7:53 PM
To: dm-devel@redhat.com
Subject: [dm-devel] Multipath not re-activating failed paths?



Hi All,

I have a working dm-multipath set up with a multipath root device. For
some reason, while multipath seems to correctly use both paths, and will
gracefully handle the failing of a path (uninterrupted IO works OK), it
does not seem to want to detect once the failed path has come back up
again. In other words, in my two-path setup, it will load balance =
between
the paths, continue successfully on one path when one fails, but it will
then be 'stuck' on that path forever until the next reboot, even if the
first path is back up and otherwise working fine.

From what I can understand of the multipath.conf settings, the paths
should be tested every 5 seconds, and should be marked 'active' once =
they
come back up.

How can I best go about debugging/investigating this?

My setup details:
Machine:     HP Blade BL25P with QLogic dual-ported HBA
Storage:     Two paths to SUN 3510
OS:          RHEL4 x86_64
DM package:  device-mapper-multipath-0.4.5-16.1.RHEL4
uname -r:    2.6.9-42.0.2.ELsmp

contents of /etc/multipath.conf:
----------8<----------[cut]
devnode_blacklist {
       devnode "^cciss!c[0-9]d[0-9]*"
}

defaults {
    user_friendly_names yes
    no_path_retry fail
    path_grouping_policy multibus
    failback immediate

}

multipaths {
    multipath {
        wwid   3500000e01190e340
        alias  os
    }
}
----------8<----------[cut]

Output of multipath -l:
----------8<----------[cut]
3500000e01190e100
[size=3D68 GB][features=3D"0"][hwhandler=3D"0"]
\_ round-robin 0 [active]
 \_ 0:0:3:0 sdd 8:48  [active]
 \_ 1:0:3:0 sdh 8:112 [active]

3500000e01190e3f0
[size=3D68 GB][features=3D"0"][hwhandler=3D"0"]
\_ round-robin 0 [active]
 \_ 0:0:1:0 sdb 8:16  [active]
 \_ 1:0:0:0 sde 8:64  [active]

os (3500000e01190e340)
[size=3D68 GB][features=3D"0"][hwhandler=3D"0"]
\_ round-robin 0 [active]
 \_ 0:0:0:0 sda 8:0   [active]
 \_ 1:0:2:0 sdg 8:96  [active]

3500000e01190e310
[size=3D68 GB][features=3D"0"][hwhandler=3D"0"]
\_ round-robin 0 [active]
 \_ 0:0:2:0 sdc 8:32  [active]
 \_ 1:0:1:0 sdf 8:80  [active]
----------8<----------[cut]

Contents of /dev/mapper/:
----------8<----------[cut]
brw-rw----  1 root disk 253,  3 Sep 15  2006 3500000e01190e100
brw-rw----  1 root disk 253,  2 Sep 15  2006 3500000e01190e310
brw-rw----  1 root disk 253,  1 Sep 15  2006 3500000e01190e3f0
crw-------  1 root root  10, 63 Sep 15  2006 control
brw-rw----  1 root disk 253,  0 Sep 15  2006 os
brw-rw----  1 root disk 253,  4 Sep 15  2006 os1
brw-rw----  1 root disk 253,  5 Sep 15  2006 os2
brw-rw----  1 root disk 253,  6 Sep 15  2006 os3
----------8<----------[cut]

Output of df -k:
----------8<----------[cut]
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/mapper/os2       50394996  29944792  17890248  63% /
/dev/mapper/os1         101086     23801     72066  25% /boot
none                   5036176         0   5036176   0% /dev/shm
----------8<----------[cut]


Any and all pointers or assistance appreciated.

regards,
Darryl Dixon
http://www.winterhouseconsulting.com =
<http://www.winterhouseconsulting.com/>=20

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel



------_=_NextPart_001_01C6D873.3CC3FE2B
Content-Type: application/ms-tnef;
	name="winmail.dat"
Content-Transfer-Encoding: base64

eJ8+Ih0DAQaQCAAEAAAAAAABAAEAAQeQBgAIAAAA5AQAAAAAAADoAAEIgAcAGAAAAElQTS5NaWNy
b3NvZnQgTWFpbC5Ob3RlADEIAQ2ABAACAAAAAgACAAEEgAEAOQAAAFJFOiBbZG0tZGV2ZWxdIE11
bHRpcGF0aCBub3QgcmUtYWN0aXZhdGluZyBmYWlsZWQgcGF0aHM/AFIUAQWAAwAOAAAA1gcJAA4A
FgA7ADEABAB6AQEggAMADgAAANYHCQAOABcAAQAbAAQAKwEBCYABAB8AAABCMjU4NzRDRUM3MEE0
NUFDM0NGOUNBRDRERUY5QzEAGQcBA5AGAAQeAAA4AAAAAwA2AAAAAABAADkATMXSAXPYxgEeAD0A
AQAAAAUAAABSRTogAAAAAAIBRwABAAAANwAAAGM9dXM7YT0gO3A9VmlPTkV4Y2hhbmdlMjAwMDts
PUNPTkRPUi0wNjA5MTUwMzAxMjdaLTYyMwAAHgBJAAEAAAA1AAAAW2RtLWRldmVsXSBNdWx0aXBh
dGggbm90IHJlLWFjdGl2YXRpbmcgZmFpbGVkIHBhdGhzPwAAAABAAE4AAJqTAFnYxgEeAFoAAQAA
ABwAAABkbS1kZXZlbC1ib3VuY2VzQHJlZGhhdC5jb20AAgFbAAEAAABVAAAAAAAAAIErH6S+oxAZ
nW4A3QEPVAIAAAAAZG0tZGV2ZWwtYm91bmNlc0ByZWRoYXQuY29tAFNNVFAAZG0tZGV2ZWwtYm91
bmNlc0ByZWRoYXQuY29tAAAAAAIBXAABAAAAIQAAAFNNVFA6RE0tREVWRUwtQk9VTkNFU0BSRURI
QVQuQ09NAAAAAB4AXQABAAAADQAAAERhcnJ5bCBEaXhvbgAAAAACAV4AAQAAAFIAAAAAAAAAgSsf
pL6jEBmdbgDdAQ9UAgAAAABEYXJyeWwgRGl4b24AU01UUABlc3JldmVyX290dWFAcHl0aG9uaGFj
a2VyLmlzLWEtZ2Vlay5uZXQAAAACAV8AAQAAAC0AAABTTVRQOkVTUkVWRVJfT1RVQUBQWVRIT05I
QUNLRVIuSVMtQS1HRUVLLk5FVAAAAAAeAGYAAQAAAAUAAABTTVRQAAAAAB4AZwABAAAAHAAAAGRt
LWRldmVsLWJvdW5jZXNAcmVkaGF0LmNvbQAeAGgAAQAAAAUAAABTTVRQAAAAAB4AaQABAAAAKAAA
AGVzcmV2ZXJfb3R1YUBweXRob25oYWNrZXIuaXMtYS1nZWVrLm5ldAAeAHAAAQAAADUAAABbZG0t
ZGV2ZWxdIE11bHRpcGF0aCBub3QgcmUtYWN0aXZhdGluZyBmYWlsZWQgcGF0aHM/AAAAAAIBcQAB
AAAAGwAAAAHG2FkJnDG1E1HRcEifnMlbcCqTF9IABn4NwQAeAHQAAQAAABQAAABkbS1kZXZlbEBy
ZWRoYXQuY29tAB4AGgwBAAAADQAAAENoYXJsZXMgUG9sawAAAAAeAB0OAQAAADUAAABbZG0tZGV2
ZWxdIE11bHRpcGF0aCBub3QgcmUtYWN0aXZhdGluZyBmYWlsZWQgcGF0aHM/AAAAAAIBCRABAAAA
JxYAACMWAAD0YgAATFpGdUW61bgDAAoAcmNwZzEyNYIyA0NodG1sMQMwPwEDAfcKgAKkA+MCAGNo
wQrAc2V0MCAHEwKA/xADAFAEVghVB7IR1Q5RAwHdENcyBgAGwxHVMwRGENlZEu9mNAPGEYo1A8ZC
GG9vaxFwAjBpcXWKYRHVNgPGVGFoA3FvAoAR4wjvCfc7HT8OMDXvHl8ePwpBDiA4IN8fYxHhnQxg
YwBQCwkBZDM2EWDJC6U0IBACKlwOsgGQAQ4QOSA8SFRNTCAgZGlyPSZwcj6efSYzACEDMCeBZG8A
4PMngQqxXHEdICeBEPADMDcn5RFgJeszJcAm4EVBJkQnsCXsNzcm0FRJOFRMRSvdJbAO8FtkhG0t
AQB2ZWxdBdAmdSZwBSBhdCnAbm/bBUAfwC0A0BqQdi+gC4CoZyBmC3BsCYAgL5Kkcz8r7Tg1JtAv
LR+7JoIK4yAzfzSPDhA2DvDAPE1FVEEgBaACMDEJ8HQ9IgXgJvM2LiAwMC4yOTizNjMKIi/QYQeA
PUdFTsBFUkFUT1Ir3S5hXzLwK58uMTW/JoE1EWA8cEJPRFkr3SUxPR9nAzlAJtBESVYgaWSCPUFw
T1dBUmULUAB5VGV4dDUxM/828Cc/KEAAACjlKYMpQSnffz8/QE9BUELvQ/9FCiYJNk40SOpFPyZk
NDgm0EboT05UMPFjOcAHEzeBWRzRPSM4sE/yIACQet05wDJI2xgwAzBjE/ADsvsB0EUZREIACfBI
YDDRAiC0IHkIYSAu8BEgaQIgwCwgSSB3YQQgC4CecyeQI8A3wDFQdG8wEBcLcBEwVcBoVkBQUk+g
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
n+fJZURhR6JzaPb8fA99H//vL/A/8U/yX9af16/nX93/H98P4B/hL+I/40ZBbnkIIGFuIwBhbGwg
THBv4tD20HJz65Bysebwc3Np9sDnAGMjoEFH8XJlY2lhJFEuf+PP5N/i7+nv6v/sCekgZ+BhcmRz
LOy/7c/r3BJE7+ByeedgRGl4DySf8S/rv9MNPEEgaBHpIGY9ItugdHA6SC8vd/jwLnfno2jLJCAj
0GPz0HN19ID2AMRnLvngbS8i9Tn0EKBmaWVsZPQSZvvgA/YA6IB7SFlQRVLgTElOSyD4f/mP+pM8
fX37kfvg5+D0gFxj+GYxXPog9dD2Z/1//o//+qDbl/VH7JAD7+yOPcD08PwvQfUw8//1D/YfB+8I
/4/Y6wq/C88J3GRtLUeh3fvQIEfgI1D6USAJsOiALw3fDu8P/xEDQOkgZGh/6WD6ghIvEz8J3/cv
+DdznwHlFbhH0SNQR+BuLxHi+RhgZm9HkBDl+t/77/z6/xsvHD8dSf/fAO4gzyHfHUj/BS8E/xj/
Bx8WzxffKn8s0oI1LSEvRk9OVC158yj/LfBccO/gMVgueC4QXzKRLn8shndgK9FQLB4wYffRL0RJ
VjCvNM9nhDU4K9FCT0RZLB2EMjcr0UhUTUwtcAJ9PDAAHgA1EAEAAABAAAAAPDcyMjFEMEI4RDVE
NzNBNEY4MUQyMURGRTgzMzJEMTJDNEJDOUM3QGNvbmRvci53d3cudmlvbm5ldC5jb20+AB4AORAB
AAAARQAAADw0NjI1My4yMDMuOTcuNjIuMjE3LjExNTgyNzgwMjAuc3F1aXJyZWxAcHl0aG9uaGFj
a2VyLmlzLWEtZ2Vlay5uZXQ+AAAAAB4ARxABAAAADwAAAG1lc3NhZ2UvcmZjODIyAAALAPIQAQAA
AB8A8xABAAAAggAAAFIARQAlADMAQQAgAFsAZABtAC0AZABlAHYAZQBsAF0AIABNAHUAbAB0AGkA
cABhAHQAaAAgAG4AbwB0ACAAcgBlAC0AYQBjAHQAaQB2AGEAdABpAG4AZwAgAGYAYQBpAGwAZQBk
ACAAcABhAHQAaABzACUAMwBGAC4ARQBNAEwAAAAAAAsA9hAAAAAAQAAHMEzF0gFz2MYBQAAIMN7p
zzxz2MYBAwDeP69vAAADAPE/CQQAAB4A+D8BAAAADQAAAENoYXJsZXMgUG9sawAAAAACAfk/AQAA
AGcAAAAAAAAA3KdAyMBCEBq0uQgAKy/hggEAAAAAAAAAL089VklPTkVYQ0hBTkdFMjAwMC9PVT1G
SVJTVCBBRE1JTklTVFJBVElWRSBHUk9VUC9DTj1SRUNJUElFTlRTL0NOPUNIQVJMRVMAAB4A+j8B
AAAAFQAAAFN5c3RlbSBBZG1pbmlzdHJhdG9yAAAAAAIB+z8BAAAAHgAAAAAAAADcp0DIwEIQGrS5
CAArL+GCAQAAAAAAAAAuAAAAAwD9P+QEAAADABlAAAAAAAMAGkAAAAAAAwAdQAAAAAADAB5AAAAA
AB4AMEABAAAACAAAAENIQVJMRVMAHgAxQAEAAAAIAAAAQ0hBUkxFUwAeADJAAQAAABwAAABkbS1k
ZXZlbC1ib3VuY2VzQHJlZGhhdC5jb20AHgAzQAEAAAAoAAAAZXNyZXZlcl9vdHVhQHB5dGhvbmhh
Y2tlci5pcy1hLWdlZWsubmV0AB4AOEABAAAACAAAAENIQVJMRVMAHgA5QAEAAAACAAAALgAAAAMA
dkD/////CwApAAAAAAALACMAAAAAAAMABhDOkRerAwAHEL8KAAADABAQAAAAAAMAERAAAAAAHgAI
EAEAAABlAAAAREVQRU5ESU5HT05ZT1VSVkVSU0lPTixJV0FTSU5TVFJVQ1RFRFRPUkFJU0VUSEVQ
Uk9DRVNTUFJJT1JJVFlUT0dFVFRIRVJFU1BPTlNFQ0hBUkxFU1BPTEtTWVNURU1TRU5HSQAAAAAC
AX8AAQAAAEAAAAA8NzIyMUQwQjhENUQ3M0E0RjgxRDIxREZFODMzMkQxMkM0QkM5QzdAY29uZG9y
Lnd3dy52aW9ubmV0LmNvbT4Ahkw=

------_=_NextPart_001_01C6D873.3CC3FE2B
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


------_=_NextPart_001_01C6D873.3CC3FE2B--
