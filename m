From: "Kevin Foote" <kevin.foote@gmail.com>
Subject: anyone using this setup without issues
Date: Thu, 3 Jan 2008 11:44:20 -0500
Message-ID: <5fb0f77b0801030844o2888f64n3a3e944ddeb7bb00@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0029837389=="
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============0029837389==
Content-Type: multipart/alternative;
	boundary="----=_Part_35626_5108508.1199378660175"

------=_Part_35626_5108508.1199378660175
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Here is my setup: (this is ISCSI) going for multipath failover.

Equallogic storage
Qlogic 4052c HBAs (2 ports)
RHEL4.5
device-mapper-multipath-0.4.5-21.RHEL4
HP-GigE switches
/etc/multipath.conf      using failover mode
defaults {
        multipath_tool          "/sbin/multipath -v0"
        udev_dir                /dev
        #polling_interval       2
        polling_interval        4
        selector                "round-robin 0"
        path_grouping_policy    failover
        getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
        path_checker            readsector0
        prio_callout            "/bin/true"
        features                "0"
        #rr_min_io               2
        rr_min_io               100
        rr_weight               priorities
        failback                immediate
        no_path_retry           fail
        user_friendly_name      yes
}

Here is the problem:
Dec 20 05:28:32 192.168.46.31/192.168.46.31 kernel: SCSI error : <2 0 5 0>
return code = 0x10000
Dec 20 05:28:32 192.168.46.31/192.168.46.31 multipathd: 65:16: readsector0
checker reports path is up
Dec 20 05:28:32 192.168.46.31/192.168.46.31 kernel: device-mapper:
dm-multipath: Failing path 8:96.
Dec 20 05:28:32 192.168.46.31/192.168.46.31 multipathd: 65:16: reinstated
Dec 20 05:28:32 192.168.46.31/192.168.46.31 multipathd: ban1.banprod:
remaining active paths: 2
Dec 20 05:28:32 192.168.46.31/192.168.46.31 multipathd: 8:96: readsector0
checker reports path is down
Dec 20 05:28:32 192.168.46.31/192.168.46.31 multipathd: checker failed path
8:96 in map ban1.datafiles.famp
Dec 20 05:28:32 192.168.46.31/192.168.46.31 multipathd: ban1.datafiles.famp:
remaining active paths: 1
Dec 20 05:28:35 192.168.46.31/192.168.46.31 kernel: SCSI error : <2 0 8 0>
return code = 0x10000
Dec 20 05:28:35 192.168.46.31/192.168.46.31 multipathd: 8:144: readsector0
checker reports path is down
Dec 20 05:28:35 192.168.46.31/192.168.46.31 multipathd: checker failed path
8:144 in map ban1.datafiles.wflw
Dec 20 05:28:35 192.168.46.31/192.168.46.31 kernel: device-mapper:
dm-multipath: Failing path 8:144.
Dec 20 05:28:37 192.168.46.31/192.168.46.31 multipathd: ban1.datafiles.wflw:
remaining active paths: 1
Dec 20 05:28:37 192.168.46.31/192.168.46.31 multipathd: 8:96: readsector0
checker reports path is up
Dec 20 05:28:37 192.168.46.31/192.168.46.31 multipathd: 8:96: reinstated
Dec 20 05:28:37 192.168.46.31/192.168.46.31 multipathd: ban1.datafiles.famp:
remaining active paths: 2
Dec 20 05:28:39 192.168.46.31/192.168.46.31 multipathd: 8:144: readsector0
checker reports path is up
Dec 20 05:28:39 192.168.46.31/192.168.46.31 multipathd: 8:144: reinstated
Dec 20 05:28:39 192.168.46.31/192.168.46.31 multipathd: ban1.datafiles.wflw:
remaining active paths: 2

There is no real pattern to these disconnect/reconnect events. The only
setting I'm thinking about changing
currently is the no_path_retry. I'm thinking of making this 2 or some low
number. The equallogic shows load balancing
events but they don't always align with the drop/reconnect that I'm seeing
on the linux hosts.

Is anyone using these HBAs with equallogic on RHEL4.5 ???

-- 
:wq!
kevin.foote

------=_Part_35626_5108508.1199378660175
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Here is my setup: (this is ISCSI) going for multipath failover.<br><br>Equallogic storage<br clear="all">Qlogic 4052c HBAs (2 ports)<br>RHEL4.5<br>device-mapper-multipath-0.4.5-21.RHEL4<br>HP-GigE switches<br>/etc/multipath.conf&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; using failover mode
<br>defaults {<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; multipath_tool&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot;/sbin/multipath -v0&quot;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; udev_dir&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /dev<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; #polling_interval&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; polling_interval&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; selector&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot;round-robin 0&quot;
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; path_grouping_policy&nbsp;&nbsp;&nbsp; failover <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; getuid_callout&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot;/sbin/scsi_id -g -u -s /block/%n&quot;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; path_checker&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; readsector0<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; prio_callout&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot;/bin/true&quot;
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; features&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot;0&quot;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; #rr_min_io&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rr_min_io&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 100<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rr_weight&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; priorities&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; failback&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; immediate
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; no_path_retry&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; fail<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; user_friendly_name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; yes<br>}<br><br>Here is the problem:<br>Dec 20 05:28:32 <a href="http://192.168.46.31/192.168.46.31">192.168.46.31/192.168.46.31</a> kernel: SCSI error : &lt;2 0 5 0&gt; return code = 0x10000
<br>Dec 20 05:28:32 <a href="http://192.168.46.31/192.168.46.31">192.168.46.31/192.168.46.31</a> multipathd: 65:16: readsector0 checker reports path is up<br>Dec 20 05:28:32 <a href="http://192.168.46.31/192.168.46.31">192.168.46.31/192.168.46.31
</a> kernel: device-mapper: dm-multipath: Failing path 8:96.<br>Dec 20 05:28:32 <a href="http://192.168.46.31/192.168.46.31">192.168.46.31/192.168.46.31</a> multipathd: 65:16: reinstated<br>Dec 20 05:28:32 <a href="http://192.168.46.31/192.168.46.31">
192.168.46.31/192.168.46.31</a> multipathd: ban1.banprod: remaining active paths: 2<br>Dec 20 05:28:32 <a href="http://192.168.46.31/192.168.46.31">192.168.46.31/192.168.46.31</a> multipathd: 8:96: readsector0 checker reports path is down
<br>Dec 20 05:28:32 <a href="http://192.168.46.31/192.168.46.31">192.168.46.31/192.168.46.31</a> multipathd: checker failed path 8:96 in map ban1.datafiles.famp<br>Dec 20 05:28:32 <a href="http://192.168.46.31/192.168.46.31">
192.168.46.31/192.168.46.31</a> multipathd: ban1.datafiles.famp: remaining active paths: 1<br>Dec 20 05:28:35 <a href="http://192.168.46.31/192.168.46.31">192.168.46.31/192.168.46.31</a> kernel: SCSI error : &lt;2 0 8 0&gt; return code = 0x10000
<br>Dec 20 05:28:35 <a href="http://192.168.46.31/192.168.46.31">192.168.46.31/192.168.46.31</a> multipathd: 8:144: readsector0 checker reports path is down<br>Dec 20 05:28:35 <a href="http://192.168.46.31/192.168.46.31">
192.168.46.31/192.168.46.31</a> multipathd: checker failed path 8:144 in map ban1.datafiles.wflw<br>Dec 20 05:28:35 <a href="http://192.168.46.31/192.168.46.31">192.168.46.31/192.168.46.31</a> kernel: device-mapper: dm-multipath: Failing path 8:144.
<br>Dec 20 05:28:37 <a href="http://192.168.46.31/192.168.46.31">192.168.46.31/192.168.46.31</a> multipathd: ban1.datafiles.wflw: remaining active paths: 1<br>Dec 20 05:28:37 <a href="http://192.168.46.31/192.168.46.31">192.168.46.31/192.168.46.31
</a> multipathd: 8:96: readsector0 checker reports path is up<br>Dec 20 05:28:37 <a href="http://192.168.46.31/192.168.46.31">192.168.46.31/192.168.46.31</a> multipathd: 8:96: reinstated<br>Dec 20 05:28:37 <a href="http://192.168.46.31/192.168.46.31">
192.168.46.31/192.168.46.31</a> multipathd: ban1.datafiles.famp: remaining active paths: 2<br>Dec 20 05:28:39 <a href="http://192.168.46.31/192.168.46.31">192.168.46.31/192.168.46.31</a> multipathd: 8:144: readsector0 checker reports path is up
<br>Dec 20 05:28:39 <a href="http://192.168.46.31/192.168.46.31">192.168.46.31/192.168.46.31</a> multipathd: 8:144: reinstated<br>Dec 20 05:28:39 <a href="http://192.168.46.31/192.168.46.31">192.168.46.31/192.168.46.31</a>
 multipathd: ban1.datafiles.wflw: remaining active paths: 2<br><br>There is no real pattern to these disconnect/reconnect events. The only setting I&#39;m thinking about changing <br>currently is the no_path_retry. I&#39;m thinking of making this 2 or some low number. The equallogic shows load balancing
<br>events but they don&#39;t always align with the drop/reconnect that I&#39;m seeing on the linux hosts.<br><br>Is anyone using these HBAs with equallogic on RHEL4.5 ??? <br><br>-- <br>:wq!<br>kevin.foote

------=_Part_35626_5108508.1199378660175--


--===============0029837389==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0029837389==--
