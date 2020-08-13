From: "McIntyre, Vincent (CASS, Marsfield)" <Vincent.Mcintyre@csiro.au>
Subject: Re: Promise and ALUA
Date: Thu, 13 Aug 2020 23:51:43 +0000
Message-ID: <20200813235143.GB2644@mayhem.atnf.CSIRO.AU>
References: <20200810043316.GH21810@mayhem.atnf.CSIRO.AU>
	<8c910ecb-ddf8-0a91-4310-4daedb85cd89@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <8c910ecb-ddf8-0a91-4310-4daedb85cd89@gmail.com>
Content-Language: en-US
Content-ID: <3DCC61EC5FA6BB469026F334A210DAC8@ausprd01.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Aug 13, 2020 at 10:07:49PM +0200, Xose Vazquez Perez wrote:
>On 8/10/20 6:33 AM, McIntyre, Vincent (CASS, Marsfield) wrote:
>
>>for many years we have been operating some Promise VTrak arrays
>>without any use of the ALUA feature (largely so we don't have to
>>specify LUN affinities as well, which seems to be required).
>>
>>In the process of upgrading to Debian Buster
>>(multipath-tools 0.7.9 and kernel 4.19)
>>I find that I can no longer connect to our Promise arrays.
>>They are detected but the only useful output I get is
>>
>>  multipathd[986]: reconfigure (operator)
>>  multipathd[986]: sdc: alua not supported
>>  multipathd[986]: sdd: alua not supported
>>  multipathd[986]: sdr: alua not supported
>>  multipathd[986]: sde: alua not supported
>>  multipathd[986]: sdf: alua not supported
>>  multipathd[986]: sdg: alua not supported
>>  multipathd[986]: sdh: alua not supported
>>  multipathd[986]: sdi: alua not supported
>>
>>
>>I found the note in the manpage about alua being selected by
>>default for these arrays[1], but I'm taken aback that I'm not
>>allowed to override this.
>>
>>Is there really no support any more for choosing whether to use
>>ALUA or not?
>>
>>I have tried messing about with detect_prio, dectect_checker
>>and whatnot, to no avail.
>
>>[1] 9b5ea2eda85ae072cb697310807611c693713c2b
>>     libmultipath: retain_attached_hw_handler obsolete with 4.3+
>
>With the next array config and an empty /etc/multipath.conf,
>reboot the linux host and put the output of "multipath -ll"
>Redundancy Type: Active-Active
>LUN Affinity: Enable
>ALUA: Enable

TL;DR I found a way forward, manually running multipath -a.
Details below, and a suggested tweak to the manpage.

I created a new LUN on the vtrak and mapped it to the test host.
The host sees it, but as expected there's no new multipath yet.
lsscsi does not show a new set of scsi devices either,
which is also expected.

 qla2xxx [0000:04:00.0]-107ff:1: qla2x00_fcport_event_handler: schedule
 qla2xxx [0000:04:00.0]-107ff:1: qla_scan_work_fn: schedule loop resync
 qla2xxx [0000:04:00.0]-280e:1: HBA in F P2P topology.
 qla2xxx [0000:04:00.0]-2814:1: Configure loop -- dpc flags = 0x60.
 qla2xxx [0000:04:00.0]-107ff:1: qla2x00_fcport_event_handler: schedule
 qla2xxx [0000:04:00.0]-2858:1: GID_PT entry - nn 250100015553ce36 pn 260700015553ce36 portid=1e0260.
 qla2xxx [0000:04:00.0]-2858:1: GID_PT entry - nn 250100015553ce36 pn 260600015553ce36 portid=1e0280.
 qla2xxx [0000:04:00.0]-2858:1: GID_PT entry - nn 250000015553ce36 pn 260200015553ce36 portid=1e02a0.
 qla2xxx [0000:04:00.0]-2858:1: GID_PT entry - nn 250000015553ce36 pn 260300015553ce36 portid=1e02c0.
 qla2xxx [0000:04:00.0]-2858:1: GID_PT entry - nn 250000015553ce36 pn 260100015553ce36 portid=1e0300.
 qla2xxx [0000:04:00.0]-2858:1: GID_PT entry - nn 250000015553ce36 pn 260000015553ce36 portid=1e0320.
 qla2xxx [0000:04:00.0]-2858:1: GID_PT entry - nn 250100015553ce36 pn 260500015553ce36 portid=1e0340.
 qla2xxx [0000:04:00.0]-2858:1: GID_PT entry - nn 250100015553ce36 pn 260400015553ce36 portid=1e0360.
 qla2xxx [0000:04:00.0]-2858:1: GID_PT entry - nn 20000024ff002350 pn 21000024ff002350 portid=1e0500.
 qla2xxx [0000:04:00.0]-2858:1: GID_PT entry - nn 200200a098b16b5f pn 203300a098b16b5f portid=1e08a0.
 qla2xxx [0000:04:00.0]-2858:1: GID_PT entry - nn 200200a098b16b5f pn 203200a098b16b5f portid=1e08a1.
 qla2xxx [0000:04:00.0]-2858:1: GID_PT entry - nn 200200a098b16b5f pn 206300a098b16b5f portid=1e08c0.
 qla2xxx [0000:04:00.0]-2858:1: GID_PT entry - nn 200200a098b16b5f pn 204200a098b16b5f portid=1e08c1.
 qla2xxx [0000:04:00.0]-2858:1: GID_PT entry - nn 200200a098b16b5f pn 204300a098b16b5f portid=1e0900.
 qla2xxx [0000:04:00.0]-2858:1: GID_PT entry - nn 200200a098b16b5f pn 205200a098b16b5f portid=1e0920.
 qla2xxx [0000:04:00.0]-2858:1: GID_PT entry - nn 200200a098b16b5f pn 205300a098b16b5f portid=1e0940.
 qla2xxx [0000:04:00.0]-107ff:1: qla_scan_work_fn: schedule loop resync
 qla2xxx [0000:04:00.0]-2858:1: GID_PT entry - nn 200200a098b16b5f pn 206200a098b16b5f portid=1e0960.
 qla2xxx [0000:04:00.0]-286a:1: qla2x00_configure_loop *** FAILED ***.
 qla2xxx [0000:04:00.0]-280e:1: HBA in F P2P topology.
 qla2xxx [0000:04:00.0]-2814:1: Configure loop -- dpc flags = 0x60.
 qla2xxx [0000:04:00.0]-2858:1: GID_PT entry - nn 250100015553ce36 pn 260700015553ce36 portid=1e0260.
 qla2xxx [0000:04:00.0]-2858:1: GID_PT entry - nn 250100015553ce36 pn 260600015553ce36 portid=1e0280.
 qla2xxx [0000:04:00.0]-2858:1: GID_PT entry - nn 250000015553ce36 pn 260200015553ce36 portid=1e02a0.
 qla2xxx [0000:04:00.0]-2858:1: GID_PT entry - nn 250000015553ce36 pn 260300015553ce36 portid=1e02c0.
 qla2xxx [0000:04:00.0]-2858:1: GID_PT entry - nn 250000015553ce36 pn 260100015553ce36 portid=1e0300.
 qla2xxx [0000:04:00.0]-2858:1: GID_PT entry - nn 250000015553ce36 pn 260000015553ce36 portid=1e0320.
 qla2xxx [0000:04:00.0]-2858:1: GID_PT entry - nn 250100015553ce36 pn 260500015553ce36 portid=1e0340.
 qla2xxx [0000:04:00.0]-2858:1: GID_PT entry - nn 250100015553ce36 pn 260400015553ce36 portid=1e0360.
 qla2xxx [0000:04:00.0]-2858:1: GID_PT entry - nn 20000024ff002350 pn 21000024ff002350 portid=1e0500.
 qla2xxx [0000:04:00.0]-2858:1: GID_PT entry - nn 200200a098b16b5f pn 203300a098b16b5f portid=1e08a0.
 qla2xxx [0000:04:00.0]-2858:1: GID_PT entry - nn 200200a098b16b5f pn 203200a098b16b5f portid=1e08a1.
 qla2xxx [0000:04:00.0]-2858:1: GID_PT entry - nn 200200a098b16b5f pn 206300a098b16b5f portid=1e08c0.
 qla2xxx [0000:04:00.0]-2858:1: GID_PT entry - nn 200200a098b16b5f pn 204200a098b16b5f portid=1e08c1.
 qla2xxx [0000:04:00.0]-2858:1: GID_PT entry - nn 200200a098b16b5f pn 204300a098b16b5f portid=1e0900.
 qla2xxx [0000:04:00.0]-2858:1: GID_PT entry - nn 200200a098b16b5f pn 205200a098b16b5f portid=1e0920.
 qla2xxx [0000:04:00.0]-2858:1: GID_PT entry - nn 200200a098b16b5f pn 205300a098b16b5f portid=1e0940.
 qla2xxx [0000:04:00.0]-2858:1: GID_PT entry - nn 200200a098b16b5f pn 206200a098b16b5f portid=1e0960.
 qla2xxx [0000:04:00.0]-289f:1: Device wrap (1e0960).
 qla2xxx [0000:04:00.0]-2869:1: LOOP READY.
 qla2xxx [0000:04:00.0]-286b:1: qla2x00_configure_loop: exiting normally.

I emptied /etc/multipath.conf, ran update-initramfs -u and rebooted.
lsscsi shows multiple paths to the new LUN, but there's no new
multipath - all those shown below were already known to the system.
On earlier versions, the new multipath usually appeared automatically.

# multipath -ll

3600a098000b173f60000079e5da82d73 dm-12 DELL,MD38xxf
size=40T features='5 queue_if_no_path pg_init_retries 50 queue_mode mq' hwhandler='1 rdac' wp=rw
|-+- policy='service-time 0' prio=14 status=active
| |- 1:0:10:0  sdaa 65:160 active ready running
| |- 1:0:12:0  sdac 65:192 active ready running
| |- 1:0:14:0  sdae 65:224 active ready running
| `- 1:0:8:0   sdy  65:128 active ready running
`-+- policy='service-time 0' prio=9 status=enabled
  |- 1:0:11:0  sdab 65:176 active ready running
  |- 1:0:13:0  sdad 65:208 active ready running
  |- 1:0:7:0   sdx  65:112 active ready running
  `- 1:0:9:0   sdz  65:144 active ready running
Aug 14 09:33:02 | sdd: alua not supported
Aug 14 09:33:02 | sdg: alua not supported
Aug 14 09:33:02 | sdag: alua not supported
Aug 14 09:33:02 | sdj: alua not supported
Aug 14 09:33:02 | sdm: alua not supported
Aug 14 09:33:02 | sdp: alua not supported
Aug 14 09:33:02 | sds: alua not supported
Aug 14 09:33:02 | sdv: alua not supported
222e300015555469c dm-10 Promise,VTrak E830f
size=20T features='3 queue_if_no_path queue_mode mq' hwhandler='0' wp=rw
`-+- policy='service-time 0' prio=-1 status=active
  |- 1:0:0:20  sdd  8:48   active ready running
  |- 1:0:1:20  sdg  8:96   active ready running
  |- 1:0:15:20 sdag 66:0   active ready running
  |- 1:0:2:20  sdj  8:144  active ready running
  |- 1:0:3:20  sdm  8:192  active ready running
  |- 1:0:4:20  sdp  8:240  active ready running
  |- 1:0:5:20  sds  65:32  active ready running
  `- 1:0:6:20  sdv  65:80  active ready running
Aug 14 09:33:02 | sdc: alua not supported
Aug 14 09:33:02 | sdf: alua not supported
Aug 14 09:33:02 | sdaf: alua not supported
Aug 14 09:33:02 | sdi: alua not supported
Aug 14 09:33:02 | sdl: alua not supported
Aug 14 09:33:02 | sdo: alua not supported
Aug 14 09:33:02 | sdr: alua not supported
Aug 14 09:33:02 | sdu: alua not supported
2221f000155c0792e dm-11 Promise,VTrak E830f
size=20T features='3 queue_if_no_path queue_mode mq' hwhandler='0' wp=rw
`-+- policy='service-time 0' prio=-1 status=active
  |- 1:0:0:5   sdc  8:32   active ready running
  |- 1:0:1:5   sdf  8:80   active ready running
  |- 1:0:15:5  sdaf 65:240 active ready running
  |- 1:0:2:5   sdi  8:128  active ready running
  |- 1:0:3:5   sdl  8:176  active ready running
  |- 1:0:4:5   sdo  8:224  active ready running
  |- 1:0:5:5   sdr  65:16  active ready running
  `- 1:0:6:5   sdu  65:64  active ready running

However I find that I can do this:

# multipath -v 3 -a 2228a0001558b1855
Aug 14 09:35:56 | set open fds limit to 1048576/1048576
Aug 14 09:35:56 | loading //lib/multipath/libchecktur.so checker
Aug 14 09:35:56 | checker tur: message table size = 3
Aug 14 09:35:56 | loading //lib/multipath/libprioconst.so prioritizer
Aug 14 09:35:56 | foreign library "nvme" loaded successfully
Aug 14 09:35:56 | libdevmapper version 1.02.155 (2018-12-18)
Aug 14 09:35:56 | DM multipath kernel driver v1.13.0
Aug 14 09:35:56 | No matching alias [2228a0001558b1855] in bindings file.
Aug 14 09:35:56 | wrote wwid 2228a0001558b1855 to wwids file
wwid '2228a0001558b1855' added
Aug 14 09:35:56 | unloading const prioritizer
Aug 14 09:35:56 | unloading tur checker

# multipath -v3 -r
Aug 14 09:36:24 | set open fds limit to 1048576/1048576
Aug 14 09:36:24 | loading //lib/multipath/libchecktur.so checker
Aug 14 09:36:24 | checker tur: message table size = 3
Aug 14 09:36:24 | loading //lib/multipath/libprioconst.so prioritizer
Aug 14 09:36:24 | foreign library "nvme" loaded successfully
Aug 14 09:36:24 | delegating command to multipathd

and now the multipath device for the new LUN appears.

# multipath -ll
3600a098000b173f60000079e5da82d73 dm-12 DELL,MD38xxf
size=40T features='5 queue_if_no_path pg_init_retries 50 queue_mode mq' hwhandler='1 rdac' wp=rw
|-+- policy='service-time 0' prio=14 status=active
| |- 1:0:10:0  sdaa 65:160 active ready running
| |- 1:0:12:0  sdac 65:192 active ready running
| |- 1:0:14:0  sdae 65:224 active ready running
| `- 1:0:8:0   sdy  65:128 active ready running
`-+- policy='service-time 0' prio=9 status=enabled
  |- 1:0:11:0  sdab 65:176 active ready running
  |- 1:0:13:0  sdad 65:208 active ready running
  |- 1:0:7:0   sdx  65:112 active ready running
  `- 1:0:9:0   sdz  65:144 active ready running
Aug 14 09:36:35 | sdd: alua not supported
Aug 14 09:36:35 | sdg: alua not supported
Aug 14 09:36:35 | sdag: alua not supported
Aug 14 09:36:35 | sdj: alua not supported
Aug 14 09:36:35 | sdm: alua not supported
Aug 14 09:36:35 | sdp: alua not supported
Aug 14 09:36:35 | sds: alua not supported
Aug 14 09:36:35 | sdv: alua not supported
222e300015555469c dm-10 Promise,VTrak E830f
size=20T features='3 queue_if_no_path queue_mode mq' hwhandler='0' wp=rw
`-+- policy='service-time 0' prio=-1 status=active
  |- 1:0:0:20  sdd  8:48   active ready running
  |- 1:0:1:20  sdg  8:96   active ready running
  |- 1:0:15:20 sdag 66:0   active ready running
  |- 1:0:2:20  sdj  8:144  active ready running
  |- 1:0:3:20  sdm  8:192  active ready running
  |- 1:0:4:20  sdp  8:240  active ready running
  |- 1:0:5:20  sds  65:32  active ready running
  `- 1:0:6:20  sdv  65:80  active ready running
Aug 14 09:36:35 | sde: alua not supported
Aug 14 09:36:35 | sdh: alua not supported
Aug 14 09:36:35 | sdah: alua not supported
Aug 14 09:36:35 | sdk: alua not supported
Aug 14 09:36:35 | sdn: alua not supported
Aug 14 09:36:35 | sdq: alua not supported
Aug 14 09:36:35 | sdt: alua not supported
Aug 14 09:36:35 | sdw: alua not supported
2228a0001558b1855 dm-14 Promise,VTrak E830f
size=20T features='3 queue_if_no_path queue_mode mq' hwhandler='0' wp=rw
`-+- policy='service-time 0' prio=-1 status=active
  |- 1:0:0:21  sde  8:64   active ready running
  |- 1:0:1:21  sdh  8:112  active ready running
  |- 1:0:15:21 sdah 66:16  active ready running
  |- 1:0:2:21  sdk  8:160  active ready running
  |- 1:0:3:21  sdn  8:208  active ready running
  |- 1:0:4:21  sdq  65:0   active ready running
  |- 1:0:5:21  sdt  65:48  active ready running
  `- 1:0:6:21  sdw  65:96  active ready running
Aug 14 09:36:35 | sdc: alua not supported
Aug 14 09:36:35 | sdf: alua not supported
Aug 14 09:36:35 | sdaf: alua not supported
Aug 14 09:36:35 | sdi: alua not supported
Aug 14 09:36:35 | sdl: alua not supported
Aug 14 09:36:35 | sdo: alua not supported
Aug 14 09:36:35 | sdr: alua not supported
Aug 14 09:36:35 | sdu: alua not supported
2221f000155c0792e dm-11 Promise,VTrak E830f
size=20T features='3 queue_if_no_path queue_mode mq' hwhandler='0' wp=rw
`-+- policy='service-time 0' prio=-1 status=active
  |- 1:0:0:5   sdc  8:32   active ready running
  |- 1:0:1:5   sdf  8:80   active ready running
  |- 1:0:15:5  sdaf 65:240 active ready running
  |- 1:0:2:5   sdi  8:128  active ready running
  |- 1:0:3:5   sdl  8:176  active ready running
  |- 1:0:4:5   sdo  8:224  active ready running
  |- 1:0:5:5   sdr  65:16  active ready running
  `- 1:0:6:5   sdu  65:64  active ready running

So it seems that multipath can be made to work, but perhaps
the manual page could be enhanced a little to cover this case.

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 05a5e8ff..718dd16a 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -1516,6 +1516,9 @@ handler to known devices (which includes all devices supporting SCSI-3 ALUA)
 and disallow changing the handler
 afterwards. Setting \fBhardware_handler\fR for such devices on these kernels
 has no effect.
+.PP
+If your device has been configured to disable ALUA support,
+\fBhardware_handler\fR will be set to \fI0\fR.
 .RE
 .
 .

Kind regards
Vince
