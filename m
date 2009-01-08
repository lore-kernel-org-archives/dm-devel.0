From: Ray Van Dolson <rvandolson@esri.com>
Subject: multipathd: sdc: readsector0 checker reports path is down
Date: Thu, 8 Jan 2009 11:31:38 -0800
Message-ID: <20090108193137.GA3953@esri.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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
Cc: open-iscsi@googlegroups.com
List-Id: dm-devel.ids

I'm still getting the hang of iSCSI and multipath, so bear with me if
this is a FAQ that I've missed...

I have a host attaching to an MD3000i via iSCSI/dm-multipath that is
working but showing a lot of the following errors in syslog:

  multipathd: sdc: readsector0 checker reports path is down

My initial impression is that sdc is likely the "passive" path (for
failover) whereas sdd is my active path:

  # multipath -ll
  sdc: checker msg is "readsector0 checker reports path is down"
  mpath2 (36001ec9000f338370000000000000000) dm-2 DELL,Universal Xport
  [size=20M][features=0][hwhandler=0]
  \_ round-robin 0 [prio=0][enabled]
   \_ 4:0:0:31 sdf 8:80  [active][ready] 
  mpath1 (36001ec9000f337dd0000000000000000) dm-1 DELL,Universal Xport
  [size=20M][features=0][hwhandler=0]
  \_ round-robin 0 [prio=0][enabled]
   \_ 3:0:0:31 sde 8:64  [active][ready] 
  mpath0 (36001ec9000f337dd0000065b491854a4) dm-0 DELL,MD3000i
  [size=150G][features=0][hwhandler=1 rdac]
  \_ round-robin 0 [prio=3][active]
   \_ 3:0:0:0  sdd 8:48  [active][ready] 
  \_ round-robin 0 [prio=0][enabled]
   \_ 4:0:0:0  sdc 8:32  [failed][faulty]

  # iscsiadm -m discovery -t sendtargets -p 192.168.132.101:3260
  0.0.0.0:3260,1 iqn.1984-05.com.dell:powervault.6001ec9000f337dd0000000048bdc862
  0.0.0.0:3260,2 iqn.1984-05.com.dell:powervault.6001ec9000f337dd0000000048bdc862
  192.168.132.101:3260,1 iqn.1984-05.com.dell:powervault.6001ec9000f337dd0000000048bdc862
  192.168.132.102:3260,2 iqn.1984-05.com.dell:powervault.6001ec9000f337dd0000000048bdc862

  # iscsiadm -m session -P 1
  Target: iqn.1984-05.com.dell:powervault.6001ec9000f337dd0000000048bdc862
    Current Portal: 192.168.132.101:3260,1
    Persistent Portal: 192.168.132.101:3260,1
      **********
      Interface:
      **********
      Iface Name: default
      Iface Transport: tcp
      Iface Initiatorname: iqn.1994-05.com.redhat:2738e0d3bd21
      Iface IPaddress: 192.168.132.202
      Iface HWaddress: default
      Iface Netdev: default
      SID: 1
      iSCSI Connection State: LOGGED IN
      iSCSI Session State: Unknown
      Internal iscsid Session State: NO CHANGE
    Current Portal: 192.168.132.102:3260,2
    Persistent Portal: 192.168.132.102:3260,2
      **********
      Interface:
      **********
      Iface Name: default
      Iface Transport: tcp
      Iface Initiatorname: iqn.1994-05.com.redhat:2738e0d3bd21
      Iface IPaddress: 192.168.132.202
      Iface HWaddress: default
      Iface Netdev: default
      SID: 2
      iSCSI Connection State: LOGGED IN
      iSCSI Session State: Unknown
      Internal iscsid Session State: NO CHANGE

sde and sdf are the silly 20MB partition that the MD3000 creates and
I'm not using either.

My ultimate goal is to not have so many of the path is down errors
showing up in my syslog file (hundreds and hundreds of them).  I'm not
sure if their presence is normal (indicative of a passive path) or
indicative of a problem.

Also, I'm not clear as to how I should identify which target
corresponds with which drive (sdc or sdd).

Any thoughts?  I don't have direct access to the MD3000i
unfortunately... this is from a CentOS 5.2 system btw.

Ray
