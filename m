From: "Kevin Foote" <kevin.foote@gmail.com>
Subject: multipath timing help sought
Date: Thu, 27 Sep 2007 11:10:11 -0400
Message-ID: <5fb0f77b0709270810o71d74994v4368c43766352e7f@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0874124744=="
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

--===============0874124744==
Content-Type: multipart/alternative;
	boundary="----=_Part_1767_17279005.1190905812609"

------=_Part_1767_17279005.1190905812609
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Timing help sought.. I think

We have been running on an iscsi mpath setup for about 1.5 years ... (no
real failover other than testing)
Here is the HW we are dealing with:
- Equallogic ps disk array dual controller modules
- qlogic 4052 HBA
- RHEL4.5

During testing phase things worked .. if i pulled power to a switch things
moved over to the other .. but when
other switch came back .. no 'failback' occurred.. I was not too concerned
about this as the initial failure worked and
oracle kept going etc.. (if this happened in real life i figured we would
obviously replace switch and reboot boxes when things
were back) ..

The orig  switch setup did not incorporate a trunk as expected by the
equallogic (as we now know) .. This  was our error and reason for the fail
back
to not happen (im thinking). By now everything is in production and we
discover this on a routine (during scheduled maintenance) fw
update of the switches which requires a reboot.

One week later (during maintenance again) we have the trunk in place between
our iscsi switches and spanning-tree working on the
switches (iscsi san looks like a square with two sets of switches with 1g
fiber connections on one set of parallel lines)

My issue is this .. I am now seeing  many  path 'failures' like below .. but
these are not really failures.. as it comes back
in less than 2 seconds.. It seems no real I/O is affected at all.

Is this due to a setting in my defaults section of multipath.conf? I'm
thinking minimum io or polling interval. Links all show
good on the switches and minimal errors (if any).


====== snip from /var/log/messages ===========
Sep 27 09:25:45 host kernel: SCSI error : <2 0 3 0> return code = 0x20000
Sep 27 09:25:45 host kernel: end_request: I/O error, dev sde, sector
161085656
Sep 27 09:25:45 host kernel: device-mapper: dm-multipath: Failing path 8:64.
Sep 27 09:25:45 host kernel: end_request: I/O error, dev sde, sector
161085664
Sep 27 09:25:45 host kernel: SCSI error : <2 0 3 0> return code = 0x20000
Sep 27 09:25:45 host kernel: end_request: I/O error, dev sde, sector
119577336
Sep 27 09:25:45 host kernel: end_request: I/O error, dev sde, sector
119577344
Sep 27 09:25:45 host kernel: SCSI error : <2 0 3 0> return code = 0x20000
Sep 27 09:25:45 host kernel: end_request: I/O error, dev sde, sector
233247600
Sep 27 09:25:45 host kernel: end_request: I/O error, dev sde, sector
233247608
Sep 27 09:25:45 host multipathd: 8:64: mark as failed
Sep 27 09:25:45 host multipathd: host.datafiles.prod: remaining active
paths: 1
Sep 27 09:25:47 host multipathd: 8:64: readsector0 checker reports path is
up
Sep 27 09:25:47 host multipathd: 8:64: reinstated
Sep 27 09:25:47 host multipathd: host.datafiles.prod: remaining active
paths: 2
Sep 27 09:25:47 host multipathd: host.datafiles.prod: switch to path group
#1
Sep 27 09:25:47 host multipathd: host.datafiles.prod: switch to path group
#1
========= end snip =========================

========= /etc/multipath.conf ================
defaults {
        multipath_tool          "/sbin/multipath -v0"
        udev_dir                /dev
        polling_interval        2
        selector                "round-robin 0"
        path_grouping_policy    failover
        getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
        path_checker            readsector0
        prio_callout            "/bin/true"
        features                "0"
        rr_min_io               2
        rr_weight               priorities
        failback                immediate
        no_path_retry           fail
        user_friendly_name      yes
}
## everything is friendly names and ignore devices below
=========== end ======================


-- 
:wq!
kevin.foote

------=_Part_1767_17279005.1190905812609
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Timing help sought.. I think<br><br>We have been running on an iscsi mpath setup for about 1.5 years ... (no real failover other than testing) <br>Here is the HW we are dealing with:<br>- Equallogic ps disk array dual controller modules
<br>- qlogic 4052 HBA <br>- RHEL4.5<br><br>During testing phase things worked .. if i pulled power to a switch things moved over to the other .. but when <br>other switch came back .. no &#39;failback&#39; occurred.. I was not too concerned about this as the initial failure worked and 
<br>oracle kept going etc.. (if this happened in real life i figured we would obviously replace switch and reboot boxes when things <br>were back) .. <br><br>The orig&nbsp; switch setup did not incorporate a trunk as expected by the equallogic (as we now know) .. This&nbsp; was our error and reason for the fail back 
<br>to not happen (im thinking). By now everything is in production and we discover this on a routine (during scheduled maintenance) fw <br>update of the switches which requires a reboot. <br><br>One week later (during maintenance again) we have the trunk in place between our iscsi switches and spanning-tree working on the 
<br>switches (iscsi san looks like a square with two sets of switches with 1g fiber connections on one set of parallel lines)<br><br>My issue is this .. I am now seeing&nbsp; many&nbsp; path &#39;failures&#39; like below .. but these are not really failures.. as it comes back 
<br>in less than 2 seconds.. It seems no real I/O is affected at all.<br><br>Is this due to a setting in my defaults section of multipath.conf? I&#39;m thinking minimum io or polling interval. Links all show<br>good on the switches and minimal errors (if any). 
<br><br><br>
====== snip from /var/log/messages ===========<br>Sep 27 09:25:45 host kernel: SCSI error : &lt;2 0 3 0&gt; return code = 0x20000<br>Sep 27 09:25:45 host kernel: end_request: I/O error, dev sde, sector 161085656<br>Sep 27 09:25:45 host kernel: device-mapper: dm-multipath: Failing path 8:64.
<br>Sep 27 09:25:45 host kernel: end_request: I/O error, dev sde, sector 161085664<br>Sep 27 09:25:45 host kernel: SCSI error : &lt;2 0 3 0&gt; return code = 0x20000<br>Sep 27 09:25:45 host kernel: end_request: I/O error, dev sde, sector 119577336
<br>Sep 27 09:25:45 host kernel: end_request: I/O error, dev sde, sector 119577344<br>Sep 27 09:25:45 host kernel: SCSI error : &lt;2 0 3 0&gt; return code = 0x20000<br>Sep 27 09:25:45 host kernel: end_request: I/O error, dev sde, sector 233247600
<br>Sep 27 09:25:45 host kernel: end_request: I/O error, dev sde, sector 233247608<br>Sep 27 09:25:45 host multipathd: 8:64: mark as failed<br>Sep 27 09:25:45 host multipathd: host.datafiles.prod: remaining active paths: 1
<br>Sep 27 09:25:47 host multipathd: 8:64: readsector0 checker reports path is up<br>Sep 27 09:25:47 host multipathd: 8:64: reinstated<br>Sep 27 09:25:47 host multipathd: host.datafiles.prod: remaining active paths: 2<br>
Sep 27 09:25:47 host multipathd: host.datafiles.prod: switch to path group #1<br>Sep 27 09:25:47 host multipathd: host.datafiles.prod: switch to path group #1<br clear="all">  ========= end snip =========================<br>
<br>========= /etc/multipath.conf ================<br>defaults {<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; multipath_tool&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot;/sbin/multipath -v0&quot;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; udev_dir&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /dev<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; polling_interval&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; selector&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot;round-robin 0&quot;
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; path_grouping_policy&nbsp;&nbsp;&nbsp; failover<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; getuid_callout&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot;/sbin/scsi_id -g -u -s /block/%n&quot;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; path_checker&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; readsector0<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; prio_callout&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot;/bin/true&quot;
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; features&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot;0&quot;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rr_min_io&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rr_weight&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; priorities<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; failback&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; immediate<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; no_path_retry&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; fail<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; user_friendly_name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; yes<br>}<br>## everything is friendly names and ignore devices below<br>=========== end ======================<br><br><br>-- <br>:wq!<br>kevin.foote

------=_Part_1767_17279005.1190905812609--


--===============0874124744==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0874124744==--
