From: Alireza Nematollahi <alirezan@sfu.ca>
Subject: Stopped disk causes LVM to go crazy
Date: Tue, 10 Feb 2009 15:31:01 -0800 (PST)
Message-ID: <638406528.2295221234308660984.JavaMail.root@jaguar7.sfu.ca>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0295430900=="
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

--===============0295430900==
Content-Type: multipart/alternative;
	boundary="----=_Part_82353_1989593995.1234308660983"

------=_Part_82353_1989593995.1234308660983
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

hi guys, 

I have a system with two SATA disks and I have LVM on the disks. 
I use sdparm (sdparm -C stop /dev/sdb) to spin-down one of them. It works fine and I can hear the disk spinning down and all...But when I run any LVM command, say lvscan or whatever, I get lots of error messages: 


	> lvscan 
end_request: I/O error, dev sdb, sector 20971839 
end_request: I/O error, dev sdb, sector 447 
/dev/dm-0: read failed after 0 of 4096 at 10737352704: Input/outend_request: I/O error, dev sdb, sector 21176639 
put error 
/dev/dm-0: read failed after 0 of 4096 at 0: Input/end_request: I/O error, dev sdb, sector 20971967 
output error 
/dev/dm-1: read failed after 0 of 4096 at 104792end_request: I/O error, dev sdb, sector 42148159 
064: Input/output error 
/dev/dm-1: read failed after 0 of 409end_request: I/O error, dev sdb, sector 21176767 
6 at 0: Input/output error 
/dev/dm-2: read failed after 0 of end_request: I/O error, dev sdb, sector 42352959 
4096 at 10737352704: Input/output error 
/dev/dm-2: read faileend_request: I/O error, dev sdb, sector 42148287 
d after 0 of 4096 at 0: Input/output error 
/dev/dm-3: read faend_request: I/O error, dev sdb, sector 63324479 
iled after 0 of 4096 at 104792064: Input/output error 
/dev/dmend_request: I/O error, dev sdb, sector 42353087 
-3: read failed after 0 of 4096 at 0: Input/output error 
/devend_request: I/O error, dev sdb, sector 63529279 
/dm-4: read failed after 0 of 4096 at 10737352704: Input/output end_request: I/O error, dev sdb, sector 63324607 
error 
/dev/dm-4: read failed after 0 of 4096 at 0: Input/outpend_request: I/O error, dev sdb, sector 287274137 
ut error 
/dev/dm-5: read failed after 0 of 4096 at 104792064:end_request: I/O error, dev sdb, sector 287258265 
Input/output error 
/dev/dm-5: read failed after 0 of 4096 atend_request: I/O error, dev sdb, sector 287258029 
0: Input/output error 
/dev/sdb1: read failed after 0 of 512 end_request: I/O error, dev sdb, sector 281410605 
at 8126464: Input/output error 
/dev/sdb1: read failed after 0end_request: I/O error, dev sdb, sector 281410367 
of 2048 at 0: Input/output error 
/dev/sdb2: read failed afteend_request: I/O error, dev sdb, sector 63 
r 0 of 4096 at 2993881088: Input/output error 
/dev/sdb2: read failed after 0 of 4096 at 0: Input/output error 
/dev/sdb4: read failed after 0 of 1024 at 144082075648: Input/output error 
/dev/sdb4: read failed after 0 of 2048 at 0: Input/output error 
ACTIVE '/dev/blahblah/blah' [10.00 GB] inherit 
ACTIVE '/dev/blahblah/blah' [100.00 MB] inherit 
ACTIVE '/dev/blahblah/blah' [10.00 GB] inherit 
ACTIVE '/dev/blahblah/blah' [100.00 MB] inherit 
ACTIVE '/dev/blahblah/blah' [10.00 GB] inherit 
ACTIVE '/dev/blahblah/blah' [100.00 MB] inherit 
File descriptor 3 left open 
end_request: I/O error, dev sdb, sector 20971839 
end_request: I/O error, dev sdb, sector 447 
/dev/dm-0: read failed after 0 of 4096 at 10737352704: Input/outend_request: I/O error, dev sdb, sector 21176639 
put error 
/dev/dm-0: read failed after 0 of 4096 at 0: Input/end_request: I/O error, dev sdb, sector 20971967 
output error 
/dev/dm-1: read failed after 0 of 4096 at 104792end_request: I/O error, dev sdb, sector 42148159 
064: Input/output error 
/dev/dm-1: read failed after 0 of 409end_request: I/O error, dev sdb, sector 21176767 
6 at 0: Input/output error 
/dev/dm-2: read failed after 0 of end_request: I/O error, dev sdb, sector 42352959 
4096 at 10737352704: Input/output error 
/dev/dm-2: read faileend_request: I/O error, dev sdb, sector 42148287 
d after 0 of 4096 at 0: Input/output error 
/dev/dm-3: read faend_request: I/O error, dev sdb, sector 63324479 
iled after 0 of 4096 at 104792064: Input/output error 
/dev/dmend_request: I/O error, dev sdb, sector 42353087 
-3: read failed after 0 of 4096 at 0: Input/output error 
/devend_request: I/O error, dev sdb, sector 63529279 
/dm-4: read failed after 0 of 4096 at 10737352704: Input/output end_request: I/O error, dev sdb, sector 63324607 
error 
/dev/dm-4: read failed after 0 of 4096 at 0: Input/outpend_request: I/O error, dev sdb, sector 287274137 
ut error 
/dev/dm-5: read failed after 0 of 4096 at 104792064:end_request: I/O error, dev sdb, sector 287258265 
Input/output error 
/dev/dm-5: read failed after 0 of 4096 atend_request: I/O error, dev sdb, sector 287258029 
0: Input/output error 
/dev/sdb1: read failed after 0 of 512 end_request: I/O error, dev sdb, sector 281410605 
at 8126464: Input/output error 
/dev/sdb1: read failed after 0end_request: I/O error, dev sdb, sector 281410367 
of 2048 at 0: Input/output error 
/dev/sdb2: read failed afteend_request: I/O error, dev sdb, sector 63 
r 0 of 4096 at 2993881088: Input/output error 
/dev/sdb2: read failed after 0 of 4096 at 0: Input/output error 
/dev/sdb4: read failed after 0 of 1024 at 144082075648: Input/output error 
/dev/sdb4: read failed after 0 of 2048 at 0: Input/output erroend_request: I/O error, dev sdb, sector 20971839 
r 
end_request: I/O error, dev sdb, sector 4474zwPa" now active 

/dev/dm-0: read failed after 0 of 4096 at 10737352704: Input/end_request: I/O error, dev sdb, sector 21176639 
output error 
/dev/dm-0: read failed after 0 of 4096 at 0: Inpend_request: I/O error, dev sdb, sector 20971967 
ut/output error 
/dev/dm-1: read failed after 0 of 4096 at 104end_request: I/O error, dev sdb, sector 42148159 
792064: Input/output error 
/dev/dm-1: read failed after 0 of end_request: I/O error, dev sdb, sector 21176767 
4096 at 0: Input/output error 
/dev/dm-2: read failed after 0 end_request: I/O error, dev sdb, sector 42352959 
of 4096 at 10737352704: Input/output error 
/dev/dm-2: read faend_request: I/O error, dev sdb, sector 42148287 
iled after 0 of 4096 at 0: Input/output error 
/dev/dm-3: readend_request: I/O error, dev sdb, sector 63324479 
failed after 0 of 4096 at 104792064: Input/output error 
/devend_request: I/O error, dev sdb, sector 42353087 
/dm-3: read failed after 0 of 4096 at 0: Input/output error 
/end_request: I/O error, dev sdb, sector 63529279 
dev/dm-4: read failed after 0 of 4096 at 10737352704: Input/outpend_request: I/O error, dev sdb, sector 63324607 
ut error 
/dev/dm-4: read failed after 0 of 4096 at 0: Input/oend_request: I/O error, dev sdb, sector 287274137 
utput error 
/dev/dm-5: read failed after 0 of 4096 at 1047920end_request: I/O error, dev sdb, sector 287258265 
64: Input/output error 
/dev/dm-5: read failed after 0 of 4096end_request: I/O error, dev sdb, sector 287258029 
at 0: Input/output error 
/dev/sdb1: read failed after 0 of 5end_request: I/O error, dev sdb, sector 281410605 
12 at 8126464: Input/output error 
/dev/sdb1: read failed afteend_request: I/O error, dev sdb, sector 281410367 
r 0 of 2048 at 0: Input/output error 
/dev/sdb2: read failed aend_request: I/O error, dev sdb, sector 63 
fter 0 of 4096 at 2993881088: Input/output error 
/dev/sdb2: read failed after 0 of 4096 at 0: Input/output error 
/dev/sdb4end_request: I/O error, dev sdb, sector 20971839 
: read failed after 0 of 1024 at 144082075648: Input/output erroend_request: I/O error, dev sdb, sector 447 
r 
/dev/sdb4: read failed after 0 of 2048 at 0: Input/output eend_request: I/O error, dev sdb, sector 21176639 
rror 
/dev/dm-0: read failed after 0 of 4096 at 10737352704: Iend_request: I/O error, dev sdb, sector 20971967 
nput/output error 
/dev/dm-0: read failed after 0 of 4096 at 0end_request: I/O error, dev sdb, sector 42148159 
: Input/output error 
/dev/dm-1: read failed after 0 of 4096 aend_request: I/O error, dev sdb, sector 21176767 
t 104792064: Input/output error 
/dev/dm-1: read failed after end_request: I/O error, dev sdb, sector 42352959 
0 of 4096 at 0: Input/output error 
/dev/dm-2: read failed aftend_request: I/O error, dev sdb, sector 42148287 
er 0 of 4096 at 10737352704: Input/output error 
/dev/dm-2: reend_request: I/O error, dev sdb, sector 63324479 
ad failed after 0 of 4096 at 0: Input/output error 
/dev/dm-3:end_request: I/O error, dev sdb, sector 42353087 
read failed after 0 of 4096 at 104792064: Input/output error 
end_request: I/O error, dev sdb, sector 63529279 
/dev/dm-3: read failed after 0 of 4096 at 0: Input/output errorend_request: I/O error, dev sdb, sector 63324607 

/dev/dm-4: read failed after 0 of 4096 at 10737352704: Inputend_request: I/O error, dev sdb, sector 287274137 
/output error 
/dev/dm-4: read failed after 0 of 4096 at 0: Inend_request: I/O error, dev sdb, sector 287258265 
put/output error 
/dev/dm-5: read failed after 0 of 4096 at 10end_request: I/O error, dev sdb, sector 287258029 
4792064: Input/output error 
/dev/dm-5: read failed after 0 ofend_request: I/O error, dev sdb, sector 281410605 
4096 at 0: Input/output error 
/dev/sdb1: read failed after 0end_request: I/O error, dev sdb, sector 281410367 
of 512 at 8126464: Input/output error 
/dev/sdb1: read failedend_request: I/O error, dev sdb, sector 63 
after 0 of 2048 at 0: Input/output error 
/dev/sdb2: read failed after 0 of 4096 at 2993881088: Input/output error 
/dev/sdb2: read failed after 0 of 4096 at 0: Input/output error 
/dev/sdb4: read failed after 0 of 1024 at 144082075648: Input/output error 
/dev/sdb4: read failed after 0 of 2048 at 0: Input/output error Even when I physically remove the disk it still happens. Is there any way I can stop LVM from querying both disks or at least to stop displaying the error messages? 

Thanks 
------=_Part_82353_1989593995.1234308660983
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: 7bit

<html><head><style type='text/css'>p { margin: 0; }</style></head><body><div style='font-family: Times New Roman; font-size: 12pt; color: #000000'>hi guys,<br>
<br>
I have a system with two SATA disks and I have LVM on the disks.<br>
I use sdparm (sdparm -C stop /dev/sdb) to spin-down one of them. It
works fine and I can hear the disk spinning down and all...But when I
run any LVM command, say lvscan or whatever, I get lots of error
messages:<br>
<br>
<div style="margin: 5px 20px 20px;">
	
	<table width="100%" border="0" cellpadding="3" cellspacing="0">
	<tbody><tr>
		<td class="bbcodeblock" style="border: 1px inset ;">
			
				&gt; lvscan<br>
end_request: I/O error, dev sdb, sector 20971839<br>
  end_request: I/O error, dev sdb, sector 447<br>
/dev/dm-0: read failed after 0 of 4096 at 10737352704: Input/outend_request: I/O error, dev sdb, sector 21176639<br>
put error<br>
  /dev/dm-0: read failed after 0 of 4096 at 0: Input/end_request: I/O error, dev sdb, sector 20971967<br>
output error<br>
  /dev/dm-1: read failed after 0 of 4096 at 104792end_request: I/O error, dev sdb, sector 42148159<br>
064: Input/output error<br>
  /dev/dm-1: read failed after 0 of 409end_request: I/O error, dev sdb, sector 21176767<br>
6 at 0: Input/output error<br>
  /dev/dm-2: read failed after 0 of end_request: I/O error, dev sdb, sector 42352959<br>
4096 at 10737352704: Input/output error<br>
  /dev/dm-2: read faileend_request: I/O error, dev sdb, sector 42148287<br>
d after 0 of 4096 at 0: Input/output error<br>
  /dev/dm-3: read faend_request: I/O error, dev sdb, sector 63324479<br>
iled after 0 of 4096 at 104792064: Input/output error<br>
  /dev/dmend_request: I/O error, dev sdb, sector 42353087<br>
-3: read failed after 0 of 4096 at 0: Input/output error<br>
  /devend_request: I/O error, dev sdb, sector 63529279<br>
/dm-4: read failed after 0 of 4096 at 10737352704: Input/output end_request: I/O error, dev sdb, sector 63324607<br>
error<br>
  /dev/dm-4: read failed after 0 of 4096 at 0: Input/outpend_request: I/O error, dev sdb, sector 287274137<br>
ut error<br>
  /dev/dm-5: read failed after 0 of 4096 at 104792064:end_request: I/O error, dev sdb, sector 287258265<br>
 Input/output error<br>
  /dev/dm-5: read failed after 0 of 4096 atend_request: I/O error, dev sdb, sector 287258029<br>
 0: Input/output error<br>
  /dev/sdb1: read failed after 0 of 512 end_request: I/O error, dev sdb, sector 281410605<br>
at 8126464: Input/output error<br>
  /dev/sdb1: read failed after 0end_request: I/O error, dev sdb, sector 281410367<br>
 of 2048 at 0: Input/output error<br>
  /dev/sdb2: read failed afteend_request: I/O error, dev sdb, sector 63<br>
r 0 of 4096 at 2993881088: Input/output error<br>
  /dev/sdb2: read failed after 0 of 4096 at 0: Input/output error<br>
  /dev/sdb4: read failed after 0 of 1024 at 144082075648: Input/output error<br>
  /dev/sdb4: read failed after 0 of 2048 at 0: Input/output error<br>
  ACTIVE            '/dev/blahblah/blah' [10.00 GB] inherit<br>
  ACTIVE            '/dev/blahblah/blah' [100.00 MB] inherit<br>
  ACTIVE            '/dev/blahblah/blah' [10.00 GB] inherit<br>
  ACTIVE            '/dev/blahblah/blah' [100.00 MB] inherit<br>
  ACTIVE            '/dev/blahblah/blah' [10.00 GB] inherit<br>
  ACTIVE            '/dev/blahblah/blah' [100.00 MB] inherit<br>
File descriptor 3 left open<br>
end_request: I/O error, dev sdb, sector 20971839<br>
  end_request: I/O error, dev sdb, sector 447<br>
/dev/dm-0: read failed after 0 of 4096 at 10737352704: Input/outend_request: I/O error, dev sdb, sector 21176639<br>
put error<br>
  /dev/dm-0: read failed after 0 of 4096 at 0: Input/end_request: I/O error, dev sdb, sector 20971967<br>
output error<br>
  /dev/dm-1: read failed after 0 of 4096 at 104792end_request: I/O error, dev sdb, sector 42148159<br>
064: Input/output error<br>
  /dev/dm-1: read failed after 0 of 409end_request: I/O error, dev sdb, sector 21176767<br>
6 at 0: Input/output error<br>
  /dev/dm-2: read failed after 0 of end_request: I/O error, dev sdb, sector 42352959<br>
4096 at 10737352704: Input/output error<br>
  /dev/dm-2: read faileend_request: I/O error, dev sdb, sector 42148287<br>
d after 0 of 4096 at 0: Input/output error<br>
  /dev/dm-3: read faend_request: I/O error, dev sdb, sector 63324479<br>
iled after 0 of 4096 at 104792064: Input/output error<br>
  /dev/dmend_request: I/O error, dev sdb, sector 42353087<br>
-3: read failed after 0 of 4096 at 0: Input/output error<br>
  /devend_request: I/O error, dev sdb, sector 63529279<br>
/dm-4: read failed after 0 of 4096 at 10737352704: Input/output end_request: I/O error, dev sdb, sector 63324607<br>
error<br>
  /dev/dm-4: read failed after 0 of 4096 at 0: Input/outpend_request: I/O error, dev sdb, sector 287274137<br>
ut error<br>
  /dev/dm-5: read failed after 0 of 4096 at 104792064:end_request: I/O error, dev sdb, sector 287258265<br>
 Input/output error<br>
  /dev/dm-5: read failed after 0 of 4096 atend_request: I/O error, dev sdb, sector 287258029<br>
 0: Input/output error<br>
  /dev/sdb1: read failed after 0 of 512 end_request: I/O error, dev sdb, sector 281410605<br>
at 8126464: Input/output error<br>
  /dev/sdb1: read failed after 0end_request: I/O error, dev sdb, sector 281410367<br>
 of 2048 at 0: Input/output error<br>
  /dev/sdb2: read failed afteend_request: I/O error, dev sdb, sector 63<br>
r 0 of 4096 at 2993881088: Input/output error<br>
  /dev/sdb2: read failed after 0 of 4096 at 0: Input/output error<br>
  /dev/sdb4: read failed after 0 of 1024 at 144082075648: Input/output error<br>
  /dev/sdb4: read failed after 0 of 2048 at 0: Input/output erroend_request: I/O error, dev sdb, sector 20971839<br>
r<br>
end_request: I/O error, dev sdb, sector 4474zwPa" now active<br>
<br>
  /dev/dm-0: read failed after 0 of 4096 at 10737352704: Input/end_request: I/O error, dev sdb, sector 21176639<br>
output error<br>
  /dev/dm-0: read failed after 0 of 4096 at 0: Inpend_request: I/O error, dev sdb, sector 20971967<br>
ut/output error<br>
  /dev/dm-1: read failed after 0 of 4096 at 104end_request: I/O error, dev sdb, sector 42148159<br>
792064: Input/output error<br>
  /dev/dm-1: read failed after 0 of end_request: I/O error, dev sdb, sector 21176767<br>
4096 at 0: Input/output error<br>
  /dev/dm-2: read failed after 0 end_request: I/O error, dev sdb, sector 42352959<br>
of 4096 at 10737352704: Input/output error<br>
  /dev/dm-2: read faend_request: I/O error, dev sdb, sector 42148287<br>
iled after 0 of 4096 at 0: Input/output error<br>
  /dev/dm-3: readend_request: I/O error, dev sdb, sector 63324479<br>
 failed after 0 of 4096 at 104792064: Input/output error<br>
  /devend_request: I/O error, dev sdb, sector 42353087<br>
/dm-3: read failed after 0 of 4096 at 0: Input/output error<br>
  /end_request: I/O error, dev sdb, sector 63529279<br>
dev/dm-4: read failed after 0 of 4096 at 10737352704: Input/outpend_request: I/O error, dev sdb, sector 63324607<br>
ut error<br>
  /dev/dm-4: read failed after 0 of 4096 at 0: Input/oend_request: I/O error, dev sdb, sector 287274137<br>
utput error<br>
  /dev/dm-5: read failed after 0 of 4096 at 1047920end_request: I/O error, dev sdb, sector 287258265<br>
64: Input/output error<br>
  /dev/dm-5: read failed after 0 of 4096end_request: I/O error, dev sdb, sector 287258029<br>
 at 0: Input/output error<br>
  /dev/sdb1: read failed after 0 of 5end_request: I/O error, dev sdb, sector 281410605<br>
12 at 8126464: Input/output error<br>
  /dev/sdb1: read failed afteend_request: I/O error, dev sdb, sector 281410367<br>
r 0 of 2048 at 0: Input/output error<br>
  /dev/sdb2: read failed aend_request: I/O error, dev sdb, sector 63<br>
fter 0 of 4096 at 2993881088: Input/output error<br>
  /dev/sdb2: read failed after 0 of 4096 at 0: Input/output error<br>
  /dev/sdb4end_request: I/O error, dev sdb, sector 20971839<br>
: read failed after 0 of 1024 at 144082075648: Input/output erroend_request: I/O error, dev sdb, sector 447<br>
r<br>
  /dev/sdb4: read failed after 0 of 2048 at 0: Input/output eend_request: I/O error, dev sdb, sector 21176639<br>
rror<br>
  /dev/dm-0: read failed after 0 of 4096 at 10737352704: Iend_request: I/O error, dev sdb, sector 20971967<br>
nput/output error<br>
  /dev/dm-0: read failed after 0 of 4096 at 0end_request: I/O error, dev sdb, sector 42148159<br>
: Input/output error<br>
  /dev/dm-1: read failed after 0 of 4096 aend_request: I/O error, dev sdb, sector 21176767<br>
t 104792064: Input/output error<br>
  /dev/dm-1: read failed after end_request: I/O error, dev sdb, sector 42352959<br>
0 of 4096 at 0: Input/output error<br>
  /dev/dm-2: read failed aftend_request: I/O error, dev sdb, sector 42148287<br>
er 0 of 4096 at 10737352704: Input/output error<br>
  /dev/dm-2: reend_request: I/O error, dev sdb, sector 63324479<br>
ad failed after 0 of 4096 at 0: Input/output error<br>
  /dev/dm-3:end_request: I/O error, dev sdb, sector 42353087<br>
 read failed after 0 of 4096 at 104792064: Input/output error<br>
 end_request: I/O error, dev sdb, sector 63529279<br>
 /dev/dm-3: read failed after 0 of 4096 at 0: Input/output errorend_request: I/O error, dev sdb, sector 63324607<br>
<br>
  /dev/dm-4: read failed after 0 of 4096 at 10737352704: Inputend_request: I/O error, dev sdb, sector 287274137<br>
/output error<br>
  /dev/dm-4: read failed after 0 of 4096 at 0: Inend_request: I/O error, dev sdb, sector 287258265<br>
put/output error<br>
  /dev/dm-5: read failed after 0 of 4096 at 10end_request: I/O error, dev sdb, sector 287258029<br>
4792064: Input/output error<br>
  /dev/dm-5: read failed after 0 ofend_request: I/O error, dev sdb, sector 281410605<br>
 4096 at 0: Input/output error<br>
  /dev/sdb1: read failed after 0end_request: I/O error, dev sdb, sector 281410367<br>
 of 512 at 8126464: Input/output error<br>
  /dev/sdb1: read failedend_request: I/O error, dev sdb, sector 63<br>
 after 0 of 2048 at 0: Input/output error<br>
  /dev/sdb2: read failed after 0 of 4096 at 2993881088: Input/output error<br>
  /dev/sdb2: read failed after 0 of 4096 at 0: Input/output error<br>
  /dev/sdb4: read failed after 0 of 1024 at 144082075648: Input/output error<br>
  /dev/sdb4: read failed after 0 of 2048 at 0: Input/output error
			
		</td>
	</tr>
	</tbody></table>
</div>Even when I physically remove the disk it still happens. Is there
any way I can stop LVM from querying both disks or at least to stop
displaying the error messages?<br>
<br>
Thanks</div></body></html>
------=_Part_82353_1989593995.1234308660983--


--===============0295430900==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0295430900==--
