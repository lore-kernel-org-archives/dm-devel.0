From: "Ethan John" <ethan.john@gmail.com>
Subject: Designing a new prio_callout
Date: Thu, 21 Jun 2007 14:42:54 -0700
Message-ID: <d61540a40706211442w1ef3bacflddd44f74c8883a3f@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0417699720=="
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

--===============0417699720==
Content-Type: multipart/alternative;
	boundary="----=_Part_86376_11008485.1182462174612"

------=_Part_86376_11008485.1182462174612
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I hope I found the right list for this.

My company is developing an iSCSI solution, and in looking into Linux
compatability and performance, we're concerned that our architecture doesn't
play well with the existing multipath configurations that are available.

We cannot support what Linux calls multibus, or what the fiber world seems
to call active/active. We will need folks to configure failover exclusively.

It appears that the current multipathing failover configuration assigns a
priority to each path (by default, just assigns the same priority to all
paths). This is bad for us, as we're presenting iSCSI targets across
multiple machines in a cluster; ideally, a user will have multiple devices,
each with a separate path to a separate machine, with failover to the other
machines in the cluster. The default setup of multipath will map all
connections to a single machine, which is no load balancing at all.

I've fooled around with various other values for default_prio_callot
(besides the /bin/true), and the one that seems to work best is actually
mpath_prio_random.

In fact, mpath_prio_random would actually work perfectly, except that it
seems to swap path priorities extremely often -- several times a minute. So
my company needs to develop a new script, probably much like the
mpath_prio_emc or mpath_prio_netapp ones, so that we can hint at load
balancing across devices with failover as the multipathing policy.

I've been completely unable to find documentation on this. Where might I
look? Is this even the right direction in which to be looking for a solution
to this problem?

Let me know if anything above needs to be more clear.

-- 
Ethan John

------=_Part_86376_11008485.1182462174612
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I hope I found the right list for this.<br><br>My company is developing an iSCSI solution, and in looking into Linux compatability and performance, we&#39;re concerned that our architecture doesn&#39;t play well with the existing multipath configurations that are available.
<br><br>We cannot support what Linux calls multibus, or what the fiber world seems to call active/active. We will need folks to configure failover exclusively.<br><br>It appears that the current multipathing failover configuration assigns a priority to each path (by default, just assigns the same priority to all paths). This is bad for us, as we&#39;re presenting iSCSI targets across multiple machines in a cluster; ideally, a user will have multiple devices, each with a separate path to a separate machine, with failover to the other machines in the cluster. The default setup of multipath will map all connections to a single machine, which is no load balancing at all.
<br><br>I&#39;ve fooled around with various other values for default_prio_callot (besides the /bin/true), and the one that seems to work best is actually mpath_prio_random.<br><br>In fact, mpath_prio_random would actually work perfectly, except that it seems to swap path priorities extremely often -- several times a minute. So my company needs to develop a new script, probably much like the mpath_prio_emc or mpath_prio_netapp ones, so that we can hint at load balancing across devices with failover as the multipathing policy.
<br><br>I&#39;ve been completely unable to find documentation on this. Where might I look? Is this even the right direction in which to be looking for a solution to this problem?<br><br>Let me know if anything above needs to be more clear.
<br clear="all"><br>-- <br>Ethan John<br>

------=_Part_86376_11008485.1182462174612--


--===============0417699720==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0417699720==--
