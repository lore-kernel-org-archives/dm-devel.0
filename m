From: Mikhail Shevyakov <Shevyakov.M@avroraid.com>
Subject: Wrong behaviour of multipathing on Active/Passive
	storage array
Date: Mon, 11 Jul 2011 19:34:46 +0400
Message-ID: <1310398486.6249.209.camel@mi>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6137548818621578172=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

--===============6137548818621578172==
Content-Type: multipart/alternative; boundary="=-aFLt3tJlmutzrRFWLFJd"

--=-aFLt3tJlmutzrRFWLFJd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hello!
I try to configure multipathing for Active/Passive storage and I have a
problem with this:
when paths are switched (Active->Passive, Passive->Active) all
read/write operations
are suspended. When paths switches back read/write resumes. 
Following is the configuration:

# less /etc/multipath.conf

defaults {
user_friendly_names yes
prio alua
path_checker tur
no_path_retry 10
fast_io_fail_tmo 5
polling_interval        10
selector                "round-robin 0"
path_grouping_policy    multibus
rr_min_io               100
failback                immediate
}



# multipath -ll
mpathb (0AvroRAIDDVAS            000000000000000097f62ae1) dm-0 AvroRAID,DVAS
size=683G features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=5 status=active
  |- 7:0:0:0 sdc 8:32 active ghost  running
  `- 9:0:0:0 sdd 8:48 active ready  running

This is output of st_turs:

# sg_turs -v /dev/sdd
    test unit ready cdb: 00 00 00 00 00 00 
# sg_turs -v /dev/sdc
    test unit ready cdb: 00 00 00 00 00 00 
test unit ready:  Fixed format, current;  Sense key: Not Ready
 Additional sense: Logical unit not accessible, target port in standby state
  Info fld=0x0 [0] 
device not ready

And REPORT TARGET PORT GROUPS output:

#sg_rtpg /dev/sdd 
Report target port groups:
  target port group id : 0x1 , Pref=1
    target port group asymmetric access state : 0x00
    T_SUP : 0, O_SUP : 0, U_SUP : 1, S_SUP : 1, AN_SUP : 0, AO_SUP : 1
    status code : 0x02
    vendor unique status : 0x00
    target port count : 02
    Relative target port ids:
      0x01
      0x02
#sg_rtpg /dev/sdc
Report target port groups:
  target port group id : 0x2 , Pref=0
    target port group asymmetric access state : 0x02
    T_SUP : 0, O_SUP : 0, U_SUP : 1, S_SUP : 1, AN_SUP : 0, AO_SUP : 1
    status code : 0x02
    vendor unique status : 0x00
    target port count : 04
    Relative target port ids:
      0x01
      0x02
      0x03
      0x04

I used dd to write on the dm device:

#dd if=/dev/zero of=/dev/dm-0 oflag=direct bs=1M

Everything works fine untill paths are switched. dd stops, turs output:

# sg_turs -v /dev/sdd
    test unit ready cdb: 00 00 00 00 00 00 
# sg_turs -v /dev/sdc
    test unit ready cdb: 00 00 00 00 00 00 
test unit ready:  Fixed format, current;  Sense key: Not Ready
 Additional sense: Logical unit not accessible, target port in standby state
  Info fld=0x0 [0] 
device not ready
 
REPORT TARGET PORT GROUPS output:

# sg_rtpg /dev/sdd 
Report target port groups:
  target port group id : 0x1 , Pref=0
    target port group asymmetric access state : 0x02
    T_SUP : 0, O_SUP : 0, U_SUP : 1, S_SUP : 1, AN_SUP : 0, AO_SUP : 1
    status code : 0x02
    vendor unique status : 0x00
    target port count : 02
    Relative target port ids:
      0x01
      0x02
# sg_rtpg /dev/sdc
Report target port groups:
  target port group id : 0x2 , Pref=1
    target port group asymmetric access state : 0x00
    T_SUP : 0, O_SUP : 0, U_SUP : 1, S_SUP : 1, AN_SUP : 0, AO_SUP : 1
    status code : 0x02
    vendor unique status : 0x00
    target port count : 04
    Relative target port ids:
      0x01                                                                                                                                                                                                                                   
      0x02                                                                                                                                                                                                                                   
      0x03                                                                                                                                                                                                                                   
      0x04

As you can see paths' states are switched.Output of multipath:

# multipath -ll
mpathb (0AvroRAIDDVAS            000000000000000097f62ae1) dm-0 AvroRAID,DVAS
size=683G features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=5 status=enabled
  |- 7:0:0:0 sdc 8:32 failed ready  running
  `- 9:0:0:0 sdd 8:48 failed ghost  running


So states of the paths are changed but multipath for some reason fails both paths.
Is something wrong with my config or is it a bug in multipath?
Could you help me with this problem?

Regards
Mikhail Shevyakov


--=-aFLt3tJlmutzrRFWLFJd
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 TRANSITIONAL//EN">
<HTML>
<HEAD>
  <META HTTP-EQUIV="Content-Type" CONTENT="text/html; CHARSET=UTF-8">
  <META NAME="GENERATOR" CONTENT="GtkHTML/3.30.1">
</HEAD>
<BODY>
Hello!<BR>
I try to configure multipathing for Active/Passive storage and I have a problem with this:<BR>
when paths are switched (Active-&gt;Passive, Passive-&gt;Active) all read/write operations<BR>
are suspended. When paths switches back read/write resumes. <BR>
Following is the configuration:<BR>
<BR>
# less /etc/multipath.conf
<PRE>
defaults {
user_friendly_names yes
prio alua
path_checker tur
no_path_retry 10
fast_io_fail_tmo 5
polling_interval        10
selector                &quot;round-robin 0&quot;
path_grouping_policy    multibus
rr_min_io               100
failback                immediate
}
</PRE>
<BR>
<PRE>
# multipath -ll
mpathb (0AvroRAIDDVAS            000000000000000097f62ae1) dm-0 AvroRAID,DVAS
size=683G features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=5 status=active
  |- 7:0:0:0 sdc 8:32 active ghost  running
&nbsp; `- 9:0:0:0 sdd 8:48 active ready&nbsp; running

This is output of st_turs:

# sg_turs -v /dev/sdd
    test unit ready cdb: 00 00 00 00 00 00 
# sg_turs -v /dev/sdc
    test unit ready cdb: 00 00 00 00 00 00 
test unit ready:  Fixed format, current;  Sense key: Not Ready
 Additional sense: Logical unit not accessible, target port in standby state
  Info fld=0x0 [0] 
device not ready

And REPORT TARGET PORT GROUPS output:

#sg_rtpg /dev/sdd 
Report target port groups:
  target port group id : 0x1 , Pref=1
    target port group asymmetric access state : 0x00
    T_SUP : 0, O_SUP : 0, U_SUP : 1, S_SUP : 1, AN_SUP : 0, AO_SUP : 1
    status code : 0x02
    vendor unique status : 0x00
    target port count : 02
    Relative target port ids:
      0x01
      0x02
#sg_rtpg /dev/sdc
Report target port groups:
  target port group id : 0x2 , Pref=0
    target port group asymmetric access state : 0x02
    T_SUP : 0, O_SUP : 0, U_SUP : 1, S_SUP : 1, AN_SUP : 0, AO_SUP : 1
    status code : 0x02
    vendor unique status : 0x00
    target port count : 04
    Relative target port ids:
      0x01
      0x02
      0x03
      0x04

I used dd to write on the dm device:

#dd if=/dev/zero of=/dev/dm-0 oflag=direct bs=1M

Everything works fine untill paths are switched. dd stops, turs output:

# sg_turs -v /dev/sdd
    test unit ready cdb: 00 00 00 00 00 00 
# sg_turs -v /dev/sdc
    test unit ready cdb: 00 00 00 00 00 00 
test unit ready:  Fixed format, current;  Sense key: Not Ready
 Additional sense: Logical unit not accessible, target port in standby state
  Info fld=0x0 [0] 
device not ready
 
REPORT TARGET PORT GROUPS output:

# sg_rtpg /dev/sdd 
Report target port groups:
  target port group id : 0x1 , Pref=0
    target port group asymmetric access state : 0x02
    T_SUP : 0, O_SUP : 0, U_SUP : 1, S_SUP : 1, AN_SUP : 0, AO_SUP : 1
    status code : 0x02
    vendor unique status : 0x00
    target port count : 02
    Relative target port ids:
      0x01
      0x02
# sg_rtpg /dev/sdc
Report target port groups:
  target port group id : 0x2 , Pref=1
    target port group asymmetric access state : 0x00
    T_SUP : 0, O_SUP : 0, U_SUP : 1, S_SUP : 1, AN_SUP : 0, AO_SUP : 1
    status code : 0x02
    vendor unique status : 0x00
    target port count : 04
    Relative target port ids:
      0x01                                                                                                                                                                                                                                   
      0x02                                                                                                                                                                                                                                   
      0x03                                                                                                                                                                                                                                   
      0x04

As you can see paths' states are switched.Output of multipath:

# multipath -ll
mpathb (0AvroRAIDDVAS            000000000000000097f62ae1) dm-0 AvroRAID,DVAS
size=683G features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=5 status=enabled
  |- 7:0:0:0 sdc 8:32 failed ready  running
&nbsp; `- 9:0:0:0 sdd 8:48 failed ghost&nbsp; running


So states of the paths are changed but multipath for some reason fails both paths.
Is something wrong with my config or is it a bug in multipath?
Could you help me with this problem?

Regards
Mikhail Shevyakov

</PRE>
</BODY>
</HTML>

--=-aFLt3tJlmutzrRFWLFJd--


--===============6137548818621578172==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6137548818621578172==--
