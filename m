From: Ray Van Dolson <rvandolson@esri.com>
Subject: Configuring Path Groups
Date: Fri, 6 Apr 2012 23:20:39 -0700
Message-ID: <20120407062039.GA22750@esri.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

I am setting up multipathing on RHEL6 via iSCSI to an IBM XIV.  My
iSCSI target looks like this:

172.16.10.1:3260,1793 iqn.2005-10.com.xivstorage:003974
172.16.8.22:3260,2048 iqn.2005-10.com.xivstorage:003974
172.16.10.22:3260,2049 iqn.2005-10.com.xivstorage:003974
172.16.8.23:3260,2304 iqn.2005-10.com.xivstorage:003974
172.16.10.23:3260,2305 iqn.2005-10.com.xivstorage:003974
172.16.8.1:3260,1792 iqn.2005-10.com.xivstorage:003974

(This is one LUN).  Networks are 172.16.10.0/23 and 172.16.8.0/23, so
as you can see above there are three target IP's on each subnet.

My RHEL6 host has two physical uplinks... one to each subnet.  When I
configure multipath, by default it creates one big path group with all
of the devices above within it and round-robins.

mpathb (2001738000f860110) dm-2 IBM,2810XIV
size=48G features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='queue-length 0' prio=1 status=active
  |- 26:0:0:1 sdb 8:16 active ready running
  |- 25:0:0:1 sdc 8:32 active ready running
  |- 27:0:0:1 sdd 8:48 active ready running
  |- 24:0:0:1 sde 8:64 active ready running
  |- 23:0:0:1 sdf 8:80 active ready running
  `- 22:0:0:1 sdg 8:96 active ready running

This results in less than ideal performance.

Ideally I want to only have one path per subnet active at any given
time, with the other paths only activating if there's a failure.

The only other option I seem to have is to set path_grouping_policy to
failover.  This creates six separate path groups of which only one is
active at a time.

I thought perhaps I could do group_by_prio, but am not sure how I can
manually set priorities for my underlying physical iSCSI devices, and
the default "const" method just gives them all priority 1 so they all
end up in the same path group again.

It looks like perhaps I could configure path groups as I want manually
with dmsetup, but I'm sure there's a better way...

As it is I am currently just configuring my iSCSI initiator to log in
to only one target per subnet.  This gets me the best performance but I
lose some (automated) redundancy.

Thoughts appreciated.

Ray
